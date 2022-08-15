# Copyright (c) 2018 The Fyde OS Authors. All rights reserved.
# Distributed under the terms of the BSD

EAPI="5"

inherit udev

DESCRIPTION="empty project"
HOMEPAGE="http://fydeos.com"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
  sys-boot/rk3588-uboot-script
  media-libs/rockchip-mpp
  "

DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_install() {
  insinto /etc
  doins ${FILESDIR}/cpufreq.conf
  insinto /etc/init
# doins ${FILESDIR}/udev-trigger-codec.conf
  udev_dorules "${FILESDIR}/50-media.rules"
}
