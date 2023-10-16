# docker安装openwrt

## 参考 https://github.com/yangyaofei/docker-openclash

## A docker image for [OpenClash](https://github.com/vernesong/OpenClash)

#### 创建macvlan，parent后面为物理网卡名称，macnet为创建的macvlan名称
```
##LAN 口
docker network create -d macvlan \
  --subnet=192.168.1.0/24 \
  --gateway=192.168.1.254 \
  --subnet=fe80::/16 \
  --gateway=fe80::1 \
  -o parent=eth0 maclan
##WAN 口
docker network create -d macvlan \
  --subnet=192.168.254.0/24 \
  --gateway=192.168.254.1 \
  --subnet=fe81::/16 \
  --gateway=fe81::1 \
  -o parent=eth1 macwan
```
#### 启动容器
```
docker run -d \
    --restart=always \
    --privileged \
    --network maclan \
    -v $PWD/openwrt/etc:/etc \
    --name=openwrt \
    rdvde/openwrt:latest \
    /sbin/init
```
#### 将第二网卡的 macvlan 挂接到 openwrt
```
docker network connect macwan openwrt
```
#### 进入容器
```
docker exec -it openwrt /bin/sh
```
#### 编辑/etc/config/network，把lan口IP地址改为192.168.1.254
#### 重启 openwrt 网络
```
/etc/init.d/network restart
```
#### 修改（必须）/etc/sysctl.conf
```
net.ipv6.conf.all.disable_ipv6=0
net.ipv6.conf.default.disable_ipv6=0
net.ipv6.conf.default.accept_ra=2
net.ipv6.conf.all.accept_ra=2
```
#### sysctl.conf参数立即生效
```
sysctl -p
```
#### 作为主路由拨号使用，进入管理界面
```
网络－接口－添加新接口，名称wan，
协议pppoe，设备选eth1，保存后填写宽带账号密码
```
#### 获取ipv6
```
wan口高级设置－获取ipv6地址－自动，
ipv6分配长度64，dhcp等关闭

lan口高级设置－ipv6分配长度64，dhcp服务器－ipv6设置，
RA服务＆DHCPv6服务－选混合或服务器模式，NDP代理－禁用
```
#### 解决主机无法访问网络，需要修改宿主机网卡配置
```
#编辑/etc/network/interfaces(eth0为对应内网网卡名称)

auto eth0
iface eth0 inet manual

auto macvlan
iface macvlan inet static
        address 192.168.1.252
        netmask 255.255.255.0
        gateway 192.168.1.254
        dns-nameservers 192.168.1.254
        pre-up ip link add macvlan link eth0 type macvlan mode bridge
        post-down ip link del macvlan link eth0 type macvlan mode bridge
```