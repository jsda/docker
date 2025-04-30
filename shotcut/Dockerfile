FROM debian:stable-slim

ARG SHOTCUT_RELEASE

RUN set -ex && \
  apt update && \
  apt upgrade -yqq && \
  apt install -yqq locales ttf-wqy-zenhei curl && \
  localedef -i zh_TW -c -f UTF-8 -A /usr/share/locale/locale.alias zh_TW.UTF-8 && \
  DEBIAN_FRONTEND=noninteractive \
  echo "**** install runtime packages ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    libjack-jackd2-0 \
    xz-utils \
    libgl1 libegl1 libgles2-mesa libxrender1 libxkbcommon0 \
    apulse \
    pulseaudio \
    libasound2 \
    libgl1-mesa-dri \
    libgl1-mesa-glx \
    libpulse0 && \
  echo "**** install shotcut ****" && \
  mkdir -p \
    /app/shotcut && \
  if [ -z ${SHOTCUT_RELEASE+x} ]; then \
    SHOTCUT_RELEASE=$(curl -sX GET "https://api.github.com/repos/mltframework/shotcut/releases/latest"| awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  SHOTCUT_SHORT_VER=$(echo ${SHOTCUT_RELEASE} | sed 's|[v.]||g') && \
  curl -o \
    /tmp/shotcut-tarball.txz -L \
    "https://github.com/mltframework/shotcut/releases/download/${SHOTCUT_RELEASE}/shotcut-linux-x86_64-${SHOTCUT_SHORT_VER}.txz" && \
  tar zxf /tmp/shotcut-tarball.txz -C \
    /app/shotcut --strip-components=2 && \
  echo "**** cleanup ****" && \
  apt-get clean && \
  apt purge -y curl && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

ENV LANG=zh_TW.UTF-8 \
    LC_CTYPE=zh_TW.UTF-8 \
    GTK_IM_MODULE=fcitx \
    QT_IM_MODULE=fcitx \
    XMODIFIERS='@im=fcitx'

ENTRYPOINT /app/shotcut/shotcut ">/dev/null 2>&1"
