- https://github.com/P3TERX/aria2.conf
- https://api.github.com/repos/mayswind/AriaNg
## 1.运行容器

```
docker run -d \
  -e PUID=$UID -e PGID=$GID \
  -e UMASK_SET=022 \
  -e RPC_PORT=6800 \
  -e LISTEN_PORT=6888 \
  -e DHT_LISTEN_PORT=6888 \
  -e HTTP_PORT=6880 \
  -e RPC_SECRET="password" \
  -p 6800:6800 \
  -p 6888:6888 \
  -p 6888:6888/udp \
  -p 6880:6880 \
  -v $HOME/Downloads:/root/Download \
  --restart always \
  --name aria2 \
  docker.io/rdvde/aria2
```

* AriaNg默认端口 `6880`
* 在线浏览下载目录 `:6880/Downloads`
* 支持 amd64/arm64