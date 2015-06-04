REPO_DIR="$(pwd)"
TMP_GENTOO="/tmp/fw-gentoo-$(uuidgen)"
mkdir -p "${TMP_GENTOO}"
cd "${TMP_GENTOO}"

wget http://distfiles.gentoo.org/releases/x86/autobuilds/latest-stage3-i686.txt
wget http://distfiles.gentoo.org/releases/x86/autobuilds/$(tail -1 latest-stage3-i686.txt| awk '{print $1}') -O stage3.tar.bz2
mkdir gentoo

sudo tar xpf stage3.tar.bz2 -C gentoo
sudo mount -o bind /dev gentoo/dev
sudo mount -t proc none gentoo/proc
sudo mount -t sysfs none gentoo/sys
sudo mount -o bind "${REPO_DIR}" gentoo/repo
sudo chroot gentoo /repo/generate_cache.sh

rm -rf ${TMP_GENTOO}

