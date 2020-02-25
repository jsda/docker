cd /home/alpine/Downloads
rm -rf BaiduPCS-Go-* && \
curl --silent "https://api.github.com/repos/liuzhuoling2011/baidupcs-web/releases/latest" |
  grep '"tag_name":' |
  sed -E 's/.*"([^"]+)".*/\1/' |
  xargs -I {} curl -sOL "https://github.com/liuzhuoling2011/baidupcs-web/releases/download/"{}/BaiduPCS-Go-{}'-linux-amd64.zip'&& \
  unzip BaiduPCS-Go-*.zip && \
  rm -rf BaiduPCS-Go-*.zip && \
  rm -rf /home/alpine/baidupcs/* && \
  mv BaiduPCS-Go-*/BaiduPCS-Go /home/alpine/baidupcs/BaiduPCS-Go && \
  rm -rf BaiduPCS-Go-* && \
  chmod a+x /home/alpine/baidupcs/BaiduPCS-Go && \
  /home/alpine/baidupcs/BaiduPCS-Go
