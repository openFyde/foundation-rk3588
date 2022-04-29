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
  chromeos-base/chromeos-bsp-baseboard-inaugural
  chromeos-base/device-appid
  "

DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_install() {
  insinto "/usr/share/power_manager/board_specific"
  doins "${FILESDIR}"/powerd_prefs/*
  udev_dorules "${FILESDIR}/93-powerd-overrides.rules"
  udev_dorules "${FILESDIR}/wifi_init/99-start-wifi.rules"
  insinto /lib/firmware
  doins -r ${FILESDIR}/firmware/*
  insinto /etc/init
  doins ${FILESDIR}/wifi_init/*.override
  exeinto /lib/udev
  doexe ${FILESDIR}/wifi_init/start_wifi.sh
  insinto /usr/share/alsa/ucm
  doins -r ${FILESDIR}/ucm-config/* 
  insinto /usr/share/alsa/cards
  doins ${FILESDIR}/alsa-card/HDMI_DP-rockchi.conf
}
