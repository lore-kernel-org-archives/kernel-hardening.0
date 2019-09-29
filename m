Return-Path: <SRS0=ilKA=XY=lists.openwall.com=kernel-hardening-return-16950-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95540C4360C
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Sep 2019 16:31:03 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4FA0621835
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Sep 2019 16:31:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AfYIgm0M"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4FA0621835
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16950-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20419 invoked by uid 550); 29 Sep 2019 16:30:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20387 invoked from network); 29 Sep 2019 16:30:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JbC/1IL+gULBBi0DXYg3ZRueOmyj/tSt0ayeIwRL7ck=;
        b=AfYIgm0M+hyayE8QMrfP4ZVivocnm0Ht/mfWQcOuRiqsztoiLQz82c7opXO43sXNya
         pEkToH62Jb0wLUlCGrY7Wt/mS18j+N00T5K5f+ieU3HIvnTYl5qTJGOIiU6SVkpWaHu7
         tpX7dySwNQil7C/vh1L9HPoCXf5n/yxmicZkTstg4+YVsc87P+2Rc8oILFnTkYN3PibM
         Dlqv4by4PPLeToQrxT49OjByXPdNit9L54aEsgVXy629NgNzHcgzZ+vm+J3KXzbPw21y
         Kh5z/Ug30nvS4/CrCvhqd7R0MGPB5wZYul1TM/sbc0LKaqLkDSiAcI+PZxkPvI6GLb9L
         Yxpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JbC/1IL+gULBBi0DXYg3ZRueOmyj/tSt0ayeIwRL7ck=;
        b=ugUcSDx4LqFPshx9BYeLeaJ1SfrCvgMc66tRILVCChdnJJmSwO8zdVNmxiGsXw5+Ea
         m6x+MW3xyPU45HNSwfIILzhxSQpuet1QdZ3vHACbnjmIiJblYi7Mwjf4AbSQ1/GD27ZG
         8AZRDQxaMak0j1ukAPBHu4MZh6jJr+xrPPE10mXQoPANMSsmijUgwBE45wcyEnmUITtB
         rA0VJfTbPMnWEvOZTAg/gp3aqecUCXfV3DM/rLkNHJiaOidYZV7QVfbu/X9VDKdoGsVV
         HMYHamCS7D04jRQ4IDs2lYUeEEr1JTQlfvq1GjT8/LEsgzjwEJnb0TiNIpXIl5K4b4/a
         GlMg==
X-Gm-Message-State: APjAAAWrlN47VdrQoq1ddcF/kp4ESaL3YiZLEADBjxhbBubydWLQXUmk
	4cvc1YZzhuO6TwfQwhGFppM=
X-Google-Smtp-Source: APXvYqyA7ITKIl+LMl4UYGxb8PBW+0XJBIfK411Fdk9+KCMnXLVufqSJfWhUUi+/QPfi05gMkcmlgg==
X-Received: by 2002:a7b:cb91:: with SMTP id m17mr14187911wmi.151.1569774638691;
        Sun, 29 Sep 2019 09:30:38 -0700 (PDT)
From: Romain Perier <romain.perier@gmail.com>
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>,
	Romain Perier <romain.perier@gmail.com>
Subject: [PRE-REVIEW PATCH 00/16] Modernize the tasklet API
Date: Sun, 29 Sep 2019 18:30:12 +0200
Message-Id: <20190929163028.9665-1-romain.perier@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

Nowadays, modern kernel subsystems that use callbacks pass the data
structure associated with a given callback as argument to the callback.
The data structure specific to the driver or subsystem that uses this
callback framework is usually "derivated" from the data structure that
is passed as argument to the callback.

The tasklet subsystem remains the one to pass callback argument as an
arbitrary unsigned long argument (This has several issues that are
explained in the first commit).

This series aims to improve the tasklet API and converts all the code
that is using it. It is based on the series for timer_list at [1].

1. https://lore.kernel.org/patchwork/patch/835464


Romain Perier (16):
  tasklet: Prepare to change tasklet callback argument type
  crypto: ccp - Prepare to use the new tasklet API
  mmc: renesas_sdhi: Prepare to use the new tasklet API
  net: liquidio: Prepare to use the new tasklet API
  chelsio: Prepare to use the new tasklet API
  net: mvpp2: Prepare to use the new tasklet API
  qed: Prepare to use the new tasklet API
  isdn: Prepare to use the new tasklet API
  scsi: pm8001: Prepare to use the new tasklet API
  scsi: pmcraid: Prepare to use the new tasklet API
  treewide: Globally replace tasklet_init() by tasklet_setup()
  tasklet: Pass tasklet_struct pointer as .data in DECLARE_TASKLET
  tasklet: Pass tasklet_struct pointer to callbacks unconditionally
  tasklet: Remove the data argument from DECLARE_TASKLET() macros
  tasklet: convert callbacks prototype for using struct tasklet_struct *
    arguments
  tasklet: Add the new initialization function permanently

 arch/mips/lasat/picvue_proc.c                 |  2 +-
 arch/um/drivers/vector_kern.c                 |  6 +-
 drivers/atm/eni.c                             |  8 +--
 drivers/atm/fore200e.c                        | 14 ++---
 drivers/atm/he.c                              |  8 +--
 drivers/atm/solos-pci.c                       |  8 +--
 drivers/block/umem.c                          |  6 +-
 drivers/block/xsysace.c                       |  6 +-
 drivers/char/ipmi/ipmi_msghandler.c           | 12 ++--
 drivers/crypto/amcc/crypto4xx_core.c          |  7 +--
 drivers/crypto/atmel-aes.c                    | 14 ++---
 drivers/crypto/atmel-sha.c                    | 14 ++---
 drivers/crypto/atmel-tdes.c                   | 14 ++---
 drivers/crypto/axis/artpec6_crypto.c          |  7 +--
 drivers/crypto/caam/jr.c                      |  8 +--
 drivers/crypto/cavium/cpt/cptvf_main.c        |  9 ++-
 drivers/crypto/cavium/nitrox/nitrox_common.h  |  2 +-
 drivers/crypto/cavium/nitrox/nitrox_isr.c     | 13 ++---
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c  |  4 +-
 drivers/crypto/ccp/ccp-dev-v3.c               |  9 ++-
 drivers/crypto/ccp/ccp-dev-v5.c               |  9 ++-
 drivers/crypto/ccp/ccp-dev.c                  | 10 ++--
 drivers/crypto/ccp/ccp-dmaengine.c            |  7 +--
 drivers/crypto/ccree/cc_fips.c                |  8 +--
 drivers/crypto/ccree/cc_request_mgr.c         | 12 ++--
 drivers/crypto/hifn_795x.c                    |  6 +-
 drivers/crypto/img-hash.c                     | 12 ++--
 drivers/crypto/ixp4xx_crypto.c                |  5 +-
 drivers/crypto/mediatek/mtk-aes.c             | 14 ++---
 drivers/crypto/mediatek/mtk-sha.c             | 14 ++---
 drivers/crypto/omap-aes.c                     |  6 +-
 drivers/crypto/omap-des.c                     |  6 +-
 drivers/crypto/omap-sham.c                    |  6 +-
 drivers/crypto/picoxcell_crypto.c             |  7 +--
 drivers/crypto/qat/qat_common/adf_isr.c       |  5 +-
 drivers/crypto/qat/qat_common/adf_sriov.c     |  8 +--
 drivers/crypto/qat/qat_common/adf_transport.c |  4 +-
 .../qat/qat_common/adf_transport_internal.h   |  2 +-
 drivers/crypto/qat/qat_common/adf_vf_isr.c    | 11 ++--
 drivers/crypto/qce/core.c                     |  7 +--
 drivers/crypto/rockchip/rk3288_crypto.c       | 14 ++---
 drivers/crypto/s5p-sss.c                      | 13 ++---
 drivers/crypto/talitos.c                      | 42 +++++++-------
 drivers/dma/altera-msgdma.c                   |  6 +-
 drivers/dma/at_hdmac.c                        |  7 +--
 drivers/dma/at_xdmac.c                        |  7 +--
 drivers/dma/coh901318.c                       |  7 +--
 drivers/dma/dw/core.c                         |  6 +-
 drivers/dma/ep93xx_dma.c                      |  7 +--
 drivers/dma/fsl_raid.c                        |  8 +--
 drivers/dma/fsldma.c                          |  6 +-
 drivers/dma/imx-dma.c                         |  7 +--
 drivers/dma/ioat/dma.c                        |  6 +-
 drivers/dma/ioat/dma.h                        |  2 +-
 drivers/dma/ioat/init.c                       |  2 +-
 drivers/dma/iop-adma.c                        |  8 +--
 drivers/dma/ipu/ipu_idmac.c                   |  6 +-
 drivers/dma/k3dma.c                           |  6 +-
 drivers/dma/mediatek/mtk-cqdma.c              |  7 +--
 drivers/dma/mmp_pdma.c                        |  6 +-
 drivers/dma/mmp_tdma.c                        |  6 +-
 drivers/dma/mpc512x_dma.c                     |  6 +-
 drivers/dma/mv_xor.c                          |  7 +--
 drivers/dma/mv_xor_v2.c                       |  8 +--
 drivers/dma/mxs-dma.c                         |  7 +--
 drivers/dma/nbpfaxi.c                         |  6 +-
 drivers/dma/pch_dma.c                         |  7 +--
 drivers/dma/pl330.c                           | 12 ++--
 drivers/dma/ppc4xx/adma.c                     |  7 +--
 drivers/dma/qcom/bam_dma.c                    |  6 +-
 drivers/dma/qcom/hidma.c                      |  6 +-
 drivers/dma/qcom/hidma_ll.c                   |  6 +-
 drivers/dma/sa11x0-dma.c                      |  6 +-
 drivers/dma/sirf-dma.c                        |  6 +-
 drivers/dma/ste_dma40.c                       |  7 +--
 drivers/dma/sun6i-dma.c                       |  6 +-
 drivers/dma/tegra20-apb-dma.c                 |  7 +--
 drivers/dma/timb_dma.c                        |  6 +-
 drivers/dma/txx9dmac.c                        | 14 ++---
 drivers/dma/virt-dma.c                        |  6 +-
 drivers/dma/xgene-dma.c                       |  7 +--
 drivers/dma/xilinx/xilinx_dma.c               |  7 +--
 drivers/dma/xilinx/zynqmp_dma.c               |  6 +-
 drivers/firewire/ohci.c                       | 16 +++---
 drivers/gpu/drm/i915/gt/intel_engine_cs.c     |  2 +-
 drivers/gpu/drm/i915/gt/intel_lrc.c           | 28 +++++-----
 .../gpu/drm/i915/gt/uc/intel_guc_submission.c |  7 ++-
 drivers/hsi/clients/nokia-modem.c             |  9 +--
 drivers/hsi/controllers/omap_ssi_core.c       |  9 ++-
 drivers/hv/channel_mgmt.c                     |  3 +-
 drivers/hv/connection.c                       |  4 +-
 drivers/hv/hv.c                               |  3 +-
 drivers/hv/hyperv_vmbus.h                     |  4 +-
 drivers/hv/vmbus_drv.c                        |  4 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.c      |  7 +--
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c    | 11 ++--
 drivers/infiniband/hw/hfi1/sdma.c             | 20 +++----
 drivers/infiniband/hw/i40iw/i40iw_main.c      | 14 ++---
 drivers/infiniband/hw/qib/qib_iba7322.c       |  7 +--
 drivers/infiniband/hw/qib/qib_sdma.c          | 10 ++--
 drivers/infiniband/sw/rxe/rxe_cq.c            |  6 +-
 drivers/infiniband/sw/rxe/rxe_task.c          |  8 +--
 drivers/infiniband/sw/rxe/rxe_task.h          |  2 +-
 drivers/input/keyboard/omap-keypad.c          | 14 +++--
 drivers/input/serio/hil_mlc.c                 |  4 +-
 drivers/input/serio/hp_sdc.c                  |  4 +-
 drivers/mailbox/bcm-pdc-mailbox.c             |  6 +-
 drivers/mailbox/imx-mailbox.c                 |  7 +--
 drivers/media/pci/bt8xx/dvb-bt8xx.c           |  7 ++-
 drivers/media/pci/mantis/mantis_dma.c         |  4 +-
 drivers/media/pci/mantis/mantis_dma.h         |  2 +-
 drivers/media/pci/mantis/mantis_dvb.c         |  2 +-
 drivers/media/pci/ngene/ngene-core.c          | 12 ++--
 drivers/media/pci/smipcie/smipcie-main.c      |  6 +-
 drivers/media/pci/ttpci/av7110.c              | 20 +++----
 drivers/media/pci/ttpci/budget-ci.c           | 16 +++---
 drivers/media/pci/ttpci/budget-core.c         |  6 +-
 drivers/media/pci/tw5864/tw5864-video.c       |  9 ++-
 .../media/platform/marvell-ccic/mcam-core.c   |  7 +--
 drivers/media/platform/pxa_camera.c           |  6 +-
 .../platform/sti/c8sectpfe/c8sectpfe-core.c   | 10 ++--
 drivers/media/radio/wl128x/fmdrv_common.c     | 12 ++--
 drivers/media/usb/ttusb-dec/ttusb_dec.c       |  7 +--
 drivers/memstick/host/jmb38x_ms.c             |  8 +--
 drivers/memstick/host/tifm_ms.c               |  8 +--
 drivers/misc/ibmvmc.c                         |  8 +--
 drivers/misc/vmw_vmci/vmci_guest.c            | 15 +++--
 drivers/mmc/host/atmel-mci.c                  |  6 +-
 drivers/mmc/host/au1xmmc.c                    | 14 ++---
 drivers/mmc/host/cb710-mmc.c                  | 10 ++--
 drivers/mmc/host/dw_mmc.c                     |  6 +-
 drivers/mmc/host/omap.c                       |  7 +--
 drivers/mmc/host/renesas_sdhi.h               |  1 +
 drivers/mmc/host/renesas_sdhi_core.c          |  2 +
 drivers/mmc/host/renesas_sdhi_internal_dmac.c | 19 +++----
 drivers/mmc/host/renesas_sdhi_sys_dmac.c      |  9 ++-
 drivers/mmc/host/s3cmci.c                     |  6 +-
 drivers/mmc/host/tifm_sd.c                    |  7 +--
 drivers/mmc/host/uniphier-sd.c                | 14 ++---
 drivers/mmc/host/via-sdmmc.c                  |  7 +--
 drivers/mmc/host/wbsd.c                       | 35 +++++-------
 drivers/net/arcnet/arcnet.c                   |  7 +--
 drivers/net/caif/caif_virtio.c                |  8 +--
 drivers/net/ethernet/alteon/acenic.c          |  9 +--
 drivers/net/ethernet/alteon/acenic.h          |  2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c      | 19 +++----
 drivers/net/ethernet/amd/xgbe/xgbe-i2c.c      | 11 ++--
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c     | 11 ++--
 drivers/net/ethernet/broadcom/cnic.c          | 18 +++---
 drivers/net/ethernet/cadence/macb_main.c      |  7 +--
 .../net/ethernet/cavium/liquidio/lio_main.c   | 11 ++--
 .../ethernet/cavium/liquidio/octeon_main.h    |  1 +
 .../net/ethernet/cavium/octeon/octeon_mgmt.c  |  7 +--
 .../net/ethernet/cavium/thunder/nicvf_main.c  | 10 ++--
 .../ethernet/cavium/thunder/nicvf_queues.c    |  4 +-
 .../ethernet/cavium/thunder/nicvf_queues.h    |  2 +-
 drivers/net/ethernet/chelsio/cxgb/sge.c       | 11 ++--
 drivers/net/ethernet/chelsio/cxgb3/sge.c      | 16 +++---
 drivers/net/ethernet/chelsio/cxgb4/sge.c      | 12 ++--
 drivers/net/ethernet/dlink/sundance.c         | 19 +++----
 .../net/ethernet/huawei/hinic/hinic_hw_eqs.c  |  7 +--
 drivers/net/ethernet/ibm/ehea/ehea_main.c     |  7 +--
 drivers/net/ethernet/ibm/ibmvnic.c            |  7 +--
 drivers/net/ethernet/jme.c                    | 43 ++++++---------
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |  1 +
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  1 +
 drivers/net/ethernet/marvell/skge.c           |  6 +-
 drivers/net/ethernet/mellanox/mlx4/cq.c       |  4 +-
 drivers/net/ethernet/mellanox/mlx4/eq.c       |  3 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h     |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/cq.c  |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |  3 +-
 .../ethernet/mellanox/mlx5/core/fpga/conn.c   |  7 +--
 .../net/ethernet/mellanox/mlx5/core/lib/eq.h  |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/pci.c     | 12 ++--
 drivers/net/ethernet/micrel/ks8842.c          | 19 ++++---
 drivers/net/ethernet/micrel/ksz884x.c         | 14 ++---
 drivers/net/ethernet/natsemi/ns83820.c        |  8 +--
 .../ethernet/netronome/nfp/nfp_net_common.c   |  7 +--
 drivers/net/ethernet/ni/nixge.c               |  7 +--
 drivers/net/ethernet/qlogic/qed/qed.h         |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_int.c     | 27 +--------
 drivers/net/ethernet/qlogic/qed/qed_int.h     |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_main.c    | 14 ++---
 drivers/net/ethernet/silan/sc92031.c          | 11 ++--
 drivers/net/ethernet/smsc/smc91x.c            |  8 +--
 .../net/ethernet/xilinx/xilinx_axienet_main.c |  9 ++-
 drivers/net/ifb.c                             |  7 +--
 drivers/net/ppp/ppp_async.c                   |  8 +--
 drivers/net/ppp/ppp_synctty.c                 |  8 +--
 drivers/net/usb/cdc_ncm.c                     |  8 +--
 drivers/net/usb/hso.c                         |  8 +--
 drivers/net/usb/lan78xx.c                     |  6 +-
 drivers/net/usb/pegasus.c                     |  6 +-
 drivers/net/usb/r8152.c                       |  8 +--
 drivers/net/usb/rtl8150.c                     |  6 +-
 drivers/net/usb/usbnet.c                      |  3 +-
 drivers/net/wan/farsync.c                     | 12 ++--
 drivers/net/wireless/ath/ath5k/base.c         | 24 ++++----
 drivers/net/wireless/ath/ath5k/rfkill.c       |  8 +--
 drivers/net/wireless/ath/ath9k/ath9k.h        |  4 +-
 drivers/net/wireless/ath/ath9k/beacon.c       |  4 +-
 drivers/net/wireless/ath/ath9k/htc.h          |  4 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |  6 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |  8 +--
 drivers/net/wireless/ath/ath9k/init.c         |  5 +-
 drivers/net/wireless/ath/ath9k/main.c         |  4 +-
 drivers/net/wireless/ath/ath9k/wmi.c          |  7 +--
 drivers/net/wireless/ath/ath9k/wmi.h          |  2 +-
 drivers/net/wireless/ath/carl9170/usb.c       |  7 +--
 drivers/net/wireless/atmel/at76c50x-usb.c     |  9 ++-
 .../net/wireless/broadcom/b43legacy/main.c    |  7 +--
 drivers/net/wireless/broadcom/b43legacy/pio.c |  7 +--
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c |  6 +-
 .../broadcom/brcm80211/brcmsmac/mac80211_if.h |  2 +-
 drivers/net/wireless/intel/ipw2x00/ipw2100.c  |  8 +--
 drivers/net/wireless/intel/ipw2x00/ipw2200.c  |  6 +-
 .../net/wireless/intel/iwlegacy/3945-mac.c    |  7 +--
 .../net/wireless/intel/iwlegacy/4965-mac.c    |  7 +--
 .../net/wireless/intersil/hostap/hostap_hw.c  | 18 +++---
 drivers/net/wireless/intersil/orinoco/main.c  |  7 +--
 drivers/net/wireless/intersil/p54/p54pci.c    |  8 +--
 drivers/net/wireless/marvell/mwl8k.c          | 16 +++---
 drivers/net/wireless/mediatek/mt76/mac80211.c |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76.h     |  2 +-
 .../wireless/mediatek/mt76/mt7603/beacon.c    |  4 +-
 .../net/wireless/mediatek/mt76/mt7603/init.c  |  3 +-
 .../wireless/mediatek/mt76/mt7603/mt7603.h    |  2 +-
 .../net/wireless/mediatek/mt76/mt76x02_dfs.c  |  9 ++-
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c | 14 ++---
 drivers/net/wireless/mediatek/mt76/tx.c       |  4 +-
 drivers/net/wireless/mediatek/mt76/usb.c      | 12 ++--
 drivers/net/wireless/mediatek/mt7601u/dma.c   | 12 ++--
 .../quantenna/qtnfmac/pcie/pearl_pcie.c       |  7 +--
 .../quantenna/qtnfmac/pcie/topaz_pcie.c       |  7 +--
 .../net/wireless/ralink/rt2x00/rt2400pci.c    | 14 +++--
 .../net/wireless/ralink/rt2x00/rt2500pci.c    | 14 +++--
 .../net/wireless/ralink/rt2x00/rt2800mmio.c   | 25 +++++----
 .../net/wireless/ralink/rt2x00/rt2800mmio.h   | 10 ++--
 drivers/net/wireless/ralink/rt2x00/rt2x00.h   | 10 ++--
 .../net/wireless/ralink/rt2x00/rt2x00dev.c    |  5 +-
 drivers/net/wireless/ralink/rt2x00/rt61pci.c  | 19 ++++---
 drivers/net/wireless/realtek/rtlwifi/pci.c    | 20 ++++---
 drivers/net/wireless/realtek/rtlwifi/usb.c    |  9 ++-
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c  |  7 +--
 drivers/ntb/ntb_transport.c                   |  9 ++-
 drivers/platform/goldfish/goldfish_pipe.c     |  7 +--
 drivers/rapidio/devices/tsi721_dma.c          |  7 +--
 drivers/s390/block/dasd.c                     | 18 +++---
 drivers/s390/char/con3215.c                   |  6 +-
 drivers/s390/char/con3270.c                   |  7 +--
 drivers/s390/char/tty3270.c                   | 15 +++--
 drivers/s390/cio/qdio.h                       |  6 +-
 drivers/s390/cio/qdio_main.c                  | 12 ++--
 drivers/s390/cio/qdio_setup.c                 |  9 +--
 drivers/s390/crypto/ap_bus.c                  |  8 +--
 drivers/s390/net/ctcm_main.c                  |  9 ++-
 drivers/s390/net/ctcm_mpc.c                   | 16 +++---
 drivers/s390/net/ctcm_mpc.h                   |  6 +-
 drivers/scsi/aic94xx/aic94xx_hwi.c            |  9 ++-
 drivers/scsi/esas2r/esas2r.h                  |  2 +-
 drivers/scsi/esas2r/esas2r_init.c             |  4 +-
 drivers/scsi/esas2r/esas2r_main.c             |  4 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c        |  6 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c        |  6 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                |  6 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c              |  8 +--
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c      |  7 +--
 drivers/scsi/isci/host.c                      |  4 +-
 drivers/scsi/isci/host.h                      |  2 +-
 drivers/scsi/isci/init.c                      |  4 +-
 drivers/scsi/megaraid/megaraid_mbox.c         | 11 ++--
 drivers/scsi/megaraid/megaraid_sas.h          |  2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c     | 16 +++---
 drivers/scsi/megaraid/megaraid_sas_fusion.c   | 13 ++---
 drivers/scsi/mvsas/mv_init.c                  |  8 +--
 drivers/scsi/pm8001/pm8001_init.c             | 55 +++++++++++--------
 drivers/scsi/pm8001/pm8001_sas.h              |  6 +-
 drivers/scsi/pmcraid.c                        | 29 +++++-----
 drivers/scsi/pmcraid.h                        |  9 ++-
 drivers/spi/spi-pl022.c                       |  7 +--
 drivers/staging/isdn/gigaset/bas-gigaset.c    | 23 ++++----
 drivers/staging/isdn/gigaset/common.c         |  3 +-
 drivers/staging/isdn/gigaset/ev-layer.c       |  4 +-
 drivers/staging/isdn/gigaset/gigaset.h        |  3 +-
 drivers/staging/isdn/gigaset/interface.c      |  6 +-
 drivers/staging/isdn/gigaset/ser-gigaset.c    |  7 +--
 drivers/staging/isdn/gigaset/usb-gigaset.c    |  7 +--
 drivers/staging/ks7010/ks7010_sdio.c          |  6 +-
 drivers/staging/ks7010/ks_hostif.c            |  6 +-
 drivers/staging/most/dim2/dim2.c              | 19 ++++---
 drivers/staging/mt7621-dma/mtk-hsdma.c        |  6 +-
 drivers/staging/octeon/ethernet-tx.c          |  6 +-
 drivers/staging/ralink-gdma/ralink-gdma.c     |  6 +-
 .../staging/rtl8188eu/hal/rtl8188eu_recv.c    |  4 +-
 .../staging/rtl8188eu/hal/rtl8188eu_xmit.c    |  5 +-
 .../staging/rtl8188eu/include/rtl8188e_recv.h |  2 +-
 .../staging/rtl8188eu/include/rtl8188e_xmit.h |  2 +-
 .../staging/rtl8188eu/os_dep/usb_ops_linux.c  |  8 +--
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c  | 29 +++++-----
 drivers/staging/rtl8192e/rtllib_softmac.c     |  8 +--
 .../rtl8192u/ieee80211/ieee80211_softmac.c    |  7 +--
 drivers/staging/rtl8192u/r8192U_core.c        |  9 ++-
 drivers/staging/rtl8712/rtl8712_recv.c        | 10 ++--
 drivers/staging/rtl8712/rtl871x_xmit.c        |  4 +-
 drivers/staging/rtl8712/rtl871x_xmit.h        |  2 +-
 drivers/staging/rtl8712/usb_ops_linux.c       |  4 +-
 .../staging/rtl8723bs/hal/rtl8723bs_recv.c    | 13 ++---
 drivers/staging/wlan-ng/hfa384x_usb.c         | 18 +++---
 drivers/staging/wlan-ng/p80211netdev.c        |  7 +--
 drivers/tty/ipwireless/hardware.c             |  6 +-
 drivers/tty/serial/atmel_serial.c             | 18 +++---
 drivers/tty/serial/ifx6x60.c                  |  7 +--
 drivers/tty/serial/timbuart.c                 |  6 +-
 drivers/tty/vt/keyboard.c                     |  4 +-
 drivers/usb/atm/usbatm.c                      | 12 ++--
 drivers/usb/c67x00/c67x00-sched.c             |  7 +--
 drivers/usb/core/hcd.c                        |  6 +-
 drivers/usb/gadget/function/f_midi.c          |  6 +-
 drivers/usb/gadget/udc/amd5536udc.h           |  1 +
 drivers/usb/gadget/udc/fsl_qe_udc.c           |  7 +--
 drivers/usb/gadget/udc/snps_udc_core.c        | 16 +++---
 drivers/usb/host/fhci-hcd.c                   |  5 +-
 drivers/usb/host/fhci-sched.c                 |  8 +--
 drivers/usb/host/fhci.h                       |  2 +-
 drivers/usb/host/xhci-dbgtty.c                |  6 +-
 drivers/usb/serial/mos7720.c                  |  7 +--
 drivers/vme/bridges/vme_fake.c                |  9 ++-
 include/linux/interrupt.h                     | 20 ++++---
 kernel/backtracetest.c                        |  4 +-
 kernel/debug/debug_core.c                     |  4 +-
 kernel/irq/resend.c                           |  4 +-
 kernel/softirq.c                              |  9 ++-
 net/atm/pppoatm.c                             |  8 +--
 net/dccp/timer.c                              |  9 +--
 net/ipv4/tcp_output.c                         |  8 +--
 net/iucv/iucv.c                               |  4 +-
 net/mac80211/ieee80211_i.h                    |  4 +-
 net/mac80211/main.c                           | 14 ++---
 net/mac80211/tx.c                             |  4 +-
 net/mac80211/util.c                           |  4 +-
 net/mac802154/main.c                          |  8 +--
 net/rds/ib_cm.c                               | 14 ++---
 net/sched/sch_atm.c                           |  8 +--
 net/smc/smc_cdc.c                             |  6 +-
 net/smc/smc_wr.c                              | 14 ++---
 net/xfrm/xfrm_input.c                         |  7 +--
 sound/core/timer.c                            |  7 +--
 sound/drivers/pcsp/pcsp_lib.c                 |  4 +-
 sound/firewire/amdtp-stream.c                 |  8 +--
 sound/pci/asihpi/asihpi.c                     |  9 ++-
 sound/pci/riptide/riptide.c                   |  6 +-
 sound/pci/rme9652/hdsp.c                      |  6 +-
 sound/pci/rme9652/hdspm.c                     |  7 +--
 sound/soc/fsl/fsl_esai.c                      |  7 +--
 sound/soc/sh/siu_pcm.c                        | 10 ++--
 sound/soc/txx9/txx9aclc.c                     |  7 +--
 sound/usb/midi.c                              |  7 +--
 sound/usb/misc/ua101.c                        |  7 +--
 359 files changed, 1432 insertions(+), 1612 deletions(-)

-- 
2.23.0

