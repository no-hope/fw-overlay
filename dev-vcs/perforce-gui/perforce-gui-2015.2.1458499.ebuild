# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2
inherit versionator

REL=$(get_version_component_range 1-2)
SHORTREL=${REL/#20/}

DESCRIPTION="GUI for Perforce version control system"
HOMEPAGE="http://www.perforce.com/"
SRC_URI="x86? ( http://ftp.perforce.com/perforce/r${SHORTREL}/bin.linux26x86/p4v.tgz -> ${PF}-x86.tgz )
         amd64? ( http://ftp.perforce.com/perforce/r${SHORTREL}/bin.linux26x86_64/p4v.tgz -> ${PF}-amd64.tgz )"

LICENSE="perforce"
SLOT="0"
KEYWORDS="-* ~x86 ~amd64"
IUSE="gtk"
RESTRICT="mirror strip test"

S=${WORKDIR}

src_install() {
        cd p4v-${PVR} || die
        insopts -m0755
        insinto /opt
        doins -r * || die

        insinto /etc/revdep-rebuild
        doins "${FILESDIR}/50-perforce-gui" || die

        if use gtk; then
                insinto /usr/share/applications
                doins "${FILESDIR}/p4v.desktop" || die
        fi
}
