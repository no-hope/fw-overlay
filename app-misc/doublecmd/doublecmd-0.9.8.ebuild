# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

inherit desktop eutils fwutils

DESCRIPTION="Double Commander is a cross platform open source file manager with two panels side by side. It is inspired by Total Commander and features some new ideas."
HOMEPAGE="http://doublecmd.sourceforge.net/"
SLOT="0"

LICENSE="GPL"
IUSE="qt5 -gtk2"
KEYWORDS="amd64 ~x86"

REQUIRED_USE="
	^^ ( gtk2 qt5 )
"

SRC_URI="
	amd64?	( qt5? ( mirror://sourceforge/${PN}/${PN}-${PV}.qt5.x86_64.tar.xz )
		  gtk2? ( mirror://sourceforge/${PN}/${PN}-${PV}.gtk2.x86_64.tar.xz ) )
	x86?	( qt5? ( mirror://sourceforge/${PN}/${PN}-${PV}.qt5.i386.tar.xz )
		  gtk2? ( mirror://sourceforge/${PN}/${PN}-${PV}.gtk2.i386.tar.xz ) )"


RDEPEND="
gtk2? ( x11-libs/gtk+:2 )
qt5? ( dev-qt/qtgui:5 )
"

INSTALL_DIR="/opt/${PN}"

S=${WORKDIR}/"doublecmd"

src_install() {
	insinto ${INSTALL_DIR}

	doins -r *

	fperms 755 ${INSTALL_DIR}/${PN}.sh
	fperms 755 ${INSTALL_DIR}/${PN}

	make_wrapper "${PN}" "${INSTALL_DIR}/${PN}.sh" || die
	newicon "${PN}.png" "${PN}.png" || die

	fw_make_desktop_entry \
	    "${PN} %d" \
	    "Double Commander" \
	    "${PN}" \
	    "Utility;" \
	    "doublecmd.desktop" \
	    "MimeType=inode/directory;" || die
}

