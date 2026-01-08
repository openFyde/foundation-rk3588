# Copyright 2016 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Virtual for ARC OpenGLES implementations"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
KEYWORDS="*"
IUSE="mali panfrost"
REQUIRED_USE=" ^^ ( mali panfrost ) "

RDEPEND="
  mali? ( media-libs/arc-mali-rk3588-bin )
  panfrost? ( media-libs/arc-mesa-panthor )
"
DEPEND=""
