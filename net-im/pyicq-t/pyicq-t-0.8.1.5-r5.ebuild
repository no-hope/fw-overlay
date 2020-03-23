# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/pyicq-t/pyicq-t-0.8.1.5-r4.ebuild,v 1.1 2014/03/30 13:44:13 pacho Exp $

EAPI=7
PYTHON_COMPAT=( python2_7 )
inherit eutils python-single-r1 systemd

MY_P="${P/pyicq-t/pyicqt}"
DESCRIPTION="Python based jabber transport for ICQ"
HOMEPAGE="http://code.google.com/p/pyicqt/"
SRC_URI="http://pyicqt.googlecode.com/files/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="patched"
KEYWORDS="amd64 x86"
IUSE="webinterface systemd postgres"

DEPEND="net-im/jabber-base"
RDEPEND="${DEPEND}
	dev-python/twisted-core
	dev-python/twisted-words
	dev-python/twisted-web
	webinterface? ( >=dev-python/nevow-0.4.1 )
	postgres? ( >=dev-db/pygresql-3.8.1 )
	systemd? ( sys-apps/systemd )
	virtual/python-imaging"

src_prepare() {
	epatch "${FILESDIR}/${P}-python26-warnings.diff"
	epatch "${FILESDIR}/${P}-pillow-imaging.patch"
	if use postgres; then
		epatch "${FILESDIR}/${P}-postgres.diff"
	fi
}

src_install() {
	python_moduleinto ${PN}
	cp PyICQt.py ${PN}.py || die
	python_domodule ${PN}.py data tools src

	insinto /etc/jabber
	newins config_example.xml ${PN}.xml
	fperms 600 /etc/jabber/${PN}.xml
	fowners jabber:jabber /etc/jabber/${PN}.xml
	fperms 755 "$(python_get_sitedir)/${PN}/${PN}.py"
	sed -i \
		-e "s:<spooldir>[^\<]*</spooldir>:<spooldir>/var/spool/jabber</spooldir>:" \
		-e "s:<pid>[^\<]*</pid>:<pid>/var/run/jabber/${PN}.pid</pid>:" \
		"${ED}/etc/jabber/${PN}.xml"

	if use systemd; then
		systemd_dounit "${FILESDIR}/${PN}.service"
		sed -i -e "s:INSPATH:$(python_get_sitedir)/${PN}:" \
			"${ED}/usr/lib/systemd/system/${PN}.service" || die
	else
		newinitd "${FILESDIR}/${PN}-0.8-initd-r2" ${PN}
		sed -i -e "s:INSPATH:$(python_get_sitedir)/${PN}:" \
			"${ED}/etc/init.d/${PN}" || die
	fi

	python_fix_shebang "${D}$(python_get_sitedir)/${PN}"
}
