FROM ghcr.io/openwrt/rootfs:x86_64
# stable x86_64-23.05.2
# https://github.com/openwrt/docker

ARG Build_Time=$Build_Time

# RUN sed -i "s/xxx/xxx/g" /etc/opkg/distfeeds.conf

COPY openwrt/ipk/* /app/
COPY openwrt/openclash/ /etc/openclash/

RUN echo -e "$(uname -r)"

RUN mkdir /var/lock
RUN opkg update && \
    sed -i "s/SNAPSHOT/SNAPSHOT Build$Build_Time/g" /etc/openwrt_release && \
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
    mv /app/ddns-go /usr/bin/ && \
    chmod +x /usr/bin/ddns-go && \
    mv /app/AdGuardHome /usr/bin/ && \
    chmod +x /usr/bin/AdGuardHome && \
    chmod a+x /etc/openclash/core/* && \
    rm -rf /app

#AdGuardHome --no-check-update -c /etc/adguardhome/conf/AdGuardHome.yaml -w /etc/adguardhome/work -s install

#/usr/bin/ddns-go -c /etc/ddns-go/config.yaml

#EXPOSE 80
