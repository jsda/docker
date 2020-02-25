date -R
mkdir /v2raybin
cd /v2raybin
curl --silent "https://api.github.com/repos/v2ray/v2ray-core/releases/latest" |
grep '"tag_name":' |
sed -E 's/.*"([^"]+)".*/\1/' |
xargs -I {} curl -sOL "https://github.com/v2ray/v2ray-core/releases/download/{}/v2ray-linux-64.zip"
unzip v2ray-linux-64.zip
chmod +x v2ray
chmod +x v2ctl
rm -rf v2ray-linux-64.zip config.json

mkdir /caddybin
mkdir /caddybin/caddy
cd /caddybin/caddy
curl --silent "https://api.github.com/repos/caddyserver/caddy/releases/latest" |
  grep '"tag_name":' |
  sed -E 's/.*"([^"]+)".*/\1/' |
  xargs -I {} curl -sOL "https://github.com/caddyserver/caddy/releases/download/"{}/caddy_{}'_linux_amd64.tar.gz'
tar -vxf caddy*
rm -rf caddy_v*
chmod +x caddy
mkdir /wwwroot
echo -e "0.0.0.0:80 {\n    root /wwwroot\n    timeouts 10m\n    proxy $V2_PATH 127.0.0.1:3050 {\n        websocket\n        header_upstream -Origin\n    }\n}" > Caddyfile

# host ip port
env | grep -E '^MARATHON_HOST=|MARATHON_PORT_' > /wwwroot/$V2_IP
if [ "x$MARATHON_HOST" != "x" ]; then
    getent hosts $MARATHON_HOST | awk '{print "MARATHON_HOST_IP="$1; exit;}' >> /wwwroot/$V2_IP
fi

cd /v2raybin
echo -e "$CONFIG_JSON" > config.json
if [ "$CERT_PEM" != "$KEY_PEM" ]; then
  echo -e "$CERT_PEM" > cert.pem
  echo -e "$KEY_PEM"  > key.pem
fi
./v2ray &
cd /caddybin/caddy
./caddy -conf="Caddyfile"
