# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="git://anongit.freedesktop.org/mesa/mesa"
CROS_WORKON_COMMIT="0fadfea4f394211946f308458f614839ef253ee8"
CROS_WORKON_TREE="37cab8cb62626d8c33d536e6a74ba7cf9bea602d"
CROS_WORKON_PROJECT="chromiumos/third_party/mesa"
CROS_WORKON_LOCALNAME="mesa"
CROS_WORKON_MANUAL_UPREV="1"
CROS_WORKON_EGIT_BRANCH="cros/upstream/26.1"

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
	dev-util/mesa_clc
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
		# Mesa 26's libpan compiles .cl kernels with mesa_clc; use the prebuilt
		# host tool (dev-util/mesa_clc) so the in-tree CLC path does not pull in
		# LLVM and conflict with -Dllvm=disabled ("CLC requires LLVM").
		-Dmesa-clc=system
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
