# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome2 virtualx

DESCRIPTION="Gnome install & update software"
HOMEPAGE="https://wiki.gnome.org/Apps/Software"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE=""

RESTRICT="test"

RDEPEND="
	>=app-admin/packagekit-base-1.1.0
	app-crypt/libsecret
	app-text/gtkspell:3
	dev-db/sqlite:3
	>=dev-libs/appstream-glib-0.5.12:0
	>=dev-libs/glib-2.46:2
	>=dev-libs/json-glib-1.1.1
	>=gnome-base/gnome-desktop-3.17.92:3=
	>=gnome-base/gsettings-desktop-schemas-3.11.5
	>=net-libs/libsoup-2.51.92:2.4
	sys-auth/polkit
	>=x11-libs/gdk-pixbuf-2.31.5
	>=x11-libs/gtk+-3.18.2:3
"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.2
	dev-libs/libxslt
	>=dev-util/intltool-0.35
	virtual/pkgconfig
"

src_configure() {
	# FIXME: investigate limba and firmware update support
	gnome2_src_configure \
		--enable-man \
		--enable-packagekit \
		--enable-polkit \
		--disable-xdg-app \
		--disable-firmware \
		--disable-limba \
		--disable-dogtail
}
