# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7
inherit eutils

SLOT="0"
RDEPEND=">=virtual/jdk-1.6"

RESTRICT="strip mirror"
QA_TEXTRELS="opt/${P}/bin/libbreakgen.so"

DESCRIPTION="A cross-platform C# IDE based on the IntelliJ platform and ReSharper"
HOMEPAGE="https://www.jetbrains.com/rider/"

MY_PN="JetBrains.Rider"
MY_PV="$(ver_cut 1-3)"
SRC_URI="http://download.jetbrains.com/rider/${MY_PN}-${MY_PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="Rider-IDEA"
IUSE=""
KEYWORDS="~* amd64"

S="${WORKDIR}/${MY_PN/./ }-${MY_PV}"

src_install() {
    local dir="/opt/${P}"
    local exe="${PN}"

    insinto "${dir}"

    for type in config system; do
      local prop="idea.${type}.path=\${user.home}"
      local expr="${prop}/.Rider/${type}"
      local repl="${prop}/.intellij/rider-$(ver_cut 1-2)/${type}"
      sed -e "\|# ${expr}|{s||${repl}|;h};\${x;/./{x;q42};x}" \
          -i bin/idea.properties
      if [[ $? != 42 ]]; then
          die "unable to modify idea.${type}.path property in idea.properties"
      fi
    done

    sed -e "s|^message()|source /etc/conf.d/rider\n\nmessage()|" \
        -i bin/${PN}.sh || die "Unable to patch startup script"

    doins -r *

    fperms 755 "${dir}"/bin/fsnotifier{,64} || die
    fperms 755 "${dir}"/jbr/bin/* || die
    fperms 755 "${dir}"/jbr/lib/{jexec,jspawnhelper}

    find "${dir}" \( -name '*.sh' -or -name '*.py' -or -name '*.so' -or -name '*.exe' -or -name '*.dll' \) -exec fperms 755 {} +
    find "${dir}/lib/ReSharperHost/linux-x64/mono/bin" -type f -exec fperms 755 {} +

    newicon "bin/rider.png" "${exe}.png"
    make_wrapper "${exe}" "/opt/${P}/bin/${PN}.sh"
    make_desktop_entry ${exe} "Rider ${MY_PV}" "${exe}" "Development;IDE"

    newconfd "${FILESDIR}/config" ${PN}
}
