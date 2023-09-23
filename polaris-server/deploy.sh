#!/bin/bash
set -e

export SERVER="polaris-server"
export VERSION="latest"
export REPO_URL=""
export NAMESPACE=""
export PORTS=()
while getopts ":s:v:r:n:p:" opt
do
    case $opt in
        s)
            SERVER=$OPTARG;;
        v)
            VERSION=$OPTARG;;
        r)
            REPO_URL=$OPTARG;;
        n)
            NAMESPACE=$OPTARG;;
        p)
            PORTS+=("$OPTARG");; 
        ?)
        echo "Unknown parameter"
        exit 1;;
    esac
done

[ ! $PORTS ] && PORTS=([0]="8090:8090" [1]="8091:8091" [2]="8093:8093")
echo ${PORTS[*]}

export DOCKER_PORT=""
for port in "${PORTS[@]}"
do
    DOCKER_PORT+="-p $port " 
done    

echo "DOCKER_PORT: ${DOCKER_PORT}"

export DOCKER_NAME=""
ELE_DOCKER_NAME=(${REPO_URL} ${NAMESPACE} ${SERVER})
for name in "${ELE_DOCKER_NAME[@]}"
do
    if [ -n $name ]
    then
        DOCKER_NAME+="$name/" 
    fi
done

[[ "$DOCKER_NAME" =~ .*/$ ]] && DOCKER_NAME=${DOCKER_NAME%/*}
echo "${DOCKER_NAME}"

export DOCKER_NAME_VERSION="${DOCKER_NAME}:${VERSION}"
echo "${DOCKER_NAME_VERSION}"

export LATEST=$(docker images ${DOCKER_NAME} -q)
echo "${DOCKER_NAME} -> ${LATEST}"

## 第一步：删除可能启动的老容器
echo "开始停止 ${SERVER} 容器"
docker stop ${SERVER} || true
echo "成功停止 ${SERVER} 容器"

echo "--------------------------"
echo "开始删除 ${SERVER} 容器"
docker rm ${SERVER} || true
echo "完成删除 ${SERVER} 容器"
echo "--------------------------"

echo "开始删除 ${SERVER} 旧镜像"
docker rmi ${LATEST} || true
echo "完成删除 ${SERVER} 旧镜像"
echo "--------------------------"

echo "开始构建 ${SERVER} 镜像"
docker build -t ${DOCKER_NAME_VERSION} .
echo "完成构建 ${SERVER} 镜像"
echo "--------------------------"

# echo "开始推送 ${SERVER} 镜像"
# docker pull ${DOCKER_NAME_VERSION}
# echo "完成推送 ${SERVER} 镜像"
# echo "--------------------------"

## 第二步：启动新的 ${SERVER} 容器 \
echo "开始启动 ${SERVER} 容器"
docker run -d \
--name ${SERVER} \
${DOCKER_PORT} \
-e "DB_URL=10.174.1.101:3306" \
-e "DB_USER=root" \
-e "DB_PWD=root" \
-v /data0/${SERVER}/log:/root/logs/ \
${DOCKER_NAME_VERSION}
echo "正在启动 ${SERVER} 容器中，需要等待 60 秒左右"
