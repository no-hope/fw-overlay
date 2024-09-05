# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=8
inherit systemd
MY_PV="${PV/_rc/.M}"

DESCRIPTION="
    Apache Karaf is a small OSGi based runtime which provides a
    lightweight container onto which various components and applications
    can be deployed.
"
HOMEPAGE="https://karaf.apache.org/"
SRC_URI="mirror://apache/karaf/${MY_PV}/apache-karaf-${MY_PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~x86 ~amd64"
IUSE="systemd"

DEPEND="
    >=virtual/jdk-1.7
    "
RDEPEND="${DEPEND}
    systemd? ( sys-apps/systemd )
    "

S="${WORKDIR}/apache-karaf-${MY_PV}"
INSTALL_DIR="/opt/karaf-${SLOT}"

pkg_setup() {
    enewgroup karaf
    enewuser karaf -1 /bin/bash ${INSTALL_DIR} karaf
}

src_prepare() {
    cd "${S}"
    find . \( -name \*.bat -or -name \*.exe \) -delete
}

src_install() {
    insinto ${INSTALL_DIR}

    doins -r bin etc lib system

    for i in bin/* ; do
        fperms 755 ${INSTALL_DIR}/${i}

        name="$(basename ${i})"
        case ${name} in
            karaf)
                make_wrapper "${name}-${SLOT}" "${INSTALL_DIR}/${i}"
                ;;
            instance|client|shell)
                make_wrapper "karaf-${name}-${SLOT}" "${INSTALL_DIR}/${i}"
                ;;
        esac
    done


    keepdir ${INSTALL_DIR}/data/tmp
    keepdir ${INSTALL_DIR}/deploy

    fowners -R karaf:karaf ${INSTALL_DIR}

    if use systemd; then
        sed -e "s/{SLOT}/${SLOT}/g" -e "s/{PV}/${PV}/g" "${FILESDIR}/karaf.service" > "${T}/karaf-${SLOT}.service" || die
        systemd_dounit "${T}/karaf-${SLOT}.service"
    else
        sed -e "s/{SLOT}/${SLOT}/g" -e "s/{PV}/${PV}/g" "${FILESDIR}/init" > "${T}/init" || die
        newinitd "${T}/init" karaf-${SLOT}
    fi

    echo "CONFIG_PROTECT=\"${INSTALL_DIR}/etc\"" > "${T}/25karaf-${SLOT}" || die
    doenvd "${T}/25karaf-${SLOT}"
}
