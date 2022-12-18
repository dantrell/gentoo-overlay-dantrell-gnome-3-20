# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml(+)"

inherit gnome2 python-single-r1 toolchain-funcs versionator

BACKPORT="1.51.2"

DESCRIPTION="Introspection system for GObject-based libraries"
HOMEPAGE="https://wiki.gnome.org/Projects/GObjectIntrospection"
SRC_URI+=" mirror://gnome/sources/${GNOME_ORG_MODULE}/$(ver_cut 1-2 ${BACKPORT})/${GNOME_ORG_MODULE}-${BACKPORT}.tar.${GNOME_TARBALL_SUFFIX}"

LICENSE="LGPL-2+ GPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="cairo doctool test"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	test? ( cairo )
"

RESTRICT="!test? ( test )"

# virtual/pkgconfig needed at runtime, bug #505408
# We force glib and g-i to be in sync by this way as explained in bug #518424
RDEPEND="
	>=dev-libs/gobject-introspection-common-${PV}
	>=dev-libs/glib-2.$(get_version_component_range 2):2
	doctool? (
		$(python_gen_cond_dep '
			dev-python/mako[${PYTHON_USEDEP}]
		')
	)
	dev-libs/libffi:=
	virtual/pkgconfig
	!<dev-lang/vala-0.20.0
	${PYTHON_DEPS}
"
# Wants real bison, not app-alternatives/yacc
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.19
	sys-devel/bison
	sys-devel/flex
"
# PDEPEND to avoid circular dependencies, bug #391213
PDEPEND="cairo? ( x11-libs/cairo[glib] )"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_unpack() {
	if [[ -n ${A} ]]; then
		unpack ${A}
	fi

	# From AppStream:
	# 	https://github.com/ximion/appstream/issues/146
	# 	https://gitlab.gnome.org/GNOME/gobject-introspection/-/commit/eea2447c4e4c1c98fda3ba212a9a9bbcc8655c90
	cd "${WORKDIR}" || die "cd failed"
	rm -rf "${WORKDIR}"/${P}/giscanner || die "rm -rf failed"
	cp -a "${WORKDIR}"/${PN}-${BACKPORT}/giscanner "${WORKDIR}"/${P} || die "cp failed"
}

src_configure() {
	if ! has_version "x11-libs/cairo[glib]"; then
		# Bug #391213: enable cairo-gobject support even if it's not installed
		# We only PDEPEND on cairo to avoid circular dependencies
		export CAIRO_LIBS="-lcairo -lcairo-gobject"
		export CAIRO_CFLAGS="-I${EPREFIX}/usr/include/cairo"
	fi

	# To prevent crosscompiling problems, bug #414105
	gnome2_src_configure \
		--disable-static \
		CC="$(tc-getCC)" \
		YACC="$(type -p yacc)" \
		$(use_with cairo) \
		$(use_enable doctool)
}

src_install() {
	gnome2_src_install

	# Prevent collision with gobject-introspection-common
	rm -v "${ED}"usr/share/aclocal/introspection.m4 \
		"${ED}"usr/share/gobject-introspection-1.0/Makefile.introspection || die
	rmdir "${ED}"usr/share/aclocal || die
}
