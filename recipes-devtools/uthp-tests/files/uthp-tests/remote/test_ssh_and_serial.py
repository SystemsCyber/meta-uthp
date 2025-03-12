import os
import pytest
import paramiko
import serial
import time
import sys
import glob
import re

LOGIN_PROMPT_REGEX = r".*\s*login:\s*"
PASSWORD_PROMPT = "Password:"
SUCCESS_MESSAGE = "Last login"

@pytest.mark.parametrize("command", ["echo SSH_SUCCESS"])
def test_ssh_connection(command):
    """Test SSH connection using Paramiko instead of SSH commands."""
    ssh_host = os.getenv("SSH_HOST")
    ssh_user = os.getenv("SSH_USER")
    ssh_pass = os.getenv("SSH_PASS")

    assert ssh_host and ssh_user and ssh_pass, "SSH credentials are not set!"

    try:
        # Create SSH client
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh.connect(ssh_host, username=ssh_user, password=ssh_pass, timeout=10)

        # Execute initial test command
        stdin, stdout, stderr = ssh.exec_command(command)
        output = stdout.read().decode().strip()
        error = stderr.read().decode().strip()

        print("SSH Output:", output)
        print("SSH Error:", error)

        assert "SSH_SUCCESS" in output, f"Initial SSH command failed: {error}"
        print("[SUCCESS] SSH authentication verified.")

        # Execute 'whoami' after SSH success
        stdin, stdout, stderr = ssh.exec_command("whoami")
        whoami_output = stdout.read().decode().strip()
        whoami_error = stderr.read().decode().strip()

        print("whoami Output:", whoami_output)
        print("whoami Error:", whoami_error)

        assert whoami_output == ssh_user, f"'whoami' command failed: {whoami_error}"

    except Exception as e:
        pytest.fail(f"SSH connection failed: {e}")

    finally:
        ssh.close()

def find_serial_ports():
    """Finds all available serial ports based on the OS."""
    if sys.platform.startswith("win"):  # Windows
        ports = [f"COM{i}" for i in range(1, 256)]  # COM1 to COM255
    elif sys.platform.startswith("darwin"):  # Mac
        ports = glob.glob("/dev/tty.usbmodem*") + glob.glob("/dev/cu.usbmodem*")
    elif sys.platform.startswith("linux"):  # Linux
        ports = glob.glob("/dev/ttyUSB*") + glob.glob("/dev/ttyS*")
    else:
        raise EnvironmentError("Unsupported OS")

    if not ports:
        raise serial.SerialException("No serial ports found. Check your connection.")

    return ports  # Return a list of detected ports

@pytest.fixture(scope="session")
def serial_connection():
    """Tries connecting to each serial port and returns the first valid one."""
    for serial_port in find_serial_ports():
        print(f"\n[INFO] Attempting connection on {serial_port}")

        try:
            ser = serial.Serial(serial_port, 115200, timeout=8)  # Increased timeout
            time.sleep(2)  # Allow connection to stabilize

            # Flush buffer
            ser.reset_input_buffer()
            ser.reset_output_buffer()

            # Send ENTER to trigger the login prompt or shell prompt
            print(f"[INFO] Sending ENTER to wake up the console on {serial_port}...")
            ser.write(b"\r\n\r\n\r\n")
            time.sleep(2)  # Wait for BBB to respond

            # Read more data to capture possible prompts
            output = ser.read(2000).decode(errors="ignore").strip()
            print(f"\n[DEBUG] FULL DATA RECEIVED FROM {serial_port}:\n{output}")

            # Save output for debugging
            with open("serial_debug.log", "a", encoding="utf-8") as log_file:
                log_file.write(f"\n[PORT: {serial_port}]\n{output}\n")

            # Check for login prompt OR direct shell prompt in any line
            lines = output.split("\n")
            prompt_found = False
            for line in lines:
                if "login:" in line or re.search(r"UTHP-R1-.*:~\$", line):
                    prompt_found = True
                    break  # Stop searching once we find a valid prompt

            if prompt_found:
                print(f"[SUCCESS] Valid prompt detected on {serial_port}")
                return ser  # Return the working serial connection and stop testing other ports
            else:
                print(f"[WARNING] No valid prompt detected on {serial_port}. Trying next port...")
                ser.close()
        except Exception as e:
            print(f"[ERROR] Skipping {serial_port} due to error: {e}")

    pytest.fail("No valid serial ports found.")


def test_serial_console_login(serial_connection):
    """Tests logging into the BeagleBone via the serial console."""
    ser = serial_connection

    # Send ENTER to trigger the login prompt
    ser.write(b"\r\n\r\n")
    time.sleep(1)  # Allow BeagleBone to respond

    # Read initial login prompt
    output = ser.read(1000).decode(errors="ignore").strip()

    # Debugging log
    print(f"\n[DEBUG] Full received output:\n{output}")

    # Save output to a log file for analysis
    with open("serial_debug.log", "a", encoding="utf-8") as log_file:
        log_file.write(f"\n[DEBUG] SERIAL OUTPUT FROM {ser.port}\n{output}\n")

    assert re.search(LOGIN_PROMPT_REGEX, output), f"Did not receive login prompt, received:\n{output}"

    # Get credentials from environment variables
    ssh_user = os.getenv("SSH_USER")
    ssh_pass = os.getenv("SSH_PASS")

    assert ssh_user and ssh_pass, "SSH credentials are not set!"

    # Send username
    ser.write((ssh_user + "\r\n").encode())  # Use \r\n for serial communication
    time.sleep(1)

    # Read password prompt
    output = ser.read_until(b"Password:").decode(errors="ignore").strip()
    assert PASSWORD_PROMPT in output, "Did not receive password prompt"

    # Send password
    ser.write((ssh_pass + "\r\n").encode())
    time.sleep(3)  # Wait for login processing

    # Read final output after login
    output = ser.read(3000).decode(errors="ignore").strip()  # Increased buffer size to capture the full banner
    print(f"\n[DEBUG] Post-login output:\n{output}")

    # Save output to a log file
    with open("serial_debug.log", "a", encoding="utf-8") as log_file:
        log_file.write(f"\n[DEBUG] POST-LOGIN OUTPUT FROM {ser.port}\n{output}\n")

    # Check for success using multiple possible login success indicators
    success_patterns = [
        r"Last login",  # Traditional login success message
        r"Welcome to the Ultimate Truck Hacking Platform",  # Custom login banner
        rf"{ssh_user}@.*:~\$",  # Expected shell prompt with username
        r"\$ ",  # Generic shell prompt
        r"# ",  # Root shell prompt
        r"UTHP-R1-.*:~\$",  # Matches different variations of the UTHP prompt
    ]

    # Ensure at least one success pattern matches
    success_detected = any(re.search(pattern, output, re.MULTILINE) for pattern in success_patterns)

    assert success_detected, f"Serial console login failed, received:\n{output}"

    # Close the session properly
    ser.write(b"exit\r\n")
    time.sleep(1)

if __name__ == "__main__":
    pytest.main(["-v", __file__])