# AviumUI configuration file

# Build 
AVIUM_BUILDTYPE ?= Unoffical
AVIUM_VERSION_APPEND_TIME_OF_DAY ?= false

# GMS
WITH_GMS ?= false
# GMS_TYPE has two options: FULL and CORE
# If WITH_GMS is true and GMS_TYPE is not set, it will default to CORE
GMS_TYPE ?= CORE

# Maintainer
AVIUM_MAINTAINER ?= Unknown
PRODUCT_SYSTEM_PROPERTIES += ro.avium.maintainer=$(AVIUM_MAINTAINER)

# LatinIMEGooglePrebuilt
# If WITH_GMS is true, TARGET_INCLUDE_GOOGLEIME and TARGET_GOOGLEIME_OVERRIDE_IME will be forced to true
TARGET_INCLUDE_GOOGLEIME ?= false
TARGET_GOOGLEIME_OVERRIDE_IME ?= false

# Include configs
$(call inherit-product, vendor/avium/config/packages.mk)
$(call inherit-product, vendor/avium/config/overlay.mk)
$(call inherit-product, vendor/avium/config/version.mk)
$(call inherit-product, vendor/avium/config/sepolicy.mk)
$(call inherit-product, vendor/avium/config/gms.mk)
