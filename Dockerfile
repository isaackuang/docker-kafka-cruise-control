FROM openjdk:11-jdk-slim

ENV S6_OVERLAY_VERSION="3.1.1.2"

RUN apt update && \
    apt install -y git wget xz-utils

RUN cd /tmp && \
    wget https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz && \
    tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz && \
    wget https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-$(uname -m).tar.xz && \
    tar -C / -Jxpf /tmp/s6-overlay-$(uname -m).tar.xz

ENTRYPOINT [ "/init" ]

COPY config /

RUN cd /opt && \
    git clone https://github.com/linkedin/cruise-control.git && \
    cd cruise-control && \
    ./gradlew jar copyDependantLibs

RUN cd /opt && \
    wget https://github.com/linkedin/cruise-control-ui/releases/download/v0.4.0/cruise-control-ui-0.4.0.tar.gz && \
    tar zxvf cruise-control-ui-0.4.0.tar.gz && \
    rm -rf /opt/cruise-control-ui-0.4.0.tar.gz && \
    mv cruise-control-ui /opt/cruise-control && \
    echo "dev,dev,/kafkacruisecontrol" > /opt/cruise-control/cruise-control-ui/dist/static/config.csv

    