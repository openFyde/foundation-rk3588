# Copyright (c) 2018 The Fyde OS Authors. All rights reserved.
# Distributed under the terms of the BSD

EAPI=7

EGIT_REPO_URI="https://github.com/rockchip-linux/mpp.git"
EGIT_COMMIT="793acb6f66034dd62d582d692eb37f81de2ea0c6"

inherit cmake-utils git-r3 udev

DESCRIPTION="Rockchip Media Process Platform (MPP) module"
HOMEPAGE="https://github.com/rockchip-linux/mpp"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="arm arm64"
IUSE="test-utils asan static +shared-lib"

RDEPEND=""

DEPEND="${RDEPEND}"

src_configure() {
  #append-cflags -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
  mycmakeargs+=( -DRKPLATFORM=ON -DHAVE_DRM=ON )
  use test-utils || mycmakeargs+=( -DBUILD_TEST=OFF )
  use asan && mycmakeargs+=( -DASAN_CHECK=ON )
  use static || mycmakeargs+=( -DENABLE_STATIC=OFF )
  use shared-lib && mycmakeargs+=( -DENABLE_SHARED=ON )
  cmake-utils_src_configure
  default
}

src_install() {
  cmake-utils_src_install
  default 
  insinto /etc/init
  udev_dorules ${FILESDIR}/99-rockchip-permissions.rules
}

PATCHES=(
  "${FILESDIR}/chang-drm-device-to-render.patch"
)
