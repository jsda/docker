* https://github.com/linuxserver/docker-shotcut

## 1.运行容器

````javascript
docker run -it --rm \
  -e PUID=$UID -e PGID=$GID \
  -v $HOME/.config/shotcut:/root/.config/Meltytech \
  -v $HOME/Downloads:/Downloads \
  -v /usr/share/fonts:/usr/share/fonts:ro \
  -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
  -e DISPLAY=$DISPLAY \
  -e PULSE_SERVER=unix:$XDG_RUNTIME_DIR/pulse/native \
  -v $XDG_RUNTIME_DIR/pulse:$XDG_RUNTIME_DIR/pulse:ro \
  --device /dev/snd \
  --device /dev/dri \
  --name shotcut \
  rdvde/shotcut
````
