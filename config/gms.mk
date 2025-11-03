#
# SPDX-FileCopyrightText: 2025 The AviumUI Project
# SPDX-License-Identifier: Apache-2.0
#

GMS_DIR := vendor/gms

# Set as no gms by default
WITH_GMS ?= false

# Override AOSP IME if using gms
ifeq ($(WITH_GMS),true)
TARGET_INCLUDE_GOOGLEIME := true
TARGET_GOOGLEIME_OVERRIDE_IME := true
endif

# Check if gms exists
ifeq ($(wildcard $(GMS_DIR)),)
$(warning Missing GMS in $(GMS_DIR))
$(warning You may want to run 'avium get_gms' to download gms source.)
endif

# Set gms type
GMS_MINI_CONFIG := $(GMS_DIR)/gms_mini.mk
GMS_PICO_CONFIG := $(GMS_DIR)/gms_pico.mk
GMS_FULL_CONFIG := $(GMS_DIR)/gms_full.mk

ifeq ($(WITH_GMS), true)
ifeq ($(TARGET_GMS_TYPE), FULL)
GMS_CONFIG := $(GMS_FULL_CONFIG)
else ifeq ($(TARGET_GMS_TYPE), PICO)
GMS_CONFIG := $(GMS_PICO_CONFIG)
else ifeq ($(TARGET_GMS_TYPE), MINI)
GMS_CONFIG := $(GMS_MINI_CONFIG)
else
$(warning TARGET_GMS_TYPE is not set correctly, defaulting to MINI)
GMS_CONFIG := $(GMS_MINI_CONFIG)
endif # TARGET_GMS_TYPE
endif # WITH_GMS

# Get non-opensource aspects
ifeq ($(WITH_GMS), true)
$(call inherit-product, $(GMS_CONFIG))
endif
