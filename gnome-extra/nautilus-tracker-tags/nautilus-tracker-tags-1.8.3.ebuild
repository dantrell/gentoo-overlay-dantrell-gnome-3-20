# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME_ORG_MODULE="tracker"

inherit gnome.org toolchain-funcs

DESCRIPTION="Nautilus extension to tag files for Tracker"
HOMEPAGE="https://wiki.gnome.org/Projects/Tracker"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

IUSE=""

COMMON_DEPEND="
	~app-misc/tracker-${PV}:0=
	>=dev-libs/glib-2.38:2
	>=gnome-base/nautilus-2.90
	x11-libs/gtk+:3
"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}"

S="${S}/src/plugins/nautilus"

pkg_setup() {
	tc-export CC
	export TRACKER_API=1.0
}

src_prepare() {
	default
	cp "${FILESDIR}"/0.12.5-Makefile Makefile || die "cp failed"
	# config.h is not used, but is included in every source file...
	sed -e 's:#include "config.h"::' -i *.c *.h || die "sed failed"
}
