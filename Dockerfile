FROM ghcr.io/ijikeman/qmk_build:${qmk_firmware_version}

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
