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

# This is AviumUI extra packages configuration file.

# LatinIMEGoogle
ifeq ($(TARGET_INCLUDE_GOOGLEIME),true)
    ifeq ($(TARGET_GOOGLEIME_OVERRIDE_IME),true)
        PRODUCT_PACKAGES += \
            LatinIMEGooglePrebuilt_Override
    else
        PRODUCT_PACKAGES += \
            LatinIMEGooglePrebuilt
    endif
endif

# AviumUI Apps
PRODUCT_PACKAGES += \
    FeatureSettings \
    AviumSystemUITools \
    MoonOCR \
    ExthmUseful \
    MoonWidget \
    CatShareForAvium \
    Via \
    AviumSetup \
    AviumLockscreenEdit \
    AviumSystemUIEX \
    BtHelper \
    OmniJaws \
    Note \
    PocketMode \
    DepthWallpaperHelper

# TODO: Need GameSpace

# Updater
ifeq ($(AVIUM_IS_OFFICIAL),true)
PRODUCT_PACKAGES += \
    Updater

PRODUCT_COPY_FILES += \
     vendor/avium/prebuilt/common/etc/init/init.avium-updater.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.avium-updater.rc
endif

# DepthWallpaperHelper
PRODUCT_COPY_FILES += \
    vendor/avium/prebuilt/media/wallpaper/mask:$(TARGET_COPY_OUT_SYSTEM_EXT)/media/wallpaper/mask \
    vendor/avium/prebuilt/media/wallpaper/wallpaper:$(TARGET_COPY_OUT_SYSTEM_EXT)/media/wallpaper/wallpaper

PRODUCT_SYSTEM_EXT_PROPERTIES += persist.avium.depthwallpaper=0

# ParanoidSense
TARGET_FACE_UNLOCK_SUPPORTED ?= $(TARGET_SUPPORTS_64_BIT_APPS)
ifeq ($(TARGET_ARCH),arm64)
ifeq ($(TARGET_FACE_UNLOCK_SUPPORTED),true)
PRODUCT_PACKAGES += \
    ParanoidSense

PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.face.sense_service=true

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.biometrics.face.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.biometrics.face.xml
endif
endif

