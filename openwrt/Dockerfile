FROM openwrt/rootfs:x86_64
# https://github.com/openwrt/docker

ARG Build_Time=$Build_Time

COPY openwrt/ipk/* /app/
# RUN sed -i 's_downloads.openwrt.org_mirrors.tuna.tsinghua.edu.cn/openwrt_' /etc/opkg/distfeeds.conf
RUN mkdir /var/lock
RUN opkg update && \
    sed -i "s/OpenWrt/OpenWrt Date$Build_Time/g" /etc/openwrt_release && \
    opkg remove dnsmasq && \
    opkg install coreutils-nohup \
    bash dnsmasq-full curl ca-certificates \
    ipset ip-full libcap libcap-bin \
    ruby ruby-yaml kmod-tun kmod-inet-diag \
    unzip kmod-nft-tproxy luci-compat luci \
    luci-base luci-i18n-base-zh-cn \
    luci-i18n-opkg-zh-cn luci-i18n-firewall-zh-cn \
    nano unzip wget openssh-sftp-server \
    openssl-util xxd coreutils-base64
RUN opkg install /app/*.ipk && \
    mv /app/AdGuardHome /usr/bin/ && \
    chmod +x /usr/bin/AdGuardHome && \
    rm -rf /app

#AdGuardHome --no-check-update -c /etc/adguardhome/conf/AdGuardHome.yaml -w /etc/adguardhome/work -s install

COPY openwrt/openclash/ /etc/openclash/
RUN chmod a+x /etc/openclash/core/*
#EXPOSE 80
