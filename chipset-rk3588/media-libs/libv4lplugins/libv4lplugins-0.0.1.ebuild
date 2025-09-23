# Copyright (c) 2018 The Fyde OS Authors. All rights reserved.
# Distributed under the terms of the BSD

EAPI="7"

EGIT_REPO_URI="https://github.com/JeffyCN/libv4l-rkmpp.git"
EGIT_COMMIT="c5bc0aef0bc571872eb67508dcd75e05247eb83a"

inherit autotools git-r3 eutils flag-o-matic meson

DESCRIPTION="A V4L2 plugin that wraps rockchip_mpp for  the chromium's V4L2 VDA/VEA"
HOMEPAGE="https://github.com/JeffyCN/libv4l-rkmpp"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="*"
IUSE="debug +max_8k log_enc log_dec"
REQUIRED_USE="?? ( log_enc log_dec )"

RDEPEND="
    media-libs/libv4l
    x11-libs/libdrm
    media-libs/rockchip-mpp
"

DEPEND="${RDEPEND}"

src_prepare() {
  if use arm; then
    append-cflags -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
  fi
  append-cflags -Wno-gnu-zero-variadic-macro-arguments -Wno-language-extension-token
  eapply -p1 ${FILESDIR}/remove-fd-state-checking.patch
  eapply -p1 ${FILESDIR}/0003-Hack-codec-while-parse-options.patch
  eapply -p1 ${FILESDIR}/0004-fix-pixelformat-for-chromium.patch
  eapply -p1 ${FILESDIR}/0005-fix-encoder-for-chromium.patch
  eapply -p1 ${FILESDIR}/0006-fix-mmap-issue.patch
  eapply -p1 ${FILESDIR}/0007-add-debug-info.patch
  eapply -p1 ${FILESDIR}/0008-fix-close-plugin-fd-issue.patch
  eapply -p1 ${FILESDIR}/0009-fix-encoder-panic.patch
  eapply -p1 ${FILESDIR}/0010-fix-encoder-infinite-loop.patch
  eapply -p1 ${FILESDIR}/0011-add-context-aware-logging.patch
  default
}

src_configure() {
  tc-getPROG PKG_CONFIG pkg-config
  if use debug; then
    append-cflags -DDEBUG
  fi
  if use log_enc; then
    append-cflags -DRKMPP_LOG_TARGET=2
  fi
  if use log_dec; then
    append-cflags -DRKMPP_LOG_TARGET=1
  fi

  cros_optimize_package_for_speed
  LLVM_ENABLE=false

  if use debug; then
    emesonargs+=( -Dverbose=true )
  fi
  if use max_8k; then
    emesonargs+=( -Dmax-dec-width=7680
                  -Dmax-dec-height=4320 )
  fi
  emesonargs+=( -Dmax-enc-width=3840
                -Dmax-enc-height=2160 )
  meson_src_configure
}

src_install() {
  meson_src_install
  local target_dir="/usr/$(get_libdir)/libv4l/plugins"
  dosym libv4l-rkmpp.so ${target_dir}/libv4l-encplugin.so
}
