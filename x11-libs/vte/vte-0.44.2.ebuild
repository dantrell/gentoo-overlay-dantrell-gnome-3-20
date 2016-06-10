# Distributed under the terms of the GNU General Public License v2

EAPI="5"
GCONF_DEBUG="no"
VALA_USE_DEPEND="vapigen"

inherit eutils gnome2 vala

DESCRIPTION="Library providing a virtual terminal emulator widget"
HOMEPAGE="https://wiki.gnome.org/action/show/Apps/Terminal/VTE"

LICENSE="LGPL-2+"
SLOT="2.91"
KEYWORDS="*"

IUSE="+crypt debug glade +introspection vala"

RDEPEND="
	>=dev-libs/glib-2.40:2
	>=x11-libs/gtk+-3.8:3[introspection?]
	>=x11-libs/pango-1.22.0

	sys-libs/ncurses:0=
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXft

	glade? ( >=dev-util/glade-3.9:3.10 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.0:= )
"
DEPEND="${RDEPEND}
	$(vala_depend)
	>=dev-util/gtk-doc-am-1.13
	>=dev-util/intltool-0.35
	sys-devel/gettext
	virtual/pkgconfig

	crypt?  ( >=net-libs/gnutls-3.2.7 )
"
RDEPEND="${RDEPEND}
	!x11-libs/vte:2.90[glade]
"

src_prepare() {
	vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	local myconf=""

	if [[ ${CHOST} == *-interix* ]]; then
		myconf="${myconf} --disable-Bsymbolic"

		# interix stropts.h is empty...
		export ac_cv_header_stropts_h=no
	fi

	# Python bindings are via gobject-introspection
	# Ex: from gi.repository import Vte
	# FIXME: add USE for pcre
	gnome2_src_configure \
		--disable-test-application \
		--disable-static \
		$(use_enable debug) \
		$(use_enable glade glade-catalogue) \
		$(use_with crypt gnutls) \
		$(use_enable introspection) \
		$(use_enable vala) \
		${myconf}
}

src_install() {
	DOCS="AUTHORS ChangeLog HACKING NEWS README"
	gnome2_src_install
	mv "${D}"/etc/profile.d/vte{,-${SLOT}}.sh || die
}