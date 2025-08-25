# AviumUI configuration file

# Build 
AVIUM_BUILDTYPE ?= Unoffical
AVIUM_VERSION_APPEND_TIME_OF_DAY ?= false

# LatinIMEGooglePrebuilt
TARGET_INCLUDE_GOOGLEIME ?= false
TARGET_GOOGLEIME_OVERRIDE_IME ?= false 

# Include configs
$(call inherit-product, vendor/avium/config/packages.mk)
$(call inherit-product, vendor/avium/config/overlay.mk)
$(call inherit-product, vendor/avium/config/version.mk)