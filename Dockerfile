FROM alpine:latest
LABEL maintainer="lunksana <zoufeng4@gmail.com>"

ENV BUILDPATH='git make linux-headers autoconf automake libtool gcc libc-dev'
ENV METHODPATH='pcre-dev libev-dev libsodium-dev c-ares-dev mbedtls-dev'
ENV SERVER_HOST=0.0.0.0
ENV SERVER_PORT=443
ENV LOCAL_PORT=1080
ENV PASSWORD='PASSWORD'
ENV METHOD='chacha20-ietf-poly1305'
ENV PLUGIN=obfs-server
ENV PLUGIN_OPT='obfs=http'
ENV SS_MOD=ss-server
ENV ENABLE_OBFS='N'

RUN apk update && \
    apk upgrade

RUN apk add ${BUILDPATH} && \
    apk add ${METHODPATH} && \
    mkdir /ss && \
    cd /ss && \
    git clone https://github.com/shadowsocks/shadowsocks-libev && \
    git clone https://github.com/shadowsocks/simple-obfs && \
    cd shadowsocks-libev && \
    git submodule update --init && \
    ./autogen.sh && \
    ./configure --disable-documentation && \
    make && make install && \
    cd /ss/simple-obfs && \
    git submodule update --init -- recursive && \
    ./autogen.sh && \
    ./configure --disable-documentation && \
    make && make install && \
    rm -rf /ss &&\
    apk del ${BUILDPATH} && \
    rm -rf /var/cache/apk/*

ADD start.sh /
RUN chmod +x /start.sh
EXPOSE ${SERVER_PORT}
EXPOSE ${SERVER_PORT}/udp
EXPOSE ${LOCAL_PORT}
EXPOSE ${LOCAL_PORT}/udp
ENTRYPOINT [ "/start.sh" ]