# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils versionator

SLOT="0"
RDEPEND=">=virtual/jdk-1.6"

DESCRIPTION="Java decompiler, inspired by (and borrowed heavily from) ILSpy and Mono.Cecil"

HOMEPAGE="https://bitbucket.org/mstrobel/procyon/wiki/Java%20Decompiler"
SRC_URI="https://bitbucket.org/mstrobel/procyon/downloads/procyon-decompiler-${PV}.jar -> ${P}.jar"
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
