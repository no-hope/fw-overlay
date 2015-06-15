# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2
inherit versionator eutils

REL=$(get_version_component_range 1-2)
SHORTREL=${REL/#20/}

DESCRIPTION="GUI for Perforce version control system"
HOMEPAGE="http://www.perforce.com/"
SRC_URI="x86? (
	ftp://ftp.perforce.com/perforce/r${SHORTREL}/bin.linux26x86/p4v.tgz -> \
	${PF}-x86.tgz )
    amd64? (
	ftp://ftp.perforce.com/perforce/r${SHORTREL}/bin.linux26x86_64/p4v.tgz -> \
	${PF}-amd64.tgz )"

LICENSE="perforce"
SLOT="0"
KEYWORDS="-* ~x86 ~amd64"
RESTRICT="mirror strip test"

MY_PN="p4v"
S=${WORKDIR}

RDEPEND="
    dev-qt/qtgui:4
"

src_install() {
	cd p4v-${PVR} || die
	[[ -f bin/assistant ]] && rm bin/assistant

	insopts -m0755
	insinto /opt/${PN}
	doins -r * || die

	for i in bin/* ; do
		if [[ ${i} != *'.bin' && ${i} != *'.conf' ]]; then
			make_wrapper "$(basename ${i})" "/opt/${PN}/${i}"
		fi
	done

	insinto /etc/revdep-rebuild
	doins "${FILESDIR}/50-perforce-gui" || die

	newicon "lib/p4v/P4VResources/icons/P4-V_96x96.png" "${MY_PN}.png"
	make_desktop_entry "${MY_PN}" "P4V" "${MY_PN}" "Development;"
}
