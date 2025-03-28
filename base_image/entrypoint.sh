#!/bin/bash
WORKDIR='/qmk_firmware/'

# Clone QMK repository
# もし$qmk_firmware_versionが'latest'でなければ、qmk_firmware.gitを再取得してセットアップする
if [ "$qmk_firmware_version" != "latest" ]; then
    echo "::group::Clone QMK repository"
    rm -rf ${WORKDIR}
    qmk setup -y -b ${qmk_firmware_version} -H ${WORKDIR}
    echo "::endgroup::"

    # Install compile packages
    echo "::group::Install compile packages"
    cd ${WORKDIR}
    bash util/qmk_install.sh
    echo "::endgroup::"
fi

if [ -d "${GITHUB_WORKSPACE}/keyboards/${keyboard}" ]; then
    echo "::group::Replacing '${WORKDIR}keyboards/${keyboard}' from workspace"
    rm -rf ${WORKDIR}keyboards/${keyboard}
    cp -Rp "${GITHUB_WORKSPACE}/keyboards/${keyboard}" "${WORKDIR}keyboards/"
    echo "::endgroup::"
fi

# Compile firmware
echo "::group::Compiling firmware"
qmk compile -kb "${keyboard}/${rev}" -km "${keymap}"
echo "::endgroup::"

# Find compiled .hex file
output_file=$(find ${WORKDIR} -maxdepth 1 -name "${keyboard}*.hex" | head -n 1)

# Save compiled .hex file
if [ -f "$output_file" ]; then
    echo "::group::Saving firmware"
    echo "Firmware compiled: $output_file"
    mkdir -p "${GITHUB_WORKSPACE}/output"
    cp "$output_file" "${GITHUB_WORKSPACE}/output/"
    echo "::endgroup::"
else
    echo "::error::Failed to find compiled .hex file"
    exit 1
fi
