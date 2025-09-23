# AviumUI GMS configuration file

GMS_DIR := vendor/gms
GMS_CORE_CONFIG := $(GMS_DIR)/gms_core.mk
GMS_FULL_CONFIG := $(GMS_DIR)/gms_full.mk

ifeq ($(WITH_GMS),true)
TARGET_INCLUDE_GOOGLEIME := true
TARGET_GOOGLEIME_OVERRIDE_IME := true
ifeq ($(wildcard $(GMS_FULL_CONFIG)),)
$(warning GMS Config not found, disabling GMS, you can run 'avium get_gms' to download the GMS")
WITH_GMS := false
else
ifeq ($(GMS_TYPE),FULL)
$(call inherit-product, $(GMS_FULL_CONFIG))
else ifeq ($(GMS_TYPE),CORE)
$(call inherit-product, $(GMS_CORE_CONFIG))
else
$(warning GMS_TYPE is not set to FULL or CORE, defaulting to CORE)
$(call inherit-product, $(GMS_CORE_CONFIG))
endif
endif
endif