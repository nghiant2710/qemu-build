FROM debian:jessie

RUN apt-get -q update \
	&& apt-get -qqy install \
		build-essential \
		libgtk2.0-dev \
		zlib1g-dev
	&& mkdir /output

ENV QEMU_VERSION 2.2.0

RUN curl http://wiki.qemu-project.org/download/qemu-${QEMU_VERSION}.tar.bz2 | tar xj

WORKDIR /qemu-${QEMU_VERSION}

COPY qemu-${QEMU_VERSION}.patch /qemu-${QEMU_VERSION}/qemu-${QEMU_VERSION}.patch

RUN patch -p1 < qemu-${QEMU_VERSION}.patch

CMD ./configure --target-list="arm-linux-user" --static \
	&& make -j $(nproc) \
	&& strip arm-linux-user/qemu-arm \
	&& cp arm-linux-user/qemu-arm /output/qemu-arm-static-${QEMU_VERSION}
