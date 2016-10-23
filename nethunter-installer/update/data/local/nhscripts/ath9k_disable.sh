#!/system/bin/sh

##
# Script to remove of atheros ath9k modules via init.d or immediately
##

SYSTEM_DEVICE="/dev/block/bootdevice/by-name/system"

# check if needed modules are available otherwise quit
if [ ! -f /system/lib/modules/mac80211.ko -o ! -f /system/lib/modules/ath9k.ko -o ! -f /system/lib/modules/ath9k_common.ko -o ! -f /system/lib/modules/ath9k_htc.ko -o ! -f /system/lib/modules/ath9k.ko ]; then
	echo "At least one of the needed modules are missing!"
	echo "Modules mac80211.ko, ath9k.ko, ath9k_common.ko, ath9k_htc.ko, ath9k.ko"
	echo "must be present in /system/lib/modules/"
	exit 0
fi

# use this to unload modules immediately
if [ "$1" == "now" ]; then
	busybox rmmod /system/lib/modules/ath9k_htc.ko
	busybox rmmod /system/lib/modules/ath9k.ko
	busybox rmmod /system/lib/modules/ath9k_common.ko
	busybox rmmod /system/lib/modules/ath9k_hw.ko
	if [ -f /system/lib/modules/ath.ko ]; then
		busybox rmmod /system/lib/modules/ath.ko
	fi
	busybox rmmod /system/lib/modules/mac80211.ko
	sleep 1
	# enable systems wifi
	svc wifi enable
	exit 0
fi

# default is to remove init script again and do a reboot (lesser problems expected)
if [ -f /system/etc/init.d/99_ath9k_init.sh ]; then
	busybox mount -o remount,rw -t ext4 $SYSTEM_DEVICE /system
	rm /system/etc/init.d/99_ath9k_init.sh
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
