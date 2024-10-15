FROM debian:stable-slim

ARG OBSIDIAN_VERSION

RUN set -e && \
	apt update && \
	apt upgrade -yqq && \
	apt install -yqq locales ttf-wqy-zenhei curl ca-certificates && \
	localedef -i zh_TW -c -f UTF-8 -A /usr/share/locale/locale.alias zh_TW.UTF-8 && \
	DEBIAN_FRONTEND=noninteractive \
	echo "**** install obsidian ****" && \
	if [ -z ${OBSIDIAN_VERSION+x} ]; then \
		OBSIDIAN_VERSION=$(curl -sX GET "https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest"| awk '/tag_name/{print $4;exit}' FS='[""]'); \
	fi && \
	apt install -y --no-install-recommends \
		git \
		libgtk-3-bin \
		libatk1.0-0 \
		libatk-bridge2.0-0 \
		libnss3 \
		python3-xdg && \
	cd /tmp && \
	curl -o \
		/tmp/obsidian.app -L \
		"https://github.com/obsidianmd/obsidian-releases/releases/download/${OBSIDIAN_VERSION}/Obsidian-$(echo ${OBSIDIAN_VERSION} | sed 's/v//g').AppImage" && \
	chmod +x /tmp/obsidian.app && \
	./obsidian.app --appimage-extract && \
	mv squashfs-root /opt/obsidian && \
	cp \
		/opt/obsidian/usr/share/icons/hicolor/512x512/apps/obsidian.png \
		/usr/share/icons/hicolor/512x512/apps/obsidian.png && \
	apt autoclean -yqq && \
	mkdir -p /Downloads && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV LANG=zh_TW.UTF-8 \
		LC_CTYPE=zh_TW.UTF-8 \
		GTK_IM_MODULE=fcitx \
		QT_IM_MODULE=fcitx \
		XMODIFIERS='@im=fcitx'

ENTRYPOINT /opt/obsidian/obsidian ">/dev/null 2>&1"
