FROM debian:stable-slim

LABEL maintainer "Jessie Frazelle <jess@linux.com>"

# Tell debconf to run in non-interactive mode
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
  apt-transport-https \
  ca-certificates \
  gnupg \
  wget \
  --no-install-recommends

# Add the atom debian repo
RUN wget -qO- https://packagecloud.io/AtomEditor/atom/gpgkey | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'

# Install dependencies
RUN apt-get update && apt-get install -y \
  atom \
  git \
  gconf2 \
  gconf-service \
  gvfs-bin \
  libasound2 \
  libcap2 \
  libgconf-2-4 \
  libgtk2.0-0 \
  libnotify4 \
  libnss3 \
  libxkbfile1 \
  libxss1 \
  libxtst6 \
  libx11-xcb-dev \
  xdg-utils \
  --no-install-recommends \
  && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y locales ttf-wqy-zenhei \
    && localedef -i zh_TW -c -f UTF-8 -A /usr/share/locale/locale.alias zh_TW.UTF-8 \
    && apt-get autoclean -y \
    && groupadd -r user \
    && useradd -r -g user -G audio,video user \
    && mkdir -p /home/user/Downloads \
    && chown -R user:user /home/user \
    && usermod -u 1000 user \
    && groupmod -g 1000 user \
    && rm -rf /var/lib/apt/lists/*

ENV LC_CTYPE=zh_TW.UTF-8 \
    GTK_IM_MODULE=fcitx \
    QT_IM_MODULE=fcitx \
    XMODIFIERS='@im=fcitx'

USER user
# Autorun atom
CMD ["atom","-f"]
