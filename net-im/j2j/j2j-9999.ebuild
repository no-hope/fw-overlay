# Copyright Nikolaus Polak
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_DEPEND="2"
PYTHON_COMPAT=( python2_7 )
inherit eutils python-single-r1 subversion

DESCRIPTION="Jabber2Jabber Transport"
ESVN_REPO_URI="svn://svn.jrudevels.org/${PN}/trunk"
HOMEPAGE="http://wiki.jrudevels.org/index.php/Eng:J2J"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="+postgres mysql"

IUSE="postgres mysql"
DEPEND="net-im/jabber-base"
RDEPEND="${DEPEND}
         dev-python/twisted-core
         dev-python/twisted-words
         dev-python/twisted-names
         postgres? ( !mysql? ( >=dev-db/pygresql-4.1.1-r1 ) )
         mysql? ( !postgres? ( >=dev-db/mysql-4.1 ) )"

src_unpack() {
    subversion_src_unpack
}

src_install() {
    python_moduleinto ${PN}
    python_domodule *.py

    insinto /etc/jabber
    newins j2j.conf.example ${PN}.conf
    fperms 600 /etc/jabber/${PN}.conf
    fowners jabber:jabber /etc/jabber/${PN}.conf
    newins j2j.conf.example ${PN}.conf

    insinto /var/lib/j2j
    if use postgres; then
        doins pgsql.schema alters/pgsql/*
    fi
    if use mysql; then
        doins mysql.schema alters/mysql/*
    fi

    dodoc Changelog.txt

    sed -i \
        -e "s:/var/log/j2j/j2j.log:/var/log/jabber/j2j.log:" \
        -e "s:xml_logging=/var/log/j2j/xml.log:xml_logging=/var/log/jabber/j2j-xml.log:" \
        "${ED}/etc/jabber/${PN}.conf"

    newinitd "${FILESDIR}/${PN}-initd" ${PN}
    sed -i -e "s:INSPATH:$(python_get_sitedir)/${PN}:" "${ED}/etc/init.d/${PN}"

    python_fix_shebang "${D}$(python_get_sitedir)/${PN}"
}

pkg_postinst() {
    elog "A sample configuration file has been installed in /etc/jabber/${PN}.conf."
    elog "Please edit it and the configuration of your Jabber server to match."
    elog "Don't forget the database connection too. If it's your first install, you"
    elog "need to initialize the Database following this documentation:"
    elog "http://wiki.jrudevels.org/Eng:J2J:AdminGuide#Database_setup"
}
