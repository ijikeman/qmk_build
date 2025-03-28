#!/bin/bash

# Clone QMK repository
# もし$qmk_firmware_versionが'latest'でなければ、qmk_firmware.gitを再取得してセットアップする
if [ "$qmk_firmware_version" != "latest" ]; then
    echo "::group::Clone QMK repository"
    rm -rf /qmk_firmware
    qmk setup -y -b ${qmk_firmware_version} -H /qmk_firmware
    echo "::endgroup::"

    # Install compile packages
    echo "::group::Install compile packages"
    cd /qmk_firmware
    bash util/qmk_install.sh
    echo "::endgroup::"
fi

# Copy keyboard files from workspace
if [ -d "$GITHUB_WORKSPACE/keyboards/${keyboard}" ]; then
    echo "::group::Replacing '/qmk_firmware/keyboards/${keyboard}' from workspace"
    rm -rf /qmk_firmware/keyboards/${keyboard}
    cp -Rp "$GITHUB_WORKSPACE/keyboards/${keyboard}" "/qmk_firmware/keyboards/"
    echo "::endgroup::"
fi

# Compile firmware
echo "::group::Compiling firmware"
qmk compile -kb "${keyboard}/${rev}" -km "${keymap}"
echo "::endgroup::"

# Find compiled .hex file
output_file=$(find . -maxdepth 1 -name "${keyboard}*.hex" | head -n 1)

# Save compiled .hex file
if [ -f "$output_file" ]; then
    echo "::group::Saving firmware"
    echo "Firmware compiled: $output_file"
    mkdir -p "$GITHUB_WORKSPACE/output"
    cp "$output_file" "$GITHUB_WORKSPACE/output/"
    echo "::endgroup::"
else
    echo "::error::Failed to find compiled .hex file"
    exit 1
fi
