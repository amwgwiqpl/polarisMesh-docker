FROM alpine:3.18.3

RUN sed -i 's!http://dl-cdn.alpinelinux.org/!https://mirrors.tencent.com/!g' /etc/apk/repositories

RUN set -eux && \
    apk add tcpdump && \
    apk add tzdata && \
    apk add busybox-extras && \
    apk add curl && \
    apk add bash && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    date

# ARG PACKAGE_NAME="polaris-server-release_v1.17.5.linux.amd64.zip"

# COPY ./polaris-server /data0/polaris
COPY ./polaris-server-release_v1.17.5.linux.amd64.zip /data0/

RUN unzip /data0/polaris-server-release_v1.17.5.linux.amd64.zip -d /data0 && \
    rm -rf /data0/polaris-server-release_v1.17.5.linux.amd64.zip && \
    mv /data0/polaris-server-release_v1.17.5.linux.amd64/ /data0/polaris/

COPY ./conf/polaris-server.yaml /data0/polaris/conf/polaris-server.yaml

WORKDIR /data0/polaris

ENV DB_URL=127.0.0.1:3306 \
    DB_USER=root \
    DB_PWD=root

CMD ["/data0/polaris/polaris-server", "start"]

EXPOSE 8090 8091 8093