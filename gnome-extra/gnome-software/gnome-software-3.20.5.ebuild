# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit gnome2 virtualx

DESCRIPTION="GNOME utility for installing and updating applications"
HOMEPAGE="https://wiki.gnome.org/Apps/Software"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="firmware"

RDEPEND="
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
	firmware? (
		>=sys-apps/fwupd-0.7.0
		<sys-apps/fwupd-1.0
	)
	>=x11-libs/gdk-pixbuf-2.31.5
	>=x11-libs/gtk+-3.18.2:3
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/docbook-xml-dtd:4.2
	dev-libs/libxslt
	>=dev-util/intltool-0.35
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure \
		--enable-man \
		--disable-packagekit \
		--enable-polkit \
		--disable-xdg-app \
		$(use_enable firmware) \
		--disable-limba \
		--disable-dogtail
}

src_install() {
	default

	# From AppStream (the /usr/share/appdata location is deprecated):
	# 	https://www.freedesktop.org/software/appstream/docs/chap-Metadata.html#spec-component-location
	# 	https://bugs.gentoo.org/709450
	mv "${ED}"/usr/share/{appdata,metainfo} || die
}
