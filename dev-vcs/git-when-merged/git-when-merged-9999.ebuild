# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{10,11,12} )

inherit eutils

DESCRIPTION="Find when a commit was merged into one or more branches."
HOMEPAGE="https://github.com/mhagger/git-when-merged"

if [[ ${PV} == 9999* ]] ; then
    inherit git-r3
    EGIT_REPO_URI="https://github.com/mhagger/git-when-merged"
    KEYWORDS=""
else
    SRC_URI="https://github.com/mhagger/git-when-merged/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
    KEYWORDS="amd64 x86"
fi

LICENSE="GPL-2"
SLOT="0"
RESTRICT="mirror"
IUSE=""

DEPEND=""
RDEPEND=">=dev-vcs/git-2.3.6"

INSTALL_DIR=/usr/libexec/git-core/

src_install() {
    insinto "${INSTALL_DIR}"
    mv src/${PN//-/_}.py src/${PN} || die
    doins src/${PN} || die
    fperms 755 ${INSTALL_DIR}/${PN}
}
