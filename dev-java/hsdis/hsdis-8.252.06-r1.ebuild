# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=8

DESCRIPTION="Basic disassembler plugin for HotSpot"
HOMEPAGE="https://kenai.com/projects/base-hsdis/"

BASE_BINUTILS="2.33.1"

MY_PV="jdk$(ver_cut 1)u$(ver_cut 2)-b$(ver_cut 3)"

SRC_URI="
    http://hg.openjdk.java.net/jdk8u/jdk8u/hotspot/archive/${MY_PV}.tar.gz/src/share/tools/hsdis/ -> ${P}.tar.gz
    mirror://gnu/binutils/binutils-${BASE_BINUTILS}.tar.xz
"

LICENSE="cc-by-3.0"
KEYWORDS="amd64 ~x86"
SLOT="0"
IUSE=""

DEPEND=">=virtual/jdk-1.8
       "

RDEPEND=">=virtual/jre-1.8
         >=app-admin/eselect-1.4.14
         sys-devel/binutils
        "
S="${WORKDIR}"

src_prepare() {
    touch ${WORKDIR}/config.h || die
    mv hotspot-${MY_PV}/src/share/tools/hsdis/* ${WORKDIR} || die
    eapply_user
}

src_compile() {
    emake -j1 \
        ARCH=${ARCH} \
        BINUTILS="binutils-${BASE_BINUTILS}" || die
    mv build/linux-amd64/hsdis-amd64.so ${P}-${ARCH}.so || die
}

src_install() {
    local dir="/opt/hsdis"
    insinto "${dir}"
    doins ${P}-${ARCH}.so

    fperms 0755 ${dir}/${P}-${ARCH}.so
    dosym ${dir}/${P}-${ARCH}.so ${dir}/${PN}-${ARCH}.so

    insinto "/usr/share/eselect/modules"
    newins ${FILESDIR}/java-hsdis-r1.eselect java-hsdis.eselect
}
