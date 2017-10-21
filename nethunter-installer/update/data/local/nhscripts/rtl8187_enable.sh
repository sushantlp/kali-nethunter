#!/system/bin/sh

##
# Script to proper load realtek rtl8187 modules via init.d or immediately
##

# system device
SYSTEM_DEVICE="/dev/block/bootdevice/by-name/system"

# if Magisk is available use its init folder
INIT_DIR="/system/etc/init.d"
if [ -e /magisk/.core/post-fs-data.d/ ]; then
    INIT_DIR="/magisk/.core/post-fs-data.d"
fi

# check if needed modules are available otherwise quit
if [ ! -f /system/lib/modules/mac80211.ko -o ! -f /system/lib/modules/rtl8187.ko -o ! -f /system/lib/modules/eeprom_93cx6.ko ]; then
	echo "At least one of the needed modules are missing!"
	echo "Modules mac80211.ko, rtl8187.ko, eeprom_93cx6.ko"
	echo "must be present in /system/lib/modules/"
	exit 0
fi

# use 'now' option to load modules immediately
if [ "$1" == "now" ]; then

	# disable systems wifi
	svc wifi disable
	sleep 2

	# load modules in proper dependency order (mac80211.ko always first)
	busybox insmod /system/lib/modules/mac80211.ko

	# rtl8187 module sequence
	busybox insmod /system/lib/modules/eeprom_93cx6.ko
	busybox insmod /system/lib/modules/rtl8187.ko
	exit 0
fi

# create init script in /system/etc/init.d folder and reboot
if [ ! -f $INIT_DIR/99_rtl8187_init.sh ]; then

	# disable systems wifi (+reboot = important to avoid possible driver clash!)
	svc wifi disable

	# create init script
	busybox mount -o remount,rw -t ext4 $SYSTEM_DEVICE /system
	echo "#!/system/bin/sh" > $INIT_DIR/99_rtl8187_init.sh
	echo "busybox insmod /system/lib/modules/mac80211.ko" >> $INIT_DIR/99_rtl8187_init.sh
	echo "busybox insmod /system/lib/modules/eeprom_93cx6.ko" >> $INIT_DIR/99_rtl8187_init.sh
	echo "busybox insmod /system/lib/modules/rtl8187.ko" >> $INIT_DIR/99_rtl8187_init.sh
	busybox chmod 775 $INIT_DIR/99_rtl8187_init.sh
	busybox sync
	busybox mount -o remount,ro -t ext4 $SYSTEM_DEVICE /system

	# make it executeable
	busybox chmod 775 $INIT_DIR/99_rtl8187_init.sh
	busybox sync
	busybox mount -o remount,ro -t ext4 $SYSTEM_DEVICE /system

	# finally reboot
	echo 0 > /sys/kernel/dyn_fsync/Dyn_fsync_active
	busybox sync
	sleep 2
	/system/bin/reboot
fi
