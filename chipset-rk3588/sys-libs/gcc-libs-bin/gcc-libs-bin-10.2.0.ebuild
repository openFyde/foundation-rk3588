# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="gcc libs so, binary only install"
HOMEPAGE=""

LICENSE="BSD-Fyde"
SLOT="0"
KEYWORDS="-* arm64 arm"
RESTRICT="arm? ( binchecks )"

RDEPEND=""

S=${WORKDIR}
: ${CTARGET:=${CHOST}}

src_install() {
  local target=""
  local arch_=""

  case ${CTARGET} in
  aarch64-cros-linux-gnu)
    arch_="arm64"
    ;;
  arm*)
    arch_="arm"
    ;;
  esac

  target="/usr/$(get_libdir)"
  einfo "target: ${target}"

  exeinto ${target}

  doexe ${FILESDIR}/${arch_}/libstdc++.so.6.0.28

  dosym ${target}/libstdc++.so.6.0.28 ${target}/libstdc++.so.6
  dosym ${target}/libstdc++.so.6.0.28 ${target}/libstdc++.so
}
