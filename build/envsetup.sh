TOP=$(gettop)
function get_gms() {
    if [ -z "$GMS_URL" ]; then
        GMS_URL="https://github.com/AviumUI/proprietary_vendor_google_gms"
    fi

    if ! [ -n "$TOP" ];then
        echo "Couldn't locate the top of the tree.  Try setting TOP."
        return 1
        exit 1
    fi
    mkdir -p "$TOP/.repo/local_manifests"
    https_code=$(curl -s -o /dev/null -w "%{http_code}\n" $GMS_URL)
    
    if ! [ $https_code -eq 200 ]; then
        echo "Error: Unable to access $GMS_URL"
        echo
        echo "Please check your network connection and URL."
        echo "HTTP response code: $https_code"
        echo "You can set the GMS_URL environment variable to use a different mirror."
        echo "For example: export GMS_URL=https://github.com/AviumUI/proprietary_vendor_google_gms"
        echo "If you are behind a proxy, please configure your proxy settings."
        echo "Skipping GMS download."
        echo
        echo "You can run 'avium get_gms' again after fixing the issue."
        return 1
        exit 1
    fi
    repo_sync_gms
    echo "GMS files downloaded. You can run 'avium remove_gms' to delete them."

}

function repo_sync_gms() {
cat >> "$TOP/.repo/avium_gms.xml" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
    <remote name="avium-gmsurl" fetch="$GMS_URL" />
  <project path="vendor/google/gms" name="proprietary_vendor_google_gms" remote="avium-gmsurl" />
</manifest>
EOF
mv "$TOP/.repo/avium_gms.xml" "$TOP/.repo/local_manifests/avium_gms.xml"
repo sync --force-sync --force-checkout vendor/google/gms
}

function remove_gms() {
    if ! [ -n "$TOP" ];then
        echo "Couldn't locate the top of the tree.  Try setting TOP."
        return 1
        exit 1
    fi
    rm -rf "$TOP/.repo/local_manifests/avium_gms.xml"
    rm -rf "$TOP/vendor/google/gms"
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