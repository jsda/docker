# 运行aria2容器

````javascript
docker run -d \
  -p 888:8080 \
  -p 6800:6800 \
  -p 6881:6881 \
  -p 6881:6881/udp \
  -v $HOME/Downloads:/root/Downloads \
  --restart always \
  --name aria2 \
  rdvde/aria2

  ````
