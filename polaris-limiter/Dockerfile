FROM alpine:3.18.3

ENV BUILD_DEPS="gettext"  \
    RUNTIME_DEPS="libintl"

RUN sed -i 's!http://dl-cdn.alpinelinux.org/!https://mirrors.tencent.com/!g' /etc/apk/repositories

RUN set -eux && \
    apk add tcpdump && \
    apk add tzdata && \
    apk add busybox-extras && \
    apk add curl && \
    apk add bash && \
    apk add --update $RUNTIME_DEPS && \
    apk add --virtual build_deps $BUILD_DEPS &&  \
    cp /usr/bin/envsubst /usr/local/bin/envsubst && \
    apk del build_deps && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    date

# ARG PACKAGE_NAME="polaris-limiter-release_v1.0.5.linux.amd64.zip"

COPY ./polaris-limiter-release_v1.0.5.linux.amd64.zip /data0/

RUN unzip /data0/polaris-limiter-release_v1.0.5.linux.amd64.zip -d /data0 && \
    rm -rf /data0/polaris-limiter-release_v1.0.5.linux.amd64.zip && \
    mv /data0/polaris-limiter-release_v1.0.5.linux.amd64/ /data0/polaris/

COPY ./conf/polaris-limiter.yaml /data0/polaris/polaris-limiter.yaml

WORKDIR /data0/polaris

ENV SERVER_URL=127.0.0.1:8089

CMD ["/data0/polaris/polaris-limiter", "start"]

EXPOSE 8101 8100