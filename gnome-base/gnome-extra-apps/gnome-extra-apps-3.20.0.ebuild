# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="Sub-meta package for the applications of GNOME 3"
HOMEPAGE="https://www.gnome.org/"

LICENSE="metapackage"
SLOT="3.0"
# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="*"

IUSE="+bijiben boxes builder california epiphany +evolution flashback +fonts +games geary +share +shotwell +todo +tracker"

# Note to developers:
# This is a wrapper for the extra apps integrated with GNOME 3
# New package
#
# cantarell upstream relies on noto, unifont and symbola fonts for
# the fonts they cannot handle due to lack of enough manpower:
# https://bugzilla.gnome.org/show_bug.cgi?id=762890
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}

	>=app-admin/gnome-system-log-20160820
	>=app-arch/file-roller-${PV}
	>=app-dicts/gnome-dictionary-${PV}
	>=gnome-base/dconf-editor-${PV}
	>=gnome-extra/gconf-editor-3
	>=gnome-extra/gnome-calculator-${PV}
	>=gnome-extra/gnome-calendar-${PV}
	>=gnome-extra/gnome-characters-${PV}
	>=gnome-extra/gnome-clocks-${PV}
	>=gnome-extra/gnome-getting-started-docs-${PV}
	>=gnome-extra/gnome-power-manager-${PV}
	>=gnome-extra/gnome-search-tool-3.6
	>=gnome-extra/gnome-system-monitor-${PV}
	>=gnome-extra/gnome-tweak-tool-${PV}
	>=gnome-extra/gnome-weather-${PV}
	>=gnome-extra/gucharmap-${PV}:2.90
	>=gnome-extra/nautilus-sendto-3.8.4
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

	bijiben? ( >=app-misc/bijiben-${PV} )
	boxes? ( >=gnome-extra/gnome-boxes-${PV} )
	builder? ( >=gnome-extra/gnome-builder-3.18.0 )
	california? ( >=gnome-extra/california-0.4.0 )
	epiphany? ( >=www-client/epiphany-${PV} )
	evolution? ( >=mail-client/evolution-${PV} )
	flashback? ( >=gnome-base/gnome-flashback-${PV} )
	fonts? (
		>=media-fonts/noto-2015.04
		>=media-fonts/symbola-8.00
		>=media-fonts/unifont-8.0.01 )
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
	geary? ( >=mail-client/geary-0.11.2 )
	share? ( >=gnome-extra/gnome-user-share-3.18.1 )
	shotwell? ( >=media-gfx/shotwell-0.22 )
	todo? ( >=gnome-extra/gnome-todo-${PV} )
	tracker? (
		>=app-misc/tracker-1.8
		>=gnome-extra/gnome-documents-${PV}
		>=media-gfx/gnome-photos-${PV}
		>=media-sound/gnome-music-${PV} )
"
DEPEND=""
S=${WORKDIR}
