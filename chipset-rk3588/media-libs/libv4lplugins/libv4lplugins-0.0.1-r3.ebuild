# Copyright (c) 2018 The Fyde OS Authors. All rights reserved.
# Distributed under the terms of the BSD

EAPI="7"

EGIT_REPO_URI="https://github.com/JeffyCN/libv4l-rkmpp.git"
EGIT_COMMIT="fe977181a5ab53bb350706cdc259ba6ccd4528da"

inherit git-r3 eutils flag-o-matic meson

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
  default
  eapply ${FILESDIR}/0001-Revert-Support-more-device-options.patch
  eapply ${FILESDIR}/0002-Revert-Filter-out-real-devices-earlier.patch
}

src_install() {
  local target_dir="/usr/$(get_libdir)/libv4l/plugins"
  einfo "install to ${D}${target_dir}"
  meson_install
  dosym libv4l-rkmpp.so ${target_dir}/libv4l-encplugin.so
}
