# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit eutils versionator

RESTRICT="strip"
REAL_PV="${PV}"

DESCRIPTION="Telegram Desktop Messenger (unofficial client), DEV version"
HOMEPAGE="https://tdesktop.com/"
SRC_URI="
	amd64?	( https://updates.tdesktop.com/tlinux/tsetup.${REAL_PV}.tar.xz -> ${P}.tar.xz )
	x86?	( https://updates.tdesktop.com/tlinux32/tsetup32.${REAL_PV}.tar.xz -> ${PN}32-${PV}.tar.xz )"

RESTRICT="mirror"
LICENSE="GPL-3"
IUSE=""
KEYWORDS="~x86 ~amd64"
INSTALL_DIR="/opt/${PN}"
SLOT="0"
DEPEND=""
RDEPEND="${DEPEND}"
S="${WORKDIR}/Telegram"

src_install() {
    insinto "${INSTALL_DIR}"
    doins -r Telegram Updater

    fperms 777 ${INSTALL_DIR}/Telegram
    fperms 777 ${INSTALL_DIR}/Updater

    make_wrapper "${PN}" "${INSTALL_DIR}/Telegram"
    #newicon "bin/yjp.ico" "${PN}-${PV}.ico"
    make_desktop_entry "${PN}" "Telegram" "${PN}" "Messenger"
}

