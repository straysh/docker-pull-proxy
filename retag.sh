#!/usr/bin/env bash

tag=$(cat trigger.txt |awk 'NR==1{print $1}')
image=$(cat trigger.txt |awk 'NR==1{print $2}')

echo "docker pull ${image}"
docker pull "${image}"

echo "docker tag ${image} ${tag}"
docker tag "${image}" "${tag}"

echo "docker rmi ${image}"
docker rmi "${image}"