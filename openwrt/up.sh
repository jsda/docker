getversion(){
wget --no-check-certificate -qO- https://api.github.com/repos/$1/tags \
| grep 'name' | cut -d\" -f4 \
| head -1 | sed 's/"//g;s/v//g' \
| sed 's/release-//g'
}

#Open_Clash
export Open_Clash=https://github.com/vernesong/OpenClash/releases/download/v$(getversion vernesong/OpenClash)/luci-app-openclash_$(getversion vernesong/OpenClash)_all.ipk
mkdir -p ipk
if curl -sfL -o ./ipk/luci-app-openclash.ipk $Open_Clash; then
	echo "openclash下载成功"
else
	echo "openclash下载失败"
	exit 1
fi
#预置OpenClash内核和GEO数据https://github.com/VIKINGYFY/OpenWRT-CI
export CORE_VER=https://raw.githubusercontent.com/vernesong/OpenClash/core/dev/core_version
export CORE_TUN=https://github.com/vernesong/OpenClash/raw/core/dev/premium/clash-linux
export CORE_DEV=https://github.com/vernesong/OpenClash/raw/core/dev/dev/clash-linux
export CORE_MATE=https://github.com/vernesong/OpenClash/raw/core/dev/meta/clash-linux

export CORE_TYPE=amd64
export TUN_VER=$(curl -sfL $CORE_VER | sed -n "2{s/\r$//;p;q}")

export GEO_MMDB=https://github.com/alecthw/mmdb_china_ip_list/raw/release/lite/Country.mmdb
export GEO_SITE=https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geosite.dat
export GEO_IP=https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geoip.dat
export Domains_china=https://github.com/felixonmars/dnsmasq-china-list/raw/master/accelerated-domains.china.conf

mkdir -p openclash

curl -sfL -o ./openclash/Country.mmdb $GEO_MMDB | echo "GEO_MMDB下载成功" || echo "GEO_MMDB下载失败"
curl -sfL -o ./openclash/GeoSite.dat $GEO_SITE | echo "GEO_SITE下载成功" || echo "GEO_SITE下载失败"
curl -sfL -o ./openclash/GeoIP.dat $GEO_IP | echo "GEO_IP下载成功" || echo "GEO_IP下载失败"
curl -sfL -o ./openclash/accelerated-domains.china.conf $Domains_china | echo "Domains_china下载成功" || echo "Domains_china下载失败"

mkdir ./core && cd ./core

if curl -sfL -o ./tun.gz "$CORE_TUN"-"$CORE_TYPE"-"$TUN_VER".gz; then
	echo "tun下载成功"
else
	echo "tun下载失败"
  	exit 1
fi
gzip -d ./tun.gz && mv ./tun ./clash_tun

if curl -sfL -o ./meta.tar.gz "$CORE_MATE"-"$CORE_TYPE".tar.gz; then
	echo "meta下载成功"
else
	echo "meta下载失败"
	exit 1
fi
tar -zxf ./meta.tar.gz && mv ./clash ./clash_meta

if curl -sfL -o ./dev.tar.gz "$CORE_DEV"-"$CORE_TYPE".tar.gz; then
	echo "CORE_DEV下载成功"
else
	echo "CORE_DEV下载失败"
	exit 1
fi
tar -zxf ./dev.tar.gz

chmod +x ./clash* ; rm -rf ./*.gz

cd ../ && mv ./core ./openclash

#ddns-go
curl -s https://api.github.com/repos/sirpdboy/luci-app-ddns-go/releases/latest \
| grep "browser_download_url.*ddns-go.*.ipk" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -qi -
if mv *.ipk ./ipk; then
	echo "ddns-go下载成功"
else
	echo "ddns-go下载失败"
	exit 1
fi

# luci-app-socat
curl -s https://api.github.com/repos/chenmozhijin/luci-app-socat/releases/latest \
| grep "browser_download_url.*socat.*.ipk" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -qi -
if mv *.ipk ./ipk; then
	echo "luci-app-socat下载成功"
else
	echo "luci-app-socat下载失败"
	exit 1
fi