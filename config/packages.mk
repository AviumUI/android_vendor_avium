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

# AviumUI extra packages configuration

# LatinIMEGoogle
ifneq ($(WITH_GMS), true)
ifeq ($(TARGET_INCLUDE_GOOGLEIME), true)
    ifeq ($(TARGET_GOOGLEIME_OVERRIDE_IME), true)
        PRODUCT_PACKAGES += \
            LatinIMEGooglePrebuilt_Override
    else
        PRODUCT_PACKAGES += \
            LatinIMEGooglePrebuiltAvium
    endif
endif # TARGET_INCLUDE_GOOGLEIME
endif # WITH_GMS

# AviumUI Apps
PRODUCT_PACKAGES += \
    FeatureSettings \
    AviumSystemUITools \
    MoonOCR \
    AviumUseful \
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
    DepthWallpaperHelper \
    AviumFreeWindow \
    AviumLyricBarCore

# TODO: Need GameSpace

# Updater
ifeq ($(AVIUM_IS_OFFICIAL),true)
PRODUCT_PACKAGES += \
    Updater

PRODUCT_COPY_FILES += \
     vendor/avium/prebuilt/common/etc/init/init.avium-updater.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.avium-updater.rc
endif

# App Clone Support
PRODUCT_COPY_FILES += \
    vendor/avium/prebuilt/common/etc/sysconfig/preinstalled-packages-platform-avium-product.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/preinstalled-packages-platform-avium-product.xml

# DepthWallpaperHelper
PRODUCT_COPY_FILES += \
    vendor/avium/prebuilt/media/wallpaper/mask:$(TARGET_COPY_OUT_SYSTEM_EXT)/media/wallpaper/mask \
    vendor/avium/prebuilt/media/wallpaper/wallpaper:$(TARGET_COPY_OUT_SYSTEM_EXT)/media/wallpaper/wallpaper

PRODUCT_SYSTEM_EXT_PROPERTIES += persist.avium.depthwallpaper=0

# ParanoidSense
TARGET_FACE_UNLOCK_SUPPORTED ?= $(TARGET_SUPPORTS_64_BIT_APPS)

ifeq ($(TARGET_FACE_UNLOCK_SUPPORTED),true)
PRODUCT_PACKAGES += \
    ParanoidSense

PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.face.sense_service=true

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.biometrics.face.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/android.hardware.biometrics.face.xml
endif

