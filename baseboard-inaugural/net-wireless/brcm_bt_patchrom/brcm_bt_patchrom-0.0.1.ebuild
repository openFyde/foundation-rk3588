# Copyright (c) 2018 The Fyde OS Authors. All rights reserved.
# Distributed under the terms of the BSD

EAPI="5"

DESCRIPTION="brcm bluetooth rom patcher"
HOMEPAGE="http://fydeos.com"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""

RESTRICT="arm? ( binchecks )"

RDEPEND=""

DEPEND="${RDEPEND}"

S=${WORKDIR}

src_prepare() {
	cp ${FILESDIR}/* .
}

src_compiles() {
	emake || die "emake failed"
}

src_install() {
	exeinto /usr/bin
	doexe brcm_patchram_plus1
	insinto /etc/init
	doins brcm_bt_patchrom.conf
}
