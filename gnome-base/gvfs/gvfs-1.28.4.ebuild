# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_LA_PUNT="yes"

inherit autotools bash-completion-r1 gnome2

DESCRIPTION="Virtual filesystem implementation for GIO"
HOMEPAGE="https://wiki.gnome.org/Projects/gvfs"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="afp archive bluray cdda fuse google gnome-keyring gnome-online-accounts gphoto2 gtk +http ios mtp nfs samba systemd test +udev udisks zeroconf"
REQUIRED_USE="
	cdda? ( udev )
	google? ( gnome-online-accounts )
	mtp? ( udev )
	udisks? ( udev )
	systemd? ( udisks )
"

# Tests with multiple failures, this is being handled upstream at:
# https://bugzilla.gnome.org/700162
RESTRICT="test"

# Can use libgphoto-2.5.0 as well. Automagic detection.
RDEPEND="
	app-crypt/gcr:0=
	>=dev-libs/glib-2.46.2:2
	sys-apps/dbus
	dev-libs/libxml2:2
	net-misc/openssh
	afp? ( >=dev-libs/libgcrypt-1.2.2:0= )
	archive? ( app-arch/libarchive:= )
	bluray? ( media-libs/libbluray:= )
	fuse? ( >=sys-fs/fuse-2.8.0 )
	gnome-keyring? ( app-crypt/libsecret )
	gnome-online-accounts? ( >=net-libs/gnome-online-accounts-3.7.1:= )
	google? (
		>=dev-libs/libgdata-0.17.3:=[crypt,gnome-online-accounts]
		>=net-libs/gnome-online-accounts-3.17.1:= )
	gphoto2? ( >=media-libs/libgphoto2-2.4.7:= )
	gtk? ( >=x11-libs/gtk+-3.0:3 )
	http? ( >=net-libs/libsoup-2.42:2.4 )
	ios? (
		>=app-pda/libimobiledevice-1.2:=
		>=app-pda/libplist-1:= )
	mtp? ( >=media-libs/libmtp-1.1.6 )
	nfs? ( >=net-fs/libnfs-1.9.7:= )
	samba? (
		sys-libs/libunwind:=
		>=net-fs/samba-4[client] )
	systemd? ( sys-apps/systemd:0= )
	udev? (
		cdda? ( dev-libs/libcdio-paranoia )
		dev-libs/libgudev:=
		virtual/libudev:= )
	udisks? ( >=sys-fs/udisks-1.97:2 )
	zeroconf? ( >=net-dns/avahi-0.6[dbus] )
"
DEPEND="${RDEPEND}
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	dev-util/gdbus-codegen
	dev-build/gtk-doc-am
	test? (
		>=dev-python/twisted-16
		|| (
			net-analyzer/netcat
			net-analyzer/netcat6 ) )
	!udev? ( >=dev-libs/libgcrypt-1.2.2:0 )
"
# libgcrypt.m4, provided by libgcrypt, needed for eautoreconf, bug #399043
# test dependencies needed per https://bugzilla.gnome.org/700162

src_prepare() {
	# From GNOME:
	# 	https://gitlab.gnome.org/GNOME/gvfs/-/commit/3424bef7ef71dc3a8c2c71310671cd6d39e7b3e7
	eapply "${FILESDIR}"/${PN}-1.31.4-metadata-include-headers-for-device-number-functionality.patch

	if ! use udev; then
		sed -e 's/gvfsd-burn/ /' \
			-e 's/burn.mount.in/ /' \
			-e 's/burn.mount/ /' \
			-i daemon/Makefile.am || die
	fi

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	# --enable-documentation installs man pages
	# --disable-obexftp, upstream bug #729945
	gnome2_src_configure \
		--enable-bash-completion \
		--with-bash-completion-dir="$(get_bashcompdir)" \
		--enable-gcr \
		--disable-gdu \
		--disable-hal \
		--with-dbus-service-dir="${EPREFIX}"/usr/share/dbus-1/services \
		--enable-documentation \
		$(use_enable afp) \
		$(use_enable archive) \
		$(use_enable bluray) \
		$(use_enable cdda) \
		$(use_enable fuse) \
		$(use_enable gnome-keyring keyring) \
		$(use_enable gnome-online-accounts goa) \
		$(use_enable google) \
		$(use_enable gphoto2) \
		$(use_enable gtk) \
		$(use_enable ios afc) \
		$(use_enable mtp libmtp) \
		$(use_enable nfs) \
		$(use_enable udev) \
		$(use_enable udev gudev) \
		$(use_enable http) \
		$(use_enable samba) \
		$(use_enable systemd libsystemd-login) \
		$(use_enable udisks udisks2) \
		$(use_enable zeroconf avahi)
}
