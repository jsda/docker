FROM alpine:latest

ARG AriaNg_VER=$AriaNg_VER
ENV TZ=Asia/Taipei
ENV ARIA2_DIR=/aria2
ENV DOWNLOAD_DIR=/Downloads

COPY  conf/* /aria2/

RUN apk add --no-cache bash ca-certificates darkhttpd tzdata \
&& rm -rf /var/cache/apk/* \
&& wget https://github.com/jsda/aria2-builder/raw/amd64/aria2-amd64.zip \
&& unzip -d /usr/local/bin aria2-*.zip \
&& chmod a+x /usr/local/bin/aria2c \
&& rm -rf aria2-*.zip /usr/local/bin/aria2-* \
&& echo "AriaNg-$AriaNg_VER" \
&& wget https://github.com/mayswind/AriaNg/releases/download/${AriaNg_VER}/AriaNg-${AriaNg_VER}.zip \
&& mkdir -p /usr/local/aria2/AriaNg/js/Originaljs \
&& unzip -d /usr/local/aria2/AriaNg AriaNg-${AriaNg_VER}.zip \
&& rm -rf AriaNg-${AriaNg_VER}.zip \
&& sed -i 's/max:16/max:256/g' /usr/local/aria2/AriaNg/js/*.js \
&& mkdir -p $DOWNLOAD_DIR \
&& mkdir -p $ARIA2_DIR \
&& sed -i 's/rpc-secret/#rpc-secret/' $ARIA2_DIR/aria2.conf \
&& sed -i 's/max-connection-per-server=16/max-connection-per-server=256/' .$ARIA2_DIR/aria2.conf \
&& sed -i '9s/^.*/\n#是否校验证书\n#check-certificate=false/' $ARIA2_DIR/aria2.conf \
&& sed -i "/^dir=/c\dir=$DOWNLOAD_DIR" $ARIA2_DIR/aria2.conf \
&& sed -i 's/root\/.//g' $ARIA2_DIR/aria2.conf \
&& sed -i "/^DOWNLOAD_PATH='/c\DOWNLOAD_PATH='$DOWNLOAD_DIR'" $ARIA2_DIR/*.sh \
&& addgroup -g 1000 -S user \
&& adduser -u 1000 -G user -h $ARIA2_DIR -D user \
&& chown -R user /usr/local/aria2/AriaNg/ \
&& chown -R user $ARIA2_DIR \
&& chown -R user $DOWNLOAD_DIR \
&& chmod a+x $ARIA2_DIR/*.sh

USER user

EXPOSE 6800  8080  6881  6881/udp
ENTRYPOINT darkhttpd /usr/local/aria2/AriaNg --port 8080 --daemon && \
    /usr/local/bin/aria2c \
        "--conf-path=$ARIA2_DIR/aria2.conf" \
        "--input-file=$ARIA2_DIR/aria2.session" \
        "--save-session=$ARIA2_DIR/aria2.session" \
        "--dht-file-path=$ARIA2_DIR/dht.dat" \
        "--dht-file-path6=$ARIA2_DIR/dht6.dat" \
        "--on-download-stop=$ARIA2_DIR/delete.sh" \
        "--on-download-complete=$ARIA2_DIR/delete.aria2.sh"
