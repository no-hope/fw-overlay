# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils

DESCRIPTION="Basic disassembler plugin for HotSpot"
HOMEPAGE="https://kenai.com/projects/base-hsdis/"

SRC_URI="https://kenai.com/projects/base-hsdis/downloads/download/linux-hsdis-amd64.so"

LICENSE="cc-by-3.0"
KEYWORDS="amd64"
SLOT="0"
IUSE=""
RESTRICT="mirror"

DEPEND=">=virtual/jdk-1.6
       "

RDEPEND=">=virtual/jre-1.6
         >=app-admin/eselect-1.4.4
        "

src_unpack() {
    mkdir -p ${S}
    cp -L ${DISTDIR}/linux-hsdis-amd64.so ${S}/hsdis-amd64.so || die
}

src_install() {
        local dir="/opt/hsdis"
        insinto "${dir}"
        doins hsdis-amd64.so
        fperms 0755 "${dir}/hsdis-amd64.so"

        insinto "/usr/share/eselect/modules"
        doins ${FILESDIR}/java-hsdis.eselect
}
