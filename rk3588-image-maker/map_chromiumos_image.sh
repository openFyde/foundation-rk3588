#!/bin/bash
top=$(dirname $0)
pushd $top 2>&1 1>/dev/null
top=$(pwd)
img_dir="$top/Image"
chromeos_image=$1
loopdev=$(sudo losetup -f)
newest_loader="v1.07.111"
get_miniloader=false

declare -A LINK_MAP=(
  [inaugural]="v1.04.106"
  [fydetab_duo]="v1.06.111"
)

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
  sleep 1
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

link_miniloader() {
  for board in "${!LINK_MAP[@]}"; do
    echo "check board:$board"
    if [ -n "$(echo $chromeos_image | grep $board)" ]; then
      echo "link miniloader: ${LINK_MAP[$board]}"
      ln -sf $top/rk3588-uboot-bin/rk3588_spl_loader_${LINK_MAP["$board"]}.bin $img_dir/MiniLoaderAll.bin
      get_miniloader=true
      break
    fi
  done
  if ! $get_miniloader; then
    echo "Use the newset loader: $newest_loader"
    ln -sf $top/rk3588-uboot-bin/rk3588_spl_loader_${newest_loader}.bin $img_dir/MiniLoaderAll.bin
  fi
}

main() {
  mount_loopdev $chromeos_image
  link_img p1 STATE
  link_img p2 KERN-A
  link_img p3 ROOT-A
  link_img p8 OEM
  link_img p12 EFI-SYSTEM
  link_miniloader
}

main
popd 2>&1 1>/dev/null
