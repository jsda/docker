# 1.运行容器


```
docker run -it --rm \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY=unix$DISPLAY \
  -v $HOME/tools/atom:/home/user/.atom \
  -v $HOME/tools/atom/config:/home/user/.config/Atom \
  -v $HOME/Downloads:/home/user/Downloads \
  --name atom \
  rdvde/atom
```
