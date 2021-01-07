FROM debian:stable-slim

ARG operator_version=0.1.2
ARG operator_hash=6f1fe37a11e28f55c2c7ccc9844c9b6c692e9cb33ff73a3c938ed57f706d8ba1

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
