install_rockpro64_boot_scr2() {
  local image="$1"
  local efi_offset_sectors=$(partoffset "$1" 12)
  local efi_size_sectors=$(partsize "$1" 12)
  local efi_offset=$((efi_offset_sectors * 512))
  local efi_size=$((efi_size_sectors * 512))
  local efi_dir=$(mktemp -d)
  info "creage boot script for inaugural-fydeos"
  info "Mounting EFI partition"
  sudo mount -o loop,offset=${efi_offset},sizelimit=${efi_size} "$1" \
    "${efi_dir}"

  info "Copying /boot/boot.scr.uimg"
  if [ -d ${efi_dir}/boot ]; then
    sudo mkdir ${efi_dir}/boot
  fi
  sudo cp "${ROOT}/boot/boot.scr.uimg" "${efi_dir}/boot"
  sudo umount "${efi_dir}"
  rmdir "${efi_dir}"

  info "Installed /boot/boot.scr.uimg"
}

#board_setup() {
#  install_rockpro64_boot_scr2 "$1"
#}

. $(dirname ${BASH_SOURCE[0]})/fydeos_version.sh
CHROMEOS_ARC_ANDROID_SDK_VERSION=28
CHROMEOS_ARC_VERSION=7441130
CHROMEOS_VERSION_AUSERVER=https://up.fydeos.com/service/update2
CHROMEOS_VERSION_DEVSERVER=https://devserver.fydeos.com:9999
CHROMEOS_VERSION_TRACK=stable-channel
CHROMEOS_PATCH=14
if [ -n "${CHROMEOS_BUILD}" ]; then
  CHROMEOS_VERSION_STRING="${CHROMEOS_BUILD}.${CHROMEOS_BRANCH}.${CHROMEOS_PATCH}.$(get_build_number ${CHROMEOS_PATCH})"
  export FYDEOS_RELEASE=$(get_fydeos_release_version)
fi
