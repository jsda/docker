## 1.运行容器

````javascript
docker run -it --rm \
  --net host \
  --cpuset-cpus 0 \
  -c 512 -m 2096m \
  -e PUID=$UID -e PGID=$GID \
  -v $HOME/tools/chromium:/home/chromium/.config/chromium \
  -v $HOME/Downloads:/home/chromium/Downloads \
  -v /usr/share/fonts:/usr/share/fonts:ro \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY=unix$DISPLAY \
  --device /dev/snd \
  -v /dev/shm:/dev/shm \
  --name chromium \
  rdvde/chromium

````



## 2.如果运行不起来，请下载chrome配置

````javascript

wget https://raw.githubusercontent.com/jfrazelle/dotfiles/master/etc/docker/seccomp/chrome.json -O ~/chrome.json

````

## 再添加一条运行参数

````javascript
--security-opt seccomp=$HOME/chrome.json \

````
