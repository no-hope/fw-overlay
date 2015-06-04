#!/bin/bash

DIR="$(
    dirname "$(readlink -f "$0")"
)"

if [[ $USER != "root" ]]; then
    sudo -n echo >/dev/null 2>&1 || echo "You must be a root to continue!" >&2
    sudo $0 $@
    exit $?
fi

if [[ "${SUDO_USER}" == "" ]]; then
    echo "Script requires to be run as normal user with sudo :-)" >&2
    exit 1
fi

cd "${DIR}"

CACHE_DIR="${DIR}/metadata/md5-cache"
REPO_NAME="$(cat ${DIR}/profiles/repo_name)"

CONFIG=$(cat << EOF
[DEFAULT]
main-repo=gentoo

[gentoo]
location = /usr/portage

[${REPO_NAME}]
location=$(pwd)
EOF
)

echo "config ->"
echo "${CONFIG}"

[[ -d ${CACHE_DIR} ]] && rm -rf ${CACHE_DIR}
egencache \
    --repositories-configuration="${CONFIG}" \
    --jobs="$(($(nproc) + 1))" \
    --repo="${REPO_NAME}" \
    --update \
    --update-manifests
