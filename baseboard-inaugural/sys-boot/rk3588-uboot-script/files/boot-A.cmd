setenv rootpart 3
setenv fdtfile /boot/rockchip/#ROCKCHIP_DTS#.dtb
setenv linux_image /boot/Image
part uuid ${devtype} ${devnum}:${rootpart} root_uuid
setenv bootargs rootfstype=ext2 rootwait ro cros_legacy ignore_rlimit_data root=PARTUUID=${root_uuid} #EXTRA_BOOT_ARGS#
load ${devtype} ${devnum}:${rootpart} ${kernel_addr_c} ${linux_image}
load ${devtype} ${devnum}:${rootpart} ${fdt_addr_r} ${fdtfile}
booti ${kernel_addr_c} - ${fdt_addr_r}
