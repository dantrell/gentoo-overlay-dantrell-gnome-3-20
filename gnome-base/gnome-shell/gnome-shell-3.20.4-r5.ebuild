# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python{3_10,3_11,3_12,3_13} )

inherit autotools gnome2 multilib pax-utils python-r1 systemd

DESCRIPTION="Provides core UI functions for the GNOME desktop"
HOMEPAGE="https://wiki.gnome.org/Projects/GnomeShell https://gitlab.gnome.org/GNOME/gnome-shell"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="+bluetooth browser-extension ck +deprecated-background elogind +ibus +networkmanager nsplugin systemd vanilla-gc vanilla-motd vanilla-screen wayland"
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	?? ( ck elogind systemd )
"

# libXfixes-5.0 needed for pointer barriers and #include <X11/extensions/Xfixes.h>
COMMON_DEPEND="
	>=app-accessibility/at-spi2-atk-2.5.3
	>=dev-libs/atk-2[introspection]
	>=app-crypt/gcr-3.7.5:0=[introspection]
	>=dev-libs/glib-2.45.3:2[dbus]
	>=dev-libs/gjs-1.39
	>=dev-libs/gobject-introspection-1.45.4:=
	dev-libs/libical:=
	>=x11-libs/gtk+-3.15.0:3[introspection]
	>=media-libs/clutter-1.21.5:1.0[introspection]
	>=dev-libs/libcroco-0.6.8:0.6
	>=gnome-base/gnome-desktop-3.7.90:3=[introspection]
	>=gnome-base/gsettings-desktop-schemas-3.19.2
	>=gnome-base/gnome-keyring-3.3.90
	gnome-base/libgnome-keyring
	>=gnome-extra/evolution-data-server-3.17.2:=
	>=media-libs/gstreamer-0.11.92:1.0
	>=net-im/telepathy-logger-0.2.4[introspection]
	>=net-libs/telepathy-glib-0.19[introspection]
	>=sys-auth/polkit-0.100[introspection]
	>=x11-libs/libXfixes-5.0
	x11-libs/libXtst
	>=x11-wm/mutter-3.20.2[deprecated-background=,introspection]
	>=x11-libs/startup-notification-0.11

	${PYTHON_DEPS}
	dev-python/pygobject:3[${PYTHON_USEDEP}]

	dev-libs/dbus-glib
	dev-libs/libxml2:2
	gnome-base/librsvg
	media-libs/libcanberra[gtk3]
	wayland? ( media-libs/mesa )
	!wayland? ( media-libs/mesa[X(+)] )
	>=media-sound/pulseaudio-2
	>=net-libs/libsoup-2.40:2.4[introspection]
	x11-libs/libX11
	x11-libs/gdk-pixbuf:2[introspection]
	x11-libs/pango[introspection]
	x11-apps/mesa-progs

	bluetooth? ( >=net-wireless/gnome-bluetooth-3.9[introspection] )
	networkmanager? (
		app-crypt/libsecret
		>=gnome-extra/nm-applet-0.9.8
		>=net-misc/networkmanager-0.9.8:=[introspection] )
	nsplugin? ( >=dev-libs/json-glib-0.13.2 )
"
# Runtime-only deps are probably incomplete and approximate.
# Introspection deps generated using:
#  grep -roe "imports.gi.*" gnome-shell-* | cut -f2 -d: | sort | uniq
# Each block:
# 1. Introspection stuff needed via imports.gi.*
# 2. gnome-session is needed for gnome-session-quit
# 3. Control shell settings
# 4. Systemd optional for suspending support
# 5. xdg-utils needed for xdg-open, used by extension tool
# 6. adwaita-icon-theme and dejavu font neeed for various icons & arrows
# 7. mobile-broadband-provider-info, timezone-data for shell-mobile-providers.c
# 8. IBus is needed for nls integration
RDEPEND="${COMMON_DEPEND}
	>=app-accessibility/caribou-0.4.8
	media-libs/cogl[introspection]
	>=sys-apps/accountsservice-0.6.14[introspection]
	>=sys-power/upower-0.99:=[introspection]

	>=gnome-base/gnome-session-2.91.91
	>=gnome-base/gnome-settings-daemon-3.8.3

	ck? ( >=sys-power/upower-0.99:=[ck] )
	elogind? ( sys-auth/elogind )
	systemd? ( >=sys-apps/systemd-186:0= )

	x11-misc/xdg-utils

	media-fonts/dejavu
	>=x11-themes/adwaita-icon-theme-3.19.90

	networkmanager? (
		net-misc/mobile-broadband-provider-info
		sys-libs/timezone-data )
	ibus? ( >=app-i18n/ibus-1.4.99[dconf(+),gtk,introspection] )
"
# avoid circular dependency, see bug #546134
PDEPEND="
	>=gnome-base/gdm-3.5[introspection(+)]
	>=gnome-base/gnome-control-center-3.8.3[bluetooth(+)?,networkmanager(+)?]
	browser-extension? ( gnome-extra/gnome-browser-connector )
"
DEPEND="${COMMON_DEPEND}
	dev-libs/libxslt
	>=dev-build/gtk-doc-am-1.17
	>=dev-util/intltool-0.40
	gnome-base/gnome-common
	dev-build/autoconf-archive
	virtual/pkgconfig
	!!=dev-lang/spidermonkey-1.8.2*
"
# libmozjs.so is picked up from /usr/lib while compiling, so block at build-time
# https://bugs.gentoo.org/360413

src_prepare() {
	# From GNOME:
	# 	https://gitlab.gnome.org/GNOME/gnome-shell/-/commit/890a1f112b62d95678f765f71013ee4c2c68ab88
	eapply "${FILESDIR}"/${PN}-3.20.5-calendar-server-add-back-missing-return-value.patch

	if use ck; then
		# From Funtoo:
		# 	https://bugs.funtoo.org/browse/FL-1329
		eapply "${FILESDIR}"/${PN}-3.14.1-restore-deprecated-code.patch
		eapply "${FILESDIR}"/${PN}-3.12.2-expose-hibernate-functionality.patch
	fi

	if use deprecated-background; then
		eapply "${FILESDIR}"/${PN}-3.20.4-restore-deprecated-background-code.patch
	fi

	if ! use vanilla-gc; then
		# From GNOME:
		# 	https://gitlab.gnome.org/GNOME/gnome-shell/-/issues/64
		eapply "${FILESDIR}"/${PN}-3.14.4-force-garbage-collection.patch
	fi

	if ! use vanilla-motd; then
		eapply "${FILESDIR}"/${PN}-3.16.4-improve-motd-handling.patch
	fi

	if ! use vanilla-screen; then
		eapply "${FILESDIR}"/${PN}-3.16.4-improve-screen-blanking.patch
	fi

	# Change favorites defaults, bug #479918
	eapply "${FILESDIR}"/${PN}-3.20.0-defaults.patch

	# Fix automagic gnome-bluetooth dep, bug #398145
	eapply "${FILESDIR}"/${PN}-3.12-bluetooth-flag.patch

	# Fix silent bluetooth linking failure with ld.gold, bug #503952
	# https://bugzilla.gnome.org/show_bug.cgi?id=726435
	eapply "${FILESDIR}"/${PN}-3.14.0-bluetooth-gold.patch

	# From GNOME:
	# 	https://gitlab.gnome.org/GNOME/gnome-shell/-/commit/3033506f2c266115a00ff43daaad14e59e3215c5
	# 	https://gitlab.gnome.org/GNOME/gnome-shell/-/commit/87da623d86323a0744b8723e1991f053586defaf
	# 	https://gitlab.gnome.org/GNOME/gnome-shell/-/commit/9c41736a813354fd9291177b12f6c4f85bd1c5f7
	# 	https://gitlab.gnome.org/GNOME/gnome-shell/-/commit/5bca4a884e8f02441a89d7b44490339d869e5966
	eapply "${FILESDIR}"/${PN}-3.24.3-dnd-nullify-dragactor-after-weve-destroyed-it-and-avoid-invalid-access.patch
	eapply "${FILESDIR}"/${PN}-3.26.2-messagelist-stop-syncing-if-closebutton-has-been-destroyed.patch
	eapply "${FILESDIR}"/${PN}-3.26.2-automountmanager-remove-allowautorun-expire-timeout-on-volume-removal.patch
	eapply "${FILESDIR}"/${PN}-3.26.2-calendar-chain-up-to-parent-on-ondestroy.patch

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	# Do not error out on warnings
	gnome2_src_configure \
		--enable-man \
		$(use_with bluetooth) \
		$(use_enable networkmanager) \
		$(use_enable nsplugin browser-plugin) \
		$(use_enable systemd) \
		BROWSER_PLUGIN_DIR="${EPREFIX}"/usr/$(get_libdir)/nsbrowser/plugins
}

src_install() {
	gnome2_src_install
	python_replicate_script "${ED}/usr/bin/gnome-shell-extension-tool"
	python_replicate_script "${ED}/usr/bin/gnome-shell-perf-tool"

	# Required for gnome-shell on hardened/PaX, bug #398941
	# Future-proof for >=spidermonkey-1.8.7 following polkit's example
	if has_version '<dev-lang/spidermonkey-1.8.7'; then
		pax-mark mr "${ED}usr/bin/gnome-shell"{,-extension-prefs}
	elif has_version '>=dev-lang/spidermonkey-1.8.7[jit]'; then
		pax-mark m "${ED}usr/bin/gnome-shell"{,-extension-prefs}
	# Required for gnome-shell on hardened/PaX #457146 and #457194
	# PaX EMUTRAMP need to be on
	elif has_version '>=dev-libs/libffi-3.0.13[pax_kernel]'; then
		pax-mark E "${ED}usr/bin/gnome-shell"{,-extension-prefs}
	else
		pax-mark m "${ED}usr/bin/gnome-shell"{,-extension-prefs}
	fi
}

pkg_postinst() {
	gnome2_pkg_postinst

	if ! has_version 'media-libs/gst-plugins-good:1.0' || \
	   ! has_version 'media-plugins/gst-plugins-vpx:1.0'; then
		ewarn "To make use of GNOME Shell's built-in screen recording utility,"
		ewarn "you need to either install media-libs/gst-plugins-good:1.0"
		ewarn "and media-plugins/gst-plugins-vpx:1.0, or use dconf-editor to change"
		ewarn "apps.gnome-shell.recorder/pipeline to what you want to use."
	fi

	if ! has_version "media-libs/mesa[llvm]"; then
		elog "llvmpipe is used as fallback when no 3D acceleration"
		elog "is available. You will need to enable llvm USE for"
		elog "media-libs/mesa if you do not have hardware 3D setup."
	fi

	# https://bugs.gentoo.org/563084
	if has_version "x11-drivers/nvidia-drivers[-kms]"; then
		ewarn "You will need to enable kms support in x11-drivers/nvidia-drivers,"
		ewarn "otherwise Gnome will fail to start"
	fi

	if use systemd && [[ ! -d /run/systemd/system ]]; then
		ewarn "You have installed GNOME Shell *with* systemd support"
		ewarn "but the system was not booted using systemd."
		ewarn "To correct this, reference: https://wiki.gentoo.org/wiki/Systemd"
	fi

	if ! use systemd; then
		ewarn "You have installed GNOME Shell *without* systemd support."
		ewarn "To report issues, see: https://github.com/dantrell/gentoo-project-gnome-without-systemd/blob/master/GOVERNANCE.md#bugs-and-other-issues"
	fi
}
