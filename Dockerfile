FROM debian:jessie

RUN apt-get -q update \
	&& apt-get -qqy install \
		build-essential \
		libgtk2.0-dev \
		zlib1g-dev \
	&& mkdir /output

ENV QEMU_VERSION 2.5.0-resin
ENV QEMU_SHA256 6525da6fef4beb5b60e2526f15fc2aa734e4395440bdd23b0ef189c57bbcea4f

RUN curl -SL https://codeload.github.com/resin-io/qemu/tar.gz/v${QEMU_VERSION} -o qemu-${QEMU_VERSION}.tar.gz \
	&& echo "$QEMU_SHA256  qemu-${QEMU_VERSION}.tar.gz" > qemu-${QEMU_VERSION}.tar.gz.sha256sum \
	&& sha256sum -c qemu-${QEMU_VERSION}.tar.gz.sha256sum \
	&& tar -xzf qemu-${QEMU_VERSION}.tar.gz \
	&& rm qemu-${QEMU_VERSION}.tar.gz*

WORKDIR /qemu-${QEMU_VERSION}

COPY qemu-${QEMU_VERSION}.patch /qemu-${QEMU_VERSION}/qemu-${QEMU_VERSION}.patch

RUN patch -p1 < qemu-${QEMU_VERSION}.patch

CMD ./configure --target-list="arm-linux-user" --static \
	&& make -j $(nproc) \
	&& strip arm-linux-user/qemu-arm \
	&& mkdir -p /output/qemu-${QEMU_VERSION} \
	&& cp arm-linux-user/qemu-arm /output/qemu-${QEMU_VERSION}/qemu-arm-static
