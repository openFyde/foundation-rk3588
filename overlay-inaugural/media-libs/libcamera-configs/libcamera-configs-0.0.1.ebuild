# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Libcamera Config files for inaugural"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* arm arm64"

S="${WORKDIR}"

src_install() {
	local CONFIG_DIR="/etc/camera/libcamera"
	insinto "${CONFIG_DIR}"
	doins "${FILESDIR}"/*
}
