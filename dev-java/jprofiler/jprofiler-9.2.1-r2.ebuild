# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7
inherit eutils desktop

SLOT="$(ver_cut 1-2)"
RDEPEND=">=virtual/jdk-1.6"

RESTRICT="strip"

DESCRIPTION="JProfiler java profiling tool"
HOMEPAGE="http://www.ej-technologies.com/products/jprofiler/overview.html"
SRC_URI="http://download-gcdn.ej-technologies.com/jprofiler/jprofiler_linux_${PV//./_}.tar.gz"
LICENSE="jprofiler"
IUSE=""
KEYWORDS="amd64"
MV="$(ver_cut 1)"
S="${WORKDIR}/jprofiler${MV}"
INSTALL_DIR="/opt/${PN}-${PV}"

QA_TEXTRELS="opt/${PN}-${PV}/bin/*/libjprofilerti.so"

src_prepare(){
       ARCH=$(uname -m)

       # remove unneeded arch files
       [[ "${ARCH}" = "i686" || "${ARCH}" = "x86_64"  || ${ARCH} = "amd64" ]] || rm -r "${S}/bin/linux-x86" "${S}/bin/linux-x64"
       [[ "${ARCH:0:3}" = "arm" ]] || rm -r "${S}/bin/linux-arm" "${S}/bin/linux-armhf"
       [[ "${ARCH:0:3}" = "ppc" ]] || rm -r "${S}/bin/linux-ppc" "${S}/bin/linux-ppc64"

       eapply_user
}

src_install() {
    insinto "${INSTALL_DIR}"
    doins -r * .install4j

    fperms 755 ${INSTALL_DIR}/bin/jprofiler
    make_wrapper "${PN}-${SLOT}" "${INSTALL_DIR}/bin/jprofiler"

    pngs=(.install4j/i4j_extf_3_*_u9lgq5.png)
    newicon "${pngs[0]}" "${PN}-${SLOT}.png"
    make_desktop_entry "${PN}-${SLOT}" "JProfiler ${PV}" "${PN}-${SLOT}" "Development;Profiling"
}
