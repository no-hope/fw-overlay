#!/bin/bash

DIR="$(
    dirname "$(readlink -f "$0")"
)"

cd "${DIR}"

CACHE_DIR="${DIR}/metadata/md5-cache"
REPO_NAME="$(cat ${DIR}/profiles/repo_name)"

CONFIG=$(cat << EOF
[DEFAULT]
main-repo=gentoo

[gentoo]
location = /usr/portage

[${REPO_NAME}]
location=${DIR}
EOF
)

[[ -d ${CACHE_DIR} ]] && rm -rf ${CACHE_DIR}
egencache \
    --repositories-configuration="${CONFIG}" \
    --jobs="$(($(nproc) + 1))" \
    --repo="${REPO_NAME}" \
    --update \
    --update-manifests
