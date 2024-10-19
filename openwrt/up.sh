getversion(){
wget -qO- https://api.github.com/repos/$1/tags \
| grep 'name' | cut -d\" -f4 \
| head -1 | sed 's/"//g;s/v//g' \
| sed 's/release-//g'
}

echo -e "$(uname -r)" >> $GITHUB_STEP_SUMMARY
echo -e "当前流程工作路径：$PATH" >> $GITHUB_STEP_SUMMARY
echo -e "开始更新软件" >> $GITHUB_STEP_SUMMARY

set -ex

# Open_Clash
export Open_Clash=https://github.com/vernesong/OpenClash/releases/download/v$(getversion vernesong/OpenClash)/luci-app-openclash_$(getversion vernesong/OpenClash)_all.ipk
mkdir -p ipk
if curl -L -o ./luci-app-openclash.ipk $Open_Clash; then
	mv *.ipk ./ipk
	echo "openclash下载成功" >> $GITHUB_STEP_SUMMARY
else
	echo "openclash下载失败" >> $GITHUB_STEP_SUMMARY
	exit 1
fi
#预置OpenClash内核和GEO数据https://github.com/VIKINGYFY/OpenWRT-CI

export GEO_MMDB=https://github.com/alecthw/mmdb_china_ip_list/raw/release/lite/Country.mmdb
export GEO_SITE=https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geosite.dat
export GEO_IP=https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geoip.dat
export Domains_china=https://github.com/felixonmars/dnsmasq-china-list/raw/master/accelerated-domains.china.conf

mkdir -p openclash

curl -L -o ./openclash/Country.mmdb $GEO_MMDB && echo "GEO_MMDB下载成功" >> $GITHUB_STEP_SUMMARY || exit 1
curl -L -o ./openclash/GeoSite.dat $GEO_SITE && echo "GEO_SITE下载成功" >> $GITHUB_STEP_SUMMARY || exit 1
curl -L -o ./openclash/GeoIP.dat $GEO_IP && echo "GEO_IP下载成功" >> $GITHUB_STEP_SUMMARY || exit 1
curl -L -o ./openclash/accelerated-domains.china.conf $Domains_china && echo "Domains_china下载成功" >> $GITHUB_STEP_SUMMARY || exit 1

mkdir ./core && cd ./core
export CORE_MATE=https://github.com/MetaCubeX/mihomo/releases/download/v$(getversion MetaCubeX/mihomo)/mihomo-linux-amd64-compatible-v$(getversion MetaCubeX/mihomo).gz
if curl -L -o ./clash_meta.gz $CORE_MATE ; then
	gzip -d clash_meta.gz
	echo "meta下载成功" >> $GITHUB_STEP_SUMMARY
else
	echo "meta下载失败" >> $GITHUB_STEP_SUMMARY
	exit 1
fi

chmod +x ./clash* ; rm -rf ./*.gz

cd ../ && mv ./core ./openclash

#ddns-go
mkdir ./ddns-go && cd ./ddns-go
wget -q -O ddns-go.tar.gz https://github.com/jeessy2/ddns-go/releases/download/v$(getversion jeessy2/ddns-go)/ddns-go_$(getversion jeessy2/ddns-go)_linux_x86_64.tar.gz
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

# AdGuardHome
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

# daed
wget -q -O daed-linux-x86_64.zip https://github.com/daeuniverse/daed/releases/download/v$(getversion daeuniverse/daed)/daed-linux-x86_64.zip

if unzip -d daed daed-linux-x86_64.zip ; then
	rm -rf daed-linux-x86_64.zip
	cd daed
	chmod +x ./daed*
	mv ./daed-linux-x86_64 ./daed
	rm -rf geo*
	echo "daed下载成功" >> $GITHUB_STEP_SUMMARY
else
	echo "daed下载失败" >> $GITHUB_STEP_SUMMARY
	exit 1
fi

cd ../