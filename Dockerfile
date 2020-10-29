FROM debian:stable-slim

ARG operator_version=0.0.3
ARG operator_hash=04c95cfd90252ed993edf2bce04de54ef249d55b489239576b2415d64b9f6401

SHELL ["/bin/bash", "-c"]

WORKDIR /opt

# Download Operator.
RUN \
  apt-get update \
    && apt-get -y install curl \
    && curl --location --silent https://github.com/mkantor/operator/releases/download/${operator_version}/operator-linux.tar.gz \
      | tee operator.tar.gz \
      | sha256sum --check <(echo "${operator_hash}  -") \
    && apt-get -y purge curl \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN tar -xf operator.tar.gz && rm operator.tar.gz

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
