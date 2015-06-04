#!/bin/bash

REPO_DIR="$(pwd)"
echo "REPO_DIR=${REPO_DIR}"

TMP_GENTOO="/tmp/fw-gentoo-$(date +%s)"
mkdir -p "${TMP_GENTOO}"
cd "${TMP_GENTOO}"

wget http://distfiles.gentoo.org/releases/x86/autobuilds/latest-stage3-i686.txt
wget http://distfiles.gentoo.org/releases/x86/autobuilds/$(tail -1 latest-stage3-i686.txt| awk '{print $1}') -O stage3.tar.bz2
mkdir gentoo

tar xpf stage3.tar.bz2 -C gentoo
mount -o bind /dev gentoo/dev
mount -t proc none gentoo/proc
mount -t sysfs none gentoo/sys
mkdir gentoo/repo
mount -o bind "${REPO_DIR}" gentoo/repo
chroot gentoo bash /repo/generate_cache.sh

rm -rf "${TMP_GENTOO}"
