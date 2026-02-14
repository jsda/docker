FROM debian:stable-slim

RUN set -e && \
	sed -i 's|http://|https://|g' /etc/apt/sources.list.d/*.sources && \
	apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y locales ttf-wqy-zenhei && \
	localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
	apt-get install -yqq \
	apt-utils \
    xz-utils \
    curl \
    apt-utils \
    dbus-x11 \
    dunst \
    hunspell-en-us \
    python3-dbus \
    libx11-xcb1 \
    libpulse0 \
    libdrm2 \
    libgtk-3-0 \
    libice6 \
    libsm6 \
    libegl1-mesa-dev \
    libxcb-cursor0 \
    libgl1 libglx-mesa0 mesa-utils \
    --no-install-recommends && \
  apt install -yqq fcitx5 fcitx5-rime && \
	cd /tmp && \
	curl -sL -o ./telegram.tar.xz https://telegram.org/dl/desktop/linux  && \
	tar xvfJ telegram.tar.xz && \
	mv Telegram/Telegram /usr/bin/Telegram && \
	ln -s /usr/bin/Telegram /usr/bin/telegram && \
	rm -rf telegram* && \
	apt-get autoclean -y && \
	groupadd -r user && \
	useradd -r -g user -G audio,video user && \
	mkdir -p /home/user/Downloads && \
	chown -R user:user /home/user && \
	usermod -u 1000 user && \
	groupmod -g 1000 user && \
	apt purge -y xz-utils curl && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV LANG=en_US.UTF-8 \
    LC_CTYPE=en_US.UTF-8 \
    GTK_IM_MODULE=fcitx \
    QT_IM_MODULE=fcitx \
    XMODIFIERS='@im=fcitx' \
    QT_QPA_PLATFORM=xcb \
    QT_XKB_CONFIG_ROOT=/usr/share/X11/xkb

USER user

ENTRYPOINT /usr/bin/fcitx5 -s 10 & /usr/bin/Telegram
