# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI="4"
inherit eutils versionator

SLOT="0"
RDEPEND=">=virtual/jdk-1.6"

RESTRICT="strip mirror"
QA_TEXTRELS="opt/${P}/bin/libbreakgen.so"

DESCRIPTION="A cross-platform C# IDE based on the IntelliJ platform and ReSharper"
HOMEPAGE="https://www.jetbrains.com/rider/"

MY_PN="riderRS"
MY_PV="${PV/0./}"
SRC_URI="http://download.jetbrains.com/resharper/${MY_PN}-${MY_PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="Rider-IDEA"
IUSE=""
KEYWORDS="~x86 ~amd64"

S="${WORKDIR}/${MY_PN}-${MY_PV}"

src_install() {
    local dir="/opt/${P}"
    local exe="${PN}"

    insinto "${dir}"

    sed -e "s|^message()|source /etc/conf.d/rider\n\nmessage()|" \
        -i bin/${PN}.sh || die "Unable to patch startup script"

    [[ -d "jre" ]] && rm -rf jre || die "no embedded jre found"

    doins -r *

    fperms 755 "${dir}/bin/fsnotifier" || die
    fperms 755 "${dir}/bin/fsnotifier64" || die
    fperms 755 "${dir}/bin/fsnotifier-arm" || die
    #fperms 755 "${dir}/bin/inspect.sh" || die
    #fperms 755 "${dir}/bin/${PN}.sh" || die

    find "${dir}" -name '*.sh' -exec fperms 755 {} +
    find "${dir}/lib/ReSharperHost" -name '*.so' -exec fperms 755 {} +
    find "${dir}/lib/ReSharperHost/linux-x64/mono/bin" -type f -exec fperms 755 {} +

    # newicon "bin/${PN}.svg" "${exe}.svg"
    newicon "bin/Rider_128.png" "${exe}.png"
    make_wrapper "${exe}" "/opt/${P}/bin/${PN}.sh"
    make_desktop_entry ${exe} "Rider ${MY_PV}" "${exe}" "Development;IDE"

    newconfd "${FILESDIR}/config" ${PN}
}
