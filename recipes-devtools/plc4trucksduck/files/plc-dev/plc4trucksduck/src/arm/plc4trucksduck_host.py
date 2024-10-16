#!/usr/bin/env python3
# PLC4TRUCKSDuck (c) 2024 National Motor Freight Traffic Association
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import select
import signal
import socket
import sys
import time
import logging
import threading

RPMSG_DEV = "/dev/rpmsg_pru30"  # RPMsg device file
PAYLOAD_LEN = 255  # Must match the same in the PRU code
PRU_FW_PATH = "/lib/firmware/am335x-pru0-fw"  # Path to PRU firmware
REMOTE_PROC_PATH = "/sys/class/remoteproc/remoteproc1"  # Path to remoteproc interface for PRU0

# Initialize logging to the file plc.log
logging.basicConfig(filename='plc.log', level=logging.DEBUG, format='%(asctime)s %(message)s')

UDP_PORTS = (6971, 6972)
running = True

def signal_handler(sig, frame):
    global running
    print("Signal received, exiting...")
    running = False
    stop_event.set()

def load_pru_firmware():
    """Load and start the PRU firmware using remoteproc."""
    # stop the PRU if it's running
    with open(os.path.join(REMOTE_PROC_PATH, "state"), 'r+') as f:
        if f.readline().strip() != "offline":
            f.seek(0)
            f.write("stop\n")
            f.flush()

    # Load the PRU firmware
    with open(os.path.join(REMOTE_PROC_PATH, "firmware"), 'w') as f:
        f.write(os.path.basename(PRU_FW_PATH) + '\n')

    # Start the PRU
    with open(os.path.join(REMOTE_PROC_PATH, "state"), 'w') as f:
        f.write("start\n")

    print("PRU firmware loaded and started")

def format_data(data):
    """Format the data received from the PRU."""
    # format as a single line of hex
    formatted_data = data.hex()
    logging.info(formatted_data)

def logging_t(rpmsg, sock, stop_event, rpmsg_lock):
    """Thread to read data from rpmsg and log it."""
    epoll = select.epoll()
    epoll.register(rpmsg, select.EPOLLIN)
    epoll.register(sock.fileno(), select.EPOLLIN)

    data_buffer = b''  # Buffer to store incoming data

    try:
        while not stop_event.is_set():
            events = epoll.poll(1)
            for fileno, event in events:
                if (fileno == rpmsg.fileno()) and (event & select.EPOLLIN):
                    with rpmsg_lock:
                        data = rpmsg.read(1024)  # Read up to 1024 bytes
                    if data:
                        data_buffer += data
                        # Process data in chunks of 10 bytes
                        while len(data_buffer) >= 10:
                            chunk = data_buffer[:10]
                            data_buffer = data_buffer[10:]
                            # TODO: test this implementation
                            sock.sendto(chunk, ('localhost', UDP_PORTS[1]))
                            format_data(chunk)
                elif (fileno == sock.fileno()) and (event & select.EPOLLIN):
                    frame = sock.recv(1024)
                    with rpmsg_lock:
                        rpmsg.write(frame[:PAYLOAD_LEN])
                    logging.info("Sent to PRU: " + frame.hex())
    finally:
        epoll.unregister(rpmsg)
        epoll.unregister(sock.fileno())
        epoll.close()
    print("Logging thread exiting")

def input_t(rpmsg, stop_event, rpmsg_lock):
    """Thread to read user input and send to rpmsg."""
    while not stop_event.is_set():
        try:
            user_input = input("Enter data to send to PRU (type 'exit' to quit): ")
            if user_input.lower() in ('exit', 'quit'):
                stop_event.set()
                break
            
            data = user_input.encode('utf-8')
            # send the first byte
            with rpmsg_lock:
                rpmsg.write(data[0:1])
            time.sleep(0.00194) # timing / response needs to be handled in the PRU. this works for now
            # send the rest of the bytes
            with rpmsg_lock:
                rpmsg.write(data[1:])

            # Convert user_input to bytes, ensure it's the correct length
            # if len(data) > PAYLOAD_LEN:
            #     data = data[:PAYLOAD_LEN]
            # elif len(data) < PAYLOAD_LEN:
            #     data = data.ljust(PAYLOAD_LEN, b'\0')
            # with rpmsg_lock:
            #     rpmsg.write(data)
            logging.info("Sent to PRU from input: " + data.hex())
        except EOFError:
            stop_event.set()
            break
    print("Input thread exiting")

if __name__ == "__main__":
    # Register the signal handler for SIGINT
    signal.signal(signal.SIGINT, signal_handler)
    sock = socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM)
    stop_event = threading.Event()

    try:
        sock.bind(('localhost', UDP_PORTS[0]))
        sock.setblocking(False)
        # Load and start the PRU firmware
        load_pru_firmware()
    except OSError as e:
        print(e)
        sys.exit(-1)
    time.sleep(1)  # wait for the PRU to start

    try:
        rpmsg = open(RPMSG_DEV, 'r+b', buffering=0)
        # rpmsg.write(b'00') # send a dummy byte
    except IOError as e:
        print(e)
        sock.close()
        sys.exit(1)

    rpmsg_lock = threading.Lock()
    logging_thread = threading.Thread(target=logging_t, args=(rpmsg, sock, stop_event, rpmsg_lock))
    input_thread = threading.Thread(target=input_t, args=(rpmsg, stop_event, rpmsg_lock))

    # start
    logging_thread.start()
    input_thread.start()

    # stop
    logging_thread.join()
    input_thread.join()
    rpmsg.close()
    sock.close()