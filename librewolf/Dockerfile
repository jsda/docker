FROM debian:stable-slim
LABEL maintainer "Jessie Frazelle <jess@linux.com>"
# https://github.com/jessfraz/dockerfiles/tree/master/firefox

RUN apt update -yqq && \
    apt install ca-certificates -yqq && \
    sed -i 's|http:|https:|' /etc/apt/sources.list.d/* && \
    apt update -yqq && \
    apt upgrade -yqq && \
    apt install -yqq extrepo && \
    extrepo enable librewolf && \
    apt install -yqq locales ttf-wqy-zenhei && \
    localedef -i zh_CN -c -f UTF-8 -A /usr/share/locale/locale.alias zh_CN.UTF-8 && \
    apt install -yqq \
      dirmngr \
      gnupg \
      --no-install-recommends && \
      apt install -yqq \
      librewolf \
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
      pulseaudio \
      --no-install-recommends && \
    apt autoclean -yqq && \
    mkdir -p /root/Downloads /data/Profiles && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV LANG=zh_CN.UTF-8 \
    LC_CTYPE=zh_CN.UTF-8 \
    GTK_IM_MODULE=fcitx \
    QT_IM_MODULE=fcitx \
    XMODIFIERS='@im=fcitx'

USER root

ENTRYPOINT /usr/bin/librewolf -profile "/data/Profiles"
