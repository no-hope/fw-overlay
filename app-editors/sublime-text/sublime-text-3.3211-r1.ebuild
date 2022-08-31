# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

inherit eutils fwutils

DESCRIPTION="Sublime Text is a sophisticated text editor for code, html and prose"
HOMEPAGE="http://www.sublimetext.com"

SLOT="$(ver_cut 1)"
BUILD="$(ver_cut 2-2)"

get_uri() {
    echo "https://download.sublimetext.com/sublime_text_${SLOT}_build_${BUILD}_${1}.tar.bz2 -> ${P}_${2}.tar.bz2"
}

SRC_URI="
    amd64? ( $(get_uri x64 amd64) )
    x86?   ( $(get_uri x32 x86) )
"
LICENSE="Unlicense"

KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="x11-libs/gtk+:2"
RESTRICT="mirror"

INSTALL_DIR="/opt/${PN}-${SLOT}"

S=${WORKDIR}/"sublime_text_3"

src_install() {
    insinto ${INSTALL_DIR}

    doins -r *

    fperms 755 ${INSTALL_DIR}/sublime_text
    fperms 755 ${INSTALL_DIR}/plugin_host

    make_wrapper "${PN}-${SLOT}" "${INSTALL_DIR}/sublime_text"
    newicon "Icon/128x128/sublime-text.png" "${PN}-${PV}.png"

    fw_make_desktop_entry "${PN}-${SLOT} %F" "Sublime Text Editor" "${PN}-${PV}" "GTK;Utility;Office;TextEditor;" "${PN}-${SLOT}.desktop" "StartupNotify=true\nMimeType=text/*;application/xml;application/javascript"
}
