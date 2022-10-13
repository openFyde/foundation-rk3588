# Copyright (c) 2018 The Fyde OS Authors. All rights reserved.
# Distributed under the terms of the BSD

EAPI="7"

DESCRIPTION="empty project"
HOMEPAGE="http://fydeos.com"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="sys-devel/arc-build"

DEPEND="${RDEPEND}"

S=$WORKDIR

src_unpack() {
  unpack ${FILESDIR}/arc-mali-rk3588-10.8.7-r0p0.tar.gz
}

src_install() {
  into /opt/google/containers/android/vendor/lib/egl
  dolib.so lib/libGLES_mali.so
  into /opt/google/containers/android/vendor/lib64/egl
  dolib.so lib64/libGLES_mali.so
  insinto /opt/google/containers/android/vendor/etc/init
  doins init/*
  insinto /opt/google/containers/android/vendor/etc/permissions
  doins permissions/*
}
