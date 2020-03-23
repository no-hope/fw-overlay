# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=7
inherit eutils desktop

SLOT="0"
RDEPEND=">=virtual/jdk-1.6"

RESTRICT="strip mirror"
QA_TEXTRELS="opt/${P}/bin/libbreakgen.so"

DESCRIPTION="The intelligent cross-platform C/C++ IDE"
HOMEPAGE="https://www.jetbrains.com/clion/"

MY_PN="CLion"
SRC_URI="http://download.jetbrains.com/cpp/${MY_PN}-${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

VER=($(ver_cut 1))
if [[ "${VER[4]}" == "0" ]]; then
    SRC_URI="https://download.jetbrains.com/cpp/${MY_PN}-$(ver_cut 1-2).tar.gz -> ${PN}-${PV}.tar.gz"
else
    SRC_URI="https://download.jetbrains.com/cpp/${MY_PN}-$(ver_cut 1-3).tar.gz -> ${PN}-${PV}.tar.gz"
fi

MY_PV="$(ver_cut 4-6)"
SHORT_PV="$(ver_cut 1-2)"


LICENSE="CLion-IDEA"
IUSE=""
KEYWORDS="amd64"

S="${WORKDIR}/${PN}-${PV}"

src_unpack() {
    unpack ${A}
    mv ${WORKDIR}/${PN}-* ${WORKDIR}/${PN}-${PV} || die
}


src_install() {
    local dir="/opt/${P}"
    local exe="${PN}"

    insinto "${dir}"

    sed -e "s|^message()|source /etc/conf.d/clion\n\nmessage()|" \
        -i bin/${PN}.sh || die "Unable to patch startup script"

    # [[ -d "jre" ]] && rm -rf jre || die "no embedded jre found"

    doins -r *

    fperms 755 "${dir}/bin/gdb/linux/bin/gcore"
    fperms 755 "${dir}/bin/gdb/linux/bin/gdb"
    fperms 755 "${dir}/bin/gdb/linux/bin/gdbserver"

    fperms 755 "${dir}/bin/lldb/linux/bin/LLDBFrontend"
    fperms 755 "${dir}/bin/lldb/linux/bin/lldb"
    fperms 755 "${dir}/bin/lldb/linux/bin/lldb-argdumper"
    fperms 755 "${dir}/bin/lldb/linux/bin/lldb-server"

    fperms 755 "${dir}/bin/${PN}.sh"
    fperms 755 "${dir}/bin/format.sh"
    fperms 755 "${dir}/bin/inspect.sh"
    fperms 755 "${dir}/bin/fsnotifier64"
    fperms 755 "${dir}/bin/fsnotifier"
    fperms 755 "${dir}/bin/cmake/linux/bin/ccmake"
    fperms 755 "${dir}/bin/cmake/linux/bin/cmake"
    fperms 755 "${dir}/bin/cmake/linux/bin/cpack"
    fperms 755 "${dir}/bin/cmake/linux/bin/ctest"

    newicon "bin/${PN}.svg" "${exe}.svg" || die
    make_wrapper "${exe}" "/opt/${P}/bin/${PN}.sh" || die
    make_desktop_entry ${exe} "CLion IDE ${PV}" "${exe}" "Development;IDE" || die

    newconfd "${FILESDIR}/config" ${PN} || die
}
