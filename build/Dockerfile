ARG VERSION=1.5.1
ARG DEBIAN_VERSION=bookworm-slim

FROM debian:${DEBIAN_VERSION} AS build
ARG VERSION

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y wget build-essential dh-autoreconf libdb-dev libsasl2-dev libssl-dev pkg-config zlib1g-dev && \
    mkdir /src && \
    wget -O /src/isync-${VERSION}.tar.gz https://sourceforge.net/projects/isync/files/isync/${VERSION}/isync-${VERSION}.tar.gz/download && \
    tar -xzvf /src/isync-${VERSION}.tar.gz -C /src

WORKDIR /src/isync-${VERSION}
RUN ./configure && \
    make

FROM debian:${DEBIAN_VERSION}
ARG VERSION

COPY --chmod=755 --from=build /src/isync-${VERSION}/src/mbsync /usr/local/bin/
ADD --chmod=755 entrypoint.sh /entrypoint.sh

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y db-util libsasl2-2 openssl zlib1g ca-certificates cron gosu && \
    mkdir /config && \
    mkdir /data && \
    addgroup --gid 1000 sync && \
    useradd --uid 1000 --gid sync --home-dir /config sync

WORKDIR /data
VOLUME ["/config", "/data"]

ENTRYPOINT ["/entrypoint.sh"]
