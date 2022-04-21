install_rockpro64_boot_scr() {
  local image="$1"
  local efi_offset_sectors=$(partoffset "$1" 12)
  local efi_size_sectors=$(partsize "$1" 12)
  local efi_offset=$((efi_offset_sectors * 512))
  local efi_size=$((efi_size_sectors * 512))
  local efi_dir=$(mktemp -d)

  info "Mounting EFI partition"
  sudo mount -o loop,offset=${efi_offset},sizelimit=${efi_size} "$1" \
    "${efi_dir}"

  info "Copying /boot/boot.scr.uimg"
  sudo mkdir ${efi_dir}/boot
  sudo cp "${ROOT}/boot/boot.scr.uimg" "${efi_dir}/boot"
  sudo umount "${efi_dir}"
  rmdir "${efi_dir}"

  info "Installed /boot/boot.scr.uimg"
}

board_setup() {
  install_rockpro64_boot_scr "$1"
}
