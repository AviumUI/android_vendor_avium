#
# SPDX-FileCopyrightText: 2025 The AviumUI Project
# SPDX-License-Identifier: Apache-2.0
#

# Permissions
PRODUCT_COPY_FILES += $(OPLUS_COMMON_PATH)/ConsumerIRApp/oplus-hiddenapi-package-allowlist.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/oplus-hiddenapi-package-allowlist.xml

PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.consumerir.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/android.hardware.consumerir.xml

# Service
PRODUCT_PACKAGES += android.hardware.ir-service.oplus

# Prebuilt App
PRODUCT_PACKAGES += ConsumerIRApp
