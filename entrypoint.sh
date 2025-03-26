#!/bin/bash

# Update qmk_firmware repository
echo "::group::Cloning QMK firmware ($qmk_firmware_version)"
cd /qmk_firmware
git fetch
git checkout -b $qmk_firmware_version --depth 1 --recursive
echo "::endgroup::"

echo "::group::QMK setup"
qmk setup -y --yes
echo "::endgroup::"

# Exec qmk_install.sh
echo "::group::Exec qmk_install.sh"
sudo bash util/qmk_install.sh
echo "::endgroup::"

# Install requirements
echo "::group::Installing requirements"
pip install -r requirements.txt
echo "::endgroup::"

# Copy keyboard files from workspace
echo "::group::Copying keyboard files from workspace"
if [[ -z "$keyboard" ]]; then
    echo "::error::Missing required input 'keyboard'"
    exit 1
else
    rm -rf keyboards/$keyboard
    cp -r "$GITHUB_WORKSPACE/$keyboard" "keyboards/$keyboard"
echo "::endgroup::"

# Compile firmware
echo "::group::Compiling firmware"
qmk compile -kb "$keyboard/$rev" -km "$keymap"
echo "::endgroup::"

# Find compiled .hex file
output_file=$(find . -name "*.hex" | head -n 1)

# Save compiled .hex file
if [[ -f "$output_file" ]]; then
    echo "::group::Saving firmware"
    echo "Firmware compiled: $output_file"
    mkdir -p "$GITHUB_WORKSPACE/output"
    cp "$output_file" "$GITHUB_WORKSPACE/output/"
    echo "::endgroup::"
else
    echo "::error::Failed to find compiled .hex file"
    exit 1
fi
