# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome2 virtualx

DESCRIPTION="Libraries for the gnome desktop that are not part of the UI"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-desktop"

LICENSE="GPL-2+ FDL-1.1+ LGPL-2+"
SLOT="3/12" # subslot = libgnome-desktop-3 soname version
KEYWORDS="*"

IUSE="debug +introspection"

# cairo[X] needed for gnome-bg
COMMON_DEPEND="
	app-text/iso-codes
	>=dev-libs/glib-2.44.0:2[dbus]
	>=x11-libs/gdk-pixbuf-2.33.0:2[introspection?]
	>=x11-libs/gtk+-3.3.6:3[X,introspection?]
	>=x11-libs/libXext-1.1
	>=x11-libs/libXrandr-1.3
	x11-libs/cairo:=[X]
	x11-libs/libX11
	x11-misc/xkeyboard-config
	>=gnome-base/gsettings-desktop-schemas-3.5.91
	introspection? ( >=dev-libs/gobject-introspection-0.9.7:= )
"
RDEPEND="${COMMON_DEPEND}
	sys-apps/hwdata
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.1.2
	dev-util/gdbus-codegen
	>=dev-util/gtk-doc-am-1.14
	>=dev-util/intltool-0.40.6
	dev-util/itstool
	sys-devel/gettext
	x11-base/xorg-proto
	virtual/pkgconfig
"

# Includes X11/Xatom.h in libgnome-desktop/gnome-bg.c which comes from xproto
# Includes X11/extensions/Xrandr.h that includes randr.h from randrproto (and
# eventually libXrandr shouldn't RDEPEND on randrproto)

src_configure() {
	gnome2_src_configure \
		--disable-static \
		--with-gnome-distributor=Gentoo \
		--enable-desktop-docs \
		--with-pnp-ids-path=/usr/share/hwdata/pnp.ids \
		$(usex debug --enable-debug=yes ' ') \
		$(use_enable debug debug-tools) \
		$(use_enable introspection)
}

src_test() {
	virtx emake check
}
