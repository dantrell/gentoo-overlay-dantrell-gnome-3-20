# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools gnome2

DESCRIPTION="GNOME compositing window manager based on Clutter"
HOMEPAGE="https://gitlab.gnome.org/GNOME/mutter"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="ck debug +deprecated-background elogind +introspection systemd test +vanilla-mipmapping wayland"
REQUIRED_USE="
	?? ( ck elogind systemd )
	wayland? ( || ( elogind systemd ) )
"

RESTRICT="!test? ( test )"

# libXi-1.7.4 or newer needed per:
# https://bugzilla.gnome.org/show_bug.cgi?id=738944
COMMON_DEPEND="
	>=x11-libs/pango-1.2[introspection?]
	>=x11-libs/cairo-1.10[X]
	>=x11-libs/gtk+-3.19.8:3[X,introspection?]
	>=dev-libs/glib-2.36.0:2[dbus]
	>=media-libs/clutter-1.25.6:1.0[X,introspection?]
	>=media-libs/cogl-1.17.1:1.0=[introspection?]
	>=media-libs/libcanberra-0.26[gtk3]
	>=x11-libs/startup-notification-0.7
	>=x11-libs/libXcomposite-0.2
	>=gnome-base/gsettings-desktop-schemas-3.19.3[introspection?]
	gnome-base/gnome-desktop:3=
	>sys-power/upower-0.99:=

	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	>=x11-libs/libXcomposite-0.2
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	>=x11-libs/libXi-1.7.4
	x11-libs/libXinerama
	>=x11-libs/libXrandr-1.5
	x11-libs/libXrender
	x11-libs/libxcb
	x11-libs/libxkbfile
	>=x11-libs/libxkbcommon-0.4.3[X]
	x11-misc/xkeyboard-config

	gnome-extra/zenity

	introspection? ( >=dev-libs/gobject-introspection-1.42:= )
	wayland? (
		dev-libs/libinput
		>=dev-libs/wayland-1.6.90
		>=dev-libs/wayland-protocols-1.1
		>=media-libs/clutter-1.20[egl,wayland]
		>=media-libs/mesa-10.3[egl(+),gbm(+),wayland]
		media-libs/cogl:1.0=[wayland]
		|| ( sys-auth/elogind sys-apps/systemd )
		dev-libs/libgudev:=
		x11-base/xwayland
		x11-libs/libdrm:=
	)
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.41
	sys-devel/gettext
	virtual/pkgconfig
	x11-base/xorg-proto
	test? ( app-text/docbook-xml-dtd:4.5 )
	wayland? ( >=sys-kernel/linux-headers-4.4 )
"
RDEPEND="${COMMON_DEPEND}
	!x11-misc/expocity
"

src_prepare() {
	if use elogind; then
		eapply "${FILESDIR}"/${PN}-3.20.3-support-elogind.patch
	fi

	if use deprecated-background; then
		eapply "${FILESDIR}"/${PN}-3.18.4-restore-deprecated-background-code.patch
	fi

	# From GNOME:
	# 	https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/89
	if ! use vanilla-mipmapping; then
		eapply "${FILESDIR}"/${PN}-3.14.4-metashapedtexture-disable-mipmapping-emulation.patch
	fi

	# From GNOME:
	# 	https://gitlab.gnome.org/GNOME/mutter/-/commit/6c5baf89ede6ea4e52724194003aae4f70427677
	# 	https://gitlab.gnome.org/GNOME/mutter/-/commit/5201d77b0bcc3d790f13bbdfb8e6cd08e53eec83
	eapply "${FILESDIR}"/${PN}-3.31.4-keybindings-limit-corner-move-to-current-monitor.patch
	eapply "${FILESDIR}"/${PN}-3.37.2-keybindings-use-current-monitor-for-move-to-center.patch

	# From GNOME:
	# 	https://gitlab.gnome.org/GNOME/mutter/-/commit/3df4348f236f6bd8e2f37e633885dfde841fc988
	# 	https://gitlab.gnome.org/GNOME/mutter/-/commit/033f0d11bfd87f82cbd3ffc56b97574bb3ffb691
	# 	https://gitlab.gnome.org/GNOME/mutter/-/commit/64ced1632e277e4fc0b1f4de3f5bf229c6cf885b
	eapply "${FILESDIR}"/${PN}-3.34.2-window-reset-tile-monitor-number-when-untiling.patch
	eapply "${FILESDIR}"/${PN}-3.37.2-window-set-fall-back-tile-monitor-if-not-set.patch
	eapply "${FILESDIR}"/${PN}-3.38.2-window-dont-override-tile-monitor.patch

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	# native backend without wayland is useless
	gnome2_src_configure \
		--disable-static \
		--enable-compile-warnings=minimum \
		--enable-sm \
		--enable-startup-notification \
		--enable-verbose-mode \
		--with-libcanberra \
		$(usex debug --enable-debug=yes "") \
		$(use_enable introspection) \
		$(use_enable wayland) \
		$(use_enable wayland native-backend)
}
