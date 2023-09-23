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

# ARG PACKAGE_NAME="polaris-console-release_v1.14.2.linux.amd64.zip"

COPY ./polaris-console-release_v1.14.2.linux.amd64.zip /data0/

RUN unzip /data0/polaris-console-release_v1.14.2.linux.amd64.zip -d /data0 && \
    rm -rf /data0/polaris-console-release_v1.14.2.linux.amd64.zip && \
    mv /data0/polaris-console-release_v1.14.2.linux.amd64/ /data0/polaris/

COPY ./conf/polaris-console.yaml /data0/polaris/polaris-console.yaml

WORKDIR /data0/polaris

ENV SERVER_URL=127.0.0.1:8089 \
    MONITOR_URL=127.0.0.1:9090

CMD ["/data0/polaris/polaris-console"]

EXPOSE 8080