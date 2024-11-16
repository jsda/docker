## 1.运行容器
```
docker run -it --rm \
	-e PUID=$UID -e PGID=$GID \
	-v $HOME/wps/backup:/config/.local/share/Kingsoft/office6/data/backup \
	-v $HOME/Downloads:/root/Downloads \
	-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
	-e DISPLAY=unix$DISPLAY \
	-e XDG_RUNTIME_DIR=/run/user/$(id -u) \
	--device /dev/snd \
	--name wps \
	docker.io/rdvde/wps \
	/usr/bin/wps
```
run
```
/usr/bin/wps
/usr/bin/et
/usr/bin/wpp
/usr/bin/wpspdf
```
config
```
-v $HOME/wps/config:/root/.config/Kingsoft
```
backup
```
-v $HOME/wps/backup:/config/.local/share/Kingsoft/office6/data/backup
```