TOP=$(gettop)
function get_gms() {

    # Default URL if user didn't set GMS_URL
    if [ -z "$GMS_URL" ]; then
        GMS_URL="https://codeberg.org/AviumUI/vendor_gms"
    fi

    # Default branch if user didn't set GMS_BRANCH
    if [ -z "$GMS_BRANCH" ]; then
        GMS_BRANCH="avium-16"
    fi

    local TARGET_BRANCH="$GMS_BRANCH"

    # Ensure TOP exists
    if ! [ -n "$TOP" ]; then
        echo "Couldn't locate the top of the tree. Try setting TOP."
        return 1
    fi

    echo "Checking GMS repository..."
    echo "URL: $GMS_URL"
    echo "Branch to check: $TARGET_BRANCH"
    echo

    echo -n "Checking repository / branch availability... "

    if ! output=$(git ls-remote --heads "$GMS_URL" "$TARGET_BRANCH" 2>/dev/null); then
        echo "FAILED"
        echo "Error: Unable to access $GMS_URL"
        echo
        echo "Please check your network connection and URL."
        echo "You can set GMS_URL to use a different mirror."
        echo "  export GMS_URL=https://codeberg.org/AviumUI/vendor_gms"
        echo "If you are behind a proxy, please check your proxy settings."
        echo
        echo "Skipping GMS download."
        echo
        echo "You can run 'avium get_gms' again after fixing the issue."
        return 1
    fi

    if [ -z "$output" ]; then
        echo "FAILED"
        echo "Error: Branch '$TARGET_BRANCH' does NOT exist on:"
        echo "  $GMS_URL"
        echo
        echo "To override the branch, set:"
        echo "  export GMS_BRANCH=<branch>"
        echo
        echo "Skipping GMS download."
        echo
        echo "You can run 'avium get_gms' again after fixing the issue."
        return 1
    fi

    echo "OK"
    echo

    git_sync_gms

    echo "GMS files downloaded. You can run 'avium remove_gms' to delete them."
    echo "To update, 'cd vendor/gms', then run 'git pull'"
}

function git_sync_gms() {
	git clone --depth=1 $GMS_URL $TOP/vendor/gms
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
    rm -rf "$TOP/.repo/local_manifests/avium_gms.xml"
    rm -rf "$TOP/vendor/gms"
    rm -rf "$TOP/.repo/project-objects/proprietary_vendor_gms.git"
    rm -rf "$TOP/.repo/projects/vendor/gms.git"
    rm -rf "$TOP/.repo/project-objects/proprietary_vendor_google_gms.git"
    rm -rf "$TOP/.repo/projects/vendor/google/gms.git"
    echo "GMS files removed. You can run 'get_gms' to download them again."
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
