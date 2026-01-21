# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="git://anongit.freedesktop.org/mesa/mesa"
CROS_WORKON_COMMIT="35721f19866d07dc671d4a83d6f6b77240629cb6"
CROS_WORKON_TREE="b0d9c48cf8158a238fc4cf3f39e58c4bd5717c49"
CROS_WORKON_PROJECT="chromiumos/third_party/mesa"
CROS_WORKON_LOCALNAME="mesa"
CROS_WORKON_MANUAL_UPREV="1"
CROS_WORKON_EGIT_BRANCH="cros/upstream/25.0"

KEYWORDS="*"

inherit meson flag-o-matic cros-workon

DESCRIPTION="The Mesa 3D Graphics Library"
HOMEPAGE="http://mesa3d.org/"

# Most of the code is MIT/X11.
# GLES[2]/gl[2]{,ext,platform}.h are SGI-B-2.0
LICENSE="MIT SGI-B-2.0"

IUSE="debug libglvnd vulkan zstd perfetto"

COMMON_DEPEND="
	dev-libs/expat:=
	>=x11-libs/libdrm-2.4.94:=
"

RDEPEND="${COMMON_DEPEND}
	libglvnd? ( media-libs/libglvnd )
	!libglvnd? ( !media-libs/libglvnd )
	zstd? ( app-arch/zstd )
  dev-libs/libxml2
  app-arch/libarchive:=
  dev-util/spirv-tools
  dev-libs/libconfig:=
  sys-libs/ncurses:=
  >=sys-libs/zlib-1.2.13
  virtual/libudev:=
"

DEPEND="${COMMON_DEPEND}
	perfetto? ( >=chromeos-base/perfetto-29.0 )
"

BDEPEND="
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
"

src_configure() {
  cros_optimize_package_for_speed

	emesonargs+=(
		-Dglvnd=$(usex libglvnd enabled disabled)
		-Dllvm=disabled
		-Dshader-cache=disabled
		-Dunversion-libgallium=true
		-Dglx=disabled
		-Degl=enabled
		-Dgbm=disabled
		-Dgles1=disabled
		-Dgles2=enabled
		-Dgallium-drivers=panfrost
		-Dgallium-vdpau=disabled
		-Dperfetto=$(usex perfetto true false)
		$(meson_feature zstd)
    -Degl-native-platform="surfaceless"
		-Dplatforms=
		-Dtools=panfrost
		--buildtype $(usex debug debug release)
		-Dvulkan-drivers=$(usex vulkan panfrost '')
	)

	meson_src_configure
}

src_install() {
	meson_src_install
	rm -v -rf "${ED}/usr/include"
}

src_prepare() {
  default
  eapply ${FILESDIR}/*.patch
}
