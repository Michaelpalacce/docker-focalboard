VERSION=$(curl -s -XGET https://api.github.com/repos/mattermost/focalboard/tags | grep name -m 1 | awk '{print $2}' | cut -d'"' -f2)

rm -rf focalboard

git clone --branch $VERSION --depth 1 https://github.com/mattermost/focalboard.git focalboard

docker buildx build --platform linux/amd64,linux/arm64 \
-f focalboard/docker/Dockerfile \
-t stefangenov/focalboard:latest \
-t stefangenov/focalboard:"${VERSION}" \
--build-arg VERSION="${VERSION}" \
--cpu-quota="400000" \
--memory=16g \
--push .
