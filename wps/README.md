## 1.运行容器
```
docker run -it --rm \
	-e PUID=$UID -e PGID=$GID \
	-v $HOME/wps/backup:/config/.local/share/Kingsoft/office6/data/backup \
	-v $HOME/Downloads:/root/Downloads \
	-v $HOME/.local/share/fcitx5:/root/.local/share/fcitx5:ro \
	-v $HOME/.config/fcitx5:/root/.config/fcitx5:ro \
	-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
	-e DISPLAY=unix$DISPLAY \
	-e XDG_RUNTIME_DIR=/run/user/$(id -u) \
	-e STARTUP=wps \
	--device /dev/snd \
	--name wps \
	docker.io/rdvde/wps \
	/usr/bin/wps
```
env
```
STARTUP=wps
STARTUP=et
STARTUP=wpp
STARTUP=wpspdf
```
config
```
-v $HOME/wps/config:/root/.config/Kingsoft
```
backup
```
-v $HOME/wps/backup:/config/.local/share/Kingsoft/office6/data/backup
```