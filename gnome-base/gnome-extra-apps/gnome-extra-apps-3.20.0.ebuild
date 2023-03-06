# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Metapackage for GNOME applications"
HOMEPAGE="https://www.gnome.org/"

LICENSE="metapackage"
SLOT="3.0"
KEYWORDS="*"

IUSE="anjuta +bijiben boxes builder california empathy epiphany +evolution flashback +fonts +games gconf geary +ghex gnote gpaste latexila multiwriter +polari +share +shotwell simple-scan software +todo +tracker"

# Cantarell doesn't provide support for modern emojis so we pair it with Noto,.Symbola, and Unifont:
#
# 	https://bugzilla.gnome.org/show_bug.cgi?id=762890
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}

	>=app-admin/gnome-system-log-20170809
	>=app-arch/file-roller-${PV}
	>=app-dicts/gnome-dictionary-${PV}
	>=gnome-base/dconf-editor-${PV}
	>=gnome-extra/gnome-calculator-${PV}
	>=gnome-extra/gnome-calendar-${PV}
	>=gnome-extra/gnome-characters-${PV}
	>=gnome-extra/gnome-clocks-${PV}
	>=gnome-extra/gnome-getting-started-docs-${PV}
	>=gnome-extra/gnome-power-manager-${PV}
	>=gnome-extra/gnome-search-tool-3.6
	>=gnome-extra/gnome-system-monitor-${PV}
	>=gnome-extra/gnome-tweaks-${PV}
	>=gnome-extra/gnome-weather-${PV}
	>=gnome-extra/gucharmap-11.0.0:2.90
	>=gnome-extra/nautilus-sendto-3.8.5
	>=gnome-extra/sushi-${PV}
	>=media-gfx/gnome-font-viewer-${PV}
	>=media-gfx/gnome-screenshot-${PV}
	>=media-sound/gnome-sound-recorder-${PV}
	>=media-sound/sound-juicer-${PV}
	>=media-video/cheese-${PV}
	>=net-analyzer/gnome-nettool-3.8
	>=net-misc/vinagre-${PV}
	>=net-misc/vino-${PV}
	>=sci-geosciences/gnome-maps-${PV}
	>=sys-apps/baobab-${PV}
	>=sys-apps/gnome-disk-utility-${PV}

	anjuta? ( >=dev-util/anjuta-${PV} )
	bijiben? ( >=app-misc/bijiben-${PV} )
	boxes? ( >=gnome-extra/gnome-boxes-${PV} )
	builder? ( >=dev-util/gnome-builder-3.18.0 )
	california? ( >=gnome-extra/california-0.4.0 )
	empathy? ( >=net-im/empathy-3.12.13 )
	epiphany? ( >=www-client/epiphany-${PV} )
	evolution? ( >=mail-client/evolution-${PV} )
	flashback? ( >=gnome-base/gnome-flashback-${PV} )
	fonts? (
		>=media-fonts/noto-20181024
		>=media-fonts/symbola-9.17
		>=media-fonts/unifont-13.0.01 )
	games? (
		>=games-arcade/gnome-nibbles-${PV}
		>=games-arcade/gnome-robots-${PV}
		>=games-board/aisleriot-${PV}
		>=games-board/four-in-a-row-${PV}
		>=games-board/gnome-chess-${PV}
		>=games-board/gnome-mahjongg-${PV}
		>=games-board/gnome-mines-${PV}
		>=games-board/iagno-${PV}
		>=games-board/tali-${PV}
		>=games-puzzle/atomix-${PV}
		>=games-puzzle/five-or-more-${PV}
		>=games-puzzle/gnome2048-${PV}
		>=games-puzzle/gnome-klotski-${PV}
		>=games-puzzle/gnome-sudoku-${PV}
		>=games-puzzle/gnome-taquin-${PV}
		>=games-puzzle/gnome-tetravex-${PV}
		>=games-puzzle/hitori-${PV}
		>=games-puzzle/lightsoff-${PV}
		>=games-puzzle/quadrapassel-${PV}
		>=games-puzzle/swell-foop-${PV} )
	gconf? ( >=gnome-extra/gconf-editor-3 )
	geary? ( >=mail-client/geary-0.12.4 )
	ghex? ( >=app-editors/ghex-3.18.4 )
	gnote? ( >=app-misc/gnote-${PV} )
	gpaste? ( >=x11-misc/gpaste-${PV} )
	latexila? ( >=app-editors/latexila-${PV} )
	multiwriter? ( >=gnome-extra/gnome-multi-writer-${PV} )
	polari? ( >=net-irc/polari-${PV} )
	share? ( >=gnome-extra/gnome-user-share-3.18.1 )
	shotwell? ( >=media-gfx/shotwell-0.24 )
	simple-scan? ( >=media-gfx/simple-scan-${PV} )
	software? ( >=gnome-extra/gnome-software-${PV} )
	todo? ( >=app-office/gnome-todo-${PV} )
	tracker? (
		>=app-misc/tracker-1.8:0=
		>=gnome-extra/gnome-documents-${PV}
		>=media-gfx/gnome-photos-${PV}
		>=media-sound/gnome-music-${PV} )
"
DEPEND=""

S="${WORKDIR}"
