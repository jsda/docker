# syntax=docker/dockerfile:labs

FROM debian:stable-slim

ARG OBSIDIAN_VERSION

RUN --mount=type=secret,id=github_token \
	TOKEN=$(cat /run/secrets/github_token) && \
	set -ex && \
	apt update && \
	apt upgrade -yqq && \
	apt install -yqq locales ttf-wqy-zenhei curl ca-certificates libgbm1 libdrm2 libasound2 xdg-utils && \
	localedef -i zh_CN -c -f UTF-8 -A /usr/share/locale/locale.alias zh_CN.UTF-8 && \
	DEBIAN_FRONTEND=noninteractive \
	echo "**** install obsidian ****" && \
	OBSIDIAN_VERSION=$(curl -H "Authorization: Bearer ${TOKEN}" -sL "https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest" \
		| awk '/tag_name/{print $4;exit}' FS='[""]' \
		| sed 's/"//g;s/v//g;s/release-//g') && \
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
		"https://github.com/obsidianmd/obsidian-releases/releases/download/v${OBSIDIAN_VERSION}/Obsidian-${OBSIDIAN_VERSION}.AppImage" && \
	chmod +x /tmp/obsidian.app && \
	./obsidian.app --appimage-extract && \
	mv squashfs-root /opt/obsidian && \
	cp \
		/opt/obsidian/usr/share/icons/hicolor/512x512/apps/obsidian.png \
		/usr/share/icons/hicolor/512x512/apps/obsidian.png && \
	apt autoclean -yqq && \
	mkdir -p /Downloads && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV LANG=zh_CN.UTF-8 \
		LC_CTYPE=zh_CN.UTF-8 \
		GTK_IM_MODULE=fcitx \
		QT_IM_MODULE=fcitx \
		XMODIFIERS='@im=fcitx'

ENTRYPOINT /opt/obsidian/obsidian "--no-sandbox" ">/dev/null 2>&1"
