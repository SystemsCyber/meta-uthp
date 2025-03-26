import os
import subprocess
import getpass
# TODO: need to log the output of the test from this script

def set_env():
    """Prompt user for SSH login details and set them as environment variables."""
    os.environ["SSH_HOST"] = input("Enter remote host IP: ").strip()
    os.environ["SSH_USER"] = input("Enter SSH username: ").strip()
    os.environ["SSH_PASS"] = input("Enter SSH password: ").strip()
    #os.environ["SSH_PASS"] = getpass.getpass("Enter SSH password: ")
def cleanup_env():
    """Remove SSH credentials from environment after test."""
    os.environ.pop("SSH_HOST", None)
    os.environ.pop("SSH_USER", None)
    os.environ.pop("SSH_PASS", None)

def main():
    """Run the SSH test script with environment variables set."""
    set_env()

    try:
        print("\nRunning SSH test...\n")
        result = subprocess.run(["pytest", "-s", "test_ssh.py"], check=True)
    except subprocess.CalledProcessError:
        print("Test failed.")
    finally:
        cleanup_env()
        print("\nEnvironment variables cleaned up.")

if __name__ == "__main__":
    main()