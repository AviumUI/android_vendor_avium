# 
# Copyright (C) 2025 The AviumUI Project
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

# AviumUI configuration file

# Build
# AVIUM_IS_OFFICIAL is a boolean flag to indicate 
# whether the build is official or unofficial.
AVIUM_IS_OFFICIAL ?= false
# AVIUM_VERSION_APPEND_TIME_OF_DAY is a boolean flag to indicate
# whether to append time of day to the build date.
AVIUM_VERSION_APPEND_TIME_OF_DAY ?= false

# GMS
# WITH_GMS is a boolean flag to indicate 
# whether to include Google Mobile Services (GMS) in the build.
WITH_GMS ?= false
# TARGET_GMS_TYPE has 3 options: FULL, MINI and PICO.
# FULL: The most complete GMS components
# MINI: The part of necessary GMS components
# PICO: The minimum GMS core components
# If WITH_GMS is true and TARGET_GMS_TYPE is not set, it will default to MINI
TARGET_GMS_TYPE ?= MINI

# Maintainer
# AVIUM_MAINTAINER is a string that represents the maintainer of the build.
AVIUM_MAINTAINER ?= Unknown

# LatinIMEGooglePrebuilt
# If WITH_GMS is true, Google LatinIME will be included 
# and forced override the default IME.
TARGET_INCLUDE_GOOGLEIME ?= false
TARGET_GOOGLEIME_OVERRIDE_IME ?= false

# Spoof Props
# Set to true to enable spoofing fake props.
# For letting apps think they are running on a locked device.
AVIUM_FORCE_SET_FAKE_PROP ?= false

# Blur Effect
# Set to true to force enable blur for SystemUI.
TARGET_ENABLE_BLUR ?= false

# Settings
# Soc model name
AVIUM_SETTINGS_SOC_MODEL_NAME ?= Unknown
# Device code name
AVIUM_SETTINGS_DEVICE_CODENAME ?= Unknown

# Include configs
$(call inherit-product, vendor/avium/config/packages.mk)
$(call inherit-product, vendor/avium/config/overlay.mk)
$(call inherit-product, vendor/avium/config/version.mk)
$(call inherit-product, vendor/avium/config/sepolicy.mk)
$(call inherit-product, vendor/avium/config/gms.mk)
$(call inherit-product, vendor/avium/config/soong_namespace.mk)
$(call inherit-product, vendor/avium/config/prop.mk)

# AviumUI init
PRODUCT_COPY_FILES += \
     vendor/avium/prebuilt/common/etc/init/init.avium.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.avium.rc
