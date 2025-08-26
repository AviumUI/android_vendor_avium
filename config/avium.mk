# AviumUI configuration file

# Build 
AVIUM_BUILDTYPE ?= Unoffical
AVIUM_VERSION_APPEND_TIME_OF_DAY ?= false

# Maintainer
AVIUM_MAINTAINER ?= Unknown
PRODUCT_SYSTEM_PROPERTIES += ro.avium.maintainer=$(AVIUM_MAINTAINER)

# LatinIMEGooglePrebuilt
TARGET_INCLUDE_GOOGLEIME ?= false
TARGET_GOOGLEIME_OVERRIDE_IME ?= false 

# Include configs
$(call inherit-product, vendor/avium/config/packages.mk)
$(call inherit-product, vendor/avium/config/overlay.mk)
$(call inherit-product, vendor/avium/config/version.mk)
$(call inherit-product, vendor/avium/config/sepolicy.mk)
