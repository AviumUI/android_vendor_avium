#
# SPDX-FileCopyrightText: 2025 The AviumUI Project
# SPDX-License-Identifier: Apache-2.0
#

# AviumUI version properties
PRODUCT_SYSTEM_PROPERTIES += \
	ro.avium.build.version=$(PLATFORM_VERSION) \
    ro.avium.display.version=$(AVIUM_DISPLAY_VERSION) \
    ro.avium.gms_status=$(WITH_GMS) \
	ro.avium.maintainer=$(AVIUM_MAINTAINER) \
    ro.avium.releasetype=$(AVIUM_BUILDTYPE)	\
    ro.avium.version=$(AVIUM_VER) 

# Enable Material Design 3 Expressive
PRODUCT_PRODUCT_PROPERTIES += is_expressive_design_enabled=true

# Enable blur if maintainer asked
ifeq ($(TARGET_ENABLE_BLUR), true)
PRODUCT_PRODUCT_PROPERTIES += ro.surface_flinger.supports_background_blur=1
PRODUCT_PRODUCT_PROPERTIES += ro.sf.blurs_are_expensive=true
endif # TARGET_ENABLE_BLUR
