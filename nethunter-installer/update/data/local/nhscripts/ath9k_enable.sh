#!/system/bin/sh

##
# Script to proper load atheros ath9k modules via init.d or immediately
##

# system device
SYSTEM_DEVICE="/dev/block/bootdevice/by-name/system"

# check if needed modules are available otherwise quit
if [ ! -f /system/lib/modules/mac80211.ko -o ! -f /system/lib/modules/ath9k.ko -o ! -f /system/lib/modules/ath9k_common.ko -o ! -f /system/lib/modules/ath9k_htc.ko -o ! -f /system/lib/modules/ath9k.ko ]; then
	echo "At least one of the needed modules are missing!"
	echo "Modules mac80211.ko, ath9k.ko, ath9k_common.ko, ath9k_htc.ko, ath9k.ko"
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

	# only add ath module if available (newer driver versions have that module)
	if [ -f /system/lib/modules/ath.ko ]; then
		busybox insmod /system/lib/modules/ath.ko
	fi

	# ath9k module sequence
	busybox insmod /system/lib/modules/ath9k_hw.ko
	busybox insmod /system/lib/modules/ath9k_common.ko
	busybox insmod /system/lib/modules/ath9k_htc.ko
	busybox insmod /system/lib/modules/ath9k.ko
	exit 0
fi

# create init script in /system/etc/init.d folder and reboot
if [ ! -f /system/etc/init.d/99_ath9k_init.sh ]; then

	# disable systems wifi (+reboot = important to avoid possible driver clash!)
	svc wifi disable

	# create init script
	busybox mount -o remount,rw -t ext4 $SYSTEM_DEVICE /system
	echo "#!/system/bin/sh" > /system/etc/init.d/99_ath9k_init.sh
	echo "busybox insmod /system/lib/modules/mac80211.ko" >> /system/etc/init.d/99_ath9k_init.sh

	# only add ath.ko module if available (newer driver versions have that module)
	if [ -f /system/lib/modules/ath.ko ]; then
		echo "busybox insmod /system/lib/modules/ath.ko" >> /system/etc/init.d/99_ath9k_init.sh
	fi

	# ath9k module sequence
	echo "busybox insmod /system/lib/modules/ath9k_hw.ko" >> /system/etc/init.d/99_ath9k_init.sh
	echo "busybox insmod /system/lib/modules/ath9k_common.ko" >> /system/etc/init.d/99_ath9k_init.sh
	echo "busybox insmod /system/lib/modules/ath9k_htc.ko" >> /system/etc/init.d/99_ath9k_init.sh
	echo "busybox insmod /system/lib/modules/ath9k.ko" >> /system/etc/init.d/99_ath9k_init.sh

	# make it executeable
	busybox chmod 775 /system/etc/init.d/99_ath9k_init.sh
	busybox sync
	busybox mount -o remount,ro -t ext4 $SYSTEM_DEVICE /system

	# finally reboot
	echo 0 > /sys/kernel/dyn_fsync/Dyn_fsync_active
	busybox sync
	sleep 2
	/system/bin/reboot
fi
