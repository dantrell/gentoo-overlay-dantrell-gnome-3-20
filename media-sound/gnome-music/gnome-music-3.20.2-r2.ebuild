# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python{3_6,3_7,3_8} )

inherit gnome2 python-r1

DESCRIPTION="Music management for Gnome"
HOMEPAGE="https://wiki.gnome.org/Apps/Music"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="
	${PYTHON_DEPS}
	>=app-misc/tracker-1.7.1[introspection(+)]
	dev-python/pygobject:3[cairo,${PYTHON_USEDEP}]
	>=dev-libs/glib-2.28:2
	>=dev-libs/gobject-introspection-1.35.9:=
	>=media-libs/grilo-0.3.0:0.3[introspection]
	media-libs/libmediaart:2.0[introspection]
	>=x11-libs/gtk+-3.19.3:3[introspection]
"
# xdg-user-dirs-update needs to be there to create needed dirs
# https://bugzilla.gnome.org/show_bug.cgi?id=731613
RDEPEND="${COMMON_DEPEND}
	|| (
		app-misc/tracker[gstreamer]
		app-misc/tracker[ffmpeg]
	)
	x11-libs/libnotify[introspection]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	media-libs/gstreamer:1.0[introspection]
	media-libs/gst-plugins-base:1.0[introspection]
	media-plugins/gst-plugins-meta:1.0
	media-plugins/grilo-plugins:0.3[tracker]
	x11-misc/xdg-user-dirs
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.26
	dev-util/itstool
	virtual/pkgconfig
"

pkg_setup() {
	python_setup
}

src_prepare() {
	sed -e '/sys.path.insert/d' -i "${S}"/gnome-music.in || die "python fixup sed failed"
	gnome2_src_prepare
}

src_install() {
	gnome2_src_install
	python_fix_shebang "${D}"usr/bin/gnome-music
}
