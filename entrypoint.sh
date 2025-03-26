#!/bin/bash

# qmk_firmwareをクローン
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

# 必要なパッケージをインストール
echo "::group::Installing requirements"
pip install -r requirements.txt
echo "::endgroup::"

echo "::group::Copying keyboard files from workspace"
# 呼び出し元の keyboard ディレクトリをコピー（呼び出し元に keyboards/$keyboard がある前提）
rm -rf keyboards/$keyboard
cp -r "$GITHUB_WORKSPACE/$keyboard" "keyboards/$keyboard"
echo "::endgroup::"

echo "::group::Compiling firmware"
qmk compile -kb "$keyboard/$rev" -km "$keymap"
echo "::endgroup::"

# 出力ファイル確認と保存
output_file=$(find . -name "*.hex" | head -n 1)

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
