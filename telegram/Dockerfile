FROM debian:stable-slim

RUN set -e && \
	apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y locales ttf-wqy-zenhei && \
	localedef -i zh_TW -c -f UTF-8 -A /usr/share/locale/locale.alias zh_TW.UTF-8 && \
	apt-get install -y \
	apt-utils \
	software-properties-common \
    wget \
    xz-utils \
    curl \
	apt-utils \
    dbus-x11 \
    dunst \
    hunspell-en-us \
    python3-dbus \
    software-properties-common \
    libx11-xcb1 \
    libpulse0 \
    gconf2 \
    libdrm2 \
    libgtk-3-0 \
    libice6 \
    libsm6 \
    libegl1-mesa-dev \
    libgl1-mesa-glx \
    --no-install-recommends && \
	cd /tmp && \
	wget https://telegram.org/dl/desktop/linux -O telegram.tar.xz && \
	tar xvfJ telegram.tar.xz && \
	mv Telegram/Telegram /usr/bin/Telegram && \
	rm -rf telegram* && \
	apt-get autoclean -y && \
	groupadd -r user && \
	useradd -r -g user -G audio,video user && \
	mkdir -p /home/user/Downloads && \
	chown -R user:user /home/user && \
	usermod -u 1000 user && \
	groupmod -g 1000 user && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV LANG=zh_TW.UTF-8 \
    LC_CTYPE=zh_TW.UTF-8 \
    GTK_IM_MODULE=fcitx \
    QT_IM_MODULE=fcitx \
    XMODIFIERS='@im=fcitx' \
	QT_XKB_CONFIG_ROOT=/usr/share/X11/xkb

USER user

ENTRYPOINT /usr/bin/Telegram "--quiet >/dev/null 2>&1"
