#!/bin/bash

# Copy keyboard files from workspace
echo "::group::Copying keyboard files from workspace"
if [[ -z "keyboards/$keyboard" ]]; then
    echo "::error::Missing required input 'keyboard'"
    exit 1
else
    rm -rf keyboards/$keyboard
    cp -r "$GITHUB_WORKSPACE/keyboards/$keyboard" "keyboards/$keyboard"
echo "::endgroup::"

# Compile firmware
echo "::group::Compiling firmware"
qmk compile -kb "$keyboard/$rev" -km "$keymap"
echo "::endgroup::"

# Find compiled .hex file
output_file=$(find . -maxdepth 1 -name "*.hex" | head -n 1)

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
