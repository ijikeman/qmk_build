FROM ghcr.io/ijikeman/qmk_cli:latest
ARG VERSION_QMK=1.1.6

RUN apt-get update && apt-get install -y \
    # for exec qmk_install.sh
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Install Python libraries
RUN pip install qmk==${VERSION_QMK}

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
