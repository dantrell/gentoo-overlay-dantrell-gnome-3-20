# Distributed under the terms of the GNU General Public License v2

EAPI="6"
VALA_MAX_API_VERSION="0.34"

inherit autotools gnome2 vala

DESCRIPTION="Simple document scanning utility"
HOMEPAGE="https://launchpad.net/simple-scan"
SRC_URI="https://gitlab.gnome.org/GNOME/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"

IUSE="+colord packagekit"

COMMON_DEPEND="
	>=dev-libs/glib-2.32:2
	dev-libs/libgusb:=[vala]
	>=media-gfx/sane-backends-1.0.20:=
	>=sys-libs/zlib-1.2.3.1:=
	virtual/jpeg:0=
	x11-libs/cairo:=
	>=x11-libs/gtk+-3:3
	colord? ( >=x11-misc/colord-0.1.24:=[udev] )
	packagekit? ( app-admin/packagekit-base )
"
RDEPEND="${COMMON_DEPEND}
	x11-misc/xdg-utils
	x11-themes/adwaita-icon-theme
"
DEPEND="${COMMON_DEPEND}
	$(vala_depend)
	app-text/yelp-tools
	>=dev-util/intltool-0.35.0
	virtual/pkgconfig
"

src_prepare() {
	eautoreconf
	vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		$(use_enable colord) \
		$(use_enable packagekit)
}

src_compile() {
	# From Simple Scan:
	# 	https://bugs.launchpad.net/simple-scan/+bug/1462769
	if ! use packagekit; then
		# Force Vala to regenerate C files
		emake clean
	fi

	gnome2_src_compile
}
