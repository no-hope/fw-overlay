# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-ladspa/gst-plugins-ladspa-0.10.19.ebuild,v 1.4 2011/01/06 16:51:14 armin76 Exp $

inherit gst-plugins-bad

KEYWORDS="alpha amd64 ~ppc ~ppc64 x86"
IUSE=""

RDEPEND=">=media-libs/libofa-0.9.3
        >=media-libs/gst-plugins-base-0.10.29
        >=media-libs/gst-plugins-bad-${PV}" # uses signalprocessor helper library
DEPEND="${RDEPEND}
        ~media-libs/gst-plugins-bad-${PV}"