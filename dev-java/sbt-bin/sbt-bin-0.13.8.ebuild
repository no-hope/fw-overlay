EAPI="5"

inherit eutils user java-utils-2 java-pkg-2 versionator

DESCRIPTION="sbt is a build tool for Scala and Java projects that aims to do the basics well"
HOMEPAGE="https://github.com/sbt/sbt"
SRC_URI="https://dl.bintray.com/sbt/native-packages/sbt/0.13.8/sbt-0.13.8.tgz"

LICENSE="BSD"
SLOT="$(get_major_version)"
IUSE=""
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jdk-1.6"

S="${WORKDIR}/sbt"

MY_PV="$(get_version_component_range 1-2)"

INSTALL_DIR="/opt/${PN}-${MY_PV}"

src_prepare() {
    cd "${S}"
}


src_install() {
    insinto ${INSTALL_DIR}

    doins -r *

    for i in bin/* ; do
        if [[ $i == *.bat ]]; then
            continue
        fi
        fperms 755 ${INSTALL_DIR}/${i}
        make_wrapper "$(basename ${i})-${MY_PV}" "${INSTALL_DIR}/${i}"
    done
}
