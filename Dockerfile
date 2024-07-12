FROM --platform=linux/amd64 debian:stable-slim

ARG operator_version=0.6.2
ARG operator_hash=8ac7e9d271b08cbc8fc840bc704f2172a8bf2aeb9af7cabe254dbf90acb440ff

SHELL ["/bin/bash", "-c"]

WORKDIR /opt

# Download Operator.
RUN \
  apt-get update \
    && apt-get -y install curl \
    && curl --location --silent https://github.com/mkantor/operator/releases/download/${operator_version}/operator-linux-x86-64.tar.gz \
      | tee operator.tar.gz \
      | sha256sum --check <(echo "${operator_hash}  -") \
    && apt-get -y purge curl \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && tar -xf operator.tar.gz \
    && rm operator.tar.gz

# Allow Operator to bind to port 80 even if it's not run by root.
RUN \
  apt-get update \
    && apt-get -y install libcap2-bin \
    && setcap 'cap_net_bind_service=+ep' ./operator \
    && apt-get -y purge libcap2-bin \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install languages needed for executables.
RUN \
  apt-get update \
    && apt-get -y install nodejs python3 \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd --system www && useradd --no-log-init --system --gid www www

USER www

COPY --chown=www:www ./content /var/www

EXPOSE 80

ENTRYPOINT ["./operator", "serve", "--content-directory=/var/www", "--bind-to=0.0.0.0:80"]
