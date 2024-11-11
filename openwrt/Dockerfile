FROM ghcr.io/openwrt/rootfs:x86_64-openwrt-23.05

# https://github.com/openwrt/docker

ARG ARCH=x86_64

ARG Build_Time=$Build_Time

ARG GEO_MMDB=https://github.com/MetaCubeX/meta-rules-dat/raw/refs/heads/release/country.mmdb
ARG GEO_SITE=https://github.com/MetaCubeX/meta-rules-dat/raw/refs/heads/release/geosite.dat
ARG GEO_IP=https://github.com/MetaCubeX/meta-rules-dat/raw/refs/heads/release/geoip.dat
ARG CN_LIST=https://github.com/MetaCubeX/meta-rules-dat/raw/refs/heads/meta/geo/geosite/cn.list
ARG Domains_china=https://github.com/felixonmars/dnsmasq-china-list/raw/master/accelerated-domains.china.conf

#COPY openwrt/ipk/* /app/

RUN echo -e "$(uname -r)"

RUN mkdir /var/lock
RUN set -ex && \
	opkg update && \
    sed -i "s/SNAPSHOT/SNAPSHOT Build$Build_Time/g" /etc/openwrt_release && \
    opkg remove --force-remove dnsmasq && \
    opkg install coreutils-nohup \
    bash curl ca-certificates \
    ipset ip-full libcap libcap-bin \
    ruby ruby-yaml kmod-tun kmod-inet-diag \
    unzip kmod-nft-tproxy luci-compat luci \
    luci-base luci-i18n-base-zh-cn \
    luci-i18n-firewall-zh-cn \
    luci-i18n-opkg-zh-cn \
    ddns-scripts-cloudflare luci-i18n-ddns-zh-cn \
    nano unzip wget openssh-sftp-server \
    kmod-veth \
    openssl-util xxd coreutils-base64
RUN set -ex && \
    mkdir -p /tmp/ipk && cd /tmp/ipk && \
    Open_Clash=$(curl -sX GET "https://api.github.com/repos/vernesong/OpenClash/releases" \
      | awk '/tag_name/{print $4;exit}' FS='[""]' \
      | sed 's/"//g;s/v//g;s/release-//g') && \
    curl -L -O https://github.com/vernesong/OpenClash/releases/download/v${Open_Clash}/luci-app-openclash_${Open_Clash}_all.ipk && \
    curl -L -O $(curl -s https://downloads.immortalwrt.org/snapshots/packages/$ARCH/luci/ | grep -Eo 'href="luci-app-socat_.*?\.ipk"' | sed 's|href="||; s|"$||; s|^|https://downloads.immortalwrt.org/snapshots/packages/'$ARCH'/luci/|') && \
    curl -L -O $(curl -s https://downloads.immortalwrt.org/snapshots/packages/$ARCH/luci/ | grep -Eo 'href="luci-i18n-socat-zh-cn_.*?\.ipk"' | sed 's|href="||; s|"$||; s|^|https://downloads.immortalwrt.org/snapshots/packages/'$ARCH'/luci/|') && \
    curl -L -O $(curl -s https://downloads.immortalwrt.org/snapshots/packages/$ARCH/luci/ | grep -Eo 'href="luci-app-homeproxy_.*?\.ipk"' | sed 's|href="||; s|"$||; s|^|https://downloads.immortalwrt.org/snapshots/packages/'$ARCH'/luci/|') && \
    curl -L -O $(curl -s https://downloads.immortalwrt.org/snapshots/packages/$ARCH/luci/ | grep -Eo 'href="luci-i18n-homeproxy-zh-cn_.*?\.ipk"' | sed 's|href="||; s|"$||; s|^|https://downloads.immortalwrt.org/snapshots/packages/'$ARCH'/luci/|') && \
    curl -L -O $(curl -s https://downloads.immortalwrt.org/snapshots/packages/$ARCH/packages/ | grep -Eo 'href="chinadns-ng_.*?\.ipk"' | sed 's|href="||; s|"$||; s|^|https://downloads.immortalwrt.org/snapshots/packages/'$ARCH'/packages/|') && \
    miho_mo=$(curl -sX GET "https://api.github.com/repos/morytyann/OpenWrt-mihomo/releases/latest" \
      | awk '/tag_name/{print $4;exit}' FS='[""]' \
      | sed 's/"//g;s/v//g;s/release-//g') && \
    curl -L -o ./miho_mo.tar.gz https://github.com/morytyann/OpenWrt-mihomo/releases/download/v${miho_mo}/mihomo_$ARCH-openwrt-23.05.tar.gz && \
    tar -zxf ./miho_mo.tar.gz &&  rm -rf ./miho_mo.tar.gz && \
    opkg install /tmp/ipk/*.ipk && rm -rf /tmp/ipk/* && \
    curl -L -O $(curl -s https://downloads.immortalwrt.org/snapshots/packages/$ARCH/luci/ | grep -Eo 'href="luci-app-daed.*?\.ipk"' | sed 's|href="||; s|"$||; s|^|https://downloads.immortalwrt.org/snapshots/packages/'$ARCH'/luci/|') && \
    curl -L -O $(curl -s https://downloads.immortalwrt.org/snapshots/packages/$ARCH/luci/ | grep -Eo 'href="luci-i18n-daed-zh-cn_.*?\.ipk"' | sed 's|href="||; s|"$||; s|^|https://downloads.immortalwrt.org/snapshots/packages/'$ARCH'/luci/|') && \
    curl -L -O $(curl -s https://downloads.immortalwrt.org/snapshots/packages/$ARCH/packages/ | grep -Eo 'href="daed.*?\.ipk"' | sed 's|href="||; s|"$||; s|^|https://downloads.immortalwrt.org/snapshots/packages/'$ARCH'/packages/|') && \
    opkg install --force-depends /tmp/ipk/*.ipk && rm -rf /tmp/ipk/ && cd /tmp && \
    mkdir ./ddns-go && cd ./ddns-go && \
    ddns_go=$(curl -sX GET "https://api.github.com/repos/jeessy2/ddns-go/releases/latest" \
      | awk '/tag_name/{print $4;exit}' FS='[""]' \
      | sed 's/"//g;s/v//g;s/release-//g') && \
    curl -L -o ./ddns-go.tar.gz https://github.com/jeessy2/ddns-go/releases/download/v${ddns_go}/ddns-go_${ddns_go}_linux_$ARCH.tar.gz && \
    tar -zxf ./ddns-go.tar.gz && mv ddns-go /usr/bin/ && chmod +x /usr/bin/ddns-go && rm -rf /tmp/ddns-go && cd /tmp && \
    adg_h=$(curl -sX GET "https://api.github.com/repos/AdguardTeam/AdGuardHome/releases/latest" \
      | awk '/tag_name/{print $4;exit}' FS='[""]' \
      | sed 's/"//g;s/v//g;s/release-//g') && \
    curl -L -o ./AdGuardHome.tar.gz https://github.com/AdguardTeam/AdGuardHome/releases/download/v${adg_h}/AdGuardHome_linux_amd64.tar.gz && \
    tar -zxf ./AdGuardHome*.tar.gz && mv ./AdGuardHome/AdGuardHome /usr/bin/ && chmod +x /usr/bin/AdGuardHome && rm -rf AdGuardHome* && \
    curl -L -o /usr/share/v2ray/geosite.dat $GEO_SITE && \
    curl -L -o /usr/share/v2ray/geoip.dat $GEO_IP && \
    mkdir -p /etc/openclash/core && \
    ln -s /usr/bin/mihomo /etc/openclash/core/clash_meta && \
    curl -L -o /etc/openclash/Country.mmdb $GEO_MMDB && \
    ln -s /usr/share/v2ray/geosite.dat /etc/openclash/GeoSite.dat && \
    ln -s /usr/share/v2ray/geoip.dat /etc/openclash/GeoIP.dat && \
    curl -L -o /etc/homeproxy/resources/china_list.txt $CN_LIST && sed -i 's/^+\.//' /etc/homeproxy/resources/china_list.txt && \
    curl -L -o /etc/openclash/accelerated-domains.china.conf $Domains_china && \
    sed -i '/microsoft/d; /live\.com/d; /office\.net/d; /onedrive/d; /youtube/d; /twnic\.tw/d; /opendns\.com/d; /akadns/d; /msedge/d; /edgekey/d; /akamai/d; /mktossl/d; /mktoweb/d; /amazon/d; /awsdns/d; /fastly/d; /bing/d; /mktoweb/d; /mozilla/d' /etc/openclash/accelerated-domains.china.conf

#AdGuardHome --no-check-update -c /etc/adguardhome/conf/AdGuardHome.yaml -w /etc/adguardhome/work -s install

# daed
#nohup /usr/bin/daed run -c /etc/daed/ > /dev/null 2>&1 &

# ddns-go
#nohup ddns-go -c /etc/ddns-go/ddns-go-config.yaml > /dev/null 2>&1 &

#EXPOSE 80
