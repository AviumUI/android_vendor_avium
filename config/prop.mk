#
# SPDX-FileCopyrightText: 2025 The AviumUI Project
# SPDX-License-Identifier: Apache-2.0
#

# Enable Material Design 3 Expressive
PRODUCT_PRODUCT_PROPERTIES += is_expressive_design_enabled=true

# Enable blur if maintainer asked
ifeq ($(TARGET_ENABLE_BLUR), true)
PRODUCT_PRODUCT_PROPERTIES += ro.surface_flinger.supports_background_blur=1
PRODUCT_PRODUCT_PROPERTIES += ro.sf.blurs_are_expensive=true
endif # TARGET_ENABLE_BLUR
