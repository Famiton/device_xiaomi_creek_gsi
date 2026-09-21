#
# Special settings for GSI releasing
#
BUILDING_GSI := true
ifneq ($(filter lineage_gsi_%,$(TARGET_PRODUCT)),)
BUILDING_LINEAGE_GSI := true
endif

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/etc/init/config \
    system/product/% \
    system/system_ext/%

# GSI should always support up-to-date platform features.
# Keep this value at the latest API level to ensure latest build system
# default configs are applied.
PRODUCT_SHIPPING_API_LEVEL := $(PLATFORM_SDK_VERSION)
BOARD_SHIPPING_API_LEVEL := 33

# Enable dynamic partitions to facilitate mixing onto Cuttlefish
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Force-set 16KB page size configuration to be explicit,
# also because shipping API level on the GSI sometimes gets
# updated late.
PRODUCT_NO_BIONIC_PAGE_SIZE_MACRO := true
PRODUCT_MAX_PAGE_SIZE_SUPPORTED := 16384
PRODUCT_CHECK_PREBUILT_MAX_PAGE_SIZE := false

# Enable dynamic partition size
PRODUCT_USE_DYNAMIC_PARTITION_SIZE := true

# GSI specific tasks on boot
PRODUCT_PACKAGES += \
    gsi_skip_mount.cfg

# Add all system_ext packages used to support older/upgrading devices that have
# PRODUCT_SHIPPING_API_LEVEL 34 or older.
# These can be removed as we drop support for the older API levels.
PRODUCT_PACKAGES += \
    hwservicemanager \
    android.hidl.allocator@1.0-service \
    android.hidl.memory@1.0-impl

# PRODUCT_SHIPPING_API_LEVEL 33 or older.
# These can be removed as we drop support for the older API levels.
PRODUCT_PACKAGES += \
    wificond

# Support additional VNDK snapshots
PRODUCT_EXTRA_VNDK_VERSIONS := \
    33

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

# Build pvmfw with GSI: b/376363989, pvmfw currently only supports AArch64
#ifneq (,$(filter %_arm64,$(TARGET_PRODUCT)))
#PRODUCT_BUILD_PVMFW_IMAGE := true
#endif

# Additional settings used in all GSI builds
PRODUCT_PRODUCT_PROPERTIES += \
    ro.crypto.metadata_init_delete_all_keys.enabled=false \
    debug.codec2.bqpool_dealloc_after_stop=1 \

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

# Include all zygote init scripts. "ro.zygote" will select one of them.
PRODUCT_PACKAGES += \
    init.zygote32.rc \
    init.zygote64.rc \
    init.zygote64_32.rc

#=====================================================================================

# Always build modules from source
MODULE_BUILD_FROM_SOURCE := true

# Allow building otatools
TARGET_FORCE_OTA_PACKAGE := true

# Disable soong defined system image for now
USE_SOONG_DEFINED_SYSTEM_IMAGE := false
PRODUCT_SOONG_DEFINED_SYSTEM_IMAGE :=

-include vendor/lineage/build/core/config.mk
PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS := false

PRODUCT_USE_DYNAMIC_PARTITION_SIZE := true

TARGET_NO_KERNEL_OVERRIDE := true
PRODUCT_ENFORCE_ARTIFACT_PATH_REQUIREMENTS :=

#====================================================

# Reduce system image size by limiting debug info
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false
WITH_DEXPREOPT_DEBUG_INFO := false
USE_DEX2OAT_DEBUG := false
TARGET_HAS_LOW_RAM := true
PRODUCT_DEX_PREOPT_GENERATE_DM_FILES := true
PRODUCT_DEX_PREOPT_DEFAULT_COMPILER_FILTER := speed-profile
# Compile everything
#PRODUCT_DEX_PREOPT_DEFAULT_COMPILER_FILTER := everything

# Enable whole-program R8 Java optimizations for SystemUI and system_server,
# but also allow explicit overriding for testing and development.
SYSTEM_OPTIMIZE_JAVA ?= true
SYSTEMUI_OPTIMIZE_JAVA ?= true

# Speed profile services and wifi-service to reduce RAM and storage
PRODUCT_SYSTEM_SERVER_COMPILER_FILTER := speed-profile

# Inherit several Android Go configurations
PRODUCT_USE_PROFILE_FOR_BOOT_IMAGE := true
##PRODUCT_DEX_PREOPT_BOOT_IMAGE_PROFILE_LOCATION := frameworks/base/boot/boot-image-profile.txt
