## 1.运行容器

````javascript
docker run -it --rm \
  --net host \
  --cpuset-cpus 0 \
  -c 512 -m 2096m \
  -e PUID=$UID -e PGID=$GID \
  -v $HOME/.mozilla/firefox:/home/user/.mozilla/firefox \
  -v $HOME/Downloads:/home/user/Downloads \
  -v /usr/share/fonts:/usr/share/fonts:ro \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY=unix$DISPLAY \
  --device /dev/snd \
  -v /dev/shm:/dev/shm \
  --name firefox \
  rdvde/firefox

````
