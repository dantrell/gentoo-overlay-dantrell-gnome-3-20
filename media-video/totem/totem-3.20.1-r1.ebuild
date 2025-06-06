# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_LA_PUNT="yes" # plugins are dlopened
PYTHON_COMPAT=( python{3_10,3_11,3_12,3_13} )
PYTHON_REQ_USE="threads(+)"

inherit autotools gnome2 python-single-r1 vala

DESCRIPTION="Media player for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Videos"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="debug +introspection lirc nautilus +python test vanilla-thumbnailer"
# see bug #359379
REQUIRED_USE="
	python? ( introspection ${PYTHON_REQUIRED_USE} )
"

RESTRICT="!test? ( test )"

# FIXME:
# Runtime dependency on gnome-session-2.91
COMMON_DEPEND="
	>=dev-libs/glib-2.35:2[dbus]
	>=dev-libs/libpeas-1.1[gtk]
	>=dev-libs/libxml2-2.6:2
	>=dev-libs/totem-pl-parser-3.10.1:0=[introspection?]
	>=media-libs/clutter-1.17.3:1.0[gtk]
	>=media-libs/clutter-gst-2.99.2:3.0
	>=media-libs/clutter-gtk-1.7.1:1.0
	>=x11-libs/cairo-1.14
	>=x11-libs/gdk-pixbuf-2.23.0:2
	>=x11-libs/gtk+-3.19.4:3[introspection?]

	>=media-libs/grilo-0.3.0:0.3[playlist]
	>=media-libs/gstreamer-1.6.0:1.0
	>=media-libs/gst-plugins-base-1.6.0:1.0[X,introspection?,pango]
	media-libs/gst-plugins-good:1.0

	x11-libs/libX11

	gnome-base/gnome-desktop:3=
	gnome-base/gsettings-desktop-schemas

	introspection? ( >=dev-libs/gobject-introspection-0.6.7:= )
	lirc? ( app-misc/lirc )
	nautilus? ( >=gnome-base/nautilus-2.91.3 )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			>=dev-python/pygobject-2.90.3:3[${PYTHON_USEDEP}]
		')
	)
"
RDEPEND="${COMMON_DEPEND}
	media-plugins/grilo-plugins:0.3
	media-plugins/gst-plugins-meta:1.0
	media-plugins/gst-plugins-taglib:1.0
	x11-themes/adwaita-icon-theme
	python? (
		>=dev-libs/libpeas-1.1.0[python,${PYTHON_SINGLE_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/pyxdg[${PYTHON_USEDEP}]
			dev-python/dbus-python[${PYTHON_USEDEP}]
		')
	)
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.5
	app-text/yelp-tools
	dev-libs/appstream-glib
	>=dev-build/gtk-doc-am-1.14
	>=dev-util/intltool-0.50.1
	sys-devel/gettext
	virtual/pkgconfig
	x11-base/xorg-proto

	dev-libs/gobject-introspection-common
	gnome-base/gnome-common
"
# eautoreconf needs:
#	app-text/yelp-tools
#	dev-libs/gobject-introspection-common
#	gnome-base/gnome-common
# docbook-xml-dtd is needed for user doc
# Prevent dev-python/pylint dep, bug #482538

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	# Prevent pylint usage by tests, bug #482538
	sed -i -e 's/ check-pylint//' src/plugins/Makefile.plugins || die

	# Support the FFMPEG Thumbnailer out-of-the-box
	if ! use vanilla-thumbnailer; then
		sed -e "s/totem-video-thumbnailer/ffmpegthumbnailer/" \
			-e "s/-s %s %u %o/-i %i -o %o -s %s -c png -f/" \
			-i data/totem.thumbnailer.in
	fi

	eautoreconf
	vala_src_prepare
	gnome2_src_prepare

	# FIXME: upstream should provide a way to set GST_INSPECT, bug #358755 & co.
	# gst-inspect causes sandbox violations when a plugin needs write access to
	# /dev/dri/card* in its init phase.
	sed -e "s|\(gst10_inspect=\).*|\1$(type -P true)|" \
		-i configure || die
}

src_configure() {
	# Disabled: sample-python, sample-vala
	local plugins="apple-trailers,autoload-subtitles,brasero-disc-recorder"
	plugins+=",im-status,gromit,media-player-keys,ontop"
	plugins+=",properties,recent,rotation,screensaver,screenshot"
	plugins+=",skipto,vimeo"
	use lirc && plugins+=",lirc"
	use nautilus && plugins+=",save-file"
	use python && plugins+=",dbusservice,pythonconsole,opensubtitles"

	# pylint is checked unconditionally, but is only used for make check
	# appstream-util overriding necessary until upstream fixes their macro
	# to respect configure switch
	gnome2_src_configure \
		--disable-run-in-source-tree \
		--disable-static \
		--enable-easy-codec-installation \
		--enable-vala \
		$(use_enable introspection) \
		$(use_enable nautilus) \
		$(use_enable python) \
		PYLINT=$(type -P true) \
		APPSTREAM_UTIL=$(type -P true) \
		--with-plugins=${plugins}
}
