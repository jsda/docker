git clone --depth 1 https://github.com/jsda/docker-wine-linux.git ../wine && cd ../wine
svn co --force -q https://github.com/RokasUrbelis/docker-wine-linux/trunk/deb ../deb && svn revert -R ../deb && rm -rf deb/ && mv ../deb ./ && echo "deb更新成功" || echo "deb更新失败"
echo "开始构建"
docker buildx build --push \
  --platform ${PLATFORMS} \
  -t ${IMAGE_NAME}:${IMAGE_TAG} \
  -f ${DOCKERFILE} \
  ${FILE_PATH} && echo "构建成功" || \
docker buildx build --push \
  --platform ${PLATFORMS} \
  -t ${IMAGE_NAME}:${IMAGE_TAG} \
  -f ${DOCKERFILE} \
  ${FILE_PATH} || echo "构建失败"
