# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools gnome2

DESCRIPTION="Personal task manager"
HOMEPAGE="https://wiki.gnome.org/Apps/Todo"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="*"

IUSE="+introspection"

RDEPEND="
	>=dev-libs/glib-2.43.4:2
	>=dev-libs/libical-0.43:=
	>=dev-libs/libpeas-1.17
	>=gnome-extra/evolution-data-server-3.17.1:=[gtk]
	>=net-libs/gnome-online-accounts-3.2:=
	>=x11-libs/gtk+-3.19.5:3

	introspection? ( >=dev-libs/gobject-introspection-1.42:= )
"
DEPEND="${RDEPEND}
	dev-libs/appstream-glib
	>=dev-util/intltool-0.40.6
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	# From GNOME:
	# 	https://gitlab.gnome.org/GNOME/gnome-todo/commit/6de8adc351b758c1d608ae0ea8acf6d35ed502ea
	eapply "${FILESDIR}"/${PN}-3.26.2-eds-build-with-libical-3-0.patch

	# From Arch:
	# 	https://git.archlinux.org/svntogit/packages.git/commit/?id=851b201268186ac89b1da6b1355775bee8167144
	eapply "${FILESDIR}"/${PN}-3.19.91-correct-linking-order.patch

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		$(use_enable introspection) \
		--enable-eds-plugin
}
