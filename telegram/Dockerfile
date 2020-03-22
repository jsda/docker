FROM debian:stable-slim

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y locales ttf-wqy-zenhei \
    && localedef -i zh_TW -c -f UTF-8 -A /usr/share/locale/locale.alias zh_TW.UTF-8 \
    && apt-get install -y \
      apt-utils \
      dbus-x11 \
      dunst \
      hunspell-en-us \
      python3-dbus \
      software-properties-common \
      libx11-xcb1 \
      libasound2 \
      gconf2 \
      wget \
      xz-utils \
      libdrm2 \
      libice6 \
      libsm6 \
      libegl1-mesa \
      libexif12 \
      liblzma5 \
      libice6 \
      libicu63 \
      libxml2 \
      libfreetype6 \
      libgpac4 \
      libtheora0 \
      libvorbis0a \
      libxcb1 \
      libxcb-image0 \
      libxcb-shm0 \
      libxcb-xfixes0 \
      libxcb-keysyms1 \
      libxcb-icccm4 \
      libatspi2.0 \
      libxcb-render-util0 \
      libxcb-util0 \
      libxcb-xkb1 \
      libxrender1 \
      libasound2 \
      libpulse0 \
      libxcb-sync1 \
      libxcb-randr0 \
      libegl1-mesa \
      libx11-xcb1 \
      libffi6 \
      libncurses5 \
      --no-install-recommends \
    && cd /tmp \
    && wget https://telegram.org/dl/desktop/linux -O telegram.tar.xz \
    && tar xvfJ telegram.tar.xz \
    && mv Telegram/Telegram /usr/bin/Telegram \
    && rm -rf  telegram* \
    && apt-get autoclean -y \
    && groupadd -r user \
    && useradd -r -g user -G audio,video user \
    && mkdir -p /home/user/Downloads \
    && chown -R user:user /home/user \
    && usermod -u 1000 user \
    && groupmod -g 1000 user \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV LC_CTYPE=zh_TW.UTF-8 \
    GTK_IM_MODULE=fcitx \
    QT_IM_MODULE=fcitx \
    XMODIFIERS='@im=fcitx' \
    QT_XKB_CONFIG_ROOT=/usr/share/X11/xkb

USER user

ENTRYPOINT ["/usr/bin/Telegram"]
