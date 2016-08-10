FROM debian:stretch

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

RUN git clone https://github.com/balena-io/qemu.git

COPY build.sh /qemu/

WORKDIR /qemu

CMD ./build.sh
