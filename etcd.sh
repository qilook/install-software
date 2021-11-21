#!/usr/bin/bash

VERSION="3.5.1"

if [ -n "$1" ];then
    VERSION=$1
fi

GOOGLE_URL=https://storage.googleapis.com/etcd
DOWNLOAD_URL=${GOOGLE_URL}

SUDO=''

_init() {
    which sudo && SUDO="sudo"
}

_main() {
    cd /tmp \
        && wget -c ${DOWNLOAD_URL}/v${VERSION}/etcd-v${VERSION}-linux-amd64.tar.gz \
        && ${SUDO} rm -rf /opt/etcd \
        && ${SUDO} mkdir -p /opt/etcd \
        && ${SUDO} tar xzvf etcd-v${VERSION}-linux-amd64.tar.gz -C /opt/etcd --strip-components=1 \
        && ${SUDO} ln -sf /opt/etcd/etcdctl /usr/local/bin/etcdctl \
        && ${SUDO} ln -sf /opt/etcd/etcd /usr/local/bin/etcd \
        && ${SUDO} ln -sf /opt/etcd/etcdutl /usr/local/bin/etcdutl \
        && echo "install etcd v${VERSION} success"
}

_init
_main