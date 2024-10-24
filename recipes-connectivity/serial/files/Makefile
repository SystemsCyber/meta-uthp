CC = gcc
CFLAGS = -Wall -Wextra -O2

SRC_DIR = src

# all .c files in the SRC_DIR
SRC_FILES = $(wildcard $(SRC_DIR)/*.c)

# Create a list of executables based on the .c files
EXECUTABLES = $(patsubst $(SRC_DIR)/%.c, %, $(SRC_FILES))

# Rule to build all executables
all: $(EXECUTABLES)

# Rule to build an executable for each .c file
%: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) $< -o $@

# Clean up build files
.PHONY: clean install

clean:
	rm -f $(EXECUTABLES)

# must be run as root
install: 
	install -d /usr/bin
	for executable in $(EXECUTABLES); do \
		install -m 0755 $$executable /usr/bin; \
		@ echo "Installed $$executable"; \
	done
