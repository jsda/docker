# 1.创建文件夹

```
mkdir -p $HOME/spotify/config $HOME/spotify/cache
```

# 2.运行容器
```
docker run -d \
  -v /etc/localtime:/etc/localtime:ro \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY=unix$DISPLAY \
  --device /dev/snd:/dev/snd \
  -v $HOME/spotify/config:/home/spotify/.config/spotify \
  -v $HOME/spotify/cache:/home/spotify/spotify \
  --name spotify \
  rdvde/spotify
```
