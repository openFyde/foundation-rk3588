# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_REPO="https://github.com/rockchip-linux/"

CROS_WORKON_COMMIT="604cec4004abe5a96c734f2fab7b74809d2d742f"

# CROS_WORKON_REPO + CROS_WORKON_PROJECT will be the whole url for rockchip kernel example: http://git/xxxx/repo/rk-kernel
CROS_WORKON_PROJECT="kernel"
# clone the kernel resource to ~/trunk/src/third_party/kernel/v5.10-rockchip to speed up the compiling.
CROS_WORKON_LOCALNAME="kernel/v5.10-rockchip"
CROS_WORKON_EGIT_BRANCH="develop-5.10"
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_MANUAL_UPREV=1
EGIT_MASTER="develop-5.10"

# ECLASS_DEBUG_OUTPUT="on"
# Please uncomment the follwing if you are not fyder
# CROS_WORKON_REPO="https://gitlab.com/rk3588_linux/rk"
# CROS_WORKON_PROJECT="kernel"
# CROS_WORKON_EGIT_BRANCH="linux-5.10"
# CROS_WORKON_COMMIT="b7ecbce3de7591a07156bad71448b31c06e06a44"

# This must be inherited *after* EGIT/CROS_WORKON variables defined
inherit cros-workon cros-kernel2

HOMEPAGE="https://www.chromium.org/chromium-os/chromiumos-design-docs/chromium-os-kernel"
DESCRIPTION="Chromium OS Linux kernel 5.10 for rockchip"
KEYWORDS="*"

# Change the following (commented out) number to the next prime number
# when you change "cros-kernel2.eclass" to work around http://crbug.com/220902
#
# NOTE: There's nothing magic keeping this number prime but you just need to
# make _any_ change to this file.  ...so why not keep it prime?
#
# Don't forget to update the comment in _all_ chromeos-kernel-x_x-9999.ebuild
# files (!!!)
#
# The coolest prime number is: 151

