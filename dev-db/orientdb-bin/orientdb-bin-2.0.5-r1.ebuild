# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=8
inherit systemd

DESCRIPTION="Multi-Model Open Source NoSQL DBMS that combines the power of graphs and the flexibility of documents into one scalable, high-performance operational database."
HOMEPAGE="http://www.orientechnologies.com"
SRC_URI="http://www.orientechnologies.com/download.php?email=unknown@unknown.com&file=orientdb-community-${PV}.tar.gz&os=linux -> orientdb-community-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="systemd"


DEPEND="
    >=virtual/jdk-1.5
    "

RDEPEND="${DEPEND}
		systemd? ( sys-apps/systemd )"

S="${WORKDIR}/orientdb-community-${PV}"
INSTALL_DIR="/opt/orientdb-community"

pkg_setup() {
    enewgroup orientdb
    enewuser orientdb -1 /bin/bash ${INSTALL_DIR} orientdb
}

src_prepare() {
    cd "${S}"
    find . \( -name \*.bat -or -name \*.exe \) -delete
    rm -rf ./databases/
    rm -rf ./log/

    ln -s /var/lib/orientdb databases
    ln -s /var/log/orientdb log
}

src_install() {
    insinto ${INSTALL_DIR}

    doins -r bin config lib plugins www

    for i in bin/* ; do
        fperms 755 ${INSTALL_DIR}/${i}
        make_wrapper "odb-$(basename ${i})" "${INSTALL_DIR}/${i}"
    done

    keepdir /var/lib/orientdb
    keepdir /var/log/orientdb
    fowners -R orientdb:orientdb /var/lib/orientdb
    fowners -R orientdb:orientdb /var/log/orientdb
    fowners -R orientdb:orientdb ${INSTALL_DIR}

	if use systemd; then
		systemd_dounit "${FILESDIR}/orientdb.service"
	else
		newinitd "${FILESDIR}/init" orientdb
	fi

    echo "CONFIG_PROTECT=\"${INSTALL_DIR}/config\"" > "${T}/25orientdb" || die
    doenvd "${T}/25orientdb"
}
