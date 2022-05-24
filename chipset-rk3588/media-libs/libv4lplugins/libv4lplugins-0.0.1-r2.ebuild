# Copyright (c) 2018 The Fyde OS Authors. All rights reserved.
# Distributed under the terms of the BSD

EAPI="5"

EGIT_REPO_URI="https://github.com/JeffyCN/libv4l-rkmpp.git"
EGIT_COMMIT="9f7cbec9d792f6822b471c0bbab5fe32c808b009"

inherit autotools git-r3 eutils flag-o-matic

DESCRIPTION="A V4L2 plugin that wraps rockchip_mpp for  the chromium's V4L2 VDA/VEA"
HOMEPAGE="https://github.com/JeffyCN/libv4l-rkmpp"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	media-libs/libv4l
  x11-libs/libdrm
"

DEPEND="${RDEPEND}"

src_prepare() {
  if use arm; then
    append-cflags -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
  fi
  eautoreconf
#  epatch ${FILESDIR}/change_drm_device_to_render.patch
}

src_configure() {
  econf
}

src_install() {
  local target_dir="/usr/$(get_libdir)/libv4l/plugins"
  einfo "install to ${D}${target_dir}"
  emake DESTDIR="${D}" install
  dosym libv4l-rkmpp.so ${target_dir}/libv4l-encplugin.so
}
