#!/usr/bin/env bash
# trigger.txt 行格式：原始镜像地址（不带域名） 目标镜像地址（带阿里云镜像域名+个人空间名称+新镜像名称） 架构
# 可以定义多行镜像，逐行解析拉取推送

docker_pull(){
  image_src=$1
  image_dest=$2
  arch=$3

  if [[ "${DEBUG,,}" =~ ^(y|yes|1)$ ]];then
    echo "docker pull --platform=${arch} ${image_src}"
    echo "docker tag ${image_src} ${image_dest}"
    echo "docker push ${image_dest}"
    exit 0
  fi

  echo "docker pull --platform=${arch} ${image_src}"
  docker pull --platform=${arch} "${image_src}"

  # docker tag
  echo "docker tag ${image_src} ${image_dest}"
  docker tag "${image_src}" "${image_dest}"

  # docker push
  echo "docker push ${image_dest}"
  docker push "${image_dest}"
}


while IFS= read -r line || [[ -n "$line" ]]; do
  if [[ -n "$line" ]];then
    echo "raw line:$line"
    arch=$(echo "$line" | awk '$1=$1' | awk '{print $3}')
    arch=${arch:-amd64}
    image_src=$(echo "$line" | awk '$1=$1' | awk '{print $1}')
    image_dest=$(echo "$line" | awk '$1=$1' | awk '{print $2}')
    image_dest="${image_dest}-${arch}"
    echo "new line:${image_src} ${image_dest} ${arch}"
    docker_pull "${image_src}" "${image_dest}" "${arch}"
  fi
done < trigger.txt

