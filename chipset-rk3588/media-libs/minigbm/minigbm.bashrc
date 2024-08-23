cros_pre_src_prepare_chipset_rk3588_patches() {
  if [ ${PV} != "9999" ]; then
    eapply -p1 ${CHIPSET_RK3588_BASHRC_FILESDIR}/0002-disable-compression.patch
  fi
}
