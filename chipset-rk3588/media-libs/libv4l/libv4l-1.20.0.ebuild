# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libv4l/libv4l-1.6.0-r1.ebuild,v 1.1 2014/11/14 03:25:09 vapier Exp $

EAPI=5
inherit autotools eutils linux-info multilib-minimal

MY_P=v4l-utils-${PV}

DESCRIPTION="Separate libraries ebuild from upstream v4l-utils package"
HOMEPAGE="http://git.linuxtv.org/v4l-utils.git"
SRC_URI="http://linuxtv.org/downloads/v4l-utils/${MY_P}.tar.bz2"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="*"
IUSE="jpeg"

# The libraries only link to -ljpeg, therefore multilib depend only for virtual/jpeg.
RDEPEND="jpeg? ( >=virtual/jpeg-0-r2:0=[${MULTILIB_USEDEP}] )
	!media-tv/v4l2-ctl
	!<media-tv/ivtv-utils-1.4.0-r2
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-medialibs-20130224-r5
		!app-emulation/emul-linux-x86-medialibs[-abi_x86_32(-)]
	)"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/os-headers
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	CONFIG_CHECK="~SHMEM"
	linux-info_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-increase-v4l2-max-devices.patch
	epatch "${FILESDIR}"/${P}-remove-glob.patch
  epatch "${FILESDIR}"/0001-libv4l2-Support-mmap-to-libv4l-plugin.patch
  epatch "${FILESDIR}"/0002-libv4l-mplane-Filter-out-multiplane-formats.patch
  epatch "${FILESDIR}"/0003-libv4l-Support-V4L2_MEMORY_DMABUF.patch
  epatch "${FILESDIR}"/0004-libv4l-mplane-Support-VIDIOC_EXPBUF-for-dmabuf.patch
	eautoreconf
}

multilib_src_configure() {
	# Hard disable the flags that apply only to the utils.
	ECONF_SOURCE=${S} \
	econf \
		--disable-static \
		--disable-qv4l2 \
		--disable-v4l-utils \
		--without-libudev \
		$(use_with jpeg) \
		--disable-bpf
}

multilib_src_compile() {
	emake -C lib
}

multilib_src_install() {
	emake -j1 -C lib DESTDIR="${D}" install
	emake -j1 -C lib/libv4l-mplane DESTDIR="${D}" uninstall
}

multilib_src_install_all() {
	dodoc ChangeLog README.lib* TODO
	prune_libtool_files --all
}
