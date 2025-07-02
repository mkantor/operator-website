FROM --platform=linux/amd64 debian:bookworm-slim

ARG operator_version=0.6.5
ARG operator_hash=68b8f0a7c1e53f34d62e4c4b4d188fcd56aad481769bba46d8fdc3b5367590b5

SHELL ["/bin/bash", "-c"]

WORKDIR /opt

# Download Operator.
RUN <<EOF
  apt-get update
  apt-get -y install curl
  curl --location --silent https://github.com/mkantor/operator/releases/download/${operator_version}/operator-linux-x86-64.tar.gz \
    | tee operator.tar.gz \
    | sha256sum --check <(echo "${operator_hash}  -")
  apt-get -y purge curl
  apt-get -y autoremove
  apt-get clean
  rm -rf /var/lib/apt/lists/*
  tar -xf operator.tar.gz
  rm operator.tar.gz
EOF

# Allow Operator to bind to port 80 even if it's not run by root.
RUN <<EOF
  apt-get update
  apt-get -y install libcap2-bin
  setcap 'cap_net_bind_service=+ep' ./operator
  apt-get -y purge libcap2-bin
  apt-get -y autoremove
  apt-get clean
  rm -rf /var/lib/apt/lists/*
EOF

# Install languages needed for executables.
RUN <<EOF
  apt-get update
  apt-get -y install nodejs python3
  apt-get -y autoremove
  apt-get clean
  rm -rf /var/lib/apt/lists/*
EOF

RUN groupadd --system www && useradd --no-log-init --system --gid www www

USER www

COPY --chown=www:www ./content /var/www

EXPOSE 80

ENTRYPOINT ["./operator", "serve", "--content-directory=/var/www", "--bind-to=0.0.0.0:80"]
