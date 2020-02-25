# 1.运行容器

```
docker run -it --rm \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY=unix$DISPLAY \
  -e XAUTHORITY=/tmp/xauth \
  -e DISPLAY=unix$DISPLAY \
  --device /dev/snd \
  -v /dev/shm:/dev/shm \
  -v $XAUTHORITY:/tmp/xauth \
  -v $HOME/signal:/home/user/.config/Signal \
  -v $HOME/Downloads:/home/user/Downloads \
  --name signal \
  rdvde/signal
```
