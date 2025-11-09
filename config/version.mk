# Avium Version
AVIUM_VER := AviumUI-$(PLATFORM_VERSION)-$(LINEAGE_BUILD)

# Date format
ifeq ($(AVIUM_VERSION_APPEND_TIME_OF_DAY),true)
    AVIUM_BUILD_DATE := $(shell date -u +%Y%m%d_%H%M%S)
else
    AVIUM_BUILD_DATE := $(shell date -u +%Y%m%d)
endif

# Display version
AVIUM_DISPLAY_VERSION := $(AVIUM_VER)

# Because some devices have 'mtdoops.fingerprint' in cmdline.
# Some device tree use LINEAGE_VERSION as default value.
AVIUM_VERSION := $(AVIUM_VER)-$(AVIUM_BUILD_DATE)-$(AVIUM_BUILDTYPE)
LINEAGE_VERSION := $(AVIUM_VERSION)

# Package name
ifeq ($(AVIUM_BUILDTYPE),Official)
    AVIUM_PACKAGE_NAME := AviumUI-$(PLATFORM_VERSION)-$(LINEAGE_BUILD)-$(AVIUM_BUILD_DATE)-Official
else
    AVIUM_PACKAGE_NAME := AviumUI-$(PLATFORM_VERSION)-$(LINEAGE_BUILD)-$(AVIUM_BUILD_DATE)-Unofficial
endif

# GMS Status
ifeq ($(WITH_GMS), true)
    AVIUM_VERSION := $(AVIUM_VERSION)-GMS
    AVIUM_PACKAGE_NAME := $(AVIUM_PACKAGE_NAME)-GMS
else
    AVIUM_VERSION := $(AVIUM_VERSION)-Vanilla
    AVIUM_PACKAGE_NAME := $(AVIUM_PACKAGE_NAME)-Vanilla
endif

# AviumUI version properties
PRODUCT_SYSTEM_PROPERTIES += \
    ro.avium.version=$(AVIUM_VER) \
    ro.avium.display.version=$(AVIUM_DISPLAY_VERSION) \
    ro.avium.build.version=$(PLATFORM_VERSION) \
    ro.avium.releasetype=$(AVIUM_BUILDTYPE) \
    ro.avium.gms_status=$(WITH_GMS)