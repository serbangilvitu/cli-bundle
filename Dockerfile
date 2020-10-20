FROM docker.io/debian:10.6-slim

RUN groupadd -r cli && \
  useradd -r -s /bin/bash -g cli cli
COPY setup-tools.sh /opt
RUN bash /opt/setup-tools.sh

WORKDIR /home/cli

USER cli