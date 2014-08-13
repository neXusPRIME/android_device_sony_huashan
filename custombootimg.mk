LOCAL_PATH := $(call my-dir)

uncompressed_ramdisk := $(PRODUCT_OUT)/ramdisk.cpio
$(uncompressed_ramdisk): $(INSTALLED_RAMDISK_TARGET)
	zcat $< > $@

MKELF := device/sony/huashan/tools/mkelf.py
INITSH := device/sony/huashan/combinedroot/init.sh
BOOTREC_DEVICE := $(PRODUCT_OUT)/recovery/bootrec-device

INSTALLED_BOOTIMAGE_TARGET := $(PRODUCT_OUT)/boot.img

	$(hide) rm -fr $INSTALLED_BOOTIMAGE_TARGET
	$(hide) cp -r vendor/sony/huashan/proprietary/kernel/boot.img $(PRODUCT_OUT)
	$(hide) rm -fr $(PRODUCT_OUT)/system/lib/modules
	$(hide) cp -r vendor/sony/huashan/proprietary/lib/modules $(PRODUCT_OUT)/system/lib

INSTALLED_RECOVERYIMAGE_TARGET := $(PRODUCT_OUT)/recovery.img
$(INSTALLED_RECOVERYIMAGE_TARGET): $(MKBOOTIMG) \
	$(recovery_ramdisk) \
	$(recovery_kernel)
	@echo ----- Making recovery image ------
	$(hide) python $(MKELF) -o $@ $(PRODUCT_OUT)/kernel@0x80208000 $(PRODUCT_OUT)/ramdisk-recovery.img@0x81900000,ramdisk vendor/sony/huashan/proprietary/boot/RPM.bin@0x00020000,rpm device/sony/huashan/rootdir/cmdline.txt@cmdline
	@echo ----- Made recovery image -------- $@
