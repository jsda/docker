FROM alpine:latest

ARG ARIA2_VER=$ARIA2_VER
ARG AriaNg_VER=$AriaNg_VER
ENV RPC_SECRET=
ENV TZ=Asia/Shanghai

COPY  root /root/
COPY entrypoint.sh /entrypoint.sh

RUN apk add --no-cache bash ca-certificates darkhttpd tzdata \
&& rm -rf /var/cache/apk/* \
&& echo "Aria2-$ARIA2_VER" \
&& wget https://github.com/jsda/aria2-builder/raw/amd64/aria2-${ARIA2_VER}-amd64.zip \
&& unzip -d /usr/local/bin aria2-${ARIA2_VER}-amd64.zip \
&& chmod a+x /usr/local/bin/aria2c \
&& rm -rf aria2-${ARIA2_VER}-amd64.zip \
&& echo "AriaNg-$AriaNg_VER" \
&& wget https://github.com/mayswind/AriaNg/releases/download/${AriaNg_VER}/AriaNg-${AriaNg_VER}.zip \
&& mkdir -p /usr/local/aria2/AriaNg/js/Originaljs \
&& unzip -d /usr/local/aria2/AriaNg AriaNg-${AriaNg_VER}.zip \
&& sed -i 's/max:16/max:256/g' /usr/local/aria2/AriaNg/js/*.js \
&& rm -rf AriaNg-${AriaNg_VER}.zip \
&& addgroup -g 1000 -S alpine \
&& adduser -u 1000 -G alpine -h /home/alpine -D alpine \
&& mkdir -p /root/Downloads \
&& chown -R alpine /root/Downloads/ \
&& touch /root/.aria2/aria2.session \
&& chown -R alpine /root/ \
&& chown -R alpine /usr/local/aria2/AriaNg/ \
&& chmod a+x /entrypoint.sh \
&& chmod a+x /root/.aria2/*.sh

USER alpine
WORKDIR /root/.aria2/

EXPOSE 6800  8080  6881  6881/udp
CMD /entrypoint.sh
