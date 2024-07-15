# docker pull
# 如果需要特定架构镜像可以手动指定  --platform linux/arm64 , linux/amd64 , linux/arm/v7 等信息
# 查看当前镜像架构信息
# docker image inspect homeassistant/home-assistant:2024.6  | grep Architectur
# "Architecture": "arm64",

arch=$(cat trigger.txt | awk '$1=$1' | awk '{print $3}')
arch=${arch:-amd64}
image_src=$(cat trigger.txt | awk '$1=$1' | awk '{print $1}')
image_dest=$(cat trigger.txt | awk '$1=$1' | awk '{print $2}')
echo "arch=${arch}"

# 不指定 cpu 架构
echo "docker pull --platform=${arch} ${image_src}"
exit 0
docker pull --platform=${arch} "${image_src}"

#指定 cpu 架构
# cat trigger.txt |awk '{print "docker pull --platform linux/arm64 " $1} '
# cat trigger.txt |awk '{print "docker pull --platform linux/arm64 " $1} '| sh

# inspect Architectur
# cat trigger.txt |awk '{print "docker image inspect  " $1 "| grep Architectur" } '
# cat trigger.txt |awk '{print "docker image inspect  " $1 "| grep Architectur" } '| sh

# docker tag
echo "docker tag ${image_src} ${image_dest}"
docker tag "${image_src}" "${image_dest}"

# docker push
echo "docker push ${image_dest}"
docker push "${image_dest}"