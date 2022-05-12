# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_PROJECT="chromiumos/platform/crosvm"
CROS_WORKON_LOCALNAME="platform/crosvm"
CROS_WORKON_INCREMENTAL_BUILD=1

# Pupr handles uprevs of crosvm.
CROS_WORKON_MANUAL_UPREV="1"

# We don't use CROS_WORKON_OUTOFTREE_BUILD here since crosvm/Cargo.toml is
# using "# ignored by ebuild" macro which supported by cros-rust.

inherit cros-fuzzer cros-rust cros-workon user

PREBUILT_VERSION="r0000"
KERNEL_FILE="crosvm-testing-bzimage-x86_64-${PREBUILT_VERSION}"
ROOTFS_FILE="crosvm-testing-rootfs-x86_64-${PREBUILT_VERSION}"

PREBUILT_URL="https://storage.googleapis.com/chromeos-localmirror"

DESCRIPTION="Utility for running VMs on Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/crosvm/"
SRC_URI="
	test? (
		${PREBUILT_URL}/${KERNEL_FILE}
		${PREBUILT_URL}/${ROOTFS_FILE}
	)
"

LICENSE="BSD-Google"
KEYWORDS="~*"
IUSE="test cros-debug crosvm-gpu -crosvm-direct -crosvm-plugin +crosvm-power-monitor-powerd +crosvm-video-decoder +crosvm-video-encoder +crosvm-wl-dmabuf fuzzer tpm2 android-vm-master arcvm_gce_l1"

COMMON_DEPEND="
	sys-apps/dtc:=
	sys-libs/libcap:=
	chromeos-base/libvda:=
	chromeos-base/minijail:=
	dev-libs/wayland:=
	crosvm-gpu? (
		media-libs/virglrenderer:=
	)
	crosvm-wl-dmabuf? ( media-libs/minigbm:= )
	dev-rust/libchromeos:=
	virtual/libusb:1=
"

RDEPEND="${COMMON_DEPEND}
	!chromeos-base/crosvm-bin
	crosvm-power-monitor-powerd? ( sys-apps/dbus )
	tpm2? ( sys-apps/dbus )
"

DEPEND="${COMMON_DEPEND}
	dev-libs/wayland-protocols:=
	=dev-rust/android_log-sys-0.2*:=
	>=dev-rust/anyhow-1.0.32:= <dev-rust/anyhow-2.0
	=dev-rust/async-task-4*:=
	=dev-rust/async-trait-0.1*:=
	=dev-rust/bitflags-1*:=
	~dev-rust/cc-1.0.25:=
	>=dev-rust/crc32fast-1.2.1:= <dev-rust/crc32fast-2
	dev-rust/cros_fuzz:=
	=dev-rust/dbus-0.8*:=
	>=dev-rust/downcast-rs-1.2.0:= <dev-rust/downcast-rs-2.0
	=dev-rust/futures-0.3*:=
	dev-rust/intrusive-collections:=
	=dev-rust/gdbstub-0.5*:=
	>=dev-rust/gdbstub_arch-0.1.1:= <dev-rust/gdbstub_arch-0.2
	~dev-rust/getopts-0.2.18:=
	>=dev-rust/libc-0.2.93:= <dev-rust/libc-0.3.0
	dev-rust/minijail:=
	~dev-rust/num_cpus-1.9.0:=
	>=dev-rust/once_cell-1.7.2:= <dev-rust/once_cell-2
	dev-rust/p9:=
	=dev-rust/paste-1*:=
	=dev-rust/pin-utils-0.1*:=
	~dev-rust/pkg-config-0.3.11:=
	=dev-rust/proc-macro2-1*:=
	>=dev-rust/protobuf-2.8:=
	!>=dev-rust/protobuf-3
	>=dev-rust/protoc-rust-2.8:=
	!>=dev-rust/protoc-rust-3
	=dev-rust/quote-1*:=
	=dev-rust/rand-0.6*:=
	=dev-rust/serde-1*:=
	=dev-rust/serde_json-1*:=
	>=dev-rust/smallvec-1.6.1:= <dev-rust/smallvec-2
	=dev-rust/syn-1*:=
	>=dev-rust/thiserror-1.0.20:= <dev-rust/thiserror-2.0
	>=dev-rust/uuid-0.8.2:= <dev-rust/uuid-0.9
	dev-rust/remain:=
	dev-rust/system_api:=
	dev-rust/vmm_vhost:=
	tpm2? (
		chromeos-base/tpm2:=
		chromeos-base/trunks:=
		=dev-rust/dbus-0.6*:=
	)
	media-sound/libcras:=
	crosvm-power-monitor-powerd? (
		chromeos-base/system_api
		=dev-rust/dbus-0.6*:=
	)
"

# Rust tests are currently run on the host, not inside the target sysroot.
# Hence we need to provide required runtime dependencies for tests at
# build-time.
# TODO(crbug.com/1154084): Remove when tests can run in sysroot.
BDEPEND="test? ( chromeos-base/libvda:= )"

get_seccomp_path() {
	local seccomp_arch="unknown"
	case ${ARCH} in
		amd64) seccomp_arch=x86_64;;
		arm) seccomp_arch=arm;;
		arm64) seccomp_arch=aarch64;;
	esac

	echo "seccomp/${seccomp_arch}"
}

FUZZERS=(
	crosvm_block_fuzzer
	crosvm_fs_server_fuzzer
	crosvm_qcow_fuzzer
	crosvm_usb_descriptor_fuzzer
	crosvm_virtqueue_fuzzer
	crosvm_zimage_fuzzer
)

src_unpack() {
	# Unpack both the project and dependency source code
	cros-workon_src_unpack
	cros-rust_src_unpack
}

src_prepare() {
	cros-rust_src_prepare

	if use arcvm_gce_l1; then
		eapply "${FILESDIR}"/0001-betty-arcvm-Loose-mprotect-mmap-for-software-renderi.patch
	fi

	default
}

src_configure() {
	cros-rust_src_configure

	# Change the path used for the minijail pivot root from /var/empty.
	# See: https://crbug.com/934513
	export DEFAULT_PIVOT_ROOT="/mnt/empty"
}

src_compile() {
	local features=(
		$(usex crosvm-gpu virgl_renderer "")
		$(usex crosvm-gpu virgl_renderer_next "")
		$(usex crosvm-plugin plugin "")
		$(usex crosvm-power-monitor-powerd power-monitor-powerd "")
		$(usex crosvm-video-decoder video-decoder "")
		$(usex crosvm-video-encoder video-encoder "")
		$(usex crosvm-wl-dmabuf wl-dmabuf "")
		$(usex tpm2 tpm "")
		$(usex cros-debug gdb "")
		chromeos
		$(usex android-vm-master composite-disk "")
	)

	local packages=(
		qcow_utils
		crosvm
	)

	for pkg in "${packages[@]}"; do
		ecargo_build -v \
			--features="${features[*]}" \
			-p "${pkg}" \
			|| die "cargo build failed"
	done

	if use crosvm-direct ; then
		ecargo_build -v \
			--no-default-features --features="direct" \
			-p "crosvm" --bin crosvm-direct \
			|| die "cargo build failed"
	fi

	if use fuzzer; then
		cd fuzz || die "failed to move directory"
		local f
		for f in "${FUZZERS[@]}"; do
			ecargo_build_fuzzer --bin "${f}"
		done
		cd .. || die "failed to move directory"
	fi
}

src_test() {
	# Some of the tests will use /dev/kvm.
	addwrite /dev/kvm
	local test_opts=()
	use tpm2 || test_opts+=( --exclude tpm2 --exclude tpm2-sys )

	# io_jail tests fork the process, which cause memory leak errors when
	# run under sanitizers.
	cros-rust_use_sanitizers && test_opts+=( --exclude io_jail )

	# Pass kernel/rootfs prebuilts to integration tests.
	# See crosvm/integration_tests/README.md for details.
	local CROSVM_CARGO_TEST_PREBUILT_VERSION="${PREBUILT_VERSION}"
	local kernel_binary="${DISTDIR}/${KERNEL_FILE}"
	[[ -e "${kernel_binary}" ]] || die "expected to find kernel binary at ${kernel_binary}"
	CROS_RUST_PLATFORM_TEST_ARGS+=(
		"--env" "CROSVM_CARGO_TEST_KERNEL_BINARY=${kernel_binary}"
	)

	local rootfs_image="${DISTDIR}/${ROOTFS_FILE}"
	[[ -e "${rootfs_image}" ]] || die "expected to find rootfs image at ${rootfs_image}"
	CROS_RUST_PLATFORM_TEST_ARGS+=(
		"--env" "CROSVM_CARGO_TEST_ROOTFS_IMAGE=${rootfs_image}"
	)

	# TODO(b/194848000): Reenable when /dev/log starts working inside cros_sdk.
	test_opts+=( --exclude "integration_tests" )

	# kernel versions between 5.1 and 5.10 have io_uring bugs, skip the io_uring
	# integration test on these platforms.  See b/189879899
	local cut_version=$(ver_cut 1-2 "$(uname -r)")
	if ver_test 5.10 -gt "${cut_version}"; then
		test_opts+=( --exclude "io_uring" )
	fi

	if ! use x86 && ! use amd64; then
		test_opts+=( --exclude "x86_64" )
		test_opts+=( --no-run )
	fi

	if ! use arm64; then
		test_opts+=( --exclude "aarch64" )
	fi

	if ! use crosvm-plugin; then
		test_opts+=( --exclude "crosvm_plugin" )
	fi

	# Excluding tests that run on a different arch, use /dev/dri,
	# /dev/net/tun, or wayland access because the bots don't support these.
	local args=(
		--workspace -v
		--exclude net_util
		--exclude gpu_display
		--exclude rutabaga_gfx
		--exclude crosvm-fuzz
		# Also exclude the following since their tests are run in their ebuilds.
		--exclude enumn
		--exclude sys_util
		"${test_opts[@]}"
	)

	# Non-x86 platforms set --no-run to disable executing the tests.
	if ! has "--no-run" "${args[@]}"; then
		# Run the "boot" test on the host until the syslog is properly passed
		# into the sandbox.
		# TODO(crbug.com/1154084) Run these on the host until libtest and libstd
		# are available on the target.
		cros-rust_get_host_test_executables "${args[@]}" --lib --tests
	fi

	ecargo_test "${args[@]}" \
		-- --test-threads=1 \
		|| die "cargo test failed"

	# Plugin tests all require /dev/kvm, but we want to make sure they build
	# at least.
	if use crosvm-plugin; then
		ecargo_test --no-run --features plugin \
			|| die "cargo build with plugin feature failed"
	fi
}

src_install() {
	# cargo doesn't know how to install cross-compiled binaries.  It will
	# always install native binaries for the host system.  Manually install
	# crosvm instead.
	local build_dir="$(cros-rust_get_build_dir)"
	dobin "${build_dir}/crosvm"

	# Install seccomp policy files.
	local seccomp_path="${S}/$(get_seccomp_path)"
	if [[ -d "${seccomp_path}" ]] ; then
		local policy
		for policy in "${seccomp_path}"/*.policy; do
			sed -i "s:/usr/share/policy/crosvm:${seccomp_path}:g" "${policy}" \
				|| die "failed to modify seccomp policy ${policy}"
		done
		for policy in "${seccomp_path}"/*.policy; do
			local policy_output="${policy%.policy}.bpf"
			compile_seccomp_policy \
				--arch-json "${SYSROOT}/build/share/constants.json" \
				--default-action trap "${policy}" "${policy_output}" \
				|| die "failed to compile seccomp policy ${policy}"
		done
		rm "${seccomp_path}"/common_device.bpf
		insinto /usr/share/policy/crosvm
		doins "${seccomp_path}"/*.bpf
	fi

	# Install qcow utils library, header, and pkgconfig files.
	dolib.so "${build_dir}/deps/libqcow_utils.so"

	local include_dir="/usr/include/crosvm"

	"${S}"/qcow_utils/platform2_preinstall.sh "${PV}" "${include_dir}" \
		"${WORKDIR}"
	insinto "/usr/$(get_libdir)/pkgconfig"
	doins "${WORKDIR}/libqcow_utils.pc"

	insinto "${include_dir}"
	doins "${S}"/qcow_utils/src/qcow_utils.h

	# Install plugin library, when requested.
	if use crosvm-plugin ; then
		insinto "${include_dir}"
		doins "${S}/crosvm_plugin/crosvm.h"
		dolib.so "${build_dir}/deps/libcrosvm_plugin.so"
	fi

	# Install crosvm-direct, when requested.
	if use crosvm-direct ; then
		into /build/manatee
		dobin "${build_dir}/crosvm-direct"
	fi

	if use fuzzer; then
		cd fuzz || die "failed to move directory"
		local f
		for f in "${FUZZERS[@]}"; do
			local fuzzer_component_id="982362"
			fuzzer_install "${S}/fuzz/OWNERS" \
				"${build_dir}/${f}" \
				--comp "${fuzzer_component_id}"
		done
		cd .. || die "failed to move directory"
	fi
}

pkg_preinst() {
	enewuser "crosvm"
	enewgroup "crosvm"

	cros-rust_pkg_preinst
}
