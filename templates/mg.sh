#!/usr/bin/env bash
# *)
# "hmmm")
# "hmmm"*)
# *"hmmm"*)
# *"hmmm"* | "huh")

dir="~/path/to/project"
name="projectname-mutagen"

case "$1" in
  "setup")
    (
      set -x
      sidecar_version=$(curl -L -s 'https://registry.hub.docker.com/v2/repositories/mutagenio/sidecar/tags?page_size=1000' | jq --raw-output '.results[].name' | sort -r | grep -v 'beta' | grep -v 'alpha' | head -n 1)

      docker volume create ${name}
      docker container create --name ${name}-container -v ${name}:/volumes/${name} mutagenio/sidecar:${sidecar_version}
      docker container start ${name}-container

      # --default-file-mode=0666 \
      # --default-directory-mode=0777 \
      mutagen sync create \
        --name ${name} \
        --sync-mode=two-way-resolved \
        --ignore-vcs \
        ${dir} \
        docker://${name}-container/volumes/${name}
    )
  ;;

  "start")
    (
      set -x
      docker container start ${name}-container
      mutagen daemon start
    )
  ;;

  "stop")
    (
      set -x
      docker container stop ${name}-container
      mutagen daemon stop
    )
  ;;

  "clean")
    (
      set -x
      mutagen sync terminate ${name}
      docker container stop ${name}-container
      docker container rm ${name}-container
      docker volume rm ${name}
      mutagen daemon stop
    )
  ;;

  *)
    printf '%s\n' "Error: unknown command \"$1\"" >&2
    exit 1
  ;;
esac
