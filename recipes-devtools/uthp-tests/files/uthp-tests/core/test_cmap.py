import os
import sys
import subprocess
import pytest

@pytest.fixture(scope="session", autouse=True)
def change_working_dir():
    """Change the working directory and update sys.path for imports."""
    cmap_path = "/opt/uthp/programs/cmap"
    os.chdir(cmap_path)
    sys.path.insert(0, cmap_path) # needed for python module imports

def test_installation():
    """Ensure the cmap package is installed."""
    try:
        from lib.uds_node import UDSNode
        from lib.net_can_bus import NetworkCanBus
        from lib.service import Service
    except ImportError:
        pytest.fail("CMAP package is not installed or not in Python path.")

def test_directories():
    """Check if all necessary directories exist in the cloned repo."""
    required_dirs = ["venv", "lib", "old"]
    missing_dirs = [d for d in required_dirs if not os.path.isdir(d)]
    
    if missing_dirs:
        pytest.fail(f"Missing directories: {', '.join(missing_dirs)}")

def test_scan_with_class():
    """Ensure that scan_with_class.py runs without errors."""
    script_path = "./scan_with_class.py"
    if not os.path.isfile(script_path):
        pytest.fail(f"scan_with_class.py not found at f{os.path.abspath(script_path)}")
    try:
        result = subprocess.run([script_path], capture_output=True, text=True, check=True)
    except subprocess.CalledProcessError as e:
        pytest.fail(f"Error running scan_with_class.py: {e}")

def test_cleanup():
    """Remove any files created during testing."""
    # remove all .log files
    try:
        for f in os.listdir():
            if f.endswith(".log"):
                os.remove(f)
    except Exception as e:
        pytest.fail(f"Error removing log files: {e}. Might need to run as sudo.")
