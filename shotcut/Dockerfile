# syntax=docker/dockerfile:labs

FROM debian:stable-slim

ARG SHOTCUT_RELEASE

RUN --mount=type=secret,id=github_token \
  TOKEN=$(cat /run/secrets/github_token) && \
  set -ex && \
  apt update && \
  apt install -yqq ca-certificates && \
  sed -i 's|http://|https://|g' /etc/apt/sources.list.d/*.sources && \
  apt upgrade -yqq && \
  apt install -yqq locales ttf-wqy-zenhei curl && \
  localedef -i zh_CN -c -f UTF-8 -A /usr/share/locale/locale.alias zh_CN.UTF-8 && \
  DEBIAN_FRONTEND=noninteractive \
  echo "**** install runtime packages ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    libjack-jackd2-0 \
    xz-utils \
    libgl1 libegl1 libgles2 libxrender1 libxkbcommon0 \
    dbus-x11 \
    libx11-xcb1 \
    libxcb1 \
    libxcb-glx0 \
    libxcb-keysyms1 \
    libxcb-image0 \
    libxcb-shm0 \
    libxcb-icccm4 \
    libxcb-sync1 \
    libxcb-xfixes0 \
    libxcb-shape0 \
    libxcb-randr0 \
    libxcb-render-util0 \
    libxrender1 \
    libxi6 \
    libxext6 \
    libxfixes3 \
    libegl1 \
    libgl1 \
    libdbus-1-3 \
    libfontconfig1 \
    libfreetype6 \
    libsdl2-2.0-0 \
    apulse \
    pulseaudio \
    libasound2 \
    libgl1-mesa-dri \
    libgl1 libglx-mesa0 mesa-utils \
    libpulse0 \
    libgpg-error0 && \
  echo "**** install shotcut ****" && \
  mkdir -p \
    /app/shotcut && \
  SHOTCUT_RELEASE=$(curl -H "Authorization: Bearer ${TOKEN}" -sL "https://api.github.com/repos/mltframework/shotcut/releases/latest" \
    | awk '/tag_name/{print $4;exit}' FS='[""]' \
    | sed 's/"//g;s/v//g;s/release-//g') && \
  curl -o \
    /tmp/shotcut-tarball.txz -L \
    "https://github.com/mltframework/shotcut/releases/download/v${SHOTCUT_RELEASE}/shotcut-linux-x86_64-${SHOTCUT_RELEASE}.txz" && \
  tar xJf /tmp/shotcut-tarball.txz -C \
    /app/shotcut --strip-components=2 && \
  echo "**** cleanup ****" && \
  apt-get clean && \
  apt purge -y curl && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

ENV LANG=zh_CN.UTF-8 \
    LC_CTYPE=zh_CN.UTF-8 \
    GTK_IM_MODULE=fcitx \
    QT_IM_MODULE=fcitx \
    XMODIFIERS='@im=fcitx'

ENTRYPOINT /app/shotcut/shotcut ">/dev/null 2>&1"
