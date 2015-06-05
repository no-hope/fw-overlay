#!/bin/bash

set -eu
set -o pipefail

OVERLAY_DIR="$(readlink -f $(dirname $0)/..)"

cd "${OVERLAY_DIR}"

CACHE_DIR="${OVERLAY_DIR}/metadata/md5-cache"
OVERLAY_NAME="$(cat ${OVERLAY_DIR}/profiles/repo_name)"

CONFIG=$(cat << EOF
[DEFAULT]
main-repo=gentoo

[gentoo]
location = /usr/portage

[${OVERLAY_NAME}]
location=${OVERLAY_DIR}
EOF
)

[[ -d ${CACHE_DIR} ]] && rm -rf ${CACHE_DIR}
egencache \
    --repositories-configuration="${CONFIG}" \
    --jobs="$(($(nproc) + 1))" \
    --repo="${OVERLAY_NAME}" \
    --update \
    --update-manifests
