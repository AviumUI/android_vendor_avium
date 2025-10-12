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
    AviumLockscreenEdit
# TODO: Need GameSpace

# Updater
ifeq ($(AVIUM_BUILDTYPE),Official)
PRODUCT_PACKAGES += \
    Updater

PRODUCT_COPY_FILES += \
     vendor/avium/prebuilt/common/etc/init/init.avium-updater.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.avium-updater.rc
endif