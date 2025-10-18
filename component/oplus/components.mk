#
# SPDX-FileCopyrightText: 2025 The AviumUI Project
# SPDX-License-Identifier: Apache-2.0
#

OPLUS_COMMON_PATH := vendor/avium/component/oplus

ifeq ($(TARGET_COMMON_OPLUS_COMPONENTS), all)
TARGET_COMMON_OPLUS_COMPONENTS := \
    ConsumerIRApp \
    $(filter-out all,$(TARGET_COMMON_OPLUS_COMPONENTS))
endif

ifneq ($(filter ConsumerIRApp, $(TARGET_COMMON_OPLUS_COMPONENTS)),)
include $(OPLUS_COMMON_PATH)/ConsumerIRApp/oplus-consumerirapp.mk
endif
