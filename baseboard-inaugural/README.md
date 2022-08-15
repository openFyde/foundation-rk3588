# baseboard-inaugural

![Logo badge](https://img.shields.io/endpoint?url=https://logo-badge-without-release-image-0lnvd7unef6z.runkit.sh)

<br>

## Introduction
Same as Chromium OS, openFyde adopts the [Portage build and packaging system](https://wiki.gentoo.org/wiki/Portage) from Gentoo Linux. openFyde uses Portage with certain customisations to support building multiple targets (bootable OS system images) across different hardware architectures from a shared set of sources.

A **board** defines a target type, it can be either for a family of hardware devices or specifically for one type of device. For example, The board `amd64-openfyde` is a target type for an openFyde system image that aims to run on most recent PCs with amd64(x86_64) architecture; whilst the `rpi4-openfyde` board is a target type specifically for the infamous single-board computer [Raspberry Pi 4B](https://www.raspberrypi.com/products/raspberry-pi-4-model-b/). We usually append `-openfyde` to the board name in openFyde to differentiate between its siblings for FydeOS.

Each board has a corresponding **overlay** that defines the configuration for it. This includes details like CPU architecture, kernel configuration, as well as additional packages and USE flags.

<br>

## About this directory
This directory is the overlay for the `baseboard-inaugural` board, it's part of the openFyde open-source project.

This repository contains the following packages:


| Packages                                       | Description                                     | Reference                                                                                                                                      |
|------------------------------------------------|-------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| chromeos-base/chromeos-base                    | ChromeOS specific system setup                  | [chromiumos-overlay](https://chromium.googlesource.com/chromiumos/overlays/chromiumos-overlay/+/refs/heads/main/chromeos-base/chromeos-base)   |
| chromeos-base/chromeos-bsp-baseboard-inaugural | Config files for inaugural                      |                                                                                                                                                |
| chromeos-base/chromeos-chrome                  | Open-source version of Google Chrome web browse | [chromiumos-overlay](https://chromium.googlesource.com/chromiumos/overlays/chromiumos-overlay/+/refs/heads/main/chromeos-base/chromeos-chrome) |
| chromeos-base/crosvm                           | Utility for running VMs on Chrome OS            | [chromiumos-overlay](https://chromium.googlesource.com/chromiumos/overlays/chromiumos-overlay/+/refs/heads/main/chromeos-base/crosvm)          |
| chromeos-base/tty                              | Init script to run agetty on selected terminals | [chromiumos-overlay](https://chromium.googlesource.com/chromiumos/overlays/chromiumos-overlay/+/refs/heads/main/chromeos-base/tty)             |
| chromeos-base/wifi_commandline_utils           | Script for wifi_connect                         |                                                                                                                                                |
| media-libs/arc-mali-rk3588-bin                 | Arc mali binary libraries for  rk3588           |                                                                                                                                                |
| media-sound/adhd                               | Google A/V Daemon                               | [chromiumos-overlay](https://chromium.googlesource.com/chromiumos/overlays/chromiumos-overlay/+/refs/heads/main/media-sound/adhd)              |
| net-wireless/brcm_bt_patchrom                  | brcm bluetooth rom patcher                      |                                                                                                                                                |
| sys-boot/rk3588-uboot-script                   | RK3588 uboot setup script                       |                                                                                                                                                |
| virtual/chromeos-bsp-test           |         Virutal for bsp  depends on test                                                                                                                                       |



<br>


## About the board `baseboard-inaugural`

This board `baseboard-inaugural` contains the common packages required by variants of inaugural.

<br>

###### Copyright (c) 2022 Fyde Innovations and the openFyde Authors. Distributed under the license specified in the root directory of this repository.
