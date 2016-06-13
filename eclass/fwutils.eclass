# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils gnome2-utils

# @FUNCTION: fw_make_desktop_entry
# @USAGE: fw_make_desktop_entry(<command>, [name], [icon], [type], [desktop_override], [fields])
# @DESCRIPTION:
# Make a .desktop file.
#
# @CODE
# binary:   what command does the app run with ?
# name:     the name that will show up in the menu
# icon:     the icon to use in the menu entry
#           this can be relative (to /usr/share/pixmaps) or
#           a full path to an icon
# type:     what kind of application is this?
#           for categories:
#           http://standards.freedesktop.org/menu-spec/latest/apa.html
#           if unset, function tries to guess from package's category
# fields:	extra fields to append to the desktop file; a printf string
# @CODE
fw_make_desktop_entry() {
	[[ -z $1 ]] && die "make_desktop_entry: You must specify the executable"

	local exec=${1}
	local name=${2:-${PN}}
	local icon=${3:-${PN}}
	local type=${4}
	local desktop_override=${5}
	local fields=${6}


	if [[ -z ${type} ]] ; then
		local catmaj=${CATEGORY%%-*}
		local catmin=${CATEGORY##*-}
		case ${catmaj} in
			app)
				case ${catmin} in
					accessibility) type="Utility;Accessibility";;
					admin)         type=System;;
					antivirus)     type=System;;
					arch)          type="Utility;Archiving";;
					backup)        type="Utility;Archiving";;
					cdr)           type="AudioVideo;DiscBurning";;
					dicts)         type="Office;Dictionary";;
					doc)           type=Documentation;;
					editors)       type="Utility;TextEditor";;
					emacs)         type="Development;TextEditor";;
					emulation)     type="System;Emulator";;
					laptop)        type="Settings;HardwareSettings";;
					office)        type=Office;;
					pda)           type="Office;PDA";;
					vim)           type="Development;TextEditor";;
					xemacs)        type="Development;TextEditor";;
				esac
				;;

			dev)
				type="Development"
				;;

			games)
				case ${catmin} in
					action|fps) type=ActionGame;;
					arcade)     type=ArcadeGame;;
					board)      type=BoardGame;;
					emulation)  type=Emulator;;
					kids)       type=KidsGame;;
					puzzle)     type=LogicGame;;
					roguelike)  type=RolePlaying;;
					rpg)        type=RolePlaying;;
					simulation) type=Simulation;;
					sports)     type=SportsGame;;
					strategy)   type=StrategyGame;;
				esac
				type="Game;${type}"
				;;

			gnome)
				type="Gnome;GTK"
				;;

			kde)
				type="KDE;Qt"
				;;

			mail)
				type="Network;Email"
				;;

			media)
				case ${catmin} in
					gfx)
						type=Graphics
						;;
					*)
						case ${catmin} in
							radio) type=Tuner;;
							sound) type=Audio;;
							tv)    type=TV;;
							video) type=Video;;
						esac
						type="AudioVideo;${type}"
						;;
				esac
				;;

			net)
				case ${catmin} in
					dialup) type=Dialup;;
					ftp)    type=FileTransfer;;
					im)     type=InstantMessaging;;
					irc)    type=IRCClient;;
					mail)   type=Email;;
					news)   type=News;;
					nntp)   type=News;;
					p2p)    type=FileTransfer;;
					voip)   type=Telephony;;
				esac
				type="Network;${type}"
				;;

			sci)
				case ${catmin} in
					astro*)  type=Astronomy;;
					bio*)    type=Biology;;
					calc*)   type=Calculator;;
					chem*)   type=Chemistry;;
					elec*)   type=Electronics;;
					geo*)    type=Geology;;
					math*)   type=Math;;
					physics) type=Physics;;
					visual*) type=DataVisualization;;
				esac
				type="Education;Science;${type}"
				;;

			sys)
				type="System"
				;;

			www)
				case ${catmin} in
					client) type=WebBrowser;;
				esac
				type="Network;${type}"
				;;

			*)
				type=
				;;
		esac
	fi
	local slot=${SLOT%/*}
	if [[ ${slot} == "0" ]] ; then
		local desktop_name="${PN}"
	else
		local desktop_name="${PN}-${slot}"
	fi
	local desktop="${T}/$(echo ${exec} | sed 's:[[:space:]/:]:_:g')-${desktop_name}.desktop"
	desktop=${desktop_override:-${desktop}}
	#local desktop=${T}/${exec%% *:-${desktop_name}}.desktop

	# Don't append another ";" when a valid category value is provided.
	type=${type%;}${type:+;}

	eshopts_push -s extglob
	if [[ -n ${icon} && ${icon} != /* ]] && [[ ${icon} == *.xpm || ${icon} == *.png || ${icon} == *.svg ]]; then
		ewarn "As described in the Icon Theme Specification, icon file extensions are not"
		ewarn "allowed in .desktop files if the value is not an absolute path."
		icon=${icon%.@(xpm|png|svg)}
	fi
	eshopts_pop

	cat <<-EOF > "${desktop}"
	[Desktop Entry]
	Name=${name}
	Type=Application
	Comment=${DESCRIPTION}
	Exec=${exec}
	TryExec=${exec%% *}
	Icon=${icon}
	Categories=${type}
	EOF

	if [[ ${fields:-=} != *=* ]] ; then
		# 5th arg used to be value to Path=
		ewarn "make_desktop_entry: update your 5th arg to read Path=${fields}"
		fields="Path=${fields}"
	fi
	[[ -n ${fields} ]] && printf '%b\n' "${fields}" >> "${desktop}"

	(
		# wrap the env here so that the 'insinto' call
		# doesn't corrupt the env of the caller
		insinto /usr/share/applications
		doins "${desktop}"
	) || die "installing desktop file failed"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
