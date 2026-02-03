# 
# Copyright (C) 2025 The AviumUI Project
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#      http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Enable blur if maintainer asked
ifeq ($(TARGET_ENABLE_BLUR), true)
PRODUCT_PRODUCT_PROPERTIES += ro.surface_flinger.supports_background_blur=1
endif # TARGET_ENABLE_BLUR

PRODUCT_BUILD_PROP_OVERRIDES += \
   AviumSocName="$(AVIUM_SETTINGS_SOC_MODEL_NAME)" \
   AviumDeviceName="$(AVIUM_SETTINGS_DEVICE_CODENAME)"

# Hide SystemApp Notifications
AVIUM_HIDE_SYSAPP_NOTIFS := org.avium.systemuiex,com.sunshine.freeform,org.exthm.exthmuseful,org.avium.alivenotifscore
PRODUCT_SYSTEM_EXT_PROPERTIES += persist.avium.hide_sysapp_notifs=$(AVIUM_HIDE_SYSAPP_NOTIFS)
   
# Popup View
PRODUCT_SYSTEM_EXT_PROPERTIES += persist.avium.popup_view=bubble