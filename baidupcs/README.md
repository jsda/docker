## 1.运行容器

````javascript
docker run -d \
  -p 5299:5299 \
  -v $HOME/Downloads:/home/alpine/Downloads \
  --network host \
  --name baidupcs \
  rdvde/baidupcs

````
