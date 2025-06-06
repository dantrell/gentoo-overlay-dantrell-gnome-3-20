# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome2

DESCRIPTION="GNOME docking library"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gdl"

LICENSE="LGPL-2.1+"
SLOT="3/5" # subslot = libgdl-3 soname version
KEYWORDS="*"

IUSE="+introspection"

RDEPEND="
	dev-libs/glib:2
	>=x11-libs/gtk+-3.0.0:3[introspection?]
	>=dev-libs/libxml2-2.4:2
	introspection? ( >=dev-libs/gobject-introspection-0.6.7:= )
"
DEPEND="${RDEPEND}
	>=dev-build/gtk-doc-am-1.4
	>=dev-util/intltool-0.40.4
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure $(use_enable introspection)
}
