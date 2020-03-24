# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#EAPI="2"

inherit java-pkg-2 eutils

#MY_PN="maven-ant-tasks"
#MY_P="${MY_PN}-${PV}"

DESCRIPTION="Ivy is a free java based dependency manager"
HOMEPAGE="http://ant.apache.org/ivy"

SRC_URI="https://repo.maven.apache.org/maven2/org/apache/maven/${PN}/${PV}/${PN}-${PV}.jar"

LICENSE="Apache-2.0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos"
SLOT=0
IUSE="test"
RESTRICT="mirror"

DEPEND=">=virtual/jdk-1.6
        dev-java/ant-core
        >=dev-java/maven-bin-2.2.1
        test? ( dev-java/ant-junit )"

RDEPEND=">=virtual/jre-1.6
         dev-java/ant-core
         >=dev-java/maven-bin-2.2.1"

JAVA_GENTOO_CLASSPATH="ant-core"


MAVEN=${PN}-${SLOT}
MAVEN_SHARE="/usr/share/hooi"

src_unpack() {
    cp ${DISTDIR}/${P}.jar "${WORKDIR}" || die "failed to copy"
}

# TODO we should use jars from packages, instead of what is bundled
src_install() {
        local dir="/opt/${PN}"
        insinto "${dir}"
        doins -r *

        java-pkg_regjar "${dir}"/${P}.jar
        java-pkg_register-ant-task
}
