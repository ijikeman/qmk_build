# QMK Firmware Build Action

GitHub Action to build keyboard firmware using QMK Firmware. Automatically replaces `/keyboards/${keyboard}` from your repository if provided.

## Latest Version

- **v0.0.1**

## Default QMK Firmware Version

- **0.28.0**

---

## Inputs

| Name                    | Description                                                                                                              | Required |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------ | -------- |
| `qmk_firmware_version`  | Specify QMK Firmware version if you want to use a different version than the default. **Optional**.<br>**Note:** Specifying this parameter will rebuild the build environment and increase the execution time. It's recommended to leave this parameter unset. | No |
| `keyboard`              | Keyboard name (`qmk_firmware/keyboards/${keyboard}`). Used by `qmk compile`.                                             | Yes      |
| `rev`                   | Revision name (`qmk_firmware/keyboards/${keyboard}/${rev}`). Used by `qmk compile`.                                      | Yes      |
| `keymap`                | Keymap name (`qmk_firmware/keyboards/${keyboard}/keymaps/${keymap}`). Used by `qmk compile`.                             | No(default)       |

---

## Directory Structure Example

```
./
  .github/workflows/
    - main.yml
  keyboards/plunck/
    - (etc: keymaps/original_keymap)
    - (etc: rev1/)
    - (etc: rules.mk)
```

---

## Usage Example (`.github/workflows/main.yml`)

```yaml
name: Sample QMK Firmware Build Action

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: QMK Build firmware Action
        uses: ijikeman/qmk_build@v0.0.1
        with:
          keyboard: 'plunck'
          rev: 'rev1'
          keymap: 'default'

      - name: Upload artifact
        uses: actions/upload-artifact@v4
        with:
          name: firmware
          path: ${{ github.workspace }}/output/*.hex
```

---

# QMKファームウェアビルドアクション

QMKファームウェアを利用してキーボードのファームウェアをビルドするためのGitHubアクションです。ご自身のリポジトリに`/keyboards/${keyboard}`がある場合、自動的に置き換えてビルドを実行します。

## 最新バージョン

- **v0.0.1**

## デフォルトのQMKファームウェアバージョン

- **0.28.0**

---

## パラメータ

| 名前                    | 説明                                                                                                                     | 必須     |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------ | -------- |
| `qmk_firmware_version`  | デフォルトのバージョンと異なるQMKファームウェアのバージョンを指定します。任意指定。<br>**注意：** ビルド環境の再構築を行うため、実行時間が長くなります。通常は指定しないことを推奨します。 | いいえ |
| `keyboard`              | キーボード名 (`qmk_firmware/keyboards/${keyboard}`)。`qmk compile`時に指定します。                                      | はい     |
| `rev`                   | リビジョン名 (`qmk_firmware/keyboards/${keyboard}/${rev}`)。`qmk compile`時に指定します。                                | はい     |
| `keymap`                | キーマップ名 (`qmk_firmware/keyboards/${keyboard}/keymaps/${keymap}`)。`qmk compile`時に指定します。                     | いいえ(default)   |

---

## ディレクトリ構成例

```
./
  .github/workflows/
    - main.yml
  keyboards/plunck/
    - (etc: keymaps/original_keymap)
    - (etc: rev1/)
    - (etc: rules.mk)
```

---

## 使用例 (`.github/workflows/main.yml`)

```yaml
name: Sample QMK Firmware Build Action

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: QMK Build firmware Action
        uses: ijikeman/qmk_build@v0.0.1
        with:
          keyboard: 'plunck'
          rev: 'rev1'
          keymap: 'default'

      - name: Upload artifact
        uses: actions/upload-artifact@v4
        with:
          name: firmware
          path: ${{ github.workspace }}/output/*.hex
```
