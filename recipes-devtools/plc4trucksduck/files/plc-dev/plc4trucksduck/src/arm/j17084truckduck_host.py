#!/usr/bin/env python3
# PLC4TRUCKSDuck (c) 2020 National Motor Freight Traffic Association
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
import fcntl  # Added import for fcntl module

RPMSG_DEV = "/dev/rpmsg_pru31"  # RPMsg device file
PAYLOAD_LEN = 255  # Must match the same in the PRU code
PRU_FW_PATH = "/lib/firmware/am335x-pru1-fw"  # Path to PRU firmware
REMOTE_PROC_PATH = "/sys/class/remoteproc/remoteproc2"  # Path to remoteproc interface for PRU1

UDP_PORTS = (6969, 6970)
running = True

def signal_handler(sig, frame):
    global running
    print("Signal received, exiting...")
    running = False

def load_pru_firmware():
    """Load and start the PRU firmware using remoteproc."""
    # Stop the PRU if it's already running
    state_path = os.path.join(REMOTE_PROC_PATH, "state")
    firmware_path = os.path.join(REMOTE_PROC_PATH, "firmware")
    try:
        with open(state_path, 'r') as f:
            state = f.readline().strip()
        if state != "offline":
            with open(state_path, 'w') as f:
                f.write("stop\n")
                f.flush()
    except IOError as e:
        print(f"Error stopping PRU: {e}")
        sys.exit(1)

    # Set the PRU firmware
    try:
        with open(firmware_path, 'w') as f:
            f.write(os.path.basename(PRU_FW_PATH) + '\n')
    except IOError as e:
        print(f"Error setting PRU firmware: {e}")
        sys.exit(1)

    # Start the PRU
    try:
        with open(state_path, 'w') as f:
            f.write("start\n")
    except IOError as e:
        print(f"Error starting PRU: {e}")
        sys.exit(1)

    print("PRU firmware loaded and started")

def forward(sock):
    global running
    try:
        rpmsg = open(RPMSG_DEV, 'rb')  # Open in binary read mode
    except IOError as e:
        print(f"Error opening RPMsg device: {e}")
        sock.close()
        sys.exit(1)

    # Set up epoll
    epoll = select.epoll()
    epoll.register(rpmsg.fileno(), select.EPOLLIN)
    epoll.register(sock.fileno(), select.EPOLLIN)

    try:
        while running:
            events = epoll.poll(1)
            for fileno, event in events:
                if fileno == rpmsg.fileno():
                    data = rpmsg.read(PAYLOAD_LEN)
                    if data:
                        sock.sendto(data, ('localhost', UDP_PORTS[1]))
                        print("Received from PRU:", data.hex())
                        print(time.time())
                elif fileno == sock.fileno():
                    frame = sock.recv(PAYLOAD_LEN)
                    rpmsg.write(frame[:PAYLOAD_LEN])
                    print("Sent to PRU:", frame.hex())
    finally:
        epoll.unregister(rpmsg.fileno())
        epoll.unregister(sock.fileno())
        epoll.close()
        rpmsg.close()
        sock.close()


if __name__ == "__main__":
    # Register the signal handler for SIGINT
    signal.signal(signal.SIGINT, signal_handler)
    sock = socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM)

    try:
        sock.bind(('localhost', UDP_PORTS[0]))
        sock.setblocking(False)
        # Load and start the PRU firmware
        load_pru_firmware()
    except OSError as e:
        print(f"Socket or PRU error: {e}")
        sys.exit(-1)
    time.sleep(1)  # Give time for file creation
    forward(sock)
