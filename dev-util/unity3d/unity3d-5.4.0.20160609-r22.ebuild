EAPI=7

inherit gnome2-utils eutils fwutils

BUILDTAG=$(ver_cut 4-4)
IUSE="ffmpeg nodejs java gzip android"
DESCRIPTION="The world's most popular development platform for creating 2D and 3D multiplatform games and interactive experiences."
HOMEPAGE="https://unity3d.com"

SRC_BASE="http://download.unity3d.com/download_unity/linux/unity-editor-installer"
UNITY_VERSION="$(ver_cut 1-3)"
if [[ "${PR}" == "r0" ]]; then
	SRC_SUFFIX=""
else
	SRC_SUFFIX="b${PR:1}"
fi
SRC_URI="${SRC_BASE}-${UNITY_VERSION}${SRC_SUFFIX}+${BUILDTAG}.sh -> ${P}+${BUILDTAG}.sh"

LICENSE="unity3d"
SLOT="$(ver_cut 1-2)"
KEYWORDS="-* ~amd64 amd64" # Package is x86_64-only
RESTRICT="strip mirror"
RDEPEND="ffmpeg? ( media-video/ffmpeg )
	nodejs? ( net-libs/nodejs )
	java? ( virtual/jdk virtual/jre )
	android? ( dev-util/android-studio )
	gzip? ( app-arch/gzip )
	dev-util/desktop-file-utils
	x11-misc/xdg-utils
	sys-devel/gcc[multilib]
	virtual/opengl
	virtual/glu
	dev-libs/nss
	media-libs/libpng
	x11-libs/libXtst
	dev-libs/libpqxx
	dev-util/monodevelop
	net-libs/nodejs[npm]"
DEPEND="${RDEPEND}
	sys-apps/fakeroot"

S="${WORKDIR}/unity-editor-${UNITY_VERSION}${SRC_SUFFIX}"
#FILES="${S}/Files"

src_unpack() {
	yes | fakeroot sh "${DISTDIR}/${P}+${BUILDTAG}.sh" > /dev/null || die "Failed unpacking archive!"
}

target="/opt/${P}"

src_install() {
	local exe_editor="unity-${SLOT}"
	local exe_monodevelop="unity-monodevelop-${SLOT}"

	insinto ${target}
	doins -r ${S}/*

	insopts "-Dm755"

	#fperms 755 "${target}/Editor/Unity"
	#fperms 755 "${target}/Editor/UnityHelper"
	#fperms 4755 "${target}/Editor/chrome-sandbox"
	#fperms 755 "${target}/MonoDevelop/bin/monodevelop"

	newicon "unity-editor-icon.png" "${exe_editor}.png"
	newicon "unity-editor-icon.png" "${exe_monodevelop}.png"
	make_wrapper "${exe_editor}" "${target}/Editor/Unity"
	make_wrapper "${exe_monodevelop}" "${target}/MonoDevelop/bin/monodevelop"
	fw_make_desktop_entry "${exe_editor} %f" "Unity Editor ${UNITY_VERSION}" "${exe_editor}" "Development;IDE" "${exe_editor}.desktop"
	fw_make_desktop_entry "${exe_monodevelop} %f" "Unity Monodevelop ${UNITY_VERSION}" "${exe_monodevelop}" "Development;IDE" "${exe_monodevelop}.desktop"
}

pkg_postinst() {
	chmod 4755 "${target}/Editor/chrome-sandbox"
	chmod -R +x ${target}
	gnome2_icon_cache_update
	ewarn "Please note that Unity3D requires closed-source"
	ewarn "graphics drivers to be used for now, as it makes"
	ewarn "use of OpenGL Compatibility profile. Please do"
	ewarn "not try to use the editor with Mesa3D - you will"
	ewarn "encounter tons of bugs & issues. Hang tight and"
	ewarn "hope that Unity3D guys will manage to add support"
	ewarn "for open-source drivers!"
}
