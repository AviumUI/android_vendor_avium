# 
# Copyright (C) 2025-2026 The AviumUI Project
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#      http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# AviumUI GMS Configuration

ifeq ($(WITH_GMS),true)
# Override gsans if using gms
TARGET_USES_GSANS := true

# Disable Google IME in avium prebuilts
TARGET_INCLUDE_GOOGLEIME := false
TARGET_GOOGLEIME_OVERRIDE_IME := false
endif

# Get non-opensource aspects
# Pixel Clocks
$(call inherit-product, vendor/pixel/clocks/products/clocks.mk)

# Pixel GMS
$(call inherit-product, vendor/pixel/gms/products/gms.mk)

# Pixel GSans
ifeq ($(TARGET_USES_GSANS),true)
$(call inherit-product, vendor/pixel/gsans/products/gsans.mk)
endif

# Pixel ThemePicker
$(call inherit-product, vendor/pixel/sounds/products/sounds.mk)

# Pixel ThemePicker
$(call inherit-product, vendor/pixel/themepicker/products/themepicker.mk)
