FROM alpine:latest

COPY entrypoint.sh /entrypoint.sh

RUN apk add --no-cache bash curl \
&& rm -rf /var/cache/apk/*  \
&& chmod +x /entrypoint.sh \
&& addgroup -g 1000 -S alpine \
&& adduser -u 1000 -G alpine -h /home/alpine -D alpine \
&& mkdir -p /home/alpine/Downloads \
&& mkdir -p /home/alpine/baidupcs \
&& mkdir -p /home/alpine/.config \
&& chown -R alpine /home/alpine/

USER alpine

EXPOSE 5299
CMD /entrypoint.sh
