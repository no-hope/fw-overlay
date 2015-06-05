#!/bin/bash

if [[ "${TRAVIS_BRANCH}" != "develop" || "${TRAVIS_PULL_REQUEST}" != "false" ]]; then
    echo "Skipping build for branch '${TRAVIS_BRANCH}'"
    exit 0
fi

set -eu
set -o pipefail

OVERLAY_DIR="$(readlink -f $(dirname $0)/..)"

echo "Setting git up..."
git config user.email "travis@no-hope.org"
git config user.name "Travis CI"
git config remote.origin.url "$(git config --get remote.origin.url | sed "s|git://|https://${GH_TOKEN}@|")"
git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"

echo "Merging develop -> master..."
git fetch origin master
git checkout -t origin/master
git merge --no-ff --no-edit develop

echo "Setting up gentoo stage3..."
TMP_GENTOO="/tmp/fw-gentoo-$(date +%s)"
mkdir -p "${TMP_GENTOO}"
cd "${TMP_GENTOO}"

wget http://distfiles.gentoo.org/releases/x86/autobuilds/latest-stage3-i686.txt
wget http://distfiles.gentoo.org/releases/x86/autobuilds/$(tail -1 latest-stage3-i686.txt| awk '{print $1}') -O stage3.tar.bz2
mkdir gentoo

echo "Unpacking stage3.tar.bz2..."
tar xpf stage3.tar.bz2 -C gentoo

echo "Creating chroot..."
mount -o bind /dev gentoo/dev
mount -t proc none gentoo/proc
mount -t sysfs none gentoo/sys

mkdir -p gentoo/usr/portage
mkdir gentoo/repo
mount -o bind "${OVERLAY_DIR}" gentoo/repo

cp -L /etc/resolv.conf gentoo/etc/resolv.conf
chroot gentoo emerge-webrsync -q
chroot gentoo emerge --quiet --sync

echo
echo "Generating cache..."
chroot gentoo bash /repo/scripts/generate_cache.sh

echo "Tearing chroot down..."
cd gentoo
umount repo sys proc dev

rm -rf "${TMP_GENTOO}"

cd ${OVERLAY_DIR}

echo
echo "Searching for changes..."
git add -f .
changed="$(git diff --name-only HEAD)"
if [[ "${changed}" != "" ]]; then
    git commit -m "[auto-generated] cache update"
    git push -q origin master
else
    echo "Nothing was changed!"
fi
