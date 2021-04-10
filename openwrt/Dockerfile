FROM rdvde/builder:latest

ARG REPO_URL=$REPO_URL
ARG REPO_BRANCH=$REPO_BRANCH
ARG FEEDS_CONF=$FEEDS_CONF
ARG CONFIG_FILE=$CONFIG_FILE
ARG DIY_P1_SH=$DIY_P1_SH
ARG DIY_P2_SH=$DIY_P2_SH
ARG DIY_P3_SH=$DIY_P3_SH
ARG GITHUB_REPO=$GITHUB_REPO
ARG TZ=Asia/Shanghai

RUN \
  echo echo "$(pwd)" && \
  df -hT $PWD && \
  git clone --depth 1 $GITHUB_REPO && \
  git clone --depth 1 $REPO_URL -b $REPO_BRANCH openwrt && \
  cd openwrt && ./scripts/feeds update -a && ./scripts/feeds install -a && \
  ../opbuild/$DIY_P2_SH && \
  ../opbuild/$DIY_P3_SH && \
  make defconfig && \
  make download -j8 && \
  find dl -size -1024c -exec ls -l {} && \
  find dl -size -1024c -exec rm -f {} && \
  echo -e "$(nproc) thread compile" && \
  make -j16 || echo "over"
