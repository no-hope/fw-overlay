# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils versionator

DESCRIPTION="Basic disassembler plugin for HotSpot"
HOMEPAGE="https://kenai.com/projects/base-hsdis/"

BASE_BINUTILS="2.25.1"
#BASE_BINUTILS="2.23.2"

MY_PV="jdk$(get_version_component_range 1-1)u$(get_version_component_range 2-2)-b$(get_version_component_range 3-3)"

SRC_URI="
    http://hg.openjdk.java.net/jdk8u/jdk8u/hotspot/archive/${MY_PV}.tar.gz/src/share/tools/hsdis/ -> ${P}.tar.gz
    mirror://kernel/linux/devel/binutils/binutils-${BASE_BINUTILS}.tar.bz2
"

LICENSE="cc-by-3.0"
KEYWORDS="amd64"
SLOT="0"
IUSE=""
RESTRICT="mirror"

DEPEND=">=virtual/jdk-1.6
       "

RDEPEND=">=virtual/jre-1.6
         >=app-admin/eselect-1.4.4
         sys-devel/binutils
        "
S="${WORKDIR}"

src_prepare() {
    touch ${WORKDIR}/config.h || die
    mv hotspot-${MY_PV}/src/share/tools/hsdis/* ${WORKDIR} || die
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
    dosym ${dir} ${dir}/${PN}-${ARCH}.so

    insinto "/usr/share/eselect/modules"
    doins ${FILESDIR}/java-hsdis.eselect
}
