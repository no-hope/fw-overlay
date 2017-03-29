# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4} )
inherit python-r1 mercurial

KEYWORDS="~x86-macos"

DESCRIPTION="Provides the shelve command to lets you choose which parts of the changes in a working directory you'd like to set aside temporarily."
HOMEPAGE="https://bitbucket.org/tksoh/hgshelve/"
EHG_REPO_URI="https://bitbucket.org/astiob/hgshelve/"

LICENSE=""
SLOT="0"
IUSE=""

DEPEND="dev-vcs/mercurial"
RDEPEND=${DEPEND}

S="${WORKDIR}/${PN}"

src_install() {
        insinto "$(python_get_sitedir)/hgext"
        doins hgshelve.py
}
