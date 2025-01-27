#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/xiaomi/manet
KERNEL_PATH := $(DEVICE_PATH)-kernel

# !!! TESTING ONLY !!!
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true
BUILD_BROKEN_INCORRECT_PARTITION_IMAGES := true
BUILD_BROKEN_VENDOR_PROPERTY_NAMESPACE := true

# A/B
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS += \
    init_boot \
    boot \
    vendor_boot \
    system_dlkm \
    odm \
    vendor \
    system_ext \
    vendor_dlkm \
    dtbo \
    recovery \
    system \
    product

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 := 
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := kryo300

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := manet
TARGET_NO_BOOTLOADER := true
BOARD_RAMDISK_USE_LZ4 := true

# Boot
BOARD_BOOT_HEADER_VERSION := 4
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)

# Init Boot
BOARD_INIT_BOOT_HEADER_VERSION := 4
BOARD_MKBOOTIMG_INIT_ARGS += --header_version $(BOARD_INIT_BOOT_HEADER_VERSION)

# DTB
BOARD_PREBUILT_DTBOIMAGE := $(KERNEL_PATH)/dtbo.img
BOARD_PREBUILT_DTBIMAGE_DIR := $(KERNEL_PATH)/dtb

# Kernel (houji kang xD)
BOARD_KERNEL_PAGESIZE := 4096
BOARD_KERNEL_BASE := 0x00000000

BOARD_KERNEL_CMDLINE := \
    video=vfb:640x400,bpp=32,memsize=3072000 \
    disable_dma32=on \
    swinfo.fingerprint=$(LINEAGE_VERSION) \
    mtdoops.fingerprint=$(LINEAGE_VERSION)

BOARD_BOOTCONFIG := \
    androidboot.hardware=qcom \
    androidboot.hypervisor.protected_vm.supported=true \
    androidboot.load_modules_parallel=true \
    androidboot.memcg=1 \
    androidboot.usbcontroller=a600000.dwc3 \
    androidboot.selinux=permissive

BOARD_KERNEL_IMAGE_NAME := Image
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_RAMDISK_USE_LZ4 := true
BOARD_USES_GENERIC_KERNEL_IMAGE := true

TARGET_NO_KERNEL_OVERRIDE := true
TARGET_KERNEL_SOURCE := $(KERNEL_PATH)/kernel-headers
PRODUCT_COPY_FILES += \
	$(KERNEL_PATH)/kernel:kernel

# Kernel modules
# BOARD_SYSTEM_KERNEL_MODULES_LOAD := $(strip $(shell cat $(KERNEL_PATH)/system_dlkm/modules.load))

BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD := $(strip $(shell cat $(KERNEL_PATH)/vendor_ramdisk/modules.load))
BOARD_VENDOR_RAMDISK_KERNEL_MODULES := $(addprefix $(KERNEL_PATH)/vendor_ramdisk/, $(BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD))
BOARD_VENDOR_RAMDISK_KERNEL_MODULES_BLOCKLIST_FILE := $(KERNEL_PATH)/vendor_ramdisk/modules.blocklist
BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES_LOAD := $(strip $(shell cat $(KERNEL_PATH)/vendor_ramdisk/modules.load.recovery))
RECOVERY_MODULES := $(addprefix $(KERNEL_PATH)/vendor_ramdisk/, $(BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES_LOAD))
BOARD_VENDOR_RAMDISK_KERNEL_MODULES := $(sort $(BOARD_VENDOR_RAMDISK_KERNEL_MODULES) $(RECOVERY_MODULES))
BOARD_VENDOR_KERNEL_MODULES_LOAD := $(strip $(shell cat $(KERNEL_PATH)/vendor_dlkm/modules.load))
BOARD_VENDOR_KERNEL_MODULES := $(addprefix $(KERNEL_PATH)/vendor_dlkm/, $(BOARD_VENDOR_KERNEL_MODULES_LOAD))
BOARD_VENDOR_KERNEL_MODULES_BLOCKLIST_FILE :=  $(KERNEL_PATH)/vendor_dlkm/modules.blocklist

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(KERNEL_PATH)/system_dlkm/,$(TARGET_COPY_OUT_SYSTEM_DLKM)/lib/modules/6.1.25-android14-11-gab928514c75c-ab11207973)

# Partitions
BOARD_FLASH_BLOCK_SIZE := 262144 # (BOARD_KERNEL_PAGESIZE * 64)
BOARD_BOOTIMAGE_PARTITION_SIZE := 100663296
BOARD_DTBOIMG_PARTITION_SIZE := 8388608
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 104857600
BOARD_INIT_BOOT_IMAGE_PARTITION_SIZE := 8388608
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 100663296
BOARD_SUPER_PARTITION_SIZE := 9126805504 # TODO: Fix hardcoded value
BOARD_SUPER_PARTITION_GROUPS := xiaomi_dynamic_partitions
BOARD_XIAOMI_DYNAMIC_PARTITIONS_PARTITION_LIST := \
    system_dlkm \
    odm \
    vendor \
    system_ext \
    vendor_dlkm \
    system \
    product
BOARD_XIAOMI_DYNAMIC_PARTITIONS_SIZE := 9122611200 # TODO: Fix hardcoded value

# Platform
TARGET_BOARD_PLATFORM := pineapple

# Properties
TARGET_SYSTEM_PROP += $(DEVICE_PATH)/system.prop
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop
TARGET_PRODUCT_PROP += $(DEVICE_PATH)/product.prop
TARGET_SYSTEM_EXT_PROP += $(DEVICE_PATH)/system_ext.prop
TARGET_SYSTEM_DLKM_PROP += $(DEVICE_PATH)/system_dlkm.prop
TARGET_ODM_PROP += $(DEVICE_PATH)/odm.prop
TARGET_ODM_DLKM_PROP += $(DEVICE_PATH)/odm_dlkm.prop
TARGET_VENDOR_DLKM_PROP += $(DEVICE_PATH)/vendor_dlkm.prop

# Recovery
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/rootdir/etc/fstab.qcom
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

# Security patch level
VENDOR_SECURITY_PATCH := 2024-02-01

# FS
TARGET_FS_CONFIG_GEN := $(DEVICE_PATH)/configs/config.fs

# Verified Boot
BOARD_AVB_ENABLE := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3
BOARD_AVB_RECOVERY_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_RECOVERY_ALGORITHM := SHA256_RSA4096
BOARD_AVB_RECOVERY_ROLLBACK_INDEX := 1
BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 1
BOARD_AVB_VENDOR_BOOT_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_VENDOR_BOOT_ALGORITHM := SHA256_RSA4096
BOARD_AVB_VENDOR_BOOT_ROLLBACK_INDEX := 1
BOARD_AVB_VENDOR_BOOT_ROLLBACK_INDEX_LOCATION := 1

# VINTF
DEVICE_MANIFEST_SKUS := pineapple
DEVICE_MATRIX_FILE := $(DEVICE_PATH)/configs/vintf/compatibility_matrix.xml
DEVICE_MANIFEST_PINEAPPLE_FILES := \
    $(DEVICE_PATH)/configs/vintf/manifest_pineapple.xml
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE := \
    $(DEVICE_PATH)/configs/vintf/compatibility_matrix.device.xml

# Inherit the proprietary files
include vendor/xiaomi/manet/BoardConfigVendor.mk
