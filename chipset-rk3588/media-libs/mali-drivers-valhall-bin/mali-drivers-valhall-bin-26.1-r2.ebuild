# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

#inherit unpacker

DESCRIPTION="Mali drivers, binary only install"
HOMEPAGE=""
#SRC_URI="http://commondatastorage.googleapis.com/chromeos-localmirror/distfiles/mali-drivers-valhall-cherry-${PV}.run"

LICENSE="Google-TOS"
SLOT="0"
KEYWORDS="-* arm64 arm"

RESTRICT="arm? ( binchecks )"
IUSE="libglvnd"

RDEPEND="
	>=x11-libs/libdrm-2.4.97
	!media-libs/mali-drivers-valhall
	!media-libs/mesa
  sys-libs/gcc-libs-bin
  libglvnd? ( media-libs/libglvnd )
"

S=$WORKDIR

src_unpack() {
 # unpack ${FILESDIR}/mali-rk3588-10.8.7-r13p0-r2.tar.gz
 unpack ${FILESDIR}/mali-rk3588-10.8.6-r13p0.tar.gz
}

src_install() {
  einfo "cp -pPR ${S}/$(get_libdir) ${D}/usr/$(get_libdir)"
  mkdir ${D}/usr
  if use libglvnd; then
    mkdir ${D}/usr/$(get_libdir)
    cp -pPR ${S}/$(get_libdir)/libmali.* ${D}/usr/$(get_libdir) || die "Install failed!"
    insinto /usr/share/glvnd/egl_vendor.d
    doins ${FILESDIR}/10_mali.json
  else
	  cp -pPR ${S}/$(get_libdir) ${D}/usr/$(get_libdir) || die "Install failed!"
  fi
}
