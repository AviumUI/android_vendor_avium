# Avium Version
AVIUM_VER := AviumUI-$(PLATFORM_VERSION)-$(LINEAGE_BUILD)

# Date format
ifeq ($(AVIUM_VERSION_APPEND_TIME_OF_DAY),true)
    AVIUM_BUILD_DATE := $(shell date -u +%Y%m%d_%H%M%S)
else
    AVIUM_BUILD_DATE := $(shell date -u +%Y%m%d)
endif

# Display version
AVIUM_DISPLAY_VERSION := AviumUI-$(LINEAGE_BUILD)-$(AVIUM_BUILD_DATE)

# Full version
# Because some devices have 'mtdoops.fingerprint' in cmdline.
# Some device tree use LINEAGE_VERSION as default value.
ifeq ($(AVIUM_IS_OFFICIAL),true)
    AVIUM_VERSION := $(AVIUM_VER)-$(AVIUM_BUILD_DATE)-Official
    LINEAGE_VERSION := AviumUI-Official-$(LINEAGE_BUILD)-$(AVIUM_BUILD_DATE)
else
    AVIUM_VERSION := $(AVIUM_VER)-$(AVIUM_BUILD_DATE)-Unofficial
    LINEAGE_VERSION := AviumUI-Unofficial-$(LINEAGE_BUILD)-$(AVIUM_BUILD_DATE)
endif

# Package name
ifeq ($(AVIUM_IS_OFFICIAL),true)
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
