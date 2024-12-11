FROM alpine:latest AS builder

ARG OPVER=https://downloads.openwrt.org/releases/24.10-SNAPSHOT/targets/x86/64
ARG ARCH=x86_64
ARG IMMORTAL=https://downloads.immortalwrt.org/releases/packages-24.10/x86_64
ARG GEO_MMDB=https://github.com/MetaCubeX/meta-rules-dat/raw/refs/heads/release/country.mmdb
ARG GEO_SITE=https://github.com/MetaCubeX/meta-rules-dat/raw/refs/heads/release/geosite.dat
ARG GEO_IP=https://github.com/MetaCubeX/meta-rules-dat/raw/refs/heads/release/geoip.dat
ARG CN_LIST=https://github.com/MetaCubeX/meta-rules-dat/raw/refs/heads/meta/geo/geosite/cn.list
ARG ASN_DB=https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/GeoLite2-ASN.mmdb
ARG META_DB=https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip.metadb
ARG Domains_china=https://github.com/felixonmars/dnsmasq-china-list/raw/master/accelerated-domains.china.conf

RUN apk add --no-cache curl jq grep sed wget && \
    ROOTFS_URL=$(curl -s $OPVER/ | grep -Eo 'href="openwrt-.*?x86-64-rootfs\.tar.gz"' | sed 's|href="||; s|"$||; s|^|'$OPVER'/|') && \
    echo "$ROOTFS_URL" && \
    curl -L -o /rootfs.tar.gz $ROOTFS_URL && \
    mkdir -p /rootfs && \
    tar -zxf /rootfs.tar.gz -C /rootfs/ --strip-components 1

RUN set -ex && \
    mkdir -p /tmp/ipk /tmp/core /tmp/data && cd /tmp/ipk && \
    # OpenClash
    curl -sL https://api.github.com/repos/vernesong/OpenClash/releases \
    | jq -r '.[0].assets[] | select(.browser_download_url | test("luci-app-openclash_.*_all.ipk$")) | .browser_download_url' \
    | wget -qi - && \
    # immortalwrt
    curl -L -O $(curl -s $IMMORTAL/luci/ | grep -Eo 'href="luci-app-socat_.*?\.ipk"' | sed 's|href="||; s|"$||; s|^|'$IMMORTAL'/luci/|') && \
    curl -L -O $(curl -s $IMMORTAL/luci/ | grep -Eo 'href="luci-i18n-socat-zh-cn_.*?\.ipk"' | sed 's|href="||; s|"$||; s|^|'$IMMORTAL'/luci/|') && \
    curl -L -O $(curl -s $IMMORTAL/luci/ | grep -Eo 'href="luci-app-homeproxy_.*?\.ipk"' | sed 's|href="||; s|"$||; s|^|'$IMMORTAL'/luci/|') && \
    curl -L -O $(curl -s $IMMORTAL/luci/ | grep -Eo 'href="luci-i18n-homeproxy-zh-cn_.*?\.ipk"' | sed 's|href="||; s|"$||; s|^|'$IMMORTAL'/luci/|') && \
    curl -L -O $(curl -s $IMMORTAL/packages/ | grep -Eo 'href="chinadns-ng_.*?\.ipk"' | sed 's|href="||; s|"$||; s|^|'$IMMORTAL'/packages/|') && \
    curl -L -O $(curl -s $IMMORTAL/packages/ | grep -Eo 'href="libcron_.*?\.ipk"' | sed 's|href="||; s|"$||; s|^|'$IMMORTAL'/packages/|') && \
    # OpenWrt-mihomo
    curl -sL https://api.github.com/repos/morytyann/OpenWrt-mihomo/releases/latest \
    | jq -r '.assets[] | select(.browser_download_url | test("mihomo_'$ARCH'-openwrt-24.10.tar.gz$")) | .browser_download_url' \
    | wget -qi - && \
    tar -zxf ./mihomo_*.tar.gz && rm -rf mihomo_*.tar.gz && \
    # luci-app-daed
    curl -sL https://api.github.com/repos/QiuSimons/luci-app-daed/releases/latest \
    | jq -r '.assets[] | select(.browser_download_url | test("daed.*'$ARCH'.ipk$")) | .browser_download_url' \
    | wget -qi - && \
    curl -sL https://api.github.com/repos/QiuSimons/luci-app-daed/releases/latest \
    | jq -r '.assets[] | select(.browser_download_url | test("luci-.*_all.ipk$")) | .browser_download_url' \
    | wget -qi - && \
    cd /tmp && \
    # sing-box
    curl -sL https://api.github.com/repos/SagerNet/sing-box/releases/latest \
    | jq -r '.assets[] | select(.browser_download_url | test("sing-box-.*-linux-amd64.tar.gz$")) | .browser_download_url' \
    | wget -qi - && \
    tar -zxf ./sing-box*.tar.gz && mv -f sing-box-*/sing-box /tmp/core && rm -rf sing-box* && \
    # mihomo
    curl -sL https://api.github.com/repos/MetaCubeX/mihomo/releases/latest \
    | jq -r '.assets[] | select(.browser_download_url | test("mihomo-linux-amd64-compatible-v.*.gz$")) | .browser_download_url' \
    | wget -qi - && \
    gzip -d ./mihomo*.gz && mv -f mihomo* /tmp/core/mihomo && \
    # daed
    #curl -sL https://api.github.com/repos/daeuniverse/daed/releases/latest \
    #| jq -r '.assets[] | select(.browser_download_url | test("daed-linux-'$ARCH'.zip$")) | .browser_download_url' \
    #| wget -qi - && \
    #unzip -qo ./daed*.zip && mv -f daed-linux-x86_64 /tmp/core/daed && rm -rf daed*.zip && \
    # curl
    curl -sL https://api.github.com/repos/stunnel/static-curl/releases/latest \
    | jq -r '.assets[] | select(.browser_download_url | test("curl-linux-x86_64-glibc-.*.tar.xz$")) | .browser_download_url' \
    | wget -qi - && \
    tar -xJf ./curl*.tar.xz && mv -f curl /tmp/core && rm -rf curl* && \
    cd /tmp/data && \
    curl -L -o ./geosite.dat $GEO_SITE && \
    curl -L -o ./geoip.dat $GEO_IP && \
    curl -L -o ./ASN.mmdb $ASN_DB && \
    curl -L -o ./geoip.metadb $META_DB && \
    curl -L -o metacubexd.zip https://github.com/MetaCubeX/metacubexd/archive/refs/heads/gh-pages.zip && unzip -qo metacubexd.zip && rm -rf metacubexd.zip && mv metacubexd* metacubexd && \
    curl -L -o ./Country.mmdb $GEO_MMDB && \
    curl -L -o ./china_list.txt $CN_LIST && sed -i 's/^+\.//' ./china_list.txt && \
    curl -L -o ./accelerated-domains.china.conf $Domains_china && \
    sed -i '/microsoft/d; /live\.com/d; /office\.net/d; /onedrive/d; /youtube/d; /twnic\.tw/d; /opendns\.com/d; /akadns/d; /msedge/d; /edgekey/d; /akamai/d; /mktossl/d; /mktoweb/d; /amazon/d; /awsdns/d; /fastly/d; /bing/d; /mktoweb/d; /mozilla/d' ./accelerated-domains.china.conf

FROM scratch
COPY --from=builder /rootfs/ /
COPY --from=builder /tmp/ipk/ /tmp/ipk/
COPY --from=builder /tmp/core/ /tmp/core/
COPY --from=builder /tmp/data/ /tmp/data/

USER root

RUN set -ex && \
    echo -e "$(uname -r)" && mkdir /var/lock && \
    opkg update && \
    sed -i "s/SNAPSHOT/SNAPSHOT $(TZ=UTC-8 date +"%Y%m%d")/g" /etc/openwrt_release && \
    opkg remove --force-remove dnsmasq && \
    opkg install coreutils-nohup \
    bash curl ca-certificates \
    ipset ip-full libcap libcap-bin \
    ruby ruby-yaml kmod-tun kmod-inet-diag \
    unzip kmod-nft-tproxy luci-compat luci \
    luci-base luci-i18n-base-zh-cn \
    luci-i18n-firewall-zh-cn \
    luci-i18n-package-manager-zh-cn \
    nano wget openssh-sftp-server \
    kmod-veth \
    openssl-util xxd coreutils-base64

RUN set -ex && \
    mkdir -p /tmp/daed && mv /tmp/ipk/*daed* /tmp/daed && mv /tmp/ipk/libcron* /tmp/daed && \
    opkg install --force-depends --force-overwrite /tmp/daed/*.ipk && rm -rf /tmp/daed && \
    opkg install /tmp/ipk/*.ipk && rm -rf /tmp/ipk && \
    chown -R root:root /tmp/core /tmp/data && \
    chmod +x /tmp/core/* && mv -f /tmp/core/* /usr/bin && rm -rf /tmp/core && \
    mv /tmp/data/geosite.dat /usr/share/v2ray/geosite.dat && \
    mv /tmp/data/geoip.dat /usr/share/v2ray/geoip.dat && \
    mkdir -p /etc/mihomo/run/ui && \
    mv /tmp/data/ASN.mmdb /etc/mihomo/run/ASN.mmdb && \
    mv /tmp/data/geoip.metadb /etc/mihomo/run/geoip.metadb && \
    ln -s /usr/share/v2ray/geosite.dat /etc/mihomo/run/geosite.dat && \
    ln -s /usr/share/v2ray/geoip.dat /etc/mihomo/run/geoip.dat && \
    mv /tmp/data/metacubexd /etc/mihomo/run/ui && \
    mkdir -p /etc/openclash/core && \
    ln -s /usr/bin/mihomo /etc/openclash/core/clash_meta && \
    mv /tmp/data/Country.mmdb /etc/openclash/Country.mmdb && \
    rm -rf /etc/openclash/GeoSite.dat /etc/openclash/GeoIP.dat && \
    ln -s /usr/share/v2ray/geosite.dat /etc/openclash/GeoSite.dat && \
    ln -s /usr/share/v2ray/geoip.dat /etc/openclash/GeoIP.dat && \
    mv /tmp/data/china_list.txt /etc/homeproxy/resources/china_list.txt && \
    mv /tmp/data/accelerated-domains.china.conf /etc/openclash/accelerated-domains.china.conf && \
    if grep -q '^mihomo:' /etc/group; then \
      chown root:mihomo /usr/bin/mihomo; \
    else \
      echo "group none"; \
    fi && \
    rm -rf /var/cache/* /var/log/*

# EXPOSE 22 80 443
CMD ["/sbin/init"]
#AdGuardHome --no-check-update -c /etc/adguardhome/conf/AdGuardHome.yaml -w /etc/adguardhome/work -s install

# daed
#nohup /usr/bin/daed run -c /etc/daed/ > /dev/null 2>&1 &

# ddns-go
#nohup ddns-go -c /etc/ddns-go/ddns-go-config.yaml > /dev/null 2>&1 &

#EXPOSE 80
