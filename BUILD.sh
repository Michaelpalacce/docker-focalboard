VERSION=$(curl -s -XGET https://api.github.com/repos/mattermost/focalboard/tags | grep name -m 1 | awk '{print $2}' | cut -d'"' -f2)

docker buildx build --platform linux/amd64,linux/arm64 \
-f Dockerfile \
-t stefangenov/focalboard:latest \
-t stefangenov/focalboard:"${VERSION}" \
--build-arg VERSION="${VERSION}" \
--cpu-quota="400000" \
--memory=16g \
--push .
