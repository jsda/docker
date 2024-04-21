getversion(){
wget --no-check-certificate -qO- https://api.github.com/repos/$1/tags \
| grep 'name' | cut -d\" -f4 \
| head -1 | sed 's/"//g;s/v//g' \
| sed 's/release-//g'
}

echo -e "$(uname -r)" >> $GITHUB_STEP_SUMMARY
echo -e "当前流程工作路径：$PATH" >> $GITHUB_STEP_SUMMARY
echo -e "开始更新软件" >> $GITHUB_STEP_SUMMARY

#Open_Clash
export Open_Clash=https://github.com/vernesong/OpenClash/releases/download/v$(getversion vernesong/OpenClash)/luci-app-openclash_$(getversion vernesong/OpenClash)_all.ipk
mkdir -p ipk
if curl -sfL -o ./luci-app-openclash.ipk $Open_Clash; then
	mv *.ipk ./ipk
	echo "openclash下载成功" >> $GITHUB_STEP_SUMMARY
else
	echo "openclash下载失败" >> $GITHUB_STEP_SUMMARY
	exit 1
fi
#预置OpenClash内核和GEO数据https://github.com/VIKINGYFY/OpenWRT-CI
export CORE_VER=https://raw.githubusercontent.com/vernesong/OpenClash/core/master/core_version
export CORE_TUN=https://github.com/vernesong/OpenClash/raw/core/master/premium/clash-linux
export CORE_DEV=https://github.com/vernesong/OpenClash/raw/core/master/dev/clash-linux
export CORE_MATE=https://github.com/vernesong/OpenClash/raw/core/master/meta/clash-linux

export CORE_TYPE=amd64
export TUN_VER=$(curl -sfL $CORE_VER | sed -n "2{s/\r$//;p;q}")

export GEO_MMDB=https://github.com/alecthw/mmdb_china_ip_list/raw/release/lite/Country.mmdb
export GEO_SITE=https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geosite.dat
export GEO_IP=https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geoip.dat
export Domains_china=https://github.com/felixonmars/dnsmasq-china-list/raw/master/accelerated-domains.china.conf

mkdir -p openclash

curl -sfL -o ./openclash/Country.mmdb $GEO_MMDB && echo "GEO_MMDB下载成功" || echo "GEO_MMDB下载失败"
curl -sfL -o ./openclash/GeoSite.dat $GEO_SITE && echo "GEO_SITE下载成功" || echo "GEO_SITE下载失败"
curl -sfL -o ./openclash/GeoIP.dat $GEO_IP && echo "GEO_IP下载成功" || echo "GEO_IP下载失败"
curl -sfL -o ./openclash/accelerated-domains.china.conf $Domains_china && echo "Domains_china下载成功" || echo "Domains_china下载失败"

mkdir ./core && cd ./core

if curl -sfL -o ./tun.gz "$CORE_TUN"-"$CORE_TYPE"-"$TUN_VER".gz; then
	gzip -d ./tun.gz
	mv ./tun ./clash_tun
	echo "tun下载成功" >> $GITHUB_STEP_SUMMARY
else
	echo "tun下载失败" >> $GITHUB_STEP_SUMMARY
  	exit 1
fi

if curl -sfL -o ./meta.tar.gz "$CORE_MATE"-"$CORE_TYPE".tar.gz; then
	tar -zxf ./meta.tar.gz
	mv ./clash ./clash_meta
	echo "meta下载成功" >> $GITHUB_STEP_SUMMARY
else
	echo "meta下载失败" >> $GITHUB_STEP_SUMMARY
	exit 1
fi

if curl -sfL -o ./dev.tar.gz "$CORE_DEV"-"$CORE_TYPE".tar.gz; then
	echo "CORE_DEV下载成功" >> $GITHUB_STEP_SUMMARY
else
	echo "CORE_DEV下载失败" >> $GITHUB_STEP_SUMMARY
	exit 1
fi
tar -zxf ./dev.tar.gz

chmod +x ./clash* ; rm -rf ./*.gz

cd ../ && mv ./core ./openclash

#ddns-go
mkdir ./ddns-go && cd ./ddns-go
wget -q -O ddns-go.tar.gz https://github.com/jeessy2/ddns-go/releases/download/v6.3.2/ddns-go_6.3.2_linux_x86_64.tar.gz
if tar -zxf ./ddns-go.tar.gz ; then
	chmod +x ./ddns-go
	cd ../
	mv ./ddns-go/ddns-go ./ipk
	rm -rf ./ddns-go*
	echo "ddns-go下载成功" >> $GITHUB_STEP_SUMMARY
else
	echo "ddns-go下载失败" >> $GITHUB_STEP_SUMMARY
	exit 1
fi

# luci-app-socat
curl -L https://api.github.com/repos/chenmozhijin/luci-app-socat/releases/latest \
| grep "browser_download_url.*socat.*.ipk" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -qi -
if mv *.ipk ./ipk; then
	echo "luci-app-socat下载成功" >> $GITHUB_STEP_SUMMARY
else
	echo "luci-app-socat下载失败" >> $GITHUB_STEP_SUMMARY
	exit 1
fi

#AdGuardHome
curl -L https://api.github.com/repos/AdguardTeam/AdGuardHome/releases/latest \
| grep "AdGuardHome_linux_amd64.tar.gz" \
| grep "https" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -qi -
if tar -zxf ./AdGuardHome*.tar.gz; then
	chmod +x ./AdGuardHome/AdGuardHome
	mv ./AdGuardHome/AdGuardHome ./ipk
	rm -rf ./AdGuardHome*
	echo "AdGuardHome下载成功" >> $GITHUB_STEP_SUMMARY
else
	echo "AdGuardHome下载失败" >> $GITHUB_STEP_SUMMARY
	exit 1
fi