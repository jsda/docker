# syntax=docker/dockerfile:labs

FROM alpine:latest AS builder

ARG GITHUB_TOKEN
ARG OPVER=https://downloads.openwrt.org/releases/24.10-SNAPSHOT/targets/x86/64
ARG ARCH=x86_64
ARG IMMORTAL=https://immortalwrt.kyarucloud.moe/releases/packages-24.10/x86_64
ARG GEO_SITE=https://github.com/MetaCubeX/meta-rules-dat/raw/refs/heads/release/geosite.dat
ARG GEO_IP=https://github.com/MetaCubeX/meta-rules-dat/raw/refs/heads/release/geoip.dat
ARG CN_LIST=https://github.com/MetaCubeX/meta-rules-dat/raw/refs/heads/meta/geo/geosite/cn.list
ARG ASN_DB=https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/GeoLite2-ASN.mmdb
ARG META_DB=https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip.metadb

RUN apk add --no-cache curl jq grep sed wget && \
    ROOTFS_URL=$(curl -s $OPVER/ | grep -Eo 'href="openwrt-.*?x86-64-rootfs\.tar.gz"' | sed 's|href="||; s|"$||; s|^|'$OPVER'/|') && \
    echo "$ROOTFS_URL" && \
    curl -sL -o /rootfs.tar.gz $ROOTFS_URL && \
    mkdir -p /rootfs && \
    tar -zxf /rootfs.tar.gz -C /rootfs/ --strip-components 1

RUN --mount=type=secret,id=github_token \
    TOKEN=$(cat /run/secrets/github_token) && \
    set -ex && \
    mkdir -p /tmp/ipk /tmp/core /tmp/data && cd /tmp/ipk && \
    # immortalwrt
    # curl -sL -O $(curl -s $IMMORTAL/luci/ | grep -Eo 'href="luci-app-socat_.*?\.ipk"' | sed 's|href="||; s|"$||; s|^|'$IMMORTAL'/luci/|') && \
    # curl -sL -O $(curl -s $IMMORTAL/luci/ | grep -Eo 'href="luci-i18n-socat-zh-cn_.*?\.ipk"' | sed 's|href="||; s|"$||; s|^|'$IMMORTAL'/luci/|') && \
    curl -sL -O $(curl -s $IMMORTAL/luci/ | grep -Eo 'href="luci-app-homeproxy_.*?\.ipk"' | sed 's|href="||; s|"$||; s|^|'$IMMORTAL'/luci/|') && \
    curl -sL -O $(curl -s $IMMORTAL/luci/ | grep -Eo 'href="luci-i18n-homeproxy-zh-cn_.*?\.ipk"' | sed 's|href="||; s|"$||; s|^|'$IMMORTAL'/luci/|') && \
    curl -sL -O $(curl -s $IMMORTAL/packages/ | grep -Eo 'href="chinadns-ng_.*?\.ipk"' | sed 's|href="||; s|"$||; s|^|'$IMMORTAL'/packages/|') && \
    curl -sL -O $(curl -s $IMMORTAL/luci/ | grep -Eo 'href="luci-app-daed.*?\.ipk"' | sed 's|href="||; s|"$||; s|^|'$IMMORTAL'/luci/|') && \
    curl -sL -O $(curl -s $IMMORTAL/luci/ | grep -Eo 'href="luci-i18n-daed-zh-cn_.*?\.ipk"' | sed 's|href="||; s|"$||; s|^|'$IMMORTAL'/luci/|') && \
    curl -sL -O $(curl -s $IMMORTAL/packages/ | grep -Eo 'href="daed_.*?\.ipk"' | sed 's|href="||; s|"$||; s|^|'$IMMORTAL'/packages/|') && \
    curl -sL -O $(curl -s $IMMORTAL/packages/ | grep -Eo 'href="daed-geosite_.*?\.ipk"' | sed 's|href="||; s|"$||; s|^|'$IMMORTAL'/packages/|') && \
    curl -sL -O $(curl -s $IMMORTAL/packages/ | grep -Eo 'href="daed-geoip_.*?\.ipk"' | sed 's|href="||; s|"$||; s|^|'$IMMORTAL'/packages/|') && \
    curl -sL -O $(curl -s $IMMORTAL/packages/ | grep -Eo 'href="libcron_.*?\.ipk"' | sed 's|href="||; s|"$||; s|^|'$IMMORTAL'/packages/|') && \
    # OpenWrt-nikki
    curl -H "Authorization: Bearer ${TOKEN}" -sL "https://api.github.com/repos/nikkinikki-org/OpenWrt-nikki/releases/latest \
    | jq -r '.assets[] | select(.browser_download_url | test("nikki_'$ARCH'-openwrt-24.10.tar.gz$")) | .browser_download_url' \
    | wget -qi - && \
    tar -zxf ./nikki_*.tar.gz && rm -rf nikki_*.tar.gz && \
    cd /tmp && \
    # sing-box
    curl -H "Authorization: Bearer ${TOKEN}" -sL "https://api.github.com/repos/SagerNet/sing-box/releases/latest \
    | jq -r '.assets[] | select(.browser_download_url | test("sing-box-.*-linux-amd64.tar.gz$")) | .browser_download_url' \
    | wget -qi - && \
    tar -zxf ./sing-box*.tar.gz && mv -f sing-box-*/sing-box /tmp/core && rm -rf sing-box* && \
    # mihomo
    curl -H "Authorization: Bearer ${TOKEN}" -sL "https://api.github.com/repos/MetaCubeX/mihomo/releases/latest \
    | jq -r '.assets[] | select(.browser_download_url | test("mihomo-linux-amd64-compatible-v.*.gz$")) | .browser_download_url' \
    | wget -qi - && \
    gzip -d ./mihomo*.gz && mv -f mihomo* /tmp/core/mihomo && \
    # daed
    #curl -H "Authorization: Bearer ${TOKEN}" -sL "https://api.github.com/repos/QiuSimons/luci-app-daed/releases/latest \
    #| jq -r '.assets[] | select(.browser_download_url | test("daed.*'$ARCH'.ipk$")) | .browser_download_url' \
    #| wget -qi - && \
    #tar -zxf ./daed*.ipk -C . ./data.tar.gz && tar -zxf ./data.tar.gz --strip-components=3 -C . ./usr/bin/daed && mv daed /tmp/core && rm -rf daed* data.tar.gz && \
    curl -H "Authorization: Bearer ${TOKEN}" -sL "https://api.github.com/repos/daeuniverse/daed/releases/latest \
    | jq -r '.assets[] | select(.browser_download_url | test("daed-linux-'$ARCH'.zip$")) | .browser_download_url' \
    | wget -qi - && \
    unzip -qo ./daed*.zip && mv -f daed-linux-x86_64 /tmp/core/daed && rm -rf daed* && \
    # curl
    curl -H "Authorization: Bearer ${TOKEN}" -sL "https://api.github.com/repos/stunnel/static-curl/releases/latest \
    | jq -r '.assets[] | select(.browser_download_url | test("curl-linux-x86_64-glibc-.*.tar.xz$")) | .browser_download_url' \
    | wget -qi - && \
    tar -xJf ./curl*.tar.xz && mv -f curl /tmp/core && rm -rf curl* && \
    cd /tmp/data && \
    curl -sL -o ./geosite.dat $GEO_SITE && \
    curl -sL -o ./geoip.dat $GEO_IP && \
    curl -sL -o ./ASN.mmdb $ASN_DB && \
    curl -sL -o ./geoip.metadb $META_DB && \
    curl -sL -o metacubexd.zip https://github.com/MetaCubeX/metacubexd/archive/refs/heads/gh-pages.zip && unzip -qo metacubexd.zip && rm -rf metacubexd.zip && mv metacubexd* metacubexd && \
    curl -sL -o ./china_list.txt $CN_LIST && sed -i 's/^+\.//' ./china_list.txt

FROM scratch
COPY --from=builder /rootfs/ /
COPY --from=builder /tmp/ipk/ /tmp/ipk/
COPY --from=builder /tmp/core/ /tmp/core/
COPY --from=builder /tmp/data/ /tmp/data/

USER root

RUN set -ex && \
    mkdir /var/lock && \
    echo "$(TZ=UTC-8 date +"%Y%m%d")" > /etc/openwrt_version && \
    opkg update && \
    opkg remove --force-remove dnsmasq && \
    opkg install \
    dnsmasq-full \
    bash \
    zoneinfo-asia \
    luci-compat \
    luci-i18n-base-zh-cn \
    luci-i18n-firewall-zh-cn \
    luci-i18n-package-manager-zh-cn \
    luci-i18n-ddns-zh-cn ddns-scripts-cloudflare ddns-scripts-dnspod \
    nano \
    openssh-sftp-server \
    kmod-veth \
    openssl-util xxd coreutils-base64

RUN set -ex && \
    mkdir -p /tmp/daed && mv /tmp/ipk/*daed* /tmp/daed && mv /tmp/ipk/libcron* /tmp/daed && \
    opkg install /tmp/ipk/*.ipk && rm -rf /tmp/ipk && \
    opkg install --force-depends --force-overwrite /tmp/daed/*.ipk && rm -rf /tmp/daed && \
    chown -R root:root /tmp/core /tmp/data && \
    chmod +x /tmp/core/* && mv -f /tmp/core/* /usr/bin && rm -rf /tmp/core && \
    mv /tmp/data/geosite.dat /usr/share/v2ray/geosite.dat && \
    mv /tmp/data/geoip.dat /usr/share/v2ray/geoip.dat && \
    mkdir -p /etc/nikki/run/ui && \
    mv /tmp/data/ASN.mmdb /etc/nikki/run/ASN.mmdb && \
    mv /tmp/data/geoip.metadb /etc/nikki/run/geoip.metadb && \
    ln -s /usr/share/v2ray/geosite.dat /etc/nikki/run/geosite.dat && \
    ln -s /usr/share/v2ray/geoip.dat /etc/nikki/run/geoip.dat && \
    mv /tmp/data/metacubexd /etc/nikki/run/ui && \
    mv /tmp/data/china_list.txt /etc/homeproxy/resources/china_list.txt && \
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

#EXPOSE 80
