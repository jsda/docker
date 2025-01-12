## 1.运行容器

````javascript
docker run -it --rm \
  -c 512 -m 8g \
  -e PUID=$UID -e PGID=$GID \
  --user root \
  -v $HOME/.mozilla/firefox/Profiles:/home/user/.mozilla/firefox/Profiles \
  -v $HOME/Downloads:/home/user/Downloads \
  -v /usr/share/fonts:/usr/share/fonts:ro \
  -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
  -e DISPLAY=unix$DISPLAY \
  -e PULSE_SERVER=unix:$XDG_RUNTIME_DIR/pulse/native \
  -v $XDG_RUNTIME_DIR/pulse:$XDG_RUNTIME_DIR/pulse:ro \
  --device /dev/snd \
  -v /dev/shm:/dev/shm:ro \
  --name firefox \
  rdvde/firefox

````