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

UDP_PORTS = (6969, 6970)
running_plc = True

def signal_handler(sig, frame):
    global running
    print("Signal received, exiting...")
    running_plc = False

def load_pru_firmware():
    """Load and start the PRU firmware using remoteproc."""
    state_path = os.path.join(REMOTE_PROC_PATH, "state")
    firmware_path = os.path.join(REMOTE_PROC_PATH, "firmware")

    # Stop the PRU if it's already running
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

def read_from_pru(rpmsg, sock):
    global running_plc
    while running_plc:
        try:
            data = rpmsg.read(PAYLOAD_LEN)
            if data:
                sock.sendto(data, ('localhost', UDP_PORTS[1]))
                print("Received from PRU:", data.hex())
                print(time.time())
        except IOError as e:
            print(f"Error reading from RPMsg: {e}")
            break

def write_to_pru(rpmsg, sock):
    global running_plc
    while running_plc:
        try:
            frame = sock.recv(PAYLOAD_LEN)
            rpmsg.write(frame[:PAYLOAD_LEN])
            print("Sent to PRU:", frame.hex())
            print(time.time())
        except IOError as e:
            print(f"Error writing to RPMsg: {e}")
            break

if __name__ == "__main__":
    # Register the signal handler for SIGINT
    signal.signal(signal.SIGINT, signal_handler)
    
    sock = socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM)

    try:
        # Bind the socket to receive UDP data
        sock.bind(('0.0.0.0', UDP_PORTS[0]))
        sock.setblocking(False)
        
        # Load and start the PRU firmware
        load_pru_firmware()
    except OSError as e:
        print(f"Socket or PRU error: {e}")
        sys.exit(-1)

    time.sleep(1)  # Give time for RPMsg device creation

    try:
        # Open the RPMsg device for both reading and writing
        rpmsg = open(RPMSG_DEV, 'rb+')  # Open in read/write binary mode
    except IOError as e:
        print(f"Error opening RPMsg device: {e}")
        sock.close()
        sys.exit(1)

    # Create and start threads for reading from and writing to PRU
    read_thread = threading.Thread(target=read_from_pru, args=(rpmsg, sock))
    write_thread = threading.Thread(target=write_to_pru, args=(rpmsg, sock))

    read_thread.start()
    write_thread.start()

    # Wait for both threads to complete (until SIGINT is received)
    read_thread.join()
    write_thread.join()

    # Clean up after threads finish
    rpmsg.close()
    sock.close()
