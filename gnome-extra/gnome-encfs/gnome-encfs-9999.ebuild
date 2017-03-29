# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit mercurial python-r1

DESCRIPTION="Integrates EncFS folders into the GNOME desktop by storing their passwords in the keyring and optionally mounting them at login"
HOMEPAGE="https://bitbucket.org/obensonne/gnome-encfs/"
EHG_REPO_URI="http://bitbucket.org/obensonne/gnome-encfs"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="dev-python/pygtk
		 dev-python/gnome-keyring-python
		 sys-fs/encfs"

src_prepare() {
	python-r1_convert_shebangs -r 2 .
}

src_install() {
	dobin gnome-encfs
	newdoc README.md README
}
