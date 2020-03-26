FROM alpine:latest

ARG ARIA2_VER=$ARIA2_VER
ARG AriaNg_VER=$AriaNg_VER
ENV RPC_SECRET=
ENV TZ=Asia/Shanghai
ENV ARIA2_DIR=/aria2
ENV DOWNLOAD_DIR=/Downloads

COPY  conf/* /aria2/
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
&& mkdir -P /usr/local/aria2/AriaNg/js/Originaljs \
&& unzip -d /usr/local/aria2/AriaNg AriaNg-${AriaNg_VER}.zip \
&& rm -rf AriaNg-${AriaNg_VER}.zip \
&& mkdir -P $DOWNLOAD_DIR \
&& mkdir -P $ARIA2_DIR \
&& sed -i 's/max:16/max:256/g' /usr/local/aria2/AriaNg/js/*.js \
&& sed -i "/^rpc-secret=/c\rpc-secret=$ARIA2C_SECRET" $ARIA2_DIR/aria2.conf \
&& sed -i 's/max-connection-per-server=16/max-connection-per-server=256/' .$ARIA2_DIR/aria2.conf \
&& sed -i '9s/^.*/\n#是否校验证书\n#check-certificate=false/' $ARIA2_DIR/aria2.conf \
&& sed -i "/^dir=/c\dir=$DOWNLOAD_DIR" $ARIA2_DIR/aria2.conf \
&& sed -i "/^DOWNLOAD_PATH='/c\DOWNLOAD_PATH='$DOWNLOAD_DIR'" $ARIA2_DIR/*.sh \
&& addgroup -g 1000 -S user \
&& adduser -u 1000 -G user -h $ARIA2_DIR -D user \
&& chown -R user /usr/local/aria2/AriaNg/ \
&& chown -R user $ARIA2_DIR \
&& chown -R user $DOWNLOAD_DIR \
&& chmod a+x /entrypoint.sh \
&& chmod a+x /root/.aria2/*.sh

USER user

EXPOSE 6800  8080  6881  6881/udp
CMD /entrypoint.sh
