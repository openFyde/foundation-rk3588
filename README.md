## How to build.
### WARNING: these ebuilds are still in developing. The image is not working properly.

1. Get Chromium OS: refer to [Build Chromium OS for raspberry pi 4](https://github.com/FydeOS/chromium_os-raspberry_pi#readme)

2. Prepare ebuild for rk3588:

```
(inside cros sdk)
(cr) git clone <this project> ~/github/chromium_os-rk3588
(cr) cd ~/trunk/src/overlays/
(cr) ln -s ~/github/chromium_os-rk3588/chipset-rk3588 .
(cr) ln -s ~/github/chromium_os-rk3588/baseboard-inaugural .
(cr) ln -s ~/github/chromium_os-rk3588/overlay-inaugural .
# edit kernel git source to internal url
(cr) vi ~/github/chipset-rk3588/sys-kernel/chromeos-kernel-5_10/chromeos-kernel-5_10-5.10.66.ebuild
(cr) cd ~/trunk/src/script
(cr) setup_board --board=inaugural
```

3. Build Image

```
(cr) ./build_package --board=inaugural --nowithautotest
(cr) ./build_image --board=inaugural --noenable_rootfs_verification test
```

3. Prepare rk3588 image for rockchip upgrade_tool

```
(cr) cd ~/github/chromium_os-rk3588/rk3588-image-maker
(cr) ./map_chromiumos_image.sh ~/trunk/src/build/images/inaugural/latest/chromiumos_test_image.bin
(cr) ./rk3588-mkupdate.sh

```

4. Set your rk3588 evb board to loader mode, update new image

```
(cr) sudo upgrade_tool UF update.img
```

5. The board will reboot. Login with the account: chronos, passwd: test0000.
