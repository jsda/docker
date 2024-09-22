FROM debian:stable-slim

RUN set -e \
	&& apt-get update \
    && apt-get upgrade -yqq \
    && apt-get install -yqq locales ttf-wqy-zenhei \
    && localedef -i zh_TW -c -f UTF-8 -A /usr/share/locale/locale.alias zh_TW.UTF-8 \
    && apt-get install -y filezilla mousepad \
    && apt-get autoclean -yqq \
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

ENTRYPOINT /usr/bin/filezilla ">/dev/null 2>&1"
