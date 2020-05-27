FROM debian:stable-slim

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y locales ttf-wqy-zenhei \
    && apt-get install -y --no-install-suggests --no-install-recommends \
    curl gnupg2 apt-transport-https ca-certificates libx11-xcb1 libasound2 libgtk-3-0 \
    && localedef -i zh_TW -c -f UTF-8 -A /usr/share/locale/locale.alias zh_TW.UTF-8 \
    && apt install -y apt-utils curl dbus-x11 libx11-xcb1 gnupg apt-transport-https libasound2 \
    && curl -s https://updates.signal.org/desktop/apt/keys.asc | apt-key add - \
    && echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" | tee -a /etc/apt/sources.list.d/signal-xenial.list \
    && apt update \
    && apt install -y signal-desktop \
    && apt-get autoclean -y \
    && groupadd -r user \
    && useradd -r -g user -G audio,video user \
    && mkdir -p /home/user/Downloads \
    && chown -R user:user /home/user \
    && usermod -u 1000 user \
    && groupmod -g 1000 user \
    && chown root:root /opt/Signal/chrome-sandbox && chmod 4755 /opt/Signal/chrome-sandbox \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV LANG=zh_TW.UTF-8 \
    LC_CTYPE=zh_TW.UTF-8 \
    GTK_IM_MODULE=fcitx \
    QT_IM_MODULE=fcitx \
    XMODIFIERS='@im=fcitx'

USER user

ENTRYPOINT /usr/bin/signal-desktop "--no-sandbox" "--quiet >/dev/null 2>&1"
