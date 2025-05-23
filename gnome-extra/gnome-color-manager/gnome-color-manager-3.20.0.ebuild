# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit gnome2 virtualx

DESCRIPTION="GNOME color profile tools"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-color-manager"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="raw"

# Need gtk+-3.3.8 for https://bugzilla.gnome.org/show_bug.cgi?id=673331
RDEPEND="
	>=dev-libs/glib-2.31.10:2
	>=x11-libs/gtk+-3.3.8:3
	>=x11-misc/colord-1.3.1:0=
	>=media-libs/lcms-2.2:2

	media-libs/libexif
	media-libs/tiff:=
	>=x11-libs/colord-gtk-0.1.20
	>=media-libs/libcanberra-0.10[gtk3]
	>=x11-libs/vte-0.25.1:2.91

	raw? ( media-gfx/exiv2:0= )
"
DEPEND="${RDEPEND}"
# docbook-sgml-{utils,dtd:4.1} needed to generate man pages
BDEPEND="
	app-text/docbook-sgml-dtd:4.1
	app-text/docbook-sgml-utils
	dev-libs/appstream-glib
	dev-libs/libxslt
	>=dev-util/intltool-0.35
	dev-util/itstool
	virtual/pkgconfig
"

PATCHES=(
	# From GNOME:
	# 	https://gitlab.gnome.org/GNOME/gnome-color-manager/-/issues/4
	# 	https://bugs.gentoo.org/674086
	#
	# From Exiv2:
	# 	https://github.com/Exiv2/exiv2/issues/2630
	"${FILESDIR}"/${PN}-3.30.0-exiv2-0.28.patch
)

src_configure() {
	# Always enable tests since they are check_PROGRAMS anyway
	gnome2_src_configure \
		--disable-static \
		--enable-tests \
		--disable-packagekit \
		$(use_enable raw exiv) \
		APPSTREAM_UTIL=$(type -P true)
}

src_test() {
	virtx emake check
}

src_install() {
	gnome2_src_install

	# From AppStream (the /usr/share/appdata location is deprecated):
	# 	https://www.freedesktop.org/software/appstream/docs/chap-Metadata.html#spec-component-location
	# 	https://bugs.gentoo.org/709450
	mv "${ED}"/usr/share/{appdata,metainfo} || die

	find "${ED}" -type f -name "*.la" -delete || die
}

pkg_postinst() {
	gnome2_pkg_postinst

	if ! has_version media-gfx/argyllcms ; then
		elog "If you want to do display or scanner calibration, you will need to"
		elog "install media-gfx/argyllcms"
	fi
}
