setenv rootpart 3
setenv fdtfile /boot/rockchip/#ROCKCHIP_DTS#.dtb
setenv linux_image /boot/Image
if test -e ${devtype} ${devnum}:${distro_bootpart} /boot/first-b.txt; then
  setenv rootpart 5
fi
part uuid ${devtype} ${devnum}:${rootpart} root_uuid
setenv bootargs rootfstype=ext2 rootwait ro cros_debug cros_secure ignore_rlimit_data root=PARTUUID=${root_uuid}
load ${devtype} ${devnum}:${rootpart} ${kernel_addr_c} ${linux_image}
load ${devtype} ${devnum}:${rootpart} ${fdt_addr_r} ${fdtfile}
booti ${kernel_addr_c} - ${fdt_addr_r}
