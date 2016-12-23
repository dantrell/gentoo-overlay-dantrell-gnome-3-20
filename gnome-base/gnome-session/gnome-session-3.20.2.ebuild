# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools gnome2

DESCRIPTION="Gnome session manager"
HOMEPAGE="https://git.gnome.org/browse/gnome-session"

LICENSE="GPL-2 LGPL-2 FDL-1.1"
SLOT="0"
KEYWORDS="*"

IUSE="+deprecated doc elibc_FreeBSD gconf ipv6 systemd wayland"

# x11-misc/xdg-user-dirs{,-gtk} are needed to create the various XDG_*_DIRs, and
# create .config/user-dirs.dirs which is read by glib to get G_USER_DIRECTORY_*
# xdg-user-dirs-update is run during login (see 10-user-dirs-update-gnome below).
# gdk-pixbuf used in the inhibit dialog
COMMON_DEPEND="
	>=dev-libs/glib-2.46.0:2[dbus]
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.18.0:3
	>=dev-libs/json-glib-0.10
	>=gnome-base/gnome-desktop-3.18:3=
	elibc_FreeBSD? ( dev-libs/libexecinfo )
	wayland? ( media-libs/mesa[egl,gles2] )
	!wayland? ( media-libs/mesa[gles2] )

	x11-libs/libSM
	x11-libs/libICE
	x11-libs/libXau
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/libXtst
	x11-misc/xdg-user-dirs
	x11-misc/xdg-user-dirs-gtk
	x11-apps/xdpyinfo

	gconf? ( >=gnome-base/gconf-2:2 )
"
# Pure-runtime deps from the session files should *NOT* be added here
# Otherwise, things like gdm pull in gnome-shell
# gnome-themes-standard is needed for the failwhale dialog themeing
# sys-apps/dbus[X] is needed for session management
RDEPEND="${COMMON_DEPEND}
	gnome-base/gnome-settings-daemon
	>=gnome-base/gsettings-desktop-schemas-0.1.7
	x11-themes/adwaita-icon-theme
	sys-apps/dbus[X]

	!deprecated? (
		systemd? ( >=sys-apps/systemd-186:0= )
	)
	!systemd? (
		sys-auth/consolekit
		>=dev-libs/dbus-glib-0.76
		deprecated? ( >=sys-power/upower-0.99:=[deprecated] )
	)
"
DEPEND="${COMMON_DEPEND}
	>=dev-lang/perl-5
	dev-libs/libxslt
	>=dev-util/intltool-0.40.6
	>=sys-devel/gettext-0.10.40
	virtual/pkgconfig
	!<gnome-base/gdm-2.20.4
	doc? (
		app-text/xmlto
		dev-libs/libxslt )
"
# gnome-common needed for eautoreconf
# gnome-base/gdm does not provide gnome.desktop anymore

src_prepare() {
	if use deprecated; then
		# From Funtoo:
		# 	https://bugs.funtoo.org/browse/FL-1329
		eapply "${FILESDIR}"/${PN}-3.16.0-restore-deprecated-code.patch
	fi

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	# 1. Support deprecated upower functionality
	# 2. xsltproc is always checked due to man configure
	#    switch, even if USE=-doc
	# 3. Enable old gconf support
	gnome2_src_configure \
		--enable-session-selector \
		$(use_enable deprecated) \
		$(use_enable doc docbook-docs) \
		$(use_enable gconf) \
		$(use_enable ipv6) \
		$(use_enable systemd) \
		$(use_enable !systemd consolekit)
		# gnome-session-selector pre-generated man page is missing
		#$(usex !doc XSLTPROC=$(type -P true))
}

src_install() {
	gnome2_src_install

	dodir /etc/X11/Sessions
	exeinto /etc/X11/Sessions
	doexe "${FILESDIR}/Gnome"

	insinto /usr/share/applications
	newins "${FILESDIR}/${PN}-3.16.0-defaults.list" gnome-mimeapps.list

	dodir /etc/X11/xinit/xinitrc.d/
	exeinto /etc/X11/xinit/xinitrc.d/
	newexe "${FILESDIR}/15-xdg-data-gnome-r1" 15-xdg-data-gnome

	# This should be done here as discussed in bug #270852
	newexe "${FILESDIR}/10-user-dirs-update-gnome-r1" 10-user-dirs-update-gnome

	# Set XCURSOR_THEME from current dconf setting instead of installing
	# default cursor symlink globally and affecting other DEs (bug #543488)
	# https://bugzilla.gnome.org/show_bug.cgi?id=711703
	newexe "${FILESDIR}/90-xcursor-theme-gnome" 90-xcursor-theme-gnome
}

pkg_postinst() {
	gnome2_pkg_postinst

	if ! has_version gnome-base/gdm && ! has_version kde-plasma/kdm; then
		ewarn "If you use a custom .xinitrc for your X session,"
		ewarn "make sure that the commands in the xinitrc.d scripts are run."
	fi
}
