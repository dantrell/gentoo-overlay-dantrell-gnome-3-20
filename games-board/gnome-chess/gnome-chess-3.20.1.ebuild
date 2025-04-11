# Distributed under the terms of the GNU General Public License v2

EAPI="6"
VALA_MIN_API_VERSION="0.28"
VALA_MAX_API_VERSION="0.34"

inherit gnome2 vala

DESCRIPTION="Play the classic two-player boardgame of chess"
HOMEPAGE="https://wiki.gnome.org/Apps/Chess https://gitlab.gnome.org/GNOME/gnome-chess"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="*"

IUSE="+engines"

RDEPEND="
	>=dev-libs/glib-2.40:2
	>=gnome-base/librsvg-2.32:2
	>=x11-libs/gtk+-3.19:3
	engines? (
		games-board/crafty
		games-board/gnuchess
		games-board/sjeng
		games-board/stockfish
	)
"
DEPEND="${RDEPEND}
	$(vala_depend)
	app-text/yelp-tools
	dev-libs/appstream-glib
	>=dev-util/intltool-0.50
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	# From GNOME:
	# 	https://gitlab.gnome.org/GNOME/gnome-chess/-/commit/21b0df604c56114eb721765d203f965b504403d7
	eapply "${FILESDIR}"/${PN}-3.24.1-gnome-chess-drop-use-of-g-module-export.patch

	vala_src_prepare
	gnome2_src_prepare
}

src_compile() {
	# Force Vala to regenerate C files
	emake clean

	gnome2_src_compile
}
