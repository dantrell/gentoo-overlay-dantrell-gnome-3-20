# Distributed under the terms of the GNU General Public License v2

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="A calculator application for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Calculator"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

IUSE=""

COMMON_DEPEND="
	dev-libs/libxml2:2
	dev-libs/mpfr:0
	>=dev-libs/glib-2.40:2
	>=net-libs/libsoup-2.42:2.4
	>=x11-libs/gtk+-3.11.6:3
	>=x11-libs/gtksourceview-3.15.1:3.0
"
RDEPEND="${COMMON_DEPEND}
	!<gnome-extra/gnome-utils-2.3
	!gnome-extra/gcalctool
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.50
	dev-util/itstool
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure \
		--disable-static \
		VALAC=$(type -P true)
}
