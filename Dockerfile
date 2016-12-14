FROM debian:jessie

ENV QEMU_VERSION 2.7.0-resin-rc2
ENV QEMU_SHA256 85ee74daf6d7874bbcd68c2e89f55e56e4cb5fadeaa3930430e2c4c05f6dda2b

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
