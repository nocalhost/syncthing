#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

docker run --rm --privileged multiarch/qemu-user-static:arm-5.2.0-2 --reset -p yes

docker build --rm -t "syncthing-builder" -<<EOF
FROM arm64v8/golang
COPY . /syncthing
WORKDIR /syncthing
RUN ./artifact.sh tar ${VERSION} ${NH_COMMIT_ID}
EOF

docker buildx build --platform linux/arm64 -t build .
docker run -itd --name syncthing-builder build /bin/bash
docker cp syncthing-builder:/syncthing/syncthing-linux-arm64.tar.gz ./