# 简单讲讲如何使用：

## 1， 安装docker环境

## 2， 拉取镜像，默认ubuntu环境:

$ docker pull rdvde/builder


## 3, 运行容器:

$ docker run -it --name lede --network host -v 你的本地文件夹:/home/lede rdvde/builder

#### git代码开始编译～
#### 默认工作用户为lede
#### root和lede用户密码为password
#### 支持root用户编译
#### 以后再运行容器时运行的命令

$ docker restart lede && docker attach lede
