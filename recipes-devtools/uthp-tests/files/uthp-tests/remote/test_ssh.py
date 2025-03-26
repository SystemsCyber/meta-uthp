import os
import pytest
import paramiko

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

if __name__ == "__main__":
    pytest.main(["-v", __file__])
