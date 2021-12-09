# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit gnome2

DESCRIPTION="The Gnome System Monitor"
HOMEPAGE="https://help.gnome.org/users/gnome-system-monitor/stable/"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="systemd X"

RDEPEND="
	>=dev-cpp/glibmm-2.34:2
	>=dev-libs/glib-2.37.3:2
	>=x11-libs/gtk+-3.12:3[X(+)]
	>=dev-cpp/gtkmm-3.3.18:3.0
	>=gnome-base/libgtop-2.28.2:2=
	>=gnome-base/librsvg-2.35:2
	>=dev-libs/libxml2-2.0:2
	X? ( >=x11-libs/libwnck-2.91.0:3 )
	systemd? ( >=sys-apps/systemd-44:0= )
"
DEPEND="${RDEPEND}"
# eautoreconf requires gnome-base/gnome-common
BDEPEND="
	>=app-text/gnome-doc-utils-0.20
	>=dev-util/intltool-0.41.0
	dev-util/itstool
	virtual/pkgconfig
	>=sys-auth/polkit-0.114
" # polkit needed at buildtime for ITS rules of policy files, first available in 0.114

src_configure() {
	gnome2_src_configure \
		$(use_enable systemd) \
		$(use_enable X wnck)
}
