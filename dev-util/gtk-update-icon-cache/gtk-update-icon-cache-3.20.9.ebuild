# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome2

DESCRIPTION="GTK update icon cache"
HOMEPAGE="http://www.gtk.org/ https://github.com/EvaSDK/gtk-update-icon-cache"
SRC_URI="https://dev.gentoo.org/~eva/distfiles/${PN}/${P}.tar.xz http://files.mirthil.org/distfiles/${PN}/${P}.tar.xz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE=""

RESTRICT="mirror"

RDEPEND="
	>=dev-libs/glib-2.45.8:2
	>=x11-libs/gdk-pixbuf-2.30:2
	!<x11-libs/gtk+-2.24.28-r1:2
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.50.1
	sys-devel/gettext
	virtual/pkgconfig
"
