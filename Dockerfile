FROM debian:jessie

ENV QEMU_VERSION 2.5.0-resin-rc1
ENV QEMU_SHA256 09e80f4168566463b9cbad6c9fc902ad21c806e683f6e196ebe7db3503ee4871

RUN apt-get -q update \
	&& apt-get -qqy install \
		build-essential \
		libgtk2.0-dev \
		zlib1g-dev \
	&& mkdir /output

RUN curl -SL https://codeload.github.com/resin-io/qemu/tar.gz/v${QEMU_VERSION} -o qemu-${QEMU_VERSION}.tar.gz \
	&& echo "${QEMU_SHA256}  qemu-${QEMU_VERSION}.tar.gz" > qemu-${QEMU_VERSION}.tar.gz.sha256sum \
	&& sha256sum -c qemu-${QEMU_VERSION}.tar.gz.sha256sum \
	&& tar -xzf qemu-${QEMU_VERSION}.tar.gz \
	&& rm qemu-${QEMU_VERSION}.tar.gz*

WORKDIR /qemu-${QEMU_VERSION}

COPY . /qemu-${QEMU_VERSION}/

CMD ./build.sh
