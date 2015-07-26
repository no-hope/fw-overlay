# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils versionator fwutils

DESCRIPTION="Double Commander is a cross platform open source file manager with two panels side by side. It is inspired by Total Commander and features some new ideas."
HOMEPAGE="http://doublecmd.sourceforge.net/"
SLOT="0"

LICENSE="GPL"
IUSE="qt4 +gtk"
KEYWORDS="~amd64 ~x86"

REQUIRED_USE="
	?? ( gtk qt4 )
"

SRC_URI="
	amd64?	( qt4? ( mirror://sourceforge/${PN}/${PN}-${PV}.qt.x86_64.tar.xz )
		      gtk? ( mirror://sourceforge/${PN}/${PN}-${PV}.gtk2.x86_64.tar.xz ) )
	x86?	( qt4? ( mirror://sourceforge/${PN}/${PN}-${PV}.qt.i386.tar.xz )
		      gtk? ( mirror://sourceforge/${PN}/${PN}-${PV}.gtk2.i386.tar.xz ) )"


RDEPEND="
gtk? ( x11-libs/gtk+:2 )
qt4? ( dev-qt/qtgui:4 )
"

INSTALL_DIR="/opt/${PN}"

S=${WORKDIR}/"doublecmd"

src_prepare() {
    sed -i -e 's/<UseConfigInProgramDir>True/<UseConfigInProgramDir>False/' ${PN}.xml || die "Sed failed!"
}


src_install() {
	insinto ${INSTALL_DIR}

	doins -r *

    fperms 755 ${INSTALL_DIR}/${PN}.sh
    fperms 755 ${INSTALL_DIR}/${PN}

    make_wrapper "${PN}" "${INSTALL_DIR}/${PN}.sh"
    newicon "${PN}.png" "${PN}.png"

	fw_make_desktop_entry "${PN}" "Double Commander" "${PN}" "Utility;" "doublecmd.desktop"
}
