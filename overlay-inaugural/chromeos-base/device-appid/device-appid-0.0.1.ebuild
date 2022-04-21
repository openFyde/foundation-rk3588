# Copyright (c) 2020 The Fyde Innovations. All rights reserved.
# Distributed under the license specified in the root directory of this project.

EAPI="5"

inherit appid
DESCRIPTION="Creates an app id for this build and update the lsb-release file"
HOMEPAGE="https://fydeos.io"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND=""

DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_install() {
      doappid "{84FBD436-16FE-4A77-9322-EAD7E1A6EFD7}" "CHROMEBOOK" 
}
