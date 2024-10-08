# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=8
inherit git-r3

SLOT="0"

DEPEND="
    >=virtual/jdk-1.7
    >=dev-java/maven-bin-3.0
    "
RDEPEND=">=virtual/jre-1.7"

RESTRICT="strip"

DESCRIPTION="GCViewer is a little tool that visualizes verbose GC output
generated by Sun/Oracle, IBM, HP and BEA Java Virtual Machines."
HOMEPAGE="https://github.com/chewiebug/GCViewer"

if [[ ${PV} == 9999 ]]; then
    SRC_URI=""
    EGIT_REPO_URI="https://github.com/chewiebug/GCViewer.git"
    RESTRICT="mirrors"
    KEYWORDS="**"
else
    KEYWORDS="amd64"
    SRC_URI="mirror://sourceforge/${PN}/${PN}-${PV}.jar"
fi

LICENSE="LGPL"
IUSE=""


if [[ ${PV} == 9999 ]]; then
    S="${WORKDIR}/${P}"

    src_compile() {
        mvn -Dmaven.test.skip=true clean package || die
        #cp -L ${DISTDIR}/${A} ${S}/${PN}.jar || die
    }

    src_install() {
        local dir="/opt/${PN}"
        insinto "${dir}"
        mv target/gcviewer-*.jar ${PN}.jar || die
        doins ${PN}.jar
        make_wrapper "${PN}" "java -jar ${dir}/${PN}.jar" ${dir}
    }
else
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
fi
