# Distributed under the terms of the GNU General Public License v2

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2 readme.gentoo

DESCRIPTION="The Gnome Terminal"
HOMEPAGE="https://wiki.gnome.org/Apps/Terminal/"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="*"

IUSE="debug +deprecated +gnome-shell +nautilus vanilla"

# FIXME: automagic dependency on gtk+[X]
RDEPEND="
	>=dev-libs/glib-2.42:2[dbus]
	>=x11-libs/gtk+-3.12:3[X]
	>=x11-libs/vte-0.44.0:2.91
	>=gnome-base/dconf-0.14
	>=gnome-base/gsettings-desktop-schemas-0.1.0
	sys-apps/util-linux
	x11-libs/libSM
	x11-libs/libICE
	gnome-shell? ( gnome-base/gnome-shell )
	nautilus? ( >=gnome-base/nautilus-3 )
"
# itstool required for help/* with non-en LINGUAS, see bug #549358
# xmllint required for glib-compile-resources, see bug #549304
DEPEND="${RDEPEND}
	app-text/yelp-tools
	dev-libs/libxml2
	dev-util/desktop-file-utils
	dev-util/gdbus-codegen
	dev-util/itstool
	>=dev-util/intltool-0.50
	sys-devel/gettext
	virtual/pkgconfig
"

DOC_CONTENTS="To get previous working directory inherited in new opened
	tab you will need to add the following line to your ~/.bashrc:\n
	. /etc/profile.d/vte.sh"

src_prepare() {
	if use deprecated; then
		# From Fedora:
		# 	http://pkgs.fedoraproject.org/cgit/rpms/gnome-terminal.git/tree/?h=f24
		epatch "${FILESDIR}"/${PN}-3-18-2-build-dont-treat-warnings-as-errors.patch
		epatch "${FILESDIR}"/${PN}-3.20.0-transparency.patch

		# From GNOME:
		# 	https://git.gnome.org/browse/gnome-terminal/commit/?id=b3c270b3612acd45f309521cf1167e1abd561c09
		epatch "${FILESDIR}"/${PN}-3.14.3-fix-broken-transparency-on-startup.patch
	fi

	if ! use vanilla; then
		# From Funtoo:
		# 	https://bugs.funtoo.org/browse/FL-1652
		epatch "${FILESDIR}"/${PN}-3.16.2-disable-function-keys.patch
	fi

	epatch_user

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-static \
		--disable-migration \
		$(use_enable debug) \
		$(use_enable gnome-shell search-provider) \
		$(use_with nautilus nautilus-extension) \
		VALAC=$(type -P true)
}

src_install() {
	DOCS="AUTHORS ChangeLog HACKING NEWS"
	gnome2_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	gnome2_pkg_postinst
	readme.gentoo_print_elog
}