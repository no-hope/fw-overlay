# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils versionator fwutils

DESCRIPTION="Sublime Text is a sophisticated text editor for code, html and prose"
HOMEPAGE="http://www.sublimetext.com"

SLOT="$(get_major_version)"

get_uri() {
    echo "https://download.sublimetext.com/Sublime%20Text%20${PV}${1}.tar.bz2 -> ${P}_${2}.tar.bz2"
}

SRC_URI="
    amd64? ( $(get_uri %20x64 amd64) )
    x86?   ( $(get_uri ''     x86) )
    "

LICENSE="Unlicense"
SLOT="$(get_major_version)"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="x11-libs/gtk+:2"
RESTRICT="mirror"

INSTALL_DIR="/opt/${PN}-${SLOT}"

S=${WORKDIR}/"Sublime Text 2"

src_install() {
    insinto ${INSTALL_DIR}

    doins -r "lib"
    doins -r "Icon"
    doins -r "Pristine Packages"
    doins "sublime_plugin.py"
    doins "PackageSetup.py"
    doins "sublime_text"

    fperms 755 ${INSTALL_DIR}/sublime_text

    make_wrapper "${PN}-${SLOT}" "${INSTALL_DIR}/sublime_text"
    newicon "Icon/128x128/sublime_text.png" "${PN}-${PV}.png"

    fw_make_desktop_entry "${PN}-${SLOT}" "Sublime Text Editor" "${PN}-${PV}" "GTK;Utility;Office;TextEditor;" "${PN}-${SLOT}.desktop" "StartupNotify=true\nMimeType=text/plain;"
}
