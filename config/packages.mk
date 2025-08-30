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
    Via
