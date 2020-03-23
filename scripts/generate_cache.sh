#!/bin/bash

set -eu
set -o pipefail

OVERLAY_DIR="$(readlink -f $(dirname $0)/..)"

cd "${OVERLAY_DIR}"

CACHE_DIR="${OVERLAY_DIR}/metadata/md5-cache"
REPO_NAME="${OVERLAY_DIR}/profiles/repo_name"
OVERLAY_NAME="$([[ -f "${REPO_NAME}" ]] && cat ${REPO_NAME} || echo 'fw-overlay-dev' )"

CONFIG=$(cat << EOF
[DEFAULT]
main-repo=gentoo

[gentoo]
location = /var/db/repos/gentoo

[${OVERLAY_NAME}]
location=${OVERLAY_DIR}
auto-sync = true
EOF
)

[[ -d ${CACHE_DIR} ]] && rm -rf ${CACHE_DIR}
egencache \
    --repositories-configuration="${CONFIG}" \
    --jobs="$(($(nproc) + 1))" \
    --repo="${OVERLAY_NAME}" \
    --update \
    --update-manifests
echo "egencache exit code $?"
