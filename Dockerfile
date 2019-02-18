FROM alpine:latest
LABEL maintainer="lunksana <zoufeng4@gmail.com>"

ENV BUILDPATH='git make linux-headers autoconf automake libtool gcc libc-dev wget'
ENV METHODPATH='pcre-dev libev-dev libsodium-dev c-ares-dev mbedtls-dev'
ENV SERVER_HOST=0.0.0.0
ENV SERVER_PORT=8388
ENV LOCALADD=0.0.0.0
ENV PASSWORD='password'
ENV METHOD='chacha20-ietf-poly1305'
ENV PLUGIN='obfs-server'
ENV PLUGIN_OPTS='obfs=http'
ENV PLUGIN_OPTS_LOCAL='obfs=http;obfs-host=www.icloud.com'
ENV SS_MOD='ss-server'
ENV ENABLE_OBFS='false'
ENV REMOTE_DNS_PORT='8.8.8.8:53'

RUN apk update && \
    apk upgrade

RUN apk add ${BUILDPATH} && \
    apk add ${METHODPATH} && \
    mkdir /ss && \
    cd /ss && \
    git clone https://github.com/shadowsocks/shadowsocks-libev && \
    git clone https://github.com/shadowsocks/simple-obfs && \
    cd shadowsocks-libev && \
    git submodule update --init --recursive && \
    ./autogen.sh && \
    ./configure --disable-documentation && \
    make && make install && \
    cd /ss/simple-obfs && \
    git submodule update --init --recursive && \
    ./autogen.sh && \
    ./configure --disable-documentation && \
    make && make install && \
    rm -rf /ss &&\
    rm -rf /usr/local/bin/ss-redir &&\
    rm -rf /usr/local/bin/ss-manager && \
    rm -rf /usr/local/bin/ss-nat && \
    apk del ${BUILDPATH} && \
    rm -rf /var/cache/apk/*

ADD start.sh /
RUN chmod +x /start.sh
EXPOSE 10000
EXPOSE 10000/udp
ENTRYPOINT [ "/start.sh" ]