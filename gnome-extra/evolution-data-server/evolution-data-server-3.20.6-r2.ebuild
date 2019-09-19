# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python{2_7,3_5,3_6,3_7} pypy )
VALA_USE_DEPEND="vapigen"

inherit autotools db-use flag-o-matic gnome2 python-any-r1 systemd vala virtualx

DESCRIPTION="Evolution groupware backend"
HOMEPAGE="https://wiki.gnome.org/Apps/Evolution"

# Note: explicitly "|| ( LGPL-2 LGPL-3 )", not "LGPL-2+".
LICENSE="|| ( LGPL-2 LGPL-3 ) BSD Sleepycat"
SLOT="0/57" # subslot = libcamel-1.2 soname version
KEYWORDS="*"

IUSE="api-doc-extras +berkdb +gnome-online-accounts +gtk google +introspection ipv6 ldap kerberos vala +weather"
REQUIRED_USE="vala? ( introspection )"

# Some tests fail due to missing locales.
# Also, dbus tests are flaky, bugs #397975 #501834
# It looks like a nightmare to disable those for now.
RESTRICT="test"

# gdata-0.15.1 is required for google tasks
# berkdb needed only for migrating old addressbook data from <3.13 versions, bug #519512
RDEPEND="
	>=app-crypt/gcr-3.4
	>=app-crypt/libsecret-0.5[crypt]
	>=dev-db/sqlite-3.7.17:=
	>=dev-libs/glib-2.40:2
	>=dev-libs/libgdata-0.10:=
	>=dev-libs/libical-0.43:=
	>=dev-libs/libxml2-2
	>=dev-libs/nspr-4.4:=
	>=dev-libs/nss-3.9:=
	>=net-libs/libsoup-2.42:2.4

	dev-libs/icu:=
	sys-libs/zlib:=
	virtual/libiconv

	berkdb? ( >=sys-libs/db-4:= )
	gtk? (
		>=app-crypt/gcr-3.4[gtk]
		>=x11-libs/gtk+-3.10:3
	)
	google? (
		>=dev-libs/json-glib-1.0.4
		>=dev-libs/libgdata-0.15.1:=
		>=net-libs/webkit-gtk-2.11.91:4
	)
	gnome-online-accounts? ( >=net-libs/gnome-online-accounts-3.8:= )
	introspection? ( >=dev-libs/gobject-introspection-0.9.12:= )
	kerberos? ( virtual/krb5:= )
	ldap? ( >=net-nds/openldap-2:= )
	weather? ( >=dev-libs/libgweather-3.10:2= )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-util/gdbus-codegen
	dev-util/gperf
	>=dev-util/gtk-doc-am-1.14
	>=dev-util/intltool-0.35.5
	>=gnome-base/gnome-common-2
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

pkg_setup() {
	python-any-r1_pkg_setup
}

src_prepare() {
	# From GNOME:
	# 	https://gitlab.gnome.org/GNOME/evolution-data-server/commit/8a829b614c6d18d9bad74dcb8ed3ba0b2590fb90
	# 	https://gitlab.gnome.org/GNOME/evolution-data-server/commit/292c7ef22c60cab709974c0da421666deb6239fb
	# 	https://gitlab.gnome.org/GNOME/evolution-data-server/commit/c9da0712f20baf5bdfdd2f1fa9d26e7204c6f685
	# 	https://gitlab.gnome.org/GNOME/evolution-data-server/commit/aad7e7c2e78b12dd632623961d51a36f94b6ca37
	# 	https://gitlab.gnome.org/GNOME/evolution-data-server/commit/6c3cff9821913913aac2c8391771f0e978e501a9
	# 	https://gitlab.gnome.org/GNOME/evolution-data-server/commit/8d07e3f02a63fbc1bc3a381b088ec2913f21c118
	eapply "${FILESDIR}"/${PN}-3.21.2-bug-765646-camel-add-some-missing-annotations.patch
	eapply "${FILESDIR}"/${PN}-3.21.3-camelgpgcontext-provide-signer-photos-when-available.patch
	eapply "${FILESDIR}"/${PN}-3.21.4-bug-764065-camel-use-get-methods-for-camelmessageinfo-fields.patch
	eapply "${FILESDIR}"/${PN}-3.21.4-bug-768496-fix-some-camel-annotations-and-rename-structures.patch
	eapply "${FILESDIR}"/${PN}-3.21.90-bug-751588-port-to-webkit2.patch
	eapply "${FILESDIR}"/${PN}-3.21.91-rename-webkitgtk-minimum-version-to-webkit2gtk-minimum-version.patch

	# From GNOME:
	# 	https://bugzilla.gnome.org/show_bug.cgi?id=795295
	eapply "${FILESDIR}"/${PN}-3.13.90-bug-795295-fails-to-compile-after-icu-61-1-upgrade-icuunicodestring.patch

	eautoreconf
	use vala && vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	# /usr/include/db.h is always db-1 on FreeBSD
	# so include the right dir in CPPFLAGS
	use berkdb && append-cppflags "-I$(db_includedir)"

	# phonenumber does not exist in tree
	gnome2_src_configure \
		$(use_enable api-doc-extras gtk-doc) \
		$(use_with api-doc-extras private-docs) \
		$(usex berkdb --with-libdb="${EPREFIX}"/usr --with-libdb=no) \
		$(use_enable gnome-online-accounts goa) \
		$(use_enable gtk) \
		$(use_enable google google-auth) \
		$(use_enable google) \
		$(use_enable introspection) \
		$(use_enable ipv6) \
		$(use_with kerberos krb5 "${EPREFIX}"/usr) \
		$(use_with kerberos krb5-libs "${EPREFIX}"/usr/$(get_libdir)) \
		$(use_with ldap openldap) \
		$(use_enable vala vala-bindings) \
		$(use_enable weather) \
		--enable-largefile \
		--enable-smime \
		--with-systemduserunitdir="$(systemd_get_userunitdir)" \
		--without-phonenumber \
		--disable-examples \
		--disable-uoa
}

src_test() {
	unset ORBIT_SOCKETDIR
	unset SESSION_MANAGER
	virtx emake check
}

src_install() {
	gnome2_src_install

	if use ldap; then
		insinto /etc/openldap/schema
		doins "${FILESDIR}"/calentry.schema
		dosym /usr/share/${PN}/evolutionperson.schema /etc/openldap/schema/evolutionperson.schema
	fi
}

pkg_postinst() {
	gnome2_pkg_postinst
	if ! use berkdb; then
		ewarn "You will need to enable berkdb USE for migrating old"
		ewarn "(pre-3.13 evolution versions) addressbook data"
	fi
}
