#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <termios.h>
#include <signal.h>
#include <linux/can.h>
#include <linux/can/raw.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <net/if.h>
#include <ctype.h>

// TODO: CLEANUP
// TruckDevil serial interface
#define SERIAL_PORT "/dev/ttyGS1"
#define DEFAULT_CAN_INTERFACE "can0"
#define BAUD_RATE B115200

int serial_fd = -1;
int can_fd = -1;
char can_interface[IFNAMSIZ] = DEFAULT_CAN_INTERFACE;
int can_baud = 0; // 0 for auto-baud

void cleanup(int signo) {
    if (serial_fd > 0)
        close(serial_fd);
    if (can_fd > 0)
        close(can_fd);
    exit(0);
}

void print_baud_rate(speed_t speed) {
    switch (speed) {
        case B0: printf("Baud rate: 0\n"); break;
        case B50: printf("Baud rate: 50\n"); break;
        case B75: printf("Baud rate: 75\n"); break;
        case B110: printf("Baud rate: 110\n"); break;
        case B134: printf("Baud rate: 134\n"); break;
        case B150: printf("Baud rate: 150\n"); break;
        case B200: printf("Baud rate: 200\n"); break;
        case B300: printf("Baud rate: 300\n"); break;
        case B600: printf("Baud rate: 600\n"); break;
        case B1200: printf("Baud rate: 1200\n"); break;
        case B1800: printf("Baud rate: 1800\n"); break;
        case B2400: printf("Baud rate: 2400\n"); break;
        case B4800: printf("Baud rate: 4800\n"); break;
        case B9600: printf("Baud rate: 9600\n"); break;
        case B19200: printf("Baud rate: 19200\n"); break;
        case B38400: printf("Baud rate: 38400\n"); break;
        case B57600: printf("Baud rate: 57600\n"); break;
        case B115200: printf("Baud rate: 115200\n"); break;
        case B230400: printf("Baud rate: 230400\n"); break;
        default: printf("Baud rate: Unknown\n"); break;
    }
}

void configure_serial(int fd) {
    struct termios tty;
    memset(&tty, 0, sizeof(tty));

    if (tcgetattr(fd, &tty) != 0) {
        perror("tcgetattr");
        exit(1);
    }

    cfsetospeed(&tty, BAUD_RATE);
    cfsetispeed(&tty, BAUD_RATE);

    tty.c_cflag = (tty.c_cflag & ~CSIZE) | CS8;     // 8-bit chars
    tty.c_iflag &= ~IGNBRK;                          // disable break processing
    tty.c_lflag = 0;                                 // no signaling chars, no echo,
                                                     // no canonical processing
    tty.c_oflag = 0;                                 // no remapping, no delays
    tty.c_cc[VMIN]  = 1;                             // read doesn't block
    tty.c_cc[VTIME] = 1;                             // 0.1 seconds read timeout

    tty.c_iflag &= ~(IXON | IXOFF | IXANY);          // shut off xon/xoff ctrl

    tty.c_cflag |= (CLOCAL | CREAD);                 // ignore modem controls,
                                                     // enable reading
    tty.c_cflag &= ~(PARENB | PARODD);               // shut off parity
    tty.c_cflag &= ~CSTOPB;                          // 1 stop bit
    tty.c_cflag &= ~CRTSCTS;                         // no hardware flow control

    tty.c_cflag &= ~HUPCL; // Disable hang-up-on-close to keep DTR asserted

    if (tcsetattr(fd, TCSANOW, &tty) != 0) { // TCSANOW: apply changes immediately
        perror("tcsetattr");
        exit(1);
    }

    int modem_bits = TIOCM_DTR;
    ioctl(fd, TIOCMBIS, &modem_bits); 
    printf("Configured serial port GS0 with the following settings:\n");
    print_baud_rate(BAUD_RATE);
    printf(tty.c_cflag & CS8 ? "Character size: 8 bits\n" : "Character size: not 8 bits lol\n");
    printf(tty.c_cflag & PARENB ? "Parity: Enabled\n" : "Parity: Disabled\n");
    printf(tty.c_cflag & PARODD ? "Parity type: Odd\n" : "Parity type: Even\n");
    printf(tty.c_cflag & CSTOPB ? "Stop bits: 2\n" : "Stop bits: 1\n");
    printf(tty.c_cflag & CRTSCTS ? "Hardware flow control: Enabled\n" : "Hardware flow control: Disabled\n");
    printf(tty.c_cflag & HUPCL ? "Hang-up on close: Enabled\n" : "Hang-up on close: Disabled\n");
    fflush(stdout);

}

int validate_can_interface(const char *iface) {
    // Simple validation to ensure interface name starts with 'can' and is followed by a digit
    if (strncmp(iface, "can", 3) != 0)
        return 0;
    if (!isdigit(iface[3]))
        return 0;
    return 1;
}

int validate_can_baud(int baud) {
    // Validate against common CAN baud rates
    int valid_baud_rates[] = {10000, 20000, 50000, 100000, 125000, 250000, 500000, 800000, 1000000};
    int num_rates = sizeof(valid_baud_rates) / sizeof(valid_baud_rates[0]);
    for (int i = 0; i < num_rates; i++) {
        if (baud == valid_baud_rates[i])
            return 1;
    }
    return 0;
}

void initialize_can_interface() {
    char command[256];
    int ret;

    // Validate CAN interface and baud rate
    if (!validate_can_interface(can_interface)) {
        fprintf(stderr, "Invalid CAN interface: %s\n", can_interface);
        exit(1);
    }

    if (can_baud != 0 && !validate_can_baud(can_baud)) {
        fprintf(stderr, "Invalid CAN baud rate: %d\n", can_baud);
        exit(1);
    }

    // Bring down the CAN interface
    snprintf(command, sizeof(command), "ip link set %s down", can_interface);
    ret = system(command);
    if (ret != 0) {
        fprintf(stderr, "Failed to bring down CAN interface %s\n", can_interface);
        exit(1);
    }

    // Bring up the CAN interface with the specified baud rate
    if (can_baud != 0) {
        snprintf(command, sizeof(command), "ip link set %s up type can bitrate %d", can_interface, can_baud);
    } else {
        // If baud rate is 0, use a default baud rate or auto-baud if supported
        snprintf(command, sizeof(command), "ip link set %s up type can bitrate 250000", can_interface);
    }
    ret = system(command);
    if (ret != 0) {
        fprintf(stderr, "Failed to bring up CAN interface %s with baud rate %d\n", can_interface, can_baud);
        exit(1);
    }

    printf("Initialized CAN interface: %s with baud rate: %d\n", can_interface, can_baud);
}

void handle_initialization_sequence() {
    char buffer[16];
    int idx = 0;
    char c;

    printf("Waiting for initialization sequence...\n");
    tcflush(serial_fd, TCIFLUSH); // Flush input buffer

    // Wait for the '#' character
    while (1) {
        int n = read(serial_fd, &c, 1);
        if (n <= 0) {
            // Read error or timeout
            printf("Read error or timeout\n");
            printf("Received initialization sequence: %s\n", buffer);
            return;
        }
        if (c == '#') {
            break;
        }
    }

    // Read the next 11 bytes: 7 bytes for baud rate and 4 bytes for channel
    while (idx < 11) {
        int n = read(serial_fd, &buffer[idx], 11 - idx);
        if (n <= 0) {
            // Read error or timeout
            printf("Read error or timeout\n");
            return;
        }
        idx += n;
    }

    printf("Received initialization sequence: %s\n", buffer);

    // Null-terminate the buffer
    buffer[11] = '\0';

    // Parse baud rate
    char baud_str[8];
    strncpy(baud_str, buffer, 7); // copy the first 7 bytes of the buffer to the baud_str
    baud_str[7] = '\0';
    can_baud = atoi(baud_str);

    // Parse CAN channel
    strncpy(can_interface, &buffer[7], 4); // copy the last 4 bytes of the buffer to the can_interface
    can_interface[4] = '\0';

    printf("Received initialization sequence: baud rate %d, interface %s\n", can_baud, can_interface);
    fflush(stdout);

    // Initialize CAN interface accordingly
    initialize_can_interface();
}

void passFrameToSerial(int serial_fd, struct can_frame *frame) {
    char buffer[256];
    int idx = 0;
    int i;

    if (frame->can_id & CAN_EFF_FLAG) {
        // Start delimiter
        buffer[idx++] = '$';

        // Extended ID (29 bits), ensure 8 hex digits with leading zeros
        unsigned int id = frame->can_id & CAN_EFF_MASK;
        idx += sprintf(&buffer[idx], "%08X", id);

        // DLC (Data Length Code), ensure 2 hex digits
        idx += sprintf(&buffer[idx], "%02X", frame->can_dlc);

        // Data bytes
        for (i = 0; i < frame->can_dlc; i++) {
            idx += sprintf(&buffer[idx], "%02X", frame->data[i]);
        }

        // End delimiter
        buffer[idx++] = '*';

        // Write to serial port
        write(serial_fd, buffer, idx);
    }
}

int passFrameFromSerial(int serial_fd, struct can_frame *frame) {
    char c;
    char message[256];
    int idx = 0;
    int n;
    char tempbuf[9]; // Buffer for temporary string conversions

    // Read until start delimiter is found
    while (1) {
        n = read(serial_fd, &c, 1);
        if (n <= 0)
            return -1;
        if (c == '$')
            break;
        else if (c == '#') {
            // Handle reinitialization
            handle_initialization_sequence();
            return -1;
        }
    }

    // Read the rest of the message until end delimiter
    while (1) {
        n = read(serial_fd, &c, 1);
        if (n <= 0)
            return -1;
        if (c == '*')
            break;
        message[idx++] = c;
        if (idx >= sizeof(message) - 1)
            return -1; // Message too long
    }
    message[idx] = '\0';

    // Parse CAN ID
    if (idx < 10)
        return -1; // Message too short
    strncpy(tempbuf, message, 8);
    tempbuf[8] = '\0';
    frame->can_id = (unsigned int)strtol(tempbuf, NULL, 16);
    frame->can_id |= CAN_EFF_FLAG; // Mark as extended frame

    // Parse DLC
    strncpy(tempbuf, &message[8], 2);
    tempbuf[2] = '\0';
    frame->can_dlc = (unsigned char)strtol(tempbuf, NULL, 16);

    // Parse data bytes
    int data_idx = 0;
    for (int i = 10; i < idx; i += 2) {
        if (data_idx >= 8)
            break; // Max 8 bytes
        strncpy(tempbuf, &message[i], 2);
        tempbuf[2] = '\0';
        frame->data[data_idx++] = (unsigned char)strtol(tempbuf, NULL, 16);
    }

    return 0;
}

int main() {
    struct sigaction sigact; // Signal handler
    struct sockaddr_can addr; // CAN socket address
    struct ifreq ifr; // Interface request
    fd_set readfds; // File descriptor set for select
    int ret; // Return value
    struct can_frame frame; // CAN frame

    // Handle signals to ensure cleanup
    sigact.sa_handler = cleanup; // Signal handler
    sigemptyset(&sigact.sa_mask); // Block all signals while in handler
    sigact.sa_flags = 0; // No special flags
    sigaction(SIGINT, &sigact, NULL); // Register signal handler for SIGINT
    sigaction(SIGTERM, &sigact, NULL); // Register signal handler for SIGTERM

    // Open serial port
    serial_fd = open(SERIAL_PORT, O_RDWR | O_NOCTTY | O_NDELAY); // Open in non-blocking mode
    if (serial_fd < 0) { // Error opening serial port
        perror("Error opening serial port");
        return 1;
    }
    configure_serial(serial_fd);

    // Handle initial initialization sequence from serial
    handle_initialization_sequence();

    // Open CAN socket
    if ((can_fd = socket(PF_CAN, SOCK_RAW, CAN_RAW)) < 0) {
        perror("Error while opening socket");
        return 1;
    }

    strcpy(ifr.ifr_name, can_interface);
    if (ioctl(can_fd, SIOCGIFINDEX, &ifr) < 0) {
        perror("Error in ioctl");
        return 1;
    }

    addr.can_family = AF_CAN;
    addr.can_ifindex = ifr.ifr_ifindex;

    // Bind the socket
    if (bind(can_fd, (struct sockaddr *)&addr, sizeof(addr)) < 0) {
        perror("Error in socket bind");
        return 1;
    }

    // Main loop
    while (1) {
        FD_ZERO(&readfds);
        FD_SET(serial_fd, &readfds);
        FD_SET(can_fd, &readfds);

        int max_fd = (serial_fd > can_fd) ? serial_fd : can_fd;

        ret = select(max_fd + 1, &readfds, NULL, NULL, NULL);
        if (ret < 0) {
            perror("select");
            break;
        }

        // Check for CAN messages to read
        if (FD_ISSET(can_fd, &readfds)) {
            ret = read(can_fd, &frame, sizeof(struct can_frame));
            if (ret < 0) {
                perror("CAN read");
                break;
            } else if (ret == sizeof(struct can_frame)) {
                // Pass frame to serial
                passFrameToSerial(serial_fd, &frame);
            }
        }

        // Check for serial data to read
        if (FD_ISSET(serial_fd, &readfds)) {
            struct can_frame outgoing;
            memset(&outgoing, 0, sizeof(outgoing));
            ret = passFrameFromSerial(serial_fd, &outgoing);
            if (ret == 0) {
                // Send frame to CAN bus
                ret = write(can_fd, &outgoing, sizeof(struct can_frame));
                if (ret < 0) {
                    perror("CAN write");
                    break;
                }
            }
        }
    }

    // Cleanup
    cleanup(0);
    return 0;
}
