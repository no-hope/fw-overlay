# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#EAPI="2"

inherit eutils versionator

DESCRIPTION="The High Velocity Web Framework For Java and Scala"
HOMEPAGE="http://www.playframework.com/"

SRC_URI="http://downloads.typesafe.com/play/${PV}/play-${PV}.zip"

LICENSE="Apache-2.0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos"
SLOT="$(get_major_version)"
IUSE=""
RESTRICT="mirror"

DEPEND=">=virtual/jdk-1.6
       "

RDEPEND=">=virtual/jre-1.6
        "

# TODO we should use jars from packages, instead of what is bundled
src_install() {
        local dir="/opt/${P}"
        insinto "${dir}"
        doins -r *

        make_wrapper "${P}" "${dir}/${PN}"
}