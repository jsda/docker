## 1.运行容器

````javascript
docker run -it --rm \
	-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
	-e DISPLAY=unix$DISPLAY \
	-e XAUTHORITY=/tmp/xauth \
	-e DISPLAY=unix$DISPLAY \
	--device /dev/snd \
	-v /dev/shm:/dev/shm:ro \
	-v $XAUTHORITY:/tmp/xauth:ro \
	-v $HOME/telegram:/home/user/.local/share/TelegramDesktop \
	-v $HOME/Downloads:/home/user/Downloads \
	-v /usr/share/fonts:/usr/share/fonts:ro \
	-e PUID=$UID -e PGID=$GID \
	--name telegram \
	rdvde/telegram

````