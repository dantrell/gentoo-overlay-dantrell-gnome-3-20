# Distributed under the terms of the GNU General Public License v2

EAPI="6"
VALA_USE_DEPEND="vapigen"

inherit gnome2 vala

DESCRIPTION="Library providing a virtual terminal emulator widget"
HOMEPAGE="https://wiki.gnome.org/Apps/Terminal/VTE"

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

	crypt?  ( >=net-libs/gnutls-3.2.7:0= )
	glade? ( >=dev-util/glade-3.9:3.10 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.0:= )
"
DEPEND="${RDEPEND}
	>=dev-build/gtk-doc-am-1.13
	>=dev-util/intltool-0.35
	sys-devel/gettext
	virtual/pkgconfig

	vala? ( $(vala_depend) )
"
RDEPEND="${RDEPEND}
	!x11-libs/vte:2.90[glade]
"

src_prepare() {
	use vala && vala_src_prepare

	# build fails because of -Werror with gcc-5.x
	sed -e 's#-Werror=format=2#-Wformat=2#' -i configure || die "sed failed"

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
	gnome2_src_install
	mv "${ED}"/etc/profile.d/vte{,-${SLOT}}.sh || die
}
