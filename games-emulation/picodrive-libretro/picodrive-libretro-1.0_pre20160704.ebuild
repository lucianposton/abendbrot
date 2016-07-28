# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit libretro-core

DESCRIPTION="libretro implementation of PicoDrive. \
(Sega GameGear/Sega CD/32X)"
HOMEPAGE="https://github.com/libretro/picodrive"
SRC_URI="https://github.com/libretro/picodrive/archive/7832385631e44008e07bef75933d084ddf278b97.tar.gz -> ${P}.tar.gz"
RESTRICT="primaryuri"

S="${WORKDIR}/picodrive-7832385631e44008e07bef75933d084ddf278b97"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/libretro/picodrive.git"
	KEYWORDS=""
else
	KEYWORDS="amd64 x86"
fi

LICENSE="PD"
SLOT="0"

RDEPEND=""
DEPEND="${RDEPEND}"

src_configure() {
	#No need for configure, libretro does its own thing
	true
}

src_compile() {
	make -f Makefile.libretro || die "emake failed!"
}

src_install() {
	insinto "${LIBRETRO_DATA_DIR}"/picodrive_libretro
	doins "${S}"/COPYING
	libretro-core_src_install
}

pkg_preinst() {
	if ! has_version "=${CATEGORY}/${PN}-${PVR}"; then
		first_install="1"
	fi
}

pkg_postinst() {
	if [[ "${first_install}" == "1" ]]; then
		ewarn ""
		ewarn "You need to have the following files in your 'system_directory' folder:"
		ewarn "bios_CD_E.bin (MegaCD EU BIOS)"
		ewarn "bios_CD_U.bin (SegaCD US BIOS)"
		ewarn "bios_CD_J.bin (MegaCD JP BIOS)"
		ewarn ""
		ewarn "This message will only be displayed once!"
		ewarn ""
	fi
}
