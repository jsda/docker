## 1.运行容器

````javascript
docker run -it --rm \
	-e PUID=$UID -e PGID=$GID \
	-v $HOME/.config/Kingsoft:/root/.config/Kingsoft \
	-v $HOME/wpsbackup:/root/.local/share/Kingsoft/office6/data/backup \
	-v $HOME/Downloads:/root/Downloads \
	-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
	-e DISPLAY=unix$DISPLAY \
	--device /dev/snd \
	--name wps \
	rdvde/wps

````
