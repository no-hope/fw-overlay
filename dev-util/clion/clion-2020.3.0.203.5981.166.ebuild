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

VER=($(ver_rs 1- ' '))
if [[ "${VER[2]}" == "0" ]]; then
    if [[ "${VER[1]}" == "0" ]]; then
        SRC_URI="https://download.jetbrains.com/cpp/${MY_PN}-$(ver_cut 1-1).tar.gz"
    else
        SRC_URI="https://download.jetbrains.com/cpp/${MY_PN}-$(ver_cut 1-2).tar.gz"
    fi
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
    mv ${WORKDIR}/${PN}-* ${S} || die
}

src_install() {
    local dir="/opt/${P}"
    local exe="${PN}"

    insinto "${dir}"

    for type in config system; do
      local prop="idea.${type}.path=\${user.home}"
      local expr="${prop}/.CLion/${type}"
      local repl="${prop}/.intellij/clion-$(ver_cut 1-2)/${type}"
      sed -e "\|# ${expr}|{s||${repl}|;h};\${x;/./{x;q42};x}" \
          -i bin/idea.properties
      if [[ $? != 42 ]]; then
          die "unable to modify idea.${type}.path property in idea.properties"
      fi
    done

    doins -r *

    fperms 755 "${dir}/bin/${PN}.sh" || die
    fperms 755 "${dir}/bin/format.sh" || die
    fperms 755 "${dir}/bin/inspect.sh" || die
    fperms 755 "${dir}/bin/fsnotifier64" || die
    fperms 755 "${dir}/bin/fsnotifier" || die

    fperms 755 "${dir}/bin/gdb/linux/bin/gcore" || die
    fperms 755 "${dir}/bin/gdb/linux/bin/gdb" || die
    fperms 755 "${dir}/bin/gdb/linux/bin/gdb-add-index" || die
    fperms 755 "${dir}/bin/gdb/linux/bin/gdbserver" || die

    fperms 755 "${dir}/bin/lldb/linux/bin/LLDBFrontend" || die
    fperms 755 "${dir}/bin/lldb/linux/bin/lldb" || die
    fperms 755 "${dir}/bin/lldb/linux/bin/lldb-argdumper" || die
    fperms 755 "${dir}/bin/lldb/linux/bin/lldb-server" || die

    fperms 755 "${dir}/bin/cmake/linux/bin/ccmake" || die
    fperms 755 "${dir}/bin/cmake/linux/bin/cmake" || die
    fperms 755 "${dir}/bin/cmake/linux/bin/cpack" || die
    fperms 755 "${dir}/bin/cmake/linux/bin/ctest" || die

    fperms 755 "${dir}/bin/clang/linux/clangd" || die
    fperms 755 "${dir}/bin/clang/linux/clang-tidy" || die

    fperms -R 755 "${dir}"/jbr/bin/ || die
    fperms 755 "${dir}"/jbr/lib/{jexec,jspawnhelper}

    newicon "bin/${PN}.svg" "${exe}.svg" || die
    make_wrapper "${exe}" "/opt/${P}/bin/${PN}.sh" || die
    make_desktop_entry ${exe} "CLion IDE ${PV}" "${exe}" "Development;IDE" || die

    newconfd "${FILESDIR}/config" ${PN} || die
}
