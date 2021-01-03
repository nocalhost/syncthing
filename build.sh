#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

script() {
	name="$1"
	shift
	go run "script/$name.go" "$@"
}

build() {
	go run build.go "$@"
}

case "${1:-default}" in
	test)
		LOGGER_DISCARD=1 build test
		;;

	bench)
		LOGGER_DISCARD=1 build bench
		;;

	prerelease)
		script authors
		build transifex
		pushd man ; ./refresh.sh ; popd
		git add -A gui man AUTHORS
		git commit -m 'gui, man, authors: Update docs, translations, and contributors'
		;;

  artifact)
    case "${2:-all}" in
      mac)
        build -cmd=zip -targetName=syncthing -goos=darwin -goarch=amd64 -nocalhostVersion="${VERSION}"
      ;;

      linux)
        build -cmd=tar -targetName=syncthing -goos=linux -goarch=amd64 -nocalhostVersion="${VERSION}"
        build -cmd=tar -targetName=syncthing -goos=linux -goarch=arm64 -nocalhostVersion="${VERSION}"
      ;;

      windows)
        build
        build -cmd=zip -targetName=syncthing -goos=windows -goarch=amd64 -nocalhostVersion="${VERSION}"
      ;;

      all)
        build -cmd=zip -targetName=syncthing -goos=darwin -goarch=amd64 -nocalhostVersion="${VERSION}"
        build -cmd=tar -targetName=syncthing -goos=linux -goarch=amd64 -nocalhostVersion="${VERSION}"
        build -cmd=tar -targetName=syncthing -goos=linux -goarch=arm64 -nocalhostVersion="${VERSION}"
        build -cmd=zip -targetName=syncthing -goos=windows -goarch=amd64 -nocalhostVersion="${VERSION}"
      ;;
    esac
    ;;

	*)
		build "$@"
		;;
esac