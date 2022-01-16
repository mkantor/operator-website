FROM --platform=linux/amd64 debian:stable-slim

ARG operator_version=0.5.0
ARG operator_hash=2a867fa0dfb37e8ccab8314d8cecfd491f238263ec23a8e0a04d967edd28bd5b

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
