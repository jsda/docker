FROM debian:stable-slim
# https://github.com/linuxserver/docker-wps-office
ARG WPS_VERSION

RUN set -e && \
	apt update && \
	apt upgrade -yqq && \
	apt install -yqq locales ttf-wqy-zenhei curl ca-certificates libgbm1 libdrm2 libasound2 xdg-utils && \
	localedef -i zh_CN -c -f UTF-8 -A /usr/share/locale/locale.alias zh_CN.UTF-8 && \
	apt install -yqq libqt5gui5 bsdmainutils && \
	echo "**** install ****" && \
	if [ -z ${WPS_VERSION+x} ]; then \
		WPS_VERSION=$(curl -s https://www.wps.cn/product/wpslinux | grep -oP 'https://[^"]+/wps/download/ep/[^"]+\.deb' | head -n 1 | sed -r 's/.*_([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)_.*\.deb/\1/'); \
		echo "Extracted WPS_VERSION: $WPS_VERSION"; \
		base_url=$(curl -s https://www.wps.cn/product/wpslinux | grep -oP 'https://[^"]+/wps/download/ep/[^"]+\.deb' | head -n 1); \
		uri="${base_url#https://wps-linux-personal.wpscdn.cn}"; \
		securityKey="7f8faaaa468174dc1c9cd62e5f218a5b"; \
		timestamp10=$(date '+%s'); \
		md5hash=$(echo -n "${securityKey}${uri}${timestamp10}" | md5sum | awk '{print $1}'); \
		deb_url="${base_url}?t=${timestamp10}&k=${md5hash}"; \
	fi && \
	curl -L "$deb_url" -o /tmp/wps.deb && \
	apt install -y /tmp/wps.deb && \
	mkdir -p /root/.config/Kingsoft /root/.local/share/Kingsoft/office6/data/backup && \
	mkdir /tmp/fonts && \
	curl -o \
		/tmp/fonts.tar.gz -L \
		"https://github.com/BannedPatriot/ttf-wps-fonts/archive/refs/heads/master.tar.gz" && \
  tar xf \
		/tmp/fonts.tar.gz -C \
		/tmp/fonts/ --strip-components=1 && \
  cd /tmp/fonts && \
  bash install.sh && cd / && \
  ln -s \
		/usr/lib/x86_64-linux-gnu/libtiff.so.6.0.0 \
		/usr/lib/x86_64-linux-gnu/libtiff.so.5 && \
	apt autoclean -yqq && \
	mkdir -p /Downloads && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV LANG=zh_CN.UTF-8 \
		LC_CTYPE=zh_CN.UTF-8 \
		GTK_IM_MODULE=fcitx \
		QT_IM_MODULE=fcitx \
		XMODIFIERS='@im=fcitx'

# /usr/bin/wps
# /usr/bin/et
# /usr/bin/wpp
# /usr/bin/wpspdf
ENTRYPOINT /usr/bin/wps "--no-sandbox" ">/dev/null 2>&1"