# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator

SLOT="0"
RDEPEND=">=virtual/jdk-1.6"

RESTRICT="strip"

DESCRIPTION="JD-GUI is a standalone graphical utility that displays Java source codes of \".class\" files"
HOMEPAGE="https://github.com/java-decompiler/jd-gui"
SRC_URI="https://github.com/java-decompiler/jd-gui/releases/download/v${PV}/jd-gui-${PV}.jar"
IUSE=""
KEYWORDS="~x86 ~amd64"
S="${WORKDIR}"

src_unpack() {
    cp -L ${DISTDIR}/${A} ${S}/${PN}.jar || die
}

src_install() {
    local dir="/opt/${PN}"
    insinto "${dir}"

    doins ${PN}.jar
    make_wrapper "${PN}" "java -jar ${dir}/${PN}.jar" ${dir}
}
