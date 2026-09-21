#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit device-specific configurations
$(call inherit-product, device/xiaomi/creek_gsi/device.mk)

# Inherit from common lineage configuration
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Special settings for GSI releasing
$(call inherit-product, device/xiaomi/creek_gsi/gsi_release.mk)

PRODUCT_NAME    := lineage_gsi_arm64
PRODUCT_DEVICE  := creek_gsi
PRODUCT_BRAND   := Android
PRODUCT_MODEL   := GSI on ARM64

PRODUCT_CHARACTERISTICS := device
PRODUCT_GMS_CLIENTID_BASE := android-xiaomi
