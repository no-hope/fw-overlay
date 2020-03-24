# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7
inherit eutils desktop

SLOT="$(ver_cut 1)"
RDEPEND=">=virtual/jdk-1.6"

RESTRICT="strip"

DESCRIPTION="YourKit java profiling tool"
HOMEPAGE="http://www.yourkit.com/download/"
SRC_URI="https://www.yourkit.com/download/YourKit-JavaProfiler-$(ver_cut 1-2)-b$(ver_cut 3).zip"
LICENSE="yourkit"
IUSE=""
KEYWORDS="~x86 amd64"

S="${WORKDIR}/YourKit-JavaProfiler-$(ver_cut 1-2)"
INSTALL_DIR="/opt/${PN}-${PV}"

src_install() {
    insinto "${INSTALL_DIR}"
    doins -r *

    fperms 755 ${INSTALL_DIR}/bin/profiler.sh || die
    make_wrapper "${PN}-${PV}" "bash -c 'YJP_JAVA_HOME=${INSTALL_DIR} ${INSTALL_DIR}/bin/profiler.sh'" || die
    newicon "bin/profiler.ico" "${PN}-${PV}.ico" || die
    make_desktop_entry "${PN}-${PV}" "YourKit ${PV}" "${PN}-${PV}" "Development;Profiling"
}
