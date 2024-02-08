FROM ghcr.io/openwrt/rootfs:x86_64
# stable x86_64-23.05.2
# https://github.com/openwrt/docker

ARG Build_Time=$Build_Time

# RUN sed -i 's_downloads.openwrt.org_mirrors.tuna.tsinghua.edu.cn/openwrt_' /etc/opkg/distfeeds.conf

RUN sed -i '6.1.74-1-83764a037d5da4b65844fa9bc9d55bc3/6.1.75-1-f9564b8bbbd1a0c3e49fc45580e1e810' /etc/opkg/distfeeds.conf

COPY openwrt/ipk/* /app/

RUN mkdir /var/lock
RUN opkg update && \
    sed -i "s/OpenWrt/OpenWrt Date$Build_Time/g" /etc/openwrt_release && \
    opkg remove --force-remove dnsmasq && \
    opkg install coreutils-nohup \
    bash curl ca-certificates \
    ipset ip-full libcap libcap-bin \
    ruby ruby-yaml kmod-tun kmod-inet-diag \
    unzip kmod-nft-tproxy luci-compat luci \
    luci-base luci-i18n-base-zh-cn \
    luci-i18n-opkg-zh-cn luci-i18n-firewall-zh-cn \
    nano unzip wget openssh-sftp-server \
    kmod-veth \
    openssl-util xxd coreutils-base64
RUN opkg install /app/*.ipk && \
    mv /app/AdGuardHome /usr/bin/ && \
    chmod +x /usr/bin/AdGuardHome && \
    rm -rf /app

#AdGuardHome --no-check-update -c /etc/adguardhome/conf/AdGuardHome.yaml -w /etc/adguardhome/work -s install

COPY openwrt/openclash/ /etc/openclash/
RUN chmod a+x /etc/openclash/core/*
#EXPOSE 80
