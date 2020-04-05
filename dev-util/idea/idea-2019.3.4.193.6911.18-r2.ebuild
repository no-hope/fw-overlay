# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=7
inherit eutils desktop fwutils

SLOT="$(ver_cut 1)"
RDEPEND=">=virtual/jdk-1.7"

RESTRICT="strip mirror"
QA_TEXTRELS="opt/${P}/bin/libbreakgen.so"

DESCRIPTION="IntelliJ IDEA is an intelligent Java IDE"
HOMEPAGE="https://jetbrains.com/idea/"

VER=($(ver_rs 1- ' '))
if [[ "${VER[4]}" == "0" ]]; then
    #if [[ "${VER[2]}" == "0" ]]; then
    #    SRC_URI="http://download.jetbrains.com/${PN}/${PN}IU-$(get_version_component_range 1-1).tar.gz"
    #else
        SRC_URI="https://download-cf.jetbrains.com/${PN}/${PN}IU-$(ver_cut 1-2).tar.gz"
    #fi
else
    SRC_URI="https://download-cf.jetbrains.com/${PN}/${PN}IU-$(ver_cut 1-3).tar.gz"
fi

LICENSE="IntelliJ-IDEA"
IUSE=""
KEYWORDS="~x86 amd64"
MY_PV="$(ver_cut 4-6)"
SHORT_PV="$(ver_cut 1-2)"

S="${WORKDIR}/${PN}-IU-${MY_PV}"

src_unpack() {
	unpack ${A}
	mv ${WORKDIR}/${PN}-IU-* ${S}
}

src_prepare() {
	local ver=""
	for index in $(seq ${#VER[@]} -1 1); do
		local ver_tmp=$(ver_cut 1-${index})
		if [[ -f ${FILESDIR}/idea-${ver_tmp}.sh.patch ]]; then
			ver=${ver_tmp}
			break;
		fi
	done
	eapply ${FILESDIR}/idea-${ver}.sh.patch || die
	eapply_user
}

src_install() {
	local dir="/opt/${P}"
	local exe="${PN}-${SLOT}"

	for type in config system; do
		local prop="idea.${type}.path=\${user.home}"
		local expr="${prop}/.IntelliJIdea/${type}"
		local repl="${prop}/.intellij/idea-$(ver_cut 1-2)/${type}"
		sed -e "\|# ${expr}|{s||${repl}|;h};\${x;/./{x;q42};x}" \
			-i bin/idea.properties
		if [[ $? != 42 ]]; then
			die "unable to modify idea.${type}.path property in idea.properties"
		fi
	done

	newconfd "${FILESDIR}/config-${SLOT}" idea-${SLOT} || die

	# config files
	insinto "/etc/idea"

	mv bin/idea.properties bin/idea-${SLOT}.properties
	doins bin/idea-${SLOT}.properties || die
	rm bin/idea-${SLOT}.properties

	case $ARCH in
		amd64|ppc64)
			cat bin/idea64.vmoptions > bin/idea.vmoptions
			rm bin/idea64.vmoptions
			;;
	esac

	mv bin/idea.vmoptions bin/idea-${SLOT}.vmoptions
	doins bin/idea-${SLOT}.vmoptions || die
	rm bin/idea-${SLOT}.vmoptions

	ln -s /etc/idea/idea-${SLOT}.properties bin/idea.properties

	# idea itself
	insinto "${dir}"
	doins -r *

	fperms 755 "${dir}/bin/${PN}.sh" || die
	fperms 755 "${dir}/bin/fsnotifier" || die
	fperms 755 "${dir}/bin/fsnotifier64" || die

	newicon "bin/${PN}.png" "${exe}.png" || die
	make_wrapper "${exe}" "/opt/${P}/bin/${PN}.sh"
	fw_make_desktop_entry ${exe} "IntelliJ IDEA ${SHORT_PV}" "${exe}" "Development;IDE" "${exe}.desktop"

	# Protect idea conf on upgrade
	env_file="${T}/25idea-${SLOT}"
	echo "CONFIG_PROTECT=\"\${CONFIG_PROTECT} /etc/idea/conf\"" > "${env_file}"  || die
	doenvd "${env_file}"
}
