FROM golang:1-bookworm AS go-builder
# defined from build kit
# DOCKER_BUILDKIT=1 docker build . -t ...
ARG TARGETARCH

WORKDIR /yamlfmt
RUN go install github.com/google/yamlfmt/cmd/yamlfmt@latest && \
    strip $(which yamlfmt) && \
    yamlfmt --version

FROM rust:1-slim
ARG TARGETARCH

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    ripgrep \
    python3 \
    python3-pip \
    clang \
    git \
    valgrind \
    curl \
    protobuf-c-compiler \
    pkg-config \
    libssl-dev \
    gnupg2 \
    binutils \
    sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo "building platform $(uname -m)"

RUN useradd --create-home --shell /bin/bash rust
RUN usermod -a -G sudo rust
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

## Rust
ENV USER=rust
COPY --chown=${USER}:${USER} --from=go-builder /go/bin/yamlfmt /go/bin/yamlfmt
USER rust
ENV PATH=${PATH}:/go/bin

RUN rustup component add rustfmt
RUN rustup component add clippy
RUN rustup component add rust-analyzer
RUN rustc --version
RUN cargo --version

LABEL \
    org.label-schema.name="rust" \
    org.label-schema.description="Rust Development Container" \
    org.label-schema.url="https://github.com/jac18281828/rust" \
    org.label-schema.vcs-url="git@github.com:jac18281828/rust.git" \
    org.label-schema.vendor="jac18281828" \
    org.label-schema.version=$VERSION \
    org.label-schema.schema-version="1.0" \
    org.opencontainers.image.description="Rust Development Container for Visual Studio Code"
