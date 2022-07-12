# Copyright (c) 2018 The Fyde OS Authors. All rights reserved.
# Distributed under the terms of the BSD

EAPI="5"

DESCRIPTION="empty project"
HOMEPAGE="http://fydeos.com"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="chromeos-base/auto-expand-partition"

DEPEND="${RDEPEND}"

S=${FILESDIR}

src_install() {
  insinto /etc/init
  doins auto-expand-partition.override
}
