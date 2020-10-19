FROM docker.io/debian:10.6-slim
COPY setup-tools.sh /opt
WORKDIR /opt
RUN bash setup-tools.sh