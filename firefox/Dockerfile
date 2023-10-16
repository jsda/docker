FROM debian:stable-slim
LABEL maintainer "Jessie Frazelle <jess@linux.com>"
# https://github.com/jessfraz/dockerfiles/tree/master/firefox

COPY firefox/local.conf /etc/fonts/local.conf

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y locales ttf-wqy-zenhei \
    && localedef -i zh_TW -c -f UTF-8 -A /usr/share/locale/locale.alias zh_TW.UTF-8 \
    && apt-get install -y \
      dirmngr \
      gnupg \
      --no-install-recommends \
      && apt-get install -y \
      firefox-esr \
      firefox-esr-l10n-zh-tw \
      dbus-x11 \
      libx11-xcb1 \
      apulse \
      ca-certificates \
      ffmpeg \
      hicolor-icon-theme \
      libasound2 \
      libgl1-mesa-dri \
      libgl1-mesa-glx \
      libpulse0 \
      fonts-noto \
      fonts-noto-cjk \
      fonts-noto-color-emoji \
      --no-install-recommends \
    && apt-get autoclean -y \
    && groupadd -r user \
    && useradd -r -g user -G audio,video user \
    && mkdir -p /home/user/Downloads \
    && chown -R user:user /home/user \
    && usermod -u 1000 user \
    && groupmod -g 1000 user \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV LANG=zh_TW.UTF-8 \
    LC_CTYPE=zh_TW.UTF-8 \
    GTK_IM_MODULE=fcitx \
    QT_IM_MODULE=fcitx \
    XMODIFIERS='@im=fcitx'

USER user

ENTRYPOINT /usr/bin/firefox "--quiet >/dev/null 2>&1"
