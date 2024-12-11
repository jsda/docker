ARG OPVER=https://downloads.openwrt.org/releases/24.10-SNAPSHOT/targets/x86/64

FROM alpine:latest AS builder

RUN apk add --no-cache curl grep sed

ARG OPVER
RUN ROOTFS_URL=$(curl -s $OPVER/ | grep -Eo 'href="openwrt-.*?x86-64-rootfs\.tar.gz"' | sed 's|href="||; s|"$||; s|^|'$OPVER'/|') && \
    echo "$ROOTFS_URL" && \
    curl -L -o /rootfs.tar.gz $ROOTFS_URL

FROM scratch
COPY --from=builder /rootfs.tar.gz /
RUN tar -xzf /rootfs.tar.gz -C /

# ARG Build_Time=$Build_Time
ARG ARCH=x86_64
ARG IMMORTAL=https://downloads.immortalwrt.org/releases/packages-23.05/x86_64
ARG GEO_MMDB=https://github.com/MetaCubeX/meta-rules-dat/raw/refs/heads/release/country.mmdb
ARG GEO_SITE=https://github.com/MetaCubeX/meta-rules-dat/raw/refs/heads/release/geosite.dat
ARG GEO_IP=https://github.com/MetaCubeX/meta-rules-dat/raw/refs/heads/release/geoip.dat
ARG CN_LIST=https://github.com/MetaCubeX/meta-rules-dat/raw/refs/heads/meta/geo/geosite/cn.list
ARG ASN_DB=https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/GeoLite2-ASN.mmdb
ARG META_DB=https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip.metadb
ARG Domains_china=https://github.com/felixonmars/dnsmasq-china-list/raw/master/accelerated-domains.china.conf

#COPY openwrt/ipk/* /app/

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
    luci-i18n-opkg-zh-cn \
    nano unzip wget openssh-sftp-server \
    kmod-veth \
    openssl-util xxd coreutils-base64
RUN set -ex && \
    mkdir -p /tmp/ipk && cd /tmp/ipk && \
    Open_Clash=$(curl -sX GET "https://api.github.com/repos/vernesong/OpenClash/releases" \
      | awk '/tag_name/{print $4;exit}' FS='[""]' \
      | sed 's/"//g;s/v//g;s/release-//g') && \
    curl -L -O https://github.com/vernesong/OpenClash/releases/download/v${Open_Clash}/luci-app-openclash_${Open_Clash}_all.ipk && \
    curl -L -O $(curl -s $IMMORTAL/luci/ | grep -Eo 'href="luci-app-socat_.*?\.ipk"' | sed 's|href="||; s|"$||; s|^|'$IMMORTAL'/luci/|') && \
    curl -L -O $(curl -s $IMMORTAL/luci/ | grep -Eo 'href="luci-i18n-socat-zh-cn_.*?\.ipk"' | sed 's|href="||; s|"$||; s|^|'$IMMORTAL'/luci/|') && \
    curl -L -O $(curl -s $IMMORTAL/luci/ | grep -Eo 'href="luci-app-homeproxy_.*?\.ipk"' | sed 's|href="||; s|"$||; s|^|'$IMMORTAL'/luci/|') && \
    curl -L -O $(curl -s $IMMORTAL/luci/ | grep -Eo 'href="luci-i18n-homeproxy-zh-cn_.*?\.ipk"' | sed 's|href="||; s|"$||; s|^|'$IMMORTAL'/luci/|') && \
    curl -L -O $(curl -s $IMMORTAL/packages/ | grep -Eo 'href="chinadns-ng_.*?\.ipk"' | sed 's|href="||; s|"$||; s|^|'$IMMORTAL'/packages/|') && \
    op_mihomo=$(curl -sX GET "https://api.github.com/repos/morytyann/OpenWrt-mihomo/releases/latest" \
      | awk '/tag_name/{print $4;exit}' FS='[""]' \
      | sed 's/"//g;s/v//g;s/release-//g') && \
    curl -L -o ./op_mihomo.tar.gz https://github.com/morytyann/OpenWrt-mihomo/releases/download/v${op_mihomo}/mihomo_$ARCH-openwrt-23.05.tar.gz && \
    tar -zxf ./op_mihomo.tar.gz && \
    opkg install /tmp/ipk/*.ipk && rm -rf /tmp/ipk/* && \
    sing_box=$(curl -sX GET "https://api.github.com/repos/SagerNet/sing-box/releases/latest" \
      | awk '/tag_name/{print $4;exit}' FS='[""]' \
      | sed 's/"//g;s/v//g;s/release-//g') && \
    curl -L -o ./sing_box.tar.gz https://github.com/SagerNet/sing-box/releases/download/v${sing_box}/sing-box-${sing_box}-linux-amd64.tar.gz && \
    tar -zxf ./sing_box*.tar.gz && mv -f sing-box-*/sing-box /usr/bin/sing-box && chown root:root /usr/bin/sing-box && chmod +x /usr/bin/sing-box && rm -rf /tmp/ipk/* && \
    miho_mo=$(curl -sX GET "https://api.github.com/repos/MetaCubeX/mihomo/releases/latest" \
      | awk '/tag_name/{print $4;exit}' FS='[""]' \
      | sed 's/"//g;s/v//g;s/release-//g') && \
    curl -L -o ./mihomo.gz https://github.com/MetaCubeX/mihomo/releases/download/v${miho_mo}/mihomo-linux-amd64-compatible-v${miho_mo}.gz && \
    gzip -d ./mihomo*.gz && mv -f mihomo /usr/bin/mihomo && chmod +x /usr/bin/mihomo && rm -rf /tmp/ipk/* && \
    if grep -q '^mihomo:' /etc/group; then \
      chown root:mihomo /usr/bin/mihomo; \
    else \
      echo "group none"; \
    fi && \
    curl -L -O $(curl -s $IMMORTAL/luci/ | grep -Eo 'href="luci-app-daed.*?\.ipk"' | sed 's|href="||; s|"$||; s|^|'$IMMORTAL'/luci/|') && \
    curl -L -O $(curl -s $IMMORTAL/luci/ | grep -Eo 'href="luci-i18n-daed-zh-cn_.*?\.ipk"' | sed 's|href="||; s|"$||; s|^|'$IMMORTAL'/luci/|') && \
    curl -L -O $(curl -s $IMMORTAL/packages/ | grep -Eo 'href="daed_.*?\.ipk"' | sed 's|href="||; s|"$||; s|^|'$IMMORTAL'/packages/|') && \
    curl -L -O $(curl -s $IMMORTAL/packages/ | grep -Eo 'href="daed-geosite_.*?\.ipk"' | sed 's|href="||; s|"$||; s|^|'$IMMORTAL'/packages/|') && \
    curl -L -O $(curl -s $IMMORTAL/packages/ | grep -Eo 'href="daed-geoip_.*?\.ipk"' | sed 's|href="||; s|"$||; s|^|'$IMMORTAL'/packages/|') && \
    opkg install --force-depends /tmp/ipk/*.ipk && rm -rf /tmp/ipk/* && \
    da_ed=$(curl -sX GET "https://api.github.com/repos/daeuniverse/daed/releases/latest" \
      | awk '/tag_name/{print $4;exit}' FS='[""]' \
      | sed 's/"//g;s/v//g;s/release-//g') && \
    curl -L -o ./da_ed.zip https://github.com/daeuniverse/daed/releases/download/v${da_ed}/daed-linux-$ARCH.zip && \
    unzip ./da_ed*.zip && mv -f daed-linux-x86_64 /usr/bin/daed && chmod +x /usr/bin/daed && rm -rf /tmp/ipk/ && \
    cd /tmp && \
    curl -L -o /usr/share/v2ray/geosite.dat $GEO_SITE && \
    curl -L -o /usr/share/v2ray/geoip.dat $GEO_IP && \
    mkdir -p /etc/mihomo/run/ui && \
    curl -L -o /etc/mihomo/run/ASN.mmdb $ASN_DB && \
    curl -L -o /etc/mihomo/run/geoip.metadb $META_DB && \
    ln -s /usr/share/v2ray/geosite.dat /etc/mihomo/run/geosite.dat && \
    ln -s /usr/share/v2ray/geoip.dat /etc/mihomo/run/geoip.dat && \
    cd /etc/mihomo/run/ui && \
    curl -L -o metacubexd.zip https://github.com/MetaCubeX/metacubexd/archive/refs/heads/gh-pages.zip && unzip metacubexd.zip && rm -rf metacubexd.zip && mv metacubexd* metacubexd && \
    mkdir -p /etc/openclash/core && \
    ln -s /usr/bin/mihomo /etc/openclash/core/clash_meta && \
    curl -L -o /etc/openclash/Country.mmdb $GEO_MMDB && \
    rm -rf /etc/openclash/GeoSite.dat /etc/openclash/GeoIP.dat && \
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
