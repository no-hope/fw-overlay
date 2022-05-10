# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7
EANT_BUILD_TARGET="dist"
inherit eutils java-pkg-2 java-ant-2

SLOT="0"
DEPEND="
    >=virtual/jdk-1.6
    >=media-gfx/graphviz-2.26.3
    "
RDEPEND="
    ${DEPEND}
    "

RESTRICT="strip"
DESCRIPTION="PlantUML is used to draw UML diagram, using a simple and human readable text description"
HOMEPAGE="http://plantuml.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${PN}-${PV}.tar.gz"
LICENSE="GPL"
IUSE=""
KEYWORDS="x86 amd64"
S="${WORKDIR}/${PN}-${PV}"
INSTALL_DIR="/opt/${PN}"
EANT_GENTOO_CLASSPATH="ant-core"
JAVA_ANT_REWRITE_CLASSPATH="true"

src_install() {
    insinto "${INSTALL_DIR}"
    doins "${FILESDIR}/${PN}"
    doins "${S}/${PN}.jar"
    #doins ${FILESDIR}

    fperms 755 ${INSTALL_DIR}/${PN}
    make_wrapper "${PN}" "${INSTALL_DIR}/${PN}"
}
