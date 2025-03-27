FROM ghcr.io/ijikeman/qmk_cli:latest
ARG VERSION_QMK_FIRMWARE=0.28.0

RUN apt-get update && apt-get install -y \
    # for exec qmk_install.sh
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Install Python libraries
RUN pip install qmk

# Clone qmk_firmware repository
RUN git clone --depth 1 -b ${VERSION_QMK_FIRMWARE} --recursive https://github.com/qmk/qmk_firmware.git /qmk_firmware
WORKDIR /qmk_firmware

# Exec qmk setup
RUN qmk setup -y --yes

# Exec qmk_install.sh
RUN sudo bash util/qmk_install.sh

# Install Python libraries for qmk compile 
RUN pip install -r requirements.txt

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
