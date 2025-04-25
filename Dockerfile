FROM debian:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y wget gnupg2 && \
    wget https://developer.download.nvidia.com/compute/cuda/repos/debian11/x86_64/cuda-keyring_1.0-1_all.deb && \
    dpkg -i cuda-keyring_1.0-1_all.deb && \
    apt-get update && apt-get install -y \
    cuda-toolkit-11-8

RUN apt-get update && apt-get install -y \
    wget \
    liburcu-dev \
    sysstat \
    dos2unix \
    python3 \
    python3-pip \
    lm-sensors \
    smartmontools \
    zenity \
    pandoc \
    curl \
    net-tools \
    iproute2 \
    x11-utils \
    lshw \
    xdg-utils \
    chromium \
    mesa-utils \
    bc \
    rocm-smi \
    && rm -rf /var/lib/apt/lists/*

COPY generate_md_report.py /usr/local/bin/generate_md_report.py

RUN chmod +x /usr/local/bin/generate_md_report.py

COPY monitor.sh /usr/local/bin/monitor.sh

RUN dos2unix /usr/local/bin/monitor.sh

RUN chmod +x /usr/local/bin/monitor.sh

WORKDIR /app

CMD ["/usr/local/bin/monitor.sh"]
