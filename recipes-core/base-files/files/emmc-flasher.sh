#!/bin/bash
source='mmcblk0'
destination='mmcblk1'

# helper functions
flush_cache () {
	sync
	blockdev --flushbufs /dev/${destination}
}

cylon_leds () {
	if [ -e /sys/class/leds/beaglebone\:green\:usr0/trigger ] ; then
		BASE=/sys/class/leds/beaglebone\:green\:usr
		echo none > ${BASE}0/trigger
		echo none > ${BASE}1/trigger
		echo none > ${BASE}2/trigger
		echo none > ${BASE}3/trigger

		STATE=1
		while : ; do
			case $STATE in
			1)	echo 255 > ${BASE}0/brightness
				echo 0   > ${BASE}1/brightness
				STATE=2
				;;
			2)	echo 255 > ${BASE}1/brightness
				echo 0   > ${BASE}0/brightness
				STATE=3
				;;
			3)	echo 255 > ${BASE}2/brightness
				echo 0   > ${BASE}1/brightness
				STATE=4
				;;
			4)	echo 255 > ${BASE}3/brightness
				echo 0   > ${BASE}2/brightness
				STATE=5
				;;
			5)	echo 255 > ${BASE}2/brightness
				echo 0   > ${BASE}3/brightness
				STATE=6
				;;
			6)	echo 255 > ${BASE}1/brightness
				echo 0   > ${BASE}2/brightness
				STATE=1
				;;
			*)	echo 255 > ${BASE}0/brightness
				echo 0   > ${BASE}1/brightness
				STATE=2
				;;
			esac
			sleep 0.1
		done
	fi
}

partition_drive () {
fdisk /dev/${destination} << EOM
o
p
n
p
1
2048
+128M
y
t
c
a
1
n
p
2


y
p
w
EOM

flush_cache
}

write_failure () {
	echo "writing to [${destination}] failed..."

	[ -e /proc/$CYLON_PID ]  && kill $CYLON_PID > /dev/null 2>&1

	if [ -e /sys/class/leds/beaglebone\:green\:usr0/trigger ] ; then
		echo heartbeat > /sys/class/leds/beaglebone\:green\:usr0/trigger
		echo heartbeat > /sys/class/leds/beaglebone\:green\:usr1/trigger
		echo heartbeat > /sys/class/leds/beaglebone\:green\:usr2/trigger
		echo heartbeat > /sys/class/leds/beaglebone\:green\:usr3/trigger
	fi
	echo "-----------------------------"
	flush_cache
	umount /mnt/${destination}p1 || true
	umount /mnt/${destination}p2 || true
    umount /mnt/${source}p1 || true
    umount /mnt/${source}p2 || true
	exit
}

format_partitions () {
    # Format the first partition
    echo "Formatting first partition"
    umount /dev/${destination}p1; echo 'y' | mkfs.vfat -F 32 /dev/${destination}p1; flush_cache

    # Format the second partition
    echo "Formatting second partition"
    umount /dev/${destination}p2; echo 'y' | mkfs.ext4 /dev/${destination}p2; flush_cache
}

copy_partitions () {
    # Prepare the system to copy partitions
    mkdir -p /mnt/${destination}p1
    mount /dev/${destination}p1 /mnt/${destination}p1
    mkdir -p /mnt/${destination}p2
    mount /dev/${destination}p2 /mnt/${destination}p2
    mkdir -p /mnt/${source}p1
    mount /dev/${source}p1 /mnt/${source}p1
    mkdir -p /mnt/${source}p2
    mount /dev/${source}p2 /mnt/${source}p2

    # Make sure the BootLoader gets copied first:
	cp -v /mnt/${source}p1/MLO /mnt/${destination}p1/MLO || write_failure
	flush_cache

	cp -v /mnt/${source}p1/u-boot.img /mnt/${destination}p1/u-boot.img || write_failure
	flush_cache

	echo "rsync: /mnt/${source}p1/ -> /mnt/${destination}p1/"
	rsync -aAX /mnt/${source}p1/ /mnt/${destination}p1/ --exclude={MLO,u-boot.img} || write_failure
	flush_cache

    echo "rsync: /mnt/${source}p2/ -> /mnt/${destination}p2/"
    rsync -aAX /mnt/${source}p2/ /mnt/${destination}p2/ --exclude={/dev/*,/proc/*,/sys/*,/tmp/*,/run/*,/mnt/*,/media/*,/lost+found,/boot/*} || write_failure
    flush_cache
}

regenerate_ssh_keys () {
    # Regenerate SSH keys
    echo "==> Applying SSH Key and machine-id Regeneration trick"
    # ssh keys and machine-id will now get regenerated on the next bootup
    touch /mnt/${destination}p2/etc/ssh/ssh.regenerate
    rm -f /mnt/${destination}p2/etc/machine-id || true
    flush_cache
}

cleanup () {
    # Cleanup
    umount /mnt/${source}p1
    umount /mnt/${source}p2
    rm -rf /mnt/${source}p1
    rm -rf /mnt/${source}p2
}

# main
echo "==> eMMC Flasher"
# Check if user has sudo privileges
    if [ "$EUID" -ne 0 ]
    then echo "Please run as root"
    echo " "
    exit 1
    fi
# 1. start leds
cylon_leds & CYLON_PID=$!
# 2. erase emmc
echo "==> Erasing eMMC"
flush_cache
dd if=/dev/zero of=${destination} bs=1M count=108
sync
dd if=${destination} of=/dev/null bs=1M count=108
sync
flush_cache
# 3. partition emmc
echo "==> Partitioning eMMC"
partition_drive
# 4. format partitions
echo "==> Formatting eMMC"
format_partitions
# 5. copy partitions
echo "==> Copying eMMC"
copy_partitions
# 6. regenerate ssh keys
echo "==> Regenerating SSH keys"
regenerate_ssh_keys
# 7. regenerate fstab
echo "==> Regenerating fstab"
sed -i "s/${source}/${destination}/g" /mnt/${destination}p2/etc/fstab
# 8. cleanup
echo "==> Cleaning up"
cleanup
# 9. stop leds
kill $CYLON_PID > /dev/null 2>&1
echo "==> eMMC Flashing Complete"
echo "==> Please power off your device, remove the SD card, and power it back on"