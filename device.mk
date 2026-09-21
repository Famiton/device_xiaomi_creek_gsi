#
# SPDX-License-Identifier: Apache-2.0
#

# pKVM
$(call inherit-product, packages/modules/Virtualization/apex/product_packages.mk)

# NFC
PRODUCT_PACKAGES += \
    com.android.nfc_extras \
    Tag

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

# Init scripts fix SMS
PRODUCT_PACKAGES += \
    sim-restart.rc

PRODUCT_PACKAGES += \
    init.sim.restart.sh

# Overlays
PRODUCT_ENFORCE_RRO_TARGETS := *

PRODUCT_PACKAGES += \
    CarrierConfigResCommon \
    TelephonyResCommon \
    FrameworksResPhone \
    FrameworksResCommon \
    SystemUIResCommon \
    SettingsResCreek \
    TelecommResCommon \
    WifiResCommon \
    DeviceAsWebcamOverlay

# Device-specific settings
PRODUCT_PACKAGES += \
    XiaomiDolby

# DeviceAsWebcam ?????
TARGET_BUILD_DEVICE_AS_WEBCAM := true

# Inherit from the proprietary files makefile.
$(call inherit-product, vendor/xiaomi/creek_gsi/creek_gsi-vendor.mk)

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH) \
    hardware/xiaomi
