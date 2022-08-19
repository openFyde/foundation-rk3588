cros_pre_src_prepare_chipset_rk3588_patches() {
    epatch ${CHIPSET_RK3588_BASHRC_FILESDIR}/0001-libv4l2-Support-mmap-to-libv4l-plugin.patch
    epatch ${CHIPSET_RK3588_BASHRC_FILESDIR}/0002-libv4l-mplane-Filter-out-multiplane-formats.patch
    epatch ${CHIPSET_RK3588_BASHRC_FILESDIR}/0003-libv4l-Support-V4L2_MEMORY_DMABUF.patch
    epatch ${CHIPSET_RK3588_BASHRC_FILESDIR}/0004-libv4l-mplane-Support-VIDIOC_EXPBUF-for-dmabuf.patch
}
