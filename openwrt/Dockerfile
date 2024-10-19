FROM ghcr.io/openwrt/rootfs:x86_64
# stable x86_64-23.05.2
# https://github.com/openwrt/docker

ARG Build_Time=$Build_Time
ARG Open_Clash=$Open_Clash
ARG CORE_MATE=$CORE_MATE
ARG ddns_go=$ddns_go
ARG adg_h=$adg_h
ARG daed_v=$daed_v

ARG GEO_MMDB=https://github.com/alecthw/mmdb_china_ip_list/raw/release/lite/Country.mmdb
ARG GEO_SITE=https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geosite.dat
ARG GEO_IP=https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geoip.dat
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
    luci-i18n-opkg-zh-cn luci-i18n-firewall-zh-cn \
    ddns-scripts-cloudflare luci-i18n-ddns-zh-cn \
    nano unzip wget openssh-sftp-server \
    kmod-veth \
    openssl-util xxd coreutils-base64
RUN set -ex && \
    mkdir -p /tmp/ipk && cd /tmp && \
    Open_Clash=$(curl -sX GET "https://api.github.com/repos/vernesong/OpenClash/releases" \
      | awk '/tag_name/{print $4;exit}' FS='[""]' \
      | sed 's/"//g;s/v//g;s/release-//g') && \
    curl -L -o /tmp/ipk/luci-app-openclash.ipk https://github.com/vernesong/OpenClash/releases/download/v${Open_Clash}/luci-app-openclash_${Open_Clash}_all.ipk && \
    luci_socat=$(curl -sX GET "https://api.github.com/repos/chenmozhijin/luci-app-socat/releases/latest" \
      | awk '/tag_name/{print $4;exit}' FS='[""]' \
      | sed 's/"//g;s/v//g;s/release-//g') && \
    curl -L -o /tmp/ipk/luci-app-socat.ipk https://github.com/chenmozhijin/luci-app-socat/releases/download/v${luci_socat}/luci-app-socat_${luci_socat}_all.ipk && \
    curl -L -o /tmp/ipk/luci-i18n-socat-zh-cn.ipk https://github.com/chenmozhijin/luci-app-socat/releases/download/v${luci_socat}/luci-i18n-socat-zh-cn_${luci_socat}_all.ipk && \
    mkdir ./ddns-go && cd ./ddns-go && \
    ddns_go=$(curl -sX GET "https://api.github.com/repos/jeessy2/ddns-go/releases/latest" \
      | awk '/tag_name/{print $4;exit}' FS='[""]' \
      | sed 's/"//g;s/v//g;s/release-//g') && \
    curl -L -o ./ddns-go.tar.gz https://github.com/jeessy2/ddns-go/releases/download/v${ddns_go}/ddns-go_${ddns_go}_linux_x86_64.tar.gz && \
    tar -zxf ./ddns-go.tar.gz && mv ddns-go /usr/bin/ && chmod +x /usr/bin/ddns-go && rm -rf /ddns-go && cd /tmp && \
    adg_h=$(curl -sX GET "https://api.github.com/repos/AdguardTeam/AdGuardHome/releases/latest" \
      | awk '/tag_name/{print $4;exit}' FS='[""]' \
      | sed 's/"//g;s/v//g;s/release-//g') && \
    curl -L -o ./AdGuardHome.tar.gz https://github.com/AdguardTeam/AdGuardHome/releases/download/v${adg_h}/AdGuardHome_linux_amd64.tar.gz && \
    tar -zxf ./AdGuardHome*.tar.gz && mv ./AdGuardHome/AdGuardHome /usr/bin/ && chmod +x /usr/bin/AdGuardHome && rm -rf AdGuardHome* && \
    opkg install /tmp/ipk/*.ipk && \
    mkdir -p /etc/openclash/core && \
    curl -L -o /etc/openclash/Country.mmdb $GEO_MMDB && \
    curl -L -o /etc/openclash/GeoSite.dat $GEO_SITE && \
    curl -L -o /etc/openclash/GeoIP.dat $GEO_IP && \
    curl -L -o /etc/openclash/accelerated-domains.china.conf $Domains_china && \
    sed -i '/microsoft/d; /live\.com/d; /office\.net/d; /onedrive/d; /youtube/d; /twnic\.tw/d; /opendns\.com/d; /akadns/d; /msedge/d; /edgekey/d; /akamai/d; /mktossl/d; /mktoweb/d; /amazon/d; /awsdns/d; /fastly/d; /bing/d; /mktoweb/d; /mozilla/d' /etc/openclash/accelerated-domains.china.conf && \
    CORE_MATE=$(curl -sX GET "https://api.github.com/repos/MetaCubeX/mihomo/releases/latest" \
      | awk '/tag_name/{print $4;exit}' FS='[""]' \
      | sed 's/"//g;s/v//g;s/release-//g') && \
    curl -L -o /tmp/clash_meta.gz.ipk https://github.com/MetaCubeX/mihomo/releases/download/v${CORE_MATE}/mihomo-linux-amd64-compatible-v${CORE_MATE}.gz && \
    gzip -d clash_meta.gz && mv clash_meta /etc/openclash/core && chmod a+x /etc/openclash/core/* && \
    daed_v=$(curl -sX GET "https://api.github.com/repos/daeuniverse/daed/releases/latest" \
      | awk '/tag_name/{print $4;exit}' FS='[""]' \
      | sed 's/"//g;s/v//g;s/release-//g') && \
    curl -L -o daed-linux-x86_64.zip https://github.com/daeuniverse/daed/releases/download/v${daed_v}/daed-linux-x86_64.zip && \
    unzip -d daed daed-linux-x86_64.zip && mv daed/daed-linux-x86_64 /usr/bin/daed && chmod +x /usr/bin/daed && rm -rf daed* && \
    mkdir -p /usr/share/daed && \
    ln -s /etc/openclash/GeoSite.dat /usr/share/daed/geosite.dat && \
    ln -s /etc/openclash/GeoIP.dat /usr/share/daed/geoip.dat && \
    rm -rf /tmp/*

#AdGuardHome --no-check-update -c /etc/adguardhome/conf/AdGuardHome.yaml -w /etc/adguardhome/work -s install

# daed
#nohup /usr/bin/daed run -c /etc/daed/ > /dev/null 2>&1 &

# ddns-go
#nohup ddns-go -c /etc/ddns-go/ddns-go-config.yaml > /dev/null 2>&1 &

#EXPOSE 80
