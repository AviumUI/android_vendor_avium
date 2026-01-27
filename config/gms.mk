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
endif # WITH_GMS

# Check if repository exists
MISSING_DIRS :=
ifeq ($(TARGET_USES_GSANS), true)
ifeq ($(wildcard vendor/pixel/gsans),)
MISSING_DIRS += vendor/pixel/gsans
endif
endif # TARGET_USES_GSANS
ifeq ($(WITH_GMS), true)
ifeq ($(wildcard vendor/pixel/gms),)
MISSING_DIRS += vendor/pixel/gms
endif
ifeq ($(wildcard vendor/pixel/clocks),)
MISSING_DIRS += vendor/pixel/clocks
endif
ifeq ($(wildcard vendor/pixel/sounds),)
MISSING_DIRS += vendor/pixel/sounds
endif
endif # WITH_GMS
ifneq ($(strip $(MISSING_DIRS)),)
$(warning Missing required directories: $(MISSING_DIRS))
$(warning You may want to run 'avium get_gms' command to sync them.)
$(error Aborting due to missing required repositories)
endif

# Get non-opensource aspects
ifeq ($(strip $(MISSING_DIRS)),)
ifeq ($(WITH_GMS), true)
# Pixel Clocks
$(call inherit-product, vendor/pixel/clocks/products/clocks.mk)

# Pixel GMS
$(call inherit-product, vendor/pixel/gms/products/gms.mk)

# Pixel Sounds
$(call inherit-product, vendor/pixel/sounds/products/sounds.mk)
endif # WITH_GMS

# Pixel GSans
ifeq ($(TARGET_USES_GSANS), true)
$(call inherit-product, vendor/pixel/gsans/products/gsans.mk)
endif # TARGET_USES_GSANS
endif # MISSING_DIRS
