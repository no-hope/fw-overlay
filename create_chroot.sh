#!/bin/bash

if [[ "${TRAVIS_BRANCH}" != "develop" || "${TRAVIS_PULL_REQUEST}" != "false" ]]; then
    echo "Skipping build for branch '${TRAVIS_BRANCH}'"
    exit 0
fi

set -eu
set -o pipefail

REPO_DIR="$(pwd)"
echo "REPO_DIR=${REPO_DIR}"

git config user.email "travis@no-hope.org"
git config user.name "Travis CI"
git config remote.origin.url "$(git config --get remote.origin.url | sed "s|git://|https://${GH_TOKEN}@|")"
git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"

git fetch origin master
git checkout -t origin/master
git merge --no-ff --no-edit develop

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

mkdir -p gentoo/usr/portage
mkdir gentoo/repo
mount -o bind "${REPO_DIR}" gentoo/repo

cp -L /etc/resolv.conf gentoo/etc/resolv.conf
chroot gentoo emerge-webrsync -q
chroot gentoo emerge --quiet --sync

chroot gentoo bash /repo/generate_cache.sh

umount gentoo/repo
umount gentoo/sys
umount gentoo/proc
umount gentoo/dev

rm -rf "${TMP_GENTOO}"

cd ${REPO_DIR}

git add -f .
changed="$(git diff --name-only --diff-filter=A HEAD)"
if [[ "${changed}" != "" ]]; then
    git commit -m "[auto-generated] cache update"
    git push -q origin master
else
    echo "Nothing was changed!"
fi
