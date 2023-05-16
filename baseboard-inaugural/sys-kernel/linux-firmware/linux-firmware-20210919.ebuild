# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit savedconfig multiprocessing toolchain-funcs

#SRC_URI="https://mirrors.edge.kernel.org/pub/linux/kernel/firmware/linux-firmware-20210919.tar.xz"
SRC_URI="https://cdn.kernel.org/pub/linux/kernel/firmware/${P}.tar.xz"

KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

S="${WORKDIR}/${P}"
FIRMWARE_INSTALL_ROOT="/lib/firmware"

DESCRIPTION="Linux firmware files"
HOMEPAGE="https://github.com/armbian/firmware.git"

LICENSE="
LICENSE.qcom
LICENSE.amd-ucode
LICENSE.amdgpu
LICENSE.QualcommAtheros_ath10k
LICENSE.i915
LICENSE.ipu3_firmware
LICENSE.ice
LICENSE.keyspan_usb
LICENSE.QualcommAtheros_ath10k
LICENSE.qcom
LICENSE.radeon
LICENSE.amdgpu
LICENCE.ralink_a_mediatek_company_firmware
LICENCE.adsp_sst
LICENCE.atheros_firmware
LICENCE.broadcom_bcm43xx
LICENCE.fw_sst
LICENCE.IntcSST2
LICENCE.ibt_firmware
LICENCE.Marvell
LICENCE.NXP
LICENCE.mediatek-nic
LICENCE.mediatek-vpu
LICENCE.nvidia
LICENCE.rockchip
LICENCE.ralink-firmware.txt
LICENCE.rtl_nic
LICENCE.rtlwifi_firmware
LICENCE.rtl_nic
LICENCE.rtlwifi_firmware
"

SLOT="0"
IUSE="compress-xz compress-zstd initramfs +redistributable savedconfig +unknown-license"
REQUIRED_USE="initramfs? ( redistributable )
	?? ( compress-xz compress-zstd )"

RESTRICT="binchecks strip
	unknown-license? ( bindist )"

BDEPEND="initramfs? ( app-arch/cpio )
	compress-xz? ( app-arch/xz-utils )
	compress-zstd? ( app-arch/zstd )
"

#add anything else that collides to this
RDEPEND="!savedconfig? (
		redistributable? (
			!sys-firmware/alsa-firmware[alsa_cards_ca0132]
			!sys-block/qla-fc-firmware
			!sys-firmware/iwl1000-ucode
			!sys-firmware/iwl6005-ucode
			!sys-firmware/iwl6030-ucode
			!sys-firmware/iwl3160-ucode
			!sys-firmware/iwl7260-ucode
			!sys-firmware/iwl3160-7260-bt-ucode
			!sys-firmware/raspberrypi-wifi-ucode
		)
		unknown-license? (
			!sys-firmware/alsa-firmware[alsa_cards_korg1212]
			!sys-firmware/alsa-firmware[alsa_cards_maestro3]
			!sys-firmware/alsa-firmware[alsa_cards_sb16]
			!sys-firmware/alsa-firmware[alsa_cards_ymfpci]
		)
        sys-kernel/linux-firmware
	)"

QA_PREBUILT="*"

src_unpack() {
             default
#		git-r3_src_unpack
}

src_prepare() {
	default

    rm nvidia -rf
    rm amdgpu -rf
    rm radeon -rf
    rm qcom -rf
    rm netronome -rf
    # https://bugs.archlinux.org/task/70071
    rm iwlwifi-ty-a0-gf-a0.pnvm

#	find . -type f -not -perm 0644 -print0 \
#		| xargs --null --no-run-if-empty chmod 0644 \
#		|| die

	#chmod +x copy-firmware.sh || die

	# whitelist of misc files
	local misc_files=(
		copy-firmware.sh
		WHENCE
		README
	)

	# whitelist of images with a free software license
	local free_software=(
		# keyspan_pda (GPL-2+)
		keyspan_pda/keyspan_pda.fw
		keyspan_pda/xircom_pgs.fw
		# dsp56k (GPL-2+)
		dsp56k/bootstrap.bin
		# ath9k_htc (BSD GPL-2+ MIT)
		ath9k_htc/htc_7010-1.4.0.fw
		ath9k_htc/htc_9271-1.4.0.fw
		# pcnet_cs, 3c589_cs, 3c574_cs, serial_cs (dual GPL-2/MPL-1.1)
		cis/LA-PCM.cis
		cis/PCMLM28.cis
		cis/DP83903.cis
		cis/NE2K.cis
		cis/tamarack.cis
		cis/PE-200.cis
		cis/PE520.cis
		cis/3CXEM556.cis
		cis/3CCFEM556.cis
		cis/MT5634ZLX.cis
		cis/RS-COM-2P.cis
		cis/COMpad2.cis
		cis/COMpad4.cis
		# serial_cs (GPL-3)
		cis/SW_555_SER.cis
		cis/SW_7xx_SER.cis
		cis/SW_8xx_SER.cis
		# dvb-ttpci (GPL-2+)
		av7110/bootcode.bin
		# usbdux, usbduxfast, usbduxsigma (GPL-2+)
		usbdux_firmware.bin
		usbduxfast_firmware.bin
		usbduxsigma_firmware.bin
		# brcmfmac (GPL-2+)
		brcm/brcmfmac4330-sdio.Prowise-PT301.txt
		brcm/brcmfmac43340-sdio.meegopad-t08.txt
		brcm/brcmfmac43362-sdio.cubietech,cubietruck.txt
		brcm/brcmfmac43362-sdio.lemaker,bananapro.txt
		brcm/brcmfmac43430a0-sdio.jumper-ezpad-mini3.txt
		"brcm/brcmfmac43430a0-sdio.ONDA-V80 PLUS.txt"
		brcm/brcmfmac43430-sdio.AP6212.txt
		brcm/brcmfmac43430-sdio.Hampoo-D2D3_Vi8A1.txt
		brcm/brcmfmac43430-sdio.MUR1DX.txt
		brcm/brcmfmac43430-sdio.raspberrypi,3-model-b.txt
		brcm/brcmfmac43455-sdio.raspberrypi,3-model-b-plus.txt
		brcm/brcmfmac4356-pcie.gpd-win-pocket.txt
		# isci (GPL-2)
		isci/isci_firmware.bin
		# carl9170 (GPL-2+)
		carl9170-1.fw
		# atusb (GPL-2+)
		atusb/atusb-0.2.dfu
		atusb/atusb-0.3.dfu
		atusb/rzusb-0.3.bin
		# mlxsw_spectrum (dual BSD/GPL-2)
		mellanox/mlxsw_spectrum-13.1420.122.mfa2
		mellanox/mlxsw_spectrum-13.1530.152.mfa2
		mellanox/mlxsw_spectrum-13.1620.192.mfa2
		mellanox/mlxsw_spectrum-13.1702.6.mfa2
		mellanox/mlxsw_spectrum-13.1703.4.mfa2
		mellanox/mlxsw_spectrum-13.1910.622.mfa2
		mellanox/mlxsw_spectrum-13.2000.1122.mfa2
	)

	# blacklist of images with unknown license
	local unknown_license=(
		korg/k1212.dsp
		ess/maestro3_assp_kernel.fw
		ess/maestro3_assp_minisrc.fw
		yamaha/ds1_ctrl.fw
		yamaha/ds1_dsp.fw
		yamaha/ds1e_ctrl.fw
		ttusb-budget/dspbootcode.bin
		emi62/bitstream.fw
		emi62/loader.fw
		emi62/midi.fw
		emi62/spdif.fw
		ti_3410.fw
		ti_5052.fw
		mts_mt9234mu.fw
		mts_mt9234zba.fw
		whiteheat.fw
		whiteheat_loader.fw
		cpia2/stv0672_vp4.bin
		vicam/firmware.fw
		edgeport/boot.fw
		edgeport/boot2.fw
		edgeport/down.fw
		edgeport/down2.fw
		edgeport/down3.bin
		sb16/mulaw_main.csp
		sb16/alaw_main.csp
		sb16/ima_adpcm_init.csp
		sb16/ima_adpcm_playback.csp
		sb16/ima_adpcm_capture.csp
		sun/cassini.bin
		acenic/tg1.bin
		acenic/tg2.bin
		adaptec/starfire_rx.bin
		adaptec/starfire_tx.bin
		yam/1200.bin
		yam/9600.bin
		ositech/Xilinx7OD.bin
		qlogic/isp1000.bin
		myricom/lanai.bin
		yamaha/yss225_registers.bin
		lgs8g75.fw
	)

	if use !unknown-license; then
		einfo "Removing files with unknown license ..."
		rm -v "${unknown_license[@]}" || die
	fi

	if use !redistributable; then
		# remove files _not_ in the free_software or unknown_license lists
		# everything else is confirmed (or assumed) to be redistributable
		# based on upstream acceptance policy
		einfo "Removing non-redistributable files ..."
		local OLDIFS="${IFS}"
		local IFS=$'\n'
		set -o pipefail
		find ! -type d -printf "%P\n" \
			| grep -Fvx -e "${misc_files[*]}" -e "${free_software[*]}" -e "${unknown_license[*]}" \
			| xargs -d '\n' --no-run-if-empty rm -v

		[[ ${?} -ne 0 ]] && die "Failed to remove non-redistributable files"

		IFS="${OLDIFS}"
	fi

	restore_config ${PN}.conf
}

doins_subdir() {
        # Avoid having this insinto command affecting later doins calls.
        local file
        for file in "${@}"; do
                (
                insinto "${FIRMWARE_INSTALL_ROOT}/${file%/*}"
                doins "${file}"
                )
        done
}

src_install() {
	if use compress-xz || use compress-zstd; then
                einfo "Compressing firmware ..."
                local target
                local ext
                local compressor

                if use compress-xz; then
                        ext=xz
                        compressor="xz -T1 -C crc32"
                elif use compress-zstd; then
                        ext=zst
                        compressor="zstd -15 -T1 -C -q --rm"
                fi

                # rename symlinks
                while IFS= read -r -d '' f; do
                        # skip symlinks pointing to directories
                        [[ -d ${f} ]] && continue
                        target=$(readlink "${f}")
                        [[ $? -eq 0 ]] || die
                        ln -sf "${target}".${ext} "${f}" || die
                        mv -T "${f}" "${f}".${ext} || die
                done < <(find . -type l -print0) || die

                find . -type f ! -path "./amd-ucode/*" -print0 | \
                        xargs -0 -P $(makeopts_jobs) -I'{}' ${compressor} '{}' || die

        fi

	insinto "${FIRMWARE_INSTALL_ROOT}"
	doins -r *
	
	local link target
	while read -r link target; do
                # ${target} is link-relative, so we need to construct a full path.
                local install_target="${D}/${FIRMWARE_INSTALL_ROOT}/$(dirname "${link}")/${target}"
                # Skip 'Link' directives for files we didn't install already.
                [[ -f "${install_target}" ]] || continue
                einfo "Creating link ${link} (${target})"
                dodir "${FIRMWARE_INSTALL_ROOT}/$(dirname "${link}")"
                dosym "${target}" "${FIRMWARE_INSTALL_ROOT}/${link}"	
        done < <(grep -E '^Link:' WHENCE | sed -e's/^Link: *//g' -e's/-> //g')

}
