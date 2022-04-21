#!/bin/bash
top=$(dirname $0)
img_dir="$top/Image"

die() {
  echo $@
  exit 1
}

loopdev=$(readlink $img_dir/STATE.img)

[ -b "${loopdev}" ] || die "no loopdev found."

loopdev=${loopdev%p1}

sudo partx -d $loopdev
sudo losetup -d $loopdev
echo "$loopdev is unmapped"
