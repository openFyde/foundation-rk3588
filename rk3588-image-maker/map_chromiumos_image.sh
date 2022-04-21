#!/bin/bash
top=$(dirname $0)
img_dir="$top/Image"
chromeos_image=$1
loopdev=$(sudo losetup -f)
die() {
  echo $@
  exit 1  
}

[ -b "$loopdev" ] || die "no loop device found."

if [ ! -f "$chromeos_image" ]; then
  die "Usage:$0 [chromiumos_image bin]"
fi

mount_loopdev() {
  local img=$1
  sudo losetup $loopdev $img || die "mount error."
  sudo partx -d $loopdev 2>&1 >/dev/null || true
  sudo partx -a $loopdev 2>&1 >/dev/null || die "Error mount patitions of $loopdev"
  echo $loopdev
}

link_img() {
  local src=${loopdev}$1
  local target=${img_dir}/${2}.img
  echo "link:$src as $target"
  ln -sf $src $target
  sudo chmod 666 $src
}

main() {
  mount_loopdev $chromeos_image
  link_img p1 STATE
  link_img p2 KERN-A
  link_img p3 ROOT-A
  link_img p8 OEM
  link_img p12 EFI-SYSTEM
}

main
