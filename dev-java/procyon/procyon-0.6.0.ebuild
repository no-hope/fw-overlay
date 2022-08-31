# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7
inherit eutils

SLOT="0"
RDEPEND=">=virtual/jdk-11"

DESCRIPTION="Java decompiler, inspired by (and borrowed heavily from) ILSpy and Mono.Cecil"

HOMEPAGE="https://github.com/mstrobel/procyon"
SRC_URI="https://github.com/mstrobel/procyon/releases/download/v0.6.0/procyon-decompiler-${PV}.jar -> ${P}.jar"
IUSE=""
KEYWORDS="~x86 ~amd64"
S="${WORKDIR}"

RESTRICT="mirror"

src_unpack() {
    cp -L ${DISTDIR}/${A} ${S}/${PN}.jar || die
}

src_install() {
    local dir="/opt/${PN}"
    insinto "${dir}"

    doins ${PN}.jar
    make_wrapper "${PN}" "java -jar ${dir}/${PN}.jar" ${dir}
}
