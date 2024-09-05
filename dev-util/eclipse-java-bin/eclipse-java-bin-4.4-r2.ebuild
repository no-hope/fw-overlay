# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=8

RNAME="luna"

SRC_URI="http://download.eclipse.org/technology/epp/downloads/release/luna/R/eclipse-jee-luna-R-linux-gtk-x86_64.tar.gz"

DESCRIPTION="Eclipse IDE for Java EE Developers"
HOMEPAGE="http://www.eclipse.org"

LICENSE="EPL-1.0"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	>=virtual/jdk-1.6
	x11-libs/gtk+:2"

S=${WORKDIR}/eclipse

src_install() {
	local dest=/opt/${PN}-${SLOT}

	insinto ${dest}
	doins -r features icon.xpm plugins artifacts.xml p2 eclipse.ini configuration dropins

	exeinto ${dest}
	doexe eclipse

	dohtml -r about.html about_files epl-v10.html notice.html readme/*

	cp "${FILESDIR}"/eclipserc-bin "${T}" || die
	cp "${FILESDIR}"/eclipse-bin "${T}" || die
	sed "s@%SLOT%@${SLOT}@" -i "${T}"/eclipse{,rc}-bin || die

	insinto /etc
	newins "${T}"/eclipserc-bin eclipserc-bin-${SLOT}

	newbin "${T}"/eclipse-bin eclipse-bin-${SLOT}
	make_desktop_entry "eclipse-bin-${SLOT}" "Eclipse ${PV} (bin)" "${dest}/icon.xpm"
}
