# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3 toolchain-funcs

DESCRIPTION="a generic, highly customizable, and efficient menu for the X Window System"
HOMEPAGE="https://tools.suckless.org/dmenu/"
EGIT_REPO_URI="https://github.com/mantrasultry/dmenu.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	media-libs/fontconfig
	x11-libs/libX11
	x11-libs/libXft
	x11-libs/libXinerama
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-4.9-gentoo.patch
)

src_prepare() {
	default

	sed -i \
		-e 's|^	@|	|g' \
		-e '/^	echo/d' \
		Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" \
		"FREETYPEINC=$( $(tc-getPKG_CONFIG) --cflags x11 fontconfig xft 2>/dev/null )" \
		"FREETYPELIBS=$( $(tc-getPKG_CONFIG) --libs x11 fontconfig xft 2>/dev/null )" \
		"X11INC=$( $(tc-getPKG_CONFIG) --cflags x11 2>/dev/null )" \
		"X11LIB=$( $(tc-getPKG_CONFIG) --libs x11 2>/dev/null )" \
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
}
