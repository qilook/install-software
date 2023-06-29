#!/bin/bash

_main() {
    which sudo >/dev/null && SUDO="sudo"

    cd /tmp \
    && wget -c https://github.com/redis/redis/archive/7.0.11.tar.gz \
    && chmod 666 7.0.11.tar.gz \
    && tar xzf 7.0.11.tar.gz \
    && cd redis-7.0.11 \
    && make distclean \
    && make \
    && ${SUDO} cp -r src/ /opt/redis \
    && ${SUDO} mkdir -p /etc/redis \
    && ${SUDO} cp redis.conf /etc/redis \
    && ${SUDO} ln -fs /opt/redis/redis-server /usr/local/bin/redis-server \
    && ${SUDO} ln -fs /opt/redis/redis-cli /usr/local/bin/redis-cli
    [ $? -ne 0 ] && return

    [ -f /etc/systemd/system/redis.service ] \
    || echo """[Unit]
Description=Redis
After=syslog.target

[Service]
ExecStart=/usr/local/bin/redis-server /etc/redis/redis.conf
Restart=always

[Install]
WantedBy=multi-user.target
""" | ${SUDO} tee /etc/systemd/system/redis.service >/dev/null \
    && ${SUDO} systemctl enable /etc/systemd/system/redis.service \
    && ${SUDO} systemctl start redis.service

    echo "install redis success"
}

_main
