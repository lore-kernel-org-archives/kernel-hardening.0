Return-Path: <SRS0=/2jR=XY=lists.openwall.com=kernel-hardening-return-16962-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E223C4360C
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Sep 2019 16:33:38 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9312F217F5
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Sep 2019 16:33:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HyB9pHxV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9312F217F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16962-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25956 invoked by uid 550); 29 Sep 2019 16:31:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25793 invoked from network); 29 Sep 2019 16:31:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yMovsAb9YtJVIq0VTEaROCxH3KDigz4KMu67Uk/gZpw=;
        b=HyB9pHxVvZs9b3T5YdjI/9bck2nPp8KwX4tpDWodbgVt9Fg60v0RUmLchjidomNkJc
         EjsXcOcWozTiS4EbZtZF81XIOFe0pl0sPRJIfggHjJRa6RYrn+VDWx/xCykf+652o0Uy
         VJUmLlu1Cmhr1TcQLDam7wi00adwWvyTcAru9dCJPe88mBNKJcU8gEyL+5qGSGD1Yvvl
         MFyWKoPgwVapkkm+Eh+/22WzVXr5AKgv7spqiPSKD9+7PSkztPgpzGszFts0pRtV+HQD
         AP3jA82lW8aS626RR2XcwLPpSoAq8ZiMDCr3NUKFYWpvW9pQpj58qiIf0P0qNKoSubK7
         Vv5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yMovsAb9YtJVIq0VTEaROCxH3KDigz4KMu67Uk/gZpw=;
        b=ap0Ihv47AYJyg37CVaY4Go/Uw1L9Kkn9Q79IMLadlArQR/1HQhCgtrzLgtrbykUWn+
         dwYMbhPN0NaaH747ab1pnmgxLJwwDjYfptwrbmSHgJABhq8hIOU5QmQs1sKKuz2Fhmgb
         WpE4Bn1w85yWuW7Xdj0M/lYPEEBBsdK5YgdvSNdLHnWYFdTbldLObdQhTOV6CE2ULkUw
         Ap7+yBFmUEcRWuvYhJfgKezKBtNjQU5wnCtd0ukh5kbx6QhtxbO+L6WtgvVFKrKfkvmx
         mT4uU1f9uGAgxlM1TDak3By8oPBJMF/ff10vcJNAg5tBOooBn+fkgYh/HL1PP7eb3Edi
         Vi+A==
X-Gm-Message-State: APjAAAUKuY94U72Nxv/X4TfTvYE94mQisBe3/tFMVxh2qNvLnobOZ44I
	3mZd7tI/PC9m3LsmUg6OvCM=
X-Google-Smtp-Source: APXvYqw/86LujSZ/ZielSQM7Ii0rsOBIQxUg8twSl0M80KcEhNcfgWq9uwa1kDQ/yNfi+StCtzCrrQ==
X-Received: by 2002:a7b:cc0b:: with SMTP id f11mr14491787wmh.112.1569774662859;
        Sun, 29 Sep 2019 09:31:02 -0700 (PDT)
From: Romain Perier <romain.perier@gmail.com>
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>,
	Romain Perier <romain.perier@gmail.com>
Subject: [PRE-REVIEW PATCH 11/16] treewide: Globally replace tasklet_init() by tasklet_setup()
Date: Sun, 29 Sep 2019 18:30:23 +0200
Message-Id: <20190929163028.9665-12-romain.perier@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929163028.9665-1-romain.perier@gmail.com>
References: <20190929163028.9665-1-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This converts all remaining cases of the old tasklet_init() API into
tasklet_setup(), where the callback argument is the structure already
holding the struct tasklet_struct. These should have no behavioral changes,
since they just change which pointer is passed into the callback with
the same available pointers after conversion. Moreover, all callbacks
that were not passing a pointer of structure holding the struct
tasklet_struct has already been converted.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 arch/um/drivers/vector_kern.c                 |  6 +--
 drivers/atm/eni.c                             |  8 ++--
 drivers/atm/fore200e.c                        | 14 +++---
 drivers/atm/he.c                              |  8 ++--
 drivers/atm/solos-pci.c                       |  8 ++--
 drivers/block/umem.c                          |  6 +--
 drivers/block/xsysace.c                       |  6 +--
 drivers/char/ipmi/ipmi_msghandler.c           | 12 +++---
 drivers/crypto/amcc/crypto4xx_core.c          |  7 ++-
 drivers/crypto/atmel-aes.c                    | 14 +++---
 drivers/crypto/atmel-sha.c                    | 14 +++---
 drivers/crypto/atmel-tdes.c                   | 14 +++---
 drivers/crypto/axis/artpec6_crypto.c          |  7 ++-
 drivers/crypto/caam/jr.c                      |  8 ++--
 drivers/crypto/cavium/cpt/cptvf_main.c        |  9 ++--
 drivers/crypto/cavium/nitrox/nitrox_common.h  |  2 +-
 drivers/crypto/cavium/nitrox/nitrox_isr.c     | 13 +++---
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c  |  4 +-
 drivers/crypto/ccp/ccp-dev-v3.c               |  9 ++--
 drivers/crypto/ccp/ccp-dev-v5.c               |  9 ++--
 drivers/crypto/ccp/ccp-dev.c                  |  6 +--
 drivers/crypto/ccp/ccp-dmaengine.c            |  7 ++-
 drivers/crypto/ccree/cc_fips.c                |  8 ++--
 drivers/crypto/ccree/cc_request_mgr.c         | 12 +++---
 drivers/crypto/hifn_795x.c                    |  6 +--
 drivers/crypto/img-hash.c                     | 12 +++---
 drivers/crypto/ixp4xx_crypto.c                |  5 +--
 drivers/crypto/mediatek/mtk-aes.c             | 14 +++---
 drivers/crypto/mediatek/mtk-sha.c             | 14 +++---
 drivers/crypto/omap-aes.c                     |  6 +--
 drivers/crypto/omap-des.c                     |  6 +--
 drivers/crypto/omap-sham.c                    |  6 +--
 drivers/crypto/picoxcell_crypto.c             |  7 ++-
 drivers/crypto/qat/qat_common/adf_isr.c       |  5 +--
 drivers/crypto/qat/qat_common/adf_sriov.c     |  8 ++--
 drivers/crypto/qat/qat_common/adf_transport.c |  4 +-
 .../qat/qat_common/adf_transport_internal.h   |  2 +-
 drivers/crypto/qat/qat_common/adf_vf_isr.c    | 11 +++--
 drivers/crypto/qce/core.c                     |  7 ++-
 drivers/crypto/rockchip/rk3288_crypto.c       | 14 +++---
 drivers/crypto/s5p-sss.c                      | 13 +++---
 drivers/crypto/talitos.c                      | 42 ++++++++----------
 drivers/dma/altera-msgdma.c                   |  6 +--
 drivers/dma/at_hdmac.c                        |  7 ++-
 drivers/dma/at_xdmac.c                        |  7 ++-
 drivers/dma/coh901318.c                       |  7 ++-
 drivers/dma/dw/core.c                         |  6 +--
 drivers/dma/ep93xx_dma.c                      |  7 ++-
 drivers/dma/fsl_raid.c                        |  8 ++--
 drivers/dma/fsldma.c                          |  6 +--
 drivers/dma/imx-dma.c                         |  7 ++-
 drivers/dma/ioat/dma.c                        |  6 +--
 drivers/dma/ioat/dma.h                        |  2 +-
 drivers/dma/ioat/init.c                       |  2 +-
 drivers/dma/iop-adma.c                        |  8 ++--
 drivers/dma/ipu/ipu_idmac.c                   |  6 +--
 drivers/dma/k3dma.c                           |  6 +--
 drivers/dma/mediatek/mtk-cqdma.c              |  7 ++-
 drivers/dma/mmp_pdma.c                        |  6 +--
 drivers/dma/mmp_tdma.c                        |  6 +--
 drivers/dma/mpc512x_dma.c                     |  6 +--
 drivers/dma/mv_xor.c                          |  7 ++-
 drivers/dma/mv_xor_v2.c                       |  8 ++--
 drivers/dma/mxs-dma.c                         |  7 ++-
 drivers/dma/nbpfaxi.c                         |  6 +--
 drivers/dma/pch_dma.c                         |  7 ++-
 drivers/dma/pl330.c                           | 12 +++---
 drivers/dma/ppc4xx/adma.c                     |  7 ++-
 drivers/dma/qcom/bam_dma.c                    |  6 +--
 drivers/dma/qcom/hidma.c                      |  6 +--
 drivers/dma/qcom/hidma_ll.c                   |  6 +--
 drivers/dma/sa11x0-dma.c                      |  6 +--
 drivers/dma/sirf-dma.c                        |  6 +--
 drivers/dma/ste_dma40.c                       |  7 ++-
 drivers/dma/sun6i-dma.c                       |  6 +--
 drivers/dma/tegra20-apb-dma.c                 |  7 ++-
 drivers/dma/timb_dma.c                        |  6 +--
 drivers/dma/txx9dmac.c                        | 14 +++---
 drivers/dma/virt-dma.c                        |  6 +--
 drivers/dma/xgene-dma.c                       |  7 ++-
 drivers/dma/xilinx/xilinx_dma.c               |  7 ++-
 drivers/dma/xilinx/zynqmp_dma.c               |  6 +--
 drivers/firewire/ohci.c                       | 16 +++----
 drivers/gpu/drm/i915/gt/intel_lrc.c           | 26 ++++++-----
 .../gpu/drm/i915/gt/uc/intel_guc_submission.c |  7 +--
 drivers/hsi/clients/nokia-modem.c             |  9 ++--
 drivers/hsi/controllers/omap_ssi_core.c       |  9 ++--
 drivers/hv/channel_mgmt.c                     |  3 +-
 drivers/hv/connection.c                       |  4 +-
 drivers/hv/hv.c                               |  3 +-
 drivers/hv/hyperv_vmbus.h                     |  4 +-
 drivers/hv/vmbus_drv.c                        |  4 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.c      |  7 ++-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c    | 11 +++--
 drivers/infiniband/hw/hfi1/sdma.c             | 20 ++++-----
 drivers/infiniband/hw/i40iw/i40iw_main.c      | 14 +++---
 drivers/infiniband/hw/qib/qib_iba7322.c       |  7 ++-
 drivers/infiniband/hw/qib/qib_sdma.c          | 10 ++---
 drivers/infiniband/sw/rxe/rxe_cq.c            |  6 +--
 drivers/infiniband/sw/rxe/rxe_task.c          |  8 ++--
 drivers/infiniband/sw/rxe/rxe_task.h          |  2 +-
 drivers/input/serio/hp_sdc.c                  |  4 +-
 drivers/mailbox/bcm-pdc-mailbox.c             |  6 +--
 drivers/mailbox/imx-mailbox.c                 |  7 ++-
 drivers/media/pci/bt8xx/dvb-bt8xx.c           |  7 +--
 drivers/media/pci/mantis/mantis_dma.c         |  4 +-
 drivers/media/pci/mantis/mantis_dma.h         |  2 +-
 drivers/media/pci/mantis/mantis_dvb.c         |  2 +-
 drivers/media/pci/ngene/ngene-core.c          | 12 +++---
 drivers/media/pci/smipcie/smipcie-main.c      |  6 +--
 drivers/media/pci/ttpci/av7110.c              | 20 ++++-----
 drivers/media/pci/ttpci/budget-ci.c           | 16 ++++---
 drivers/media/pci/ttpci/budget-core.c         |  6 +--
 drivers/media/pci/tw5864/tw5864-video.c       |  9 ++--
 .../media/platform/marvell-ccic/mcam-core.c   |  7 ++-
 drivers/media/platform/pxa_camera.c           |  6 +--
 .../platform/sti/c8sectpfe/c8sectpfe-core.c   | 10 ++---
 drivers/media/radio/wl128x/fmdrv_common.c     | 12 +++---
 drivers/media/usb/ttusb-dec/ttusb_dec.c       |  7 ++-
 drivers/memstick/host/jmb38x_ms.c             |  8 ++--
 drivers/memstick/host/tifm_ms.c               |  8 ++--
 drivers/misc/ibmvmc.c                         |  8 ++--
 drivers/misc/vmw_vmci/vmci_guest.c            | 15 +++----
 drivers/mmc/host/atmel-mci.c                  |  6 +--
 drivers/mmc/host/au1xmmc.c                    | 14 +++---
 drivers/mmc/host/cb710-mmc.c                  | 10 ++---
 drivers/mmc/host/dw_mmc.c                     |  6 +--
 drivers/mmc/host/omap.c                       |  7 ++-
 drivers/mmc/host/renesas_sdhi_internal_dmac.c | 19 ++++----
 drivers/mmc/host/renesas_sdhi_sys_dmac.c      |  9 ++--
 drivers/mmc/host/s3cmci.c                     |  6 +--
 drivers/mmc/host/tifm_sd.c                    |  7 ++-
 drivers/mmc/host/uniphier-sd.c                | 14 +++---
 drivers/mmc/host/via-sdmmc.c                  |  7 ++-
 drivers/mmc/host/wbsd.c                       | 35 +++++++--------
 drivers/net/arcnet/arcnet.c                   |  7 ++-
 drivers/net/caif/caif_virtio.c                |  8 ++--
 drivers/net/ethernet/alteon/acenic.c          |  9 ++--
 drivers/net/ethernet/alteon/acenic.h          |  2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c      | 19 ++++----
 drivers/net/ethernet/amd/xgbe/xgbe-i2c.c      | 11 +++--
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c     | 11 +++--
 drivers/net/ethernet/broadcom/cnic.c          | 18 ++++----
 drivers/net/ethernet/cadence/macb_main.c      |  7 ++-
 .../net/ethernet/cavium/liquidio/lio_main.c   | 10 ++---
 .../net/ethernet/cavium/octeon/octeon_mgmt.c  |  7 ++-
 .../net/ethernet/cavium/thunder/nicvf_main.c  | 10 ++---
 .../ethernet/cavium/thunder/nicvf_queues.c    |  4 +-
 .../ethernet/cavium/thunder/nicvf_queues.h    |  2 +-
 drivers/net/ethernet/chelsio/cxgb/sge.c       |  9 ++--
 drivers/net/ethernet/chelsio/cxgb3/sge.c      | 16 +++----
 drivers/net/ethernet/chelsio/cxgb4/sge.c      | 12 +++---
 drivers/net/ethernet/dlink/sundance.c         | 19 ++++----
 .../net/ethernet/huawei/hinic/hinic_hw_eqs.c  |  7 ++-
 drivers/net/ethernet/ibm/ehea/ehea_main.c     |  7 ++-
 drivers/net/ethernet/ibm/ibmvnic.c            |  7 ++-
 drivers/net/ethernet/jme.c                    | 43 +++++++------------
 drivers/net/ethernet/marvell/skge.c           |  6 +--
 drivers/net/ethernet/mellanox/mlx4/cq.c       |  4 +-
 drivers/net/ethernet/mellanox/mlx4/eq.c       |  3 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h     |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/cq.c  |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |  3 +-
 .../ethernet/mellanox/mlx5/core/fpga/conn.c   |  7 ++-
 .../net/ethernet/mellanox/mlx5/core/lib/eq.h  |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/pci.c     | 12 +++---
 drivers/net/ethernet/micrel/ks8842.c          | 19 ++++----
 drivers/net/ethernet/micrel/ksz884x.c         | 14 +++---
 drivers/net/ethernet/natsemi/ns83820.c        |  8 ++--
 .../ethernet/netronome/nfp/nfp_net_common.c   |  7 ++-
 drivers/net/ethernet/ni/nixge.c               |  7 ++-
 drivers/net/ethernet/qlogic/qed/qed_int.c     |  7 ++-
 drivers/net/ethernet/qlogic/qed/qed_int.h     |  2 +-
 drivers/net/ethernet/silan/sc92031.c          | 11 ++---
 drivers/net/ethernet/smsc/smc91x.c            |  8 ++--
 .../net/ethernet/xilinx/xilinx_axienet_main.c |  9 ++--
 drivers/net/ifb.c                             |  7 ++-
 drivers/net/ppp/ppp_async.c                   |  8 ++--
 drivers/net/ppp/ppp_synctty.c                 |  8 ++--
 drivers/net/usb/cdc_ncm.c                     |  8 ++--
 drivers/net/usb/hso.c                         |  8 ++--
 drivers/net/usb/lan78xx.c                     |  6 +--
 drivers/net/usb/pegasus.c                     |  6 +--
 drivers/net/usb/r8152.c                       |  8 ++--
 drivers/net/usb/rtl8150.c                     |  6 +--
 drivers/net/usb/usbnet.c                      |  4 +-
 drivers/net/wireless/ath/ath5k/base.c         | 24 +++++------
 drivers/net/wireless/ath/ath5k/rfkill.c       |  8 ++--
 drivers/net/wireless/ath/ath9k/ath9k.h        |  4 +-
 drivers/net/wireless/ath/ath9k/beacon.c       |  4 +-
 drivers/net/wireless/ath/ath9k/htc.h          |  4 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |  6 +--
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |  8 ++--
 drivers/net/wireless/ath/ath9k/init.c         |  5 +--
 drivers/net/wireless/ath/ath9k/main.c         |  4 +-
 drivers/net/wireless/ath/ath9k/wmi.c          |  7 ++-
 drivers/net/wireless/ath/ath9k/wmi.h          |  2 +-
 drivers/net/wireless/ath/carl9170/usb.c       |  7 ++-
 drivers/net/wireless/atmel/at76c50x-usb.c     |  8 ++--
 .../net/wireless/broadcom/b43legacy/main.c    |  7 ++-
 drivers/net/wireless/broadcom/b43legacy/pio.c |  7 ++-
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c |  6 +--
 .../broadcom/brcm80211/brcmsmac/mac80211_if.h |  2 +-
 drivers/net/wireless/intel/ipw2x00/ipw2100.c  |  8 ++--
 drivers/net/wireless/intel/ipw2x00/ipw2200.c  |  6 +--
 .../net/wireless/intel/iwlegacy/3945-mac.c    |  7 ++-
 .../net/wireless/intel/iwlegacy/4965-mac.c    |  7 ++-
 .../net/wireless/intersil/hostap/hostap_hw.c  | 18 ++++----
 drivers/net/wireless/intersil/orinoco/main.c  |  7 ++-
 drivers/net/wireless/intersil/p54/p54pci.c    |  8 ++--
 drivers/net/wireless/marvell/mwl8k.c          | 16 +++----
 drivers/net/wireless/mediatek/mt76/mac80211.c |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76.h     |  2 +-
 .../wireless/mediatek/mt76/mt7603/beacon.c    |  4 +-
 .../net/wireless/mediatek/mt76/mt7603/init.c  |  3 +-
 .../wireless/mediatek/mt76/mt7603/mt7603.h    |  2 +-
 .../net/wireless/mediatek/mt76/mt76x02_dfs.c  |  9 ++--
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c | 14 +++---
 drivers/net/wireless/mediatek/mt76/tx.c       |  4 +-
 drivers/net/wireless/mediatek/mt76/usb.c      | 12 +++---
 drivers/net/wireless/mediatek/mt7601u/dma.c   | 12 +++---
 .../quantenna/qtnfmac/pcie/pearl_pcie.c       |  7 ++-
 .../quantenna/qtnfmac/pcie/topaz_pcie.c       |  7 ++-
 .../net/wireless/ralink/rt2x00/rt2400pci.c    | 14 +++---
 .../net/wireless/ralink/rt2x00/rt2500pci.c    | 14 +++---
 .../net/wireless/ralink/rt2x00/rt2800mmio.c   | 25 ++++++-----
 .../net/wireless/ralink/rt2x00/rt2800mmio.h   | 10 ++---
 drivers/net/wireless/ralink/rt2x00/rt2x00.h   | 10 ++---
 .../net/wireless/ralink/rt2x00/rt2x00dev.c    |  5 +--
 drivers/net/wireless/ralink/rt2x00/rt61pci.c  | 19 ++++----
 drivers/net/wireless/realtek/rtlwifi/pci.c    | 20 +++++----
 drivers/net/wireless/realtek/rtlwifi/usb.c    | 10 ++---
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c  |  8 ++--
 drivers/ntb/ntb_transport.c                   |  9 ++--
 drivers/platform/goldfish/goldfish_pipe.c     |  7 ++-
 drivers/rapidio/devices/tsi721_dma.c          |  7 ++-
 drivers/s390/block/dasd.c                     | 18 ++++----
 drivers/s390/char/con3215.c                   |  6 +--
 drivers/s390/char/con3270.c                   |  7 ++-
 drivers/s390/char/tty3270.c                   | 15 +++----
 drivers/s390/cio/qdio.h                       |  6 +--
 drivers/s390/cio/qdio_main.c                  | 12 +++---
 drivers/s390/cio/qdio_setup.c                 |  9 ++--
 drivers/s390/net/ctcm_main.c                  |  9 ++--
 drivers/s390/net/ctcm_mpc.c                   | 16 +++----
 drivers/s390/net/ctcm_mpc.h                   |  6 +--
 drivers/scsi/aic94xx/aic94xx_hwi.c            |  9 ++--
 drivers/scsi/esas2r/esas2r.h                  |  2 +-
 drivers/scsi/esas2r/esas2r_init.c             |  4 +-
 drivers/scsi/esas2r/esas2r_main.c             |  4 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c        |  6 +--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c        |  6 +--
 drivers/scsi/ibmvscsi/ibmvfc.c                |  6 +--
 drivers/scsi/ibmvscsi/ibmvscsi.c              |  8 ++--
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c      |  7 ++-
 drivers/scsi/isci/host.c                      |  4 +-
 drivers/scsi/isci/host.h                      |  2 +-
 drivers/scsi/isci/init.c                      |  4 +-
 drivers/scsi/megaraid/megaraid_mbox.c         | 11 +++--
 drivers/scsi/megaraid/megaraid_sas.h          |  2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c     | 16 +++----
 drivers/scsi/megaraid/megaraid_sas_fusion.c   | 13 +++---
 drivers/scsi/mvsas/mv_init.c                  |  8 ++--
 drivers/scsi/pm8001/pm8001_init.c             | 25 ++++++-----
 drivers/scsi/pmcraid.c                        | 21 +++++----
 drivers/spi/spi-pl022.c                       |  7 ++-
 drivers/staging/isdn/gigaset/bas-gigaset.c    | 22 +++++-----
 drivers/staging/isdn/gigaset/common.c         |  3 +-
 drivers/staging/isdn/gigaset/ev-layer.c       |  4 +-
 drivers/staging/isdn/gigaset/gigaset.h        |  2 +-
 drivers/staging/isdn/gigaset/interface.c      |  6 +--
 drivers/staging/isdn/gigaset/ser-gigaset.c    |  7 ++-
 drivers/staging/isdn/gigaset/usb-gigaset.c    |  7 ++-
 drivers/staging/ks7010/ks7010_sdio.c          |  6 +--
 drivers/staging/ks7010/ks_hostif.c            |  6 +--
 drivers/staging/mt7621-dma/mtk-hsdma.c        |  6 +--
 drivers/staging/ralink-gdma/ralink-gdma.c     |  6 +--
 .../staging/rtl8188eu/hal/rtl8188eu_recv.c    |  4 +-
 .../staging/rtl8188eu/hal/rtl8188eu_xmit.c    |  5 +--
 .../staging/rtl8188eu/include/rtl8188e_recv.h |  2 +-
 .../staging/rtl8188eu/include/rtl8188e_xmit.h |  2 +-
 .../staging/rtl8188eu/os_dep/usb_ops_linux.c  |  8 ++--
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c  | 29 +++++++------
 drivers/staging/rtl8192e/rtllib_softmac.c     |  8 ++--
 .../rtl8192u/ieee80211/ieee80211_softmac.c    |  7 ++-
 drivers/staging/rtl8192u/r8192U_core.c        |  9 ++--
 drivers/staging/rtl8712/rtl8712_recv.c        | 10 ++---
 drivers/staging/rtl8712/rtl871x_xmit.c        |  4 +-
 drivers/staging/rtl8712/rtl871x_xmit.h        |  2 +-
 drivers/staging/rtl8712/usb_ops_linux.c       |  4 +-
 .../staging/rtl8723bs/hal/rtl8723bs_recv.c    | 13 +++---
 drivers/staging/wlan-ng/hfa384x_usb.c         | 18 ++++----
 drivers/staging/wlan-ng/p80211netdev.c        |  7 ++-
 drivers/tty/ipwireless/hardware.c             |  6 +--
 drivers/tty/serial/atmel_serial.c             | 18 ++++----
 drivers/tty/serial/ifx6x60.c                  |  7 ++-
 drivers/tty/serial/timbuart.c                 |  6 +--
 drivers/usb/atm/usbatm.c                      | 12 +++---
 drivers/usb/c67x00/c67x00-sched.c             |  7 ++-
 drivers/usb/core/hcd.c                        |  6 +--
 drivers/usb/gadget/function/f_midi.c          |  6 +--
 drivers/usb/gadget/udc/fsl_qe_udc.c           |  7 ++-
 drivers/usb/host/xhci-dbgtty.c                |  6 +--
 drivers/usb/serial/mos7720.c                  |  7 ++-
 drivers/vme/bridges/vme_fake.c                |  9 ++--
 net/dccp/timer.c                              |  9 ++--
 net/ipv4/tcp_output.c                         |  8 ++--
 net/mac80211/ieee80211_i.h                    |  4 +-
 net/mac80211/main.c                           | 14 +++---
 net/mac80211/tx.c                             |  4 +-
 net/mac80211/util.c                           |  4 +-
 net/mac802154/main.c                          |  8 ++--
 net/rds/ib_cm.c                               | 14 +++---
 net/sched/sch_atm.c                           |  8 ++--
 net/smc/smc_cdc.c                             |  6 +--
 net/smc/smc_wr.c                              | 14 +++---
 net/xfrm/xfrm_input.c                         |  7 ++-
 sound/core/timer.c                            |  7 ++-
 sound/firewire/amdtp-stream.c                 |  8 ++--
 sound/pci/asihpi/asihpi.c                     |  9 ++--
 sound/pci/riptide/riptide.c                   |  6 +--
 sound/pci/rme9652/hdsp.c                      |  6 +--
 sound/pci/rme9652/hdspm.c                     |  7 ++-
 sound/soc/fsl/fsl_esai.c                      |  7 ++-
 sound/soc/sh/siu_pcm.c                        | 10 ++---
 sound/soc/txx9/txx9aclc.c                     |  7 ++-
 sound/usb/midi.c                              |  7 ++-
 sound/usb/misc/ua101.c                        |  7 ++-
 328 files changed, 1293 insertions(+), 1487 deletions(-)

diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
index 769ffbd9e9a6..36bd2b02746b 100644
--- a/arch/um/drivers/vector_kern.c
+++ b/arch/um/drivers/vector_kern.c
@@ -1166,9 +1166,9 @@ static int vector_net_close(struct net_device *dev)
 
 /* TX tasklet */
 
-static void vector_tx_poll(unsigned long data)
+static void vector_tx_poll(struct tasklet_struct *t)
 {
-	struct vector_private *vp = (struct vector_private *)data;
+	struct vector_private *vp = from_tasklet(vp, t, tx_poll);
 
 	vp->estats.tx_kicks++;
 	vector_send(vp->tx_queue);
@@ -1532,7 +1532,7 @@ static void vector_eth_configure(
 		});
 
 	dev->features = dev->hw_features = (NETIF_F_SG | NETIF_F_FRAGLIST);
-	tasklet_init(&vp->tx_poll, vector_tx_poll, (unsigned long)vp);
+	tasklet_setup(&vp->tx_poll, vector_tx_poll);
 	INIT_WORK(&vp->reset_tx, vector_reset_tx);
 
 	timer_setup(&vp->tl, vector_timer_expire, 0);
diff --git a/drivers/atm/eni.c b/drivers/atm/eni.c
index b23d1e4bad33..8a6fbc469ce1 100644
--- a/drivers/atm/eni.c
+++ b/drivers/atm/eni.c
@@ -1525,10 +1525,10 @@ static irqreturn_t eni_int(int irq,void *dev_id)
 }
 
 
-static void eni_tasklet(unsigned long data)
+static void eni_tasklet(struct tasklet_struct *t)
 {
-	struct atm_dev *dev = (struct atm_dev *) data;
-	struct eni_dev *eni_dev = ENI_DEV(dev);
+	struct eni_dev *eni_dev = from_tasklet(eni_dev, t, task);
+	struct atm_dev *dev = container_of((void *)eni_dev, typeof(*dev), dev_data);
 	unsigned long flags;
 	u32 events;
 
@@ -1842,7 +1842,7 @@ static int eni_start(struct atm_dev *dev)
 	     eni_dev->vci,eni_dev->rx_dma,eni_dev->tx_dma,
 	     eni_dev->service,buf);
 	spin_lock_init(&eni_dev->lock);
-	tasklet_init(&eni_dev->task,eni_tasklet,(unsigned long) dev);
+	tasklet_setup(&eni_dev->task, eni_tasklet);
 	eni_dev->events = 0;
 	/* initialize memory management */
 	buffer_mem = eni_dev->mem - (buf - eni_dev->ram);
diff --git a/drivers/atm/fore200e.c b/drivers/atm/fore200e.c
index f1a500205313..35976eb61498 100644
--- a/drivers/atm/fore200e.c
+++ b/drivers/atm/fore200e.c
@@ -1180,9 +1180,9 @@ fore200e_interrupt(int irq, void* dev)
 
 #ifdef FORE200E_USE_TASKLET
 static void
-fore200e_tx_tasklet(unsigned long data)
+fore200e_tx_tasklet(struct tasklet_struct *t)
 {
-    struct fore200e* fore200e = (struct fore200e*) data;
+    struct fore200e* fore200e = from_tasklet(fore200e, t, tx_tasklet);
     unsigned long flags;
 
     DPRINTK(3, "tx tasklet scheduled for device %d\n", fore200e->atm_dev->number);
@@ -1194,15 +1194,15 @@ fore200e_tx_tasklet(unsigned long data)
 
 
 static void
-fore200e_rx_tasklet(unsigned long data)
+fore200e_rx_tasklet(struct tasklet_struct *t)
 {
-    struct fore200e* fore200e = (struct fore200e*) data;
+    struct fore200e* fore200e = from_tasklet(fore200e, t, rx_tasklet);
     unsigned long    flags;
 
     DPRINTK(3, "rx tasklet scheduled for device %d\n", fore200e->atm_dev->number);
 
     spin_lock_irqsave(&fore200e->q_lock, flags);
-    fore200e_rx_irq((struct fore200e*) data);
+    fore200e_rx_irq(fore200e);
     spin_unlock_irqrestore(&fore200e->q_lock, flags);
 }
 #endif
@@ -1957,8 +1957,8 @@ static int fore200e_irq_request(struct fore200e *fore200e)
 	   fore200e_irq_itoa(fore200e->irq), fore200e->name);
 
 #ifdef FORE200E_USE_TASKLET
-    tasklet_init(&fore200e->tx_tasklet, fore200e_tx_tasklet, (unsigned long)fore200e);
-    tasklet_init(&fore200e->rx_tasklet, fore200e_rx_tasklet, (unsigned long)fore200e);
+    tasklet_setup(&fore200e->tx_tasklet, fore200e_tx_tasklet);
+    tasklet_setup(&fore200e->rx_tasklet, fore200e_rx_tasklet);
 #endif
 
     fore200e->state = FORE200E_STATE_IRQ;
diff --git a/drivers/atm/he.c b/drivers/atm/he.c
index 70b00ae4ec38..b12823a036cc 100644
--- a/drivers/atm/he.c
+++ b/drivers/atm/he.c
@@ -100,7 +100,7 @@ static void he_close(struct atm_vcc *vcc);
 static int he_send(struct atm_vcc *vcc, struct sk_buff *skb);
 static int he_ioctl(struct atm_dev *dev, unsigned int cmd, void __user *arg);
 static irqreturn_t he_irq_handler(int irq, void *dev_id);
-static void he_tasklet(unsigned long data);
+static void he_tasklet(struct tasklet_struct *t);
 static int he_proc_read(struct atm_dev *dev,loff_t *pos,char *page);
 static int he_start(struct atm_dev *dev);
 static void he_stop(struct he_dev *dev);
@@ -383,7 +383,7 @@ static int he_init_one(struct pci_dev *pci_dev,
 	he_dev->atm_dev->dev_data = he_dev;
 	atm_dev->dev_data = he_dev;
 	he_dev->number = atm_dev->number;
-	tasklet_init(&he_dev->tasklet, he_tasklet, (unsigned long) he_dev);
+	tasklet_setup(&he_dev->tasklet, he_tasklet);
 	spin_lock_init(&he_dev->global_lock);
 
 	if (he_start(atm_dev)) {
@@ -1925,10 +1925,10 @@ he_service_rbpl(struct he_dev *he_dev, int group)
 }
 
 static void
-he_tasklet(unsigned long data)
+he_tasklet(struct tasklet_struct *t)
 {
 	unsigned long flags;
-	struct he_dev *he_dev = (struct he_dev *) data;
+	struct he_dev *he_dev = from_tasklet(he_dev, t, tasklet);
 	int group, type;
 	int updated = 0;
 
diff --git a/drivers/atm/solos-pci.c b/drivers/atm/solos-pci.c
index c32f7dd9879a..29ae47427445 100644
--- a/drivers/atm/solos-pci.c
+++ b/drivers/atm/solos-pci.c
@@ -167,7 +167,7 @@ static struct atm_vcc* find_vcc(struct atm_dev *dev, short vpi, int vci);
 static int atm_init(struct solos_card *, struct device *);
 static void atm_remove(struct solos_card *);
 static int send_command(struct solos_card *card, int dev, const char *buf, size_t size);
-static void solos_bh(unsigned long);
+static void solos_bh(struct tasklet_struct *t);
 static int print_buffer(struct sk_buff *buf);
 
 static inline void solos_pop(struct atm_vcc *vcc, struct sk_buff *skb)
@@ -754,9 +754,9 @@ static irqreturn_t solos_irq(int irq, void *dev_id)
 	return IRQ_RETVAL(handled);
 }
 
-static void solos_bh(unsigned long card_arg)
+static void solos_bh(struct tasklet_struct *t)
 {
-	struct solos_card *card = (void *)card_arg;
+	struct solos_card *card = from_tasklet(card, t, tlet);
 	uint32_t card_flags;
 	uint32_t rx_done = 0;
 	int port;
@@ -1296,7 +1296,7 @@ static int fpga_probe(struct pci_dev *dev, const struct pci_device_id *id)
 
 	pci_set_drvdata(dev, card);
 
-	tasklet_init(&card->tlet, solos_bh, (unsigned long)card);
+	tasklet_setup(&card->tlet, solos_bh);
 	spin_lock_init(&card->tx_lock);
 	spin_lock_init(&card->tx_queue_lock);
 	spin_lock_init(&card->cli_queue_lock);
diff --git a/drivers/block/umem.c b/drivers/block/umem.c
index 1f3f9e0f02a8..2373bd61cd6e 100644
--- a/drivers/block/umem.c
+++ b/drivers/block/umem.c
@@ -405,7 +405,7 @@ static int add_bio(struct cardinfo *card)
 	return 1;
 }
 
-static void process_page(unsigned long data)
+static void process_page(struct tasklet_struct *t)
 {
 	/* check if any of the requests in the page are DMA_COMPLETE,
 	 * and deal with them appropriately.
@@ -415,7 +415,7 @@ static void process_page(unsigned long data)
 	 */
 	struct mm_page *page;
 	struct bio *return_bio = NULL;
-	struct cardinfo *card = (struct cardinfo *)data;
+	struct cardinfo *card = from_tasklet(card, t, tasklet);
 	unsigned int dma_status = card->dma_status;
 
 	spin_lock(&card->lock);
@@ -892,7 +892,7 @@ static int mm_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	blk_queue_make_request(card->queue, mm_make_request);
 	card->queue->queuedata = card;
 
-	tasklet_init(&card->tasklet, process_page, (unsigned long)card);
+	tasklet_setup(&card->tasklet, process_page);
 
 	card->check_batteries = 0;
 
diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index 5d8e0ab3f054..bdd50a87d10f 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -762,9 +762,9 @@ static void ace_fsm_dostate(struct ace_device *ace)
 	}
 }
 
-static void ace_fsm_tasklet(unsigned long data)
+static void ace_fsm_tasklet(struct tasklet_struct *t)
 {
-	struct ace_device *ace = (void *)data;
+	struct ace_device *ace = from_tasklet(ace, t, fsm_tasklet);
 	unsigned long flags;
 
 	spin_lock_irqsave(&ace->lock, flags);
@@ -1001,7 +1001,7 @@ static int ace_setup(struct ace_device *ace)
 	/*
 	 * Initialize the state machine tasklet and stall timer
 	 */
-	tasklet_init(&ace->fsm_tasklet, ace_fsm_tasklet, (unsigned long)ace);
+	tasklet_setup(&ace->fsm_tasklet, ace_fsm_tasklet);
 	timer_setup(&ace->stall_timer, ace_stall_timer, 0);
 
 	/*
diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 2aab80e19ae0..c51a195ab98b 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -38,7 +38,7 @@
 
 static struct ipmi_recv_msg *ipmi_alloc_recv_msg(void);
 static int ipmi_init_msghandler(void);
-static void smi_recv_tasklet(unsigned long);
+static void smi_recv_tasklet(struct tasklet_struct *t);
 static void handle_new_recv_msgs(struct ipmi_smi *intf);
 static void need_waiter(struct ipmi_smi *intf);
 static int handle_one_recv_msg(struct ipmi_smi *intf,
@@ -3433,9 +3433,7 @@ int ipmi_register_smi(const struct ipmi_smi_handlers *handlers,
 	intf->curr_seq = 0;
 	spin_lock_init(&intf->waiting_rcv_msgs_lock);
 	INIT_LIST_HEAD(&intf->waiting_rcv_msgs);
-	tasklet_init(&intf->recv_tasklet,
-		     smi_recv_tasklet,
-		     (unsigned long) intf);
+	tasklet_setup(&intf->recv_tasklet, smi_recv_tasklet);
 	atomic_set(&intf->watchdog_pretimeouts_to_deliver, 0);
 	spin_lock_init(&intf->xmit_msgs_lock);
 	INIT_LIST_HEAD(&intf->xmit_msgs);
@@ -4469,10 +4467,10 @@ static void handle_new_recv_msgs(struct ipmi_smi *intf)
 	}
 }
 
-static void smi_recv_tasklet(unsigned long val)
+static void smi_recv_tasklet(struct tasklet_struct *t)
 {
 	unsigned long flags = 0; /* keep us warning-free. */
-	struct ipmi_smi *intf = (struct ipmi_smi *) val;
+	struct ipmi_smi *intf = from_tasklet(intf, t, recv_tasklet);
 	int run_to_completion = intf->run_to_completion;
 	struct ipmi_smi_msg *newmsg = NULL;
 
@@ -4544,7 +4542,7 @@ void ipmi_smi_msg_received(struct ipmi_smi *intf,
 		spin_unlock_irqrestore(&intf->xmit_msgs_lock, flags);
 
 	if (run_to_completion)
-		smi_recv_tasklet((unsigned long) intf);
+		smi_recv_tasklet(&intf->recv_tasklet);
 	else
 		tasklet_schedule(&intf->recv_tasklet);
 }
diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index de5e9352e920..e2858cbde9d1 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1075,9 +1075,9 @@ static void crypto4xx_unregister_alg(struct crypto4xx_device *sec_dev)
 	}
 }
 
-static void crypto4xx_bh_tasklet_cb(unsigned long data)
+static void crypto4xx_bh_tasklet_cb(struct tasklet_struct *t)
 {
-	struct device *dev = (struct device *)data;
+	struct device *dev = from_tasklet(dev, t, tasklet);
 	struct crypto4xx_core_device *core_dev = dev_get_drvdata(dev);
 	struct pd_uinfo *pd_uinfo;
 	struct ce_pd *pd;
@@ -1456,8 +1456,7 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 		goto err_build_sdr;
 
 	/* Init tasklet for bottom half processing */
-	tasklet_init(&core_dev->tasklet, crypto4xx_bh_tasklet_cb,
-		     (unsigned long) dev);
+	tasklet_setup(&core_dev->tasklet, crypto4xx_bh_tasklet_cb);
 
 	core_dev->dev->ce_base = of_iomap(ofdev->dev.of_node, 0);
 	if (!core_dev->dev->ce_base) {
diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 026f193556f9..0ee5b8c1552a 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -2423,16 +2423,16 @@ static void atmel_aes_dma_cleanup(struct atmel_aes_dev *dd)
 	dma_release_channel(dd->src.chan);
 }
 
-static void atmel_aes_queue_task(unsigned long data)
+static void atmel_aes_queue_task(struct tasklet_struct *t)
 {
-	struct atmel_aes_dev *dd = (struct atmel_aes_dev *)data;
+	struct atmel_aes_dev *dd = from_tasklet(dd, t, queue_task);
 
 	atmel_aes_handle_queue(dd, NULL);
 }
 
-static void atmel_aes_done_task(unsigned long data)
+static void atmel_aes_done_task(struct tasklet_struct *t)
 {
-	struct atmel_aes_dev *dd = (struct atmel_aes_dev *)data;
+	struct atmel_aes_dev *dd = from_tasklet(dd, t, done_task);
 
 	dd->is_async = true;
 	(void)dd->resume(dd);
@@ -2654,10 +2654,8 @@ static int atmel_aes_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&aes_dd->list);
 	spin_lock_init(&aes_dd->lock);
 
-	tasklet_init(&aes_dd->done_task, atmel_aes_done_task,
-					(unsigned long)aes_dd);
-	tasklet_init(&aes_dd->queue_task, atmel_aes_queue_task,
-					(unsigned long)aes_dd);
+	tasklet_setup(&aes_dd->done_task, atmel_aes_done_task);
+	tasklet_setup(&aes_dd->queue_task, atmel_aes_queue_task);
 
 	crypto_init_queue(&aes_dd->queue, ATMEL_AES_QUEUE_LENGTH);
 
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 84cb8748a795..a24e91073f58 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -1375,9 +1375,9 @@ static struct ahash_alg sha_384_512_algs[] = {
 },
 };
 
-static void atmel_sha_queue_task(unsigned long data)
+static void atmel_sha_queue_task(struct tasklet_struct *t)
 {
-	struct atmel_sha_dev *dd = (struct atmel_sha_dev *)data;
+	struct atmel_sha_dev *dd = from_tasklet(dd, t, queue_task);
 
 	atmel_sha_handle_queue(dd, NULL);
 }
@@ -1418,9 +1418,9 @@ static int atmel_sha_done(struct atmel_sha_dev *dd)
 	return err;
 }
 
-static void atmel_sha_done_task(unsigned long data)
+static void atmel_sha_done_task(struct tasklet_struct *t)
 {
-	struct atmel_sha_dev *dd = (struct atmel_sha_dev *)data;
+	struct atmel_sha_dev *dd = from_tasklet(dd, t, done_task);
 
 	dd->is_async = true;
 	(void)dd->resume(dd);
@@ -2760,10 +2760,8 @@ static int atmel_sha_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&sha_dd->list);
 	spin_lock_init(&sha_dd->lock);
 
-	tasklet_init(&sha_dd->done_task, atmel_sha_done_task,
-					(unsigned long)sha_dd);
-	tasklet_init(&sha_dd->queue_task, atmel_sha_queue_task,
-					(unsigned long)sha_dd);
+	tasklet_setup(&sha_dd->done_task, atmel_sha_done_task);
+	tasklet_setup(&sha_dd->queue_task, atmel_sha_queue_task);
 
 	crypto_init_queue(&sha_dd->queue, ATMEL_SHA_QUEUE_LENGTH);
 
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 1a6c86ae6148..7c0f845f76ce 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -1089,16 +1089,16 @@ static struct crypto_alg tdes_algs[] = {
 },
 };
 
-static void atmel_tdes_queue_task(unsigned long data)
+static void atmel_tdes_queue_task(struct tasklet_struct *t)
 {
-	struct atmel_tdes_dev *dd = (struct atmel_tdes_dev *)data;
+	struct atmel_tdes_dev *dd = from_tasklet(dd, t, queue_task);
 
 	atmel_tdes_handle_queue(dd, NULL);
 }
 
-static void atmel_tdes_done_task(unsigned long data)
+static void atmel_tdes_done_task(struct tasklet_struct *t)
 {
-	struct atmel_tdes_dev *dd = (struct atmel_tdes_dev *) data;
+	struct atmel_tdes_dev *dd = from_tasklet(dd, t, done_task);
 	int err;
 
 	if (!(dd->flags & TDES_FLAGS_DMA))
@@ -1248,10 +1248,8 @@ static int atmel_tdes_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&tdes_dd->list);
 	spin_lock_init(&tdes_dd->lock);
 
-	tasklet_init(&tdes_dd->done_task, atmel_tdes_done_task,
-					(unsigned long)tdes_dd);
-	tasklet_init(&tdes_dd->queue_task, atmel_tdes_queue_task,
-					(unsigned long)tdes_dd);
+	tasklet_setup(&tdes_dd->done_task, atmel_tdes_done_task);
+	tasklet_setup(&tdes_dd->queue_task, atmel_tdes_queue_task);
 
 	crypto_init_queue(&tdes_dd->queue, ATMEL_TDES_QUEUE_LENGTH);
 
diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
index 4b20606983a4..f4f19eed3248 100644
--- a/drivers/crypto/axis/artpec6_crypto.c
+++ b/drivers/crypto/axis/artpec6_crypto.c
@@ -2080,9 +2080,9 @@ static void artpec6_crypto_timeout(struct timer_list *t)
 	tasklet_schedule(&ac->task);
 }
 
-static void artpec6_crypto_task(unsigned long data)
+static void artpec6_crypto_task(struct tasklet_struct *t)
 {
-	struct artpec6_crypto *ac = (struct artpec6_crypto *)data;
+	struct artpec6_crypto *ac = from_tasklet(ac, t, task);
 	struct artpec6_crypto_req_common *req;
 	struct artpec6_crypto_req_common *n;
 	struct list_head complete_done;
@@ -2901,8 +2901,7 @@ static int artpec6_crypto_probe(struct platform_device *pdev)
 	artpec6_crypto_init_debugfs();
 #endif
 
-	tasklet_init(&ac->task, artpec6_crypto_task,
-		     (unsigned long)ac);
+	tasklet_setup(&ac->task, artpec6_crypto_task);
 
 	ac->pad_buffer = devm_kzalloc(&pdev->dev, 2 * ARTPEC_CACHE_LINE_MAX,
 				      GFP_KERNEL);
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index fc97cde27059..2f6aa5652bb8 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -189,11 +189,11 @@ static irqreturn_t caam_jr_interrupt(int irq, void *st_dev)
 }
 
 /* Deferred service handler, run as interrupt-fired tasklet */
-static void caam_jr_dequeue(unsigned long devarg)
+static void caam_jr_dequeue(struct tasklet_struct *t)
 {
 	int hw_idx, sw_idx, i, head, tail;
-	struct device *dev = (struct device *)devarg;
-	struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
+	struct caam_drv_private_jr *jrp = from_tasklet(jrp, t, irqtask);
+	struct device *dev = jrp->dev;
 	void (*usercall)(struct device *dev, u32 *desc, u32 status, void *arg);
 	u32 *userdesc, userstatus;
 	void *userarg;
@@ -472,7 +472,7 @@ static int caam_jr_init(struct device *dev)
 		      (JOBR_INTC_COUNT_THLD << JRCFG_ICDCT_SHIFT) |
 		      (JOBR_INTC_TIME_THLD << JRCFG_ICTT_SHIFT));
 
-	tasklet_init(&jrp->irqtask, caam_jr_dequeue, (unsigned long)dev);
+	tasklet_setup(&jrp->irqtask, caam_jr_dequeue);
 
 	/* Connect job ring interrupt handler. */
 	error = devm_request_irq(dev, jrp->irq, caam_jr_interrupt, IRQF_SHARED,
diff --git a/drivers/crypto/cavium/cpt/cptvf_main.c b/drivers/crypto/cavium/cpt/cptvf_main.c
index 0f72e9abdefe..514eaf1140fa 100644
--- a/drivers/crypto/cavium/cpt/cptvf_main.c
+++ b/drivers/crypto/cavium/cpt/cptvf_main.c
@@ -21,10 +21,10 @@ struct cptvf_wqe_info {
 	struct cptvf_wqe vq_wqe[CPT_NUM_QS_PER_VF];
 };
 
-static void vq_work_handler(unsigned long data)
+static void vq_work_handler(struct tasklet_struct *t)
 {
-	struct cptvf_wqe_info *cwqe_info = (struct cptvf_wqe_info *)data;
-	struct cptvf_wqe *cwqe = &cwqe_info->vq_wqe[0];
+	struct cptvf_wqe *cwqe = from_tasklet(cwqe, t, twork);
+	struct cptvf_wqe_info *cwqe_info = container_of(cwqe, typeof(*cwqe_info), vq_wqe[0]);
 
 	vq_post_process(cwqe->cptvf, cwqe->qno);
 }
@@ -45,8 +45,7 @@ static int init_worker_threads(struct cpt_vf *cptvf)
 	}
 
 	for (i = 0; i < cptvf->nr_queues; i++) {
-		tasklet_init(&cwqe_info->vq_wqe[i].twork, vq_work_handler,
-			     (u64)cwqe_info);
+		tasklet_setup(&cwqe_info->vq_wqe[i].twork, vq_work_handler);
 		cwqe_info->vq_wqe[i].qno = i;
 		cwqe_info->vq_wqe[i].cptvf = cptvf;
 	}
diff --git a/drivers/crypto/cavium/nitrox/nitrox_common.h b/drivers/crypto/cavium/nitrox/nitrox_common.h
index e4be69d7e6e5..f73ae8735272 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_common.h
+++ b/drivers/crypto/cavium/nitrox/nitrox_common.h
@@ -19,7 +19,7 @@ void nitrox_put_device(struct nitrox_device *ndev);
 int nitrox_common_sw_init(struct nitrox_device *ndev);
 void nitrox_common_sw_cleanup(struct nitrox_device *ndev);
 
-void pkt_slc_resp_tasklet(unsigned long data);
+void pkt_slc_resp_tasklet(struct tasklet_struct *t);
 int nitrox_process_se_request(struct nitrox_device *ndev,
 			      struct se_crypto_request *req,
 			      completion_t cb,
diff --git a/drivers/crypto/cavium/nitrox/nitrox_isr.c b/drivers/crypto/cavium/nitrox/nitrox_isr.c
index 3dec570a190a..cc6b7c78e070 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_isr.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_isr.c
@@ -200,9 +200,9 @@ static void clear_bmi_err_intr(struct nitrox_device *ndev)
 	dev_err_ratelimited(DEV(ndev), "BMI_INT  0x%016llx\n", value);
 }
 
-static void nps_core_int_tasklet(unsigned long data)
+static void nps_core_int_tasklet(struct tasklet_struct *t)
 {
-	struct nitrox_q_vector *qvec = (void *)(uintptr_t)(data);
+	struct nitrox_q_vector *qvec = from_tasklet(qvec, t, resp_tasklet);
 	struct nitrox_device *ndev = qvec->ndev;
 
 	/* if pf mode do queue recovery */
@@ -342,8 +342,7 @@ int nitrox_register_interrupts(struct nitrox_device *ndev)
 		cpu = qvec->ring % num_online_cpus();
 		irq_set_affinity_hint(vec, get_cpu_mask(cpu));
 
-		tasklet_init(&qvec->resp_tasklet, pkt_slc_resp_tasklet,
-			     (unsigned long)qvec);
+		tasklet_setup(&qvec->resp_tasklet, pkt_slc_resp_tasklet);
 		qvec->valid = true;
 	}
 
@@ -363,8 +362,7 @@ int nitrox_register_interrupts(struct nitrox_device *ndev)
 	cpu = num_online_cpus();
 	irq_set_affinity_hint(vec, get_cpu_mask(cpu));
 
-	tasklet_init(&qvec->resp_tasklet, nps_core_int_tasklet,
-		     (unsigned long)qvec);
+	tasklet_setup(&qvec->resp_tasklet, nps_core_int_tasklet);
 	qvec->valid = true;
 
 	return 0;
@@ -441,8 +439,7 @@ int nitrox_sriov_register_interupts(struct nitrox_device *ndev)
 	cpu = num_online_cpus();
 	irq_set_affinity_hint(vec, get_cpu_mask(cpu));
 
-	tasklet_init(&qvec->resp_tasklet, nps_core_int_tasklet,
-		     (unsigned long)qvec);
+	tasklet_setup(&qvec->resp_tasklet, nps_core_int_tasklet);
 	qvec->valid = true;
 
 	return 0;
diff --git a/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c b/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
index 5826c2c98a50..1c113be87ada 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
@@ -579,9 +579,9 @@ static void process_response_list(struct nitrox_cmdq *cmdq)
 /**
  * pkt_slc_resp_tasklet - post processing of SE responses
  */
-void pkt_slc_resp_tasklet(unsigned long data)
+void pkt_slc_resp_tasklet(struct tasklet_struct *t)
 {
-	struct nitrox_q_vector *qvec = (void *)(uintptr_t)(data);
+	struct nitrox_q_vector *qvec = from_tasklet(qvec, t, resp_tasklet);
 	struct nitrox_cmdq *cmdq = qvec->cmdq;
 	union nps_pkt_slc_cnts slc_cnts;
 
diff --git a/drivers/crypto/ccp/ccp-dev-v3.c b/drivers/crypto/ccp/ccp-dev-v3.c
index 0186b3df4c87..a4b912e7aec2 100644
--- a/drivers/crypto/ccp/ccp-dev-v3.c
+++ b/drivers/crypto/ccp/ccp-dev-v3.c
@@ -321,9 +321,9 @@ static void ccp_enable_queue_interrupts(struct ccp_device *ccp)
 	iowrite32(ccp->qim, ccp->io_regs + IRQ_MASK_REG);
 }
 
-static void ccp_irq_bh(unsigned long data)
+static void ccp_irq_bh(struct tasklet_struct *t)
 {
-	struct ccp_device *ccp = (struct ccp_device *)data;
+	struct ccp_device *ccp = from_tasklet(ccp, t, irq_tasklet);
 	struct ccp_cmd_queue *cmd_q;
 	u32 q_int, status;
 	unsigned int i;
@@ -361,7 +361,7 @@ static irqreturn_t ccp_irq_handler(int irq, void *data)
 	if (ccp->use_tasklet)
 		tasklet_schedule(&ccp->irq_tasklet);
 	else
-		ccp_irq_bh((unsigned long)ccp);
+		ccp_irq_bh(&ccp->irq_tasklet);
 
 	return IRQ_HANDLED;
 }
@@ -457,8 +457,7 @@ static int ccp_init(struct ccp_device *ccp)
 
 	/* Initialize the ISR tasklet? */
 	if (ccp->use_tasklet)
-		tasklet_init(&ccp->irq_tasklet, ccp_irq_bh,
-			     (unsigned long)ccp);
+		tasklet_setup(&ccp->irq_tasklet, ccp_irq_bh);
 
 	dev_dbg(dev, "Starting threads...\n");
 	/* Create a kthread for each queue */
diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
index 57eb53b8ac21..604bc4947829 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -733,9 +733,9 @@ static void ccp5_enable_queue_interrupts(struct ccp_device *ccp)
 		iowrite32(SUPPORTED_INTERRUPTS, ccp->cmd_q[i].reg_int_enable);
 }
 
-static void ccp5_irq_bh(unsigned long data)
+static void ccp5_irq_bh(struct tasklet_struct *t)
 {
-	struct ccp_device *ccp = (struct ccp_device *)data;
+	struct ccp_device *ccp = from_tasklet(ccp, t, irq_tasklet);
 	u32 status;
 	unsigned int i;
 
@@ -772,7 +772,7 @@ static irqreturn_t ccp5_irq_handler(int irq, void *data)
 	if (ccp->use_tasklet)
 		tasklet_schedule(&ccp->irq_tasklet);
 	else
-		ccp5_irq_bh((unsigned long)ccp);
+		ccp5_irq_bh(&ccp->irq_tasklet);
 	return IRQ_HANDLED;
 }
 
@@ -882,8 +882,7 @@ static int ccp5_init(struct ccp_device *ccp)
 	}
 	/* Initialize the ISR tasklet */
 	if (ccp->use_tasklet)
-		tasklet_init(&ccp->irq_tasklet, ccp5_irq_bh,
-			     (unsigned long)ccp);
+		tasklet_setup(&ccp->irq_tasklet, ccp5_irq_bh);
 
 	dev_dbg(dev, "Loading LSB map...\n");
 	/* Copy the private LSB mask to the public registers */
diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index d0d180176f45..12adf272d3a6 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -417,9 +417,9 @@ static struct ccp_cmd *ccp_dequeue_cmd(struct ccp_cmd_queue *cmd_q)
 	return cmd;
 }
 
-static void ccp_do_cmd_complete(unsigned long data)
+static void ccp_do_cmd_complete(struct tasklet_struct *t)
 {
-	struct ccp_tasklet_data *tdata = (struct ccp_tasklet_data *)data;
+	struct ccp_tasklet_data *tdata = from_tasklet(tdata, t, tasklet);
 	struct ccp_cmd *cmd = tdata->cmd;
 
 	cmd->callback(cmd->data, cmd->ret);
@@ -438,7 +438,7 @@ int ccp_cmd_queue_thread(void *data)
 	struct ccp_cmd *cmd;
 	struct ccp_tasklet_data tdata;
 
-	tasklet_init(&tdata.tasklet, ccp_do_cmd_complete, (unsigned long)&tdata);
+	tasklet_setup(&tdata.tasklet, ccp_do_cmd_complete);
 
 	set_current_state(TASK_INTERRUPTIBLE);
 	while (!kthread_should_stop()) {
diff --git a/drivers/crypto/ccp/ccp-dmaengine.c b/drivers/crypto/ccp/ccp-dmaengine.c
index a54f9367a580..d6c7db573f94 100644
--- a/drivers/crypto/ccp/ccp-dmaengine.c
+++ b/drivers/crypto/ccp/ccp-dmaengine.c
@@ -121,9 +121,9 @@ static void ccp_cleanup_desc_resources(struct ccp_device *ccp,
 	}
 }
 
-static void ccp_do_cleanup(unsigned long data)
+static void ccp_do_cleanup(struct tasklet_struct *t)
 {
-	struct ccp_dma_chan *chan = (struct ccp_dma_chan *)data;
+	struct ccp_dma_chan *chan = from_tasklet(chan, t, cleanup_tasklet);
 	unsigned long flags;
 
 	dev_dbg(chan->ccp->dev, "%s - chan=%s\n", __func__,
@@ -711,8 +711,7 @@ int ccp_dmaengine_register(struct ccp_device *ccp)
 		INIT_LIST_HEAD(&chan->active);
 		INIT_LIST_HEAD(&chan->complete);
 
-		tasklet_init(&chan->cleanup_tasklet, ccp_do_cleanup,
-			     (unsigned long)chan);
+		tasklet_setup(&chan->cleanup_tasklet, ccp_do_cleanup);
 
 		dma_chan->device = dma_dev;
 		dma_cookie_init(dma_chan);
diff --git a/drivers/crypto/ccree/cc_fips.c b/drivers/crypto/ccree/cc_fips.c
index 4c8bce33abcf..87332357fdf3 100644
--- a/drivers/crypto/ccree/cc_fips.c
+++ b/drivers/crypto/ccree/cc_fips.c
@@ -8,7 +8,7 @@
 #include "cc_driver.h"
 #include "cc_fips.h"
 
-static void fips_dsr(unsigned long devarg);
+static void fips_dsr(struct tasklet_struct *t);
 
 struct cc_fips_handle {
 	struct tasklet_struct tasklet;
@@ -109,9 +109,9 @@ void cc_tee_handle_fips_error(struct cc_drvdata *p_drvdata)
 }
 
 /* Deferred service handler, run as interrupt-fired tasklet */
-static void fips_dsr(unsigned long devarg)
+static void fips_dsr(struct tasklet_struct *t)
 {
-	struct cc_drvdata *drvdata = (struct cc_drvdata *)devarg;
+	struct cc_drvdata *drvdata = from_tasklet(drvdata, t, tasklet);
 	u32 irq, val;
 
 	irq = (drvdata->irq & (CC_GPR0_IRQ_MASK));
@@ -143,7 +143,7 @@ int cc_fips_init(struct cc_drvdata *p_drvdata)
 	p_drvdata->fips_handle = fips_h;
 
 	dev_dbg(dev, "Initializing fips tasklet\n");
-	tasklet_init(&fips_h->tasklet, fips_dsr, (unsigned long)p_drvdata);
+	tasklet_setup(&fips_h->tasklet, fips_dsr);
 	fips_h->drvdata = p_drvdata;
 	fips_h->nb.notifier_call = cc_ree_fips_failure;
 	atomic_notifier_chain_register(&fips_fail_notif_chain, &fips_h->nb);
diff --git a/drivers/crypto/ccree/cc_request_mgr.c b/drivers/crypto/ccree/cc_request_mgr.c
index a947d5a2cf35..673994f11af7 100644
--- a/drivers/crypto/ccree/cc_request_mgr.c
+++ b/drivers/crypto/ccree/cc_request_mgr.c
@@ -71,7 +71,7 @@ static const u32 cc_cpp_int_masks[CC_CPP_NUM_ALGS][CC_CPP_NUM_SLOTS] = {
 	  BIT(CC_HOST_IRR_REE_OP_ABORTED_SM_7_INT_BIT_SHIFT) }
 };
 
-static void comp_handler(unsigned long devarg);
+static void comp_handler(struct tasklet_struct *t);
 #ifdef COMP_IN_WQ
 static void comp_work_handler(struct work_struct *work);
 #endif
@@ -141,8 +141,7 @@ int cc_req_mgr_init(struct cc_drvdata *drvdata)
 	INIT_DELAYED_WORK(&req_mgr_h->compwork, comp_work_handler);
 #else
 	dev_dbg(dev, "Initializing completion tasklet\n");
-	tasklet_init(&req_mgr_h->comptask, comp_handler,
-		     (unsigned long)drvdata);
+	tasklet_setup(&req_mgr_h->comptask, comp_handler);
 #endif
 	req_mgr_h->hw_queue_size = cc_ioread(drvdata,
 					     CC_REG(DSCRPTR_QUEUE_SRAM_SIZE));
@@ -627,11 +626,10 @@ static inline u32 cc_axi_comp_count(struct cc_drvdata *drvdata)
 }
 
 /* Deferred service handler, run as interrupt-fired tasklet */
-static void comp_handler(unsigned long devarg)
+static void comp_handler(struct tasklet_struct *t)
 {
-	struct cc_drvdata *drvdata = (struct cc_drvdata *)devarg;
-	struct cc_req_mgr_handle *request_mgr_handle =
-						drvdata->request_mgr_handle;
+	struct cc_req_mgr_handle *request_mgr_handle = from_tasklet(request_mgr_handle, t, comptask);
+	struct cc_drvdata *drvdata = container_of((void *)request_mgr_handle, typeof(*drvdata), request_mgr_handle);
 	struct device *dev = drvdata_to_dev(drvdata);
 	u32 irq;
 
diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index a18e62df68d9..5d5d6ea58ca2 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -2442,9 +2442,9 @@ static int hifn_register_alg(struct hifn_device *dev)
 	return err;
 }
 
-static void hifn_tasklet_callback(unsigned long data)
+static void hifn_tasklet_callback(struct tasklet_struct *t)
 {
-	struct hifn_device *dev = (struct hifn_device *)data;
+	struct hifn_device *dev = from_tasklet(dev, t, tasklet);
 
 	/*
 	 * This is ok to call this without lock being held,
@@ -2529,7 +2529,7 @@ static int hifn_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	pci_set_drvdata(pdev, dev);
 
-	tasklet_init(&dev->tasklet, hifn_tasklet_callback, (unsigned long)dev);
+	tasklet_setup(&dev->tasklet, hifn_tasklet_callback);
 
 	crypto_init_queue(&dev->queue, 1);
 
diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index fe4cc8babe1c..3981b0ed297a 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -353,9 +353,9 @@ static int img_hash_dma_init(struct img_hash_dev *hdev)
 	return 0;
 }
 
-static void img_hash_dma_task(unsigned long d)
+static void img_hash_dma_task(struct tasklet_struct *t)
 {
-	struct img_hash_dev *hdev = (struct img_hash_dev *)d;
+	struct img_hash_dev *hdev = from_tasklet(hdev, t, dma_task);
 	struct img_hash_request_ctx *ctx = ahash_request_ctx(hdev->req);
 	u8 *addr;
 	size_t nbytes, bleft, wsend, len, tbc;
@@ -885,9 +885,9 @@ static int img_unregister_algs(struct img_hash_dev *hdev)
 	return 0;
 }
 
-static void img_hash_done_task(unsigned long data)
+static void img_hash_done_task(struct tasklet_struct *t)
 {
-	struct img_hash_dev *hdev = (struct img_hash_dev *)data;
+	struct img_hash_dev *hdev = from_tasklet(hdev, t, done_task);
 	int err = 0;
 
 	if (hdev->err == -EINVAL) {
@@ -952,8 +952,8 @@ static int img_hash_probe(struct platform_device *pdev)
 
 	INIT_LIST_HEAD(&hdev->list);
 
-	tasklet_init(&hdev->done_task, img_hash_done_task, (unsigned long)hdev);
-	tasklet_init(&hdev->dma_task, img_hash_dma_task, (unsigned long)hdev);
+	tasklet_setup(&hdev->done_task, img_hash_done_task);
+	tasklet_setup(&hdev->dma_task, img_hash_dma_task);
 
 	crypto_init_queue(&hdev->queue, IMG_HASH_QUEUE_LENGTH);
 
diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 9181523ba760..8bd3c6acbf5e 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -413,8 +413,7 @@ static void irqhandler(void *_unused)
 	tasklet_schedule(&crypto_done_tasklet);
 }
 
-static void crypto_done_action(unsigned long arg)
-{
+static void crypto_done_action(struct tasklet_struct *unused){
 	int i;
 
 	for(i=0; i<4; i++) {
@@ -496,7 +495,7 @@ static int init_ixp_crypto(struct device *dev)
 		goto err;
 	}
 	qmgr_set_irq(RECV_QID, QUEUE_IRQ_SRC_NOT_EMPTY, irqhandler, NULL);
-	tasklet_init(&crypto_done_tasklet, crypto_done_action, 0);
+	tasklet_setup(&crypto_done_tasklet, crypto_done_action);
 
 	qmgr_enable_irq(RECV_QID);
 	return 0;
diff --git a/drivers/crypto/mediatek/mtk-aes.c b/drivers/crypto/mediatek/mtk-aes.c
index 90c9644fb8a8..48b3e8b72448 100644
--- a/drivers/crypto/mediatek/mtk-aes.c
+++ b/drivers/crypto/mediatek/mtk-aes.c
@@ -1156,16 +1156,16 @@ static struct aead_alg aes_gcm_alg = {
 	},
 };
 
-static void mtk_aes_queue_task(unsigned long data)
+static void mtk_aes_queue_task(struct tasklet_struct *t)
 {
-	struct mtk_aes_rec *aes = (struct mtk_aes_rec *)data;
+	struct mtk_aes_rec *aes = from_tasklet(aes, t, queue_task);
 
 	mtk_aes_handle_queue(aes->cryp, aes->id, NULL);
 }
 
-static void mtk_aes_done_task(unsigned long data)
+static void mtk_aes_done_task(struct tasklet_struct *t)
 {
-	struct mtk_aes_rec *aes = (struct mtk_aes_rec *)data;
+	struct mtk_aes_rec *aes = from_tasklet(aes, t, done_task);
 	struct mtk_cryp *cryp = aes->cryp;
 
 	mtk_aes_unmap(cryp, aes);
@@ -1218,10 +1218,8 @@ static int mtk_aes_record_init(struct mtk_cryp *cryp)
 		spin_lock_init(&aes[i]->lock);
 		crypto_init_queue(&aes[i]->queue, AES_QUEUE_SIZE);
 
-		tasklet_init(&aes[i]->queue_task, mtk_aes_queue_task,
-			     (unsigned long)aes[i]);
-		tasklet_init(&aes[i]->done_task, mtk_aes_done_task,
-			     (unsigned long)aes[i]);
+		tasklet_setup(&aes[i]->queue_task, mtk_aes_queue_task);
+		tasklet_setup(&aes[i]->done_task, mtk_aes_done_task);
 	}
 
 	/* Link to ring0 and ring1 respectively */
diff --git a/drivers/crypto/mediatek/mtk-sha.c b/drivers/crypto/mediatek/mtk-sha.c
index 9e9f48bb7f85..fa59ca315d77 100644
--- a/drivers/crypto/mediatek/mtk-sha.c
+++ b/drivers/crypto/mediatek/mtk-sha.c
@@ -1166,16 +1166,16 @@ static struct ahash_alg algs_sha384_sha512[] = {
 },
 };
 
-static void mtk_sha_queue_task(unsigned long data)
+static void mtk_sha_queue_task(struct tasklet_struct *t)
 {
-	struct mtk_sha_rec *sha = (struct mtk_sha_rec *)data;
+	struct mtk_sha_rec *sha = from_tasklet(sha, t, queue_task);
 
 	mtk_sha_handle_queue(sha->cryp, sha->id - MTK_RING2, NULL);
 }
 
-static void mtk_sha_done_task(unsigned long data)
+static void mtk_sha_done_task(struct tasklet_struct *t)
 {
-	struct mtk_sha_rec *sha = (struct mtk_sha_rec *)data;
+	struct mtk_sha_rec *sha = from_tasklet(sha, t, done_task);
 	struct mtk_cryp *cryp = sha->cryp;
 
 	mtk_sha_unmap(cryp, sha);
@@ -1221,10 +1221,8 @@ static int mtk_sha_record_init(struct mtk_cryp *cryp)
 		spin_lock_init(&sha[i]->lock);
 		crypto_init_queue(&sha[i]->queue, SHA_QUEUE_SIZE);
 
-		tasklet_init(&sha[i]->queue_task, mtk_sha_queue_task,
-			     (unsigned long)sha[i]);
-		tasklet_init(&sha[i]->done_task, mtk_sha_done_task,
-			     (unsigned long)sha[i]);
+		tasklet_setup(&sha[i]->queue_task, mtk_sha_queue_task);
+		tasklet_setup(&sha[i]->done_task, mtk_sha_done_task);
 	}
 
 	/* Link to ring2 and ring3 respectively */
diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 2f53fbb74100..54045315189e 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -479,9 +479,9 @@ static int omap_aes_crypt_req(struct crypto_engine *engine,
 	return omap_aes_crypt_dma_start(dd);
 }
 
-static void omap_aes_done_task(unsigned long data)
+static void omap_aes_done_task(struct tasklet_struct *t)
 {
-	struct omap_aes_dev *dd = (struct omap_aes_dev *)data;
+	struct omap_aes_dev *dd = from_tasklet(dd, t, done_task);
 
 	pr_debug("enter done_task\n");
 
@@ -1170,7 +1170,7 @@ static int omap_aes_probe(struct platform_device *pdev)
 		 (reg & dd->pdata->major_mask) >> dd->pdata->major_shift,
 		 (reg & dd->pdata->minor_mask) >> dd->pdata->minor_shift);
 
-	tasklet_init(&dd->done_task, omap_aes_done_task, (unsigned long)dd);
+	tasklet_setup(&dd->done_task, omap_aes_done_task);
 
 	err = omap_aes_dma_init(dd);
 	if (err == -EPROBE_DEFER) {
diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index b19d7e5d55ec..b8e7c3609b9a 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -593,9 +593,9 @@ static int omap_des_crypt_req(struct crypto_engine *engine,
 	return omap_des_crypt_dma_start(dd);
 }
 
-static void omap_des_done_task(unsigned long data)
+static void omap_des_done_task(struct tasklet_struct *t)
 {
-	struct omap_des_dev *dd = (struct omap_des_dev *)data;
+	struct omap_des_dev *dd = from_tasklet(dd, t, done_task);
 
 	pr_debug("enter done_task\n");
 
@@ -1028,7 +1028,7 @@ static int omap_des_probe(struct platform_device *pdev)
 		 (reg & dd->pdata->major_mask) >> dd->pdata->major_shift,
 		 (reg & dd->pdata->minor_mask) >> dd->pdata->minor_shift);
 
-	tasklet_init(&dd->done_task, omap_des_done_task, (unsigned long)dd);
+	tasklet_setup(&dd->done_task, omap_des_done_task);
 
 	err = omap_des_dma_init(dd);
 	if (err == -EPROBE_DEFER) {
diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index ac80bc6af093..cf7c49508ccb 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1725,9 +1725,9 @@ static struct ahash_alg algs_sha384_sha512[] = {
 },
 };
 
-static void omap_sham_done_task(unsigned long data)
+static void omap_sham_done_task(struct tasklet_struct *t)
 {
-	struct omap_sham_dev *dd = (struct omap_sham_dev *)data;
+	struct omap_sham_dev *dd = from_tasklet(dd, t, done_task);
 	int err = 0;
 
 	if (!test_bit(FLAGS_BUSY, &dd->flags)) {
@@ -2099,7 +2099,7 @@ static int omap_sham_probe(struct platform_device *pdev)
 
 	INIT_LIST_HEAD(&dd->list);
 	spin_lock_init(&dd->lock);
-	tasklet_init(&dd->done_task, omap_sham_done_task, (unsigned long)dd);
+	tasklet_setup(&dd->done_task, omap_sham_done_task);
 	crypto_init_queue(&dd->queue, OMAP_SHAM_QUEUE_LENGTH);
 
 	err = (dev->of_node) ? omap_sham_get_res_of(dd, dev, &res) :
diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index 3cbefb41b099..0a4d600f1731 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -1142,9 +1142,9 @@ static int spacc_req_submit(struct spacc_req *req)
 		return spacc_ablk_submit(req);
 }
 
-static void spacc_spacc_complete(unsigned long data)
+static void spacc_spacc_complete(struct tasklet_struct *t)
 {
-	struct spacc_engine *engine = (struct spacc_engine *)data;
+	struct spacc_engine *engine = from_tasklet(engine, t, complete);
 	struct spacc_req *req, *tmp;
 	unsigned long flags;
 	LIST_HEAD(completed);
@@ -1712,8 +1712,7 @@ static int spacc_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&engine->completed);
 	INIT_LIST_HEAD(&engine->in_progress);
 	engine->in_flight = 0;
-	tasklet_init(&engine->complete, spacc_spacc_complete,
-		     (unsigned long)engine);
+	tasklet_setup(&engine->complete, spacc_spacc_complete);
 
 	platform_set_drvdata(pdev, engine);
 
diff --git a/drivers/crypto/qat/qat_common/adf_isr.c b/drivers/crypto/qat/qat_common/adf_isr.c
index cd1cdf5305bc..75c85b46062d 100644
--- a/drivers/crypto/qat/qat_common/adf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_isr.c
@@ -283,9 +283,8 @@ static int adf_setup_bh(struct adf_accel_dev *accel_dev)
 	int i;
 
 	for (i = 0; i < hw_data->num_banks; i++)
-		tasklet_init(&priv_data->banks[i].resp_handler,
-			     adf_response_handler,
-			     (unsigned long)&priv_data->banks[i]);
+		tasklet_setup(&priv_data->banks[i].resp_handler,
+			      adf_response_handler);
 	return 0;
 }
 
diff --git a/drivers/crypto/qat/qat_common/adf_sriov.c b/drivers/crypto/qat/qat_common/adf_sriov.c
index b36d8653b1ba..e7cdeb57f726 100644
--- a/drivers/crypto/qat/qat_common/adf_sriov.c
+++ b/drivers/crypto/qat/qat_common/adf_sriov.c
@@ -93,9 +93,9 @@ static void adf_iov_send_resp(struct work_struct *work)
 	kfree(pf2vf_resp);
 }
 
-static void adf_vf2pf_bh_handler(void *data)
+static void adf_vf2pf_bh_handler(struct tasklet_struct *t)
 {
-	struct adf_accel_vf_info *vf_info = (struct adf_accel_vf_info *)data;
+	struct adf_accel_vf_info *vf_info = from_tasklet(vf_info, t, vf2pf_bh_tasklet);
 	struct adf_pf2vf_resp *pf2vf_resp;
 
 	pf2vf_resp = kzalloc(sizeof(*pf2vf_resp), GFP_ATOMIC);
@@ -125,9 +125,7 @@ static int adf_enable_sriov(struct adf_accel_dev *accel_dev)
 		vf_info->accel_dev = accel_dev;
 		vf_info->vf_nr = i;
 
-		tasklet_init(&vf_info->vf2pf_bh_tasklet,
-			     (void *)adf_vf2pf_bh_handler,
-			     (unsigned long)vf_info);
+		tasklet_setup(&vf_info->vf2pf_bh_tasklet, adf_vf2pf_bh_handler);
 		mutex_init(&vf_info->pf2vf_lock);
 		ratelimit_state_init(&vf_info->vf2pf_ratelimit,
 				     DEFAULT_RATELIMIT_INTERVAL,
diff --git a/drivers/crypto/qat/qat_common/adf_transport.c b/drivers/crypto/qat/qat_common/adf_transport.c
index 2136cbe4bf6c..52f7bd30848b 100644
--- a/drivers/crypto/qat/qat_common/adf_transport.c
+++ b/drivers/crypto/qat/qat_common/adf_transport.c
@@ -341,9 +341,9 @@ static void adf_ring_response_handler(struct adf_etr_bank_data *bank)
 	}
 }
 
-void adf_response_handler(uintptr_t bank_addr)
+void adf_response_handler(struct tasklet_struct *t)
 {
-	struct adf_etr_bank_data *bank = (void *)bank_addr;
+	struct adf_etr_bank_data *bank = from_tasklet(bank, t, resp_handler);
 
 	/* Handle all the responses and reenable IRQs */
 	adf_ring_response_handler(bank);
diff --git a/drivers/crypto/qat/qat_common/adf_transport_internal.h b/drivers/crypto/qat/qat_common/adf_transport_internal.h
index bb883368ac01..5caaf001e44f 100644
--- a/drivers/crypto/qat/qat_common/adf_transport_internal.h
+++ b/drivers/crypto/qat/qat_common/adf_transport_internal.h
@@ -91,7 +91,7 @@ struct adf_etr_data {
 	struct dentry *debug;
 };
 
-void adf_response_handler(uintptr_t bank_addr);
+void adf_response_handler(struct tasklet_struct *t);
 #ifdef CONFIG_DEBUG_FS
 #include <linux/debugfs.h>
 int adf_bank_debugfs_add(struct adf_etr_bank_data *bank);
diff --git a/drivers/crypto/qat/qat_common/adf_vf_isr.c b/drivers/crypto/qat/qat_common/adf_vf_isr.c
index 4a73fc70f7a9..2ea5523dce66 100644
--- a/drivers/crypto/qat/qat_common/adf_vf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_vf_isr.c
@@ -112,9 +112,10 @@ static void adf_dev_stop_async(struct work_struct *work)
 	kfree(stop_data);
 }
 
-static void adf_pf2vf_bh_handler(void *data)
+static void adf_pf2vf_bh_handler(struct tasklet_struct *t)
 {
-	struct adf_accel_dev *accel_dev = data;
+	struct adf_accel_dev *accel_dev = from_tasklet(accel_dev, t,
+					  vf.pf2vf_bh_tasklet);
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 	struct adf_bar *pmisc =
 			&GET_BARS(accel_dev)[hw_data->get_misc_bar_id(hw_data)];
@@ -182,8 +183,7 @@ static void adf_pf2vf_bh_handler(void *data)
 
 static int adf_setup_pf2vf_bh(struct adf_accel_dev *accel_dev)
 {
-	tasklet_init(&accel_dev->vf.pf2vf_bh_tasklet,
-		     (void *)adf_pf2vf_bh_handler, (unsigned long)accel_dev);
+	tasklet_setup(&accel_dev->vf.pf2vf_bh_tasklet, adf_pf2vf_bh_handler);
 
 	mutex_init(&accel_dev->vf.vf2pf_lock);
 	return 0;
@@ -259,8 +259,7 @@ static int adf_setup_bh(struct adf_accel_dev *accel_dev)
 {
 	struct adf_etr_data *priv_data = accel_dev->transport;
 
-	tasklet_init(&priv_data->banks[0].resp_handler, adf_response_handler,
-		     (unsigned long)priv_data->banks);
+	tasklet_setup(&priv_data->banks[0].resp_handler, adf_response_handler);
 	return 0;
 }
 
diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index 08d4ce3bfddf..ada8538e3d2e 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -112,9 +112,9 @@ static int qce_handle_queue(struct qce_device *qce,
 	return ret;
 }
 
-static void qce_tasklet_req_done(unsigned long data)
+static void qce_tasklet_req_done(struct tasklet_struct *t)
 {
-	struct qce_device *qce = (struct qce_device *)data;
+	struct qce_device *qce = from_tasklet(qce, t, done_tasklet);
 	struct crypto_async_request *req;
 	unsigned long flags;
 
@@ -217,8 +217,7 @@ static int qce_crypto_probe(struct platform_device *pdev)
 		goto err_clks;
 
 	spin_lock_init(&qce->lock);
-	tasklet_init(&qce->done_tasklet, qce_tasklet_req_done,
-		     (unsigned long)qce);
+	tasklet_setup(&qce->done_tasklet, qce_tasklet_req_done);
 	crypto_init_queue(&qce->queue, QCE_QUEUE_LENGTH);
 
 	qce->async_req_enqueue = qce_async_request_enqueue;
diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto/rockchip/rk3288_crypto.c
index e5714ef24bf2..e1bd1f4f3e72 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.c
+++ b/drivers/crypto/rockchip/rk3288_crypto.c
@@ -200,9 +200,9 @@ static int rk_crypto_enqueue(struct rk_crypto_info *dev,
 	return ret;
 }
 
-static void rk_crypto_queue_task_cb(unsigned long data)
+static void rk_crypto_queue_task_cb(struct tasklet_struct *t)
 {
-	struct rk_crypto_info *dev = (struct rk_crypto_info *)data;
+	struct rk_crypto_info *dev = from_tasklet(dev, t, queue_task);
 	struct crypto_async_request *async_req, *backlog;
 	unsigned long flags;
 	int err = 0;
@@ -230,9 +230,9 @@ static void rk_crypto_queue_task_cb(unsigned long data)
 		dev->complete(dev->async_req, err);
 }
 
-static void rk_crypto_done_task_cb(unsigned long data)
+static void rk_crypto_done_task_cb(struct tasklet_struct *t)
 {
-	struct rk_crypto_info *dev = (struct rk_crypto_info *)data;
+	struct rk_crypto_info *dev = from_tasklet(dev, t, done_task);
 
 	if (dev->err) {
 		dev->complete(dev->async_req, dev->err);
@@ -388,10 +388,8 @@ static int rk_crypto_probe(struct platform_device *pdev)
 	crypto_info->dev = &pdev->dev;
 	platform_set_drvdata(pdev, crypto_info);
 
-	tasklet_init(&crypto_info->queue_task,
-		     rk_crypto_queue_task_cb, (unsigned long)crypto_info);
-	tasklet_init(&crypto_info->done_task,
-		     rk_crypto_done_task_cb, (unsigned long)crypto_info);
+	tasklet_setup(&crypto_info->queue_task, rk_crypto_queue_task_cb);
+	tasklet_setup(&crypto_info->done_task, rk_crypto_done_task_cb);
 	crypto_init_queue(&crypto_info->queue, 50);
 
 	crypto_info->enable_clk = rk_crypto_enable_clk;
diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 010f1bb20dad..d4a31bb08c97 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -1443,9 +1443,9 @@ static int s5p_hash_handle_queue(struct s5p_aes_dev *dd,
  * s5p_hash_tasklet_cb() - hash tasklet
  * @data:	ptr to s5p_aes_dev
  */
-static void s5p_hash_tasklet_cb(unsigned long data)
+static void s5p_hash_tasklet_cb(struct tasklet_struct *t)
 {
-	struct s5p_aes_dev *dd = (struct s5p_aes_dev *)data;
+	struct s5p_aes_dev *dd = from_tasklet(dd, t, hash_tasklet);
 
 	if (!test_bit(HASH_FLAGS_BUSY, &dd->hash_flags)) {
 		s5p_hash_handle_queue(dd, NULL);
@@ -2000,9 +2000,9 @@ static void s5p_aes_crypt_start(struct s5p_aes_dev *dev, unsigned long mode)
 	s5p_aes_complete(req, err);
 }
 
-static void s5p_tasklet_cb(unsigned long data)
+static void s5p_tasklet_cb(struct tasklet_struct *t)
 {
-	struct s5p_aes_dev *dev = (struct s5p_aes_dev *)data;
+	struct s5p_aes_dev *dev = from_tasklet(dev, t, tasklet);
 	struct crypto_async_request *async_req, *backlog;
 	struct s5p_aes_reqctx *reqctx;
 	unsigned long flags;
@@ -2293,7 +2293,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, pdata);
 	s5p_dev = pdata;
 
-	tasklet_init(&pdata->tasklet, s5p_tasklet_cb, (unsigned long)pdata);
+	tasklet_setup(&pdata->tasklet, s5p_tasklet_cb);
 	crypto_init_queue(&pdata->queue, CRYPTO_QUEUE_LEN);
 
 	for (i = 0; i < ARRAY_SIZE(algs); i++) {
@@ -2303,8 +2303,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
 	}
 
 	if (pdata->use_hash) {
-		tasklet_init(&pdata->hash_tasklet, s5p_hash_tasklet_cb,
-			     (unsigned long)pdata);
+		tasklet_setup(&pdata->hash_tasklet, s5p_hash_tasklet_cb);
 		crypto_init_queue(&pdata->hash_queue, SSS_HASH_QUEUE_LENGTH);
 
 		for (hash_i = 0; hash_i < ARRAY_SIZE(algs_sha1_md5_sha256);
diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index cb6c10b1bf36..6256ca97c6eb 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -402,10 +402,11 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
  * process completed requests for channels that have done status
  */
 #define DEF_TALITOS1_DONE(name, ch_done_mask)				\
-static void talitos1_done_##name(unsigned long data)			\
+static void talitos1_done_##name(struct tasklet_struct *t)		\
 {									\
-	struct device *dev = (struct device *)data;			\
-	struct talitos_private *priv = dev_get_drvdata(dev);		\
+	struct talitos_private *priv = from_tasklet(priv, t,		\
+		done_task[0]);						\
+	struct device *dev = priv->dev;					\
 	unsigned long flags;						\
 									\
 	if (ch_done_mask & 0x10000000)					\
@@ -428,11 +429,12 @@ static void talitos1_done_##name(unsigned long data)			\
 DEF_TALITOS1_DONE(4ch, TALITOS1_ISR_4CHDONE)
 DEF_TALITOS1_DONE(ch0, TALITOS1_ISR_CH_0_DONE)
 
-#define DEF_TALITOS2_DONE(name, ch_done_mask)				\
-static void talitos2_done_##name(unsigned long data)			\
+#define DEF_TALITOS2_DONE(name, ch_done_mask, tasklet_idx)		\
+static void talitos2_done_##name(struct tasklet_struct *t)		\
 {									\
-	struct device *dev = (struct device *)data;			\
-	struct talitos_private *priv = dev_get_drvdata(dev);		\
+	struct talitos_private *priv = from_tasklet(priv, t,		\
+		done_task[tasklet_idx]);				\
+	struct device *dev = priv->dev;					\
 	unsigned long flags;						\
 									\
 	if (ch_done_mask & 1)						\
@@ -452,10 +454,10 @@ static void talitos2_done_##name(unsigned long data)			\
 	spin_unlock_irqrestore(&priv->reg_lock, flags);			\
 }
 
-DEF_TALITOS2_DONE(4ch, TALITOS2_ISR_4CHDONE)
-DEF_TALITOS2_DONE(ch0, TALITOS2_ISR_CH_0_DONE)
-DEF_TALITOS2_DONE(ch0_2, TALITOS2_ISR_CH_0_2_DONE)
-DEF_TALITOS2_DONE(ch1_3, TALITOS2_ISR_CH_1_3_DONE)
+DEF_TALITOS2_DONE(4ch, TALITOS2_ISR_4CHDONE, 0)
+DEF_TALITOS2_DONE(ch0, TALITOS2_ISR_CH_0_DONE, 0)
+DEF_TALITOS2_DONE(ch0_2, TALITOS2_ISR_CH_0_2_DONE, 0)
+DEF_TALITOS2_DONE(ch1_3, TALITOS2_ISR_CH_1_3_DONE, 1)
 
 /*
  * locate current (offending) descriptor
@@ -3372,23 +3374,17 @@ static int talitos_probe(struct platform_device *ofdev)
 
 	if (has_ftr_sec1(priv)) {
 		if (priv->num_channels == 1)
-			tasklet_init(&priv->done_task[0], talitos1_done_ch0,
-				     (unsigned long)dev);
+			tasklet_setup(&priv->done_task[0], talitos1_done_ch0);
 		else
-			tasklet_init(&priv->done_task[0], talitos1_done_4ch,
-				     (unsigned long)dev);
+			tasklet_setup(&priv->done_task[0], talitos1_done_4ch);
 	} else {
 		if (priv->irq[1]) {
-			tasklet_init(&priv->done_task[0], talitos2_done_ch0_2,
-				     (unsigned long)dev);
-			tasklet_init(&priv->done_task[1], talitos2_done_ch1_3,
-				     (unsigned long)dev);
+			tasklet_setup(&priv->done_task[0], talitos2_done_ch0_2);
+			tasklet_setup(&priv->done_task[1], talitos2_done_ch1_3);
 		} else if (priv->num_channels == 1) {
-			tasklet_init(&priv->done_task[0], talitos2_done_ch0,
-				     (unsigned long)dev);
+			tasklet_setup(&priv->done_task[0], talitos2_done_ch0);
 		} else {
-			tasklet_init(&priv->done_task[0], talitos2_done_4ch,
-				     (unsigned long)dev);
+			tasklet_setup(&priv->done_task[0], talitos2_done_4ch);
 		}
 	}
 
diff --git a/drivers/dma/altera-msgdma.c b/drivers/dma/altera-msgdma.c
index 832aefbe7af9..6ce616c6b51d 100644
--- a/drivers/dma/altera-msgdma.c
+++ b/drivers/dma/altera-msgdma.c
@@ -678,9 +678,9 @@ static int msgdma_alloc_chan_resources(struct dma_chan *dchan)
  * msgdma_tasklet - Schedule completion tasklet
  * @data: Pointer to the Altera sSGDMA channel structure
  */
-static void msgdma_tasklet(unsigned long data)
+static void msgdma_tasklet(struct tasklet_struct *t)
 {
-	struct msgdma_device *mdev = (struct msgdma_device *)data;
+	struct msgdma_device *mdev = from_tasklet(mdev, t, irq_tasklet);
 	u32 count;
 	u32 __maybe_unused size;
 	u32 __maybe_unused status;
@@ -828,7 +828,7 @@ static int msgdma_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	tasklet_init(&mdev->irq_tasklet, msgdma_tasklet, (unsigned long)mdev);
+	tasklet_setup(&mdev->irq_tasklet, msgdma_tasklet);
 
 	dma_cookie_init(&mdev->dmachan);
 
diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 672c73b4a2d4..e09e8fd1cec1 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -597,9 +597,9 @@ static void atc_handle_cyclic(struct at_dma_chan *atchan)
 
 /*--  IRQ & Tasklet  ---------------------------------------------------*/
 
-static void atc_tasklet(unsigned long data)
+static void atc_tasklet(struct tasklet_struct *t)
 {
-	struct at_dma_chan *atchan = (struct at_dma_chan *)data;
+	struct at_dma_chan *atchan = from_tasklet(atchan, t, tasklet);
 	unsigned long flags;
 
 	spin_lock_irqsave(&atchan->lock, flags);
@@ -1902,8 +1902,7 @@ static int __init at_dma_probe(struct platform_device *pdev)
 		INIT_LIST_HEAD(&atchan->queue);
 		INIT_LIST_HEAD(&atchan->free_list);
 
-		tasklet_init(&atchan->tasklet, atc_tasklet,
-				(unsigned long)atchan);
+		tasklet_setup(&atchan->tasklet, atc_tasklet);
 		atc_enable_chan_irq(atdma, i);
 	}
 
diff --git a/drivers/dma/at_xdmac.c b/drivers/dma/at_xdmac.c
index b58ac720d9a1..a1ef35174f35 100644
--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -1618,9 +1618,9 @@ static void at_xdmac_handle_error(struct at_xdmac_chan *atchan)
 	/* Then continue with usual descriptor management */
 }
 
-static void at_xdmac_tasklet(unsigned long data)
+static void at_xdmac_tasklet(struct tasklet_struct *t)
 {
-	struct at_xdmac_chan	*atchan = (struct at_xdmac_chan *)data;
+	struct at_xdmac_chan *atchan = from_tasklet(atchan, t, tasklet);
 	struct at_xdmac_desc	*desc;
 	u32			error_mask;
 
@@ -2076,8 +2076,7 @@ static int at_xdmac_probe(struct platform_device *pdev)
 		spin_lock_init(&atchan->lock);
 		INIT_LIST_HEAD(&atchan->xfers_list);
 		INIT_LIST_HEAD(&atchan->free_descs_list);
-		tasklet_init(&atchan->tasklet, at_xdmac_tasklet,
-			     (unsigned long)atchan);
+		tasklet_setup(&atchan->tasklet, at_xdmac_tasklet);
 
 		/* Clear pending interrupts. */
 		while (at_xdmac_chan_read(atchan, AT_XDMAC_CIS))
diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index e51d836afcc7..90490ddc2e1e 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -1868,9 +1868,9 @@ static struct coh901318_desc *coh901318_queue_start(struct coh901318_chan *cohc)
  * This tasklet is called from the interrupt handler to
  * handle each descriptor (DMA job) that is sent to a channel.
  */
-static void dma_tasklet(unsigned long data)
+static void dma_tasklet(struct tasklet_struct *t)
 {
-	struct coh901318_chan *cohc = (struct coh901318_chan *) data;
+	struct coh901318_chan *cohc = from_tasklet(cohc, t, tasklet);
 	struct coh901318_desc *cohd_fin;
 	unsigned long flags;
 	struct dmaengine_desc_callback cb;
@@ -2619,8 +2619,7 @@ static void coh901318_base_init(struct dma_device *dma, const int *pick_chans,
 			INIT_LIST_HEAD(&cohc->active);
 			INIT_LIST_HEAD(&cohc->queue);
 
-			tasklet_init(&cohc->tasklet, dma_tasklet,
-				     (unsigned long) cohc);
+			tasklet_setup(&cohc->tasklet, dma_tasklet);
 
 			list_add_tail(&cohc->chan.device_node,
 				      &dma->channels);
diff --git a/drivers/dma/dw/core.c b/drivers/dma/dw/core.c
index 21cb2a58dbd2..4feb97fe1b9d 100644
--- a/drivers/dma/dw/core.c
+++ b/drivers/dma/dw/core.c
@@ -468,9 +468,9 @@ static void dwc_handle_error(struct dw_dma *dw, struct dw_dma_chan *dwc)
 	dwc_descriptor_complete(dwc, bad_desc, true);
 }
 
-static void dw_dma_tasklet(unsigned long data)
+static void dw_dma_tasklet(struct tasklet_struct *t)
 {
-	struct dw_dma *dw = (struct dw_dma *)data;
+	struct dw_dma *dw = from_tasklet(dw, t, tasklet);
 	struct dw_dma_chan *dwc;
 	u32 status_xfer;
 	u32 status_err;
@@ -1126,7 +1126,7 @@ int do_dma_probe(struct dw_dma_chip *chip)
 		goto err_pdata;
 	}
 
-	tasklet_init(&dw->tasklet, dw_dma_tasklet, (unsigned long)dw);
+	tasklet_setup(&dw->tasklet, dw_dma_tasklet);
 
 	err = request_irq(chip->irq, dw_dma_interrupt, IRQF_SHARED,
 			  dw->name, dw);
diff --git a/drivers/dma/ep93xx_dma.c b/drivers/dma/ep93xx_dma.c
index 9c8b4d35cf03..b7f81921d419 100644
--- a/drivers/dma/ep93xx_dma.c
+++ b/drivers/dma/ep93xx_dma.c
@@ -743,9 +743,9 @@ static void ep93xx_dma_advance_work(struct ep93xx_dma_chan *edmac)
 	spin_unlock_irqrestore(&edmac->lock, flags);
 }
 
-static void ep93xx_dma_tasklet(unsigned long data)
+static void ep93xx_dma_tasklet(struct tasklet_struct *t)
 {
-	struct ep93xx_dma_chan *edmac = (struct ep93xx_dma_chan *)data;
+	struct ep93xx_dma_chan *edmac = from_tasklet(edmac, t, tasklet);
 	struct ep93xx_dma_desc *desc, *d;
 	struct dmaengine_desc_callback cb;
 	LIST_HEAD(list);
@@ -1351,8 +1351,7 @@ static int __init ep93xx_dma_probe(struct platform_device *pdev)
 		INIT_LIST_HEAD(&edmac->active);
 		INIT_LIST_HEAD(&edmac->queue);
 		INIT_LIST_HEAD(&edmac->free_list);
-		tasklet_init(&edmac->tasklet, ep93xx_dma_tasklet,
-			     (unsigned long)edmac);
+		tasklet_setup(&edmac->tasklet, ep93xx_dma_tasklet);
 
 		list_add_tail(&edmac->chan.device_node,
 			      &dma_dev->channels);
diff --git a/drivers/dma/fsl_raid.c b/drivers/dma/fsl_raid.c
index 493dc6c59d1d..fdf3500d96a9 100644
--- a/drivers/dma/fsl_raid.c
+++ b/drivers/dma/fsl_raid.c
@@ -154,17 +154,15 @@ static void fsl_re_cleanup_descs(struct fsl_re_chan *re_chan)
 	fsl_re_issue_pending(&re_chan->chan);
 }
 
-static void fsl_re_dequeue(unsigned long data)
+static void fsl_re_dequeue(struct tasklet_struct *t)
 {
-	struct fsl_re_chan *re_chan;
+	struct fsl_re_chan *re_chan = from_tasklet(re_chan, t, irqtask);
 	struct fsl_re_desc *desc, *_desc;
 	struct fsl_re_hw_desc *hwdesc;
 	unsigned long flags;
 	unsigned int count, oub_count;
 	int found;
 
-	re_chan = dev_get_drvdata((struct device *)data);
-
 	fsl_re_cleanup_descs(re_chan);
 
 	spin_lock_irqsave(&re_chan->desc_lock, flags);
@@ -671,7 +669,7 @@ static int fsl_re_chan_probe(struct platform_device *ofdev,
 	snprintf(chan->name, sizeof(chan->name), "re_jr%02d", q);
 
 	chandev = &chan_ofdev->dev;
-	tasklet_init(&chan->irqtask, fsl_re_dequeue, (unsigned long)chandev);
+	tasklet_setup(&chan->irqtask, fsl_re_dequeue);
 
 	ret = request_irq(chan->irq, fsl_re_isr, 0, chan->name, chandev);
 	if (ret) {
diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index ad72b3f42ffa..3ce9cf3d62f5 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -976,9 +976,9 @@ static irqreturn_t fsldma_chan_irq(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static void dma_do_tasklet(unsigned long data)
+static void dma_do_tasklet(struct tasklet_struct *t)
 {
-	struct fsldma_chan *chan = (struct fsldma_chan *)data;
+	struct fsldma_chan *chan = from_tasklet(chan, t, tasklet);
 
 	chan_dbg(chan, "tasklet entry\n");
 
@@ -1151,7 +1151,7 @@ static int fsl_dma_chan_probe(struct fsldma_device *fdev,
 	}
 
 	fdev->chan[chan->id] = chan;
-	tasklet_init(&chan->tasklet, dma_do_tasklet, (unsigned long)chan);
+	tasklet_setup(&chan->tasklet, dma_do_tasklet);
 	snprintf(chan->name, sizeof(chan->name), "chan%d", chan->id);
 
 	/* Initialize the channel */
diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index 5c0fb3134825..67b9f2bf35b7 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -613,9 +613,9 @@ static int imxdma_xfer_desc(struct imxdma_desc *d)
 	return 0;
 }
 
-static void imxdma_tasklet(unsigned long data)
+static void imxdma_tasklet(struct tasklet_struct *t)
 {
-	struct imxdma_channel *imxdmac = (void *)data;
+	struct imxdma_channel *imxdmac = from_tasklet(imxdmac, t, dma_tasklet);
 	struct imxdma_engine *imxdma = imxdmac->imxdma;
 	struct imxdma_desc *desc, *next_desc;
 	unsigned long flags;
@@ -1169,8 +1169,7 @@ static int __init imxdma_probe(struct platform_device *pdev)
 		INIT_LIST_HEAD(&imxdmac->ld_free);
 		INIT_LIST_HEAD(&imxdmac->ld_active);
 
-		tasklet_init(&imxdmac->dma_tasklet, imxdma_tasklet,
-			     (unsigned long)imxdmac);
+		tasklet_setup(&imxdmac->dma_tasklet, imxdma_tasklet);
 		imxdmac->chan.device = &imxdma->dma_device;
 		dma_cookie_init(&imxdmac->chan);
 		imxdmac->channel = i;
diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
index 1a422a8b43cf..4c7c2d819ce7 100644
--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -153,7 +153,7 @@ void ioat_stop(struct ioatdma_chan *ioat_chan)
 	tasklet_kill(&ioat_chan->cleanup_task);
 
 	/* final cleanup now that everything is quiesced and can't re-arm */
-	ioat_cleanup_event((unsigned long)&ioat_chan->dma_chan);
+	ioat_cleanup_event(&ioat_chan->cleanup_task);
 }
 
 static void __ioat_issue_pending(struct ioatdma_chan *ioat_chan)
@@ -674,9 +674,9 @@ static void ioat_cleanup(struct ioatdma_chan *ioat_chan)
 	spin_unlock_bh(&ioat_chan->cleanup_lock);
 }
 
-void ioat_cleanup_event(unsigned long data)
+void ioat_cleanup_event(struct tasklet_struct *t)
 {
-	struct ioatdma_chan *ioat_chan = to_ioat_chan((void *)data);
+	struct ioatdma_chan *ioat_chan = from_tasklet(ioat_chan, t, cleanup_task);
 
 	ioat_cleanup(ioat_chan);
 	if (!test_bit(IOAT_RUN, &ioat_chan->state))
diff --git a/drivers/dma/ioat/dma.h b/drivers/dma/ioat/dma.h
index b8e8e0b9693c..c1bafbfa38c2 100644
--- a/drivers/dma/ioat/dma.h
+++ b/drivers/dma/ioat/dma.h
@@ -393,7 +393,7 @@ int ioat_reset_hw(struct ioatdma_chan *ioat_chan);
 enum dma_status
 ioat_tx_status(struct dma_chan *c, dma_cookie_t cookie,
 		struct dma_tx_state *txstate);
-void ioat_cleanup_event(unsigned long data);
+void ioat_cleanup_event(struct tasklet_struct *t);
 void ioat_timer_event(struct timer_list *t);
 int ioat_check_space_lock(struct ioatdma_chan *ioat_chan, int num_descs);
 void ioat_issue_pending(struct dma_chan *chan);
diff --git a/drivers/dma/ioat/init.c b/drivers/dma/ioat/init.c
index a6a6dc432db8..63cc6e2cc92d 100644
--- a/drivers/dma/ioat/init.c
+++ b/drivers/dma/ioat/init.c
@@ -778,7 +778,7 @@ ioat_init_channel(struct ioatdma_device *ioat_dma,
 	list_add_tail(&ioat_chan->dma_chan.device_node, &dma->channels);
 	ioat_dma->idx[idx] = ioat_chan;
 	timer_setup(&ioat_chan->timer, ioat_timer_event, 0);
-	tasklet_init(&ioat_chan->cleanup_task, ioat_cleanup_event, data);
+	tasklet_setup(&ioat_chan->cleanup_task, ioat_cleanup_event);
 }
 
 #define IOAT_NUM_SRC_TEST 6 /* must be <= 8 */
diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index a3f942a6a946..f6bb76428153 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -238,9 +238,10 @@ iop_adma_slot_cleanup(struct iop_adma_chan *iop_chan)
 	spin_unlock_bh(&iop_chan->lock);
 }
 
-static void iop_adma_tasklet(unsigned long data)
+static void iop_adma_tasklet(struct tasklet_struct *t)
 {
-	struct iop_adma_chan *iop_chan = (struct iop_adma_chan *) data;
+	struct iop_adma_chan *iop_chan = from_tasklet(iop_chan, t,
+						      irq_tasklet);
 
 	/* lockdep will flag depedency submissions as potentially
 	 * recursive locking, this is not the case as a dependency
@@ -1352,8 +1353,7 @@ static int iop_adma_probe(struct platform_device *pdev)
 		ret = -ENOMEM;
 		goto err_free_iop_chan;
 	}
-	tasklet_init(&iop_chan->irq_tasklet, iop_adma_tasklet, (unsigned long)
-		iop_chan);
+	tasklet_setup(&iop_chan->irq_tasklet, iop_adma_tasklet);
 
 	/* clear errors before enabling interrupts */
 	iop_adma_device_clear_err_status(iop_chan);
diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
index 0457b1f26540..38036db284cb 100644
--- a/drivers/dma/ipu/ipu_idmac.c
+++ b/drivers/dma/ipu/ipu_idmac.c
@@ -1299,9 +1299,9 @@ static irqreturn_t idmac_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static void ipu_gc_tasklet(unsigned long arg)
+static void ipu_gc_tasklet(struct tasklet_struct *t)
 {
-	struct ipu *ipu = (struct ipu *)arg;
+	struct ipu *ipu = from_tasklet(ipu, t, tasklet);
 	int i;
 
 	for (i = 0; i < IPU_CHANNELS_NUM; i++) {
@@ -1740,7 +1740,7 @@ static int __init ipu_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto err_idmac_init;
 
-	tasklet_init(&ipu_data.tasklet, ipu_gc_tasklet, (unsigned long)&ipu_data);
+	tasklet_setup(&ipu_data.tasklet, ipu_gc_tasklet);
 
 	ipu_data.dev = &pdev->dev;
 
diff --git a/drivers/dma/k3dma.c b/drivers/dma/k3dma.c
index 4b36c8810517..43d6162429c7 100644
--- a/drivers/dma/k3dma.c
+++ b/drivers/dma/k3dma.c
@@ -291,9 +291,9 @@ static int k3_dma_start_txd(struct k3_dma_chan *c)
 	return -EAGAIN;
 }
 
-static void k3_dma_tasklet(unsigned long arg)
+static void k3_dma_tasklet(struct tasklet_struct *t)
 {
-	struct k3_dma_dev *d = (struct k3_dma_dev *)arg;
+	struct k3_dma_dev *d = from_tasklet(d, t, task);
 	struct k3_dma_phy *p;
 	struct k3_dma_chan *c, *cn;
 	unsigned pch, pch_alloc = 0;
@@ -961,7 +961,7 @@ static int k3_dma_probe(struct platform_device *op)
 
 	spin_lock_init(&d->lock);
 	INIT_LIST_HEAD(&d->chan_pending);
-	tasklet_init(&d->task, k3_dma_tasklet, (unsigned long)d);
+	tasklet_setup(&d->task, k3_dma_tasklet);
 	platform_set_drvdata(op, d);
 	dev_info(&op->dev, "initialized\n");
 
diff --git a/drivers/dma/mediatek/mtk-cqdma.c b/drivers/dma/mediatek/mtk-cqdma.c
index 723b11c190b3..bcdfc81eb163 100644
--- a/drivers/dma/mediatek/mtk-cqdma.c
+++ b/drivers/dma/mediatek/mtk-cqdma.c
@@ -356,9 +356,9 @@ static struct mtk_cqdma_vdesc
 	return ret;
 }
 
-static void mtk_cqdma_tasklet_cb(unsigned long data)
+static void mtk_cqdma_tasklet_cb(struct tasklet_struct *t)
 {
-	struct mtk_cqdma_pchan *pc = (struct mtk_cqdma_pchan *)data;
+	struct mtk_cqdma_pchan *pc = from_tasklet(pc, t, tasklet);
 	struct mtk_cqdma_vdesc *cvd = NULL;
 	unsigned long flags;
 
@@ -886,8 +886,7 @@ static int mtk_cqdma_probe(struct platform_device *pdev)
 
 	/* initialize tasklet for each PC */
 	for (i = 0; i < cqdma->dma_channels; ++i)
-		tasklet_init(&cqdma->pc[i]->tasklet, mtk_cqdma_tasklet_cb,
-			     (unsigned long)cqdma->pc[i]);
+		tasklet_setup(&cqdma->pc[i]->tasklet, mtk_cqdma_tasklet_cb);
 
 	dev_info(&pdev->dev, "MediaTek CQDMA driver registered\n");
 
diff --git a/drivers/dma/mmp_pdma.c b/drivers/dma/mmp_pdma.c
index 7fe494fc50d4..545434654130 100644
--- a/drivers/dma/mmp_pdma.c
+++ b/drivers/dma/mmp_pdma.c
@@ -873,9 +873,9 @@ static void mmp_pdma_issue_pending(struct dma_chan *dchan)
  * Do call back
  * Start pending list
  */
-static void dma_do_tasklet(unsigned long data)
+static void dma_do_tasklet(struct tasklet_struct *t)
 {
-	struct mmp_pdma_chan *chan = (struct mmp_pdma_chan *)data;
+	struct mmp_pdma_chan *chan = from_tasklet(chan, t, tasklet);
 	struct mmp_pdma_desc_sw *desc, *_desc;
 	LIST_HEAD(chain_cleanup);
 	unsigned long flags;
@@ -991,7 +991,7 @@ static int mmp_pdma_chan_init(struct mmp_pdma_device *pdev, int idx, int irq)
 	spin_lock_init(&chan->desc_lock);
 	chan->dev = pdev->dev;
 	chan->chan.device = &pdev->device;
-	tasklet_init(&chan->tasklet, dma_do_tasklet, (unsigned long)chan);
+	tasklet_setup(&chan->tasklet, dma_do_tasklet);
 	INIT_LIST_HEAD(&chan->chain_pending);
 	INIT_LIST_HEAD(&chan->chain_running);
 
diff --git a/drivers/dma/mmp_tdma.c b/drivers/dma/mmp_tdma.c
index e7d1e12bf464..db8e822eb32e 100644
--- a/drivers/dma/mmp_tdma.c
+++ b/drivers/dma/mmp_tdma.c
@@ -346,9 +346,9 @@ static irqreturn_t mmp_tdma_int_handler(int irq, void *dev_id)
 		return IRQ_NONE;
 }
 
-static void dma_do_tasklet(unsigned long data)
+static void dma_do_tasklet(struct tasklet_struct *t)
 {
-	struct mmp_tdma_chan *tdmac = (struct mmp_tdma_chan *)data;
+	struct mmp_tdma_chan *tdmac = from_tasklet(tdmac, t, tasklet);
 
 	dmaengine_desc_get_callback_invoke(&tdmac->desc, NULL);
 }
@@ -573,7 +573,7 @@ static int mmp_tdma_chan_init(struct mmp_tdma_device *tdev,
 	tdmac->pool	   = pool;
 	tdmac->status = DMA_COMPLETE;
 	tdev->tdmac[tdmac->idx] = tdmac;
-	tasklet_init(&tdmac->tasklet, dma_do_tasklet, (unsigned long)tdmac);
+	tasklet_setup(&tdmac->tasklet, dma_do_tasklet);
 
 	/* add the channel to tdma_chan list */
 	list_add_tail(&tdmac->chan.device_node,
diff --git a/drivers/dma/mpc512x_dma.c b/drivers/dma/mpc512x_dma.c
index dc2cae7bcf69..c1a69149c8bf 100644
--- a/drivers/dma/mpc512x_dma.c
+++ b/drivers/dma/mpc512x_dma.c
@@ -414,9 +414,9 @@ static void mpc_dma_process_completed(struct mpc_dma *mdma)
 }
 
 /* DMA Tasklet */
-static void mpc_dma_tasklet(unsigned long data)
+static void mpc_dma_tasklet(struct tasklet_struct *t)
 {
-	struct mpc_dma *mdma = (void *)data;
+	struct mpc_dma *mdma = from_tasklet(mdma, t, tasklet);
 	unsigned long flags;
 	uint es;
 
@@ -1009,7 +1009,7 @@ static int mpc_dma_probe(struct platform_device *op)
 		list_add_tail(&mchan->chan.device_node, &dma->channels);
 	}
 
-	tasklet_init(&mdma->tasklet, mpc_dma_tasklet, (unsigned long)mdma);
+	tasklet_setup(&mdma->tasklet, mpc_dma_tasklet);
 
 	/*
 	 * Configure DMA Engine:
diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 0ac8e7b34e12..00cd1335eeba 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -336,9 +336,9 @@ static void mv_chan_slot_cleanup(struct mv_xor_chan *mv_chan)
 		mv_chan->dmachan.completed_cookie = cookie;
 }
 
-static void mv_xor_tasklet(unsigned long data)
+static void mv_xor_tasklet(struct tasklet_struct *t)
 {
-	struct mv_xor_chan *chan = (struct mv_xor_chan *) data;
+	struct mv_xor_chan *chan = from_tasklet(chan, t, irq_tasklet);
 
 	spin_lock(&chan->lock);
 	mv_chan_slot_cleanup(chan);
@@ -1097,8 +1097,7 @@ mv_xor_channel_add(struct mv_xor_device *xordev,
 
 	mv_chan->mmr_base = xordev->xor_base;
 	mv_chan->mmr_high_base = xordev->xor_high_base;
-	tasklet_init(&mv_chan->irq_tasklet, mv_xor_tasklet, (unsigned long)
-		     mv_chan);
+	tasklet_setup(&mv_chan->irq_tasklet, mv_xor_tasklet);
 
 	/* clear errors before enabling interrupts */
 	mv_chan_clear_err_status(mv_chan);
diff --git a/drivers/dma/mv_xor_v2.c b/drivers/dma/mv_xor_v2.c
index e3850f04f676..a8b74cbe0371 100644
--- a/drivers/dma/mv_xor_v2.c
+++ b/drivers/dma/mv_xor_v2.c
@@ -549,9 +549,10 @@ int mv_xor_v2_get_pending_params(struct mv_xor_v2_device *xor_dev,
 /*
  * handle the descriptors after HW process
  */
-static void mv_xor_v2_tasklet(unsigned long data)
+static void mv_xor_v2_tasklet(struct tasklet_struct *t)
 {
-	struct mv_xor_v2_device *xor_dev = (struct mv_xor_v2_device *) data;
+	struct mv_xor_v2_device *xor_dev = from_tasklet(xor_dev, t,
+							irq_tasklet);
 	int pending_ptr, num_of_pending, i;
 	struct mv_xor_v2_sw_desc *next_pending_sw_desc = NULL;
 
@@ -776,8 +777,7 @@ static int mv_xor_v2_probe(struct platform_device *pdev)
 	if (ret)
 		goto free_msi_irqs;
 
-	tasklet_init(&xor_dev->irq_tasklet, mv_xor_v2_tasklet,
-		     (unsigned long) xor_dev);
+	tasklet_setup(&xor_dev->irq_tasklet, mv_xor_v2_tasklet);
 
 	xor_dev->desc_size = mv_xor_v2_set_desc_size(xor_dev);
 
diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
index 3039bba0e4d5..6f296a137543 100644
--- a/drivers/dma/mxs-dma.c
+++ b/drivers/dma/mxs-dma.c
@@ -320,9 +320,9 @@ static dma_cookie_t mxs_dma_tx_submit(struct dma_async_tx_descriptor *tx)
 	return dma_cookie_assign(tx);
 }
 
-static void mxs_dma_tasklet(unsigned long data)
+static void mxs_dma_tasklet(struct tasklet_struct *t)
 {
-	struct mxs_dma_chan *mxs_chan = (struct mxs_dma_chan *) data;
+	struct mxs_dma_chan *mxs_chan = from_tasklet(mxs_chan, t, tasklet);
 
 	dmaengine_desc_get_callback_invoke(&mxs_chan->desc, NULL);
 }
@@ -812,8 +812,7 @@ static int __init mxs_dma_probe(struct platform_device *pdev)
 		mxs_chan->chan.device = &mxs_dma->dma_device;
 		dma_cookie_init(&mxs_chan->chan);
 
-		tasklet_init(&mxs_chan->tasklet, mxs_dma_tasklet,
-			     (unsigned long) mxs_chan);
+		tasklet_setup(&mxs_chan->tasklet, mxs_dma_tasklet);
 
 
 		/* Add the channel to mxs_chan list */
diff --git a/drivers/dma/nbpfaxi.c b/drivers/dma/nbpfaxi.c
index 594409a6e975..f6980009d347 100644
--- a/drivers/dma/nbpfaxi.c
+++ b/drivers/dma/nbpfaxi.c
@@ -1106,9 +1106,9 @@ static struct dma_chan *nbpf_of_xlate(struct of_phandle_args *dma_spec,
 	return dchan;
 }
 
-static void nbpf_chan_tasklet(unsigned long data)
+static void nbpf_chan_tasklet(struct tasklet_struct *t)
 {
-	struct nbpf_channel *chan = (struct nbpf_channel *)data;
+	struct nbpf_channel *chan = from_tasklet(chan, t, tasklet);
 	struct nbpf_desc *desc, *tmp;
 	struct dmaengine_desc_callback cb;
 
@@ -1253,7 +1253,7 @@ static int nbpf_chan_probe(struct nbpf_device *nbpf, int n)
 
 	snprintf(chan->name, sizeof(chan->name), "nbpf %d", n);
 
-	tasklet_init(&chan->tasklet, nbpf_chan_tasklet, (unsigned long)chan);
+	tasklet_setup(&chan->tasklet, nbpf_chan_tasklet);
 	ret = devm_request_irq(dma_dev->dev, chan->irq,
 			nbpf_chan_irq, IRQF_SHARED,
 			chan->name, chan);
diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
index 581e7a290d98..75660beae932 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -670,9 +670,9 @@ static int pd_device_terminate_all(struct dma_chan *chan)
 	return 0;
 }
 
-static void pdc_tasklet(unsigned long data)
+static void pdc_tasklet(struct tasklet_struct *t)
 {
-	struct pch_dma_chan *pd_chan = (struct pch_dma_chan *)data;
+	struct pch_dma_chan *pd_chan = from_tasklet(pd_chan, t, tasklet);
 	unsigned long flags;
 
 	if (!pdc_is_idle(pd_chan)) {
@@ -898,8 +898,7 @@ static int pch_dma_probe(struct pci_dev *pdev,
 		INIT_LIST_HEAD(&pd_chan->queue);
 		INIT_LIST_HEAD(&pd_chan->free_list);
 
-		tasklet_init(&pd_chan->tasklet, pdc_tasklet,
-			     (unsigned long)pd_chan);
+		tasklet_setup(&pd_chan->tasklet, pdc_tasklet);
 		list_add_tail(&pd_chan->chan.device_node, &pd->dma.channels);
 	}
 
diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 6cce9ef61b29..c70ccd46176a 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -1565,9 +1565,9 @@ static void dma_pl330_rqcb(struct dma_pl330_desc *desc, enum pl330_op_err err)
 	tasklet_schedule(&pch->task);
 }
 
-static void pl330_dotask(unsigned long data)
+static void pl330_dotask(struct tasklet_struct *t)
 {
-	struct pl330_dmac *pl330 = (struct pl330_dmac *) data;
+	struct pl330_dmac *pl330 = from_tasklet(pl330, t, tasks);
 	unsigned long flags;
 	int i;
 
@@ -1971,7 +1971,7 @@ static int pl330_add(struct pl330_dmac *pl330)
 		return ret;
 	}
 
-	tasklet_init(&pl330->tasks, pl330_dotask, (unsigned long) pl330);
+	tasklet_setup(&pl330->tasks, pl330_dotask);
 
 	pl330->state = INIT;
 
@@ -2054,9 +2054,9 @@ static inline void fill_queue(struct dma_pl330_chan *pch)
 	}
 }
 
-static void pl330_tasklet(unsigned long data)
+static void pl330_tasklet(struct tasklet_struct *t)
 {
-	struct dma_pl330_chan *pch = (struct dma_pl330_chan *)data;
+	struct dma_pl330_chan *pch = from_tasklet(pch, t, task);
 	struct dma_pl330_desc *desc, *_dt;
 	unsigned long flags;
 	bool power_down = false;
@@ -2164,7 +2164,7 @@ static int pl330_alloc_chan_resources(struct dma_chan *chan)
 		return -ENOMEM;
 	}
 
-	tasklet_init(&pch->task, pl330_tasklet, (unsigned long) pch);
+	tasklet_setup(&pch->task, pl330_tasklet);
 
 	spin_unlock_irqrestore(&pl330->lock, flags);
 
diff --git a/drivers/dma/ppc4xx/adma.c b/drivers/dma/ppc4xx/adma.c
index fbabd2e88a18..2c0dc645c447 100644
--- a/drivers/dma/ppc4xx/adma.c
+++ b/drivers/dma/ppc4xx/adma.c
@@ -1660,9 +1660,9 @@ static void __ppc440spe_adma_slot_cleanup(struct ppc440spe_adma_chan *chan)
 /**
  * ppc440spe_adma_tasklet - clean up watch-dog initiator
  */
-static void ppc440spe_adma_tasklet(unsigned long data)
+static void ppc440spe_adma_tasklet(struct tasklet_struct *t)
 {
-	struct ppc440spe_adma_chan *chan = (struct ppc440spe_adma_chan *) data;
+	struct ppc440spe_adma_chan *chan = from_tasklet(chan, t, irq_tasklet);
 
 	spin_lock_nested(&chan->lock, SINGLE_DEPTH_NESTING);
 	__ppc440spe_adma_slot_cleanup(chan);
@@ -4141,8 +4141,7 @@ static int ppc440spe_adma_probe(struct platform_device *ofdev)
 	chan->common.device = &adev->common;
 	dma_cookie_init(&chan->common);
 	list_add_tail(&chan->common.device_node, &adev->common.channels);
-	tasklet_init(&chan->irq_tasklet, ppc440spe_adma_tasklet,
-		     (unsigned long)chan);
+	tasklet_setup(&chan->irq_tasklet, ppc440spe_adma_tasklet);
 
 	/* allocate and map helper pages for async validation or
 	 * async_mult/async_sum_product operations on DMA0/1.
diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
index 8e90a405939d..38e16d3fd8ec 100644
--- a/drivers/dma/qcom/bam_dma.c
+++ b/drivers/dma/qcom/bam_dma.c
@@ -1056,9 +1056,9 @@ static void bam_start_dma(struct bam_chan *bchan)
  *
  * Sets up next DMA operation and then processes all completed transactions
  */
-static void dma_tasklet(unsigned long data)
+static void dma_tasklet(struct tasklet_struct *t)
 {
-	struct bam_device *bdev = (struct bam_device *)data;
+	struct bam_device *bdev = from_tasklet(bdev, t, task);
 	struct bam_chan *bchan;
 	unsigned long flags;
 	unsigned int i;
@@ -1274,7 +1274,7 @@ static int bam_dma_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_disable_clk;
 
-	tasklet_init(&bdev->task, dma_tasklet, (unsigned long)bdev);
+	tasklet_setup(&bdev->task, dma_tasklet);
 
 	bdev->channels = devm_kcalloc(bdev->dev, bdev->num_channels,
 				sizeof(*bdev->channels), GFP_KERNEL);
diff --git a/drivers/dma/qcom/hidma.c b/drivers/dma/qcom/hidma.c
index 411f91fde734..af575852a6b7 100644
--- a/drivers/dma/qcom/hidma.c
+++ b/drivers/dma/qcom/hidma.c
@@ -224,9 +224,9 @@ static int hidma_chan_init(struct hidma_dev *dmadev, u32 dma_sig)
 	return 0;
 }
 
-static void hidma_issue_task(unsigned long arg)
+static void hidma_issue_task(struct tasklet_struct *t)
 {
-	struct hidma_dev *dmadev = (struct hidma_dev *)arg;
+	struct hidma_dev *dmadev = from_tasklet(dmadev, t, task);
 
 	pm_runtime_get_sync(dmadev->ddev.dev);
 	hidma_ll_start(dmadev->lldev);
@@ -885,7 +885,7 @@ static int hidma_probe(struct platform_device *pdev)
 		goto uninit;
 
 	dmadev->irq = chirq;
-	tasklet_init(&dmadev->task, hidma_issue_task, (unsigned long)dmadev);
+	tasklet_setup(&dmadev->task, hidma_issue_task);
 	hidma_debug_init(dmadev);
 	hidma_sysfs_init(dmadev);
 	dev_info(&pdev->dev, "HI-DMA engine driver registration complete\n");
diff --git a/drivers/dma/qcom/hidma_ll.c b/drivers/dma/qcom/hidma_ll.c
index bb4471e84e48..53244e0e34a3 100644
--- a/drivers/dma/qcom/hidma_ll.c
+++ b/drivers/dma/qcom/hidma_ll.c
@@ -173,9 +173,9 @@ int hidma_ll_request(struct hidma_lldev *lldev, u32 sig, const char *dev_name,
 /*
  * Multiple TREs may be queued and waiting in the pending queue.
  */
-static void hidma_ll_tre_complete(unsigned long arg)
+static void hidma_ll_tre_complete(struct tasklet_struct *t)
 {
-	struct hidma_lldev *lldev = (struct hidma_lldev *)arg;
+	struct hidma_lldev *lldev = from_tasklet(lldev, t, task);
 	struct hidma_tre *tre;
 
 	while (kfifo_out(&lldev->handoff_fifo, &tre, 1)) {
@@ -792,7 +792,7 @@ struct hidma_lldev *hidma_ll_init(struct device *dev, u32 nr_tres,
 		return NULL;
 
 	spin_lock_init(&lldev->lock);
-	tasklet_init(&lldev->task, hidma_ll_tre_complete, (unsigned long)lldev);
+	tasklet_setup(&lldev->task, hidma_ll_tre_complete);
 	lldev->initialized = 1;
 	writel(ENABLE_IRQS, lldev->evca + HIDMA_EVCA_IRQ_EN_REG);
 	return lldev;
diff --git a/drivers/dma/sa11x0-dma.c b/drivers/dma/sa11x0-dma.c
index afb68055ed1b..d972f63f5736 100644
--- a/drivers/dma/sa11x0-dma.c
+++ b/drivers/dma/sa11x0-dma.c
@@ -323,9 +323,9 @@ static void sa11x0_dma_start_txd(struct sa11x0_dma_chan *c)
 	}
 }
 
-static void sa11x0_dma_tasklet(unsigned long arg)
+static void sa11x0_dma_tasklet(struct tasklet_struct *t)
 {
-	struct sa11x0_dma_dev *d = (struct sa11x0_dma_dev *)arg;
+	struct sa11x0_dma_dev *d = from_tasklet(d, t, task);
 	struct sa11x0_dma_phy *p;
 	struct sa11x0_dma_chan *c;
 	unsigned pch, pch_alloc = 0;
@@ -928,7 +928,7 @@ static int sa11x0_dma_probe(struct platform_device *pdev)
 		goto err_ioremap;
 	}
 
-	tasklet_init(&d->task, sa11x0_dma_tasklet, (unsigned long)d);
+	tasklet_setup(&d->task, sa11x0_dma_tasklet);
 
 	for (i = 0; i < NR_PHY_CHAN; i++) {
 		struct sa11x0_dma_phy *p = &d->phy[i];
diff --git a/drivers/dma/sirf-dma.c b/drivers/dma/sirf-dma.c
index 30064689d67f..a5c2843384fd 100644
--- a/drivers/dma/sirf-dma.c
+++ b/drivers/dma/sirf-dma.c
@@ -393,9 +393,9 @@ static void sirfsoc_dma_process_completed(struct sirfsoc_dma *sdma)
 }
 
 /* DMA Tasklet */
-static void sirfsoc_dma_tasklet(unsigned long data)
+static void sirfsoc_dma_tasklet(struct tasklet_struct *t)
 {
-	struct sirfsoc_dma *sdma = (void *)data;
+	struct sirfsoc_dma *sdma = from_tasklet(sdma, t, tasklet);
 
 	sirfsoc_dma_process_completed(sdma);
 }
@@ -938,7 +938,7 @@ static int sirfsoc_dma_probe(struct platform_device *op)
 		list_add_tail(&schan->chan.device_node, &dma->channels);
 	}
 
-	tasklet_init(&sdma->tasklet, sirfsoc_dma_tasklet, (unsigned long)sdma);
+	tasklet_setup(&sdma->tasklet, sirfsoc_dma_tasklet);
 
 	/* Register DMA engine */
 	dev_set_drvdata(dev, sdma);
diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index de8bfd9a76e9..3b684e0ebe13 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1571,9 +1571,9 @@ static void dma_tc_handle(struct d40_chan *d40c)
 
 }
 
-static void dma_tasklet(unsigned long data)
+static void dma_tasklet(struct tasklet_struct *t)
 {
-	struct d40_chan *d40c = (struct d40_chan *) data;
+	struct d40_chan *d40c = from_tasklet(d40c, t, tasklet);
 	struct d40_desc *d40d;
 	unsigned long flags;
 	bool callback_active;
@@ -2804,8 +2804,7 @@ static void __init d40_chan_init(struct d40_base *base, struct dma_device *dma,
 		INIT_LIST_HEAD(&d40c->client);
 		INIT_LIST_HEAD(&d40c->prepare_queue);
 
-		tasklet_init(&d40c->tasklet, dma_tasklet,
-			     (unsigned long) d40c);
+		tasklet_setup(&d40c->tasklet, dma_tasklet);
 
 		list_add_tail(&d40c->chan.device_node,
 			      &dma->channels);
diff --git a/drivers/dma/sun6i-dma.c b/drivers/dma/sun6i-dma.c
index 06cd7f867f7c..f5f9c86c50bc 100644
--- a/drivers/dma/sun6i-dma.c
+++ b/drivers/dma/sun6i-dma.c
@@ -467,9 +467,9 @@ static int sun6i_dma_start_desc(struct sun6i_vchan *vchan)
 	return 0;
 }
 
-static void sun6i_dma_tasklet(unsigned long data)
+static void sun6i_dma_tasklet(struct tasklet_struct *t)
 {
-	struct sun6i_dma_dev *sdev = (struct sun6i_dma_dev *)data;
+	struct sun6i_dma_dev *sdev = from_tasklet(sdev, t, task);
 	struct sun6i_vchan *vchan;
 	struct sun6i_pchan *pchan;
 	unsigned int pchan_alloc = 0;
@@ -1343,7 +1343,7 @@ static int sun6i_dma_probe(struct platform_device *pdev)
 	if (!sdc->vchans)
 		return -ENOMEM;
 
-	tasklet_init(&sdc->task, sun6i_dma_tasklet, (unsigned long)sdc);
+	tasklet_setup(&sdc->task, sun6i_dma_tasklet);
 
 	for (i = 0; i < sdc->num_pchans; i++) {
 		struct sun6i_pchan *pchan = &sdc->pchans[i];
diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index 3a45079d11ec..74e1f5e5fa32 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -653,9 +653,9 @@ static void handle_cont_sngl_cycle_dma_done(struct tegra_dma_channel *tdc,
 	}
 }
 
-static void tegra_dma_tasklet(unsigned long data)
+static void tegra_dma_tasklet(struct tasklet_struct *t)
 {
-	struct tegra_dma_channel *tdc = (struct tegra_dma_channel *)data;
+	struct tegra_dma_channel *tdc = from_tasklet(tdc, t, tasklet);
 	struct dmaengine_desc_callback cb;
 	struct tegra_dma_desc *dma_desc;
 	unsigned long flags;
@@ -1476,8 +1476,7 @@ static int tegra_dma_probe(struct platform_device *pdev)
 		tdc->id = i;
 		tdc->slave_id = TEGRA_APBDMA_SLAVE_ID_INVALID;
 
-		tasklet_init(&tdc->tasklet, tegra_dma_tasklet,
-				(unsigned long)tdc);
+		tasklet_setup(&tdc->tasklet, tegra_dma_tasklet);
 		spin_lock_init(&tdc->lock);
 
 		INIT_LIST_HEAD(&tdc->pending_sg_req);
diff --git a/drivers/dma/timb_dma.c b/drivers/dma/timb_dma.c
index 39382694fdfc..936c639d7ca7 100644
--- a/drivers/dma/timb_dma.c
+++ b/drivers/dma/timb_dma.c
@@ -563,9 +563,9 @@ static int td_terminate_all(struct dma_chan *chan)
 	return 0;
 }
 
-static void td_tasklet(unsigned long data)
+static void td_tasklet(struct tasklet_struct *t)
 {
-	struct timb_dma *td = (struct timb_dma *)data;
+	struct timb_dma *td = from_tasklet(td, t, tasklet);
 	u32 isr;
 	u32 ipr;
 	u32 ier;
@@ -658,7 +658,7 @@ static int td_probe(struct platform_device *pdev)
 	iowrite32(0x0, td->membase + TIMBDMA_IER);
 	iowrite32(0xFFFFFFFF, td->membase + TIMBDMA_ISR);
 
-	tasklet_init(&td->tasklet, td_tasklet, (unsigned long)td);
+	tasklet_setup(&td->tasklet, td_tasklet);
 
 	err = request_irq(irq, td_irq, IRQF_SHARED, DRIVER_NAME, td);
 	if (err) {
diff --git a/drivers/dma/txx9dmac.c b/drivers/dma/txx9dmac.c
index 628bdf4430c7..5b6b375a257e 100644
--- a/drivers/dma/txx9dmac.c
+++ b/drivers/dma/txx9dmac.c
@@ -601,13 +601,13 @@ static void txx9dmac_scan_descriptors(struct txx9dmac_chan *dc)
 	}
 }
 
-static void txx9dmac_chan_tasklet(unsigned long data)
+static void txx9dmac_chan_tasklet(struct tasklet_struct *t)
 {
 	int irq;
 	u32 csr;
 	struct txx9dmac_chan *dc;
 
-	dc = (struct txx9dmac_chan *)data;
+	dc = from_tasklet(dc, t, tasklet);
 	csr = channel_readl(dc, CSR);
 	dev_vdbg(chan2dev(&dc->chan), "tasklet: status=%x\n", csr);
 
@@ -638,13 +638,13 @@ static irqreturn_t txx9dmac_chan_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static void txx9dmac_tasklet(unsigned long data)
+static void txx9dmac_tasklet(struct tasklet_struct *t)
 {
 	int irq;
 	u32 csr;
 	struct txx9dmac_chan *dc;
 
-	struct txx9dmac_dev *ddev = (struct txx9dmac_dev *)data;
+	struct txx9dmac_dev *ddev = from_tasklet(ddev, t, tasklet);
 	u32 mcr;
 	int i;
 
@@ -1113,8 +1113,7 @@ static int __init txx9dmac_chan_probe(struct platform_device *pdev)
 		irq = platform_get_irq(pdev, 0);
 		if (irq < 0)
 			return irq;
-		tasklet_init(&dc->tasklet, txx9dmac_chan_tasklet,
-				(unsigned long)dc);
+		tasklet_setup(&dc->tasklet, txx9dmac_chan_tasklet);
 		dc->irq = irq;
 		err = devm_request_irq(&pdev->dev, dc->irq,
 			txx9dmac_chan_interrupt, 0, dev_name(&pdev->dev), dc);
@@ -1200,8 +1199,7 @@ static int __init txx9dmac_probe(struct platform_device *pdev)
 
 	ddev->irq = platform_get_irq(pdev, 0);
 	if (ddev->irq >= 0) {
-		tasklet_init(&ddev->tasklet, txx9dmac_tasklet,
-				(unsigned long)ddev);
+		tasklet_setup(&ddev->tasklet, txx9dmac_tasklet);
 		err = devm_request_irq(&pdev->dev, ddev->irq,
 			txx9dmac_interrupt, 0, dev_name(&pdev->dev), ddev);
 		if (err)
diff --git a/drivers/dma/virt-dma.c b/drivers/dma/virt-dma.c
index ec4adf4260a0..fad88a41b657 100644
--- a/drivers/dma/virt-dma.c
+++ b/drivers/dma/virt-dma.c
@@ -80,9 +80,9 @@ EXPORT_SYMBOL_GPL(vchan_find_desc);
  * This tasklet handles the completion of a DMA descriptor by
  * calling its callback and freeing it.
  */
-static void vchan_complete(unsigned long arg)
+static void vchan_complete(struct tasklet_struct *t)
 {
-	struct virt_dma_chan *vc = (struct virt_dma_chan *)arg;
+	struct virt_dma_chan *vc = from_tasklet(vc, t, task);
 	struct virt_dma_desc *vd, *_vd;
 	struct dmaengine_desc_callback cb;
 	LIST_HEAD(head);
@@ -136,7 +136,7 @@ void vchan_init(struct virt_dma_chan *vc, struct dma_device *dmadev)
 	INIT_LIST_HEAD(&vc->desc_issued);
 	INIT_LIST_HEAD(&vc->desc_completed);
 
-	tasklet_init(&vc->task, vchan_complete, (unsigned long)vc);
+	tasklet_setup(&vc->task, vchan_complete);
 
 	vc->chan.device = dmadev;
 	list_add_tail(&vc->chan.device_node, &dmadev->channels);
diff --git a/drivers/dma/xgene-dma.c b/drivers/dma/xgene-dma.c
index cd60fa6d6750..1c70b74c25d1 100644
--- a/drivers/dma/xgene-dma.c
+++ b/drivers/dma/xgene-dma.c
@@ -973,9 +973,9 @@ static enum dma_status xgene_dma_tx_status(struct dma_chan *dchan,
 	return dma_cookie_status(dchan, cookie, txstate);
 }
 
-static void xgene_dma_tasklet_cb(unsigned long data)
+static void xgene_dma_tasklet_cb(struct tasklet_struct *t)
 {
-	struct xgene_dma_chan *chan = (struct xgene_dma_chan *)data;
+	struct xgene_dma_chan *chan = from_tasklet(chan, t, tasklet);
 
 	/* Run all cleanup for descriptors which have been completed */
 	xgene_dma_cleanup_descriptors(chan);
@@ -1537,8 +1537,7 @@ static int xgene_dma_async_register(struct xgene_dma *pdma, int id)
 	INIT_LIST_HEAD(&chan->ld_pending);
 	INIT_LIST_HEAD(&chan->ld_running);
 	INIT_LIST_HEAD(&chan->ld_completed);
-	tasklet_init(&chan->tasklet, xgene_dma_tasklet_cb,
-		     (unsigned long)chan);
+	tasklet_setup(&chan->tasklet, xgene_dma_tasklet_cb);
 
 	chan->pending = 0;
 	chan->desc_pool = NULL;
diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index e7dc3c4dc8e0..3a8d9d4c0056 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -850,9 +850,9 @@ static void xilinx_dma_chan_desc_cleanup(struct xilinx_dma_chan *chan)
  * xilinx_dma_do_tasklet - Schedule completion tasklet
  * @data: Pointer to the Xilinx DMA channel structure
  */
-static void xilinx_dma_do_tasklet(unsigned long data)
+static void xilinx_dma_do_tasklet(struct tasklet_struct *t)
 {
-	struct xilinx_dma_chan *chan = (struct xilinx_dma_chan *)data;
+	struct xilinx_dma_chan *chan = from_tasklet(chan, t, tasklet);
 
 	xilinx_dma_chan_desc_cleanup(chan);
 }
@@ -2499,8 +2499,7 @@ static int xilinx_dma_chan_probe(struct xilinx_dma_device *xdev,
 	}
 
 	/* Initialize the tasklet */
-	tasklet_init(&chan->tasklet, xilinx_dma_do_tasklet,
-			(unsigned long)chan);
+	tasklet_setup(&chan->tasklet, xilinx_dma_do_tasklet);
 
 	/*
 	 * Initialize the DMA channel and add it to the DMA engine channels
diff --git a/drivers/dma/xilinx/zynqmp_dma.c b/drivers/dma/xilinx/zynqmp_dma.c
index 9c845c07b107..968fa7538aaa 100644
--- a/drivers/dma/xilinx/zynqmp_dma.c
+++ b/drivers/dma/xilinx/zynqmp_dma.c
@@ -739,9 +739,9 @@ static irqreturn_t zynqmp_dma_irq_handler(int irq, void *data)
  * zynqmp_dma_do_tasklet - Schedule completion tasklet
  * @data: Pointer to the ZynqMP DMA channel structure
  */
-static void zynqmp_dma_do_tasklet(unsigned long data)
+static void zynqmp_dma_do_tasklet(struct tasklet_struct *t)
 {
-	struct zynqmp_dma_chan *chan = (struct zynqmp_dma_chan *)data;
+	struct zynqmp_dma_chan *chan = from_tasklet(chan, t, tasklet);
 	u32 count;
 	unsigned long irqflags;
 
@@ -903,7 +903,7 @@ static int zynqmp_dma_chan_probe(struct zynqmp_dma_device *zdev,
 
 	chan->is_dmacoherent =  of_property_read_bool(node, "dma-coherent");
 	zdev->chan = chan;
-	tasklet_init(&chan->tasklet, zynqmp_dma_do_tasklet, (ulong)chan);
+	tasklet_setup(&chan->tasklet, zynqmp_dma_do_tasklet);
 	spin_lock_init(&chan->lock);
 	INIT_LIST_HEAD(&chan->active_list);
 	INIT_LIST_HEAD(&chan->pending_list);
diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 522f3addb5bd..3887ea7c2e03 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -921,9 +921,9 @@ static void ar_recycle_buffers(struct ar_context *ctx, unsigned int end_buffer)
 	}
 }
 
-static void ar_context_tasklet(unsigned long data)
+static void ar_context_tasklet(struct tasklet_struct *t)
 {
-	struct ar_context *ctx = (struct ar_context *)data;
+	struct ar_context *ctx = from_tasklet(ctx, t, tasklet);
 	unsigned int end_buffer_index, end_buffer_offset;
 	void *p, *end;
 
@@ -977,7 +977,7 @@ static int ar_context_init(struct ar_context *ctx, struct fw_ohci *ohci,
 
 	ctx->regs        = regs;
 	ctx->ohci        = ohci;
-	tasklet_init(&ctx->tasklet, ar_context_tasklet, (unsigned long)ctx);
+	tasklet_setup(&ctx->tasklet, ar_context_tasklet);
 
 	for (i = 0; i < AR_BUFFERS; i++) {
 		ctx->pages[i] = alloc_page(GFP_KERNEL | GFP_DMA32);
@@ -1049,9 +1049,9 @@ static struct descriptor *find_branch_descriptor(struct descriptor *d, int z)
 		return d + z - 1;
 }
 
-static void context_tasklet(unsigned long data)
+static void context_tasklet(struct tasklet_struct *t)
 {
-	struct context *ctx = (struct context *) data;
+	struct context *ctx = from_tasklet(ctx, t, tasklet);
 	struct descriptor *d, *last;
 	u32 address;
 	int z;
@@ -1145,7 +1145,7 @@ static int context_init(struct context *ctx, struct fw_ohci *ohci,
 	ctx->buffer_tail = list_entry(ctx->buffer_list.next,
 			struct descriptor_buffer, list);
 
-	tasklet_init(&ctx->tasklet, context_tasklet, (unsigned long)ctx);
+	tasklet_setup(&ctx->tasklet, context_tasklet);
 	ctx->callback = callback;
 
 	/*
@@ -1420,7 +1420,7 @@ static void at_context_flush(struct context *ctx)
 	tasklet_disable(&ctx->tasklet);
 
 	ctx->flushing = true;
-	context_tasklet((unsigned long)ctx);
+	context_tasklet(&ctx->tasklet);
 	ctx->flushing = false;
 
 	tasklet_enable(&ctx->tasklet);
@@ -3472,7 +3472,7 @@ static int ohci_flush_iso_completions(struct fw_iso_context *base)
 	tasklet_disable(&ctx->context.tasklet);
 
 	if (!test_and_set_bit_lock(0, &ctx->flushing_completions)) {
-		context_tasklet((unsigned long)&ctx->context);
+		context_tasklet(&ctx->context.tasklet);
 
 		switch (base->type) {
 		case FW_ISO_CONTEXT_TRANSMIT:
diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index e09404f2de79..d630dbc953ad 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -1600,9 +1600,9 @@ static void __execlists_submission_tasklet(struct intel_engine_cs *const engine)
  * Check the unread Context Status Buffers and manage the submission of new
  * contexts to the ELSP accordingly.
  */
-static void execlists_submission_tasklet(unsigned long data)
+static void execlists_submission_tasklet(struct tasklet_struct *t)
 {
-	struct intel_engine_cs * const engine = (struct intel_engine_cs *)data;
+	struct intel_engine_cs * const engine = from_tasklet(engine, t, execlists.tasklet);
 	unsigned long flags;
 
 	process_csb(engine);
@@ -1637,7 +1637,7 @@ static void __submit_queue_imm(struct intel_engine_cs *engine)
 	if (reset_in_progress(execlists))
 		return; /* defer until we restart the engine following reset */
 
-	if (execlists->tasklet.func == execlists_submission_tasklet)
+	if (execlists->tasklet.func == (TASKLET_FUNC_TYPE)execlists_submission_tasklet)
 		__execlists_submission_tasklet(engine);
 	else
 		tasklet_hi_schedule(&execlists->tasklet);
@@ -2518,7 +2518,7 @@ static void execlists_reset(struct intel_engine_cs *engine, bool stalled)
 	spin_unlock_irqrestore(&engine->active.lock, flags);
 }
 
-static void nop_submission_tasklet(unsigned long data)
+static void nop_submission_tasklet(struct tasklet_struct *unused)
 {
 	/* The driver is wedged; don't process any more events. */
 }
@@ -2600,7 +2600,7 @@ static void execlists_cancel_requests(struct intel_engine_cs *engine)
 	execlists->queue = RB_ROOT_CACHED;
 
 	GEM_BUG_ON(__tasklet_is_enabled(&execlists->tasklet));
-	execlists->tasklet.func = nop_submission_tasklet;
+	execlists->tasklet.func = (TASKLET_FUNC_TYPE)nop_submission_tasklet;
 
 	spin_unlock_irqrestore(&engine->active.lock, flags);
 }
@@ -2956,7 +2956,7 @@ void intel_execlists_set_default_submission(struct intel_engine_cs *engine)
 	engine->submit_request = execlists_submit_request;
 	engine->cancel_requests = execlists_cancel_requests;
 	engine->schedule = i915_schedule;
-	engine->execlists.tasklet.func = execlists_submission_tasklet;
+	engine->execlists.tasklet.func = (TASKLET_FUNC_TYPE)execlists_submission_tasklet;
 
 	engine->reset.prepare = execlists_reset_prepare;
 	engine->reset.reset = execlists_reset;
@@ -3056,8 +3056,8 @@ static void rcs_submission_override(struct intel_engine_cs *engine)
 
 int intel_execlists_submission_setup(struct intel_engine_cs *engine)
 {
-	tasklet_init(&engine->execlists.tasklet,
-		     execlists_submission_tasklet, (unsigned long)engine);
+	tasklet_setup(&engine->execlists.tasklet,
+		      execlists_submission_tasklet);
 	timer_setup(&engine->execlists.timer, execlists_submission_timer, 0);
 
 	logical_ring_default_vfuncs(engine);
@@ -3510,9 +3510,9 @@ static intel_engine_mask_t virtual_submission_mask(struct virtual_engine *ve)
 	return mask;
 }
 
-static void virtual_submission_tasklet(unsigned long data)
+static void virtual_submission_tasklet(struct tasklet_struct *t)
 {
-	struct virtual_engine * const ve = (struct virtual_engine *)data;
+	struct virtual_engine * ve = from_tasklet(ve, t, base.execlists.tasklet);
 	const int prio = ve->base.execlists.queue_priority_hint;
 	intel_engine_mask_t mask;
 	unsigned int n;
@@ -3700,9 +3700,7 @@ intel_execlists_create_virtual(struct i915_gem_context *ctx,
 
 	INIT_LIST_HEAD(virtual_queue(ve));
 	ve->base.execlists.queue_priority_hint = INT_MIN;
-	tasklet_init(&ve->base.execlists.tasklet,
-		     virtual_submission_tasklet,
-		     (unsigned long)ve);
+	tasklet_setup(&ve->base.execlists.tasklet, virtual_submission_tasklet);
 
 	intel_context_init(&ve->context, ctx, &ve->base);
 
@@ -3725,7 +3723,7 @@ intel_execlists_create_virtual(struct i915_gem_context *ctx,
 		 * submitting a copy into each backend.
 		 */
 		if (sibling->execlists.tasklet.func !=
-		    execlists_submission_tasklet) {
+		    (TASKLET_FUNC_TYPE)execlists_submission_tasklet) {
 			err = -ENODEV;
 			goto err_put;
 		}
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
index f325d3dd564f..615ed19d2aeb 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -594,9 +594,10 @@ static void __guc_dequeue(struct intel_engine_cs *engine)
 	execlists->active = execlists->inflight;
 }
 
-static void guc_submission_tasklet(unsigned long data)
+static void guc_submission_tasklet(struct tasklet_struct *t)
 {
-	struct intel_engine_cs * const engine = (struct intel_engine_cs *)data;
+	struct intel_engine_cs * const engine = from_tasklet(engine, t,
+						execlists.tasklet);
 	struct intel_engine_execlists * const execlists = &engine->execlists;
 	struct i915_request **port, *rq;
 	unsigned long flags;
@@ -1089,7 +1090,7 @@ static void guc_set_default_submission(struct intel_engine_cs *engine)
 	 */
 	intel_execlists_set_default_submission(engine);
 
-	engine->execlists.tasklet.func = guc_submission_tasklet;
+	engine->execlists.tasklet.func = (TASKLET_FUNC_TYPE)guc_submission_tasklet;
 
 	/* do not use execlists park/unpark */
 	engine->park = engine->unpark = NULL;
diff --git a/drivers/hsi/clients/nokia-modem.c b/drivers/hsi/clients/nokia-modem.c
index cd7ebf4c2e2f..1936314d3bed 100644
--- a/drivers/hsi/clients/nokia-modem.c
+++ b/drivers/hsi/clients/nokia-modem.c
@@ -36,9 +36,10 @@ struct nokia_modem_device {
 	struct hsi_client	*cmt_speech;
 };
 
-static void do_nokia_modem_rst_ind_tasklet(unsigned long data)
+static void do_nokia_modem_rst_ind_tasklet(struct tasklet_struct *t)
 {
-	struct nokia_modem_device *modem = (struct nokia_modem_device *)data;
+	struct nokia_modem_device *modem = from_tasklet(modem, t,
+						        nokia_modem_rst_ind_tasklet);
 
 	if (!modem)
 		return;
@@ -155,8 +156,8 @@ static int nokia_modem_probe(struct device *dev)
 	modem->nokia_modem_rst_ind_irq = irq;
 	pflags = irq_get_trigger_type(irq);
 
-	tasklet_init(&modem->nokia_modem_rst_ind_tasklet,
-			do_nokia_modem_rst_ind_tasklet, (unsigned long)modem);
+	tasklet_setup(&modem->nokia_modem_rst_ind_tasklet,
+		      do_nokia_modem_rst_ind_tasklet);
 	err = devm_request_irq(dev, irq, nokia_modem_rst_ind_isr,
 				pflags, "modem_rst_ind", modem);
 	if (err < 0) {
diff --git a/drivers/hsi/controllers/omap_ssi_core.c b/drivers/hsi/controllers/omap_ssi_core.c
index 4bc4a201f0f6..317e9b162681 100644
--- a/drivers/hsi/controllers/omap_ssi_core.c
+++ b/drivers/hsi/controllers/omap_ssi_core.c
@@ -215,10 +215,10 @@ static void ssi_gdd_complete(struct hsi_controller *ssi, unsigned int lch)
 	msg->actual_len = sg_dma_len(msg->sgt.sgl);
 }
 
-static void ssi_gdd_tasklet(unsigned long dev)
+static void ssi_gdd_tasklet(struct tasklet_struct *t)
 {
-	struct hsi_controller *ssi = (struct hsi_controller *)dev;
-	struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
+	struct omap_ssi_controller *omap_ssi = from_tasklet(omap_ssi, t, gdd_tasklet);
+	struct hsi_controller *ssi = container_of(omap_ssi->dev, typeof(*ssi), device);
 	void __iomem *sys = omap_ssi->sys;
 	unsigned int lch;
 	u32 status_reg;
@@ -373,8 +373,7 @@ static int ssi_add_controller(struct hsi_controller *ssi,
 	if (err < 0)
 		goto out_err;
 	omap_ssi->gdd_irq = err;
-	tasklet_init(&omap_ssi->gdd_tasklet, ssi_gdd_tasklet,
-							(unsigned long)ssi);
+	tasklet_setup(&omap_ssi->gdd_tasklet, ssi_gdd_tasklet);
 	err = devm_request_irq(&ssi->device, omap_ssi->gdd_irq, ssi_gdd_isr,
 						0, "gdd_mpu", ssi);
 	if (err < 0) {
diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index 8eb167540b4f..15b70de05f3b 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -321,8 +321,7 @@ static struct vmbus_channel *alloc_channel(void)
 	INIT_LIST_HEAD(&channel->sc_list);
 	INIT_LIST_HEAD(&channel->percpu_list);
 
-	tasklet_init(&channel->callback_event,
-		     vmbus_on_event, (unsigned long)channel);
+	tasklet_setup(&channel->callback_event, vmbus_on_event);
 
 	hv_ringbuffer_pre_init(channel);
 
diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 6e4c015783ff..78c219a2dfbb 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -354,9 +354,9 @@ struct vmbus_channel *relid2channel(u32 relid)
  *    If this tasklet has been running for a long time
  *    then reschedule ourselves.
  */
-void vmbus_on_event(unsigned long data)
+void vmbus_on_event(struct tasklet_struct *t)
 {
-	struct vmbus_channel *channel = (void *) data;
+	struct vmbus_channel *channel = from_tasklet(channel, t, callback_event);
 	unsigned long time_limit = jiffies + 2;
 
 	trace_vmbus_on_event(channel);
diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index fcc52797c169..7815c966e099 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -96,8 +96,7 @@ int hv_synic_alloc(void)
 	for_each_present_cpu(cpu) {
 		hv_cpu = per_cpu_ptr(hv_context.cpu_context, cpu);
 
-		tasklet_init(&hv_cpu->msg_dpc,
-			     vmbus_on_msg_dpc, (unsigned long) hv_cpu);
+		tasklet_setup(&hv_cpu->msg_dpc, vmbus_on_msg_dpc);
 
 		hv_cpu->synic_message_page =
 			(void *)get_zeroed_page(GFP_ATOMIC);
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index af9379a3bf89..7a93ea02609c 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -347,8 +347,8 @@ void vmbus_disconnect(void);
 
 int vmbus_post_msg(void *buffer, size_t buflen, bool can_sleep);
 
-void vmbus_on_event(unsigned long data);
-void vmbus_on_msg_dpc(unsigned long data);
+void vmbus_on_event(struct tasklet_struct *t);
+void vmbus_on_msg_dpc(struct tasklet_struct *t);
 
 int hv_kvp_init(struct hv_util_service *srv);
 void hv_kvp_deinit(void);
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 391f0b225c9a..f885f62d8c5c 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -1004,9 +1004,9 @@ static void vmbus_onmessage_work(struct work_struct *work)
 	kfree(ctx);
 }
 
-void vmbus_on_msg_dpc(unsigned long data)
+void vmbus_on_msg_dpc(struct tasklet_struct *t)
 {
-	struct hv_per_cpu_context *hv_cpu = (void *)data;
+	struct hv_per_cpu_context *hv_cpu = from_tasklet(hv_cpu, t, msg_dpc);
 	void *page_addr = hv_cpu->synic_message_page;
 	struct hv_message *msg = (struct hv_message *)page_addr +
 				  VMBUS_MESSAGE_SINT;
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index 958c1ff9c515..4289c82271dd 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -233,9 +233,9 @@ static int bnxt_qplib_alloc_qp_hdr_buf(struct bnxt_qplib_res *res,
 	return rc;
 }
 
-static void bnxt_qplib_service_nq(unsigned long data)
+static void bnxt_qplib_service_nq(struct tasklet_struct *t)
 {
-	struct bnxt_qplib_nq *nq = (struct bnxt_qplib_nq *)data;
+	struct bnxt_qplib_nq *nq = from_tasklet(nq, t, worker);
 	struct bnxt_qplib_hwq *hwq = &nq->hwq;
 	struct nq_base *nqe, **nq_ptr;
 	struct bnxt_qplib_cq *cq;
@@ -387,8 +387,7 @@ int bnxt_qplib_nq_start_irq(struct bnxt_qplib_nq *nq, int nq_indx,
 
 	nq->vector = msix_vector;
 	if (need_init)
-		tasklet_init(&nq->worker, bnxt_qplib_service_nq,
-			     (unsigned long)nq);
+		tasklet_setup(&nq->worker, bnxt_qplib_service_nq);
 	else
 		tasklet_enable(&nq->worker);
 
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
index 60c8f76aab33..53d3c68e5ce8 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
@@ -50,7 +50,7 @@
 #include "qplib_sp.h"
 #include "qplib_fp.h"
 
-static void bnxt_qplib_service_creq(unsigned long data);
+static void bnxt_qplib_service_creq(struct tasklet_struct *t);
 
 /* Hardware communication channel */
 static int __wait_for_resp(struct bnxt_qplib_rcfw *rcfw, u16 cookie)
@@ -75,7 +75,7 @@ static int __block_for_resp(struct bnxt_qplib_rcfw *rcfw, u16 cookie)
 		goto done;
 	do {
 		mdelay(1); /* 1m sec */
-		bnxt_qplib_service_creq((unsigned long)rcfw);
+		bnxt_qplib_service_creq(&rcfw->worker);
 	} while (test_bit(cbit, rcfw->cmdq_bitmap) && --count);
 done:
 	return count ? 0 : -ETIMEDOUT;
@@ -362,9 +362,9 @@ static int bnxt_qplib_process_qp_event(struct bnxt_qplib_rcfw *rcfw,
 }
 
 /* SP - CREQ Completion handlers */
-static void bnxt_qplib_service_creq(unsigned long data)
+static void bnxt_qplib_service_creq(struct tasklet_struct *t)
 {
-	struct bnxt_qplib_rcfw *rcfw = (struct bnxt_qplib_rcfw *)data;
+	struct bnxt_qplib_rcfw *rcfw = from_tasklet(rcfw, t, worker);
 	bool gen_p5 = bnxt_qplib_is_chip_gen_p5(rcfw->res->cctx);
 	struct bnxt_qplib_hwq *creq = &rcfw->creq;
 	u32 type, budget = CREQ_ENTRY_POLL_BUDGET;
@@ -671,8 +671,7 @@ int bnxt_qplib_rcfw_start_irq(struct bnxt_qplib_rcfw *rcfw, int msix_vector,
 
 	rcfw->vector = msix_vector;
 	if (need_init)
-		tasklet_init(&rcfw->worker,
-			     bnxt_qplib_service_creq, (unsigned long)rcfw);
+		tasklet_setup(&rcfw->worker, bnxt_qplib_service_creq);
 	else
 		tasklet_enable(&rcfw->worker);
 	rc = request_irq(rcfw->vector, bnxt_qplib_creq_irq, 0,
diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index 2395fd4233a7..6b9d055353e4 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -231,11 +231,11 @@ static const struct sdma_set_state_action sdma_action_table[] = {
 static void sdma_complete(struct kref *);
 static void sdma_finalput(struct sdma_state *);
 static void sdma_get(struct sdma_state *);
-static void sdma_hw_clean_up_task(unsigned long);
+static void sdma_hw_clean_up_task(struct tasklet_struct *);
 static void sdma_put(struct sdma_state *);
 static void sdma_set_state(struct sdma_engine *, enum sdma_states);
 static void sdma_start_hw_clean_up(struct sdma_engine *);
-static void sdma_sw_clean_up_task(unsigned long);
+static void sdma_sw_clean_up_task(struct tasklet_struct *);
 static void sdma_sendctrl(struct sdma_engine *, unsigned);
 static void init_sdma_regs(struct sdma_engine *, u32, uint);
 static void sdma_process_event(
@@ -544,9 +544,9 @@ static void sdma_err_progress_check(struct timer_list *t)
 	schedule_work(&sde->err_halt_worker);
 }
 
-static void sdma_hw_clean_up_task(unsigned long opaque)
+static void sdma_hw_clean_up_task(struct tasklet_struct *t)
 {
-	struct sdma_engine *sde = (struct sdma_engine *)opaque;
+	struct sdma_engine *sde = from_tasklet(sde, t, sdma_hw_clean_up_task);
 	u64 statuscsr;
 
 	while (1) {
@@ -603,9 +603,9 @@ static void sdma_flush_descq(struct sdma_engine *sde)
 		sdma_desc_avail(sde, sdma_descq_freecnt(sde));
 }
 
-static void sdma_sw_clean_up_task(unsigned long opaque)
+static void sdma_sw_clean_up_task(struct tasklet_struct *t)
 {
-	struct sdma_engine *sde = (struct sdma_engine *)opaque;
+	struct sdma_engine *sde = from_tasklet(sde, t, sdma_sw_clean_up_task);
 	unsigned long flags;
 
 	spin_lock_irqsave(&sde->tail_lock, flags);
@@ -1453,11 +1453,11 @@ int sdma_init(struct hfi1_devdata *dd, u8 port)
 		sde->tail_csr =
 			get_kctxt_csr_addr(dd, this_idx, SD(TAIL));
 
-		tasklet_init(&sde->sdma_hw_clean_up_task, sdma_hw_clean_up_task,
-			     (unsigned long)sde);
+		tasklet_setup(&sde->sdma_hw_clean_up_task,
+			      sdma_hw_clean_up_task);
 
-		tasklet_init(&sde->sdma_sw_clean_up_task, sdma_sw_clean_up_task,
-			     (unsigned long)sde);
+		tasklet_setup(&sde->sdma_sw_clean_up_task,
+			      sdma_sw_clean_up_task);
 		INIT_WORK(&sde->err_halt_worker, sdma_err_halt_wait);
 		INIT_WORK(&sde->flush_worker, sdma_field_flush);
 
diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
index d44cf33df81a..494ef2e5d3de 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_main.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
@@ -192,9 +192,9 @@ static void i40iw_enable_intr(struct i40iw_sc_dev *dev, u32 msix_id)
  * i40iw_dpc - tasklet for aeq and ceq 0
  * @data: iwarp device
  */
-static void i40iw_dpc(unsigned long data)
+static void i40iw_dpc(struct tasklet_struct *t)
 {
-	struct i40iw_device *iwdev = (struct i40iw_device *)data;
+	struct i40iw_device *iwdev = from_tasklet(iwdev, t, dpc_tasklet);
 
 	if (iwdev->msix_shared)
 		i40iw_process_ceq(iwdev, iwdev->ceqlist);
@@ -206,9 +206,9 @@ static void i40iw_dpc(unsigned long data)
  * i40iw_ceq_dpc - dpc handler for CEQ
  * @data: data points to CEQ
  */
-static void i40iw_ceq_dpc(unsigned long data)
+static void i40iw_ceq_dpc(struct tasklet_struct *t)
 {
-	struct i40iw_ceq *iwceq = (struct i40iw_ceq *)data;
+	struct i40iw_ceq *iwceq = from_tasklet(iwceq, t, dpc_tasklet);
 	struct i40iw_device *iwdev = iwceq->iwdev;
 
 	i40iw_process_ceq(iwdev, iwceq);
@@ -689,10 +689,10 @@ static enum i40iw_status_code i40iw_configure_ceq_vector(struct i40iw_device *iw
 	enum i40iw_status_code status;
 
 	if (iwdev->msix_shared && !ceq_id) {
-		tasklet_init(&iwdev->dpc_tasklet, i40iw_dpc, (unsigned long)iwdev);
+		tasklet_setup(&iwdev->dpc_tasklet, i40iw_dpc);
 		status = request_irq(msix_vec->irq, i40iw_irq_handler, 0, "AEQCEQ", iwdev);
 	} else {
-		tasklet_init(&iwceq->dpc_tasklet, i40iw_ceq_dpc, (unsigned long)iwceq);
+		tasklet_setup(&iwceq->dpc_tasklet, i40iw_ceq_dpc);
 		status = request_irq(msix_vec->irq, i40iw_ceq_handler, 0, "CEQ", iwceq);
 	}
 
@@ -841,7 +841,7 @@ static enum i40iw_status_code i40iw_configure_aeq_vector(struct i40iw_device *iw
 	u32 ret = 0;
 
 	if (!iwdev->msix_shared) {
-		tasklet_init(&iwdev->dpc_tasklet, i40iw_dpc, (unsigned long)iwdev);
+		tasklet_setup(&iwdev->dpc_tasklet, i40iw_dpc);
 		ret = request_irq(msix_vec->irq, i40iw_irq_handler, 0, "i40iw", iwdev);
 	}
 	if (ret) {
diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index dd4843379f51..88544c638c41 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -1733,9 +1733,9 @@ static noinline void handle_7322_errors(struct qib_devdata *dd)
 	return;
 }
 
-static void qib_error_tasklet(unsigned long data)
+static void qib_error_tasklet(struct tasklet_struct *t)
 {
-	struct qib_devdata *dd = (struct qib_devdata *)data;
+	struct qib_devdata *dd = from_tasklet(dd, t, error_tasklet);
 
 	handle_7322_errors(dd);
 	qib_write_kreg(dd, kr_errmask, dd->cspec->errormask);
@@ -3538,8 +3538,7 @@ static void qib_setup_7322_interrupt(struct qib_devdata *dd, int clearpend)
 	for (i = 0; i < ARRAY_SIZE(redirect); i++)
 		qib_write_kreg(dd, kr_intredirect + i, redirect[i]);
 	dd->cspec->main_int_mask = mask;
-	tasklet_init(&dd->error_tasklet, qib_error_tasklet,
-		(unsigned long)dd);
+	tasklet_setup(&dd->error_tasklet, qib_error_tasklet);
 }
 
 /**
diff --git a/drivers/infiniband/hw/qib/qib_sdma.c b/drivers/infiniband/hw/qib/qib_sdma.c
index 99e11c347130..eece0d4ce6c7 100644
--- a/drivers/infiniband/hw/qib/qib_sdma.c
+++ b/drivers/infiniband/hw/qib/qib_sdma.c
@@ -62,7 +62,7 @@ static void sdma_get(struct qib_sdma_state *);
 static void sdma_put(struct qib_sdma_state *);
 static void sdma_set_state(struct qib_pportdata *, enum qib_sdma_states);
 static void sdma_start_sw_clean_up(struct qib_pportdata *);
-static void sdma_sw_clean_up_task(unsigned long);
+static void sdma_sw_clean_up_task(struct tasklet_struct *);
 static void unmap_desc(struct qib_pportdata *, unsigned);
 
 static void sdma_get(struct qib_sdma_state *ss)
@@ -119,9 +119,10 @@ static void clear_sdma_activelist(struct qib_pportdata *ppd)
 	}
 }
 
-static void sdma_sw_clean_up_task(unsigned long opaque)
+static void sdma_sw_clean_up_task(struct tasklet_struct *t)
 {
-	struct qib_pportdata *ppd = (struct qib_pportdata *) opaque;
+	struct qib_pportdata *ppd = from_tasklet(ppd, t,
+						 sdma_sw_clean_up_task);
 	unsigned long flags;
 
 	spin_lock_irqsave(&ppd->sdma_lock, flags);
@@ -436,8 +437,7 @@ int qib_setup_sdma(struct qib_pportdata *ppd)
 
 	INIT_LIST_HEAD(&ppd->sdma_activelist);
 
-	tasklet_init(&ppd->sdma_sw_clean_up_task, sdma_sw_clean_up_task,
-		(unsigned long)ppd);
+	tasklet_setup(&ppd->sdma_sw_clean_up_task, sdma_sw_clean_up_task);
 
 	ret = dd->f_init_sdma_regs(ppd);
 	if (ret)
diff --git a/drivers/infiniband/sw/rxe/rxe_cq.c b/drivers/infiniband/sw/rxe/rxe_cq.c
index ad3090131126..f232fd03d19a 100644
--- a/drivers/infiniband/sw/rxe/rxe_cq.c
+++ b/drivers/infiniband/sw/rxe/rxe_cq.c
@@ -66,9 +66,9 @@ int rxe_cq_chk_attr(struct rxe_dev *rxe, struct rxe_cq *cq,
 	return -EINVAL;
 }
 
-static void rxe_send_complete(unsigned long data)
+static void rxe_send_complete(struct tasklet_struct *t)
 {
-	struct rxe_cq *cq = (struct rxe_cq *)data;
+	struct rxe_cq *cq = from_tasklet(cq, t, comp_task);
 	unsigned long flags;
 
 	spin_lock_irqsave(&cq->cq_lock, flags);
@@ -107,7 +107,7 @@ int rxe_cq_from_init(struct rxe_dev *rxe, struct rxe_cq *cq, int cqe,
 
 	cq->is_dying = false;
 
-	tasklet_init(&cq->comp_task, rxe_send_complete, (unsigned long)cq);
+	tasklet_setup(&cq->comp_task, rxe_send_complete);
 
 	spin_lock_init(&cq->cq_lock);
 	cq->ibcq.cqe = cqe;
diff --git a/drivers/infiniband/sw/rxe/rxe_task.c b/drivers/infiniband/sw/rxe/rxe_task.c
index 08f05ac5f5d5..f7c944d2f987 100644
--- a/drivers/infiniband/sw/rxe/rxe_task.c
+++ b/drivers/infiniband/sw/rxe/rxe_task.c
@@ -55,12 +55,12 @@ int __rxe_do_task(struct rxe_task *task)
  * a second caller finds the task already running
  * but looks just after the last call to func
  */
-void rxe_do_task(unsigned long data)
+void rxe_do_task(struct tasklet_struct *t)
 {
 	int cont;
 	int ret;
 	unsigned long flags;
-	struct rxe_task *task = (struct rxe_task *)data;
+	struct rxe_task *task = from_tasklet(task, t, tasklet);
 
 	spin_lock_irqsave(&task->state_lock, flags);
 	switch (task->state) {
@@ -123,7 +123,7 @@ int rxe_init_task(void *obj, struct rxe_task *task,
 	snprintf(task->name, sizeof(task->name), "%s", name);
 	task->destroyed	= false;
 
-	tasklet_init(&task->tasklet, rxe_do_task, (unsigned long)task);
+	tasklet_setup(&task->tasklet, rxe_do_task);
 
 	task->state = TASK_STATE_START;
 	spin_lock_init(&task->state_lock);
@@ -159,7 +159,7 @@ void rxe_run_task(struct rxe_task *task, int sched)
 	if (sched)
 		tasklet_schedule(&task->tasklet);
 	else
-		rxe_do_task((unsigned long)task);
+		rxe_do_task(&task->tasklet);
 }
 
 void rxe_disable_task(struct rxe_task *task)
diff --git a/drivers/infiniband/sw/rxe/rxe_task.h b/drivers/infiniband/sw/rxe/rxe_task.h
index 08ff42d451c6..f69fbb2dd09f 100644
--- a/drivers/infiniband/sw/rxe/rxe_task.h
+++ b/drivers/infiniband/sw/rxe/rxe_task.h
@@ -80,7 +80,7 @@ int __rxe_do_task(struct rxe_task *task);
  * work to do someone must reschedule the task before
  * leaving
  */
-void rxe_do_task(unsigned long data);
+void rxe_do_task(struct tasklet_struct *t);
 
 /* run a task, else schedule it to run as a tasklet, The decision
  * to run or schedule tasklet is based on the parameter sched.
diff --git a/drivers/input/serio/hp_sdc.c b/drivers/input/serio/hp_sdc.c
index 654252361653..60ba94abde86 100644
--- a/drivers/input/serio/hp_sdc.c
+++ b/drivers/input/serio/hp_sdc.c
@@ -301,7 +301,7 @@ static irqreturn_t hp_sdc_nmisr(int irq, void *dev_id)
 
 unsigned long hp_sdc_put(void);
 
-static void hp_sdc_tasklet(unsigned long foo)
+static void hp_sdc_tasklet(struct tasklet_struct *unused)
 {
 	write_lock_irq(&hp_sdc.rtq_lock);
 
@@ -890,7 +890,7 @@ static int __init hp_sdc_init(void)
 	hp_sdc_status_in8();
 	hp_sdc_data_in8();
 
-	tasklet_init(&hp_sdc.task, hp_sdc_tasklet, 0);
+	tasklet_setup(&hp_sdc.task, hp_sdc_tasklet);
 
 	/* Sync the output buffer registers, thus scheduling hp_sdc_tasklet. */
 	t_sync.actidx	= 0;
diff --git a/drivers/mailbox/bcm-pdc-mailbox.c b/drivers/mailbox/bcm-pdc-mailbox.c
index fcb3b18a0678..5c9375f9ab64 100644
--- a/drivers/mailbox/bcm-pdc-mailbox.c
+++ b/drivers/mailbox/bcm-pdc-mailbox.c
@@ -962,9 +962,9 @@ static irqreturn_t pdc_irq_handler(int irq, void *data)
  * a DMA receive interrupt. Reenables the receive interrupt.
  * @data: PDC state structure
  */
-static void pdc_tasklet_cb(unsigned long data)
+static void pdc_tasklet_cb(struct tasklet_struct *t)
 {
-	struct pdc_state *pdcs = (struct pdc_state *)data;
+	struct pdc_state *pdcs = from_tasklet(pdcs, t, rx_tasklet);
 
 	pdc_receive(pdcs);
 
@@ -1589,7 +1589,7 @@ static int pdc_probe(struct platform_device *pdev)
 	pdc_hw_init(pdcs);
 
 	/* Init tasklet for deferred DMA rx processing */
-	tasklet_init(&pdcs->rx_tasklet, pdc_tasklet_cb, (unsigned long)pdcs);
+	tasklet_setup(&pdcs->rx_tasklet, pdc_tasklet_cb);
 
 	err = pdc_interrupts_init(pdcs);
 	if (err)
diff --git a/drivers/mailbox/imx-mailbox.c b/drivers/mailbox/imx-mailbox.c
index 9f74dee1a58c..14ce3875f576 100644
--- a/drivers/mailbox/imx-mailbox.c
+++ b/drivers/mailbox/imx-mailbox.c
@@ -97,9 +97,9 @@ static u32 imx_mu_xcr_rmw(struct imx_mu_priv *priv, u32 set, u32 clr)
 	return val;
 }
 
-static void imx_mu_txdb_tasklet(unsigned long data)
+static void imx_mu_txdb_tasklet(struct tasklet_struct *t)
 {
-	struct imx_mu_con_priv *cp = (struct imx_mu_con_priv *)data;
+	struct imx_mu_con_priv *cp = from_tasklet(cp, t, txdb_tasklet);
 
 	mbox_chan_txdone(cp->chan, 0);
 }
@@ -182,8 +182,7 @@ static int imx_mu_startup(struct mbox_chan *chan)
 
 	if (cp->type == IMX_MU_TYPE_TXDB) {
 		/* Tx doorbell don't have ACK support */
-		tasklet_init(&cp->txdb_tasklet, imx_mu_txdb_tasklet,
-			     (unsigned long)cp);
+		tasklet_setup(&cp->txdb_tasklet, imx_mu_txdb_tasklet);
 		return 0;
 	}
 
diff --git a/drivers/media/pci/bt8xx/dvb-bt8xx.c b/drivers/media/pci/bt8xx/dvb-bt8xx.c
index 02ebd43e672e..4cb890b949c3 100644
--- a/drivers/media/pci/bt8xx/dvb-bt8xx.c
+++ b/drivers/media/pci/bt8xx/dvb-bt8xx.c
@@ -39,9 +39,10 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 #define IF_FREQUENCYx6 217    /* 6 * 36.16666666667MHz */
 
-static void dvb_bt8xx_task(unsigned long data)
+static void dvb_bt8xx_task(struct tasklet_struct *t)
 {
-	struct dvb_bt8xx_card *card = (struct dvb_bt8xx_card *)data;
+	struct bt878 *bt = from_tasklet(bt, t, tasklet);
+	struct dvb_bt8xx_card *card = dev_get_drvdata(&bt->adapter->dev);
 
 	dprintk("%d\n", card->bt->finished_block);
 
@@ -777,7 +778,7 @@ static int dvb_bt8xx_load_card(struct dvb_bt8xx_card *card, u32 type)
 		goto err_disconnect_frontend;
 	}
 
-	tasklet_init(&card->bt->tasklet, dvb_bt8xx_task, (unsigned long) card);
+	tasklet_setup(&card->bt->tasklet, dvb_bt8xx_task);
 
 	frontend_init(card, type);
 
diff --git a/drivers/media/pci/mantis/mantis_dma.c b/drivers/media/pci/mantis/mantis_dma.c
index affc5977387f..4df571ff272b 100644
--- a/drivers/media/pci/mantis/mantis_dma.c
+++ b/drivers/media/pci/mantis/mantis_dma.c
@@ -200,9 +200,9 @@ void mantis_dma_stop(struct mantis_pci *mantis)
 }
 
 
-void mantis_dma_xfer(unsigned long data)
+void mantis_dma_xfer(struct tasklet_struct *t)
 {
-	struct mantis_pci *mantis = (struct mantis_pci *) data;
+	struct mantis_pci *mantis = from_tasklet(mantis, t, tasklet);
 	struct mantis_hwconfig *config = mantis->hwconfig;
 
 	while (mantis->last_block != mantis->busy_block) {
diff --git a/drivers/media/pci/mantis/mantis_dma.h b/drivers/media/pci/mantis/mantis_dma.h
index 421663443d62..37da982c9c29 100644
--- a/drivers/media/pci/mantis/mantis_dma.h
+++ b/drivers/media/pci/mantis/mantis_dma.h
@@ -13,6 +13,6 @@ extern int mantis_dma_init(struct mantis_pci *mantis);
 extern int mantis_dma_exit(struct mantis_pci *mantis);
 extern void mantis_dma_start(struct mantis_pci *mantis);
 extern void mantis_dma_stop(struct mantis_pci *mantis);
-extern void mantis_dma_xfer(unsigned long data);
+extern void mantis_dma_xfer(struct tasklet_struct *t);
 
 #endif /* __MANTIS_DMA_H */
diff --git a/drivers/media/pci/mantis/mantis_dvb.c b/drivers/media/pci/mantis/mantis_dvb.c
index e78ca1f26e68..6d41b87dd382 100644
--- a/drivers/media/pci/mantis/mantis_dvb.c
+++ b/drivers/media/pci/mantis/mantis_dvb.c
@@ -205,7 +205,7 @@ int mantis_dvb_init(struct mantis_pci *mantis)
 	}
 
 	dvb_net_init(&mantis->dvb_adapter, &mantis->dvbnet, &mantis->demux.dmx);
-	tasklet_init(&mantis->tasklet, mantis_dma_xfer, (unsigned long) mantis);
+	tasklet_setup(&mantis->tasklet, mantis_dma_xfer);
 	tasklet_disable(&mantis->tasklet);
 	if (mantis->hwconfig) {
 		result = config->frontend_init(mantis, mantis->fe);
diff --git a/drivers/media/pci/ngene/ngene-core.c b/drivers/media/pci/ngene/ngene-core.c
index af15ca1c501b..f9f94f47d76b 100644
--- a/drivers/media/pci/ngene/ngene-core.c
+++ b/drivers/media/pci/ngene/ngene-core.c
@@ -50,9 +50,9 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 /* nGene interrupt handler **************************************************/
 /****************************************************************************/
 
-static void event_tasklet(unsigned long data)
+static void event_tasklet(struct tasklet_struct *t)
 {
-	struct ngene *dev = (struct ngene *)data;
+	struct ngene *dev = from_tasklet(dev, t, event_tasklet);
 
 	while (dev->EventQueueReadIndex != dev->EventQueueWriteIndex) {
 		struct EVENT_BUFFER Event =
@@ -68,9 +68,9 @@ static void event_tasklet(unsigned long data)
 	}
 }
 
-static void demux_tasklet(unsigned long data)
+static void demux_tasklet(struct tasklet_struct *t)
 {
-	struct ngene_channel *chan = (struct ngene_channel *)data;
+	struct ngene_channel *chan = from_tasklet(chan, t, demux_tasklet);
 	struct device *pdev = &chan->dev->pci_dev->dev;
 	struct SBufferHeader *Cur = chan->nextBuffer;
 
@@ -1181,7 +1181,7 @@ static void ngene_init(struct ngene *dev)
 	struct device *pdev = &dev->pci_dev->dev;
 	int i;
 
-	tasklet_init(&dev->event_tasklet, event_tasklet, (unsigned long)dev);
+	tasklet_setup(&dev->event_tasklet, event_tasklet);
 
 	memset_io(dev->iomem + 0xc000, 0x00, 0x220);
 	memset_io(dev->iomem + 0xc400, 0x00, 0x100);
@@ -1445,7 +1445,7 @@ static int init_channel(struct ngene_channel *chan)
 	struct ngene_info *ni = dev->card_info;
 	int io = ni->io_type[nr];
 
-	tasklet_init(&chan->demux_tasklet, demux_tasklet, (unsigned long)chan);
+	tasklet_setup(&chan->demux_tasklet, demux_tasklet);
 	chan->users = 0;
 	chan->type = io;
 	chan->mode = chan->type;	/* for now only one mode */
diff --git a/drivers/media/pci/smipcie/smipcie-main.c b/drivers/media/pci/smipcie/smipcie-main.c
index 1fb78462e081..21e4624b2794 100644
--- a/drivers/media/pci/smipcie/smipcie-main.c
+++ b/drivers/media/pci/smipcie/smipcie-main.c
@@ -280,9 +280,9 @@ static void smi_port_clearInterrupt(struct smi_port *port)
 }
 
 /* tasklet handler: DMA data to dmx.*/
-static void smi_dma_xfer(unsigned long data)
+static void smi_dma_xfer(struct tasklet_struct *t)
 {
-	struct smi_port *port = (struct smi_port *) data;
+	struct smi_port *port = from_tasklet(port, t, tasklet);
 	struct smi_dev *dev = port->dev;
 	u32 intr_status, finishedData, dmaManagement;
 	u8 dmaChan0State, dmaChan1State;
@@ -422,7 +422,7 @@ static int smi_port_init(struct smi_port *port, int dmaChanUsed)
 	}
 
 	smi_port_disableInterrupt(port);
-	tasklet_init(&port->tasklet, smi_dma_xfer, (unsigned long)port);
+	tasklet_setup(&port->tasklet, smi_dma_xfer);
 	tasklet_disable(&port->tasklet);
 	port->enable = 1;
 	return 0;
diff --git a/drivers/media/pci/ttpci/av7110.c b/drivers/media/pci/ttpci/av7110.c
index d0cdee1c6eb0..6d3698cfd512 100644
--- a/drivers/media/pci/ttpci/av7110.c
+++ b/drivers/media/pci/ttpci/av7110.c
@@ -357,9 +357,9 @@ static inline void start_debi_dma(struct av7110 *av7110, int dir,
 		irdebi(av7110, DEBISWAB, addr, 0, len);
 }
 
-static void debiirq(unsigned long cookie)
+static void debiirq(struct tasklet_struct *t)
 {
-	struct av7110 *av7110 = (struct av7110 *)cookie;
+	struct av7110 *av7110 = from_tasklet(av7110, t, debi_tasklet);
 	int type = av7110->debitype;
 	int handle = (type >> 8) & 0x1f;
 	unsigned int xfer = 0;
@@ -457,9 +457,9 @@ static void debiirq(unsigned long cookie)
 }
 
 /* irq from av7110 firmware writing the mailbox register in the DPRAM */
-static void gpioirq(unsigned long cookie)
+static void gpioirq(struct tasklet_struct *t)
 {
-	struct av7110 *av7110 = (struct av7110 *)cookie;
+	struct av7110 *av7110 = from_tasklet(av7110, t, gpio_tasklet);
 	u32 rxbuf, txbuf;
 	int len;
 
@@ -1229,9 +1229,9 @@ static int budget_stop_feed(struct dvb_demux_feed *feed)
 	return status;
 }
 
-static void vpeirq(unsigned long cookie)
+static void vpeirq(struct tasklet_struct *t)
 {
-	struct av7110 *budget = (struct av7110 *)cookie;
+	struct av7110 *budget = from_tasklet(budget, t, vpe_tasklet);
 	u8 *mem = (u8 *) (budget->grabbing);
 	u32 olddma = budget->ttbp;
 	u32 newdma = saa7146_read(budget->dev, PCI_VDP3);
@@ -2517,7 +2517,7 @@ static int av7110_attach(struct saa7146_dev* dev,
 		saa7146_write(dev, NUM_LINE_BYTE3, (TS_HEIGHT << 16) | TS_WIDTH);
 		saa7146_write(dev, MC2, MASK_04 | MASK_20);
 
-		tasklet_init(&av7110->vpe_tasklet, vpeirq, (unsigned long) av7110);
+		tasklet_setup(&av7110->vpe_tasklet, vpeirq);
 
 	} else if (budgetpatch) {
 		spin_lock_init(&av7110->feedlock1);
@@ -2598,7 +2598,7 @@ static int av7110_attach(struct saa7146_dev* dev,
 		saa7146_write(dev, MC1, (MASK_13 | MASK_29));
 
 		/* end of budgetpatch register initialization */
-		tasklet_init (&av7110->vpe_tasklet,  vpeirq,  (unsigned long) av7110);
+		tasklet_setup(&av7110->vpe_tasklet, vpeirq);
 	} else {
 		saa7146_write(dev, PCI_BT_V1, 0x1c00101f);
 		saa7146_write(dev, BCS_CTRL, 0x80400040);
@@ -2613,8 +2613,8 @@ static int av7110_attach(struct saa7146_dev* dev,
 		saa7146_write(dev, GPIO_CTRL, 0x000000);
 	}
 
-	tasklet_init (&av7110->debi_tasklet, debiirq, (unsigned long) av7110);
-	tasklet_init (&av7110->gpio_tasklet, gpioirq, (unsigned long) av7110);
+	tasklet_setup(&av7110->debi_tasklet, debiirq);
+	tasklet_setup(&av7110->gpio_tasklet, gpioirq);
 
 	mutex_init(&av7110->pid_mutex);
 
diff --git a/drivers/media/pci/ttpci/budget-ci.c b/drivers/media/pci/ttpci/budget-ci.c
index 77b102b8a013..98e832f31943 100644
--- a/drivers/media/pci/ttpci/budget-ci.c
+++ b/drivers/media/pci/ttpci/budget-ci.c
@@ -99,9 +99,10 @@ struct budget_ci {
 	u8 tuner_pll_address; /* used for philips_tdm1316l configs */
 };
 
-static void msp430_ir_interrupt(unsigned long data)
+static void msp430_ir_interrupt(struct tasklet_struct *t)
 {
-	struct budget_ci *budget_ci = (struct budget_ci *) data;
+	struct budget_ci_ir *ir = from_tasklet(ir, t, msp430_irq_tasklet);
+	struct budget_ci *budget_ci = container_of(ir, typeof(*budget_ci), ir);
 	struct rc_dev *dev = budget_ci->ir.dev;
 	u32 command = ttpci_budget_debiread(&budget_ci->budget, DEBINOSWAP, DEBIADDR_IR, 2, 1, 0) >> 8;
 
@@ -229,8 +230,7 @@ static int msp430_ir_init(struct budget_ci *budget_ci)
 
 	budget_ci->ir.dev = dev;
 
-	tasklet_init(&budget_ci->ir.msp430_irq_tasklet, msp430_ir_interrupt,
-		     (unsigned long) budget_ci);
+	tasklet_setup(&budget_ci->ir.msp430_irq_tasklet, msp430_ir_interrupt);
 
 	SAA7146_IER_ENABLE(saa, MASK_06);
 	saa7146_setgpio(saa, 3, SAA7146_GPIO_IRQHI);
@@ -348,9 +348,10 @@ static int ciintf_slot_ts_enable(struct dvb_ca_en50221 *ca, int slot)
 	return 0;
 }
 
-static void ciintf_interrupt(unsigned long data)
+static void ciintf_interrupt(struct tasklet_struct *t)
 {
-	struct budget_ci *budget_ci = (struct budget_ci *) data;
+	struct budget_ci *budget_ci = from_tasklet(budget_ci, t,
+						   ciintf_irq_tasklet);
 	struct saa7146_dev *saa = budget_ci->budget.dev;
 	unsigned int flags;
 
@@ -491,7 +492,8 @@ static int ciintf_init(struct budget_ci *budget_ci)
 
 	// Setup CI slot IRQ
 	if (budget_ci->ci_irq) {
-		tasklet_init(&budget_ci->ciintf_irq_tasklet, ciintf_interrupt, (unsigned long) budget_ci);
+		tasklet_setup(&budget_ci->ciintf_irq_tasklet,
+			      ciintf_interrupt);
 		if (budget_ci->slot_status != SLOTSTATUS_NONE) {
 			saa7146_setgpio(saa, 0, SAA7146_GPIO_IRQLO);
 		} else {
diff --git a/drivers/media/pci/ttpci/budget-core.c b/drivers/media/pci/ttpci/budget-core.c
index fadbdeeb4495..fd3187bdb8e6 100644
--- a/drivers/media/pci/ttpci/budget-core.c
+++ b/drivers/media/pci/ttpci/budget-core.c
@@ -171,9 +171,9 @@ static int budget_read_fe_status(struct dvb_frontend *fe,
 	return ret;
 }
 
-static void vpeirq(unsigned long data)
+static void vpeirq(struct tasklet_struct *t)
 {
-	struct budget *budget = (struct budget *) data;
+	struct budget *budget = from_tasklet(budget, t, vpe_tasklet);
 	u8 *mem = (u8 *) (budget->grabbing);
 	u32 olddma = budget->ttbp;
 	u32 newdma = saa7146_read(budget->dev, PCI_VDP3);
@@ -514,7 +514,7 @@ int ttpci_budget_init(struct budget *budget, struct saa7146_dev *dev,
 	/* upload all */
 	saa7146_write(dev, GPIO_CTRL, 0x000000);
 
-	tasklet_init(&budget->vpe_tasklet, vpeirq, (unsigned long) budget);
+	tasklet_setup(&budget->vpe_tasklet, vpeirq);
 
 	/* frontend power on */
 	if (bi->type != BUDGET_FS_ACTIVY)
diff --git a/drivers/media/pci/tw5864/tw5864-video.c b/drivers/media/pci/tw5864/tw5864-video.c
index 09732eed7eb4..0e70b28bf816 100644
--- a/drivers/media/pci/tw5864/tw5864-video.c
+++ b/drivers/media/pci/tw5864/tw5864-video.c
@@ -175,7 +175,7 @@ static const unsigned int intra4x4_lambda3[] = {
 static v4l2_std_id tw5864_get_v4l2_std(enum tw5864_vid_std std);
 static enum tw5864_vid_std tw5864_from_v4l2_std(v4l2_std_id v4l2_std);
 
-static void tw5864_handle_frame_task(unsigned long data);
+static void tw5864_handle_frame_task(struct tasklet_struct *t);
 static void tw5864_handle_frame(struct tw5864_h264_frame *frame);
 static void tw5864_frame_interval_set(struct tw5864_input *input);
 
@@ -1057,8 +1057,7 @@ int tw5864_video_init(struct tw5864_dev *dev, int *video_nr)
 	dev->irqmask |= TW5864_INTR_VLC_DONE | TW5864_INTR_TIMER;
 	tw5864_irqmask_apply(dev);
 
-	tasklet_init(&dev->tasklet, tw5864_handle_frame_task,
-		     (unsigned long)dev);
+	tasklet_setup(&dev->tasklet, tw5864_handle_frame_task);
 
 	for (i = 0; i < TW5864_INPUTS; i++) {
 		dev->inputs[i].root = dev;
@@ -1313,9 +1312,9 @@ static int tw5864_is_motion_triggered(struct tw5864_h264_frame *frame)
 	return detected;
 }
 
-static void tw5864_handle_frame_task(unsigned long data)
+static void tw5864_handle_frame_task(struct tasklet_struct *t)
 {
-	struct tw5864_dev *dev = (struct tw5864_dev *)data;
+	struct tw5864_dev *dev = from_tasklet(dev, t, tasklet);
 	unsigned long flags;
 	int batch_size = H264_BUF_CNT;
 
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 803baf97f06e..03d20d307524 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -438,9 +438,9 @@ static void mcam_ctlr_dma_vmalloc(struct mcam_camera *cam)
 /*
  * Copy data out to user space in the vmalloc case
  */
-static void mcam_frame_tasklet(unsigned long data)
+static void mcam_frame_tasklet(struct tasklet_struct *t)
 {
-	struct mcam_camera *cam = (struct mcam_camera *) data;
+	struct mcam_camera *cam = from_tasklet(cam, t, s_tasklet);
 	int i;
 	unsigned long flags;
 	struct mcam_vb_buffer *buf;
@@ -1323,8 +1323,7 @@ static int mcam_setup_vb2(struct mcam_camera *cam)
 		break;
 	case B_vmalloc:
 #ifdef MCAM_MODE_VMALLOC
-		tasklet_init(&cam->s_tasklet, mcam_frame_tasklet,
-				(unsigned long) cam);
+		tasklet_setup(&cam->s_tasklet, mcam_frame_tasklet);
 		vq->ops = &mcam_vb2_ops;
 		vq->mem_ops = &vb2_vmalloc_memops;
 		cam->dma_setup = mcam_ctlr_dma_vmalloc;
diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index 8d47ea0c33f8..9a1257276a5c 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -1186,9 +1186,9 @@ static void pxa_camera_deactivate(struct pxa_camera_dev *pcdev)
 	clk_disable_unprepare(pcdev->clk);
 }
 
-static void pxa_camera_eof(unsigned long arg)
+static void pxa_camera_eof(struct tasklet_struct *t)
 {
-	struct pxa_camera_dev *pcdev = (struct pxa_camera_dev *)arg;
+	struct pxa_camera_dev *pcdev = from_tasklet(pcdev, t, task_eof);
 	unsigned long cifr;
 	struct pxa_buffer *buf;
 
@@ -2478,7 +2478,7 @@ static int pxa_camera_probe(struct platform_device *pdev)
 		goto exit_free_dma;
 	}
 
-	tasklet_init(&pcdev->task_eof, pxa_camera_eof, (unsigned long)pcdev);
+	tasklet_setup(&pcdev->task_eof, pxa_camera_eof);
 
 	pxa_camera_activate(pcdev);
 
diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
index 5baada4f65e5..dbe7788083a4 100644
--- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
+++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
@@ -77,9 +77,9 @@ static void c8sectpfe_timer_interrupt(struct timer_list *t)
 	add_timer(&fei->timer);
 }
 
-static void channel_swdemux_tsklet(unsigned long data)
+static void channel_swdemux_tsklet(struct tasklet_struct *t)
 {
-	struct channel_info *channel = (struct channel_info *)data;
+	struct channel_info *channel = from_tasklet(channel, t, tsklet);
 	struct c8sectpfei *fei;
 	unsigned long wp, rp;
 	int pos, num_packets, n, size;
@@ -208,8 +208,7 @@ static int c8sectpfe_start_feed(struct dvb_demux_feed *dvbdmxfeed)
 
 		dev_dbg(fei->dev, "Starting channel=%p\n", channel);
 
-		tasklet_init(&channel->tsklet, channel_swdemux_tsklet,
-			     (unsigned long) channel);
+		tasklet_setup(&channel->tsklet, channel_swdemux_tsklet);
 
 		/* Reset the internal inputblock sram pointers */
 		writel(channel->fifo,
@@ -638,8 +637,7 @@ static int configure_memdma_and_inputblock(struct c8sectpfei *fei,
 	writel(tsin->back_buffer_busaddr, tsin->irec + DMA_PRDS_BUSRP_TP(0));
 
 	/* initialize tasklet */
-	tasklet_init(&tsin->tsklet, channel_swdemux_tsklet,
-		(unsigned long) tsin);
+	tasklet_setup(&tsin->tsklet, channel_swdemux_tsklet);
 
 	return 0;
 
diff --git a/drivers/media/radio/wl128x/fmdrv_common.c b/drivers/media/radio/wl128x/fmdrv_common.c
index cce97c9d5409..dc0cc7a0da60 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.c
+++ b/drivers/media/radio/wl128x/fmdrv_common.c
@@ -244,7 +244,7 @@ void fmc_update_region_info(struct fmdev *fmdev, u8 region_to_set)
  * FM common sub-module will schedule this tasklet whenever it receives
  * FM packet from ST driver.
  */
-static void recv_tasklet(unsigned long arg)
+static void recv_tasklet(struct tasklet_struct *t)
 {
 	struct fmdev *fmdev;
 	struct fm_irq *irq_info;
@@ -253,7 +253,7 @@ static void recv_tasklet(unsigned long arg)
 	u8 num_fm_hci_cmds;
 	unsigned long flags;
 
-	fmdev = (struct fmdev *)arg;
+	fmdev = from_tasklet(fmdev, t, rx_task);
 	irq_info = &fmdev->irq_info;
 	/* Process all packets in the RX queue */
 	while ((skb = skb_dequeue(&fmdev->rx_q))) {
@@ -328,13 +328,13 @@ static void recv_tasklet(unsigned long arg)
 }
 
 /* FM send tasklet: is scheduled when FM packet has to be sent to chip */
-static void send_tasklet(unsigned long arg)
+static void send_tasklet(struct tasklet_struct *t)
 {
 	struct fmdev *fmdev;
 	struct sk_buff *skb;
 	int len;
 
-	fmdev = (struct fmdev *)arg;
+	fmdev = from_tasklet(fmdev, t, tx_task);
 
 	if (!atomic_read(&fmdev->tx_cnt))
 		return;
@@ -1535,11 +1535,11 @@ int fmc_prepare(struct fmdev *fmdev)
 
 	/* Initialize TX queue and TX tasklet */
 	skb_queue_head_init(&fmdev->tx_q);
-	tasklet_init(&fmdev->tx_task, send_tasklet, (unsigned long)fmdev);
+	tasklet_setup(&fmdev->tx_task, send_tasklet);
 
 	/* Initialize RX Queue and RX tasklet */
 	skb_queue_head_init(&fmdev->rx_q);
-	tasklet_init(&fmdev->rx_task, recv_tasklet, (unsigned long)fmdev);
+	tasklet_setup(&fmdev->rx_task, recv_tasklet);
 
 	fmdev->irq_info.stage = 0;
 	atomic_set(&fmdev->tx_cnt, 1);
diff --git a/drivers/media/usb/ttusb-dec/ttusb_dec.c b/drivers/media/usb/ttusb-dec/ttusb_dec.c
index 3198f9624b7c..3f03cfee3bf7 100644
--- a/drivers/media/usb/ttusb-dec/ttusb_dec.c
+++ b/drivers/media/usb/ttusb-dec/ttusb_dec.c
@@ -768,9 +768,9 @@ static void ttusb_dec_process_urb_frame(struct ttusb_dec *dec, u8 *b,
 	}
 }
 
-static void ttusb_dec_process_urb_frame_list(unsigned long data)
+static void ttusb_dec_process_urb_frame_list(struct tasklet_struct *t)
 {
-	struct ttusb_dec *dec = (struct ttusb_dec *)data;
+	struct ttusb_dec *dec = from_tasklet(dec, t, urb_tasklet);
 	struct list_head *item;
 	struct urb_frame *frame;
 	unsigned long flags;
@@ -1208,8 +1208,7 @@ static void ttusb_dec_init_tasklet(struct ttusb_dec *dec)
 {
 	spin_lock_init(&dec->urb_frame_list_lock);
 	INIT_LIST_HEAD(&dec->urb_frame_list);
-	tasklet_init(&dec->urb_tasklet, ttusb_dec_process_urb_frame_list,
-		     (unsigned long)dec);
+	tasklet_setup(&dec->urb_tasklet, ttusb_dec_process_urb_frame_list);
 }
 
 static int ttusb_init_rc( struct ttusb_dec *dec)
diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
index 32747425297d..a3fb91b0ec68 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -603,10 +603,10 @@ static void jmb38x_ms_abort(struct timer_list *t)
 	spin_unlock_irqrestore(&host->lock, flags);
 }
 
-static void jmb38x_ms_req_tasklet(unsigned long data)
+static void jmb38x_ms_req_tasklet(struct tasklet_struct *t)
 {
-	struct memstick_host *msh = (struct memstick_host *)data;
-	struct jmb38x_ms_host *host = memstick_priv(msh);
+	struct jmb38x_ms_host *host = from_tasklet(host, t, notify);
+	struct memstick_host *msh = host->msh;
 	unsigned long flags;
 	int rc;
 
@@ -885,7 +885,7 @@ static struct memstick_host *jmb38x_ms_alloc_host(struct jmb38x_ms *jm, int cnt)
 	host->irq = jm->pdev->irq;
 	host->timeout_jiffies = msecs_to_jiffies(1000);
 
-	tasklet_init(&host->notify, jmb38x_ms_req_tasklet, (unsigned long)msh);
+	tasklet_setup(&host->notify, jmb38x_ms_req_tasklet);
 	msh->request = jmb38x_ms_submit_req;
 	msh->set_param = jmb38x_ms_set_param;
 
diff --git a/drivers/memstick/host/tifm_ms.c b/drivers/memstick/host/tifm_ms.c
index 5b966b54d6e9..4bc4256008a4 100644
--- a/drivers/memstick/host/tifm_ms.c
+++ b/drivers/memstick/host/tifm_ms.c
@@ -452,11 +452,11 @@ static void tifm_ms_card_event(struct tifm_dev *sock)
 	return;
 }
 
-static void tifm_ms_req_tasklet(unsigned long data)
+static void tifm_ms_req_tasklet(struct tasklet_struct *t)
 {
-	struct memstick_host *msh = (struct memstick_host *)data;
-	struct tifm_ms *host = memstick_priv(msh);
+	struct tifm_ms *host = from_tasklet(host, t, notify);
 	struct tifm_dev *sock = host->dev;
+	struct memstick_host *msh = tifm_get_drvdata(sock);
 	unsigned long flags;
 	int rc;
 
@@ -571,7 +571,7 @@ static int tifm_ms_probe(struct tifm_dev *sock)
 	host->timeout_jiffies = msecs_to_jiffies(1000);
 
 	timer_setup(&host->timer, tifm_ms_abort, 0);
-	tasklet_init(&host->notify, tifm_ms_req_tasklet, (unsigned long)msh);
+	tasklet_setup(&host->notify, tifm_ms_req_tasklet);
 
 	msh->request = tifm_ms_submit_req;
 	msh->set_param = tifm_ms_set_param;
diff --git a/drivers/misc/ibmvmc.c b/drivers/misc/ibmvmc.c
index 2ed23c99f59f..46359aa26c73 100644
--- a/drivers/misc/ibmvmc.c
+++ b/drivers/misc/ibmvmc.c
@@ -2064,10 +2064,10 @@ static void ibmvmc_handle_crq(struct ibmvmc_crq_msg *crq,
 	}
 }
 
-static void ibmvmc_task(unsigned long data)
+static void ibmvmc_task(struct tasklet_struct *t)
 {
-	struct crq_server_adapter *adapter =
-		(struct crq_server_adapter *)data;
+	struct crq_server_adapter *adapter = from_tasklet(adapter, t,
+							  work_task);
 	struct vio_dev *vdev = to_vio_dev(adapter->dev);
 	struct ibmvmc_crq_msg *crq;
 	int done = 0;
@@ -2150,7 +2150,7 @@ static int ibmvmc_init_crq_queue(struct crq_server_adapter *adapter)
 	queue->cur = 0;
 	spin_lock_init(&queue->lock);
 
-	tasklet_init(&adapter->work_task, ibmvmc_task, (unsigned long)adapter);
+	tasklet_setup(&adapter->work_task, ibmvmc_task);
 
 	if (request_irq(vdev->irq,
 			ibmvmc_handle_event,
diff --git a/drivers/misc/vmw_vmci/vmci_guest.c b/drivers/misc/vmw_vmci/vmci_guest.c
index 7a84a48c75da..3d43a8441295 100644
--- a/drivers/misc/vmw_vmci/vmci_guest.c
+++ b/drivers/misc/vmw_vmci/vmci_guest.c
@@ -205,9 +205,10 @@ static int vmci_check_host_caps(struct pci_dev *pdev)
  * This function assumes that it has exclusive access to the data
  * in port for the duration of the call.
  */
-static void vmci_dispatch_dgs(unsigned long data)
+static void vmci_dispatch_dgs(struct tasklet_struct *t)
 {
-	struct vmci_guest_device *vmci_dev = (struct vmci_guest_device *)data;
+	struct vmci_guest_device *vmci_dev = from_tasklet(vmci_dev, t,
+							  datagram_tasklet);
 	u8 *dg_in_buffer = vmci_dev->data_buffer;
 	struct vmci_datagram *dg;
 	size_t dg_in_buffer_size = VMCI_MAX_DG_SIZE;
@@ -352,9 +353,9 @@ static void vmci_dispatch_dgs(unsigned long data)
  * Scans the notification bitmap for raised flags, clears them
  * and handles the notifications.
  */
-static void vmci_process_bitmap(unsigned long data)
+static void vmci_process_bitmap(struct tasklet_struct *t)
 {
-	struct vmci_guest_device *dev = (struct vmci_guest_device *)data;
+	struct vmci_guest_device *dev = from_tasklet(dev, t, bm_tasklet);
 
 	if (!dev->notification_bitmap) {
 		dev_dbg(dev->dev, "No bitmap present in %s\n", __func__);
@@ -467,10 +468,8 @@ static int vmci_guest_probe_device(struct pci_dev *pdev,
 	vmci_dev->exclusive_vectors = false;
 	vmci_dev->iobase = iobase;
 
-	tasklet_init(&vmci_dev->datagram_tasklet,
-		     vmci_dispatch_dgs, (unsigned long)vmci_dev);
-	tasklet_init(&vmci_dev->bm_tasklet,
-		     vmci_process_bitmap, (unsigned long)vmci_dev);
+	tasklet_setup(&vmci_dev->datagram_tasklet, vmci_dispatch_dgs);
+	tasklet_setup(&vmci_dev->bm_tasklet, vmci_process_bitmap);
 
 	vmci_dev->data_buffer = vmalloc(VMCI_MAX_DG_SIZE);
 	if (!vmci_dev->data_buffer) {
diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index c26fbe5f2222..26671441ff9b 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -1713,9 +1713,9 @@ static void atmci_detect_change(struct timer_list *t)
 	}
 }
 
-static void atmci_tasklet_func(unsigned long priv)
+static void atmci_tasklet_func(struct tasklet_struct *t)
 {
-	struct atmel_mci	*host = (struct atmel_mci *)priv;
+	struct atmel_mci *host = from_tasklet(host, t, tasklet);
 	struct mmc_request	*mrq = host->mrq;
 	struct mmc_data		*data = host->data;
 	enum atmel_mci_state	state = host->state;
@@ -2491,7 +2491,7 @@ static int atmci_probe(struct platform_device *pdev)
 
 	host->mapbase = regs->start;
 
-	tasklet_init(&host->tasklet, atmci_tasklet_func, (unsigned long)host);
+	tasklet_setup(&host->tasklet, atmci_tasklet_func);
 
 	ret = request_irq(irq, atmci_interrupt, 0, dev_name(&pdev->dev), host);
 	if (ret) {
diff --git a/drivers/mmc/host/au1xmmc.c b/drivers/mmc/host/au1xmmc.c
index bc8aeb47a7b4..4de6bf45d382 100644
--- a/drivers/mmc/host/au1xmmc.c
+++ b/drivers/mmc/host/au1xmmc.c
@@ -253,9 +253,9 @@ static void au1xmmc_finish_request(struct au1xmmc_host *host)
 	mmc_request_done(host->mmc, mrq);
 }
 
-static void au1xmmc_tasklet_finish(unsigned long param)
+static void au1xmmc_tasklet_finish(struct tasklet_struct *t)
 {
-	struct au1xmmc_host *host = (struct au1xmmc_host *) param;
+	struct au1xmmc_host *host = from_tasklet(host, t, finish_task);
 	au1xmmc_finish_request(host);
 }
 
@@ -379,9 +379,9 @@ static void au1xmmc_data_complete(struct au1xmmc_host *host, u32 status)
 	au1xmmc_finish_request(host);
 }
 
-static void au1xmmc_tasklet_data(unsigned long param)
+static void au1xmmc_tasklet_data(struct tasklet_struct *t)
 {
-	struct au1xmmc_host *host = (struct au1xmmc_host *)param;
+	struct au1xmmc_host *host = from_tasklet(host, t, data_task);
 
 	u32 status = __raw_readl(HOST_STATUS(host));
 	au1xmmc_data_complete(host, status);
@@ -1056,11 +1056,9 @@ static int au1xmmc_probe(struct platform_device *pdev)
 	if (host->platdata)
 		mmc->caps &= ~(host->platdata->mask_host_caps);
 
-	tasklet_init(&host->data_task, au1xmmc_tasklet_data,
-			(unsigned long)host);
+	tasklet_setup(&host->data_task, au1xmmc_tasklet_data);
 
-	tasklet_init(&host->finish_task, au1xmmc_tasklet_finish,
-			(unsigned long)host);
+	tasklet_setup(&host->finish_task, au1xmmc_tasklet_finish);
 
 	if (has_dbdma()) {
 		ret = au1xmmc_dbdma_init(host);
diff --git a/drivers/mmc/host/cb710-mmc.c b/drivers/mmc/host/cb710-mmc.c
index e33270e40539..927857e3b6d9 100644
--- a/drivers/mmc/host/cb710-mmc.c
+++ b/drivers/mmc/host/cb710-mmc.c
@@ -644,11 +644,11 @@ static int cb710_mmc_irq_handler(struct cb710_slot *slot)
 	return 1;
 }
 
-static void cb710_mmc_finish_request_tasklet(unsigned long data)
+static void cb710_mmc_finish_request_tasklet(struct tasklet_struct *t)
 {
-	struct mmc_host *mmc = (void *)data;
-	struct cb710_mmc_reader *reader = mmc_priv(mmc);
+	struct cb710_mmc_reader *reader = from_tasklet(reader, t, finish_req_tasklet);
 	struct mmc_request *mrq = reader->mrq;
+	struct mmc_host *mmc = mrq->host;
 
 	reader->mrq = NULL;
 	mmc_request_done(mmc, mrq);
@@ -710,8 +710,8 @@ static int cb710_mmc_init(struct platform_device *pdev)
 
 	reader = mmc_priv(mmc);
 
-	tasklet_init(&reader->finish_req_tasklet,
-		cb710_mmc_finish_request_tasklet, (unsigned long)mmc);
+	tasklet_setup(&reader->finish_req_tasklet,
+		      cb710_mmc_finish_request_tasklet);
 	spin_lock_init(&reader->irq_lock);
 	cb710_dump_regs(chip, CB710_DUMP_REGS_MMC);
 
diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 79c55c7b4afd..b90e90435a90 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -1951,9 +1951,9 @@ static bool dw_mci_clear_pending_data_complete(struct dw_mci *host)
 	return true;
 }
 
-static void dw_mci_tasklet_func(unsigned long priv)
+static void dw_mci_tasklet_func(struct tasklet_struct *t)
 {
-	struct dw_mci *host = (struct dw_mci *)priv;
+	struct dw_mci *host = from_tasklet(host, t, tasklet);
 	struct mmc_data	*data;
 	struct mmc_command *cmd;
 	struct mmc_request *mrq;
@@ -3317,7 +3317,7 @@ int dw_mci_probe(struct dw_mci *host)
 	else
 		host->fifo_reg = host->regs + DATA_240A_OFFSET;
 
-	tasklet_init(&host->tasklet, dw_mci_tasklet_func, (unsigned long)host);
+	tasklet_setup(&host->tasklet, dw_mci_tasklet_func);
 	ret = devm_request_irq(host->dev, host->irq, dw_mci_interrupt,
 			       host->irq_flags, "dw-mci", host);
 	if (ret)
diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index d74e73c95fdf..5684b9eece22 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -878,9 +878,9 @@ static void mmc_omap_cover_timer(struct timer_list *t)
 	tasklet_schedule(&slot->cover_tasklet);
 }
 
-static void mmc_omap_cover_handler(unsigned long param)
+static void mmc_omap_cover_handler(struct tasklet_struct *t)
 {
-	struct mmc_omap_slot *slot = (struct mmc_omap_slot *)param;
+	struct mmc_omap_slot *slot = from_tasklet(slot, t, cover_tasklet);
 	int cover_open = mmc_omap_cover_is_open(slot);
 
 	mmc_detect_change(slot->mmc, 0);
@@ -1269,8 +1269,7 @@ static int mmc_omap_new_slot(struct mmc_omap_host *host, int id)
 
 	if (slot->pdata->get_cover_state != NULL) {
 		timer_setup(&slot->cover_timer, mmc_omap_cover_timer, 0);
-		tasklet_init(&slot->cover_tasklet, mmc_omap_cover_handler,
-			     (unsigned long)slot);
+		tasklet_setup(&slot->cover_tasklet, mmc_omap_cover_handler);
 	}
 
 	r = mmc_add_host(mmc);
diff --git a/drivers/mmc/host/renesas_sdhi_internal_dmac.c b/drivers/mmc/host/renesas_sdhi_internal_dmac.c
index a66f8d6d61d1..4731632039b8 100644
--- a/drivers/mmc/host/renesas_sdhi_internal_dmac.c
+++ b/drivers/mmc/host/renesas_sdhi_internal_dmac.c
@@ -218,9 +218,9 @@ renesas_sdhi_internal_dmac_start_dma(struct tmio_mmc_host *host,
 	renesas_sdhi_internal_dmac_enable_dma(host, false);
 }
 
-static void renesas_sdhi_internal_dmac_issue_tasklet_fn(unsigned long arg)
+static void renesas_sdhi_internal_dmac_issue_tasklet_fn(struct tasklet_struct *t)
 {
-	struct tmio_mmc_host *host = (struct tmio_mmc_host *)arg;
+	struct tmio_mmc_host *host = from_tasklet(host, t, dma_issue);
 
 	tmio_mmc_enable_mmc_irqs(host, TMIO_STAT_DATAEND);
 
@@ -229,9 +229,10 @@ static void renesas_sdhi_internal_dmac_issue_tasklet_fn(unsigned long arg)
 					    DTRAN_CTRL_DM_START);
 }
 
-static void renesas_sdhi_internal_dmac_complete_tasklet_fn(unsigned long arg)
+static void renesas_sdhi_internal_dmac_complete_tasklet_fn(struct tasklet_struct *t)
 {
-	struct tmio_mmc_host *host = (struct tmio_mmc_host *)arg;
+	struct renesas_sdhi *priv = from_tasklet(priv, t, dma_priv.dma_complete);
+	struct tmio_mmc_host *host = platform_get_drvdata(priv->pdev);
 	enum dma_data_direction dir;
 
 	spin_lock_irq(&host->lock);
@@ -270,12 +271,10 @@ renesas_sdhi_internal_dmac_request_dma(struct tmio_mmc_host *host,
 	/* Each value is set to non-zero to assume "enabling" each DMA */
 	host->chan_rx = host->chan_tx = (void *)0xdeadbeaf;
 
-	tasklet_init(&priv->dma_priv.dma_complete,
-		     renesas_sdhi_internal_dmac_complete_tasklet_fn,
-		     (unsigned long)host);
-	tasklet_init(&host->dma_issue,
-		     renesas_sdhi_internal_dmac_issue_tasklet_fn,
-		     (unsigned long)host);
+	tasklet_setup(&priv->dma_priv.dma_complete,
+		      renesas_sdhi_internal_dmac_complete_tasklet_fn);
+	tasklet_setup(&host->dma_issue,
+		      renesas_sdhi_internal_dmac_issue_tasklet_fn);
 }
 
 static void
diff --git a/drivers/mmc/host/renesas_sdhi_sys_dmac.c b/drivers/mmc/host/renesas_sdhi_sys_dmac.c
index 13ff023fbee9..e96af5f25c89 100644
--- a/drivers/mmc/host/renesas_sdhi_sys_dmac.c
+++ b/drivers/mmc/host/renesas_sdhi_sys_dmac.c
@@ -310,9 +310,9 @@ static void renesas_sdhi_sys_dmac_start_dma(struct tmio_mmc_host *host,
 	}
 }
 
-static void renesas_sdhi_sys_dmac_issue_tasklet_fn(unsigned long priv)
+static void renesas_sdhi_sys_dmac_issue_tasklet_fn(struct tasklet_struct *t)
 {
-	struct tmio_mmc_host *host = (struct tmio_mmc_host *)priv;
+	struct tmio_mmc_host *host = from_tasklet(host, t, dma_issue);
 	struct dma_chan *chan = NULL;
 
 	spin_lock_irq(&host->lock);
@@ -399,9 +399,8 @@ static void renesas_sdhi_sys_dmac_request_dma(struct tmio_mmc_host *host,
 			goto ebouncebuf;
 
 		init_completion(&priv->dma_priv.dma_dataend);
-		tasklet_init(&host->dma_issue,
-			     renesas_sdhi_sys_dmac_issue_tasklet_fn,
-			     (unsigned long)host);
+		tasklet_setup(&host->dma_issue,
+			      renesas_sdhi_sys_dmac_issue_tasklet_fn);
 	}
 
 	renesas_sdhi_sys_dmac_enable_dma(host, true);
diff --git a/drivers/mmc/host/s3cmci.c b/drivers/mmc/host/s3cmci.c
index bce9c33bc4b5..569fa5cca12c 100644
--- a/drivers/mmc/host/s3cmci.c
+++ b/drivers/mmc/host/s3cmci.c
@@ -549,9 +549,9 @@ static void do_pio_write(struct s3cmci_host *host)
 	enable_imask(host, S3C2410_SDIIMSK_TXFIFOHALF);
 }
 
-static void pio_tasklet(unsigned long data)
+static void pio_tasklet(struct tasklet_struct *t)
 {
-	struct s3cmci_host *host = (struct s3cmci_host *) data;
+	struct s3cmci_host *host = from_tasklet(host, t, pio_tasklet);
 
 	s3cmci_disable_irq(host, true);
 
@@ -1572,7 +1572,7 @@ static int s3cmci_probe(struct platform_device *pdev)
 	host->pdata = pdev->dev.platform_data;
 
 	spin_lock_init(&host->complete_lock);
-	tasklet_init(&host->pio_tasklet, pio_tasklet, (unsigned long) host);
+	tasklet_setup(&host->pio_tasklet, pio_tasklet);
 
 	if (host->is2440) {
 		host->sdiimsk	= S3C2440_SDIIMSK;
diff --git a/drivers/mmc/host/tifm_sd.c b/drivers/mmc/host/tifm_sd.c
index 54271b92ee59..ae7046b4d6bf 100644
--- a/drivers/mmc/host/tifm_sd.c
+++ b/drivers/mmc/host/tifm_sd.c
@@ -729,9 +729,9 @@ static void tifm_sd_request(struct mmc_host *mmc, struct mmc_request *mrq)
 	mmc_request_done(mmc, mrq);
 }
 
-static void tifm_sd_end_cmd(unsigned long data)
+static void tifm_sd_end_cmd(struct tasklet_struct *t)
 {
-	struct tifm_sd *host = (struct tifm_sd*)data;
+	struct tifm_sd *host = from_tasklet(host, t, finish_tasklet);
 	struct tifm_dev *sock = host->dev;
 	struct mmc_host *mmc = tifm_get_drvdata(sock);
 	struct mmc_request *mrq;
@@ -961,8 +961,7 @@ static int tifm_sd_probe(struct tifm_dev *sock)
 	host->dev = sock;
 	host->timeout_jiffies = msecs_to_jiffies(1000);
 
-	tasklet_init(&host->finish_tasklet, tifm_sd_end_cmd,
-		     (unsigned long)host);
+	tasklet_setup(&host->finish_tasklet, tifm_sd_end_cmd);
 	timer_setup(&host->timer, tifm_sd_abort, 0);
 
 	mmc->ops = &tifm_sd_ops;
diff --git a/drivers/mmc/host/uniphier-sd.c b/drivers/mmc/host/uniphier-sd.c
index 0c72ec5546c3..01087006edcb 100644
--- a/drivers/mmc/host/uniphier-sd.c
+++ b/drivers/mmc/host/uniphier-sd.c
@@ -82,9 +82,9 @@ static void uniphier_sd_dma_endisable(struct tmio_mmc_host *host, int enable)
 }
 
 /* external DMA engine */
-static void uniphier_sd_external_dma_issue(unsigned long arg)
+static void uniphier_sd_external_dma_issue(struct tasklet_struct *t)
 {
-	struct tmio_mmc_host *host = (void *)arg;
+	struct tmio_mmc_host *host = from_tasklet(host, t, dma_issue);
 	struct uniphier_sd_priv *priv = uniphier_sd_priv(host);
 
 	uniphier_sd_dma_endisable(host, 1);
@@ -191,8 +191,7 @@ static void uniphier_sd_external_dma_request(struct tmio_mmc_host *host,
 	host->chan_rx = chan;
 	host->chan_tx = chan;
 
-	tasklet_init(&host->dma_issue, uniphier_sd_external_dma_issue,
-		     (unsigned long)host);
+	tasklet_setup(&host->dma_issue, uniphier_sd_external_dma_issue);
 }
 
 static void uniphier_sd_external_dma_release(struct tmio_mmc_host *host)
@@ -229,9 +228,9 @@ static const struct tmio_mmc_dma_ops uniphier_sd_external_dma_ops = {
 	.dataend = uniphier_sd_external_dma_dataend,
 };
 
-static void uniphier_sd_internal_dma_issue(unsigned long arg)
+static void uniphier_sd_internal_dma_issue(struct tasklet_struct *t)
 {
-	struct tmio_mmc_host *host = (void *)arg;
+	struct tmio_mmc_host *host = from_tasklet(host, t, dma_issue);
 	unsigned long flags;
 
 	spin_lock_irqsave(&host->lock, flags);
@@ -310,8 +309,7 @@ static void uniphier_sd_internal_dma_request(struct tmio_mmc_host *host,
 
 	host->chan_tx = (void *)0xdeadbeaf;
 
-	tasklet_init(&host->dma_issue, uniphier_sd_internal_dma_issue,
-		     (unsigned long)host);
+	tasklet_setup(&host->dma_issue, uniphier_sd_internal_dma_issue);
 }
 
 static void uniphier_sd_internal_dma_release(struct tmio_mmc_host *host)
diff --git a/drivers/mmc/host/via-sdmmc.c b/drivers/mmc/host/via-sdmmc.c
index f4ac064ff471..dae831544ee0 100644
--- a/drivers/mmc/host/via-sdmmc.c
+++ b/drivers/mmc/host/via-sdmmc.c
@@ -954,13 +954,13 @@ static void via_sdc_timeout(struct timer_list *t)
 	spin_unlock_irqrestore(&sdhost->lock, flags);
 }
 
-static void via_sdc_tasklet_finish(unsigned long param)
+static void via_sdc_tasklet_finish(struct tasklet_struct *t)
 {
 	struct via_crdr_mmc_host *host;
 	unsigned long flags;
 	struct mmc_request *mrq;
 
-	host = (struct via_crdr_mmc_host *)param;
+	host = from_tasklet(host, t, finish_tasklet);
 
 	spin_lock_irqsave(&host->lock, flags);
 
@@ -1045,8 +1045,7 @@ static void via_init_mmc_host(struct via_crdr_mmc_host *host)
 
 	INIT_WORK(&host->carddet_work, via_sdc_card_detect);
 
-	tasklet_init(&host->finish_tasklet, via_sdc_tasklet_finish,
-		     (unsigned long)host);
+	tasklet_setup(&host->finish_tasklet, via_sdc_tasklet_finish);
 
 	addrbase = host->sdhc_mmiobase;
 	writel(0x0, addrbase + VIA_CRDR_SDINTMASK);
diff --git a/drivers/mmc/host/wbsd.c b/drivers/mmc/host/wbsd.c
index 740179f42cf2..0d94beb37123 100644
--- a/drivers/mmc/host/wbsd.c
+++ b/drivers/mmc/host/wbsd.c
@@ -985,9 +985,9 @@ static inline struct mmc_data *wbsd_get_data(struct wbsd_host *host)
 	return host->mrq->cmd->data;
 }
 
-static void wbsd_tasklet_card(unsigned long param)
+static void wbsd_tasklet_card(struct tasklet_struct *t)
 {
-	struct wbsd_host *host = (struct wbsd_host *)param;
+	struct wbsd_host *host = from_tasklet(host, t, card_tasklet);
 	u8 csr;
 	int delay = -1;
 
@@ -1034,9 +1034,9 @@ static void wbsd_tasklet_card(unsigned long param)
 		mmc_detect_change(host->mmc, msecs_to_jiffies(delay));
 }
 
-static void wbsd_tasklet_fifo(unsigned long param)
+static void wbsd_tasklet_fifo(struct tasklet_struct *t)
 {
-	struct wbsd_host *host = (struct wbsd_host *)param;
+	struct wbsd_host *host = from_tasklet(host, t, fifo_tasklet);
 	struct mmc_data *data;
 
 	spin_lock(&host->lock);
@@ -1065,9 +1065,9 @@ static void wbsd_tasklet_fifo(unsigned long param)
 	spin_unlock(&host->lock);
 }
 
-static void wbsd_tasklet_crc(unsigned long param)
+static void wbsd_tasklet_crc(struct tasklet_struct *t)
 {
-	struct wbsd_host *host = (struct wbsd_host *)param;
+	struct wbsd_host *host = from_tasklet(host, t, crc_tasklet);
 	struct mmc_data *data;
 
 	spin_lock(&host->lock);
@@ -1089,9 +1089,9 @@ static void wbsd_tasklet_crc(unsigned long param)
 	spin_unlock(&host->lock);
 }
 
-static void wbsd_tasklet_timeout(unsigned long param)
+static void wbsd_tasklet_timeout(struct tasklet_struct *t)
 {
-	struct wbsd_host *host = (struct wbsd_host *)param;
+	struct wbsd_host *host = from_tasklet(host, t, timeout_tasklet);
 	struct mmc_data *data;
 
 	spin_lock(&host->lock);
@@ -1113,9 +1113,9 @@ static void wbsd_tasklet_timeout(unsigned long param)
 	spin_unlock(&host->lock);
 }
 
-static void wbsd_tasklet_finish(unsigned long param)
+static void wbsd_tasklet_finish(struct tasklet_struct *t)
 {
-	struct wbsd_host *host = (struct wbsd_host *)param;
+	struct wbsd_host *host = from_tasklet(host, t, finish_tasklet);
 	struct mmc_data *data;
 
 	spin_lock(&host->lock);
@@ -1447,16 +1447,11 @@ static int wbsd_request_irq(struct wbsd_host *host, int irq)
 	/*
 	 * Set up tasklets. Must be done before requesting interrupt.
 	 */
-	tasklet_init(&host->card_tasklet, wbsd_tasklet_card,
-			(unsigned long)host);
-	tasklet_init(&host->fifo_tasklet, wbsd_tasklet_fifo,
-			(unsigned long)host);
-	tasklet_init(&host->crc_tasklet, wbsd_tasklet_crc,
-			(unsigned long)host);
-	tasklet_init(&host->timeout_tasklet, wbsd_tasklet_timeout,
-			(unsigned long)host);
-	tasklet_init(&host->finish_tasklet, wbsd_tasklet_finish,
-			(unsigned long)host);
+	tasklet_setup(&host->card_tasklet, wbsd_tasklet_card);
+	tasklet_setup(&host->fifo_tasklet, wbsd_tasklet_fifo);
+	tasklet_setup(&host->crc_tasklet, wbsd_tasklet_crc);
+	tasklet_setup(&host->timeout_tasklet, wbsd_tasklet_timeout);
+	tasklet_setup(&host->finish_tasklet, wbsd_tasklet_finish);
 
 	/*
 	 * Allocate interrupt.
diff --git a/drivers/net/arcnet/arcnet.c b/drivers/net/arcnet/arcnet.c
index 8459115d9d4e..8dc181f3745a 100644
--- a/drivers/net/arcnet/arcnet.c
+++ b/drivers/net/arcnet/arcnet.c
@@ -393,9 +393,9 @@ static void arcnet_timer(struct timer_list *t)
 	}
 }
 
-static void arcnet_reply_tasklet(unsigned long data)
+static void arcnet_reply_tasklet(struct tasklet_struct *t)
 {
-	struct arcnet_local *lp = (struct arcnet_local *)data;
+	struct arcnet_local *lp = from_tasklet(lp, t, reply_tasklet);
 
 	struct sk_buff *ackskb, *skb;
 	struct sock_exterr_skb *serr;
@@ -483,8 +483,7 @@ int arcnet_open(struct net_device *dev)
 		arc_cont(D_PROTO, "\n");
 	}
 
-	tasklet_init(&lp->reply_tasklet, arcnet_reply_tasklet,
-		     (unsigned long)lp);
+	tasklet_setup(&lp->reply_tasklet, arcnet_reply_tasklet);
 
 	arc_printk(D_INIT, dev, "arcnet_open: resetting card.\n");
 
diff --git a/drivers/net/caif/caif_virtio.c b/drivers/net/caif/caif_virtio.c
index eb426822ad06..a8b62e32872d 100644
--- a/drivers/net/caif/caif_virtio.c
+++ b/drivers/net/caif/caif_virtio.c
@@ -598,9 +598,9 @@ static int cfv_netdev_tx(struct sk_buff *skb, struct net_device *netdev)
 	return NETDEV_TX_OK;
 }
 
-static void cfv_tx_release_tasklet(unsigned long drv)
+static void cfv_tx_release_tasklet(struct tasklet_struct *t)
 {
-	struct cfv_info *cfv = (struct cfv_info *)drv;
+	struct cfv_info *cfv = from_tasklet(cfv, t, tx_release_tasklet);
 	cfv_release_used_buf(cfv->vq_tx);
 }
 
@@ -716,9 +716,7 @@ static int cfv_probe(struct virtio_device *vdev)
 	cfv->ctx.head = USHRT_MAX;
 	netif_napi_add(netdev, &cfv->napi, cfv_rx_poll, CFV_DEFAULT_QUOTA);
 
-	tasklet_init(&cfv->tx_release_tasklet,
-		     cfv_tx_release_tasklet,
-		     (unsigned long)cfv);
+	tasklet_setup(&cfv->tx_release_tasklet, cfv_tx_release_tasklet);
 
 	/* Carrier is off until netdevice is opened */
 	netif_carrier_off(netdev);
diff --git a/drivers/net/ethernet/alteon/acenic.c b/drivers/net/ethernet/alteon/acenic.c
index 46b4207d3266..ab7678e60984 100644
--- a/drivers/net/ethernet/alteon/acenic.c
+++ b/drivers/net/ethernet/alteon/acenic.c
@@ -1567,10 +1567,11 @@ static void ace_watchdog(struct net_device *data)
 }
 
 
-static void ace_tasklet(unsigned long arg)
+static void ace_tasklet(struct tasklet_struct *t)
 {
-	struct net_device *dev = (struct net_device *) arg;
-	struct ace_private *ap = netdev_priv(dev);
+	struct ace_private *ap = from_tasklet(ap, t, ace_tasklet);
+	struct net_device *dev = (struct net_device *)((char *)ap -
+				ALIGN(sizeof(struct net_device), NETDEV_ALIGN));
 	int cur_size;
 
 	cur_size = atomic_read(&ap->cur_rx_bufs);
@@ -2275,7 +2276,7 @@ static int ace_open(struct net_device *dev)
 	/*
 	 * Setup the bottom half rx ring refill handler
 	 */
-	tasklet_init(&ap->ace_tasklet, ace_tasklet, (unsigned long)dev);
+	tasklet_setup(&ap->ace_tasklet, ace_tasklet);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/alteon/acenic.h b/drivers/net/ethernet/alteon/acenic.h
index c670067b1541..4b02c705859c 100644
--- a/drivers/net/ethernet/alteon/acenic.h
+++ b/drivers/net/ethernet/alteon/acenic.h
@@ -776,7 +776,7 @@ static int ace_open(struct net_device *dev);
 static netdev_tx_t ace_start_xmit(struct sk_buff *skb,
 				  struct net_device *dev);
 static int ace_close(struct net_device *dev);
-static void ace_tasklet(unsigned long dev);
+static void ace_tasklet(struct tasklet_struct *t);
 static void ace_dump_trace(struct ace_private *ap);
 static void ace_set_multicast_list(struct net_device *dev);
 static int ace_change_mtu(struct net_device *dev, int new_mtu);
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 98f8f2033154..fdbba19319b7 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -403,9 +403,9 @@ static bool xgbe_ecc_ded(struct xgbe_prv_data *pdata, unsigned long *period,
 	return false;
 }
 
-static void xgbe_ecc_isr_task(unsigned long data)
+static void xgbe_ecc_isr_task(struct tasklet_struct *t)
 {
-	struct xgbe_prv_data *pdata = (struct xgbe_prv_data *)data;
+	struct xgbe_prv_data *pdata = from_tasklet(pdata, t, tasklet_ecc);
 	unsigned int ecc_isr;
 	bool stop = false;
 
@@ -468,14 +468,14 @@ static irqreturn_t xgbe_ecc_isr(int irq, void *data)
 	if (pdata->isr_as_tasklet)
 		tasklet_schedule(&pdata->tasklet_ecc);
 	else
-		xgbe_ecc_isr_task((unsigned long)pdata);
+		xgbe_ecc_isr_task(&pdata->tasklet_ecc);
 
 	return IRQ_HANDLED;
 }
 
-static void xgbe_isr_task(unsigned long data)
+static void xgbe_isr_task(struct tasklet_struct *t)
 {
-	struct xgbe_prv_data *pdata = (struct xgbe_prv_data *)data;
+	struct xgbe_prv_data *pdata = from_tasklet(pdata, t, tasklet_dev);
 	struct xgbe_hw_if *hw_if = &pdata->hw_if;
 	struct xgbe_channel *channel;
 	unsigned int dma_isr, dma_ch_isr;
@@ -582,7 +582,7 @@ static void xgbe_isr_task(unsigned long data)
 
 	/* If there is not a separate ECC irq, handle it here */
 	if (pdata->vdata->ecc_support && (pdata->dev_irq == pdata->ecc_irq))
-		xgbe_ecc_isr_task((unsigned long)pdata);
+		xgbe_ecc_isr_task(&pdata->tasklet_ecc);
 
 	/* If there is not a separate I2C irq, handle it here */
 	if (pdata->vdata->i2c_support && (pdata->dev_irq == pdata->i2c_irq))
@@ -607,7 +607,7 @@ static irqreturn_t xgbe_isr(int irq, void *data)
 	if (pdata->isr_as_tasklet)
 		tasklet_schedule(&pdata->tasklet_dev);
 	else
-		xgbe_isr_task((unsigned long)pdata);
+		xgbe_isr_task(&pdata->tasklet_dev);
 
 	return IRQ_HANDLED;
 }
@@ -1065,9 +1065,8 @@ static int xgbe_request_irqs(struct xgbe_prv_data *pdata)
 	unsigned int i;
 	int ret;
 
-	tasklet_init(&pdata->tasklet_dev, xgbe_isr_task, (unsigned long)pdata);
-	tasklet_init(&pdata->tasklet_ecc, xgbe_ecc_isr_task,
-		     (unsigned long)pdata);
+	tasklet_setup(&pdata->tasklet_dev, xgbe_isr_task);
+	tasklet_setup(&pdata->tasklet_ecc, xgbe_ecc_isr_task);
 
 	ret = devm_request_irq(pdata->dev, pdata->dev_irq, xgbe_isr, 0,
 			       netdev_name(netdev), pdata);
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-i2c.c b/drivers/net/ethernet/amd/xgbe/xgbe-i2c.c
index 4d9062d35930..22d4fc547a0a 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-i2c.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-i2c.c
@@ -274,9 +274,9 @@ static void xgbe_i2c_clear_isr_interrupts(struct xgbe_prv_data *pdata,
 		XI2C_IOREAD(pdata, IC_CLR_STOP_DET);
 }
 
-static void xgbe_i2c_isr_task(unsigned long data)
+static void xgbe_i2c_isr_task(struct tasklet_struct *t)
 {
-	struct xgbe_prv_data *pdata = (struct xgbe_prv_data *)data;
+	struct xgbe_prv_data *pdata = from_tasklet(pdata, t, tasklet_i2c);
 	struct xgbe_i2c_op_state *state = &pdata->i2c.op_state;
 	unsigned int isr;
 
@@ -324,7 +324,7 @@ static irqreturn_t xgbe_i2c_isr(int irq, void *data)
 	if (pdata->isr_as_tasklet)
 		tasklet_schedule(&pdata->tasklet_i2c);
 	else
-		xgbe_i2c_isr_task((unsigned long)pdata);
+		xgbe_i2c_isr_task(&pdata->tasklet_i2c);
 
 	return IRQ_HANDLED;
 }
@@ -369,7 +369,7 @@ static void xgbe_i2c_set_target(struct xgbe_prv_data *pdata, unsigned int addr)
 
 static irqreturn_t xgbe_i2c_combined_isr(struct xgbe_prv_data *pdata)
 {
-	xgbe_i2c_isr_task((unsigned long)pdata);
+	xgbe_i2c_isr_task(&pdata->tasklet_i2c);
 
 	return IRQ_HANDLED;
 }
@@ -462,8 +462,7 @@ static int xgbe_i2c_start(struct xgbe_prv_data *pdata)
 
 	/* If we have a separate I2C irq, enable it */
 	if (pdata->dev_irq != pdata->i2c_irq) {
-		tasklet_init(&pdata->tasklet_i2c, xgbe_i2c_isr_task,
-			     (unsigned long)pdata);
+		tasklet_setup(&pdata->tasklet_i2c, xgbe_i2c_isr_task);
 
 		ret = devm_request_irq(pdata->dev, pdata->i2c_irq,
 				       xgbe_i2c_isr, 0, pdata->i2c_name,
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
index 8a3a60bb2688..93ef5a30cb8d 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
@@ -688,9 +688,9 @@ static void xgbe_an73_isr(struct xgbe_prv_data *pdata)
 	}
 }
 
-static void xgbe_an_isr_task(unsigned long data)
+static void xgbe_an_isr_task(struct tasklet_struct *t)
 {
-	struct xgbe_prv_data *pdata = (struct xgbe_prv_data *)data;
+	struct xgbe_prv_data *pdata = from_tasklet(pdata, t, tasklet_an);
 
 	netif_dbg(pdata, intr, pdata->netdev, "AN interrupt received\n");
 
@@ -715,14 +715,14 @@ static irqreturn_t xgbe_an_isr(int irq, void *data)
 	if (pdata->isr_as_tasklet)
 		tasklet_schedule(&pdata->tasklet_an);
 	else
-		xgbe_an_isr_task((unsigned long)pdata);
+		xgbe_an_isr_task(&pdata->tasklet_an);
 
 	return IRQ_HANDLED;
 }
 
 static irqreturn_t xgbe_an_combined_isr(struct xgbe_prv_data *pdata)
 {
-	xgbe_an_isr_task((unsigned long)pdata);
+	xgbe_an_isr_task(&pdata->tasklet_an);
 
 	return IRQ_HANDLED;
 }
@@ -1414,8 +1414,7 @@ static int xgbe_phy_start(struct xgbe_prv_data *pdata)
 
 	/* If we have a separate AN irq, enable it */
 	if (pdata->dev_irq != pdata->an_irq) {
-		tasklet_init(&pdata->tasklet_an, xgbe_an_isr_task,
-			     (unsigned long)pdata);
+		tasklet_setup(&pdata->tasklet_an, xgbe_an_isr_task);
 
 		ret = devm_request_irq(pdata->dev, pdata->an_irq,
 				       xgbe_an_isr, 0, pdata->an_name,
diff --git a/drivers/net/ethernet/broadcom/cnic.c b/drivers/net/ethernet/broadcom/cnic.c
index 155599dcee76..3112c807c3e8 100644
--- a/drivers/net/ethernet/broadcom/cnic.c
+++ b/drivers/net/ethernet/broadcom/cnic.c
@@ -3010,10 +3010,10 @@ static int cnic_service_bnx2(void *data, void *status_blk)
 	return cnic_service_bnx2_queues(dev);
 }
 
-static void cnic_service_bnx2_msix(unsigned long data)
+static void cnic_service_bnx2_msix(struct tasklet_struct *t)
 {
-	struct cnic_dev *dev = (struct cnic_dev *) data;
-	struct cnic_local *cp = dev->cnic_priv;
+	struct cnic_local *cp = from_tasklet(cp, t, cnic_irq_task);
+	struct cnic_dev *dev = cp->dev;
 
 	cp->last_status_idx = cnic_service_bnx2_queues(dev);
 
@@ -3135,10 +3135,10 @@ static u32 cnic_service_bnx2x_kcq(struct cnic_dev *dev, struct kcq_info *info)
 	return last_status;
 }
 
-static void cnic_service_bnx2x_bh(unsigned long data)
+static void cnic_service_bnx2x_bh(struct tasklet_struct *t)
 {
-	struct cnic_dev *dev = (struct cnic_dev *) data;
-	struct cnic_local *cp = dev->cnic_priv;
+	struct cnic_local *cp = from_tasklet(cp, t, cnic_irq_task);
+	struct cnic_dev *dev = cp->dev;
 	struct bnx2x *bp = netdev_priv(dev->netdev);
 	u32 status_idx, new_status_idx;
 
@@ -4459,8 +4459,7 @@ static int cnic_init_bnx2_irq(struct cnic_dev *dev)
 		CNIC_WR(dev, base + BNX2_HC_CMD_TICKS_OFF, (64 << 16) | 220);
 
 		cp->last_status_idx = cp->status_blk.bnx2->status_idx;
-		tasklet_init(&cp->cnic_irq_task, cnic_service_bnx2_msix,
-			     (unsigned long) dev);
+		tasklet_setup(&cp->cnic_irq_task, cnic_service_bnx2_msix);
 		err = cnic_request_irq(dev);
 		if (err)
 			return err;
@@ -4869,8 +4868,7 @@ static int cnic_init_bnx2x_irq(struct cnic_dev *dev)
 	struct cnic_eth_dev *ethdev = cp->ethdev;
 	int err = 0;
 
-	tasklet_init(&cp->cnic_irq_task, cnic_service_bnx2x_bh,
-		     (unsigned long) dev);
+	tasklet_setup(&cp->cnic_irq_task, cnic_service_bnx2x_bh);
 	if (ethdev->drv_state & CNIC_DRV_STATE_USING_MSIX)
 		err = cnic_request_irq(dev);
 
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 35b59b5edf0f..84e820799ab5 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1292,9 +1292,9 @@ static int macb_poll(struct napi_struct *napi, int budget)
 	return work_done;
 }
 
-static void macb_hresp_error_task(unsigned long data)
+static void macb_hresp_error_task(struct tasklet_struct *t)
 {
-	struct macb *bp = (struct macb *)data;
+	struct macb *bp = from_tasklet(bp, t, hresp_err_tasklet);
 	struct net_device *dev = bp->dev;
 	struct macb_queue *queue = bp->queues;
 	unsigned int q;
@@ -4335,8 +4335,7 @@ static int macb_probe(struct platform_device *pdev)
 		goto err_out_unregister_mdio;
 	}
 
-	tasklet_init(&bp->hresp_err_tasklet, macb_hresp_error_task,
-		     (unsigned long)bp);
+	tasklet_setup(&bp->hresp_err_tasklet, macb_hresp_error_task);
 
 	phy_attached_info(phydev);
 
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index 283e1461257d..433eb8fa607d 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -162,13 +162,12 @@ static int liquidio_set_vf_link_state(struct net_device *netdev, int vfidx,
 static struct handshake handshake[MAX_OCTEON_DEVICES];
 static struct completion first_stage;
 
-static void octeon_droq_bh(unsigned long pdev)
+static void octeon_droq_bh(struct tasklet_struct *t)
 {
 	int q_no;
 	int reschedule = 0;
-	struct octeon_device *oct = (struct octeon_device *)pdev;
-	struct octeon_device_priv *oct_priv =
-		(struct octeon_device_priv *)oct->priv;
+	struct octeon_device_priv *oct_priv = from_tasklet(oct_priv, t, droq_tasklet);
+	struct octeon_device *oct = oct_priv->dev;
 
 	for (q_no = 0; q_no < MAX_OCTEON_OUTPUT_QUEUES(oct); q_no++) {
 		if (!(oct->io_qmask.oq & BIT_ULL(q_no)))
@@ -4221,8 +4220,7 @@ static int octeon_device_init(struct octeon_device *octeon_dev)
 
 	/* Initialize the tasklet that handles output queue packet processing.*/
 	dev_dbg(&octeon_dev->pci_dev->dev, "Initializing droq tasklet\n");
-	tasklet_init(&oct_priv->droq_tasklet, octeon_droq_bh,
-		     (unsigned long)octeon_dev);
+	tasklet_setup(&oct_priv->droq_tasklet, octeon_droq_bh);
 
 	/* Setup the interrupt handler and record the INT SUM register address
 	 */
diff --git a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
index 0e5de88fd6e8..bf3ee371f07c 100644
--- a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
+++ b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
@@ -311,9 +311,9 @@ static void octeon_mgmt_clean_tx_buffers(struct octeon_mgmt *p)
 		netif_wake_queue(p->netdev);
 }
 
-static void octeon_mgmt_clean_tx_tasklet(unsigned long arg)
+static void octeon_mgmt_clean_tx_tasklet(struct tasklet_struct *t)
 {
-	struct octeon_mgmt *p = (struct octeon_mgmt *)arg;
+	struct octeon_mgmt *p = from_tasklet(p, t, tx_clean_tasklet);
 	octeon_mgmt_clean_tx_buffers(p);
 	octeon_mgmt_enable_tx_irq(p);
 }
@@ -1490,8 +1490,7 @@ static int octeon_mgmt_probe(struct platform_device *pdev)
 
 	skb_queue_head_init(&p->tx_list);
 	skb_queue_head_init(&p->rx_list);
-	tasklet_init(&p->tx_clean_tasklet,
-		     octeon_mgmt_clean_tx_tasklet, (unsigned long)p);
+	tasklet_setup(&p->tx_clean_tasklet, octeon_mgmt_clean_tx_tasklet);
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index 40a44dcb3d9b..2e6a71b05d49 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -985,9 +985,9 @@ static int nicvf_poll(struct napi_struct *napi, int budget)
  *
  * As of now only CQ errors are handled
  */
-static void nicvf_handle_qs_err(unsigned long data)
+static void nicvf_handle_qs_err(struct tasklet_struct *t)
 {
-	struct nicvf *nic = (struct nicvf *)data;
+	struct nicvf *nic = from_tasklet(nic, t, qs_err_task);
 	struct queue_set *qs = nic->qs;
 	int qidx;
 	u64 status;
@@ -1493,12 +1493,10 @@ int nicvf_open(struct net_device *netdev)
 	}
 
 	/* Init tasklet for handling Qset err interrupt */
-	tasklet_init(&nic->qs_err_task, nicvf_handle_qs_err,
-		     (unsigned long)nic);
+	tasklet_setup(&nic->qs_err_task, nicvf_handle_qs_err);
 
 	/* Init RBDR tasklet which will refill RBDR */
-	tasklet_init(&nic->rbdr_task, nicvf_rbdr_task,
-		     (unsigned long)nic);
+	tasklet_setup(&nic->rbdr_task, nicvf_rbdr_task);
 	INIT_DELAYED_WORK(&nic->rbdr_work, nicvf_rbdr_work);
 
 	/* Configure CPI alorithm */
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_queues.c b/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
index 4ab57d33a87e..b54b61094d40 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
@@ -460,9 +460,9 @@ void nicvf_rbdr_work(struct work_struct *work)
 }
 
 /* In Softirq context, alloc rcv buffers in atomic mode */
-void nicvf_rbdr_task(unsigned long data)
+void nicvf_rbdr_task(struct tasklet_struct *t)
 {
-	struct nicvf *nic = (struct nicvf *)data;
+	struct nicvf *nic = from_tasklet(nic, t, rbdr_task);
 
 	nicvf_refill_rbdr(nic, GFP_ATOMIC);
 	if (nic->rb_alloc_fail) {
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_queues.h b/drivers/net/ethernet/cavium/thunder/nicvf_queues.h
index bc2427c49b89..63ac0fc664dc 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_queues.h
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_queues.h
@@ -348,7 +348,7 @@ void nicvf_xdp_sq_doorbell(struct nicvf *nic, struct snd_queue *sq, int sq_num);
 
 struct sk_buff *nicvf_get_rcv_skb(struct nicvf *nic,
 				  struct cqe_rx_t *cqe_rx, bool xdp);
-void nicvf_rbdr_task(unsigned long data);
+void nicvf_rbdr_task(struct tasklet_struct *t);
 void nicvf_rbdr_work(struct work_struct *work);
 
 void nicvf_enable_intr(struct nicvf *nic, int int_type, int q_idx);
diff --git a/drivers/net/ethernet/chelsio/cxgb/sge.c b/drivers/net/ethernet/chelsio/cxgb/sge.c
index b6c656e15801..be9e28fbbacf 100644
--- a/drivers/net/ethernet/chelsio/cxgb/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb/sge.c
@@ -241,7 +241,7 @@ struct sched {
 	struct tasklet_struct sched_tsk;/* tasklet used to run scheduler */
 	struct sge *sge;
 };
-static void restart_sched(unsigned long);
+static void restart_sched(struct tasklet_struct *);
 
 
 /*
@@ -379,7 +379,7 @@ static int tx_sched_init(struct sge *sge)
 		return -ENOMEM;
 
 	pr_debug("tx_sched_init\n");
-	tasklet_init(&s->sched_tsk, restart_sched, (unsigned long) sge);
+	tasklet_setup(&s->sched_tsk, restart_sched);
 	s->sge = sge;
 	sge->tx_sched = s;
 
@@ -1303,9 +1303,10 @@ static inline void reclaim_completed_tx(struct sge *sge, struct cmdQ *q)
  * Called from tasklet. Checks the scheduler for any
  * pending skbs that can be sent.
  */
-static void restart_sched(unsigned long arg)
+static void restart_sched(struct tasklet_struct *t)
 {
-	struct sge *sge = (struct sge *) arg;
+	struct sched *s = from_tasklet(s, t, sched_tsk);
+	struct sge *sge = s->sge;
 	struct adapter *adapter = sge->adapter;
 	struct cmdQ *q = &sge->cmdQ[0];
 	struct sk_buff *skb;
diff --git a/drivers/net/ethernet/chelsio/cxgb3/sge.c b/drivers/net/ethernet/chelsio/cxgb3/sge.c
index 6dabbf1502c7..8f04bad877d5 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/sge.c
@@ -1520,11 +1520,11 @@ static int ctrl_xmit(struct adapter *adap, struct sge_txq *q,
  *
  *	Resumes transmission on a suspended Tx control queue.
  */
-static void restart_ctrlq(unsigned long data)
+static void restart_ctrlq(struct tasklet_struct *t)
 {
 	struct sk_buff *skb;
-	struct sge_qset *qs = (struct sge_qset *)data;
-	struct sge_txq *q = &qs->txq[TXQ_CTRL];
+	struct sge_qset *qs = from_tasklet(qs, t, txq[TXQ_CTRL].qresume_tsk);
+	struct sge_txq *q = &qs->txq[TXQ_CTRL]; 
 
 	spin_lock(&q->lock);
       again:reclaim_completed_tx_imm(q);
@@ -1737,10 +1737,10 @@ again:	reclaim_completed_tx(adap, q, TX_RECLAIM_CHUNK);
  *
  *	Resumes transmission on a suspended Tx offload queue.
  */
-static void restart_offloadq(unsigned long data)
+static void restart_offloadq(struct tasklet_struct *t)
 {
 	struct sk_buff *skb;
-	struct sge_qset *qs = (struct sge_qset *)data;
+	struct sge_qset *qs = from_tasklet(qs, t, txq[TXQ_OFLD].qresume_tsk);
 	struct sge_txq *q = &qs->txq[TXQ_OFLD];
 	const struct port_info *pi = netdev_priv(qs->netdev);
 	struct adapter *adap = pi->adapter;
@@ -3084,10 +3084,8 @@ int t3_sge_alloc_qset(struct adapter *adapter, unsigned int id, int nports,
 		skb_queue_head_init(&q->txq[i].sendq);
 	}
 
-	tasklet_init(&q->txq[TXQ_OFLD].qresume_tsk, restart_offloadq,
-		     (unsigned long)q);
-	tasklet_init(&q->txq[TXQ_CTRL].qresume_tsk, restart_ctrlq,
-		     (unsigned long)q);
+	tasklet_setup(&q->txq[TXQ_OFLD].qresume_tsk, restart_offloadq);
+	tasklet_setup(&q->txq[TXQ_CTRL].qresume_tsk, restart_ctrlq);
 
 	q->fl[0].gen = q->fl[1].gen = 1;
 	q->fl[0].size = p->fl_size;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index b3da81e90132..04e0534325e3 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -2101,11 +2101,11 @@ static int ctrl_xmit(struct sge_ctrl_txq *q, struct sk_buff *skb)
  *
  *	Resumes transmission on a suspended Tx control queue.
  */
-static void restart_ctrlq(unsigned long data)
+static void restart_ctrlq(struct tasklet_struct *t)
 {
 	struct sk_buff *skb;
 	unsigned int written = 0;
-	struct sge_ctrl_txq *q = (struct sge_ctrl_txq *)data;
+	struct sge_ctrl_txq *q = from_tasklet(q, t, qresume_tsk);
 
 	spin_lock(&q->sendq.lock);
 	reclaim_completed_tx_imm(&q->q);
@@ -2402,9 +2402,9 @@ static int ofld_xmit(struct sge_uld_txq *q, struct sk_buff *skb)
  *
  *	Resumes transmission on a suspended Tx offload queue.
  */
-static void restart_ofldq(unsigned long data)
+static void restart_ofldq(struct tasklet_struct *t)
 {
-	struct sge_uld_txq *q = (struct sge_uld_txq *)data;
+	struct sge_uld_txq *q = from_tasklet(q, t, qresume_tsk);
 
 	spin_lock(&q->sendq.lock);
 	q->full = 0;            /* the queue actually is completely empty now */
@@ -3899,7 +3899,7 @@ int t4_sge_alloc_ctrl_txq(struct adapter *adap, struct sge_ctrl_txq *txq,
 	init_txq(adap, &txq->q, FW_EQ_CTRL_CMD_EQID_G(ntohl(c.cmpliqid_eqid)));
 	txq->adap = adap;
 	skb_queue_head_init(&txq->sendq);
-	tasklet_init(&txq->qresume_tsk, restart_ctrlq, (unsigned long)txq);
+	tasklet_setup(&txq->qresume_tsk, restart_ctrlq);
 	txq->full = 0;
 	return 0;
 }
@@ -3974,7 +3974,7 @@ int t4_sge_alloc_uld_txq(struct adapter *adap, struct sge_uld_txq *txq,
 	init_txq(adap, &txq->q, FW_EQ_OFLD_CMD_EQID_G(ntohl(c.eqid_pkd)));
 	txq->adap = adap;
 	skb_queue_head_init(&txq->sendq);
-	tasklet_init(&txq->qresume_tsk, restart_ofldq, (unsigned long)txq);
+	tasklet_setup(&txq->qresume_tsk, restart_ofldq);
 	txq->full = 0;
 	txq->mapping_err = 0;
 	return 0;
diff --git a/drivers/net/ethernet/dlink/sundance.c b/drivers/net/ethernet/dlink/sundance.c
index 4a37a69764ce..d7fdc5bc32ca 100644
--- a/drivers/net/ethernet/dlink/sundance.c
+++ b/drivers/net/ethernet/dlink/sundance.c
@@ -437,8 +437,8 @@ static void init_ring(struct net_device *dev);
 static netdev_tx_t start_tx(struct sk_buff *skb, struct net_device *dev);
 static int reset_tx (struct net_device *dev);
 static irqreturn_t intr_handler(int irq, void *dev_instance);
-static void rx_poll(unsigned long data);
-static void tx_poll(unsigned long data);
+static void rx_poll(struct tasklet_struct *t);
+static void tx_poll(struct tasklet_struct *t);
 static void refill_rx (struct net_device *dev);
 static void netdev_error(struct net_device *dev, int intr_status);
 static void netdev_error(struct net_device *dev, int intr_status);
@@ -552,8 +552,8 @@ static int sundance_probe1(struct pci_dev *pdev,
 	np->msg_enable = (1 << debug) - 1;
 	spin_lock_init(&np->lock);
 	spin_lock_init(&np->statlock);
-	tasklet_init(&np->rx_tasklet, rx_poll, (unsigned long)dev);
-	tasklet_init(&np->tx_tasklet, tx_poll, (unsigned long)dev);
+	tasklet_setup(&np->rx_tasklet, rx_poll);
+	tasklet_setup(&np->tx_tasklet, tx_poll);
 
 	ring_space = dma_alloc_coherent(&pdev->dev, TX_TOTAL_SIZE,
 			&ring_dma, GFP_KERNEL);
@@ -1069,10 +1069,9 @@ static void init_ring(struct net_device *dev)
 	}
 }
 
-static void tx_poll (unsigned long data)
+static void tx_poll(struct tasklet_struct *t)
 {
-	struct net_device *dev = (struct net_device *)data;
-	struct netdev_private *np = netdev_priv(dev);
+	struct netdev_private *np = from_tasklet(np, t, tx_tasklet);
 	unsigned head = np->cur_task % TX_RING_SIZE;
 	struct netdev_desc *txdesc =
 		&np->tx_ring[(np->cur_tx - 1) % TX_RING_SIZE];
@@ -1327,10 +1326,10 @@ static irqreturn_t intr_handler(int irq, void *dev_instance)
 	return IRQ_RETVAL(handled);
 }
 
-static void rx_poll(unsigned long data)
+static void rx_poll(struct tasklet_struct *t)
 {
-	struct net_device *dev = (struct net_device *)data;
-	struct netdev_private *np = netdev_priv(dev);
+	struct netdev_private *np = from_tasklet(np, t, rx_tasklet);
+	struct net_device *dev = (struct net_device *)((char *)np - ALIGN(sizeof(struct net_device), NETDEV_ALIGN));
 	int entry = np->cur_rx % RX_RING_SIZE;
 	int boguscnt = np->budget;
 	void __iomem *ioaddr = np->base;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
index 79243b626ddb..714c9fd320e7 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
@@ -367,9 +367,9 @@ static void eq_irq_work(struct work_struct *work)
  * ceq_tasklet - the tasklet of the EQ that received the event
  * @ceq_data: the eq
  **/
-static void ceq_tasklet(unsigned long ceq_data)
+static void ceq_tasklet(struct tasklet_struct *t)
 {
-	struct hinic_eq *ceq = (struct hinic_eq *)ceq_data;
+	struct hinic_eq *ceq = from_tasklet(ceq, t, ceq_tasklet);
 
 	eq_irq_handler(ceq);
 }
@@ -715,8 +715,7 @@ static int init_eq(struct hinic_eq *eq, struct hinic_hwif *hwif,
 
 		INIT_WORK(&aeq_work->work, eq_irq_work);
 	} else if (type == HINIC_CEQ) {
-		tasklet_init(&eq->ceq_tasklet, ceq_tasklet,
-			     (unsigned long)eq);
+		tasklet_setup(&eq->ceq_tasklet, ceq_tasklet);
 	}
 
 	/* set the attributes of the msix entry */
diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethernet/ibm/ehea/ehea_main.c
index 13e30eba5349..cb0c8f88d851 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -1212,9 +1212,9 @@ static void ehea_parse_eqe(struct ehea_adapter *adapter, u64 eqe)
 	}
 }
 
-static void ehea_neq_tasklet(unsigned long data)
+static void ehea_neq_tasklet(struct tasklet_struct *t)
 {
-	struct ehea_adapter *adapter = (struct ehea_adapter *)data;
+	struct ehea_adapter *adapter = from_tasklet(adapter, t, neq_tasklet);
 	struct ehea_eqe *eqe;
 	u64 event_mask;
 
@@ -3417,8 +3417,7 @@ static int ehea_probe_adapter(struct platform_device *dev)
 		goto out_free_ad;
 	}
 
-	tasklet_init(&adapter->neq_tasklet, ehea_neq_tasklet,
-		     (unsigned long)adapter);
+	tasklet_setup(&adapter->neq_tasklet, ehea_neq_tasklet);
 
 	ret = ehea_create_device_sysfs(dev);
 	if (ret)
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 2e5172f61564..f5ab7f493b25 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4528,9 +4528,9 @@ static irqreturn_t ibmvnic_interrupt(int irq, void *instance)
 	return IRQ_HANDLED;
 }
 
-static void ibmvnic_tasklet(void *data)
+static void ibmvnic_tasklet(struct tasklet_struct *t)
 {
-	struct ibmvnic_adapter *adapter = data;
+	struct ibmvnic_adapter *adapter = from_tasklet(adapter, t, tasklet);
 	struct ibmvnic_crq_queue *queue = &adapter->crq;
 	union ibmvnic_crq *crq;
 	unsigned long flags;
@@ -4665,8 +4665,7 @@ static int init_crq_queue(struct ibmvnic_adapter *adapter)
 
 	retrc = 0;
 
-	tasklet_init(&adapter->tasklet, (void *)ibmvnic_tasklet,
-		     (unsigned long)adapter);
+	tasklet_setup(&adapter->tasklet, ibmvnic_tasklet);
 
 	netdev_dbg(adapter->netdev, "registering irq 0x%x\n", vdev->irq);
 	snprintf(crq->name, sizeof(crq->name), "ibmvnic-%x",
diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
index 25aa400e2e3c..3dacfe7e178a 100644
--- a/drivers/net/ethernet/jme.c
+++ b/drivers/net/ethernet/jme.c
@@ -1186,10 +1186,9 @@ jme_shutdown_nic(struct jme_adapter *jme)
 	}
 }
 
-static void
-jme_pcc_tasklet(unsigned long arg)
+static void jme_pcc_tasklet(struct tasklet_struct *t)
 {
-	struct jme_adapter *jme = (struct jme_adapter *)arg;
+	struct jme_adapter *jme = from_tasklet(jme, t, pcc_task);
 	struct net_device *netdev = jme->dev;
 
 	if (unlikely(test_bit(JME_FLAG_SHUTDOWN, &jme->flags))) {
@@ -1265,10 +1264,9 @@ jme_stop_shutdown_timer(struct jme_adapter *jme)
 	jwrite32f(jme, JME_APMC, apmc);
 }
 
-static void
-jme_link_change_tasklet(unsigned long arg)
+static void jme_link_change_tasklet(struct tasklet_struct *t)
 {
-	struct jme_adapter *jme = (struct jme_adapter *)arg;
+	struct jme_adapter *jme = from_tasklet(jme, t, linkch_task);
 	struct net_device *netdev = jme->dev;
 	int rc;
 
@@ -1344,10 +1342,9 @@ jme_link_change_tasklet(unsigned long arg)
 	atomic_inc(&jme->link_changing);
 }
 
-static void
-jme_rx_clean_tasklet(unsigned long arg)
+static void jme_rx_clean_tasklet(struct tasklet_struct *t)
 {
-	struct jme_adapter *jme = (struct jme_adapter *)arg;
+	struct jme_adapter *jme = from_tasklet(jme, t, rxclean_task);
 	struct dynpcc_info *dpi = &(jme->dpi);
 
 	jme_process_receive(jme, jme->rx_ring_size);
@@ -1379,10 +1376,9 @@ jme_poll(JME_NAPI_HOLDER(holder), JME_NAPI_WEIGHT(budget))
 	return JME_NAPI_WEIGHT_VAL(budget) - rest;
 }
 
-static void
-jme_rx_empty_tasklet(unsigned long arg)
+static void jme_rx_empty_tasklet(struct tasklet_struct *t)
 {
-	struct jme_adapter *jme = (struct jme_adapter *)arg;
+	struct jme_adapter *jme = from_tasklet(jme, t, rxempty_task);
 
 	if (unlikely(atomic_read(&jme->link_changing) != 1))
 		return;
@@ -1392,7 +1388,7 @@ jme_rx_empty_tasklet(unsigned long arg)
 
 	netif_info(jme, rx_status, jme->dev, "RX Queue Full!\n");
 
-	jme_rx_clean_tasklet(arg);
+	jme_rx_clean_tasklet(&jme->rxclean_task);
 
 	while (atomic_read(&jme->rx_empty) > 0) {
 		atomic_dec(&jme->rx_empty);
@@ -1416,10 +1412,9 @@ jme_wake_queue_if_stopped(struct jme_adapter *jme)
 
 }
 
-static void
-jme_tx_clean_tasklet(unsigned long arg)
+static void jme_tx_clean_tasklet(struct tasklet_struct *t)
 {
-	struct jme_adapter *jme = (struct jme_adapter *)arg;
+	struct jme_adapter *jme = from_tasklet(jme, t, txclean_task);
 	struct jme_ring *txring = &(jme->txring[0]);
 	struct txdesc *txdesc = txring->desc;
 	struct jme_buffer_info *txbi = txring->bufinf, *ctxbi, *ttxbi;
@@ -1834,14 +1829,10 @@ jme_open(struct net_device *netdev)
 	jme_clear_pm_disable_wol(jme);
 	JME_NAPI_ENABLE(jme);
 
-	tasklet_init(&jme->linkch_task, jme_link_change_tasklet,
-		     (unsigned long) jme);
-	tasklet_init(&jme->txclean_task, jme_tx_clean_tasklet,
-		     (unsigned long) jme);
-	tasklet_init(&jme->rxclean_task, jme_rx_clean_tasklet,
-		     (unsigned long) jme);
-	tasklet_init(&jme->rxempty_task, jme_rx_empty_tasklet,
-		     (unsigned long) jme);
+	tasklet_setup(&jme->linkch_task, jme_link_change_tasklet);
+	tasklet_setup(&jme->txclean_task, jme_tx_clean_tasklet);
+	tasklet_setup(&jme->rxclean_task, jme_rx_clean_tasklet);
+	tasklet_setup(&jme->rxempty_task, jme_rx_empty_tasklet);
 
 	rc = jme_request_irq(jme);
 	if (rc)
@@ -3042,9 +3033,7 @@ jme_init_one(struct pci_dev *pdev,
 	atomic_set(&jme->tx_cleaning, 1);
 	atomic_set(&jme->rx_empty, 1);
 
-	tasklet_init(&jme->pcc_task,
-		     jme_pcc_tasklet,
-		     (unsigned long) jme);
+	tasklet_setup(&jme->pcc_task, jme_pcc_tasklet);
 	jme->dpi.cur = PCC_P1;
 
 	jme->reg_ghc = 0;
diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/marvell/skge.c
index 0a2ec387a482..85d26fd2e3ba 100644
--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -3341,9 +3341,9 @@ static void skge_error_irq(struct skge_hw *hw)
  * because accessing phy registers requires spin wait which might
  * cause excess interrupt latency.
  */
-static void skge_extirq(unsigned long arg)
+static void skge_extirq(struct tasklet_struct *t)
 {
-	struct skge_hw *hw = (struct skge_hw *) arg;
+	struct skge_hw *hw = from_tasklet(hw, t, phy_task);
 	int port;
 
 	for (port = 0; port < hw->ports; port++) {
@@ -3930,7 +3930,7 @@ static int skge_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	hw->pdev = pdev;
 	spin_lock_init(&hw->hw_lock);
 	spin_lock_init(&hw->phy_lock);
-	tasklet_init(&hw->phy_task, skge_extirq, (unsigned long) hw);
+	tasklet_setup(&hw->phy_task, skge_extirq);
 
 	hw->regs = ioremap_nocache(pci_resource_start(pdev, 0), 0x4000);
 	if (!hw->regs) {
diff --git a/drivers/net/ethernet/mellanox/mlx4/cq.c b/drivers/net/ethernet/mellanox/mlx4/cq.c
index 65f8a4b6ed0c..3b8576b9c2f9 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cq.c
@@ -55,11 +55,11 @@
 #define TASKLET_MAX_TIME 2
 #define TASKLET_MAX_TIME_JIFFIES msecs_to_jiffies(TASKLET_MAX_TIME)
 
-void mlx4_cq_tasklet_cb(unsigned long data)
+void mlx4_cq_tasklet_cb(struct tasklet_struct *t)
 {
 	unsigned long flags;
 	unsigned long end = jiffies + TASKLET_MAX_TIME_JIFFIES;
-	struct mlx4_eq_tasklet *ctx = (struct mlx4_eq_tasklet *)data;
+	struct mlx4_eq_tasklet *ctx = from_tasklet(ctx, t, task);
 	struct mlx4_cq *mcq, *temp;
 
 	spin_lock_irqsave(&ctx->lock, flags);
diff --git a/drivers/net/ethernet/mellanox/mlx4/eq.c b/drivers/net/ethernet/mellanox/mlx4/eq.c
index c790a5fcea73..da2956e50118 100644
--- a/drivers/net/ethernet/mellanox/mlx4/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/eq.c
@@ -1057,8 +1057,7 @@ static int mlx4_create_eq(struct mlx4_dev *dev, int nent,
 	INIT_LIST_HEAD(&eq->tasklet_ctx.list);
 	INIT_LIST_HEAD(&eq->tasklet_ctx.process_list);
 	spin_lock_init(&eq->tasklet_ctx.lock);
-	tasklet_init(&eq->tasklet_ctx.task, mlx4_cq_tasklet_cb,
-		     (unsigned long)&eq->tasklet_ctx);
+	tasklet_setup(&eq->tasklet_ctx.task, mlx4_cq_tasklet_cb);
 
 	return err;
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4.h b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
index 527b52e48276..64bed7ac3836 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
@@ -1217,7 +1217,7 @@ void mlx4_cmd_use_polling(struct mlx4_dev *dev);
 int mlx4_comm_cmd(struct mlx4_dev *dev, u8 cmd, u16 param,
 		  u16 op, unsigned long timeout);
 
-void mlx4_cq_tasklet_cb(unsigned long data);
+void mlx4_cq_tasklet_cb(struct tasklet_struct *t);
 void mlx4_cq_completion(struct mlx4_dev *dev, u32 cqn);
 void mlx4_cq_event(struct mlx4_dev *dev, u32 cqn, int event_type);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cq.c b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
index 818edc63e428..84686fc9a55b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
@@ -43,11 +43,11 @@
 #define TASKLET_MAX_TIME 2
 #define TASKLET_MAX_TIME_JIFFIES msecs_to_jiffies(TASKLET_MAX_TIME)
 
-void mlx5_cq_tasklet_cb(unsigned long data)
+void mlx5_cq_tasklet_cb(struct tasklet_struct *t)
 {
 	unsigned long flags;
 	unsigned long end = jiffies + TASKLET_MAX_TIME_JIFFIES;
-	struct mlx5_eq_tasklet *ctx = (struct mlx5_eq_tasklet *)data;
+	struct mlx5_eq_tasklet *ctx = from_tasklet(ctx, t, task);
 	struct mlx5_core_cq *mcq;
 	struct mlx5_core_cq *temp;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 580c71cb9dfa..4afdb9d7385f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -802,8 +802,7 @@ static int create_comp_eqs(struct mlx5_core_dev *dev)
 		INIT_LIST_HEAD(&eq->tasklet_ctx.list);
 		INIT_LIST_HEAD(&eq->tasklet_ctx.process_list);
 		spin_lock_init(&eq->tasklet_ctx.lock);
-		tasklet_init(&eq->tasklet_ctx.task, mlx5_cq_tasklet_cb,
-			     (unsigned long)&eq->tasklet_ctx);
+		tasklet_setup(&eq->tasklet_ctx.task, mlx5_cq_tasklet_cb);
 
 		eq->irq_nb.notifier_call = mlx5_eq_comp_int;
 		param = (struct mlx5_eq_param) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
index 4c50efe4e7f1..2d674c3505df 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
@@ -405,9 +405,9 @@ static inline void mlx5_fpga_conn_cqes(struct mlx5_fpga_conn *conn,
 	mlx5_fpga_conn_arm_cq(conn);
 }
 
-static void mlx5_fpga_conn_cq_tasklet(unsigned long data)
+static void mlx5_fpga_conn_cq_tasklet(struct tasklet_struct *t)
 {
-	struct mlx5_fpga_conn *conn = (void *)data;
+	struct mlx5_fpga_conn *conn = from_tasklet(conn, t, cq.tasklet);
 
 	if (unlikely(!conn->qp.active))
 		return;
@@ -494,8 +494,7 @@ static int mlx5_fpga_conn_create_cq(struct mlx5_fpga_conn *conn, int cq_size)
 	conn->cq.mcq.event      = mlx5_fpga_conn_cq_event;
 	conn->cq.mcq.irqn       = irqn;
 	conn->cq.mcq.uar        = fdev->conn_res.uar;
-	tasklet_init(&conn->cq.tasklet, mlx5_fpga_conn_cq_tasklet,
-		     (unsigned long)conn);
+	tasklet_setup(&conn->cq.tasklet, mlx5_fpga_conn_cq_tasklet);
 
 	mlx5_fpga_dbg(fdev, "Created CQ #0x%x\n", conn->cq.mcq.cqn);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
index 4be4d2d36218..93cd9a3f1708 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
@@ -78,7 +78,7 @@ int mlx5_eq_add_cq(struct mlx5_eq *eq, struct mlx5_core_cq *cq);
 void mlx5_eq_del_cq(struct mlx5_eq *eq, struct mlx5_core_cq *cq);
 struct mlx5_eq_comp *mlx5_eqn2comp_eq(struct mlx5_core_dev *dev, int eqn);
 struct mlx5_eq *mlx5_get_async_eq(struct mlx5_core_dev *dev);
-void mlx5_cq_tasklet_cb(unsigned long data);
+void mlx5_cq_tasklet_cb(struct tasklet_struct *t);
 struct cpumask *mlx5_eq_comp_cpumask(struct mlx5_core_dev *dev, int ix);
 
 u32 mlx5_eq_poll_irq_disabled(struct mlx5_eq_comp *eq);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index 615455a21567..3c65cb537d63 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -604,9 +604,9 @@ static char *mlxsw_pci_cq_sw_cqe_get(struct mlxsw_pci_queue *q)
 	return elem;
 }
 
-static void mlxsw_pci_cq_tasklet(unsigned long data)
+static void mlxsw_pci_cq_tasklet(struct tasklet_struct *t)
 {
-	struct mlxsw_pci_queue *q = (struct mlxsw_pci_queue *) data;
+	struct mlxsw_pci_queue *q = from_tasklet(q, t, tasklet);
 	struct mlxsw_pci *mlxsw_pci = q->pci;
 	char *cqe;
 	int items = 0;
@@ -717,9 +717,9 @@ static char *mlxsw_pci_eq_sw_eqe_get(struct mlxsw_pci_queue *q)
 	return elem;
 }
 
-static void mlxsw_pci_eq_tasklet(unsigned long data)
+static void mlxsw_pci_eq_tasklet(struct tasklet_struct *t)
 {
-	struct mlxsw_pci_queue *q = (struct mlxsw_pci_queue *) data;
+	struct mlxsw_pci_queue *q = from_tasklet(q, t, tasklet);
 	struct mlxsw_pci *mlxsw_pci = q->pci;
 	u8 cq_count = mlxsw_pci_cq_count(mlxsw_pci);
 	unsigned long active_cqns[BITS_TO_LONGS(MLXSW_PCI_CQS_MAX)];
@@ -776,7 +776,7 @@ struct mlxsw_pci_queue_ops {
 		    struct mlxsw_pci_queue *q);
 	void (*fini)(struct mlxsw_pci *mlxsw_pci,
 		     struct mlxsw_pci_queue *q);
-	void (*tasklet)(unsigned long data);
+	void (*tasklet)(struct tasklet_struct *t);
 	u16 (*elem_count_f)(const struct mlxsw_pci_queue *q);
 	u8 (*elem_size_f)(const struct mlxsw_pci_queue *q);
 	u16 elem_count;
@@ -839,7 +839,7 @@ static int mlxsw_pci_queue_init(struct mlxsw_pci *mlxsw_pci, char *mbox,
 	q->pci = mlxsw_pci;
 
 	if (q_ops->tasklet)
-		tasklet_init(&q->tasklet, q_ops->tasklet, (unsigned long) q);
+		tasklet_setup(&q->tasklet, q_ops->tasklet);
 
 	mem_item->size = MLXSW_PCI_AQ_SIZE;
 	mem_item->buf = pci_alloc_consistent(mlxsw_pci->pdev,
diff --git a/drivers/net/ethernet/micrel/ks8842.c b/drivers/net/ethernet/micrel/ks8842.c
index da329ca115cc..6a795c0db704 100644
--- a/drivers/net/ethernet/micrel/ks8842.c
+++ b/drivers/net/ethernet/micrel/ks8842.c
@@ -587,10 +587,11 @@ static int __ks8842_start_new_rx_dma(struct net_device *netdev)
 	return err;
 }
 
-static void ks8842_rx_frame_dma_tasklet(unsigned long arg)
+static void ks8842_rx_frame_dma_tasklet(struct tasklet_struct *t)
 {
-	struct net_device *netdev = (struct net_device *)arg;
-	struct ks8842_adapter *adapter = netdev_priv(netdev);
+	struct ks8842_adapter *adapter = from_tasklet(adapter, t, dma_rx.tasklet);
+	struct net_device *netdev = (struct net_device *)((char *)adapter -
+				ALIGN(sizeof(struct net_device), NETDEV_ALIGN));
 	struct ks8842_rx_dma_ctl *ctl = &adapter->dma_rx;
 	struct sk_buff *skb = ctl->skb;
 	dma_addr_t addr = sg_dma_address(&ctl->sg);
@@ -720,10 +721,11 @@ static void ks8842_handle_rx_overrun(struct net_device *netdev,
 	netdev->stats.rx_fifo_errors++;
 }
 
-static void ks8842_tasklet(unsigned long arg)
+static void ks8842_tasklet(struct tasklet_struct *t)
 {
-	struct net_device *netdev = (struct net_device *)arg;
-	struct ks8842_adapter *adapter = netdev_priv(netdev);
+	struct ks8842_adapter *adapter = from_tasklet(adapter, t, tasklet);
+	struct net_device *netdev = (struct net_device *)((char *)adapter -
+				ALIGN(sizeof(struct net_device), NETDEV_ALIGN));
 	u16 isr;
 	unsigned long flags;
 	u16 entry_bank;
@@ -953,8 +955,7 @@ static int ks8842_alloc_dma_bufs(struct net_device *netdev)
 		goto err;
 	}
 
-	tasklet_init(&rx_ctl->tasklet, ks8842_rx_frame_dma_tasklet,
-		(unsigned long)netdev);
+	tasklet_setup(&rx_ctl->tasklet, ks8842_rx_frame_dma_tasklet);
 
 	return 0;
 err:
@@ -1173,7 +1174,7 @@ static int ks8842_probe(struct platform_device *pdev)
 		adapter->dma_tx.channel = -1;
 	}
 
-	tasklet_init(&adapter->tasklet, ks8842_tasklet, (unsigned long)netdev);
+	tasklet_setup(&adapter->tasklet, ks8842_tasklet);
 	spin_lock_init(&adapter->lock);
 
 	netdev->netdev_ops = &ks8842_netdev_ops;
diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index e102e1560ac7..7ce9bd09401f 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -5167,9 +5167,9 @@ static int dev_rcv_special(struct dev_info *hw_priv)
 	return received;
 }
 
-static void rx_proc_task(unsigned long data)
+static void rx_proc_task(struct tasklet_struct *t)
 {
-	struct dev_info *hw_priv = (struct dev_info *) data;
+	struct dev_info *hw_priv = from_tasklet(hw_priv, t, rx_tasklet);
 	struct ksz_hw *hw = &hw_priv->hw;
 
 	if (!hw->enabled)
@@ -5189,9 +5189,9 @@ static void rx_proc_task(unsigned long data)
 	}
 }
 
-static void tx_proc_task(unsigned long data)
+static void tx_proc_task(struct tasklet_struct *t)
 {
-	struct dev_info *hw_priv = (struct dev_info *) data;
+	struct dev_info *hw_priv = from_tasklet(hw_priv, t, tx_tasklet);
 	struct ksz_hw *hw = &hw_priv->hw;
 
 	hw_ack_intr(hw, KS884X_INT_TX_MASK);
@@ -5444,10 +5444,8 @@ static int prepare_hardware(struct net_device *dev)
 	rc = request_irq(dev->irq, netdev_intr, IRQF_SHARED, dev->name, dev);
 	if (rc)
 		return rc;
-	tasklet_init(&hw_priv->rx_tasklet, rx_proc_task,
-		     (unsigned long) hw_priv);
-	tasklet_init(&hw_priv->tx_tasklet, tx_proc_task,
-		     (unsigned long) hw_priv);
+	tasklet_setup(&hw_priv->rx_tasklet, rx_proc_task);
+	tasklet_setup(&hw_priv->tx_tasklet, tx_proc_task);
 
 	hw->promiscuous = 0;
 	hw->all_multi = 0;
diff --git a/drivers/net/ethernet/natsemi/ns83820.c b/drivers/net/ethernet/natsemi/ns83820.c
index 6af9a7eee114..b41f15d81661 100644
--- a/drivers/net/ethernet/natsemi/ns83820.c
+++ b/drivers/net/ethernet/natsemi/ns83820.c
@@ -923,10 +923,10 @@ static void rx_irq(struct net_device *ndev)
 	spin_unlock_irqrestore(&info->lock, flags);
 }
 
-static void rx_action(unsigned long _dev)
+static void rx_action(struct tasklet_struct *t)
 {
-	struct net_device *ndev = (void *)_dev;
-	struct ns83820 *dev = PRIV(ndev);
+	struct ns83820 *dev = from_tasklet(dev, t, rx_tasklet);
+	struct net_device *ndev = dev->ndev;
 	rx_irq(ndev);
 	writel(ihr, dev->base + IHR);
 
@@ -1927,7 +1927,7 @@ static int ns83820_init_one(struct pci_dev *pci_dev,
 	SET_NETDEV_DEV(ndev, &pci_dev->dev);
 
 	INIT_WORK(&dev->tq_refill, queue_refill);
-	tasklet_init(&dev->rx_tasklet, rx_action, (unsigned long)ndev);
+	tasklet_setup(&dev->rx_tasklet, rx_action);
 
 	err = pci_enable_device(pci_dev);
 	if (err) {
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 61aabffc8888..4dfef6256e05 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2281,9 +2281,9 @@ static bool nfp_ctrl_rx(struct nfp_net_r_vector *r_vec)
 	return budget;
 }
 
-static void nfp_ctrl_poll(unsigned long arg)
+static void nfp_ctrl_poll(struct tasklet_struct *t)
 {
-	struct nfp_net_r_vector *r_vec = (void *)arg;
+	struct nfp_net_r_vector *r_vec = from_tasklet(r_vec, t, tasklet);
 
 	spin_lock(&r_vec->lock);
 	nfp_net_tx_complete(r_vec->tx_ring, 0);
@@ -2331,8 +2331,7 @@ static void nfp_net_vecs_init(struct nfp_net *nn)
 
 			__skb_queue_head_init(&r_vec->queue);
 			spin_lock_init(&r_vec->lock);
-			tasklet_init(&r_vec->tasklet, nfp_ctrl_poll,
-				     (unsigned long)r_vec);
+			tasklet_setup(&r_vec->tasklet, nfp_ctrl_poll);
 			tasklet_disable(&r_vec->tasklet);
 		}
 
diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
index 0b384f97d2fd..f2c70907c7b3 100644
--- a/drivers/net/ethernet/ni/nixge.c
+++ b/drivers/net/ethernet/ni/nixge.c
@@ -786,9 +786,9 @@ static irqreturn_t nixge_rx_irq(int irq, void *_ndev)
 	return IRQ_HANDLED;
 }
 
-static void nixge_dma_err_handler(unsigned long data)
+static void nixge_dma_err_handler(struct tasklet_struct *t)
 {
-	struct nixge_priv *lp = (struct nixge_priv *)data;
+	struct nixge_priv *lp = from_tasklet(lp, t, dma_err_tasklet);
 	struct nixge_hw_dma_bd *cur_p;
 	struct nixge_tx_skb *tx_skb;
 	u32 cr, i;
@@ -878,8 +878,7 @@ static int nixge_open(struct net_device *ndev)
 	phy_start(phy);
 
 	/* Enable tasklets for Axi DMA error handling */
-	tasklet_init(&priv->dma_err_tasklet, nixge_dma_err_handler,
-		     (unsigned long)priv);
+	tasklet_setup(&priv->dma_err_tasklet, nixge_dma_err_handler);
 
 	napi_enable(&priv->napi);
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.c b/drivers/net/ethernet/qlogic/qed/qed_int.c
index 7e1ef7b281b5..4cb548809281 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.c
@@ -1210,9 +1210,9 @@ static void qed_sb_ack_attn(struct qed_hwfn *p_hwfn,
 	barrier();
 }
 
-void qed_int_sp_dpc(unsigned long hwfn_cookie)
+void qed_int_sp_dpc(struct tasklet_struct *t)
 {
-	struct qed_hwfn *p_hwfn = (struct qed_hwfn *)hwfn_cookie;
+	struct qed_hwfn *p_hwfn = from_tasklet(p_hwfn, t, sp_dpc);
 	struct qed_pi_info *pi_info = NULL;
 	struct qed_sb_attn_info *sb_attn;
 	struct qed_sb_info *sb_info;
@@ -2279,8 +2279,7 @@ u64 qed_int_igu_read_sisr_reg(struct qed_hwfn *p_hwfn)
 
 static void qed_int_sp_dpc_setup(struct qed_hwfn *p_hwfn)
 {
-	tasklet_init(&p_hwfn->sp_dpc,
-		     qed_int_sp_dpc, (unsigned long)p_hwfn);
+	tasklet_setup(&p_hwfn->sp_dpc, qed_int_sp_dpc);
 	p_hwfn->b_sp_dpc_enabled = true;
 }
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.h b/drivers/net/ethernet/qlogic/qed/qed_int.h
index d473b522afc5..4f945f253a8d 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.h
@@ -166,7 +166,7 @@ int qed_int_sb_release(struct qed_hwfn *p_hwfn,
  * @param p_hwfn - pointer to hwfn
  *
  */
-void qed_int_sp_dpc(unsigned long hwfn_cookie);
+void qed_int_sp_dpc(struct tasklet_struct *t);
 
 /**
  * @brief qed_int_get_num_sbs - get the number of status
diff --git a/drivers/net/ethernet/silan/sc92031.c b/drivers/net/ethernet/silan/sc92031.c
index c7641a236eb8..eb4a1ec30e15 100644
--- a/drivers/net/ethernet/silan/sc92031.c
+++ b/drivers/net/ethernet/silan/sc92031.c
@@ -829,10 +829,11 @@ static void _sc92031_link_tasklet(struct net_device *dev)
 	}
 }
 
-static void sc92031_tasklet(unsigned long data)
+static void sc92031_tasklet(struct tasklet_struct *t)
 {
-	struct net_device *dev = (struct net_device *)data;
-	struct sc92031_priv *priv = netdev_priv(dev);
+	struct  sc92031_priv *priv = from_tasklet(priv, t, tasklet); 
+	struct net_device *dev = (struct net_device *)((char *)priv -
+				ALIGN(sizeof(struct net_device), NETDEV_ALIGN));
 	void __iomem *port_base = priv->port_base;
 	u32 intr_status, intr_mask;
 
@@ -1108,7 +1109,7 @@ static void sc92031_poll_controller(struct net_device *dev)
 
 	disable_irq(irq);
 	if (sc92031_interrupt(irq, dev) != IRQ_NONE)
-		sc92031_tasklet((unsigned long)dev);
+		sc92031_tasklet(&priv->tasklet);
 	enable_irq(irq);
 }
 #endif
@@ -1446,7 +1447,7 @@ static int sc92031_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	spin_lock_init(&priv->lock);
 	priv->port_base = port_base;
 	priv->pdev = pdev;
-	tasklet_init(&priv->tasklet, sc92031_tasklet, (unsigned long)dev);
+	tasklet_setup(&priv->tasklet, sc92031_tasklet);
 	/* Fudge tasklet count so the call to sc92031_enable_interrupts at
 	 * sc92031_open will work correctly */
 	tasklet_disable_nosync(&priv->tasklet);
diff --git a/drivers/net/ethernet/smsc/smc91x.c b/drivers/net/ethernet/smsc/smc91x.c
index 3a6761131f4c..771e978ff93a 100644
--- a/drivers/net/ethernet/smsc/smc91x.c
+++ b/drivers/net/ethernet/smsc/smc91x.c
@@ -535,10 +535,10 @@ static inline void  smc_rcv(struct net_device *dev)
 /*
  * This is called to actually send a packet to the chip.
  */
-static void smc_hardware_send_pkt(unsigned long data)
+static void smc_hardware_send_pkt(struct tasklet_struct *t)
 {
-	struct net_device *dev = (struct net_device *)data;
-	struct smc_local *lp = netdev_priv(dev);
+	struct smc_local *lp = from_tasklet(lp, t, tx_task);
+	struct net_device *dev = lp->dev;
 	void __iomem *ioaddr = lp->base;
 	struct sk_buff *skb;
 	unsigned int packet_no, len;
@@ -1965,7 +1965,7 @@ static int smc_probe(struct net_device *dev, void __iomem *ioaddr,
 	dev->netdev_ops = &smc_netdev_ops;
 	dev->ethtool_ops = &smc_ethtool_ops;
 
-	tasklet_init(&lp->tx_task, smc_hardware_send_pkt, (unsigned long)dev);
+	tasklet_setup(&lp->tx_task, smc_hardware_send_pkt);
 	INIT_WORK(&lp->phy_configure, smc_phy_configure);
 	lp->dev = dev;
 	lp->mii.phy_id_mask = 0x1f;
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 4fc627fb4d11..f24f392e9031 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -891,7 +891,7 @@ static irqreturn_t axienet_eth_irq(int irq, void *_ndev)
 	return IRQ_HANDLED;
 }
 
-static void axienet_dma_err_handler(unsigned long data);
+static void axienet_dma_err_handler(struct tasklet_struct *t);
 
 /**
  * axienet_open - Driver open routine.
@@ -936,8 +936,7 @@ static int axienet_open(struct net_device *ndev)
 	phylink_start(lp->phylink);
 
 	/* Enable tasklets for Axi DMA error handling */
-	tasklet_init(&lp->dma_err_tasklet, axienet_dma_err_handler,
-		     (unsigned long) lp);
+	tasklet_setup(&lp->dma_err_tasklet, axienet_dma_err_handler);
 
 	/* Enable interrupts for Axi DMA Tx */
 	ret = request_irq(lp->tx_irq, axienet_tx_irq, IRQF_SHARED,
@@ -1511,11 +1510,11 @@ static const struct phylink_mac_ops axienet_phylink_ops = {
  * Resets the Axi DMA and Axi Ethernet devices, and reconfigures the
  * Tx/Rx BDs.
  */
-static void axienet_dma_err_handler(unsigned long data)
+static void axienet_dma_err_handler(struct tasklet_struct *t)
 {
 	u32 axienet_status;
 	u32 cr, i;
-	struct axienet_local *lp = (struct axienet_local *) data;
+	struct axienet_local *lp = from_tasklet(lp, t, dma_err_tasklet);
 	struct net_device *ndev = lp->ndev;
 	struct axidma_bd *cur_p;
 
diff --git a/drivers/net/ifb.c b/drivers/net/ifb.c
index 242b9b0943f8..c921d95a7ef6 100644
--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -59,9 +59,9 @@ static netdev_tx_t ifb_xmit(struct sk_buff *skb, struct net_device *dev);
 static int ifb_open(struct net_device *dev);
 static int ifb_close(struct net_device *dev);
 
-static void ifb_ri_tasklet(unsigned long _txp)
+static void ifb_ri_tasklet(struct tasklet_struct *t)
 {
-	struct ifb_q_private *txp = (struct ifb_q_private *)_txp;
+	struct ifb_q_private *txp = from_tasklet(txp, t, ifb_tasklet);
 	struct netdev_queue *txq;
 	struct sk_buff *skb;
 
@@ -170,8 +170,7 @@ static int ifb_dev_init(struct net_device *dev)
 		__skb_queue_head_init(&txp->tq);
 		u64_stats_init(&txp->rsync);
 		u64_stats_init(&txp->tsync);
-		tasklet_init(&txp->ifb_tasklet, ifb_ri_tasklet,
-			     (unsigned long)txp);
+		tasklet_setup(&txp->ifb_tasklet, ifb_ri_tasklet);
 		netif_tx_start_queue(netdev_get_tx_queue(dev, i));
 	}
 	return 0;
diff --git a/drivers/net/ppp/ppp_async.c b/drivers/net/ppp/ppp_async.c
index a7b9cf3269bf..b9211c1719d5 100644
--- a/drivers/net/ppp/ppp_async.c
+++ b/drivers/net/ppp/ppp_async.c
@@ -101,7 +101,7 @@ static void ppp_async_input(struct asyncppp *ap, const unsigned char *buf,
 			    char *flags, int count);
 static int ppp_async_ioctl(struct ppp_channel *chan, unsigned int cmd,
 			   unsigned long arg);
-static void ppp_async_process(unsigned long arg);
+static void ppp_async_process(struct tasklet_struct *t);
 
 static void async_lcp_peek(struct asyncppp *ap, unsigned char *data,
 			   int len, int inbound);
@@ -179,7 +179,7 @@ ppp_asynctty_open(struct tty_struct *tty)
 	ap->lcp_fcs = -1;
 
 	skb_queue_head_init(&ap->rqueue);
-	tasklet_init(&ap->tsk, ppp_async_process, (unsigned long) ap);
+	tasklet_setup(&ap->tsk, ppp_async_process);
 
 	refcount_set(&ap->refcnt, 1);
 	init_completion(&ap->dead);
@@ -488,9 +488,9 @@ ppp_async_ioctl(struct ppp_channel *chan, unsigned int cmd, unsigned long arg)
  * to the ppp_generic code, and to tell the ppp_generic code
  * if we can accept more output now.
  */
-static void ppp_async_process(unsigned long arg)
+static void ppp_async_process(struct tasklet_struct *t)
 {
-	struct asyncppp *ap = (struct asyncppp *) arg;
+	struct asyncppp *ap = from_tasklet(ap, t, tsk);
 	struct sk_buff *skb;
 
 	/* process received packets */
diff --git a/drivers/net/ppp/ppp_synctty.c b/drivers/net/ppp/ppp_synctty.c
index 0f338752c38b..86ee5149f4f2 100644
--- a/drivers/net/ppp/ppp_synctty.c
+++ b/drivers/net/ppp/ppp_synctty.c
@@ -90,7 +90,7 @@ static struct sk_buff* ppp_sync_txmunge(struct syncppp *ap, struct sk_buff *);
 static int ppp_sync_send(struct ppp_channel *chan, struct sk_buff *skb);
 static int ppp_sync_ioctl(struct ppp_channel *chan, unsigned int cmd,
 			  unsigned long arg);
-static void ppp_sync_process(unsigned long arg);
+static void ppp_sync_process(struct tasklet_struct *t);
 static int ppp_sync_push(struct syncppp *ap);
 static void ppp_sync_flush_output(struct syncppp *ap);
 static void ppp_sync_input(struct syncppp *ap, const unsigned char *buf,
@@ -177,7 +177,7 @@ ppp_sync_open(struct tty_struct *tty)
 	ap->raccm = ~0U;
 
 	skb_queue_head_init(&ap->rqueue);
-	tasklet_init(&ap->tsk, ppp_sync_process, (unsigned long) ap);
+	tasklet_setup(&ap->tsk, ppp_sync_process);
 
 	refcount_set(&ap->refcnt, 1);
 	init_completion(&ap->dead_cmp);
@@ -480,9 +480,9 @@ ppp_sync_ioctl(struct ppp_channel *chan, unsigned int cmd, unsigned long arg)
  * to the ppp_generic code, and to tell the ppp_generic code
  * if we can accept more output now.
  */
-static void ppp_sync_process(unsigned long arg)
+static void ppp_sync_process(struct tasklet_struct *t)
 {
-	struct syncppp *ap = (struct syncppp *) arg;
+	struct syncppp *ap = from_tasklet(ap, t, tsk);
 	struct sk_buff *skb;
 
 	/* process received packets */
diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 50c05d0f44cb..0c2cfc706423 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -61,7 +61,7 @@ static bool prefer_mbim;
 module_param(prefer_mbim, bool, 0644);
 MODULE_PARM_DESC(prefer_mbim, "Prefer MBIM setting on dual NCM/MBIM functions");
 
-static void cdc_ncm_txpath_bh(unsigned long param);
+static void cdc_ncm_txpath_bh(struct tasklet_struct *t);
 static void cdc_ncm_tx_timeout_start(struct cdc_ncm_ctx *ctx);
 static enum hrtimer_restart cdc_ncm_tx_timer_cb(struct hrtimer *hr_timer);
 static struct usb_driver cdc_ncm_driver;
@@ -779,7 +779,7 @@ int cdc_ncm_bind_common(struct usbnet *dev, struct usb_interface *intf, u8 data_
 
 	hrtimer_init(&ctx->tx_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	ctx->tx_timer.function = &cdc_ncm_tx_timer_cb;
-	tasklet_init(&ctx->bh, cdc_ncm_txpath_bh, (unsigned long)dev);
+	tasklet_setup(&ctx->bh, cdc_ncm_txpath_bh);
 	atomic_set(&ctx->stop, 0);
 	spin_lock_init(&ctx->mtx);
 
@@ -1356,9 +1356,9 @@ static enum hrtimer_restart cdc_ncm_tx_timer_cb(struct hrtimer *timer)
 	return HRTIMER_NORESTART;
 }
 
-static void cdc_ncm_txpath_bh(unsigned long param)
+static void cdc_ncm_txpath_bh(struct tasklet_struct *t)
 {
-	struct usbnet *dev = (struct usbnet *)param;
+	struct usbnet *dev = from_tasklet(dev, t, bh);
 	struct cdc_ncm_ctx *ctx = (struct cdc_ncm_ctx *)dev->data[0];
 
 	spin_lock_bh(&ctx->mtx);
diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index ce78714f536f..811d4250c3f0 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -1214,8 +1214,9 @@ static void hso_std_serial_read_bulk_callback(struct urb *urb)
  * This needs to be a tasklet otherwise we will
  * end up recursively calling this function.
  */
-static void hso_unthrottle_tasklet(struct hso_serial *serial)
+static void hso_unthrottle_tasklet(struct tasklet_struct *t)
 {
+	struct hso_serial *serial = from_tasklet(serial, t, unthrottle_tasklet);
 	unsigned long flags;
 
 	spin_lock_irqsave(&serial->serial_lock, flags);
@@ -1264,9 +1265,8 @@ static int hso_serial_open(struct tty_struct *tty, struct file *filp)
 		serial->rx_state = RX_IDLE;
 		/* Force default termio settings */
 		_hso_serial_set_termios(tty, NULL);
-		tasklet_init(&serial->unthrottle_tasklet,
-			     (void (*)(unsigned long))hso_unthrottle_tasklet,
-			     (unsigned long)serial);
+		tasklet_setup(&serial->unthrottle_tasklet,
+			hso_unthrottle_tasklet);
 		result = hso_start_serial_device(serial->parent, GFP_KERNEL);
 		if (result) {
 			hso_stop_serial_device(serial->parent);
diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 58f5a219fb65..ea966aa47119 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -3462,9 +3462,9 @@ static void lan78xx_rx_bh(struct lan78xx_net *dev)
 		netif_wake_queue(dev->net);
 }
 
-static void lan78xx_bh(unsigned long param)
+static void lan78xx_bh(struct tasklet_struct *t)
 {
-	struct lan78xx_net *dev = (struct lan78xx_net *)param;
+	struct lan78xx_net *dev = from_tasklet(dev, t, bh);
 	struct sk_buff *skb;
 	struct skb_data *entry;
 
@@ -3727,7 +3727,7 @@ static int lan78xx_probe(struct usb_interface *intf,
 	skb_queue_head_init(&dev->txq_pend);
 	mutex_init(&dev->phy_mutex);
 
-	tasklet_init(&dev->bh, lan78xx_bh, (unsigned long)dev);
+	tasklet_setup(&dev->bh, lan78xx_bh);
 	INIT_DELAYED_WORK(&dev->wq, lan78xx_delayedwork);
 	init_usb_anchor(&dev->deferred);
 
diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index f7d117d80cfb..221b46f66082 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -564,12 +564,12 @@ static void read_bulk_callback(struct urb *urb)
 	tasklet_schedule(&pegasus->rx_tl);
 }
 
-static void rx_fixup(unsigned long data)
+static void rx_fixup(struct tasklet_struct *t)
 {
 	pegasus_t *pegasus;
 	int status;
 
-	pegasus = (pegasus_t *) data;
+	pegasus = from_tasklet(pegasus, t, rx_tl);
 	if (pegasus->flags & PEGASUS_UNPLUG)
 		return;
 
@@ -1165,7 +1165,7 @@ static int pegasus_probe(struct usb_interface *intf,
 		goto out1;
 	}
 
-	tasklet_init(&pegasus->rx_tl, rx_fixup, (unsigned long) pegasus);
+	tasklet_setup(&pegasus->rx_tl, rx_fixup);
 
 	INIT_DELAYED_WORK(&pegasus->carrier_check, check_carrier);
 
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 08726090570e..421e4f075670 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -2210,11 +2210,9 @@ static void tx_bottom(struct r8152 *tp)
 	} while (res == 0);
 }
 
-static void bottom_half(unsigned long data)
+static void bottom_half(struct tasklet_struct *t)
 {
-	struct r8152 *tp;
-
-	tp = (struct r8152 *)data;
+	struct r8152 *tp = from_tasklet(tp, t, tx_tl);
 
 	if (test_bit(RTL8152_UNPLUG, &tp->flags))
 		return;
@@ -5610,7 +5608,7 @@ static int rtl8152_probe(struct usb_interface *intf,
 	mutex_init(&tp->control);
 	INIT_DELAYED_WORK(&tp->schedule, rtl_work_func_t);
 	INIT_DELAYED_WORK(&tp->hw_phy_work, rtl_hw_phy_work_func_t);
-	tasklet_init(&tp->tx_tl, bottom_half, (unsigned long)tp);
+	tasklet_setup(&tp->tx_tl, bottom_half);
 	tasklet_disable(&tp->tx_tl);
 
 	netdev->netdev_ops = &rtl8152_netdev_ops;
diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
index 13e51ccf0214..3a5c628f79b7 100644
--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -589,9 +589,9 @@ static void free_skb_pool(rtl8150_t *dev)
 		dev_kfree_skb(dev->rx_skb_pool[i]);
 }
 
-static void rx_fixup(unsigned long data)
+static void rx_fixup(struct tasklet_struct *t)
 {
-	struct rtl8150 *dev = (struct rtl8150 *)data;
+	struct rtl8150 *dev = from_tasklet(dev, t, tl);
 	struct sk_buff *skb;
 	int status;
 
@@ -890,7 +890,7 @@ static int rtl8150_probe(struct usb_interface *intf,
 		return -ENOMEM;
 	}
 
-	tasklet_init(&dev->tl, rx_fixup, (unsigned long)dev);
+	tasklet_setup(&dev->tl, rx_fixup);
 	spin_lock_init(&dev->rx_pool_lock);
 
 	dev->udev = udev;
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 58952a79b05f..1c4817c05d3c 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1692,8 +1692,8 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 	skb_queue_head_init (&dev->txq);
 	skb_queue_head_init (&dev->done);
 	skb_queue_head_init(&dev->rxq_pause);
-	dev->bh.func = (void (*)(unsigned long))usbnet_bh;
-	dev->bh.data = (unsigned long)&dev->delay;
+	dev->bh.func = (TASKLET_FUNC_TYPE)usbnet_bh;
+	dev->bh.data = (TASKLET_DATA_TYPE)&dev->delay;
 	INIT_WORK (&dev->kevent, usbnet_deferred_kevent);
 	init_usb_anchor(&dev->deferred);
 	timer_setup(&dev->delay, usbnet_bh, 0);
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 65a4c142640d..2781dcd534a9 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1536,12 +1536,12 @@ ath5k_set_current_imask(struct ath5k_hw *ah)
 }
 
 static void
-ath5k_tasklet_rx(unsigned long data)
+ath5k_tasklet_rx(struct tasklet_struct *t)
 {
 	struct ath5k_rx_status rs = {};
 	struct sk_buff *skb, *next_skb;
 	dma_addr_t next_skb_addr;
-	struct ath5k_hw *ah = (void *)data;
+	struct ath5k_hw *ah = from_tasklet(ah, t, rxtq);
 	struct ath_common *common = ath5k_hw_common(ah);
 	struct ath5k_buf *bf;
 	struct ath5k_desc *ds;
@@ -1784,10 +1784,10 @@ ath5k_tx_processq(struct ath5k_hw *ah, struct ath5k_txq *txq)
 }
 
 static void
-ath5k_tasklet_tx(unsigned long data)
+ath5k_tasklet_tx(struct tasklet_struct *t)
 {
 	int i;
-	struct ath5k_hw *ah = (void *)data;
+	struct ath5k_hw *ah = from_tasklet(ah, t, txtq);
 
 	for (i = 0; i < AR5K_NUM_TX_QUEUES; i++)
 		if (ah->txqs[i].setup && (ah->ah_txq_isr_txok_all & BIT(i)))
@@ -2176,9 +2176,9 @@ ath5k_beacon_config(struct ath5k_hw *ah)
 	spin_unlock_bh(&ah->block);
 }
 
-static void ath5k_tasklet_beacon(unsigned long data)
+static void ath5k_tasklet_beacon(struct tasklet_struct *t)
 {
-	struct ath5k_hw *ah = (struct ath5k_hw *) data;
+	struct ath5k_hw *ah = from_tasklet(ah, t, beacontq);
 
 	/*
 	 * Software beacon alert--time to send a beacon.
@@ -2447,9 +2447,9 @@ ath5k_calibrate_work(struct work_struct *work)
 
 
 static void
-ath5k_tasklet_ani(unsigned long data)
+ath5k_tasklet_ani(struct tasklet_struct *t)
 {
-	struct ath5k_hw *ah = (void *)data;
+	struct ath5k_hw *ah = from_tasklet(ah, t, ani_tasklet);
 
 	ah->ah_cal_mask |= AR5K_CALIBRATION_ANI;
 	ath5k_ani_calibration(ah);
@@ -3069,10 +3069,10 @@ ath5k_init(struct ieee80211_hw *hw)
 		hw->queues = 1;
 	}
 
-	tasklet_init(&ah->rxtq, ath5k_tasklet_rx, (unsigned long)ah);
-	tasklet_init(&ah->txtq, ath5k_tasklet_tx, (unsigned long)ah);
-	tasklet_init(&ah->beacontq, ath5k_tasklet_beacon, (unsigned long)ah);
-	tasklet_init(&ah->ani_tasklet, ath5k_tasklet_ani, (unsigned long)ah);
+	tasklet_setup(&ah->rxtq, ath5k_tasklet_rx);
+	tasklet_setup(&ah->txtq, ath5k_tasklet_tx);
+	tasklet_setup(&ah->beacontq, ath5k_tasklet_beacon);
+	tasklet_setup(&ah->ani_tasklet, ath5k_tasklet_ani);
 
 	INIT_WORK(&ah->reset_work, ath5k_reset_work);
 	INIT_WORK(&ah->calib_work, ath5k_calibrate_work);
diff --git a/drivers/net/wireless/ath/ath5k/rfkill.c b/drivers/net/wireless/ath/ath5k/rfkill.c
index 270a319f3aeb..4861a716cb29 100644
--- a/drivers/net/wireless/ath/ath5k/rfkill.c
+++ b/drivers/net/wireless/ath/ath5k/rfkill.c
@@ -72,10 +72,9 @@ ath5k_is_rfkill_set(struct ath5k_hw *ah)
 							ah->rf_kill.polarity;
 }
 
-static void
-ath5k_tasklet_rfkill_toggle(unsigned long data)
+static void ath5k_tasklet_rfkill_toggle(struct tasklet_struct *t)
 {
-	struct ath5k_hw *ah = (void *)data;
+	struct ath5k_hw *ah = from_tasklet(ah, t, rf_kill.toggleq);
 	bool blocked;
 
 	blocked = ath5k_is_rfkill_set(ah);
@@ -90,8 +89,7 @@ ath5k_rfkill_hw_start(struct ath5k_hw *ah)
 	ah->rf_kill.gpio = ah->ah_capabilities.cap_eeprom.ee_rfkill_pin;
 	ah->rf_kill.polarity = ah->ah_capabilities.cap_eeprom.ee_rfkill_pol;
 
-	tasklet_init(&ah->rf_kill.toggleq, ath5k_tasklet_rfkill_toggle,
-		(unsigned long)ah);
+	tasklet_setup(&ah->rf_kill.toggleq, ath5k_tasklet_rfkill_toggle);
 
 	ath5k_rfkill_disable(ah);
 
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index a412b352182c..e06b74a54a69 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -713,7 +713,7 @@ struct ath_beacon {
 	bool tx_last;
 };
 
-void ath9k_beacon_tasklet(unsigned long data);
+void ath9k_beacon_tasklet(struct tasklet_struct *t);
 void ath9k_beacon_config(struct ath_softc *sc, struct ieee80211_vif *main_vif,
 			 bool beacons);
 void ath9k_beacon_assign_slot(struct ath_softc *sc, struct ieee80211_vif *vif);
@@ -1117,7 +1117,7 @@ static inline void ath_read_cachesize(struct ath_common *common, int *csz)
 	common->bus_ops->read_cachesize(common, csz);
 }
 
-void ath9k_tasklet(unsigned long data);
+void ath9k_tasklet(struct tasklet_struct *t);
 int ath_cabq_update(struct ath_softc *);
 u8 ath9k_parse_mpdudensity(u8 mpdudensity);
 irqreturn_t ath_isr(int irq, void *dev);
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index e36f947e19fc..4876bff2dc2c 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -385,9 +385,9 @@ void ath9k_csa_update(struct ath_softc *sc)
 						   ath9k_csa_update_vif, sc);
 }
 
-void ath9k_beacon_tasklet(unsigned long data)
+void ath9k_beacon_tasklet(struct tasklet_struct *t)
 {
-	struct ath_softc *sc = (struct ath_softc *)data;
+	struct ath_softc *sc = from_tasklet(sc, t, bcon_tasklet);
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_buf *bf = NULL;
diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 9f64e32381f9..0a1634238e67 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -583,14 +583,14 @@ int ath9k_htc_tx_get_slot(struct ath9k_htc_priv *priv);
 void ath9k_htc_tx_clear_slot(struct ath9k_htc_priv *priv, int slot);
 void ath9k_htc_tx_drain(struct ath9k_htc_priv *priv);
 void ath9k_htc_txstatus(struct ath9k_htc_priv *priv, void *wmi_event);
-void ath9k_tx_failed_tasklet(unsigned long data);
+void ath9k_tx_failed_tasklet(struct tasklet_struct *t);
 void ath9k_htc_tx_cleanup_timer(struct timer_list *t);
 bool ath9k_htc_csa_is_finished(struct ath9k_htc_priv *priv);
 
 int ath9k_rx_init(struct ath9k_htc_priv *priv);
 void ath9k_rx_cleanup(struct ath9k_htc_priv *priv);
 void ath9k_host_rx_init(struct ath9k_htc_priv *priv);
-void ath9k_rx_tasklet(unsigned long data);
+void ath9k_rx_tasklet(struct tasklet_struct *t);
 u32 ath9k_htc_calcrxfilter(struct ath9k_htc_priv *priv);
 
 void ath9k_htc_ps_wakeup(struct ath9k_htc_priv *priv);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index d961095ab01f..b795081a4da7 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -645,10 +645,8 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv,
 	spin_lock_init(&priv->tx.tx_lock);
 	mutex_init(&priv->mutex);
 	mutex_init(&priv->htc_pm_lock);
-	tasklet_init(&priv->rx_tasklet, ath9k_rx_tasklet,
-		     (unsigned long)priv);
-	tasklet_init(&priv->tx_failed_tasklet, ath9k_tx_failed_tasklet,
-		     (unsigned long)priv);
+	tasklet_setup(&priv->rx_tasklet, ath9k_rx_tasklet);
+	tasklet_setup(&priv->tx_failed_tasklet, ath9k_tx_failed_tasklet);
 	INIT_DELAYED_WORK(&priv->ani_work, ath9k_htc_ani_work);
 	INIT_WORK(&priv->ps_work, ath9k_ps_work);
 	INIT_WORK(&priv->fatal_work, ath9k_fatal_work);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 4e8e80ac8341..f738835d5bf5 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -570,9 +570,9 @@ void ath9k_htc_tx_drain(struct ath9k_htc_priv *priv)
 	spin_unlock_bh(&priv->tx.tx_lock);
 }
 
-void ath9k_tx_failed_tasklet(unsigned long data)
+void ath9k_tx_failed_tasklet(struct tasklet_struct *t)
 {
-	struct ath9k_htc_priv *priv = (struct ath9k_htc_priv *)data;
+	struct ath9k_htc_priv *priv = from_tasklet(priv, t, tx_failed_tasklet);
 
 	spin_lock(&priv->tx.tx_lock);
 	if (priv->tx.flags & ATH9K_HTC_OP_TX_DRAIN) {
@@ -1046,9 +1046,9 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 /*
  * FIXME: Handle FLUSH later on.
  */
-void ath9k_rx_tasklet(unsigned long data)
+void ath9k_rx_tasklet(struct tasklet_struct *t)
 {
-	struct ath9k_htc_priv *priv = (struct ath9k_htc_priv *)data;
+	struct ath9k_htc_priv *priv = from_tasklet(priv, t, rx_tasklet);
 	struct ath9k_htc_rxbuf *rxbuf = NULL, *tmp_buf = NULL;
 	struct ieee80211_rx_status rx_status;
 	struct sk_buff *skb;
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 17c318902cb8..0427c64d210a 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -728,9 +728,8 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	spin_lock_init(&sc->sc_pm_lock);
 	spin_lock_init(&sc->chan_lock);
 	mutex_init(&sc->mutex);
-	tasklet_init(&sc->intr_tq, ath9k_tasklet, (unsigned long)sc);
-	tasklet_init(&sc->bcon_tasklet, ath9k_beacon_tasklet,
-		     (unsigned long)sc);
+	tasklet_setup(&sc->intr_tq, ath9k_tasklet);
+	tasklet_setup(&sc->bcon_tasklet, ath9k_beacon_tasklet);
 
 	timer_setup(&sc->sleep_timer, ath_ps_full_sleep, 0);
 	INIT_WORK(&sc->hw_reset_work, ath_reset_work);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 34121fbf32e3..4a369a3751f4 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -368,9 +368,9 @@ static void ath_node_detach(struct ath_softc *sc, struct ieee80211_sta *sta)
 	ath_dynack_node_deinit(sc->sc_ah, an);
 }
 
-void ath9k_tasklet(unsigned long data)
+void ath9k_tasklet(struct tasklet_struct *t)
 {
-	struct ath_softc *sc = (struct ath_softc *)data;
+	struct ath_softc *sc = from_tasklet(sc, t, intr_tq);
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	enum ath_reset_type type;
diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index cdc146091194..0b206779f631 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -106,8 +106,7 @@ struct wmi *ath9k_init_wmi(struct ath9k_htc_priv *priv)
 	mutex_init(&wmi->multi_rmw_mutex);
 	init_completion(&wmi->cmd_wait);
 	INIT_LIST_HEAD(&wmi->pending_tx_events);
-	tasklet_init(&wmi->wmi_event_tasklet, ath9k_wmi_event_tasklet,
-		     (unsigned long)wmi);
+	tasklet_setup(&wmi->wmi_event_tasklet, ath9k_wmi_event_tasklet);
 
 	return wmi;
 }
@@ -133,9 +132,9 @@ void ath9k_wmi_event_drain(struct ath9k_htc_priv *priv)
 	spin_unlock_irqrestore(&priv->wmi->wmi_lock, flags);
 }
 
-void ath9k_wmi_event_tasklet(unsigned long data)
+void ath9k_wmi_event_tasklet(struct tasklet_struct *t)
 {
-	struct wmi *wmi = (struct wmi *)data;
+	struct wmi *wmi = from_tasklet(wmi, t, wmi_event_tasklet);
 	struct ath9k_htc_priv *priv = wmi->drv_priv;
 	struct wmi_cmd_hdr *hdr;
 	void *wmi_event;
diff --git a/drivers/net/wireless/ath/ath9k/wmi.h b/drivers/net/wireless/ath/ath9k/wmi.h
index 380175d5ecd7..9bafd2ee32ec 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.h
+++ b/drivers/net/wireless/ath/ath9k/wmi.h
@@ -186,7 +186,7 @@ int ath9k_wmi_cmd(struct wmi *wmi, enum wmi_cmd_id cmd_id,
 		  u8 *cmd_buf, u32 cmd_len,
 		  u8 *rsp_buf, u32 rsp_len,
 		  u32 timeout);
-void ath9k_wmi_event_tasklet(unsigned long data);
+void ath9k_wmi_event_tasklet(struct tasklet_struct *t);
 void ath9k_fatal_work(struct work_struct *work);
 void ath9k_wmi_event_drain(struct ath9k_htc_priv *priv);
 
diff --git a/drivers/net/wireless/ath/carl9170/usb.c b/drivers/net/wireless/ath/carl9170/usb.c
index 486957a04bd1..149abb4a1eed 100644
--- a/drivers/net/wireless/ath/carl9170/usb.c
+++ b/drivers/net/wireless/ath/carl9170/usb.c
@@ -377,9 +377,9 @@ void carl9170_usb_handle_tx_err(struct ar9170 *ar)
 	}
 }
 
-static void carl9170_usb_tasklet(unsigned long data)
+static void carl9170_usb_tasklet(struct tasklet_struct *t)
 {
-	struct ar9170 *ar = (struct ar9170 *) data;
+	struct ar9170 *ar = from_tasklet(ar, t, usb_tasklet);
 
 	if (!IS_INITIALIZED(ar))
 		return;
@@ -1082,8 +1082,7 @@ static int carl9170_usb_probe(struct usb_interface *intf,
 	init_completion(&ar->cmd_wait);
 	init_completion(&ar->fw_boot_wait);
 	init_completion(&ar->fw_load_wait);
-	tasklet_init(&ar->usb_tasklet, carl9170_usb_tasklet,
-		     (unsigned long)ar);
+	tasklet_setup(&ar->usb_tasklet, carl9170_usb_tasklet);
 
 	atomic_set(&ar->tx_cmd_urbs, 0);
 	atomic_set(&ar->tx_anch_urbs, 0);
diff --git a/drivers/net/wireless/atmel/at76c50x-usb.c b/drivers/net/wireless/atmel/at76c50x-usb.c
index db2c3b8d491e..3a66538a0853 100644
--- a/drivers/net/wireless/atmel/at76c50x-usb.c
+++ b/drivers/net/wireless/atmel/at76c50x-usb.c
@@ -1545,10 +1545,10 @@ static inline int at76_guess_freq(struct at76_priv *priv)
 	return ieee80211_channel_to_frequency(channel, NL80211_BAND_2GHZ);
 }
 
-static void at76_rx_tasklet(unsigned long param)
+static void at76_rx_tasklet(struct tasklet_struct *t)
 {
-	struct urb *urb = (struct urb *)param;
-	struct at76_priv *priv = urb->context;
+	struct at76_priv *priv = from_tasklet(priv, t, rx_tasklet);
+	struct urb *urb = priv->rx_urb;
 	struct at76_rx_buffer *buf;
 	struct ieee80211_rx_status rx_status = { 0 };
 
@@ -2215,7 +2215,7 @@ static struct at76_priv *at76_alloc_new_device(struct usb_device *udev)
 	INIT_WORK(&priv->work_join_bssid, at76_work_join_bssid);
 	INIT_DELAYED_WORK(&priv->dwork_hw_scan, at76_dwork_hw_scan);
 
-	tasklet_init(&priv->rx_tasklet, at76_rx_tasklet, 0);
+	tasklet_setup(&priv->rx_tasklet, at76_rx_tasklet);
 
 	priv->pm_mode = AT76_PM_OFF;
 	priv->pm_period = 0;
diff --git a/drivers/net/wireless/broadcom/b43legacy/main.c b/drivers/net/wireless/broadcom/b43legacy/main.c
index 4325e91736eb..414105580902 100644
--- a/drivers/net/wireless/broadcom/b43legacy/main.c
+++ b/drivers/net/wireless/broadcom/b43legacy/main.c
@@ -1275,8 +1275,9 @@ static void handle_irq_ucode_debug(struct b43legacy_wldev *dev)
 }
 
 /* Interrupt handler bottom-half */
-static void b43legacy_interrupt_tasklet(struct b43legacy_wldev *dev)
+static void b43legacy_interrupt_tasklet(struct tasklet_struct *t)
 {
+	struct b43legacy_wldev *dev = from_tasklet(dev, t, isr_tasklet);
 	u32 reason;
 	u32 dma_reason[ARRAY_SIZE(dev->dma_reason)];
 	u32 merged_dma_reason = 0;
@@ -3740,9 +3741,7 @@ static int b43legacy_one_core_attach(struct ssb_device *dev,
 	wldev->wl = wl;
 	b43legacy_set_status(wldev, B43legacy_STAT_UNINIT);
 	wldev->bad_frames_preempt = modparam_bad_frames_preempt;
-	tasklet_init(&wldev->isr_tasklet,
-		     (void (*)(unsigned long))b43legacy_interrupt_tasklet,
-		     (unsigned long)wldev);
+	tasklet_setup(&wldev->isr_tasklet, b43legacy_interrupt_tasklet);
 	if (modparam_pio)
 		wldev->__using_pio = true;
 	INIT_LIST_HEAD(&wldev->list);
diff --git a/drivers/net/wireless/broadcom/b43legacy/pio.c b/drivers/net/wireless/broadcom/b43legacy/pio.c
index cbb761378619..aac413d0f629 100644
--- a/drivers/net/wireless/broadcom/b43legacy/pio.c
+++ b/drivers/net/wireless/broadcom/b43legacy/pio.c
@@ -264,9 +264,9 @@ static int pio_tx_packet(struct b43legacy_pio_txpacket *packet)
 	return 0;
 }
 
-static void tx_tasklet(unsigned long d)
+static void tx_tasklet(struct tasklet_struct *t)
 {
-	struct b43legacy_pioqueue *queue = (struct b43legacy_pioqueue *)d;
+	struct b43legacy_pioqueue *queue = from_tasklet(queue, t, txtask);
 	struct b43legacy_wldev *dev = queue->dev;
 	unsigned long flags;
 	struct b43legacy_pio_txpacket *packet, *tmp_packet;
@@ -331,8 +331,7 @@ struct b43legacy_pioqueue *b43legacy_setup_pioqueue(struct b43legacy_wldev *dev,
 	INIT_LIST_HEAD(&queue->txfree);
 	INIT_LIST_HEAD(&queue->txqueue);
 	INIT_LIST_HEAD(&queue->txrunning);
-	tasklet_init(&queue->txtask, tx_tasklet,
-		     (unsigned long)queue);
+	tasklet_setup(&queue->txtask, tx_tasklet);
 
 	value = b43legacy_read32(dev, B43legacy_MMIO_MACCTL);
 	value &= ~B43legacy_MACCTL_BE;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
index 6188275b17e5..8ecd25ff32da 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
@@ -983,11 +983,11 @@ static const struct ieee80211_ops brcms_ops = {
 	.set_tim = brcms_ops_beacon_set_tim,
 };
 
-void brcms_dpc(unsigned long data)
+void brcms_dpc(struct tasklet_struct *t)
 {
 	struct brcms_info *wl;
 
-	wl = (struct brcms_info *) data;
+	wl = from_tasklet(wl, t, tasklet);
 
 	spin_lock_bh(&wl->lock);
 
@@ -1150,7 +1150,7 @@ static struct brcms_info *brcms_attach(struct bcma_device *pdev)
 	init_waitqueue_head(&wl->tx_flush_wq);
 
 	/* setup the bottom half handler */
-	tasklet_init(&wl->tasklet, brcms_dpc, (unsigned long) wl);
+	tasklet_setup(&wl->tasklet, brcms_dpc);
 
 	spin_lock_init(&wl->lock);
 	spin_lock_init(&wl->isr_lock);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.h b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.h
index 198053dfc310..eaf926a96a88 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.h
@@ -106,7 +106,7 @@ struct brcms_timer *brcms_init_timer(struct brcms_info *wl,
 void brcms_free_timer(struct brcms_timer *timer);
 void brcms_add_timer(struct brcms_timer *timer, uint ms, int periodic);
 bool brcms_del_timer(struct brcms_timer *timer);
-void brcms_dpc(unsigned long data);
+void brcms_dpc(struct tasklet_struct *t);
 void brcms_timer(struct brcms_timer *t);
 void brcms_fatal_error(struct brcms_info *wl);
 
diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
index 8dfbaff2d1fe..4420c95b84d6 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -3206,8 +3206,9 @@ static void ipw2100_tx_send_data(struct ipw2100_priv *priv)
 	}
 }
 
-static void ipw2100_irq_tasklet(struct ipw2100_priv *priv)
+static void ipw2100_irq_tasklet(struct tasklet_struct *t)
 {
+	struct ipw2100_priv *priv = from_tasklet(priv, t, irq_tasklet);
 	struct net_device *dev = priv->net_dev;
 	unsigned long flags;
 	u32 inta, tmp;
@@ -6007,7 +6008,7 @@ static void ipw2100_rf_kill(struct work_struct *work)
 	spin_unlock_irqrestore(&priv->low_lock, flags);
 }
 
-static void ipw2100_irq_tasklet(struct ipw2100_priv *priv);
+static void ipw2100_irq_tasklet(struct tasklet_struct *t);
 
 static const struct net_device_ops ipw2100_netdev_ops = {
 	.ndo_open		= ipw2100_open,
@@ -6137,8 +6138,7 @@ static struct net_device *ipw2100_alloc_device(struct pci_dev *pci_dev,
 	INIT_DELAYED_WORK(&priv->rf_kill, ipw2100_rf_kill);
 	INIT_DELAYED_WORK(&priv->scan_event, ipw2100_scan_event);
 
-	tasklet_init(&priv->irq_tasklet, (void (*)(unsigned long))
-		     ipw2100_irq_tasklet, (unsigned long)priv);
+	tasklet_setup(&priv->irq_tasklet, ipw2100_irq_tasklet);
 
 	/* NOTE:  We do not start the deferred work for status checks yet */
 	priv->stop_rf_kill = 1;
diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index ed0f06532d5e..74ef15fb701d 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -1945,8 +1945,9 @@ static void notify_wx_assoc_event(struct ipw_priv *priv)
 	wireless_send_event(priv->net_dev, SIOCGIWAP, &wrqu, NULL);
 }
 
-static void ipw_irq_tasklet(struct ipw_priv *priv)
+static void ipw_irq_tasklet(struct tasklet_struct *t)
 {
+	struct ipw_priv *priv = from_tasklet(priv, t, irq_tasklet);
 	u32 inta, inta_mask, handled = 0;
 	unsigned long flags;
 	int rc = 0;
@@ -10680,8 +10681,7 @@ static int ipw_setup_deferred_work(struct ipw_priv *priv)
 	INIT_WORK(&priv->qos_activate, ipw_bg_qos_activate);
 #endif				/* CONFIG_IPW2200_QOS */
 
-	tasklet_init(&priv->irq_tasklet, (void (*)(unsigned long))
-		     ipw_irq_tasklet, (unsigned long)priv);
+	tasklet_setup(&priv->irq_tasklet, ipw_irq_tasklet);
 
 	return ret;
 }
diff --git a/drivers/net/wireless/intel/iwlegacy/3945-mac.c b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
index 4fbcc7fba3cc..bbeed63d7141 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
@@ -1376,8 +1376,9 @@ il3945_dump_nic_error_log(struct il_priv *il)
 }
 
 static void
-il3945_irq_tasklet(struct il_priv *il)
+il3945_irq_tasklet(struct tasklet_struct *t)
 {
+	struct il_priv *il = from_tasklet(il, t, irq_tasklet);
 	u32 inta, handled = 0;
 	u32 inta_fh;
 	unsigned long flags;
@@ -3402,9 +3403,7 @@ il3945_setup_deferred_work(struct il_priv *il)
 
 	timer_setup(&il->watchdog, il_bg_watchdog, 0);
 
-	tasklet_init(&il->irq_tasklet,
-		     (void (*)(unsigned long))il3945_irq_tasklet,
-		     (unsigned long)il);
+	tasklet_setup(&il->irq_tasklet, il3945_irq_tasklet);
 }
 
 static void
diff --git a/drivers/net/wireless/intel/iwlegacy/4965-mac.c b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
index ffb705b18fb1..94587592909a 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
@@ -4344,8 +4344,9 @@ il4965_synchronize_irq(struct il_priv *il)
 }
 
 static void
-il4965_irq_tasklet(struct il_priv *il)
+il4965_irq_tasklet(struct tasklet_struct *t)
 {
+	struct il_priv *il = from_tasklet(il, t, irq_tasklet);
 	u32 inta, handled = 0;
 	u32 inta_fh;
 	unsigned long flags;
@@ -6237,9 +6238,7 @@ il4965_setup_deferred_work(struct il_priv *il)
 
 	timer_setup(&il->watchdog, il_bg_watchdog, 0);
 
-	tasklet_init(&il->irq_tasklet,
-		     (void (*)(unsigned long))il4965_irq_tasklet,
-		     (unsigned long)il);
+	tasklet_setup(&il->irq_tasklet, il4965_irq_tasklet);
 }
 
 static void
diff --git a/drivers/net/wireless/intersil/hostap/hostap_hw.c b/drivers/net/wireless/intersil/hostap/hostap_hw.c
index 158a3d762e55..187095e13294 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_hw.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_hw.c
@@ -2083,9 +2083,9 @@ static void hostap_rx_skb(local_info_t *local, struct sk_buff *skb)
 
 
 /* Called only as a tasklet (software IRQ) */
-static void hostap_rx_tasklet(unsigned long data)
+static void hostap_rx_tasklet(struct tasklet_struct *t)
 {
-	local_info_t *local = (local_info_t *) data;
+	local_info_t *local = from_tasklet(local, t, rx_tasklet);
 	struct sk_buff *skb;
 
 	while ((skb = skb_dequeue(&local->rx_list)) != NULL)
@@ -2288,9 +2288,9 @@ static void prism2_tx_ev(local_info_t *local)
 
 
 /* Called only as a tasklet (software IRQ) */
-static void hostap_sta_tx_exc_tasklet(unsigned long data)
+static void hostap_sta_tx_exc_tasklet(struct tasklet_struct *t)
 {
-	local_info_t *local = (local_info_t *) data;
+	local_info_t *local = from_tasklet(local, t, sta_tx_exc_tasklet);
 	struct sk_buff *skb;
 
 	while ((skb = skb_dequeue(&local->sta_tx_exc_list)) != NULL) {
@@ -2390,9 +2390,9 @@ static void prism2_txexc(local_info_t *local)
 
 
 /* Called only as a tasklet (software IRQ) */
-static void hostap_info_tasklet(unsigned long data)
+static void hostap_info_tasklet(struct tasklet_struct *t)
 {
-	local_info_t *local = (local_info_t *) data;
+	local_info_t *local = from_tasklet(local, t, info_tasklet);
 	struct sk_buff *skb;
 
 	while ((skb = skb_dequeue(&local->info_list)) != NULL) {
@@ -2469,9 +2469,9 @@ static void prism2_info(local_info_t *local)
 
 
 /* Called only as a tasklet (software IRQ) */
-static void hostap_bap_tasklet(unsigned long data)
+static void hostap_bap_tasklet(struct tasklet_struct *t)
 {
-	local_info_t *local = (local_info_t *) data;
+	local_info_t *local = from_tasklet(local, t, bap_tasklet);
 	struct net_device *dev = local->dev;
 	u16 ev;
 	int frames = 30;
@@ -3183,7 +3183,7 @@ prism2_init_local_data(struct prism2_helper_functions *funcs, int card_idx,
 	/* Initialize tasklets for handling hardware IRQ related operations
 	 * outside hw IRQ handler */
 #define HOSTAP_TASKLET_INIT(q, f, d) \
-do { memset((q), 0, sizeof(*(q))); (q)->func = (f); (q)->data = (d); } \
+do { memset((q), 0, sizeof(*(q))); (q)->func = (TASKLET_FUNC_TYPE)(f); (q)->data = (TASKLET_DATA_TYPE)(q); } \
 while (0)
 	HOSTAP_TASKLET_INIT(&local->bap_tasklet, hostap_bap_tasklet,
 			    (unsigned long) local);
diff --git a/drivers/net/wireless/intersil/orinoco/main.c b/drivers/net/wireless/intersil/orinoco/main.c
index 28dac36d7c4c..c01ce6a5ccd0 100644
--- a/drivers/net/wireless/intersil/orinoco/main.c
+++ b/drivers/net/wireless/intersil/orinoco/main.c
@@ -1062,9 +1062,9 @@ static void orinoco_rx(struct net_device *dev,
 	stats->rx_dropped++;
 }
 
-static void orinoco_rx_isr_tasklet(unsigned long data)
+static void orinoco_rx_isr_tasklet(struct tasklet_struct *t)
 {
-	struct orinoco_private *priv = (struct orinoco_private *) data;
+	struct orinoco_private *priv = from_tasklet(priv, t, rx_tasklet);
 	struct net_device *dev = priv->ndev;
 	struct orinoco_rx_data *rx_data, *temp;
 	struct hermes_rx_descriptor *desc;
@@ -2198,8 +2198,7 @@ struct orinoco_private
 	INIT_WORK(&priv->wevent_work, orinoco_send_wevents);
 
 	INIT_LIST_HEAD(&priv->rx_list);
-	tasklet_init(&priv->rx_tasklet, orinoco_rx_isr_tasklet,
-		     (unsigned long) priv);
+	tasklet_setup(&priv->rx_tasklet, orinoco_rx_isr_tasklet);
 
 	spin_lock_init(&priv->scan_lock);
 	INIT_LIST_HEAD(&priv->scan_list);
diff --git a/drivers/net/wireless/intersil/p54/p54pci.c b/drivers/net/wireless/intersil/p54/p54pci.c
index 80ad0b7eaef4..3d2070d9e523 100644
--- a/drivers/net/wireless/intersil/p54/p54pci.c
+++ b/drivers/net/wireless/intersil/p54/p54pci.c
@@ -274,10 +274,10 @@ static void p54p_check_tx_ring(struct ieee80211_hw *dev, u32 *index,
 	}
 }
 
-static void p54p_tasklet(unsigned long dev_id)
+static void p54p_tasklet(struct tasklet_struct *t)
 {
-	struct ieee80211_hw *dev = (struct ieee80211_hw *)dev_id;
-	struct p54p_priv *priv = dev->priv;
+	struct p54p_priv *priv = from_tasklet(priv, t, tasklet);
+	struct ieee80211_hw *dev = pci_get_drvdata(priv->pdev);
 	struct p54p_ring_control *ring_control = priv->ring_control;
 
 	p54p_check_tx_ring(dev, &priv->tx_idx_mgmt, 3, ring_control->tx_mgmt,
@@ -615,7 +615,7 @@ static int p54p_probe(struct pci_dev *pdev,
 	priv->common.tx = p54p_tx;
 
 	spin_lock_init(&priv->lock);
-	tasklet_init(&priv->tasklet, p54p_tasklet, (unsigned long)dev);
+	tasklet_setup(&priv->tasklet, p54p_tasklet);
 
 	err = request_firmware_nowait(THIS_MODULE, 1, "isl3886pci",
 				      &priv->pdev->dev, GFP_KERNEL,
diff --git a/drivers/net/wireless/marvell/mwl8k.c b/drivers/net/wireless/marvell/mwl8k.c
index c4db6417748f..305da73e6940 100644
--- a/drivers/net/wireless/marvell/mwl8k.c
+++ b/drivers/net/wireless/marvell/mwl8k.c
@@ -4630,10 +4630,10 @@ static irqreturn_t mwl8k_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static void mwl8k_tx_poll(unsigned long data)
+static void mwl8k_tx_poll(struct tasklet_struct *t)
 {
-	struct ieee80211_hw *hw = (struct ieee80211_hw *)data;
-	struct mwl8k_priv *priv = hw->priv;
+	struct mwl8k_priv *priv = from_tasklet(priv, t, poll_tx_task);
+	struct ieee80211_hw *hw = pci_get_drvdata(priv->pdev);
 	int limit;
 	int i;
 
@@ -4659,10 +4659,10 @@ static void mwl8k_tx_poll(unsigned long data)
 	}
 }
 
-static void mwl8k_rx_poll(unsigned long data)
+static void mwl8k_rx_poll(struct tasklet_struct *t)
 {
-	struct ieee80211_hw *hw = (struct ieee80211_hw *)data;
-	struct mwl8k_priv *priv = hw->priv;
+	struct mwl8k_priv *priv = from_tasklet(priv, t, poll_rx_task);
+	struct ieee80211_hw *hw = pci_get_drvdata(priv->pdev);
 	int limit;
 
 	limit = 32;
@@ -6120,9 +6120,9 @@ static int mwl8k_firmware_load_success(struct mwl8k_priv *priv)
 	INIT_WORK(&priv->fw_reload, mwl8k_hw_restart_work);
 
 	/* TX reclaim and RX tasklets.  */
-	tasklet_init(&priv->poll_tx_task, mwl8k_tx_poll, (unsigned long)hw);
+	tasklet_setup(&priv->poll_tx_task, mwl8k_tx_poll);
 	tasklet_disable(&priv->poll_tx_task);
-	tasklet_init(&priv->poll_rx_task, mwl8k_rx_poll, (unsigned long)hw);
+	tasklet_setup(&priv->poll_rx_task, mwl8k_rx_poll);
 	tasklet_disable(&priv->poll_rx_task);
 
 	/* Power management cookie */
diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 1a2c143b34d0..75abbfc1bb7f 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -283,7 +283,7 @@ mt76_alloc_device(struct device *pdev, unsigned int size,
 	init_waitqueue_head(&dev->tx_wait);
 	skb_queue_head_init(&dev->status_list);
 
-	tasklet_init(&dev->tx_tasklet, mt76_tx_tasklet, (unsigned long)dev);
+	tasklet_setup(&dev->tx_tasklet, mt76_tx_tasklet);
 
 	return dev;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 570c159515a0..c0dabc269074 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -708,7 +708,7 @@ void mt76_stop_tx_queues(struct mt76_dev *dev, struct ieee80211_sta *sta,
 			 bool send_bar);
 void mt76_txq_schedule(struct mt76_dev *dev, enum mt76_txq_id qid);
 void mt76_txq_schedule_all(struct mt76_dev *dev);
-void mt76_tx_tasklet(unsigned long data);
+void mt76_tx_tasklet(struct tasklet_struct *t);
 void mt76_release_buffered_frames(struct ieee80211_hw *hw,
 				  struct ieee80211_sta *sta,
 				  u16 tids, int nframes,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c b/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
index 7a41cdf1c4ae..ab6771c6d2a6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
@@ -64,9 +64,9 @@ mt7603_add_buffered_bc(void *priv, u8 *mac, struct ieee80211_vif *vif)
 	data->count[mvif->idx]++;
 }
 
-void mt7603_pre_tbtt_tasklet(unsigned long arg)
+void mt7603_pre_tbtt_tasklet(struct tasklet_struct *t)
 {
-	struct mt7603_dev *dev = (struct mt7603_dev *)arg;
+	struct mt7603_dev *dev = from_tasklet(dev, t, mt76.pre_tbtt_tasklet);
 	struct mt76_queue *q;
 	struct beacon_bc_data data = {};
 	struct sk_buff *skb;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/init.c b/drivers/net/wireless/mediatek/mt76/mt7603/init.c
index ad2ccdbe7258..c27e7a1a1e86 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/init.c
@@ -527,8 +527,7 @@ int mt7603_register_device(struct mt7603_dev *dev)
 	spin_lock_init(&dev->ps_lock);
 
 	INIT_DELAYED_WORK(&dev->mt76.mac_work, mt7603_mac_work);
-	tasklet_init(&dev->mt76.pre_tbtt_tasklet, mt7603_pre_tbtt_tasklet,
-		     (unsigned long)dev);
+	tasklet_setup(&dev->mt76.pre_tbtt_tasklet, mt7603_pre_tbtt_tasklet);
 
 	/* Check for 7688, which only has 1SS */
 	dev->mt76.antenna_mask = 3;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h b/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
index 257300fec4f8..83262870f7c5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
@@ -243,7 +243,7 @@ void mt7603_sta_assoc(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 void mt7603_sta_remove(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta);
 
-void mt7603_pre_tbtt_tasklet(unsigned long arg);
+void mt7603_pre_tbtt_tasklet(struct tasklet_struct *t);
 
 void mt7603_update_channel(struct mt76_dev *mdev);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c b/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c
index 5dec33ed8527..b454177ed6df 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c
@@ -609,10 +609,10 @@ static void mt76x02_dfs_check_event_window(struct mt76x02_dev *dev)
 	}
 }
 
-static void mt76x02_dfs_tasklet(unsigned long arg)
+static void mt76x02_dfs_tasklet(struct tasklet_struct *t)
 {
-	struct mt76x02_dev *dev = (struct mt76x02_dev *)arg;
-	struct mt76x02_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
+	struct mt76x02_dfs_pattern_detector *dfs_pd = from_tasklet(dfs_pd, t, dfs_tasklet);
+	struct mt76x02_dev *dev = container_of(dfs_pd, typeof(*dev), dfs_pd);
 	u32 engine_mask;
 	int i;
 
@@ -860,8 +860,7 @@ void mt76x02_dfs_init_detector(struct mt76x02_dev *dev)
 	INIT_LIST_HEAD(&dfs_pd->seq_pool);
 	dev->mt76.region = NL80211_DFS_UNSET;
 	dfs_pd->last_sw_check = jiffies;
-	tasklet_init(&dfs_pd->dfs_tasklet, mt76x02_dfs_tasklet,
-		     (unsigned long)dev);
+	tasklet_setup(&dfs_pd->dfs_tasklet, mt76x02_dfs_tasklet);
 }
 
 static void
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index dc773070481d..83296955ce4f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -11,9 +11,9 @@
 #include "mt76x02_mcu.h"
 #include "mt76x02_trace.h"
 
-static void mt76x02_pre_tbtt_tasklet(unsigned long arg)
+static void mt76x02_pre_tbtt_tasklet(struct tasklet_struct *t)
 {
-	struct mt76x02_dev *dev = (struct mt76x02_dev *)arg;
+	struct mt76x02_dev *dev = from_tasklet(dev, t, mt76.pre_tbtt_tasklet);
 	struct mt76_queue *q = dev->mt76.q_tx[MT_TXQ_PSD].q;
 	struct beacon_bc_data data = {};
 	struct sk_buff *skb;
@@ -144,9 +144,9 @@ static void mt76x02_process_tx_status_fifo(struct mt76x02_dev *dev)
 		mt76x02_send_tx_status(dev, &stat, &update);
 }
 
-static void mt76x02_tx_tasklet(unsigned long data)
+static void mt76x02_tx_tasklet(struct tasklet_struct *t)
 {
-	struct mt76x02_dev *dev = (struct mt76x02_dev *)data;
+	struct mt76x02_dev *dev = from_tasklet(dev, t, mt76.tx_tasklet);
 
 	mt76x02_mac_poll_tx_status(dev, false);
 	mt76x02_process_tx_status_fifo(dev);
@@ -190,10 +190,8 @@ int mt76x02_dma_init(struct mt76x02_dev *dev)
 	if (!status_fifo)
 		return -ENOMEM;
 
-	tasklet_init(&dev->mt76.tx_tasklet, mt76x02_tx_tasklet,
-		     (unsigned long)dev);
-	tasklet_init(&dev->mt76.pre_tbtt_tasklet, mt76x02_pre_tbtt_tasklet,
-		     (unsigned long)dev);
+	tasklet_setup(&dev->mt76.tx_tasklet, mt76x02_tx_tasklet);
+	tasklet_setup(&dev->mt76.pre_tbtt_tasklet, mt76x02_pre_tbtt_tasklet);
 
 	spin_lock_init(&dev->txstatus_fifo_lock);
 	kfifo_init(&dev->txstatus_fifo, status_fifo, fifo_size);
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index c22a05f06fd0..8c85d9acacd9 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -555,9 +555,9 @@ void mt76_txq_schedule_all(struct mt76_dev *dev)
 }
 EXPORT_SYMBOL_GPL(mt76_txq_schedule_all);
 
-void mt76_tx_tasklet(unsigned long data)
+void mt76_tx_tasklet(struct tasklet_struct *t)
 {
-	struct mt76_dev *dev = (struct mt76_dev *)data;
+	struct mt76_dev *dev = from_tasklet(dev, t, tx_tasklet);
 
 	mt76_txq_schedule_all(dev);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 20c6fe510e9d..bb5ee441f3b4 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -531,9 +531,9 @@ mt76u_submit_rx_buf(struct mt76_dev *dev, struct urb *urb)
 	return usb_submit_urb(urb, GFP_ATOMIC);
 }
 
-static void mt76u_rx_tasklet(unsigned long data)
+static void mt76u_rx_tasklet(struct tasklet_struct *t)
 {
-	struct mt76_dev *dev = (struct mt76_dev *)data;
+	struct mt76_dev *dev = from_tasklet(dev, t, usb.rx_tasklet);
 	struct urb *urb;
 	int err, count;
 
@@ -646,9 +646,9 @@ int mt76u_resume_rx(struct mt76_dev *dev)
 }
 EXPORT_SYMBOL_GPL(mt76u_resume_rx);
 
-static void mt76u_tx_tasklet(unsigned long data)
+static void mt76u_tx_tasklet(struct tasklet_struct *t)
 {
-	struct mt76_dev *dev = (struct mt76_dev *)data;
+	struct mt76_dev *dev = from_tasklet(dev, t, tx_tasklet);
 	struct mt76_queue_entry entry;
 	struct mt76_sw_queue *sq;
 	struct mt76_queue *q;
@@ -954,8 +954,8 @@ int mt76u_init(struct mt76_dev *dev,
 	};
 	struct mt76_usb *usb = &dev->usb;
 
-	tasklet_init(&usb->rx_tasklet, mt76u_rx_tasklet, (unsigned long)dev);
-	tasklet_init(&dev->tx_tasklet, mt76u_tx_tasklet, (unsigned long)dev);
+	tasklet_setup(&usb->rx_tasklet, mt76u_rx_tasklet);
+	tasklet_setup(&dev->tx_tasklet, mt76u_tx_tasklet);
 	INIT_DELAYED_WORK(&usb->stat_work, mt76u_tx_status_data);
 	skb_queue_head_init(&dev->rx_skb[MT_RXQ_MAIN]);
 
diff --git a/drivers/net/wireless/mediatek/mt7601u/dma.c b/drivers/net/wireless/mediatek/mt7601u/dma.c
index f6a0454abe04..abeffeb388b7 100644
--- a/drivers/net/wireless/mediatek/mt7601u/dma.c
+++ b/drivers/net/wireless/mediatek/mt7601u/dma.c
@@ -212,9 +212,9 @@ static void mt7601u_complete_rx(struct urb *urb)
 	spin_unlock_irqrestore(&dev->rx_lock, flags);
 }
 
-static void mt7601u_rx_tasklet(unsigned long data)
+static void mt7601u_rx_tasklet(struct tasklet_struct *t)
 {
-	struct mt7601u_dev *dev = (struct mt7601u_dev *) data;
+	struct mt7601u_dev *dev = from_tasklet(dev, t, rx_tasklet);
 	struct mt7601u_dma_buf_rx *e;
 
 	while ((e = mt7601u_rx_get_pending_entry(dev))) {
@@ -266,9 +266,9 @@ static void mt7601u_complete_tx(struct urb *urb)
 	spin_unlock_irqrestore(&dev->tx_lock, flags);
 }
 
-static void mt7601u_tx_tasklet(unsigned long data)
+static void mt7601u_tx_tasklet(struct tasklet_struct *t)
 {
-	struct mt7601u_dev *dev = (struct mt7601u_dev *) data;
+	struct mt7601u_dev *dev = from_tasklet(dev, t, tx_tasklet);
 	struct sk_buff_head skbs;
 	unsigned long flags;
 
@@ -507,8 +507,8 @@ int mt7601u_dma_init(struct mt7601u_dev *dev)
 {
 	int ret = -ENOMEM;
 
-	tasklet_init(&dev->tx_tasklet, mt7601u_tx_tasklet, (unsigned long) dev);
-	tasklet_init(&dev->rx_tasklet, mt7601u_rx_tasklet, (unsigned long) dev);
+	tasklet_setup(&dev->tx_tasklet, mt7601u_tx_tasklet);
+	tasklet_setup(&dev->rx_tasklet, mt7601u_rx_tasklet);
 
 	ret = mt7601u_alloc_tx(dev);
 	if (ret)
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
index 3aa3714d4dfd..147cc41d0b0c 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
@@ -1049,9 +1049,9 @@ static void qtnf_pearl_fw_work_handler(struct work_struct *work)
 	put_device(&pdev->dev);
 }
 
-static void qtnf_pearl_reclaim_tasklet_fn(unsigned long data)
+static void qtnf_pearl_reclaim_tasklet_fn(struct tasklet_struct *t)
 {
-	struct qtnf_pcie_pearl_state *ps = (void *)data;
+	struct qtnf_pcie_pearl_state *ps = from_tasklet(ps, t, base.reclaim_tq);
 
 	qtnf_pearl_data_tx_reclaim(ps);
 	qtnf_en_txdone_irq(ps);
@@ -1102,8 +1102,7 @@ static int qtnf_pcie_pearl_probe(struct qtnf_bus *bus, unsigned int tx_bd_size)
 		return ret;
 	}
 
-	tasklet_init(&ps->base.reclaim_tq, qtnf_pearl_reclaim_tasklet_fn,
-		     (unsigned long)ps);
+	tasklet_setup(&ps->base.reclaim_tq, qtnf_pearl_reclaim_tasklet_fn);
 	netif_napi_add(&bus->mux_dev, &bus->mux_napi,
 		       qtnf_pcie_pearl_rx_poll, 10);
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c
index 9a4380ed7f1b..09ae5f925572 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c
@@ -1101,9 +1101,9 @@ static void qtnf_topaz_fw_work_handler(struct work_struct *work)
 	put_device(&pdev->dev);
 }
 
-static void qtnf_reclaim_tasklet_fn(unsigned long data)
+static void qtnf_reclaim_tasklet_fn(struct tasklet_struct *t)
 {
-	struct qtnf_pcie_topaz_state *ts = (void *)data;
+	struct qtnf_pcie_topaz_state *ts = from_tasklet(ts, t, base.reclaim_tq);
 
 	qtnf_topaz_data_tx_reclaim(ts);
 }
@@ -1153,8 +1153,7 @@ static int qtnf_pcie_topaz_probe(struct qtnf_bus *bus, unsigned int tx_bd_num)
 		return ret;
 	}
 
-	tasklet_init(&ts->base.reclaim_tq, qtnf_reclaim_tasklet_fn,
-		     (unsigned long)ts);
+	tasklet_setup(&ts->base.reclaim_tq, qtnf_reclaim_tasklet_fn);
 	netif_napi_add(&bus->mux_dev, &bus->mux_napi,
 		       qtnf_topaz_rx_poll, 10);
 
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2400pci.c b/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
index 4d44509e2ce3..3b8eb2e5726d 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
@@ -1319,9 +1319,10 @@ static inline void rt2400pci_enable_interrupt(struct rt2x00_dev *rt2x00dev,
 	spin_unlock_irq(&rt2x00dev->irqmask_lock);
 }
 
-static void rt2400pci_txstatus_tasklet(unsigned long data)
+static void rt2400pci_txstatus_tasklet(struct tasklet_struct *t)
 {
-	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
+	struct rt2x00_dev *rt2x00dev = from_tasklet(rt2x00dev, t,
+						    txstatus_tasklet);
 	u32 reg;
 
 	/*
@@ -1347,17 +1348,18 @@ static void rt2400pci_txstatus_tasklet(unsigned long data)
 	}
 }
 
-static void rt2400pci_tbtt_tasklet(unsigned long data)
+static void rt2400pci_tbtt_tasklet(struct tasklet_struct *t)
 {
-	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
+	struct rt2x00_dev *rt2x00dev = from_tasklet(rt2x00dev, t, tbtt_tasklet);
 	rt2x00lib_beacondone(rt2x00dev);
 	if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
 		rt2400pci_enable_interrupt(rt2x00dev, CSR8_TBCN_EXPIRE);
 }
 
-static void rt2400pci_rxdone_tasklet(unsigned long data)
+static void rt2400pci_rxdone_tasklet(struct tasklet_struct *t)
 {
-	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
+	struct rt2x00_dev *rt2x00dev = from_tasklet(rt2x00dev, t,
+						    rxdone_tasklet);
 	if (rt2x00mmio_rxdone(rt2x00dev))
 		tasklet_schedule(&rt2x00dev->rxdone_tasklet);
 	else if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2500pci.c b/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
index 4620990a94cf..cadd3ac829bb 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
@@ -1447,9 +1447,10 @@ static inline void rt2500pci_enable_interrupt(struct rt2x00_dev *rt2x00dev,
 	spin_unlock_irq(&rt2x00dev->irqmask_lock);
 }
 
-static void rt2500pci_txstatus_tasklet(unsigned long data)
+static void rt2500pci_txstatus_tasklet(struct tasklet_struct *t)
 {
-	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
+	struct rt2x00_dev *rt2x00dev = from_tasklet(rt2x00dev, t,
+						    txstatus_tasklet);
 	u32 reg;
 
 	/*
@@ -1475,17 +1476,18 @@ static void rt2500pci_txstatus_tasklet(unsigned long data)
 	}
 }
 
-static void rt2500pci_tbtt_tasklet(unsigned long data)
+static void rt2500pci_tbtt_tasklet(struct tasklet_struct *t)
 {
-	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
+	struct rt2x00_dev *rt2x00dev = from_tasklet(rt2x00dev, t, tbtt_tasklet);
 	rt2x00lib_beacondone(rt2x00dev);
 	if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
 		rt2500pci_enable_interrupt(rt2x00dev, CSR8_TBCN_EXPIRE);
 }
 
-static void rt2500pci_rxdone_tasklet(unsigned long data)
+static void rt2500pci_rxdone_tasklet(struct tasklet_struct *t)
 {
-	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
+	struct rt2x00_dev *rt2x00dev = from_tasklet(rt2x00dev, t,
+						    rxdone_tasklet);
 	if (rt2x00mmio_rxdone(rt2x00dev))
 		tasklet_schedule(&rt2x00dev->rxdone_tasklet);
 	else if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c b/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
index 110bb391c372..18f84c94b53c 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
@@ -210,18 +210,20 @@ static inline void rt2800mmio_enable_interrupt(struct rt2x00_dev *rt2x00dev,
 	spin_unlock_irq(&rt2x00dev->irqmask_lock);
 }
 
-void rt2800mmio_pretbtt_tasklet(unsigned long data)
+void rt2800mmio_pretbtt_tasklet(struct tasklet_struct *t)
 {
-	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
+	struct rt2x00_dev *rt2x00dev = from_tasklet(rt2x00dev, t,
+						    pretbtt_tasklet);
+
 	rt2x00lib_pretbtt(rt2x00dev);
 	if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
 		rt2800mmio_enable_interrupt(rt2x00dev, INT_MASK_CSR_PRE_TBTT);
 }
 EXPORT_SYMBOL_GPL(rt2800mmio_pretbtt_tasklet);
 
-void rt2800mmio_tbtt_tasklet(unsigned long data)
+void rt2800mmio_tbtt_tasklet(struct tasklet_struct *t)
 {
-	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
+	struct rt2x00_dev *rt2x00dev = from_tasklet(rt2x00dev, t, tbtt_tasklet);
 	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
 	u32 reg;
 
@@ -254,9 +256,10 @@ void rt2800mmio_tbtt_tasklet(unsigned long data)
 }
 EXPORT_SYMBOL_GPL(rt2800mmio_tbtt_tasklet);
 
-void rt2800mmio_rxdone_tasklet(unsigned long data)
+void rt2800mmio_rxdone_tasklet(struct tasklet_struct *t)
 {
-	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
+	struct rt2x00_dev *rt2x00dev = from_tasklet(rt2x00dev, t,
+						    rxdone_tasklet);
 	if (rt2x00mmio_rxdone(rt2x00dev))
 		tasklet_schedule(&rt2x00dev->rxdone_tasklet);
 	else if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
@@ -264,9 +267,10 @@ void rt2800mmio_rxdone_tasklet(unsigned long data)
 }
 EXPORT_SYMBOL_GPL(rt2800mmio_rxdone_tasklet);
 
-void rt2800mmio_autowake_tasklet(unsigned long data)
+void rt2800mmio_autowake_tasklet(struct tasklet_struct *t)
 {
-	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
+	struct rt2x00_dev *rt2x00dev = from_tasklet(rt2x00dev, t,
+						    autowake_tasklet);
 	rt2800mmio_wakeup(rt2x00dev);
 	if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
 		rt2800mmio_enable_interrupt(rt2x00dev,
@@ -307,9 +311,10 @@ static void rt2800mmio_fetch_txstatus(struct rt2x00_dev *rt2x00dev)
 	spin_unlock_irqrestore(&rt2x00dev->irqmask_lock, flags);
 }
 
-void rt2800mmio_txstatus_tasklet(unsigned long data)
+void rt2800mmio_txstatus_tasklet(struct tasklet_struct *t)
 {
-	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
+	struct rt2x00_dev *rt2x00dev = from_tasklet(rt2x00dev, t,
+						    txstatus_tasklet);
 
 	rt2800_txdone(rt2x00dev, 16);
 
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800mmio.h b/drivers/net/wireless/ralink/rt2x00/rt2800mmio.h
index adcd9d54ac1c..05708950f24d 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800mmio.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800mmio.h
@@ -126,11 +126,11 @@ void rt2800mmio_fill_rxdone(struct queue_entry *entry,
 			    struct rxdone_entry_desc *rxdesc);
 
 /* Interrupt functions */
-void rt2800mmio_txstatus_tasklet(unsigned long data);
-void rt2800mmio_pretbtt_tasklet(unsigned long data);
-void rt2800mmio_tbtt_tasklet(unsigned long data);
-void rt2800mmio_rxdone_tasklet(unsigned long data);
-void rt2800mmio_autowake_tasklet(unsigned long data);
+void rt2800mmio_txstatus_tasklet(struct tasklet_struct *t);
+void rt2800mmio_pretbtt_tasklet(struct tasklet_struct *t);
+void rt2800mmio_tbtt_tasklet(struct tasklet_struct *t);
+void rt2800mmio_rxdone_tasklet(struct tasklet_struct *t);
+void rt2800mmio_autowake_tasklet(struct tasklet_struct *t);
 irqreturn_t rt2800mmio_interrupt(int irq, void *dev_instance);
 void rt2800mmio_toggle_irq(struct rt2x00_dev *rt2x00dev,
 			   enum dev_state state);
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
index 2b216edd0c7d..eb6fd6a9dc76 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
@@ -519,11 +519,11 @@ struct rt2x00lib_ops {
 	/*
 	 * TX status tasklet handler.
 	 */
-	void (*txstatus_tasklet) (unsigned long data);
-	void (*pretbtt_tasklet) (unsigned long data);
-	void (*tbtt_tasklet) (unsigned long data);
-	void (*rxdone_tasklet) (unsigned long data);
-	void (*autowake_tasklet) (unsigned long data);
+	void (*txstatus_tasklet) (struct tasklet_struct *t);
+	void (*pretbtt_tasklet) (struct tasklet_struct *t);
+	void (*tbtt_tasklet) (struct tasklet_struct *t);
+	void (*rxdone_tasklet) (struct tasklet_struct *t);
+	void (*autowake_tasklet) (struct tasklet_struct *t);
 
 	/*
 	 * Device init handlers.
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
index c3eab767bc21..379613a566c7 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
@@ -1167,9 +1167,8 @@ static int rt2x00lib_probe_hw(struct rt2x00_dev *rt2x00dev)
 	 */
 #define RT2X00_TASKLET_INIT(taskletname) \
 	if (rt2x00dev->ops->lib->taskletname) { \
-		tasklet_init(&rt2x00dev->taskletname, \
-			     rt2x00dev->ops->lib->taskletname, \
-			     (unsigned long)rt2x00dev); \
+		tasklet_setup(&rt2x00dev->taskletname, \
+			     rt2x00dev->ops->lib->taskletname); \
 	}
 
 	RT2X00_TASKLET_INIT(txstatus_tasklet);
diff --git a/drivers/net/wireless/ralink/rt2x00/rt61pci.c b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
index d83288bef2fc..21c35d3434d0 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
@@ -2190,34 +2190,37 @@ static void rt61pci_enable_mcu_interrupt(struct rt2x00_dev *rt2x00dev,
 	spin_unlock_irq(&rt2x00dev->irqmask_lock);
 }
 
-static void rt61pci_txstatus_tasklet(unsigned long data)
+static void rt61pci_txstatus_tasklet(struct tasklet_struct *t)
 {
-	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
+	struct rt2x00_dev *rt2x00dev = from_tasklet(rt2x00dev, t,
+						    txstatus_tasklet);
 	rt61pci_txdone(rt2x00dev);
 	if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
 		rt61pci_enable_interrupt(rt2x00dev, INT_MASK_CSR_TXDONE);
 }
 
-static void rt61pci_tbtt_tasklet(unsigned long data)
+static void rt61pci_tbtt_tasklet(struct tasklet_struct *t)
 {
-	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
+	struct rt2x00_dev *rt2x00dev = from_tasklet(rt2x00dev, t, tbtt_tasklet);
 	rt2x00lib_beacondone(rt2x00dev);
 	if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
 		rt61pci_enable_interrupt(rt2x00dev, INT_MASK_CSR_BEACON_DONE);
 }
 
-static void rt61pci_rxdone_tasklet(unsigned long data)
+static void rt61pci_rxdone_tasklet(struct tasklet_struct *t)
 {
-	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
+	struct rt2x00_dev *rt2x00dev = from_tasklet(rt2x00dev, t,
+						    rxdone_tasklet);
 	if (rt2x00mmio_rxdone(rt2x00dev))
 		tasklet_schedule(&rt2x00dev->rxdone_tasklet);
 	else if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
 		rt61pci_enable_interrupt(rt2x00dev, INT_MASK_CSR_RXDONE);
 }
 
-static void rt61pci_autowake_tasklet(unsigned long data)
+static void rt61pci_autowake_tasklet(struct tasklet_struct *t)
 {
-	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
+	struct rt2x00_dev *rt2x00dev = from_tasklet(rt2x00dev, t,
+						    autowake_tasklet);
 	rt61pci_wakeup(rt2x00dev);
 	rt2x00mmio_register_write(rt2x00dev,
 				  M2H_CMD_DONE_CSR, 0xffffffff);
diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index 6087ec7a90a6..6e97ebd70215 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -1060,14 +1060,19 @@ static irqreturn_t _rtl_pci_interrupt(int irq, void *dev_id)
 	return ret;
 }
 
-static void _rtl_pci_irq_tasklet(struct ieee80211_hw *hw)
+static void _rtl_pci_irq_tasklet(struct tasklet_struct *t)
 {
+	struct rtl_priv *rtlpriv = from_tasklet(rtlpriv, t, works.irq_tasklet);
+	struct ieee80211_hw *hw = rtlpriv->hw;
 	_rtl_pci_tx_chk_waitq(hw);
 }
 
-static void _rtl_pci_prepare_bcn_tasklet(struct ieee80211_hw *hw)
+static void _rtl_pci_prepare_bcn_tasklet(struct tasklet_struct *t)
 {
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	struct rtl_priv *rtlpriv = from_tasklet(rtlpriv, t,
+						works.irq_prepare_bcn_tasklet);
+	struct ieee80211_hw *hw = rtlpriv->hw;
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rtl8192_tx_ring *ring = NULL;
@@ -1191,12 +1196,9 @@ static void _rtl_pci_init_struct(struct ieee80211_hw *hw,
 	rtlpci->acm_method = EACMWAY2_SW;
 
 	/*task */
-	tasklet_init(&rtlpriv->works.irq_tasklet,
-		     (void (*)(unsigned long))_rtl_pci_irq_tasklet,
-		     (unsigned long)hw);
-	tasklet_init(&rtlpriv->works.irq_prepare_bcn_tasklet,
-		     (void (*)(unsigned long))_rtl_pci_prepare_bcn_tasklet,
-		     (unsigned long)hw);
+	tasklet_setup(&rtlpriv->works.irq_tasklet, _rtl_pci_irq_tasklet);
+	tasklet_setup(&rtlpriv->works.irq_prepare_bcn_tasklet,
+		      _rtl_pci_prepare_bcn_tasklet);
 	INIT_WORK(&rtlpriv->works.lps_change_work,
 		  rtl_lps_change_work_callback);
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index 4b59f3b46b28..aae5c5aa1769 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -289,7 +289,7 @@ static int _rtl_usb_init_tx(struct ieee80211_hw *hw)
 	return 0;
 }
 
-static void _rtl_rx_work(unsigned long param);
+static void _rtl_rx_work(struct tasklet_struct *t);
 
 static int _rtl_usb_init_rx(struct ieee80211_hw *hw)
 {
@@ -310,8 +310,8 @@ static int _rtl_usb_init_rx(struct ieee80211_hw *hw)
 	init_usb_anchor(&rtlusb->rx_cleanup_urbs);
 
 	skb_queue_head_init(&rtlusb->rx_queue);
-	rtlusb->rx_work_tasklet.func = _rtl_rx_work;
-	rtlusb->rx_work_tasklet.data = (unsigned long)rtlusb;
+	rtlusb->rx_work_tasklet.func = (TASKLET_FUNC_TYPE)_rtl_rx_work;
+	rtlusb->rx_work_tasklet.data = (TASKLET_DATA_TYPE)&rtlusb->rx_work_tasklet;
 
 	return 0;
 }
@@ -528,9 +528,9 @@ static void _rtl_rx_pre_process(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 #define __RX_SKB_MAX_QUEUED	64
 
-static void _rtl_rx_work(unsigned long param)
+static void _rtl_rx_work(struct tasklet_struct *t)
 {
-	struct rtl_usb *rtlusb = (struct rtl_usb *)param;
+	struct rtl_usb *rtlusb = from_tasklet(rtlusb, t, rx_work_tasklet);
 	struct ieee80211_hw *hw = usb_get_intfdata(rtlusb->intf);
 	struct sk_buff *skb;
 
diff --git a/drivers/net/wireless/zydas/zd1211rw/zd_usb.c b/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
index 4e44ea8c652d..0ebbd727a452 100644
--- a/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
@@ -1142,9 +1142,9 @@ static void zd_rx_idle_timer_handler(struct work_struct *work)
 	zd_usb_reset_rx(usb);
 }
 
-static void zd_usb_reset_rx_idle_timer_tasklet(unsigned long param)
+static void zd_usb_reset_rx_idle_timer_tasklet(struct tasklet_struct *t)
 {
-	struct zd_usb *usb = (struct zd_usb *)param;
+	struct zd_usb *usb = from_tasklet(usb, t, rx.reset_timer_tasklet);
 
 	zd_usb_reset_rx_idle_timer(usb);
 }
@@ -1180,8 +1180,8 @@ static inline void init_usb_rx(struct zd_usb *usb)
 	}
 	ZD_ASSERT(rx->fragment_length == 0);
 	INIT_DELAYED_WORK(&rx->idle_work, zd_rx_idle_timer_handler);
-	rx->reset_timer_tasklet.func = zd_usb_reset_rx_idle_timer_tasklet;
-	rx->reset_timer_tasklet.data = (unsigned long)usb;
+	rx->reset_timer_tasklet.func = (TASKLET_FUNC_TYPE)zd_usb_reset_rx_idle_timer_tasklet;
+	rx->reset_timer_tasklet.data = (TASKLET_DATA_TYPE)&rx->reset_timer_tasklet;
 }
 
 static inline void init_usb_tx(struct zd_usb *usb)
diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index 00a5d5764993..59400d3b680e 100644
--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -273,7 +273,7 @@ enum {
 #define NTB_QP_DEF_NUM_ENTRIES	100
 #define NTB_LINK_DOWN_TIMEOUT	10
 
-static void ntb_transport_rxc_db(unsigned long data);
+static void ntb_transport_rxc_db(struct tasklet_struct *t);
 static const struct ntb_ctx_ops ntb_transport_ops;
 static struct ntb_client ntb_transport_client;
 static int ntb_async_tx_submit(struct ntb_transport_qp *qp,
@@ -1234,8 +1234,7 @@ static int ntb_transport_init_queue(struct ntb_transport_ctx *nt,
 	INIT_LIST_HEAD(&qp->rx_free_q);
 	INIT_LIST_HEAD(&qp->tx_free_q);
 
-	tasklet_init(&qp->rxc_db_work, ntb_transport_rxc_db,
-		     (unsigned long)qp);
+	tasklet_setup(&qp->rxc_db_work, ntb_transport_rxc_db);
 
 	return 0;
 }
@@ -1685,9 +1684,9 @@ static int ntb_process_rxc(struct ntb_transport_qp *qp)
 	return 0;
 }
 
-static void ntb_transport_rxc_db(unsigned long data)
+static void ntb_transport_rxc_db(struct tasklet_struct *t)
 {
-	struct ntb_transport_qp *qp = (void *)data;
+	struct ntb_transport_qp *qp = from_tasklet(qp, t, rxc_db_work);
 	int rc, i;
 
 	dev_dbg(&qp->ndev->pdev->dev, "%s: doorbell %d received\n",
diff --git a/drivers/platform/goldfish/goldfish_pipe.c b/drivers/platform/goldfish/goldfish_pipe.c
index cef0133aa47a..9bad04014906 100644
--- a/drivers/platform/goldfish/goldfish_pipe.c
+++ b/drivers/platform/goldfish/goldfish_pipe.c
@@ -588,10 +588,10 @@ static struct goldfish_pipe *signalled_pipes_pop_front(
 	return pipe;
 }
 
-static void goldfish_interrupt_task(unsigned long dev_addr)
+static void goldfish_interrupt_task(struct tasklet_struct *t)
 {
 	/* Iterate over the signalled pipes and wake them one by one */
-	struct goldfish_pipe_dev *dev = (struct goldfish_pipe_dev *)dev_addr;
+	struct goldfish_pipe_dev *dev = from_tasklet(dev, t, irq_tasklet);
 	struct goldfish_pipe *pipe;
 	int wakes;
 
@@ -822,8 +822,7 @@ static int goldfish_pipe_device_init(struct platform_device *pdev,
 {
 	int err;
 
-	tasklet_init(&dev->irq_tasklet, &goldfish_interrupt_task,
-		     (unsigned long)dev);
+	tasklet_setup(&dev->irq_tasklet, &goldfish_interrupt_task);
 
 	err = devm_request_irq(&pdev->dev, dev->irq,
 			       goldfish_pipe_interrupt,
diff --git a/drivers/rapidio/devices/tsi721_dma.c b/drivers/rapidio/devices/tsi721_dma.c
index d375c02059f3..4a2bb6d7c692 100644
--- a/drivers/rapidio/devices/tsi721_dma.c
+++ b/drivers/rapidio/devices/tsi721_dma.c
@@ -566,9 +566,9 @@ static void tsi721_advance_work(struct tsi721_bdma_chan *bdma_chan,
 		  bdma_chan->id);
 }
 
-static void tsi721_dma_tasklet(unsigned long data)
+static void tsi721_dma_tasklet(struct tasklet_struct *t)
 {
-	struct tsi721_bdma_chan *bdma_chan = (struct tsi721_bdma_chan *)data;
+	struct tsi721_bdma_chan *bdma_chan = from_tasklet(bdma_chan, t, tasklet);
 	u32 dmac_int, dmac_sts;
 
 	dmac_int = ioread32(bdma_chan->regs + TSI721_DMAC_INT);
@@ -988,8 +988,7 @@ int tsi721_register_dma(struct tsi721_device *priv)
 		INIT_LIST_HEAD(&bdma_chan->queue);
 		INIT_LIST_HEAD(&bdma_chan->free_list);
 
-		tasklet_init(&bdma_chan->tasklet, tsi721_dma_tasklet,
-			     (unsigned long)bdma_chan);
+		tasklet_setup(&bdma_chan->tasklet, tsi721_dma_tasklet);
 		list_add_tail(&bdma_chan->dchan.device_node,
 			      &mport->dma.channels);
 		nr_channels++;
diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index 6cca72782af6..b292c7806e5a 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -72,8 +72,8 @@ MODULE_LICENSE("GPL");
 static int  dasd_alloc_queue(struct dasd_block *);
 static void dasd_free_queue(struct dasd_block *);
 static int dasd_flush_block_queue(struct dasd_block *);
-static void dasd_device_tasklet(unsigned long);
-static void dasd_block_tasklet(unsigned long);
+static void dasd_device_tasklet(struct tasklet_struct *);
+static void dasd_block_tasklet(struct tasklet_struct *);
 static void do_kick_device(struct work_struct *);
 static void do_restore_device(struct work_struct *);
 static void do_reload_device(struct work_struct *);
@@ -133,8 +133,7 @@ struct dasd_device *dasd_alloc_device(void)
 	dasd_init_chunklist(&device->ese_chunks, device->ese_mem, PAGE_SIZE * 2);
 	spin_lock_init(&device->mem_lock);
 	atomic_set(&device->tasklet_scheduled, 0);
-	tasklet_init(&device->tasklet, dasd_device_tasklet,
-		     (unsigned long) device);
+	tasklet_setup(&device->tasklet, dasd_device_tasklet);
 	INIT_LIST_HEAD(&device->ccw_queue);
 	timer_setup(&device->timer, dasd_device_timeout, 0);
 	INIT_WORK(&device->kick_work, do_kick_device);
@@ -174,8 +173,7 @@ struct dasd_block *dasd_alloc_block(void)
 	atomic_set(&block->open_count, -1);
 
 	atomic_set(&block->tasklet_scheduled, 0);
-	tasklet_init(&block->tasklet, dasd_block_tasklet,
-		     (unsigned long) block);
+	tasklet_setup(&block->tasklet, dasd_block_tasklet);
 	INIT_LIST_HEAD(&block->ccw_queue);
 	spin_lock_init(&block->queue_lock);
 	timer_setup(&block->timer, dasd_block_timeout, 0);
@@ -2179,9 +2177,9 @@ EXPORT_SYMBOL_GPL(dasd_flush_device_queue);
 /*
  * Acquire the device lock and process queues for the device.
  */
-static void dasd_device_tasklet(unsigned long data)
+static void dasd_device_tasklet(struct tasklet_struct *t)
 {
-	struct dasd_device *device = (struct dasd_device *) data;
+	struct dasd_device *device = from_tasklet(device, t, tasklet);
 	struct list_head final_queue;
 
 	atomic_set (&device->tasklet_scheduled, 0);
@@ -2908,9 +2906,9 @@ static void __dasd_block_start_head(struct dasd_block *block)
  * block layer request queue, creates ccw requests, enqueues them on
  * a dasd_device and processes ccw requests that have been returned.
  */
-static void dasd_block_tasklet(unsigned long data)
+static void dasd_block_tasklet(struct tasklet_struct *t)
 {
-	struct dasd_block *block = (struct dasd_block *) data;
+	struct dasd_block *block = from_tasklet(block, t, tasklet);
 	struct list_head final_queue;
 	struct list_head *l, *n;
 	struct dasd_ccw_req *cqr;
diff --git a/drivers/s390/char/con3215.c b/drivers/s390/char/con3215.c
index e7cf0a1d4f71..eb32ee817f21 100644
--- a/drivers/s390/char/con3215.c
+++ b/drivers/s390/char/con3215.c
@@ -334,9 +334,9 @@ static inline void raw3215_try_io(struct raw3215_info *raw)
 /*
  * Call tty_wakeup from tasklet context
  */
-static void raw3215_wakeup(unsigned long data)
+static void raw3215_wakeup(struct tasklet_struct *t)
 {
-	struct raw3215_info *raw = (struct raw3215_info *) data;
+	struct raw3215_info *raw = from_tasklet(raw, t, tlet);
 	struct tty_struct *tty;
 
 	tty = tty_port_tty_get(&raw->port);
@@ -673,7 +673,7 @@ static struct raw3215_info *raw3215_alloc_info(void)
 
 	timer_setup(&info->timer, raw3215_timeout, 0);
 	init_waitqueue_head(&info->empty_wait);
-	tasklet_init(&info->tlet, raw3215_wakeup, (unsigned long)info);
+	tasklet_setup(&info->tlet, raw3215_wakeup);
 	tty_port_init(&info->port);
 
 	return info;
diff --git a/drivers/s390/char/con3270.c b/drivers/s390/char/con3270.c
index e17364e13d2f..b1d4b7e69d0f 100644
--- a/drivers/s390/char/con3270.c
+++ b/drivers/s390/char/con3270.c
@@ -291,8 +291,9 @@ con3270_update(struct timer_list *t)
  * Read tasklet.
  */
 static void
-con3270_read_tasklet(struct raw3270_request *rrq)
+con3270_read_tasklet(struct tasklet_struct *unused)
 {
+	struct raw3270_request *rrq = condev->read;
 	static char kreset_data = TW_KR;
 	struct con3270 *cp;
 	unsigned long flags;
@@ -625,9 +626,7 @@ con3270_init(void)
 	INIT_LIST_HEAD(&condev->lines);
 	INIT_LIST_HEAD(&condev->update);
 	timer_setup(&condev->timer, con3270_update, 0);
-	tasklet_init(&condev->readlet, 
-		     (void (*)(unsigned long)) con3270_read_tasklet,
-		     (unsigned long) condev->read);
+	tasklet_setup(&condev->readlet, con3270_read_tasklet);
 
 	raw3270_add_view(&condev->view, &con3270_fn, 1, RAW3270_VIEW_LOCK_IRQ);
 
diff --git a/drivers/s390/char/tty3270.c b/drivers/s390/char/tty3270.c
index 98d7fc152e32..07157f33abaf 100644
--- a/drivers/s390/char/tty3270.c
+++ b/drivers/s390/char/tty3270.c
@@ -556,8 +556,10 @@ tty3270_scroll_backward(struct kbd_data *kbd)
  * Pass input line to tty.
  */
 static void
-tty3270_read_tasklet(struct raw3270_request *rrq)
+tty3270_read_tasklet(struct tasklet_struct *t)
 {
+	struct tty3270 *tp = from_tasklet(tp, t, readlet);
+	struct raw3270_request *rrq = tp->read;
 	static char kreset_data = TW_KR;
 	struct tty3270 *tp = container_of(rrq->view, struct tty3270, view);
 	char *input;
@@ -652,8 +654,9 @@ tty3270_issue_read(struct tty3270 *tp, int lock)
  * Hang up the tty
  */
 static void
-tty3270_hangup_tasklet(struct tty3270 *tp)
+tty3270_hangup_tasklet(struct tasklet_struct *t)
 {
+	struct tty3270 *tp = from_tasklet(tp, t, hanglet);
 	tty_port_tty_hangup(&tp->port, true);
 	raw3270_put_view(&tp->view);
 }
@@ -752,12 +755,8 @@ tty3270_alloc_view(void)
 
 	tty_port_init(&tp->port);
 	timer_setup(&tp->timer, tty3270_update, 0);
-	tasklet_init(&tp->readlet,
-		     (void (*)(unsigned long)) tty3270_read_tasklet,
-		     (unsigned long) tp->read);
-	tasklet_init(&tp->hanglet,
-		     (void (*)(unsigned long)) tty3270_hangup_tasklet,
-		     (unsigned long) tp);
+	tasklet_setup(&tp->readlet, tty3270_read_tasklet);
+	tasklet_setup(&tp->hanglet, tty3270_hangup_tasklet);
 	INIT_WORK(&tp->resize_work, tty3270_resize_work);
 
 	return tp;
diff --git a/drivers/s390/cio/qdio.h b/drivers/s390/cio/qdio.h
index a58b45df95d7..d28c0d3b02d1 100644
--- a/drivers/s390/cio/qdio.h
+++ b/drivers/s390/cio/qdio.h
@@ -377,7 +377,7 @@ int qdio_establish_thinint(struct qdio_irq *irq_ptr);
 void qdio_shutdown_thinint(struct qdio_irq *irq_ptr);
 void tiqdio_add_input_queues(struct qdio_irq *irq_ptr);
 void tiqdio_remove_input_queues(struct qdio_irq *irq_ptr);
-void tiqdio_inbound_processing(unsigned long q);
+void tiqdio_inbound_processing(struct tasklet_struct *t);
 int tiqdio_allocate_memory(void);
 void tiqdio_free_memory(void);
 int tiqdio_register_thinints(void);
@@ -386,8 +386,8 @@ void clear_nonshared_ind(struct qdio_irq *);
 int test_nonshared_ind(struct qdio_irq *);
 
 /* prototypes for setup */
-void qdio_inbound_processing(unsigned long data);
-void qdio_outbound_processing(unsigned long data);
+void qdio_inbound_processing(struct tasklet_struct *t);
+void qdio_outbound_processing(struct tasklet_struct *t);
 void qdio_outbound_timer(struct timer_list *t);
 void qdio_int_handler(struct ccw_device *cdev, unsigned long intparm,
 		      struct irb *irb);
diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
index 5b63c505a2f7..925b0fd4e2ab 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -699,9 +699,9 @@ static void __qdio_inbound_processing(struct qdio_q *q)
 	}
 }
 
-void qdio_inbound_processing(unsigned long data)
+void qdio_inbound_processing(struct tasklet_struct *t)
 {
-	struct qdio_q *q = (struct qdio_q *)data;
+	struct qdio_q *q = from_tasklet(q, t, tasklet);
 	__qdio_inbound_processing(q);
 }
 
@@ -862,9 +862,9 @@ static void __qdio_outbound_processing(struct qdio_q *q)
 }
 
 /* outbound tasklet */
-void qdio_outbound_processing(unsigned long data)
+void qdio_outbound_processing(struct tasklet_struct *t)
 {
-	struct qdio_q *q = (struct qdio_q *)data;
+	struct qdio_q *q = from_tasklet(q, t, tasklet);
 	__qdio_outbound_processing(q);
 }
 
@@ -925,9 +925,9 @@ static void __tiqdio_inbound_processing(struct qdio_q *q)
 	}
 }
 
-void tiqdio_inbound_processing(unsigned long data)
+void tiqdio_inbound_processing(struct tasklet_struct *t)
 {
-	struct qdio_q *q = (struct qdio_q *)data;
+	struct qdio_q *q = from_tasklet(q, t, tasklet);
 	__tiqdio_inbound_processing(q);
 }
 
diff --git a/drivers/s390/cio/qdio_setup.c b/drivers/s390/cio/qdio_setup.c
index f4ca1d29d61b..4eff37f90091 100644
--- a/drivers/s390/cio/qdio_setup.c
+++ b/drivers/s390/cio/qdio_setup.c
@@ -232,11 +232,9 @@ static void setup_queues(struct qdio_irq *irq_ptr,
 		input_sbal_array += QDIO_MAX_BUFFERS_PER_Q;
 
 		if (is_thinint_irq(irq_ptr)) {
-			tasklet_init(&q->tasklet, tiqdio_inbound_processing,
-				     (unsigned long) q);
+			tasklet_setup(&q->tasklet, tiqdio_inbound_processing);
 		} else {
-			tasklet_init(&q->tasklet, qdio_inbound_processing,
-				     (unsigned long) q);
+			tasklet_setup(&q->tasklet, qdio_inbound_processing);
 		}
 	}
 
@@ -251,8 +249,7 @@ static void setup_queues(struct qdio_irq *irq_ptr,
 		setup_storage_lists(q, irq_ptr, output_sbal_array, i);
 		output_sbal_array += QDIO_MAX_BUFFERS_PER_Q;
 
-		tasklet_init(&q->tasklet, qdio_outbound_processing,
-			     (unsigned long) q);
+		tasklet_setup(&q->tasklet, qdio_outbound_processing);
 		timer_setup(&q->u.out.timer, qdio_outbound_timer, 0);
 	}
 }
diff --git a/drivers/s390/net/ctcm_main.c b/drivers/s390/net/ctcm_main.c
index 437a6d822105..f1f42622c7e5 100644
--- a/drivers/s390/net/ctcm_main.c
+++ b/drivers/s390/net/ctcm_main.c
@@ -1165,8 +1165,7 @@ static struct net_device *ctcm_init_netdevice(struct ctcm_priv *priv)
 			free_netdev(dev);
 			return NULL;
 		}
-		tasklet_init(&grp->mpc_tasklet2,
-				mpc_group_ready, (unsigned long)dev);
+		tasklet_setup(&grp->mpc_tasklet2, mpc_group_ready);
 		dev->mtu = MPC_BUFSIZE_DEFAULT -
 				TH_HEADER_LENGTH - PDU_HEADER_LENGTH;
 
@@ -1366,10 +1365,10 @@ static int add_channel(struct ccw_device *cdev, enum ctcm_channel_types type,
 					goto nomem_return;
 
 		ch->discontact_th->th_blk_flag = TH_DISCONTACT;
-		tasklet_init(&ch->ch_disc_tasklet,
-			mpc_action_send_discontact, (unsigned long)ch);
+		tasklet_setup(&ch->ch_disc_tasklet,
+			      mpc_action_send_discontact);
 
-		tasklet_init(&ch->ch_tasklet, ctcmpc_bh, (unsigned long)ch);
+		tasklet_setup(&ch->ch_tasklet, ctcmpc_bh);
 		ch->max_bufsize = (MPC_BUFSIZE_DEFAULT - 35);
 		ccw_num = 17;
 	} else
diff --git a/drivers/s390/net/ctcm_mpc.c b/drivers/s390/net/ctcm_mpc.c
index ab316baa8284..049b6ca0789f 100644
--- a/drivers/s390/net/ctcm_mpc.c
+++ b/drivers/s390/net/ctcm_mpc.c
@@ -870,11 +870,11 @@ static void mpc_action_go_ready(fsm_instance *fsm, int event, void *arg)
  * helper of ctcm_init_netdevice
  * CTCM_PROTO_MPC only
  */
-void mpc_group_ready(unsigned long adev)
+void mpc_group_ready(struct tasklet_struct *t)
 {
-	struct net_device *dev = (struct net_device *)adev;
-	struct ctcm_priv *priv = dev->ml_priv;
-	struct mpc_group *grp = priv->mpcg;
+	struct mpc_group *grp = from_tasklet(grp, t, mpc_tasklet2);
+	struct ctcm_priv *priv = container_of(grp, typeof(*priv), mpcg);
+	struct net_device *dev = container_of(priv, typeof(*dev), ml_priv);
 	struct channel *ch = NULL;
 
 	if (grp == NULL) {
@@ -1233,9 +1233,9 @@ static void ctcmpc_unpack_skb(struct channel *ch, struct sk_buff *pskb)
  * Throttling back channel can result in excessive
  * channel inactivity and system deact of channel
  */
-void ctcmpc_bh(unsigned long thischan)
+void ctcmpc_bh(struct tasklet_struct *t)
 {
-	struct channel	  *ch	= (struct channel *)thischan;
+	struct channel	  *ch	= from_tasklet(ch, t, ch_tasklet);
 	struct sk_buff	  *skb;
 	struct net_device *dev	= ch->netdev;
 	struct ctcm_priv  *priv	= dev->ml_priv;
@@ -1516,10 +1516,10 @@ void mpc_action_discontact(fsm_instance *fi, int event, void *arg)
  * CTCM_PROTO_MPC only
  * called from add_channel in ctcm_main.c
  */
-void mpc_action_send_discontact(unsigned long thischan)
+void mpc_action_send_discontact(struct tasklet_struct *t)
 {
 	int rc;
-	struct channel	*ch = (struct channel *)thischan;
+	struct channel	*ch = from_tasklet(ch, t, ch_disc_tasklet);
 	unsigned long	saveflags = 0;
 
 	spin_lock_irqsave(get_ccwdev_lock(ch->cdev), saveflags);
diff --git a/drivers/s390/net/ctcm_mpc.h b/drivers/s390/net/ctcm_mpc.h
index 441d7b211f0f..80c772326178 100644
--- a/drivers/s390/net/ctcm_mpc.h
+++ b/drivers/s390/net/ctcm_mpc.h
@@ -230,10 +230,10 @@ static inline void ctcmpc_dump32(char *buf, int len)
 
 int ctcmpc_open(struct net_device *);
 void ctcm_ccw_check_rc(struct channel *, int, char *);
-void mpc_group_ready(unsigned long adev);
+void mpc_group_ready(struct tasklet_struct *t);
 void mpc_channel_action(struct channel *ch, int direction, int action);
-void mpc_action_send_discontact(unsigned long thischan);
+void mpc_action_send_discontact(struct tasklet_struct *t);
 void mpc_action_discontact(fsm_instance *fi, int event, void *arg);
-void ctcmpc_bh(unsigned long thischan);
+void ctcmpc_bh(struct tasklet_struct *t);
 #endif
 /* --- This is the END my friend --- */
diff --git a/drivers/scsi/aic94xx/aic94xx_hwi.c b/drivers/scsi/aic94xx/aic94xx_hwi.c
index c5a46c59d4f8..a28700b74d67 100644
--- a/drivers/scsi/aic94xx/aic94xx_hwi.c
+++ b/drivers/scsi/aic94xx/aic94xx_hwi.c
@@ -248,7 +248,7 @@ static void asd_get_max_scb_ddb(struct asd_ha_struct *asd_ha)
 
 /* ---------- Done List initialization ---------- */
 
-static void asd_dl_tasklet_handler(unsigned long);
+static void asd_dl_tasklet_handler(struct tasklet_struct *);
 
 static int asd_init_dl(struct asd_ha_struct *asd_ha)
 {
@@ -261,8 +261,7 @@ static int asd_init_dl(struct asd_ha_struct *asd_ha)
 	asd_ha->seq.dl = asd_ha->seq.actual_dl->vaddr;
 	asd_ha->seq.dl_toggle = ASD_DEF_DL_TOGGLE;
 	asd_ha->seq.dl_next = 0;
-	tasklet_init(&asd_ha->seq.dl_tasklet, asd_dl_tasklet_handler,
-		     (unsigned long) asd_ha);
+	tasklet_setup(&asd_ha->seq.dl_tasklet, asd_dl_tasklet_handler);
 
 	return 0;
 }
@@ -711,9 +710,9 @@ static void asd_chip_reset(struct asd_ha_struct *asd_ha)
 
 /* ---------- Done List Routines ---------- */
 
-static void asd_dl_tasklet_handler(unsigned long data)
+static void asd_dl_tasklet_handler(struct tasklet_struct *t)
 {
-	struct asd_ha_struct *asd_ha = (struct asd_ha_struct *) data;
+	struct asd_ha_struct *asd_ha = from_tasklet(asd_ha, t, seq.dl_tasklet);
 	struct asd_seq_data *seq = &asd_ha->seq;
 	unsigned long flags;
 
diff --git a/drivers/scsi/esas2r/esas2r.h b/drivers/scsi/esas2r/esas2r.h
index 7f43b95f4e94..d3bf68b2fb1d 100644
--- a/drivers/scsi/esas2r/esas2r.h
+++ b/drivers/scsi/esas2r/esas2r.h
@@ -992,7 +992,7 @@ int esas2r_write_vda(struct esas2r_adapter *a, const char *buf, long off,
 int esas2r_read_fs(struct esas2r_adapter *a, char *buf, long off, int count);
 int esas2r_write_fs(struct esas2r_adapter *a, const char *buf, long off,
 		    int count);
-void esas2r_adapter_tasklet(unsigned long context);
+void esas2r_adapter_tasklet(struct tasklet_struct *t);
 irqreturn_t esas2r_interrupt(int irq, void *dev_id);
 irqreturn_t esas2r_msi_interrupt(int irq, void *dev_id);
 void esas2r_kickoff_timer(struct esas2r_adapter *a);
diff --git a/drivers/scsi/esas2r/esas2r_init.c b/drivers/scsi/esas2r/esas2r_init.c
index eb7d139ffc00..55387c14fb8d 100644
--- a/drivers/scsi/esas2r/esas2r_init.c
+++ b/drivers/scsi/esas2r/esas2r_init.c
@@ -401,9 +401,7 @@ int esas2r_init_adapter(struct Scsi_Host *host, struct pci_dev *pcid,
 		return 0;
 	}
 
-	tasklet_init(&a->tasklet,
-		     esas2r_adapter_tasklet,
-		     (unsigned long)a);
+	tasklet_setup(&a->tasklet, esas2r_adapter_tasklet);
 
 	/*
 	 * Disable chip interrupts to prevent spurious interrupts
diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index 80c5a235d193..ead267dd687d 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -1539,9 +1539,9 @@ void esas2r_complete_request_cb(struct esas2r_adapter *a,
 }
 
 /* Run tasklet to handle stuff outside of interrupt context. */
-void esas2r_adapter_tasklet(unsigned long context)
+void esas2r_adapter_tasklet(struct tasklet_struct *t)
 {
-	struct esas2r_adapter *a = (struct esas2r_adapter *)context;
+	struct esas2r_adapter *a = from_tasklet(a, t, tasklet);
 
 	if (unlikely(test_bit(AF2_TIMER_TICK, &a->flags2))) {
 		clear_bit(AF2_TIMER_TICK, &a->flags2);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 8e96a257e439..bc4a687ec60e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -3104,9 +3104,9 @@ static irqreturn_t fatal_axi_int_v2_hw(int irq_no, void *p)
 	return IRQ_HANDLED;
 }
 
-static void cq_tasklet_v2_hw(unsigned long val)
+static void cq_tasklet_v2_hw(struct tasklet_struct *t)
 {
-	struct hisi_sas_cq *cq = (struct hisi_sas_cq *)val;
+	struct hisi_sas_cq *cq = from_tasklet(cq, t, tasklet);
 	struct hisi_hba *hisi_hba = cq->hisi_hba;
 	struct hisi_sas_slot *slot;
 	struct hisi_sas_itct *itct;
@@ -3364,7 +3364,7 @@ static int interrupt_init_v2_hw(struct hisi_hba *hisi_hba)
 			rc = -ENOENT;
 			goto err_out;
 		}
-		tasklet_init(t, cq_tasklet_v2_hw, (unsigned long)cq);
+		tasklet_setup(t, cq_tasklet_v2_hw);
 	}
 
 	hisi_hba->cq_nvecs = hisi_hba->queue_count;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index cb8d087762db..10130c8ebf7c 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2290,9 +2290,9 @@ slot_complete_v3_hw(struct hisi_hba *hisi_hba, struct hisi_sas_slot *slot)
 	return sts;
 }
 
-static void cq_tasklet_v3_hw(unsigned long val)
+static void cq_tasklet_v3_hw(struct tasklet_struct *t)
 {
-	struct hisi_sas_cq *cq = (struct hisi_sas_cq *)val;
+	struct hisi_sas_cq *cq = from_tasklet(cq, t, tasklet);
 	struct hisi_hba *hisi_hba = cq->hisi_hba;
 	struct hisi_sas_slot *slot;
 	struct hisi_sas_complete_v3_hdr *complete_queue;
@@ -2449,7 +2449,7 @@ static int interrupt_init_v3_hw(struct hisi_hba *hisi_hba)
 			goto free_irq_vectors;
 		}
 
-		tasklet_init(t, cq_tasklet_v3_hw, (unsigned long)cq);
+		tasklet_setup(t, cq_tasklet_v3_hw);
 	}
 
 	return 0;
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index df897df5cafe..c7277401367d 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -3168,9 +3168,9 @@ static irqreturn_t ibmvfc_interrupt(int irq, void *dev_instance)
  * Returns:
  *	Nothing
  **/
-static void ibmvfc_tasklet(void *data)
+static void ibmvfc_tasklet(struct tasklet_struct *t)
 {
-	struct ibmvfc_host *vhost = data;
+	struct ibmvfc_host *vhost = from_tasklet(vhost, t, tasklet);
 	struct vio_dev *vdev = to_vio_dev(vhost->dev);
 	struct ibmvfc_crq *crq;
 	struct ibmvfc_async_crq *async;
@@ -4536,7 +4536,7 @@ static int ibmvfc_init_crq(struct ibmvfc_host *vhost)
 
 	retrc = 0;
 
-	tasklet_init(&vhost->tasklet, (void *)ibmvfc_tasklet, (unsigned long)vhost);
+	tasklet_setup(&vhost->tasklet, ibmvfc_tasklet);
 
 	if ((rc = request_irq(vdev->irq, ibmvfc_interrupt, 0, IBMVFC_NAME, vhost))) {
 		dev_err(dev, "Couldn't register irq 0x%x. rc=%d\n", vdev->irq, rc);
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 7f66a7783209..e6877d9ec6c5 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -208,9 +208,10 @@ static int ibmvscsi_send_crq(struct ibmvscsi_host_data *hostdata,
  * ibmvscsi_task: - Process srps asynchronously
  * @data:	ibmvscsi_host_data of host
  */
-static void ibmvscsi_task(void *data)
+static void ibmvscsi_task(struct tasklet_struct *t)
 {
-	struct ibmvscsi_host_data *hostdata = (struct ibmvscsi_host_data *)data;
+	struct ibmvscsi_host_data *hostdata = from_tasklet(hostdata, t,
+							   srp_task);
 	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
 	struct viosrp_crq *crq;
 	int done = 0;
@@ -366,8 +367,7 @@ static int ibmvscsi_init_crq_queue(struct crq_queue *queue,
 	queue->cur = 0;
 	spin_lock_init(&queue->lock);
 
-	tasklet_init(&hostdata->srp_task, (void *)ibmvscsi_task,
-		     (unsigned long)hostdata);
+	tasklet_setup(&hostdata->srp_task, ibmvscsi_task);
 
 	if (request_irq(vdev->irq,
 			ibmvscsi_handle_event,
diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index a929fe76102b..2c7d1e4e64aa 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -3332,9 +3332,9 @@ static int ibmvscsis_rdma(struct ibmvscsis_cmd *cmd, struct scatterlist *sg,
  *
  * Note: this is an edge triggered interrupt. It can not be shared.
  */
-static void ibmvscsis_handle_crq(unsigned long data)
+static void ibmvscsis_handle_crq(struct tasklet_struct *t)
 {
-	struct scsi_info *vscsi = (struct scsi_info *)data;
+	struct scsi_info *vscsi = from_tasklet(vscsi, t, work_task);
 	struct viosrp_crq *crq;
 	long rc;
 	bool ack = true;
@@ -3545,8 +3545,7 @@ static int ibmvscsis_probe(struct vio_dev *vdev,
 	dev_dbg(&vscsi->dev, "probe hrc %ld, client partition num %d\n",
 		hrc, vscsi->client_data.partition_number);
 
-	tasklet_init(&vscsi->work_task, ibmvscsis_handle_crq,
-		     (unsigned long)vscsi);
+	tasklet_setup(&vscsi->work_task, ibmvscsis_handle_crq);
 
 	init_completion(&vscsi->wait_idle);
 	init_completion(&vscsi->unconfig);
diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index 7b5deae68d33..599adebd039e 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -1113,9 +1113,9 @@ void ireq_done(struct isci_host *ihost, struct isci_request *ireq, struct sas_ta
  * @data: This parameter specifies the ISCI host object
  *
  */
-void isci_host_completion_routine(unsigned long data)
+void isci_host_completion_routine(struct tasklet_struct *t)
 {
-	struct isci_host *ihost = (struct isci_host *)data;
+	struct isci_host *ihost = from_tasklet(ihost, t, completion_tasklet);
 	u16 active;
 
 	spin_lock_irq(&ihost->scic_lock);
diff --git a/drivers/scsi/isci/host.h b/drivers/scsi/isci/host.h
index 6bc3f022630a..6abe23682d9b 100644
--- a/drivers/scsi/isci/host.h
+++ b/drivers/scsi/isci/host.h
@@ -478,7 +478,7 @@ void isci_tci_free(struct isci_host *ihost, u16 tci);
 void ireq_done(struct isci_host *ihost, struct isci_request *ireq, struct sas_task *task);
 
 int isci_host_init(struct isci_host *);
-void isci_host_completion_routine(unsigned long data);
+void isci_host_completion_routine(struct tasklet_struct *t);
 void isci_host_deinit(struct isci_host *);
 void sci_controller_disable_interrupts(struct isci_host *ihost);
 bool sci_controller_has_remote_devices_stopping(struct isci_host *ihost);
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 1727d0c71b12..e036f08c39a5 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -507,8 +507,8 @@ static struct isci_host *isci_host_alloc(struct pci_dev *pdev, int id)
 	init_waitqueue_head(&ihost->eventq);
 	ihost->sas_ha.dev = &ihost->pdev->dev;
 	ihost->sas_ha.lldd_ha = ihost;
-	tasklet_init(&ihost->completion_tasklet,
-		     isci_host_completion_routine, (unsigned long)ihost);
+	tasklet_setup(&ihost->completion_tasklet,
+		      isci_host_completion_routine);
 
 	/* validate module parameters */
 	/* TODO: kill struct sci_user_parameters and reference directly */
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index f6ac819e6e96..f0cfae886e1a 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -119,7 +119,7 @@ static void megaraid_mbox_prepare_epthru(adapter_t *, scb_t *,
 
 static irqreturn_t megaraid_isr(int, void *);
 
-static void megaraid_mbox_dpc(unsigned long);
+static void megaraid_mbox_dpc(struct tasklet_struct *t);
 
 static ssize_t megaraid_sysfs_show_app_hndl(struct device *, struct device_attribute *attr, char *);
 static ssize_t megaraid_sysfs_show_ldnum(struct device *, struct device_attribute *attr, char *);
@@ -878,8 +878,7 @@ megaraid_init_mbox(adapter_t *adapter)
 	}
 
 	// setup tasklet for DPC
-	tasklet_init(&adapter->dpc_h, megaraid_mbox_dpc,
-			(unsigned long)adapter);
+	tasklet_setup(&adapter->dpc_h, megaraid_mbox_dpc);
 
 	con_log(CL_DLEVEL1, (KERN_INFO
 		"megaraid mbox hba successfully initialized\n"));
@@ -2161,16 +2160,16 @@ megaraid_isr(int irq, void *devp)
 
 /**
  * megaraid_mbox_dpc - the tasklet to complete the commands from completed list
- * @devp	: pointer to HBA soft state
+ * @t: pointer to the tasklet associated with this handler
  *
  * Pick up the commands from the completed list and send back to the owners.
  * This is a reentrant function and does not assume any locks are held while
  * it is being called.
  */
 static void
-megaraid_mbox_dpc(unsigned long devp)
+megaraid_mbox_dpc(struct tasklet_struct *t)
 {
-	adapter_t		*adapter = (adapter_t *)devp;
+	adapter_t		*adapter = from_tasklet(adapter, t, dpc_h);
 	mraid_device_t		*raid_dev;
 	struct list_head	clist;
 	struct scatterlist	*sgl;
diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index a6e788c02ff4..4431cd4c91da 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2528,7 +2528,7 @@ struct megasas_instance_template {
 	int (*check_reset)(struct megasas_instance *, \
 		struct megasas_register_set __iomem *);
 	irqreturn_t (*service_isr)(int irq, void *devp);
-	void (*tasklet)(unsigned long);
+	void (*tasklet)(struct tasklet_struct *t);
 	u32 (*init_adapter)(struct megasas_instance *);
 	u32 (*build_and_issue_cmd) (struct megasas_instance *,
 				    struct scsi_cmnd *);
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 42cf38c1ea99..447e67436dff 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -221,7 +221,7 @@ megasas_init_adapter_mfi(struct megasas_instance *instance);
 u32
 megasas_build_and_issue_cmd(struct megasas_instance *instance,
 			    struct scsi_cmnd *scmd);
-static void megasas_complete_cmd_dpc(unsigned long instance_addr);
+static void megasas_complete_cmd_dpc(struct tasklet_struct *t);
 int
 wait_and_poll(struct megasas_instance *instance, struct megasas_cmd *cmd,
 	int seconds);
@@ -2202,14 +2202,14 @@ megasas_check_and_restore_queue_depth(struct megasas_instance *instance)
  *
  * Tasklet to complete cmds
  */
-static void megasas_complete_cmd_dpc(unsigned long instance_addr)
+static void megasas_complete_cmd_dpc(struct tasklet_struct *t)
 {
 	u32 producer;
 	u32 consumer;
 	u32 context;
 	struct megasas_cmd *cmd;
-	struct megasas_instance *instance =
-				(struct megasas_instance *)instance_addr;
+	struct megasas_instance *instance = from_tasklet(instance, t,
+							 isr_tasklet);
 	unsigned long flags;
 
 	/* If we have already declared adapter dead, donot complete cmds */
@@ -2754,7 +2754,7 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
 			 * Call cmd completion routine. Cmd to be
 			 * be completed directly without depending on isr.
 			 */
-			megasas_complete_cmd_dpc((unsigned long)instance);
+			megasas_complete_cmd_dpc(&instance->isr_tasklet);
 		}
 
 		msleep(1000);
@@ -6149,8 +6149,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	dev_info(&instance->pdev->dev,
 		"RDPQ mode\t: (%s)\n", instance->is_rdpq ? "enabled" : "disabled");
 
-	tasklet_init(&instance->isr_tasklet, instance->instancet->tasklet,
-		(unsigned long)instance);
+	tasklet_setup(&instance->isr_tasklet, instance->instancet->tasklet);
 
 	/*
 	 * Below are default value for legacy Firmware.
@@ -7662,8 +7661,7 @@ megasas_resume(struct pci_dev *pdev)
 	if (megasas_get_ctrl_info(instance) != DCMD_SUCCESS)
 		goto fail_init_mfi;
 
-	tasklet_init(&instance->isr_tasklet, instance->instancet->tasklet,
-		     (unsigned long)instance);
+	tasklet_setup(&instance->isr_tasklet, instance->instancet->tasklet);
 
 	if (instance->msix_vectors ?
 			megasas_setup_irqs_msix(instance, 0) :
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index e301458bcbae..778db8e95f31 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3753,15 +3753,14 @@ int megasas_irqpoll(struct irq_poll *irqpoll, int budget)
 
 /**
  * megasas_complete_cmd_dpc_fusion -	Completes command
- * @instance:			Adapter soft state
+ * @t:	Instance of the tasklet being run
  *
  * Tasklet to complete cmds
  */
 static void
-megasas_complete_cmd_dpc_fusion(unsigned long instance_addr)
+megasas_complete_cmd_dpc_fusion(struct tasklet_struct *t)
 {
-	struct megasas_instance *instance =
-		(struct megasas_instance *)instance_addr;
+	struct megasas_instance *instance = from_tasklet(instance, t, isr_tasklet);
 	u32 count, MSIxIndex;
 
 	count = instance->msix_vectors > 0 ? instance->msix_vectors : 1;
@@ -4108,7 +4107,7 @@ megasas_wait_for_outstanding_fusion(struct megasas_instance *instance,
 	if (reason == MFI_IO_TIMEOUT_OCR) {
 		dev_info(&instance->pdev->dev,
 			"MFI command is timed out\n");
-		megasas_complete_cmd_dpc_fusion((unsigned long)instance);
+		megasas_complete_cmd_dpc_fusion(&instance->isr_tasklet);
 		if (instance->snapdump_wait_time)
 			megasas_trigger_snap_dump(instance);
 		retval = 1;
@@ -4124,7 +4123,7 @@ megasas_wait_for_outstanding_fusion(struct megasas_instance *instance,
 				   "FW in FAULT state Fault code:0x%x subcode:0x%x func:%s\n",
 				   abs_state & MFI_STATE_FAULT_CODE,
 				   abs_state & MFI_STATE_FAULT_SUBCODE, __func__);
-			megasas_complete_cmd_dpc_fusion((unsigned long)instance);
+			megasas_complete_cmd_dpc_fusion(&instance->isr_tasklet);
 			if (instance->requestorId && reason) {
 				dev_warn(&instance->pdev->dev, "SR-IOV Found FW in FAULT"
 				" state while polling during"
@@ -4168,7 +4167,7 @@ megasas_wait_for_outstanding_fusion(struct megasas_instance *instance,
 			}
 		}
 
-		megasas_complete_cmd_dpc_fusion((unsigned long)instance);
+		megasas_complete_cmd_dpc_fusion(&instance->isr_tasklet);
 		outstanding = atomic_read(&instance->fw_outstanding);
 		if (!outstanding)
 			goto out;
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index da719b0694dc..34b866c5b281 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -143,13 +143,14 @@ static void mvs_free(struct mvs_info *mvi)
 }
 
 #ifdef CONFIG_SCSI_MVSAS_TASKLET
-static void mvs_tasklet(unsigned long opaque)
+static void mvs_tasklet(struct tasklet_struct *t)
 {
 	u32 stat;
 	u16 core_nr, i = 0;
 
 	struct mvs_info *mvi;
-	struct sas_ha_struct *sha = (struct sas_ha_struct *)opaque;
+	struct mvs_prv_info *mpi = from_tasklet(mpi, t, mv_tasklet);
+	struct sas_ha_struct *sha = pci_get_drvdata(mpi->mvi[0]->pdev);
 
 	core_nr = ((struct mvs_prv_info *)sha->lldd_ha)->n_host;
 	mvi = ((struct mvs_prv_info *)sha->lldd_ha)->mvi[0];
@@ -560,8 +561,7 @@ static int mvs_pci_init(struct pci_dev *pdev, const struct pci_device_id *ent)
 	} while (nhost < chip->n_host);
 	mpi = (struct mvs_prv_info *)(SHOST_TO_SAS_HA(shost)->lldd_ha);
 #ifdef CONFIG_SCSI_MVSAS_TASKLET
-	tasklet_init(&(mpi->mv_tasklet), mvs_tasklet,
-		     (unsigned long)SHOST_TO_SAS_HA(shost));
+	tasklet_setup(&(mpi->mv_tasklet), mvs_tasklet);
 #endif
 
 	mvs_post_sas_ha_init(shost, chip);
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index f508e8314188..65a6573f4aec 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -171,12 +171,15 @@ static void pm8001_free(struct pm8001_hba_info *pm8001_ha)
  * @opaque: the passed general host adapter struct
  * Note: pm8001_tasklet is common for pm8001 & pm80xx
  */
-static void pm8001_tasklet(unsigned long opaque)
+static void pm8001_tasklet(struct tasklet_struct *t)
 {
-	struct pm8001_hba_info *pm8001_ha;
+	struct tsk_param *tsk_param = from_tasklet(tsk_param, t, tasklet);
+	struct pm8001_hba_info *pm8001_ha = container_of(tsk_param,
+						typeof(*pm8001_ha),
+						tasklet[tsk_param->irq_id]);
 	struct isr_param *irq_vector;
 
-	irq_vector = (struct isr_param *)opaque;
+	irq_vector = &pm8001_ha->irq_vector[tsk_param->irq_id];
 	pm8001_ha = irq_vector->drv_inst;
 	if (unlikely(!pm8001_ha))
 		BUG_ON(1);
@@ -479,14 +482,12 @@ static struct pm8001_hba_info *pm8001_pci_alloc(struct pci_dev *pdev,
 	if ((!pdev->msix_cap || !pci_msi_enabled())
 	    || (pm8001_ha->chip_id == chip_8001)) {
 		pm8001_ha->tasklet[0].irq_id = 0;
-		tasklet_init(&pm8001_ha->tasklet[0].tasklet, pm8001_tasklet,
-			(unsigned long)&(pm8001_ha->irq_vector[0]));
+		tasklet_setup(&pm8001_ha->tasklet[0].tasklet, pm8001_tasklet);
 	} else {
 		for (j = 0; j < PM8001_MAX_MSIX_VEC; j++) {
 			pm8001_ha->tasklet[j].irq_id = j;
-			tasklet_init(&pm8001_ha->tasklet[j].tasklet,
-				pm8001_tasklet,
-				(unsigned long)&(pm8001_ha->irq_vector[j]));
+			tasklet_setup(&pm8001_ha->tasklet[j].tasklet,
+				pm8001_tasklet);
 		}
 	}
 #endif
@@ -1218,14 +1219,12 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
 	if ((!pdev->msix_cap || !pci_msi_enabled()) ||
 	    (pm8001_ha->chip_id == chip_8001)) {
 		pm8001_ha->tasklet[0].irq_id = 0;
-		tasklet_init(&pm8001_ha->tasklet[0].tasklet, pm8001_tasklet,
-			(unsigned long)&(pm8001_ha->irq_vector[0]));
+		tasklet_setup(&pm8001_ha->tasklet[0].tasklet, pm8001_tasklet);
 	} else {
 		for (j = 0; j < PM8001_MAX_MSIX_VEC; j++) {
 			pm8001_ha->tasklet[j].irq_id = j;
-			tasklet_init(&pm8001_ha->tasklet[j].tasklet,
-				pm8001_tasklet,
-				(unsigned long)&(pm8001_ha->irq_vector[j]));
+			tasklet_setup(&pm8001_ha->tasklet[j].tasklet,
+				      pm8001_tasklet);
 		}
 	}
 #endif
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 2e44e3954bb0..7730aae67076 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4380,20 +4380,20 @@ static void pmcraid_worker_function(struct work_struct *workp)
  * Return Value
  *	None
  */
-static void pmcraid_tasklet_function(unsigned long instance)
-{
-	struct pmcraid_isr_param *hrrq_vector;
-	struct pmcraid_instance *pinstance;
+static void pmcraid_tasklet_function(struct tasklet_struct *t)
+{
+	struct pmcraid_tsk_param *tsk_param = from_tasklet(tsk_param, t,
+							   tasklet);
+	int id = tsk_param->isr_tasklet_id;
+	struct pmcraid_instance *pinstance = container_of(tsk_param,
+							  typeof(*pinstance),
+							  isr_tasklet[id]);
 	unsigned long hrrq_lock_flags;
 	unsigned long pending_lock_flags;
 	unsigned long host_lock_flags;
 	spinlock_t *lockp; /* hrrq buffer lock */
-	int id;
 	u32 resp;
 
-	hrrq_vector = (struct pmcraid_isr_param *)instance;
-	pinstance = hrrq_vector->drv_inst;
-	id = hrrq_vector->hrrq_id;
 	lockp = &(pinstance->hrrq_lock[id]);
 
 	/* loop through each of the commands responded by IOA. Each HRRQ buf is
@@ -4886,9 +4886,8 @@ static void pmcraid_init_tasklets(struct pmcraid_instance *pinstance)
 	int i;
 	for (i = 0; i < pinstance->num_hrrq; i++) {
 		pinstance->isr_tasklet[i].isr_tasklet_id = i;
-		tasklet_init(&pinstance->isr_tasklet[i].tasklet,
-			     pmcraid_tasklet_function,
-			     (unsigned long)&pinstance->hrrq_vector[i]);
+		tasklet_setup(&pinstance->isr_tasklet[i].tasklet,
+			     pmcraid_tasklet_function);
 	}
 }
 
diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
index 7fedea67159c..96ed75f995fe 100644
--- a/drivers/spi/spi-pl022.c
+++ b/drivers/spi/spi-pl022.c
@@ -1371,9 +1371,9 @@ static int set_up_next_transfer(struct pl022 *pl022,
  * @data: SSP driver private data structure
  *
  */
-static void pump_transfers(unsigned long data)
+static void pump_transfers(struct tasklet_struct *t)
 {
-	struct pl022 *pl022 = (struct pl022 *) data;
+	struct pl022 *pl022 = from_tasklet(pl022, t, pump_transfers);
 	struct spi_message *message = NULL;
 	struct spi_transfer *transfer = NULL;
 	struct spi_transfer *previous = NULL;
@@ -2241,8 +2241,7 @@ static int pl022_probe(struct amba_device *adev, const struct amba_id *id)
 	}
 
 	/* Initialize transfer pump */
-	tasklet_init(&pl022->pump_transfers, pump_transfers,
-		     (unsigned long)pl022);
+	tasklet_setup(&pl022->pump_transfers, pump_transfers);
 
 	/* Disable SSP */
 	writew((readw(SSP_CR1(pl022->virtbase)) & (~SSP_CR1_MASK_SSE)),
diff --git a/drivers/staging/isdn/gigaset/bas-gigaset.c b/drivers/staging/isdn/gigaset/bas-gigaset.c
index a3febefde39b..5285311d7a1c 100644
--- a/drivers/staging/isdn/gigaset/bas-gigaset.c
+++ b/drivers/staging/isdn/gigaset/bas-gigaset.c
@@ -1152,12 +1152,12 @@ static int submit_iso_write_urb(struct isow_urbctx_t *ucx)
  * tasklet scheduled when an isochronous output URB from the Gigaset device
  * has completed
  * parameter:
- *	data	B channel state structure
+ *	t	B instance of the tasklet being run
  */
-static void write_iso_tasklet(unsigned long data)
+static void write_iso_tasklet(struct tasklet_struct *t)
 {
-	struct bc_state *bcs = (struct bc_state *) data;
-	struct bas_bc_state *ubc = bcs->hw.bas;
+	struct bas_bc_state *ubc = from_tasklet(ubc, t, sent_tasklet);
+	struct bc_state *bcs = ubc->bcs;
 	struct cardstate *cs = bcs->cs;
 	struct isow_urbctx_t *done, *next, *ovfl;
 	struct urb *urb;
@@ -1295,12 +1295,12 @@ static void write_iso_tasklet(unsigned long data)
  * tasklet scheduled when an isochronous input URB from the Gigaset device
  * has completed
  * parameter:
- *	data	B channel state structure
+ *	t	B instance of the tasklet being run
  */
-static void read_iso_tasklet(unsigned long data)
+static void read_iso_tasklet(struct tasklet_struct *t)
 {
-	struct bc_state *bcs = (struct bc_state *) data;
-	struct bas_bc_state *ubc = bcs->hw.bas;
+	struct bas_bc_state *ubc = from_tasklet(ubc, t, rcvd_tasklet);
+	struct bc_state *bcs = ubc->bcs;
 	struct cardstate *cs = bcs->cs;
 	struct urb *urb;
 	int status;
@@ -2145,8 +2145,7 @@ static int gigaset_initbcshw(struct bc_state *bcs)
 		bcs->hw.bas = NULL;
 		return -ENOMEM;
 	}
-	tasklet_init(&ubc->sent_tasklet,
-		     write_iso_tasklet, (unsigned long) bcs);
+	tasklet_setup(&ubc->sent_tasklet, write_iso_tasklet);
 
 	spin_lock_init(&ubc->isoinlock);
 	for (i = 0; i < BAS_INURBS; ++i)
@@ -2166,8 +2165,7 @@ static int gigaset_initbcshw(struct bc_state *bcs)
 	ubc->aborts = 0;
 	ubc->shared0s = 0;
 	ubc->stolen0s = 0;
-	tasklet_init(&ubc->rcvd_tasklet,
-		     read_iso_tasklet, (unsigned long) bcs);
+	tasklet_setup(&ubc->rcvd_tasklet, read_iso_tasklet);
 	return 0;
 }
 
diff --git a/drivers/staging/isdn/gigaset/common.c b/drivers/staging/isdn/gigaset/common.c
index 3bb8092858ab..a0f16907e030 100644
--- a/drivers/staging/isdn/gigaset/common.c
+++ b/drivers/staging/isdn/gigaset/common.c
@@ -689,8 +689,7 @@ struct cardstate *gigaset_initcs(struct gigaset_driver *drv, int channels,
 	cs->ev_tail = 0;
 	cs->ev_head = 0;
 
-	tasklet_init(&cs->event_tasklet, gigaset_handle_event,
-		     (unsigned long) cs);
+	tasklet_setup(&cs->event_tasklet, gigaset_handle_event);
 	tty_port_init(&cs->port);
 	cs->commands_pending = 0;
 	cs->cur_at_seq = 0;
diff --git a/drivers/staging/isdn/gigaset/ev-layer.c b/drivers/staging/isdn/gigaset/ev-layer.c
index f8bb1869c600..0f2335226a2d 100644
--- a/drivers/staging/isdn/gigaset/ev-layer.c
+++ b/drivers/staging/isdn/gigaset/ev-layer.c
@@ -1896,9 +1896,9 @@ static void process_events(struct cardstate *cs)
  * parameter:
  *	data	ISDN controller state structure
  */
-void gigaset_handle_event(unsigned long data)
+void gigaset_handle_event(struct tasklet_struct *t)
 {
-	struct cardstate *cs = (struct cardstate *) data;
+	struct cardstate *cs = from_tasklet(cs, t, event_tasklet);
 
 	/* handle incoming data on control/common channel */
 	if (cs->inbuf->head != cs->inbuf->tail) {
diff --git a/drivers/staging/isdn/gigaset/gigaset.h b/drivers/staging/isdn/gigaset/gigaset.h
index df745c7bf57c..6946a26e45d0 100644
--- a/drivers/staging/isdn/gigaset/gigaset.h
+++ b/drivers/staging/isdn/gigaset/gigaset.h
@@ -689,7 +689,7 @@ void gigaset_isdn_hupB(struct bc_state *bcs);
  */
 
 /* tasklet called from common.c to process queued events */
-void gigaset_handle_event(unsigned long data);
+void gigaset_handle_event(struct tasklet_struct *t);
 
 /* called from isocdata.c / asyncdata.c
  * when a complete modem response line has been received */
diff --git a/drivers/staging/isdn/gigaset/interface.c b/drivers/staging/isdn/gigaset/interface.c
index 17fa615a8c68..a2f79e7dcbee 100644
--- a/drivers/staging/isdn/gigaset/interface.c
+++ b/drivers/staging/isdn/gigaset/interface.c
@@ -492,9 +492,9 @@ static const struct tty_operations if_ops = {
 
 
 /* wakeup tasklet for the write operation */
-static void if_wake(unsigned long data)
+static void if_wake(struct tasklet_struct *t)
 {
-	struct cardstate *cs = (struct cardstate *)data;
+	struct cardstate *cs = from_tasklet(cs, t, if_wake_tasklet);
 
 	tty_port_tty_wakeup(&cs->port);
 }
@@ -509,7 +509,7 @@ void gigaset_if_init(struct cardstate *cs)
 	if (!drv->have_tty)
 		return;
 
-	tasklet_init(&cs->if_wake_tasklet, if_wake, (unsigned long) cs);
+	tasklet_setup(&cs->if_wake_tasklet, if_wake);
 
 	mutex_lock(&cs->mutex);
 	cs->tty_dev = tty_port_register_device(&cs->port, drv->tty,
diff --git a/drivers/staging/isdn/gigaset/ser-gigaset.c b/drivers/staging/isdn/gigaset/ser-gigaset.c
index 5587e9e7fc73..746b5bdd6d83 100644
--- a/drivers/staging/isdn/gigaset/ser-gigaset.c
+++ b/drivers/staging/isdn/gigaset/ser-gigaset.c
@@ -153,9 +153,9 @@ static int send_cb(struct cardstate *cs)
  * by calling "write_modem".
  * Otherwise take a new skb out of the queue.
  */
-static void gigaset_modem_fill(unsigned long data)
+static void gigaset_modem_fill(struct tasklet_struct *t)
 {
-	struct cardstate *cs = (struct cardstate *) data;
+	struct cardstate *cs = from_tasklet(cs, t, write_tasklet);
 	struct bc_state *bcs;
 	struct sk_buff *nextskb;
 	int sent = 0;
@@ -400,8 +400,7 @@ static int gigaset_initcshw(struct cardstate *cs)
 		return rc;
 	}
 
-	tasklet_init(&cs->write_tasklet,
-		     gigaset_modem_fill, (unsigned long) cs);
+	tasklet_setup(&cs->write_tasklet, gigaset_modem_fill);
 	return 0;
 }
 
diff --git a/drivers/staging/isdn/gigaset/usb-gigaset.c b/drivers/staging/isdn/gigaset/usb-gigaset.c
index 1b9b43659bdf..a5f628acb238 100644
--- a/drivers/staging/isdn/gigaset/usb-gigaset.c
+++ b/drivers/staging/isdn/gigaset/usb-gigaset.c
@@ -296,9 +296,9 @@ static int send_cb(struct cardstate *cs);
 /* Write tasklet handler: Continue sending current skb, or send command, or
  * start sending an skb from the send queue.
  */
-static void gigaset_modem_fill(unsigned long data)
+static void gigaset_modem_fill(struct tasklet_struct *t)
 {
-	struct cardstate *cs = (struct cardstate *) data;
+	struct cardstate *cs = from_tasklet(cs, t, write_tasklet);
 	struct bc_state *bcs = &cs->bcs[0]; /* only one channel */
 
 	gig_dbg(DEBUG_OUTPUT, "modem_fill");
@@ -587,8 +587,7 @@ static int gigaset_initcshw(struct cardstate *cs)
 	ucs->bulk_out_buffer = NULL;
 	ucs->bulk_out_urb = NULL;
 	ucs->read_urb = NULL;
-	tasklet_init(&cs->write_tasklet,
-		     gigaset_modem_fill, (unsigned long) cs);
+	tasklet_setup(&cs->write_tasklet, gigaset_modem_fill);
 
 	return 0;
 }
diff --git a/drivers/staging/ks7010/ks7010_sdio.c b/drivers/staging/ks7010/ks7010_sdio.c
index 4b379542ecd5..9f5e80b65dcf 100644
--- a/drivers/staging/ks7010/ks7010_sdio.c
+++ b/drivers/staging/ks7010/ks7010_sdio.c
@@ -405,9 +405,9 @@ int ks_wlan_hw_tx(struct ks_wlan_private *priv, void *p, unsigned long size,
 	return result;
 }
 
-static void rx_event_task(unsigned long dev)
+static void rx_event_task(struct tasklet_struct *t)
 {
-	struct ks_wlan_private *priv = (struct ks_wlan_private *)dev;
+	struct ks_wlan_private *priv = from_tasklet(priv, t, rx_bh_task);
 	struct rx_device_buffer *rp;
 
 	if (rxq_has_space(priv) && priv->dev_state >= DEVICE_STATE_BOOT) {
@@ -617,7 +617,7 @@ static int trx_device_init(struct ks_wlan_private *priv)
 	spin_lock_init(&priv->tx_dev.tx_dev_lock);
 	spin_lock_init(&priv->rx_dev.rx_dev_lock);
 
-	tasklet_init(&priv->rx_bh_task, rx_event_task, (unsigned long)priv);
+	tasklet_setup(&priv->rx_bh_task, rx_event_task);
 
 	return 0;
 }
diff --git a/drivers/staging/ks7010/ks_hostif.c b/drivers/staging/ks7010/ks_hostif.c
index 2666f9e30c15..26fc11a8aec9 100644
--- a/drivers/staging/ks7010/ks_hostif.c
+++ b/drivers/staging/ks7010/ks_hostif.c
@@ -2210,9 +2210,9 @@ static void hostif_sme_execute(struct ks_wlan_private *priv, int event)
 }
 
 static
-void hostif_sme_task(unsigned long dev)
+void hostif_sme_task(struct tasklet_struct *t)
 {
-	struct ks_wlan_private *priv = (struct ks_wlan_private *)dev;
+	struct ks_wlan_private *priv = from_tasklet(priv, t, sme_task);
 
 	if (priv->dev_state < DEVICE_STATE_BOOT)
 		return;
@@ -2263,7 +2263,7 @@ static inline void hostif_sme_init(struct ks_wlan_private *priv)
 	priv->sme_i.qtail = 0;
 	spin_lock_init(&priv->sme_i.sme_spin);
 	priv->sme_i.sme_flag = 0;
-	tasklet_init(&priv->sme_task, hostif_sme_task, (unsigned long)priv);
+	tasklet_setup(&priv->sme_task, hostif_sme_task);
 }
 
 static inline void hostif_wpa_init(struct ks_wlan_private *priv)
diff --git a/drivers/staging/mt7621-dma/mtk-hsdma.c b/drivers/staging/mt7621-dma/mtk-hsdma.c
index d964642d95a3..bf1e47a3bfc7 100644
--- a/drivers/staging/mt7621-dma/mtk-hsdma.c
+++ b/drivers/staging/mt7621-dma/mtk-hsdma.c
@@ -534,9 +534,9 @@ static void mtk_hsdma_rx(struct mtk_hsdam_engine *hsdma)
 	mtk_hsdma_chan_done(hsdma, chan);
 }
 
-static void mtk_hsdma_tasklet(unsigned long arg)
+static void mtk_hsdma_tasklet(struct tasklet_struct *t)
 {
-	struct mtk_hsdam_engine *hsdma = (struct mtk_hsdam_engine *)arg;
+	struct mtk_hsdam_engine *hsdma = from_tasklet(hsdma, t, task);
 
 	mtk_hsdma_rx(hsdma);
 	mtk_hsdma_tx(hsdma);
@@ -672,7 +672,7 @@ static int mtk_hsdma_probe(struct platform_device *pdev)
 	if (IS_ERR(base))
 		return PTR_ERR(base);
 	hsdma->base = base + HSDMA_BASE_OFFSET;
-	tasklet_init(&hsdma->task, mtk_hsdma_tasklet, (unsigned long)hsdma);
+	tasklet_setup(&hsdma->task, mtk_hsdma_tasklet);
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
diff --git a/drivers/staging/ralink-gdma/ralink-gdma.c b/drivers/staging/ralink-gdma/ralink-gdma.c
index 900424db9b97..b9c88e71b312 100644
--- a/drivers/staging/ralink-gdma/ralink-gdma.c
+++ b/drivers/staging/ralink-gdma/ralink-gdma.c
@@ -701,9 +701,9 @@ static void gdma_dma_desc_free(struct virt_dma_desc *vdesc)
 	kfree(container_of(vdesc, struct gdma_dma_desc, vdesc));
 }
 
-static void gdma_dma_tasklet(unsigned long arg)
+static void gdma_dma_tasklet(struct tasklet_struct *t)
 {
-	struct gdma_dma_dev *dma_dev = (struct gdma_dma_dev *)arg;
+	struct gdma_dma_dev *dma_dev = from_tasklet(dma_dev, t, task);
 	struct gdma_dmaengine_chan *chan;
 	static unsigned int last_chan;
 	unsigned int i, chan_mask;
@@ -823,7 +823,7 @@ static int gdma_dma_probe(struct platform_device *pdev)
 	if (IS_ERR(base))
 		return PTR_ERR(base);
 	dma_dev->base = base;
-	tasklet_init(&dma_dev->task, gdma_dma_tasklet, (unsigned long)dma_dev);
+	tasklet_setup(&dma_dev->task, gdma_dma_tasklet);
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c b/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
index c0d51ba70a75..1c0350dfc5a0 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
@@ -22,9 +22,7 @@ int	rtw_hal_init_recv_priv(struct adapter *padapter)
 	int	i, res = _SUCCESS;
 	struct recv_buf *precvbuf;
 
-	tasklet_init(&precvpriv->recv_tasklet,
-		     (void(*)(unsigned long))rtl8188eu_recv_tasklet,
-		     (unsigned long)padapter);
+	tasklet_setup(&precvpriv->recv_tasklet, rtl8188eu_recv_tasklet);
 
 	/* init recv_buf */
 	_rtw_init_queue(&precvpriv->free_recv_buf_queue);
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c b/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c
index ab94ad9d608a..d848cdb09eee 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c
@@ -17,9 +17,8 @@ s32 rtw_hal_init_xmit_priv(struct adapter *adapt)
 {
 	struct xmit_priv *pxmitpriv = &adapt->xmitpriv;
 
-	tasklet_init(&pxmitpriv->xmit_tasklet,
-		     (void(*)(unsigned long))rtl8188eu_xmit_tasklet,
-		     (unsigned long)adapt);
+	tasklet_setup(&pxmitpriv->xmit_tasklet, rtl8188eu_xmit_tasklet);
+
 	return _SUCCESS;
 }
 
diff --git a/drivers/staging/rtl8188eu/include/rtl8188e_recv.h b/drivers/staging/rtl8188eu/include/rtl8188e_recv.h
index c2c7ef974dc5..fea1119c426e 100644
--- a/drivers/staging/rtl8188eu/include/rtl8188e_recv.h
+++ b/drivers/staging/rtl8188eu/include/rtl8188e_recv.h
@@ -43,7 +43,7 @@ enum rx_packet_type {
 };
 
 #define INTERRUPT_MSG_FORMAT_LEN 60
-void rtl8188eu_recv_tasklet(void *priv);
+void rtl8188eu_recv_tasklet(struct tasklet_struct *t);
 void rtl8188e_process_phy_info(struct adapter *padapter,
 			       struct recv_frame *prframe);
 void update_recvframe_phyinfo_88e(struct recv_frame *fra, struct phy_stat *phy);
diff --git a/drivers/staging/rtl8188eu/include/rtl8188e_xmit.h b/drivers/staging/rtl8188eu/include/rtl8188e_xmit.h
index 421e9f45306f..77fd699a80ba 100644
--- a/drivers/staging/rtl8188eu/include/rtl8188e_xmit.h
+++ b/drivers/staging/rtl8188eu/include/rtl8188e_xmit.h
@@ -148,7 +148,7 @@ void rtl8188e_fill_fake_txdesc(struct adapter *padapter, u8 *pDesc,
 s32 rtl8188eu_init_xmit_priv(struct adapter *padapter);
 s32 rtl8188eu_xmit_buf_handler(struct adapter *padapter);
 #define hal_xmit_handler rtl8188eu_xmit_buf_handler
-void rtl8188eu_xmit_tasklet(void *priv);
+void rtl8188eu_xmit_tasklet(struct tasklet_struct *t);
 bool rtl8188eu_xmitframe_complete(struct adapter *padapter,
 				  struct xmit_priv *pxmitpriv);
 
diff --git a/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c b/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
index aaab0d577453..644aa09b0ae3 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
@@ -773,10 +773,10 @@ void usb_write_port_cancel(struct adapter *padapter)
 	}
 }
 
-void rtl8188eu_recv_tasklet(void *priv)
+void rtl8188eu_recv_tasklet(struct tasklet_struct *t)
 {
 	struct sk_buff *pskb;
-	struct adapter *adapt = priv;
+	struct adapter *adapt = from_tasklet(adapt, t, recvpriv.recv_tasklet);
 	struct recv_priv *precvpriv = &adapt->recvpriv;
 
 	while (NULL != (pskb = skb_dequeue(&precvpriv->rx_skb_queue))) {
@@ -792,9 +792,9 @@ void rtl8188eu_recv_tasklet(void *priv)
 	}
 }
 
-void rtl8188eu_xmit_tasklet(void *priv)
+void rtl8188eu_xmit_tasklet(struct tasklet_struct *t)
 {
-	struct adapter *adapt = priv;
+	struct adapter *adapt = from_tasklet(adapt, t, xmitpriv.xmit_tasklet);
 	struct xmit_priv *pxmitpriv = &adapt->xmitpriv;
 
 	if (check_fwstate(&adapt->mlmepriv, _FW_UNDER_SURVEY))
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
index f932cb15e4e5..f5b41baa0f85 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
@@ -81,8 +81,8 @@ static int _rtl92e_hard_start_xmit(struct sk_buff *skb, struct net_device *dev);
 static void _rtl92e_tx_cmd(struct net_device *dev, struct sk_buff *skb);
 static short _rtl92e_tx(struct net_device *dev, struct sk_buff *skb);
 static short _rtl92e_pci_initdescring(struct net_device *dev);
-static void _rtl92e_irq_tx_tasklet(struct r8192_priv *priv);
-static void _rtl92e_irq_rx_tasklet(struct r8192_priv *priv);
+static void _rtl92e_irq_tx_tasklet(struct tasklet_struct *t);
+static void _rtl92e_irq_rx_tasklet(struct tasklet_struct *t);
 static void _rtl92e_cancel_deferred_work(struct r8192_priv *priv);
 static int _rtl92e_up(struct net_device *dev, bool is_silent_reset);
 static int _rtl92e_try_up(struct net_device *dev);
@@ -516,8 +516,10 @@ static int _rtl92e_handle_assoc_response(struct net_device *dev,
 	return 0;
 }
 
-static void _rtl92e_prepare_beacon(struct r8192_priv *priv)
+static void _rtl92e_prepare_beacon(struct tasklet_struct *t)
 {
+	struct r8192_priv *priv = from_tasklet(priv, t,
+					       irq_prepare_beacon_tasklet);
 	struct net_device *dev = priv->rtllib->dev;
 	struct sk_buff *pskb = NULL, *pnewskb = NULL;
 	struct cb_desc *tcb_desc = NULL;
@@ -1007,15 +1009,10 @@ static void _rtl92e_init_priv_task(struct net_device *dev)
 			      (void *)rtl92e_hw_wakeup_wq, dev);
 	INIT_DELAYED_WORK_RSL(&priv->rtllib->hw_sleep_wq,
 			      (void *)rtl92e_hw_sleep_wq, dev);
-	tasklet_init(&priv->irq_rx_tasklet,
-		     (void(*)(unsigned long))_rtl92e_irq_rx_tasklet,
-		     (unsigned long)priv);
-	tasklet_init(&priv->irq_tx_tasklet,
-		     (void(*)(unsigned long))_rtl92e_irq_tx_tasklet,
-		     (unsigned long)priv);
-	tasklet_init(&priv->irq_prepare_beacon_tasklet,
-		     (void(*)(unsigned long))_rtl92e_prepare_beacon,
-		     (unsigned long)priv);
+	tasklet_setup(&priv->irq_rx_tasklet, _rtl92e_irq_rx_tasklet);
+	tasklet_setup(&priv->irq_tx_tasklet, _rtl92e_irq_tx_tasklet);
+	tasklet_setup(&priv->irq_prepare_beacon_tasklet,
+		      _rtl92e_prepare_beacon);
 }
 
 static short _rtl92e_get_channel_map(struct net_device *dev)
@@ -2119,13 +2116,17 @@ static void _rtl92e_tx_resume(struct net_device *dev)
 	}
 }
 
-static void _rtl92e_irq_tx_tasklet(struct r8192_priv *priv)
+static void _rtl92e_irq_tx_tasklet(struct tasklet_struct *t)
 {
+	struct r8192_priv *priv = from_tasklet(priv, t, irq_tx_tasklet);
+
 	_rtl92e_tx_resume(priv->rtllib->dev);
 }
 
-static void _rtl92e_irq_rx_tasklet(struct r8192_priv *priv)
+static void _rtl92e_irq_rx_tasklet(struct tasklet_struct *t)
 {
+	struct r8192_priv *priv = from_tasklet(priv, t, irq_rx_tasklet);
+
 	_rtl92e_rx_normal(priv->rtllib->dev);
 
 	rtl92e_writel(priv->rtllib->dev, INTA_MASK,
diff --git a/drivers/staging/rtl8192e/rtllib_softmac.c b/drivers/staging/rtl8192e/rtllib_softmac.c
index f2f7529e7c80..51c6ba7269f0 100644
--- a/drivers/staging/rtl8192e/rtllib_softmac.c
+++ b/drivers/staging/rtl8192e/rtllib_softmac.c
@@ -2044,8 +2044,9 @@ static short rtllib_sta_ps_sleep(struct rtllib_device *ieee, u64 *time)
 
 }
 
-static inline void rtllib_sta_ps(struct rtllib_device *ieee)
+static inline void rtllib_sta_ps(struct tasklet_struct *t)
 {
+	struct rtllib_device *ieee = from_tasklet(ieee, t, ps_task);
 	u64 time;
 	short sleep;
 	unsigned long flags, flags2;
@@ -3027,10 +3028,7 @@ void rtllib_softmac_init(struct rtllib_device *ieee)
 	spin_lock_init(&ieee->mgmt_tx_lock);
 	spin_lock_init(&ieee->beacon_lock);
 
-	tasklet_init(&ieee->ps_task,
-	     (void(*)(unsigned long)) rtllib_sta_ps,
-	     (unsigned long)ieee);
-
+	tasklet_setup(&ieee->ps_task, rtllib_sta_ps);
 }
 
 void rtllib_softmac_free(struct rtllib_device *ieee)
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
index 33a6af7aad22..b684c8a5f583 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
@@ -1683,8 +1683,9 @@ static short ieee80211_sta_ps_sleep(struct ieee80211_device *ieee, u32 *time_h,
 	return 1;
 }
 
-static inline void ieee80211_sta_ps(struct ieee80211_device *ieee)
+static inline void ieee80211_sta_ps(struct tasklet_struct *t)
 {
+	struct ieee80211_device *ieee = from_tasklet(ieee, t, ps_task);
 	u32 th, tl;
 	short sleep;
 
@@ -2593,9 +2594,7 @@ void ieee80211_softmac_init(struct ieee80211_device *ieee)
 	spin_lock_init(&ieee->mgmt_tx_lock);
 	spin_lock_init(&ieee->beacon_lock);
 
-	tasklet_init(&ieee->ps_task,
-		     (void(*)(unsigned long)) ieee80211_sta_ps,
-		     (unsigned long)ieee);
+	tasklet_setup(&ieee->ps_task, ieee80211_sta_ps);
 }
 
 void ieee80211_softmac_free(struct ieee80211_device *ieee)
diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 2821411878ce..f076ba6c36a7 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -2211,7 +2211,7 @@ static void rtl8192_init_priv_lock(struct r8192_priv *priv)
 
 static void rtl819x_watchdog_wqcallback(struct work_struct *work);
 
-static void rtl8192_irq_rx_tasklet(struct r8192_priv *priv);
+static void rtl8192_irq_rx_tasklet(struct tasklet_struct *t);
 /* init tasklet and wait_queue here. only 2.6 above kernel is considered */
 #define DRV_NAME "wlan0"
 static void rtl8192_init_priv_task(struct net_device *dev)
@@ -2233,9 +2233,7 @@ static void rtl8192_init_priv_task(struct net_device *dev)
 			  InitialGainOperateWorkItemCallBack);
 	INIT_WORK(&priv->qos_activate, rtl8192_qos_activate);
 
-	tasklet_init(&priv->irq_rx_tasklet,
-		     (void(*)(unsigned long))rtl8192_irq_rx_tasklet,
-		     (unsigned long)priv);
+	tasklet_setup(&priv->irq_rx_tasklet, rtl8192_irq_rx_tasklet);
 }
 
 static void rtl8192_get_eeprom_size(struct net_device *dev)
@@ -4716,8 +4714,9 @@ static void rtl8192_rx_cmd(struct sk_buff *skb)
 	}
 }
 
-static void rtl8192_irq_rx_tasklet(struct r8192_priv *priv)
+static void rtl8192_irq_rx_tasklet(struct tasklet_struct *t)
 {
+	struct r8192_priv *priv = from_tasklet(priv, t, irq_rx_tasklet);
 	struct sk_buff *skb;
 	struct rtl8192_rx_info *info;
 
diff --git a/drivers/staging/rtl8712/rtl8712_recv.c b/drivers/staging/rtl8712/rtl8712_recv.c
index 9901815604f4..d332b529a29a 100644
--- a/drivers/staging/rtl8712/rtl8712_recv.c
+++ b/drivers/staging/rtl8712/rtl8712_recv.c
@@ -33,7 +33,7 @@ static u8 bridge_tunnel_header[] = {0xaa, 0xaa, 0x03, 0x00, 0x00, 0xf8};
 /* Ethernet-II snap header (RFC1042 for most EtherTypes) */
 static u8 rfc1042_header[] = {0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00};
 
-static void recv_tasklet(void *priv);
+static void recv_tasklet(struct tasklet_struct *t);
 
 void r8712_init_recv_priv(struct recv_priv *precvpriv,
 			  struct _adapter *padapter)
@@ -65,9 +65,7 @@ void r8712_init_recv_priv(struct recv_priv *precvpriv,
 		precvbuf++;
 	}
 	precvpriv->free_recv_buf_queue_cnt = NR_RECVBUFF;
-	tasklet_init(&precvpriv->recv_tasklet,
-	     (void(*)(unsigned long))recv_tasklet,
-	     (unsigned long)padapter);
+	tasklet_setup(&precvpriv->recv_tasklet, recv_tasklet);
 	skb_queue_head_init(&precvpriv->rx_skb_queue);
 
 	skb_queue_head_init(&precvpriv->free_recv_skb_queue);
@@ -1080,10 +1078,10 @@ static void recvbuf2recvframe(struct _adapter *padapter, struct sk_buff *pskb)
 	} while ((transfer_len > 0) && pkt_cnt > 0);
 }
 
-static void recv_tasklet(void *priv)
+static void recv_tasklet(struct tasklet_struct *t)
 {
 	struct sk_buff *pskb;
-	struct _adapter *padapter = priv;
+	struct _adapter *padapter = from_tasklet(padapter, t, recvpriv.recv_tasklet);
 	struct recv_priv *precvpriv = &padapter->recvpriv;
 
 	while (NULL != (pskb = skb_dequeue(&precvpriv->rx_skb_queue))) {
diff --git a/drivers/staging/rtl8712/rtl871x_xmit.c b/drivers/staging/rtl8712/rtl871x_xmit.c
index cc5809e49e35..c7f2c00aa8b9 100644
--- a/drivers/staging/rtl8712/rtl871x_xmit.c
+++ b/drivers/staging/rtl8712/rtl871x_xmit.c
@@ -143,9 +143,7 @@ int _r8712_init_xmit_priv(struct xmit_priv *pxmitpriv,
 	INIT_WORK(&padapter->wk_filter_rx_ff0, r8712_SetFilter);
 	alloc_hwxmits(padapter);
 	init_hwxmits(pxmitpriv->hwxmits, pxmitpriv->hwxmit_entry);
-	tasklet_init(&pxmitpriv->xmit_tasklet,
-		(void(*)(unsigned long))r8712_xmit_bh,
-		(unsigned long)padapter);
+	tasklet_setup(&pxmitpriv->xmit_tasklet, r8712_xmit_bh);
 	return 0;
 }
 
diff --git a/drivers/staging/rtl8712/rtl871x_xmit.h b/drivers/staging/rtl8712/rtl871x_xmit.h
index b14da38bf652..36008478062a 100644
--- a/drivers/staging/rtl8712/rtl871x_xmit.h
+++ b/drivers/staging/rtl8712/rtl871x_xmit.h
@@ -277,7 +277,7 @@ int r8712_pre_xmit(struct _adapter *padapter, struct xmit_frame *pxmitframe);
 int r8712_xmit_enqueue(struct _adapter *padapter,
 		       struct xmit_frame *pxmitframe);
 void r8712_xmit_direct(struct _adapter *padapter, struct xmit_frame *pxmitframe);
-void r8712_xmit_bh(void *priv);
+void r8712_xmit_bh(struct tasklet_struct *t);
 
 void xmitframe_xmitbuf_attach(struct xmit_frame *pxmitframe,
 			struct xmit_buf *pxmitbuf);
diff --git a/drivers/staging/rtl8712/usb_ops_linux.c b/drivers/staging/rtl8712/usb_ops_linux.c
index 9d290bc2fdb7..acf828101401 100644
--- a/drivers/staging/rtl8712/usb_ops_linux.c
+++ b/drivers/staging/rtl8712/usb_ops_linux.c
@@ -308,10 +308,10 @@ void r8712_usb_read_port_cancel(struct _adapter *padapter)
 	}
 }
 
-void r8712_xmit_bh(void *priv)
+void r8712_xmit_bh(struct tasklet_struct *t)
 {
 	int ret = false;
-	struct _adapter *padapter = priv;
+	struct _adapter *padapter = from_tasklet(padapter, t, xmitpriv.xmit_tasklet);
 	struct xmit_priv *pxmitpriv = &padapter->xmitpriv;
 
 	if (padapter->driver_stopped ||
diff --git a/drivers/staging/rtl8723bs/hal/rtl8723bs_recv.c b/drivers/staging/rtl8723bs/hal/rtl8723bs_recv.c
index 0f3301091258..638fb6ff3962 100644
--- a/drivers/staging/rtl8723bs/hal/rtl8723bs_recv.c
+++ b/drivers/staging/rtl8723bs/hal/rtl8723bs_recv.c
@@ -232,9 +232,10 @@ static inline bool pkt_exceeds_tail(struct recv_priv *precvpriv,
 	return false;
 }
 
-static void rtl8723bs_recv_tasklet(void *priv)
+static void rtl8723bs_recv_tasklet(struct tasklet_struct *t)
 {
-	struct adapter *padapter;
+	struct adapter *padapter = from_tasklet(padapter, t,
+						recvpriv.recv_tasklet);
 	struct hal_com_data *p_hal_data;
 	struct recv_priv *precvpriv;
 	struct recv_buf *precvbuf;
@@ -246,7 +247,6 @@ static void rtl8723bs_recv_tasklet(void *priv)
 	_pkt *pkt_copy = NULL;
 	u8 shift_sz = 0, rx_report_sz = 0;
 
-	padapter = priv;
 	p_hal_data = GET_HAL_DATA(padapter);
 	precvpriv = &padapter->recvpriv;
 	recv_buf_queue = &precvpriv->recv_buf_pending_queue;
@@ -464,11 +464,8 @@ s32 rtl8723bs_init_recv_priv(struct adapter *padapter)
 		goto initbuferror;
 
 	/* 3 2. init tasklet */
-	tasklet_init(
-		&precvpriv->recv_tasklet,
-		(void(*)(unsigned long))rtl8723bs_recv_tasklet,
-		(unsigned long)padapter
-	);
+	tasklet_setup(
+		&precvpriv->recv_tasklet, rtl8723bs_recv_tasklet);
 
 	goto exit;
 
diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index 28d372a0663a..62cbc7c900d1 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -191,9 +191,9 @@ static void hfa384x_usbctlx_resptimerfn(struct timer_list *t);
 
 static void hfa384x_usb_throttlefn(struct timer_list *t);
 
-static void hfa384x_usbctlx_completion_task(unsigned long data);
+static void hfa384x_usbctlx_completion_task(struct tasklet_struct *t);
 
-static void hfa384x_usbctlx_reaper_task(unsigned long data);
+static void hfa384x_usbctlx_reaper_task(struct tasklet_struct *t);
 
 static int hfa384x_usbctlx_submit(struct hfa384x *hw,
 				  struct hfa384x_usbctlx *ctlx);
@@ -546,10 +546,8 @@ void hfa384x_create(struct hfa384x *hw, struct usb_device *usb)
 	/* Initialize the authentication queue */
 	skb_queue_head_init(&hw->authq);
 
-	tasklet_init(&hw->reaper_bh,
-		     hfa384x_usbctlx_reaper_task, (unsigned long)hw);
-	tasklet_init(&hw->completion_bh,
-		     hfa384x_usbctlx_completion_task, (unsigned long)hw);
+	tasklet_setup(&hw->reaper_bh, hfa384x_usbctlx_reaper_task);
+	tasklet_setup(&hw->completion_bh, hfa384x_usbctlx_completion_task);
 	INIT_WORK(&hw->link_bh, prism2sta_processing_defer);
 	INIT_WORK(&hw->usb_work, hfa384x_usb_defer);
 
@@ -2606,9 +2604,9 @@ void hfa384x_tx_timeout(struct wlandevice *wlandev)
  *	Interrupt
  *----------------------------------------------------------------
  */
-static void hfa384x_usbctlx_reaper_task(unsigned long data)
+static void hfa384x_usbctlx_reaper_task(struct tasklet_struct *t)
 {
-	struct hfa384x *hw = (struct hfa384x *)data;
+	struct hfa384x *hw = from_tasklet(hw, t, reaper_bh);
 	struct hfa384x_usbctlx *ctlx, *temp;
 	unsigned long flags;
 
@@ -2640,9 +2638,9 @@ static void hfa384x_usbctlx_reaper_task(unsigned long data)
  *	Interrupt
  *----------------------------------------------------------------
  */
-static void hfa384x_usbctlx_completion_task(unsigned long data)
+static void hfa384x_usbctlx_completion_task(struct tasklet_struct *t)
 {
-	struct hfa384x *hw = (struct hfa384x *)data;
+	struct hfa384x *hw = from_tasklet(hw, t, completion_bh);
 	struct hfa384x_usbctlx *ctlx, *temp;
 	unsigned long flags;
 
diff --git a/drivers/staging/wlan-ng/p80211netdev.c b/drivers/staging/wlan-ng/p80211netdev.c
index a70fb84f38f1..89827be85461 100644
--- a/drivers/staging/wlan-ng/p80211netdev.c
+++ b/drivers/staging/wlan-ng/p80211netdev.c
@@ -268,9 +268,9 @@ static int p80211_convert_to_ether(struct wlandevice *wlandev,
  *
  * @arg: pointer to WLAN network device structure (cast to unsigned long)
  */
-static void p80211netdev_rx_bh(unsigned long arg)
+static void p80211netdev_rx_bh(struct tasklet_struct *t)
 {
-	struct wlandevice *wlandev = (struct wlandevice *)arg;
+	struct wlandevice *wlandev = from_tasklet(wlandev, t, rx_bh);
 	struct sk_buff *skb = NULL;
 	struct net_device *dev = wlandev->netdev;
 
@@ -728,8 +728,7 @@ int wlan_setup(struct wlandevice *wlandev, struct device *physdev)
 
 	/* Set up the rx queue */
 	skb_queue_head_init(&wlandev->nsd_rxq);
-	tasklet_init(&wlandev->rx_bh,
-		     p80211netdev_rx_bh, (unsigned long)wlandev);
+	tasklet_setup(&wlandev->rx_bh, p80211netdev_rx_bh);
 
 	/* Allocate and initialize the wiphy struct */
 	wiphy = wlan_create_wiphy(physdev, wlandev);
diff --git a/drivers/tty/ipwireless/hardware.c b/drivers/tty/ipwireless/hardware.c
index 6bbf35682d53..f5d3e68f5750 100644
--- a/drivers/tty/ipwireless/hardware.c
+++ b/drivers/tty/ipwireless/hardware.c
@@ -1006,9 +1006,9 @@ static int send_pending_packet(struct ipw_hardware *hw, int priority_limit)
 /*
  * Send and receive all queued packets.
  */
-static void ipwireless_do_tasklet(unsigned long hw_)
+static void ipwireless_do_tasklet(struct tasklet_struct *t)
 {
-	struct ipw_hardware *hw = (struct ipw_hardware *) hw_;
+	struct ipw_hardware *hw = from_tasklet(hw, t, tasklet);
 	unsigned long flags;
 
 	spin_lock_irqsave(&hw->lock, flags);
@@ -1635,7 +1635,7 @@ struct ipw_hardware *ipwireless_hardware_create(void)
 	INIT_LIST_HEAD(&hw->rx_queue);
 	INIT_LIST_HEAD(&hw->rx_pool);
 	spin_lock_init(&hw->lock);
-	tasklet_init(&hw->tasklet, ipwireless_do_tasklet, (unsigned long) hw);
+	tasklet_setup(&hw->tasklet, ipwireless_do_tasklet);
 	INIT_WORK(&hw->work_rx, ipw_receive_data_work);
 	timer_setup(&hw->setup_timer, ipwireless_setup_timer, 0);
 
diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index a8dc8af83f39..1fc46d5c3ca6 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -1719,10 +1719,10 @@ static int atmel_prepare_rx_pdc(struct uart_port *port)
 /*
  * tasklet handling tty stuff outside the interrupt handler.
  */
-static void atmel_tasklet_rx_func(unsigned long data)
+static void atmel_tasklet_rx_func(struct tasklet_struct *t)
 {
-	struct uart_port *port = (struct uart_port *)data;
-	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
+	struct atmel_uart_port *atmel_port = from_tasklet(atmel_port, t, tasklet_rx);
+	struct uart_port *port = &atmel_port->uart;
 
 	/* The interrupt handler does not take the lock */
 	spin_lock(&port->lock);
@@ -1730,10 +1730,10 @@ static void atmel_tasklet_rx_func(unsigned long data)
 	spin_unlock(&port->lock);
 }
 
-static void atmel_tasklet_tx_func(unsigned long data)
+static void atmel_tasklet_tx_func(struct tasklet_struct *t)
 {
-	struct uart_port *port = (struct uart_port *)data;
-	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
+	struct atmel_uart_port *atmel_port = from_tasklet(atmel_port, t, tasklet_tx);
+	struct uart_port *port = &atmel_port->uart;
 
 	/* The interrupt handler does not take the lock */
 	spin_lock(&port->lock);
@@ -1908,10 +1908,8 @@ static int atmel_startup(struct uart_port *port)
 	}
 
 	atomic_set(&atmel_port->tasklet_shutdown, 0);
-	tasklet_init(&atmel_port->tasklet_rx, atmel_tasklet_rx_func,
-			(unsigned long)port);
-	tasklet_init(&atmel_port->tasklet_tx, atmel_tasklet_tx_func,
-			(unsigned long)port);
+	tasklet_setup(&atmel_port->tasklet_rx, atmel_tasklet_rx_func);
+	tasklet_setup(&atmel_port->tasklet_tx, atmel_tasklet_tx_func);
 
 	/*
 	 * Initialize DMA (if necessary)
diff --git a/drivers/tty/serial/ifx6x60.c b/drivers/tty/serial/ifx6x60.c
index ffefd218761e..23d69d94c799 100644
--- a/drivers/tty/serial/ifx6x60.c
+++ b/drivers/tty/serial/ifx6x60.c
@@ -726,10 +726,10 @@ static void ifx_spi_complete(void *ctx)
  *	Queue data for transmission if possible and then kick off the
  *	transfer.
  */
-static void ifx_spi_io(unsigned long data)
+static void ifx_spi_io(struct tasklet_struct *t)
 {
 	int retval;
-	struct ifx_spi_device *ifx_dev = (struct ifx_spi_device *) data;
+	struct ifx_spi_device *ifx_dev = from_tasklet(ifx_dev, t, io_work_tasklet);
 
 	if (!test_and_set_bit(IFX_SPI_STATE_IO_IN_PROGRESS, &ifx_dev->flags) &&
 		test_bit(IFX_SPI_STATE_IO_AVAILABLE, &ifx_dev->flags)) {
@@ -1067,8 +1067,7 @@ static int ifx_spi_spi_probe(struct spi_device *spi)
 	init_waitqueue_head(&ifx_dev->mdm_reset_wait);
 
 	spi_set_drvdata(spi, ifx_dev);
-	tasklet_init(&ifx_dev->io_work_tasklet, ifx_spi_io,
-						(unsigned long)ifx_dev);
+	tasklet_setup(&ifx_dev->io_work_tasklet, ifx_spi_io);
 
 	set_bit(IFX_SPI_STATE_PRESENT, &ifx_dev->flags);
 
diff --git a/drivers/tty/serial/timbuart.c b/drivers/tty/serial/timbuart.c
index 19d38b504e27..2126e6e6dfd1 100644
--- a/drivers/tty/serial/timbuart.c
+++ b/drivers/tty/serial/timbuart.c
@@ -172,9 +172,9 @@ static void timbuart_handle_rx_port(struct uart_port *port, u32 isr, u32 *ier)
 	dev_dbg(port->dev, "%s - leaving\n", __func__);
 }
 
-static void timbuart_tasklet(unsigned long arg)
+static void timbuart_tasklet(struct tasklet_struct *t)
 {
-	struct timbuart_port *uart = (struct timbuart_port *)arg;
+	struct timbuart_port *uart = from_tasklet(uart, t, tasklet);
 	u32 isr, ier = 0;
 
 	spin_lock(&uart->port.lock);
@@ -451,7 +451,7 @@ static int timbuart_probe(struct platform_device *dev)
 	}
 	uart->port.irq = irq;
 
-	tasklet_init(&uart->tasklet, timbuart_tasklet, (unsigned long)uart);
+	tasklet_setup(&uart->tasklet, timbuart_tasklet);
 
 	err = uart_register_driver(&timbuart_driver);
 	if (err)
diff --git a/drivers/usb/atm/usbatm.c b/drivers/usb/atm/usbatm.c
index dbea28495e1d..d102db9ca9b1 100644
--- a/drivers/usb/atm/usbatm.c
+++ b/drivers/usb/atm/usbatm.c
@@ -511,9 +511,9 @@ static unsigned int usbatm_write_cells(struct usbatm_data *instance,
 **  receive  **
 **************/
 
-static void usbatm_rx_process(unsigned long data)
+static void usbatm_rx_process(struct tasklet_struct *t)
 {
-	struct usbatm_data *instance = (struct usbatm_data *)data;
+	struct usbatm_data *instance = from_tasklet(instance, t, rx_channel.tasklet);
 	struct urb *urb;
 
 	while ((urb = usbatm_pop_urb(&instance->rx_channel))) {
@@ -564,9 +564,9 @@ static void usbatm_rx_process(unsigned long data)
 **  send  **
 ***********/
 
-static void usbatm_tx_process(unsigned long data)
+static void usbatm_tx_process(struct tasklet_struct *t)
 {
-	struct usbatm_data *instance = (struct usbatm_data *)data;
+	struct usbatm_data *instance = from_tasklet(instance, t, tx_channel.tasklet);
 	struct sk_buff *skb = instance->current_skb;
 	struct urb *urb = NULL;
 	const unsigned int buf_size = instance->tx_channel.buf_size;
@@ -1069,8 +1069,8 @@ int usbatm_usb_probe(struct usb_interface *intf, const struct usb_device_id *id,
 
 	usbatm_init_channel(&instance->rx_channel);
 	usbatm_init_channel(&instance->tx_channel);
-	tasklet_init(&instance->rx_channel.tasklet, usbatm_rx_process, (unsigned long)instance);
-	tasklet_init(&instance->tx_channel.tasklet, usbatm_tx_process, (unsigned long)instance);
+	tasklet_setup(&instance->rx_channel.tasklet, usbatm_rx_process);
+	tasklet_setup(&instance->tx_channel.tasklet, usbatm_tx_process);
 	instance->rx_channel.stride = ATM_CELL_SIZE + driver->rx_padding;
 	instance->tx_channel.stride = ATM_CELL_SIZE + driver->tx_padding;
 	instance->rx_channel.usbatm = instance->tx_channel.usbatm = instance;
diff --git a/drivers/usb/c67x00/c67x00-sched.c b/drivers/usb/c67x00/c67x00-sched.c
index 633c52de3bb3..9bd194ba4965 100644
--- a/drivers/usb/c67x00/c67x00-sched.c
+++ b/drivers/usb/c67x00/c67x00-sched.c
@@ -1122,9 +1122,9 @@ static void c67x00_do_work(struct c67x00_hcd *c67x00)
 
 /* -------------------------------------------------------------------------- */
 
-static void c67x00_sched_tasklet(unsigned long __c67x00)
+static void c67x00_sched_tasklet(struct tasklet_struct *t)
 {
-	struct c67x00_hcd *c67x00 = (struct c67x00_hcd *)__c67x00;
+	struct c67x00_hcd *c67x00 = from_tasklet(c67x00, t, tasklet);
 	c67x00_do_work(c67x00);
 }
 
@@ -1135,8 +1135,7 @@ void c67x00_sched_kick(struct c67x00_hcd *c67x00)
 
 int c67x00_sched_start_scheduler(struct c67x00_hcd *c67x00)
 {
-	tasklet_init(&c67x00->tasklet, c67x00_sched_tasklet,
-		     (unsigned long)c67x00);
+	tasklet_setup(&c67x00->tasklet, c67x00_sched_tasklet);
 	return 0;
 }
 
diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index f225eaa98ff8..f5c9077a8041 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1660,9 +1660,9 @@ static void __usb_hcd_giveback_urb(struct urb *urb)
 	usb_put_urb(urb);
 }
 
-static void usb_giveback_urb_bh(unsigned long param)
+static void usb_giveback_urb_bh(struct tasklet_struct *t)
 {
-	struct giveback_urb_bh *bh = (struct giveback_urb_bh *)param;
+	struct giveback_urb_bh *bh = from_tasklet(bh, t, bh);
 	struct list_head local_list;
 
 	spin_lock_irq(&bh->lock);
@@ -2406,7 +2406,7 @@ static void init_giveback_urb_bh(struct giveback_urb_bh *bh)
 
 	spin_lock_init(&bh->lock);
 	INIT_LIST_HEAD(&bh->head);
-	tasklet_init(&bh->bh, usb_giveback_urb_bh, (unsigned long)bh);
+	tasklet_setup(&bh->bh, usb_giveback_urb_bh);
 }
 
 struct usb_hcd *__usb_create_hcd(const struct hc_driver *driver,
diff --git a/drivers/usb/gadget/function/f_midi.c b/drivers/usb/gadget/function/f_midi.c
index 46af0aa07e2e..85cb15734aa8 100644
--- a/drivers/usb/gadget/function/f_midi.c
+++ b/drivers/usb/gadget/function/f_midi.c
@@ -698,9 +698,9 @@ static void f_midi_transmit(struct f_midi *midi)
 	f_midi_drop_out_substreams(midi);
 }
 
-static void f_midi_in_tasklet(unsigned long data)
+static void f_midi_in_tasklet(struct tasklet_struct *t)
 {
-	struct f_midi *midi = (struct f_midi *) data;
+	struct f_midi *midi = from_tasklet(midi, t, tasklet);
 	f_midi_transmit(midi);
 }
 
@@ -875,7 +875,7 @@ static int f_midi_bind(struct usb_configuration *c, struct usb_function *f)
 	int status, n, jack = 1, i = 0, endpoint_descriptor_index = 0;
 
 	midi->gadget = cdev->gadget;
-	tasklet_init(&midi->tasklet, f_midi_in_tasklet, (unsigned long) midi);
+	tasklet_setup(&midi->tasklet, f_midi_in_tasklet);
 	status = f_midi_register_card(midi);
 	if (status < 0)
 		goto fail_register;
diff --git a/drivers/usb/gadget/udc/fsl_qe_udc.c b/drivers/usb/gadget/udc/fsl_qe_udc.c
index 2707be628298..fa66449b3907 100644
--- a/drivers/usb/gadget/udc/fsl_qe_udc.c
+++ b/drivers/usb/gadget/udc/fsl_qe_udc.c
@@ -923,9 +923,9 @@ static int qe_ep_rxframe_handle(struct qe_ep *ep)
 	return 0;
 }
 
-static void ep_rx_tasklet(unsigned long data)
+static void ep_rx_tasklet(struct tasklet_struct *t)
 {
-	struct qe_udc *udc = (struct qe_udc *)data;
+	struct qe_udc *udc = from_tasklet(udc, t, rx_tasklet);
 	struct qe_ep *ep;
 	struct qe_frame *pframe;
 	struct qe_bd __iomem *bd;
@@ -2553,8 +2553,7 @@ static int qe_udc_probe(struct platform_device *ofdev)
 					DMA_TO_DEVICE);
 	}
 
-	tasklet_init(&udc->rx_tasklet, ep_rx_tasklet,
-			(unsigned long)udc);
+	tasklet_setup(&udc->rx_tasklet, ep_rx_tasklet);
 	/* request irq and disable DR  */
 	udc->usb_irq = irq_of_parse_and_map(np, 0);
 	if (!udc->usb_irq) {
diff --git a/drivers/usb/host/xhci-dbgtty.c b/drivers/usb/host/xhci-dbgtty.c
index be726c791323..49cce47394cf 100644
--- a/drivers/usb/host/xhci-dbgtty.c
+++ b/drivers/usb/host/xhci-dbgtty.c
@@ -328,14 +328,14 @@ void xhci_dbc_tty_unregister_driver(void)
 	}
 }
 
-static void dbc_rx_push(unsigned long _port)
+static void dbc_rx_push(struct tasklet_struct *t)
 {
 	struct dbc_request	*req;
 	struct tty_struct	*tty;
 	unsigned long		flags;
 	bool			do_push = false;
 	bool			disconnect = false;
-	struct dbc_port		*port = (void *)_port;
+	struct dbc_port		*port = from_tasklet(port, t, push);
 	struct list_head	*queue = &port->read_queue;
 
 	spin_lock_irqsave(&port->port_lock, flags);
@@ -422,7 +422,7 @@ xhci_dbc_tty_init_port(struct xhci_hcd *xhci, struct dbc_port *port)
 {
 	tty_port_init(&port->port);
 	spin_lock_init(&port->port_lock);
-	tasklet_init(&port->push, dbc_rx_push, (unsigned long)port);
+	tasklet_setup(&port->push, dbc_rx_push);
 	INIT_LIST_HEAD(&port->read_pool);
 	INIT_LIST_HEAD(&port->read_queue);
 	INIT_LIST_HEAD(&port->write_pool);
diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index 18110225d506..af3bab46cf57 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -282,11 +282,11 @@ static void destroy_urbtracker(struct kref *kref)
  * port callback had to be deferred because the disconnect mutex could not be
  * obtained at the time.
  */
-static void send_deferred_urbs(unsigned long _mos_parport)
+static void send_deferred_urbs(struct tasklet_struct *t)
 {
 	int ret_val;
 	unsigned long flags;
-	struct mos7715_parport *mos_parport = (void *)_mos_parport;
+	struct mos7715_parport *mos_parport = from_tasklet(mos_parport, t, urb_tasklet);
 	struct urbtracker *urbtrack, *tmp;
 	struct list_head *cursor, *next;
 	struct device *dev;
@@ -716,8 +716,7 @@ static int mos7715_parport_init(struct usb_serial *serial)
 	INIT_LIST_HEAD(&mos_parport->deferred_urbs);
 	usb_set_serial_data(serial, mos_parport); /* hijack private pointer */
 	mos_parport->serial = serial;
-	tasklet_init(&mos_parport->urb_tasklet, send_deferred_urbs,
-		     (unsigned long) mos_parport);
+	tasklet_setup(&mos_parport->urb_tasklet, send_deferred_urbs);
 	init_completion(&mos_parport->syncmsg_compl);
 
 	/* cycle parallel port reset bit */
diff --git a/drivers/vme/bridges/vme_fake.c b/drivers/vme/bridges/vme_fake.c
index 3208a4409e44..3a5e705ec0e5 100644
--- a/drivers/vme/bridges/vme_fake.c
+++ b/drivers/vme/bridges/vme_fake.c
@@ -90,13 +90,13 @@ static struct device *vme_root;
 /*
  * Calling VME bus interrupt callback if provided.
  */
-static void fake_VIRQ_tasklet(unsigned long data)
+static void fake_VIRQ_tasklet(struct tasklet_struct *t)
 {
 	struct vme_bridge *fake_bridge;
 	struct fake_driver *bridge;
 
-	fake_bridge = (struct vme_bridge *) data;
-	bridge = fake_bridge->driver_priv;
+	bridge = from_tasklet(bridge, t, int_tasklet);
+	fake_bridge = bridge->parent;
 
 	vme_irq_handler(fake_bridge, bridge->int_level, bridge->int_statid);
 }
@@ -1092,8 +1092,7 @@ static int __init fake_init(void)
 	/* Initialize wait queues & mutual exclusion flags */
 	mutex_init(&fake_device->vme_int);
 	mutex_init(&fake_bridge->irq_mtx);
-	tasklet_init(&fake_device->int_tasklet, fake_VIRQ_tasklet,
-			(unsigned long) fake_bridge);
+	tasklet_setup(&fake_device->int_tasklet, fake_VIRQ_tasklet);
 
 	strcpy(fake_bridge->name, driver_name);
 
diff --git a/net/dccp/timer.c b/net/dccp/timer.c
index c0b3672637c4..80cb7558d04d 100644
--- a/net/dccp/timer.c
+++ b/net/dccp/timer.c
@@ -218,9 +218,10 @@ static void dccp_delack_timer(struct timer_list *t)
  * dccp_write_xmitlet  -  Workhorse for CCID packet dequeueing interface
  * See the comments above %ccid_dequeueing_decision for supported modes.
  */
-static void dccp_write_xmitlet(unsigned long data)
+static void dccp_write_xmitlet(struct tasklet_struct *t)
 {
-	struct sock *sk = (struct sock *)data;
+	struct dccp_sock *dp = from_tasklet(dp, t, dccps_xmitlet);
+	struct sock *sk = &dp->dccps_inet_connection.icsk_inet.sk;
 
 	bh_lock_sock(sk);
 	if (sock_owned_by_user(sk))
@@ -236,14 +237,14 @@ static void dccp_write_xmit_timer(struct timer_list *t)
 	struct dccp_sock *dp = from_timer(dp, t, dccps_xmit_timer);
 	struct sock *sk = &dp->dccps_inet_connection.icsk_inet.sk;
 
-	dccp_write_xmitlet((unsigned long)sk);
+	dccp_write_xmitlet(&dp->dccps_xmitlet);
 }
 
 void dccp_init_xmit_timers(struct sock *sk)
 {
 	struct dccp_sock *dp = dccp_sk(sk);
 
-	tasklet_init(&dp->dccps_xmitlet, dccp_write_xmitlet, (unsigned long)sk);
+	tasklet_setup(&dp->dccps_xmitlet, dccp_write_xmitlet);
 	timer_setup(&dp->dccps_xmit_timer, dccp_write_xmit_timer, 0);
 	inet_csk_init_xmit_timers(sk, &dccp_write_timer, &dccp_delack_timer,
 				  &dccp_keepalive_timer);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index fec6d67bfd14..e8018ff49bf0 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -816,9 +816,9 @@ static void tcp_tsq_handler(struct sock *sk)
  * transferring tsq->head because tcp_wfree() might
  * interrupt us (non NAPI drivers)
  */
-static void tcp_tasklet_func(unsigned long data)
+static void tcp_tasklet_func(struct tasklet_struct *t)
 {
-	struct tsq_tasklet *tsq = (struct tsq_tasklet *)data;
+	struct tsq_tasklet *tsq = from_tasklet(tsq, t, tasklet);
 	LIST_HEAD(list);
 	unsigned long flags;
 	struct list_head *q, *n;
@@ -903,9 +903,7 @@ void __init tcp_tasklet_init(void)
 		struct tsq_tasklet *tsq = &per_cpu(tsq_tasklet, i);
 
 		INIT_LIST_HEAD(&tsq->head);
-		tasklet_init(&tsq->tasklet,
-			     tcp_tasklet_func,
-			     (unsigned long)tsq);
+		tasklet_setup(&tsq->tasklet, tcp_tasklet_func);
 	}
 }
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 05406e9c05b3..fd20d0ead959 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1753,7 +1753,7 @@ static inline bool ieee80211_sdata_running(struct ieee80211_sub_if_data *sdata)
 
 /* tx handling */
 void ieee80211_clear_tx_pending(struct ieee80211_local *local);
-void ieee80211_tx_pending(unsigned long data);
+void ieee80211_tx_pending(struct tasklet_struct *t);
 netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 					 struct net_device *dev);
 netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
@@ -2092,7 +2092,7 @@ void ieee80211_txq_remove_vlan(struct ieee80211_local *local,
 			       struct ieee80211_sub_if_data *sdata);
 void ieee80211_fill_txq_stats(struct cfg80211_txq_stats *txqstats,
 			      struct txq_info *txqi);
-void ieee80211_wake_txqs(unsigned long data);
+void ieee80211_wake_txqs(struct tasklet_struct *t);
 void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 			 u16 transaction, u16 auth_alg, u16 status,
 			 const u8 *extra, size_t extra_len, const u8 *bssid,
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index aba094b4ccfc..8781769223fc 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -213,9 +213,9 @@ u32 ieee80211_reset_erp_info(struct ieee80211_sub_if_data *sdata)
 	       BSS_CHANGED_ERP_SLOT;
 }
 
-static void ieee80211_tasklet_handler(unsigned long data)
+static void ieee80211_tasklet_handler(struct tasklet_struct *t)
 {
-	struct ieee80211_local *local = (struct ieee80211_local *) data;
+	struct ieee80211_local *local = from_tasklet(local, t, tasklet);
 	struct sk_buff *skb;
 
 	while ((skb = skb_dequeue(&local->skb_queue)) ||
@@ -701,16 +701,12 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 		skb_queue_head_init(&local->pending[i]);
 		atomic_set(&local->agg_queue_stop[i], 0);
 	}
-	tasklet_init(&local->tx_pending_tasklet, ieee80211_tx_pending,
-		     (unsigned long)local);
+	tasklet_setup(&local->tx_pending_tasklet, ieee80211_tx_pending);
 
 	if (ops->wake_tx_queue)
-		tasklet_init(&local->wake_txqs_tasklet, ieee80211_wake_txqs,
-			     (unsigned long)local);
+		tasklet_setup(&local->wake_txqs_tasklet, ieee80211_wake_txqs);
 
-	tasklet_init(&local->tasklet,
-		     ieee80211_tasklet_handler,
-		     (unsigned long) local);
+	tasklet_setup(&local->tasklet, ieee80211_tasklet_handler);
 
 	skb_queue_head_init(&local->skb_queue);
 	skb_queue_head_init(&local->skb_queue_unreliable);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 1fa422782905..1705e3b08f15 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4125,9 +4125,9 @@ static bool ieee80211_tx_pending_skb(struct ieee80211_local *local,
 /*
  * Transmit all pending packets. Called from tasklet.
  */
-void ieee80211_tx_pending(unsigned long data)
+void ieee80211_tx_pending(struct tasklet_struct *t)
 {
-	struct ieee80211_local *local = (struct ieee80211_local *)data;
+	struct ieee80211_local *local = from_tasklet(local, t, tx_pending_tasklet);
 	unsigned long flags;
 	int i;
 	bool txok;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 051a02ddcb85..8a558ed04859 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -332,9 +332,9 @@ _ieee80211_wake_txqs(struct ieee80211_local *local, unsigned long *flags)
 	rcu_read_unlock();
 }
 
-void ieee80211_wake_txqs(unsigned long data)
+void ieee80211_wake_txqs(struct tasklet_struct *t)
 {
-	struct ieee80211_local *local = (struct ieee80211_local *)data;
+	struct ieee80211_local *local = from_tasklet(local, t, wake_txqs_tasklet);
 	unsigned long flags;
 
 	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
diff --git a/net/mac802154/main.c b/net/mac802154/main.c
index 06ea0f8bfd5c..520cedc594e1 100644
--- a/net/mac802154/main.c
+++ b/net/mac802154/main.c
@@ -20,9 +20,9 @@
 #include "ieee802154_i.h"
 #include "cfg.h"
 
-static void ieee802154_tasklet_handler(unsigned long data)
+static void ieee802154_tasklet_handler(struct tasklet_struct *t)
 {
-	struct ieee802154_local *local = (struct ieee802154_local *)data;
+	struct ieee802154_local *local = from_tasklet(local, t, tasklet);
 	struct sk_buff *skb;
 
 	while ((skb = skb_dequeue(&local->skb_queue))) {
@@ -91,9 +91,7 @@ ieee802154_alloc_hw(size_t priv_data_len, const struct ieee802154_ops *ops)
 	INIT_LIST_HEAD(&local->interfaces);
 	mutex_init(&local->iflist_mtx);
 
-	tasklet_init(&local->tasklet,
-		     ieee802154_tasklet_handler,
-		     (unsigned long)local);
+	tasklet_setup(&local->tasklet, ieee802154_tasklet_handler);
 
 	skb_queue_head_init(&local->skb_queue);
 
diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index 233f1368162b..aa67a0c2c24a 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -312,9 +312,9 @@ static void poll_scq(struct rds_ib_connection *ic, struct ib_cq *cq,
 	}
 }
 
-static void rds_ib_tasklet_fn_send(unsigned long data)
+static void rds_ib_tasklet_fn_send(struct tasklet_struct *t)
 {
-	struct rds_ib_connection *ic = (struct rds_ib_connection *)data;
+	struct rds_ib_connection *ic = from_tasklet(ic, t, i_send_tasklet);
 	struct rds_connection *conn = ic->conn;
 
 	rds_ib_stats_inc(s_ib_tasklet_call);
@@ -352,9 +352,9 @@ static void poll_rcq(struct rds_ib_connection *ic, struct ib_cq *cq,
 	}
 }
 
-static void rds_ib_tasklet_fn_recv(unsigned long data)
+static void rds_ib_tasklet_fn_recv(struct tasklet_struct *t)
 {
-	struct rds_ib_connection *ic = (struct rds_ib_connection *)data;
+	struct rds_ib_connection *ic = from_tasklet(ic, t, i_recv_tasklet);
 	struct rds_connection *conn = ic->conn;
 	struct rds_ib_device *rds_ibdev = ic->rds_ibdev;
 	struct rds_ib_ack_state state;
@@ -1132,10 +1132,8 @@ int rds_ib_conn_alloc(struct rds_connection *conn, gfp_t gfp)
 	}
 
 	INIT_LIST_HEAD(&ic->ib_node);
-	tasklet_init(&ic->i_send_tasklet, rds_ib_tasklet_fn_send,
-		     (unsigned long)ic);
-	tasklet_init(&ic->i_recv_tasklet, rds_ib_tasklet_fn_recv,
-		     (unsigned long)ic);
+	tasklet_setup(&ic->i_send_tasklet, rds_ib_tasklet_fn_send);
+	tasklet_setup(&ic->i_recv_tasklet, rds_ib_tasklet_fn_recv);
 	mutex_init(&ic->i_recv_mutex);
 #ifndef KERNEL_HAS_ATOMIC64
 	spin_lock_init(&ic->i_ack_lock);
diff --git a/net/sched/sch_atm.c b/net/sched/sch_atm.c
index f4f9b8cdbffb..4ddca34e4297 100644
--- a/net/sched/sch_atm.c
+++ b/net/sched/sch_atm.c
@@ -466,10 +466,10 @@ drop: __maybe_unused
  * non-ATM interfaces.
  */
 
-static void sch_atm_dequeue(unsigned long data)
+static void sch_atm_dequeue(struct tasklet_struct *t)
 {
-	struct Qdisc *sch = (struct Qdisc *)data;
-	struct atm_qdisc_data *p = qdisc_priv(sch);
+	struct atm_qdisc_data *p = from_tasklet(p, t, task);
+	struct Qdisc *sch = (struct Qdisc *)((char *) p - QDISC_ALIGN(sizeof(struct Qdisc)));
 	struct atm_flow_data *flow;
 	struct sk_buff *skb;
 
@@ -563,7 +563,7 @@ static int atm_tc_init(struct Qdisc *sch, struct nlattr *opt,
 	p->link.sock = NULL;
 	p->link.common.classid = sch->handle;
 	p->link.ref = 1;
-	tasklet_init(&p->task, sch_atm_dequeue, (unsigned long)sch);
+	tasklet_setup(&p->task, sch_atm_dequeue);
 	return 0;
 }
 
diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index d0b0f4c865b4..390b87132c5a 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -321,9 +321,9 @@ static void smc_cdc_msg_recv(struct smc_sock *smc, struct smc_cdc_msg *cdc)
  * Context:
  * - tasklet context
  */
-static void smcd_cdc_rx_tsklet(unsigned long data)
+static void smcd_cdc_rx_tsklet(struct tasklet_struct *t)
 {
-	struct smc_connection *conn = (struct smc_connection *)data;
+	struct smc_connection *conn = from_tasklet(conn, t, rx_tsklet);
 	struct smcd_cdc_msg *data_cdc;
 	struct smcd_cdc_msg cdc;
 	struct smc_sock *smc;
@@ -343,7 +343,7 @@ static void smcd_cdc_rx_tsklet(unsigned long data)
  */
 void smcd_cdc_rx_init(struct smc_connection *conn)
 {
-	tasklet_init(&conn->rx_tsklet, smcd_cdc_rx_tsklet, (unsigned long)conn);
+	tasklet_setup(&conn->rx_tsklet, smcd_cdc_rx_tsklet);
 }
 
 /***************************** init, exit, misc ******************************/
diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
index 253aa75dc2b6..30004026038f 100644
--- a/net/smc/smc_wr.c
+++ b/net/smc/smc_wr.c
@@ -108,9 +108,9 @@ static inline void smc_wr_tx_process_cqe(struct ib_wc *wc)
 	wake_up(&link->wr_tx_wait);
 }
 
-static void smc_wr_tx_tasklet_fn(unsigned long data)
+static void smc_wr_tx_tasklet_fn(struct tasklet_struct *t)
 {
-	struct smc_ib_device *dev = (struct smc_ib_device *)data;
+	struct smc_ib_device *dev = from_tasklet(dev, t, send_tasklet);
 	struct ib_wc wc[SMC_WR_MAX_POLL_CQE];
 	int i = 0, rc;
 	int polled = 0;
@@ -383,9 +383,9 @@ static inline void smc_wr_rx_process_cqes(struct ib_wc wc[], int num)
 	}
 }
 
-static void smc_wr_rx_tasklet_fn(unsigned long data)
+static void smc_wr_rx_tasklet_fn(struct tasklet_struct *t)
 {
-	struct smc_ib_device *dev = (struct smc_ib_device *)data;
+	struct smc_ib_device *dev = from_tasklet(dev, t, recv_tasklet);
 	struct ib_wc wc[SMC_WR_MAX_POLL_CQE];
 	int polled = 0;
 	int rc;
@@ -635,10 +635,8 @@ void smc_wr_remove_dev(struct smc_ib_device *smcibdev)
 
 void smc_wr_add_dev(struct smc_ib_device *smcibdev)
 {
-	tasklet_init(&smcibdev->recv_tasklet, smc_wr_rx_tasklet_fn,
-		     (unsigned long)smcibdev);
-	tasklet_init(&smcibdev->send_tasklet, smc_wr_tx_tasklet_fn,
-		     (unsigned long)smcibdev);
+	tasklet_setup(&smcibdev->recv_tasklet, smc_wr_rx_tasklet_fn);
+	tasklet_setup(&smcibdev->send_tasklet, smc_wr_tx_tasklet_fn);
 }
 
 int smc_wr_create_link(struct smc_link *lnk)
diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 6088bc2dc11e..5d43fc6783f1 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -753,9 +753,9 @@ int xfrm_input_resume(struct sk_buff *skb, int nexthdr)
 }
 EXPORT_SYMBOL(xfrm_input_resume);
 
-static void xfrm_trans_reinject(unsigned long data)
+static void xfrm_trans_reinject(struct tasklet_struct *t)
 {
-	struct xfrm_trans_tasklet *trans = (void *)data;
+	struct xfrm_trans_tasklet *trans = from_tasklet(trans, t, tasklet);
 	struct sk_buff_head queue;
 	struct sk_buff *skb;
 
@@ -799,7 +799,6 @@ void __init xfrm_input_init(void)
 
 		trans = &per_cpu(xfrm_trans_tasklet, i);
 		__skb_queue_head_init(&trans->queue);
-		tasklet_init(&trans->tasklet, xfrm_trans_reinject,
-			     (unsigned long)trans);
+		tasklet_setup(&trans->tasklet, xfrm_trans_reinject);
 	}
 }
diff --git a/sound/core/timer.c b/sound/core/timer.c
index 5c9fbf3f4340..ac93bcf838dc 100644
--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -767,9 +767,9 @@ static void snd_timer_clear_callbacks(struct snd_timer *timer,
  * timer tasklet
  *
  */
-static void snd_timer_tasklet(unsigned long arg)
+static void snd_timer_tasklet(struct tasklet_struct *t)
 {
-	struct snd_timer *timer = (struct snd_timer *) arg;
+	struct snd_timer *timer = from_tasklet(timer, t, task_queue);
 	unsigned long flags;
 
 	if (timer->card && timer->card->shutdown) {
@@ -918,8 +918,7 @@ int snd_timer_new(struct snd_card *card, char *id, struct snd_timer_id *tid,
 	INIT_LIST_HEAD(&timer->ack_list_head);
 	INIT_LIST_HEAD(&timer->sack_list_head);
 	spin_lock_init(&timer->lock);
-	tasklet_init(&timer->task_queue, snd_timer_tasklet,
-		     (unsigned long)timer);
+	tasklet_setup(&timer->task_queue, snd_timer_tasklet);
 	timer->max_instances = 1000; /* default limit per timer */
 	if (card != NULL) {
 		timer->module = card->module;
diff --git a/sound/firewire/amdtp-stream.c b/sound/firewire/amdtp-stream.c
index e50e28f77e74..af76a712d024 100644
--- a/sound/firewire/amdtp-stream.c
+++ b/sound/firewire/amdtp-stream.c
@@ -65,7 +65,7 @@
 #define IT_PKT_HEADER_SIZE_CIP		8 // For 2 CIP header.
 #define IT_PKT_HEADER_SIZE_NO_CIP	0 // Nothing.
 
-static void pcm_period_tasklet(unsigned long data);
+static void pcm_period_tasklet(struct tasklet_struct *t);
 
 /**
  * amdtp_stream_init - initialize an AMDTP stream structure
@@ -95,7 +95,7 @@ int amdtp_stream_init(struct amdtp_stream *s, struct fw_unit *unit,
 	s->flags = flags;
 	s->context = ERR_PTR(-1);
 	mutex_init(&s->mutex);
-	tasklet_init(&s->period_tasklet, pcm_period_tasklet, (unsigned long)s);
+	tasklet_setup(&s->period_tasklet, pcm_period_tasklet);
 	s->packet_index = 0;
 
 	init_waitqueue_head(&s->callback_wait);
@@ -427,9 +427,9 @@ static void update_pcm_pointers(struct amdtp_stream *s,
 	}
 }
 
-static void pcm_period_tasklet(unsigned long data)
+static void pcm_period_tasklet(struct tasklet_struct *t)
 {
-	struct amdtp_stream *s = (void *)data;
+	struct amdtp_stream *s = from_tasklet(s, t, period_tasklet);
 	struct snd_pcm_substream *pcm = READ_ONCE(s->pcm);
 
 	if (pcm)
diff --git a/sound/pci/asihpi/asihpi.c b/sound/pci/asihpi/asihpi.c
index 2a21a3d99719..58141942f2ef 100644
--- a/sound/pci/asihpi/asihpi.c
+++ b/sound/pci/asihpi/asihpi.c
@@ -925,10 +925,10 @@ static void snd_card_asihpi_timer_function(struct timer_list *t)
 		add_timer(&dpcm->timer);
 }
 
-static void snd_card_asihpi_int_task(unsigned long data)
+static void snd_card_asihpi_int_task(struct tasklet_struct *t)
 {
-	struct hpi_adapter *a = (struct hpi_adapter *)data;
-	struct snd_card_asihpi *asihpi;
+	struct snd_card_asihpi *asihpi = from_tasklet(asihpi, t, t);
+	struct hpi_adapter *a = asihpi->hpi;
 
 	WARN_ON(!a || !a->snd_card || !a->snd_card->private_data);
 	asihpi = (struct snd_card_asihpi *)a->snd_card->private_data;
@@ -2894,8 +2894,7 @@ static int snd_asihpi_probe(struct pci_dev *pci_dev,
 	if (hpi->interrupt_mode) {
 		asihpi->pcm_start = snd_card_asihpi_pcm_int_start;
 		asihpi->pcm_stop = snd_card_asihpi_pcm_int_stop;
-		tasklet_init(&asihpi->t, snd_card_asihpi_int_task,
-			(unsigned long)hpi);
+		tasklet_setup(&asihpi->t, snd_card_asihpi_int_task);
 		hpi->interrupt_callback = snd_card_asihpi_isr;
 	} else {
 		asihpi->pcm_start = snd_card_asihpi_pcm_timer_start;
diff --git a/sound/pci/riptide/riptide.c b/sound/pci/riptide/riptide.c
index 58771ae0ed63..55493d00ba3c 100644
--- a/sound/pci/riptide/riptide.c
+++ b/sound/pci/riptide/riptide.c
@@ -1070,9 +1070,9 @@ getmixer(struct cmdif *cif, short num, unsigned short *rval,
 	return 0;
 }
 
-static void riptide_handleirq(unsigned long dev_id)
+static void riptide_handleirq(struct tasklet_struct *t)
 {
-	struct snd_riptide *chip = (void *)dev_id;
+	struct snd_riptide *chip = from_tasklet(chip, t, riptide_tq);
 	struct cmdif *cif = chip->cif;
 	struct snd_pcm_substream *substream[PLAYBACK_SUBSTREAMS + 1];
 	struct snd_pcm_runtime *runtime;
@@ -1849,7 +1849,7 @@ snd_riptide_create(struct snd_card *card, struct pci_dev *pci,
 	chip->received_irqs = 0;
 	chip->handled_irqs = 0;
 	chip->cif = NULL;
-	tasklet_init(&chip->riptide_tq, riptide_handleirq, (unsigned long)chip);
+	tasklet_setup(&chip->riptide_tq, riptide_handleirq);
 
 	if ((chip->res_port =
 	     request_region(chip->port, 64, "RIPTIDE")) == NULL) {
diff --git a/sound/pci/rme9652/hdsp.c b/sound/pci/rme9652/hdsp.c
index 5cbdc9be9c7e..c41154d3c339 100644
--- a/sound/pci/rme9652/hdsp.c
+++ b/sound/pci/rme9652/hdsp.c
@@ -3795,9 +3795,9 @@ static int snd_hdsp_set_defaults(struct hdsp *hdsp)
 	return 0;
 }
 
-static void hdsp_midi_tasklet(unsigned long arg)
+static void hdsp_midi_tasklet(struct tasklet_struct *t)
 {
-	struct hdsp *hdsp = (struct hdsp *)arg;
+	struct hdsp *hdsp = from_tasklet(hdsp, t, midi_tasklet);
 
 	if (hdsp->midi[0].pending)
 		snd_hdsp_midi_input_read (&hdsp->midi[0]);
@@ -5187,7 +5187,7 @@ static int snd_hdsp_create(struct snd_card *card,
 
 	spin_lock_init(&hdsp->lock);
 
-	tasklet_init(&hdsp->midi_tasklet, hdsp_midi_tasklet, (unsigned long)hdsp);
+	tasklet_setup(&hdsp->midi_tasklet, hdsp_midi_tasklet);
 
 	pci_read_config_word(hdsp->pci, PCI_CLASS_REVISION, &hdsp->firmware_rev);
 	hdsp->firmware_rev &= 0xff;
diff --git a/sound/pci/rme9652/hdspm.c b/sound/pci/rme9652/hdspm.c
index 81a6f4b2bd3c..ccc3c8eafd82 100644
--- a/sound/pci/rme9652/hdspm.c
+++ b/sound/pci/rme9652/hdspm.c
@@ -2165,9 +2165,9 @@ static int snd_hdspm_create_midi(struct snd_card *card,
 }
 
 
-static void hdspm_midi_tasklet(unsigned long arg)
+static void hdspm_midi_tasklet(struct tasklet_struct *t)
 {
-	struct hdspm *hdspm = (struct hdspm *)arg;
+	struct hdspm *hdspm = from_tasklet(hdspm, t, midi_tasklet);
 	int i = 0;
 
 	while (i < hdspm->midiPorts) {
@@ -6832,8 +6832,7 @@ static int snd_hdspm_create(struct snd_card *card,
 
 	}
 
-	tasklet_init(&hdspm->midi_tasklet,
-			hdspm_midi_tasklet, (unsigned long) hdspm);
+	tasklet_setup(&hdspm->midi_tasklet, hdspm_midi_tasklet);
 
 
 	if (hdspm->io_type != MADIface) {
diff --git a/sound/soc/fsl/fsl_esai.c b/sound/soc/fsl/fsl_esai.c
index a78e4ab478df..2d65d36061e9 100644
--- a/sound/soc/fsl/fsl_esai.c
+++ b/sound/soc/fsl/fsl_esai.c
@@ -672,9 +672,9 @@ static void fsl_esai_trigger_stop(struct fsl_esai *esai_priv, bool tx)
 			   ESAI_xFCR_xFR, 0);
 }
 
-static void fsl_esai_hw_reset(unsigned long arg)
+static void fsl_esai_hw_reset(struct tasklet_struct *t)
 {
-	struct fsl_esai *esai_priv = (struct fsl_esai *)arg;
+	struct fsl_esai *esai_priv = from_tasklet(esai_priv, t, task);
 	bool tx = true, rx = false, enabled[2];
 	u32 tfcr, rfcr;
 
@@ -1022,8 +1022,7 @@ static int fsl_esai_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	tasklet_init(&esai_priv->task, fsl_esai_hw_reset,
-		     (unsigned long)esai_priv);
+	tasklet_setup(&esai_priv->task, fsl_esai_hw_reset);
 
 	pm_runtime_enable(&pdev->dev);
 
diff --git a/sound/soc/sh/siu_pcm.c b/sound/soc/sh/siu_pcm.c
index 78c3145b4109..e777cb7d6d2f 100644
--- a/sound/soc/sh/siu_pcm.c
+++ b/sound/soc/sh/siu_pcm.c
@@ -198,9 +198,9 @@ static int siu_pcm_rd_set(struct siu_port *port_info,
 	return 0;
 }
 
-static void siu_io_tasklet(unsigned long data)
+static void siu_io_tasklet(struct tasklet_struct *t)
 {
-	struct siu_stream *siu_stream = (struct siu_stream *)data;
+	struct siu_stream *siu_stream = from_tasklet(siu_stream, t, tasklet);
 	struct snd_pcm_substream *substream = siu_stream->substream;
 	struct device *dev = substream->pcm->card->dev;
 	struct snd_pcm_runtime *rt = substream->runtime;
@@ -548,10 +548,8 @@ static int siu_pcm_new(struct snd_soc_pcm_runtime *rtd)
 		(*port_info)->pcm = pcm;
 
 		/* IO tasklets */
-		tasklet_init(&(*port_info)->playback.tasklet, siu_io_tasklet,
-			     (unsigned long)&(*port_info)->playback);
-		tasklet_init(&(*port_info)->capture.tasklet, siu_io_tasklet,
-			     (unsigned long)&(*port_info)->capture);
+		tasklet_setup(&(*port_info)->playback.tasklet, siu_io_tasklet);
+		tasklet_setup(&(*port_info)->capture.tasklet, siu_io_tasklet);
 	}
 
 	dev_info(card->dev, "SuperH SIU driver initialized.\n");
diff --git a/sound/soc/txx9/txx9aclc.c b/sound/soc/txx9/txx9aclc.c
index 66044559f70f..dbdeae9d4519 100644
--- a/sound/soc/txx9/txx9aclc.c
+++ b/sound/soc/txx9/txx9aclc.c
@@ -144,9 +144,9 @@ txx9aclc_dma_submit(struct txx9aclc_dmadata *dmadata, dma_addr_t buf_dma_addr)
 
 #define NR_DMA_CHAIN		2
 
-static void txx9aclc_dma_tasklet(unsigned long data)
+static void txx9aclc_dma_tasklet(struct tasklet_struct *t)
 {
-	struct txx9aclc_dmadata *dmadata = (struct txx9aclc_dmadata *)data;
+	struct txx9aclc_dmadata *dmadata = from_tasklet(dmadata, t, tasklet);
 	struct dma_chan *chan = dmadata->dma_chan;
 	struct dma_async_tx_descriptor *desc;
 	struct snd_pcm_substream *substream = dmadata->substream;
@@ -369,8 +369,7 @@ static int txx9aclc_dma_init(struct txx9aclc_soc_device *dev,
 			"playback" : "capture");
 		return -EBUSY;
 	}
-	tasklet_init(&dmadata->tasklet, txx9aclc_dma_tasklet,
-		     (unsigned long)dmadata);
+	tasklet_setup(&dmadata->tasklet, txx9aclc_dma_tasklet);
 	return 0;
 }
 
diff --git a/sound/usb/midi.c b/sound/usb/midi.c
index b737f0ec77d0..6861c362d756 100644
--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -344,10 +344,9 @@ static void snd_usbmidi_do_output(struct snd_usb_midi_out_endpoint *ep)
 	spin_unlock_irqrestore(&ep->buffer_lock, flags);
 }
 
-static void snd_usbmidi_out_tasklet(unsigned long data)
+static void snd_usbmidi_out_tasklet(struct tasklet_struct *t)
 {
-	struct snd_usb_midi_out_endpoint *ep =
-		(struct snd_usb_midi_out_endpoint *) data;
+	struct snd_usb_midi_out_endpoint *ep = from_tasklet(ep, t, tasklet);
 
 	snd_usbmidi_do_output(ep);
 }
@@ -1441,7 +1440,7 @@ static int snd_usbmidi_out_endpoint_create(struct snd_usb_midi *umidi,
 	}
 
 	spin_lock_init(&ep->buffer_lock);
-	tasklet_init(&ep->tasklet, snd_usbmidi_out_tasklet, (unsigned long)ep);
+	tasklet_setup(&ep->tasklet, snd_usbmidi_out_tasklet);
 	init_waitqueue_head(&ep->drain_wait);
 
 	for (i = 0; i < 0x10; ++i)
diff --git a/sound/usb/misc/ua101.c b/sound/usb/misc/ua101.c
index 307b72d5fffa..70b0fef7cf08 100644
--- a/sound/usb/misc/ua101.c
+++ b/sound/usb/misc/ua101.c
@@ -247,9 +247,9 @@ static inline void add_with_wraparound(struct ua101 *ua,
 		*value -= ua->playback.queue_length;
 }
 
-static void playback_tasklet(unsigned long data)
+static void playback_tasklet(struct tasklet_struct *t)
 {
-	struct ua101 *ua = (void *)data;
+	struct ua101 *ua = from_tasklet(ua, t, playback_tasklet);
 	unsigned long flags;
 	unsigned int frames;
 	struct ua101_urb *urb;
@@ -1237,8 +1237,7 @@ static int ua101_probe(struct usb_interface *interface,
 	spin_lock_init(&ua->lock);
 	mutex_init(&ua->mutex);
 	INIT_LIST_HEAD(&ua->ready_playback_urbs);
-	tasklet_init(&ua->playback_tasklet,
-		     playback_tasklet, (unsigned long)ua);
+	tasklet_setup(&ua->playback_tasklet, playback_tasklet);
 	init_waitqueue_head(&ua->alsa_capture_wait);
 	init_waitqueue_head(&ua->rate_feedback_wait);
 	init_waitqueue_head(&ua->alsa_playback_wait);
-- 
2.23.0

