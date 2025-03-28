#!/usr/bin/env python3
import os
import subprocess
import logging
import sys
from datetime import datetime

class StreamToLogger:
    def __init__(self, logger, level):
        self.logger = logger
        self.level = level
        self.linebuf = ''

    def write(self, buf):
        for line in buf.rstrip().splitlines():
            self.logger.log(self.level, line.rstrip())

    def flush(self):
        pass

def init_logging():
    """Initialize logging configuration."""
    LOG_DIR = "logs"
    if not os.path.exists(LOG_DIR):
        os.makedirs(LOG_DIR)
    TIMESTAMP = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    HOST = os.getenv("SSH_PASS")
    LOG_FILE = f"{LOG_DIR}/{HOST}_{TIMESTAMP}-remote-results.txt"

    logging.basicConfig(
        level=logging.DEBUG,
        format='%(asctime)s - %(levelname)s - %(message)s',
        handlers=[
            logging.FileHandler(LOG_FILE),
            logging.StreamHandler(sys.stdout)
        ]
    )    
    return logging.getLogger()

def cleanup_env():
    """Remove SSH credentials from environment after test."""
    os.environ.pop("SSH_HOST", None)
    os.environ.pop("SSH_USER", None)
    os.environ.pop("SSH_PASS", None)

def main():
    """Run the SSH test script with environment variables set."""
    os.environ["SSH_HOST"] = input("Enter remote host IP: ").strip()
    os.environ["SSH_USER"] = input("Enter SSH username: ").strip()
    os.environ["SSH_PASS"] = input("Enter SSH password: ").strip()
    print("\nEnvironment variables cleaned up.")

    # initialize logging
    logger = init_logging()
    sys.stdout = StreamToLogger(logger, logging.INFO)
    sys.stderr = StreamToLogger(logger, logging.ERROR)

    try:
        print("\nRunning tests...\n")
        result = subprocess.run(["pytest", "."], capture_output=True, text=True)
        # print the result of the test
        print(result.stderr)
        print(result.stdout)
    except Exception as e:
        print(f"Test failed: {e}")
    finally:
        cleanup_env()

if __name__ == "__main__":
    main()