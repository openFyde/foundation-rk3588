_cros-kernel_emit_its_script() {
  local its_out=${1}
  local kernel_dir=${2}
  local dtb=${3}
  local its_template=${CHIPSET_RK3588_BASHRC_FILESDIR}/image.its
  kernel_bin_path="${kernel_dir}/$(_cros-kernel_get_compressed_path)"
  cat ${its_template} | sed "s#BOOT_IMG#${kernel_bin_path}#g" | \
    sed "s#BOARD_DTB#${dtb}#g" > $its_out
  wait
}

cros_post_src_install_add_rawimage_dtbs() {
  local install_prefix=/boot
  local install_dir="${D}${install_prefix}"
  local kernel_dir="$(cros-workon_get_build_dir)"
  local kernel_arch=${CHROMEOS_KERNEL_ARCH:-$(tc-arch-kernel)}
  local dtb_dir="${kernel_dir}/arch/${kernel_arch}/boot/dts"
  local version=$(kernelrelease)
  local boot_dir="${kernel_dir}/arch/${kernel_arch}/boot"
  einfo "rk3588 post install ${SYSROOT}${install_prefix}"
  insinto ${install_prefix}
  newins ${boot_dir}/Image Image-${version}
  dosym Image-${version} /boot/Image
  insinto ${install_prefix}/rockchip
  doins $dtb_dir/rockchip/*.dtb
  if [[ -d "${dtb_dir}"/rockchip/overlay ]] ; then
    insinto ${install_prefix}/rockchip/overlay
    doins "${dtb_dir}"/rockchip/overlay/*.dtbo || die
  fi
}

CHROMEOS_DTBS="${ROCKCHIP_DTS}.dtb"

cros_pre_src_prepare_build_toolchain_catch() {
  true
}
