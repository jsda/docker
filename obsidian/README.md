## 1.运行容器

````javascript
docker run -it --rm \
	-e PUID=$UID -e PGID=$GID \
	-v $HOME/.config/obsidian:/root/.config/obsidian \
	-v $HOME/Downloads:/home/user/Downloads \
	-v /usr/share/fonts:/usr/share/fonts:ro \
	-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
	-e DISPLAY=unix$DISPLAY \
	--device /dev/snd \
	--name obsidian \
	rdvde/obsidian

````
