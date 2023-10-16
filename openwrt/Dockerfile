FROM openwrt/rootfs:x86-64
ARG Build_Time=$Build_Time
LABEL vsrsion=$Build_Time

COPY openwrt/ipk/*.ipk /app/
# RUN sed -i 's_downloads.openwrt.org_mirrors.tuna.tsinghua.edu.cn/openwrt_' /etc/opkg/distfeeds.conf
RUN mkdir /var/lock
RUN opkg update && \
    opkg remove dnsmasq && \
    opkg install coreutils-nohup \
    bash dnsmasq-full curl ca-certificates \
    ipset ip-full libcap libcap-bin \
    ruby ruby-yaml kmod-tun kmod-inet-diag \
    unzip kmod-nft-tproxy luci-compat luci \
    luci-base luci-i18n-base-zh-cn \
    luci-i18n-opkg-zh-cn luci-i18n-firewall-zh-cn \
    nano unzip wget openssh-sftp-server
RUN opkg install /app/*.ipk && \
    rm -rf /app
COPY openwrt/openclash/ /etc/openclash/
RUN chmod a+x /etc/openclash/core/*
#EXPOSE 80
