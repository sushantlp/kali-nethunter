#!/system/bin/sh

##
# Script to remove of realtek rtl8187 modules via init.d or immediately
##

SYSTEM_DEVICE="/dev/block/bootdevice/by-name/system"

# check if needed modules are available otherwise quit, in addition quit if we already have our init script removed
if [ ! -f /system/lib/modules/mac80211.ko -o ! -f /system/lib/modules/rtl8187.ko -o ! -f /system/lib/modules/eeprom_93cx6.ko ]; then
	echo "At least one of the needed modules are missing!"
	echo "Modules mac80211.ko, rtl8187.ko, eeprom_93cx6.ko"
	echo "must be present in /system/lib/modules/"
	exit 0
fi

# use this to unload modules immediately
if [ "$1" == "now" ]; then
	busybox rmmod /system/lib/modules/rtl8187.ko
	busybox rmmod /system/lib/modules/eeprom_93cx6.ko
	busybox rmmod /system/lib/modules/mac80211.ko
	sleep 1
	# enable systems wifi
	svc wifi enable
	exit 0
fi

# but default is to remove init script and do a reboot (lesser problems expected)
if [ -f /system/etc/init.d/99_rtl8187_init.sh ]; then
	busybox mount -o remount,rw -t ext4 $SYSTEM_DEVICE /system
	rm /system/etc/init.d/99_rtl8187_init.sh
	busybox sync
	busybox mount -o remount,ro -t ext4 $SYSTEM_DEVICE /system
	# enable systems wifi
	svc wifi enable
	# finally reboot
	echo 0 > /sys/kernel/dyn_fsync/Dyn_fsync_active
	busybox sync
	sleep 1
	/system/bin/reboot
fi