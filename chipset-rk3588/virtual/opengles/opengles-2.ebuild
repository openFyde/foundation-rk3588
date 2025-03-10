# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Virtual for OpenGLES implementations"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="-* arm arm64"
IUSE="mali panfrost"
REQUIRED_USE=" ^^ ( mali panfrost ) "
DEPEND="
	mali? ( media-libs/mali-drivers-valhall-bin )
  panfrost? ( media-libs/mesa-panfrost )
	x11-drivers/opengles-headers
"
RDEPEND="${DEPEND}"
