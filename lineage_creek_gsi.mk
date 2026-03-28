#
# All components inherited here go to system image
#
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)

TARGET_SUPPORTS_OMX_SERVICE := false
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_system.mk)


# Always build modules from source
MODULE_BUILD_FROM_SOURCE := true

#
# All components inherited here go to system_ext image
#
# This makefile contains the system_ext partition contents for CTS on
# GSI compliance testing. Only add something here for this purpose.
$(call inherit-product, $(SRC_TARGET_DIR)/product/media_system_ext.mk)

#  handheld packages
PRODUCT_PACKAGES += \
    Launcher3QuickStep \
    Provision \
    Settings \
    StorageManager \
    SystemUI

#  telephony packages
PRODUCT_PACKAGES += \
    CarrierConfig

# Add all of the packages used to support older/upgrading devices
# These can be removed as we drop support for the older API levels
PRODUCT_PACKAGES += \
    $(PRODUCT_PACKAGES_SHIPPING_API_LEVEL_29) \
    $(PRODUCT_PACKAGES_SHIPPING_API_LEVEL_33) \
    $(PRODUCT_PACKAGES_SHIPPING_API_LEVEL_34)

# Install a copy of the debug policy to the system_ext partition, and allow
# init-second-stage to load debug policy from system_ext.
# This option is only meant to be set by compliance GSI targets.
PRODUCT_INSTALL_DEBUG_POLICY_TO_SYSTEM_EXT := true
PRODUCT_PACKAGES += system_ext_userdebug_plat_sepolicy.cil

##$(call inherit-product, device/generic/common/gsi_system_ext.mk)

# pKVM
$(call inherit-product, packages/modules/Virtualization/apex/product_packages.mk)

#
# All components inherited here go to product image
#

$(call inherit-product, $(SRC_TARGET_DIR)/product/media_product.mk)

PRODUCT_PACKAGES += \
    Browser2 \
    Camera2 \
    Dialer \
    LatinIME

# Default AOSP sounds
$(call inherit-product-if-exists, frameworks/base/data/sounds/AllAudio.mk)

# Additional settings used in all AOSP builds
PRODUCT_PRODUCT_PROPERTIES += \
    ro.config.ringtone?=Ring_Synth_04.ogg \
    ro.config.notification_sound?=pixiedust.ogg \
    ro.com.android.dataroaming?=true

##$(call inherit-product, device/generic/common/gsi_product.mk)

#
# Special settings for GSI releasing
#

BUILDING_GSI := true

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/etc/init/config \
    system/product/% \
    system/system_ext/%

# GSI should always support up-to-date platform features.
# Keep this value at the latest API level to ensure latest build system
# default configs are applied.

BOARD_SHIPPING_API_LEVEL := 33
PRODUCT_SHIPPING_API_LEVEL := 33
##PRODUCT_SHIPPING_API_LEVEL := 34 +++

# Enable dynamic partitions to facilitate mixing onto Cuttlefish
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Enable dynamic partition size
PRODUCT_USE_DYNAMIC_PARTITION_SIZE := true

# GSI specific tasks on boot
PRODUCT_PACKAGES += \
    gsi_skip_mount.cfg

# Overlay the GSI specific setting for framework and SystemUI
ifneq ($(PRODUCT_IS_AUTOMOTIVE),true)
    PRODUCT_PACKAGES += \
        gsi_overlay_framework \
        gsi_overlay_systemui

    PRODUCT_COPY_FILES += \
        device/generic/common/overlays/overlay-config.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/overlay/config/config.xml
endif

# Support additional VNDK snapshots
PRODUCT_EXTRA_VNDK_VERSIONS := \
    33 \
    34

# Do not build non-GSI partition images.
PRODUCT_BUILD_CACHE_IMAGE := false
PRODUCT_BUILD_DEBUG_BOOT_IMAGE := false
PRODUCT_BUILD_DEBUG_VENDOR_BOOT_IMAGE := false
PRODUCT_BUILD_USERDATA_IMAGE := false
PRODUCT_BUILD_VENDOR_IMAGE := false
PRODUCT_BUILD_SUPER_PARTITION := false
PRODUCT_BUILD_SUPER_EMPTY_IMAGE := false
PRODUCT_BUILD_SYSTEM_DLKM_IMAGE := false
PRODUCT_EXPORT_BOOT_IMAGE_TO_DIST := true

# Additional settings used in all GSI builds
PRODUCT_PRODUCT_PROPERTIES += \
    ro.crypto.metadata_init_delete_all_keys.enabled=false \
    debug.codec2.bqpool_dealloc_after_stop=1 

# Window Extensions
ifneq ($(PRODUCT_IS_ATV),true)
$(call inherit-product, $(SRC_TARGET_DIR)/product/window_extensions.mk)
endif

# A GSI is to be mixed with different boot images. That means we can't determine
# the kernel version when building a GSI.
# Assume the device supports UFFD. If it doesn't, the ART runtime will fall back
# to CC, and odrefresh will regenerate core dexopt artifacts on the first boot,
# so this is okay.
PRODUCT_ENABLE_UFFD_GC := true

##$(call inherit-product, $(SRC_TARGET_DIR)/product/gsi_release.mk)

##$(call inherit-product, device/generic/common/gsi_arm64.mk)

$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
##$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base_telephony.mk)



# Allow building otatools
TARGET_FORCE_OTA_PACKAGE := true
##include vendor/lineage/build/target/product/lineage_generic_target.mk

PRODUCT_USE_DYNAMIC_PARTITION_SIZE := true

TARGET_NO_KERNEL_OVERRIDE := true



##$(call inherit-product, vendor/lineage/build/target/product/lineage_gsi_arm64.mk)
-include vendor/lineage/build/core/config.mk
PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS := false



# Telephony
PRODUCT_PACKAGES += \
    extphonelib \
    extphonelib-product \
    extphonelib.xml \
    extphonelib_product.xml \
    ims-ext-common \
    ims_ext_common.xml \
    qti-telephony-hidl-wrapper \
    qti-telephony-hidl-wrapper-prd \
    qti_telephony_hidl_wrapper.xml \
    qti_telephony_hidl_wrapper_prd.xml \
    qti-telephony-utils \
    qti-telephony-utils-prd \
    qti_telephony_utils.xml \
    qti_telephony_utils_prd.xml \
    telephony-ext \
    xiaomi-telephony-stub \
    QtiTelephonyCompat

PRODUCT_BOOT_JARS += \
    telephony-ext \
    xiaomi-telephony-stub

# DeviceAsWebcam
#PRODUCT_PACKAGES += \
#    DeviceAsWebcam
#PRODUCT_SYSTEM_PROPERTIES += \
#    ro.usb.uvc.enabled=true

# Init scripts fiks SMS
PRODUCT_PACKAGES += \
    sim-restart.rc

PRODUCT_PACKAGES += \
    init.sim.restart.sh


# Overlays

PRODUCT_ENFORCE_RRO_TARGETS := *
#PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS :=

PRODUCT_PACKAGES += \
    CarrierConfigResCommon \
    TelephonyResCommon \
    FrameworksResPhone \
    FrameworksResCommon \
    SystemUIResCommon \
    SettingsResCreek \
    TelecommResCommon \
    WifiResCommon


# Device-specific settings
PRODUCT_PACKAGES += \
     XiaomiDolby

##$(call inherit-product, device/lineage/gsi/device.mk)

# Inherit from the proprietary files makefile.
$(call inherit-product, vendor/xiaomi/creek_gsi/creek_gsi-vendor.mk)


# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH) \
    hardware/xiaomi

PRODUCT_BRAND := Android
PRODUCT_NAME := lineage_gsi_arm64
PRODUCT_DEVICE := creek_gsi
PRODUCT_MODEL := mivendor

PRODUCT_CHARACTERISTICS := device

PRODUCT_ENFORCE_ARTIFACT_PATH_REQUIREMENTS :=
#PRODUCT_GMS_CLIENTID_BASE := android-xiaomi
