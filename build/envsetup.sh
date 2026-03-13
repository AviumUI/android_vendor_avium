# 
# Copyright (C) 2025-2026 The AviumUI Project
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

TOP=$(gettop)

# Colors
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
RESET="\033[0m"

function get_gms() {
    if [ -z "$TOP" ]; then
        echo "Couldn't locate the top of the tree.  Try setting TOP."
        return 1
    fi

    local SRC_XML="$TOP/vendor/avium/manifest_snippets/pixel.xml"
    local DST_DIR="$TOP/.repo/local_manifests"
    local DST_XML="$DST_DIR/pixel.xml"

    if [ ! -f "$SRC_XML" ]; then
        echo -e "${RED}error:${RESET} source manifest not found:"
        echo "  $SRC_XML"
        return 1
    fi

    mkdir -p "$DST_DIR"

    local force_sync=0

    if [ -f "$DST_XML" ]; then
        if diff -q "$SRC_XML" "$DST_XML" >/dev/null; then
            echo -e "${GREEN}pixel.xml already up to date.${RESET}"
        else
            echo -e "${YELLOW}Local manifest differs from source:${RESET}"
            echo "  $DST_XML"
            echo
            force_sync=1

            if [ -t 0 ]; then
                echo -ne "${YELLOW}Overwrite with new pixel.xml? [y/N] ${RESET}"
                IFS= read -r answer
            else
                answer="n"
            fi

            case "$answer" in
                y|Y)
                    cp "$SRC_XML" "$DST_XML"
                    echo -e "${GREEN}pixel.xml updated.${RESET}"
                    ;;
                *)
                    echo -e "${BLUE}Keeping existing pixel.xml.${RESET}"
                    ;;
            esac
        fi
    else
        cp "$SRC_XML" "$DST_XML"
        echo -e "${GREEN}pixel.xml installed into local_manifests.${RESET}"
    fi

    echo

    if [ -t 0 ]; then
        echo -ne "${YELLOW}Sync GMS repositories now? [y/N] ${RESET}"
        IFS= read -r sync_answer
    else
        sync_answer="n"
    fi

    case "$sync_answer" in
        y|Y)
            echo
            echo -e "${BLUE}Executing repo sync command...${RESET}"
            echo

            repo sync \
                vendor/pixel/clocks \
                vendor/pixel/sounds \
                vendor/pixel/gms \
                vendor/pixel/gsans \
                -c -j5 \
                $( [ "$force_sync" -eq 1 ] && echo "--force-sync" )

            local sync_ret=$?

            echo
            if [ $sync_ret -eq 0 ]; then
                echo -e "${GREEN}repo sync finished.${RESET}"
		echo -e "${BLUE}Merging file parts...${RESET}"
		merge_files
            else
                echo -e "${RED}repo sync failed (exit code $sync_ret).${RESET}"
                return $sync_ret
            fi
            ;;
        *)
            echo -e "${BLUE}repo sync skipped.${RESET}"
            echo -e "${BLUE}You can run 'avium get_gms' to download GMS.${RESET}"
            ;;
    esac
}

function remove_gms() {
    if ! [ -n "$TOP" ];then
        echo "Couldn't locate the top of the tree.  Try setting TOP."
        return 1
        exit 1
    fi
    # Due to some historical reasons, some builders still remain old
    # method to download the gms.
    # TODO: Remove this when capable.
    rm -rf "$TOP/.repo/local_manifests/pixel.xml"
    rm -rf "$TOP/vendor/gms"
    echo "GMS files removed. You can run 'avium get_gms' to download them again."
}

function merge_file_parts() {
    target_file="$1"

    if [ -z "$target_file" ]; then
        echo -e "merge_file_parts(): ${RED}ERROR: merge_file_parts() requires a target file path.${RESET}" >&2
        return 1
    fi

    [ -f "$target_file" ] && return 0

    part_prefix="$target_file"
    found_part=0

    for part in "${part_prefix}".*.part; do
        [ -e "$part" ] || continue

        if [ "$found_part" -eq 0 ]; then
            : > "$target_file"
            found_part=1
        fi
        cat "$part" >> "$target_file"
    done

    [ "$found_part" -eq 0 ] && return 0

    if [ -s "$target_file" ]; then
        echo -e "merge_file_parts(): ${GREEN}Merged: $target_file${RESET}"
    fi
}

function avium_build() {
    local avium_device="$1"
    local avium_variant="$2"
    local avium_target="$3 $4 $5 $6 $7"

    if [ -z "$avium_device" ]; then
        echo -e "Usage: avium build <device> <variant> <target>"
        echo -e "       device  - Device codename (e.g., thyme)"
        echo -e "       variant - Build variant (user, userdebug, eng)"
        echo -e "       target  - Build target (default: bacon)"
        echo -e
        echo -e "<target> options:"
        echo -e "  bacon            - Build the ROM (default)"
        echo -e "  fastbootpackage  - Build the Fastboot package(Use fastboot update <file> to flash)"
        echo -e "  recoveryimage    - Build only recovery image(if available)"
        echo -e "  bootimage        - Build only boot image"
        return 1
        exit 1
    fi
    if [ -z "$avium_target" ]; then
        echo "No build target specified. Defaulting to 'bacon'."
        avium_target="bacon"
    fi
    if [ -z "$avium_variant" ]; then
        echo "No build variant specified. Defaulting to 'userdebug'."
        avium_variant="userdebug"
    fi
    if ! [ -n "$TOP" ];then
        echo "Couldn't locate the top of the tree.  Try setting TOP."
        return 1
        exit 1
    fi
    source ${ANDROID_BUILD_TOP}/vendor/lineage/vars/aosp_target_release
    lunch lineage_$avium_device-$aosp_target_release-$avium_variant
    if ! [ $? -eq 0 ]; then
        echo "ERROR: Unable to locate device configuration for $avium_device" 
        echo "       Please ensure the device codename is correct and the device tree is present."
        return 1
        exit 1
    fi
    mka $avium_target -j$(nproc --all)
}

function gen_keys() {
    if ! [ -n "$TOP" ];then
        echo "Couldn't locate the top of the tree.  Try setting TOP."
        return 1
        exit 1
    fi
    local subject='/C=US/ST=California/L=Mountain View/O=Android/OU=Android/CN=Android/emailAddress=android@android.com'
    mkdir ~/.avium-certs
    for cert in bluetooth cyngn-app media networkstack nfc platform releasekey sdk_sandbox shared testcert testkey verity; do
    ./development/tools/make_key ~/.avium-certs/$cert "$subject"; \
    done
    cp ./development/tools/make_key ~/.avium-certs/
    sed -i 's|2048|4096|g' ~/.avium-certs/make_key
    for apex in com.android.adbd com.android.adservices com.android.adservices.api com.android.appsearch com.android.appsearch.apk com.android.art com.android.bluetooth com.android.btservices com.android.cellbroadcast com.android.compos com.android.configinfrastructure com.android.connectivity.resources com.android.conscrypt com.android.devicelock com.android.extservices com.android.graphics.pdf com.android.hardware.authsecret com.android.hardware.biometrics.face.virtual com.android.hardware.biometrics.fingerprint.virtual com.android.hardware.boot com.android.hardware.cas com.android.hardware.neuralnetworks com.android.hardware.rebootescrow com.android.hardware.wifi com.android.healthfitness com.android.hotspot2.osulogin com.android.i18n com.android.ipsec com.android.media com.android.media.swcodec com.android.mediaprovider com.android.nearby.halfsheet com.android.networkstack.tethering com.android.neuralnetworks com.android.nfcservices com.android.ondevicepersonalization com.android.os.statsd com.android.permission com.android.profiling com.android.resolv com.android.rkpd com.android.runtime com.android.safetycenter.resources com.android.scheduling com.android.sdkext com.android.support.apexer com.android.telephony com.android.telephonymodules com.android.tethering com.android.tzdata com.android.uwb com.android.uwb.resources com.android.virt com.android.vndk.current com.android.vndk.current.on_vendor com.android.wifi com.android.wifi.dialog com.android.wifi.resources com.google.pixel.camera.hal com.google.pixel.vibrator.hal com.qorvo.uwb; do \
    subject='/C=US/ST=California/L=Mountain View/O=Android/OU=Android/CN='$apex'/emailAddress=android@android.com'
    ~/.avium-certs/make_key ~/.avium-certs/$apex "$subject"
    openssl pkcs8 -in ~/.avium-certs/$apex.pk8 -inform DER -nocrypt -out ~/.avium-certs/$apex.pem
    done
}

function avium() {
    local T=$(gettop)
    if [ -z "$T" ]; then
        echo "Couldn't locate the top of the tree.  Try setting TOP."
        return 1
        exit 1
    fi
    case "$1" in
        get_gms)
            get_gms
            ;;
        remove_gms)
            remove_gms
            ;;
        build)
            avium_build "$2" "$3" "$4" "$5" "$6" "$7" "$8"
            ;;
        *)
            echo "Usage: avium [build|get_gms|remove_gms]"
            echo "       build       - Build Avium for a specific device and variant"
            echo "       get_gms     - Download GMS files"
            echo "       remove_gms  - Remove GMS files"
            ;;
    esac
}

function merge_files() {
merge_file_parts "packages/apps/DepthWallpaperHelper/DepthWallpaperHelper.apk"
merge_file_parts "vendor/pixel/gms/common/proprietary/product/app/Maps/Maps.apk"
merge_file_parts "vendor/pixel/gms/common/proprietary/product/app/Photos/Photos.apk"
merge_file_parts "vendor/pixel/gms/common/proprietary/product/app/PrebuiltGmail/PrebuiltGmail.apk"
merge_file_parts "vendor/pixel/gms/common/proprietary/product/priv-app/DevicePersonalizationPrebuiltPixel2024-playstore_aiai_20250306.00_RC10/DevicePersonalizationPrebuiltPixel2024-playstore_aiai_20250306.00_RC10.apk"
merge_file_parts "vendor/pixel/gms/common/proprietary/product/priv-app/PrebuiltBugle/PrebuiltBugle.apk"
merge_file_parts "vendor/pixel/gms/common/proprietary/product/priv-app/PrebuiltGmsCoreVic/PrebuiltGmsCoreVic.apk"
merge_file_parts "vendor/pixel/gms/common/proprietary/product/priv-app/Velvet/Velvet.apk"
}

merge_files
