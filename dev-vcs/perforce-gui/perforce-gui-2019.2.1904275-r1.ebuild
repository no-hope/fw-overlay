# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=8

REL=$(ver_cut 1-2)
SHORTREL=${REL/#20/}

DESCRIPTION="GUI for Perforce version control system"
HOMEPAGE="http://www.perforce.com/"
SRC_URI="amd64? ( http://ftp.perforce.com/perforce/r${SHORTREL}/bin.linux26x86_64/p4v.tgz -> ${PF}-amd64.tgz )"

LICENSE="perforce"
SLOT="0"
KEYWORDS="-* ~x86 amd64"
IUSE="gtk"
RESTRICT="mirror strip test"

S=${WORKDIR}
INSTALL_DIR="/opt/${P}"

src_install() {
	echo "p4v-${PVR}"
	cd p4v-${PVR} || die
	insopts -m0755
	insinto /opt/${P}
	doins -r * || die

	insinto /etc/revdep-rebuild
	doins "${FILESDIR}/50-perforce-gui" || die

	for p in helixmfa  p4admin p4merge p4v p4vc; do
		make_wrapper $p ${INSTALL_DIR}/bin/$p || die
	done

	if use gtk; then
		insinto /usr/share/applications
		doins "${FILESDIR}/p4v.desktop" || die
	fi
}
