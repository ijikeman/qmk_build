FROM ghcr.io/ijikeman/qmk_cli:latest

ARG VERSION_QMK
ARG VERSION_QMK_FIRMWARE

RUN apt-get update && apt-get install -y \
    # for exec qmk_install.sh
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Install Python libraries
RUN pip install qmk==${VERSION_QMK}

# Clone qmk_firmware.git
RUN qmk setup -y -b ${VERSION_QMK_FIRMWARE} -H /qmk_firmware

# Install compile packages
WORKDIR /qmk_firmware/
RUN bash util/qmk_install.sh

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
