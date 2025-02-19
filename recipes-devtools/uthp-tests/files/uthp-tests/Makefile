LOG_DIR := ./logs
TIMESTAMP := $(shell date +%Y-%m-%d_%H-%M-%S)
HOST := $(shell hostname)
LOG_FILE := $(LOG_DIR)/$(HOST)_$(TIMESTAMP)

core-test: create-log-dir
	@script -q -c "bash -c './core-testing && pytest ./core/'" $(LOG_FILE)-core-results.txt

plc-test: create-log-dir
	@script -q -c "bash -c './plc-testing && pytest ./plc/'" $(LOG_FILE)-plc-results.txt

remote-test: create-log-dir
	# TODO: Add remote testing commands here

reset: 
	rm -rf logs/
	rm -rf core/__pycache__
	rm -rf core/.pytest_cache
	rm -rf plc/__pycache__
	rm -rf plc/.pytest_cache
	sudo rm -f /var/log/plc4trucksduck-errors.log
	sudo rm -f /var/log/plc4trucksduck.log
	sudo rm -f /var/log/j17084truckduck-errors.log
	sudo rm -f /var/log/j17084truckduck.log
	if ls /opt/uthp/programs/cmap/*.log 1> /dev/null 2>&1; then sudo rm /opt/uthp/programs/cmap/*.log; fi

reset-remote:
	# TODO: Add remote clean up commands here    

post-production:
	# TODO: Add post production ready commands here (clean up the uthp tests directory)
	rm -rf /home/uthp/testing/

create-log-dir:
	mkdir -p $(LOG_DIR)
