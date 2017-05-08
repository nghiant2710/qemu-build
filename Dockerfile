FROM debian:jessie

ENV QEMU_VERSION 2.8.1-resin-rc1
ENV QEMU_SHA256 d4f00bda10cddbc20907ab05c4c64cef984b07784f0aa9913b365be96eae46d2

RUN apt-get -q update \
        && apt-get -qqy install \
                build-essential \
                zlib1g-dev \
                libpixman-1-dev \
                python \
                libglib2.0-dev \
                pkg-config \
                curl \
                jq \
        && rm -rf /var/lib/apt/lists/*

RUN curl -SL https://codeload.github.com/resin-io/qemu/tar.gz/v${QEMU_VERSION} -o qemu-${QEMU_VERSION}.tar.gz \
        && echo "${QEMU_SHA256}  qemu-${QEMU_VERSION}.tar.gz" > qemu-${QEMU_VERSION}.tar.gz.sha256sum \
        && sha256sum -c qemu-${QEMU_VERSION}.tar.gz.sha256sum \
        && tar -xzf qemu-${QEMU_VERSION}.tar.gz \
        && rm qemu-${QEMU_VERSION}.tar.gz*

WORKDIR /qemu-${QEMU_VERSION}

COPY . /qemu-${QEMU_VERSION}/

CMD ./build.sh
