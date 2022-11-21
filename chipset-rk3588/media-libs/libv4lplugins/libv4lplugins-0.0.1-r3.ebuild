# Copyright (c) 2018 The Fyde OS Authors. All rights reserved.
# Distributed under the terms of the BSD

EAPI="7"

EGIT_REPO_URI="https://github.com/JeffyCN/libv4l-rkmpp.git"
EGIT_COMMIT="fe977181a5ab53bb350706cdc259ba6ccd4528da"

inherit autotools git-r3 eutils flag-o-matic meson

DESCRIPTION="A V4L2 plugin that wraps rockchip_mpp for  the chromium's V4L2 VDA/VEA"
HOMEPAGE="https://github.com/JeffyCN/libv4l-rkmpp"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="*"
IUSE="debug max_8k"

RDEPEND="
	media-libs/libv4l
  x11-libs/libdrm
"

DEPEND="${RDEPEND}"

src_prepare() {
  if use arm; then
    append-cflags -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
  fi
  append-cflags -Wno-gnu-zero-variadic-macro-arguments -Wno-language-extension-token
  eapply -p1 ${FILESDIR}/remove-fd-state-checking.patch
  default
}

src_configure() {
  tc-getPROG PKG_CONFIG pkg-config

  cros_optimize_package_for_speed
  LLVM_ENABLE=false

  if use debug; then
    emesonargs+=( -Dverbose=true )
  fi
  if use max_8k; then
    emesonargs+=( -Dmax-dec-width=7680
                  -Dmax-dec-height=4320 )
  fi
  meson_src_configure
}

src_install() {
  meson_src_install
  local target_dir="/usr/$(get_libdir)/libv4l/plugins"
  dosym libv4l-rkmpp.so ${target_dir}/libv4l-encplugin.so
}
