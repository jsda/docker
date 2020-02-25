FROM alpine:latest

ENV CONFIG_JSON=none CERT_PEM=none KEY_PEM=none V2_PATH=/ws V2_IP=123.txt

RUN apk add --no-cache --virtual .build-deps ca-certificates curl

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD /entrypoint.sh
