#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

build() {
	go run build.go "$@"
}

CMD=${1:-zip}
VERSION=${2:-dev}
NH_COMMIT_ID=${3:-dev}

build -targetName=syncthing -cmd="${CMD}" -nocalhostVersion="${VERSION}" -nocalhostCommitId="${NH_COMMIT_ID}"

