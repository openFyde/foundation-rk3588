# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Virtual for OpenGLES implementations"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="-* arm arm64"
IUSE=""

DEPEND="
	media-libs/mali-drivers-valhall-bin
	x11-drivers/opengles-headers
"
RDEPEND="${DEPEND}"
