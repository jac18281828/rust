FROM debian:stable-slim as builder
# defined from build kit
# DOCKER_BUILDKIT=1 docker build . -t ...
ARG TARGETARCH

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt update && \
    apt install -y -q --no-install-recommends \
    git curl gnupg2 build-essential \
    linux-headers-${TARGETARCH} libc6-dev \ 
    openssl libssl-dev pkg-config \
    ca-certificates apt-transport-https \
    python3 && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

RUN useradd --create-home -s /bin/bash jac
RUN usermod -a -G sudo jac
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

WORKDIR /rustup
## Rust
ADD https://sh.rustup.rs /rustup/rustup.sh
RUN chmod 755 /rustup/rustup.sh

ENV USER=jac
USER jac
RUN /rustup/rustup.sh -y --default-toolchain stable --profile minimal

ENV PATH=$PATH:~jac/.cargo/bin

FROM debian:stable-slim
ARG TARGETARCH

RUN export DEBIAN_FRONTEND=noninteractive && \
  apt update && \
  apt install -y -q --no-install-recommends \
    ca-certificates apt-transport-https \
    sudo ripgrep procps build-essential \
    python3 python3-pip python3-dev \
    git valgrind curl \
    pkg-config openssl libssl-dev && \
  apt clean && \
  rm -rf /var/lib/apt/lists/*

RUN echo "building platform $(uname -m)"

RUN useradd --create-home -s /bin/bash jac
RUN usermod -a -G sudo jac
RUN echo '%jac ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

## Rust 
COPY --chown=jac:jac --from=builder /home/jac/.cargo /home/jac/.cargo
COPY --chown=jac:jac --from=builder /home/jac/.rustup /home/jac/.rustup

ENV PATH=/home/jac/.cargo/bin:$PATH
ENV USER=jac
USER jac
RUN rustup toolchain install stable 
RUN rustup component add rustfmt
RUN rustup component add clippy
RUN cargo --version

LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.name="rustdev" \
    org.label-schema.description="Rust Development Container" \
    org.label-schema.url="https://github.com/jac18281828/rustdev" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="git@github.com:jac18281828/rustdev.git" \
    org.label-schema.vendor="jac18281828" \
    org.label-schema.version=$VERSION \
    org.label-schema.schema-version="1.0" \
    org.opencontainers.image.description="Rust Development Container"
