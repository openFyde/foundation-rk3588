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

src_install() {
  exeinto /usr/lib
  doexe ${FILESDIR}/libstdc++.so.6.0.28
  dosym /usr/lib/libstdc++.so.6.0.28 /usr/lib/libstdc++.so.6
  dosym /usr/lib/libstdc++.so.6.0.28 /usr/lib/libstdc++.so
}
