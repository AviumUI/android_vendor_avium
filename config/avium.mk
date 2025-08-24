# AviumUI configuration file

# LatinIMEGooglePrebuilt
TARGET_INCLUDE_GOOGLEIME ?= false
TARGET_GOOGLEIME_OVERRIDE_IME ?= false 

# Include configs
$(call inherit-product, vendor/avium/config/packages.mk)
$(call inherit-product, vendor/avium/config/overlay.mk)