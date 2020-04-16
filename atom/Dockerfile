FROM debian:stable-slim

LABEL maintainer "Jessie Frazelle <jess@linux.com>"

# Tell debconf to run in non-interactive mode
ENV DEBIAN_FRONTEND noninteractive
ARG ATOM_VERSION=$ATOM_VERSION

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      fakeroot \
      gconf2 \
      gconf-service \
      git \
      gvfs-bin \
      libasound2 \
      libcap2 \
      libgconf-2-4 \
      libgcrypt20 \
      libgtk2.0-0 \
      libgtk-3-0 \
      libnotify4 \
      libnss3 \
      libx11-xcb1 \
      libxkbfile1 \
      libxss1 \
      libxtst6 \
      libgl1-mesa-glx \
      libgl1-mesa-dri \
      policykit-1 \
      python \
      xdg-utils \
    && apt-get upgrade -y \
    && apt-get install -y locales ttf-wqy-zenhei \
    && localedef -i zh_TW -c -f UTF-8 -A /usr/share/locale/locale.alias zh_TW.UTF-8 \
    && apt-get autoclean -y \
    && curl -L https://github.com/atom/atom/releases/download/${ATOM_VERSION}/atom-amd64.deb > /tmp/atom.deb \
    && dpkg -i /tmp/atom.deb \
    && rm -f /tmp/atom.deb \
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

CMD ["/usr/bin/atom","-f"]
