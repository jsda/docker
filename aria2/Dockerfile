FROM alpine:latest AS builder

RUN apk add --no-cache bash curl wget darkhttpd jq grep sed && \
    # aria2
    wget -q https://raw.githubusercontent.com/jsda/aria2-builder/refs/heads/amd64/aria2-amd64.zip && \
    unzip -oq aria2-amd64.zip && rm -rf aria2-amd64.zip && chmod +x aria2c && \
    # AriaNg
    mkdir -p /root/AriaNg && cd /root/AriaNg && \
    Aria_Ng=$(curl -sX GET "https://api.github.com/repos/mayswind/AriaNg/releases/latest" \
      | awk '/tag_name/{print $4;exit}' FS='[""]' \
      | sed 's/"//g;s/v//g;s/release-//g') && \
    curl -L -o ./AriaNg.zip https://github.com/mayswind/AriaNg/releases/download/${Aria_Ng}/AriaNg-${Aria_Ng}.zip && \
    unzip -oq AriaNg.zip && rm -rf AriaNg.zip && \
    sed -i 's/max:16/max:256/g' js/*.js && \
    mkdir -p /root/Download && ln -sf /root/Download /root/AriaNg/ && \
    # aria2.conf
    mkdir -p /root/.aria2 && cd /root/.aria2 && \
    wget -q https://github.com/P3TERX/aria2.conf/archive/refs/heads/master.tar.gz && \
    tar -zxvf master.tar.gz --strip-components=1 && \
    rm -rf master.tar.gz && \
    sed -i 's|rpc-secret|#rpc-secret|g' ./aria2.conf && \
    touch /root/.aria2/aria2.session && \
    ./tracker.sh

FROM alpine:latest

COPY --from=builder /aria2c /usr/bin/
COPY --from=builder /usr/bin/darkhttpd /usr/bin/
COPY --from=builder /root/.aria2 /root/.aria2
COPY --from=builder /root/AriaNg /root/AriaNg
COPY --from=builder /root/Download /root/Download

ENV PUID=0 PGID=0 UMASK=022
ENV RPC_SECRET="password"
ENV RPC_PORT="6800"
ENV LISTEN_PORT="6888"
ENV DHT_LISTEN_PORT="6888"
ENV HTTP_PORT="6880"
EXPOSE 6800  6881  6881/udp  6880

ENTRYPOINT darkhttpd /root/AriaNg --port $HTTP_PORT --daemon && \
    aria2c \
        "--rpc-secret=$RPC_SECRET" \
        "--rpc-listen-port=$RPC_PORT" \
        "--listen-port=$LISTEN_PORT" \
        "--dht-listen-port=$DHT_LISTEN_PORT" \
        "--conf-path=/root/.aria2/aria2.conf"
        