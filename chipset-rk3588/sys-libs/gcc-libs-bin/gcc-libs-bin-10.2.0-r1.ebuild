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
  exeinto /usr/$(get_libdir)
  doexe ${FILESDIR}/$(get_libdir)/libstdc++.so.6.0.28
  dosym libstdc++.so.6.0.28 /usr/$(get_libdir)/libstdc++.so.6
  dosym libstdc++.so.6.0.28 /usr/$(get_libdir)/libstdc++.so
}
