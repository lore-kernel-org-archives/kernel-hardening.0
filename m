Return-Path: <SRS0=0K/z=FI=lists.openwall.com=kernel-hardening-return-20533-kernel-hardening=archiver.kernel.org@kernel.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5648C433FE
	for <kernel-hardening@archiver.kernel.org>; Fri,  4 Dec 2020 15:39:12 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 80C9422BF5
	for <kernel-hardening@archiver.kernel.org>; Fri,  4 Dec 2020 15:39:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 80C9422BF5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20533-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28668 invoked by uid 550); 4 Dec 2020 15:38:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28558 invoked from network); 4 Dec 2020 15:38:26 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PTQHEe48J7VwM0IA5pqYNed2YTW7ncMVW8CoxD2o8tM=;
        b=uFqCgE7gaD+7/venEO6PDL3LJggWKkSLbFwKLSEDfTGaVHFlxsDrqNgd1EOwgkdoNa
         LggT+D6ya7PKAdnC7pTj3UJWbOvITzQ4wFWbn3e6OyqrQEj9cgdGrpTr24cC+p6gwwjd
         A4zGD4zpuoFwL8bvYh8NhjaLiD7ICh6hkY9mdR1nDrWYsaiCIDdYltax895+OIJuOJ5A
         uEUVQ7ff/DsFpFY3+009GDdkRdib6jcJ5sIm8OOxfBueWzp4vKSRrwWa+MxYV42dJ2ZE
         EM6wxb7Udwbq7YhxDcBpQ++7+l8B5izQFSpYrDPQR1okywCP2JO5JcyibMmF77aQitqU
         4hTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PTQHEe48J7VwM0IA5pqYNed2YTW7ncMVW8CoxD2o8tM=;
        b=s1uaEFuJe3ZFY4dJwhBD7fTNeu9EGJH3PknWP+urJuqDy9XX5qRkzTx9p1z3aLQ1V/
         sczq1X10f5T49OGv7Dzou+IJ/srmHG/UVgQusQJLYPTu7Kcd+JL1mvFk40Bt0cC8xBUJ
         Vv6Lb5G3rw1UBe61+ywXlXOHzjNVdCduwWlmLHkXP6JUR/q+EFPk7yWJ4uV0dL4VUeyu
         N0D96jInqcCki6eXlwRhnMSumyYaE7RaCa0zwz9qxlLSYA+ZNsfdai3jvuUrIO7aKOTi
         RuLSiLexDjWLS9XlfDlfDruJmZqa1vIqjHho3pF4b5S/U27DXpmASBKcccJMCwgVhR1i
         +HLA==
X-Gm-Message-State: AOAM5323TtMD/j1S6/6rQrjxwFZolX6hhUAoFFNWBEAxFfgH8VaUXZ54
	E0Nr4bpiLB5q37T650F7KXw=
X-Google-Smtp-Source: ABdhPJxPOPouGcbxcZVm/nuGn3HU1GHsqCTJxBXag2VHJo5PfaxKp8ridI+RZMejifH6NbXbhHx3xw==
X-Received: by 2002:a1c:cc19:: with SMTP id h25mr4919476wmb.124.1607096294194;
        Fri, 04 Dec 2020 07:38:14 -0800 (PST)
From: Romain Perier <romain.perier@gmail.com>
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>,
	Romain Perier <romain.perier@gmail.com>
Subject: [PRE-REVIEW PATCH 2/2] Automated replacement of all other deprecated strlcpy()
Date: Fri,  4 Dec 2020 16:37:54 +0100
Message-Id: <20201204153754.7941-3-romain.perier@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201204153754.7941-1-romain.perier@gmail.com>
References: <20201204153754.7941-1-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The strlcpy() reads the entire source buffer first, it is dangerous if
the source buffer lenght is unbounded or possibility non NULL-terminated.
It can lead to linear read overflows, crashes, etc...

As recommended in the deprecated interfaces [1], it should be replaced
by strscpy.

This commit replaces all other calls to strcpy() by the corresponding
call to strscpy(). All has been done automatically by using the
following Cocinelle script:

virtual patch

@@
identifier d, s;
expression size;
@@

-strlcpy(d, s, size)
+strscpy(d, s, size)

@@
identifier a, x;
expression s, size;
@@

-strlcpy(a->x, s, size)
+strscpy(a->x, s, size)

@@
identifier a, x;
expression s, size;
@@

-strlcpy(a.x, s, size)
+strscpy(a.x, s, size)

@@
identifier a;
expression s, size;
@@

-strlcpy(a, s, size)
+strscpy(a, s, size)

@@
expression d, s, size;
@@

-strlcpy(d, s, size)
+strscpy(d, s, size)

@@
identifier d, s, size;
@@

-strlcpy(d, s, size)
+strscpy(d, s, size)

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 arch/alpha/kernel/setup.c                     |  5 ++--
 arch/arm/kernel/atags_parse.c                 |  4 +--
 arch/arm/kernel/setup.c                       |  2 +-
 arch/arm/kernel/vdso.c                        |  2 +-
 arch/arm/mach-s3c/mach-mini2440.c             |  2 +-
 arch/arm/mach-s3c/mach-mini6410.c             |  2 +-
 arch/arm/mach-s3c/mach-real6410.c             |  2 +-
 arch/hexagon/kernel/setup.c                   |  6 ++---
 arch/ia64/kernel/setup.c                      |  2 +-
 arch/m68k/kernel/setup_mm.c                   |  2 +-
 arch/microblaze/kernel/prom.c                 |  2 +-
 arch/mips/bcm47xx/board.c                     |  2 +-
 arch/mips/kernel/prom.c                       |  6 ++---
 arch/mips/kernel/relocate.c                   |  2 +-
 arch/mips/kernel/setup.c                      |  6 ++---
 arch/mips/pic32/pic32mzda/init.c              |  2 +-
 arch/nios2/kernel/cpuinfo.c                   |  2 +-
 arch/nios2/kernel/setup.c                     |  6 ++---
 arch/parisc/kernel/drivers.c                  |  2 +-
 arch/parisc/kernel/setup.c                    |  2 +-
 arch/powerpc/kernel/dt_cpu_ftrs.c             |  2 +-
 arch/powerpc/kernel/vdso.c                    |  4 +--
 arch/powerpc/platforms/pasemi/misc.c          |  3 +--
 arch/powerpc/platforms/powermac/bootx_init.c  |  2 +-
 arch/powerpc/platforms/powernv/idle.c         |  2 +-
 arch/powerpc/platforms/powernv/pci-ioda.c     |  2 +-
 arch/powerpc/platforms/pseries/hvcserver.c    |  2 +-
 arch/riscv/kernel/setup.c                     |  2 +-
 arch/s390/kernel/debug.c                      |  2 +-
 arch/s390/kernel/early.c                      |  2 +-
 arch/sh/drivers/dma/dma-api.c                 |  2 +-
 arch/sh/kernel/setup.c                        |  4 +--
 arch/sparc/kernel/ioport.c                    |  2 +-
 arch/sparc/kernel/setup_32.c                  |  2 +-
 arch/sparc/kernel/setup_64.c                  |  2 +-
 arch/sparc/prom/bootstr_32.c                  |  3 ++-
 arch/um/drivers/net_kern.c                    |  2 +-
 arch/um/drivers/vector_kern.c                 |  2 +-
 arch/um/kernel/um_arch.c                      |  2 +-
 arch/um/os-Linux/drivers/tuntap_user.c        |  2 +-
 arch/um/os-Linux/umid.c                       |  6 ++---
 arch/x86/kernel/setup.c                       |  6 ++---
 arch/xtensa/kernel/setup.c                    |  8 +++---
 arch/xtensa/platforms/iss/network.c           |  4 +--
 block/elevator.c                              |  2 +-
 block/genhd.c                                 |  2 +-
 crypto/api.c                                  |  2 +-
 crypto/essiv.c                                |  2 +-
 drivers/acpi/bus.c                            |  4 +--
 drivers/acpi/processor_idle.c                 |  8 +++---
 drivers/acpi/utils.c                          |  6 ++---
 drivers/base/dd.c                             |  2 +-
 drivers/block/drbd/drbd_nl.c                  |  3 ++-
 drivers/block/mtip32xx/mtip32xx.c             | 20 +++++++--------
 drivers/block/ps3vram.c                       |  2 +-
 drivers/block/rnbd/rnbd-clt-sysfs.c           |  6 ++---
 drivers/block/rnbd/rnbd-clt.c                 |  6 ++---
 drivers/block/rnbd/rnbd-srv.c                 |  6 ++---
 drivers/block/zram/zram_drv.c                 |  7 +++---
 drivers/char/ipmi/ipmi_ssif.c                 |  2 +-
 drivers/char/tpm/tpm_ppi.c                    |  2 +-
 drivers/clk/clkdev.c                          |  2 +-
 drivers/clk/mvebu/dove-divider.c              |  2 +-
 drivers/clk/tegra/clk-bpmp.c                  |  2 +-
 drivers/cpuidle/cpuidle-powernv.c             |  4 +--
 .../crypto/marvell/octeontx/otx_cptpf_ucode.c |  6 ++---
 drivers/crypto/qat/qat_common/adf_cfg.c       |  6 ++---
 drivers/crypto/qat/qat_common/adf_ctl_drv.c   |  3 ++-
 .../qat/qat_common/adf_transport_debug.c      |  2 +-
 drivers/dma-buf/sw_sync.c                     |  2 +-
 drivers/dma-buf/sync_file.c                   |  8 +++---
 drivers/dma/dmatest.c                         | 12 ++++-----
 drivers/dma/xilinx/xilinx_dpdma.c             |  2 +-
 drivers/eisa/eisa-bus.c                       |  3 +--
 drivers/firmware/arm_scmi/base.c              |  2 +-
 drivers/firmware/arm_scmi/clock.c             |  2 +-
 drivers/firmware/arm_scmi/perf.c              |  2 +-
 drivers/firmware/arm_scmi/power.c             |  2 +-
 drivers/firmware/arm_scmi/reset.c             |  2 +-
 drivers/firmware/arm_scmi/sensors.c           |  3 ++-
 drivers/gpu/drm/amd/amdgpu/atom.c             |  2 +-
 drivers/gpu/drm/amd/pm/amdgpu_dpm.c           |  2 +-
 .../drm/bridge/synopsys/dw-hdmi-ahb-audio.c   |  6 ++---
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c     |  2 +-
 drivers/gpu/drm/drm_dp_helper.c               |  2 +-
 drivers/gpu/drm/drm_dp_mst_topology.c         |  2 +-
 drivers/gpu/drm/drm_mipi_dsi.c                |  2 +-
 drivers/gpu/drm/i2c/tda998x_drv.c             |  2 +-
 drivers/gpu/drm/i915/selftests/i915_perf.c    |  2 +-
 drivers/gpu/drm/mediatek/mtk_hdmi_ddc.c       |  2 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_io_util.c   |  2 +-
 drivers/gpu/drm/msm/dp/dp_parser.c            |  9 ++++---
 drivers/gpu/drm/radeon/radeon_atombios.c      |  4 +--
 drivers/gpu/drm/radeon/radeon_combios.c       |  4 +--
 drivers/gpu/drm/rockchip/inno_hdmi.c          |  2 +-
 drivers/gpu/drm/rockchip/rk3066_hdmi.c        |  2 +-
 drivers/gpu/drm/sun4i/sun4i_hdmi_i2c.c        |  2 +-
 drivers/hid/hid-steam.c                       | 12 ++++-----
 drivers/hid/i2c-hid/i2c-hid-core.c            |  2 +-
 drivers/hid/usbhid/hid-core.c                 |  2 +-
 drivers/hid/usbhid/usbkbd.c                   |  2 +-
 drivers/hid/usbhid/usbmouse.c                 |  2 +-
 drivers/hid/wacom_sys.c                       |  6 ++---
 drivers/hwmon/adc128d818.c                    |  2 +-
 drivers/hwmon/adm1021.c                       |  2 +-
 drivers/hwmon/adm1025.c                       |  2 +-
 drivers/hwmon/adm1026.c                       |  2 +-
 drivers/hwmon/adm1029.c                       |  2 +-
 drivers/hwmon/adm1031.c                       |  2 +-
 drivers/hwmon/adm9240.c                       |  2 +-
 drivers/hwmon/adt7411.c                       |  2 +-
 drivers/hwmon/adt7462.c                       |  2 +-
 drivers/hwmon/adt7470.c                       |  2 +-
 drivers/hwmon/adt7475.c                       |  2 +-
 drivers/hwmon/amc6821.c                       |  2 +-
 drivers/hwmon/asb100.c                        |  2 +-
 drivers/hwmon/asc7621.c                       |  2 +-
 drivers/hwmon/dell-smm-hwmon.c                |  6 ++---
 drivers/hwmon/dme1737.c                       |  2 +-
 drivers/hwmon/emc1403.c                       | 12 ++++-----
 drivers/hwmon/emc2103.c                       |  2 +-
 drivers/hwmon/emc6w201.c                      |  2 +-
 drivers/hwmon/f75375s.c                       |  2 +-
 drivers/hwmon/fschmd.c                        |  2 +-
 drivers/hwmon/ftsteutates.c                   |  2 +-
 drivers/hwmon/gl518sm.c                       |  2 +-
 drivers/hwmon/gl520sm.c                       |  2 +-
 drivers/hwmon/jc42.c                          |  2 +-
 drivers/hwmon/lm63.c                          |  6 ++---
 drivers/hwmon/lm73.c                          |  2 +-
 drivers/hwmon/lm75.c                          |  2 +-
 drivers/hwmon/lm77.c                          |  2 +-
 drivers/hwmon/lm78.c                          |  2 +-
 drivers/hwmon/lm80.c                          |  2 +-
 drivers/hwmon/lm83.c                          |  2 +-
 drivers/hwmon/lm85.c                          |  2 +-
 drivers/hwmon/lm87.c                          |  2 +-
 drivers/hwmon/lm90.c                          |  2 +-
 drivers/hwmon/lm92.c                          |  2 +-
 drivers/hwmon/lm93.c                          |  2 +-
 drivers/hwmon/lm95234.c                       |  2 +-
 drivers/hwmon/lm95241.c                       |  2 +-
 drivers/hwmon/lm95245.c                       |  2 +-
 drivers/hwmon/max1619.c                       |  2 +-
 drivers/hwmon/max1668.c                       |  2 +-
 drivers/hwmon/max31730.c                      |  2 +-
 drivers/hwmon/max6639.c                       |  2 +-
 drivers/hwmon/max6642.c                       |  2 +-
 drivers/hwmon/nct7802.c                       |  2 +-
 drivers/hwmon/nct7904.c                       |  2 +-
 drivers/hwmon/sch56xx-common.c                |  2 +-
 drivers/hwmon/smsc47m192.c                    |  2 +-
 drivers/hwmon/stts751.c                       |  2 +-
 drivers/hwmon/thmc50.c                        |  2 +-
 drivers/hwmon/tmp401.c                        |  2 +-
 drivers/hwmon/tmp421.c                        |  2 +-
 drivers/hwmon/w83781d.c                       |  2 +-
 drivers/hwmon/w83791d.c                       |  2 +-
 drivers/hwmon/w83792d.c                       |  2 +-
 drivers/hwmon/w83793.c                        |  2 +-
 drivers/hwmon/w83795.c                        |  2 +-
 drivers/hwmon/w83l785ts.c                     |  2 +-
 drivers/hwmon/w83l786ng.c                     |  2 +-
 drivers/i2c/busses/i2c-altera.c               |  2 +-
 drivers/i2c/busses/i2c-aspeed.c               |  2 +-
 drivers/i2c/busses/i2c-au1550.c               |  2 +-
 drivers/i2c/busses/i2c-axxia.c                |  2 +-
 drivers/i2c/busses/i2c-bcm-kona.c             |  2 +-
 drivers/i2c/busses/i2c-brcmstb.c              |  2 +-
 drivers/i2c/busses/i2c-cbus-gpio.c            |  2 +-
 drivers/i2c/busses/i2c-cht-wc.c               |  2 +-
 drivers/i2c/busses/i2c-cros-ec-tunnel.c       |  2 +-
 drivers/i2c/busses/i2c-davinci.c              |  2 +-
 drivers/i2c/busses/i2c-digicolor.c            |  2 +-
 drivers/i2c/busses/i2c-efm32.c                |  2 +-
 drivers/i2c/busses/i2c-eg20t.c                |  3 ++-
 drivers/i2c/busses/i2c-emev2.c                |  2 +-
 drivers/i2c/busses/i2c-exynos5.c              |  2 +-
 drivers/i2c/busses/i2c-gpio.c                 |  2 +-
 drivers/i2c/busses/i2c-highlander.c           |  2 +-
 drivers/i2c/busses/i2c-hix5hd2.c              |  2 +-
 drivers/i2c/busses/i2c-i801.c                 |  6 ++---
 drivers/i2c/busses/i2c-ibm_iic.c              |  2 +-
 drivers/i2c/busses/i2c-icy.c                  |  2 +-
 drivers/i2c/busses/i2c-imx-lpi2c.c            |  2 +-
 drivers/i2c/busses/i2c-imx.c                  |  3 ++-
 drivers/i2c/busses/i2c-lpc2k.c                |  2 +-
 drivers/i2c/busses/i2c-meson.c                |  3 +--
 drivers/i2c/busses/i2c-mt65xx.c               |  2 +-
 drivers/i2c/busses/i2c-mt7621.c               |  2 +-
 drivers/i2c/busses/i2c-mv64xxx.c              |  2 +-
 drivers/i2c/busses/i2c-mxs.c                  |  2 +-
 drivers/i2c/busses/i2c-nvidia-gpu.c           |  4 +--
 drivers/i2c/busses/i2c-omap.c                 |  2 +-
 drivers/i2c/busses/i2c-opal.c                 |  4 +--
 drivers/i2c/busses/i2c-parport.c              |  2 +-
 drivers/i2c/busses/i2c-pxa.c                  |  2 +-
 drivers/i2c/busses/i2c-qcom-geni.c            |  2 +-
 drivers/i2c/busses/i2c-qup.c                  |  2 +-
 drivers/i2c/busses/i2c-rcar.c                 |  2 +-
 drivers/i2c/busses/i2c-riic.c                 |  2 +-
 drivers/i2c/busses/i2c-rk3x.c                 |  2 +-
 drivers/i2c/busses/i2c-s3c2410.c              |  2 +-
 drivers/i2c/busses/i2c-sh_mobile.c            |  2 +-
 drivers/i2c/busses/i2c-simtec.c               |  2 +-
 drivers/i2c/busses/i2c-sirf.c                 |  2 +-
 drivers/i2c/busses/i2c-stu300.c               |  2 +-
 drivers/i2c/busses/i2c-sun6i-p2wi.c           |  2 +-
 drivers/i2c/busses/i2c-taos-evm.c             |  2 +-
 drivers/i2c/busses/i2c-tegra-bpmp.c           |  2 +-
 drivers/i2c/busses/i2c-tegra.c                |  2 +-
 drivers/i2c/busses/i2c-uniphier-f.c           |  2 +-
 drivers/i2c/busses/i2c-uniphier.c             |  2 +-
 drivers/i2c/busses/i2c-versatile.c            |  3 ++-
 drivers/i2c/busses/i2c-wmt.c                  |  2 +-
 drivers/i2c/busses/i2c-zx2967.c               |  3 +--
 drivers/i2c/i2c-core-base.c                   |  2 +-
 drivers/i2c/i2c-smbus.c                       |  2 +-
 drivers/idle/intel_idle.c                     |  2 +-
 .../iio/common/st_sensors/st_sensors_core.c   |  2 +-
 drivers/iio/imu/inv_mpu6050/inv_mpu_acpi.c    |  4 +--
 drivers/infiniband/core/cma_configfs.c        |  2 +-
 drivers/infiniband/core/device.c              |  4 +--
 drivers/infiniband/hw/bnxt_re/main.c          |  2 +-
 drivers/infiniband/hw/efa/efa_main.c          |  4 +--
 drivers/infiniband/hw/hfi1/file_ops.c         |  2 +-
 drivers/infiniband/hw/hfi1/verbs.c            |  2 +-
 drivers/infiniband/hw/mthca/mthca_cmd.c       |  3 ++-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c      |  2 +-
 drivers/infiniband/hw/qib/qib_file_ops.c      |  2 +-
 drivers/infiniband/hw/qib/qib_iba7322.c       |  2 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c         |  2 +-
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c  |  4 +--
 .../ulp/opa_vnic/opa_vnic_ethtool.c           |  5 ++--
 drivers/infiniband/ulp/rtrs/rtrs-clt.c        |  6 ++---
 drivers/infiniband/ulp/rtrs/rtrs-srv.c        |  6 ++---
 drivers/infiniband/ulp/srpt/ib_srpt.c         |  2 +-
 drivers/input/keyboard/lkkbd.c                |  8 +++---
 drivers/input/misc/keyspan_remote.c           |  3 ++-
 drivers/input/mouse/hgpk.c                    |  2 +-
 drivers/input/mouse/synaptics.c               |  4 +--
 drivers/input/mouse/synaptics_usb.c           |  2 +-
 drivers/input/mouse/vsxxxaa.c                 |  4 +--
 drivers/input/rmi4/rmi_f03.c                  |  2 +-
 drivers/input/rmi4/rmi_f54.c                  |  8 +++---
 drivers/input/serio/altera_ps2.c              |  4 +--
 drivers/input/serio/ambakmi.c                 |  4 +--
 drivers/input/serio/ams_delta_serio.c         |  5 ++--
 drivers/input/serio/apbps2.c                  |  2 +-
 drivers/input/serio/ct82c710.c                |  2 +-
 drivers/input/serio/gscps2.c                  |  2 +-
 drivers/input/serio/hyperv-keyboard.c         |  4 +--
 drivers/input/serio/i8042-x86ia64io.h         |  6 ++---
 drivers/input/serio/i8042.c                   | 14 +++++------
 drivers/input/serio/olpc_apsp.c               |  8 +++---
 drivers/input/serio/parkbd.c                  |  3 ++-
 drivers/input/serio/pcips2.c                  |  4 +--
 drivers/input/serio/ps2-gpio.c                |  4 +--
 drivers/input/serio/ps2mult.c                 |  2 +-
 drivers/input/serio/q40kbd.c                  |  4 +--
 drivers/input/serio/rpckbd.c                  |  4 +--
 drivers/input/serio/sa1111ps2.c               |  4 +--
 drivers/input/serio/serport.c                 |  2 +-
 drivers/input/serio/sun4i-ps2.c               |  4 +--
 drivers/input/tablet/acecad.c                 |  2 +-
 drivers/input/tablet/hanwang.c                |  2 +-
 drivers/input/tablet/pegasus_notetaker.c      |  2 +-
 drivers/input/touchscreen/atmel_mxt_ts.c      |  8 +++---
 drivers/input/touchscreen/edt-ft5x06.c        | 12 ++++-----
 drivers/input/touchscreen/exc3000.c           |  4 +--
 drivers/input/touchscreen/sur40.c             |  6 ++---
 drivers/input/touchscreen/usbtouchscreen.c    |  3 ++-
 drivers/input/touchscreen/wacom_w8001.c       |  7 +++---
 drivers/isdn/capi/kcapi.c                     |  4 +--
 drivers/leds/led-class.c                      |  2 +-
 drivers/leds/leds-aat1290.c                   |  2 +-
 drivers/leds/leds-as3645a.c                   |  4 +--
 drivers/leds/leds-blinkm.c                    |  2 +-
 drivers/leds/leds-spi-byte.c                  |  2 +-
 drivers/lightnvm/core.c                       |  6 ++---
 drivers/macintosh/therm_windtunnel.c          |  4 +--
 drivers/md/dm-ioctl.c                         |  4 +--
 drivers/md/md-bitmap.c                        |  6 ++---
 drivers/md/md-cluster.c                       |  2 +-
 drivers/md/md.c                               |  6 ++---
 drivers/message/fusion/mptbase.c              |  6 ++---
 drivers/message/fusion/mptctl.c               |  5 ++--
 drivers/mfd/htc-i2cpld.c                      |  2 +-
 drivers/mfd/lpc_ich.c                         |  2 +-
 drivers/mfd/mfd-core.c                        |  2 +-
 drivers/misc/altera-stapl/altera.c            | 15 +++++------
 drivers/misc/eeprom/eeprom.c                  |  2 +-
 drivers/misc/eeprom/idt_89hpesx.c             |  2 +-
 drivers/misc/habanalabs/common/device.c       |  2 +-
 drivers/misc/ics932s401.c                     |  2 +-
 drivers/misc/mei/bus-fixup.c                  |  2 +-
 drivers/most/configfs.c                       |  8 +++---
 drivers/mtd/devices/block2mtd.c               |  2 +-
 drivers/mtd/parsers/cmdlinepart.c             |  4 +--
 drivers/net/bonding/bond_main.c               |  2 +-
 drivers/net/can/sja1000/peak_pcmcia.c         |  2 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c  |  2 +-
 drivers/net/dsa/b53/b53_common.c              |  4 +--
 drivers/net/dsa/bcm_sf2_cfp.c                 |  4 +--
 drivers/net/dsa/mv88e6xxx/chip.c              |  5 ++--
 drivers/net/dsa/sja1105/sja1105_ethtool.c     |  4 +--
 drivers/net/dummy.c                           |  2 +-
 drivers/net/ethernet/3com/3c509.c             |  2 +-
 drivers/net/ethernet/3com/3c515.c             |  2 +-
 drivers/net/ethernet/3com/3c589_cs.c          |  2 +-
 drivers/net/ethernet/3com/3c59x.c             |  6 ++---
 drivers/net/ethernet/3com/typhoon.c           |  8 +++---
 drivers/net/ethernet/8390/ax88796.c           |  6 ++---
 drivers/net/ethernet/8390/etherh.c            |  6 ++---
 drivers/net/ethernet/adaptec/starfire.c       |  4 +--
 drivers/net/ethernet/aeroflex/greth.c         |  4 +--
 drivers/net/ethernet/agere/et131x.c           |  4 +--
 drivers/net/ethernet/alacritech/slicoss.c     |  4 +--
 drivers/net/ethernet/allwinner/sun4i-emac.c   |  4 +--
 drivers/net/ethernet/alteon/acenic.c          |  6 ++---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |  4 +--
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  2 +-
 drivers/net/ethernet/amd/amd8111e.c           |  4 +--
 drivers/net/ethernet/amd/au1000_eth.c         |  2 +-
 drivers/net/ethernet/amd/nmclan_cs.c          |  2 +-
 drivers/net/ethernet/amd/pcnet32.c            |  6 ++---
 drivers/net/ethernet/amd/sunlance.c           |  2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c  |  4 +--
 .../ethernet/aquantia/atlantic/aq_ethtool.c   |  2 +-
 drivers/net/ethernet/arc/emac_main.c          |  2 +-
 drivers/net/ethernet/atheros/ag71xx.c         |  4 +--
 .../ethernet/atheros/atl1c/atl1c_ethtool.c    |  4 +--
 .../ethernet/atheros/atl1e/atl1e_ethtool.c    |  6 ++---
 drivers/net/ethernet/atheros/atlx/atl1.c      |  4 +--
 drivers/net/ethernet/atheros/atlx/atl2.c      |  6 ++---
 drivers/net/ethernet/broadcom/b44.c           |  7 +++---
 drivers/net/ethernet/broadcom/bcm63xx_enet.c  |  5 ++--
 drivers/net/ethernet/broadcom/bcmsysport.c    |  4 +--
 drivers/net/ethernet/broadcom/bgmac.c         |  8 +++---
 drivers/net/ethernet/broadcom/bnx2.c          |  6 ++---
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   |  2 +-
 .../ethernet/broadcom/bnx2x/bnx2x_ethtool.c   |  6 ++---
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  |  2 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_sriov.h |  2 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c  |  2 +-
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 12 ++++-----
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c |  2 +-
 .../net/ethernet/broadcom/genet/bcmgenet.c    |  2 +-
 drivers/net/ethernet/broadcom/tg3.c           |  6 ++---
 .../net/ethernet/brocade/bna/bnad_ethtool.c   |  6 ++---
 .../net/ethernet/cavium/octeon/octeon_mgmt.c  |  2 +-
 .../ethernet/cavium/thunder/nicvf_ethtool.c   |  4 +--
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c     |  4 +--
 .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   |  4 +--
 .../ethernet/chelsio/cxgb4/cxgb4_ethtool.c    |  4 +--
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  4 +--
 .../ethernet/chelsio/cxgb4vf/cxgb4vf_main.c   |  4 +--
 .../chelsio/inline_crypto/chtls/chtls_main.c  |  2 +-
 drivers/net/ethernet/cirrus/ep93xx_eth.c      |  2 +-
 .../net/ethernet/cisco/enic/enic_ethtool.c    |  6 ++---
 drivers/net/ethernet/davicom/dm9000.c         |  4 +--
 drivers/net/ethernet/dec/tulip/de2104x.c      |  4 +--
 drivers/net/ethernet/dec/tulip/dmfe.c         |  4 +--
 drivers/net/ethernet/dec/tulip/tulip_core.c   |  4 +--
 drivers/net/ethernet/dec/tulip/uli526x.c      |  4 +--
 drivers/net/ethernet/dec/tulip/winbond-840.c  |  4 +--
 drivers/net/ethernet/dlink/dl2k.c             |  4 +--
 drivers/net/ethernet/dlink/sundance.c         |  4 +--
 drivers/net/ethernet/dnet.c                   |  4 +--
 drivers/net/ethernet/emulex/benet/be_cmds.c   | 16 ++++++------
 .../net/ethernet/emulex/benet/be_ethtool.c    |  6 ++---
 drivers/net/ethernet/faraday/ftgmac100.c      |  5 ++--
 drivers/net/ethernet/faraday/ftmac100.c       |  5 ++--
 drivers/net/ethernet/fealnx.c                 |  4 +--
 .../ethernet/freescale/dpaa/dpaa_ethtool.c    |  5 ++--
 .../ethernet/freescale/dpaa2/dpaa2-ethtool.c  |  8 +++---
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  |  2 +-
 .../ethernet/freescale/enetc/enetc_ethtool.c  |  4 +--
 drivers/net/ethernet/freescale/fec_main.c     |  9 ++++---
 drivers/net/ethernet/freescale/fec_ptp.c      |  2 +-
 .../ethernet/freescale/fs_enet/fs_enet-main.c |  2 +-
 .../net/ethernet/freescale/gianfar_ethtool.c  |  2 +-
 .../net/ethernet/freescale/ucc_geth_ethtool.c |  4 +--
 drivers/net/ethernet/fujitsu/fmvj18x_cs.c     |  4 +--
 drivers/net/ethernet/google/gve/gve_ethtool.c |  6 ++---
 drivers/net/ethernet/hisilicon/hip04_eth.c    |  4 +--
 .../net/ethernet/huawei/hinic/hinic_ethtool.c |  4 +--
 drivers/net/ethernet/ibm/ehea/ehea_ethtool.c  |  4 +--
 drivers/net/ethernet/ibm/emac/core.c          |  4 +--
 drivers/net/ethernet/ibm/ibmveth.c            |  4 +--
 drivers/net/ethernet/ibm/ibmvnic.c            |  6 ++---
 drivers/net/ethernet/intel/e100.c             |  5 ++--
 .../net/ethernet/intel/e1000/e1000_ethtool.c  |  5 ++--
 drivers/net/ethernet/intel/e1000e/ethtool.c   |  4 +--
 drivers/net/ethernet/intel/e1000e/netdev.c    |  6 ++---
 .../net/ethernet/intel/i40e/i40e_ethtool.c    |  6 ++---
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 16 ++++++------
 drivers/net/ethernet/intel/i40e/i40e_ptp.c    |  2 +-
 .../net/ethernet/intel/iavf/iavf_ethtool.c    |  6 ++---
 drivers/net/ethernet/intel/igb/igb_ethtool.c  |  6 ++---
 drivers/net/ethernet/intel/igb/igb_main.c     |  2 +-
 drivers/net/ethernet/intel/igbvf/ethtool.c    |  4 +--
 drivers/net/ethernet/intel/igc/igc_ethtool.c  |  4 +--
 .../net/ethernet/intel/ixgb/ixgb_ethtool.c    |  5 ++--
 .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  |  6 ++---
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  4 +--
 drivers/net/ethernet/intel/ixgbevf/ethtool.c  |  4 +--
 drivers/net/ethernet/jme.c                    |  6 ++---
 drivers/net/ethernet/korina.c                 |  6 ++---
 drivers/net/ethernet/lantiq_etop.c            |  6 ++---
 drivers/net/ethernet/marvell/mv643xx_eth.c    |  8 +++---
 drivers/net/ethernet/marvell/mvneta.c         |  7 +++---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  7 +++---
 .../marvell/octeontx2/nic/otx2_ethtool.c      |  8 +++---
 .../marvell/prestera/prestera_ethtool.c       |  4 +--
 drivers/net/ethernet/marvell/pxa168_eth.c     |  8 +++---
 drivers/net/ethernet/marvell/skge.c           |  6 ++---
 drivers/net/ethernet/marvell/sky2.c           |  6 ++---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  6 +++--
 drivers/net/ethernet/mediatek/mtk_star_emac.c |  2 +-
 .../net/ethernet/mellanox/mlx4/en_ethtool.c   |  7 +++---
 drivers/net/ethernet/mellanox/mlx4/fw.c       |  3 ++-
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  7 +++---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  6 ++---
 .../mellanox/mlx5/core/ipoib/ethtool.c        |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/minimal.c |  4 +--
 .../mellanox/mlxsw/spectrum_ethtool.c         |  6 ++---
 .../net/ethernet/mellanox/mlxsw/switchx2.c    |  7 +++---
 drivers/net/ethernet/micrel/ks8851_common.c   |  6 ++---
 drivers/net/ethernet/micrel/ksz884x.c         |  6 ++---
 drivers/net/ethernet/microchip/enc28j60.c     |  8 +++---
 drivers/net/ethernet/microchip/encx24j600.c   |  6 ++---
 .../net/ethernet/microchip/lan743x_ethtool.c  |  6 ++---
 .../net/ethernet/myricom/myri10ge/myri10ge.c  |  8 +++---
 drivers/net/ethernet/natsemi/natsemi.c        |  6 ++---
 drivers/net/ethernet/natsemi/ns83820.c        |  7 +++---
 drivers/net/ethernet/neterion/s2io.c          |  6 ++---
 .../net/ethernet/neterion/vxge/vxge-ethtool.c |  8 +++---
 .../net/ethernet/neterion/vxge/vxge-main.c    |  2 +-
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  |  6 ++---
 drivers/net/ethernet/ni/nixge.c               |  4 +--
 drivers/net/ethernet/nvidia/forcedeth.c       |  6 ++---
 drivers/net/ethernet/nxp/lpc_eth.c            |  6 ++---
 .../oki-semi/pch_gbe/pch_gbe_ethtool.c        |  7 +++---
 drivers/net/ethernet/packetengines/hamachi.c  |  6 ++---
 .../net/ethernet/packetengines/yellowfin.c    |  6 ++---
 .../ethernet/pensando/ionic/ionic_ethtool.c   |  6 ++---
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  2 +-
 .../qlogic/netxen/netxen_nic_ethtool.c        |  6 ++---
 drivers/net/ethernet/qlogic/qed/qed_int.c     |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_main.c    |  2 +-
 .../net/ethernet/qlogic/qede/qede_ethtool.c   |  4 +--
 drivers/net/ethernet/qlogic/qede/qede_main.c  |  2 +-
 drivers/net/ethernet/qlogic/qla3xxx.c         |  6 ++---
 .../ethernet/qlogic/qlcnic/qlcnic_ethtool.c   |  6 ++---
 .../net/ethernet/qualcomm/emac/emac-ethtool.c |  2 +-
 drivers/net/ethernet/qualcomm/qca_debug.c     |  8 +++---
 drivers/net/ethernet/rdc/r6040.c              |  6 ++---
 drivers/net/ethernet/realtek/8139cp.c         |  6 ++---
 drivers/net/ethernet/realtek/8139too.c        |  6 ++---
 drivers/net/ethernet/realtek/r8169_main.c     |  8 +++---
 drivers/net/ethernet/rocker/rocker_main.c     |  4 +--
 .../ethernet/samsung/sxgbe/sxgbe_ethtool.c    |  4 +--
 drivers/net/ethernet/sfc/efx.c                |  2 +-
 drivers/net/ethernet/sfc/efx_common.c         |  2 +-
 drivers/net/ethernet/sfc/ethtool_common.c     |  7 +++---
 drivers/net/ethernet/sfc/falcon/efx.c         |  4 +--
 drivers/net/ethernet/sfc/falcon/ethtool.c     |  9 ++++---
 drivers/net/ethernet/sfc/falcon/falcon.c      |  2 +-
 drivers/net/ethernet/sfc/falcon/nic.c         |  2 +-
 drivers/net/ethernet/sfc/mcdi_mon.c           |  2 +-
 drivers/net/ethernet/sfc/nic.c                |  2 +-
 drivers/net/ethernet/sgi/ioc3-eth.c           |  6 ++---
 drivers/net/ethernet/sis/sis190.c             |  7 +++---
 drivers/net/ethernet/sis/sis900.c             |  6 ++---
 drivers/net/ethernet/smsc/epic100.c           |  6 ++---
 drivers/net/ethernet/smsc/smc911x.c           |  6 ++---
 drivers/net/ethernet/smsc/smc91c92_cs.c       |  4 +--
 drivers/net/ethernet/smsc/smc91x.c            |  6 ++---
 drivers/net/ethernet/smsc/smsc911x.c          |  6 ++---
 drivers/net/ethernet/smsc/smsc9420.c          |  6 ++---
 drivers/net/ethernet/socionext/netsec.c       |  4 +--
 drivers/net/ethernet/socionext/sni_ave.c      |  4 +--
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  |  9 ++++---
 drivers/net/ethernet/sun/cassini.c            |  6 ++---
 drivers/net/ethernet/sun/ldmvsw.c             |  4 +--
 drivers/net/ethernet/sun/niu.c                |  8 +++---
 drivers/net/ethernet/sun/sunbmac.c            |  4 +--
 drivers/net/ethernet/sun/sungem.c             |  6 ++---
 drivers/net/ethernet/sun/sunhme.c             |  7 +++---
 drivers/net/ethernet/sun/sunqe.c              |  4 +--
 drivers/net/ethernet/sun/sunvnet.c            |  4 +--
 .../net/ethernet/synopsys/dwc-xlgmac-common.c |  4 +--
 .../ethernet/synopsys/dwc-xlgmac-ethtool.c    |  6 ++---
 drivers/net/ethernet/tehuti/tehuti.c          |  8 +++---
 drivers/net/ethernet/ti/am65-cpsw-ethtool.c   |  4 +--
 drivers/net/ethernet/ti/cpmac.c               |  4 +--
 drivers/net/ethernet/ti/cpsw.c                |  6 ++---
 drivers/net/ethernet/ti/cpsw_new.c            |  6 ++---
 drivers/net/ethernet/ti/davinci_emac.c        |  4 +--
 drivers/net/ethernet/ti/tlan.c                |  8 +++---
 drivers/net/ethernet/toshiba/ps3_gelic_net.c  |  4 +--
 .../net/ethernet/toshiba/spider_net_ethtool.c |  8 +++---
 drivers/net/ethernet/toshiba/tc35815.c        |  6 ++---
 drivers/net/ethernet/via/via-rhine.c          |  4 +--
 drivers/net/ethernet/via/via-velocity.c       | 10 ++++----
 drivers/net/ethernet/wiznet/w5100.c           |  6 ++---
 drivers/net/ethernet/wiznet/w5300.c           |  6 ++---
 .../net/ethernet/xilinx/xilinx_axienet_main.c |  4 +--
 drivers/net/ethernet/xilinx/xilinx_emaclite.c |  2 +-
 drivers/net/ethernet/xircom/xirc2ps_cs.c      |  2 +-
 drivers/net/ethernet/xscale/ixp4xx_eth.c      |  4 +--
 drivers/net/fjes/fjes_ethtool.c               |  6 ++---
 drivers/net/geneve.c                          |  4 +--
 drivers/net/hyperv/netvsc_drv.c               |  4 +--
 drivers/net/ipvlan/ipvlan_main.c              |  4 +--
 drivers/net/macvlan.c                         |  4 +--
 drivers/net/net_failover.c                    |  4 +--
 drivers/net/netconsole.c                      | 10 ++++----
 drivers/net/ntb_netdev.c                      |  6 ++---
 drivers/net/phy/adin.c                        |  4 +--
 drivers/net/phy/bcm-phy-lib.c                 |  4 +--
 drivers/net/phy/marvell.c                     |  2 +-
 drivers/net/phy/micrel.c                      |  4 +--
 drivers/net/phy/mscc/mscc_main.c              |  4 +--
 drivers/net/phy/phy_device.c                  |  2 +-
 drivers/net/rionet.c                          |  8 +++---
 drivers/net/team/team.c                       |  4 +--
 drivers/net/tun.c                             |  8 +++---
 drivers/net/usb/aqc111.c                      |  2 +-
 drivers/net/usb/asix_common.c                 |  4 +--
 drivers/net/usb/catc.c                        |  4 +--
 drivers/net/usb/pegasus.c                     |  4 +--
 drivers/net/usb/r8152.c                       |  8 +++---
 drivers/net/usb/rtl8150.c                     |  4 +--
 drivers/net/usb/sierra_net.c                  |  4 +--
 drivers/net/usb/usbnet.c                      |  4 +--
 drivers/net/veth.c                            |  4 +--
 drivers/net/virtio_net.c                      |  6 ++---
 drivers/net/vmxnet3/vmxnet3_ethtool.c         |  6 ++---
 drivers/net/vrf.c                             |  4 +--
 drivers/net/vxlan.c                           |  4 +--
 drivers/net/wimax/i2400m/netdev.c             |  8 +++---
 drivers/net/wimax/i2400m/usb.c                |  4 +--
 drivers/net/wireless/ath/ath10k/coredump.c    |  6 ++---
 drivers/net/wireless/ath/ath10k/qmi.c         |  5 ++--
 drivers/net/wireless/ath/ath11k/qmi.c         |  6 ++---
 drivers/net/wireless/ath/ath6kl/init.c        |  4 +--
 drivers/net/wireless/ath/carl9170/fw.c        |  2 +-
 drivers/net/wireless/ath/wil6210/main.c       |  2 +-
 drivers/net/wireless/ath/wil6210/netdev.c     |  2 +-
 drivers/net/wireless/ath/wil6210/wmi.c        |  2 +-
 drivers/net/wireless/atmel/atmel.c            |  3 ++-
 drivers/net/wireless/broadcom/b43/leds.c      |  2 +-
 .../net/wireless/broadcom/b43legacy/leds.c    |  2 +-
 .../broadcom/brcm80211/brcmfmac/common.c      |  8 +++---
 .../broadcom/brcm80211/brcmfmac/core.c        |  8 +++---
 .../broadcom/brcm80211/brcmfmac/firmware.c    |  5 ++--
 .../broadcom/brcm80211/brcmfmac/fwsignal.c    |  2 +-
 drivers/net/wireless/intel/ipw2x00/ipw2100.c  |  6 ++---
 drivers/net/wireless/intel/ipw2x00/ipw2200.c  |  7 +++---
 .../net/wireless/intel/iwlegacy/3945-mac.c    |  2 +-
 .../wireless/intersil/hostap/hostap_ioctl.c   |  2 +-
 .../wireless/intersil/prism54/islpci_dev.c    |  4 +--
 .../net/wireless/marvell/libertas/ethtool.c   |  4 +--
 drivers/net/wireless/marvell/mwifiex/main.c   |  3 +--
 .../mediatek/mt76/mt7615/mt7615_trace.h       |  2 +-
 .../wireless/mediatek/mt76/mt76x02_trace.h    |  2 +-
 drivers/net/wireless/mediatek/mt76/trace.h    |  2 +-
 .../net/wireless/mediatek/mt76/usb_trace.h    |  2 +-
 drivers/net/wireless/mediatek/mt7601u/trace.h |  2 +-
 drivers/net/wireless/microchip/wilc1000/mon.c |  2 +-
 .../net/wireless/quantenna/qtnfmac/cfg80211.c |  2 +-
 .../net/wireless/quantenna/qtnfmac/commands.c |  2 +-
 .../wireless/realtek/rtl818x/rtl8187/leds.c   |  2 +-
 drivers/net/wireless/wl3501_cs.c              |  8 +++---
 drivers/nvme/host/core.c                      |  2 +-
 drivers/nvme/host/fabrics.c                   |  2 +-
 drivers/nvme/target/admin-cmd.c               |  2 +-
 drivers/nvme/target/discovery.c               |  2 +-
 drivers/of/base.c                             |  2 +-
 drivers/of/fdt.c                              |  6 ++---
 drivers/of/unittest.c                         |  2 +-
 drivers/parisc/led.c                          |  2 +-
 drivers/phy/allwinner/phy-sun4i-usb.c         |  2 +-
 drivers/platform/x86/i2c-multi-instantiate.c  |  2 +-
 .../platform/x86/intel_cht_int33fe_typec.c    |  6 ++---
 drivers/platform/x86/surface3_power.c         |  2 +-
 drivers/platform/x86/thinkpad_acpi.c          |  5 ++--
 drivers/remoteproc/qcom_sysmon.c              |  2 +-
 drivers/rpmsg/qcom_glink_ssr.c                |  2 +-
 drivers/s390/block/dasd_devmap.c              |  2 +-
 drivers/s390/block/dasd_eer.c                 |  4 +--
 drivers/s390/block/dcssblk.c                  |  2 +-
 drivers/s390/char/hmcdrv_cache.c              |  2 +-
 drivers/s390/char/tape_class.c                |  4 +--
 drivers/s390/cio/qdio_debug.c                 |  2 +-
 drivers/s390/net/ctcm_main.c                  |  2 +-
 drivers/s390/net/fsm.c                        |  2 +-
 drivers/s390/net/qeth_ethtool.c               |  4 +--
 drivers/s390/scsi/zfcp_aux.c                  |  2 +-
 drivers/s390/scsi/zfcp_fc.c                   |  2 +-
 drivers/scsi/3w-9xxx.c                        |  2 +-
 drivers/scsi/aacraid/aachba.c                 |  4 +--
 drivers/scsi/bfa/bfa_fcbuild.c                |  4 +--
 drivers/scsi/bfa/bfa_fcs.c                    |  6 ++---
 drivers/scsi/bfa/bfa_fcs_lport.c              | 25 +++++++++----------
 drivers/scsi/bfa/bfa_ioc.c                    |  2 +-
 drivers/scsi/bfa/bfa_svc.c                    |  2 +-
 drivers/scsi/bfa/bfad.c                       | 10 ++++----
 drivers/scsi/bfa/bfad_attr.c                  |  4 +--
 drivers/scsi/bfa/bfad_bsg.c                   |  6 ++---
 drivers/scsi/bfa/bfad_im.c                    |  2 +-
 drivers/scsi/bnx2i/bnx2i_init.c               |  2 +-
 drivers/scsi/fcoe/fcoe_transport.c            |  2 +-
 drivers/scsi/gdth.c                           |  6 ++---
 drivers/scsi/ibmvscsi/ibmvscsi.c              |  8 +++---
 drivers/scsi/lpfc/lpfc_attr.c                 |  6 ++---
 drivers/scsi/lpfc/lpfc_hbadisc.c              |  2 +-
 drivers/scsi/ncr53c8xx.c                      |  2 +-
 drivers/scsi/qedi/qedi_main.c                 |  2 +-
 drivers/scsi/qla2xxx/qla_init.c               | 16 ++++++------
 drivers/scsi/qla2xxx/qla_mr.c                 | 20 +++++++--------
 drivers/scsi/qla4xxx/ql4_mbx.c                |  8 +++---
 drivers/scsi/qla4xxx/ql4_os.c                 | 14 +++++------
 drivers/scsi/smartpqi/smartpqi_init.c         |  2 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c           |  2 +-
 drivers/scsi/ufs/ufs-qcom.c                   |  2 +-
 drivers/soc/fsl/qe/qe.c                       |  5 ++--
 drivers/soc/qcom/smp2p.c                      |  2 +-
 drivers/spi/spi.c                             |  4 +--
 drivers/staging/comedi/comedi_fops.c          |  4 +--
 .../staging/fsl-dpaa2/ethsw/ethsw-ethtool.c   |  6 ++---
 drivers/staging/greybus/audio_helper.c        |  2 +-
 drivers/staging/greybus/audio_module.c        |  2 +-
 drivers/staging/greybus/audio_topology.c      |  6 ++---
 drivers/staging/greybus/power_supply.c        |  2 +-
 drivers/staging/greybus/spilib.c              |  4 +--
 drivers/staging/most/sound/sound.c            |  2 +-
 drivers/staging/most/video/video.c            |  6 ++---
 drivers/staging/nvec/nvec_ps2.c               |  4 +--
 drivers/staging/octeon/ethernet-mdio.c        |  6 ++---
 drivers/staging/olpc_dcon/olpc_dcon.c         |  2 +-
 drivers/staging/qlge/qlge_ethtool.c           |  6 ++---
 .../staging/rtl8188eu/os_dep/ioctl_linux.c    |  2 +-
 .../staging/rtl8192e/rtl8192e/rtl_ethtool.c   |  6 ++---
 .../rtl8192u/ieee80211/ieee80211_softmac_wx.c |  2 +-
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c |  2 +-
 drivers/staging/sm750fb/sm750.c               |  2 +-
 .../target/iscsi/iscsi_target_parameters.c    |  4 +--
 drivers/target/iscsi/iscsi_target_util.c      | 12 ++++-----
 drivers/target/target_core_configfs.c         | 11 ++++----
 drivers/target/target_core_device.c           |  6 ++---
 drivers/target/target_core_user.c             |  4 +--
 drivers/thermal/thermal_core.c                |  4 +--
 drivers/thermal/thermal_hwmon.c               |  2 +-
 drivers/tty/hvc/hvcs.c                        |  2 +-
 drivers/tty/serial/earlycon.c                 |  6 ++---
 drivers/tty/serial/serial_core.c              |  2 +-
 drivers/tty/serial/sunsu.c                    |  6 ++---
 drivers/tty/serial/sunzilog.c                 |  9 +++----
 drivers/usb/atm/usbatm.c                      |  2 +-
 drivers/usb/core/devio.c                      |  3 +--
 drivers/usb/gadget/function/f_fs.c            |  2 +-
 drivers/usb/gadget/function/f_uvc.c           |  2 +-
 drivers/usb/gadget/function/u_audio.c         |  6 ++---
 drivers/usb/gadget/function/u_ether.c         |  8 +++---
 drivers/usb/gadget/function/uvc_v4l2.c        |  6 ++---
 drivers/usb/gadget/udc/omap_udc.c             |  2 +-
 drivers/usb/misc/usb251xb.c                   |  6 ++---
 drivers/usb/storage/onetouch.c                |  2 +-
 drivers/usb/typec/tcpm/fusb302.c              |  2 +-
 drivers/usb/usbip/stub_main.c                 |  2 +-
 drivers/video/console/sticore.c               |  2 +-
 drivers/video/fbdev/aty/atyfb_base.c          |  2 +-
 drivers/video/fbdev/aty/radeon_base.c         |  2 +-
 drivers/video/fbdev/bw2.c                     |  2 +-
 drivers/video/fbdev/cirrusfb.c                |  2 +-
 drivers/video/fbdev/clps711x-fb.c             |  2 +-
 drivers/video/fbdev/core/fbcon.c              |  2 +-
 drivers/video/fbdev/cyber2000fb.c             |  8 +++---
 drivers/video/fbdev/ffb.c                     |  2 +-
 drivers/video/fbdev/geode/gx1fb_core.c        |  8 +++---
 drivers/video/fbdev/gxt4500.c                 |  2 +-
 drivers/video/fbdev/i740fb.c                  |  2 +-
 drivers/video/fbdev/imxfb.c                   |  2 +-
 drivers/video/fbdev/matrox/matroxfb_base.c    |  7 +++---
 .../video/fbdev/omap2/omapfb/omapfb-main.c    |  2 +-
 drivers/video/fbdev/pxa168fb.c                |  2 +-
 drivers/video/fbdev/pxafb.c                   |  2 +-
 drivers/video/fbdev/s3fb.c                    |  2 +-
 drivers/video/fbdev/simplefb.c                |  2 +-
 drivers/video/fbdev/sis/sis_main.c            |  4 +--
 drivers/video/fbdev/sm501fb.c                 |  2 +-
 drivers/video/fbdev/sstfb.c                   |  2 +-
 drivers/video/fbdev/sunxvr1000.c              |  2 +-
 drivers/video/fbdev/sunxvr2500.c              |  2 +-
 drivers/video/fbdev/sunxvr500.c               |  2 +-
 drivers/video/fbdev/tcx.c                     |  2 +-
 drivers/video/fbdev/tdfxfb.c                  |  4 +--
 drivers/video/fbdev/tgafb.c                   |  2 +-
 drivers/video/fbdev/tridentfb.c               |  2 +-
 drivers/virt/vboxguest/vboxguest_core.c       |  3 +--
 drivers/w1/masters/sgi_w1.c                   |  2 +-
 drivers/xen/xen-scsiback.c                    |  2 +-
 drivers/xen/xenbus/xenbus_probe_frontend.c    |  2 +-
 fs/9p/vfs_inode.c                             |  4 +--
 fs/affs/super.c                               |  2 +-
 fs/befs/btree.c                               |  2 +-
 fs/befs/linuxvfs.c                            |  2 +-
 fs/btrfs/check-integrity.c                    |  2 +-
 fs/char_dev.c                                 |  2 +-
 fs/cifs/cifs_unicode.c                        |  2 +-
 fs/cifs/cifsroot.c                            |  2 +-
 fs/cifs/connect.c                             |  2 +-
 fs/cifs/smb2pdu.c                             |  2 +-
 fs/dlm/config.c                               |  6 ++---
 fs/exec.c                                     |  2 +-
 fs/ext4/file.c                                |  2 +-
 fs/gfs2/ops_fstype.c                          | 10 ++++----
 fs/hostfs/hostfs_kern.c                       |  2 +-
 fs/lockd/host.c                               |  2 +-
 fs/nfs/nfs4client.c                           |  2 +-
 fs/nfs/nfsroot.c                              |  4 +--
 fs/nfsd/nfs4idmap.c                           |  8 +++---
 fs/nfsd/nfssvc.c                              |  3 +--
 fs/ocfs2/dlmfs/dlmfs.c                        |  2 +-
 fs/ocfs2/stackglue.c                          |  4 +--
 fs/ocfs2/super.c                              | 10 ++++----
 fs/proc/kcore.c                               |  2 +-
 fs/reiserfs/procfs.c                          |  4 +--
 fs/super.c                                    |  4 +--
 fs/vboxsf/super.c                             |  2 +-
 include/linux/gameport.h                      |  2 +-
 include/linux/suspend.h                       |  2 +-
 include/rdma/rdma_vt.h                        |  2 +-
 include/trace/events/kyber.h                  |  8 +++---
 include/trace/events/task.h                   |  2 +-
 include/trace/events/wbt.h                    |  8 +++---
 init/do_mounts.c                              |  2 +-
 init/main.c                                   |  4 +--
 kernel/acct.c                                 |  2 +-
 kernel/cgroup/cgroup-v1.c                     |  4 +--
 kernel/events/core.c                          |  6 ++---
 kernel/kallsyms.c                             |  4 +--
 kernel/kprobes.c                              |  2 +-
 kernel/module.c                               | 13 +++++-----
 kernel/params.c                               |  2 +-
 kernel/printk/printk.c                        |  2 +-
 kernel/relay.c                                |  4 +--
 kernel/sched/fair.c                           |  6 ++---
 kernel/time/clocksource.c                     |  2 +-
 kernel/trace/ftrace.c                         | 19 +++++++-------
 kernel/trace/trace.c                          |  8 +++---
 kernel/trace/trace_boot.c                     |  8 +++---
 kernel/trace/trace_events.c                   |  2 +-
 kernel/trace/trace_events_inject.c            |  6 +++--
 kernel/trace/trace_kprobe.c                   |  2 +-
 kernel/trace/trace_probe.c                    |  2 +-
 lib/dynamic_debug.c                           |  2 +-
 lib/earlycpio.c                               |  2 +-
 mm/dmapool.c                                  |  2 +-
 mm/kasan/report.c                             |  2 +-
 mm/zswap.c                                    |  2 +-
 net/8021q/vlan_dev.c                          |  6 ++---
 net/ax25/af_ax25.c                            |  2 +-
 net/bluetooth/hidp/core.c                     |  6 ++---
 net/bridge/br_device.c                        |  8 +++---
 net/bridge/br_sysfs_if.c                      |  4 +--
 net/bridge/netfilter/ebtables.c               |  2 +-
 net/caif/caif_dev.c                           |  3 +--
 net/caif/caif_usb.c                           |  2 +-
 net/caif/cfcnfg.c                             |  4 +--
 net/caif/cfctrl.c                             |  2 +-
 net/core/dev.c                                |  6 ++---
 net/core/drop_monitor.c                       |  2 +-
 net/core/netpoll.c                            |  4 +--
 net/dsa/master.c                              |  2 +-
 net/dsa/slave.c                               |  6 ++---
 net/ethtool/ioctl.c                           |  6 ++---
 net/ieee802154/trace.h                        |  2 +-
 net/ipv4/arp.c                                |  2 +-
 net/ipv4/ip_tunnel.c                          |  4 +--
 net/ipv4/ipconfig.c                           | 10 ++++----
 net/ipv6/ip6_gre.c                            |  2 +-
 net/ipv6/ip6_tunnel.c                         |  2 +-
 net/ipv6/ip6_vti.c                            |  2 +-
 net/ipv6/sit.c                                |  2 +-
 net/l2tp/l2tp_eth.c                           |  4 +--
 net/mac80211/iface.c                          |  2 +-
 net/mac80211/trace.h                          |  2 +-
 net/mac802154/trace.h                         |  2 +-
 net/netfilter/ipset/ip_set_core.c             |  4 +--
 net/netfilter/ipset/ip_set_hash_netiface.c    |  2 +-
 net/netfilter/ipvs/ip_vs_ctl.c                |  8 +++---
 net/netfilter/nf_log.c                        |  4 +--
 net/netfilter/nf_tables_api.c                 |  2 +-
 net/netfilter/nft_osf.c                       |  2 +-
 net/netfilter/x_tables.c                      | 20 +++++++--------
 net/netfilter/xt_RATEEST.c                    |  2 +-
 net/openvswitch/vport-internal_dev.c          |  2 +-
 net/packet/af_packet.c                        |  4 +--
 net/sched/act_api.c                           |  2 +-
 net/sched/sch_api.c                           |  2 +-
 net/sched/sch_teql.c                          |  2 +-
 net/sunrpc/svc.c                              |  8 +++---
 net/sunrpc/xprtsock.c                         |  2 +-
 net/wireless/ethtool.c                        | 12 ++++-----
 net/wireless/trace.h                          |  2 +-
 samples/trace_events/trace-events-sample.h    |  2 +-
 samples/v4l/v4l2-pci-skeleton.c               | 10 ++++----
 security/integrity/ima/ima_api.c              |  2 +-
 security/keys/request_key_auth.c              |  2 +-
 sound/aoa/codecs/onyx.c                       |  2 +-
 sound/aoa/codecs/tas.c                        |  2 +-
 sound/aoa/codecs/toonie.c                     |  2 +-
 sound/aoa/core/alsa.c                         |  9 ++++---
 sound/aoa/fabrics/layout.c                    |  8 +++---
 sound/aoa/soundbus/sysfs.c                    |  2 +-
 sound/arm/aaci.c                              |  7 +++---
 sound/arm/pxa2xx-ac97.c                       |  2 +-
 sound/core/compress_offload.c                 |  2 +-
 sound/core/control.c                          | 16 ++++++------
 sound/core/ctljack.c                          |  2 +-
 sound/core/hwdep.c                            |  6 ++---
 sound/core/init.c                             |  4 +--
 sound/core/oss/mixer_oss.c                    | 19 +++++++++-----
 sound/core/pcm.c                              |  2 +-
 sound/core/pcm_native.c                       |  6 ++---
 sound/core/rawmidi.c                          |  2 +-
 sound/core/seq/oss/seq_oss_midi.c             |  4 +--
 sound/core/seq/oss/seq_oss_synth.c            |  6 ++---
 sound/core/seq/seq_clientmgr.c                |  2 +-
 sound/core/seq/seq_ports.c                    |  6 ++---
 sound/core/timer.c                            | 10 ++++----
 sound/core/timer_compat.c                     |  4 +--
 sound/drivers/opl3/opl3_oss.c                 |  2 +-
 sound/drivers/opl3/opl3_synth.c               |  2 +-
 sound/firewire/bebob/bebob_hwdep.c            |  2 +-
 sound/firewire/dice/dice-hwdep.c              |  2 +-
 sound/firewire/digi00x/digi00x-hwdep.c        |  2 +-
 sound/firewire/fireface/ff-hwdep.c            |  2 +-
 sound/firewire/fireworks/fireworks_hwdep.c    |  2 +-
 sound/firewire/motu/motu-hwdep.c              |  2 +-
 sound/firewire/oxfw/oxfw-hwdep.c              |  2 +-
 sound/firewire/tascam/tascam-hwdep.c          |  2 +-
 sound/i2c/i2c.c                               |  4 +--
 sound/isa/ad1848/ad1848.c                     |  4 +--
 sound/isa/cs423x/cs4231.c                     |  4 +--
 sound/isa/cs423x/cs4236.c                     |  4 +--
 sound/isa/es1688/es1688.c                     |  4 +--
 sound/isa/sb/sb16_csp.c                       |  3 ++-
 sound/isa/sb/sb_mixer.c                       |  2 +-
 sound/oss/dmasound/dmasound_core.c            |  4 +--
 sound/pci/cs5535audio/cs5535audio_olpc.c      |  4 +--
 sound/pci/ctxfi/ctpcm.c                       |  2 +-
 sound/pci/emu10k1/emu10k1.c                   |  4 +--
 sound/pci/emu10k1/emu10k1_main.c              |  2 +-
 sound/pci/emu10k1/emufx.c                     |  7 +++---
 sound/pci/es1968.c                            |  2 +-
 sound/pci/fm801.c                             |  2 +-
 sound/pci/hda/hda_auto_parser.c               |  2 +-
 sound/pci/hda/hda_codec.c                     |  2 +-
 sound/pci/hda/hda_controller.c                |  2 +-
 sound/pci/hda/hda_eld.c                       |  2 +-
 sound/pci/hda/hda_generic.c                   |  2 +-
 sound/pci/hda/hda_intel.c                     |  2 +-
 sound/pci/hda/hda_jack.c                      |  2 +-
 sound/pci/ice1712/juli.c                      |  2 +-
 sound/pci/ice1712/psc724.c                    |  8 +++---
 sound/pci/ice1712/quartet.c                   |  2 +-
 sound/pci/ice1712/wm8776.c                    |  2 +-
 sound/pci/lola/lola.c                         |  2 +-
 sound/pci/lola/lola_pcm.c                     |  2 +-
 sound/pci/rme9652/hdspm.c                     |  4 +--
 sound/ppc/keywest.c                           |  2 +-
 sound/soc/qcom/qdsp6/q6afe.c                  |  4 +--
 sound/soc/sh/rcar/core.c                      |  2 +-
 sound/usb/bcd2000/bcd2000.c                   |  2 +-
 sound/usb/caiaq/audio.c                       |  2 +-
 sound/usb/caiaq/device.c                      |  6 ++---
 sound/usb/caiaq/midi.c                        |  2 +-
 sound/usb/card.c                              |  4 +--
 sound/usb/hiface/chip.c                       |  8 +++---
 sound/usb/hiface/pcm.c                        |  2 +-
 sound/usb/mixer.c                             | 19 ++++++++------
 sound/usb/mixer_quirks.c                      |  3 ++-
 sound/usb/mixer_scarlett.c                    |  2 +-
 sound/usb/mixer_scarlett_gen2.c               |  2 +-
 sound/usb/mixer_us16x08.c                     |  2 +-
 sound/x86/intel_hdmi_audio.c                  |  2 +-
 sound/xen/xen_snd_front_cfg.c                 |  2 +-
 tools/perf/arch/x86/util/event.c              |  2 +-
 tools/perf/arch/x86/util/machine.c            |  2 +-
 tools/perf/builtin-buildid-cache.c            |  6 ++---
 tools/perf/jvmti/libjvmti.c                   |  2 +-
 tools/perf/ui/tui/helpline.c                  |  2 +-
 tools/perf/util/annotate.c                    |  2 +-
 tools/perf/util/auxtrace.c                    |  2 +-
 tools/perf/util/dso.c                         |  2 +-
 .../util/intel-pt-decoder/intel-pt-decoder.c  |  2 +-
 tools/perf/util/llvm-utils.c                  |  4 +--
 tools/perf/util/machine.c                     |  6 ++---
 tools/perf/util/parse-events.c                |  2 +-
 tools/perf/util/probe-file.c                  |  2 +-
 tools/perf/util/svghelper.c                   |  2 +-
 tools/perf/util/symbol.c                      |  2 +-
 tools/perf/util/synthetic-events.c            |  4 +--
 910 files changed, 1773 insertions(+), 1741 deletions(-)

diff --git a/arch/alpha/kernel/setup.c b/arch/alpha/kernel/setup.c
index 916e42d74a86..fedb950dedda 100644
--- a/arch/alpha/kernel/setup.c
+++ b/arch/alpha/kernel/setup.c
@@ -499,9 +499,10 @@ setup_arch(char **cmdline_p)
 	   boot flags depending on the boot mode, we need some shorthand.
 	   This should do for installation.  */
 	if (strcmp(COMMAND_LINE, "INSTALL") == 0) {
-		strlcpy(command_line, "root=/dev/fd0 load_ramdisk=1", sizeof command_line);
+		strscpy(command_line, "root=/dev/fd0 load_ramdisk=1",
+			sizeof command_line);
 	} else {
-		strlcpy(command_line, COMMAND_LINE, sizeof command_line);
+		strscpy(command_line, COMMAND_LINE, sizeof command_line);
 	}
 	strcpy(boot_command_line, command_line);
 	*cmdline_p = command_line;
diff --git a/arch/arm/kernel/atags_parse.c b/arch/arm/kernel/atags_parse.c
index 6c12d9fe694e..385fc7f267cc 100644
--- a/arch/arm/kernel/atags_parse.c
+++ b/arch/arm/kernel/atags_parse.c
@@ -127,7 +127,7 @@ static int __init parse_tag_cmdline(const struct tag *tag)
 #elif defined(CONFIG_CMDLINE_FORCE)
 	pr_warn("Ignoring tag cmdline (using the default kernel command line)\n");
 #else
-	strlcpy(default_command_line, tag->u.cmdline.cmdline,
+	strscpy(default_command_line, tag->u.cmdline.cmdline,
 		COMMAND_LINE_SIZE);
 #endif
 	return 0;
@@ -224,7 +224,7 @@ setup_machine_tags(phys_addr_t __atags_pointer, unsigned int machine_nr)
 	}
 
 	/* parse_early_param needs a boot_command_line */
-	strlcpy(boot_command_line, from, COMMAND_LINE_SIZE);
+	strscpy(boot_command_line, from, COMMAND_LINE_SIZE);
 
 	return mdesc;
 }
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 3f65d0ac9f63..3c30e99f7c1b 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -1110,7 +1110,7 @@ void __init setup_arch(char **cmdline_p)
 	init_mm.brk	   = (unsigned long) _end;
 
 	/* populate cmd_line too for later use, preserving boot_command_line */
-	strlcpy(cmd_line, boot_command_line, COMMAND_LINE_SIZE);
+	strscpy(cmd_line, boot_command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = cmd_line;
 
 	early_fixmap_init();
diff --git a/arch/arm/kernel/vdso.c b/arch/arm/kernel/vdso.c
index fddd08a6e063..4ca2745a07dc 100644
--- a/arch/arm/kernel/vdso.c
+++ b/arch/arm/kernel/vdso.c
@@ -144,7 +144,7 @@ static Elf32_Sym * __init find_symbol(struct elfinfo *lib, const char *symname)
 
 		if (lib->dynsym[i].st_name == 0)
 			continue;
-		strlcpy(name, lib->dynstr + lib->dynsym[i].st_name,
+		strscpy(name, lib->dynstr + lib->dynsym[i].st_name,
 			MAX_SYMNAME);
 		c = strchr(name, '@');
 		if (c)
diff --git a/arch/arm/mach-s3c/mach-mini2440.c b/arch/arm/mach-s3c/mach-mini2440.c
index dc22ab839b95..8ae37308aba4 100644
--- a/arch/arm/mach-s3c/mach-mini2440.c
+++ b/arch/arm/mach-s3c/mach-mini2440.c
@@ -620,7 +620,7 @@ static char mini2440_features_str[12] __initdata = "0tb";
 static int __init mini2440_features_setup(char *str)
 {
 	if (str)
-		strlcpy(mini2440_features_str, str,
+		strscpy(mini2440_features_str, str,
 			sizeof(mini2440_features_str));
 	return 1;
 }
diff --git a/arch/arm/mach-s3c/mach-mini6410.c b/arch/arm/mach-s3c/mach-mini6410.c
index 741fa1f09694..c14c2e27127b 100644
--- a/arch/arm/mach-s3c/mach-mini6410.c
+++ b/arch/arm/mach-s3c/mach-mini6410.c
@@ -262,7 +262,7 @@ static char mini6410_features_str[12] __initdata = "0";
 static int __init mini6410_features_setup(char *str)
 {
 	if (str)
-		strlcpy(mini6410_features_str, str,
+		strscpy(mini6410_features_str, str,
 			sizeof(mini6410_features_str));
 	return 1;
 }
diff --git a/arch/arm/mach-s3c/mach-real6410.c b/arch/arm/mach-s3c/mach-real6410.c
index 9d218a53d631..5180618fdb43 100644
--- a/arch/arm/mach-s3c/mach-real6410.c
+++ b/arch/arm/mach-s3c/mach-real6410.c
@@ -232,7 +232,7 @@ static char real6410_features_str[12] __initdata = "0";
 static int __init real6410_features_setup(char *str)
 {
 	if (str)
-		strlcpy(real6410_features_str, str,
+		strscpy(real6410_features_str, str,
 			sizeof(real6410_features_str));
 	return 1;
 }
diff --git a/arch/hexagon/kernel/setup.c b/arch/hexagon/kernel/setup.c
index 1880d9beaf2b..621674e86232 100644
--- a/arch/hexagon/kernel/setup.c
+++ b/arch/hexagon/kernel/setup.c
@@ -66,9 +66,9 @@ void __init setup_arch(char **cmdline_p)
 		on_simulator = 0;
 
 	if (p[0] != '\0')
-		strlcpy(boot_command_line, p, COMMAND_LINE_SIZE);
+		strscpy(boot_command_line, p, COMMAND_LINE_SIZE);
 	else
-		strlcpy(boot_command_line, default_command_line,
+		strscpy(boot_command_line, default_command_line,
 			COMMAND_LINE_SIZE);
 
 	/*
@@ -76,7 +76,7 @@ void __init setup_arch(char **cmdline_p)
 	 * are both picked up by the init code. If no reason to
 	 * make them different, pass the same pointer back.
 	 */
-	strlcpy(cmd_line, boot_command_line, COMMAND_LINE_SIZE);
+	strscpy(cmd_line, boot_command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = cmd_line;
 
 	parse_early_param();
diff --git a/arch/ia64/kernel/setup.c b/arch/ia64/kernel/setup.c
index dd595fbd8006..eeaebf346d12 100644
--- a/arch/ia64/kernel/setup.c
+++ b/arch/ia64/kernel/setup.c
@@ -556,7 +556,7 @@ setup_arch (char **cmdline_p)
 	ia64_patch_vtop((u64) __start___vtop_patchlist, (u64) __end___vtop_patchlist);
 
 	*cmdline_p = __va(ia64_boot_param->command_line);
-	strlcpy(boot_command_line, *cmdline_p, COMMAND_LINE_SIZE);
+	strscpy(boot_command_line, *cmdline_p, COMMAND_LINE_SIZE);
 
 	efi_init();
 	io_port_init();
diff --git a/arch/m68k/kernel/setup_mm.c b/arch/m68k/kernel/setup_mm.c
index ab8aa7be260f..cae3788b2c70 100644
--- a/arch/m68k/kernel/setup_mm.c
+++ b/arch/m68k/kernel/setup_mm.c
@@ -181,7 +181,7 @@ static void __init m68k_parse_bootinfo(const struct bi_record *record)
 			break;
 
 		case BI_COMMAND_LINE:
-			strlcpy(m68k_command_line, data,
+			strscpy(m68k_command_line, data,
 				sizeof(m68k_command_line));
 			break;
 
diff --git a/arch/microblaze/kernel/prom.c b/arch/microblaze/kernel/prom.c
index c5c6186a7e8b..e424c796e297 100644
--- a/arch/microblaze/kernel/prom.c
+++ b/arch/microblaze/kernel/prom.c
@@ -20,7 +20,7 @@ void __init early_init_devtree(void *params)
 
 	early_init_dt_scan(params);
 	if (!strlen(boot_command_line))
-		strlcpy(boot_command_line, cmd_line, COMMAND_LINE_SIZE);
+		strscpy(boot_command_line, cmd_line, COMMAND_LINE_SIZE);
 
 	memblock_allow_resize();
 
diff --git a/arch/mips/bcm47xx/board.c b/arch/mips/bcm47xx/board.c
index 35266a70e22a..74113dcd86e0 100644
--- a/arch/mips/bcm47xx/board.c
+++ b/arch/mips/bcm47xx/board.c
@@ -345,7 +345,7 @@ void __init bcm47xx_board_detect(void)
 
 	board_detected = bcm47xx_board_get_nvram();
 	bcm47xx_board.board = board_detected->board;
-	strlcpy(bcm47xx_board.name, board_detected->name,
+	strscpy(bcm47xx_board.name, board_detected->name,
 		BCM47XX_BOARD_MAX_NAME);
 }
 
diff --git a/arch/mips/kernel/prom.c b/arch/mips/kernel/prom.c
index 6abebd57b218..96dcd93b3c94 100644
--- a/arch/mips/kernel/prom.c
+++ b/arch/mips/kernel/prom.c
@@ -26,7 +26,7 @@ __init void mips_set_machine_name(const char *name)
 	if (name == NULL)
 		return;
 
-	strlcpy(mips_machine_name, name, sizeof(mips_machine_name));
+	strscpy(mips_machine_name, name, sizeof(mips_machine_name));
 	pr_info("MIPS: machine is %s\n", mips_get_machine_name());
 }
 
@@ -52,9 +52,9 @@ int __init __dt_register_buses(const char *bus0, const char *bus1)
 	if (!of_have_populated_dt())
 		panic("device tree not present");
 
-	strlcpy(of_ids[0].compatible, bus0, sizeof(of_ids[0].compatible));
+	strscpy(of_ids->compatible, bus0, sizeof(of_ids[0].compatible));
 	if (bus1) {
-		strlcpy(of_ids[1].compatible, bus1,
+		strscpy(of_ids->compatible, bus1,
 			sizeof(of_ids[1].compatible));
 	}
 
diff --git a/arch/mips/kernel/relocate.c b/arch/mips/kernel/relocate.c
index 3d80a51256de..3ef9aded6a59 100644
--- a/arch/mips/kernel/relocate.c
+++ b/arch/mips/kernel/relocate.c
@@ -313,7 +313,7 @@ void *__init relocate_kernel(void)
 	early_init_dt_scan(fdt);
 	if (boot_command_line[0]) {
 		/* Boot command line was passed in device tree */
-		strlcpy(arcs_cmdline, boot_command_line, COMMAND_LINE_SIZE);
+		strscpy(arcs_cmdline, boot_command_line, COMMAND_LINE_SIZE);
 	}
 #endif /* CONFIG_USE_OF */
 
diff --git a/arch/mips/kernel/setup.c b/arch/mips/kernel/setup.c
index ca579deef939..033e191b6ca6 100644
--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -552,7 +552,7 @@ static void __init bootcmdline_init(void)
 	 * unmodified.
 	 */
 	if (IS_ENABLED(CONFIG_CMDLINE_OVERRIDE)) {
-		strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
+		strscpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
 		return;
 	}
 
@@ -564,7 +564,7 @@ static void __init bootcmdline_init(void)
 	 * boot_command_line to undo anything early_init_dt_scan_chosen() did.
 	 */
 	if (IS_ENABLED(CONFIG_MIPS_CMDLINE_BUILTIN_EXTEND))
-		strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
+		strscpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
 	else
 		boot_command_line[0] = 0;
 
@@ -626,7 +626,7 @@ static void __init arch_mem_init(char **cmdline_p)
 	memblock_set_bottom_up(true);
 
 	bootcmdline_init();
-	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
+	strscpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = command_line;
 
 	parse_early_param();
diff --git a/arch/mips/pic32/pic32mzda/init.c b/arch/mips/pic32/pic32mzda/init.c
index 50f376f058f4..0e9473211507 100644
--- a/arch/mips/pic32/pic32mzda/init.c
+++ b/arch/mips/pic32/pic32mzda/init.c
@@ -57,7 +57,7 @@ void __init plat_mem_setup(void)
 	pr_info(" builtin_cmdline  : %s\n", CONFIG_CMDLINE);
 #endif
 	if (dtb != __dtb_start)
-		strlcpy(arcs_cmdline, boot_command_line, COMMAND_LINE_SIZE);
+		strscpy(arcs_cmdline, boot_command_line, COMMAND_LINE_SIZE);
 
 #ifdef CONFIG_EARLY_PRINTK
 	fw_init_early_console(-1);
diff --git a/arch/nios2/kernel/cpuinfo.c b/arch/nios2/kernel/cpuinfo.c
index 203870c4b86d..338849c430a5 100644
--- a/arch/nios2/kernel/cpuinfo.c
+++ b/arch/nios2/kernel/cpuinfo.c
@@ -47,7 +47,7 @@ void __init setup_cpuinfo(void)
 
 	str = of_get_property(cpu, "altr,implementation", &len);
 	if (str)
-		strlcpy(cpuinfo.cpu_impl, str, sizeof(cpuinfo.cpu_impl));
+		strscpy(cpuinfo.cpu_impl, str, sizeof(cpuinfo.cpu_impl));
 	else
 		strcpy(cpuinfo.cpu_impl, "<unknown>");
 
diff --git a/arch/nios2/kernel/setup.c b/arch/nios2/kernel/setup.c
index 3c6e3c813a0b..6431fdf88393 100644
--- a/arch/nios2/kernel/setup.c
+++ b/arch/nios2/kernel/setup.c
@@ -123,7 +123,7 @@ asmlinkage void __init nios2_boot_init(unsigned r4, unsigned r5, unsigned r6,
 		dtb_passed = r6;
 
 		if (r7)
-			strlcpy(cmdline_passed, (char *)r7, COMMAND_LINE_SIZE);
+			strscpy(cmdline_passed, (char *)r7, COMMAND_LINE_SIZE);
 	}
 #endif
 
@@ -131,10 +131,10 @@ asmlinkage void __init nios2_boot_init(unsigned r4, unsigned r5, unsigned r6,
 
 #ifndef CONFIG_CMDLINE_FORCE
 	if (cmdline_passed[0])
-		strlcpy(boot_command_line, cmdline_passed, COMMAND_LINE_SIZE);
+		strscpy(boot_command_line, cmdline_passed, COMMAND_LINE_SIZE);
 #ifdef CONFIG_NIOS2_CMDLINE_IGNORE_DTB
 	else
-		strlcpy(boot_command_line, CONFIG_CMDLINE, COMMAND_LINE_SIZE);
+		strscpy(boot_command_line, CONFIG_CMDLINE, COMMAND_LINE_SIZE);
 #endif
 #endif
 
diff --git a/arch/parisc/kernel/drivers.c b/arch/parisc/kernel/drivers.c
index 80fa0650736b..e9185bcf5575 100644
--- a/arch/parisc/kernel/drivers.c
+++ b/arch/parisc/kernel/drivers.c
@@ -537,7 +537,7 @@ alloc_pa_dev(unsigned long hpa, struct hardware_path *mod_path)
 	dev->hpa.flags = IORESOURCE_MEM;
 	name = parisc_hardware_description(&dev->id);
 	if (name) {
-		strlcpy(dev->name, name, sizeof(dev->name));
+		strscpy(dev->name, name, sizeof(dev->name));
 	}
 
 	/* Silently fail things like mouse ports which are subsumed within
diff --git a/arch/parisc/kernel/setup.c b/arch/parisc/kernel/setup.c
index e320bae501d3..9803721f82af 100644
--- a/arch/parisc/kernel/setup.c
+++ b/arch/parisc/kernel/setup.c
@@ -56,7 +56,7 @@ void __init setup_cmdline(char **cmdline_p)
 		/* called from hpux boot loader */
 		boot_command_line[0] = '\0';
 	} else {
-		strlcpy(boot_command_line, (char *)__va(boot_args[1]),
+		strscpy(boot_command_line, (char *)__va(boot_args[1]),
 			COMMAND_LINE_SIZE);
 
 #ifdef CONFIG_BLK_DEV_INITRD
diff --git a/arch/powerpc/kernel/dt_cpu_ftrs.c b/arch/powerpc/kernel/dt_cpu_ftrs.c
index 1098863e17ee..77e23824cb98 100644
--- a/arch/powerpc/kernel/dt_cpu_ftrs.c
+++ b/arch/powerpc/kernel/dt_cpu_ftrs.c
@@ -1116,7 +1116,7 @@ static int __init dt_cpu_ftrs_scan_callback(unsigned long node, const char
 
 	prop = of_get_flat_dt_prop(node, "display-name", NULL);
 	if (prop && strlen((char *)prop) != 0) {
-		strlcpy(dt_cpu_name, (char *)prop, sizeof(dt_cpu_name));
+		strscpy(dt_cpu_name, (char *)prop, sizeof(dt_cpu_name));
 		cur_cpu_spec->cpu_name = dt_cpu_name;
 	}
 
diff --git a/arch/powerpc/kernel/vdso.c b/arch/powerpc/kernel/vdso.c
index 8dad44262e75..e76acc3196bf 100644
--- a/arch/powerpc/kernel/vdso.c
+++ b/arch/powerpc/kernel/vdso.c
@@ -260,7 +260,7 @@ static Elf32_Sym * __init find_symbol32(struct lib32_elfinfo *lib,
 	for (i = 0; i < (lib->dynsymsize / sizeof(Elf32_Sym)); i++) {
 		if (lib->dynsym[i].st_name == 0)
 			continue;
-		strlcpy(name, lib->dynstr + lib->dynsym[i].st_name,
+		strscpy(name, lib->dynstr + lib->dynsym[i].st_name,
 			MAX_SYMNAME);
 		c = strchr(name, '@');
 		if (c)
@@ -366,7 +366,7 @@ static Elf64_Sym * __init find_symbol64(struct lib64_elfinfo *lib,
 	for (i = 0; i < (lib->dynsymsize / sizeof(Elf64_Sym)); i++) {
 		if (lib->dynsym[i].st_name == 0)
 			continue;
-		strlcpy(name, lib->dynstr + lib->dynsym[i].st_name,
+		strscpy(name, lib->dynstr + lib->dynsym[i].st_name,
 			MAX_SYMNAME);
 		c = strchr(name, '@');
 		if (c)
diff --git a/arch/powerpc/platforms/pasemi/misc.c b/arch/powerpc/platforms/pasemi/misc.c
index 1bf65d02d3ba..75528ea0747a 100644
--- a/arch/powerpc/platforms/pasemi/misc.c
+++ b/arch/powerpc/platforms/pasemi/misc.c
@@ -35,8 +35,7 @@ static int __init find_i2c_driver(struct device_node *node,
 	for (i = 0; i < ARRAY_SIZE(i2c_devices); i++) {
 		if (!of_device_is_compatible(node, i2c_devices[i].of_device))
 			continue;
-		if (strlcpy(info->type, i2c_devices[i].i2c_type,
-			    I2C_NAME_SIZE) >= I2C_NAME_SIZE)
+		if (strscpy(info->type, i2c_devices[i].i2c_type, I2C_NAME_SIZE) >= I2C_NAME_SIZE)
 			return -ENOMEM;
 		return 0;
 	}
diff --git a/arch/powerpc/platforms/powermac/bootx_init.c b/arch/powerpc/platforms/powermac/bootx_init.c
index 9d4ecd292255..17d95e328944 100644
--- a/arch/powerpc/platforms/powermac/bootx_init.c
+++ b/arch/powerpc/platforms/powermac/bootx_init.c
@@ -243,7 +243,7 @@ static void __init bootx_scan_dt_build_strings(unsigned long base,
 		DBG(" detected display ! adding properties names !\n");
 		bootx_dt_add_string("linux,boot-display", mem_end);
 		bootx_dt_add_string("linux,opened", mem_end);
-		strlcpy(bootx_disp_path, namep, sizeof(bootx_disp_path));
+		strscpy(bootx_disp_path, namep, sizeof(bootx_disp_path));
 	}
 
 	/* get and store all property names */
diff --git a/arch/powerpc/platforms/powernv/idle.c b/arch/powerpc/platforms/powernv/idle.c
index 1ed7c5286487..fb71228642ff 100644
--- a/arch/powerpc/platforms/powernv/idle.c
+++ b/arch/powerpc/platforms/powernv/idle.c
@@ -1447,7 +1447,7 @@ static int pnv_parse_cpuidle_dt(void)
 		goto out;
 	}
 	for (i = 0; i < nr_idle_states; i++)
-		strlcpy(pnv_idle_states[i].name, temp_string[i],
+		strscpy(pnv_idle_states->name, temp_string[i],
 			PNV_IDLE_NAME_LEN);
 	nr_pnv_idle_states = nr_idle_states;
 	rc = 0;
diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index 2b4ceb5e6ce4..37081d6ce673 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -66,7 +66,7 @@ void pe_level_printk(const struct pnv_ioda_pe *pe, const char *level,
 	vaf.va = &args;
 
 	if (pe->flags & PNV_IODA_PE_DEV)
-		strlcpy(pfix, dev_name(&pe->pdev->dev), sizeof(pfix));
+		strscpy(pfix, dev_name(&pe->pdev->dev), sizeof(pfix));
 	else if (pe->flags & (PNV_IODA_PE_BUS | PNV_IODA_PE_BUS_ALL))
 		sprintf(pfix, "%04x:%02x     ",
 			pci_domain_nr(pe->pbus), pe->pbus->number);
diff --git a/arch/powerpc/platforms/pseries/hvcserver.c b/arch/powerpc/platforms/pseries/hvcserver.c
index 96e18d3b2fcf..d48c9c7ce10f 100644
--- a/arch/powerpc/platforms/pseries/hvcserver.c
+++ b/arch/powerpc/platforms/pseries/hvcserver.c
@@ -176,7 +176,7 @@ int hvcs_get_partner_info(uint32_t unit_address, struct list_head *head,
 			= (unsigned int)last_p_partition_ID;
 
 		/* copy the Null-term char too */
-		strlcpy(&next_partner_info->location_code[0],
+		strscpy(&next_partner_info->location_code[0],
 			(char *)&pi_buff[2],
 			sizeof(next_partner_info->location_code));
 
diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
index 117f3212a8e4..f49ab699e305 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -59,7 +59,7 @@ static void __init parse_dtb(void)
 
 	pr_err("No DTB passed to the kernel\n");
 #ifdef CONFIG_CMDLINE_FORCE
-	strlcpy(boot_command_line, CONFIG_CMDLINE, COMMAND_LINE_SIZE);
+	strscpy(boot_command_line, CONFIG_CMDLINE, COMMAND_LINE_SIZE);
 	pr_info("Forcing kernel command line to: %s\n", boot_command_line);
 #endif
 }
diff --git a/arch/s390/kernel/debug.c b/arch/s390/kernel/debug.c
index b6619ae9a3e0..be40103e95e9 100644
--- a/arch/s390/kernel/debug.c
+++ b/arch/s390/kernel/debug.c
@@ -247,7 +247,7 @@ static debug_info_t *debug_info_alloc(const char *name, int pages_per_area,
 	rc->level	   = level;
 	rc->buf_size	   = buf_size;
 	rc->entry_size	   = sizeof(debug_entry_t) + buf_size;
-	strlcpy(rc->name, name, sizeof(rc->name));
+	strscpy(rc->name, name, sizeof(rc->name));
 	memset(rc->views, 0, DEBUG_MAX_VIEWS * sizeof(struct debug_view *));
 	memset(rc->debugfs_entries, 0, DEBUG_MAX_VIEWS * sizeof(struct dentry *));
 	refcount_set(&(rc->ref_count), 0);
diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
index 705844f73934..2ec078e68b38 100644
--- a/arch/s390/kernel/early.c
+++ b/arch/s390/kernel/early.c
@@ -278,7 +278,7 @@ char __bootdata(early_command_line)[COMMAND_LINE_SIZE];
 static void __init setup_boot_command_line(void)
 {
 	/* copy arch command line */
-	strlcpy(boot_command_line, early_command_line, ARCH_COMMAND_LINE_SIZE);
+	strscpy(boot_command_line, early_command_line, ARCH_COMMAND_LINE_SIZE);
 }
 
 static void __init check_image_bootable(void)
diff --git a/arch/sh/drivers/dma/dma-api.c b/arch/sh/drivers/dma/dma-api.c
index ab9170494dcc..89cd4a3b4cca 100644
--- a/arch/sh/drivers/dma/dma-api.c
+++ b/arch/sh/drivers/dma/dma-api.c
@@ -198,7 +198,7 @@ int request_dma(unsigned int chan, const char *dev_id)
 	if (atomic_xchg(&channel->busy, 1))
 		return -EBUSY;
 
-	strlcpy(channel->dev_id, dev_id, sizeof(channel->dev_id));
+	strscpy(channel->dev_id, dev_id, sizeof(channel->dev_id));
 
 	if (info->ops->request) {
 		result = info->ops->request(channel);
diff --git a/arch/sh/kernel/setup.c b/arch/sh/kernel/setup.c
index 4144be650d41..3f903e7cc26c 100644
--- a/arch/sh/kernel/setup.c
+++ b/arch/sh/kernel/setup.c
@@ -307,9 +307,9 @@ void __init setup_arch(char **cmdline_p)
 	bss_resource.end = virt_to_phys(__bss_stop)-1;
 
 #ifdef CONFIG_CMDLINE_OVERWRITE
-	strlcpy(command_line, CONFIG_CMDLINE, sizeof(command_line));
+	strscpy(command_line, CONFIG_CMDLINE, sizeof(command_line));
 #else
-	strlcpy(command_line, COMMAND_LINE, sizeof(command_line));
+	strscpy(command_line, COMMAND_LINE, sizeof(command_line));
 #ifdef CONFIG_CMDLINE_EXTEND
 	strlcat(command_line, " ", sizeof(command_line));
 	strlcat(command_line, CONFIG_CMDLINE, sizeof(command_line));
diff --git a/arch/sparc/kernel/ioport.c b/arch/sparc/kernel/ioport.c
index 8e1d72a16759..681298b7c056 100644
--- a/arch/sparc/kernel/ioport.c
+++ b/arch/sparc/kernel/ioport.c
@@ -202,7 +202,7 @@ static void __iomem *_sparc_alloc_io(unsigned int busno, unsigned long phys,
 		tack += sizeof (struct resource);
 	}
 
-	strlcpy(tack, name, XNMLN+1);
+	strscpy(tack, name, XNMLN + 1);
 	res->name = tack;
 
 	va = _sparc_ioremap(res, busno, phys, size);
diff --git a/arch/sparc/kernel/setup_32.c b/arch/sparc/kernel/setup_32.c
index eea43a1aef1b..f2d21252371b 100644
--- a/arch/sparc/kernel/setup_32.c
+++ b/arch/sparc/kernel/setup_32.c
@@ -303,7 +303,7 @@ void __init setup_arch(char **cmdline_p)
 
 	/* Initialize PROM console and command line. */
 	*cmdline_p = prom_getbootargs();
-	strlcpy(boot_command_line, *cmdline_p, COMMAND_LINE_SIZE);
+	strscpy(boot_command_line, *cmdline_p, COMMAND_LINE_SIZE);
 	parse_early_param();
 
 	boot_flags_init(*cmdline_p);
diff --git a/arch/sparc/kernel/setup_64.c b/arch/sparc/kernel/setup_64.c
index d87244197d5c..520235abb7ce 100644
--- a/arch/sparc/kernel/setup_64.c
+++ b/arch/sparc/kernel/setup_64.c
@@ -638,7 +638,7 @@ void __init setup_arch(char **cmdline_p)
 {
 	/* Initialize PROM console and command line. */
 	*cmdline_p = prom_getbootargs();
-	strlcpy(boot_command_line, *cmdline_p, COMMAND_LINE_SIZE);
+	strscpy(boot_command_line, *cmdline_p, COMMAND_LINE_SIZE);
 	parse_early_param();
 
 	boot_flags_init(*cmdline_p);
diff --git a/arch/sparc/prom/bootstr_32.c b/arch/sparc/prom/bootstr_32.c
index e3b731ff00f0..25c50a22a54e 100644
--- a/arch/sparc/prom/bootstr_32.c
+++ b/arch/sparc/prom/bootstr_32.c
@@ -52,7 +52,8 @@ prom_getbootargs(void)
 		 * V3 PROM cannot supply as with more than 128 bytes
 		 * of an argument. But a smart bootstrap loader can.
 		 */
-		strlcpy(barg_buf, *romvec->pv_v2bootargs.bootargs, sizeof(barg_buf));
+		strscpy(barg_buf, *romvec->pv_v2bootargs.bootargs,
+			sizeof(barg_buf));
 		break;
 	default:
 		break;
diff --git a/arch/um/drivers/net_kern.c b/arch/um/drivers/net_kern.c
index 1802cf4ef5a5..c348190884a0 100644
--- a/arch/um/drivers/net_kern.c
+++ b/arch/um/drivers/net_kern.c
@@ -265,7 +265,7 @@ static void uml_net_poll_controller(struct net_device *dev)
 static void uml_net_get_drvinfo(struct net_device *dev,
 				struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRIVER_NAME, sizeof(info->driver));
+	strscpy(info->driver, DRIVER_NAME, sizeof(info->driver));
 }
 
 static const struct ethtool_ops uml_net_ethtool_ops = {
diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
index 555203e3e7b4..cff31774650f 100644
--- a/arch/um/drivers/vector_kern.c
+++ b/arch/um/drivers/vector_kern.c
@@ -1379,7 +1379,7 @@ static void vector_net_poll_controller(struct net_device *dev)
 static void vector_net_get_drvinfo(struct net_device *dev,
 				struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRIVER_NAME, sizeof(info->driver));
+	strscpy(info->driver, DRIVER_NAME, sizeof(info->driver));
 }
 
 static int vector_net_load_bpf_flash(struct net_device *dev,
diff --git a/arch/um/kernel/um_arch.c b/arch/um/kernel/um_arch.c
index 76b37297b7d4..b291caa8b1ac 100644
--- a/arch/um/kernel/um_arch.c
+++ b/arch/um/kernel/um_arch.c
@@ -347,7 +347,7 @@ void __init setup_arch(char **cmdline_p)
 	read_initrd();
 
 	paging_init();
-	strlcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
+	strscpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = command_line;
 	setup_hostinfo(host_info, sizeof host_info);
 }
diff --git a/arch/um/os-Linux/drivers/tuntap_user.c b/arch/um/os-Linux/drivers/tuntap_user.c
index 53eb3d508645..2284e9c1cbbb 100644
--- a/arch/um/os-Linux/drivers/tuntap_user.c
+++ b/arch/um/os-Linux/drivers/tuntap_user.c
@@ -146,7 +146,7 @@ static int tuntap_open(void *data)
 		}
 		memset(&ifr, 0, sizeof(ifr));
 		ifr.ifr_flags = IFF_TAP | IFF_NO_PI;
-		strlcpy(ifr.ifr_name, pri->dev_name, sizeof(ifr.ifr_name));
+		strscpy(ifr.ifr_name, pri->dev_name, sizeof(ifr.ifr_name));
 		if (ioctl(pri->fd, TUNSETIFF, &ifr) < 0) {
 			err = -errno;
 			printk(UM_KERN_ERR "TUNSETIFF failed, errno = %d\n",
diff --git a/arch/um/os-Linux/umid.c b/arch/um/os-Linux/umid.c
index 1d7558dac75f..716a55dc37fd 100644
--- a/arch/um/os-Linux/umid.c
+++ b/arch/um/os-Linux/umid.c
@@ -40,7 +40,7 @@ static int __init make_uml_dir(void)
 				__func__);
 			goto err;
 		}
-		strlcpy(dir, home, sizeof(dir));
+		strscpy(dir, home, sizeof(dir));
 		uml_dir++;
 	}
 	strlcat(dir, uml_dir, sizeof(dir));
@@ -251,7 +251,7 @@ int __init set_umid(char *name)
 	if (strlen(name) > UMID_LEN - 1)
 		return -E2BIG;
 
-	strlcpy(umid, name, sizeof(umid));
+	strscpy(umid, name, sizeof(umid));
 
 	return 0;
 }
@@ -270,7 +270,7 @@ static int __init make_umid(void)
 	make_uml_dir();
 
 	if (*umid == '\0') {
-		strlcpy(tmp, uml_dir, sizeof(tmp));
+		strscpy(tmp, uml_dir, sizeof(tmp));
 		strlcat(tmp, "XXXXXX", sizeof(tmp));
 		fd = mkstemp(tmp);
 		if (fd < 0) {
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 84f581c91db4..db92478c8c59 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -891,18 +891,18 @@ void __init setup_arch(char **cmdline_p)
 
 #ifdef CONFIG_CMDLINE_BOOL
 #ifdef CONFIG_CMDLINE_OVERRIDE
-	strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
+	strscpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
 #else
 	if (builtin_cmdline[0]) {
 		/* append boot loader cmdline to builtin */
 		strlcat(builtin_cmdline, " ", COMMAND_LINE_SIZE);
 		strlcat(builtin_cmdline, boot_command_line, COMMAND_LINE_SIZE);
-		strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
+		strscpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
 	}
 #endif
 #endif
 
-	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
+	strscpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = command_line;
 
 	/*
diff --git a/arch/xtensa/kernel/setup.c b/arch/xtensa/kernel/setup.c
index ed184106e4cf..0014e41534db 100644
--- a/arch/xtensa/kernel/setup.c
+++ b/arch/xtensa/kernel/setup.c
@@ -139,7 +139,7 @@ __tagtable(BP_TAG_FDT, parse_tag_fdt);
 
 static int __init parse_tag_cmdline(const bp_tag_t* tag)
 {
-	strlcpy(command_line, (char *)(tag->data), COMMAND_LINE_SIZE);
+	strscpy(command_line, (char *)(tag->data), COMMAND_LINE_SIZE);
 	return 0;
 }
 
@@ -229,7 +229,7 @@ void __init early_init_devtree(void *params)
 	of_scan_flat_dt(xtensa_dt_io_area, NULL);
 
 	if (!command_line[0])
-		strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
+		strscpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
 }
 
 #endif /* CONFIG_OF */
@@ -259,7 +259,7 @@ void __init init_arch(bp_tag_t *bp_start)
 
 #ifdef CONFIG_CMDLINE_BOOL
 	if (!command_line[0])
-		strlcpy(command_line, default_command_line, COMMAND_LINE_SIZE);
+		strscpy(command_line, default_command_line, COMMAND_LINE_SIZE);
 #endif
 
 	/* Early hook for platforms */
@@ -331,7 +331,7 @@ void __init setup_arch(char **cmdline_p)
 
 	*cmdline_p = command_line;
 	platform_setup(cmdline_p);
-	strlcpy(boot_command_line, *cmdline_p, COMMAND_LINE_SIZE);
+	strscpy(boot_command_line, *cmdline_p, COMMAND_LINE_SIZE);
 
 	/* Reserve some memory regions */
 
diff --git a/arch/xtensa/platforms/iss/network.c b/arch/xtensa/platforms/iss/network.c
index 4986226a5ab2..e8847f8de691 100644
--- a/arch/xtensa/platforms/iss/network.c
+++ b/arch/xtensa/platforms/iss/network.c
@@ -173,7 +173,7 @@ static int tuntap_open(struct iss_net_private *lp)
 
 	memset(&ifr, 0, sizeof(ifr));
 	ifr.ifr_flags = IFF_TAP | IFF_NO_PI;
-	strlcpy(ifr.ifr_name, dev_name, sizeof(ifr.ifr_name));
+	strscpy(ifr.ifr_name, dev_name, sizeof(ifr.ifr_name));
 
 	err = simc_ioctl(fd, TUNSETIFF, &ifr);
 	if (err < 0) {
@@ -248,7 +248,7 @@ static int tuntap_probe(struct iss_net_private *lp, int index, char *init)
 		return 0;
 	}
 
-	strlcpy(lp->tp.info.tuntap.dev_name, dev_name,
+	strscpy(lp->tp.info.tuntap.dev_name, dev_name,
 		sizeof(lp->tp.info.tuntap.dev_name));
 
 	setup_etheraddr(dev, mac_str);
diff --git a/block/elevator.c b/block/elevator.c
index 293c5c81397a..28fb2bed1c26 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -738,7 +738,7 @@ static int __elevator_change(struct request_queue *q, const char *name)
 		return elevator_switch(q, NULL);
 	}
 
-	strlcpy(elevator_name, name, sizeof(elevator_name));
+	strscpy(elevator_name, name, sizeof(elevator_name));
 	e = elevator_get(q, strstrip(elevator_name), true);
 	if (!e)
 		return -EINVAL;
diff --git a/block/genhd.c b/block/genhd.c
index 9387f050c248..b01fa452fe08 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -473,7 +473,7 @@ int register_blkdev(unsigned int major, const char *name)
 	}
 
 	p->major = major;
-	strlcpy(p->name, name, sizeof(p->name));
+	strscpy(p->name, name, sizeof(p->name));
 	p->next = NULL;
 	index = major_to_index(major);
 
diff --git a/crypto/api.c b/crypto/api.c
index ed08cbd5b9d3..5105038bf7ea 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -115,7 +115,7 @@ struct crypto_larval *crypto_larval_alloc(const char *name, u32 type, u32 mask)
 	larval->alg.cra_priority = -1;
 	larval->alg.cra_destroy = crypto_larval_destroy;
 
-	strlcpy(larval->alg.cra_name, name, CRYPTO_MAX_ALG_NAME);
+	strscpy(larval->alg.cra_name, name, CRYPTO_MAX_ALG_NAME);
 	init_completion(&larval->completion);
 
 	return larval;
diff --git a/crypto/essiv.c b/crypto/essiv.c
index d012be23d496..9c8fd21297e0 100644
--- a/crypto/essiv.c
+++ b/crypto/essiv.c
@@ -542,7 +542,7 @@ static int essiv_create(struct crypto_template *tmpl, struct rtattr **tb)
 	}
 
 	/* record the driver name so we can instantiate this exact algo later */
-	strlcpy(ictx->shash_driver_name, hash_alg->base.cra_driver_name,
+	strscpy(ictx->shash_driver_name, hash_alg->base.cra_driver_name,
 		CRYPTO_MAX_ALG_NAME);
 
 	/* Instance fields */
diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 1682f8b454a2..2807e79e00d6 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -681,7 +681,7 @@ static bool acpi_of_modalias(struct acpi_device *adev,
 
 	str = obj->string.pointer;
 	chr = strchr(str, ',');
-	strlcpy(modalias, chr ? chr + 1 : str, len);
+	strscpy(modalias, chr ? chr + 1 : str, len);
 
 	return true;
 }
@@ -701,7 +701,7 @@ void acpi_set_modalias(struct acpi_device *adev, const char *default_id,
 		       char *modalias, size_t len)
 {
 	if (!acpi_of_modalias(adev, modalias, len))
-		strlcpy(modalias, default_id, len);
+		strscpy(modalias, default_id, len);
 }
 EXPORT_SYMBOL_GPL(acpi_set_modalias);
 
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index f66236cff69b..7b9770485f19 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -743,7 +743,7 @@ static int acpi_processor_setup_cstates(struct acpi_processor *pr)
 
 		state = &drv->states[count];
 		snprintf(state->name, CPUIDLE_NAME_LEN, "C%d", i);
-		strlcpy(state->desc, cx->desc, CPUIDLE_DESC_LEN);
+		strscpy(state->desc, cx->desc, CPUIDLE_DESC_LEN);
 		state->exit_latency = cx->latency;
 		state->target_residency = cx->latency * latency_factor;
 		state->enter = acpi_idle_enter;
@@ -910,7 +910,7 @@ static int acpi_processor_evaluate_lpi(acpi_handle handle,
 
 		obj = pkg_elem + 9;
 		if (obj->type == ACPI_TYPE_STRING)
-			strlcpy(lpi_state->desc, obj->string.pointer,
+			strscpy(lpi_state->desc, obj->string.pointer,
 				ACPI_CX_DESC_LEN);
 
 		lpi_state->index = state_idx;
@@ -976,7 +976,7 @@ static bool combine_lpi_states(struct acpi_lpi_state *local,
 	result->arch_flags = parent->arch_flags;
 	result->index = parent->index;
 
-	strlcpy(result->desc, local->desc, ACPI_CX_DESC_LEN);
+	strscpy(result->desc, local->desc, ACPI_CX_DESC_LEN);
 	strlcat(result->desc, "+", ACPI_CX_DESC_LEN);
 	strlcat(result->desc, parent->desc, ACPI_CX_DESC_LEN);
 	return true;
@@ -1145,7 +1145,7 @@ static int acpi_processor_setup_lpi_states(struct acpi_processor *pr)
 
 		state = &drv->states[i];
 		snprintf(state->name, CPUIDLE_NAME_LEN, "LPI-%d", i);
-		strlcpy(state->desc, lpi->desc, CPUIDLE_DESC_LEN);
+		strscpy(state->desc, lpi->desc, CPUIDLE_DESC_LEN);
 		state->exit_latency = lpi->wake_latency;
 		state->target_residency = lpi->min_residency;
 		if (lpi->arch_flags)
diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
index d5411a166685..bc7115d62d98 100644
--- a/drivers/acpi/utils.c
+++ b/drivers/acpi/utils.c
@@ -832,7 +832,7 @@ bool acpi_dev_present(const char *hid, const char *uid, s64 hrv)
 	struct acpi_dev_match_info match = {};
 	struct device *dev;
 
-	strlcpy(match.hid[0].id, hid, sizeof(match.hid[0].id));
+	strscpy(match.hid[0].id, hid, sizeof(match.hid[0].id));
 	match.uid = uid;
 	match.hrv = hrv;
 
@@ -861,7 +861,7 @@ acpi_dev_get_first_match_dev(const char *hid, const char *uid, s64 hrv)
 	struct acpi_dev_match_info match = {};
 	struct device *dev;
 
-	strlcpy(match.hid[0].id, hid, sizeof(match.hid[0].id));
+	strscpy(match.hid[0].id, hid, sizeof(match.hid[0].id));
 	match.uid = uid;
 	match.hrv = hrv;
 
@@ -879,7 +879,7 @@ EXPORT_SYMBOL(acpi_video_backlight_string);
 
 static int __init acpi_backlight(char *str)
 {
-	strlcpy(acpi_video_backlight_string, str,
+	strscpy(acpi_video_backlight_string, str,
 		sizeof(acpi_video_backlight_string));
 	return 1;
 }
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 148e81969e04..1c96299ebc43 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -756,7 +756,7 @@ static int __init save_async_options(char *buf)
 	if (strlen(buf) >= ASYNC_DRV_NAMES_MAX_LEN)
 		pr_warn("Too long list of driver names for 'driver_async_probe'!\n");
 
-	strlcpy(async_probe_drv_names, buf, ASYNC_DRV_NAMES_MAX_LEN);
+	strscpy(async_probe_drv_names, buf, ASYNC_DRV_NAMES_MAX_LEN);
 	return 0;
 }
 __setup("driver_async_probe=", save_async_options);
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index bf7de4c7b96c..9d9b972859da 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -4824,7 +4824,8 @@ void notify_helper(enum drbd_notification_type type,
 	struct drbd_genlmsghdr *dh;
 	int err;
 
-	strlcpy(helper_info.helper_name, name, sizeof(helper_info.helper_name));
+	strscpy(helper_info.helper_name, name,
+		sizeof(helper_info.helper_name));
 	helper_info.helper_name_len = min(strlen(name), sizeof(helper_info.helper_name));
 	helper_info.helper_status = status;
 
diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 153e2cdecb4d..a46f165a58a5 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -1409,15 +1409,15 @@ static void mtip_dump_identify(struct mtip_port *port)
 	if (!port->identify_valid)
 		return;
 
-	strlcpy(cbuf, (char *)(port->identify+10), 21);
+	strscpy(cbuf, (char *)(port->identify + 10), 21);
 	dev_info(&port->dd->pdev->dev,
 		"Serial No.: %s\n", cbuf);
 
-	strlcpy(cbuf, (char *)(port->identify+23), 9);
+	strscpy(cbuf, (char *)(port->identify + 23), 9);
 	dev_info(&port->dd->pdev->dev,
 		"Firmware Ver.: %s\n", cbuf);
 
-	strlcpy(cbuf, (char *)(port->identify+27), 41);
+	strscpy(cbuf, (char *)(port->identify + 27), 41);
 	dev_info(&port->dd->pdev->dev, "Model: %s\n", cbuf);
 
 	dev_info(&port->dd->pdev->dev, "Security: %04x %s\n",
@@ -1433,13 +1433,13 @@ static void mtip_dump_identify(struct mtip_port *port)
 	pci_read_config_word(port->dd->pdev, PCI_REVISION_ID, &revid);
 	switch (revid & 0xFF) {
 	case 0x1:
-		strlcpy(cbuf, "A0", 3);
+		strscpy(cbuf, "A0", 3);
 		break;
 	case 0x3:
-		strlcpy(cbuf, "A2", 3);
+		strscpy(cbuf, "A2", 3);
 		break;
 	default:
-		strlcpy(cbuf, "?", 2);
+		strscpy(cbuf, "?", 2);
 		break;
 	}
 	dev_info(&port->dd->pdev->dev,
@@ -2177,8 +2177,8 @@ static ssize_t show_device_status(struct device_driver *drv, char *buf)
 			if (dd->port &&
 			    dd->port->identify &&
 			    dd->port->identify_valid) {
-				strlcpy(id_buf,
-					(char *) (dd->port->identify + 10), 21);
+				strscpy(id_buf,
+					(char *)(dd->port->identify + 10), 21);
 				status = *(dd->port->identify + 141);
 			} else {
 				memset(id_buf, 0, 42);
@@ -2207,8 +2207,8 @@ static ssize_t show_device_status(struct device_driver *drv, char *buf)
 			if (dd->port &&
 			    dd->port->identify &&
 			    dd->port->identify_valid) {
-				strlcpy(id_buf,
-					(char *) (dd->port->identify+10), 21);
+				strscpy(id_buf,
+					(char *)(dd->port->identify + 10), 21);
 				status = *(dd->port->identify + 141);
 			} else {
 				memset(id_buf, 0, 42);
diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
index 1088798c8dd0..577773294b80 100644
--- a/drivers/block/ps3vram.c
+++ b/drivers/block/ps3vram.c
@@ -761,7 +761,7 @@ static int ps3vram_probe(struct ps3_system_bus_device *dev)
 	gendisk->fops = &ps3vram_fops;
 	gendisk->queue = queue;
 	gendisk->private_data = dev;
-	strlcpy(gendisk->disk_name, DEVICE_NAME, sizeof(gendisk->disk_name));
+	strscpy(gendisk->disk_name, DEVICE_NAME, sizeof(gendisk->disk_name));
 	set_capacity(gendisk, priv->size >> 9);
 
 	dev_info(&dev->core, "%s: Using %llu MiB of GPU memory\n",
diff --git a/drivers/block/rnbd/rnbd-clt-sysfs.c b/drivers/block/rnbd/rnbd-clt-sysfs.c
index 4f4474eecadb..128f93afb15f 100644
--- a/drivers/block/rnbd/rnbd-clt-sysfs.c
+++ b/drivers/block/rnbd/rnbd-clt-sysfs.c
@@ -97,7 +97,7 @@ static int rnbd_clt_parse_map_options(const char *buf, size_t max_path_cnt,
 				kfree(p);
 				goto out;
 			}
-			strlcpy(opt->sessname, p, NAME_MAX);
+			strscpy(opt->sessname, p, NAME_MAX);
 			kfree(p);
 			break;
 
@@ -140,7 +140,7 @@ static int rnbd_clt_parse_map_options(const char *buf, size_t max_path_cnt,
 				kfree(p);
 				goto out;
 			}
-			strlcpy(opt->pathname, p, NAME_MAX);
+			strscpy(opt->pathname, p, NAME_MAX);
 			kfree(p);
 			break;
 
@@ -473,7 +473,7 @@ static int rnbd_clt_get_path_name(struct rnbd_clt_dev *dev, char *buf,
 	int ret;
 	char pathname[NAME_MAX], *s;
 
-	strlcpy(pathname, dev->pathname, sizeof(pathname));
+	strscpy(pathname, dev->pathname, sizeof(pathname));
 	while ((s = strchr(pathname, '/')))
 		s[0] = '!';
 
diff --git a/drivers/block/rnbd/rnbd-clt.c b/drivers/block/rnbd/rnbd-clt.c
index 8b2411ccbda9..efc43e0aae7e 100644
--- a/drivers/block/rnbd/rnbd-clt.c
+++ b/drivers/block/rnbd/rnbd-clt.c
@@ -566,7 +566,7 @@ static int send_msg_open(struct rnbd_clt_dev *dev, bool wait)
 
 	msg.hdr.type	= cpu_to_le16(RNBD_MSG_OPEN);
 	msg.access_mode	= dev->access_mode;
-	strlcpy(msg.dev_name, dev->pathname, sizeof(msg.dev_name));
+	strscpy(msg.dev_name, dev->pathname, sizeof(msg.dev_name));
 
 	WARN_ON(!rnbd_clt_get_dev(dev));
 	err = send_usr_msg(sess->rtrs, READ, iu,
@@ -786,7 +786,7 @@ static struct rnbd_clt_session *alloc_sess(const char *sessname)
 	sess = kzalloc_node(sizeof(*sess), GFP_KERNEL, NUMA_NO_NODE);
 	if (!sess)
 		return ERR_PTR(-ENOMEM);
-	strlcpy(sess->sessname, sessname, sizeof(sess->sessname));
+	strscpy(sess->sessname, sessname, sizeof(sess->sessname));
 	atomic_set(&sess->busy, 0);
 	mutex_init(&sess->lock);
 	INIT_LIST_HEAD(&sess->devs_list);
@@ -1384,7 +1384,7 @@ static struct rnbd_clt_dev *init_dev(struct rnbd_clt_session *sess,
 	dev->clt_device_id	= ret;
 	dev->sess		= sess;
 	dev->access_mode	= access_mode;
-	strlcpy(dev->pathname, pathname, sizeof(dev->pathname));
+	strscpy(dev->pathname, pathname, sizeof(dev->pathname));
 	mutex_init(&dev->lock);
 	refcount_set(&dev->refcount, 1);
 	dev->dev_state = DEV_STATE_INIT;
diff --git a/drivers/block/rnbd/rnbd-srv.c b/drivers/block/rnbd/rnbd-srv.c
index e1bc8b4cd592..64f452613243 100644
--- a/drivers/block/rnbd/rnbd-srv.c
+++ b/drivers/block/rnbd/rnbd-srv.c
@@ -298,7 +298,7 @@ static int create_sess(struct rtrs_srv *rtrs)
 	mutex_unlock(&sess_lock);
 
 	srv_sess->rtrs = rtrs;
-	strlcpy(srv_sess->sessname, sessname, sizeof(srv_sess->sessname));
+	strscpy(srv_sess->sessname, sessname, sizeof(srv_sess->sessname));
 
 	rtrs_srv_set_sess_priv(rtrs, srv_sess);
 
@@ -428,7 +428,7 @@ static struct rnbd_srv_dev *rnbd_srv_init_srv_dev(const char *id)
 	if (!dev)
 		return ERR_PTR(-ENOMEM);
 
-	strlcpy(dev->id, id, sizeof(dev->id));
+	strscpy(dev->id, id, sizeof(dev->id));
 	kref_init(&dev->kref);
 	INIT_LIST_HEAD(&dev->sess_dev_list);
 	mutex_init(&dev->lock);
@@ -575,7 +575,7 @@ rnbd_srv_create_set_sess_dev(struct rnbd_srv_session *srv_sess,
 
 	kref_init(&sdev->kref);
 
-	strlcpy(sdev->pathname, open_msg->dev_name, sizeof(sdev->pathname));
+	strscpy(sdev->pathname, open_msg->dev_name, sizeof(sdev->pathname));
 
 	sdev->rnbd_dev		= rnbd_dev;
 	sdev->sess		= srv_sess;
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 1b697208d661..988da99af569 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -471,7 +471,7 @@ static ssize_t backing_dev_store(struct device *dev,
 		goto out;
 	}
 
-	strlcpy(file_name, buf, PATH_MAX);
+	strscpy(file_name, buf, PATH_MAX);
 	/* ignore trailing newline */
 	sz = strlen(file_name);
 	if (sz > 0 && file_name[sz - 1] == '\n')
@@ -994,7 +994,7 @@ static ssize_t comp_algorithm_store(struct device *dev,
 	char compressor[ARRAY_SIZE(zram->compressor)];
 	size_t sz;
 
-	strlcpy(compressor, buf, sizeof(compressor));
+	strscpy(compressor, buf, sizeof(compressor));
 	/* ignore trailing newline */
 	sz = strlen(compressor);
 	if (sz > 0 && compressor[sz - 1] == '\n')
@@ -1960,7 +1960,8 @@ static int zram_add(void)
 	blk_queue_flag_set(QUEUE_FLAG_STABLE_WRITES, zram->disk->queue);
 	device_add_disk(NULL, zram->disk, zram_disk_attr_groups);
 
-	strlcpy(zram->compressor, default_compressor, sizeof(zram->compressor));
+	strscpy(zram->compressor, default_compressor,
+		sizeof(zram->compressor));
 
 	zram_debugfs_register(zram);
 	pr_info("Added device: %s\n", zram->disk->disk_name);
diff --git a/drivers/char/ipmi/ipmi_ssif.c b/drivers/char/ipmi/ipmi_ssif.c
index 0416b9c9d410..d55d6fd537fa 100644
--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -1395,7 +1395,7 @@ static int ssif_detect(struct i2c_client *client, struct i2c_board_info *info)
 	if (rv)
 		rv = -ENODEV;
 	else
-		strlcpy(info->type, DEVICE_NAME, I2C_NAME_SIZE);
+		strscpy(info->type, DEVICE_NAME, I2C_NAME_SIZE);
 	kfree(resp);
 	return rv;
 }
diff --git a/drivers/char/tpm/tpm_ppi.c b/drivers/char/tpm/tpm_ppi.c
index b2dab941cb7f..3b29571bc95c 100644
--- a/drivers/char/tpm/tpm_ppi.c
+++ b/drivers/char/tpm/tpm_ppi.c
@@ -380,7 +380,7 @@ void tpm_add_ppi(struct tpm_chip *chip)
 				      TPM_PPI_FN_VERSION,
 				      NULL, ACPI_TYPE_STRING);
 	if (obj) {
-		strlcpy(chip->ppi_version, obj->string.pointer,
+		strscpy(chip->ppi_version, obj->string.pointer,
 			sizeof(chip->ppi_version));
 		ACPI_FREE(obj);
 	}
diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index 0f2e3fcf0f19..ee56109bc0b4 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -165,7 +165,7 @@ vclkdev_alloc(struct clk_hw *hw, const char *con_id, const char *dev_fmt,
 
 	cla->cl.clk_hw = hw;
 	if (con_id) {
-		strlcpy(cla->con_id, con_id, sizeof(cla->con_id));
+		strscpy(cla->con_id, con_id, sizeof(cla->con_id));
 		cla->cl.con_id = cla->con_id;
 	}
 
diff --git a/drivers/clk/mvebu/dove-divider.c b/drivers/clk/mvebu/dove-divider.c
index 7e35c891e168..0a90452ee808 100644
--- a/drivers/clk/mvebu/dove-divider.c
+++ b/drivers/clk/mvebu/dove-divider.c
@@ -170,7 +170,7 @@ static struct clk *clk_register_dove_divider(struct device *dev,
 		.num_parents = num_parents,
 	};
 
-	strlcpy(name, dc->name, sizeof(name));
+	strscpy(name, dc->name, sizeof(name));
 
 	dc->hw.init = &init;
 	dc->base = base;
diff --git a/drivers/clk/tegra/clk-bpmp.c b/drivers/clk/tegra/clk-bpmp.c
index a66263b6490d..14576959b81d 100644
--- a/drivers/clk/tegra/clk-bpmp.c
+++ b/drivers/clk/tegra/clk-bpmp.c
@@ -344,7 +344,7 @@ static int tegra_bpmp_clk_get_info(struct tegra_bpmp *bpmp, unsigned int id,
 	if (err < 0)
 		return err;
 
-	strlcpy(info->name, response.name, MRQ_CLK_NAME_MAXLEN);
+	strscpy(info->name, response.name, MRQ_CLK_NAME_MAXLEN);
 	info->num_parents = response.num_parents;
 
 	for (i = 0; i < info->num_parents; i++)
diff --git a/drivers/cpuidle/cpuidle-powernv.c b/drivers/cpuidle/cpuidle-powernv.c
index c32c600b3cf8..cf970c00624b 100644
--- a/drivers/cpuidle/cpuidle-powernv.c
+++ b/drivers/cpuidle/cpuidle-powernv.c
@@ -233,8 +233,8 @@ static inline void add_powernv_state(int index, const char *name,
 				     unsigned int exit_latency,
 				     u64 psscr_val, u64 psscr_mask)
 {
-	strlcpy(powernv_states[index].name, name, CPUIDLE_NAME_LEN);
-	strlcpy(powernv_states[index].desc, name, CPUIDLE_NAME_LEN);
+	strscpy(powernv_states->name, name, CPUIDLE_NAME_LEN);
+	strscpy(powernv_states->desc, name, CPUIDLE_NAME_LEN);
 	powernv_states[index].flags = flags;
 	powernv_states[index].target_residency = target_residency;
 	powernv_states[index].exit_latency = exit_latency;
diff --git a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
index 40b482198ebc..23c6edc70914 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
@@ -97,7 +97,7 @@ static int dev_supports_eng_type(struct otx_cpt_eng_grps *eng_grps,
 static void set_ucode_filename(struct otx_cpt_ucode *ucode,
 			       const char *filename)
 {
-	strlcpy(ucode->filename, filename, OTX_CPT_UCODE_NAME_LENGTH);
+	strscpy(ucode->filename, filename, OTX_CPT_UCODE_NAME_LENGTH);
 }
 
 static char *get_eng_type_str(int eng_type)
@@ -138,7 +138,7 @@ static int get_ucode_type(struct otx_cpt_ucode_hdr *ucode_hdr, int *ucode_type)
 	u32 i, val = 0;
 	u8 nn;
 
-	strlcpy(tmp_ver_str, ucode_hdr->ver_str, OTX_CPT_UCODE_VER_STR_SZ);
+	strscpy(tmp_ver_str, ucode_hdr->ver_str, OTX_CPT_UCODE_VER_STR_SZ);
 	for (i = 0; i < strlen(tmp_ver_str); i++)
 		tmp_ver_str[i] = tolower(tmp_ver_str[i]);
 
@@ -1328,7 +1328,7 @@ static ssize_t ucode_load_store(struct device *dev,
 
 	eng_grps = container_of(attr, struct otx_cpt_eng_grps, ucode_load_attr);
 	err_msg = "Invalid engine group format";
-	strlcpy(tmp_buf, buf, OTX_CPT_UCODE_NAME_LENGTH);
+	strscpy(tmp_buf, buf, OTX_CPT_UCODE_NAME_LENGTH);
 	start = tmp_buf;
 
 	has_se = has_ie = has_ae = false;
diff --git a/drivers/crypto/qat/qat_common/adf_cfg.c b/drivers/crypto/qat/qat_common/adf_cfg.c
index 22ae32838113..80c1c780c0c9 100644
--- a/drivers/crypto/qat/qat_common/adf_cfg.c
+++ b/drivers/crypto/qat/qat_common/adf_cfg.c
@@ -230,13 +230,13 @@ int adf_cfg_add_key_value_param(struct adf_accel_dev *accel_dev,
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&key_val->list);
-	strlcpy(key_val->key, key, sizeof(key_val->key));
+	strscpy(key_val->key, key, sizeof(key_val->key));
 
 	if (type == ADF_DEC) {
 		snprintf(key_val->val, ADF_CFG_MAX_VAL_LEN_IN_BYTES,
 			 "%ld", (*((long *)val)));
 	} else if (type == ADF_STR) {
-		strlcpy(key_val->val, (char *)val, sizeof(key_val->val));
+		strscpy(key_val->val, (char *)val, sizeof(key_val->val));
 	} else if (type == ADF_HEX) {
 		snprintf(key_val->val, ADF_CFG_MAX_VAL_LEN_IN_BYTES,
 			 "0x%lx", (unsigned long)val);
@@ -276,7 +276,7 @@ int adf_cfg_section_add(struct adf_accel_dev *accel_dev, const char *name)
 	if (!sec)
 		return -ENOMEM;
 
-	strlcpy(sec->name, name, sizeof(sec->name));
+	strscpy(sec->name, name, sizeof(sec->name));
 	INIT_LIST_HEAD(&sec->param_head);
 	down_write(&cfg->lock);
 	list_add_tail(&sec->list, &cfg->sec_list);
diff --git a/drivers/crypto/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
index eb9b3be9d8eb..000c62f01925 100644
--- a/drivers/crypto/qat/qat_common/adf_ctl_drv.c
+++ b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
@@ -363,7 +363,8 @@ static int adf_ctl_ioctl_get_status(struct file *fp, unsigned int cmd,
 	dev_info.num_logical_accel = hw_data->num_logical_accel;
 	dev_info.banks_per_accel = hw_data->num_banks
 					/ hw_data->num_logical_accel;
-	strlcpy(dev_info.name, hw_data->dev_class->name, sizeof(dev_info.name));
+	strscpy(dev_info.name, hw_data->dev_class->name,
+		sizeof(dev_info.name));
 	dev_info.instance_id = hw_data->instance_id;
 	dev_info.type = hw_data->dev_class->type;
 	dev_info.bus = accel_to_pci_dev(accel_dev)->bus->number;
diff --git a/drivers/crypto/qat/qat_common/adf_transport_debug.c b/drivers/crypto/qat/qat_common/adf_transport_debug.c
index dac25ba47260..faf2e53edcf6 100644
--- a/drivers/crypto/qat/qat_common/adf_transport_debug.c
+++ b/drivers/crypto/qat/qat_common/adf_transport_debug.c
@@ -95,7 +95,7 @@ int adf_ring_debugfs_add(struct adf_etr_ring_data *ring, const char *name)
 	if (!ring_debug)
 		return -ENOMEM;
 
-	strlcpy(ring_debug->ring_name, name, sizeof(ring_debug->ring_name));
+	strscpy(ring_debug->ring_name, name, sizeof(ring_debug->ring_name));
 	snprintf(entry_name, sizeof(entry_name), "ring_%02d",
 		 ring->ring_number);
 
diff --git a/drivers/dma-buf/sw_sync.c b/drivers/dma-buf/sw_sync.c
index 348b3a9170fa..63f0aeb66db6 100644
--- a/drivers/dma-buf/sw_sync.c
+++ b/drivers/dma-buf/sw_sync.c
@@ -85,7 +85,7 @@ static struct sync_timeline *sync_timeline_create(const char *name)
 
 	kref_init(&obj->kref);
 	obj->context = dma_fence_context_alloc(1);
-	strlcpy(obj->name, name, sizeof(obj->name));
+	strscpy(obj->name, name, sizeof(obj->name));
 
 	obj->pt_tree = RB_ROOT;
 	INIT_LIST_HEAD(&obj->pt_list);
diff --git a/drivers/dma-buf/sync_file.c b/drivers/dma-buf/sync_file.c
index 5a5a1da01a00..75f76a3eaa75 100644
--- a/drivers/dma-buf/sync_file.c
+++ b/drivers/dma-buf/sync_file.c
@@ -131,7 +131,7 @@ EXPORT_SYMBOL(sync_file_get_fence);
 char *sync_file_get_name(struct sync_file *sync_file, char *buf, int len)
 {
 	if (sync_file->user_name[0]) {
-		strlcpy(buf, sync_file->user_name, len);
+		strscpy(buf, sync_file->user_name, len);
 	} else {
 		struct dma_fence *fence = sync_file->fence;
 
@@ -283,7 +283,7 @@ static struct sync_file *sync_file_merge(const char *name, struct sync_file *a,
 		goto err;
 	}
 
-	strlcpy(sync_file->user_name, name, sizeof(sync_file->user_name));
+	strscpy(sync_file->user_name, name, sizeof(sync_file->user_name));
 	return sync_file;
 
 err:
@@ -378,9 +378,9 @@ static long sync_file_ioctl_merge(struct sync_file *sync_file,
 static int sync_fill_fence_info(struct dma_fence *fence,
 				 struct sync_fence_info *info)
 {
-	strlcpy(info->obj_name, fence->ops->get_timeline_name(fence),
+	strscpy(info->obj_name, fence->ops->get_timeline_name(fence),
 		sizeof(info->obj_name));
-	strlcpy(info->driver_name, fence->ops->get_driver_name(fence),
+	strscpy(info->driver_name, fence->ops->get_driver_name(fence),
 		sizeof(info->driver_name));
 
 	info->status = dma_fence_get_status(fence);
diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index a3a172173e34..6b6cbff489c8 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -1092,8 +1092,8 @@ static void add_threaded_test(struct dmatest_info *info)
 
 	/* Copy test parameters */
 	params->buf_size = test_buf_size;
-	strlcpy(params->channel, strim(test_channel), sizeof(params->channel));
-	strlcpy(params->device, strim(test_device), sizeof(params->device));
+	strscpy(params->channel, strim(test_channel), sizeof(params->channel));
+	strscpy(params->device, strim(test_device), sizeof(params->device));
 	params->threads_per_chan = threads_per_chan;
 	params->max_channels = max_channels;
 	params->iterations = iterations;
@@ -1237,7 +1237,7 @@ static int dmatest_chan_set(const char *val, const struct kernel_param *kp)
 				dtc = list_last_entry(&info->channels,
 						      struct dmatest_chan,
 						      node);
-				strlcpy(chan_reset_val,
+				strscpy(chan_reset_val,
 					dma_chan_name(dtc->chan),
 					sizeof(chan_reset_val));
 				ret = -EBUSY;
@@ -1260,14 +1260,14 @@ static int dmatest_chan_set(const char *val, const struct kernel_param *kp)
 		if ((strcmp(dma_chan_name(dtc->chan), strim(test_channel)) != 0)
 		    && (strcmp("", strim(test_channel)) != 0)) {
 			ret = -EINVAL;
-			strlcpy(chan_reset_val, dma_chan_name(dtc->chan),
+			strscpy(chan_reset_val, dma_chan_name(dtc->chan),
 				sizeof(chan_reset_val));
 			goto add_chan_err;
 		}
 
 	} else {
 		/* Clear test_channel if no channels were added successfully */
-		strlcpy(chan_reset_val, "", sizeof(chan_reset_val));
+		strscpy(chan_reset_val, "", sizeof(chan_reset_val));
 		ret = -EBUSY;
 		goto add_chan_err;
 	}
@@ -1292,7 +1292,7 @@ static int dmatest_chan_get(char *val, const struct kernel_param *kp)
 	mutex_lock(&info->lock);
 	if (!is_threaded_test_run(info) && !is_threaded_test_pending(info)) {
 		stop_threaded_test(info);
-		strlcpy(test_channel, "", sizeof(test_channel));
+		strscpy(test_channel, "", sizeof(test_channel));
 	}
 	mutex_unlock(&info->lock);
 
diff --git a/drivers/dma/xilinx/xilinx_dpdma.c b/drivers/dma/xilinx/xilinx_dpdma.c
index 55df63dead8d..7b783b596193 100644
--- a/drivers/dma/xilinx/xilinx_dpdma.c
+++ b/drivers/dma/xilinx/xilinx_dpdma.c
@@ -377,7 +377,7 @@ static ssize_t xilinx_dpdma_debugfs_read(struct file *f, char __user *buf,
 		if (ret < 0)
 			goto done;
 	} else {
-		strlcpy(kern_buff, "No testcase executed",
+		strscpy(kern_buff, "No testcase executed",
 			XILINX_DPDMA_DEBUGFS_READ_MAX_SIZE);
 	}
 
diff --git a/drivers/eisa/eisa-bus.c b/drivers/eisa/eisa-bus.c
index d9a16ba2ccc2..8c4402d1f152 100644
--- a/drivers/eisa/eisa-bus.c
+++ b/drivers/eisa/eisa-bus.c
@@ -60,8 +60,7 @@ static void __init eisa_name_device(struct eisa_device *edev)
 	int i;
 	for (i = 0; i < EISA_INFOS; i++) {
 		if (!strcmp(edev->id.sig, eisa_table[i].id.sig)) {
-			strlcpy(edev->pretty_name,
-				eisa_table[i].name,
+			strscpy(edev->pretty_name, eisa_table[i].name,
 				sizeof(edev->pretty_name));
 			return;
 		}
diff --git a/drivers/firmware/arm_scmi/base.c b/drivers/firmware/arm_scmi/base.c
index 017e5d8bd869..f863b7b5a8d3 100644
--- a/drivers/firmware/arm_scmi/base.c
+++ b/drivers/firmware/arm_scmi/base.c
@@ -234,7 +234,7 @@ static int scmi_base_discover_agent_get(const struct scmi_handle *handle,
 
 	ret = scmi_do_xfer(handle, t);
 	if (!ret)
-		strlcpy(name, t->rx.buf, SCMI_MAX_STR_SIZE);
+		strscpy(name, t->rx.buf, SCMI_MAX_STR_SIZE);
 
 	scmi_xfer_put(handle, t);
 
diff --git a/drivers/firmware/arm_scmi/clock.c b/drivers/firmware/arm_scmi/clock.c
index 4645677d86f1..41219e604185 100644
--- a/drivers/firmware/arm_scmi/clock.c
+++ b/drivers/firmware/arm_scmi/clock.c
@@ -115,7 +115,7 @@ static int scmi_clock_attributes_get(const struct scmi_handle *handle,
 
 	ret = scmi_do_xfer(handle, t);
 	if (!ret)
-		strlcpy(clk->name, attr->name, SCMI_MAX_STR_SIZE);
+		strscpy(clk->name, attr->name, SCMI_MAX_STR_SIZE);
 	else
 		clk->name[0] = '\0';
 
diff --git a/drivers/firmware/arm_scmi/perf.c b/drivers/firmware/arm_scmi/perf.c
index 82fb3babff72..e17bc72a11b9 100644
--- a/drivers/firmware/arm_scmi/perf.c
+++ b/drivers/firmware/arm_scmi/perf.c
@@ -242,7 +242,7 @@ scmi_perf_domain_attributes_get(const struct scmi_handle *handle, u32 domain,
 			dom_info->mult_factor =
 					(dom_info->sustained_freq_khz * 1000) /
 					dom_info->sustained_perf_level;
-		strlcpy(dom_info->name, attr->name, SCMI_MAX_STR_SIZE);
+		strscpy(dom_info->name, attr->name, SCMI_MAX_STR_SIZE);
 	}
 
 	scmi_xfer_put(handle, t);
diff --git a/drivers/firmware/arm_scmi/power.c b/drivers/firmware/arm_scmi/power.c
index 1f37258e9bee..23d5bfdf2434 100644
--- a/drivers/firmware/arm_scmi/power.c
+++ b/drivers/firmware/arm_scmi/power.c
@@ -118,7 +118,7 @@ scmi_power_domain_attributes_get(const struct scmi_handle *handle, u32 domain,
 		dom_info->state_set_notify = SUPPORTS_STATE_SET_NOTIFY(flags);
 		dom_info->state_set_async = SUPPORTS_STATE_SET_ASYNC(flags);
 		dom_info->state_set_sync = SUPPORTS_STATE_SET_SYNC(flags);
-		strlcpy(dom_info->name, attr->name, SCMI_MAX_STR_SIZE);
+		strscpy(dom_info->name, attr->name, SCMI_MAX_STR_SIZE);
 	}
 
 	scmi_xfer_put(handle, t);
diff --git a/drivers/firmware/arm_scmi/reset.c b/drivers/firmware/arm_scmi/reset.c
index a981a22cfe89..aaedef25afe5 100644
--- a/drivers/firmware/arm_scmi/reset.c
+++ b/drivers/firmware/arm_scmi/reset.c
@@ -112,7 +112,7 @@ scmi_reset_domain_attributes_get(const struct scmi_handle *handle, u32 domain,
 		dom_info->latency_us = le32_to_cpu(attr->latency);
 		if (dom_info->latency_us == U32_MAX)
 			dom_info->latency_us = 0;
-		strlcpy(dom_info->name, attr->name, SCMI_MAX_STR_SIZE);
+		strscpy(dom_info->name, attr->name, SCMI_MAX_STR_SIZE);
 	}
 
 	scmi_xfer_put(handle, t);
diff --git a/drivers/firmware/arm_scmi/sensors.c b/drivers/firmware/arm_scmi/sensors.c
index b4232d611033..e6d5d614847b 100644
--- a/drivers/firmware/arm_scmi/sensors.c
+++ b/drivers/firmware/arm_scmi/sensors.c
@@ -162,7 +162,8 @@ static int scmi_sensor_description_get(const struct scmi_handle *handle,
 				s->scale |= SENSOR_SCALE_EXTEND;
 			s->async = SUPPORTS_ASYNC_READ(attrl);
 			s->num_trip_points = NUM_TRIP_POINTS(attrl);
-			strlcpy(s->name, buf->desc[cnt].name, SCMI_MAX_STR_SIZE);
+			strscpy(s->name, buf->desc[cnt].name,
+				SCMI_MAX_STR_SIZE);
 		}
 
 		desc_index += num_returned;
diff --git a/drivers/gpu/drm/amd/amdgpu/atom.c b/drivers/gpu/drm/amd/amdgpu/atom.c
index 4cfc786699c7..d586f38000e3 100644
--- a/drivers/gpu/drm/amd/amdgpu/atom.c
+++ b/drivers/gpu/drm/amd/amdgpu/atom.c
@@ -1350,7 +1350,7 @@ struct atom_context *amdgpu_atom_parse(struct card_info *card, void *bios)
 	str = CSTR(idx);
 	if (*str != '\0') {
 		pr_info("ATOM BIOS: %s\n", str);
-		strlcpy(ctx->vbios_version, str, sizeof(ctx->vbios_version));
+		strscpy(ctx->vbios_version, str, sizeof(ctx->vbios_version));
 	}
 
 
diff --git a/drivers/gpu/drm/amd/pm/amdgpu_dpm.c b/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
index 17a45baff638..9924dd9fce97 100644
--- a/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
@@ -860,7 +860,7 @@ void amdgpu_add_thermal_controller(struct amdgpu_device *adev)
 				struct i2c_board_info info = { };
 				const char *name = pp_lib_thermal_controller_names[controller->ucType];
 				info.addr = controller->ucI2cAddress >> 1;
-				strlcpy(info.type, name, sizeof(info.type));
+				strscpy(info.type, name, sizeof(info.type));
 				i2c_new_client_device(&adev->pm.i2c_bus->adapter, &info);
 			}
 		} else {
diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi-ahb-audio.c b/drivers/gpu/drm/bridge/synopsys/dw-hdmi-ahb-audio.c
index d0db1acf11d7..1882cd34e757 100644
--- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi-ahb-audio.c
+++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi-ahb-audio.c
@@ -538,8 +538,8 @@ static int snd_dw_hdmi_probe(struct platform_device *pdev)
 	if (ret < 0)
 		return ret;
 
-	strlcpy(card->driver, DRIVER_NAME, sizeof(card->driver));
-	strlcpy(card->shortname, "DW-HDMI", sizeof(card->shortname));
+	strscpy(card->driver, DRIVER_NAME, sizeof(card->driver));
+	strscpy(card->shortname, "DW-HDMI", sizeof(card->shortname));
 	snprintf(card->longname, sizeof(card->longname),
 		 "%s rev 0x%02x, irq %d", card->shortname, revision,
 		 data->irq);
@@ -557,7 +557,7 @@ static int snd_dw_hdmi_probe(struct platform_device *pdev)
 
 	dw->pcm = pcm;
 	pcm->private_data = dw;
-	strlcpy(pcm->name, DRIVER_NAME, sizeof(pcm->name));
+	strscpy(pcm->name, DRIVER_NAME, sizeof(pcm->name));
 	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_PLAYBACK, &snd_dw_hdmi_ops);
 
 	/*
diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
index 0c79a9ba48bb..893a867b7e9c 100644
--- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
+++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
@@ -528,7 +528,7 @@ static struct i2c_adapter *dw_hdmi_i2c_adapter(struct dw_hdmi *hdmi)
 	adap->owner = THIS_MODULE;
 	adap->dev.parent = hdmi->dev;
 	adap->algo = &dw_hdmi_algorithm;
-	strlcpy(adap->name, "DesignWare HDMI", sizeof(adap->name));
+	strscpy(adap->name, "DesignWare HDMI", sizeof(adap->name));
 	i2c_set_adapdata(adap, hdmi);
 
 	ret = i2c_add_adapter(adap);
diff --git a/drivers/gpu/drm/drm_dp_helper.c b/drivers/gpu/drm/drm_dp_helper.c
index deeed73f4ed6..99001bddf86d 100644
--- a/drivers/gpu/drm/drm_dp_helper.c
+++ b/drivers/gpu/drm/drm_dp_helper.c
@@ -1665,7 +1665,7 @@ int drm_dp_aux_register(struct drm_dp_aux *aux)
 	aux->ddc.owner = THIS_MODULE;
 	aux->ddc.dev.parent = aux->dev;
 
-	strlcpy(aux->ddc.name, aux->name ? aux->name : dev_name(aux->dev),
+	strscpy(aux->ddc.name, aux->name ? aux->name : dev_name(aux->dev),
 		sizeof(aux->ddc.name));
 
 	ret = drm_dp_aux_register_devnode(aux);
diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index e87542533640..bc6b2acf5a28 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -5674,7 +5674,7 @@ static int drm_dp_mst_register_i2c_bus(struct drm_dp_mst_port *port)
 	aux->ddc.dev.parent = parent_dev;
 	aux->ddc.dev.of_node = parent_dev->of_node;
 
-	strlcpy(aux->ddc.name, aux->name ? aux->name : dev_name(parent_dev),
+	strscpy(aux->ddc.name, aux->name ? aux->name : dev_name(parent_dev),
 		sizeof(aux->ddc.name));
 
 	return i2c_add_adapter(&aux->ddc);
diff --git a/drivers/gpu/drm/drm_mipi_dsi.c b/drivers/gpu/drm/drm_mipi_dsi.c
index 5dd475e82995..9ff815d1c2fe 100644
--- a/drivers/gpu/drm/drm_mipi_dsi.c
+++ b/drivers/gpu/drm/drm_mipi_dsi.c
@@ -223,7 +223,7 @@ mipi_dsi_device_register_full(struct mipi_dsi_host *host,
 
 	dsi->dev.of_node = info->node;
 	dsi->channel = info->channel;
-	strlcpy(dsi->name, info->type, sizeof(dsi->name));
+	strscpy(dsi->name, info->type, sizeof(dsi->name));
 
 	ret = mipi_dsi_device_add(dsi);
 	if (ret) {
diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index b7ec6c374fbd..a4aa2508a4bf 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -1948,7 +1948,7 @@ static int tda998x_create(struct device *dev)
 	 * offset.
 	 */
 	memset(&cec_info, 0, sizeof(cec_info));
-	strlcpy(cec_info.type, "tda9950", sizeof(cec_info.type));
+	strscpy(cec_info.type, "tda9950", sizeof(cec_info.type));
 	cec_info.addr = priv->cec_addr;
 	cec_info.platform_data = &priv->cec_glue;
 	cec_info.irq = client->irq;
diff --git a/drivers/gpu/drm/i915/selftests/i915_perf.c b/drivers/gpu/drm/i915/selftests/i915_perf.c
index debbac660519..a3c14906c5e1 100644
--- a/drivers/gpu/drm/i915/selftests/i915_perf.c
+++ b/drivers/gpu/drm/i915/selftests/i915_perf.c
@@ -28,7 +28,7 @@ alloc_empty_config(struct i915_perf *perf)
 	oa_config->perf = perf;
 	kref_init(&oa_config->ref);
 
-	strlcpy(oa_config->uuid, TEST_OA_CONFIG_UUID, sizeof(oa_config->uuid));
+	strscpy(oa_config->uuid, TEST_OA_CONFIG_UUID, sizeof(oa_config->uuid));
 
 	mutex_lock(&perf->metrics_lock);
 
diff --git a/drivers/gpu/drm/mediatek/mtk_hdmi_ddc.c b/drivers/gpu/drm/mediatek/mtk_hdmi_ddc.c
index 62dbad5675bb..763a7df7f8d9 100644
--- a/drivers/gpu/drm/mediatek/mtk_hdmi_ddc.c
+++ b/drivers/gpu/drm/mediatek/mtk_hdmi_ddc.c
@@ -292,7 +292,7 @@ static int mtk_hdmi_ddc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	strlcpy(ddc->adap.name, "mediatek-hdmi-ddc", sizeof(ddc->adap.name));
+	strscpy(ddc->adap.name, "mediatek-hdmi-ddc", sizeof(ddc->adap.name));
 	ddc->adap.owner = THIS_MODULE;
 	ddc->adap.class = I2C_CLASS_DDC;
 	ddc->adap.algo = &mtk_hdmi_ddc_algorithm;
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_io_util.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_io_util.c
index 078afc5f5882..7aa8ac6f502f 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_io_util.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_io_util.c
@@ -151,7 +151,7 @@ int msm_dss_parse_clock(struct platform_device *pdev,
 				i);
 			break;
 		}
-		strlcpy(mp->clk_config[i].clk_name, clock_name,
+		strscpy(mp->clk_config[i].clk_name, clock_name,
 			sizeof(mp->clk_config[i].clk_name));
 
 		mp->clk_config[i].type = DSS_CLK_AHB;
diff --git a/drivers/gpu/drm/msm/dp/dp_parser.c b/drivers/gpu/drm/msm/dp/dp_parser.c
index 0519dd3ac3c3..82b89c2ea963 100644
--- a/drivers/gpu/drm/msm/dp/dp_parser.c
+++ b/drivers/gpu/drm/msm/dp/dp_parser.c
@@ -219,21 +219,24 @@ static int dp_parser_clock(struct dp_parser *parser)
 				core_clk_index < core_clk_count) {
 			struct dss_clk *clk =
 				&core_power->clk_config[core_clk_index];
-			strlcpy(clk->clk_name, clk_name, sizeof(clk->clk_name));
+			strscpy(clk->clk_name, clk_name,
+				sizeof(clk->clk_name));
 			clk->type = DSS_CLK_AHB;
 			core_clk_index++;
 		} else if (dp_parser_check_prefix("stream", clk_name) &&
 				stream_clk_index < stream_clk_count) {
 			struct dss_clk *clk =
 				&stream_power->clk_config[stream_clk_index];
-			strlcpy(clk->clk_name, clk_name, sizeof(clk->clk_name));
+			strscpy(clk->clk_name, clk_name,
+				sizeof(clk->clk_name));
 			clk->type = DSS_CLK_PCLK;
 			stream_clk_index++;
 		} else if (dp_parser_check_prefix("ctrl", clk_name) &&
 			   ctrl_clk_index < ctrl_clk_count) {
 			struct dss_clk *clk =
 				&ctrl_power->clk_config[ctrl_clk_index];
-			strlcpy(clk->clk_name, clk_name, sizeof(clk->clk_name));
+			strscpy(clk->clk_name, clk_name,
+				sizeof(clk->clk_name));
 			ctrl_clk_index++;
 			if (dp_parser_check_prefix("ctrl_link", clk_name) ||
 			    dp_parser_check_prefix("stream_pixel", clk_name))
diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index 5d2591725189..29c482f4f417 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -2110,7 +2110,7 @@ static int radeon_atombios_parse_power_table_1_3(struct radeon_device *rdev)
 			const char *name = thermal_controller_names[power_info->info.
 								    ucOverdriveThermalController];
 			info.addr = power_info->info.ucOverdriveControllerAddress >> 1;
-			strlcpy(info.type, name, sizeof(info.type));
+			strscpy(info.type, name, sizeof(info.type));
 			i2c_new_client_device(&rdev->pm.i2c_bus->adapter, &info);
 		}
 	}
@@ -2350,7 +2350,7 @@ static void radeon_atombios_add_pplib_thermal_controller(struct radeon_device *r
 				struct i2c_board_info info = { };
 				const char *name = pp_lib_thermal_controller_names[controller->ucType];
 				info.addr = controller->ucI2cAddress >> 1;
-				strlcpy(info.type, name, sizeof(info.type));
+				strscpy(info.type, name, sizeof(info.type));
 				i2c_new_client_device(&rdev->pm.i2c_bus->adapter, &info);
 			}
 		} else {
diff --git a/drivers/gpu/drm/radeon/radeon_combios.c b/drivers/gpu/drm/radeon/radeon_combios.c
index d3c04df7e75d..be914378b977 100644
--- a/drivers/gpu/drm/radeon/radeon_combios.c
+++ b/drivers/gpu/drm/radeon/radeon_combios.c
@@ -2703,7 +2703,7 @@ void radeon_combios_get_power_modes(struct radeon_device *rdev)
 				struct i2c_board_info info = { };
 				const char *name = thermal_controller_names[thermal_controller];
 				info.addr = i2c_addr >> 1;
-				strlcpy(info.type, name, sizeof(info.type));
+				strscpy(info.type, name, sizeof(info.type));
 				i2c_new_client_device(&rdev->pm.i2c_bus->adapter, &info);
 			}
 		}
@@ -2720,7 +2720,7 @@ void radeon_combios_get_power_modes(struct radeon_device *rdev)
 				struct i2c_board_info info = { };
 				const char *name = "f75375";
 				info.addr = 0x28;
-				strlcpy(info.type, name, sizeof(info.type));
+				strscpy(info.type, name, sizeof(info.type));
 				i2c_new_client_device(&rdev->pm.i2c_bus->adapter, &info);
 				DRM_INFO("Possible %s thermal controller at 0x%02x\n",
 					 name, info.addr);
diff --git a/drivers/gpu/drm/rockchip/inno_hdmi.c b/drivers/gpu/drm/rockchip/inno_hdmi.c
index 7afdc54eb3ec..9790989fdeee 100644
--- a/drivers/gpu/drm/rockchip/inno_hdmi.c
+++ b/drivers/gpu/drm/rockchip/inno_hdmi.c
@@ -787,7 +787,7 @@ static struct i2c_adapter *inno_hdmi_i2c_adapter(struct inno_hdmi *hdmi)
 	adap->dev.parent = hdmi->dev;
 	adap->dev.of_node = hdmi->dev->of_node;
 	adap->algo = &inno_hdmi_algorithm;
-	strlcpy(adap->name, "Inno HDMI", sizeof(adap->name));
+	strscpy(adap->name, "Inno HDMI", sizeof(adap->name));
 	i2c_set_adapdata(adap, hdmi);
 
 	ret = i2c_add_adapter(adap);
diff --git a/drivers/gpu/drm/rockchip/rk3066_hdmi.c b/drivers/gpu/drm/rockchip/rk3066_hdmi.c
index 1c546c3a8998..ece55cd65f75 100644
--- a/drivers/gpu/drm/rockchip/rk3066_hdmi.c
+++ b/drivers/gpu/drm/rockchip/rk3066_hdmi.c
@@ -719,7 +719,7 @@ static struct i2c_adapter *rk3066_hdmi_i2c_adapter(struct rk3066_hdmi *hdmi)
 	adap->dev.parent = hdmi->dev;
 	adap->dev.of_node = hdmi->dev->of_node;
 	adap->algo = &rk3066_hdmi_algorithm;
-	strlcpy(adap->name, "RK3066 HDMI", sizeof(adap->name));
+	strscpy(adap->name, "RK3066 HDMI", sizeof(adap->name));
 	i2c_set_adapdata(adap, hdmi);
 
 	ret = i2c_add_adapter(adap);
diff --git a/drivers/gpu/drm/sun4i/sun4i_hdmi_i2c.c b/drivers/gpu/drm/sun4i/sun4i_hdmi_i2c.c
index b66fa27fe6ea..f69350fc4395 100644
--- a/drivers/gpu/drm/sun4i/sun4i_hdmi_i2c.c
+++ b/drivers/gpu/drm/sun4i/sun4i_hdmi_i2c.c
@@ -304,7 +304,7 @@ int sun4i_hdmi_i2c_create(struct device *dev, struct sun4i_hdmi *hdmi)
 	adap->owner = THIS_MODULE;
 	adap->class = I2C_CLASS_DDC;
 	adap->algo = &sun4i_hdmi_i2c_algorithm;
-	strlcpy(adap->name, "sun4i_hdmi_i2c adapter", sizeof(adap->name));
+	strscpy(adap->name, "sun4i_hdmi_i2c adapter", sizeof(adap->name));
 	i2c_set_adapdata(adap, hdmi);
 
 	ret = i2c_add_adapter(adap);
diff --git a/drivers/hid/hid-steam.c b/drivers/hid/hid-steam.c
index a3b151b29bd7..90eb2a649982 100644
--- a/drivers/hid/hid-steam.c
+++ b/drivers/hid/hid-steam.c
@@ -246,7 +246,7 @@ static int steam_get_serial(struct steam_device *steam)
 	if (reply[0] != 0xae || reply[1] != 0x15 || reply[2] != 0x01)
 		return -EIO;
 	reply[3 + STEAM_SERIAL_LEN] = 0;
-	strlcpy(steam->serial_no, reply + 3, sizeof(steam->serial_no));
+	strscpy(steam->serial_no, reply + 3, sizeof(steam->serial_no));
 	return 0;
 }
 
@@ -514,8 +514,8 @@ static int steam_register(struct steam_device *steam)
 		 */
 		mutex_lock(&steam->mutex);
 		if (steam_get_serial(steam) < 0)
-			strlcpy(steam->serial_no, "XXXXXXXXXX",
-					sizeof(steam->serial_no));
+			strscpy(steam->serial_no, "XXXXXXXXXX",
+				sizeof(steam->serial_no));
 		mutex_unlock(&steam->mutex);
 
 		hid_info(steam->hdev, "Steam Controller '%s' connected",
@@ -689,10 +689,8 @@ static struct hid_device *steam_create_client_hid(struct hid_device *hdev)
 	client_hdev->version = hdev->version;
 	client_hdev->type = hdev->type;
 	client_hdev->country = hdev->country;
-	strlcpy(client_hdev->name, hdev->name,
-			sizeof(client_hdev->name));
-	strlcpy(client_hdev->phys, hdev->phys,
-			sizeof(client_hdev->phys));
+	strscpy(client_hdev->name, hdev->name, sizeof(client_hdev->name));
+	strscpy(client_hdev->phys, hdev->phys, sizeof(client_hdev->phys));
 	/*
 	 * Since we use the same device info than the real interface to
 	 * trick userspace, we will be calling steam_probe recursively.
diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index aeff1ffb0c8b..e6f1ae4c1eac 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -1131,7 +1131,7 @@ static int i2c_hid_probe(struct i2c_client *client,
 
 	snprintf(hid->name, sizeof(hid->name), "%s %04hX:%04hX",
 		 client->name, hid->vendor, hid->product);
-	strlcpy(hid->phys, dev_name(&client->dev), sizeof(hid->phys));
+	strscpy(hid->phys, dev_name(&client->dev), sizeof(hid->phys));
 
 	ihid->quirks = i2c_hid_lookup_quirk(hid->vendor, hid->product);
 
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 17a29ee0ac6c..891cfee31a02 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -1364,7 +1364,7 @@ static int usbhid_probe(struct usb_interface *intf, const struct usb_device_id *
 		hid->type = HID_TYPE_USBNONE;
 
 	if (dev->manufacturer)
-		strlcpy(hid->name, dev->manufacturer, sizeof(hid->name));
+		strscpy(hid->name, dev->manufacturer, sizeof(hid->name));
 
 	if (dev->product) {
 		if (dev->manufacturer)
diff --git a/drivers/hid/usbhid/usbkbd.c b/drivers/hid/usbhid/usbkbd.c
index d5b7a696a68c..285c87c5369f 100644
--- a/drivers/hid/usbhid/usbkbd.c
+++ b/drivers/hid/usbhid/usbkbd.c
@@ -294,7 +294,7 @@ static int usb_kbd_probe(struct usb_interface *iface,
 	spin_lock_init(&kbd->leds_lock);
 
 	if (dev->manufacturer)
-		strlcpy(kbd->name, dev->manufacturer, sizeof(kbd->name));
+		strscpy(kbd->name, dev->manufacturer, sizeof(kbd->name));
 
 	if (dev->product) {
 		if (dev->manufacturer)
diff --git a/drivers/hid/usbhid/usbmouse.c b/drivers/hid/usbhid/usbmouse.c
index 073127e65ac1..15766312163b 100644
--- a/drivers/hid/usbhid/usbmouse.c
+++ b/drivers/hid/usbhid/usbmouse.c
@@ -142,7 +142,7 @@ static int usb_mouse_probe(struct usb_interface *intf, const struct usb_device_i
 	mouse->dev = input_dev;
 
 	if (dev->manufacturer)
-		strlcpy(mouse->name, dev->manufacturer, sizeof(mouse->name));
+		strscpy(mouse->name, dev->manufacturer, sizeof(mouse->name));
 
 	if (dev->product) {
 		if (dev->manufacturer)
diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
index cd71e7133944..7c4bfac949c0 100644
--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -2197,7 +2197,7 @@ static void wacom_update_name(struct wacom *wacom, const char *suffix)
 		} else if (strstr(product_name, "Wacom") ||
 			   strstr(product_name, "wacom") ||
 			   strstr(product_name, "WACOM")) {
-			strlcpy(name, product_name, sizeof(name));
+			strscpy(name, product_name, sizeof(name));
 		} else {
 			snprintf(name, sizeof(name), "Wacom %s", product_name);
 		}
@@ -2215,7 +2215,7 @@ static void wacom_update_name(struct wacom *wacom, const char *suffix)
 		if (name[strlen(name)-1] == ' ')
 			name[strlen(name)-1] = '\0';
 	} else {
-		strlcpy(name, features->name, sizeof(name));
+		strscpy(name, features->name, sizeof(name));
 	}
 
 	snprintf(wacom_wac->name, sizeof(wacom_wac->name), "%s%s",
@@ -2471,7 +2471,7 @@ static void wacom_wireless_work(struct work_struct *work)
 				goto fail;
 		}
 
-		strlcpy(wacom_wac->name, wacom_wac1->name,
+		strscpy(wacom_wac->name, wacom_wac1->name,
 			sizeof(wacom_wac->name));
 		error = wacom_initialize_battery(wacom);
 		if (error)
diff --git a/drivers/hwmon/adc128d818.c b/drivers/hwmon/adc128d818.c
index 6c9a906631b8..71cabb23fab0 100644
--- a/drivers/hwmon/adc128d818.c
+++ b/drivers/hwmon/adc128d818.c
@@ -384,7 +384,7 @@ static int adc128_detect(struct i2c_client *client, struct i2c_board_info *info)
 	if (i2c_smbus_read_byte_data(client, ADC128_REG_BUSY_STATUS) & 0xfc)
 		return -ENODEV;
 
-	strlcpy(info->type, "adc128d818", I2C_NAME_SIZE);
+	strscpy(info->type, "adc128d818", I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/adm1021.c b/drivers/hwmon/adm1021.c
index 71deb2cd20f5..dce0657964d3 100644
--- a/drivers/hwmon/adm1021.c
+++ b/drivers/hwmon/adm1021.c
@@ -411,7 +411,7 @@ static int adm1021_detect(struct i2c_client *client,
 
 	pr_debug("Detected chip %s at adapter %d, address 0x%02x.\n",
 		 type_name, i2c_adapter_id(adapter), client->addr);
-	strlcpy(info->type, type_name, I2C_NAME_SIZE);
+	strscpy(info->type, type_name, I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/adm1025.c b/drivers/hwmon/adm1025.c
index de51e01c061b..68708dfecc63 100644
--- a/drivers/hwmon/adm1025.c
+++ b/drivers/hwmon/adm1025.c
@@ -470,7 +470,7 @@ static int adm1025_detect(struct i2c_client *client,
 	else
 		return -ENODEV;
 
-	strlcpy(info->type, name, I2C_NAME_SIZE);
+	strscpy(info->type, name, I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/adm1026.c b/drivers/hwmon/adm1026.c
index 49cefbadb156..fefeecae4bca 100644
--- a/drivers/hwmon/adm1026.c
+++ b/drivers/hwmon/adm1026.c
@@ -1610,7 +1610,7 @@ static int adm1026_detect(struct i2c_client *client,
 		return -ENODEV;
 	}
 
-	strlcpy(info->type, "adm1026", I2C_NAME_SIZE);
+	strscpy(info->type, "adm1026", I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/adm1029.c b/drivers/hwmon/adm1029.c
index 50b1df7b008c..c53db4e11788 100644
--- a/drivers/hwmon/adm1029.c
+++ b/drivers/hwmon/adm1029.c
@@ -329,7 +329,7 @@ static int adm1029_detect(struct i2c_client *client,
 		return -ENODEV;
 	}
 
-	strlcpy(info->type, "adm1029", I2C_NAME_SIZE);
+	strscpy(info->type, "adm1029", I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/adm1031.c b/drivers/hwmon/adm1031.c
index b538ace2d292..37e0d387cea0 100644
--- a/drivers/hwmon/adm1031.c
+++ b/drivers/hwmon/adm1031.c
@@ -986,7 +986,7 @@ static int adm1031_detect(struct i2c_client *client,
 		return -ENODEV;
 	name = (id == 0x30) ? "adm1030" : "adm1031";
 
-	strlcpy(info->type, name, I2C_NAME_SIZE);
+	strscpy(info->type, name, I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/adm9240.c b/drivers/hwmon/adm9240.c
index cc3e0184e720..cf85b4839052 100644
--- a/drivers/hwmon/adm9240.c
+++ b/drivers/hwmon/adm9240.c
@@ -757,7 +757,7 @@ static int adm9240_detect(struct i2c_client *new_client,
 		 man_id == 0x23 ? "ADM9240" :
 		 man_id == 0xda ? "DS1780" : "LM81", die_rev);
 
-	strlcpy(info->type, name, I2C_NAME_SIZE);
+	strscpy(info->type, name, I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/adt7411.c b/drivers/hwmon/adt7411.c
index fad74aa62b64..bf5c5618f8d0 100644
--- a/drivers/hwmon/adt7411.c
+++ b/drivers/hwmon/adt7411.c
@@ -590,7 +590,7 @@ static int adt7411_detect(struct i2c_client *client,
 		return -ENODEV;
 	}
 
-	strlcpy(info->type, "adt7411", I2C_NAME_SIZE);
+	strscpy(info->type, "adt7411", I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/adt7462.c b/drivers/hwmon/adt7462.c
index e75bbd87ad09..9c0235849d4b 100644
--- a/drivers/hwmon/adt7462.c
+++ b/drivers/hwmon/adt7462.c
@@ -1782,7 +1782,7 @@ static int adt7462_detect(struct i2c_client *client,
 	if (revision != ADT7462_REVISION)
 		return -ENODEV;
 
-	strlcpy(info->type, "adt7462", I2C_NAME_SIZE);
+	strscpy(info->type, "adt7462", I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/adt7470.c b/drivers/hwmon/adt7470.c
index 740f39a54ab0..03dee54a751d 100644
--- a/drivers/hwmon/adt7470.c
+++ b/drivers/hwmon/adt7470.c
@@ -1200,7 +1200,7 @@ static int adt7470_detect(struct i2c_client *client,
 	if (revision != ADT7470_REVISION)
 		return -ENODEV;
 
-	strlcpy(info->type, "adt7470", I2C_NAME_SIZE);
+	strscpy(info->type, "adt7470", I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/adt7475.c b/drivers/hwmon/adt7475.c
index 9d5b019651f2..6a6c22b1820f 100644
--- a/drivers/hwmon/adt7475.c
+++ b/drivers/hwmon/adt7475.c
@@ -1340,7 +1340,7 @@ static int adt7475_detect(struct i2c_client *client,
 		return -ENODEV;
 	}
 
-	strlcpy(info->type, name, I2C_NAME_SIZE);
+	strscpy(info->type, name, I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/amc6821.c b/drivers/hwmon/amc6821.c
index 6b1ce2242c61..1575030025b0 100644
--- a/drivers/hwmon/amc6821.c
+++ b/drivers/hwmon/amc6821.c
@@ -809,7 +809,7 @@ static int amc6821_detect(
 	}
 
 	dev_info(&adapter->dev, "amc6821: chip found at 0x%02x.\n", address);
-	strlcpy(info->type, "amc6821", I2C_NAME_SIZE);
+	strscpy(info->type, "amc6821", I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/asb100.c b/drivers/hwmon/asb100.c
index ba9fcf6f9264..670595c94b51 100644
--- a/drivers/hwmon/asb100.c
+++ b/drivers/hwmon/asb100.c
@@ -769,7 +769,7 @@ static int asb100_detect(struct i2c_client *client,
 	if (val1 != 0x31 || val2 != 0x06)
 		return -ENODEV;
 
-	strlcpy(info->type, "asb100", I2C_NAME_SIZE);
+	strscpy(info->type, "asb100", I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/asc7621.c b/drivers/hwmon/asc7621.c
index 600ffc7e1900..8bff43408fb5 100644
--- a/drivers/hwmon/asc7621.c
+++ b/drivers/hwmon/asc7621.c
@@ -1153,7 +1153,7 @@ static int asc7621_detect(struct i2c_client *client,
 
 		if (company == asc7621_chips[chip_index].company_id &&
 		    verstep == asc7621_chips[chip_index].verstep_id) {
-			strlcpy(info->type, asc7621_chips[chip_index].name,
+			strscpy(info->type, asc7621_chips[chip_index].name,
 				I2C_NAME_SIZE);
 
 			dev_info(&adapter->dev, "Matched %s at 0x%02x\n",
diff --git a/drivers/hwmon/dell-smm-hwmon.c b/drivers/hwmon/dell-smm-hwmon.c
index ec448f5f2dc3..d78e8f044d65 100644
--- a/drivers/hwmon/dell-smm-hwmon.c
+++ b/drivers/hwmon/dell-smm-hwmon.c
@@ -465,7 +465,7 @@ i8k_ioctl_unlocked(struct file *fp, unsigned int cmd, unsigned long arg)
 			return -EPERM;
 
 		memset(buff, 0, sizeof(buff));
-		strlcpy(buff, bios_machineid, sizeof(buff));
+		strscpy(buff, bios_machineid, sizeof(buff));
 		break;
 
 	case I8K_FN_STATUS:
@@ -1240,9 +1240,9 @@ static int __init i8k_probe(void)
 			disallow_fan_type_call = true;
 	}
 
-	strlcpy(bios_version, i8k_get_dmi_data(DMI_BIOS_VERSION),
+	strscpy(bios_version, i8k_get_dmi_data(DMI_BIOS_VERSION),
 		sizeof(bios_version));
-	strlcpy(bios_machineid, i8k_get_dmi_data(DMI_PRODUCT_SERIAL),
+	strscpy(bios_machineid, i8k_get_dmi_data(DMI_PRODUCT_SERIAL),
 		sizeof(bios_machineid));
 
 	/*
diff --git a/drivers/hwmon/dme1737.c b/drivers/hwmon/dme1737.c
index c1e4cfb40c3d..78c5b4be3ef3 100644
--- a/drivers/hwmon/dme1737.c
+++ b/drivers/hwmon/dme1737.c
@@ -2456,7 +2456,7 @@ static int dme1737_i2c_detect(struct i2c_client *client,
 	dev_info(dev, "Found a %s chip at 0x%02x (rev 0x%02x).\n",
 		 verstep == SCH5027_VERSTEP ? "SCH5027" : "DME1737",
 		 client->addr, verstep);
-	strlcpy(info->type, name, I2C_NAME_SIZE);
+	strscpy(info->type, name, I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/emc1403.c b/drivers/hwmon/emc1403.c
index 314838272049..61d59189a6d1 100644
--- a/drivers/hwmon/emc1403.c
+++ b/drivers/hwmon/emc1403.c
@@ -329,22 +329,22 @@ static int emc1403_detect(struct i2c_client *client,
 	id = i2c_smbus_read_byte_data(client, THERMAL_PID_REG);
 	switch (id) {
 	case 0x20:
-		strlcpy(info->type, "emc1402", I2C_NAME_SIZE);
+		strscpy(info->type, "emc1402", I2C_NAME_SIZE);
 		break;
 	case 0x21:
-		strlcpy(info->type, "emc1403", I2C_NAME_SIZE);
+		strscpy(info->type, "emc1403", I2C_NAME_SIZE);
 		break;
 	case 0x22:
-		strlcpy(info->type, "emc1422", I2C_NAME_SIZE);
+		strscpy(info->type, "emc1422", I2C_NAME_SIZE);
 		break;
 	case 0x23:
-		strlcpy(info->type, "emc1423", I2C_NAME_SIZE);
+		strscpy(info->type, "emc1423", I2C_NAME_SIZE);
 		break;
 	case 0x25:
-		strlcpy(info->type, "emc1404", I2C_NAME_SIZE);
+		strscpy(info->type, "emc1404", I2C_NAME_SIZE);
 		break;
 	case 0x27:
-		strlcpy(info->type, "emc1424", I2C_NAME_SIZE);
+		strscpy(info->type, "emc1424", I2C_NAME_SIZE);
 		break;
 	default:
 		return -ENODEV;
diff --git a/drivers/hwmon/emc2103.c b/drivers/hwmon/emc2103.c
index e4c95ca9e19f..361cf9292456 100644
--- a/drivers/hwmon/emc2103.c
+++ b/drivers/hwmon/emc2103.c
@@ -643,7 +643,7 @@ emc2103_detect(struct i2c_client *new_client, struct i2c_board_info *info)
 	if ((product != 0x24) && (product != 0x26))
 		return -ENODEV;
 
-	strlcpy(info->type, "emc2103", I2C_NAME_SIZE);
+	strscpy(info->type, "emc2103", I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/emc6w201.c b/drivers/hwmon/emc6w201.c
index ec5c98702bf5..1a1527da5a8b 100644
--- a/drivers/hwmon/emc6w201.c
+++ b/drivers/hwmon/emc6w201.c
@@ -439,7 +439,7 @@ static int emc6w201_detect(struct i2c_client *client,
 		return -ENODEV;
 	}
 
-	strlcpy(info->type, "emc6w201", I2C_NAME_SIZE);
+	strscpy(info->type, "emc6w201", I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/f75375s.c b/drivers/hwmon/f75375s.c
index 3e567be60fb1..f9e2804f7b4b 100644
--- a/drivers/hwmon/f75375s.c
+++ b/drivers/hwmon/f75375s.c
@@ -897,7 +897,7 @@ static int f75375_detect(struct i2c_client *client,
 
 	version = f75375_read8(client, F75375_REG_VERSION);
 	dev_info(&adapter->dev, "found %s version: %02X\n", name, version);
-	strlcpy(info->type, name, I2C_NAME_SIZE);
+	strscpy(info->type, name, I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/fschmd.c b/drivers/hwmon/fschmd.c
index 5191cd85a8d1..9f342ac2c09c 100644
--- a/drivers/hwmon/fschmd.c
+++ b/drivers/hwmon/fschmd.c
@@ -1075,7 +1075,7 @@ static int fschmd_detect(struct i2c_client *client,
 	else
 		return -ENODEV;
 
-	strlcpy(info->type, fschmd_id[kind].name, I2C_NAME_SIZE);
+	strscpy(info->type, fschmd_id[kind].name, I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/ftsteutates.c b/drivers/hwmon/ftsteutates.c
index ef88a156efc2..e7bb61324755 100644
--- a/drivers/hwmon/ftsteutates.c
+++ b/drivers/hwmon/ftsteutates.c
@@ -739,7 +739,7 @@ static int fts_detect(struct i2c_client *client,
 	if (val != 0x11)
 		return -ENODEV;
 
-	strlcpy(info->type, fts_id[0].name, I2C_NAME_SIZE);
+	strscpy(info->type, fts_id[0].name, I2C_NAME_SIZE);
 	info->flags = 0;
 	return 0;
 }
diff --git a/drivers/hwmon/gl518sm.c b/drivers/hwmon/gl518sm.c
index 7aaee5a48243..b4f925e92a67 100644
--- a/drivers/hwmon/gl518sm.c
+++ b/drivers/hwmon/gl518sm.c
@@ -586,7 +586,7 @@ static int gl518_detect(struct i2c_client *client, struct i2c_board_info *info)
 	if (rev != 0x00 && rev != 0x80)
 		return -ENODEV;
 
-	strlcpy(info->type, "gl518sm", I2C_NAME_SIZE);
+	strscpy(info->type, "gl518sm", I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/gl520sm.c b/drivers/hwmon/gl520sm.c
index 4ae1295cc3ea..00bf135a96a0 100644
--- a/drivers/hwmon/gl520sm.c
+++ b/drivers/hwmon/gl520sm.c
@@ -811,7 +811,7 @@ static int gl520_detect(struct i2c_client *client, struct i2c_board_info *info)
 		return -ENODEV;
 	}
 
-	strlcpy(info->type, "gl520sm", I2C_NAME_SIZE);
+	strscpy(info->type, "gl520sm", I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/jc42.c b/drivers/hwmon/jc42.c
index 4a03d010ec5a..8ea3a2db0c27 100644
--- a/drivers/hwmon/jc42.c
+++ b/drivers/hwmon/jc42.c
@@ -431,7 +431,7 @@ static int jc42_detect(struct i2c_client *client, struct i2c_board_info *info)
 		struct jc42_chips *chip = &jc42_chips[i];
 		if (manid == chip->manid &&
 		    (devid & chip->devid_mask) == chip->devid) {
-			strlcpy(info->type, "jc42", I2C_NAME_SIZE);
+			strscpy(info->type, "jc42", I2C_NAME_SIZE);
 			return 0;
 		}
 	}
diff --git a/drivers/hwmon/lm63.c b/drivers/hwmon/lm63.c
index 50f67265c71d..1b25d476c38a 100644
--- a/drivers/hwmon/lm63.c
+++ b/drivers/hwmon/lm63.c
@@ -996,11 +996,11 @@ static int lm63_detect(struct i2c_client *client,
 	}
 
 	if (chip_id == 0x41 && address == 0x4c)
-		strlcpy(info->type, "lm63", I2C_NAME_SIZE);
+		strscpy(info->type, "lm63", I2C_NAME_SIZE);
 	else if (chip_id == 0x51 && (address == 0x18 || address == 0x4e))
-		strlcpy(info->type, "lm64", I2C_NAME_SIZE);
+		strscpy(info->type, "lm64", I2C_NAME_SIZE);
 	else if (chip_id == 0x49 && address == 0x4c)
-		strlcpy(info->type, "lm96163", I2C_NAME_SIZE);
+		strscpy(info->type, "lm96163", I2C_NAME_SIZE);
 	else
 		return -ENODEV;
 
diff --git a/drivers/hwmon/lm73.c b/drivers/hwmon/lm73.c
index beb0d61bcd82..1346b3b3f463 100644
--- a/drivers/hwmon/lm73.c
+++ b/drivers/hwmon/lm73.c
@@ -257,7 +257,7 @@ static int lm73_detect(struct i2c_client *new_client,
 	if (id < 0 || id != LM73_ID)
 		return -ENODEV;
 
-	strlcpy(info->type, "lm73", I2C_NAME_SIZE);
+	strscpy(info->type, "lm73", I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/lm75.c b/drivers/hwmon/lm75.c
index e447febd121a..e03ebc5477df 100644
--- a/drivers/hwmon/lm75.c
+++ b/drivers/hwmon/lm75.c
@@ -866,7 +866,7 @@ static int lm75_detect(struct i2c_client *new_client,
 			return -ENODEV;
 	}
 
-	strlcpy(info->type, is_lm75a ? "lm75a" : "lm75", I2C_NAME_SIZE);
+	strscpy(info->type, is_lm75a ? "lm75a" : "lm75", I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/lm77.c b/drivers/hwmon/lm77.c
index 7570c9d50ddc..cb0106fbd438 100644
--- a/drivers/hwmon/lm77.c
+++ b/drivers/hwmon/lm77.c
@@ -302,7 +302,7 @@ static int lm77_detect(struct i2c_client *client, struct i2c_board_info *info)
 	 || i2c_smbus_read_word_data(client, 7) != min)
 		return -ENODEV;
 
-	strlcpy(info->type, "lm77", I2C_NAME_SIZE);
+	strscpy(info->type, "lm77", I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/lm78.c b/drivers/hwmon/lm78.c
index 1aa35ca0c6fe..cb46c1b37f36 100644
--- a/drivers/hwmon/lm78.c
+++ b/drivers/hwmon/lm78.c
@@ -617,7 +617,7 @@ static int lm78_i2c_detect(struct i2c_client *client,
 	if (isa)
 		mutex_unlock(&isa->update_lock);
 
-	strlcpy(info->type, client_name, I2C_NAME_SIZE);
+	strscpy(info->type, client_name, I2C_NAME_SIZE);
 
 	return 0;
 
diff --git a/drivers/hwmon/lm80.c b/drivers/hwmon/lm80.c
index ac4adb44b224..30427c1b996b 100644
--- a/drivers/hwmon/lm80.c
+++ b/drivers/hwmon/lm80.c
@@ -586,7 +586,7 @@ static int lm80_detect(struct i2c_client *client, struct i2c_board_info *info)
 		name = "lm80";
 	}
 
-	strlcpy(info->type, name, I2C_NAME_SIZE);
+	strscpy(info->type, name, I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/lm83.c b/drivers/hwmon/lm83.c
index 2ff5ecce608e..bf15b667f3a0 100644
--- a/drivers/hwmon/lm83.c
+++ b/drivers/hwmon/lm83.c
@@ -312,7 +312,7 @@ static int lm83_detect(struct i2c_client *new_client,
 		return -ENODEV;
 	}
 
-	strlcpy(info->type, name, I2C_NAME_SIZE);
+	strscpy(info->type, name, I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/lm85.c b/drivers/hwmon/lm85.c
index c7bf5de7b70f..e53db8d60f22 100644
--- a/drivers/hwmon/lm85.c
+++ b/drivers/hwmon/lm85.c
@@ -1539,7 +1539,7 @@ static int lm85_detect(struct i2c_client *client, struct i2c_board_info *info)
 	if (!type_name)
 		return -ENODEV;
 
-	strlcpy(info->type, type_name, I2C_NAME_SIZE);
+	strscpy(info->type, type_name, I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/lm87.c b/drivers/hwmon/lm87.c
index b2d820125bb6..77f11caa0096 100644
--- a/drivers/hwmon/lm87.c
+++ b/drivers/hwmon/lm87.c
@@ -833,7 +833,7 @@ static int lm87_detect(struct i2c_client *client, struct i2c_board_info *info)
 		return -ENODEV;
 	}
 
-	strlcpy(info->type, name, I2C_NAME_SIZE);
+	strscpy(info->type, name, I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index ebbfd5f352c0..b74209991078 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -1638,7 +1638,7 @@ static int lm90_detect(struct i2c_client *client,
 		return -ENODEV;
 	}
 
-	strlcpy(info->type, name, I2C_NAME_SIZE);
+	strscpy(info->type, name, I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/lm92.c b/drivers/hwmon/lm92.c
index 9bf278cf0bd0..00753cd40636 100644
--- a/drivers/hwmon/lm92.c
+++ b/drivers/hwmon/lm92.c
@@ -287,7 +287,7 @@ static int lm92_detect(struct i2c_client *new_client,
 	else
 		return -ENODEV;
 
-	strlcpy(info->type, "lm92", I2C_NAME_SIZE);
+	strscpy(info->type, "lm92", I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/lm93.c b/drivers/hwmon/lm93.c
index 78d6dfaf145b..b7aa9dddd216 100644
--- a/drivers/hwmon/lm93.c
+++ b/drivers/hwmon/lm93.c
@@ -2575,7 +2575,7 @@ static int lm93_detect(struct i2c_client *client, struct i2c_board_info *info)
 		return -ENODEV;
 	}
 
-	strlcpy(info->type, name, I2C_NAME_SIZE);
+	strscpy(info->type, name, I2C_NAME_SIZE);
 	dev_dbg(&adapter->dev, "loading %s at %d, 0x%02x\n",
 		client->name, i2c_adapter_id(client->adapter),
 		client->addr);
diff --git a/drivers/hwmon/lm95234.c b/drivers/hwmon/lm95234.c
index ac169a994ae0..b4a9d0c223c4 100644
--- a/drivers/hwmon/lm95234.c
+++ b/drivers/hwmon/lm95234.c
@@ -644,7 +644,7 @@ static int lm95234_detect(struct i2c_client *client,
 	if (val & model_mask)
 		return -ENODEV;
 
-	strlcpy(info->type, name, I2C_NAME_SIZE);
+	strscpy(info->type, name, I2C_NAME_SIZE);
 	return 0;
 }
 
diff --git a/drivers/hwmon/lm95241.c b/drivers/hwmon/lm95241.c
index 00dbc170c8c6..1f0642db0b9b 100644
--- a/drivers/hwmon/lm95241.c
+++ b/drivers/hwmon/lm95241.c
@@ -389,7 +389,7 @@ static int lm95241_detect(struct i2c_client *new_client,
 	}
 
 	/* Fill the i2c board info */
-	strlcpy(info->type, name, I2C_NAME_SIZE);
+	strscpy(info->type, name, I2C_NAME_SIZE);
 	return 0;
 }
 
diff --git a/drivers/hwmon/lm95245.c b/drivers/hwmon/lm95245.c
index 29388fcf5f74..c433f0af2d31 100644
--- a/drivers/hwmon/lm95245.c
+++ b/drivers/hwmon/lm95245.c
@@ -461,7 +461,7 @@ static int lm95245_detect(struct i2c_client *new_client,
 		return -ENODEV;
 	}
 
-	strlcpy(info->type, name, I2C_NAME_SIZE);
+	strscpy(info->type, name, I2C_NAME_SIZE);
 	return 0;
 }
 
diff --git a/drivers/hwmon/max1619.c b/drivers/hwmon/max1619.c
index 8bd941cae4d1..8dada6e13e3f 100644
--- a/drivers/hwmon/max1619.c
+++ b/drivers/hwmon/max1619.c
@@ -241,7 +241,7 @@ static int max1619_detect(struct i2c_client *client,
 		return -ENODEV;
 	}
 
-	strlcpy(info->type, "max1619", I2C_NAME_SIZE);
+	strscpy(info->type, "max1619", I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/max1668.c b/drivers/hwmon/max1668.c
index 5c41c78f0458..8318354dfa39 100644
--- a/drivers/hwmon/max1668.c
+++ b/drivers/hwmon/max1668.c
@@ -386,7 +386,7 @@ static int max1668_detect(struct i2c_client *client,
 	if (!type_name)
 		return -ENODEV;
 
-	strlcpy(info->type, type_name, I2C_NAME_SIZE);
+	strscpy(info->type, type_name, I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/max31730.c b/drivers/hwmon/max31730.c
index 23598b8b8793..9bdff881f59c 100644
--- a/drivers/hwmon/max31730.c
+++ b/drivers/hwmon/max31730.c
@@ -399,7 +399,7 @@ static int max31730_detect(struct i2c_client *client,
 			return -ENODEV;
 	}
 
-	strlcpy(info->type, "max31730", I2C_NAME_SIZE);
+	strscpy(info->type, "max31730", I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/max6639.c b/drivers/hwmon/max6639.c
index b71899c641fa..c8496631b532 100644
--- a/drivers/hwmon/max6639.c
+++ b/drivers/hwmon/max6639.c
@@ -511,7 +511,7 @@ static int max6639_detect(struct i2c_client *client,
 	if (dev_id != 0x58 || manu_id != 0x4D)
 		return -ENODEV;
 
-	strlcpy(info->type, "max6639", I2C_NAME_SIZE);
+	strscpy(info->type, "max6639", I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/max6642.c b/drivers/hwmon/max6642.c
index 23d93142b0b3..0d171aa06814 100644
--- a/drivers/hwmon/max6642.c
+++ b/drivers/hwmon/max6642.c
@@ -148,7 +148,7 @@ static int max6642_detect(struct i2c_client *client,
 	if ((reg_status & 0x2b) != 0x00)
 		return -ENODEV;
 
-	strlcpy(info->type, "max6642", I2C_NAME_SIZE);
+	strscpy(info->type, "max6642", I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/nct7802.c b/drivers/hwmon/nct7802.c
index 604af2f6103a..f18e7e5a452f 100644
--- a/drivers/hwmon/nct7802.c
+++ b/drivers/hwmon/nct7802.c
@@ -1021,7 +1021,7 @@ static int nct7802_detect(struct i2c_client *client,
 	if (reg < 0 || (reg & 0x3f))
 		return -ENODEV;
 
-	strlcpy(info->type, "nct7802", I2C_NAME_SIZE);
+	strscpy(info->type, "nct7802", I2C_NAME_SIZE);
 	return 0;
 }
 
diff --git a/drivers/hwmon/nct7904.c b/drivers/hwmon/nct7904.c
index b1c837fc407a..ecc5db0011a3 100644
--- a/drivers/hwmon/nct7904.c
+++ b/drivers/hwmon/nct7904.c
@@ -798,7 +798,7 @@ static int nct7904_detect(struct i2c_client *client,
 	    (i2c_smbus_read_byte_data(client, BANK_SEL_REG) & 0xf8) != 0x00)
 		return -ENODEV;
 
-	strlcpy(info->type, "nct7904", I2C_NAME_SIZE);
+	strscpy(info->type, "nct7904", I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/sch56xx-common.c b/drivers/hwmon/sch56xx-common.c
index 6c84780e358e..030f5769bcd0 100644
--- a/drivers/hwmon/sch56xx-common.c
+++ b/drivers/hwmon/sch56xx-common.c
@@ -408,7 +408,7 @@ struct sch56xx_watchdog_data *sch56xx_watchdog_register(struct device *parent,
 	data->addr = addr;
 	data->io_lock = io_lock;
 
-	strlcpy(data->wdinfo.identity, "sch56xx watchdog",
+	strscpy(data->wdinfo.identity, "sch56xx watchdog",
 		sizeof(data->wdinfo.identity));
 	data->wdinfo.firmware_version = revision;
 	data->wdinfo.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT;
diff --git a/drivers/hwmon/smsc47m192.c b/drivers/hwmon/smsc47m192.c
index 03a87aa2017a..50da5d5432ba 100644
--- a/drivers/hwmon/smsc47m192.c
+++ b/drivers/hwmon/smsc47m192.c
@@ -582,7 +582,7 @@ static int smsc47m192_detect(struct i2c_client *client,
 		return -ENODEV;
 	}
 
-	strlcpy(info->type, "smsc47m192", I2C_NAME_SIZE);
+	strscpy(info->type, "smsc47m192", I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/stts751.c b/drivers/hwmon/stts751.c
index 6928be6dbe4e..b6532ce1c328 100644
--- a/drivers/hwmon/stts751.c
+++ b/drivers/hwmon/stts751.c
@@ -692,7 +692,7 @@ static int stts751_detect(struct i2c_client *new_client,
 	}
 	dev_dbg(&new_client->dev, "Chip %s detected", name);
 
-	strlcpy(info->type, stts751_id[0].name, I2C_NAME_SIZE);
+	strscpy(info->type, stts751_id[0].name, I2C_NAME_SIZE);
 	return 0;
 }
 
diff --git a/drivers/hwmon/thmc50.c b/drivers/hwmon/thmc50.c
index fde5e2d0825a..976aa88c9bbd 100644
--- a/drivers/hwmon/thmc50.c
+++ b/drivers/hwmon/thmc50.c
@@ -352,7 +352,7 @@ static int thmc50_detect(struct i2c_client *client,
 	pr_debug("thmc50: Detected %s (version %x, revision %x)\n",
 		 type_name, (revision >> 4) - 0xc, revision & 0xf);
 
-	strlcpy(info->type, type_name, I2C_NAME_SIZE);
+	strscpy(info->type, type_name, I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/tmp401.c b/drivers/hwmon/tmp401.c
index 9dc210b55e69..ca5142bef4fe 100644
--- a/drivers/hwmon/tmp401.c
+++ b/drivers/hwmon/tmp401.c
@@ -678,7 +678,7 @@ static int tmp401_detect(struct i2c_client *client,
 	if (reg > 15)
 		return -ENODEV;
 
-	strlcpy(info->type, tmp401_id[kind].name, I2C_NAME_SIZE);
+	strscpy(info->type, tmp401_id[kind].name, I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/tmp421.c b/drivers/hwmon/tmp421.c
index ede66ea6a730..ac86982b2690 100644
--- a/drivers/hwmon/tmp421.c
+++ b/drivers/hwmon/tmp421.c
@@ -267,7 +267,7 @@ static int tmp421_detect(struct i2c_client *client,
 		return -ENODEV;
 	}
 
-	strlcpy(info->type, tmp421_id[kind].name, I2C_NAME_SIZE);
+	strscpy(info->type, tmp421_id[kind].name, I2C_NAME_SIZE);
 	dev_info(&adapter->dev, "Detected TI %s chip at 0x%02x\n",
 		 names[kind], client->addr);
 
diff --git a/drivers/hwmon/w83781d.c b/drivers/hwmon/w83781d.c
index e84aa5604e64..857d7b1f4677 100644
--- a/drivers/hwmon/w83781d.c
+++ b/drivers/hwmon/w83781d.c
@@ -1171,7 +1171,7 @@ w83781d_detect(struct i2c_client *client, struct i2c_board_info *info)
 	if (isa)
 		mutex_unlock(&isa->update_lock);
 
-	strlcpy(info->type, client_name, I2C_NAME_SIZE);
+	strscpy(info->type, client_name, I2C_NAME_SIZE);
 
 	return 0;
 
diff --git a/drivers/hwmon/w83791d.c b/drivers/hwmon/w83791d.c
index 37b25a1474c4..ed88d2dde330 100644
--- a/drivers/hwmon/w83791d.c
+++ b/drivers/hwmon/w83791d.c
@@ -1340,7 +1340,7 @@ static int w83791d_detect(struct i2c_client *client,
 	if (val1 != 0x71 || val2 != 0x5c)
 		return -ENODEV;
 
-	strlcpy(info->type, "w83791d", I2C_NAME_SIZE);
+	strscpy(info->type, "w83791d", I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/w83792d.c b/drivers/hwmon/w83792d.c
index abd5c3a722b9..4383ba4e55d0 100644
--- a/drivers/hwmon/w83792d.c
+++ b/drivers/hwmon/w83792d.c
@@ -1352,7 +1352,7 @@ w83792d_detect(struct i2c_client *client, struct i2c_board_info *info)
 	if (val1 != 0x7a || val2 != 0x5c)
 		return -ENODEV;
 
-	strlcpy(info->type, "w83792d", I2C_NAME_SIZE);
+	strscpy(info->type, "w83792d", I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/w83793.c b/drivers/hwmon/w83793.c
index e7d0484eabe4..a0076b68e56f 100644
--- a/drivers/hwmon/w83793.c
+++ b/drivers/hwmon/w83793.c
@@ -1640,7 +1640,7 @@ static int w83793_detect(struct i2c_client *client,
 	if (chip_id != 0x7b)
 		return -ENODEV;
 
-	strlcpy(info->type, "w83793", I2C_NAME_SIZE);
+	strscpy(info->type, "w83793", I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/w83795.c b/drivers/hwmon/w83795.c
index 621b05afa837..6fe08ab0386c 100644
--- a/drivers/hwmon/w83795.c
+++ b/drivers/hwmon/w83795.c
@@ -1967,7 +1967,7 @@ static int w83795_detect(struct i2c_client *client,
 	else
 		chip_name = "w83795g";
 
-	strlcpy(info->type, chip_name, I2C_NAME_SIZE);
+	strscpy(info->type, chip_name, I2C_NAME_SIZE);
 	dev_info(&adapter->dev, "Found %s rev. %c at 0x%02hx\n", chip_name,
 		 'A' + (device_id & 0xf), address);
 
diff --git a/drivers/hwmon/w83l785ts.c b/drivers/hwmon/w83l785ts.c
index 656a77102ca6..90c906d9538d 100644
--- a/drivers/hwmon/w83l785ts.c
+++ b/drivers/hwmon/w83l785ts.c
@@ -157,7 +157,7 @@ static int w83l785ts_detect(struct i2c_client *client,
 		return -ENODEV;
 	}
 
-	strlcpy(info->type, "w83l785ts", I2C_NAME_SIZE);
+	strscpy(info->type, "w83l785ts", I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/hwmon/w83l786ng.c b/drivers/hwmon/w83l786ng.c
index 542afff1423b..7b7b970f49bb 100644
--- a/drivers/hwmon/w83l786ng.c
+++ b/drivers/hwmon/w83l786ng.c
@@ -687,7 +687,7 @@ w83l786ng_detect(struct i2c_client *client, struct i2c_board_info *info)
 		return -ENODEV;
 	}
 
-	strlcpy(info->type, "w83l786ng", I2C_NAME_SIZE);
+	strscpy(info->type, "w83l786ng", I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/i2c/busses/i2c-altera.c b/drivers/i2c/busses/i2c-altera.c
index 7d62cbda6e06..50cfc818bdb2 100644
--- a/drivers/i2c/busses/i2c-altera.c
+++ b/drivers/i2c/busses/i2c-altera.c
@@ -448,7 +448,7 @@ static int altr_i2c_probe(struct platform_device *pdev)
 	mutex_unlock(&idev->isr_mutex);
 
 	i2c_set_adapdata(&idev->adapter, idev);
-	strlcpy(idev->adapter.name, pdev->name, sizeof(idev->adapter.name));
+	strscpy(idev->adapter.name, pdev->name, sizeof(idev->adapter.name));
 	idev->adapter.owner = THIS_MODULE;
 	idev->adapter.algo = &altr_i2c_algo;
 	idev->adapter.dev.parent = &pdev->dev;
diff --git a/drivers/i2c/busses/i2c-aspeed.c b/drivers/i2c/busses/i2c-aspeed.c
index 724bf30600d6..e9e9d0ece0c1 100644
--- a/drivers/i2c/busses/i2c-aspeed.c
+++ b/drivers/i2c/busses/i2c-aspeed.c
@@ -1020,7 +1020,7 @@ static int aspeed_i2c_probe_bus(struct platform_device *pdev)
 	bus->adap.algo = &aspeed_i2c_algo;
 	bus->adap.dev.parent = &pdev->dev;
 	bus->adap.dev.of_node = pdev->dev.of_node;
-	strlcpy(bus->adap.name, pdev->name, sizeof(bus->adap.name));
+	strscpy(bus->adap.name, pdev->name, sizeof(bus->adap.name));
 	i2c_set_adapdata(&bus->adap, bus);
 
 	bus->dev = &pdev->dev;
diff --git a/drivers/i2c/busses/i2c-au1550.c b/drivers/i2c/busses/i2c-au1550.c
index 22aed922552b..99bd24d0e6a5 100644
--- a/drivers/i2c/busses/i2c-au1550.c
+++ b/drivers/i2c/busses/i2c-au1550.c
@@ -321,7 +321,7 @@ i2c_au1550_probe(struct platform_device *pdev)
 	priv->adap.algo = &au1550_algo;
 	priv->adap.algo_data = priv;
 	priv->adap.dev.parent = &pdev->dev;
-	strlcpy(priv->adap.name, "Au1xxx PSC I2C", sizeof(priv->adap.name));
+	strscpy(priv->adap.name, "Au1xxx PSC I2C", sizeof(priv->adap.name));
 
 	/* Now, set up the PSC for SMBus PIO mode. */
 	i2c_au1550_setup(priv);
diff --git a/drivers/i2c/busses/i2c-axxia.c b/drivers/i2c/busses/i2c-axxia.c
index 5294b73beca8..bdf3b50de8ad 100644
--- a/drivers/i2c/busses/i2c-axxia.c
+++ b/drivers/i2c/busses/i2c-axxia.c
@@ -783,7 +783,7 @@ static int axxia_i2c_probe(struct platform_device *pdev)
 	}
 
 	i2c_set_adapdata(&idev->adapter, idev);
-	strlcpy(idev->adapter.name, pdev->name, sizeof(idev->adapter.name));
+	strscpy(idev->adapter.name, pdev->name, sizeof(idev->adapter.name));
 	idev->adapter.owner = THIS_MODULE;
 	idev->adapter.algo = &axxia_i2c_algo;
 	idev->adapter.bus_recovery_info = &axxia_i2c_recovery_info;
diff --git a/drivers/i2c/busses/i2c-bcm-kona.c b/drivers/i2c/busses/i2c-bcm-kona.c
index ed5e1275ae46..118cf62a7969 100644
--- a/drivers/i2c/busses/i2c-bcm-kona.c
+++ b/drivers/i2c/busses/i2c-bcm-kona.c
@@ -849,7 +849,7 @@ static int bcm_kona_i2c_probe(struct platform_device *pdev)
 	adap = &dev->adapter;
 	i2c_set_adapdata(adap, dev);
 	adap->owner = THIS_MODULE;
-	strlcpy(adap->name, "Broadcom I2C adapter", sizeof(adap->name));
+	strscpy(adap->name, "Broadcom I2C adapter", sizeof(adap->name));
 	adap->algo = &bcm_algo;
 	adap->dev.parent = &pdev->dev;
 	adap->dev.of_node = pdev->dev.of_node;
diff --git a/drivers/i2c/busses/i2c-brcmstb.c b/drivers/i2c/busses/i2c-brcmstb.c
index d4e0a0f6732a..bbc62cceb09a 100644
--- a/drivers/i2c/busses/i2c-brcmstb.c
+++ b/drivers/i2c/busses/i2c-brcmstb.c
@@ -685,7 +685,7 @@ static int brcmstb_i2c_probe(struct platform_device *pdev)
 	adap = &dev->adapter;
 	i2c_set_adapdata(adap, dev);
 	adap->owner = THIS_MODULE;
-	strlcpy(adap->name, "Broadcom STB : ", sizeof(adap->name));
+	strscpy(adap->name, "Broadcom STB : ", sizeof(adap->name));
 	if (int_name)
 		strlcat(adap->name, int_name, sizeof(adap->name));
 	adap->algo = &brcmstb_i2c_algo;
diff --git a/drivers/i2c/busses/i2c-cbus-gpio.c b/drivers/i2c/busses/i2c-cbus-gpio.c
index 72df563477b1..9d5712f885d7 100644
--- a/drivers/i2c/busses/i2c-cbus-gpio.c
+++ b/drivers/i2c/busses/i2c-cbus-gpio.c
@@ -244,7 +244,7 @@ static int cbus_i2c_probe(struct platform_device *pdev)
 	adapter->nr		= pdev->id;
 	adapter->timeout	= HZ;
 	adapter->algo		= &cbus_i2c_algo;
-	strlcpy(adapter->name, "CBUS I2C adapter", sizeof(adapter->name));
+	strscpy(adapter->name, "CBUS I2C adapter", sizeof(adapter->name));
 
 	spin_lock_init(&chost->lock);
 	chost->dev = &pdev->dev;
diff --git a/drivers/i2c/busses/i2c-cht-wc.c b/drivers/i2c/busses/i2c-cht-wc.c
index f80d79e973cd..1adc3ca9892b 100644
--- a/drivers/i2c/busses/i2c-cht-wc.c
+++ b/drivers/i2c/busses/i2c-cht-wc.c
@@ -330,7 +330,7 @@ static int cht_wc_i2c_adap_i2c_probe(struct platform_device *pdev)
 	adap->adapter.class = I2C_CLASS_HWMON;
 	adap->adapter.algo = &cht_wc_i2c_adap_algo;
 	adap->adapter.lock_ops = &cht_wc_i2c_adap_lock_ops;
-	strlcpy(adap->adapter.name, "PMIC I2C Adapter",
+	strscpy(adap->adapter.name, "PMIC I2C Adapter",
 		sizeof(adap->adapter.name));
 	adap->adapter.dev.parent = &pdev->dev;
 
diff --git a/drivers/i2c/busses/i2c-cros-ec-tunnel.c b/drivers/i2c/busses/i2c-cros-ec-tunnel.c
index 790ea3fda693..4856a7dc60c4 100644
--- a/drivers/i2c/busses/i2c-cros-ec-tunnel.c
+++ b/drivers/i2c/busses/i2c-cros-ec-tunnel.c
@@ -267,7 +267,7 @@ static int ec_i2c_probe(struct platform_device *pdev)
 	bus->dev = dev;
 
 	bus->adap.owner = THIS_MODULE;
-	strlcpy(bus->adap.name, "cros-ec-i2c-tunnel", sizeof(bus->adap.name));
+	strscpy(bus->adap.name, "cros-ec-i2c-tunnel", sizeof(bus->adap.name));
 	bus->adap.algo = &ec_i2c_algorithm;
 	bus->adap.algo_data = bus;
 	bus->adap.dev.parent = &pdev->dev;
diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
index 232a7679b69b..8d67ee9c44ea 100644
--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -850,7 +850,7 @@ static int davinci_i2c_probe(struct platform_device *pdev)
 	i2c_set_adapdata(adap, dev);
 	adap->owner = THIS_MODULE;
 	adap->class = I2C_CLASS_DEPRECATED;
-	strlcpy(adap->name, "DaVinci I2C adapter", sizeof(adap->name));
+	strscpy(adap->name, "DaVinci I2C adapter", sizeof(adap->name));
 	adap->algo = &i2c_davinci_algo;
 	adap->dev.parent = &pdev->dev;
 	adap->timeout = DAVINCI_I2C_TIMEOUT;
diff --git a/drivers/i2c/busses/i2c-digicolor.c b/drivers/i2c/busses/i2c-digicolor.c
index f67639dc74b7..4aefb0a5ba91 100644
--- a/drivers/i2c/busses/i2c-digicolor.c
+++ b/drivers/i2c/busses/i2c-digicolor.c
@@ -323,7 +323,7 @@ static int dc_i2c_probe(struct platform_device *pdev)
 	if (ret < 0)
 		return ret;
 
-	strlcpy(i2c->adap.name, "Conexant Digicolor I2C adapter",
+	strscpy(i2c->adap.name, "Conexant Digicolor I2C adapter",
 		sizeof(i2c->adap.name));
 	i2c->adap.owner = THIS_MODULE;
 	i2c->adap.algo = &dc_i2c_algorithm;
diff --git a/drivers/i2c/busses/i2c-efm32.c b/drivers/i2c/busses/i2c-efm32.c
index f6e13ceeb2b3..5205db0828c2 100644
--- a/drivers/i2c/busses/i2c-efm32.c
+++ b/drivers/i2c/busses/i2c-efm32.c
@@ -318,7 +318,7 @@ static int efm32_i2c_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, ddata);
 
 	init_completion(&ddata->done);
-	strlcpy(ddata->adapter.name, pdev->name, sizeof(ddata->adapter.name));
+	strscpy(ddata->adapter.name, pdev->name, sizeof(ddata->adapter.name));
 	ddata->adapter.owner = THIS_MODULE;
 	ddata->adapter.algo = &efm32_i2c_algo;
 	ddata->adapter.dev.parent = &pdev->dev;
diff --git a/drivers/i2c/busses/i2c-eg20t.c b/drivers/i2c/busses/i2c-eg20t.c
index 843b31a0f752..6a62ff0c0277 100644
--- a/drivers/i2c/busses/i2c-eg20t.c
+++ b/drivers/i2c/busses/i2c-eg20t.c
@@ -772,7 +772,8 @@ static int pch_i2c_probe(struct pci_dev *pdev,
 
 		pch_adap->owner = THIS_MODULE;
 		pch_adap->class = I2C_CLASS_HWMON;
-		strlcpy(pch_adap->name, KBUILD_MODNAME, sizeof(pch_adap->name));
+		strscpy(pch_adap->name, KBUILD_MODNAME,
+			sizeof(pch_adap->name));
 		pch_adap->algo = &pch_algorithm;
 		pch_adap->algo_data = &adap_info->pch_data[i];
 
diff --git a/drivers/i2c/busses/i2c-emev2.c b/drivers/i2c/busses/i2c-emev2.c
index a08554c1a570..1ae738d920c6 100644
--- a/drivers/i2c/busses/i2c-emev2.c
+++ b/drivers/i2c/busses/i2c-emev2.c
@@ -371,7 +371,7 @@ static int em_i2c_probe(struct platform_device *pdev)
 	if (IS_ERR(priv->base))
 		return PTR_ERR(priv->base);
 
-	strlcpy(priv->adap.name, "EMEV2 I2C", sizeof(priv->adap.name));
+	strscpy(priv->adap.name, "EMEV2 I2C", sizeof(priv->adap.name));
 
 	priv->sclk = devm_clk_get(&pdev->dev, "sclk");
 	if (IS_ERR(priv->sclk))
diff --git a/drivers/i2c/busses/i2c-exynos5.c b/drivers/i2c/busses/i2c-exynos5.c
index 6ce3ec03b595..1eab54add850 100644
--- a/drivers/i2c/busses/i2c-exynos5.c
+++ b/drivers/i2c/busses/i2c-exynos5.c
@@ -745,7 +745,7 @@ static int exynos5_i2c_probe(struct platform_device *pdev)
 	if (of_property_read_u32(np, "clock-frequency", &i2c->op_clock))
 		i2c->op_clock = I2C_MAX_STANDARD_MODE_FREQ;
 
-	strlcpy(i2c->adap.name, "exynos5-i2c", sizeof(i2c->adap.name));
+	strscpy(i2c->adap.name, "exynos5-i2c", sizeof(i2c->adap.name));
 	i2c->adap.owner   = THIS_MODULE;
 	i2c->adap.algo    = &exynos5_i2c_algorithm;
 	i2c->adap.retries = 3;
diff --git a/drivers/i2c/busses/i2c-gpio.c b/drivers/i2c/busses/i2c-gpio.c
index a4a6825c8758..03258f905af4 100644
--- a/drivers/i2c/busses/i2c-gpio.c
+++ b/drivers/i2c/busses/i2c-gpio.c
@@ -436,7 +436,7 @@ static int i2c_gpio_probe(struct platform_device *pdev)
 
 	adap->owner = THIS_MODULE;
 	if (np)
-		strlcpy(adap->name, dev_name(dev), sizeof(adap->name));
+		strscpy(adap->name, dev_name(dev), sizeof(adap->name));
 	else
 		snprintf(adap->name, sizeof(adap->name), "i2c-gpio%d", pdev->id);
 
diff --git a/drivers/i2c/busses/i2c-highlander.c b/drivers/i2c/busses/i2c-highlander.c
index 803dad70e2a7..d0d7c3210bbb 100644
--- a/drivers/i2c/busses/i2c-highlander.c
+++ b/drivers/i2c/busses/i2c-highlander.c
@@ -402,7 +402,7 @@ static int highlander_i2c_probe(struct platform_device *pdev)
 	i2c_set_adapdata(adap, dev);
 	adap->owner = THIS_MODULE;
 	adap->class = I2C_CLASS_HWMON;
-	strlcpy(adap->name, "HL FPGA I2C adapter", sizeof(adap->name));
+	strscpy(adap->name, "HL FPGA I2C adapter", sizeof(adap->name));
 	adap->algo = &highlander_i2c_algo;
 	adap->dev.parent = &pdev->dev;
 	adap->nr = pdev->id;
diff --git a/drivers/i2c/busses/i2c-hix5hd2.c b/drivers/i2c/busses/i2c-hix5hd2.c
index ab15b1ec2ab3..ec4e76cddbc0 100644
--- a/drivers/i2c/busses/i2c-hix5hd2.c
+++ b/drivers/i2c/busses/i2c-hix5hd2.c
@@ -425,7 +425,7 @@ static int hix5hd2_i2c_probe(struct platform_device *pdev)
 	}
 	clk_prepare_enable(priv->clk);
 
-	strlcpy(priv->adap.name, "hix5hd2-i2c", sizeof(priv->adap.name));
+	strscpy(priv->adap.name, "hix5hd2-i2c", sizeof(priv->adap.name));
 	priv->dev = &pdev->dev;
 	priv->adap.owner = THIS_MODULE;
 	priv->adap.algo = &hix5hd2_i2c_algorithm;
diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index ae90713443fa..6cc0739621e4 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -1148,7 +1148,7 @@ static void dmi_check_onboard_device(u8 type, const char *name,
 
 		memset(&info, 0, sizeof(struct i2c_board_info));
 		info.addr = dmi_devices[i].i2c_addr;
-		strlcpy(info.type, dmi_devices[i].i2c_type, I2C_NAME_SIZE);
+		strscpy(info.type, dmi_devices[i].i2c_type, I2C_NAME_SIZE);
 		i2c_new_client_device(adap, &info);
 		break;
 	}
@@ -1303,7 +1303,7 @@ static void register_dell_lis3lv02d_i2c_device(struct i801_priv *priv)
 
 	memset(&info, 0, sizeof(struct i2c_board_info));
 	info.addr = dell_lis3lv02d_devices[i].i2c_addr;
-	strlcpy(info.type, "lis3lv02d", I2C_NAME_SIZE);
+	strscpy(info.type, "lis3lv02d", I2C_NAME_SIZE);
 	i2c_new_client_device(&priv->adapter, &info);
 }
 
@@ -1319,7 +1319,7 @@ static void i801_probe_optional_slaves(struct i801_priv *priv)
 
 		memset(&info, 0, sizeof(struct i2c_board_info));
 		info.addr = apanel_addr;
-		strlcpy(info.type, "fujitsu_apanel", I2C_NAME_SIZE);
+		strscpy(info.type, "fujitsu_apanel", I2C_NAME_SIZE);
 		i2c_new_client_device(&priv->adapter, &info);
 	}
 
diff --git a/drivers/i2c/busses/i2c-ibm_iic.c b/drivers/i2c/busses/i2c-ibm_iic.c
index 9f71daf6db64..eeb80e34f9ad 100644
--- a/drivers/i2c/busses/i2c-ibm_iic.c
+++ b/drivers/i2c/busses/i2c-ibm_iic.c
@@ -738,7 +738,7 @@ static int iic_probe(struct platform_device *ofdev)
 	adap = &dev->adap;
 	adap->dev.parent = &ofdev->dev;
 	adap->dev.of_node = of_node_get(np);
-	strlcpy(adap->name, "IBM IIC", sizeof(adap->name));
+	strscpy(adap->name, "IBM IIC", sizeof(adap->name));
 	i2c_set_adapdata(adap, dev);
 	adap->class = I2C_CLASS_HWMON | I2C_CLASS_SPD;
 	adap->algo = &iic_algo;
diff --git a/drivers/i2c/busses/i2c-icy.c b/drivers/i2c/busses/i2c-icy.c
index 66c9923fc766..dc9edbc1799e 100644
--- a/drivers/i2c/busses/i2c-icy.c
+++ b/drivers/i2c/busses/i2c-icy.c
@@ -138,7 +138,7 @@ static int icy_probe(struct zorro_dev *z,
 	i2c->adapter.owner = THIS_MODULE;
 	/* i2c->adapter.algo assigned by i2c_pcf_add_bus() */
 	i2c->adapter.algo_data = algo_data;
-	strlcpy(i2c->adapter.name, "ICY I2C Zorro adapter",
+	strscpy(i2c->adapter.name, "ICY I2C Zorro adapter",
 		sizeof(i2c->adapter.name));
 
 	if (!devm_request_mem_region(&z->dev,
diff --git a/drivers/i2c/busses/i2c-imx-lpi2c.c b/drivers/i2c/busses/i2c-imx-lpi2c.c
index 9db6ccded5e9..26263e631f2d 100644
--- a/drivers/i2c/busses/i2c-imx-lpi2c.c
+++ b/drivers/i2c/busses/i2c-imx-lpi2c.c
@@ -558,7 +558,7 @@ static int lpi2c_imx_probe(struct platform_device *pdev)
 	lpi2c_imx->adapter.algo		= &lpi2c_imx_algo;
 	lpi2c_imx->adapter.dev.parent	= &pdev->dev;
 	lpi2c_imx->adapter.dev.of_node	= pdev->dev.of_node;
-	strlcpy(lpi2c_imx->adapter.name, pdev->name,
+	strscpy(lpi2c_imx->adapter.name, pdev->name,
 		sizeof(lpi2c_imx->adapter.name));
 
 	lpi2c_imx->clk = devm_clk_get(&pdev->dev, NULL);
diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index c98529c76348..94c0993cd6b9 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -1148,7 +1148,8 @@ static int i2c_imx_probe(struct platform_device *pdev)
 				platform_get_device_id(pdev)->driver_data;
 
 	/* Setup i2c_imx driver structure */
-	strlcpy(i2c_imx->adapter.name, pdev->name, sizeof(i2c_imx->adapter.name));
+	strscpy(i2c_imx->adapter.name, pdev->name,
+		sizeof(i2c_imx->adapter.name));
 	i2c_imx->adapter.owner		= THIS_MODULE;
 	i2c_imx->adapter.algo		= &i2c_imx_algo;
 	i2c_imx->adapter.dev.parent	= &pdev->dev;
diff --git a/drivers/i2c/busses/i2c-lpc2k.c b/drivers/i2c/busses/i2c-lpc2k.c
index 4e30c5267142..8fff6fbb7065 100644
--- a/drivers/i2c/busses/i2c-lpc2k.c
+++ b/drivers/i2c/busses/i2c-lpc2k.c
@@ -417,7 +417,7 @@ static int i2c_lpc2k_probe(struct platform_device *pdev)
 
 	i2c_set_adapdata(&i2c->adap, i2c);
 	i2c->adap.owner = THIS_MODULE;
-	strlcpy(i2c->adap.name, "LPC2K I2C adapter", sizeof(i2c->adap.name));
+	strscpy(i2c->adap.name, "LPC2K I2C adapter", sizeof(i2c->adap.name));
 	i2c->adap.algo = &i2c_lpc2k_algorithm;
 	i2c->adap.dev.parent = &pdev->dev;
 	i2c->adap.dev.of_node = pdev->dev.of_node;
diff --git a/drivers/i2c/busses/i2c-meson.c b/drivers/i2c/busses/i2c-meson.c
index ef73a42577cc..04d7756a5c2d 100644
--- a/drivers/i2c/busses/i2c-meson.c
+++ b/drivers/i2c/busses/i2c-meson.c
@@ -451,8 +451,7 @@ static int meson_i2c_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	strlcpy(i2c->adap.name, "Meson I2C adapter",
-		sizeof(i2c->adap.name));
+	strscpy(i2c->adap.name, "Meson I2C adapter", sizeof(i2c->adap.name));
 	i2c->adap.owner = THIS_MODULE;
 	i2c->adap.algo = &meson_i2c_algorithm;
 	i2c->adap.dev.parent = &pdev->dev;
diff --git a/drivers/i2c/busses/i2c-mt65xx.c b/drivers/i2c/busses/i2c-mt65xx.c
index 33de99b7bc20..ce82ffb3ae5d 100644
--- a/drivers/i2c/busses/i2c-mt65xx.c
+++ b/drivers/i2c/busses/i2c-mt65xx.c
@@ -1232,7 +1232,7 @@ static int mtk_i2c_probe(struct platform_device *pdev)
 		clk = i2c->clk_pmic;
 	}
 
-	strlcpy(i2c->adap.name, I2C_DRV_NAME, sizeof(i2c->adap.name));
+	strscpy(i2c->adap.name, I2C_DRV_NAME, sizeof(i2c->adap.name));
 
 	ret = mtk_i2c_set_speed(i2c, clk_get_rate(clk));
 	if (ret) {
diff --git a/drivers/i2c/busses/i2c-mt7621.c b/drivers/i2c/busses/i2c-mt7621.c
index 45fe4a7fe0c0..259503303a0c 100644
--- a/drivers/i2c/busses/i2c-mt7621.c
+++ b/drivers/i2c/busses/i2c-mt7621.c
@@ -314,7 +314,7 @@ static int mtk_i2c_probe(struct platform_device *pdev)
 	adap->dev.parent = &pdev->dev;
 	i2c_set_adapdata(adap, i2c);
 	adap->dev.of_node = pdev->dev.of_node;
-	strlcpy(adap->name, dev_name(&pdev->dev), sizeof(adap->name));
+	strscpy(adap->name, dev_name(&pdev->dev), sizeof(adap->name));
 
 	platform_set_drvdata(pdev, i2c);
 
diff --git a/drivers/i2c/busses/i2c-mv64xxx.c b/drivers/i2c/busses/i2c-mv64xxx.c
index e0e45fc19b8f..8c6f0a0d4660 100644
--- a/drivers/i2c/busses/i2c-mv64xxx.c
+++ b/drivers/i2c/busses/i2c-mv64xxx.c
@@ -889,7 +889,7 @@ mv64xxx_i2c_probe(struct platform_device *pd)
 	if (IS_ERR(drv_data->reg_base))
 		return PTR_ERR(drv_data->reg_base);
 
-	strlcpy(drv_data->adapter.name, MV64XXX_I2C_CTLR_NAME " adapter",
+	strscpy(drv_data->adapter.name, MV64XXX_I2C_CTLR_NAME " adapter",
 		sizeof(drv_data->adapter.name));
 
 	init_waitqueue_head(&drv_data->waitq);
diff --git a/drivers/i2c/busses/i2c-mxs.c b/drivers/i2c/busses/i2c-mxs.c
index c4b08a924461..7b86937efb81 100644
--- a/drivers/i2c/busses/i2c-mxs.c
+++ b/drivers/i2c/busses/i2c-mxs.c
@@ -854,7 +854,7 @@ static int mxs_i2c_probe(struct platform_device *pdev)
 		return err;
 
 	adap = &i2c->adapter;
-	strlcpy(adap->name, "MXS I2C adapter", sizeof(adap->name));
+	strscpy(adap->name, "MXS I2C adapter", sizeof(adap->name));
 	adap->owner = THIS_MODULE;
 	adap->algo = &mxs_i2c_algo;
 	adap->quirks = &mxs_i2c_quirks;
diff --git a/drivers/i2c/busses/i2c-nvidia-gpu.c b/drivers/i2c/busses/i2c-nvidia-gpu.c
index f9a69b109e5c..130eae303158 100644
--- a/drivers/i2c/busses/i2c-nvidia-gpu.c
+++ b/drivers/i2c/busses/i2c-nvidia-gpu.c
@@ -270,7 +270,7 @@ static int gpu_populate_client(struct gpu_i2c_dev *i2cd, int irq)
 	if (!i2cd->gpu_ccgx_ucsi)
 		return -ENOMEM;
 
-	strlcpy(i2cd->gpu_ccgx_ucsi->type, "ccgx-ucsi",
+	strscpy(i2cd->gpu_ccgx_ucsi->type, "ccgx-ucsi",
 		sizeof(i2cd->gpu_ccgx_ucsi->type));
 	i2cd->gpu_ccgx_ucsi->addr = 0x8;
 	i2cd->gpu_ccgx_ucsi->irq = irq;
@@ -315,7 +315,7 @@ static int gpu_i2c_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	i2c_set_adapdata(&i2cd->adapter, i2cd);
 	i2cd->adapter.owner = THIS_MODULE;
-	strlcpy(i2cd->adapter.name, "NVIDIA GPU I2C adapter",
+	strscpy(i2cd->adapter.name, "NVIDIA GPU I2C adapter",
 		sizeof(i2cd->adapter.name));
 	i2cd->adapter.algo = &gpu_i2c_algorithm;
 	i2cd->adapter.quirks = &gpu_i2c_quirks;
diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 12ac4212aded..7d9ac7581dea 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -1488,7 +1488,7 @@ omap_i2c_probe(struct platform_device *pdev)
 	i2c_set_adapdata(adap, omap);
 	adap->owner = THIS_MODULE;
 	adap->class = I2C_CLASS_DEPRECATED;
-	strlcpy(adap->name, "OMAP I2C adapter", sizeof(adap->name));
+	strscpy(adap->name, "OMAP I2C adapter", sizeof(adap->name));
 	adap->algo = &omap_i2c_algo;
 	adap->quirks = &omap_i2c_quirks;
 	adap->dev.parent = &pdev->dev;
diff --git a/drivers/i2c/busses/i2c-opal.c b/drivers/i2c/busses/i2c-opal.c
index 6eb0f50c5d28..9f773b4f5ed8 100644
--- a/drivers/i2c/busses/i2c-opal.c
+++ b/drivers/i2c/busses/i2c-opal.c
@@ -220,9 +220,9 @@ static int i2c_opal_probe(struct platform_device *pdev)
 	adapter->dev.of_node = of_node_get(pdev->dev.of_node);
 	pname = of_get_property(pdev->dev.of_node, "ibm,port-name", NULL);
 	if (pname)
-		strlcpy(adapter->name, pname, sizeof(adapter->name));
+		strscpy(adapter->name, pname, sizeof(adapter->name));
 	else
-		strlcpy(adapter->name, "opal", sizeof(adapter->name));
+		strscpy(adapter->name, "opal", sizeof(adapter->name));
 
 	platform_set_drvdata(pdev, adapter);
 	rc = i2c_add_adapter(adapter);
diff --git a/drivers/i2c/busses/i2c-parport.c b/drivers/i2c/busses/i2c-parport.c
index a535889acca6..22abc5afc93d 100644
--- a/drivers/i2c/busses/i2c-parport.c
+++ b/drivers/i2c/busses/i2c-parport.c
@@ -298,7 +298,7 @@ static void i2c_parport_attach(struct parport *port)
 	/* Fill the rest of the structure */
 	adapter->adapter.owner = THIS_MODULE;
 	adapter->adapter.class = I2C_CLASS_HWMON;
-	strlcpy(adapter->adapter.name, "Parallel port adapter",
+	strscpy(adapter->adapter.name, "Parallel port adapter",
 		sizeof(adapter->adapter.name));
 	adapter->algo_data = parport_algo_data;
 	/* Slow down if we can't sense SCL */
diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
index 35ca2c02c9b9..4fafc9bc5fa4 100644
--- a/drivers/i2c/busses/i2c-pxa.c
+++ b/drivers/i2c/busses/i2c-pxa.c
@@ -1463,7 +1463,7 @@ static int i2c_pxa_probe(struct platform_device *dev)
 	spin_lock_init(&i2c->lock);
 	init_waitqueue_head(&i2c->wait);
 
-	strlcpy(i2c->adap.name, "pxa_i2c-i2c", sizeof(i2c->adap.name));
+	strscpy(i2c->adap.name, "pxa_i2c-i2c", sizeof(i2c->adap.name));
 
 	i2c->clk = devm_clk_get(&dev->dev, NULL);
 	if (IS_ERR(i2c->clk)) {
diff --git a/drivers/i2c/busses/i2c-qcom-geni.c b/drivers/i2c/busses/i2c-qcom-geni.c
index 8b4c35f47a70..9a2d5ee9fc00 100644
--- a/drivers/i2c/busses/i2c-qcom-geni.c
+++ b/drivers/i2c/busses/i2c-qcom-geni.c
@@ -556,7 +556,7 @@ static int geni_i2c_probe(struct platform_device *pdev)
 	i2c_set_adapdata(&gi2c->adap, gi2c);
 	gi2c->adap.dev.parent = dev;
 	gi2c->adap.dev.of_node = dev->of_node;
-	strlcpy(gi2c->adap.name, "Geni-I2C", sizeof(gi2c->adap.name));
+	strscpy(gi2c->adap.name, "Geni-I2C", sizeof(gi2c->adap.name));
 
 	ret = geni_icc_get(&gi2c->se, "qup-memory");
 	if (ret)
diff --git a/drivers/i2c/busses/i2c-qup.c b/drivers/i2c/busses/i2c-qup.c
index fbc04b60cfd1..b6aa3e8835d9 100644
--- a/drivers/i2c/busses/i2c-qup.c
+++ b/drivers/i2c/busses/i2c-qup.c
@@ -1877,7 +1877,7 @@ static int qup_i2c_probe(struct platform_device *pdev)
 	qup->adap.dev.of_node = pdev->dev.of_node;
 	qup->is_last = true;
 
-	strlcpy(qup->adap.name, "QUP I2C adapter", sizeof(qup->adap.name));
+	strscpy(qup->adap.name, "QUP I2C adapter", sizeof(qup->adap.name));
 
 	pm_runtime_set_autosuspend_delay(qup->dev, MSEC_PER_SEC);
 	pm_runtime_use_autosuspend(qup->dev);
diff --git a/drivers/i2c/busses/i2c-rcar.c b/drivers/i2c/busses/i2c-rcar.c
index 217def2d7cb4..73787fed3339 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -963,7 +963,7 @@ static int rcar_i2c_probe(struct platform_device *pdev)
 	adap->bus_recovery_info = &rcar_i2c_bri;
 	adap->quirks = &rcar_i2c_quirks;
 	i2c_set_adapdata(adap, priv);
-	strlcpy(adap->name, pdev->name, sizeof(adap->name));
+	strscpy(adap->name, pdev->name, sizeof(adap->name));
 
 	/* Init DMA */
 	sg_init_table(&priv->sg, 1);
diff --git a/drivers/i2c/busses/i2c-riic.c b/drivers/i2c/busses/i2c-riic.c
index 4eccc0f69861..0fe8bb11f684 100644
--- a/drivers/i2c/busses/i2c-riic.c
+++ b/drivers/i2c/busses/i2c-riic.c
@@ -427,7 +427,7 @@ static int riic_i2c_probe(struct platform_device *pdev)
 
 	adap = &riic->adapter;
 	i2c_set_adapdata(adap, riic);
-	strlcpy(adap->name, "Renesas RIIC adapter", sizeof(adap->name));
+	strscpy(adap->name, "Renesas RIIC adapter", sizeof(adap->name));
 	adap->owner = THIS_MODULE;
 	adap->algo = &riic_algo;
 	adap->dev.parent = &pdev->dev;
diff --git a/drivers/i2c/busses/i2c-rk3x.c b/drivers/i2c/busses/i2c-rk3x.c
index 819ab4ee517e..df6daf38c31f 100644
--- a/drivers/i2c/busses/i2c-rk3x.c
+++ b/drivers/i2c/busses/i2c-rk3x.c
@@ -1240,7 +1240,7 @@ static int rk3x_i2c_probe(struct platform_device *pdev)
 	/* use common interface to get I2C timing properties */
 	i2c_parse_fw_timings(&pdev->dev, &i2c->t, true);
 
-	strlcpy(i2c->adap.name, "rk3x-i2c", sizeof(i2c->adap.name));
+	strscpy(i2c->adap.name, "rk3x-i2c", sizeof(i2c->adap.name));
 	i2c->adap.owner = THIS_MODULE;
 	i2c->adap.algo = &rk3x_i2c_algorithm;
 	i2c->adap.retries = 3;
diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index 3eafe0eb3e4c..3f567d436536 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -1076,7 +1076,7 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 	else
 		s3c24xx_i2c_parse_dt(pdev->dev.of_node, i2c);
 
-	strlcpy(i2c->adap.name, "s3c2410-i2c", sizeof(i2c->adap.name));
+	strscpy(i2c->adap.name, "s3c2410-i2c", sizeof(i2c->adap.name));
 	i2c->adap.owner = THIS_MODULE;
 	i2c->adap.algo = &s3c24xx_i2c_algorithm;
 	i2c->adap.retries = 2;
diff --git a/drivers/i2c/busses/i2c-sh_mobile.c b/drivers/i2c/busses/i2c-sh_mobile.c
index bdd60770779a..0e404ad04e95 100644
--- a/drivers/i2c/busses/i2c-sh_mobile.c
+++ b/drivers/i2c/busses/i2c-sh_mobile.c
@@ -930,7 +930,7 @@ static int sh_mobile_i2c_probe(struct platform_device *dev)
 	adap->nr = dev->id;
 	adap->dev.of_node = dev->dev.of_node;
 
-	strlcpy(adap->name, dev->name, sizeof(adap->name));
+	strscpy(adap->name, dev->name, sizeof(adap->name));
 
 	spin_lock_init(&pd->lock);
 	init_waitqueue_head(&pd->wait);
diff --git a/drivers/i2c/busses/i2c-simtec.c b/drivers/i2c/busses/i2c-simtec.c
index 458c7bcf1d24..87701744752f 100644
--- a/drivers/i2c/busses/i2c-simtec.c
+++ b/drivers/i2c/busses/i2c-simtec.c
@@ -99,7 +99,7 @@ static int simtec_i2c_probe(struct platform_device *dev)
 	pd->adap.algo_data = &pd->bit;
 	pd->adap.dev.parent = &dev->dev;
 
-	strlcpy(pd->adap.name, "Simtec I2C", sizeof(pd->adap.name));
+	strscpy(pd->adap.name, "Simtec I2C", sizeof(pd->adap.name));
 
 	pd->bit.data = pd;
 	pd->bit.setsda = simtec_i2c_setsda;
diff --git a/drivers/i2c/busses/i2c-sirf.c b/drivers/i2c/busses/i2c-sirf.c
index 30db8fafe078..2a164d958777 100644
--- a/drivers/i2c/busses/i2c-sirf.c
+++ b/drivers/i2c/busses/i2c-sirf.c
@@ -332,7 +332,7 @@ static int i2c_sirfsoc_probe(struct platform_device *pdev)
 	adap->dev.parent = &pdev->dev;
 	adap->nr = pdev->id;
 
-	strlcpy(adap->name, "sirfsoc-i2c", sizeof(adap->name));
+	strscpy(adap->name, "sirfsoc-i2c", sizeof(adap->name));
 
 	platform_set_drvdata(pdev, adap);
 	init_completion(&siic->done);
diff --git a/drivers/i2c/busses/i2c-stu300.c b/drivers/i2c/busses/i2c-stu300.c
index 64d739baf480..5f4aa74784ba 100644
--- a/drivers/i2c/busses/i2c-stu300.c
+++ b/drivers/i2c/busses/i2c-stu300.c
@@ -905,7 +905,7 @@ static int stu300_probe(struct platform_device *pdev)
 	adap->owner = THIS_MODULE;
 	/* DDC class but actually often used for more generic I2C */
 	adap->class = I2C_CLASS_DEPRECATED;
-	strlcpy(adap->name, "ST Microelectronics DDC I2C adapter",
+	strscpy(adap->name, "ST Microelectronics DDC I2C adapter",
 		sizeof(adap->name));
 	adap->nr = bus_nr;
 	adap->algo = &stu300_algo;
diff --git a/drivers/i2c/busses/i2c-sun6i-p2wi.c b/drivers/i2c/busses/i2c-sun6i-p2wi.c
index 2f6f6468214d..9e3483f507ff 100644
--- a/drivers/i2c/busses/i2c-sun6i-p2wi.c
+++ b/drivers/i2c/busses/i2c-sun6i-p2wi.c
@@ -234,7 +234,7 @@ static int p2wi_probe(struct platform_device *pdev)
 	if (IS_ERR(p2wi->regs))
 		return PTR_ERR(p2wi->regs);
 
-	strlcpy(p2wi->adapter.name, pdev->name, sizeof(p2wi->adapter.name));
+	strscpy(p2wi->adapter.name, pdev->name, sizeof(p2wi->adapter.name));
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
 		return irq;
diff --git a/drivers/i2c/busses/i2c-taos-evm.c b/drivers/i2c/busses/i2c-taos-evm.c
index b4050f5b6746..b0f0120793e1 100644
--- a/drivers/i2c/busses/i2c-taos-evm.c
+++ b/drivers/i2c/busses/i2c-taos-evm.c
@@ -239,7 +239,7 @@ static int taos_connect(struct serio *serio, struct serio_driver *drv)
 		dev_err(&serio->dev, "TAOS EVM identification failed\n");
 		goto exit_close;
 	}
-	strlcpy(adapter->name, name, sizeof(adapter->name));
+	strscpy(adapter->name, name, sizeof(adapter->name));
 
 	/* Turn echo off for better performance */
 	taos->state = TAOS_STATE_EOFF;
diff --git a/drivers/i2c/busses/i2c-tegra-bpmp.c b/drivers/i2c/busses/i2c-tegra-bpmp.c
index ec7a7e917edd..e539af505813 100644
--- a/drivers/i2c/busses/i2c-tegra-bpmp.c
+++ b/drivers/i2c/busses/i2c-tegra-bpmp.c
@@ -308,7 +308,7 @@ static int tegra_bpmp_i2c_probe(struct platform_device *pdev)
 
 	i2c_set_adapdata(&i2c->adapter, i2c);
 	i2c->adapter.owner = THIS_MODULE;
-	strlcpy(i2c->adapter.name, "Tegra BPMP I2C adapter",
+	strscpy(i2c->adapter.name, "Tegra BPMP I2C adapter",
 		sizeof(i2c->adapter.name));
 	i2c->adapter.algo = &tegra_bpmp_i2c_algo;
 	i2c->adapter.dev.parent = &pdev->dev;
diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 6f08c0c3238d..37f77aab6df8 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -1774,7 +1774,7 @@ static int tegra_i2c_probe(struct platform_device *pdev)
 	if (i2c_dev->hw->supports_bus_clear)
 		i2c_dev->adapter.bus_recovery_info = &tegra_i2c_recovery_info;
 
-	strlcpy(i2c_dev->adapter.name, dev_name(i2c_dev->dev),
+	strscpy(i2c_dev->adapter.name, dev_name(i2c_dev->dev),
 		sizeof(i2c_dev->adapter.name));
 
 	err = i2c_add_numbered_adapter(&i2c_dev->adapter);
diff --git a/drivers/i2c/busses/i2c-uniphier-f.c b/drivers/i2c/busses/i2c-uniphier-f.c
index cb4666c54a23..d7b622891e52 100644
--- a/drivers/i2c/busses/i2c-uniphier-f.c
+++ b/drivers/i2c/busses/i2c-uniphier-f.c
@@ -564,7 +564,7 @@ static int uniphier_fi2c_probe(struct platform_device *pdev)
 	priv->adap.algo = &uniphier_fi2c_algo;
 	priv->adap.dev.parent = dev;
 	priv->adap.dev.of_node = dev->of_node;
-	strlcpy(priv->adap.name, "UniPhier FI2C", sizeof(priv->adap.name));
+	strscpy(priv->adap.name, "UniPhier FI2C", sizeof(priv->adap.name));
 	priv->adap.bus_recovery_info = &uniphier_fi2c_bus_recovery_info;
 	i2c_set_adapdata(&priv->adap, priv);
 	platform_set_drvdata(pdev, priv);
diff --git a/drivers/i2c/busses/i2c-uniphier.c b/drivers/i2c/busses/i2c-uniphier.c
index ee00a44bf4c7..e3ebae381f08 100644
--- a/drivers/i2c/busses/i2c-uniphier.c
+++ b/drivers/i2c/busses/i2c-uniphier.c
@@ -358,7 +358,7 @@ static int uniphier_i2c_probe(struct platform_device *pdev)
 	priv->adap.algo = &uniphier_i2c_algo;
 	priv->adap.dev.parent = dev;
 	priv->adap.dev.of_node = dev->of_node;
-	strlcpy(priv->adap.name, "UniPhier I2C", sizeof(priv->adap.name));
+	strscpy(priv->adap.name, "UniPhier I2C", sizeof(priv->adap.name));
 	priv->adap.bus_recovery_info = &uniphier_i2c_bus_recovery_info;
 	i2c_set_adapdata(&priv->adap, priv);
 	platform_set_drvdata(pdev, priv);
diff --git a/drivers/i2c/busses/i2c-versatile.c b/drivers/i2c/busses/i2c-versatile.c
index 8d980b1374a8..64f58493f96a 100644
--- a/drivers/i2c/busses/i2c-versatile.c
+++ b/drivers/i2c/busses/i2c-versatile.c
@@ -79,7 +79,8 @@ static int i2c_versatile_probe(struct platform_device *dev)
 	writel(SCL | SDA, i2c->base + I2C_CONTROLS);
 
 	i2c->adap.owner = THIS_MODULE;
-	strlcpy(i2c->adap.name, "Versatile I2C adapter", sizeof(i2c->adap.name));
+	strscpy(i2c->adap.name, "Versatile I2C adapter",
+		sizeof(i2c->adap.name));
 	i2c->adap.algo_data = &i2c->algo;
 	i2c->adap.dev.parent = &dev->dev;
 	i2c->adap.dev.of_node = dev->dev.of_node;
diff --git a/drivers/i2c/busses/i2c-wmt.c b/drivers/i2c/busses/i2c-wmt.c
index 88f5aafdce5b..7d4bc8736079 100644
--- a/drivers/i2c/busses/i2c-wmt.c
+++ b/drivers/i2c/busses/i2c-wmt.c
@@ -413,7 +413,7 @@ static int wmt_i2c_probe(struct platform_device *pdev)
 
 	adap = &i2c_dev->adapter;
 	i2c_set_adapdata(adap, i2c_dev);
-	strlcpy(adap->name, "WMT I2C adapter", sizeof(adap->name));
+	strscpy(adap->name, "WMT I2C adapter", sizeof(adap->name));
 	adap->owner = THIS_MODULE;
 	adap->algo = &wmt_i2c_algo;
 	adap->dev.parent = &pdev->dev;
diff --git a/drivers/i2c/busses/i2c-zx2967.c b/drivers/i2c/busses/i2c-zx2967.c
index 8db9519695a6..f37eebb36ee4 100644
--- a/drivers/i2c/busses/i2c-zx2967.c
+++ b/drivers/i2c/busses/i2c-zx2967.c
@@ -557,8 +557,7 @@ static int zx2967_i2c_probe(struct platform_device *pdev)
 	}
 
 	i2c_set_adapdata(&i2c->adap, i2c);
-	strlcpy(i2c->adap.name, "zx2967 i2c adapter",
-		sizeof(i2c->adap.name));
+	strscpy(i2c->adap.name, "zx2967 i2c adapter", sizeof(i2c->adap.name));
 	i2c->adap.algo = &zx2967_i2c_algo;
 	i2c->adap.quirks = &zx2967_i2c_quirks;
 	i2c->adap.nr = pdev->id;
diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
index 573b5da145d1..86dbe644385e 100644
--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -885,7 +885,7 @@ i2c_new_client_device(struct i2c_adapter *adap, struct i2c_board_info const *inf
 		client->init_irq = i2c_dev_irq_from_resources(info->resources,
 							 info->num_resources);
 
-	strlcpy(client->name, info->type, sizeof(client->name));
+	strscpy(client->name, info->type, sizeof(client->name));
 
 	status = i2c_check_addr_validity(client->addr, client->flags);
 	if (status) {
diff --git a/drivers/i2c/i2c-smbus.c b/drivers/i2c/i2c-smbus.c
index d3d06e3b4f3b..f73cbb69b569 100644
--- a/drivers/i2c/i2c-smbus.c
+++ b/drivers/i2c/i2c-smbus.c
@@ -390,7 +390,7 @@ void i2c_register_spd(struct i2c_adapter *adap)
 		unsigned short addr_list[2];
 
 		memset(&info, 0, sizeof(struct i2c_board_info));
-		strlcpy(info.type, name, I2C_NAME_SIZE);
+		strscpy(info.type, name, I2C_NAME_SIZE);
 		addr_list[0] = 0x50 + n;
 		addr_list[1] = I2C_CLIENT_END;
 
diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 7ee7ffe22ae3..04f257ed1a55 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -1244,7 +1244,7 @@ static void __init intel_idle_init_cstates_acpi(struct cpuidle_driver *drv)
 		state = &drv->states[drv->state_count++];
 
 		snprintf(state->name, CPUIDLE_NAME_LEN, "C%d_ACPI", cstate);
-		strlcpy(state->desc, cx->desc, CPUIDLE_DESC_LEN);
+		strscpy(state->desc, cx->desc, CPUIDLE_DESC_LEN);
 		state->exit_latency = cx->latency;
 		/*
 		 * For C1-type C-states use the same number for both the exit
diff --git a/drivers/iio/common/st_sensors/st_sensors_core.c b/drivers/iio/common/st_sensors/st_sensors_core.c
index 7a69c1be7393..927051c5f369 100644
--- a/drivers/iio/common/st_sensors/st_sensors_core.c
+++ b/drivers/iio/common/st_sensors/st_sensors_core.c
@@ -353,7 +353,7 @@ void st_sensors_dev_name_probe(struct device *dev, char *name, int len)
 		return;
 
 	/* The name from the match takes precedence if present */
-	strlcpy(name, match, len);
+	strscpy(name, match, len);
 }
 EXPORT_SYMBOL(st_sensors_dev_name_probe);
 
diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_acpi.c b/drivers/iio/imu/inv_mpu6050/inv_mpu_acpi.c
index f8f0cf716bc6..8078b19f7e93 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_acpi.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_acpi.c
@@ -65,7 +65,7 @@ static int asus_acpi_get_sensor_info(struct acpi_device *adev,
 
 			sub_elem = &elem->package.elements[j];
 			if (sub_elem->type == ACPI_TYPE_STRING)
-				strlcpy(info->type, sub_elem->string.pointer,
+				strscpy(info->type, sub_elem->string.pointer,
 					sizeof(info->type));
 			else if (sub_elem->type == ACPI_TYPE_INTEGER) {
 				if (sub_elem->integer.value != client->addr) {
@@ -159,7 +159,7 @@ int inv_mpu_acpi_create_mux_client(struct i2c_client *client)
 				char *name;
 
 				info.addr = secondary;
-				strlcpy(info.type, dev_name(&adev->dev),
+				strscpy(info.type, dev_name(&adev->dev),
 					sizeof(info.type));
 				name = strchr(info.type, ':');
 				if (name)
diff --git a/drivers/infiniband/core/cma_configfs.c b/drivers/infiniband/core/cma_configfs.c
index 7ec4af2ed87a..b5e8ae026072 100644
--- a/drivers/infiniband/core/cma_configfs.c
+++ b/drivers/infiniband/core/cma_configfs.c
@@ -299,7 +299,7 @@ static struct config_group *make_cma_dev(struct config_group *group,
 		goto fail;
 	}
 
-	strlcpy(cma_dev_group->name, name, sizeof(cma_dev_group->name));
+	strscpy(cma_dev_group->name, name, sizeof(cma_dev_group->name));
 
 	config_group_init_type_name(&cma_dev_group->ports_group, "ports",
 				    &cma_ports_group_type);
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index a3b1fc84cdca..fd089df08579 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -420,7 +420,7 @@ int ib_device_rename(struct ib_device *ibdev, const char *name)
 		return ret;
 	}
 
-	strlcpy(ibdev->name, name, IB_DEVICE_NAME_MAX);
+	strscpy(ibdev->name, name, IB_DEVICE_NAME_MAX);
 	ret = rename_compat_devs(ibdev);
 
 	downgrade_write(&devices_rwsem);
@@ -1165,7 +1165,7 @@ static int assign_name(struct ib_device *device, const char *name)
 		ret = -ENFILE;
 		goto out;
 	}
-	strlcpy(device->name, dev_name(&device->dev), IB_DEVICE_NAME_MAX);
+	strscpy(device->name, dev_name(&device->dev), IB_DEVICE_NAME_MAX);
 
 	ret = xa_alloc_cyclic(&devices, &device->index, device, xa_limit_31b,
 			&last_id, GFP_KERNEL);
diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 04621ba8fa76..d837503e382f 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -691,7 +691,7 @@ static int bnxt_re_register_ib(struct bnxt_re_dev *rdev)
 
 	/* ib device init */
 	ibdev->node_type = RDMA_NODE_IB_CA;
-	strlcpy(ibdev->node_desc, BNXT_RE_DESC " HCA",
+	strscpy(ibdev->node_desc, BNXT_RE_DESC " HCA",
 		strlen(BNXT_RE_DESC) + 5);
 	ibdev->phys_port_cnt = 1;
 
diff --git a/drivers/infiniband/hw/efa/efa_main.c b/drivers/infiniband/hw/efa/efa_main.c
index 6faed3a81e08..ee669de63965 100644
--- a/drivers/infiniband/hw/efa/efa_main.c
+++ b/drivers/infiniband/hw/efa/efa_main.c
@@ -209,10 +209,10 @@ static void efa_set_host_info(struct efa_dev *dev)
 	if (!hinf)
 		return;
 
-	strlcpy(hinf->os_dist_str, utsname()->release,
+	strscpy(hinf->os_dist_str, utsname()->release,
 		min(sizeof(hinf->os_dist_str), sizeof(utsname()->release)));
 	hinf->os_type = EFA_ADMIN_OS_LINUX;
-	strlcpy(hinf->kernel_ver_str, utsname()->version,
+	strscpy(hinf->kernel_ver_str, utsname()->version,
 		min(sizeof(hinf->kernel_ver_str), sizeof(utsname()->version)));
 	hinf->kernel_ver = LINUX_VERSION_CODE;
 	EFA_SET(&hinf->driver_ver, EFA_ADMIN_HOST_INFO_DRIVER_MAJOR, 0);
diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 329ee4f48d95..adc975988801 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -1004,7 +1004,7 @@ static int allocate_ctxt(struct hfi1_filedata *fd, struct hfi1_devdata *dd,
 	uctxt->userversion = uinfo->userversion;
 	uctxt->flags = hfi1_cap_mask; /* save current flag state */
 	init_waitqueue_head(&uctxt->wait);
-	strlcpy(uctxt->comm, current->comm, sizeof(uctxt->comm));
+	strscpy(uctxt->comm, current->comm, sizeof(uctxt->comm));
 	memcpy(uctxt->uuid, uinfo->uuid, sizeof(uctxt->uuid));
 	uctxt->jkey = generate_jkey(current_uid());
 	hfi1_stats.sps_ctxts++;
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 3591923abebb..85089a0a71e7 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1843,7 +1843,7 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 
 	ib_set_device_ops(ibdev, &hfi1_dev_ops);
 
-	strlcpy(ibdev->node_desc, init_utsname()->nodename,
+	strscpy(ibdev->node_desc, init_utsname()->nodename,
 		sizeof(ibdev->node_desc));
 
 	/*
diff --git a/drivers/infiniband/hw/mthca/mthca_cmd.c b/drivers/infiniband/hw/mthca/mthca_cmd.c
index bdf5ed38de22..12e95fa137c8 100644
--- a/drivers/infiniband/hw/mthca/mthca_cmd.c
+++ b/drivers/infiniband/hw/mthca/mthca_cmd.c
@@ -1252,7 +1252,8 @@ static void get_board_id(void *vsd, char *board_id)
 
 	if (be16_to_cpup(vsd + VSD_OFFSET_SIG1) == VSD_SIGNATURE_TOPSPIN &&
 	    be16_to_cpup(vsd + VSD_OFFSET_SIG2) == VSD_SIGNATURE_TOPSPIN) {
-		strlcpy(board_id, vsd + VSD_OFFSET_TS_BOARD_ID, MTHCA_BOARD_ID_LEN);
+		strscpy(board_id, vsd + VSD_OFFSET_TS_BOARD_ID,
+			MTHCA_BOARD_ID_LEN);
 	} else {
 		/*
 		 * The board ID is a string but the firmware byte
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index c51c3f40700e..c17716ab8b39 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -1363,7 +1363,7 @@ static int ocrdma_mbx_get_ctrl_attribs(struct ocrdma_dev *dev)
 		dev->hba_port_num = (hba_attribs->ptpnum_maxdoms_hbast_cv &
 					OCRDMA_HBA_ATTRB_PTNUM_MASK)
 					>> OCRDMA_HBA_ATTRB_PTNUM_SHIFT;
-		strlcpy(dev->model_number,
+		strscpy(dev->model_number,
 			hba_attribs->controller_model_number,
 			sizeof(dev->model_number));
 	}
diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniband/hw/qib/qib_file_ops.c
index ff87a67dd7b7..12578a729968 100644
--- a/drivers/infiniband/hw/qib/qib_file_ops.c
+++ b/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -1321,7 +1321,7 @@ static int setup_ctxt(struct qib_pportdata *ppd, int ctxt,
 	rcd->tid_pg_list = ptmp;
 	rcd->pid = current->pid;
 	init_waitqueue_head(&dd->rcd[ctxt]->wait);
-	strlcpy(rcd->comm, current->comm, sizeof(rcd->comm));
+	strscpy(rcd->comm, current->comm, sizeof(rcd->comm));
 	ctxt_fp(fp) = rcd;
 	qib_stats.sps_ctxts++;
 	dd->freectxts--;
diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 189a0ce6056a..45e50b2ebc34 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -2146,7 +2146,7 @@ static void qib_7322_handle_hwerrors(struct qib_devdata *dd, char *msg,
 
 	if (hwerrs & HWE_MASK(PowerOnBISTFailed)) {
 		isfatal = 1;
-		strlcpy(msg,
+		strscpy(msg,
 			"[Memory BIST test failed, InfiniPath hardware unusable]",
 			msgl);
 		/* ignore from now on, so disable until driver reloaded */
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index f9c832e82552..f051776d0310 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -1120,7 +1120,7 @@ int rxe_register_device(struct rxe_dev *rxe, const char *ibdev_name)
 	struct crypto_shash *tfm;
 	u64 dma_mask;
 
-	strlcpy(dev->node_desc, "rxe", sizeof(dev->node_desc));
+	strscpy(dev->node_desc, "rxe", sizeof(dev->node_desc));
 
 	dev->node_type = RDMA_NODE_IB_CA;
 	dev->phys_port_cnt = 1;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
index 67a21fdf5367..989b71c3c85c 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
@@ -65,10 +65,10 @@ static void ipoib_get_drvinfo(struct net_device *netdev,
 
 	ib_get_device_fw_str(priv->ca, drvinfo->fw_version);
 
-	strlcpy(drvinfo->bus_info, dev_name(priv->ca->dev.parent),
+	strscpy(drvinfo->bus_info, dev_name(priv->ca->dev.parent),
 		sizeof(drvinfo->bus_info));
 
-	strlcpy(drvinfo->driver, "ib_ipoib", sizeof(drvinfo->driver));
+	strscpy(drvinfo->driver, "ib_ipoib", sizeof(drvinfo->driver));
 }
 
 static int ipoib_get_coalesce(struct net_device *dev,
diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_ethtool.c b/drivers/infiniband/ulp/opa_vnic/opa_vnic_ethtool.c
index 42d557dff19d..f553cfe267a9 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_ethtool.c
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_ethtool.c
@@ -124,8 +124,9 @@ static struct vnic_stats vnic_gstrings_stats[] = {
 static void vnic_get_drvinfo(struct net_device *netdev,
 			     struct ethtool_drvinfo *drvinfo)
 {
-	strlcpy(drvinfo->driver, opa_vnic_driver_name, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->bus_info, dev_name(netdev->dev.parent),
+	strscpy(drvinfo->driver, opa_vnic_driver_name,
+		sizeof(drvinfo->driver));
+	strscpy(drvinfo->bus_info, dev_name(netdev->dev.parent),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index f298adc02acb..c1e6ce3548c4 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -1441,7 +1441,7 @@ static struct rtrs_clt_sess *alloc_sess(struct rtrs_clt *clt,
 	if (path->src)
 		memcpy(&sess->s.src_addr, path->src,
 		       rdma_addr_size((struct sockaddr *)path->src));
-	strlcpy(sess->s.sessname, clt->sessname, sizeof(sess->s.sessname));
+	strscpy(sess->s.sessname, clt->sessname, sizeof(sess->s.sessname));
 	sess->s.con_num = con_num;
 	sess->clt = clt;
 	sess->max_pages_per_mr = max_segments * max_segment_size >> 12;
@@ -2565,7 +2565,7 @@ static struct rtrs_clt *alloc_clt(const char *sessname, size_t paths_num,
 	clt->priv = priv;
 	clt->link_ev = link_ev;
 	clt->mp_policy = MP_POLICY_MIN_INFLIGHT;
-	strlcpy(clt->sessname, sessname, sizeof(clt->sessname));
+	strscpy(clt->sessname, sessname, sizeof(clt->sessname));
 	init_waitqueue_head(&clt->permits_wait);
 	mutex_init(&clt->paths_ev_mutex);
 	mutex_init(&clt->paths_mutex);
@@ -2916,7 +2916,7 @@ int rtrs_clt_query(struct rtrs_clt *clt, struct rtrs_attrs *attr)
 	attr->queue_depth      = clt->queue_depth;
 	attr->max_io_size      = clt->max_io_size;
 	attr->sess_kobj	       = &clt->dev.kobj;
-	strlcpy(attr->sessname, clt->sessname, sizeof(attr->sessname));
+	strscpy(attr->sessname, clt->sessname, sizeof(attr->sessname));
 
 	return 0;
 }
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index d6f93601712e..dc6738d40e25 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -800,7 +800,7 @@ static int process_info_req(struct rtrs_srv_con *con,
 	rwr = kcalloc(sess->mrs_num, sizeof(*rwr), GFP_KERNEL);
 	if (unlikely(!rwr))
 		return -ENOMEM;
-	strlcpy(sess->s.sessname, msg->sessname, sizeof(sess->s.sessname));
+	strscpy(sess->s.sessname, msg->sessname, sizeof(sess->s.sessname));
 
 	tx_sz  = sizeof(*rsp);
 	tx_sz += sizeof(rsp->desc[0]) * sess->mrs_num;
@@ -1282,8 +1282,8 @@ int rtrs_srv_get_sess_name(struct rtrs_srv *srv, char *sessname, size_t len)
 	list_for_each_entry(sess, &srv->paths_list, s.entry) {
 		if (sess->state != RTRS_SRV_CONNECTED)
 			continue;
-		strlcpy(sessname, sess->s.sessname,
-		       min_t(size_t, sizeof(sess->s.sessname), len));
+		strscpy(sessname, sess->s.sessname,
+			min_t(size_t, sizeof(sess->s.sessname), len));
 		err = 0;
 		break;
 	}
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 53a8becac827..3e5b9fed07d7 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2299,7 +2299,7 @@ static int srpt_cm_req_recv(struct srpt_device *const sdev,
 		goto free_recv_ring;
 	}
 
-	strlcpy(ch->sess_name, src_addr, sizeof(ch->sess_name));
+	strscpy(ch->sess_name, src_addr, sizeof(ch->sess_name));
 	snprintf(i_port_id, sizeof(i_port_id), "0x%016llx%016llx",
 			be64_to_cpu(*(__be64 *)nexus->i_port_id),
 			be64_to_cpu(*(__be64 *)(nexus->i_port_id + 8)));
diff --git a/drivers/input/keyboard/lkkbd.c b/drivers/input/keyboard/lkkbd.c
index e4a1839ca934..ea9a1d8834c1 100644
--- a/drivers/input/keyboard/lkkbd.c
+++ b/drivers/input/keyboard/lkkbd.c
@@ -359,18 +359,18 @@ static void lkkbd_detection_done(struct lkkbd *lk)
 	 */
 	switch (lk->id[4]) {
 	case 1:
-		strlcpy(lk->name, "DEC LK201 keyboard", sizeof(lk->name));
+		strscpy(lk->name, "DEC LK201 keyboard", sizeof(lk->name));
 
 		if (lk201_compose_is_alt)
 			lk->keycode[0xb1] = KEY_LEFTALT;
 		break;
 
 	case 2:
-		strlcpy(lk->name, "DEC LK401 keyboard", sizeof(lk->name));
+		strscpy(lk->name, "DEC LK401 keyboard", sizeof(lk->name));
 		break;
 
 	default:
-		strlcpy(lk->name, "Unknown DEC keyboard", sizeof(lk->name));
+		strscpy(lk->name, "Unknown DEC keyboard", sizeof(lk->name));
 		printk(KERN_ERR
 			"lkkbd: keyboard on %s is unknown, please report to "
 			"Jan-Benedict Glaw <jbglaw@lug-owl.de>\n", lk->phys);
@@ -626,7 +626,7 @@ static int lkkbd_connect(struct serio *serio, struct serio_driver *drv)
 	lk->ctrlclick_volume = ctrlclick_volume;
 	memcpy(lk->keycode, lkkbd_keycode, sizeof(lk->keycode));
 
-	strlcpy(lk->name, "DEC LK keyboard", sizeof(lk->name));
+	strscpy(lk->name, "DEC LK keyboard", sizeof(lk->name));
 	snprintf(lk->phys, sizeof(lk->phys), "%s/input0", serio->phys);
 
 	input_dev->name = lk->name;
diff --git a/drivers/input/misc/keyspan_remote.c b/drivers/input/misc/keyspan_remote.c
index 4650f4a94989..d4f5ef5ed46c 100644
--- a/drivers/input/misc/keyspan_remote.c
+++ b/drivers/input/misc/keyspan_remote.c
@@ -485,7 +485,8 @@ static int keyspan_probe(struct usb_interface *interface, const struct usb_devic
 	}
 
 	if (udev->manufacturer)
-		strlcpy(remote->name, udev->manufacturer, sizeof(remote->name));
+		strscpy(remote->name, udev->manufacturer,
+			sizeof(remote->name));
 
 	if (udev->product) {
 		if (udev->manufacturer)
diff --git a/drivers/input/mouse/hgpk.c b/drivers/input/mouse/hgpk.c
index 4dc441309aac..523b26a117d6 100644
--- a/drivers/input/mouse/hgpk.c
+++ b/drivers/input/mouse/hgpk.c
@@ -1057,7 +1057,7 @@ void hgpk_module_init(void)
 						strlen(hgpk_mode_name));
 	if (hgpk_default_mode == HGPK_MODE_INVALID) {
 		hgpk_default_mode = HGPK_MODE_MOUSE;
-		strlcpy(hgpk_mode_name, hgpk_mode_names[HGPK_MODE_MOUSE],
+		strscpy(hgpk_mode_name, hgpk_mode_names[HGPK_MODE_MOUSE],
 			sizeof(hgpk_mode_name));
 	}
 }
diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 82577095e175..c8cf893793ea 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -714,8 +714,8 @@ static void synaptics_pt_create(struct psmouse *psmouse)
 	}
 
 	serio->id.type = SERIO_PS_PSTHRU;
-	strlcpy(serio->name, "Synaptics pass-through", sizeof(serio->name));
-	strlcpy(serio->phys, "synaptics-pt/serio0", sizeof(serio->phys));
+	strscpy(serio->name, "Synaptics pass-through", sizeof(serio->name));
+	strscpy(serio->phys, "synaptics-pt/serio0", sizeof(serio->phys));
 	serio->write = synaptics_pt_write;
 	serio->start = synaptics_pt_start;
 	serio->stop = synaptics_pt_stop;
diff --git a/drivers/input/mouse/synaptics_usb.c b/drivers/input/mouse/synaptics_usb.c
index b5ff27e32a0c..75e45f3ae675 100644
--- a/drivers/input/mouse/synaptics_usb.c
+++ b/drivers/input/mouse/synaptics_usb.c
@@ -354,7 +354,7 @@ static int synusb_probe(struct usb_interface *intf,
 	synusb->urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 
 	if (udev->manufacturer)
-		strlcpy(synusb->name, udev->manufacturer,
+		strscpy(synusb->name, udev->manufacturer,
 			sizeof(synusb->name));
 
 	if (udev->product) {
diff --git a/drivers/input/mouse/vsxxxaa.c b/drivers/input/mouse/vsxxxaa.c
index bd415f4b574e..3bd6e723a422 100644
--- a/drivers/input/mouse/vsxxxaa.c
+++ b/drivers/input/mouse/vsxxxaa.c
@@ -138,12 +138,12 @@ static void vsxxxaa_detection_done(struct vsxxxaa *mouse)
 {
 	switch (mouse->type) {
 	case 0x02:
-		strlcpy(mouse->name, "DEC VSXXX-AA/-GA mouse",
+		strscpy(mouse->name, "DEC VSXXX-AA/-GA mouse",
 			sizeof(mouse->name));
 		break;
 
 	case 0x04:
-		strlcpy(mouse->name, "DEC VSXXX-AB digitizer",
+		strscpy(mouse->name, "DEC VSXXX-AB digitizer",
 			sizeof(mouse->name));
 		break;
 
diff --git a/drivers/input/rmi4/rmi_f03.c b/drivers/input/rmi4/rmi_f03.c
index c194b1664b10..1e11ea30d7bd 100644
--- a/drivers/input/rmi4/rmi_f03.c
+++ b/drivers/input/rmi4/rmi_f03.c
@@ -181,7 +181,7 @@ static int rmi_f03_register_pt(struct f03_data *f03)
 	serio->close = rmi_f03_pt_close;
 	serio->port_data = f03;
 
-	strlcpy(serio->name, "RMI4 PS/2 pass-through", sizeof(serio->name));
+	strscpy(serio->name, "RMI4 PS/2 pass-through", sizeof(serio->name));
 	snprintf(serio->phys, sizeof(serio->phys), "%s/serio0",
 		 dev_name(&f03->fn->dev));
 	serio->dev.parent = &f03->fn->dev;
diff --git a/drivers/input/rmi4/rmi_f54.c b/drivers/input/rmi4/rmi_f54.c
index 6b23e679606e..ed82dac01d77 100644
--- a/drivers/input/rmi4/rmi_f54.c
+++ b/drivers/input/rmi4/rmi_f54.c
@@ -384,8 +384,8 @@ static int rmi_f54_vidioc_querycap(struct file *file, void *priv,
 {
 	struct f54_data *f54 = video_drvdata(file);
 
-	strlcpy(cap->driver, F54_NAME, sizeof(cap->driver));
-	strlcpy(cap->card, SYNAPTICS_INPUT_DEVICE_NAME, sizeof(cap->card));
+	strscpy(cap->driver, F54_NAME, sizeof(cap->driver));
+	strscpy(cap->card, SYNAPTICS_INPUT_DEVICE_NAME, sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info),
 		"rmi4:%s", dev_name(&f54->fn->dev));
 
@@ -404,7 +404,7 @@ static int rmi_f54_vidioc_enum_input(struct file *file, void *priv,
 
 	i->type = V4L2_INPUT_TYPE_TOUCH;
 
-	strlcpy(i->name, rmi_f54_report_type_names[reptype], sizeof(i->name));
+	strscpy(i->name, rmi_f54_report_type_names[reptype], sizeof(i->name));
 	return 0;
 }
 
@@ -690,7 +690,7 @@ static int rmi_f54_probe(struct rmi_function *fn)
 	rmi_f54_set_input(f54, 0);
 
 	/* register video device */
-	strlcpy(f54->v4l2.name, F54_NAME, sizeof(f54->v4l2.name));
+	strscpy(f54->v4l2.name, F54_NAME, sizeof(f54->v4l2.name));
 	ret = v4l2_device_register(&fn->dev, &f54->v4l2);
 	if (ret) {
 		dev_err(&fn->dev, "Unable to register video dev.\n");
diff --git a/drivers/input/serio/altera_ps2.c b/drivers/input/serio/altera_ps2.c
index 379e9240c2b3..3a92304f64fb 100644
--- a/drivers/input/serio/altera_ps2.c
+++ b/drivers/input/serio/altera_ps2.c
@@ -110,8 +110,8 @@ static int altera_ps2_probe(struct platform_device *pdev)
 	serio->write		= altera_ps2_write;
 	serio->open		= altera_ps2_open;
 	serio->close		= altera_ps2_close;
-	strlcpy(serio->name, dev_name(&pdev->dev), sizeof(serio->name));
-	strlcpy(serio->phys, dev_name(&pdev->dev), sizeof(serio->phys));
+	strscpy(serio->name, dev_name(&pdev->dev), sizeof(serio->name));
+	strscpy(serio->phys, dev_name(&pdev->dev), sizeof(serio->phys));
 	serio->port_data	= ps2if;
 	serio->dev.parent	= &pdev->dev;
 	ps2if->io		= serio;
diff --git a/drivers/input/serio/ambakmi.c b/drivers/input/serio/ambakmi.c
index ecdeca147ed7..e7853b32c030 100644
--- a/drivers/input/serio/ambakmi.c
+++ b/drivers/input/serio/ambakmi.c
@@ -126,8 +126,8 @@ static int amba_kmi_probe(struct amba_device *dev,
 	io->write	= amba_kmi_write;
 	io->open	= amba_kmi_open;
 	io->close	= amba_kmi_close;
-	strlcpy(io->name, dev_name(&dev->dev), sizeof(io->name));
-	strlcpy(io->phys, dev_name(&dev->dev), sizeof(io->phys));
+	strscpy(io->name, dev_name(&dev->dev), sizeof(io->name));
+	strscpy(io->phys, dev_name(&dev->dev), sizeof(io->phys));
 	io->port_data	= kmi;
 	io->dev.parent	= &dev->dev;
 
diff --git a/drivers/input/serio/ams_delta_serio.c b/drivers/input/serio/ams_delta_serio.c
index 1c0be299f179..b0855f36c82b 100644
--- a/drivers/input/serio/ams_delta_serio.c
+++ b/drivers/input/serio/ams_delta_serio.c
@@ -159,8 +159,9 @@ static int ams_delta_serio_init(struct platform_device *pdev)
 	serio->id.type = SERIO_8042;
 	serio->open = ams_delta_serio_open;
 	serio->close = ams_delta_serio_close;
-	strlcpy(serio->name, "AMS DELTA keyboard adapter", sizeof(serio->name));
-	strlcpy(serio->phys, dev_name(&pdev->dev), sizeof(serio->phys));
+	strscpy(serio->name, "AMS DELTA keyboard adapter",
+		sizeof(serio->name));
+	strscpy(serio->phys, dev_name(&pdev->dev), sizeof(serio->phys));
 	serio->dev.parent = &pdev->dev;
 	serio->port_data = priv;
 
diff --git a/drivers/input/serio/apbps2.c b/drivers/input/serio/apbps2.c
index 594ac4e6f8ea..54e6620c9a8c 100644
--- a/drivers/input/serio/apbps2.c
+++ b/drivers/input/serio/apbps2.c
@@ -177,7 +177,7 @@ static int apbps2_of_probe(struct platform_device *ofdev)
 	priv->io->close = apbps2_close;
 	priv->io->write = apbps2_write;
 	priv->io->port_data = priv;
-	strlcpy(priv->io->name, "APBPS2 PS/2", sizeof(priv->io->name));
+	strscpy(priv->io->name, "APBPS2 PS/2", sizeof(priv->io->name));
 	snprintf(priv->io->phys, sizeof(priv->io->phys),
 		 "apbps2_%d", apbps2_idx++);
 
diff --git a/drivers/input/serio/ct82c710.c b/drivers/input/serio/ct82c710.c
index d45009d654bf..752ce60e2211 100644
--- a/drivers/input/serio/ct82c710.c
+++ b/drivers/input/serio/ct82c710.c
@@ -170,7 +170,7 @@ static int ct82c710_probe(struct platform_device *dev)
 	ct82c710_port->open = ct82c710_open;
 	ct82c710_port->close = ct82c710_close;
 	ct82c710_port->write = ct82c710_write;
-	strlcpy(ct82c710_port->name, "C&T 82c710 mouse port",
+	strscpy(ct82c710_port->name, "C&T 82c710 mouse port",
 		sizeof(ct82c710_port->name));
 	snprintf(ct82c710_port->phys, sizeof(ct82c710_port->phys),
 		 "isa%16llx/serio0", (unsigned long long)CT82C710_DATA);
diff --git a/drivers/input/serio/gscps2.c b/drivers/input/serio/gscps2.c
index 2f9775de3c5b..cae74d0edb09 100644
--- a/drivers/input/serio/gscps2.c
+++ b/drivers/input/serio/gscps2.c
@@ -357,7 +357,7 @@ static int __init gscps2_probe(struct parisc_device *dev)
 
 	snprintf(serio->name, sizeof(serio->name), "gsc-ps2-%s",
 		 (ps2port->id == GSC_ID_KEYBOARD) ? "keyboard" : "mouse");
-	strlcpy(serio->phys, dev_name(&dev->dev), sizeof(serio->phys));
+	strscpy(serio->phys, dev_name(&dev->dev), sizeof(serio->phys));
 	serio->id.type		= SERIO_8042;
 	serio->write		= gscps2_write;
 	serio->open		= gscps2_open;
diff --git a/drivers/input/serio/hyperv-keyboard.c b/drivers/input/serio/hyperv-keyboard.c
index 1a7b72a9016d..d62aefb2e245 100644
--- a/drivers/input/serio/hyperv-keyboard.c
+++ b/drivers/input/serio/hyperv-keyboard.c
@@ -334,9 +334,9 @@ static int hv_kbd_probe(struct hv_device *hv_dev,
 	hv_serio->dev.parent  = &hv_dev->device;
 	hv_serio->id.type = SERIO_8042_XL;
 	hv_serio->port_data = kbd_dev;
-	strlcpy(hv_serio->name, dev_name(&hv_dev->device),
+	strscpy(hv_serio->name, dev_name(&hv_dev->device),
 		sizeof(hv_serio->name));
-	strlcpy(hv_serio->phys, dev_name(&hv_dev->device),
+	strscpy(hv_serio->phys, dev_name(&hv_dev->device),
 		sizeof(hv_serio->phys));
 
 	hv_serio->start = hv_kbd_start;
diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index a4c9b9652560..8a5c8236d27b 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -948,7 +948,7 @@ static char i8042_pnp_aux_name[32];
 
 static void i8042_pnp_id_to_string(struct pnp_id *id, char *dst, int dst_size)
 {
-	strlcpy(dst, "PNP:", dst_size);
+	strscpy(dst, "PNP:", dst_size);
 
 	while (id) {
 		strlcat(dst, " ", dst_size);
@@ -968,7 +968,7 @@ static int i8042_pnp_kbd_probe(struct pnp_dev *dev, const struct pnp_device_id *
 	if (pnp_irq_valid(dev,0))
 		i8042_pnp_kbd_irq = pnp_irq(dev, 0);
 
-	strlcpy(i8042_pnp_kbd_name, did->id, sizeof(i8042_pnp_kbd_name));
+	strscpy(i8042_pnp_kbd_name, did->id, sizeof(i8042_pnp_kbd_name));
 	if (strlen(pnp_dev_name(dev))) {
 		strlcat(i8042_pnp_kbd_name, ":", sizeof(i8042_pnp_kbd_name));
 		strlcat(i8042_pnp_kbd_name, pnp_dev_name(dev), sizeof(i8042_pnp_kbd_name));
@@ -995,7 +995,7 @@ static int i8042_pnp_aux_probe(struct pnp_dev *dev, const struct pnp_device_id *
 	if (pnp_irq_valid(dev, 0))
 		i8042_pnp_aux_irq = pnp_irq(dev, 0);
 
-	strlcpy(i8042_pnp_aux_name, did->id, sizeof(i8042_pnp_aux_name));
+	strscpy(i8042_pnp_aux_name, did->id, sizeof(i8042_pnp_aux_name));
 	if (strlen(pnp_dev_name(dev))) {
 		strlcat(i8042_pnp_aux_name, ":", sizeof(i8042_pnp_aux_name));
 		strlcat(i8042_pnp_aux_name, pnp_dev_name(dev), sizeof(i8042_pnp_aux_name));
diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index 944cbb519c6d..372ab524ab0c 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -1337,9 +1337,9 @@ static int __init i8042_create_kbd_port(void)
 	serio->ps2_cmd_mutex	= &i8042_mutex;
 	serio->port_data	= port;
 	serio->dev.parent	= &i8042_platform_device->dev;
-	strlcpy(serio->name, "i8042 KBD port", sizeof(serio->name));
-	strlcpy(serio->phys, I8042_KBD_PHYS_DESC, sizeof(serio->phys));
-	strlcpy(serio->firmware_id, i8042_kbd_firmware_id,
+	strscpy(serio->name, "i8042 KBD port", sizeof(serio->name));
+	strscpy(serio->phys, I8042_KBD_PHYS_DESC, sizeof(serio->phys));
+	strscpy(serio->firmware_id, i8042_kbd_firmware_id,
 		sizeof(serio->firmware_id));
 	set_primary_fwnode(&serio->dev, i8042_kbd_fwnode);
 
@@ -1367,15 +1367,15 @@ static int __init i8042_create_aux_port(int idx)
 	serio->port_data	= port;
 	serio->dev.parent	= &i8042_platform_device->dev;
 	if (idx < 0) {
-		strlcpy(serio->name, "i8042 AUX port", sizeof(serio->name));
-		strlcpy(serio->phys, I8042_AUX_PHYS_DESC, sizeof(serio->phys));
-		strlcpy(serio->firmware_id, i8042_aux_firmware_id,
+		strscpy(serio->name, "i8042 AUX port", sizeof(serio->name));
+		strscpy(serio->phys, I8042_AUX_PHYS_DESC, sizeof(serio->phys));
+		strscpy(serio->firmware_id, i8042_aux_firmware_id,
 			sizeof(serio->firmware_id));
 		serio->close = i8042_port_close;
 	} else {
 		snprintf(serio->name, sizeof(serio->name), "i8042 AUX%d port", idx);
 		snprintf(serio->phys, sizeof(serio->phys), I8042_MUX_PHYS_DESC, idx + 1);
-		strlcpy(serio->firmware_id, i8042_aux_firmware_id,
+		strscpy(serio->firmware_id, i8042_aux_firmware_id,
 			sizeof(serio->firmware_id));
 	}
 
diff --git a/drivers/input/serio/olpc_apsp.c b/drivers/input/serio/olpc_apsp.c
index 59de8d9b6710..04d2db982fb8 100644
--- a/drivers/input/serio/olpc_apsp.c
+++ b/drivers/input/serio/olpc_apsp.c
@@ -199,8 +199,8 @@ static int olpc_apsp_probe(struct platform_device *pdev)
 	kb_serio->close		= olpc_apsp_close;
 	kb_serio->port_data	= priv;
 	kb_serio->dev.parent	= &pdev->dev;
-	strlcpy(kb_serio->name, "sp keyboard", sizeof(kb_serio->name));
-	strlcpy(kb_serio->phys, "sp/serio0", sizeof(kb_serio->phys));
+	strscpy(kb_serio->name, "sp keyboard", sizeof(kb_serio->name));
+	strscpy(kb_serio->phys, "sp/serio0", sizeof(kb_serio->phys));
 	priv->kbio		= kb_serio;
 	serio_register_port(kb_serio);
 
@@ -216,8 +216,8 @@ static int olpc_apsp_probe(struct platform_device *pdev)
 	pad_serio->close	= olpc_apsp_close;
 	pad_serio->port_data	= priv;
 	pad_serio->dev.parent	= &pdev->dev;
-	strlcpy(pad_serio->name, "sp touchpad", sizeof(pad_serio->name));
-	strlcpy(pad_serio->phys, "sp/serio1", sizeof(pad_serio->phys));
+	strscpy(pad_serio->name, "sp touchpad", sizeof(pad_serio->name));
+	strscpy(pad_serio->phys, "sp/serio1", sizeof(pad_serio->phys));
 	priv->padio		= pad_serio;
 	serio_register_port(pad_serio);
 
diff --git a/drivers/input/serio/parkbd.c b/drivers/input/serio/parkbd.c
index ddbbd4afb4a2..da7e09c18180 100644
--- a/drivers/input/serio/parkbd.c
+++ b/drivers/input/serio/parkbd.c
@@ -169,7 +169,8 @@ static struct serio *parkbd_allocate_serio(void)
 	if (serio) {
 		serio->id.type = parkbd_mode;
 		serio->write = parkbd_write,
-		strlcpy(serio->name, "PARKBD AT/XT keyboard adapter", sizeof(serio->name));
+		strscpy(serio->name, "PARKBD AT/XT keyboard adapter",
+			sizeof(serio->name));
 		snprintf(serio->phys, sizeof(serio->phys), "%s/serio0", parkbd_dev->port->name);
 	}
 
diff --git a/drivers/input/serio/pcips2.c b/drivers/input/serio/pcips2.c
index bedf75de0a2c..05878750f2c2 100644
--- a/drivers/input/serio/pcips2.c
+++ b/drivers/input/serio/pcips2.c
@@ -149,8 +149,8 @@ static int pcips2_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	serio->write		= pcips2_write;
 	serio->open		= pcips2_open;
 	serio->close		= pcips2_close;
-	strlcpy(serio->name, pci_name(dev), sizeof(serio->name));
-	strlcpy(serio->phys, dev_name(&dev->dev), sizeof(serio->phys));
+	strscpy(serio->name, pci_name(dev), sizeof(serio->name));
+	strscpy(serio->phys, dev_name(&dev->dev), sizeof(serio->phys));
 	serio->port_data	= ps2if;
 	serio->dev.parent	= &dev->dev;
 	ps2if->io		= serio;
diff --git a/drivers/input/serio/ps2-gpio.c b/drivers/input/serio/ps2-gpio.c
index 8970b49ea09a..1e5e8d94220a 100644
--- a/drivers/input/serio/ps2-gpio.c
+++ b/drivers/input/serio/ps2-gpio.c
@@ -393,8 +393,8 @@ static int ps2_gpio_probe(struct platform_device *pdev)
 	serio->write = drvdata->write_enable ? ps2_gpio_write : NULL;
 	serio->port_data = drvdata;
 	serio->dev.parent = dev;
-	strlcpy(serio->name, dev_name(dev), sizeof(serio->name));
-	strlcpy(serio->phys, dev_name(dev), sizeof(serio->phys));
+	strscpy(serio->name, dev_name(dev), sizeof(serio->name));
+	strscpy(serio->phys, dev_name(dev), sizeof(serio->phys));
 
 	drvdata->serio = serio;
 	drvdata->dev = dev;
diff --git a/drivers/input/serio/ps2mult.c b/drivers/input/serio/ps2mult.c
index 0071dd5ebcc2..902e81826fbf 100644
--- a/drivers/input/serio/ps2mult.c
+++ b/drivers/input/serio/ps2mult.c
@@ -131,7 +131,7 @@ static int ps2mult_create_port(struct ps2mult *psm, int i)
 	if (!serio)
 		return -ENOMEM;
 
-	strlcpy(serio->name, "TQC PS/2 Multiplexer", sizeof(serio->name));
+	strscpy(serio->name, "TQC PS/2 Multiplexer", sizeof(serio->name));
 	snprintf(serio->phys, sizeof(serio->phys),
 		 "%s/port%d", mx_serio->phys, i);
 	serio->id.type = SERIO_8042;
diff --git a/drivers/input/serio/q40kbd.c b/drivers/input/serio/q40kbd.c
index bd248398556a..a1c61f5de047 100644
--- a/drivers/input/serio/q40kbd.c
+++ b/drivers/input/serio/q40kbd.c
@@ -126,8 +126,8 @@ static int q40kbd_probe(struct platform_device *pdev)
 	port->close = q40kbd_close;
 	port->port_data = q40kbd;
 	port->dev.parent = &pdev->dev;
-	strlcpy(port->name, "Q40 Kbd Port", sizeof(port->name));
-	strlcpy(port->phys, "Q40", sizeof(port->phys));
+	strscpy(port->name, "Q40 Kbd Port", sizeof(port->name));
+	strscpy(port->phys, "Q40", sizeof(port->phys));
 
 	q40kbd_stop();
 
diff --git a/drivers/input/serio/rpckbd.c b/drivers/input/serio/rpckbd.c
index 37fe6a5711ea..7008bc101415 100644
--- a/drivers/input/serio/rpckbd.c
+++ b/drivers/input/serio/rpckbd.c
@@ -128,8 +128,8 @@ static int rpckbd_probe(struct platform_device *dev)
 	serio->close		= rpckbd_close;
 	serio->dev.parent	= &dev->dev;
 	serio->port_data	= rpckbd;
-	strlcpy(serio->name, "RiscPC PS/2 kbd port", sizeof(serio->name));
-	strlcpy(serio->phys, "rpckbd/serio0", sizeof(serio->phys));
+	strscpy(serio->name, "RiscPC PS/2 kbd port", sizeof(serio->name));
+	strscpy(serio->phys, "rpckbd/serio0", sizeof(serio->phys));
 
 	platform_set_drvdata(dev, serio);
 	serio_register_port(serio);
diff --git a/drivers/input/serio/sa1111ps2.c b/drivers/input/serio/sa1111ps2.c
index 7b8ceb702a74..62b8f9e39e26 100644
--- a/drivers/input/serio/sa1111ps2.c
+++ b/drivers/input/serio/sa1111ps2.c
@@ -267,8 +267,8 @@ static int ps2_probe(struct sa1111_dev *dev)
 	serio->write		= ps2_write;
 	serio->open		= ps2_open;
 	serio->close		= ps2_close;
-	strlcpy(serio->name, dev_name(&dev->dev), sizeof(serio->name));
-	strlcpy(serio->phys, dev_name(&dev->dev), sizeof(serio->phys));
+	strscpy(serio->name, dev_name(&dev->dev), sizeof(serio->name));
+	strscpy(serio->phys, dev_name(&dev->dev), sizeof(serio->phys));
 	serio->port_data	= ps2if;
 	serio->dev.parent	= &dev->dev;
 	ps2if->io		= serio;
diff --git a/drivers/input/serio/serport.c b/drivers/input/serio/serport.c
index 8ac970a423de..8e068ec12a8b 100644
--- a/drivers/input/serio/serport.c
+++ b/drivers/input/serio/serport.c
@@ -168,7 +168,7 @@ static ssize_t serport_ldisc_read(struct tty_struct * tty, struct file * file, u
 	if (!serio)
 		return -ENOMEM;
 
-	strlcpy(serio->name, "Serial port", sizeof(serio->name));
+	strscpy(serio->name, "Serial port", sizeof(serio->name));
 	snprintf(serio->phys, sizeof(serio->phys), "%s/serio0", tty_name(tty));
 	serio->id = serport->id;
 	serio->id.type = SERIO_RS232;
diff --git a/drivers/input/serio/sun4i-ps2.c b/drivers/input/serio/sun4i-ps2.c
index f15ed3dcdb9b..eb262640192e 100644
--- a/drivers/input/serio/sun4i-ps2.c
+++ b/drivers/input/serio/sun4i-ps2.c
@@ -256,8 +256,8 @@ static int sun4i_ps2_probe(struct platform_device *pdev)
 	serio->close = sun4i_ps2_close;
 	serio->port_data = drvdata;
 	serio->dev.parent = dev;
-	strlcpy(serio->name, dev_name(dev), sizeof(serio->name));
-	strlcpy(serio->phys, dev_name(dev), sizeof(serio->phys));
+	strscpy(serio->name, dev_name(dev), sizeof(serio->name));
+	strscpy(serio->phys, dev_name(dev), sizeof(serio->phys));
 
 	/* shutoff interrupt */
 	writel(0, drvdata->reg_base + PS2_REG_GCTL);
diff --git a/drivers/input/tablet/acecad.c b/drivers/input/tablet/acecad.c
index a38d1fe97334..e5f69159128f 100644
--- a/drivers/input/tablet/acecad.c
+++ b/drivers/input/tablet/acecad.c
@@ -155,7 +155,7 @@ static int usb_acecad_probe(struct usb_interface *intf, const struct usb_device_
 	acecad->input = input_dev;
 
 	if (dev->manufacturer)
-		strlcpy(acecad->name, dev->manufacturer, sizeof(acecad->name));
+		strscpy(acecad->name, dev->manufacturer, sizeof(acecad->name));
 
 	if (dev->product) {
 		if (dev->manufacturer)
diff --git a/drivers/input/tablet/hanwang.c b/drivers/input/tablet/hanwang.c
index 6d58443bb3e9..e492a0331b24 100644
--- a/drivers/input/tablet/hanwang.c
+++ b/drivers/input/tablet/hanwang.c
@@ -356,7 +356,7 @@ static int hanwang_probe(struct usb_interface *intf, const struct usb_device_id
 	usb_make_path(dev, hanwang->phys, sizeof(hanwang->phys));
 	strlcat(hanwang->phys, "/input0", sizeof(hanwang->phys));
 
-	strlcpy(hanwang->name, hanwang->features->name, sizeof(hanwang->name));
+	strscpy(hanwang->name, hanwang->features->name, sizeof(hanwang->name));
 	input_dev->name = hanwang->name;
 	input_dev->phys = hanwang->phys;
 	usb_to_input_id(dev, &input_dev->id);
diff --git a/drivers/input/tablet/pegasus_notetaker.c b/drivers/input/tablet/pegasus_notetaker.c
index 749edbdb7ffa..4c8e11d0ffb1 100644
--- a/drivers/input/tablet/pegasus_notetaker.c
+++ b/drivers/input/tablet/pegasus_notetaker.c
@@ -319,7 +319,7 @@ static int pegasus_probe(struct usb_interface *intf,
 	pegasus->irq->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 
 	if (dev->manufacturer)
-		strlcpy(pegasus->name, dev->manufacturer,
+		strscpy(pegasus->name, dev->manufacturer,
 			sizeof(pegasus->name));
 
 	if (dev->product) {
diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 98f17fa3a892..1a0f6e9a06ef 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -2454,8 +2454,8 @@ static int mxt_vidioc_querycap(struct file *file, void *priv,
 {
 	struct mxt_data *data = video_drvdata(file);
 
-	strlcpy(cap->driver, "atmel_mxt_ts", sizeof(cap->driver));
-	strlcpy(cap->card, "atmel_mxt_ts touch", sizeof(cap->card));
+	strscpy(cap->driver, "atmel_mxt_ts", sizeof(cap->driver));
+	strscpy(cap->card, "atmel_mxt_ts touch", sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info),
 		 "I2C:%s", dev_name(&data->client->dev));
 	return 0;
@@ -2471,11 +2471,11 @@ static int mxt_vidioc_enum_input(struct file *file, void *priv,
 
 	switch (i->index) {
 	case MXT_V4L_INPUT_REFS:
-		strlcpy(i->name, "Mutual Capacitance References",
+		strscpy(i->name, "Mutual Capacitance References",
 			sizeof(i->name));
 		break;
 	case MXT_V4L_INPUT_DELTAS:
-		strlcpy(i->name, "Mutual Capacitance Deltas", sizeof(i->name));
+		strscpy(i->name, "Mutual Capacitance Deltas", sizeof(i->name));
 		break;
 	}
 
diff --git a/drivers/input/touchscreen/edt-ft5x06.c b/drivers/input/touchscreen/edt-ft5x06.c
index 6ff81d48da86..dcd81fdbc642 100644
--- a/drivers/input/touchscreen/edt-ft5x06.c
+++ b/drivers/input/touchscreen/edt-ft5x06.c
@@ -850,8 +850,8 @@ static int edt_ft5x06_ts_identify(struct i2c_client *client,
 		p = strchr(rdbuf, '*');
 		if (p)
 			*p++ = '\0';
-		strlcpy(model_name, rdbuf + 1, EDT_NAME_LEN);
-		strlcpy(fw_version, p ? p : "", EDT_NAME_LEN);
+		strscpy(model_name, rdbuf + 1, EDT_NAME_LEN);
+		strscpy(fw_version, p ? p : "", EDT_NAME_LEN);
 	} else if (!strncasecmp(rdbuf, "EP0", 3)) {
 		tsdata->version = EDT_M12;
 
@@ -864,8 +864,8 @@ static int edt_ft5x06_ts_identify(struct i2c_client *client,
 		p = strchr(rdbuf, '*');
 		if (p)
 			*p++ = '\0';
-		strlcpy(model_name, rdbuf, EDT_NAME_LEN);
-		strlcpy(fw_version, p ? p : "", EDT_NAME_LEN);
+		strscpy(model_name, rdbuf, EDT_NAME_LEN);
+		strscpy(fw_version, p ? p : "", EDT_NAME_LEN);
 	} else {
 		/* If it is not an EDT M06/M12 touchscreen, then the model
 		 * detection is a bit hairy. The different ft5x06
@@ -883,7 +883,7 @@ static int edt_ft5x06_ts_identify(struct i2c_client *client,
 		if (error)
 			return error;
 
-		strlcpy(fw_version, rdbuf, 2);
+		strscpy(fw_version, rdbuf, 2);
 
 		error = edt_ft5x06_ts_readwrite(client, 1, "\xA8",
 						1, rdbuf);
@@ -918,7 +918,7 @@ static int edt_ft5x06_ts_identify(struct i2c_client *client,
 							1, rdbuf);
 			if (error)
 				return error;
-			strlcpy(fw_version, rdbuf, 1);
+			strscpy(fw_version, rdbuf, 1);
 			snprintf(model_name, EDT_NAME_LEN,
 				 "EVERVISION-FT5726NEi");
 			break;
diff --git a/drivers/input/touchscreen/exc3000.c b/drivers/input/touchscreen/exc3000.c
index a6597f026980..75af0d285f26 100644
--- a/drivers/input/touchscreen/exc3000.c
+++ b/drivers/input/touchscreen/exc3000.c
@@ -177,9 +177,9 @@ static int exc3000_query_interrupt(struct exc3000_data *data)
 		return -EPROTO;
 
 	if (buf[4] == 'E')
-		strlcpy(data->model, buf + 5, sizeof(data->model));
+		strscpy(data->model, buf + 5, sizeof(data->model));
 	else if (buf[4] == 'D')
-		strlcpy(data->fw_version, buf + 5, sizeof(data->fw_version));
+		strscpy(data->fw_version, buf + 5, sizeof(data->fw_version));
 	else
 		return -EPROTO;
 
diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
index 620cdd7d214a..bce83967cc57 100644
--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -938,8 +938,8 @@ static int sur40_vidioc_querycap(struct file *file, void *priv,
 {
 	struct sur40_state *sur40 = video_drvdata(file);
 
-	strlcpy(cap->driver, DRIVER_SHORT, sizeof(cap->driver));
-	strlcpy(cap->card, DRIVER_LONG, sizeof(cap->card));
+	strscpy(cap->driver, DRIVER_SHORT, sizeof(cap->driver));
+	strscpy(cap->card, DRIVER_LONG, sizeof(cap->card));
 	usb_make_path(sur40->usbdev, cap->bus_info, sizeof(cap->bus_info));
 	return 0;
 }
@@ -951,7 +951,7 @@ static int sur40_vidioc_enum_input(struct file *file, void *priv,
 		return -EINVAL;
 	i->type = V4L2_INPUT_TYPE_TOUCH;
 	i->std = V4L2_STD_UNKNOWN;
-	strlcpy(i->name, "In-Cell Sensor", sizeof(i->name));
+	strscpy(i->name, "In-Cell Sensor", sizeof(i->name));
 	i->capabilities = 0;
 	return 0;
 }
diff --git a/drivers/input/touchscreen/usbtouchscreen.c b/drivers/input/touchscreen/usbtouchscreen.c
index 397cb1d3f481..c3c8f2de9cbd 100644
--- a/drivers/input/touchscreen/usbtouchscreen.c
+++ b/drivers/input/touchscreen/usbtouchscreen.c
@@ -1702,7 +1702,8 @@ static int usbtouch_probe(struct usb_interface *intf,
 	usbtouch->input = input_dev;
 
 	if (udev->manufacturer)
-		strlcpy(usbtouch->name, udev->manufacturer, sizeof(usbtouch->name));
+		strscpy(usbtouch->name, udev->manufacturer,
+			sizeof(usbtouch->name));
 
 	if (udev->product) {
 		if (udev->manufacturer)
diff --git a/drivers/input/touchscreen/wacom_w8001.c b/drivers/input/touchscreen/wacom_w8001.c
index 691285ace228..6f273e0ba43c 100644
--- a/drivers/input/touchscreen/wacom_w8001.c
+++ b/drivers/input/touchscreen/wacom_w8001.c
@@ -625,7 +625,7 @@ static int w8001_connect(struct serio *serio, struct serio_driver *drv)
 	/* For backwards-compatibility we compose the basename based on
 	 * capabilities and then just append the tool type
 	 */
-	strlcpy(basename, "Wacom Serial", sizeof(basename));
+	strscpy(basename, "Wacom Serial", sizeof(basename));
 
 	err_pen = w8001_setup_pen(w8001, basename, sizeof(basename));
 	err_touch = w8001_setup_touch(w8001, basename, sizeof(basename));
@@ -635,7 +635,7 @@ static int w8001_connect(struct serio *serio, struct serio_driver *drv)
 	}
 
 	if (!err_pen) {
-		strlcpy(w8001->pen_name, basename, sizeof(w8001->pen_name));
+		strscpy(w8001->pen_name, basename, sizeof(w8001->pen_name));
 		strlcat(w8001->pen_name, " Pen", sizeof(w8001->pen_name));
 		input_dev_pen->name = w8001->pen_name;
 
@@ -651,7 +651,8 @@ static int w8001_connect(struct serio *serio, struct serio_driver *drv)
 	}
 
 	if (!err_touch) {
-		strlcpy(w8001->touch_name, basename, sizeof(w8001->touch_name));
+		strscpy(w8001->touch_name, basename,
+			sizeof(w8001->touch_name));
 		strlcat(w8001->touch_name, " Finger",
 			sizeof(w8001->touch_name));
 		input_dev_touch->name = w8001->touch_name;
diff --git a/drivers/isdn/capi/kcapi.c b/drivers/isdn/capi/kcapi.c
index 7168778fbbe1..876bdad72337 100644
--- a/drivers/isdn/capi/kcapi.c
+++ b/drivers/isdn/capi/kcapi.c
@@ -793,7 +793,7 @@ u16 capi20_get_serial(u32 contr, u8 *serial)
 	u16 ret;
 
 	if (contr == 0) {
-		strlcpy(serial, driver_serial, CAPI_SERIAL_LEN);
+		strscpy(serial, driver_serial, CAPI_SERIAL_LEN);
 		return CAPI_NOERROR;
 	}
 
@@ -801,7 +801,7 @@ u16 capi20_get_serial(u32 contr, u8 *serial)
 
 	ctr = get_capi_ctr_by_nr(contr);
 	if (ctr && ctr->state == CAPI_CTR_RUNNING) {
-		strlcpy(serial, ctr->serial, CAPI_SERIAL_LEN);
+		strscpy(serial, ctr->serial, CAPI_SERIAL_LEN);
 		ret = CAPI_NOERROR;
 	} else
 		ret = CAPI_REGNOTINSTALLED;
diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 131ca83f5fb3..58968f2c58c4 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -315,7 +315,7 @@ static int led_classdev_next_name(const char *init_name, char *name,
 	int ret = 0;
 	struct device *dev;
 
-	strlcpy(name, init_name, len);
+	strscpy(name, init_name, len);
 
 	while ((ret < len) &&
 	       (dev = class_find_device_by_name(leds_class, name))) {
diff --git a/drivers/leds/leds-aat1290.c b/drivers/leds/leds-aat1290.c
index 589484b22c79..f12ecb2c6580 100644
--- a/drivers/leds/leds-aat1290.c
+++ b/drivers/leds/leds-aat1290.c
@@ -425,7 +425,7 @@ static void aat1290_init_v4l2_flash_config(struct aat1290_led *led,
 	struct led_classdev *led_cdev = &led->fled_cdev.led_cdev;
 	struct led_flash_setting *s;
 
-	strlcpy(v4l2_sd_cfg->dev_name, led_cdev->dev->kobj.name,
+	strscpy(v4l2_sd_cfg->dev_name, led_cdev->dev->kobj.name,
 		sizeof(v4l2_sd_cfg->dev_name));
 
 	s = &v4l2_sd_cfg->intensity;
diff --git a/drivers/leds/leds-as3645a.c b/drivers/leds/leds-as3645a.c
index e8922fa03379..cf39b9128556 100644
--- a/drivers/leds/leds-as3645a.c
+++ b/drivers/leds/leds-as3645a.c
@@ -650,8 +650,8 @@ static int as3645a_v4l2_setup(struct as3645a *flash)
 		},
 	};
 
-	strlcpy(cfg.dev_name, led->dev->kobj.name, sizeof(cfg.dev_name));
-	strlcpy(cfgind.dev_name, flash->iled_cdev.dev->kobj.name,
+	strscpy(cfg.dev_name, led->dev->kobj.name, sizeof(cfg.dev_name));
+	strscpy(cfgind.dev_name, flash->iled_cdev.dev->kobj.name,
 		sizeof(cfgind.dev_name));
 
 	flash->vf = v4l2_flash_init(
diff --git a/drivers/leds/leds-blinkm.c b/drivers/leds/leds-blinkm.c
index e11fe1788242..8da0569cfae5 100644
--- a/drivers/leds/leds-blinkm.c
+++ b/drivers/leds/leds-blinkm.c
@@ -562,7 +562,7 @@ static int blinkm_detect(struct i2c_client *client, struct i2c_board_info *info)
 		return -ENODEV;
 	}
 
-	strlcpy(info->type, "blinkm", I2C_NAME_SIZE);
+	strscpy(info->type, "blinkm", I2C_NAME_SIZE);
 	return 0;
 }
 
diff --git a/drivers/leds/leds-spi-byte.c b/drivers/leds/leds-spi-byte.c
index f1964c96fb15..4a678509f054 100644
--- a/drivers/leds/leds-spi-byte.c
+++ b/drivers/leds/leds-spi-byte.c
@@ -98,7 +98,7 @@ static int spi_byte_probe(struct spi_device *spi)
 		return -ENOMEM;
 
 	of_property_read_string(child, "label", &name);
-	strlcpy(led->name, name, sizeof(led->name));
+	strscpy(led->name, name, sizeof(led->name));
 	led->spi = spi;
 	mutex_init(&led->mutex);
 	led->cdef = device_get_match_data(dev);
diff --git a/drivers/lightnvm/core.c b/drivers/lightnvm/core.c
index c1bcac71008c..333e912fd5a2 100644
--- a/drivers/lightnvm/core.c
+++ b/drivers/lightnvm/core.c
@@ -382,7 +382,7 @@ static int nvm_create_tgt(struct nvm_dev *dev, struct nvm_ioctl_create *create)
 		goto err_disk;
 	}
 
-	strlcpy(tdisk->disk_name, create->tgtname, sizeof(tdisk->disk_name));
+	strscpy(tdisk->disk_name, create->tgtname, sizeof(tdisk->disk_name));
 	tdisk->flags = GENHD_FL_EXT_DEVT;
 	tdisk->major = 0;
 	tdisk->first_minor = 0;
@@ -1302,13 +1302,13 @@ static long nvm_ioctl_get_devices(struct file *file, void __user *arg)
 	list_for_each_entry(dev, &nvm_devices, devices) {
 		struct nvm_ioctl_device_info *info = &devices->info[i];
 
-		strlcpy(info->devname, dev->name, sizeof(info->devname));
+		strscpy(info->devname, dev->name, sizeof(info->devname));
 
 		/* kept for compatibility */
 		info->bmversion[0] = 1;
 		info->bmversion[1] = 0;
 		info->bmversion[2] = 0;
-		strlcpy(info->bmname, "gennvm", sizeof(info->bmname));
+		strscpy(info->bmname, "gennvm", sizeof(info->bmname));
 		i++;
 
 		if (i >= ARRAY_SIZE(devices->info)) {
diff --git a/drivers/macintosh/therm_windtunnel.c b/drivers/macintosh/therm_windtunnel.c
index f55f6adf5e5f..085df19bfc4c 100644
--- a/drivers/macintosh/therm_windtunnel.c
+++ b/drivers/macintosh/therm_windtunnel.c
@@ -322,7 +322,7 @@ static void do_attach(struct i2c_adapter *adapter)
 	if (np) {
 		of_node_put(np);
 	} else {
-		strlcpy(info.type, "MAC,ds1775", I2C_NAME_SIZE);
+		strscpy(info.type, "MAC,ds1775", I2C_NAME_SIZE);
 		i2c_new_scanned_device(adapter, &info, scan_ds1775, NULL);
 	}
 
@@ -330,7 +330,7 @@ static void do_attach(struct i2c_adapter *adapter)
 	if (np) {
 		of_node_put(np);
 	} else {
-		strlcpy(info.type, "MAC,adm1030", I2C_NAME_SIZE);
+		strscpy(info.type, "MAC,adm1030", I2C_NAME_SIZE);
 		i2c_new_scanned_device(adapter, &info, scan_adm1030, NULL);
 	}
 }
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index cd0478d44058..694db4c02ab4 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -832,9 +832,9 @@ static struct hash_cell *__find_device_hash_cell(struct dm_ioctl *param)
 	 * Sneakily write in both the name and the uuid
 	 * while we have the cell.
 	 */
-	strlcpy(param->name, hc->name, sizeof(param->name));
+	strscpy(param->name, hc->name, sizeof(param->name));
 	if (hc->uuid)
-		strlcpy(param->uuid, hc->uuid, sizeof(param->uuid));
+		strscpy(param->uuid, hc->uuid, sizeof(param->uuid));
 	else
 		param->uuid[0] = '\0';
 
diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 200c5d0f08bf..ee01ace1cd98 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -644,8 +644,8 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
 	 */
 	if (sb->version == cpu_to_le32(BITMAP_MAJOR_CLUSTERED)) {
 		nodes = le32_to_cpu(sb->nodes);
-		strlcpy(bitmap->mddev->bitmap_info.cluster_name,
-				sb->cluster_name, 64);
+		strscpy(bitmap->mddev->bitmap_info.cluster_name,
+			sb->cluster_name, 64);
 	}
 
 	/* verify that the bitmap-specific fields are valid */
@@ -695,7 +695,7 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
 	if (le32_to_cpu(sb->version) == BITMAP_MAJOR_HOSTENDIAN)
 		set_bit(BITMAP_HOSTENDIAN, &bitmap->flags);
 	bitmap->events_cleared = le64_to_cpu(sb->events_cleared);
-	strlcpy(bitmap->mddev->bitmap_info.cluster_name, sb->cluster_name, 64);
+	strscpy(bitmap->mddev->bitmap_info.cluster_name, sb->cluster_name, 64);
 	err = 0;
 
 out:
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 4aaf4820b6f6..95fa0b6cc24b 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -201,7 +201,7 @@ static struct dlm_lock_resource *lockres_init(struct mddev *mddev,
 		pr_err("md-cluster: Unable to allocate resource name for resource %s\n", name);
 		goto out_err;
 	}
-	strlcpy(res->name, name, namelen + 1);
+	strscpy(res->name, name, namelen + 1);
 	if (with_lvb) {
 		res->lksb.sb_lvbptr = kzalloc(LVB_SIZE, GFP_KERNEL);
 		if (!res->lksb.sb_lvbptr) {
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 98bac4f304ae..b48304423c51 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4041,7 +4041,7 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 	oldpriv = mddev->private;
 	mddev->pers = pers;
 	mddev->private = priv;
-	strlcpy(mddev->clevel, pers->name, sizeof(mddev->clevel));
+	strscpy(mddev->clevel, pers->name, sizeof(mddev->clevel));
 	mddev->level = mddev->new_level;
 	mddev->layout = mddev->new_layout;
 	mddev->chunk_sectors = mddev->new_chunk_sectors;
@@ -5789,7 +5789,7 @@ static int add_named_array(const char *val, const struct kernel_param *kp)
 		len--;
 	if (len >= DISK_NAME_LEN)
 		return -E2BIG;
-	strlcpy(buf, val, len+1);
+	strscpy(buf, val, len + 1);
 	if (strncmp(buf, "md_", 3) == 0)
 		return md_alloc(0, buf);
 	if (strncmp(buf, "md", 2) == 0 &&
@@ -5922,7 +5922,7 @@ int md_run(struct mddev *mddev)
 		mddev->level = pers->level;
 		mddev->new_level = pers->level;
 	}
-	strlcpy(mddev->clevel, pers->name, sizeof(mddev->clevel));
+	strscpy(mddev->clevel, pers->name, sizeof(mddev->clevel));
 
 	if (mddev->reshape_position != MaxSector &&
 	    pers->start_reshape == NULL) {
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 9903e9660a38..35fc87d2864c 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -713,8 +713,8 @@ mpt_register(MPT_CALLBACK cbfunc, MPT_DRIVER_CLASS dclass, char *func_name)
 			MptDriverClass[cb_idx] = dclass;
 			MptEvHandlers[cb_idx] = NULL;
 			last_drv_idx = cb_idx;
-			strlcpy(MptCallbacksName[cb_idx], func_name,
-				MPT_MAX_CALLBACKNAME_LEN+1);
+			strscpy(MptCallbacksName[cb_idx], func_name,
+				MPT_MAX_CALLBACKNAME_LEN + 1);
 			break;
 		}
 	}
@@ -7666,7 +7666,7 @@ mpt_display_event_info(MPT_ADAPTER *ioc, EventNotificationReply_t *pEventReply)
 		break;
 	}
 	if (ds)
-		strlcpy(evStr, ds, EVENT_DESCR_STR_SZ);
+		strscpy(evStr, ds, EVENT_DESCR_STR_SZ);
 
 
 	devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT
diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index 24aebad60366..f41e4568b93a 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -2409,8 +2409,9 @@ mptctl_hp_hostinfo(MPT_ADAPTER *ioc, unsigned long arg, unsigned int data_size)
 				if (mpt_config(ioc, &cfg) == 0) {
 					ManufacturingPage0_t *pdata = (ManufacturingPage0_t *) pbuf;
 					if (strlen(pdata->BoardTracerNumber) > 1) {
-						strlcpy(karg.serial_number,
-							pdata->BoardTracerNumber, 24);
+						strscpy(karg.serial_number,
+							pdata->BoardTracerNumber,
+							24);
 					}
 				}
 				pci_free_consistent(ioc->pcidev, hdr.PageLength * 4, pbuf, buf_dma);
diff --git a/drivers/mfd/htc-i2cpld.c b/drivers/mfd/htc-i2cpld.c
index 247f9849e54a..ce0651af5b41 100644
--- a/drivers/mfd/htc-i2cpld.c
+++ b/drivers/mfd/htc-i2cpld.c
@@ -351,7 +351,7 @@ static int htcpld_register_chip_i2c(
 
 	memset(&info, 0, sizeof(struct i2c_board_info));
 	info.addr = plat_chip_data->addr;
-	strlcpy(info.type, "htcpld-chip", I2C_NAME_SIZE);
+	strscpy(info.type, "htcpld-chip", I2C_NAME_SIZE);
 	info.platform_data = chip;
 
 	/* Add the I2C device.  This calls the probe() function. */
diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
index 3bbb29a7e7a5..8908ce0c2d94 100644
--- a/drivers/mfd/lpc_ich.c
+++ b/drivers/mfd/lpc_ich.c
@@ -888,7 +888,7 @@ static int lpc_ich_finalize_wdt_cell(struct pci_dev *dev)
 	info = &lpc_chipset_info[priv->chipset];
 
 	pdata->version = info->iTCO_version;
-	strlcpy(pdata->name, info->name, sizeof(pdata->name));
+	strscpy(pdata->name, info->name, sizeof(pdata->name));
 
 	cell->platform_data = pdata;
 	cell->pdata_size = sizeof(*pdata);
diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index fc00aaccb5f7..b7319078e2e3 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -85,7 +85,7 @@ static void mfd_acpi_add_device(const struct mfd_cell *cell,
 		if (match->pnpid) {
 			struct acpi_device_id ids[2] = {};
 
-			strlcpy(ids[0].id, match->pnpid, sizeof(ids[0].id));
+			strscpy(ids->id, match->pnpid, sizeof(ids[0].id));
 			list_for_each_entry(child, &parent->children, node) {
 				if (!acpi_match_device_ids(child, ids)) {
 					adev = child;
diff --git a/drivers/misc/altera-stapl/altera.c b/drivers/misc/altera-stapl/altera.c
index 5bdf57472314..56b3e9d92ccc 100644
--- a/drivers/misc/altera-stapl/altera.c
+++ b/drivers/misc/altera-stapl/altera.c
@@ -1035,8 +1035,7 @@ static int altera_execute(struct altera_state *astate,
 			 * ...argument 0 is string ID
 			 */
 			count = strlen(msg_buff);
-			strlcpy(&msg_buff[count],
-				&p[str_table + args[0]],
+			strscpy(&msg_buff[count], &p[str_table + args[0]],
 				ALTERA_MESSAGE_LENGTH - count);
 			break;
 		case OP_SINT:
@@ -2170,7 +2169,7 @@ static int altera_get_note(u8 *p, s32 program_size, s32 *offset,
 						&p[note_table + (8 * i) + 4])];
 
 				if (value != NULL)
-					strlcpy(value, value_ptr, vallen);
+					strscpy(value, value_ptr, vallen);
 
 			}
 		}
@@ -2186,15 +2185,13 @@ static int altera_get_note(u8 *p, s32 program_size, s32 *offset,
 			status = 0;
 
 			if (key != NULL)
-				strlcpy(key, &p[note_strings +
-						get_unaligned_be32(
-						&p[note_table + (8 * i)])],
+				strscpy(key,
+					&p[note_strings + get_unaligned_be32(&p[note_table + (8 * i)])],
 					keylen);
 
 			if (value != NULL)
-				strlcpy(value, &p[note_strings +
-						get_unaligned_be32(
-						&p[note_table + (8 * i) + 4])],
+				strscpy(value,
+					&p[note_strings + get_unaligned_be32(&p[note_table + (8 * i) + 4])],
 					vallen);
 
 			*offset = i + 1;
diff --git a/drivers/misc/eeprom/eeprom.c b/drivers/misc/eeprom/eeprom.c
index 34fa385dfd4b..adb08ae5062d 100644
--- a/drivers/misc/eeprom/eeprom.c
+++ b/drivers/misc/eeprom/eeprom.c
@@ -136,7 +136,7 @@ static int eeprom_detect(struct i2c_client *client, struct i2c_board_info *info)
 	 && !i2c_check_functionality(adapter, I2C_FUNC_SMBUS_READ_I2C_BLOCK))
 		return -ENODEV;
 
-	strlcpy(info->type, "eeprom", I2C_NAME_SIZE);
+	strscpy(info->type, "eeprom", I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/misc/eeprom/idt_89hpesx.c b/drivers/misc/eeprom/idt_89hpesx.c
index 81c70e5bc168..d7608885e56e 100644
--- a/drivers/misc/eeprom/idt_89hpesx.c
+++ b/drivers/misc/eeprom/idt_89hpesx.c
@@ -1102,7 +1102,7 @@ static const struct i2c_device_id *idt_ee_match_id(struct fwnode_handle *fwnode)
 		return NULL;
 
 	p = strchr(compatible, ',');
-	strlcpy(devname, p ? p + 1 : compatible, sizeof(devname));
+	strscpy(devname, p ? p + 1 : compatible, sizeof(devname));
 	/* Search through the device name */
 	while (id->name[0]) {
 		if (strcmp(devname, id->name) == 0)
diff --git a/drivers/misc/habanalabs/common/device.c b/drivers/misc/habanalabs/common/device.c
index 20572224099a..21e82d373b06 100644
--- a/drivers/misc/habanalabs/common/device.c
+++ b/drivers/misc/habanalabs/common/device.c
@@ -259,7 +259,7 @@ static int device_early_init(struct hl_device *hdev)
 	switch (hdev->asic_type) {
 	case ASIC_GOYA:
 		goya_set_asic_funcs(hdev);
-		strlcpy(hdev->asic_name, "GOYA", sizeof(hdev->asic_name));
+		strscpy(hdev->asic_name, "GOYA", sizeof(hdev->asic_name));
 		break;
 	case ASIC_GAUDI:
 		gaudi_set_asic_funcs(hdev);
diff --git a/drivers/misc/ics932s401.c b/drivers/misc/ics932s401.c
index 2bdf560ee681..0e6244f893f9 100644
--- a/drivers/misc/ics932s401.c
+++ b/drivers/misc/ics932s401.c
@@ -424,7 +424,7 @@ static int ics932s401_detect(struct i2c_client *client,
 	if (revision != ICS932S401_REV)
 		dev_info(&adapter->dev, "Unknown revision %d\n", revision);
 
-	strlcpy(info->type, "ics932s401", I2C_NAME_SIZE);
+	strscpy(info->type, "ics932s401", I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/misc/mei/bus-fixup.c b/drivers/misc/mei/bus-fixup.c
index 4e30fa98fe7d..edbf448aeb3c 100644
--- a/drivers/misc/mei/bus-fixup.c
+++ b/drivers/misc/mei/bus-fixup.c
@@ -442,7 +442,7 @@ static void mei_nfc(struct mei_cl_device *cldev)
 	}
 
 	dev_dbg(bus->dev, "nfc radio %s\n", radio_name);
-	strlcpy(cldev->name, radio_name, sizeof(cldev->name));
+	strscpy(cldev->name, radio_name, sizeof(cldev->name));
 
 disconnect:
 	mutex_lock(&bus->device_lock);
diff --git a/drivers/most/configfs.c b/drivers/most/configfs.c
index 27b0c923597f..36d8c917f65f 100644
--- a/drivers/most/configfs.c
+++ b/drivers/most/configfs.c
@@ -204,7 +204,7 @@ static ssize_t mdev_link_device_store(struct config_item *item,
 {
 	struct mdev_link *mdev_link = to_mdev_link(item);
 
-	strlcpy(mdev_link->device, page, sizeof(mdev_link->device));
+	strscpy(mdev_link->device, page, sizeof(mdev_link->device));
 	strim(mdev_link->device);
 	return count;
 }
@@ -219,7 +219,7 @@ static ssize_t mdev_link_channel_store(struct config_item *item,
 {
 	struct mdev_link *mdev_link = to_mdev_link(item);
 
-	strlcpy(mdev_link->channel, page, sizeof(mdev_link->channel));
+	strscpy(mdev_link->channel, page, sizeof(mdev_link->channel));
 	strim(mdev_link->channel);
 	return count;
 }
@@ -234,7 +234,7 @@ static ssize_t mdev_link_comp_store(struct config_item *item,
 {
 	struct mdev_link *mdev_link = to_mdev_link(item);
 
-	strlcpy(mdev_link->comp, page, sizeof(mdev_link->comp));
+	strscpy(mdev_link->comp, page, sizeof(mdev_link->comp));
 	strim(mdev_link->comp);
 	return count;
 }
@@ -250,7 +250,7 @@ static ssize_t mdev_link_comp_params_store(struct config_item *item,
 {
 	struct mdev_link *mdev_link = to_mdev_link(item);
 
-	strlcpy(mdev_link->comp_params, page, sizeof(mdev_link->comp_params));
+	strscpy(mdev_link->comp_params, page, sizeof(mdev_link->comp_params));
 	strim(mdev_link->comp_params);
 	return count;
 }
diff --git a/drivers/mtd/devices/block2mtd.c b/drivers/mtd/devices/block2mtd.c
index c08721b11642..50a303f9f322 100644
--- a/drivers/mtd/devices/block2mtd.c
+++ b/drivers/mtd/devices/block2mtd.c
@@ -448,7 +448,7 @@ static int block2mtd_setup(const char *val, const struct kernel_param *kp)
 	   the device (even kmalloc() fails). Deter that work to
 	   block2mtd_setup2(). */
 
-	strlcpy(block2mtd_paramline, val, sizeof(block2mtd_paramline));
+	strscpy(block2mtd_paramline, val, sizeof(block2mtd_paramline));
 
 	return 0;
 #endif
diff --git a/drivers/mtd/parsers/cmdlinepart.c b/drivers/mtd/parsers/cmdlinepart.c
index a79e4d866b08..d327d0c5bf5a 100644
--- a/drivers/mtd/parsers/cmdlinepart.c
+++ b/drivers/mtd/parsers/cmdlinepart.c
@@ -193,7 +193,7 @@ static struct mtd_partition * newpart(char *s,
 	parts[this_part].mask_flags = mask_flags;
 	parts[this_part].add_flags = add_flags;
 	if (name)
-		strlcpy(extra_mem, name, name_len + 1);
+		strscpy(extra_mem, name, name_len + 1);
 	else
 		sprintf(extra_mem, "Partition_%03d", this_part);
 	parts[this_part].name = extra_mem;
@@ -286,7 +286,7 @@ static int mtdpart_setup_real(char *s)
 		this_mtd->parts = parts;
 		this_mtd->num_parts = num_parts;
 		this_mtd->mtd_id = (char*)(this_mtd + 1);
-		strlcpy(this_mtd->mtd_id, mtd_id, mtd_id_len + 1);
+		strscpy(this_mtd->mtd_id, mtd_id, mtd_id_len + 1);
 
 		/* link into chain */
 		this_mtd->next = partitions;
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 47afc5938c26..1eb9cd8e28ab 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4647,7 +4647,7 @@ static int bond_ethtool_get_link_ksettings(struct net_device *bond_dev,
 static void bond_ethtool_get_drvinfo(struct net_device *bond_dev,
 				     struct ethtool_drvinfo *drvinfo)
 {
-	strlcpy(drvinfo->driver, DRV_NAME, sizeof(drvinfo->driver));
+	strscpy(drvinfo->driver, DRV_NAME, sizeof(drvinfo->driver));
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version), "%d",
 		 BOND_ABI_VERSION);
 }
diff --git a/drivers/net/can/sja1000/peak_pcmcia.c b/drivers/net/can/sja1000/peak_pcmcia.c
index cf951a783078..cf848b4d7fe9 100644
--- a/drivers/net/can/sja1000/peak_pcmcia.c
+++ b/drivers/net/can/sja1000/peak_pcmcia.c
@@ -479,7 +479,7 @@ static void pcan_free_channels(struct pcan_pccard *card)
 		if (!netdev)
 			continue;
 
-		strlcpy(name, netdev->name, IFNAMSIZ);
+		strscpy(name, netdev->name, IFNAMSIZ);
 
 		unregister_sja1000dev(netdev);
 
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
index 204ccb27d6d9..9b28413e5698 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -896,7 +896,7 @@ static void peak_usb_disconnect(struct usb_interface *intf)
 
 		dev_prev_siblings = dev->prev_siblings;
 		dev->state &= ~PCAN_USB_STATE_CONNECTED;
-		strlcpy(name, netdev->name, IFNAMSIZ);
+		strscpy(name, netdev->name, IFNAMSIZ);
 
 		unregister_netdev(netdev);
 
diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 288b5a5c3e0d..eec857410935 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -901,8 +901,8 @@ void b53_get_strings(struct dsa_switch *ds, int port, u32 stringset,
 
 	if (stringset == ETH_SS_STATS) {
 		for (i = 0; i < mib_size; i++)
-			strlcpy(data + i * ETH_GSTRING_LEN,
-				mibs[i].name, ETH_GSTRING_LEN);
+			strscpy(data + i * ETH_GSTRING_LEN, mibs[i].name,
+				ETH_GSTRING_LEN);
 	} else if (stringset == ETH_SS_PHY_STATS) {
 		phydev = b53_get_phy_device(ds, port);
 		if (!phydev)
diff --git a/drivers/net/dsa/bcm_sf2_cfp.c b/drivers/net/dsa/bcm_sf2_cfp.c
index d82cee5d9202..afd22ed37625 100644
--- a/drivers/net/dsa/bcm_sf2_cfp.c
+++ b/drivers/net/dsa/bcm_sf2_cfp.c
@@ -1300,8 +1300,8 @@ void bcm_sf2_cfp_get_strings(struct dsa_switch *ds, int port,
 				 "CFP%03d_%sCntr",
 				 i, bcm_sf2_cfp_stats[j].name);
 			iter = (i - 1) * s + j;
-			strlcpy(data + iter * ETH_GSTRING_LEN,
-				buf, ETH_GSTRING_LEN);
+			strscpy(data + iter * ETH_GSTRING_LEN, buf,
+				ETH_GSTRING_LEN);
 		}
 	}
 }
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 34cca0a4b31c..7b8f8a9251a2 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -941,9 +941,8 @@ static void mv88e6xxx_atu_vtu_get_strings(uint8_t *data)
 	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(mv88e6xxx_atu_vtu_stats_strings); i++)
-		strlcpy(data + i * ETH_GSTRING_LEN,
-			mv88e6xxx_atu_vtu_stats_strings[i],
-			ETH_GSTRING_LEN);
+		strscpy(data + i * ETH_GSTRING_LEN,
+		        mv88e6xxx_atu_vtu_stats_strings[i], ETH_GSTRING_LEN);
 }
 
 static void mv88e6xxx_get_strings(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/sja1105/sja1105_ethtool.c b/drivers/net/dsa/sja1105/sja1105_ethtool.c
index 9133a831ec79..c0eda6ff876b 100644
--- a/drivers/net/dsa/sja1105/sja1105_ethtool.c
+++ b/drivers/net/dsa/sja1105/sja1105_ethtool.c
@@ -523,14 +523,14 @@ void sja1105_get_strings(struct dsa_switch *ds, int port,
 	switch (stringset) {
 	case ETH_SS_STATS:
 		for (i = 0; i < ARRAY_SIZE(sja1105_port_stats); i++) {
-			strlcpy(p, sja1105_port_stats[i], ETH_GSTRING_LEN);
+			strscpy(p, sja1105_port_stats[i], ETH_GSTRING_LEN);
 			p += ETH_GSTRING_LEN;
 		}
 		if (priv->info->device_id == SJA1105E_DEVICE_ID ||
 		    priv->info->device_id == SJA1105T_DEVICE_ID)
 			return;
 		for (i = 0; i < ARRAY_SIZE(sja1105pqrs_extra_port_stats); i++) {
-			strlcpy(p, sja1105pqrs_extra_port_stats[i],
+			strscpy(p, sja1105pqrs_extra_port_stats[i],
 				ETH_GSTRING_LEN);
 			p += ETH_GSTRING_LEN;
 		}
diff --git a/drivers/net/dummy.c b/drivers/net/dummy.c
index bab3a9bb5e6f..fae994249c9d 100644
--- a/drivers/net/dummy.c
+++ b/drivers/net/dummy.c
@@ -102,7 +102,7 @@ static const struct net_device_ops dummy_netdev_ops = {
 static void dummy_get_drvinfo(struct net_device *dev,
 			      struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
 }
 
 static const struct ethtool_ops dummy_ethtool_ops = {
diff --git a/drivers/net/ethernet/3com/3c509.c b/drivers/net/ethernet/3com/3c509.c
index 667f38c9e4c6..71e1e4bae850 100644
--- a/drivers/net/ethernet/3com/3c509.c
+++ b/drivers/net/ethernet/3com/3c509.c
@@ -1136,7 +1136,7 @@ el3_netdev_set_ecmd(struct net_device *dev,
 
 static void el3_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
 }
 
 static int el3_get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/ethernet/3com/3c515.c b/drivers/net/ethernet/3com/3c515.c
index 47b4215bb93b..c85a58220d4c 100644
--- a/drivers/net/ethernet/3com/3c515.c
+++ b/drivers/net/ethernet/3com/3c515.c
@@ -1525,7 +1525,7 @@ static void set_rx_mode(struct net_device *dev)
 static void netdev_get_drvinfo(struct net_device *dev,
 			       struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
 	snprintf(info->bus_info, sizeof(info->bus_info), "ISA 0x%lx",
 		 dev->base_addr);
 }
diff --git a/drivers/net/ethernet/3com/3c589_cs.c b/drivers/net/ethernet/3com/3c589_cs.c
index 09816e84314d..9a1c3d2dd721 100644
--- a/drivers/net/ethernet/3com/3c589_cs.c
+++ b/drivers/net/ethernet/3com/3c589_cs.c
@@ -480,7 +480,7 @@ static void tc589_reset(struct net_device *dev)
 static void netdev_get_drvinfo(struct net_device *dev,
 			       struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
 	snprintf(info->bus_info, sizeof(info->bus_info),
 		"PCMCIA 0x%lx", dev->base_addr);
 }
diff --git a/drivers/net/ethernet/3com/3c59x.c b/drivers/net/ethernet/3com/3c59x.c
index 741c67e546d4..fa917e403b22 100644
--- a/drivers/net/ethernet/3com/3c59x.c
+++ b/drivers/net/ethernet/3com/3c59x.c
@@ -2957,13 +2957,13 @@ static void vortex_get_drvinfo(struct net_device *dev,
 {
 	struct vortex_private *vp = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
 	if (VORTEX_PCI(vp)) {
-		strlcpy(info->bus_info, pci_name(VORTEX_PCI(vp)),
+		strscpy(info->bus_info, pci_name(VORTEX_PCI(vp)),
 			sizeof(info->bus_info));
 	} else {
 		if (VORTEX_EISA(vp))
-			strlcpy(info->bus_info, dev_name(vp->gendev),
+			strscpy(info->bus_info, dev_name(vp->gendev),
 				sizeof(info->bus_info));
 		else
 			snprintf(info->bus_info, sizeof(info->bus_info),
diff --git a/drivers/net/ethernet/3com/typhoon.c b/drivers/net/ethernet/3com/typhoon.c
index 05e15b6e5e2c..d720e1139513 100644
--- a/drivers/net/ethernet/3com/typhoon.c
+++ b/drivers/net/ethernet/3com/typhoon.c
@@ -974,12 +974,12 @@ typhoon_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 
 	smp_rmb();
 	if (tp->card_state == Sleeping) {
-		strlcpy(info->fw_version, "Sleep image",
+		strscpy(info->fw_version, "Sleep image",
 			sizeof(info->fw_version));
 	} else {
 		INIT_COMMAND_WITH_RESPONSE(&xp_cmd, TYPHOON_CMD_READ_VERSIONS);
 		if (typhoon_issue_command(tp, 1, &xp_cmd, 3, xp_resp) < 0) {
-			strlcpy(info->fw_version, "Unknown runtime",
+			strscpy(info->fw_version, "Unknown runtime",
 				sizeof(info->fw_version));
 		} else {
 			u32 sleep_ver = le32_to_cpu(xp_resp[0].parm2);
@@ -989,8 +989,8 @@ typhoon_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 		}
 	}
 
-	strlcpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(pci_dev), sizeof(info->bus_info));
+	strscpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(pci_dev), sizeof(info->bus_info));
 }
 
 static int
diff --git a/drivers/net/ethernet/8390/ax88796.c b/drivers/net/ethernet/8390/ax88796.c
index 172947fc051a..28c072e89943 100644
--- a/drivers/net/ethernet/8390/ax88796.c
+++ b/drivers/net/ethernet/8390/ax88796.c
@@ -572,9 +572,9 @@ static void ax_get_drvinfo(struct net_device *dev,
 {
 	struct platform_device *pdev = to_platform_device(dev->dev.parent);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pdev->name, sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pdev->name, sizeof(info->bus_info));
 }
 
 static u32 ax_get_msglevel(struct net_device *dev)
diff --git a/drivers/net/ethernet/8390/etherh.c b/drivers/net/ethernet/8390/etherh.c
index bd22a534b1c0..4cf8f46ef40e 100644
--- a/drivers/net/ethernet/8390/etherh.c
+++ b/drivers/net/ethernet/8390/etherh.c
@@ -555,9 +555,9 @@ static int __init etherm_addr(char *addr)
 
 static void etherh_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, dev_name(dev->dev.parent),
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, dev_name(dev->dev.parent),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/adaptec/starfire.c b/drivers/net/ethernet/adaptec/starfire.c
index 555299737b51..1919676377af 100644
--- a/drivers/net/ethernet/adaptec/starfire.c
+++ b/drivers/net/ethernet/adaptec/starfire.c
@@ -1842,8 +1842,8 @@ static int check_if_running(struct net_device *dev)
 static void get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
 	struct netdev_private *np = netdev_priv(dev);
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(np->pci_dev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(np->pci_dev), sizeof(info->bus_info));
 }
 
 static int get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/ethernet/aeroflex/greth.c b/drivers/net/ethernet/aeroflex/greth.c
index 9c5891bbfe61..d0d31cacb437 100644
--- a/drivers/net/ethernet/aeroflex/greth.c
+++ b/drivers/net/ethernet/aeroflex/greth.c
@@ -1112,9 +1112,9 @@ static void greth_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *in
 {
 	struct greth_private *greth = netdev_priv(dev);
 
-	strlcpy(info->driver, dev_driver_string(greth->dev),
+	strscpy(info->driver, dev_driver_string(greth->dev),
 		sizeof(info->driver));
-	strlcpy(info->bus_info, greth->dev->bus->name, sizeof(info->bus_info));
+	strscpy(info->bus_info, greth->dev->bus->name, sizeof(info->bus_info));
 }
 
 static void greth_get_regs(struct net_device *dev, struct ethtool_regs *regs, void *p)
diff --git a/drivers/net/ethernet/agere/et131x.c b/drivers/net/ethernet/agere/et131x.c
index 41f8821f792d..826141f522e5 100644
--- a/drivers/net/ethernet/agere/et131x.c
+++ b/drivers/net/ethernet/agere/et131x.c
@@ -2953,8 +2953,8 @@ static void et131x_get_drvinfo(struct net_device *netdev,
 {
 	struct et131x_adapter *adapter = netdev_priv(netdev);
 
-	strlcpy(info->driver, DRIVER_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(adapter->pdev),
+	strscpy(info->driver, DRIVER_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(adapter->pdev),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/alacritech/slicoss.c b/drivers/net/ethernet/alacritech/slicoss.c
index 696517eae77f..28f373889086 100644
--- a/drivers/net/ethernet/alacritech/slicoss.c
+++ b/drivers/net/ethernet/alacritech/slicoss.c
@@ -1531,8 +1531,8 @@ static void slic_get_drvinfo(struct net_device *dev,
 {
 	struct slic_device *sdev = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(sdev->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(sdev->pdev), sizeof(info->bus_info));
 }
 
 static const struct ethtool_ops slic_ethtool_ops = {
diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.c b/drivers/net/ethernet/allwinner/sun4i-emac.c
index 862ea44beea7..de7067816d1e 100644
--- a/drivers/net/ethernet/allwinner/sun4i-emac.c
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
@@ -210,8 +210,8 @@ static void emac_inblk_32bit(void __iomem *reg, void *data, int count)
 static void emac_get_drvinfo(struct net_device *dev,
 			      struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, dev_name(&dev->dev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, dev_name(&dev->dev), sizeof(info->bus_info));
 }
 
 static u32 emac_get_msglevel(struct net_device *dev)
diff --git a/drivers/net/ethernet/alteon/acenic.c b/drivers/net/ethernet/alteon/acenic.c
index 1a7e4df9b3e9..a89948a801ae 100644
--- a/drivers/net/ethernet/alteon/acenic.c
+++ b/drivers/net/ethernet/alteon/acenic.c
@@ -2694,13 +2694,13 @@ static void ace_get_drvinfo(struct net_device *dev,
 {
 	struct ace_private *ap = netdev_priv(dev);
 
-	strlcpy(info->driver, "acenic", sizeof(info->driver));
+	strscpy(info->driver, "acenic", sizeof(info->driver));
 	snprintf(info->fw_version, sizeof(info->version), "%i.%i.%i",
 		 ap->firmware_major, ap->firmware_minor, ap->firmware_fix);
 
 	if (ap->pdev)
-		strlcpy(info->bus_info, pci_name(ap->pdev),
-			sizeof(info->bus_info));
+		strscpy(info->bus_info, pci_name(ap->pdev),
+		        sizeof(info->bus_info));
 
 }
 
diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 3b2cd28f962d..d5aa36931296 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -452,8 +452,8 @@ static void ena_get_drvinfo(struct net_device *dev,
 {
 	struct ena_adapter *adapter = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(adapter->pdev),
+	strscpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(adapter->pdev),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index df1884d57d1a..5857bdae0f6a 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3084,7 +3084,7 @@ static void ena_config_host_info(struct ena_com_dev *ena_dev, struct pci_dev *pd
 	host_info->bdf = (pdev->bus->number << 8) | pdev->devfn;
 	host_info->os_type = ENA_ADMIN_OS_LINUX;
 	host_info->kernel_ver = LINUX_VERSION_CODE;
-	strlcpy(host_info->kernel_ver_str, utsname()->version,
+	strscpy(host_info->kernel_ver_str, utsname()->version,
 		sizeof(host_info->kernel_ver_str) - 1);
 	host_info->os_dist = 0;
 	strncpy(host_info->os_dist_str, utsname()->release,
diff --git a/drivers/net/ethernet/amd/amd8111e.c b/drivers/net/ethernet/amd/amd8111e.c
index 960d483e8997..a58044b1d697 100644
--- a/drivers/net/ethernet/amd/amd8111e.c
+++ b/drivers/net/ethernet/amd/amd8111e.c
@@ -1371,10 +1371,10 @@ static void amd8111e_get_drvinfo(struct net_device *dev,
 {
 	struct amd8111e_priv *lp = netdev_priv(dev);
 	struct pci_dev *pci_dev = lp->pci_dev;
-	strlcpy(info->driver, MODULE_NAME, sizeof(info->driver));
+	strscpy(info->driver, MODULE_NAME, sizeof(info->driver));
 	snprintf(info->fw_version, sizeof(info->fw_version),
 		"%u", chip_version);
-	strlcpy(info->bus_info, pci_name(pci_dev), sizeof(info->bus_info));
+	strscpy(info->bus_info, pci_name(pci_dev), sizeof(info->bus_info));
 }
 
 static int amd8111e_get_regs_len(struct net_device *dev)
diff --git a/drivers/net/ethernet/amd/au1000_eth.c b/drivers/net/ethernet/amd/au1000_eth.c
index 19e195420e24..c0f396bae7ef 100644
--- a/drivers/net/ethernet/amd/au1000_eth.c
+++ b/drivers/net/ethernet/amd/au1000_eth.c
@@ -650,7 +650,7 @@ au1000_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
 	struct au1000_private *aup = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
 	snprintf(info->bus_info, sizeof(info->bus_info), "%s %d", DRV_NAME,
 		 aup->mac_id);
 }
diff --git a/drivers/net/ethernet/amd/nmclan_cs.c b/drivers/net/ethernet/amd/nmclan_cs.c
index 11c0b13edd30..8ccef8ab83c8 100644
--- a/drivers/net/ethernet/amd/nmclan_cs.c
+++ b/drivers/net/ethernet/amd/nmclan_cs.c
@@ -814,7 +814,7 @@ static int mace_close(struct net_device *dev)
 static void netdev_get_drvinfo(struct net_device *dev,
 			       struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
 	snprintf(info->bus_info, sizeof(info->bus_info),
 		"PCMCIA 0x%lx", dev->base_addr);
 }
diff --git a/drivers/net/ethernet/amd/pcnet32.c b/drivers/net/ethernet/amd/pcnet32.c
index 187b0b9a6e1d..f626821485dc 100644
--- a/drivers/net/ethernet/amd/pcnet32.c
+++ b/drivers/net/ethernet/amd/pcnet32.c
@@ -797,10 +797,10 @@ static void pcnet32_get_drvinfo(struct net_device *dev,
 {
 	struct pcnet32_private *lp = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
 	if (lp->pci_dev)
-		strlcpy(info->bus_info, pci_name(lp->pci_dev),
-			sizeof(info->bus_info));
+		strscpy(info->bus_info, pci_name(lp->pci_dev),
+		        sizeof(info->bus_info));
 	else
 		snprintf(info->bus_info, sizeof(info->bus_info),
 			"VLB 0x%lx", dev->base_addr);
diff --git a/drivers/net/ethernet/amd/sunlance.c b/drivers/net/ethernet/amd/sunlance.c
index ddece276ae23..1edb957601a4 100644
--- a/drivers/net/ethernet/amd/sunlance.c
+++ b/drivers/net/ethernet/amd/sunlance.c
@@ -1276,7 +1276,7 @@ static void lance_free_hwresources(struct lance_private *lp)
 /* Ethtool support... */
 static void sparc_lance_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, "sunlance", sizeof(info->driver));
+	strscpy(info->driver, "sunlance", sizeof(info->driver));
 }
 
 static const struct ethtool_ops sparc_lance_ethtool_ops = {
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c b/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
index 61f39a0e04f9..a12913e3cad8 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
@@ -404,8 +404,8 @@ static void xgbe_get_drvinfo(struct net_device *netdev,
 	struct xgbe_prv_data *pdata = netdev_priv(netdev);
 	struct xgbe_hw_features *hw_feat = &pdata->hw_feat;
 
-	strlcpy(drvinfo->driver, XGBE_DRV_NAME, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->bus_info, dev_name(pdata->dev),
+	strscpy(drvinfo->driver, XGBE_DRV_NAME, sizeof(drvinfo->driver));
+	strscpy(drvinfo->bus_info, dev_name(pdata->dev),
 		sizeof(drvinfo->bus_info));
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version), "%d.%d.%d",
 		 XGMAC_GET_BITS(hw_feat->version, MAC_VR, USERVER),
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
index de2a9348bc3f..54a08333d606 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -229,7 +229,7 @@ static void aq_ethtool_get_drvinfo(struct net_device *ndev,
 		 "%u.%u.%u", firmware_version >> 24,
 		 (firmware_version >> 16) & 0xFFU, firmware_version & 0xFFFFU);
 
-	strlcpy(drvinfo->bus_info, pdev ? pci_name(pdev) : "",
+	strscpy(drvinfo->bus_info, pdev ? pci_name(pdev) : "",
 		sizeof(drvinfo->bus_info));
 	drvinfo->n_stats = aq_ethtool_n_stats(ndev);
 	drvinfo->testinfo_len = 0;
diff --git a/drivers/net/ethernet/arc/emac_main.c b/drivers/net/ethernet/arc/emac_main.c
index b56a9e2aecd9..df8cd727e02e 100644
--- a/drivers/net/ethernet/arc/emac_main.c
+++ b/drivers/net/ethernet/arc/emac_main.c
@@ -91,7 +91,7 @@ static void arc_emac_get_drvinfo(struct net_device *ndev,
 {
 	struct arc_emac_priv *priv = netdev_priv(ndev);
 
-	strlcpy(info->driver, priv->drv_name, sizeof(info->driver));
+	strscpy(info->driver, priv->drv_name, sizeof(info->driver));
 }
 
 static const struct ethtool_ops arc_emac_ethtool_ops = {
diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index dd5c8a9038bb..24d55f25bff7 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -452,8 +452,8 @@ static void ag71xx_get_drvinfo(struct net_device *ndev,
 {
 	struct ag71xx *ag = netdev_priv(ndev);
 
-	strlcpy(info->driver, "ag71xx", sizeof(info->driver));
-	strlcpy(info->bus_info, of_node_full_name(ag->pdev->dev.of_node),
+	strscpy(info->driver, "ag71xx", sizeof(info->driver));
+	strscpy(info->bus_info, of_node_full_name(ag->pdev->dev.of_node),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_ethtool.c b/drivers/net/ethernet/atheros/atl1c/atl1c_ethtool.c
index e2eb7b8c63a0..14f002259e66 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_ethtool.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_ethtool.c
@@ -220,8 +220,8 @@ static void atl1c_get_drvinfo(struct net_device *netdev,
 {
 	struct atl1c_adapter *adapter = netdev_priv(netdev);
 
-	strlcpy(drvinfo->driver,  atl1c_driver_name, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
+	strscpy(drvinfo->driver, atl1c_driver_name, sizeof(drvinfo->driver));
+	strscpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_ethtool.c b/drivers/net/ethernet/atheros/atl1e/atl1e_ethtool.c
index 0cbde352d1ba..fa77e17e4333 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_ethtool.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_ethtool.c
@@ -306,9 +306,9 @@ static void atl1e_get_drvinfo(struct net_device *netdev,
 {
 	struct atl1e_adapter *adapter = netdev_priv(netdev);
 
-	strlcpy(drvinfo->driver,  atl1e_driver_name, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->fw_version, "L1e", sizeof(drvinfo->fw_version));
-	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
+	strscpy(drvinfo->driver, atl1e_driver_name, sizeof(drvinfo->driver));
+	strscpy(drvinfo->fw_version, "L1e", sizeof(drvinfo->fw_version));
+	strscpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/atheros/atlx/atl1.c b/drivers/net/ethernet/atheros/atlx/atl1.c
index eaf96d002fa5..f6fae19b4d51 100644
--- a/drivers/net/ethernet/atheros/atlx/atl1.c
+++ b/drivers/net/ethernet/atheros/atlx/atl1.c
@@ -3341,8 +3341,8 @@ static void atl1_get_drvinfo(struct net_device *netdev,
 {
 	struct atl1_adapter *adapter = netdev_priv(netdev);
 
-	strlcpy(drvinfo->driver, ATLX_DRIVER_NAME, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
+	strscpy(drvinfo->driver, ATLX_DRIVER_NAME, sizeof(drvinfo->driver));
+	strscpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/atheros/atlx/atl2.c b/drivers/net/ethernet/atheros/atlx/atl2.c
index 7b80d924632a..2da591ecdd24 100644
--- a/drivers/net/ethernet/atheros/atlx/atl2.c
+++ b/drivers/net/ethernet/atheros/atlx/atl2.c
@@ -2002,9 +2002,9 @@ static void atl2_get_drvinfo(struct net_device *netdev,
 {
 	struct atl2_adapter *adapter = netdev_priv(netdev);
 
-	strlcpy(drvinfo->driver,  atl2_driver_name, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->fw_version, "L2", sizeof(drvinfo->fw_version));
-	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
+	strscpy(drvinfo->driver, atl2_driver_name, sizeof(drvinfo->driver));
+	strscpy(drvinfo->fw_version, "L2", sizeof(drvinfo->fw_version));
+	strscpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/broadcom/b44.c
index b455b60a5434..52aba6181964 100644
--- a/drivers/net/ethernet/broadcom/b44.c
+++ b/drivers/net/ethernet/broadcom/b44.c
@@ -1788,13 +1788,14 @@ static void b44_get_drvinfo (struct net_device *dev, struct ethtool_drvinfo *inf
 	struct b44 *bp = netdev_priv(dev);
 	struct ssb_bus *bus = bp->sdev->bus;
 
-	strlcpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
+	strscpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
 	switch (bus->bustype) {
 	case SSB_BUSTYPE_PCI:
-		strlcpy(info->bus_info, pci_name(bus->host_pci), sizeof(info->bus_info));
+		strscpy(info->bus_info, pci_name(bus->host_pci),
+			sizeof(info->bus_info));
 		break;
 	case SSB_BUSTYPE_SSB:
-		strlcpy(info->bus_info, "SSB", sizeof(info->bus_info));
+		strscpy(info->bus_info, "SSB", sizeof(info->bus_info));
 		break;
 	case SSB_BUSTYPE_PCMCIA:
 	case SSB_BUSTYPE_SDIO:
diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
index 916824cca3fd..7d5d743354e1 100644
--- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -1302,8 +1302,9 @@ static const u32 unused_mib_regs[] = {
 static void bcm_enet_get_drvinfo(struct net_device *netdev,
 				 struct ethtool_drvinfo *drvinfo)
 {
-	strlcpy(drvinfo->driver, bcm_enet_driver_name, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->bus_info, "bcm63xx", sizeof(drvinfo->bus_info));
+	strscpy(drvinfo->driver, bcm_enet_driver_name,
+		sizeof(drvinfo->driver));
+	strscpy(drvinfo->bus_info, "bcm63xx", sizeof(drvinfo->bus_info));
 }
 
 static int bcm_enet_get_sset_count(struct net_device *netdev,
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 0fdd19d99d99..8d9b5f260edf 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -307,8 +307,8 @@ static const struct bcm_sysport_stats bcm_sysport_gstrings_stats[] = {
 static void bcm_sysport_get_drvinfo(struct net_device *dev,
 				    struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
-	strlcpy(info->bus_info, "platform", sizeof(info->bus_info));
+	strscpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
+	strscpy(info->bus_info, "platform", sizeof(info->bus_info));
 }
 
 static u32 bcm_sysport_get_msglvl(struct net_device *dev)
diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index 98ec1b8a7d8e..c9cfaecacecf 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -1367,8 +1367,8 @@ static void bgmac_get_strings(struct net_device *dev, u32 stringset,
 		return;
 
 	for (i = 0; i < BGMAC_STATS_LEN; i++)
-		strlcpy(data + i * ETH_GSTRING_LEN,
-			bgmac_get_strings_stats[i].name, ETH_GSTRING_LEN);
+		strscpy(data + i * ETH_GSTRING_LEN,
+		        bgmac_get_strings_stats[i].name, ETH_GSTRING_LEN);
 }
 
 static void bgmac_get_ethtool_stats(struct net_device *dev,
@@ -1395,8 +1395,8 @@ static void bgmac_get_ethtool_stats(struct net_device *dev,
 static void bgmac_get_drvinfo(struct net_device *net_dev,
 			      struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
-	strlcpy(info->bus_info, "AXI", sizeof(info->bus_info));
+	strscpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
+	strscpy(info->bus_info, "AXI", sizeof(info->bus_info));
 }
 
 static const struct ethtool_ops bgmac_ethtool_ops = {
diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index 3e8a179f39db..7ef231a9936f 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -7041,9 +7041,9 @@ bnx2_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
 	struct bnx2 *bp = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(bp->pdev), sizeof(info->bus_info));
-	strlcpy(info->fw_version, bp->fw_version, sizeof(info->fw_version));
+	strscpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(bp->pdev), sizeof(info->bus_info));
+	strscpy(info->fw_version, bp->fw_version, sizeof(info->fw_version));
 }
 
 #define BNX2_REGDUMP_LEN		(32 * 1024)
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 1a6ec1a12d53..22c411492401 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -149,7 +149,7 @@ void bnx2x_fill_fw_str(struct bnx2x *bp, char *buf, size_t buf_len)
 		phy_fw_ver[0] = '\0';
 		bnx2x_get_ext_phy_fw_version(&bp->link_params,
 					     phy_fw_ver, PHY_FW_VER_LEN);
-		strlcpy(buf, bp->fw_ver, buf_len);
+		strscpy(buf, bp->fw_ver, buf_len);
 		snprintf(buf + strlen(bp->fw_ver), 32 - strlen(bp->fw_ver),
 			 "bc %d.%d.%d%s%s",
 			 (bp->common.bc_ver & 0xff0000) >> 16,
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
index 32245bbe88a8..225277cd5dee 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
@@ -1112,7 +1112,7 @@ static void bnx2x_get_drvinfo(struct net_device *dev,
 	int ext_dev_info_offset;
 	u32 mbi;
 
-	strlcpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
+	strscpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
 
 	if (SHMEM2_HAS(bp, extended_dev_info_shared_addr)) {
 		ext_dev_info_offset = SHMEM2_RD(bp,
@@ -1126,7 +1126,7 @@ static void bnx2x_get_drvinfo(struct net_device *dev,
 				 (mbi & 0xff000000) >> 24,
 				 (mbi & 0x00ff0000) >> 16,
 				 (mbi & 0x0000ff00) >> 8);
-			strlcpy(info->fw_version, version,
+			strscpy(info->fw_version, version,
 				sizeof(info->fw_version));
 		}
 	}
@@ -1135,7 +1135,7 @@ static void bnx2x_get_drvinfo(struct net_device *dev,
 	bnx2x_fill_fw_str(bp, version, ETHTOOL_FWVERS_LEN);
 	strlcat(info->fw_version, version, sizeof(info->fw_version));
 
-	strlcpy(info->bus_info, pci_name(bp->pdev), sizeof(info->bus_info));
+	strscpy(info->bus_info, pci_name(bp->pdev), sizeof(info->bus_info));
 }
 
 static void bnx2x_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 28069b290862..e8df78a6f597 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -3375,7 +3375,7 @@ static void bnx2x_drv_info_ether_stat(struct bnx2x *bp)
 		&bp->sp_objs->mac_obj;
 	int i;
 
-	strlcpy(ether_stat->version, DRV_MODULE_VERSION,
+	strscpy(ether_stat->version, DRV_MODULE_VERSION,
 		ETH_STAT_INFO_VERSION_LEN);
 
 	/* get DRV_INFO_ETH_STAT_NUM_MACS_REQUIRED macs, placing them in the
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h
index 3a716c015415..b9f4577ce8d8 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h
@@ -518,7 +518,7 @@ int bnx2x_vfpf_storm_rx_mode(struct bnx2x *bp);
 static inline void bnx2x_vf_fill_fw_str(struct bnx2x *bp, char *buf,
 					size_t buf_len)
 {
-	strlcpy(buf, bp->acquire_resp.pfdev_info.fw_ver, buf_len);
+	strscpy(buf, bp->acquire_resp.pfdev_info.fw_ver, buf_len);
 }
 
 static inline int bnx2x_vf_ustorm_prods_offset(struct bnx2x *bp,
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c
index ea0e9394f898..1acc7501f6ab 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c
@@ -380,7 +380,7 @@ int bnx2x_vfpf_acquire(struct bnx2x *bp, u8 tx_count, u8 rx_count)
 	bp->igu_base_sb = bp->acquire_resp.resc.hw_sbs[0].hw_sb_id;
 	bp->vlan_credit = bp->acquire_resp.resc.num_vlan_filters;
 
-	strlcpy(bp->fw_ver, bp->acquire_resp.pfdev_info.fw_ver,
+	strscpy(bp->fw_ver, bp->acquire_resp.pfdev_info.fw_ver,
 		sizeof(bp->fw_ver));
 
 	if (is_valid_ether_addr(bp->acquire_resp.resc.current_mac_addr))
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 1471c9a36238..2bcbe60ca460 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1317,9 +1317,9 @@ static void bnxt_get_drvinfo(struct net_device *dev,
 {
 	struct bnxt *bp = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
-	strlcpy(info->fw_version, bp->fw_ver_str, sizeof(info->fw_version));
-	strlcpy(info->bus_info, pci_name(bp->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
+	strscpy(info->fw_version, bp->fw_ver_str, sizeof(info->fw_version));
+	strscpy(info->bus_info, pci_name(bp->pdev), sizeof(info->bus_info));
 	info->n_stats = bnxt_get_num_stats(bp);
 	info->testinfo_len = bp->num_tests;
 	/* TODO CHIMP_FW: eeprom dump details */
@@ -3639,7 +3639,7 @@ bnxt_fill_coredump_record(struct bnxt *bp, struct bnxt_coredump_record *record,
 	record->low_version = 0;
 	record->high_version = 1;
 	record->asic_state = 0;
-	strlcpy(record->system_name, utsname()->nodename,
+	strscpy(record->system_name, utsname()->nodename,
 		sizeof(record->system_name));
 	record->year = cpu_to_le16(tm.tm_year + 1900);
 	record->month = cpu_to_le16(tm.tm_mon + 1);
@@ -3655,7 +3655,7 @@ bnxt_fill_coredump_record(struct bnxt *bp, struct bnxt_coredump_record *record,
 	record->os_ver_major = cpu_to_le32(os_ver_major);
 	record->os_ver_minor = cpu_to_le32(os_ver_minor);
 
-	strlcpy(record->os_name, utsname()->sysname, 32);
+	strscpy(record->os_name, utsname()->sysname, 32);
 	time64_to_tm(end, 0, &tm);
 	record->end_year = cpu_to_le16(tm.tm_year + 1900);
 	record->end_month = cpu_to_le16(tm.tm_mon + 1);
@@ -3885,7 +3885,7 @@ void bnxt_ethtool_init(struct bnxt *bp)
 		} else if (i == BNXT_IRQ_TEST_IDX) {
 			strcpy(str, "Interrupt_test (offline)");
 		} else {
-			strlcpy(str, fw_str, ETH_GSTRING_LEN);
+			strscpy(str, fw_str, ETH_GSTRING_LEN);
 			strncat(str, " test", ETH_GSTRING_LEN - strlen(str));
 			if (test_info->offline_mask & (1 << i))
 				strncat(str, " (offline)",
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
index 4b5c8fd76a51..e993860ef4c2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
@@ -218,7 +218,7 @@ static int bnxt_vf_rep_get_phys_port_name(struct net_device *dev, char *buf,
 static void bnxt_vf_rep_get_drvinfo(struct net_device *dev,
 				    struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
+	strscpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
 }
 
 static int bnxt_vf_rep_get_port_parent_id(struct net_device *dev,
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index be85dad2e3bc..8ccd0497f904 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1100,7 +1100,7 @@ static const struct bcmgenet_stats bcmgenet_gstrings_stats[] = {
 static void bcmgenet_get_drvinfo(struct net_device *dev,
 				 struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, "bcmgenet", sizeof(info->driver));
+	strscpy(info->driver, "bcmgenet", sizeof(info->driver));
 }
 
 static int bcmgenet_get_sset_count(struct net_device *dev, int string_set)
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 5143cdd0eeca..41b535de45ba 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -12317,9 +12317,9 @@ static void tg3_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info
 {
 	struct tg3 *tp = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
-	strlcpy(info->fw_version, tp->fw_ver, sizeof(info->fw_version));
-	strlcpy(info->bus_info, pci_name(tp->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
+	strscpy(info->fw_version, tp->fw_ver, sizeof(info->fw_version));
+	strscpy(info->bus_info, pci_name(tp->pdev), sizeof(info->bus_info));
 }
 
 static void tg3_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
diff --git a/drivers/net/ethernet/brocade/bna/bnad_ethtool.c b/drivers/net/ethernet/brocade/bna/bnad_ethtool.c
index 588c4804d10a..d7334e7eddee 100644
--- a/drivers/net/ethernet/brocade/bna/bnad_ethtool.c
+++ b/drivers/net/ethernet/brocade/bna/bnad_ethtool.c
@@ -283,7 +283,7 @@ bnad_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *drvinfo)
 	struct bfa_ioc_attr *ioc_attr;
 	unsigned long flags;
 
-	strlcpy(drvinfo->driver, BNAD_NAME, sizeof(drvinfo->driver));
+	strscpy(drvinfo->driver, BNAD_NAME, sizeof(drvinfo->driver));
 
 	ioc_attr = kzalloc(sizeof(*ioc_attr), GFP_KERNEL);
 	if (ioc_attr) {
@@ -291,12 +291,12 @@ bnad_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *drvinfo)
 		bfa_nw_ioc_get_attr(&bnad->bna.ioceth.ioc, ioc_attr);
 		spin_unlock_irqrestore(&bnad->bna_lock, flags);
 
-		strlcpy(drvinfo->fw_version, ioc_attr->adapter_attr.fw_ver,
+		strscpy(drvinfo->fw_version, ioc_attr->adapter_attr.fw_ver,
 			sizeof(drvinfo->fw_version));
 		kfree(ioc_attr);
 	}
 
-	strlcpy(drvinfo->bus_info, pci_name(bnad->pcidev),
+	strscpy(drvinfo->bus_info, pci_name(bnad->pcidev),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
index 5e50bb19bf26..b346ea47321e 100644
--- a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
+++ b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
@@ -1345,7 +1345,7 @@ static void octeon_mgmt_poll_controller(struct net_device *netdev)
 static void octeon_mgmt_get_drvinfo(struct net_device *netdev,
 				    struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
 }
 
 static int octeon_mgmt_nway_reset(struct net_device *dev)
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c b/drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c
index c7bdac79299a..5da9bdfda1ce 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c
@@ -190,8 +190,8 @@ static void nicvf_get_drvinfo(struct net_device *netdev,
 {
 	struct nicvf *nic = netdev_priv(netdev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(nic->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(nic->pdev), sizeof(info->bus_info));
 }
 
 static u32 nicvf_get_msglevel(struct net_device *netdev)
diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
index 0e4a0f413960..1e3dc095072c 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -428,8 +428,8 @@ static void get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
 	struct adapter *adapter = dev->ml_priv;
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(adapter->pdev),
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(adapter->pdev),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index 84ad7261e243..f50fbd8aee25 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -1627,8 +1627,8 @@ static void get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 	t3_get_tp_version(adapter, &tp_vers);
 	spin_unlock(&adapter->stats_lock);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(adapter->pdev),
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(adapter->pdev),
 		sizeof(info->bus_info));
 	if (fw_vers)
 		snprintf(info->fw_version, sizeof(info->fw_version),
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index 61ea3ec5c3fc..78969c9d5c74 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -199,8 +199,8 @@ static void get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 	struct adapter *adapter = netdev2adap(dev);
 	u32 exprom_vers;
 
-	strlcpy(info->driver, cxgb4_driver_name, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(adapter->pdev),
+	strscpy(info->driver, cxgb4_driver_name, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(adapter->pdev),
 		sizeof(info->bus_info));
 	info->regdump_len = get_regs_len(dev);
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 7fd264a6d085..7d432e6e077a 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -3905,8 +3905,8 @@ static void cxgb4_mgmt_get_drvinfo(struct net_device *dev,
 {
 	struct adapter *adapter = netdev2adap(dev);
 
-	strlcpy(info->driver, cxgb4_driver_name, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(adapter->pdev),
+	strscpy(info->driver, cxgb4_driver_name, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(adapter->pdev),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index 2820a0bb971b..4ffb75773602 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -1553,8 +1553,8 @@ static void cxgb4vf_get_drvinfo(struct net_device *dev,
 {
 	struct adapter *adapter = netdev2adap(dev);
 
-	strlcpy(drvinfo->driver, KBUILD_MODNAME, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->bus_info, pci_name(to_pci_dev(dev->dev.parent)),
+	strscpy(drvinfo->driver, KBUILD_MODNAME, sizeof(drvinfo->driver));
+	strscpy(drvinfo->bus_info, pci_name(to_pci_dev(dev->dev.parent)),
 		sizeof(drvinfo->bus_info));
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 		 "%u.%u.%u.%u, TP %u.%u.%u.%u",
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c
index 9098b3eed4da..1e55b12fee51 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c
@@ -193,7 +193,7 @@ static void chtls_register_dev(struct chtls_dev *cdev)
 {
 	struct tls_toe_device *tlsdev = &cdev->tlsdev;
 
-	strlcpy(tlsdev->name, "chtls", TLS_TOE_DEVICE_NAME_MAX);
+	strscpy(tlsdev->name, "chtls", TLS_TOE_DEVICE_NAME_MAX);
 	strlcat(tlsdev->name, cdev->lldi->ports[0]->name,
 		TLS_TOE_DEVICE_NAME_MAX);
 	tlsdev->feature = chtls_inline_feature;
diff --git a/drivers/net/ethernet/cirrus/ep93xx_eth.c b/drivers/net/ethernet/cirrus/ep93xx_eth.c
index 9f5e5ec69991..a63855b032f3 100644
--- a/drivers/net/ethernet/cirrus/ep93xx_eth.c
+++ b/drivers/net/ethernet/cirrus/ep93xx_eth.c
@@ -689,7 +689,7 @@ static int ep93xx_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 
 static void ep93xx_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
+	strscpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
 }
 
 static int ep93xx_get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/ethernet/cisco/enic/enic_ethtool.c b/drivers/net/ethernet/cisco/enic/enic_ethtool.c
index 1a9803f2073e..9428d8c9f495 100644
--- a/drivers/net/ethernet/cisco/enic/enic_ethtool.c
+++ b/drivers/net/ethernet/cisco/enic/enic_ethtool.c
@@ -146,10 +146,10 @@ static void enic_get_drvinfo(struct net_device *netdev,
 	if (err == -ENOMEM)
 		return;
 
-	strlcpy(drvinfo->driver, DRV_NAME, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->fw_version, fw_info->fw_version,
+	strscpy(drvinfo->driver, DRV_NAME, sizeof(drvinfo->driver));
+	strscpy(drvinfo->fw_version, fw_info->fw_version,
 		sizeof(drvinfo->fw_version));
-	strlcpy(drvinfo->bus_info, pci_name(enic->pdev),
+	strscpy(drvinfo->bus_info, pci_name(enic->pdev),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
index 5c6c8c5ec747..d64eea6d2a11 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -541,8 +541,8 @@ static void dm9000_get_drvinfo(struct net_device *dev,
 {
 	struct board_info *dm = to_dm9000_board(dev);
 
-	strlcpy(info->driver, CARDNAME, sizeof(info->driver));
-	strlcpy(info->bus_info, to_platform_device(dm->dev)->name,
+	strscpy(info->driver, CARDNAME, sizeof(info->driver));
+	strscpy(info->bus_info, to_platform_device(dm->dev)->name,
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/dec/tulip/de2104x.c b/drivers/net/ethernet/dec/tulip/de2104x.c
index d9f6c19940ef..b11f598f58dc 100644
--- a/drivers/net/ethernet/dec/tulip/de2104x.c
+++ b/drivers/net/ethernet/dec/tulip/de2104x.c
@@ -1606,8 +1606,8 @@ static void de_get_drvinfo (struct net_device *dev,struct ethtool_drvinfo *info)
 {
 	struct de_private *de = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(de->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(de->pdev), sizeof(info->bus_info));
 }
 
 static int de_get_regs_len(struct net_device *dev)
diff --git a/drivers/net/ethernet/dec/tulip/dmfe.c b/drivers/net/ethernet/dec/tulip/dmfe.c
index 87a27fe2992d..5ddbb339cc8f 100644
--- a/drivers/net/ethernet/dec/tulip/dmfe.c
+++ b/drivers/net/ethernet/dec/tulip/dmfe.c
@@ -1075,8 +1075,8 @@ static void dmfe_ethtool_get_drvinfo(struct net_device *dev,
 {
 	struct dmfe_board_info *np = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(np->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(np->pdev), sizeof(info->bus_info));
 }
 
 static int dmfe_ethtool_set_wol(struct net_device *dev,
diff --git a/drivers/net/ethernet/dec/tulip/tulip_core.c b/drivers/net/ethernet/dec/tulip/tulip_core.c
index e7b0d7de40fd..a6b9039f607f 100644
--- a/drivers/net/ethernet/dec/tulip/tulip_core.c
+++ b/drivers/net/ethernet/dec/tulip/tulip_core.c
@@ -858,8 +858,8 @@ static struct net_device_stats *tulip_get_stats(struct net_device *dev)
 static void tulip_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
 	struct tulip_private *np = netdev_priv(dev);
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(np->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(np->pdev), sizeof(info->bus_info));
 }
 
 
diff --git a/drivers/net/ethernet/dec/tulip/uli526x.c b/drivers/net/ethernet/dec/tulip/uli526x.c
index 13e73ed15ef0..707d781e312d 100644
--- a/drivers/net/ethernet/dec/tulip/uli526x.c
+++ b/drivers/net/ethernet/dec/tulip/uli526x.c
@@ -968,8 +968,8 @@ static void netdev_get_drvinfo(struct net_device *dev,
 {
 	struct uli526x_board_info *np = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(np->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(np->pdev), sizeof(info->bus_info));
 }
 
 static int netdev_get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/ethernet/dec/tulip/winbond-840.c b/drivers/net/ethernet/dec/tulip/winbond-840.c
index 89cbdc1f4857..6bf22ecee6a6 100644
--- a/drivers/net/ethernet/dec/tulip/winbond-840.c
+++ b/drivers/net/ethernet/dec/tulip/winbond-840.c
@@ -1376,8 +1376,8 @@ static void netdev_get_drvinfo (struct net_device *dev, struct ethtool_drvinfo *
 {
 	struct netdev_private *np = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(np->pci_dev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(np->pci_dev), sizeof(info->bus_info));
 }
 
 static int netdev_get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/ethernet/dlink/dl2k.c b/drivers/net/ethernet/dlink/dl2k.c
index 734acb834c98..76d30557f77d 100644
--- a/drivers/net/ethernet/dlink/dl2k.c
+++ b/drivers/net/ethernet/dlink/dl2k.c
@@ -1236,8 +1236,8 @@ static void rio_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info
 {
 	struct netdev_private *np = netdev_priv(dev);
 
-	strlcpy(info->driver, "dl2k", sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(np->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, "dl2k", sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(np->pdev), sizeof(info->bus_info));
 }
 
 static int rio_get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/ethernet/dlink/sundance.c b/drivers/net/ethernet/dlink/sundance.c
index e3a8858915b3..b18f26a9fd5b 100644
--- a/drivers/net/ethernet/dlink/sundance.c
+++ b/drivers/net/ethernet/dlink/sundance.c
@@ -1642,8 +1642,8 @@ static int check_if_running(struct net_device *dev)
 static void get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
 	struct netdev_private *np = netdev_priv(dev);
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(np->pci_dev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(np->pci_dev), sizeof(info->bus_info));
 }
 
 static int get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/ethernet/dnet.c b/drivers/net/ethernet/dnet.c
index 48c6eb142dcc..166c7b8b98c2 100644
--- a/drivers/net/ethernet/dnet.c
+++ b/drivers/net/ethernet/dnet.c
@@ -725,8 +725,8 @@ static struct net_device_stats *dnet_get_stats(struct net_device *dev)
 static void dnet_get_drvinfo(struct net_device *dev,
 			     struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, "0", sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, "0", sizeof(info->bus_info));
 }
 
 static const struct ethtool_ops dnet_ethtool_ops = {
diff --git a/drivers/net/ethernet/emulex/benet/be_cmds.c b/drivers/net/ethernet/emulex/benet/be_cmds.c
index 701c12c9e033..015f84d0c0c3 100644
--- a/drivers/net/ethernet/emulex/benet/be_cmds.c
+++ b/drivers/net/ethernet/emulex/benet/be_cmds.c
@@ -1876,9 +1876,10 @@ int be_cmd_get_fw_ver(struct be_adapter *adapter)
 	if (!status) {
 		struct be_cmd_resp_get_fw_version *resp = embedded_payload(wrb);
 
-		strlcpy(adapter->fw_ver, resp->firmware_version_string,
+		strscpy(adapter->fw_ver, resp->firmware_version_string,
 			sizeof(adapter->fw_ver));
-		strlcpy(adapter->fw_on_flash, resp->fw_on_flash_version_string,
+		strscpy(adapter->fw_on_flash,
+			resp->fw_on_flash_version_string,
 			sizeof(adapter->fw_on_flash));
 	}
 err:
@@ -2371,7 +2372,7 @@ static int lancer_cmd_write_object(struct be_adapter *adapter,
 
 	be_dws_cpu_to_le(ctxt, sizeof(req->context));
 	req->write_offset = cpu_to_le32(data_offset);
-	strlcpy(req->object_name, obj_name, sizeof(req->object_name));
+	strscpy(req->object_name, obj_name, sizeof(req->object_name));
 	req->descriptor_count = cpu_to_le32(1);
 	req->buf_len = cpu_to_le32(data_size);
 	req->addr_low = cpu_to_le32((cmd->dma +
@@ -2440,9 +2441,10 @@ int be_cmd_query_sfp_info(struct be_adapter *adapter)
 	status = be_cmd_read_port_transceiver_data(adapter, TR_PAGE_A0,
 						   page_data);
 	if (!status) {
-		strlcpy(adapter->phy.vendor_name, page_data +
-			SFP_VENDOR_NAME_OFFSET, SFP_VENDOR_NAME_LEN - 1);
-		strlcpy(adapter->phy.vendor_pn,
+		strscpy(adapter->phy.vendor_name,
+			page_data + SFP_VENDOR_NAME_OFFSET,
+			SFP_VENDOR_NAME_LEN - 1);
+		strscpy(adapter->phy.vendor_pn,
 			page_data + SFP_VENDOR_PN_OFFSET,
 			SFP_VENDOR_NAME_LEN - 1);
 	}
@@ -2471,7 +2473,7 @@ static int lancer_cmd_delete_object(struct be_adapter *adapter,
 			       OPCODE_COMMON_DELETE_OBJECT,
 			       sizeof(*req), wrb, NULL);
 
-	strlcpy(req->object_name, obj_name, sizeof(req->object_name));
+	strscpy(req->object_name, obj_name, sizeof(req->object_name));
 
 	status = be_mcc_notify_wait(adapter);
 err:
diff --git a/drivers/net/ethernet/emulex/benet/be_ethtool.c b/drivers/net/ethernet/emulex/benet/be_ethtool.c
index 99cc1c46fb30..32bce86abcd8 100644
--- a/drivers/net/ethernet/emulex/benet/be_ethtool.c
+++ b/drivers/net/ethernet/emulex/benet/be_ethtool.c
@@ -220,15 +220,15 @@ static void be_get_drvinfo(struct net_device *netdev,
 {
 	struct be_adapter *adapter = netdev_priv(netdev);
 
-	strlcpy(drvinfo->driver, DRV_NAME, sizeof(drvinfo->driver));
+	strscpy(drvinfo->driver, DRV_NAME, sizeof(drvinfo->driver));
 	if (!memcmp(adapter->fw_ver, adapter->fw_on_flash, FW_VER_LEN))
-		strlcpy(drvinfo->fw_version, adapter->fw_ver,
+		strscpy(drvinfo->fw_version, adapter->fw_ver,
 			sizeof(drvinfo->fw_version));
 	else
 		snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 			 "%s [%s]", adapter->fw_ver, adapter->fw_on_flash);
 
-	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
+	strscpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 80fb1f537bb3..db12343b8762 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1148,8 +1148,9 @@ static int ftgmac100_mdiobus_write(struct mii_bus *bus, int phy_addr,
 static void ftgmac100_get_drvinfo(struct net_device *netdev,
 				  struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, dev_name(&netdev->dev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, dev_name(&netdev->dev),
+		sizeof(info->bus_info));
 }
 
 static void ftgmac100_get_ringparam(struct net_device *netdev,
diff --git a/drivers/net/ethernet/faraday/ftmac100.c b/drivers/net/ethernet/faraday/ftmac100.c
index 473b337b2e3b..b17d4e6cc365 100644
--- a/drivers/net/ethernet/faraday/ftmac100.c
+++ b/drivers/net/ethernet/faraday/ftmac100.c
@@ -807,8 +807,9 @@ static void ftmac100_mdio_write(struct net_device *netdev, int phy_id, int reg,
 static void ftmac100_get_drvinfo(struct net_device *netdev,
 				 struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, dev_name(&netdev->dev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, dev_name(&netdev->dev),
+		sizeof(info->bus_info));
 }
 
 static int ftmac100_get_link_ksettings(struct net_device *netdev,
diff --git a/drivers/net/ethernet/fealnx.c b/drivers/net/ethernet/fealnx.c
index c696651dd735..4fb7bc2fc79f 100644
--- a/drivers/net/ethernet/fealnx.c
+++ b/drivers/net/ethernet/fealnx.c
@@ -1807,8 +1807,8 @@ static void netdev_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *i
 {
 	struct netdev_private *np = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(np->pci_dev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(np->pci_dev), sizeof(info->bus_info));
 }
 
 static int netdev_get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
index 1268996b7030..0351ab24f404 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
@@ -106,9 +106,8 @@ static int dpaa_set_link_ksettings(struct net_device *net_dev,
 static void dpaa_get_drvinfo(struct net_device *net_dev,
 			     struct ethtool_drvinfo *drvinfo)
 {
-	strlcpy(drvinfo->driver, KBUILD_MODNAME,
-		sizeof(drvinfo->driver));
-	strlcpy(drvinfo->bus_info, dev_name(net_dev->dev.parent->parent),
+	strscpy(drvinfo->driver, KBUILD_MODNAME, sizeof(drvinfo->driver));
+	strscpy(drvinfo->bus_info, dev_name(net_dev->dev.parent->parent),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index f981a523e13a..0b30e61bd0a0 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -72,12 +72,12 @@ static void dpaa2_eth_get_drvinfo(struct net_device *net_dev,
 {
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
 
-	strlcpy(drvinfo->driver, KBUILD_MODNAME, sizeof(drvinfo->driver));
+	strscpy(drvinfo->driver, KBUILD_MODNAME, sizeof(drvinfo->driver));
 
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 		 "%u.%u", priv->dpni_ver_major, priv->dpni_ver_minor);
 
-	strlcpy(drvinfo->bus_info, dev_name(net_dev->dev.parent->parent),
+	strscpy(drvinfo->bus_info, dev_name(net_dev->dev.parent->parent),
 		sizeof(drvinfo->bus_info));
 }
 
@@ -191,11 +191,11 @@ static void dpaa2_eth_get_strings(struct net_device *netdev, u32 stringset,
 	switch (stringset) {
 	case ETH_SS_STATS:
 		for (i = 0; i < DPAA2_ETH_NUM_STATS; i++) {
-			strlcpy(p, dpaa2_ethtool_stats[i], ETH_GSTRING_LEN);
+			strscpy(p, dpaa2_ethtool_stats[i], ETH_GSTRING_LEN);
 			p += ETH_GSTRING_LEN;
 		}
 		for (i = 0; i < DPAA2_ETH_NUM_EXTRA_STATS; i++) {
-			strlcpy(p, dpaa2_ethtool_extras[i], ETH_GSTRING_LEN);
+			strscpy(p, dpaa2_ethtool_extras[i], ETH_GSTRING_LEN);
 			p += ETH_GSTRING_LEN;
 		}
 		if (priv->mac)
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 90cd243070d7..6c1a3969a1ed 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -449,7 +449,7 @@ void dpaa2_mac_get_strings(u8 *data)
 	int i;
 
 	for (i = 0; i < DPAA2_MAC_NUM_STATS; i++) {
-		strlcpy(p, dpaa2_mac_ethtool_stats[i], ETH_GSTRING_LEN);
+		strscpy(p, dpaa2_mac_ethtool_stats[i], ETH_GSTRING_LEN);
 		p += ETH_GSTRING_LEN;
 	}
 }
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index 8ed1ebd5a183..b9d263b57038 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -223,7 +223,7 @@ static void enetc_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
 	switch (stringset) {
 	case ETH_SS_STATS:
 		for (i = 0; i < ARRAY_SIZE(enetc_si_counters); i++) {
-			strlcpy(p, enetc_si_counters[i].name, ETH_GSTRING_LEN);
+			strscpy(p, enetc_si_counters[i].name, ETH_GSTRING_LEN);
 			p += ETH_GSTRING_LEN;
 		}
 		for (i = 0; i < priv->num_tx_rings; i++) {
@@ -245,7 +245,7 @@ static void enetc_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
 			break;
 
 		for (i = 0; i < ARRAY_SIZE(enetc_port_counters); i++) {
-			strlcpy(p, enetc_port_counters[i].name,
+			strscpy(p, enetc_port_counters[i].name,
 				ETH_GSTRING_LEN);
 			p += ETH_GSTRING_LEN;
 		}
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 04f24c66cf36..af6a871c2dad 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2009,13 +2009,14 @@ static int fec_enet_mii_probe(struct net_device *ndev)
 				continue;
 			if (dev_id--)
 				continue;
-			strlcpy(mdio_bus_id, fep->mii_bus->id, MII_BUS_ID_SIZE);
+			strscpy(mdio_bus_id, fep->mii_bus->id,
+				MII_BUS_ID_SIZE);
 			break;
 		}
 
 		if (phy_id >= PHY_MAX_ADDR) {
 			netdev_info(ndev, "no PHY, assuming direct connection to switch\n");
-			strlcpy(mdio_bus_id, "fixed-0", MII_BUS_ID_SIZE);
+			strscpy(mdio_bus_id, "fixed-0", MII_BUS_ID_SIZE);
 			phy_id = 0;
 		}
 
@@ -2196,9 +2197,9 @@ static void fec_enet_get_drvinfo(struct net_device *ndev,
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
 
-	strlcpy(info->driver, fep->pdev->dev.driver->name,
+	strscpy(info->driver, fep->pdev->dev.driver->name,
 		sizeof(info->driver));
-	strlcpy(info->bus_info, dev_name(&ndev->dev), sizeof(info->bus_info));
+	strscpy(info->bus_info, dev_name(&ndev->dev), sizeof(info->bus_info));
 }
 
 static int fec_enet_get_regs_len(struct net_device *ndev)
diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index 2e344aada4c6..06313e4a5d75 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -582,7 +582,7 @@ void fec_ptp_init(struct platform_device *pdev, int irq_idx)
 	int ret;
 
 	fep->ptp_caps.owner = THIS_MODULE;
-	strlcpy(fep->ptp_caps.name, "fec ptp", sizeof(fep->ptp_caps.name));
+	strscpy(fep->ptp_caps.name, "fec ptp", sizeof(fep->ptp_caps.name));
 
 	fep->ptp_caps.max_adj = 250000000;
 	fep->ptp_caps.n_alarm = 0;
diff --git a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
index 78e008b81374..ec8142e2e469 100644
--- a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
+++ b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
@@ -791,7 +791,7 @@ static int fs_enet_close(struct net_device *dev)
 static void fs_get_drvinfo(struct net_device *dev,
 			    struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
+	strscpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
 }
 
 static int fs_get_regs_len(struct net_device *dev)
diff --git a/drivers/net/ethernet/freescale/gianfar_ethtool.c b/drivers/net/ethernet/freescale/gianfar_ethtool.c
index cc7d4f93da54..44bd278386e5 100644
--- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
+++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
@@ -163,7 +163,7 @@ static int gfar_sset_count(struct net_device *dev, int sset)
 static void gfar_gdrvinfo(struct net_device *dev,
 			  struct ethtool_drvinfo *drvinfo)
 {
-	strlcpy(drvinfo->driver, DRV_NAME, sizeof(drvinfo->driver));
+	strscpy(drvinfo->driver, DRV_NAME, sizeof(drvinfo->driver));
 }
 
 /* Return the length of the register structure */
diff --git a/drivers/net/ethernet/freescale/ucc_geth_ethtool.c b/drivers/net/ethernet/freescale/ucc_geth_ethtool.c
index 14c08a868190..8b6e94d63280 100644
--- a/drivers/net/ethernet/freescale/ucc_geth_ethtool.c
+++ b/drivers/net/ethernet/freescale/ucc_geth_ethtool.c
@@ -333,8 +333,8 @@ static void
 uec_get_drvinfo(struct net_device *netdev,
                        struct ethtool_drvinfo *drvinfo)
 {
-	strlcpy(drvinfo->driver, DRV_NAME, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->bus_info, "QUICC ENGINE", sizeof(drvinfo->bus_info));
+	strscpy(drvinfo->driver, DRV_NAME, sizeof(drvinfo->driver));
+	strscpy(drvinfo->bus_info, "QUICC ENGINE", sizeof(drvinfo->bus_info));
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/net/ethernet/fujitsu/fmvj18x_cs.c b/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
index a7b7a4aace79..7408af50b705 100644
--- a/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
+++ b/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
@@ -1046,8 +1046,8 @@ static void fjn_rx(struct net_device *dev)
 static void netdev_get_drvinfo(struct net_device *dev,
 			       struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
 	snprintf(info->bus_info, sizeof(info->bus_info),
 		"PCMCIA 0x%lx", dev->base_addr);
 }
diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index 7b44769bd87c..9b4aaf02bc4f 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -13,9 +13,9 @@ static void gve_get_drvinfo(struct net_device *netdev,
 {
 	struct gve_priv *priv = netdev_priv(netdev);
 
-	strlcpy(info->driver, "gve", sizeof(info->driver));
-	strlcpy(info->version, gve_version_str, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(priv->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, "gve", sizeof(info->driver));
+	strscpy(info->version, gve_version_str, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(priv->pdev), sizeof(info->bus_info));
 }
 
 static void gve_set_msglevel(struct net_device *netdev, u32 value)
diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
index 12f6c2442a7a..09e6d0f3aaf6 100644
--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -826,8 +826,8 @@ static int hip04_set_coalesce(struct net_device *netdev,
 static void hip04_get_drvinfo(struct net_device *netdev,
 			      struct ethtool_drvinfo *drvinfo)
 {
-	strlcpy(drvinfo->driver, DRV_NAME, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, DRV_VERSION, sizeof(drvinfo->version));
+	strscpy(drvinfo->driver, DRV_NAME, sizeof(drvinfo->driver));
+	strscpy(drvinfo->version, DRV_VERSION, sizeof(drvinfo->version));
 }
 
 static const struct ethtool_ops hip04_ethtool_ops = {
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
index c340d9acba80..c7848c382a5e 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
@@ -543,8 +543,8 @@ static void hinic_get_drvinfo(struct net_device *netdev,
 	struct hinic_hwif *hwif = hwdev->hwif;
 	int err;
 
-	strlcpy(info->driver, HINIC_DRV_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(hwif->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, HINIC_DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(hwif->pdev), sizeof(info->bus_info));
 
 	err = hinic_get_mgmt_version(nic_dev, mgmt_ver);
 	if (err)
diff --git a/drivers/net/ethernet/ibm/ehea/ehea_ethtool.c b/drivers/net/ethernet/ibm/ehea/ehea_ethtool.c
index 6cb86032ce46..1db5b6790a41 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_ethtool.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_ethtool.c
@@ -159,8 +159,8 @@ static int ehea_nway_reset(struct net_device *dev)
 static void ehea_get_drvinfo(struct net_device *dev,
 			       struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
 }
 
 static u32 ehea_get_msglevel(struct net_device *dev)
diff --git a/drivers/net/ethernet/ibm/emac/core.c b/drivers/net/ethernet/ibm/emac/core.c
index c00b9097eeea..ae83a2528675 100644
--- a/drivers/net/ethernet/ibm/emac/core.c
+++ b/drivers/net/ethernet/ibm/emac/core.c
@@ -2280,8 +2280,8 @@ static void emac_ethtool_get_drvinfo(struct net_device *ndev,
 {
 	struct emac_instance *dev = netdev_priv(ndev);
 
-	strlcpy(info->driver, "ibm_emac", sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->driver, "ibm_emac", sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
 	snprintf(info->bus_info, sizeof(info->bus_info), "PPC 4xx EMAC-%d %pOF",
 		 dev->cell_index, dev->ofdev->dev.of_node);
 }
diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index c3ec9ceed833..56d57c7ca0f2 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -745,8 +745,8 @@ static void ibmveth_init_link_settings(struct net_device *dev)
 static void netdev_get_drvinfo(struct net_device *dev,
 			       struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, ibmveth_driver_name, sizeof(info->driver));
-	strlcpy(info->version, ibmveth_driver_version, sizeof(info->version));
+	strscpy(info->driver, ibmveth_driver_name, sizeof(info->driver));
+	strscpy(info->version, ibmveth_driver_version, sizeof(info->version));
 }
 
 static netdev_features_t ibmveth_fix_features(struct net_device *dev,
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index da9450f18717..6fd91fabe3f5 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2600,9 +2600,9 @@ static void ibmvnic_get_drvinfo(struct net_device *netdev,
 {
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
 
-	strlcpy(info->driver, ibmvnic_driver_name, sizeof(info->driver));
-	strlcpy(info->version, IBMVNIC_DRIVER_VERSION, sizeof(info->version));
-	strlcpy(info->fw_version, adapter->fw_version,
+	strscpy(info->driver, ibmvnic_driver_name, sizeof(info->driver));
+	strscpy(info->version, IBMVNIC_DRIVER_VERSION, sizeof(info->version));
+	strscpy(info->fw_version, adapter->fw_version,
 		sizeof(info->fw_version));
 }
 
diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 8cc651d37a7f..b1916335cc89 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -2426,9 +2426,8 @@ static void e100_get_drvinfo(struct net_device *netdev,
 	struct ethtool_drvinfo *info)
 {
 	struct nic *nic = netdev_priv(netdev);
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(nic->pdev),
-		sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(nic->pdev), sizeof(info->bus_info));
 }
 
 #define E100_PHY_REGS 0x1C
diff --git a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
index f976e9daa3d8..dd3154432cb3 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
@@ -531,10 +531,9 @@ static void e1000_get_drvinfo(struct net_device *netdev,
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 
-	strlcpy(drvinfo->driver,  e1000_driver_name,
-		sizeof(drvinfo->driver));
+	strscpy(drvinfo->driver, e1000_driver_name, sizeof(drvinfo->driver));
 
-	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
+	strscpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/intel/e1000e/ethtool.c b/drivers/net/ethernet/intel/e1000e/ethtool.c
index 03215b0aee4b..61ac28d26b38 100644
--- a/drivers/net/ethernet/intel/e1000e/ethtool.c
+++ b/drivers/net/ethernet/intel/e1000e/ethtool.c
@@ -632,7 +632,7 @@ static void e1000_get_drvinfo(struct net_device *netdev,
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 
-	strlcpy(drvinfo->driver, e1000e_driver_name, sizeof(drvinfo->driver));
+	strscpy(drvinfo->driver, e1000e_driver_name, sizeof(drvinfo->driver));
 
 	/* EEPROM image version # is reported as firmware version # for
 	 * PCI-E controllers
@@ -643,7 +643,7 @@ static void e1000_get_drvinfo(struct net_device *netdev,
 		 (adapter->eeprom_vers & 0x0FF0) >> 4,
 		 (adapter->eeprom_vers & 0x000F));
 
-	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
+	strscpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index b30f00891c03..823a2ebcae24 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -7241,7 +7241,7 @@ static void e1000_print_device_info(struct e1000_adapter *adapter)
 	ret_val = e1000_read_pba_string_generic(hw, pba_str,
 						E1000_PBANUM_LENGTH);
 	if (ret_val)
-		strlcpy((char *)pba_str, "Unknown", sizeof(pba_str));
+		strscpy((char *)pba_str, "Unknown", sizeof(pba_str));
 	e_info("MAC: %d, PHY: %d, PBA No: %s\n",
 	       hw->mac.type, hw->phy.type, pba_str);
 }
@@ -7460,7 +7460,7 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	e1000e_set_ethtool_ops(netdev);
 	netdev->watchdog_timeo = 5 * HZ;
 	netif_napi_add(netdev, &adapter->napi, e1000e_poll, 64);
-	strlcpy(netdev->name, pci_name(pdev), sizeof(netdev->name));
+	strscpy(netdev->name, pci_name(pdev), sizeof(netdev->name));
 
 	netdev->mem_start = mmio_start;
 	netdev->mem_end = mmio_start + mmio_len;
@@ -7655,7 +7655,7 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!(adapter->flags & FLAG_HAS_AMT))
 		e1000e_get_hw_control(adapter);
 
-	strlcpy(netdev->name, "eth%d", sizeof(netdev->name));
+	strscpy(netdev->name, "eth%d", sizeof(netdev->name));
 	err = register_netdev(netdev);
 	if (err)
 		goto err_register;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 26ba1f3eb2d8..6138adf4a8c8 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -1895,10 +1895,10 @@ static void i40e_get_drvinfo(struct net_device *netdev,
 	struct i40e_vsi *vsi = np->vsi;
 	struct i40e_pf *pf = vsi->back;
 
-	strlcpy(drvinfo->driver, i40e_driver_name, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->fw_version, i40e_nvm_version_str(&pf->hw),
+	strscpy(drvinfo->driver, i40e_driver_name, sizeof(drvinfo->driver));
+	strscpy(drvinfo->fw_version, i40e_nvm_version_str(&pf->hw),
 		sizeof(drvinfo->fw_version));
-	strlcpy(drvinfo->bus_info, pci_name(pf->pdev),
+	strscpy(drvinfo->bus_info, pci_name(pf->pdev),
 		sizeof(drvinfo->bus_info));
 	drvinfo->n_priv_flags = I40E_PRIV_FLAGS_STR_LEN;
 	if (pf->hw.pf_id == 0)
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 1337686bd099..42ccd735dd88 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -9910,7 +9910,7 @@ static void i40e_send_version(struct i40e_pf *pf)
 	dv.minor_version = 0xff;
 	dv.build_version = 0xff;
 	dv.subbuild_version = 0;
-	strlcpy(dv.driver_string, UTS_RELEASE, sizeof(dv.driver_string));
+	strscpy(dv.driver_string, UTS_RELEASE, sizeof(dv.driver_string));
 	i40e_aq_send_driver_version(&pf->hw, &dv, NULL);
 }
 
@@ -15188,23 +15188,23 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 		switch (hw->bus.speed) {
 		case i40e_bus_speed_8000:
-			strlcpy(speed, "8.0", PCI_SPEED_SIZE); break;
+			strscpy(speed, "8.0", PCI_SPEED_SIZE); break;
 		case i40e_bus_speed_5000:
-			strlcpy(speed, "5.0", PCI_SPEED_SIZE); break;
+			strscpy(speed, "5.0", PCI_SPEED_SIZE); break;
 		case i40e_bus_speed_2500:
-			strlcpy(speed, "2.5", PCI_SPEED_SIZE); break;
+			strscpy(speed, "2.5", PCI_SPEED_SIZE); break;
 		default:
 			break;
 		}
 		switch (hw->bus.width) {
 		case i40e_bus_width_pcie_x8:
-			strlcpy(width, "8", PCI_WIDTH_SIZE); break;
+			strscpy(width, "8", PCI_WIDTH_SIZE); break;
 		case i40e_bus_width_pcie_x4:
-			strlcpy(width, "4", PCI_WIDTH_SIZE); break;
+			strscpy(width, "4", PCI_WIDTH_SIZE); break;
 		case i40e_bus_width_pcie_x2:
-			strlcpy(width, "2", PCI_WIDTH_SIZE); break;
+			strscpy(width, "2", PCI_WIDTH_SIZE); break;
 		case i40e_bus_width_pcie_x1:
-			strlcpy(width, "1", PCI_WIDTH_SIZE); break;
+			strscpy(width, "1", PCI_WIDTH_SIZE); break;
 		default:
 			break;
 		}
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ptp.c b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
index 7a879614ca55..4735279907b9 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ptp.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
@@ -699,7 +699,7 @@ static long i40e_ptp_create_clock(struct i40e_pf *pf)
 	if (!IS_ERR_OR_NULL(pf->ptp_clock))
 		return 0;
 
-	strlcpy(pf->ptp_caps.name, i40e_driver_name,
+	strscpy(pf->ptp_caps.name, i40e_driver_name,
 		sizeof(pf->ptp_caps.name) - 1);
 	pf->ptp_caps.owner = THIS_MODULE;
 	pf->ptp_caps.max_adj = 999999999;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index c93567f4d0f7..434603e633c8 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -570,9 +570,9 @@ static void iavf_get_drvinfo(struct net_device *netdev,
 {
 	struct iavf_adapter *adapter = netdev_priv(netdev);
 
-	strlcpy(drvinfo->driver, iavf_driver_name, 32);
-	strlcpy(drvinfo->fw_version, "N/A", 4);
-	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev), 32);
+	strscpy(drvinfo->driver, iavf_driver_name, 32);
+	strscpy(drvinfo->fw_version, "N/A", 4);
+	strscpy(drvinfo->bus_info, pci_name(adapter->pdev), 32);
 	drvinfo->n_priv_flags = IAVF_PRIV_FLAGS_STR_LEN;
 }
 
diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index 28baf203459a..11e2b59c2cb3 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -850,14 +850,14 @@ static void igb_get_drvinfo(struct net_device *netdev,
 {
 	struct igb_adapter *adapter = netdev_priv(netdev);
 
-	strlcpy(drvinfo->driver,  igb_driver_name, sizeof(drvinfo->driver));
+	strscpy(drvinfo->driver, igb_driver_name, sizeof(drvinfo->driver));
 
 	/* EEPROM image version # is reported as firmware version # for
 	 * 82575 controllers
 	 */
-	strlcpy(drvinfo->fw_version, adapter->fw_version,
+	strscpy(drvinfo->fw_version, adapter->fw_version,
 		sizeof(drvinfo->fw_version));
-	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
+	strscpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
 
 	drvinfo->n_priv_flags = IGB_PRIV_FLAGS_STR_LEN;
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 5fc2c381da55..df320ed44558 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -3113,7 +3113,7 @@ static s32 igb_init_i2c(struct igb_adapter *adapter)
 	adapter->i2c_algo.data = adapter;
 	adapter->i2c_adap.algo_data = &adapter->i2c_algo;
 	adapter->i2c_adap.dev.parent = &adapter->pdev->dev;
-	strlcpy(adapter->i2c_adap.name, "igb BB",
+	strscpy(adapter->i2c_adap.name, "igb BB",
 		sizeof(adapter->i2c_adap.name));
 	status = i2c_bit_add_bus(&adapter->i2c_adap);
 	return status;
diff --git a/drivers/net/ethernet/intel/igbvf/ethtool.c b/drivers/net/ethernet/intel/igbvf/ethtool.c
index f4835eb62fee..d4bc892db6ce 100644
--- a/drivers/net/ethernet/intel/igbvf/ethtool.c
+++ b/drivers/net/ethernet/intel/igbvf/ethtool.c
@@ -169,8 +169,8 @@ static void igbvf_get_drvinfo(struct net_device *netdev,
 {
 	struct igbvf_adapter *adapter = netdev_priv(netdev);
 
-	strlcpy(drvinfo->driver,  igbvf_driver_name, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
+	strscpy(drvinfo->driver, igbvf_driver_name, sizeof(drvinfo->driver));
+	strscpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 61d331ce38cd..9605d5b7bad5 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -130,10 +130,10 @@ static void igc_ethtool_get_drvinfo(struct net_device *netdev,
 {
 	struct igc_adapter *adapter = netdev_priv(netdev);
 
-	strlcpy(drvinfo->driver,  igc_driver_name, sizeof(drvinfo->driver));
+	strscpy(drvinfo->driver, igc_driver_name, sizeof(drvinfo->driver));
 
 	/* add fw_version here */
-	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
+	strscpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
 
 	drvinfo->n_priv_flags = IGC_PRIV_FLAGS_STR_LEN;
diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_ethtool.c b/drivers/net/ethernet/intel/ixgb/ixgb_ethtool.c
index 582099a5ad41..9978ba1ef182 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_ethtool.c
@@ -456,9 +456,8 @@ ixgb_get_drvinfo(struct net_device *netdev,
 {
 	struct ixgb_adapter *adapter = netdev_priv(netdev);
 
-	strlcpy(drvinfo->driver,  ixgb_driver_name,
-		sizeof(drvinfo->driver));
-	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
+	strscpy(drvinfo->driver, ixgb_driver_name, sizeof(drvinfo->driver));
+	strscpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index a280aa34ca1d..80568fcc5d6d 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -1107,12 +1107,12 @@ static void ixgbe_get_drvinfo(struct net_device *netdev,
 {
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
 
-	strlcpy(drvinfo->driver, ixgbe_driver_name, sizeof(drvinfo->driver));
+	strscpy(drvinfo->driver, ixgbe_driver_name, sizeof(drvinfo->driver));
 
-	strlcpy(drvinfo->fw_version, adapter->eeprom_id,
+	strscpy(drvinfo->fw_version, adapter->eeprom_id,
 		sizeof(drvinfo->fw_version));
 
-	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
+	strscpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
 
 	drvinfo->n_priv_flags = IXGBE_PRIV_FLAGS_STR_LEN;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
index 0fcd82036d4e..7311bd545acf 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
@@ -1004,7 +1004,7 @@ int ixgbe_fcoe_get_hbainfo(struct net_device *netdev,
 		 ixgbe_driver_name,
 		 UTS_RELEASE);
 	/* Firmware Version */
-	strlcpy(info->firmware_version, adapter->eeprom_id,
+	strscpy(info->firmware_version, adapter->eeprom_id,
 		sizeof(info->firmware_version));
 
 	/* Model */
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 45ae33e15303..17e572c3966a 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -10678,7 +10678,7 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->netdev_ops = &ixgbe_netdev_ops;
 	ixgbe_set_ethtool_ops(netdev);
 	netdev->watchdog_timeo = 5 * HZ;
-	strlcpy(netdev->name, pci_name(pdev), sizeof(netdev->name));
+	strscpy(netdev->name, pci_name(pdev), sizeof(netdev->name));
 
 	/* Setup hw api */
 	hw->mac.ops   = *ii->mac_ops;
@@ -10967,7 +10967,7 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	err = ixgbe_read_pba_string_generic(hw, part_str, sizeof(part_str));
 	if (err)
-		strlcpy(part_str, "Unknown", sizeof(part_str));
+		strscpy(part_str, "Unknown", sizeof(part_str));
 	if (ixgbe_is_sfp(hw) && hw->phy.sfp_type != ixgbe_sfp_type_not_present)
 		e_dev_info("MAC: %d, PHY: %d, SFP+: %d, PBA No: %s\n",
 			   hw->mac.type, hw->phy.type, hw->phy.sfp_type,
diff --git a/drivers/net/ethernet/intel/ixgbevf/ethtool.c b/drivers/net/ethernet/intel/ixgbevf/ethtool.c
index e49fb1cd9a99..c52e1c8a7777 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ethtool.c
@@ -217,8 +217,8 @@ static void ixgbevf_get_drvinfo(struct net_device *netdev,
 {
 	struct ixgbevf_adapter *adapter = netdev_priv(netdev);
 
-	strlcpy(drvinfo->driver, ixgbevf_driver_name, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
+	strscpy(drvinfo->driver, ixgbevf_driver_name, sizeof(drvinfo->driver));
+	strscpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
 
 	drvinfo->n_priv_flags = IXGBEVF_PRIV_FLAGS_STR_LEN;
diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
index e9efe074edc1..4f7712c93243 100644
--- a/drivers/net/ethernet/jme.c
+++ b/drivers/net/ethernet/jme.c
@@ -2347,9 +2347,9 @@ jme_get_drvinfo(struct net_device *netdev,
 {
 	struct jme_adapter *jme = netdev_priv(netdev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(jme->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(jme->pdev), sizeof(info->bus_info));
 }
 
 static int
diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
index bf48f0ded9c7..01b2c1472f6a 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -694,9 +694,9 @@ static void netdev_get_drvinfo(struct net_device *dev,
 {
 	struct korina_private *lp = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, lp->dev->name, sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, lp->dev->name, sizeof(info->bus_info));
 }
 
 static int netdev_get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
index 2d0c52f7106b..9f904787c207 100644
--- a/drivers/net/ethernet/lantiq_etop.c
+++ b/drivers/net/ethernet/lantiq_etop.c
@@ -288,9 +288,9 @@ ltq_etop_hw_init(struct net_device *dev)
 static void
 ltq_etop_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, "Lantiq ETOP", sizeof(info->driver));
-	strlcpy(info->bus_info, "internal", sizeof(info->bus_info));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->driver, "Lantiq ETOP", sizeof(info->driver));
+	strscpy(info->bus_info, "internal", sizeof(info->bus_info));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
 }
 
 static const struct ethtool_ops ltq_etop_ethtool_ops = {
diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 90e6111ce534..845f9581fd87 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -1601,12 +1601,12 @@ mv643xx_eth_set_link_ksettings(struct net_device *dev,
 static void mv643xx_eth_get_drvinfo(struct net_device *dev,
 				    struct ethtool_drvinfo *drvinfo)
 {
-	strlcpy(drvinfo->driver, mv643xx_eth_driver_name,
+	strscpy(drvinfo->driver, mv643xx_eth_driver_name,
 		sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, mv643xx_eth_driver_version,
+	strscpy(drvinfo->version, mv643xx_eth_driver_version,
 		sizeof(drvinfo->version));
-	strlcpy(drvinfo->fw_version, "N/A", sizeof(drvinfo->fw_version));
-	strlcpy(drvinfo->bus_info, "platform", sizeof(drvinfo->bus_info));
+	strscpy(drvinfo->fw_version, "N/A", sizeof(drvinfo->fw_version));
+	strscpy(drvinfo->bus_info, "platform", sizeof(drvinfo->bus_info));
 }
 
 static int
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 4a9041ee1b39..b7269a174845 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4513,11 +4513,10 @@ static int mvneta_ethtool_get_coalesce(struct net_device *dev,
 static void mvneta_ethtool_get_drvinfo(struct net_device *dev,
 				    struct ethtool_drvinfo *drvinfo)
 {
-	strlcpy(drvinfo->driver, MVNETA_DRIVER_NAME,
-		sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, MVNETA_DRIVER_VERSION,
+	strscpy(drvinfo->driver, MVNETA_DRIVER_NAME, sizeof(drvinfo->driver));
+	strscpy(drvinfo->version, MVNETA_DRIVER_VERSION,
 		sizeof(drvinfo->version));
-	strlcpy(drvinfo->bus_info, dev_name(&dev->dev),
+	strscpy(drvinfo->bus_info, dev_name(&dev->dev),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index cea886c5bcb5..0eee4bb69cbb 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5015,11 +5015,10 @@ static int mvpp2_ethtool_get_coalesce(struct net_device *dev,
 static void mvpp2_ethtool_get_drvinfo(struct net_device *dev,
 				      struct ethtool_drvinfo *drvinfo)
 {
-	strlcpy(drvinfo->driver, MVPP2_DRIVER_NAME,
-		sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, MVPP2_DRIVER_VERSION,
+	strscpy(drvinfo->driver, MVPP2_DRIVER_NAME, sizeof(drvinfo->driver));
+	strscpy(drvinfo->version, MVPP2_DRIVER_VERSION,
 		sizeof(drvinfo->version));
-	strlcpy(drvinfo->bus_info, dev_name(&dev->dev),
+	strscpy(drvinfo->bus_info, dev_name(&dev->dev),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index 662fb80dbb9d..0aec7942557e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -71,8 +71,8 @@ static void otx2_get_drvinfo(struct net_device *netdev,
 {
 	struct otx2_nic *pfvf = netdev_priv(netdev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(pfvf->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(pfvf->pdev), sizeof(info->bus_info));
 }
 
 static void otx2_get_qset_strings(struct otx2_nic *pfvf, u8 **data, int qset)
@@ -735,8 +735,8 @@ static void otx2vf_get_drvinfo(struct net_device *netdev,
 {
 	struct otx2_nic *vf = netdev_priv(netdev);
 
-	strlcpy(info->driver, DRV_VF_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(vf->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_VF_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(vf->pdev), sizeof(info->bus_info));
 }
 
 static void otx2vf_get_strings(struct net_device *netdev, u32 sset, u8 *data)
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c b/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
index 93a5e2baf808..4bdaba765c9f 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
@@ -300,8 +300,8 @@ static void prestera_ethtool_get_drvinfo(struct net_device *dev,
 	struct prestera_port *port = netdev_priv(dev);
 	struct prestera_switch *sw = port->sw;
 
-	strlcpy(drvinfo->driver, driver_kind, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->bus_info, dev_name(prestera_dev(sw)),
+	strscpy(drvinfo->driver, driver_kind, sizeof(drvinfo->driver));
+	strscpy(drvinfo->bus_info, dev_name(prestera_dev(sw)),
 		sizeof(drvinfo->bus_info));
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 		 "%d.%d.%d",
diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
index d1e4d42e497d..d02063ef4d75 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -1355,10 +1355,10 @@ static void pxa168_eth_netpoll(struct net_device *dev)
 static void pxa168_get_drvinfo(struct net_device *dev,
 			       struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRIVER_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRIVER_VERSION, sizeof(info->version));
-	strlcpy(info->fw_version, "N/A", sizeof(info->fw_version));
-	strlcpy(info->bus_info, "N/A", sizeof(info->bus_info));
+	strscpy(info->driver, DRIVER_NAME, sizeof(info->driver));
+	strscpy(info->version, DRIVER_VERSION, sizeof(info->version));
+	strscpy(info->fw_version, "N/A", sizeof(info->fw_version));
+	strscpy(info->bus_info, "N/A", sizeof(info->bus_info));
 }
 
 static const struct ethtool_ops pxa168_ethtool_ops = {
diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/marvell/skge.c
index 8a9c0f490bfb..397bc56ae88f 100644
--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -395,9 +395,9 @@ static void skge_get_drvinfo(struct net_device *dev,
 {
 	struct skge_port *skge = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(skge->hw->pdev),
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(skge->hw->pdev),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 25981a7a43b5..1253823135b1 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -3686,9 +3686,9 @@ static void sky2_get_drvinfo(struct net_device *dev,
 {
 	struct sky2_port *sky2 = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(sky2->hw->pdev),
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(sky2->hw->pdev),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 6d2d60675ffd..648514408d52 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2629,8 +2629,10 @@ static void mtk_get_drvinfo(struct net_device *dev,
 {
 	struct mtk_mac *mac = netdev_priv(dev);
 
-	strlcpy(info->driver, mac->hw->dev->driver->name, sizeof(info->driver));
-	strlcpy(info->bus_info, dev_name(mac->hw->dev), sizeof(info->bus_info));
+	strscpy(info->driver, mac->hw->dev->driver->name,
+		sizeof(info->driver));
+	strscpy(info->bus_info, dev_name(mac->hw->dev),
+		sizeof(info->bus_info));
 	info->n_stats = ARRAY_SIZE(mtk_ethtool_stats);
 }
 
diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
index a8641a407c06..b12bdaaf089d 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -1170,7 +1170,7 @@ static const struct net_device_ops mtk_star_netdev_ops = {
 static void mtk_star_get_drvinfo(struct net_device *dev,
 				 struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, MTK_STAR_DRVNAME, sizeof(info->driver));
+	strscpy(info->driver, MTK_STAR_DRVNAME, sizeof(info->driver));
 }
 
 /* TODO Add ethtool stats. */
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
index 23849f2b9c25..cd5487781f7f 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
@@ -88,15 +88,14 @@ mlx4_en_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *drvinfo)
 	struct mlx4_en_priv *priv = netdev_priv(dev);
 	struct mlx4_en_dev *mdev = priv->mdev;
 
-	strlcpy(drvinfo->driver, DRV_NAME, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, DRV_VERSION,
-		sizeof(drvinfo->version));
+	strscpy(drvinfo->driver, DRV_NAME, sizeof(drvinfo->driver));
+	strscpy(drvinfo->version, DRV_VERSION, sizeof(drvinfo->version));
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 		"%d.%d.%d",
 		(u16) (mdev->dev->caps.fw_ver >> 32),
 		(u16) ((mdev->dev->caps.fw_ver >> 16) & 0xffff),
 		(u16) (mdev->dev->caps.fw_ver & 0xffff));
-	strlcpy(drvinfo->bus_info, pci_name(mdev->dev->persist->pdev),
+	strscpy(drvinfo->bus_info, pci_name(mdev->dev->persist->pdev),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
index f6cfec81ccc3..a71602097f61 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -1776,7 +1776,8 @@ static void get_board_id(void *vsd, char *board_id)
 
 	if (be16_to_cpup(vsd + VSD_OFFSET_SIG1) == VSD_SIGNATURE_TOPSPIN &&
 	    be16_to_cpup(vsd + VSD_OFFSET_SIG2) == VSD_SIGNATURE_TOPSPIN) {
-		strlcpy(board_id, vsd + VSD_OFFSET_TS_BOARD_ID, MLX4_BOARD_ID_LEN);
+		strscpy(board_id, vsd + VSD_OFFSET_TS_BOARD_ID,
+			MLX4_BOARD_ID_LEN);
 	} else {
 		/*
 		 * The board ID is a string but the firmware byte
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index d25a56ec6876..30c96da1eeff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -40,14 +40,13 @@ void mlx5e_ethtool_get_drvinfo(struct mlx5e_priv *priv,
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
 
-	strlcpy(drvinfo->driver, DRIVER_NAME, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, DRIVER_VERSION,
-		sizeof(drvinfo->version));
+	strscpy(drvinfo->driver, DRIVER_NAME, sizeof(drvinfo->driver));
+	strscpy(drvinfo->version, DRIVER_VERSION, sizeof(drvinfo->version));
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 		 "%d.%d.%04d (%.16s)",
 		 fw_rev_maj(mdev), fw_rev_min(mdev), fw_rev_sub(mdev),
 		 mdev->board_id);
-	strlcpy(drvinfo->bus_info, dev_name(mdev->device),
+	strscpy(drvinfo->bus_info, dev_name(mdev->device),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 67247c33b9fd..47e4dc552c76 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -62,9 +62,9 @@ static void mlx5e_rep_get_drvinfo(struct net_device *dev,
 	struct mlx5e_priv *priv = netdev_priv(dev);
 	struct mlx5_core_dev *mdev = priv->mdev;
 
-	strlcpy(drvinfo->driver, mlx5e_rep_driver_name,
+	strscpy(drvinfo->driver, mlx5e_rep_driver_name,
 		sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, UTS_RELEASE, sizeof(drvinfo->version));
+	strscpy(drvinfo->version, UTS_RELEASE, sizeof(drvinfo->version));
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 		 "%d.%d.%04d (%.16s)",
 		 fw_rev_maj(mdev), fw_rev_min(mdev),
@@ -77,7 +77,7 @@ static void mlx5e_uplink_rep_get_drvinfo(struct net_device *dev,
 	struct mlx5e_priv *priv = netdev_priv(dev);
 
 	mlx5e_rep_get_drvinfo(dev, drvinfo);
-	strlcpy(drvinfo->bus_info, pci_name(priv->mdev->pdev),
+	strscpy(drvinfo->bus_info, pci_name(priv->mdev->pdev),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
index cac8f085b16d..b93b5341ca53 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
@@ -39,7 +39,7 @@ static void mlx5i_get_drvinfo(struct net_device *dev,
 	struct mlx5e_priv *priv = mlx5i_epriv(dev);
 
 	mlx5e_ethtool_get_drvinfo(priv, drvinfo);
-	strlcpy(drvinfo->driver, DRIVER_NAME "[ib_ipoib]",
+	strscpy(drvinfo->driver, DRIVER_NAME "[ib_ipoib]",
 		sizeof(drvinfo->driver));
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 1a86535c4968..1718206a2cae 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -557,7 +557,7 @@ static void mlxsw_emad_process_string_tlv(const struct sk_buff *skb,
 		return;
 
 	string = mlxsw_emad_string_tlv_string_data(string_tlv);
-	strlcpy(trans->emad_err_string, string,
+	strscpy(trans->emad_err_string, string,
 		MLXSW_EMAD_STRING_TLV_STRING_LEN);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index c010db2c9dba..85819823f468 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -81,14 +81,14 @@ static void mlxsw_m_module_get_drvinfo(struct net_device *dev,
 	struct mlxsw_m_port *mlxsw_m_port = netdev_priv(dev);
 	struct mlxsw_m *mlxsw_m = mlxsw_m_port->mlxsw_m;
 
-	strlcpy(drvinfo->driver, mlxsw_m->bus_info->device_kind,
+	strscpy(drvinfo->driver, mlxsw_m->bus_info->device_kind,
 		sizeof(drvinfo->driver));
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 		 "%d.%d.%d",
 		 mlxsw_m->bus_info->fw_rev.major,
 		 mlxsw_m->bus_info->fw_rev.minor,
 		 mlxsw_m->bus_info->fw_rev.subminor);
-	strlcpy(drvinfo->bus_info, mlxsw_m->bus_info->device_name,
+	strscpy(drvinfo->bus_info, mlxsw_m->bus_info->device_name,
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index 540616469e28..2ebb5598b9ff 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -14,16 +14,16 @@ static void mlxsw_sp_port_get_drvinfo(struct net_device *dev,
 	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 
-	strlcpy(drvinfo->driver, mlxsw_sp->bus_info->device_kind,
+	strscpy(drvinfo->driver, mlxsw_sp->bus_info->device_kind,
 		sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, mlxsw_sp_driver_version,
+	strscpy(drvinfo->version, mlxsw_sp_driver_version,
 		sizeof(drvinfo->version));
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 		 "%d.%d.%d",
 		 mlxsw_sp->bus_info->fw_rev.major,
 		 mlxsw_sp->bus_info->fw_rev.minor,
 		 mlxsw_sp->bus_info->fw_rev.subminor);
-	strlcpy(drvinfo->bus_info, mlxsw_sp->bus_info->device_name,
+	strscpy(drvinfo->bus_info, mlxsw_sp->bus_info->device_name,
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
index 5023d91269f4..e82a83e8b850 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
@@ -401,15 +401,16 @@ static void mlxsw_sx_port_get_drvinfo(struct net_device *dev,
 	struct mlxsw_sx_port *mlxsw_sx_port = netdev_priv(dev);
 	struct mlxsw_sx *mlxsw_sx = mlxsw_sx_port->mlxsw_sx;
 
-	strlcpy(drvinfo->driver, mlxsw_sx_driver_name, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, mlxsw_sx_driver_version,
+	strscpy(drvinfo->driver, mlxsw_sx_driver_name,
+		sizeof(drvinfo->driver));
+	strscpy(drvinfo->version, mlxsw_sx_driver_version,
 		sizeof(drvinfo->version));
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 		 "%d.%d.%d",
 		 mlxsw_sx->bus_info->fw_rev.major,
 		 mlxsw_sx->bus_info->fw_rev.minor,
 		 mlxsw_sx->bus_info->fw_rev.subminor);
-	strlcpy(drvinfo->bus_info, mlxsw_sx->bus_info->device_name,
+	strscpy(drvinfo->bus_info, mlxsw_sx->bus_info->device_name,
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/micrel/ks8851_common.c b/drivers/net/ethernet/micrel/ks8851_common.c
index d65872172229..b314a5061b39 100644
--- a/drivers/net/ethernet/micrel/ks8851_common.c
+++ b/drivers/net/ethernet/micrel/ks8851_common.c
@@ -703,9 +703,9 @@ static const struct net_device_ops ks8851_netdev_ops = {
 static void ks8851_get_drvinfo(struct net_device *dev,
 			       struct ethtool_drvinfo *di)
 {
-	strlcpy(di->driver, "KS8851", sizeof(di->driver));
-	strlcpy(di->version, "1.00", sizeof(di->version));
-	strlcpy(di->bus_info, dev_name(dev->dev.parent), sizeof(di->bus_info));
+	strscpy(di->driver, "KS8851", sizeof(di->driver));
+	strscpy(di->version, "1.00", sizeof(di->version));
+	strscpy(di->bus_info, dev_name(dev->dev.parent), sizeof(di->bus_info));
 }
 
 static u32 ks8851_get_msglevel(struct net_device *dev)
diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index 9ed264ed7070..3960ffe2ce56 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -6075,9 +6075,9 @@ static void netdev_get_drvinfo(struct net_device *dev,
 	struct dev_priv *priv = netdev_priv(dev);
 	struct dev_info *hw_priv = priv->adapter;
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(hw_priv->pdev),
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(hw_priv->pdev),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/microchip/enc28j60.c b/drivers/net/ethernet/microchip/enc28j60.c
index 09cdc2f2e7ff..0cb993e7624c 100644
--- a/drivers/net/ethernet/microchip/enc28j60.c
+++ b/drivers/net/ethernet/microchip/enc28j60.c
@@ -1467,10 +1467,10 @@ static void enc28j60_restart_work_handler(struct work_struct *work)
 static void
 enc28j60_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info,
-		dev_name(dev->dev.parent), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, dev_name(dev->dev.parent),
+		sizeof(info->bus_info));
 }
 
 static int
diff --git a/drivers/net/ethernet/microchip/encx24j600.c b/drivers/net/ethernet/microchip/encx24j600.c
index 2c0dcd7acf3f..a1706f895d6c 100644
--- a/drivers/net/ethernet/microchip/encx24j600.c
+++ b/drivers/net/ethernet/microchip/encx24j600.c
@@ -926,9 +926,9 @@ static void encx24j600_get_regs(struct net_device *dev,
 static void encx24j600_get_drvinfo(struct net_device *dev,
 				   struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, dev_name(dev->dev.parent),
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, dev_name(dev->dev.parent),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/microchip/lan743x_ethtool.c b/drivers/net/ethernet/microchip/lan743x_ethtool.c
index dcde496da7fb..8b5d8045d737 100644
--- a/drivers/net/ethernet/microchip/lan743x_ethtool.c
+++ b/drivers/net/ethernet/microchip/lan743x_ethtool.c
@@ -268,9 +268,9 @@ static void lan743x_ethtool_get_drvinfo(struct net_device *netdev,
 {
 	struct lan743x_adapter *adapter = netdev_priv(netdev);
 
-	strlcpy(info->driver, DRIVER_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info,
-		pci_name(adapter->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, DRIVER_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(adapter->pdev),
+		sizeof(info->bus_info));
 }
 
 static u32 lan743x_ethtool_get_msglevel(struct net_device *netdev)
diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 1634ca6d4a8f..2866cee5fbd4 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -1645,10 +1645,10 @@ myri10ge_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *info)
 {
 	struct myri10ge_priv *mgp = netdev_priv(netdev);
 
-	strlcpy(info->driver, "myri10ge", sizeof(info->driver));
-	strlcpy(info->version, MYRI10GE_VERSION_STR, sizeof(info->version));
-	strlcpy(info->fw_version, mgp->fw_version, sizeof(info->fw_version));
-	strlcpy(info->bus_info, pci_name(mgp->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, "myri10ge", sizeof(info->driver));
+	strscpy(info->version, MYRI10GE_VERSION_STR, sizeof(info->version));
+	strscpy(info->fw_version, mgp->fw_version, sizeof(info->fw_version));
+	strscpy(info->bus_info, pci_name(mgp->pdev), sizeof(info->bus_info));
 }
 
 static int
diff --git a/drivers/net/ethernet/natsemi/natsemi.c b/drivers/net/ethernet/natsemi/natsemi.c
index b81e1487945c..c359ce70cd84 100644
--- a/drivers/net/ethernet/natsemi/natsemi.c
+++ b/drivers/net/ethernet/natsemi/natsemi.c
@@ -2567,9 +2567,9 @@ static void set_rx_mode(struct net_device *dev)
 static void get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
 	struct netdev_private *np = netdev_priv(dev);
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(np->pci_dev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(np->pci_dev), sizeof(info->bus_info));
 }
 
 static int get_regs_len(struct net_device *dev)
diff --git a/drivers/net/ethernet/natsemi/ns83820.c b/drivers/net/ethernet/natsemi/ns83820.c
index 72794d158871..a4e5e3e448dc 100644
--- a/drivers/net/ethernet/natsemi/ns83820.c
+++ b/drivers/net/ethernet/natsemi/ns83820.c
@@ -1351,9 +1351,10 @@ static int ns83820_set_link_ksettings(struct net_device *ndev,
 static void ns83820_get_drvinfo(struct net_device *ndev, struct ethtool_drvinfo *info)
 {
 	struct ns83820 *dev = PRIV(ndev);
-	strlcpy(info->driver, "ns83820", sizeof(info->driver));
-	strlcpy(info->version, VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(dev->pci_dev), sizeof(info->bus_info));
+	strscpy(info->driver, "ns83820", sizeof(info->driver));
+	strscpy(info->version, VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(dev->pci_dev),
+		sizeof(info->bus_info));
 }
 
 static u32 ns83820_get_link(struct net_device *ndev)
diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index d13d92bf7447..a33615e24ab8 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -5337,9 +5337,9 @@ static void s2io_ethtool_gdrvinfo(struct net_device *dev,
 {
 	struct s2io_nic *sp = netdev_priv(dev);
 
-	strlcpy(info->driver, s2io_driver_name, sizeof(info->driver));
-	strlcpy(info->version, s2io_driver_version, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(sp->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, s2io_driver_name, sizeof(info->driver));
+	strscpy(info->version, s2io_driver_version, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(sp->pdev), sizeof(info->bus_info));
 }
 
 /**
diff --git a/drivers/net/ethernet/neterion/vxge/vxge-ethtool.c b/drivers/net/ethernet/neterion/vxge/vxge-ethtool.c
index 4d91026485ae..3f813d02535b 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-ethtool.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-ethtool.c
@@ -108,10 +108,10 @@ static void vxge_ethtool_gdrvinfo(struct net_device *dev,
 				  struct ethtool_drvinfo *info)
 {
 	struct vxgedev *vdev = netdev_priv(dev);
-	strlcpy(info->driver, VXGE_DRIVER_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->fw_version, vdev->fw_version, sizeof(info->fw_version));
-	strlcpy(info->bus_info, pci_name(vdev->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, VXGE_DRIVER_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->fw_version, vdev->fw_version, sizeof(info->fw_version));
+	strscpy(info->bus_info, pci_name(vdev->pdev), sizeof(info->bus_info));
 }
 
 /**
diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index 87892bd992b1..252963ad592d 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -3518,7 +3518,7 @@ static void vxge_device_unregister(struct __vxge_hw_device *hldev)
 	vxge_debug_entryexit(vdev->level_trace,	"%s: %s:%d", vdev->ndev->name,
 			     __func__, __LINE__);
 
-	strlcpy(buf, dev->name, IFNAMSIZ);
+	strscpy(buf, dev->name, IFNAMSIZ);
 
 	flush_work(&vdev->reset_task);
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 9c9ae33d84ce..fbb8e878bf33 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -202,7 +202,7 @@ nfp_get_drvinfo(struct nfp_app *app, struct pci_dev *pdev,
 {
 	char nsp_version[ETHTOOL_FWVERS_LEN] = {};
 
-	strlcpy(drvinfo->driver, pdev->driver->name, sizeof(drvinfo->driver));
+	strscpy(drvinfo->driver, pdev->driver->name, sizeof(drvinfo->driver));
 	nfp_net_get_nspinfo(app, nsp_version);
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 		 "%s %s %s %s", vnic_version, nsp_version,
@@ -218,7 +218,7 @@ nfp_net_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *drvinfo)
 	snprintf(vnic_version, sizeof(vnic_version), "%d.%d.%d.%d",
 		 nn->fw_ver.resv, nn->fw_ver.class,
 		 nn->fw_ver.major, nn->fw_ver.minor);
-	strlcpy(drvinfo->bus_info, pci_name(nn->pdev),
+	strscpy(drvinfo->bus_info, pci_name(nn->pdev),
 		sizeof(drvinfo->bus_info));
 
 	nfp_get_drvinfo(nn->app, nn->pdev, vnic_version, drvinfo);
@@ -229,7 +229,7 @@ nfp_app_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *drvinfo)
 {
 	struct nfp_app *app = nfp_app_from_netdev(netdev);
 
-	strlcpy(drvinfo->bus_info, pci_name(app->pdev),
+	strscpy(drvinfo->bus_info, pci_name(app->pdev),
 		sizeof(drvinfo->bus_info));
 	nfp_get_drvinfo(app, app->pdev, "*", drvinfo);
 }
diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
index a6861df9904f..78fc43cc1d61 100644
--- a/drivers/net/ethernet/ni/nixge.c
+++ b/drivers/net/ethernet/ni/nixge.c
@@ -989,8 +989,8 @@ static const struct net_device_ops nixge_netdev_ops = {
 static void nixge_ethtools_get_drvinfo(struct net_device *ndev,
 				       struct ethtool_drvinfo *ed)
 {
-	strlcpy(ed->driver, "nixge", sizeof(ed->driver));
-	strlcpy(ed->bus_info, "platform", sizeof(ed->bus_info));
+	strscpy(ed->driver, "nixge", sizeof(ed->driver));
+	strscpy(ed->bus_info, "platform", sizeof(ed->bus_info));
 }
 
 static int nixge_ethtools_get_coalesce(struct net_device *ndev,
diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 2fc10a36afa4..a4143266d5f2 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -4296,9 +4296,9 @@ static void nv_do_stats_poll(struct timer_list *t)
 static void nv_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
 	struct fe_priv *np = netdev_priv(dev);
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, FORCEDETH_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(np->pci_dev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, FORCEDETH_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(np->pci_dev), sizeof(info->bus_info));
 }
 
 static void nv_get_wol(struct net_device *dev, struct ethtool_wolinfo *wolinfo)
diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index d3cbb4215f5c..612536106f7e 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -1184,9 +1184,9 @@ static int lpc_eth_open(struct net_device *ndev)
 static void lpc_eth_ethtool_getdrvinfo(struct net_device *ndev,
 	struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, MODNAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, dev_name(ndev->dev.parent),
+	strscpy(info->driver, MODNAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, dev_name(ndev->dev.parent),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c
index a58f14aca10c..388582edeb63 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c
@@ -167,9 +167,10 @@ static void pch_gbe_get_drvinfo(struct net_device *netdev,
 {
 	struct pch_gbe_adapter *adapter = netdev_priv(netdev);
 
-	strlcpy(drvinfo->driver, KBUILD_MODNAME, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, pch_driver_version, sizeof(drvinfo->version));
-	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
+	strscpy(drvinfo->driver, KBUILD_MODNAME, sizeof(drvinfo->driver));
+	strscpy(drvinfo->version, pch_driver_version,
+		sizeof(drvinfo->version));
+	strscpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/packetengines/hamachi.c b/drivers/net/ethernet/packetengines/hamachi.c
index d058a63602a9..85d6cf0b16dd 100644
--- a/drivers/net/ethernet/packetengines/hamachi.c
+++ b/drivers/net/ethernet/packetengines/hamachi.c
@@ -1815,9 +1815,9 @@ static void hamachi_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *
 {
 	struct hamachi_private *np = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(np->pci_dev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(np->pci_dev), sizeof(info->bus_info));
 }
 
 static int hamachi_get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/ethernet/packetengines/yellowfin.c b/drivers/net/ethernet/packetengines/yellowfin.c
index d1dd9bc1bc7f..c4bc1a87839f 100644
--- a/drivers/net/ethernet/packetengines/yellowfin.c
+++ b/drivers/net/ethernet/packetengines/yellowfin.c
@@ -1338,9 +1338,9 @@ static void yellowfin_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo
 {
 	struct yellowfin_private *np = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(np->pci_dev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(np->pci_dev), sizeof(info->bus_info));
 }
 
 static const struct ethtool_ops ethtool_ops = {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 35c72d4a78b3..6051c1df0e06 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -87,10 +87,10 @@ static void ionic_get_drvinfo(struct net_device *netdev,
 	struct ionic_lif *lif = netdev_priv(netdev);
 	struct ionic *ionic = lif->ionic;
 
-	strlcpy(drvinfo->driver, IONIC_DRV_NAME, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->fw_version, ionic->idev.dev_info.fw_version,
+	strscpy(drvinfo->driver, IONIC_DRV_NAME, sizeof(drvinfo->driver));
+	strscpy(drvinfo->fw_version, ionic->idev.dev_info.fw_version,
 		sizeof(drvinfo->fw_version));
-	strlcpy(drvinfo->bus_info, ionic_bus_info(ionic),
+	strscpy(drvinfo->bus_info, ionic_bus_info(ionic),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index a12df3946a07..a476b25b57d7 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2908,7 +2908,7 @@ static void ionic_lif_set_netdev_info(struct ionic_lif *lif)
 		},
 	};
 
-	strlcpy(ctx.cmd.lif_setattr.name, lif->netdev->name,
+	strscpy(ctx.cmd.lif_setattr.name, lif->netdev->name,
 		sizeof(ctx.cmd.lif_setattr.name));
 
 	ionic_adminq_post_wait(lif, &ctx);
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c
index dd22cb056d03..edff0510f5db 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c
@@ -65,9 +65,9 @@ netxen_nic_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *drvinfo)
 	u32 fw_minor = 0;
 	u32 fw_build = 0;
 
-	strlcpy(drvinfo->driver, netxen_nic_driver_name,
+	strscpy(drvinfo->driver, netxen_nic_driver_name,
 		sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, NETXEN_NIC_LINUX_VERSIONID,
+	strscpy(drvinfo->version, NETXEN_NIC_LINUX_VERSIONID,
 		sizeof(drvinfo->version));
 	fw_major = NXRD32(adapter, NETXEN_FW_VERSION_MAJOR);
 	fw_minor = NXRD32(adapter, NETXEN_FW_VERSION_MINOR);
@@ -75,7 +75,7 @@ netxen_nic_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *drvinfo)
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 		"%d.%d.%d", fw_major, fw_minor, fw_build);
 
-	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
+	strscpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.c b/drivers/net/ethernet/qlogic/qed/qed_int.c
index 578935f643b8..92a7d24a7904 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.c
@@ -1099,7 +1099,7 @@ static int qed_int_deassertion(struct qed_hwfn  *p_hwfn,
 						snprintf(bit_name, 30,
 							 p_aeu->bit_name, num);
 					else
-						strlcpy(bit_name,
+						strscpy(bit_name,
 							p_aeu->bit_name, 30);
 
 					/* We now need to pass bitmask in its
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 5bd58c65e163..cf8aac5715d2 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -1372,7 +1372,7 @@ static int qed_slowpath_start(struct qed_dev *cdev,
 				      (params->drv_minor << 16) |
 				      (params->drv_rev << 8) |
 				      (params->drv_eng);
-		strlcpy(drv_version.name, params->name,
+		strscpy(drv_version.name, params->name,
 			MCP_DRV_VER_STR_SIZE - 4);
 		rc = qed_mcp_send_drv_version(hwfn, hwfn->p_main_ptt,
 					      &drv_version);
diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
index bedbb85a179a..514307199052 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
@@ -611,7 +611,7 @@ static void qede_get_drvinfo(struct net_device *ndev,
 	struct qede_dev *edev = netdev_priv(ndev);
 	char mbi[ETHTOOL_FWVERS_LEN];
 
-	strlcpy(info->driver, "qede", sizeof(info->driver));
+	strscpy(info->driver, "qede", sizeof(info->driver));
 
 	snprintf(storm, ETHTOOL_FWVERS_LEN, "%d.%d.%d.%d",
 		 edev->dev_info.common.fw_major,
@@ -648,7 +648,7 @@ static void qede_get_drvinfo(struct net_device *ndev,
 			 "mfw %s", mfw);
 	}
 
-	strlcpy(info->bus_info, pci_name(edev->pdev), sizeof(info->bus_info));
+	strscpy(info->bus_info, pci_name(edev->pdev), sizeof(info->bus_info));
 }
 
 static void qede_get_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 05e3a3b60269..fc185bc2bca6 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1151,7 +1151,7 @@ static int __qede_probe(struct pci_dev *pdev, u32 dp_module, u8 dp_level,
 	sp_params.drv_minor = QEDE_MINOR_VERSION;
 	sp_params.drv_rev = QEDE_REVISION_VERSION;
 	sp_params.drv_eng = QEDE_ENGINEERING_VERSION;
-	strlcpy(sp_params.name, "qede LAN", QED_DRV_VER_STR_SIZE);
+	strscpy(sp_params.name, "qede LAN", QED_DRV_VER_STR_SIZE);
 	rc = qed_ops->common->slowpath_start(cdev, &sp_params);
 	if (rc) {
 		pr_notice("Cannot start slowpath\n");
diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
index 27740c027681..c7d5f9b93922 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -1735,10 +1735,10 @@ static void ql_get_drvinfo(struct net_device *ndev,
 			   struct ethtool_drvinfo *drvinfo)
 {
 	struct ql3_adapter *qdev = netdev_priv(ndev);
-	strlcpy(drvinfo->driver, ql3xxx_driver_name, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, ql3xxx_driver_version,
+	strscpy(drvinfo->driver, ql3xxx_driver_name, sizeof(drvinfo->driver));
+	strscpy(drvinfo->version, ql3xxx_driver_version,
 		sizeof(drvinfo->version));
-	strlcpy(drvinfo->bus_info, pci_name(qdev->pdev),
+	strscpy(drvinfo->bus_info, pci_name(qdev->pdev),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
index d8a3ecaed3fc..93b3df78a20c 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
@@ -277,10 +277,10 @@ qlcnic_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *drvinfo)
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 		"%d.%d.%d", fw_major, fw_minor, fw_build);
 
-	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
+	strscpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
-	strlcpy(drvinfo->driver, qlcnic_driver_name, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, QLCNIC_LINUX_VERSIONID,
+	strscpy(drvinfo->driver, qlcnic_driver_name, sizeof(drvinfo->driver));
+	strscpy(drvinfo->version, QLCNIC_LINUX_VERSIONID,
 		sizeof(drvinfo->version));
 }
 
diff --git a/drivers/net/ethernet/qualcomm/emac/emac-ethtool.c b/drivers/net/ethernet/qualcomm/emac/emac-ethtool.c
index 79e50079ed03..f72e13b83869 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac-ethtool.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac-ethtool.c
@@ -100,7 +100,7 @@ static void emac_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
 
 	case ETH_SS_STATS:
 		for (i = 0; i < EMAC_STATS_LEN; i++) {
-			strlcpy(data, emac_ethtool_stat_strings[i],
+			strscpy(data, emac_ethtool_stat_strings[i],
 				ETH_GSTRING_LEN);
 			data += ETH_GSTRING_LEN;
 		}
diff --git a/drivers/net/ethernet/qualcomm/qca_debug.c b/drivers/net/ethernet/qualcomm/qca_debug.c
index 702aa217a27a..5ece53b86f31 100644
--- a/drivers/net/ethernet/qualcomm/qca_debug.c
+++ b/drivers/net/ethernet/qualcomm/qca_debug.c
@@ -163,10 +163,10 @@ qcaspi_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *p)
 {
 	struct qcaspi *qca = netdev_priv(dev);
 
-	strlcpy(p->driver, QCASPI_DRV_NAME, sizeof(p->driver));
-	strlcpy(p->version, QCASPI_DRV_VERSION, sizeof(p->version));
-	strlcpy(p->fw_version, "QCA7000", sizeof(p->fw_version));
-	strlcpy(p->bus_info, dev_name(&qca->spi_dev->dev),
+	strscpy(p->driver, QCASPI_DRV_NAME, sizeof(p->driver));
+	strscpy(p->version, QCASPI_DRV_VERSION, sizeof(p->version));
+	strscpy(p->fw_version, "QCA7000", sizeof(p->fw_version));
+	strscpy(p->bus_info, dev_name(&qca->spi_dev->dev),
 		sizeof(p->bus_info));
 }
 
diff --git a/drivers/net/ethernet/rdc/r6040.c b/drivers/net/ethernet/rdc/r6040.c
index 7c74318620b1..4af4775eb73a 100644
--- a/drivers/net/ethernet/rdc/r6040.c
+++ b/drivers/net/ethernet/rdc/r6040.c
@@ -932,9 +932,9 @@ static void netdev_get_drvinfo(struct net_device *dev,
 {
 	struct r6040_private *rp = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(rp->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(rp->pdev), sizeof(info->bus_info));
 }
 
 static const struct ethtool_ops netdev_ethtool_ops = {
diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index 4e44313b7651..d8be25cf2af0 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -1382,9 +1382,9 @@ static void cp_get_drvinfo (struct net_device *dev, struct ethtool_drvinfo *info
 {
 	struct cp_private *cp = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(cp->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(cp->pdev), sizeof(info->bus_info));
 }
 
 static void cp_get_ringparam(struct net_device *dev,
diff --git a/drivers/net/ethernet/realtek/8139too.c b/drivers/net/ethernet/realtek/8139too.c
index 1e5a453dea14..abeb15d96829 100644
--- a/drivers/net/ethernet/realtek/8139too.c
+++ b/drivers/net/ethernet/realtek/8139too.c
@@ -2379,9 +2379,9 @@ static int rtl8139_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 static void rtl8139_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
 	struct rtl8139_private *tp = netdev_priv(dev);
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(tp->pci_dev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(tp->pci_dev), sizeof(info->bus_info));
 }
 
 static int rtl8139_get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 85d9c3e30c69..0523d215e5e3 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1447,12 +1447,12 @@ static void rtl8169_get_drvinfo(struct net_device *dev,
 	struct rtl8169_private *tp = netdev_priv(dev);
 	struct rtl_fw *rtl_fw = tp->rtl_fw;
 
-	strlcpy(info->driver, MODULENAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(tp->pci_dev), sizeof(info->bus_info));
+	strscpy(info->driver, MODULENAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(tp->pci_dev), sizeof(info->bus_info));
 	BUILD_BUG_ON(sizeof(info->fw_version) < sizeof(rtl_fw->version));
 	if (rtl_fw)
-		strlcpy(info->fw_version, rtl_fw->version,
-			sizeof(info->fw_version));
+		strscpy(info->fw_version, rtl_fw->version,
+		        sizeof(info->fw_version));
 }
 
 static int rtl8169_get_regs_len(struct net_device *dev)
diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index dd0bc7f0aaee..368980a560fe 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -2264,8 +2264,8 @@ rocker_port_set_link_ksettings(struct net_device *dev,
 static void rocker_port_get_drvinfo(struct net_device *dev,
 				    struct ethtool_drvinfo *drvinfo)
 {
-	strlcpy(drvinfo->driver, rocker_driver_name, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, UTS_RELEASE, sizeof(drvinfo->version));
+	strscpy(drvinfo->driver, rocker_driver_name, sizeof(drvinfo->driver));
+	strscpy(drvinfo->version, UTS_RELEASE, sizeof(drvinfo->version));
 }
 
 static struct rocker_port_stats {
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_ethtool.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_ethtool.c
index 7f8b10c49660..eaf5bf94d197 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_ethtool.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_ethtool.c
@@ -175,8 +175,8 @@ static int sxgbe_set_eee(struct net_device *dev,
 static void sxgbe_getdrvinfo(struct net_device *dev,
 			     struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
 }
 
 static u32 sxgbe_getmsglevel(struct net_device *dev)
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 718308076341..a458c1a3b087 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -782,7 +782,7 @@ static void efx_unregister_netdev(struct efx_nic *efx)
 	BUG_ON(netdev_priv(efx->net_dev) != efx);
 
 	if (efx_dev_registered(efx)) {
-		strlcpy(efx->name, pci_name(efx->pci_dev), sizeof(efx->name));
+		strscpy(efx->name, pci_name(efx->pci_dev), sizeof(efx->name));
 		efx_fini_mcdi_logging(efx);
 		device_remove_file(&efx->pci_dev->dev, &dev_attr_phy_type);
 		unregister_netdev(efx->net_dev);
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index de797e1ac5a9..8a0673399b87 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -995,7 +995,7 @@ int efx_init_struct(struct efx_nic *efx,
 	efx->pci_dev = pci_dev;
 	efx->msg_enable = debug;
 	efx->state = STATE_UNINIT;
-	strlcpy(efx->name, pci_name(pci_dev), sizeof(efx->name));
+	strscpy(efx->name, pci_name(pci_dev), sizeof(efx->name));
 
 	efx->net_dev = net_dev;
 	efx->rx_prefix_size = efx->type->rx_prefix_size;
diff --git a/drivers/net/ethernet/sfc/ethtool_common.c b/drivers/net/ethernet/sfc/ethtool_common.c
index bf1443539a1a..1807e5b285e6 100644
--- a/drivers/net/ethernet/sfc/ethtool_common.c
+++ b/drivers/net/ethernet/sfc/ethtool_common.c
@@ -105,10 +105,11 @@ void efx_ethtool_get_drvinfo(struct net_device *net_dev,
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 
-	strlcpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
+	strscpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
 	efx_mcdi_print_fwver(efx, info->fw_version,
 			     sizeof(info->fw_version));
-	strlcpy(info->bus_info, pci_name(efx->pci_dev), sizeof(info->bus_info));
+	strscpy(info->bus_info, pci_name(efx->pci_dev),
+		sizeof(info->bus_info));
 }
 
 u32 efx_ethtool_get_msglevel(struct net_device *net_dev)
@@ -467,7 +468,7 @@ void efx_ethtool_get_strings(struct net_device *net_dev,
 		strings += (efx->type->describe_stats(efx, strings) *
 			    ETH_GSTRING_LEN);
 		for (i = 0; i < EFX_ETHTOOL_SW_STAT_COUNT; i++)
-			strlcpy(strings + i * ETH_GSTRING_LEN,
+			strscpy(strings + i * ETH_GSTRING_LEN,
 				efx_sw_stat_desc[i].name, ETH_GSTRING_LEN);
 		strings += EFX_ETHTOOL_SW_STAT_COUNT * ETH_GSTRING_LEN;
 		strings += (efx_describe_per_queue_stats(efx, strings) *
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index f8979991970e..5fc24950051f 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -2339,7 +2339,7 @@ static void ef4_unregister_netdev(struct ef4_nic *efx)
 	BUG_ON(netdev_priv(efx->net_dev) != efx);
 
 	if (ef4_dev_registered(efx)) {
-		strlcpy(efx->name, pci_name(efx->pci_dev), sizeof(efx->name));
+		strscpy(efx->name, pci_name(efx->pci_dev), sizeof(efx->name));
 		device_remove_file(&efx->pci_dev->dev, &dev_attr_phy_type);
 		unregister_netdev(efx->net_dev);
 	}
@@ -2650,7 +2650,7 @@ static int ef4_init_struct(struct ef4_nic *efx,
 	efx->pci_dev = pci_dev;
 	efx->msg_enable = debug;
 	efx->state = STATE_UNINIT;
-	strlcpy(efx->name, pci_name(pci_dev), sizeof(efx->name));
+	strscpy(efx->name, pci_name(pci_dev), sizeof(efx->name));
 
 	efx->net_dev = net_dev;
 	efx->rx_prefix_size = efx->type->rx_prefix_size;
diff --git a/drivers/net/ethernet/sfc/falcon/ethtool.c b/drivers/net/ethernet/sfc/falcon/ethtool.c
index a6bae6a234ba..4533b22bc968 100644
--- a/drivers/net/ethernet/sfc/falcon/ethtool.c
+++ b/drivers/net/ethernet/sfc/falcon/ethtool.c
@@ -162,9 +162,10 @@ static void ef4_ethtool_get_drvinfo(struct net_device *net_dev,
 {
 	struct ef4_nic *efx = netdev_priv(net_dev);
 
-	strlcpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
-	strlcpy(info->version, EF4_DRIVER_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(efx->pci_dev), sizeof(info->bus_info));
+	strscpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
+	strscpy(info->version, EF4_DRIVER_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(efx->pci_dev),
+		sizeof(info->bus_info));
 }
 
 static int ef4_ethtool_get_regs_len(struct net_device *net_dev)
@@ -412,7 +413,7 @@ static void ef4_ethtool_get_strings(struct net_device *net_dev,
 		strings += (efx->type->describe_stats(efx, strings) *
 			    ETH_GSTRING_LEN);
 		for (i = 0; i < EF4_ETHTOOL_SW_STAT_COUNT; i++)
-			strlcpy(strings + i * ETH_GSTRING_LEN,
+			strscpy(strings + i * ETH_GSTRING_LEN,
 				ef4_sw_stat_desc[i].name, ETH_GSTRING_LEN);
 		strings += EF4_ETHTOOL_SW_STAT_COUNT * ETH_GSTRING_LEN;
 		strings += (ef4_describe_per_queue_stats(efx, strings) *
diff --git a/drivers/net/ethernet/sfc/falcon/falcon.c b/drivers/net/ethernet/sfc/falcon/falcon.c
index 3324a6219a09..7a1c9337081b 100644
--- a/drivers/net/ethernet/sfc/falcon/falcon.c
+++ b/drivers/net/ethernet/sfc/falcon/falcon.c
@@ -2387,7 +2387,7 @@ static int falcon_probe_nic(struct ef4_nic *efx)
 	board->i2c_data.data = efx;
 	board->i2c_adap.algo_data = &board->i2c_data;
 	board->i2c_adap.dev.parent = &efx->pci_dev->dev;
-	strlcpy(board->i2c_adap.name, "SFC4000 GPIO",
+	strscpy(board->i2c_adap.name, "SFC4000 GPIO",
 		sizeof(board->i2c_adap.name));
 	rc = i2c_bit_add_bus(&board->i2c_adap);
 	if (rc)
diff --git a/drivers/net/ethernet/sfc/falcon/nic.c b/drivers/net/ethernet/sfc/falcon/nic.c
index 156da315ec89..78c851b5a56f 100644
--- a/drivers/net/ethernet/sfc/falcon/nic.c
+++ b/drivers/net/ethernet/sfc/falcon/nic.c
@@ -452,7 +452,7 @@ size_t ef4_nic_describe_stats(const struct ef4_hw_stat_desc *desc, size_t count,
 	for_each_set_bit(index, mask, count) {
 		if (desc[index].name) {
 			if (names) {
-				strlcpy(names, desc[index].name,
+				strscpy(names, desc[index].name,
 					ETH_GSTRING_LEN);
 				names += ETH_GSTRING_LEN;
 			}
diff --git a/drivers/net/ethernet/sfc/mcdi_mon.c b/drivers/net/ethernet/sfc/mcdi_mon.c
index 5954fcfee2b1..f5128db7c7e7 100644
--- a/drivers/net/ethernet/sfc/mcdi_mon.c
+++ b/drivers/net/ethernet/sfc/mcdi_mon.c
@@ -285,7 +285,7 @@ efx_mcdi_mon_add_attr(struct efx_nic *efx, const char *name,
 	struct efx_mcdi_mon *hwmon = efx_mcdi_mon(efx);
 	struct efx_mcdi_mon_attribute *attr = &hwmon->attrs[hwmon->n_attrs];
 
-	strlcpy(attr->name, name, sizeof(attr->name));
+	strscpy(attr->name, name, sizeof(attr->name));
 	attr->index = index;
 	attr->type = type;
 	if (type < ARRAY_SIZE(efx_mcdi_sensor_type))
diff --git a/drivers/net/ethernet/sfc/nic.c b/drivers/net/ethernet/sfc/nic.c
index d1e908846f5d..0d890fe9e0f0 100644
--- a/drivers/net/ethernet/sfc/nic.c
+++ b/drivers/net/ethernet/sfc/nic.c
@@ -464,7 +464,7 @@ size_t efx_nic_describe_stats(const struct efx_hw_stat_desc *desc, size_t count,
 	for_each_set_bit(index, mask, count) {
 		if (desc[index].name) {
 			if (names) {
-				strlcpy(names, desc[index].name,
+				strscpy(names, desc[index].name,
 					ETH_GSTRING_LEN);
 				names += ETH_GSTRING_LEN;
 			}
diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
index 6eef0f45b133..45e99a05cdb7 100644
--- a/drivers/net/ethernet/sgi/ioc3-eth.c
+++ b/drivers/net/ethernet/sgi/ioc3-eth.c
@@ -1154,9 +1154,9 @@ static inline unsigned int ioc3_hash(const unsigned char *addr)
 static void ioc3_get_drvinfo(struct net_device *dev,
 			     struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, IOC3_NAME, sizeof(info->driver));
-	strlcpy(info->version, IOC3_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(to_pci_dev(dev->dev.parent)),
+	strscpy(info->driver, IOC3_NAME, sizeof(info->driver));
+	strscpy(info->version, IOC3_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(to_pci_dev(dev->dev.parent)),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/sis/sis190.c b/drivers/net/ethernet/sis/sis190.c
index 676b193833c0..53140de6beab 100644
--- a/drivers/net/ethernet/sis/sis190.c
+++ b/drivers/net/ethernet/sis/sis190.c
@@ -1765,10 +1765,9 @@ static void sis190_get_drvinfo(struct net_device *dev,
 {
 	struct sis190_private *tp = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(tp->pci_dev),
-		sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(tp->pci_dev), sizeof(info->bus_info));
 }
 
 static int sis190_get_regs_len(struct net_device *dev)
diff --git a/drivers/net/ethernet/sis/sis900.c b/drivers/net/ethernet/sis/sis900.c
index 620c26f71be8..566f8f8ea335 100644
--- a/drivers/net/ethernet/sis/sis900.c
+++ b/drivers/net/ethernet/sis/sis900.c
@@ -2022,9 +2022,9 @@ static void sis900_get_drvinfo(struct net_device *net_dev,
 {
 	struct sis900_private *sis_priv = netdev_priv(net_dev);
 
-	strlcpy(info->driver, SIS900_MODULE_NAME, sizeof(info->driver));
-	strlcpy(info->version, SIS900_DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(sis_priv->pci_dev),
+	strscpy(info->driver, SIS900_MODULE_NAME, sizeof(info->driver));
+	strscpy(info->version, SIS900_DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(sis_priv->pci_dev),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/smsc/epic100.c b/drivers/net/ethernet/smsc/epic100.c
index 51cd7dca91cd..ec34fb45f091 100644
--- a/drivers/net/ethernet/smsc/epic100.c
+++ b/drivers/net/ethernet/smsc/epic100.c
@@ -1390,9 +1390,9 @@ static void netdev_get_drvinfo (struct net_device *dev, struct ethtool_drvinfo *
 {
 	struct epic_private *np = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(np->pci_dev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(np->pci_dev), sizeof(info->bus_info));
 }
 
 static int netdev_get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/ethernet/smsc/smc911x.c b/drivers/net/ethernet/smsc/smc911x.c
index 01069dfaf75c..211f03f79b31 100644
--- a/drivers/net/ethernet/smsc/smc911x.c
+++ b/drivers/net/ethernet/smsc/smc911x.c
@@ -1506,9 +1506,9 @@ smc911x_ethtool_set_link_ksettings(struct net_device *dev,
 static void
 smc911x_ethtool_getdrvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, CARDNAME, sizeof(info->driver));
-	strlcpy(info->version, version, sizeof(info->version));
-	strlcpy(info->bus_info, dev_name(dev->dev.parent),
+	strscpy(info->driver, CARDNAME, sizeof(info->driver));
+	strscpy(info->version, version, sizeof(info->version));
+	strscpy(info->bus_info, dev_name(dev->dev.parent),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/smsc/smc91c92_cs.c b/drivers/net/ethernet/smsc/smc91c92_cs.c
index f2a50eb3c1e0..085eab7bc15c 100644
--- a/drivers/net/ethernet/smsc/smc91c92_cs.c
+++ b/drivers/net/ethernet/smsc/smc91c92_cs.c
@@ -1906,8 +1906,8 @@ static int check_if_running(struct net_device *dev)
 
 static void smc_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
 }
 
 static int smc_get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/ethernet/smsc/smc91x.c b/drivers/net/ethernet/smsc/smc91x.c
index f6b73afd1879..39fd81677389 100644
--- a/drivers/net/ethernet/smsc/smc91x.c
+++ b/drivers/net/ethernet/smsc/smc91x.c
@@ -1587,9 +1587,9 @@ smc_ethtool_set_link_ksettings(struct net_device *dev,
 static void
 smc_ethtool_getdrvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, CARDNAME, sizeof(info->driver));
-	strlcpy(info->version, version, sizeof(info->version));
-	strlcpy(info->bus_info, dev_name(dev->dev.parent),
+	strscpy(info->driver, CARDNAME, sizeof(info->driver));
+	strscpy(info->version, version, sizeof(info->version));
+	strscpy(info->bus_info, dev_name(dev->dev.parent),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/smsc/smsc911x.c b/drivers/net/ethernet/smsc/smsc911x.c
index 823d9a7184fe..b4c54687b1d3 100644
--- a/drivers/net/ethernet/smsc/smsc911x.c
+++ b/drivers/net/ethernet/smsc/smsc911x.c
@@ -1945,9 +1945,9 @@ static int smsc911x_set_mac_address(struct net_device *dev, void *p)
 static void smsc911x_ethtool_getdrvinfo(struct net_device *dev,
 					struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, SMSC_CHIPNAME, sizeof(info->driver));
-	strlcpy(info->version, SMSC_DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, dev_name(dev->dev.parent),
+	strscpy(info->driver, SMSC_CHIPNAME, sizeof(info->driver));
+	strscpy(info->version, SMSC_DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, dev_name(dev->dev.parent),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/smsc/smsc9420.c b/drivers/net/ethernet/smsc/smsc9420.c
index c1dab009415d..00fbc23471f2 100644
--- a/drivers/net/ethernet/smsc/smsc9420.c
+++ b/drivers/net/ethernet/smsc/smsc9420.c
@@ -215,10 +215,10 @@ static void smsc9420_ethtool_get_drvinfo(struct net_device *netdev,
 {
 	struct smsc9420_pdata *pd = netdev_priv(netdev);
 
-	strlcpy(drvinfo->driver, DRV_NAME, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->bus_info, pci_name(pd->pdev),
+	strscpy(drvinfo->driver, DRV_NAME, sizeof(drvinfo->driver));
+	strscpy(drvinfo->bus_info, pci_name(pd->pdev),
 		sizeof(drvinfo->bus_info));
-	strlcpy(drvinfo->version, DRV_VERSION, sizeof(drvinfo->version));
+	strscpy(drvinfo->version, DRV_VERSION, sizeof(drvinfo->version));
 }
 
 static u32 smsc9420_ethtool_get_msglevel(struct net_device *netdev)
diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 1503cc9ec6e2..6df3ade3bb93 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -526,8 +526,8 @@ static int netsec_phy_read(struct mii_bus *bus, int phy_addr, int reg_addr)
 static void netsec_et_get_drvinfo(struct net_device *net_device,
 				  struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, "netsec", sizeof(info->driver));
-	strlcpy(info->bus_info, dev_name(net_device->dev.parent),
+	strscpy(info->driver, "netsec", sizeof(info->driver));
+	strscpy(info->bus_info, dev_name(net_device->dev.parent),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/socionext/sni_ave.c b/drivers/net/ethernet/socionext/sni_ave.c
index 501b9c7aba56..267ff6ccde9a 100644
--- a/drivers/net/ethernet/socionext/sni_ave.c
+++ b/drivers/net/ethernet/socionext/sni_ave.c
@@ -395,8 +395,8 @@ static void ave_ethtool_get_drvinfo(struct net_device *ndev,
 {
 	struct device *dev = ndev->dev.parent;
 
-	strlcpy(info->driver, dev->driver->name, sizeof(info->driver));
-	strlcpy(info->bus_info, dev_name(dev), sizeof(info->bus_info));
+	strscpy(info->driver, dev->driver->name, sizeof(info->driver));
+	strscpy(info->bus_info, dev_name(dev), sizeof(info->bus_info));
 	ave_hw_read_version(ndev, info->fw_version, sizeof(info->fw_version));
 }
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index 9e54f953634b..1a3ec4de4204 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -261,14 +261,15 @@ static void stmmac_ethtool_getdrvinfo(struct net_device *dev,
 	struct stmmac_priv *priv = netdev_priv(dev);
 
 	if (priv->plat->has_gmac || priv->plat->has_gmac4)
-		strlcpy(info->driver, GMAC_ETHTOOL_NAME, sizeof(info->driver));
+		strscpy(info->driver, GMAC_ETHTOOL_NAME, sizeof(info->driver));
 	else if (priv->plat->has_xgmac)
-		strlcpy(info->driver, XGMAC_ETHTOOL_NAME, sizeof(info->driver));
+		strscpy(info->driver, XGMAC_ETHTOOL_NAME,
+			sizeof(info->driver));
 	else
-		strlcpy(info->driver, MAC100_ETHTOOL_NAME,
+		strscpy(info->driver, MAC100_ETHTOOL_NAME,
 			sizeof(info->driver));
 
-	strlcpy(info->version, DRV_MODULE_VERSION, sizeof(info->version));
+	strscpy(info->version, DRV_MODULE_VERSION, sizeof(info->version));
 }
 
 static int stmmac_ethtool_get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index 9ff894ba8d3e..cf198adf7621 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -4497,9 +4497,9 @@ static void cas_set_multicast(struct net_device *dev)
 static void cas_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
 	struct cas *cp = netdev_priv(dev);
-	strlcpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_MODULE_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(cp->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_MODULE_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(cp->pdev), sizeof(info->bus_info));
 }
 
 static int cas_get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/ethernet/sun/ldmvsw.c b/drivers/net/ethernet/sun/ldmvsw.c
index 01ea0d6f8819..cac0efc019b1 100644
--- a/drivers/net/ethernet/sun/ldmvsw.c
+++ b/drivers/net/ethernet/sun/ldmvsw.c
@@ -63,8 +63,8 @@ static struct vio_version vsw_versions[] = {
 static void vsw_get_drvinfo(struct net_device *dev,
 			    struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_MODULE_VERSION, sizeof(info->version));
+	strscpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_MODULE_VERSION, sizeof(info->version));
 }
 
 static u32 vsw_get_msglevel(struct net_device *dev)
diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index 68695d4afacd..059508ec5cfa 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -6782,13 +6782,13 @@ static void niu_get_drvinfo(struct net_device *dev,
 	struct niu *np = netdev_priv(dev);
 	struct niu_vpd *vpd = &np->vpd;
 
-	strlcpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_MODULE_VERSION, sizeof(info->version));
+	strscpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_MODULE_VERSION, sizeof(info->version));
 	snprintf(info->fw_version, sizeof(info->fw_version), "%d.%d",
 		vpd->fcode_major, vpd->fcode_minor);
 	if (np->parent->plat_type != PLAT_TYPE_NIU)
-		strlcpy(info->bus_info, pci_name(np->pdev),
-			sizeof(info->bus_info));
+		strscpy(info->bus_info, pci_name(np->pdev),
+		        sizeof(info->bus_info));
 }
 
 static int niu_get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/ethernet/sun/sunbmac.c b/drivers/net/ethernet/sun/sunbmac.c
index c646575e79d5..75f94ae035ae 100644
--- a/drivers/net/ethernet/sun/sunbmac.c
+++ b/drivers/net/ethernet/sun/sunbmac.c
@@ -1038,8 +1038,8 @@ static void bigmac_set_multicast(struct net_device *dev)
 /* Ethtool support... */
 static void bigmac_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, "sunbmac", sizeof(info->driver));
-	strlcpy(info->version, "2.0", sizeof(info->version));
+	strscpy(info->driver, "sunbmac", sizeof(info->driver));
+	strscpy(info->version, "2.0", sizeof(info->version));
 }
 
 static u32 bigmac_get_link(struct net_device *dev)
diff --git a/drivers/net/ethernet/sun/sungem.c b/drivers/net/ethernet/sun/sungem.c
index 58f142ee78a3..a3e437233619 100644
--- a/drivers/net/ethernet/sun/sungem.c
+++ b/drivers/net/ethernet/sun/sungem.c
@@ -2522,9 +2522,9 @@ static void gem_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info
 {
 	struct gem *gp = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(gp->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(gp->pdev), sizeof(info->bus_info));
 }
 
 static int gem_get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 54b53dbdb33c..deab1c26b9b1 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2510,11 +2510,12 @@ static void hme_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info
 {
 	struct happy_meal *hp = netdev_priv(dev);
 
-	strlcpy(info->driver, "sunhme", sizeof(info->driver));
-	strlcpy(info->version, "2.02", sizeof(info->version));
+	strscpy(info->driver, "sunhme", sizeof(info->driver));
+	strscpy(info->version, "2.02", sizeof(info->version));
 	if (hp->happy_flags & HFLAG_PCI) {
 		struct pci_dev *pdev = hp->happy_dev;
-		strlcpy(info->bus_info, pci_name(pdev), sizeof(info->bus_info));
+		strscpy(info->bus_info, pci_name(pdev),
+			sizeof(info->bus_info));
 	}
 #ifdef CONFIG_SBUS
 	else {
diff --git a/drivers/net/ethernet/sun/sunqe.c b/drivers/net/ethernet/sun/sunqe.c
index 577cd9753d8e..1086fef7f508 100644
--- a/drivers/net/ethernet/sun/sunqe.c
+++ b/drivers/net/ethernet/sun/sunqe.c
@@ -684,8 +684,8 @@ static void qe_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 	struct sunqe *qep = netdev_priv(dev);
 	struct platform_device *op;
 
-	strlcpy(info->driver, "sunqe", sizeof(info->driver));
-	strlcpy(info->version, "3.0", sizeof(info->version));
+	strscpy(info->driver, "sunqe", sizeof(info->driver));
+	strscpy(info->version, "3.0", sizeof(info->version));
 
 	op = qep->op;
 	regs = of_get_property(op->dev.of_node, "reg", NULL);
diff --git a/drivers/net/ethernet/sun/sunvnet.c b/drivers/net/ethernet/sun/sunvnet.c
index 96b883f965f6..25b32f0391cb 100644
--- a/drivers/net/ethernet/sun/sunvnet.c
+++ b/drivers/net/ethernet/sun/sunvnet.c
@@ -60,8 +60,8 @@ static struct vio_version vnet_versions[] = {
 static void vnet_get_drvinfo(struct net_device *dev,
 			     struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_MODULE_VERSION, sizeof(info->version));
+	strscpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_MODULE_VERSION, sizeof(info->version));
 }
 
 static u32 vnet_get_msglevel(struct net_device *dev)
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
index df26cea45904..af303efb0671 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
@@ -54,8 +54,8 @@ static void xlgmac_default_config(struct xlgmac_pdata *pdata)
 	pdata->phy_speed = SPEED_25000;
 	pdata->sysclk_rate = XLGMAC_SYSCLOCK;
 
-	strlcpy(pdata->drv_name, XLGMAC_DRV_NAME, sizeof(pdata->drv_name));
-	strlcpy(pdata->drv_ver, XLGMAC_DRV_VERSION, sizeof(pdata->drv_ver));
+	strscpy(pdata->drv_name, XLGMAC_DRV_NAME, sizeof(pdata->drv_name));
+	strscpy(pdata->drv_ver, XLGMAC_DRV_VERSION, sizeof(pdata->drv_ver));
 }
 
 static void xlgmac_init_all_ops(struct xlgmac_pdata *pdata)
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-ethtool.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-ethtool.c
index bc198eadfcab..68e0e6f4c077 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-ethtool.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-ethtool.c
@@ -102,9 +102,9 @@ static void xlgmac_ethtool_get_drvinfo(struct net_device *netdev,
 	u32 ver = pdata->hw_feat.version;
 	u32 snpsver, devid, userver;
 
-	strlcpy(drvinfo->driver, pdata->drv_name, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, pdata->drv_ver, sizeof(drvinfo->version));
-	strlcpy(drvinfo->bus_info, dev_name(pdata->dev),
+	strscpy(drvinfo->driver, pdata->drv_name, sizeof(drvinfo->driver));
+	strscpy(drvinfo->version, pdata->drv_ver, sizeof(drvinfo->version));
+	strscpy(drvinfo->bus_info, dev_name(pdata->dev),
 		sizeof(drvinfo->bus_info));
 	/* S|SNPSVER: Synopsys-defined Version
 	 * D|DEVID: Indicates the Device family
diff --git a/drivers/net/ethernet/tehuti/tehuti.c b/drivers/net/ethernet/tehuti/tehuti.c
index b8f4f419173f..597daf5f6d3b 100644
--- a/drivers/net/ethernet/tehuti/tehuti.c
+++ b/drivers/net/ethernet/tehuti/tehuti.c
@@ -2146,10 +2146,10 @@ bdx_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *drvinfo)
 {
 	struct bdx_priv *priv = netdev_priv(netdev);
 
-	strlcpy(drvinfo->driver, BDX_DRV_NAME, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, BDX_DRV_VERSION, sizeof(drvinfo->version));
-	strlcpy(drvinfo->fw_version, "N/A", sizeof(drvinfo->fw_version));
-	strlcpy(drvinfo->bus_info, pci_name(priv->pdev),
+	strscpy(drvinfo->driver, BDX_DRV_NAME, sizeof(drvinfo->driver));
+	strscpy(drvinfo->version, BDX_DRV_VERSION, sizeof(drvinfo->version));
+	strscpy(drvinfo->fw_version, "N/A", sizeof(drvinfo->fw_version));
+	strscpy(drvinfo->bus_info, pci_name(priv->pdev),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/ti/am65-cpsw-ethtool.c b/drivers/net/ethernet/ti/am65-cpsw-ethtool.c
index 6e4d4f9e32e0..cff3607fb1c1 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-ethtool.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-ethtool.c
@@ -404,9 +404,9 @@ static void am65_cpsw_get_drvinfo(struct net_device *ndev,
 {
 	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
 
-	strlcpy(info->driver, dev_driver_string(common->dev),
+	strscpy(info->driver, dev_driver_string(common->dev),
 		sizeof(info->driver));
-	strlcpy(info->bus_info, dev_name(common->dev), sizeof(info->bus_info));
+	strscpy(info->bus_info, dev_name(common->dev), sizeof(info->bus_info));
 }
 
 static u32 am65_cpsw_get_msglevel(struct net_device *ndev)
diff --git a/drivers/net/ethernet/ti/cpmac.c b/drivers/net/ethernet/ti/cpmac.c
index c20715107075..fc0ca3c8325c 100644
--- a/drivers/net/ethernet/ti/cpmac.c
+++ b/drivers/net/ethernet/ti/cpmac.c
@@ -847,8 +847,8 @@ static int cpmac_set_ringparam(struct net_device *dev,
 static void cpmac_get_drvinfo(struct net_device *dev,
 			      struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, "cpmac", sizeof(info->driver));
-	strlcpy(info->version, CPMAC_VERSION, sizeof(info->version));
+	strscpy(info->driver, "cpmac", sizeof(info->driver));
+	strscpy(info->version, CPMAC_VERSION, sizeof(info->version));
 	snprintf(info->bus_info, sizeof(info->bus_info), "%s", "cpmac");
 }
 
diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index b0f00b4edd94..8b139837aafb 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1190,9 +1190,9 @@ static void cpsw_get_drvinfo(struct net_device *ndev,
 	struct cpsw_common *cpsw = ndev_to_cpsw(ndev);
 	struct platform_device	*pdev = to_platform_device(cpsw->dev);
 
-	strlcpy(info->driver, "cpsw", sizeof(info->driver));
-	strlcpy(info->version, "1.0", sizeof(info->version));
-	strlcpy(info->bus_info, pdev->name, sizeof(info->bus_info));
+	strscpy(info->driver, "cpsw", sizeof(info->driver));
+	strscpy(info->version, "1.0", sizeof(info->version));
+	strscpy(info->bus_info, pdev->name, sizeof(info->bus_info));
 }
 
 static int cpsw_set_pauseparam(struct net_device *ndev,
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 2f5e0ad23ad7..49f9e1538554 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1161,9 +1161,9 @@ static void cpsw_get_drvinfo(struct net_device *ndev,
 	struct platform_device *pdev;
 
 	pdev = to_platform_device(cpsw->dev);
-	strlcpy(info->driver, "cpsw-switch", sizeof(info->driver));
-	strlcpy(info->version, "2.0", sizeof(info->version));
-	strlcpy(info->bus_info, pdev->name, sizeof(info->bus_info));
+	strscpy(info->driver, "cpsw-switch", sizeof(info->driver));
+	strscpy(info->version, "2.0", sizeof(info->version));
+	strscpy(info->bus_info, pdev->name, sizeof(info->bus_info));
 }
 
 static int cpsw_set_pauseparam(struct net_device *ndev,
diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
index c7031e1960d4..84625b4ee9dd 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -375,8 +375,8 @@ static char *emac_rxhost_errcodes[16] = {
 static void emac_get_drvinfo(struct net_device *ndev,
 			     struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, emac_version_string, sizeof(info->driver));
-	strlcpy(info->version, EMAC_MODULE_VERSION, sizeof(info->version));
+	strscpy(info->driver, emac_version_string, sizeof(info->driver));
+	strscpy(info->version, EMAC_MODULE_VERSION, sizeof(info->version));
 }
 
 /**
diff --git a/drivers/net/ethernet/ti/tlan.c b/drivers/net/ethernet/ti/tlan.c
index 267c080ee084..91bb9038e046 100644
--- a/drivers/net/ethernet/ti/tlan.c
+++ b/drivers/net/ethernet/ti/tlan.c
@@ -763,12 +763,12 @@ static void tlan_get_drvinfo(struct net_device *dev,
 {
 	struct tlan_priv *priv = netdev_priv(dev);
 
-	strlcpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
+	strscpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
 	if (priv->pci_dev)
-		strlcpy(info->bus_info, pci_name(priv->pci_dev),
-			sizeof(info->bus_info));
+		strscpy(info->bus_info, pci_name(priv->pci_dev),
+		        sizeof(info->bus_info));
 	else
-		strlcpy(info->bus_info, "EISA",	sizeof(info->bus_info));
+		strscpy(info->bus_info, "EISA", sizeof(info->bus_info));
 }
 
 static int tlan_get_eeprom_len(struct net_device *dev)
diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
index d9a5722f561b..9bae1a232bfa 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
@@ -1187,8 +1187,8 @@ int gelic_net_open(struct net_device *netdev)
 void gelic_net_get_drvinfo(struct net_device *netdev,
 			   struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
 }
 
 static int gelic_ether_get_link_ksettings(struct net_device *netdev,
diff --git a/drivers/net/ethernet/toshiba/spider_net_ethtool.c b/drivers/net/ethernet/toshiba/spider_net_ethtool.c
index 54f655a68148..bf8aa3f4ab81 100644
--- a/drivers/net/ethernet/toshiba/spider_net_ethtool.c
+++ b/drivers/net/ethernet/toshiba/spider_net_ethtool.c
@@ -63,12 +63,12 @@ spider_net_ethtool_get_drvinfo(struct net_device *netdev,
 	card = netdev_priv(netdev);
 
 	/* clear and fill out info */
-	strlcpy(drvinfo->driver, spider_net_driver_name,
+	strscpy(drvinfo->driver, spider_net_driver_name,
 		sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, VERSION, sizeof(drvinfo->version));
-	strlcpy(drvinfo->fw_version, "no information",
+	strscpy(drvinfo->version, VERSION, sizeof(drvinfo->version));
+	strscpy(drvinfo->fw_version, "no information",
 		sizeof(drvinfo->fw_version));
-	strlcpy(drvinfo->bus_info, pci_name(card->pdev),
+	strscpy(drvinfo->bus_info, pci_name(card->pdev),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/toshiba/tc35815.c b/drivers/net/ethernet/toshiba/tc35815.c
index 7a6e5ff8e5d4..fc793845835d 100644
--- a/drivers/net/ethernet/toshiba/tc35815.c
+++ b/drivers/net/ethernet/toshiba/tc35815.c
@@ -1952,9 +1952,9 @@ static void tc35815_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *
 {
 	struct tc35815_local *lp = netdev_priv(dev);
 
-	strlcpy(info->driver, MODNAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(lp->pci_dev), sizeof(info->bus_info));
+	strscpy(info->driver, MODNAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(lp->pci_dev), sizeof(info->bus_info));
 }
 
 static u32 tc35815_get_msglevel(struct net_device *dev)
diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
index 73ca597ebd1b..ad7ae09634ee 100644
--- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -2284,8 +2284,8 @@ static void netdev_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *i
 {
 	struct device *hwdev = dev->dev.parent;
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, dev_name(hwdev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, dev_name(hwdev), sizeof(info->bus_info));
 }
 
 static int netdev_get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/ethernet/via/via-velocity.c b/drivers/net/ethernet/via/via-velocity.c
index b65767f9e499..d649e084e7f4 100644
--- a/drivers/net/ethernet/via/via-velocity.c
+++ b/drivers/net/ethernet/via/via-velocity.c
@@ -3420,13 +3420,13 @@ static void velocity_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo
 {
 	struct velocity_info *vptr = netdev_priv(dev);
 
-	strlcpy(info->driver, VELOCITY_NAME, sizeof(info->driver));
-	strlcpy(info->version, VELOCITY_VERSION, sizeof(info->version));
+	strscpy(info->driver, VELOCITY_NAME, sizeof(info->driver));
+	strscpy(info->version, VELOCITY_VERSION, sizeof(info->version));
 	if (vptr->pdev)
-		strlcpy(info->bus_info, pci_name(vptr->pdev),
-						sizeof(info->bus_info));
+		strscpy(info->bus_info, pci_name(vptr->pdev),
+		        sizeof(info->bus_info));
 	else
-		strlcpy(info->bus_info, "platform", sizeof(info->bus_info));
+		strscpy(info->bus_info, "platform", sizeof(info->bus_info));
 }
 
 static void velocity_ethtool_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
diff --git a/drivers/net/ethernet/wiznet/w5100.c b/drivers/net/ethernet/wiznet/w5100.c
index c0d181a7f83a..e2e6c7a28b8c 100644
--- a/drivers/net/ethernet/wiznet/w5100.c
+++ b/drivers/net/ethernet/wiznet/w5100.c
@@ -724,9 +724,9 @@ static void w5100_hw_close(struct w5100_priv *priv)
 static void w5100_get_drvinfo(struct net_device *ndev,
 			      struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, dev_name(ndev->dev.parent),
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, dev_name(ndev->dev.parent),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/wiznet/w5300.c b/drivers/net/ethernet/wiznet/w5300.c
index 46aae30c4636..a5cd7992c2e4 100644
--- a/drivers/net/ethernet/wiznet/w5300.c
+++ b/drivers/net/ethernet/wiznet/w5300.c
@@ -282,9 +282,9 @@ static void w5300_hw_close(struct w5300_priv *priv)
 static void w5300_get_drvinfo(struct net_device *ndev,
 			      struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, dev_name(ndev->dev.parent),
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, dev_name(ndev->dev.parent),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 9aafd3ecdaa4..0d4112f46051 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1254,8 +1254,8 @@ static const struct net_device_ops axienet_netdev_ops = {
 static void axienet_ethtools_get_drvinfo(struct net_device *ndev,
 					 struct ethtool_drvinfo *ed)
 {
-	strlcpy(ed->driver, DRIVER_NAME, sizeof(ed->driver));
-	strlcpy(ed->version, DRIVER_VERSION, sizeof(ed->version));
+	strscpy(ed->driver, DRIVER_NAME, sizeof(ed->driver));
+	strscpy(ed->version, DRIVER_VERSION, sizeof(ed->version));
 }
 
 /**
diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 0c26f5bcc523..fe1c5f59b5de 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -1082,7 +1082,7 @@ static bool get_bool(struct platform_device *ofdev, const char *s)
 static void xemaclite_ethtools_get_drvinfo(struct net_device *ndev,
 					   struct ethtool_drvinfo *ed)
 {
-	strlcpy(ed->driver, DRIVER_NAME, sizeof(ed->driver));
+	strscpy(ed->driver, DRIVER_NAME, sizeof(ed->driver));
 }
 
 static const struct ethtool_ops xemaclite_ethtool_ops = {
diff --git a/drivers/net/ethernet/xircom/xirc2ps_cs.c b/drivers/net/ethernet/xircom/xirc2ps_cs.c
index 3e337142b516..6d428b9cc736 100644
--- a/drivers/net/ethernet/xircom/xirc2ps_cs.c
+++ b/drivers/net/ethernet/xircom/xirc2ps_cs.c
@@ -1408,7 +1408,7 @@ do_open(struct net_device *dev)
 static void netdev_get_drvinfo(struct net_device *dev,
 			       struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, "xirc2ps_cs", sizeof(info->driver));
+	strscpy(info->driver, "xirc2ps_cs", sizeof(info->driver));
 	snprintf(info->bus_info, sizeof(info->bus_info), "PCMCIA 0x%lx",
 		 dev->base_addr);
 }
diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index 2e5202923510..4bd61ec6114e 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -978,11 +978,11 @@ static void ixp4xx_get_drvinfo(struct net_device *dev,
 {
 	struct port *port = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
 	snprintf(info->fw_version, sizeof(info->fw_version), "%u:%u:%u:%u",
 		 port->firmware[0], port->firmware[1],
 		 port->firmware[2], port->firmware[3]);
-	strlcpy(info->bus_info, "internal", sizeof(info->bus_info));
+	strscpy(info->bus_info, "internal", sizeof(info->bus_info));
 }
 
 int ixp46x_phc_index = -1;
diff --git a/drivers/net/fjes/fjes_ethtool.c b/drivers/net/fjes/fjes_ethtool.c
index 746736c83873..19c99529566b 100644
--- a/drivers/net/fjes/fjes_ethtool.c
+++ b/drivers/net/fjes/fjes_ethtool.c
@@ -151,11 +151,11 @@ static void fjes_get_drvinfo(struct net_device *netdev,
 
 	plat_dev = adapter->plat_dev;
 
-	strlcpy(drvinfo->driver, fjes_driver_name, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, fjes_driver_version,
+	strscpy(drvinfo->driver, fjes_driver_name, sizeof(drvinfo->driver));
+	strscpy(drvinfo->version, fjes_driver_version,
 		sizeof(drvinfo->version));
 
-	strlcpy(drvinfo->fw_version, "none", sizeof(drvinfo->fw_version));
+	strscpy(drvinfo->fw_version, "none", sizeof(drvinfo->fw_version));
 	snprintf(drvinfo->bus_info, sizeof(drvinfo->bus_info),
 		 "platform:%s", plat_dev->name);
 }
diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 8ae9ce2014a4..18cd96cab40e 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -1159,8 +1159,8 @@ static const struct net_device_ops geneve_netdev_ops = {
 static void geneve_get_drvinfo(struct net_device *dev,
 			       struct ethtool_drvinfo *drvinfo)
 {
-	strlcpy(drvinfo->version, GENEVE_NETDEV_VER, sizeof(drvinfo->version));
-	strlcpy(drvinfo->driver, "geneve", sizeof(drvinfo->driver));
+	strscpy(drvinfo->version, GENEVE_NETDEV_VER, sizeof(drvinfo->version));
+	strscpy(drvinfo->driver, "geneve", sizeof(drvinfo->driver));
 }
 
 static const struct ethtool_ops geneve_ethtool_ops = {
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 261e6e55a907..5a36bd0c7e60 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -954,8 +954,8 @@ int netvsc_recv_callback(struct net_device *net,
 static void netvsc_get_drvinfo(struct net_device *net,
 			       struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
-	strlcpy(info->fw_version, "N/A", sizeof(info->fw_version));
+	strscpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
+	strscpy(info->fw_version, "N/A", sizeof(info->fw_version));
 }
 
 static void netvsc_get_channels(struct net_device *net,
diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index 60b7d93bb834..04704b4a6aae 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -408,8 +408,8 @@ static int ipvlan_ethtool_get_link_ksettings(struct net_device *dev,
 static void ipvlan_ethtool_get_drvinfo(struct net_device *dev,
 				       struct ethtool_drvinfo *drvinfo)
 {
-	strlcpy(drvinfo->driver, IPVLAN_DRV, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, IPV_DRV_VER, sizeof(drvinfo->version));
+	strscpy(drvinfo->driver, IPVLAN_DRV, sizeof(drvinfo->driver));
+	strscpy(drvinfo->version, IPV_DRV_VER, sizeof(drvinfo->version));
 }
 
 static u32 ipvlan_ethtool_get_msglevel(struct net_device *dev)
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index c8d803d3616c..f1f7bf3a78a6 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1034,8 +1034,8 @@ static int macvlan_fdb_del(struct ndmsg *ndm, struct nlattr *tb[],
 static void macvlan_ethtool_get_drvinfo(struct net_device *dev,
 					struct ethtool_drvinfo *drvinfo)
 {
-	strlcpy(drvinfo->driver, "macvlan", sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, "0.1", sizeof(drvinfo->version));
+	strscpy(drvinfo->driver, "macvlan", sizeof(drvinfo->driver));
+	strscpy(drvinfo->version, "0.1", sizeof(drvinfo->version));
 }
 
 static int macvlan_ethtool_get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index fb182bec8f06..0dbb72bd9d09 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -324,8 +324,8 @@ static const struct net_device_ops failover_dev_ops = {
 static void nfo_ethtool_get_drvinfo(struct net_device *dev,
 				    struct ethtool_drvinfo *drvinfo)
 {
-	strlcpy(drvinfo->driver, FAILOVER_NAME, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, FAILOVER_VERSION, sizeof(drvinfo->version));
+	strscpy(drvinfo->driver, FAILOVER_NAME, sizeof(drvinfo->driver));
+	strscpy(drvinfo->version, FAILOVER_VERSION, sizeof(drvinfo->version));
 }
 
 static int nfo_ethtool_get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index 92001f7af380..7ad76e70d32e 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -55,7 +55,7 @@ MODULE_PARM_DESC(oops_only, "Only log oops messages");
 #ifndef	MODULE
 static int __init option_setup(char *opt)
 {
-	strlcpy(config, opt, MAX_PARAM_LENGTH);
+	strscpy(config, opt, MAX_PARAM_LENGTH);
 	return 1;
 }
 __setup("netconsole=", option_setup);
@@ -177,7 +177,7 @@ static struct netconsole_target *alloc_param_target(char *target_config)
 		goto fail;
 
 	nt->np.name = "netconsole";
-	strlcpy(nt->np.dev_name, "eth0", IFNAMSIZ);
+	strscpy(nt->np.dev_name, "eth0", IFNAMSIZ);
 	nt->np.local_port = 6665;
 	nt->np.remote_port = 6666;
 	eth_broadcast_addr(nt->np.remote_mac);
@@ -413,7 +413,7 @@ static ssize_t dev_name_store(struct config_item *item, const char *buf,
 		return -EINVAL;
 	}
 
-	strlcpy(nt->np.dev_name, buf, IFNAMSIZ);
+	strscpy(nt->np.dev_name, buf, IFNAMSIZ);
 
 	/* Get rid of possible trailing newline from echo(1) */
 	len = strnlen(nt->np.dev_name, IFNAMSIZ);
@@ -629,7 +629,7 @@ static struct config_item *make_netconsole_target(struct config_group *group,
 		return ERR_PTR(-ENOMEM);
 
 	nt->np.name = "netconsole";
-	strlcpy(nt->np.dev_name, "eth0", IFNAMSIZ);
+	strscpy(nt->np.dev_name, "eth0", IFNAMSIZ);
 	nt->np.local_port = 6665;
 	nt->np.remote_port = 6666;
 	eth_broadcast_addr(nt->np.remote_mac);
@@ -707,7 +707,7 @@ static int netconsole_netdev_event(struct notifier_block *this,
 		if (nt->np.dev == dev) {
 			switch (event) {
 			case NETDEV_CHANGENAME:
-				strlcpy(nt->np.dev_name, dev->name, IFNAMSIZ);
+				strscpy(nt->np.dev_name, dev->name, IFNAMSIZ);
 				break;
 			case NETDEV_RELEASE:
 			case NETDEV_JOIN:
diff --git a/drivers/net/ntb_netdev.c b/drivers/net/ntb_netdev.c
index a5bab614ff84..6555176c79f1 100644
--- a/drivers/net/ntb_netdev.c
+++ b/drivers/net/ntb_netdev.c
@@ -364,9 +364,9 @@ static void ntb_get_drvinfo(struct net_device *ndev,
 {
 	struct ntb_netdev *dev = netdev_priv(ndev);
 
-	strlcpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
-	strlcpy(info->version, NTB_NETDEV_VER, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(dev->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
+	strscpy(info->version, NTB_NETDEV_VER, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(dev->pdev), sizeof(info->bus_info));
 }
 
 static int ntb_get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 307f0ac1287b..7c8584e18c93 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -644,8 +644,8 @@ static void adin_get_strings(struct phy_device *phydev, u8 *data)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(adin_hw_stats); i++) {
-		strlcpy(&data[i * ETH_GSTRING_LEN],
-			adin_hw_stats[i].string, ETH_GSTRING_LEN);
+		strscpy(&data[i * ETH_GSTRING_LEN], adin_hw_stats[i].string,
+			ETH_GSTRING_LEN);
 	}
 }
 
diff --git a/drivers/net/phy/bcm-phy-lib.c b/drivers/net/phy/bcm-phy-lib.c
index ef6825b30323..e3c1dc8b8d4b 100644
--- a/drivers/net/phy/bcm-phy-lib.c
+++ b/drivers/net/phy/bcm-phy-lib.c
@@ -471,8 +471,8 @@ void bcm_phy_get_strings(struct phy_device *phydev, u8 *data)
 	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(bcm_phy_hw_stats); i++)
-		strlcpy(data + i * ETH_GSTRING_LEN,
-			bcm_phy_hw_stats[i].string, ETH_GSTRING_LEN);
+		strscpy(data + i * ETH_GSTRING_LEN,
+		        bcm_phy_hw_stats[i].string, ETH_GSTRING_LEN);
 }
 EXPORT_SYMBOL_GPL(bcm_phy_get_strings);
 
diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 5aec673a0120..4849ada8a772 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1710,7 +1710,7 @@ static void marvell_get_strings(struct phy_device *phydev, u8 *data)
 	int i;
 
 	for (i = 0; i < count; i++) {
-		strlcpy(data + i * ETH_GSTRING_LEN,
+		strscpy(data + i * ETH_GSTRING_LEN,
 			marvell_hw_stats[i].string, ETH_GSTRING_LEN);
 	}
 }
diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index a7f74b3b97af..77377ec0345b 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1020,8 +1020,8 @@ static void kszphy_get_strings(struct phy_device *phydev, u8 *data)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(kszphy_hw_stats); i++) {
-		strlcpy(data + i * ETH_GSTRING_LEN,
-			kszphy_hw_stats[i].string, ETH_GSTRING_LEN);
+		strscpy(data + i * ETH_GSTRING_LEN, kszphy_hw_stats[i].string,
+			ETH_GSTRING_LEN);
 	}
 }
 
diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 6bc7406a1ce7..33831e6d92ba 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -136,8 +136,8 @@ static void vsc85xx_get_strings(struct phy_device *phydev, u8 *data)
 		return;
 
 	for (i = 0; i < priv->nstats; i++)
-		strlcpy(data + i * ETH_GSTRING_LEN, priv->hw_stats[i].string,
-			ETH_GSTRING_LEN);
+		strscpy(data + i * ETH_GSTRING_LEN, priv->hw_stats[i].string,
+		        ETH_GSTRING_LEN);
 }
 
 static u64 vsc85xx_get_stat(struct phy_device *phydev, int i)
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 5dab6be6fc38..2fe146410cce 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -363,7 +363,7 @@ int phy_register_fixup(const char *bus_id, u32 phy_uid, u32 phy_uid_mask,
 	if (!fixup)
 		return -ENOMEM;
 
-	strlcpy(fixup->bus_id, bus_id, sizeof(fixup->bus_id));
+	strscpy(fixup->bus_id, bus_id, sizeof(fixup->bus_id));
 	fixup->phy_uid = phy_uid;
 	fixup->phy_uid_mask = phy_uid_mask;
 	fixup->run = run;
diff --git a/drivers/net/rionet.c b/drivers/net/rionet.c
index 2056d6ad04b5..54a0eafd5514 100644
--- a/drivers/net/rionet.c
+++ b/drivers/net/rionet.c
@@ -443,10 +443,10 @@ static void rionet_get_drvinfo(struct net_device *ndev,
 {
 	struct rionet_private *rnet = netdev_priv(ndev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->fw_version, "n/a", sizeof(info->fw_version));
-	strlcpy(info->bus_info, rnet->mport->name, sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->fw_version, "n/a", sizeof(info->fw_version));
+	strscpy(info->bus_info, rnet->mport->name, sizeof(info->bus_info));
 }
 
 static u32 rionet_get_msglevel(struct net_device *ndev)
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 07f1f3933927..ee6fa5b986b1 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -2065,8 +2065,8 @@ static const struct net_device_ops team_netdev_ops = {
 static void team_ethtool_get_drvinfo(struct net_device *dev,
 				     struct ethtool_drvinfo *drvinfo)
 {
-	strlcpy(drvinfo->driver, DRV_NAME, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, UTS_RELEASE, sizeof(drvinfo->version));
+	strscpy(drvinfo->driver, DRV_NAME, sizeof(drvinfo->driver));
+	strscpy(drvinfo->version, UTS_RELEASE, sizeof(drvinfo->version));
 }
 
 static int team_ethtool_get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index cd06cae76035..b4999b5ee7f0 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3483,15 +3483,15 @@ static void tun_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info
 {
 	struct tun_struct *tun = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
 
 	switch (tun->flags & TUN_TYPE_MASK) {
 	case IFF_TUN:
-		strlcpy(info->bus_info, "tun", sizeof(info->bus_info));
+		strscpy(info->bus_info, "tun", sizeof(info->bus_info));
 		break;
 	case IFF_TAP:
-		strlcpy(info->bus_info, "tap", sizeof(info->bus_info));
+		strscpy(info->bus_info, "tap", sizeof(info->bus_info));
 		break;
 	}
 }
diff --git a/drivers/net/usb/aqc111.c b/drivers/net/usb/aqc111.c
index 0717c18015c9..456c89ca5fef 100644
--- a/drivers/net/usb/aqc111.c
+++ b/drivers/net/usb/aqc111.c
@@ -201,7 +201,7 @@ static void aqc111_get_drvinfo(struct net_device *net,
 
 	/* Inherit standard device info */
 	usbnet_get_drvinfo(net, info);
-	strlcpy(info->driver, DRIVER_NAME, sizeof(info->driver));
+	strscpy(info->driver, DRIVER_NAME, sizeof(info->driver));
 	snprintf(info->fw_version, sizeof(info->fw_version), "%u.%u.%u",
 		 aqc111_data->fw_ver.major,
 		 aqc111_data->fw_ver.minor,
diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
index 7bc6e8f856fe..83fa7d5db822 100644
--- a/drivers/net/usb/asix_common.c
+++ b/drivers/net/usb/asix_common.c
@@ -734,8 +734,8 @@ void asix_get_drvinfo(struct net_device *net, struct ethtool_drvinfo *info)
 {
 	/* Inherit standard device info */
 	usbnet_get_drvinfo(net, info);
-	strlcpy(info->driver, DRIVER_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRIVER_VERSION, sizeof(info->version));
+	strscpy(info->driver, DRIVER_NAME, sizeof(info->driver));
+	strscpy(info->version, DRIVER_VERSION, sizeof(info->version));
 }
 
 int asix_set_mac_address(struct net_device *net, void *p)
diff --git a/drivers/net/usb/catc.c b/drivers/net/usb/catc.c
index 97ba67042d12..43b9fc1bcdaa 100644
--- a/drivers/net/usb/catc.c
+++ b/drivers/net/usb/catc.c
@@ -672,8 +672,8 @@ static void catc_get_drvinfo(struct net_device *dev,
 			     struct ethtool_drvinfo *info)
 {
 	struct catc *catc = netdev_priv(dev);
-	strlcpy(info->driver, driver_name, sizeof(info->driver));
-	strlcpy(info->version, DRIVER_VERSION, sizeof(info->version));
+	strscpy(info->driver, driver_name, sizeof(info->driver));
+	strscpy(info->version, DRIVER_VERSION, sizeof(info->version));
 	usb_make_path(catc->usbdev, info->bus_info, sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index 32e1335c94ad..14e649569a79 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -880,8 +880,8 @@ static void pegasus_get_drvinfo(struct net_device *dev,
 {
 	pegasus_t *pegasus = netdev_priv(dev);
 
-	strlcpy(info->driver, driver_name, sizeof(info->driver));
-	strlcpy(info->version, DRIVER_VERSION, sizeof(info->version));
+	strscpy(info->driver, driver_name, sizeof(info->driver));
+	strscpy(info->version, DRIVER_VERSION, sizeof(info->version));
 	usb_make_path(pegasus->usb, info->bus_info, sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index b1770489aca5..b7f92147d719 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -5931,12 +5931,12 @@ static void rtl8152_get_drvinfo(struct net_device *netdev,
 {
 	struct r8152 *tp = netdev_priv(netdev);
 
-	strlcpy(info->driver, MODULENAME, sizeof(info->driver));
-	strlcpy(info->version, DRIVER_VERSION, sizeof(info->version));
+	strscpy(info->driver, MODULENAME, sizeof(info->driver));
+	strscpy(info->version, DRIVER_VERSION, sizeof(info->version));
 	usb_make_path(tp->udev, info->bus_info, sizeof(info->bus_info));
 	if (!IS_ERR_OR_NULL(tp->rtl_fw.fw))
-		strlcpy(info->fw_version, tp->rtl_fw.version,
-			sizeof(info->fw_version));
+		strscpy(info->fw_version, tp->rtl_fw.version,
+		        sizeof(info->fw_version));
 }
 
 static
diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
index bf8a60533f3e..0cde1efa66c5 100644
--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -769,8 +769,8 @@ static void rtl8150_get_drvinfo(struct net_device *netdev, struct ethtool_drvinf
 {
 	rtl8150_t *dev = netdev_priv(netdev);
 
-	strlcpy(info->driver, driver_name, sizeof(info->driver));
-	strlcpy(info->version, DRIVER_VERSION, sizeof(info->version));
+	strscpy(info->driver, driver_name, sizeof(info->driver));
+	strscpy(info->version, DRIVER_VERSION, sizeof(info->version));
 	usb_make_path(dev->udev, info->bus_info, sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/usb/sierra_net.c b/drivers/net/usb/sierra_net.c
index 0abd257b634c..7fef838cb9b8 100644
--- a/drivers/net/usb/sierra_net.c
+++ b/drivers/net/usb/sierra_net.c
@@ -612,8 +612,8 @@ static void sierra_net_get_drvinfo(struct net_device *net,
 {
 	/* Inherit standard device info */
 	usbnet_get_drvinfo(net, info);
-	strlcpy(info->driver, driver_name, sizeof(info->driver));
-	strlcpy(info->version, DRIVER_VERSION, sizeof(info->version));
+	strscpy(info->driver, driver_name, sizeof(info->driver));
+	strscpy(info->version, DRIVER_VERSION, sizeof(info->version));
 }
 
 static u32 sierra_net_get_link(struct net_device *net)
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 6062dc27870e..e4ca49d53c26 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1021,8 +1021,8 @@ void usbnet_get_drvinfo (struct net_device *net, struct ethtool_drvinfo *info)
 {
 	struct usbnet *dev = netdev_priv(net);
 
-	strlcpy (info->driver, dev->driver_name, sizeof info->driver);
-	strlcpy (info->fw_version, dev->driver_info->description,
+	strscpy (info->driver, dev->driver_name, sizeof info->driver);
+	strscpy (info->fw_version, dev->driver_info->description,
 		sizeof info->fw_version);
 	usb_make_path (dev->udev, info->bus_info, sizeof info->bus_info);
 }
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 8c737668008a..8867a0d13e40 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -126,8 +126,8 @@ static int veth_get_link_ksettings(struct net_device *dev,
 
 static void veth_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
 }
 
 static void veth_get_strings(struct net_device *dev, u32 stringset, u8 *buf)
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 21b71148c532..b953a2710e4d 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2061,9 +2061,9 @@ static void virtnet_get_drvinfo(struct net_device *dev,
 	struct virtnet_info *vi = netdev_priv(dev);
 	struct virtio_device *vdev = vi->vdev;
 
-	strlcpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
-	strlcpy(info->version, VIRTNET_DRIVER_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, virtio_bus_name(vdev), sizeof(info->bus_info));
+	strscpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
+	strscpy(info->version, VIRTNET_DRIVER_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, virtio_bus_name(vdev), sizeof(info->bus_info));
 
 }
 
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index 7ec8652f2c26..c9426b6f0476 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -205,12 +205,12 @@ vmxnet3_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *drvinfo)
 {
 	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
 
-	strlcpy(drvinfo->driver, vmxnet3_driver_name, sizeof(drvinfo->driver));
+	strscpy(drvinfo->driver, vmxnet3_driver_name, sizeof(drvinfo->driver));
 
-	strlcpy(drvinfo->version, VMXNET3_DRIVER_VERSION_REPORT,
+	strscpy(drvinfo->version, VMXNET3_DRIVER_VERSION_REPORT,
 		sizeof(drvinfo->version));
 
-	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
+	strscpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index f2793ffde191..cd5396131d54 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1451,8 +1451,8 @@ static const struct l3mdev_ops vrf_l3mdev_ops = {
 static void vrf_get_drvinfo(struct net_device *dev,
 			    struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
 }
 
 static const struct ethtool_ops vrf_ethtool_ops = {
diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 977f77e2c2ce..876760426c60 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -3427,8 +3427,8 @@ static int vxlan_validate(struct nlattr *tb[], struct nlattr *data[],
 static void vxlan_get_drvinfo(struct net_device *netdev,
 			      struct ethtool_drvinfo *drvinfo)
 {
-	strlcpy(drvinfo->version, VXLAN_VERSION, sizeof(drvinfo->version));
-	strlcpy(drvinfo->driver, "vxlan", sizeof(drvinfo->driver));
+	strscpy(drvinfo->version, VXLAN_VERSION, sizeof(drvinfo->version));
+	strscpy(drvinfo->driver, "vxlan", sizeof(drvinfo->driver));
 }
 
 static int vxlan_get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/wimax/i2400m/netdev.c b/drivers/net/wimax/i2400m/netdev.c
index a7fcbceb6e6b..459cc4806c6d 100644
--- a/drivers/net/wimax/i2400m/netdev.c
+++ b/drivers/net/wimax/i2400m/netdev.c
@@ -561,12 +561,12 @@ static void i2400m_get_drvinfo(struct net_device *net_dev,
 {
 	struct i2400m *i2400m = net_dev_to_i2400m(net_dev);
 
-	strlcpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
-	strlcpy(info->fw_version, i2400m->fw_name ? : "",
+	strscpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
+	strscpy(info->fw_version, i2400m->fw_name ? : "",
 		sizeof(info->fw_version));
 	if (net_dev->dev.parent)
-		strlcpy(info->bus_info, dev_name(net_dev->dev.parent),
-			sizeof(info->bus_info));
+		strscpy(info->bus_info, dev_name(net_dev->dev.parent),
+		        sizeof(info->bus_info));
 }
 
 static const struct ethtool_ops i2400m_ethtool_ops = {
diff --git a/drivers/net/wimax/i2400m/usb.c b/drivers/net/wimax/i2400m/usb.c
index b684e97ac976..8860bef2dedb 100644
--- a/drivers/net/wimax/i2400m/usb.c
+++ b/drivers/net/wimax/i2400m/usb.c
@@ -332,8 +332,8 @@ static void i2400mu_get_drvinfo(struct net_device *net_dev,
 	struct i2400mu *i2400mu = container_of(i2400m, struct i2400mu, i2400m);
 	struct usb_device *udev = i2400mu->usb_dev;
 
-	strlcpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
-	strlcpy(info->fw_version, i2400m->fw_name ? : "",
+	strscpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
+	strscpy(info->fw_version, i2400m->fw_name ? : "",
 		sizeof(info->fw_version));
 	usb_make_path(udev, info->bus_info, sizeof(info->bus_info));
 }
diff --git a/drivers/net/wireless/ath/ath10k/coredump.c b/drivers/net/wireless/ath/ath10k/coredump.c
index 7eb72290a925..81980a8daa19 100644
--- a/drivers/net/wireless/ath/ath10k/coredump.c
+++ b/drivers/net/wireless/ath/ath10k/coredump.c
@@ -1517,7 +1517,7 @@ static struct ath10k_dump_file_data *ath10k_coredump_build(struct ath10k *ar)
 	mutex_lock(&ar->dump_mutex);
 
 	dump_data = (struct ath10k_dump_file_data *)(buf);
-	strlcpy(dump_data->df_magic, "ATH10K-FW-DUMP",
+	strscpy(dump_data->df_magic, "ATH10K-FW-DUMP",
 		sizeof(dump_data->df_magic));
 	dump_data->len = cpu_to_le32(len);
 
@@ -1538,11 +1538,11 @@ static struct ath10k_dump_file_data *ath10k_coredump_build(struct ath10k *ar)
 	dump_data->vht_cap_info = cpu_to_le32(ar->vht_cap_info);
 	dump_data->num_rf_chains = cpu_to_le32(ar->num_rf_chains);
 
-	strlcpy(dump_data->fw_ver, ar->hw->wiphy->fw_version,
+	strscpy(dump_data->fw_ver, ar->hw->wiphy->fw_version,
 		sizeof(dump_data->fw_ver));
 
 	dump_data->kernel_ver_code = 0;
-	strlcpy(dump_data->kernel_ver, init_utsname()->release,
+	strscpy(dump_data->kernel_ver, init_utsname()->release,
 		sizeof(dump_data->kernel_ver));
 
 	dump_data->tv_sec = cpu_to_le64(crash_data->timestamp.tv_sec);
diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
index ae6b1f402adf..51e88171d951 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.c
+++ b/drivers/net/wireless/ath/ath10k/qmi.c
@@ -590,12 +590,13 @@ static int ath10k_qmi_cap_send_sync_msg(struct ath10k_qmi *qmi)
 
 	if (resp->fw_version_info_valid) {
 		qmi->fw_version = resp->fw_version_info.fw_version;
-		strlcpy(qmi->fw_build_timestamp, resp->fw_version_info.fw_build_timestamp,
+		strscpy(qmi->fw_build_timestamp,
+			resp->fw_version_info.fw_build_timestamp,
 			sizeof(qmi->fw_build_timestamp));
 	}
 
 	if (resp->fw_build_id_valid)
-		strlcpy(qmi->fw_build_id, resp->fw_build_id,
+		strscpy(qmi->fw_build_id, resp->fw_build_id,
 			MAX_BUILD_ID_LEN + 1);
 
 	if (!test_bit(ATH10K_SNOC_FLAG_REGISTERED, &ar_snoc->flags)) {
diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
index c2b165158225..199e12f4394d 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -1840,13 +1840,13 @@ static int ath11k_qmi_request_target_cap(struct ath11k_base *ab)
 
 	if (resp.fw_version_info_valid) {
 		ab->qmi.target.fw_version = resp.fw_version_info.fw_version;
-		strlcpy(ab->qmi.target.fw_build_timestamp,
+		strscpy(ab->qmi.target.fw_build_timestamp,
 			resp.fw_version_info.fw_build_timestamp,
 			sizeof(ab->qmi.target.fw_build_timestamp));
 	}
 
 	if (resp.fw_build_id_valid)
-		strlcpy(ab->qmi.target.fw_build_id, resp.fw_build_id,
+		strscpy(ab->qmi.target.fw_build_id, resp.fw_build_id,
 			sizeof(ab->qmi.target.fw_build_id));
 
 	ath11k_info(ab, "chip_id 0x%x chip_family 0x%x board_id 0x%x soc_id 0x%x\n",
@@ -2252,7 +2252,7 @@ static int ath11k_qmi_wlanfw_wlan_cfg_send(struct ath11k_base *ab)
 	memset(&resp, 0, sizeof(resp));
 
 	req->host_version_valid = 1;
-	strlcpy(req->host_version, ATH11K_HOST_VERSION_STRING,
+	strscpy(req->host_version, ATH11K_HOST_VERSION_STRING,
 		sizeof(req->host_version));
 
 	req->tgt_cfg_valid = 1;
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 39bf19686175..c9e701d4a902 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1014,8 +1014,8 @@ static int ath6kl_fetch_fw_apin(struct ath6kl *ar, const char *name)
 
 		switch (ie_id) {
 		case ATH6KL_FW_IE_FW_VERSION:
-			strlcpy(ar->wiphy->fw_version, data,
-				min(sizeof(ar->wiphy->fw_version), ie_len+1));
+			strscpy(ar->wiphy->fw_version, data,
+				min(sizeof(ar->wiphy->fw_version), ie_len + 1));
 
 			ath6kl_dbg(ATH6KL_DBG_BOOT,
 				   "found fw version %s\n",
diff --git a/drivers/net/wireless/ath/carl9170/fw.c b/drivers/net/wireless/ath/carl9170/fw.c
index 1ab09e1c9ec5..4c1aecd1163c 100644
--- a/drivers/net/wireless/ath/carl9170/fw.c
+++ b/drivers/net/wireless/ath/carl9170/fw.c
@@ -105,7 +105,7 @@ static void carl9170_fw_info(struct ar9170 *ar)
 			 CARL9170FW_GET_MONTH(fw_date),
 			 CARL9170FW_GET_DAY(fw_date));
 
-		strlcpy(ar->hw->wiphy->fw_version, motd_desc->release,
+		strscpy(ar->hw->wiphy->fw_version, motd_desc->release,
 			sizeof(ar->hw->wiphy->fw_version));
 	}
 }
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 3ba5b2550a8c..bb532c6866be 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -1305,7 +1305,7 @@ void wil_get_board_file(struct wil6210_priv *wil, char *buf, size_t len)
 			board_file = WIL_BOARD_FILE_NAME;
 	}
 
-	strlcpy(buf, board_file, len);
+	strscpy(buf, board_file, len);
 }
 
 static int wil_get_bl_info(struct wil6210_priv *wil)
diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index 07b4a252a23c..41fd4e548a51 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -445,7 +445,7 @@ int wil_if_add(struct wil6210_priv *wil)
 
 	wil_dbg_misc(wil, "entered");
 
-	strlcpy(wiphy->fw_version, wil->fw_version, sizeof(wiphy->fw_version));
+	strscpy(wiphy->fw_version, wil->fw_version, sizeof(wiphy->fw_version));
 
 	rc = wiphy_register(wiphy);
 	if (rc < 0) {
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 421aebbb49e5..a2c0f14bf74e 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -780,7 +780,7 @@ static void wmi_evt_ready(struct wil6210_vif *vif, int id, void *d, int len)
 		return; /* FW load will fail after timeout */
 	}
 	/* ignore MAC address, we already have it from the boot loader */
-	strlcpy(wiphy->fw_version, wil->fw_version, sizeof(wiphy->fw_version));
+	strscpy(wiphy->fw_version, wil->fw_version, sizeof(wiphy->fw_version));
 
 	if (len > offsetof(struct wmi_ready_event, rfc_read_calib_result)) {
 		wil_dbg_wmi(wil, "rfc calibration result %d\n",
diff --git a/drivers/net/wireless/atmel/atmel.c b/drivers/net/wireless/atmel/atmel.c
index 707fe66727f8..1240d61f74f4 100644
--- a/drivers/net/wireless/atmel/atmel.c
+++ b/drivers/net/wireless/atmel/atmel.c
@@ -1519,7 +1519,8 @@ struct net_device *init_atmel_card(unsigned short irq, unsigned long port,
 	priv->firmware = NULL;
 	priv->firmware_type = fw_type;
 	if (firmware) /* module parameter */
-		strlcpy(priv->firmware_id, firmware, sizeof(priv->firmware_id));
+		strscpy(priv->firmware_id, firmware,
+			sizeof(priv->firmware_id));
 	priv->bus_type = card_present ? BUS_TYPE_PCCARD : BUS_TYPE_PCI;
 	priv->station_state = STATION_STATE_DOWN;
 	priv->do_rx_crc = 0;
diff --git a/drivers/net/wireless/broadcom/b43/leds.c b/drivers/net/wireless/broadcom/b43/leds.c
index 982a772a9d87..bfe1be345844 100644
--- a/drivers/net/wireless/broadcom/b43/leds.c
+++ b/drivers/net/wireless/broadcom/b43/leds.c
@@ -118,7 +118,7 @@ static int b43_register_led(struct b43_wldev *dev, struct b43_led *led,
 	led->wl = dev->wl;
 	led->index = led_index;
 	led->activelow = activelow;
-	strlcpy(led->name, name, sizeof(led->name));
+	strscpy(led->name, name, sizeof(led->name));
 	atomic_set(&led->state, 0);
 
 	led->led_dev.name = led->name;
diff --git a/drivers/net/wireless/broadcom/b43legacy/leds.c b/drivers/net/wireless/broadcom/b43legacy/leds.c
index 38b5be3a84e2..79e6fd205bfb 100644
--- a/drivers/net/wireless/broadcom/b43legacy/leds.c
+++ b/drivers/net/wireless/broadcom/b43legacy/leds.c
@@ -88,7 +88,7 @@ static int b43legacy_register_led(struct b43legacy_wldev *dev,
 	led->dev = dev;
 	led->index = led_index;
 	led->activelow = activelow;
-	strlcpy(led->name, name, sizeof(led->name));
+	strscpy(led->name, name, sizeof(led->name));
 
 	led->led_dev.name = led->name;
 	led->led_dev.default_trigger = default_trigger;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index e3758bd86acf..03a33787bbf2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -219,7 +219,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 				     &revinfo, sizeof(revinfo));
 	if (err < 0) {
 		bphy_err(drvr, "retrieving revision info failed, %d\n", err);
-		strlcpy(ri->chipname, "UNKNOWN", sizeof(ri->chipname));
+		strscpy(ri->chipname, "UNKNOWN", sizeof(ri->chipname));
 	} else {
 		ri->vendorid = le32_to_cpu(revinfo.vendorid);
 		ri->deviceid = le32_to_cpu(revinfo.deviceid);
@@ -272,7 +272,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 
 	/* locate firmware version number for ethtool */
 	ptr = strrchr(buf, ' ') + 1;
-	strlcpy(ifp->drvr->fwver, ptr, sizeof(ifp->drvr->fwver));
+	strscpy(ifp->drvr->fwver, ptr, sizeof(ifp->drvr->fwver));
 
 	/* Query for 'clmver' to get CLM version info from firmware */
 	memset(buf, 0, sizeof(buf));
@@ -382,11 +382,11 @@ static void brcmf_mp_attach(void)
 	 * if not set then if available use the platform data version. To make
 	 * sure it gets initialized at all, always copy the module param version
 	 */
-	strlcpy(brcmf_mp_global.firmware_path, brcmf_firmware_path,
+	strscpy(brcmf_mp_global.firmware_path, brcmf_firmware_path,
 		BRCMF_FW_ALTPATH_LEN);
 	if ((brcmfmac_pdata) && (brcmfmac_pdata->fw_alternative_path) &&
 	    (brcmf_mp_global.firmware_path[0] == '\0')) {
-		strlcpy(brcmf_mp_global.firmware_path,
+		strscpy(brcmf_mp_global.firmware_path,
 			brcmfmac_pdata->fw_alternative_path,
 			BRCMF_FW_ALTPATH_LEN);
 	}
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 3dd28f5fef19..e77154f1bf95 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -567,10 +567,10 @@ static void brcmf_ethtool_get_drvinfo(struct net_device *ndev,
 
 	if (drvr->revinfo.result == 0)
 		brcmu_dotrev_str(drvr->revinfo.driverrev, drev);
-	strlcpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
-	strlcpy(info->version, drev, sizeof(info->version));
-	strlcpy(info->fw_version, drvr->fwver, sizeof(info->fw_version));
-	strlcpy(info->bus_info, dev_name(drvr->bus_if->dev),
+	strscpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
+	strscpy(info->version, drev, sizeof(info->version));
+	strscpy(info->fw_version, drvr->fwver, sizeof(info->fw_version));
+	strscpy(info->bus_info, dev_name(drvr->bus_if->dev),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index d821a4758f8c..f9af2512310c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -606,7 +606,7 @@ static int brcmf_fw_request_firmware(const struct firmware **fw,
 	if (cur->type == BRCMF_FW_TYPE_NVRAM && fwctx->req->board_type) {
 		char alt_path[BRCMF_FW_NAME_LEN];
 
-		strlcpy(alt_path, cur->path, BRCMF_FW_NAME_LEN);
+		strscpy(alt_path, cur->path, BRCMF_FW_NAME_LEN);
 		/* strip .txt at the end */
 		alt_path[strlen(alt_path) - 4] = 0;
 		strlcat(alt_path, ".", BRCMF_FW_NAME_LEN);
@@ -733,8 +733,7 @@ brcmf_fw_alloc_request(u32 chip, u32 chiprev,
 		fwnames[j].path[0] = '\0';
 		/* check if firmware path is provided by module parameter */
 		if (brcmf_mp_global.firmware_path[0] != '\0') {
-			strlcpy(fwnames[j].path, mp_path,
-				BRCMF_FW_NAME_LEN);
+			strscpy(fwnames->path, mp_path, BRCMF_FW_NAME_LEN);
 
 			if (end != '/') {
 				strlcat(fwnames[j].path, "/",
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
index 437e83ea8902..4ff5432a36cb 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
@@ -688,7 +688,7 @@ static void brcmf_fws_macdesc_set_name(struct brcmf_fws_info *fws,
 				       struct brcmf_fws_mac_descriptor *desc)
 {
 	if (desc == &fws->desc.other)
-		strlcpy(desc->name, "MAC-OTHER", sizeof(desc->name));
+		strscpy(desc->name, "MAC-OTHER", sizeof(desc->name));
 	else if (desc->mac_handle)
 		scnprintf(desc->name, sizeof(desc->name), "MAC-%d:%d",
 			  desc->mac_handle, desc->interface_id);
diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
index 23fbddd0c1f8..24a0cea9d64e 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -5907,8 +5907,8 @@ static void ipw_ethtool_get_drvinfo(struct net_device *dev,
 	struct ipw2100_priv *priv = libipw_priv(dev);
 	char fw_ver[64], ucode_ver[64];
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
 
 	ipw2100_get_fwversion(priv, fw_ver, sizeof(fw_ver));
 	ipw2100_get_ucodeversion(priv, ucode_ver, sizeof(ucode_ver));
@@ -5916,7 +5916,7 @@ static void ipw_ethtool_get_drvinfo(struct net_device *dev,
 	snprintf(info->fw_version, sizeof(info->fw_version), "%s:%d:%s",
 		 fw_ver, priv->eeprom_version, ucode_ver);
 
-	strlcpy(info->bus_info, pci_name(priv->pci_dev),
+	strscpy(info->bus_info, pci_name(priv->pci_dev),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index ada6ce32c1f1..7b9debfa41b8 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -10427,8 +10427,8 @@ static void ipw_ethtool_get_drvinfo(struct net_device *dev,
 	char date[32];
 	u32 len;
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
 
 	len = sizeof(vers);
 	ipw_get_ordinal(p, IPW_ORD_STAT_FW_VERSION, vers, &len);
@@ -10437,8 +10437,7 @@ static void ipw_ethtool_get_drvinfo(struct net_device *dev,
 
 	snprintf(info->fw_version, sizeof(info->fw_version), "%s (%s)",
 		 vers, date);
-	strlcpy(info->bus_info, pci_name(p->pci_dev),
-		sizeof(info->bus_info));
+	strscpy(info->bus_info, pci_name(p->pci_dev), sizeof(info->bus_info));
 }
 
 static u32 ipw_ethtool_get_link(struct net_device *dev)
diff --git a/drivers/net/wireless/intel/iwlegacy/3945-mac.c b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
index 4ca8212d4fa4..8ba37aaaff5e 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
@@ -3256,7 +3256,7 @@ il3945_store_measurement(struct device *d, struct device_attribute *attr,
 
 	if (count) {
 		char *p = buffer;
-		strlcpy(buffer, buf, sizeof(buffer));
+		strscpy(buffer, buf, sizeof(buffer));
 		channel = simple_strtoul(p, NULL, 0);
 		if (channel)
 			params.channel = channel;
diff --git a/drivers/net/wireless/intersil/hostap/hostap_ioctl.c b/drivers/net/wireless/intersil/hostap/hostap_ioctl.c
index 514c7b01dbf6..293a081b0dc7 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_ioctl.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_ioctl.c
@@ -3859,7 +3859,7 @@ static void prism2_get_drvinfo(struct net_device *dev,
 	iface = netdev_priv(dev);
 	local = iface->local;
 
-	strlcpy(info->driver, "hostap", sizeof(info->driver));
+	strscpy(info->driver, "hostap", sizeof(info->driver));
 	snprintf(info->fw_version, sizeof(info->fw_version),
 		 "%d.%d.%d", (local->sta_fw_ver >> 16) & 0xff,
 		 (local->sta_fw_ver >> 8) & 0xff,
diff --git a/drivers/net/wireless/intersil/prism54/islpci_dev.c b/drivers/net/wireless/intersil/prism54/islpci_dev.c
index 8eb6d5e4bd57..7cda93a2f656 100644
--- a/drivers/net/wireless/intersil/prism54/islpci_dev.c
+++ b/drivers/net/wireless/intersil/prism54/islpci_dev.c
@@ -780,8 +780,8 @@ islpci_set_multicast_list(struct net_device *dev)
 static void islpci_ethtool_get_drvinfo(struct net_device *dev,
                                        struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
 }
 
 static const struct ethtool_ops islpci_ethtool_ops = {
diff --git a/drivers/net/wireless/marvell/libertas/ethtool.c b/drivers/net/wireless/marvell/libertas/ethtool.c
index 1bb8746a0b23..d580e6a95d7a 100644
--- a/drivers/net/wireless/marvell/libertas/ethtool.c
+++ b/drivers/net/wireless/marvell/libertas/ethtool.c
@@ -20,8 +20,8 @@ static void lbs_ethtool_get_drvinfo(struct net_device *dev,
 		priv->fwrelease >> 16 & 0xff,
 		priv->fwrelease >>  8 & 0xff,
 		priv->fwrelease       & 0xff);
-	strlcpy(info->driver, "libertas", sizeof(info->driver));
-	strlcpy(info->version, lbs_driver_version, sizeof(info->version));
+	strscpy(info->driver, "libertas", sizeof(info->driver));
+	strscpy(info->version, lbs_driver_version, sizeof(info->version));
 }
 
 /*
diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 9ba8a8f64976..c496a5f2cd24 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -698,8 +698,7 @@ static int mwifiex_init_hw_fw(struct mwifiex_adapter *adapter,
 	 * manufacturing mode is enabled
 	 */
 	if (mfg_mode) {
-		if (strlcpy(adapter->fw_name, MFG_FIRMWARE,
-			    sizeof(adapter->fw_name)) >=
+		if (strscpy(adapter->fw_name, MFG_FIRMWARE, sizeof(adapter->fw_name)) >=
 			    sizeof(adapter->fw_name)) {
 			pr_err("%s: fw_name too long!\n", __func__);
 			return -1;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mt7615_trace.h b/drivers/net/wireless/mediatek/mt76/mt7615/mt7615_trace.h
index d3eb49d83b98..9be5a58a4e6d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mt7615_trace.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mt7615_trace.h
@@ -14,7 +14,7 @@
 
 #define MAXNAME		32
 #define DEV_ENTRY	__array(char, wiphy_name, 32)
-#define DEV_ASSIGN	strlcpy(__entry->wiphy_name,	\
+#define DEV_ASSIGN	strscpy(__entry->wiphy_name,	\
 				wiphy_name(mt76_hw(dev)->wiphy), MAXNAME)
 #define DEV_PR_FMT	"%s"
 #define DEV_PR_ARG	__entry->wiphy_name
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_trace.h b/drivers/net/wireless/mediatek/mt76/mt76x02_trace.h
index 6a98092e996b..11d119cd0f6f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_trace.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_trace.h
@@ -14,7 +14,7 @@
 
 #define MAXNAME		32
 #define DEV_ENTRY	__array(char, wiphy_name, 32)
-#define DEV_ASSIGN	strlcpy(__entry->wiphy_name,	\
+#define DEV_ASSIGN	strscpy(__entry->wiphy_name,	\
 				wiphy_name(mt76_hw(dev)->wiphy), MAXNAME)
 #define DEV_PR_FMT	"%s"
 #define DEV_PR_ARG	__entry->wiphy_name
diff --git a/drivers/net/wireless/mediatek/mt76/trace.h b/drivers/net/wireless/mediatek/mt76/trace.h
index c3d0ef8e2890..109a07f9733a 100644
--- a/drivers/net/wireless/mediatek/mt76/trace.h
+++ b/drivers/net/wireless/mediatek/mt76/trace.h
@@ -14,7 +14,7 @@
 
 #define MAXNAME		32
 #define DEV_ENTRY	__array(char, wiphy_name, 32)
-#define DEVICE_ASSIGN	strlcpy(__entry->wiphy_name,	\
+#define DEVICE_ASSIGN	strscpy(__entry->wiphy_name,	\
 				wiphy_name(dev->hw->wiphy), MAXNAME)
 #define DEV_PR_FMT	"%s"
 #define DEV_PR_ARG	__entry->wiphy_name
diff --git a/drivers/net/wireless/mediatek/mt76/usb_trace.h b/drivers/net/wireless/mediatek/mt76/usb_trace.h
index f5ab3215af80..7b261ddb2ac6 100644
--- a/drivers/net/wireless/mediatek/mt76/usb_trace.h
+++ b/drivers/net/wireless/mediatek/mt76/usb_trace.h
@@ -14,7 +14,7 @@
 
 #define MAXNAME		32
 #define DEV_ENTRY	__array(char, wiphy_name, 32)
-#define DEV_ASSIGN	strlcpy(__entry->wiphy_name,	\
+#define DEV_ASSIGN	strscpy(__entry->wiphy_name,	\
 				wiphy_name(dev->hw->wiphy), MAXNAME)
 #define DEV_PR_FMT	"%s "
 #define DEV_PR_ARG	__entry->wiphy_name
diff --git a/drivers/net/wireless/mediatek/mt7601u/trace.h b/drivers/net/wireless/mediatek/mt7601u/trace.h
index 5a6ba015085f..07696b672161 100644
--- a/drivers/net/wireless/mediatek/mt7601u/trace.h
+++ b/drivers/net/wireless/mediatek/mt7601u/trace.h
@@ -16,7 +16,7 @@
 
 #define MAXNAME		32
 #define DEV_ENTRY	__array(char, wiphy_name, 32)
-#define DEV_ASSIGN	strlcpy(__entry->wiphy_name,			\
+#define DEV_ASSIGN	strscpy(__entry->wiphy_name,			\
 				wiphy_name(dev->hw->wiphy), MAXNAME)
 #define DEV_PR_FMT	"%s "
 #define DEV_PR_ARG	__entry->wiphy_name
diff --git a/drivers/net/wireless/microchip/wilc1000/mon.c b/drivers/net/wireless/microchip/wilc1000/mon.c
index b5a1b65c087c..03b7229a0ff5 100644
--- a/drivers/net/wireless/microchip/wilc1000/mon.c
+++ b/drivers/net/wireless/microchip/wilc1000/mon.c
@@ -229,7 +229,7 @@ struct net_device *wilc_wfi_init_mon_interface(struct wilc *wl,
 		return NULL;
 
 	wl->monitor_dev->type = ARPHRD_IEEE80211_RADIOTAP;
-	strlcpy(wl->monitor_dev->name, name, IFNAMSIZ);
+	strscpy(wl->monitor_dev->name, name, IFNAMSIZ);
 	wl->monitor_dev->netdev_ops = &wilc_wfi_netdev_ops;
 	wl->monitor_dev->needs_free_netdev = true;
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 54cdf3ad09d7..7b555bd36527 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -1236,7 +1236,7 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info, struct qtnf_wmac *mac)
 			mac->macinfo.extended_capabilities_len;
 	}
 
-	strlcpy(wiphy->fw_version, hw_info->fw_version,
+	strscpy(wiphy->fw_version, hw_info->fw_version,
 		sizeof(wiphy->fw_version));
 	wiphy->hw_version = hw_info->hw_version;
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index f3ccbd2b1084..c75241f50583 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -979,7 +979,7 @@ qtnf_cmd_resp_proc_hw_info(struct qtnf_bus *bus,
 		hwinfo->total_rx_chain, hwinfo->total_tx_chain,
 		hwinfo->fw_ver);
 
-	strlcpy(hwinfo->fw_version, bld_label, sizeof(hwinfo->fw_version));
+	strscpy(hwinfo->fw_version, bld_label, sizeof(hwinfo->fw_version));
 	hwinfo->hw_version = hw_ver;
 
 	return 0;
diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8187/leds.c b/drivers/net/wireless/realtek/rtl818x/rtl8187/leds.c
index 49421d10e22b..f7d95c9624a0 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8187/leds.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8187/leds.c
@@ -143,7 +143,7 @@ static int rtl8187_register_led(struct ieee80211_hw *dev,
 	led->dev = dev;
 	led->ledpin = ledpin;
 	led->is_radio = is_radio;
-	strlcpy(led->name, name, sizeof(led->name));
+	strscpy(led->name, name, sizeof(led->name));
 
 	led->led_dev.name = led->name;
 	led->led_dev.default_trigger = default_trigger;
diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl3501_cs.c
index 026e88b80bfc..bc944eb08a84 100644
--- a/drivers/net/wireless/wl3501_cs.c
+++ b/drivers/net/wireless/wl3501_cs.c
@@ -1439,7 +1439,7 @@ static void wl3501_detach(struct pcmcia_device *link)
 static int wl3501_get_name(struct net_device *dev, struct iw_request_info *info,
 			   union iwreq_data *wrqu, char *extra)
 {
-	strlcpy(wrqu->name, "IEEE 802.11-DS", sizeof(wrqu->name));
+	strscpy(wrqu->name, "IEEE 802.11-DS", sizeof(wrqu->name));
 	return 0;
 }
 
@@ -1650,7 +1650,7 @@ static int wl3501_set_nick(struct net_device *dev, struct iw_request_info *info,
 
 	if (wrqu->data.length > sizeof(this->nick))
 		return -E2BIG;
-	strlcpy(this->nick, extra, wrqu->data.length);
+	strscpy(this->nick, extra, wrqu->data.length);
 	return 0;
 }
 
@@ -1659,7 +1659,7 @@ static int wl3501_get_nick(struct net_device *dev, struct iw_request_info *info,
 {
 	struct wl3501_card *this = netdev_priv(dev);
 
-	strlcpy(extra, this->nick, 32);
+	strscpy(extra, this->nick, 32);
 	wrqu->data.length = strlen(extra);
 	return 0;
 }
@@ -1964,7 +1964,7 @@ static int wl3501_config(struct pcmcia_device *link)
 	this->firmware_date[0]	= '\0';
 	this->rssi		= 255;
 	this->chan		= iw_default_channel(this->reg_domain);
-	strlcpy(this->nick, "Planet WL3501", sizeof(this->nick));
+	strscpy(this->nick, "Planet WL3501", sizeof(this->nick));
 	spin_lock_init(&this->lock);
 	init_waitqueue_head(&this->wait);
 	netif_start_queue(dev);
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 9a270e49df17..de650785e7c3 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2676,7 +2676,7 @@ static void nvme_init_subnqn(struct nvme_subsystem *subsys, struct nvme_ctrl *ct
 	if(!(ctrl->quirks & NVME_QUIRK_IGNORE_DEV_SUBNQN)) {
 		nqnlen = strnlen(id->subnqn, NVMF_NQN_SIZE);
 		if (nqnlen > 0 && nqnlen < NVMF_NQN_SIZE) {
-			strlcpy(subsys->subnqn, id->subnqn, NVMF_NQN_SIZE);
+			strscpy(subsys->subnqn, id->subnqn, NVMF_NQN_SIZE);
 			return;
 		}
 
diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index 8575724734e0..afb93525c3a7 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -49,7 +49,7 @@ static struct nvmf_host *nvmf_host_add(const char *hostnqn)
 		goto out_unlock;
 
 	kref_init(&host->ref);
-	strlcpy(host->nqn, hostnqn, NVMF_NQN_SIZE);
+	strscpy(host->nqn, hostnqn, NVMF_NQN_SIZE);
 
 	list_add_tail(&host->list, &nvmf_hosts);
 out_unlock:
diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index dca34489a1dc..a4b152b5d6d9 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -428,7 +428,7 @@ static void nvmet_execute_identify_ctrl(struct nvmet_req *req)
 	if (req->port->inline_data_size)
 		id->sgls |= cpu_to_le32(1 << 20);
 
-	strlcpy(id->subnqn, ctrl->subsys->subsysnqn, sizeof(id->subnqn));
+	strscpy(id->subnqn, ctrl->subsys->subsysnqn, sizeof(id->subnqn));
 
 	/*
 	 * Max command capsule size is sqe + in-capsule data size.
diff --git a/drivers/nvme/target/discovery.c b/drivers/nvme/target/discovery.c
index f40c05c33c3a..a08b473ccb22 100644
--- a/drivers/nvme/target/discovery.c
+++ b/drivers/nvme/target/discovery.c
@@ -284,7 +284,7 @@ static void nvmet_execute_disc_identify(struct nvmet_req *req)
 
 	id->oaes = cpu_to_le32(NVMET_DISC_AEN_CFG_OPTIONAL);
 
-	strlcpy(id->subnqn, ctrl->subsys->subsysnqn, sizeof(id->subnqn));
+	strscpy(id->subnqn, ctrl->subsys->subsysnqn, sizeof(id->subnqn));
 
 	status = nvmet_copy_to_sgl(req, 0, id, sizeof(*id));
 
diff --git a/drivers/of/base.c b/drivers/of/base.c
index 161a23631472..378f4a141118 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1181,7 +1181,7 @@ int of_modalias_node(struct device_node *node, char *modalias, int len)
 	if (!compatible || strlen(compatible) > cplen)
 		return -ENODEV;
 	p = strchr(compatible, ',');
-	strlcpy(modalias, p ? p + 1 : compatible, len);
+	strscpy(modalias, p ? p + 1 : compatible, len);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(of_modalias_node);
diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 4602e467ca8b..d393af20f611 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -1054,7 +1054,7 @@ int __init early_init_dt_scan_chosen(unsigned long node, const char *uname,
 	/* Retrieve command line */
 	p = of_get_flat_dt_prop(node, "bootargs", &l);
 	if (p != NULL && l > 0)
-		strlcpy(data, p, min(l, COMMAND_LINE_SIZE));
+		strscpy(data, p, min(l, COMMAND_LINE_SIZE));
 
 	/*
 	 * CONFIG_CMDLINE is meant to be a default in case nothing else
@@ -1066,11 +1066,11 @@ int __init early_init_dt_scan_chosen(unsigned long node, const char *uname,
 	strlcat(data, " ", COMMAND_LINE_SIZE);
 	strlcat(data, CONFIG_CMDLINE, COMMAND_LINE_SIZE);
 #elif defined(CONFIG_CMDLINE_FORCE)
-	strlcpy(data, CONFIG_CMDLINE, COMMAND_LINE_SIZE);
+	strscpy(data, CONFIG_CMDLINE, COMMAND_LINE_SIZE);
 #else
 	/* No arguments from boot loader, use kernel's  cmdl*/
 	if (!((char *)data)[0])
-		strlcpy(data, CONFIG_CMDLINE, COMMAND_LINE_SIZE);
+		strscpy(data, CONFIG_CMDLINE, COMMAND_LINE_SIZE);
 #endif
 #endif /* CONFIG_CMDLINE */
 
diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index 06cc988faf78..cf84b400f393 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -2437,7 +2437,7 @@ static int unittest_i2c_bus_probe(struct platform_device *pdev)
 	adap = &std->adap;
 	i2c_set_adapdata(adap, std);
 	adap->nr = -1;
-	strlcpy(adap->name, pdev->name, sizeof(adap->name));
+	strscpy(adap->name, pdev->name, sizeof(adap->name));
 	adap->class = I2C_CLASS_DEPRECATED;
 	adap->algo = &unittest_i2c_algo;
 	adap->dev.parent = dev;
diff --git a/drivers/parisc/led.c b/drivers/parisc/led.c
index 36c6613f7a36..bdb4701fb45c 100644
--- a/drivers/parisc/led.c
+++ b/drivers/parisc/led.c
@@ -646,7 +646,7 @@ int lcd_print( const char *str )
 		cancel_delayed_work_sync(&led_task);
 
 	/* copy display string to buffer for procfs */
-	strlcpy(lcd_text, str, sizeof(lcd_text));
+	strscpy(lcd_text, str, sizeof(lcd_text));
 
 	/* Set LCD Cursor to 1st character */
 	gsc_writeb(lcd_info.reset_cmd1, LCD_CMD_REG);
diff --git a/drivers/phy/allwinner/phy-sun4i-usb.c b/drivers/phy/allwinner/phy-sun4i-usb.c
index 651d5e2a25ce..fd092a3e7355 100644
--- a/drivers/phy/allwinner/phy-sun4i-usb.c
+++ b/drivers/phy/allwinner/phy-sun4i-usb.c
@@ -768,7 +768,7 @@ static int sun4i_usb_phy_probe(struct platform_device *pdev)
 		if (data->cfg->dedicated_clocks)
 			snprintf(name, sizeof(name), "usb%d_phy", i);
 		else
-			strlcpy(name, "usb_phy", sizeof(name));
+			strscpy(name, "usb_phy", sizeof(name));
 
 		phy->clk = devm_clk_get(dev, name);
 		if (IS_ERR(phy->clk)) {
diff --git a/drivers/platform/x86/i2c-multi-instantiate.c b/drivers/platform/x86/i2c-multi-instantiate.c
index 6acc8457866e..911e202c0c07 100644
--- a/drivers/platform/x86/i2c-multi-instantiate.c
+++ b/drivers/platform/x86/i2c-multi-instantiate.c
@@ -89,7 +89,7 @@ static int i2c_multi_inst_probe(struct platform_device *pdev)
 
 	for (i = 0; i < multi->num_clients && inst_data[i].type; i++) {
 		memset(&board_info, 0, sizeof(board_info));
-		strlcpy(board_info.type, inst_data[i].type, I2C_NAME_SIZE);
+		strscpy(board_info.type, inst_data[i].type, I2C_NAME_SIZE);
 		snprintf(name, sizeof(name), "%s-%s.%d", dev_name(dev),
 			 inst_data[i].type, i);
 		board_info.dev_name = name;
diff --git a/drivers/platform/x86/intel_cht_int33fe_typec.c b/drivers/platform/x86/intel_cht_int33fe_typec.c
index 48638d1c56e5..e7a2aae4eb4f 100644
--- a/drivers/platform/x86/intel_cht_int33fe_typec.c
+++ b/drivers/platform/x86/intel_cht_int33fe_typec.c
@@ -245,7 +245,7 @@ cht_int33fe_register_max17047(struct device *dev, struct cht_int33fe_data *data)
 	}
 
 	memset(&board_info, 0, sizeof(board_info));
-	strlcpy(board_info.type, "max17047", I2C_NAME_SIZE);
+	strscpy(board_info.type, "max17047", I2C_NAME_SIZE);
 	board_info.dev_name = "max17047";
 	board_info.fwnode = fwnode;
 	data->battery_fg = i2c_acpi_new_device(dev, 1, &board_info);
@@ -307,7 +307,7 @@ int cht_int33fe_typec_probe(struct cht_int33fe_data *data)
 	}
 
 	memset(&board_info, 0, sizeof(board_info));
-	strlcpy(board_info.type, "typec_fusb302", I2C_NAME_SIZE);
+	strscpy(board_info.type, "typec_fusb302", I2C_NAME_SIZE);
 	board_info.dev_name = "fusb302";
 	board_info.fwnode = fwnode;
 	board_info.irq = fusb302_irq;
@@ -327,7 +327,7 @@ int cht_int33fe_typec_probe(struct cht_int33fe_data *data)
 	memset(&board_info, 0, sizeof(board_info));
 	board_info.dev_name = "pi3usb30532";
 	board_info.fwnode = fwnode;
-	strlcpy(board_info.type, "pi3usb30532", I2C_NAME_SIZE);
+	strscpy(board_info.type, "pi3usb30532", I2C_NAME_SIZE);
 
 	data->pi3usb30532 = i2c_acpi_new_device(dev, 3, &board_info);
 	if (IS_ERR(data->pi3usb30532)) {
diff --git a/drivers/platform/x86/surface3_power.c b/drivers/platform/x86/surface3_power.c
index cc4f9cba6856..16a25ba5b230 100644
--- a/drivers/platform/x86/surface3_power.c
+++ b/drivers/platform/x86/surface3_power.c
@@ -519,7 +519,7 @@ static int mshw0011_probe(struct i2c_client *client)
 	i2c_set_clientdata(client, data);
 
 	memset(&board_info, 0, sizeof(board_info));
-	strlcpy(board_info.type, "MSHW0011-bat0", I2C_NAME_SIZE);
+	strscpy(board_info.type, "MSHW0011-bat0", I2C_NAME_SIZE);
 
 	bat0 = i2c_acpi_new_device(dev, 1, &board_info);
 	if (IS_ERR(bat0))
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index c404706379d9..167b0716e3cd 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -7613,9 +7613,8 @@ static int __init volume_create_alsa_mixer(void)
 	data = card->private_data;
 	data->card = card;
 
-	strlcpy(card->driver, TPACPI_ALSA_DRVNAME,
-		sizeof(card->driver));
-	strlcpy(card->shortname, TPACPI_ALSA_SHRTNAME,
+	strscpy(card->driver, TPACPI_ALSA_DRVNAME, sizeof(card->driver));
+	strscpy(card->shortname, TPACPI_ALSA_SHRTNAME,
 		sizeof(card->shortname));
 	snprintf(card->mixername, sizeof(card->mixername), "ThinkPad EC %s",
 		 (thinkpad_id.ec_version_str) ?
diff --git a/drivers/remoteproc/qcom_sysmon.c b/drivers/remoteproc/qcom_sysmon.c
index 9eb2f6bccea6..05e8f69d1566 100644
--- a/drivers/remoteproc/qcom_sysmon.c
+++ b/drivers/remoteproc/qcom_sysmon.c
@@ -361,7 +361,7 @@ static void ssctl_send_event(struct qcom_sysmon *sysmon,
 	}
 
 	memset(&req, 0, sizeof(req));
-	strlcpy(req.subsys_name, event->subsys_name, sizeof(req.subsys_name));
+	strscpy(req.subsys_name, event->subsys_name, sizeof(req.subsys_name));
 	req.subsys_name_len = strlen(req.subsys_name);
 	req.event = event->ssr_event;
 	req.evt_driven_valid = true;
diff --git a/drivers/rpmsg/qcom_glink_ssr.c b/drivers/rpmsg/qcom_glink_ssr.c
index dcd1ce616974..a3fdaad559f7 100644
--- a/drivers/rpmsg/qcom_glink_ssr.c
+++ b/drivers/rpmsg/qcom_glink_ssr.c
@@ -110,7 +110,7 @@ static int qcom_glink_ssr_notifier_call(struct notifier_block *nb,
 	msg.command = cpu_to_le32(GLINK_SSR_DO_CLEANUP);
 	msg.seq_num = cpu_to_le32(ssr->seq_num);
 	msg.name_len = cpu_to_le32(strlen(ssr_name));
-	strlcpy(msg.name, ssr_name, sizeof(msg.name));
+	strscpy(msg.name, ssr_name, sizeof(msg.name));
 
 	ret = rpmsg_send(ssr->ept, &msg, sizeof(msg));
 	if (ret < 0)
diff --git a/drivers/s390/block/dasd_devmap.c b/drivers/s390/block/dasd_devmap.c
index 32fc51341d99..02db62ce8734 100644
--- a/drivers/s390/block/dasd_devmap.c
+++ b/drivers/s390/block/dasd_devmap.c
@@ -426,7 +426,7 @@ dasd_add_busid(const char *bus_id, int features)
 	if (!devmap) {
 		/* This bus_id is new. */
 		new->devindex = dasd_max_devindex++;
-		strlcpy(new->bus_id, bus_id, DASD_BUS_ID_SIZE);
+		strscpy(new->bus_id, bus_id, DASD_BUS_ID_SIZE);
 		new->features = features;
 		new->device = NULL;
 		list_add(&new->list, &dasd_hashlists[hash]);
diff --git a/drivers/s390/block/dasd_eer.c b/drivers/s390/block/dasd_eer.c
index 5ae64af9ccea..d4d31cd11d26 100644
--- a/drivers/s390/block/dasd_eer.c
+++ b/drivers/s390/block/dasd_eer.c
@@ -313,7 +313,7 @@ static void dasd_eer_write_standard_trigger(struct dasd_device *device,
 	ktime_get_real_ts64(&ts);
 	header.tv_sec = ts.tv_sec;
 	header.tv_usec = ts.tv_nsec / NSEC_PER_USEC;
-	strlcpy(header.busid, dev_name(&device->cdev->dev),
+	strscpy(header.busid, dev_name(&device->cdev->dev),
 		DASD_EER_BUSID_SIZE);
 
 	spin_lock_irqsave(&bufferlock, flags);
@@ -356,7 +356,7 @@ static void dasd_eer_write_snss_trigger(struct dasd_device *device,
 	ktime_get_real_ts64(&ts);
 	header.tv_sec = ts.tv_sec;
 	header.tv_usec = ts.tv_nsec / NSEC_PER_USEC;
-	strlcpy(header.busid, dev_name(&device->cdev->dev),
+	strscpy(header.busid, dev_name(&device->cdev->dev),
 		DASD_EER_BUSID_SIZE);
 
 	spin_lock_irqsave(&bufferlock, flags);
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 299e77ec2c41..e7f017118d86 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -631,7 +631,7 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
 		rc = -ENAMETOOLONG;
 		goto seg_list_del;
 	}
-	strlcpy(local_buf, buf, i + 1);
+	strscpy(local_buf, buf, i + 1);
 	dev_info->num_of_segments = num_of_segments;
 	rc = dcssblk_is_continuous(dev_info);
 	if (rc < 0)
diff --git a/drivers/s390/char/hmcdrv_cache.c b/drivers/s390/char/hmcdrv_cache.c
index 1f5bdb237862..43df27ceec11 100644
--- a/drivers/s390/char/hmcdrv_cache.c
+++ b/drivers/s390/char/hmcdrv_cache.c
@@ -154,7 +154,7 @@ static ssize_t hmcdrv_cache_do(const struct hmcdrv_ftp_cmdspec *ftp,
 		/* cache some file info (FTP command, file name and file
 		 * size) unconditionally
 		 */
-		strlcpy(hmcdrv_cache_file.fname, ftp->fname,
+		strscpy(hmcdrv_cache_file.fname, ftp->fname,
 			HMCDRV_FTP_FIDENT_MAX);
 		hmcdrv_cache_file.id = ftp->id;
 		pr_debug("caching cmd %d, file size %zu for '%s'\n",
diff --git a/drivers/s390/char/tape_class.c b/drivers/s390/char/tape_class.c
index b58df0dd0039..c21dc68e05a0 100644
--- a/drivers/s390/char/tape_class.c
+++ b/drivers/s390/char/tape_class.c
@@ -54,10 +54,10 @@ struct tape_class_device *register_tape_dev(
 	if (!tcd)
 		return ERR_PTR(-ENOMEM);
 
-	strlcpy(tcd->device_name, device_name, TAPECLASS_NAME_LEN);
+	strscpy(tcd->device_name, device_name, TAPECLASS_NAME_LEN);
 	for (s = strchr(tcd->device_name, '/'); s; s = strchr(s, '/'))
 		*s = '!';
-	strlcpy(tcd->mode_name, mode_name, TAPECLASS_NAME_LEN);
+	strscpy(tcd->mode_name, mode_name, TAPECLASS_NAME_LEN);
 	for (s = strchr(tcd->mode_name, '/'); s; s = strchr(s, '/'))
 		*s = '!';
 
diff --git a/drivers/s390/cio/qdio_debug.c b/drivers/s390/cio/qdio_debug.c
index 863d17c802ca..c7b660593dc4 100644
--- a/drivers/s390/cio/qdio_debug.c
+++ b/drivers/s390/cio/qdio_debug.c
@@ -87,7 +87,7 @@ int qdio_allocate_dbf(struct qdio_irq *irq_ptr)
 			debug_unregister(irq_ptr->debug_area);
 			return -ENOMEM;
 		}
-		strlcpy(new_entry->dbf_name, text, QDIO_DBF_NAME_LEN);
+		strscpy(new_entry->dbf_name, text, QDIO_DBF_NAME_LEN);
 		new_entry->dbf_info = irq_ptr->debug_area;
 		mutex_lock(&qdio_dbf_list_mutex);
 		list_add(&new_entry->dbf_list, &qdio_dbf_list);
diff --git a/drivers/s390/net/ctcm_main.c b/drivers/s390/net/ctcm_main.c
index d06809eac16d..c585efd88917 100644
--- a/drivers/s390/net/ctcm_main.c
+++ b/drivers/s390/net/ctcm_main.c
@@ -1606,7 +1606,7 @@ static int ctcm_new_device(struct ccwgroup_device *cgdev)
 		goto out_dev;
 	}
 
-	strlcpy(priv->fsm->name, dev->name, sizeof(priv->fsm->name));
+	strscpy(priv->fsm->name, dev->name, sizeof(priv->fsm->name));
 
 	dev_info(&dev->dev,
 		"setup OK : r/w = %s/%s, protocol : %d\n",
diff --git a/drivers/s390/net/fsm.c b/drivers/s390/net/fsm.c
index eb07862bd36a..eb9d90402f5d 100644
--- a/drivers/s390/net/fsm.c
+++ b/drivers/s390/net/fsm.c
@@ -28,7 +28,7 @@ init_fsm(char *name, const char **state_names, const char **event_names, int nr_
 			"fsm(%s): init_fsm: Couldn't alloc instance\n", name);
 		return NULL;
 	}
-	strlcpy(this->name, name, sizeof(this->name));
+	strscpy(this->name, name, sizeof(this->name));
 	init_waitqueue_head(&this->wait_q);
 
 	f = kzalloc(sizeof(fsm), order);
diff --git a/drivers/s390/net/qeth_ethtool.c b/drivers/s390/net/qeth_ethtool.c
index b5caa723326e..41ed903cfd1f 100644
--- a/drivers/s390/net/qeth_ethtool.c
+++ b/drivers/s390/net/qeth_ethtool.c
@@ -185,9 +185,9 @@ static void qeth_get_drvinfo(struct net_device *dev,
 {
 	struct qeth_card *card = dev->ml_priv;
 
-	strlcpy(info->driver, IS_LAYER2(card) ? "qeth_l2" : "qeth_l3",
+	strscpy(info->driver, IS_LAYER2(card) ? "qeth_l2" : "qeth_l3",
 		sizeof(info->driver));
-	strlcpy(info->fw_version, card->info.mcl_level,
+	strscpy(info->fw_version, card->info.mcl_level,
 		sizeof(info->fw_version));
 	snprintf(info->bus_info, sizeof(info->bus_info), "%s/%s/%s",
 		 CARD_RDEV_ID(card), CARD_WDEV_ID(card), CARD_DDEV_ID(card));
diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
index 18b713a616de..3253c8e44a6d 100644
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -103,7 +103,7 @@ static void __init zfcp_init_device_setup(char *devstr)
 	token = strsep(&str, ",");
 	if (!token || strlen(token) >= ZFCP_BUS_ID_SIZE)
 		goto err_out;
-	strlcpy(busid, token, ZFCP_BUS_ID_SIZE);
+	strscpy(busid, token, ZFCP_BUS_ID_SIZE);
 
 	token = strsep(&str, ",");
 	if (!token || kstrtoull(token, 0, (unsigned long long *) &wwpn))
diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
index 8a65241011b9..7aa6419c23a1 100644
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -863,7 +863,7 @@ static int zfcp_fc_gspn(struct zfcp_adapter *adapter,
 			 dev_name(&adapter->ccw_device->dev),
 			 init_utsname()->nodename);
 	else
-		strlcpy(fc_host_symbolic_name(adapter->scsi_host),
+		strscpy(fc_host_symbolic_name(adapter->scsi_host),
 			gspn_rsp->gspn.fp_name, FC_SYMBOLIC_NAME_SIZE);
 
 	return 0;
diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 3337b1e80412..87482f624839 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -616,7 +616,7 @@ static int twa_check_srl(TW_Device_Extension *tw_dev, int *flashed)
 	}
 
 	/* Load rest of compatibility struct */
-	strlcpy(tw_dev->tw_compat_info.driver_version, TW_DRIVER_VERSION,
+	strscpy(tw_dev->tw_compat_info.driver_version, TW_DRIVER_VERSION,
 		sizeof(tw_dev->tw_compat_info.driver_version));
 	tw_dev->tw_compat_info.driver_srl_high = TW_CURRENT_DRIVER_SRL;
 	tw_dev->tw_compat_info.driver_branch_high = TW_CURRENT_DRIVER_BRANCH;
diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 31233f6a0274..b44b3ebf8bdc 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -3309,8 +3309,8 @@ static int query_disk(struct aac_dev *dev, void __user *arg)
 	else
 		qd.unmapped = 0;
 
-	strlcpy(qd.name, fsa_dev_ptr[qd.cnum].devname,
-	  min(sizeof(qd.name), sizeof(fsa_dev_ptr[qd.cnum].devname) + 1));
+	strscpy(qd.name, fsa_dev_ptr[qd.cnum].devname,
+		min(sizeof(qd.name), sizeof(fsa_dev_ptr[qd.cnum].devname) + 1));
 
 	if (copy_to_user(arg, &qd, sizeof (struct aac_query_disk)))
 		return -EFAULT;
diff --git a/drivers/scsi/bfa/bfa_fcbuild.c b/drivers/scsi/bfa/bfa_fcbuild.c
index df18d9d2af53..773c84af784c 100644
--- a/drivers/scsi/bfa/bfa_fcbuild.c
+++ b/drivers/scsi/bfa/bfa_fcbuild.c
@@ -1134,7 +1134,7 @@ fc_rspnid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
 	memset(rspnid, 0, sizeof(struct fcgs_rspnid_req_s));
 
 	rspnid->dap = s_id;
-	strlcpy(rspnid->spn, name, sizeof(rspnid->spn));
+	strscpy(rspnid->spn, name, sizeof(rspnid->spn));
 	rspnid->spn_len = (u8) strlen(rspnid->spn);
 
 	return sizeof(struct fcgs_rspnid_req_s) + sizeof(struct ct_hdr_s);
@@ -1155,7 +1155,7 @@ fc_rsnn_nn_build(struct fchs_s *fchs, void *pyld, u32 s_id,
 	memset(rsnn_nn, 0, sizeof(struct fcgs_rsnn_nn_req_s));
 
 	rsnn_nn->node_name = node_name;
-	strlcpy(rsnn_nn->snn, name, sizeof(rsnn_nn->snn));
+	strscpy(rsnn_nn->snn, name, sizeof(rsnn_nn->snn));
 	rsnn_nn->snn_len = (u8) strlen(rsnn_nn->snn);
 
 	return sizeof(struct fcgs_rsnn_nn_req_s) + sizeof(struct ct_hdr_s);
diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c
index d2d396ca0e9a..6903c00515ba 100644
--- a/drivers/scsi/bfa/bfa_fcs.c
+++ b/drivers/scsi/bfa/bfa_fcs.c
@@ -761,8 +761,7 @@ bfa_fcs_fabric_psymb_init(struct bfa_fcs_fabric_s *fabric)
 	bfa_ioc_get_adapter_model(&fabric->fcs->bfa->ioc, model);
 
 	/* Model name/number */
-	strlcpy(port_cfg->sym_name.symname, model,
-		BFA_SYMNAME_MAXLEN);
+	strscpy(port_cfg->sym_name.symname, model, BFA_SYMNAME_MAXLEN);
 	strlcat(port_cfg->sym_name.symname, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
 		BFA_SYMNAME_MAXLEN);
 
@@ -822,8 +821,7 @@ bfa_fcs_fabric_nsymb_init(struct bfa_fcs_fabric_s *fabric)
 	bfa_ioc_get_adapter_model(&fabric->fcs->bfa->ioc, model);
 
 	/* Model name/number */
-	strlcpy(port_cfg->node_sym_name.symname, model,
-		BFA_SYMNAME_MAXLEN);
+	strscpy(port_cfg->node_sym_name.symname, model, BFA_SYMNAME_MAXLEN);
 	strlcat(port_cfg->node_sym_name.symname,
 			BFA_FCS_PORT_SYMBNAME_SEPARATOR,
 			BFA_SYMNAME_MAXLEN);
diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 3486e402bfc1..e666de0ad98e 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -2634,10 +2634,10 @@ bfa_fcs_fdmi_get_hbaattr(struct bfa_fcs_lport_fdmi_s *fdmi,
 	bfa_ioc_get_adapter_fw_ver(&port->fcs->bfa->ioc,
 					hba_attr->fw_version);
 
-	strlcpy(hba_attr->driver_version, (char *)driver_info->version,
+	strscpy(hba_attr->driver_version, (char *)driver_info->version,
 		sizeof(hba_attr->driver_version));
 
-	strlcpy(hba_attr->os_name, driver_info->host_os_name,
+	strscpy(hba_attr->os_name, driver_info->host_os_name,
 		sizeof(hba_attr->os_name));
 
 	/*
@@ -2655,13 +2655,13 @@ bfa_fcs_fdmi_get_hbaattr(struct bfa_fcs_lport_fdmi_s *fdmi,
 	bfa_fcs_fdmi_get_portattr(fdmi, &fcs_port_attr);
 	hba_attr->max_ct_pyld = fcs_port_attr.max_frm_size;
 
-	strlcpy(hba_attr->node_sym_name.symname,
+	strscpy(hba_attr->node_sym_name.symname,
 		port->port_cfg.node_sym_name.symname, BFA_SYMNAME_MAXLEN);
 	strcpy(hba_attr->vendor_info, "QLogic");
 	hba_attr->num_ports =
 		cpu_to_be32(bfa_ioc_get_nports(&port->fcs->bfa->ioc));
 	hba_attr->fabric_name = port->fabric->lps->pr_nwwn;
-	strlcpy(hba_attr->bios_ver, hba_attr->option_rom_ver, BFA_VERSION_LEN);
+	strscpy(hba_attr->bios_ver, hba_attr->option_rom_ver, BFA_VERSION_LEN);
 
 }
 
@@ -2728,19 +2728,19 @@ bfa_fcs_fdmi_get_portattr(struct bfa_fcs_lport_fdmi_s *fdmi,
 	/*
 	 * OS device Name
 	 */
-	strlcpy(port_attr->os_device_name, driver_info->os_device_name,
+	strscpy(port_attr->os_device_name, driver_info->os_device_name,
 		sizeof(port_attr->os_device_name));
 
 	/*
 	 * Host name
 	 */
-	strlcpy(port_attr->host_name, driver_info->host_machine_name,
+	strscpy(port_attr->host_name, driver_info->host_machine_name,
 		sizeof(port_attr->host_name));
 
 	port_attr->node_name = bfa_fcs_lport_get_nwwn(port);
 	port_attr->port_name = bfa_fcs_lport_get_pwwn(port);
 
-	strlcpy(port_attr->port_sym_name.symname,
+	strscpy(port_attr->port_sym_name.symname,
 		bfa_fcs_lport_get_psym_name(port).symname, BFA_SYMNAME_MAXLEN);
 	bfa_fcs_lport_get_attr(port, &lport_attr);
 	port_attr->port_type = cpu_to_be32(lport_attr.port_type);
@@ -3221,7 +3221,7 @@ bfa_fcs_lport_ms_gmal_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
 					rsp_str[gmal_entry->len-1] = 0;
 
 				/* copy IP Address to fabric */
-				strlcpy(bfa_fcs_lport_get_fabric_ipaddr(port),
+				strscpy(bfa_fcs_lport_get_fabric_ipaddr(port),
 					gmal_entry->ip_addr,
 					BFA_FCS_FABRIC_IPADDR_SZ);
 				break;
@@ -4659,9 +4659,8 @@ bfa_fcs_lport_ns_send_rspn_id(void *ns_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 		 * to that of the base port.
 		 */
 
-		strlcpy(symbl,
-			(char *)&(bfa_fcs_lport_get_psym_name
-			 (bfa_fcs_get_base_port(port->fcs))),
+		strscpy(symbl,
+			(char *)&(bfa_fcs_lport_get_psym_name(bfa_fcs_get_base_port(port->fcs))),
 			sizeof(symbl));
 
 		strlcat(symbl, (char *)&(bfa_fcs_lport_get_psym_name(port)),
@@ -5186,8 +5185,8 @@ bfa_fcs_lport_ns_util_send_rspn_id(void *cbarg, struct bfa_fcxp_s *fcxp_alloced)
 		 * For Vports, we append the vport's port symbolic name
 		 * to that of the base port.
 		 */
-		strlcpy(symbl, (char *)&(bfa_fcs_lport_get_psym_name
-			(bfa_fcs_get_base_port(port->fcs))),
+		strscpy(symbl,
+			(char *)&(bfa_fcs_lport_get_psym_name(bfa_fcs_get_base_port(port->fcs))),
 			sizeof(symbl));
 
 		strlcat(symbl,
diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 325ad8a592bb..f0509364eebb 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -2788,7 +2788,7 @@ void
 bfa_ioc_get_adapter_manufacturer(struct bfa_ioc_s *ioc, char *manufacturer)
 {
 	memset((void *)manufacturer, 0, BFA_ADAPTER_MFG_NAME_LEN);
-	strlcpy(manufacturer, BFA_MFG_NAME, BFA_ADAPTER_MFG_NAME_LEN);
+	strscpy(manufacturer, BFA_MFG_NAME, BFA_ADAPTER_MFG_NAME_LEN);
 }
 
 void
diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index 11c0c3e6f014..1bc419fc94a8 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -330,7 +330,7 @@ bfa_plog_str(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
 		lp.eid = event;
 		lp.log_type = BFA_PL_LOG_TYPE_STRING;
 		lp.misc = misc;
-		strlcpy(lp.log_entry.string_log, log_str,
+		strscpy(lp.log_entry.string_log, log_str,
 			BFA_PL_STRING_LOG_SZ);
 		lp.log_entry.string_log[BFA_PL_STRING_LOG_SZ - 1] = '\0';
 		bfa_plog_add(plog, &lp);
diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 440ef32be048..963aed97a04b 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -973,19 +973,19 @@ bfad_start_ops(struct bfad_s *bfad) {
 
 	/* Fill the driver_info info to fcs*/
 	memset(&driver_info, 0, sizeof(driver_info));
-	strlcpy(driver_info.version, BFAD_DRIVER_VERSION,
+	strscpy(driver_info.version, BFAD_DRIVER_VERSION,
 		sizeof(driver_info.version));
 	if (host_name)
-		strlcpy(driver_info.host_machine_name, host_name,
+		strscpy(driver_info.host_machine_name, host_name,
 			sizeof(driver_info.host_machine_name));
 	if (os_name)
-		strlcpy(driver_info.host_os_name, os_name,
+		strscpy(driver_info.host_os_name, os_name,
 			sizeof(driver_info.host_os_name));
 	if (os_patch)
-		strlcpy(driver_info.host_os_patch, os_patch,
+		strscpy(driver_info.host_os_patch, os_patch,
 			sizeof(driver_info.host_os_patch));
 
-	strlcpy(driver_info.os_device_name, bfad->pci_name,
+	strscpy(driver_info.os_device_name, bfad->pci_name,
 		sizeof(driver_info.os_device_name));
 
 	/* FCS driver info init */
diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index 5ae1e3f78910..818cc281e435 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -834,8 +834,8 @@ bfad_im_symbolic_name_show(struct device *dev, struct device_attribute *attr,
 	char symname[BFA_SYMNAME_MAXLEN];
 
 	bfa_fcs_lport_get_attr(&bfad->bfa_fcs.fabric.bport, &port_attr);
-	strlcpy(symname, port_attr.port_cfg.sym_name.symname,
-			BFA_SYMNAME_MAXLEN);
+	strscpy(symname, port_attr.port_cfg.sym_name.symname,
+		BFA_SYMNAME_MAXLEN);
 	return snprintf(buf, PAGE_SIZE, "%s\n", symname);
 }
 
diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index fc515424ca88..d390c030c467 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -119,8 +119,8 @@ bfad_iocmd_ioc_get_attr(struct bfad_s *bfad, void *cmd)
 
 	/* fill in driver attr info */
 	strcpy(iocmd->ioc_attr.driver_attr.driver, BFAD_DRIVER_NAME);
-	strlcpy(iocmd->ioc_attr.driver_attr.driver_ver,
-		BFAD_DRIVER_VERSION, BFA_VERSION_LEN);
+	strscpy(iocmd->ioc_attr.driver_attr.driver_ver, BFAD_DRIVER_VERSION,
+		BFA_VERSION_LEN);
 	strcpy(iocmd->ioc_attr.driver_attr.fw_ver,
 		iocmd->ioc_attr.adapter_attr.fw_ver);
 	strcpy(iocmd->ioc_attr.driver_attr.bios_ver,
@@ -307,7 +307,7 @@ bfad_iocmd_port_get_attr(struct bfad_s *bfad, void *cmd)
 	iocmd->attr.port_type = port_attr.port_type;
 	iocmd->attr.loopback = port_attr.loopback;
 	iocmd->attr.authfail = port_attr.authfail;
-	strlcpy(iocmd->attr.port_symname.symname,
+	strscpy(iocmd->attr.port_symname.symname,
 		port_attr.port_cfg.sym_name.symname,
 		sizeof(iocmd->attr.port_symname.symname));
 
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 22f06be2606f..4b79cba83950 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -1046,7 +1046,7 @@ bfad_fc_host_init(struct bfad_im_port_s *im_port)
 	/* For fibre channel services type 0x20 */
 	fc_host_supported_fc4s(host)[7] = 1;
 
-	strlcpy(symname, bfad->bfa_fcs.fabric.bport.port_cfg.sym_name.symname,
+	strscpy(symname, bfad->bfa_fcs.fabric.bport.port_cfg.sym_name.symname,
 		BFA_SYMNAME_MAXLEN);
 	sprintf(fc_host_symbolic_name(host), "%s", symname);
 
diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index 2b3f0c10478e..872ad37e2a6e 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -383,7 +383,7 @@ int bnx2i_get_stats(void *handle)
 	if (!stats)
 		return -ENOMEM;
 
-	strlcpy(stats->version, DRV_MODULE_VERSION, sizeof(stats->version));
+	strscpy(stats->version, DRV_MODULE_VERSION, sizeof(stats->version));
 	memcpy(stats->mac_add1 + 2, hba->cnic->mac_addr, ETH_ALEN);
 
 	stats->max_frame_size = hba->netdev->mtu;
diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index 6e187d0e71fd..b5dbc864b497 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -710,7 +710,7 @@ static struct net_device *fcoe_if_to_netdev(const char *buffer)
 	char ifname[IFNAMSIZ + 2];
 
 	if (buffer) {
-		strlcpy(ifname, buffer, IFNAMSIZ);
+		strscpy(ifname, buffer, IFNAMSIZ);
 		cp = ifname + strlen(ifname);
 		while (--cp >= ifname && *cp == '\n')
 			*cp = '\0';
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 5d801388680b..18e81ac587a0 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -1447,7 +1447,7 @@ static int gdth_search_drives(gdth_ha_str *ha)
         printk("GDT-HA %d: Vendor: %s Name: %s\n",
                ha->hanum, oemstr->text.oem_company_name, ha->binfo.type_string);
         /* Save the Host Drive inquiry data */
-        strlcpy(ha->oem_name,oemstr->text.scsi_host_drive_inquiry_vendor_id,
+        strscpy(ha->oem_name, oemstr->text.scsi_host_drive_inquiry_vendor_id,
                 sizeof(ha->oem_name));
     } else {
         /* Old method, based on PCI ID */
@@ -1455,9 +1455,9 @@ static int gdth_search_drives(gdth_ha_str *ha)
         printk("GDT-HA %d: Name: %s\n",
                ha->hanum, ha->binfo.type_string);
         if (ha->oem_id == OEM_ID_INTEL)
-            strlcpy(ha->oem_name,"Intel  ", sizeof(ha->oem_name));
+            strscpy(ha->oem_name, "Intel  ", sizeof(ha->oem_name));
         else
-            strlcpy(ha->oem_name,"ICP    ", sizeof(ha->oem_name));
+            strscpy(ha->oem_name, "ICP    ", sizeof(ha->oem_name));
     }
 
     /* scanning for host drives */
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 29fcc44be2d5..1fcb6dc4f4a1 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -249,8 +249,8 @@ static void gather_partition_info(void)
 
 	ppartition_name = of_get_property(of_root, "ibm,partition-name", NULL);
 	if (ppartition_name)
-		strlcpy(partition_name, ppartition_name,
-				sizeof(partition_name));
+		strscpy(partition_name, ppartition_name,
+			sizeof(partition_name));
 	p_number_ptr = of_get_property(of_root, "ibm,partition-no", NULL);
 	if (p_number_ptr)
 		partition_number = of_read_number(p_number_ptr, 1);
@@ -1280,12 +1280,12 @@ static void send_mad_capabilities(struct ibmvscsi_host_data *hostdata)
 	if (hostdata->client_migrated)
 		hostdata->caps.flags |= cpu_to_be32(CLIENT_MIGRATED);
 
-	strlcpy(hostdata->caps.name, dev_name(&hostdata->host->shost_gendev),
+	strscpy(hostdata->caps.name, dev_name(&hostdata->host->shost_gendev),
 		sizeof(hostdata->caps.name));
 
 	location = of_get_property(of_node, "ibm,loc-code", NULL);
 	location = location ? location : dev_name(hostdata->dev);
-	strlcpy(hostdata->caps.loc, location, sizeof(hostdata->caps.loc));
+	strscpy(hostdata->caps.loc, location, sizeof(hostdata->caps.loc));
 
 	req->common.type = cpu_to_be32(VIOSRP_CAPABILITIES_TYPE);
 	req->buffer = cpu_to_be64(hostdata->caps_addr);
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index e94eac194676..565225d7fa40 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -516,11 +516,9 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 				"6314 Catching potential buffer "
 				"overflow > PAGE_SIZE = %lu bytes\n",
 				PAGE_SIZE);
-		strlcpy(buf + PAGE_SIZE - 1 -
-			strnlen(LPFC_NVME_INFO_MORE_STR, PAGE_SIZE - 1),
+		strscpy(buf + PAGE_SIZE - 1 - strnlen(LPFC_NVME_INFO_MORE_STR, PAGE_SIZE - 1),
 			LPFC_NVME_INFO_MORE_STR,
-			strnlen(LPFC_NVME_INFO_MORE_STR, PAGE_SIZE - 1)
-			+ 1);
+			strnlen(LPFC_NVME_INFO_MORE_STR, PAGE_SIZE - 1) + 1);
 	}
 
 	return len;
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index bb02fd8bc2dd..8274c7e75b89 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4414,7 +4414,7 @@ lpfc_nlp_state_name(char *buffer, size_t size, int state)
 	};
 
 	if (state < NLP_STE_MAX_STATE && states[state])
-		strlcpy(buffer, states[state], size);
+		strscpy(buffer, states[state], size);
 	else
 		snprintf(buffer, size, "unknown (%d)", state);
 	return buffer;
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 03d70138ad58..9eea2387806b 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -4702,7 +4702,7 @@ static void ncr_detach(struct ncb *np)
 	char inst_name[16];
 
 	/* Local copy so we don't access np after freeing it! */
-	strlcpy(inst_name, ncr_name(np), sizeof(inst_name));
+	strscpy(inst_name, ncr_name(np), sizeof(inst_name));
 
 	printk("%s: releasing host resources\n", ncr_name(np));
 
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 61fab01d2d52..1cb6d093399c 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -2596,7 +2596,7 @@ static int __qedi_probe(struct pci_dev *pdev, int mode)
 	sp_params.drv_minor = QEDI_DRIVER_MINOR_VER;
 	sp_params.drv_rev = QEDI_DRIVER_REV_VER;
 	sp_params.drv_eng = QEDI_DRIVER_ENG_VER;
-	strlcpy(sp_params.name, "qedi iSCSI", QED_DRV_VER_STR_SIZE);
+	strscpy(sp_params.name, "qedi iSCSI", QED_DRV_VER_STR_SIZE);
 	rc = qedi_ops->common->slowpath_start(qedi->cdev, &sp_params);
 	if (rc) {
 		QEDI_ERR(&qedi->dbg_ctx, "Cannot start slowpath\n");
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 898c70b8ebbf..9e10be918c2e 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4525,22 +4525,22 @@ qla2x00_set_model_info(scsi_qla_host_t *vha, uint8_t *model, size_t len,
 		if (use_tbl &&
 		    ha->pdev->subsystem_vendor == PCI_VENDOR_ID_QLOGIC &&
 		    index < QLA_MODEL_NAMES)
-			strlcpy(ha->model_desc,
-			    qla2x00_model_name[index * 2 + 1],
-			    sizeof(ha->model_desc));
+			strscpy(ha->model_desc,
+				qla2x00_model_name[index * 2 + 1],
+				sizeof(ha->model_desc));
 	} else {
 		index = (ha->pdev->subsystem_device & 0xff);
 		if (use_tbl &&
 		    ha->pdev->subsystem_vendor == PCI_VENDOR_ID_QLOGIC &&
 		    index < QLA_MODEL_NAMES) {
-			strlcpy(ha->model_number,
+			strscpy(ha->model_number,
 				qla2x00_model_name[index * 2],
 				sizeof(ha->model_number));
-			strlcpy(ha->model_desc,
-			    qla2x00_model_name[index * 2 + 1],
-			    sizeof(ha->model_desc));
+			strscpy(ha->model_desc,
+				qla2x00_model_name[index * 2 + 1],
+				sizeof(ha->model_desc));
 		} else {
-			strlcpy(ha->model_number, def,
+			strscpy(ha->model_number, def,
 				sizeof(ha->model_number));
 		}
 	}
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index ca7306685325..b2e31c8f9029 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -691,7 +691,7 @@ qlafx00_pci_info_str(struct scsi_qla_host *vha, char *str, size_t str_len)
 	struct qla_hw_data *ha = vha->hw;
 
 	if (pci_is_pcie(ha->pdev))
-		strlcpy(str, "PCIe iSA", str_len);
+		strscpy(str, "PCIe iSA", str_len);
 	return str;
 }
 
@@ -1872,21 +1872,21 @@ qlafx00_fx_disc(scsi_qla_host_t *vha, fc_port_t *fcport, uint16_t fx_type)
 			phost_info = &preg_hsi->hsi;
 			memset(preg_hsi, 0, sizeof(struct register_host_info));
 			phost_info->os_type = OS_TYPE_LINUX;
-			strlcpy(phost_info->sysname, p_sysid->sysname,
+			strscpy(phost_info->sysname, p_sysid->sysname,
 				sizeof(phost_info->sysname));
-			strlcpy(phost_info->nodename, p_sysid->nodename,
+			strscpy(phost_info->nodename, p_sysid->nodename,
 				sizeof(phost_info->nodename));
 			if (!strcmp(phost_info->nodename, "(none)"))
 				ha->mr.host_info_resend = true;
-			strlcpy(phost_info->release, p_sysid->release,
+			strscpy(phost_info->release, p_sysid->release,
 				sizeof(phost_info->release));
-			strlcpy(phost_info->version, p_sysid->version,
+			strscpy(phost_info->version, p_sysid->version,
 				sizeof(phost_info->version));
-			strlcpy(phost_info->machine, p_sysid->machine,
+			strscpy(phost_info->machine, p_sysid->machine,
 				sizeof(phost_info->machine));
-			strlcpy(phost_info->domainname, p_sysid->domainname,
+			strscpy(phost_info->domainname, p_sysid->domainname,
 				sizeof(phost_info->domainname));
-			strlcpy(phost_info->hostdriver, QLA2XXX_VERSION,
+			strscpy(phost_info->hostdriver, QLA2XXX_VERSION,
 				sizeof(phost_info->hostdriver));
 			preg_hsi->utc = (uint64_t)ktime_get_real_seconds();
 			ql_dbg(ql_dbg_init, vha, 0x0149,
@@ -1932,9 +1932,9 @@ qlafx00_fx_disc(scsi_qla_host_t *vha, fc_port_t *fcport, uint16_t fx_type)
 	if (fx_type == FXDISC_GET_CONFIG_INFO) {
 		struct config_info_data *pinfo =
 		    (struct config_info_data *) fdisc->u.fxiocb.rsp_addr;
-		strlcpy(vha->hw->model_number, pinfo->model_num,
+		strscpy(vha->hw->model_number, pinfo->model_num,
 			ARRAY_SIZE(vha->hw->model_number));
-		strlcpy(vha->hw->model_desc, pinfo->model_description,
+		strscpy(vha->hw->model_desc, pinfo->model_description,
 			ARRAY_SIZE(vha->hw->model_desc));
 		memcpy(&vha->hw->mr.symbolic_name, pinfo->symbolic_name,
 		    sizeof(vha->hw->mr.symbolic_name));
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 17b719a8b6fb..52a1f73cf48b 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -1611,8 +1611,8 @@ int qla4xxx_get_chap(struct scsi_qla_host *ha, char *username, char *password,
 		goto exit_get_chap;
 	}
 
-	strlcpy(password, chap_table->secret, QL4_CHAP_MAX_SECRET_LEN);
-	strlcpy(username, chap_table->name, QL4_CHAP_MAX_NAME_LEN);
+	strscpy(password, chap_table->secret, QL4_CHAP_MAX_SECRET_LEN);
+	strscpy(username, chap_table->name, QL4_CHAP_MAX_NAME_LEN);
 	chap_table->cookie = __constant_cpu_to_le16(CHAP_VALID_COOKIE);
 
 exit_get_chap:
@@ -1732,8 +1732,8 @@ int qla4xxx_get_uni_chap_at_index(struct scsi_qla_host *ha, char *username,
 		goto exit_unlock_uni_chap;
 	}
 
-	strlcpy(password, chap_table->secret, MAX_CHAP_SECRET_LEN);
-	strlcpy(username, chap_table->name, MAX_CHAP_NAME_LEN);
+	strscpy(password, chap_table->secret, MAX_CHAP_SECRET_LEN);
+	strscpy(username, chap_table->name, MAX_CHAP_NAME_LEN);
 
 	rval = QLA_SUCCESS;
 
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 2c23b692e318..fd65580759cb 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -800,9 +800,9 @@ static int qla4xxx_get_chap_list(struct Scsi_Host *shost, uint16_t chap_tbl_idx,
 			continue;
 
 		chap_rec->chap_tbl_idx = i;
-		strlcpy(chap_rec->username, chap_table->name,
+		strscpy(chap_rec->username, chap_table->name,
 			ISCSI_CHAP_AUTH_NAME_MAX_LEN);
-		strlcpy(chap_rec->password, chap_table->secret,
+		strscpy(chap_rec->password, chap_table->secret,
 			QL4_CHAP_MAX_SECRET_LEN);
 		chap_rec->password_length = chap_table->secret_len;
 
@@ -6059,8 +6059,8 @@ static int qla4xxx_get_bidi_chap(struct scsi_qla_host *ha, char *username,
 		if (!(chap_table->flags & BIT_6)) /* Not BIDI */
 			continue;
 
-		strlcpy(password, chap_table->secret, QL4_CHAP_MAX_SECRET_LEN);
-		strlcpy(username, chap_table->name, QL4_CHAP_MAX_NAME_LEN);
+		strscpy(password, chap_table->secret, QL4_CHAP_MAX_SECRET_LEN);
+		strscpy(username, chap_table->name, QL4_CHAP_MAX_NAME_LEN);
 		ret = 0;
 		break;
 	}
@@ -6288,8 +6288,8 @@ static void qla4xxx_get_param_ddb(struct ddb_entry *ddb_entry,
 
 	tddb->tpgt = sess->tpgt;
 	tddb->port = conn->persistent_port;
-	strlcpy(tddb->iscsi_name, sess->targetname, ISCSI_NAME_SIZE);
-	strlcpy(tddb->ip_addr, conn->persistent_address, DDB_IPADDR_LEN);
+	strscpy(tddb->iscsi_name, sess->targetname, ISCSI_NAME_SIZE);
+	strscpy(tddb->ip_addr, conn->persistent_address, DDB_IPADDR_LEN);
 }
 
 static void qla4xxx_convert_param_ddb(struct dev_db_entry *fw_ddb_entry,
@@ -7792,7 +7792,7 @@ static int qla4xxx_sysfs_ddb_logout(struct iscsi_bus_flash_session *fnode_sess,
 		goto exit_ddb_logout;
 	}
 
-	strlcpy(flash_tddb->iscsi_name, fnode_sess->targetname,
+	strscpy(flash_tddb->iscsi_name, fnode_sess->targetname,
 		ISCSI_NAME_SIZE);
 
 	if (!strncmp(fnode_sess->portal_type, PORTAL_TYPE_IPV6, 4))
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 9d0229656681..b035ade91bd5 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6242,7 +6242,7 @@ static ssize_t pqi_lockup_action_store(struct device *dev,
 	char *action_name;
 	char action_name_buffer[32];
 
-	strlcpy(action_name_buffer, buffer, sizeof(action_name_buffer));
+	strscpy(action_name_buffer, buffer, sizeof(action_name_buffer));
 	action_name = strstrip(action_name_buffer);
 
 	for (i = 0; i < ARRAY_SIZE(pqi_lockup_actions); i++) {
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index d9a045f9858c..830cdb9555e0 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -1291,7 +1291,7 @@ static struct Scsi_Host *sym_attach(struct scsi_host_template *tpnt, int unit,
 	/*
 	 *  Edit its name.
 	 */
-	strlcpy(np->s.chip_name, dev->chip.name, sizeof(np->s.chip_name));
+	strscpy(np->s.chip_name, dev->chip.name, sizeof(np->s.chip_name));
 	sprintf(np->s.inst_name, "sym%d", np->s.unit);
 
 	if ((SYM_CONF_DMA_ADDRESSING_MODE > 0) && (np->features & FE_DAC) &&
diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index f9d6ef356540..6f1b40ae70f7 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -954,7 +954,7 @@ static char android_boot_dev[ANDROID_BOOT_DEV_MAX];
 #ifndef MODULE
 static int __init get_android_boot_dev(char *str)
 {
-	strlcpy(android_boot_dev, str, ANDROID_BOOT_DEV_MAX);
+	strscpy(android_boot_dev, str, ANDROID_BOOT_DEV_MAX);
 	return 1;
 }
 __setup("androidboot.bootdevice=", get_android_boot_dev);
diff --git a/drivers/soc/fsl/qe/qe.c b/drivers/soc/fsl/qe/qe.c
index 2df20d6f85fa..eeab872cc37d 100644
--- a/drivers/soc/fsl/qe/qe.c
+++ b/drivers/soc/fsl/qe/qe.c
@@ -524,7 +524,8 @@ int qe_upload_firmware(const struct qe_firmware *firmware)
 	 * saved microcode information and put in the new.
 	 */
 	memset(&qe_firmware_info, 0, sizeof(qe_firmware_info));
-	strlcpy(qe_firmware_info.id, firmware->id, sizeof(qe_firmware_info.id));
+	strscpy(qe_firmware_info.id, firmware->id,
+		sizeof(qe_firmware_info.id));
 	qe_firmware_info.extended_modes = be64_to_cpu(firmware->extended_modes);
 	memcpy(qe_firmware_info.vtraps, firmware->vtraps,
 		sizeof(firmware->vtraps));
@@ -599,7 +600,7 @@ struct qe_firmware_info *qe_get_firmware_info(void)
 	/* Copy the data into qe_firmware_info*/
 	sprop = of_get_property(fw, "id", NULL);
 	if (sprop)
-		strlcpy(qe_firmware_info.id, sprop,
+		strscpy(qe_firmware_info.id, sprop,
 			sizeof(qe_firmware_info.id));
 
 	of_property_read_u64(fw, "extended-modes",
diff --git a/drivers/soc/qcom/smp2p.c b/drivers/soc/qcom/smp2p.c
index 07183d731d74..766d0dfdbef8 100644
--- a/drivers/soc/qcom/smp2p.c
+++ b/drivers/soc/qcom/smp2p.c
@@ -346,7 +346,7 @@ static int qcom_smp2p_outbound_entry(struct qcom_smp2p *smp2p,
 	char buf[SMP2P_MAX_ENTRY_NAME] = {};
 
 	/* Allocate an entry from the smem item */
-	strlcpy(buf, entry->name, SMP2P_MAX_ENTRY_NAME);
+	strscpy(buf, entry->name, SMP2P_MAX_ENTRY_NAME);
 	memcpy(out->entries[out->valid_entries].name, buf, SMP2P_MAX_ENTRY_NAME);
 
 	/* Make the logical entry reference the physical value */
diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index fc9a59788d2e..f2d7ebeeb653 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -662,7 +662,7 @@ struct spi_device *spi_new_device(struct spi_controller *ctlr,
 	proxy->max_speed_hz = chip->max_speed_hz;
 	proxy->mode = chip->mode;
 	proxy->irq = chip->irq;
-	strlcpy(proxy->modalias, chip->modalias, sizeof(proxy->modalias));
+	strscpy(proxy->modalias, chip->modalias, sizeof(proxy->modalias));
 	proxy->dev.platform_data = (void *) chip->platform_data;
 	proxy->controller_data = chip->controller_data;
 	proxy->controller_state = NULL;
@@ -2349,7 +2349,7 @@ static ssize_t slave_store(struct device *dev, struct device_attribute *attr,
 		if (!spi)
 			return -ENOMEM;
 
-		strlcpy(spi->modalias, name, sizeof(spi->modalias));
+		strscpy(spi->modalias, name, sizeof(spi->modalias));
 
 		rc = spi_add_device(spi);
 		if (rc) {
diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index d99231c737fb..f55857f0ea62 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -939,8 +939,8 @@ static int do_devinfo_ioctl(struct comedi_device *dev,
 	/* fill devinfo structure */
 	devinfo.version_code = COMEDI_VERSION_CODE;
 	devinfo.n_subdevs = dev->n_subdevices;
-	strlcpy(devinfo.driver_name, dev->driver->driver_name, COMEDI_NAMELEN);
-	strlcpy(devinfo.board_name, dev->board_name, COMEDI_NAMELEN);
+	strscpy(devinfo.driver_name, dev->driver->driver_name, COMEDI_NAMELEN);
+	strscpy(devinfo.board_name, dev->board_name, COMEDI_NAMELEN);
 
 	s = comedi_file_read_subdevice(file);
 	if (s)
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw-ethtool.c b/drivers/staging/fsl-dpaa2/ethsw/ethsw-ethtool.c
index ace4a6d28562..6dc4a9e1707a 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw-ethtool.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw-ethtool.c
@@ -36,19 +36,19 @@ static void dpaa2_switch_get_drvinfo(struct net_device *netdev,
 	u16 version_major, version_minor;
 	int err;
 
-	strlcpy(drvinfo->driver, KBUILD_MODNAME, sizeof(drvinfo->driver));
+	strscpy(drvinfo->driver, KBUILD_MODNAME, sizeof(drvinfo->driver));
 
 	err = dpsw_get_api_version(port_priv->ethsw_data->mc_io, 0,
 				   &version_major,
 				   &version_minor);
 	if (err)
-		strlcpy(drvinfo->fw_version, "N/A",
+		strscpy(drvinfo->fw_version, "N/A",
 			sizeof(drvinfo->fw_version));
 	else
 		snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 			 "%u.%u", version_major, version_minor);
 
-	strlcpy(drvinfo->bus_info, dev_name(netdev->dev.parent->parent),
+	strscpy(drvinfo->bus_info, dev_name(netdev->dev.parent->parent),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/staging/greybus/audio_helper.c b/drivers/staging/greybus/audio_helper.c
index 237531ba60f3..4334b4775d1b 100644
--- a/drivers/staging/greybus/audio_helper.c
+++ b/drivers/staging/greybus/audio_helper.c
@@ -165,7 +165,7 @@ static int gbaudio_remove_controls(struct snd_card *card, struct device *dev,
 			snprintf(id.name, sizeof(id.name), "%s %s", prefix,
 				 control->name);
 		else
-			strlcpy(id.name, control->name, sizeof(id.name));
+			strscpy(id.name, control->name, sizeof(id.name));
 		id.numid = 0;
 		id.iface = control->iface;
 		id.device = control->device;
diff --git a/drivers/staging/greybus/audio_module.c b/drivers/staging/greybus/audio_module.c
index c52c4f361b90..bdf0f4b104f4 100644
--- a/drivers/staging/greybus/audio_module.c
+++ b/drivers/staging/greybus/audio_module.c
@@ -342,7 +342,7 @@ static int gb_audio_probe(struct gb_bundle *bundle,
 	/* inform above layer for uevent */
 	dev_dbg(dev, "Inform set_event:%d to above layer\n", 1);
 	/* prepare for the audio manager */
-	strlcpy(desc.name, gbmodule->name, GB_AUDIO_MANAGER_MODULE_NAME_LEN);
+	strscpy(desc.name, gbmodule->name, GB_AUDIO_MANAGER_MODULE_NAME_LEN);
 	desc.vid = 2; /* todo */
 	desc.pid = 3; /* todo */
 	desc.intf_id = gbmodule->dev_id;
diff --git a/drivers/staging/greybus/audio_topology.c b/drivers/staging/greybus/audio_topology.c
index 662e3e8b4b63..e816e4db555e 100644
--- a/drivers/staging/greybus/audio_topology.c
+++ b/drivers/staging/greybus/audio_topology.c
@@ -200,7 +200,7 @@ static int gbcodec_mixer_ctl_info(struct snd_kcontrol *kcontrol,
 			return -EINVAL;
 		name = gbaudio_map_controlid(module, data->ctl_id,
 					     uinfo->value.enumerated.item);
-		strlcpy(uinfo->value.enumerated.name, name, NAME_SIZE);
+		strscpy(uinfo->value.enumerated.name, name, NAME_SIZE);
 		break;
 	default:
 		dev_err(comp->dev, "Invalid type: %d for %s:kcontrol\n",
@@ -1047,7 +1047,7 @@ static int gbaudio_tplg_create_widget(struct gbaudio_module_info *module,
 	}
 
 	/* Prefix dev_id to widget control_name */
-	strlcpy(temp_name, w->name, NAME_SIZE);
+	strscpy(temp_name, w->name, NAME_SIZE);
 	snprintf(w->name, NAME_SIZE, "GB %d %s", module->dev_id, temp_name);
 
 	switch (w->type) {
@@ -1169,7 +1169,7 @@ static int gbaudio_tplg_process_kcontrols(struct gbaudio_module_info *module,
 		}
 		control->id = curr->id;
 		/* Prefix dev_id to widget_name */
-		strlcpy(temp_name, curr->name, NAME_SIZE);
+		strscpy(temp_name, curr->name, NAME_SIZE);
 		snprintf(curr->name, NAME_SIZE, "GB %d %s", module->dev_id,
 			 temp_name);
 		control->name = curr->name;
diff --git a/drivers/staging/greybus/power_supply.c b/drivers/staging/greybus/power_supply.c
index ec96f28887f9..75cb170e05fb 100644
--- a/drivers/staging/greybus/power_supply.c
+++ b/drivers/staging/greybus/power_supply.c
@@ -449,7 +449,7 @@ static int __gb_power_supply_set_name(char *init_name, char *name, size_t len)
 
 	if (!strlen(init_name))
 		init_name = "gb_power_supply";
-	strlcpy(name, init_name, len);
+	strscpy(name, init_name, len);
 
 	while ((ret < len) && (psy = power_supply_get_by_name(name))) {
 		power_supply_put(psy);
diff --git a/drivers/staging/greybus/spilib.c b/drivers/staging/greybus/spilib.c
index fc27c52de74a..672d540d3365 100644
--- a/drivers/staging/greybus/spilib.c
+++ b/drivers/staging/greybus/spilib.c
@@ -455,10 +455,10 @@ static int gb_spi_setup_device(struct gb_spilib *spi, u8 cs)
 	dev_type = response.device_type;
 
 	if (dev_type == GB_SPI_SPI_DEV)
-		strlcpy(spi_board.modalias, "spidev",
+		strscpy(spi_board.modalias, "spidev",
 			sizeof(spi_board.modalias));
 	else if (dev_type == GB_SPI_SPI_NOR)
-		strlcpy(spi_board.modalias, "spi-nor",
+		strscpy(spi_board.modalias, "spi-nor",
 			sizeof(spi_board.modalias));
 	else if (dev_type == GB_SPI_SPI_MODALIAS)
 		memcpy(spi_board.modalias, response.name,
diff --git a/drivers/staging/most/sound/sound.c b/drivers/staging/most/sound/sound.c
index 8a449ab9bdce..9d5bb0fff7e4 100644
--- a/drivers/staging/most/sound/sound.c
+++ b/drivers/staging/most/sound/sound.c
@@ -535,7 +535,7 @@ static int audio_probe_channel(struct most_interface *iface, int channel_id,
 		pr_err("Incompatible channel type\n");
 		return -EINVAL;
 	}
-	strlcpy(arg_list_cpy, arg_list, STRING_SIZE);
+	strscpy(arg_list_cpy, arg_list, STRING_SIZE);
 	ret = split_arg_list(arg_list_cpy, &ch_num, &sample_res);
 	if (ret < 0)
 		return ret;
diff --git a/drivers/staging/most/video/video.c b/drivers/staging/most/video/video.c
index 829df899b993..90933d78c332 100644
--- a/drivers/staging/most/video/video.c
+++ b/drivers/staging/most/video/video.c
@@ -245,8 +245,8 @@ static int vidioc_querycap(struct file *file, void *priv,
 	struct comp_fh *fh = priv;
 	struct most_video_dev *mdev = fh->mdev;
 
-	strlcpy(cap->driver, "v4l2_component", sizeof(cap->driver));
-	strlcpy(cap->card, "MOST", sizeof(cap->card));
+	strscpy(cap->driver, "v4l2_component", sizeof(cap->driver));
+	strscpy(cap->card, "MOST", sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info),
 		 "%s", mdev->iface->description);
 	return 0;
@@ -483,7 +483,7 @@ static int comp_probe_channel(struct most_interface *iface, int channel_idx,
 	mdev->v4l2_dev.release = comp_v4l2_dev_release;
 
 	/* Create the v4l2_device */
-	strlcpy(mdev->v4l2_dev.name, name, sizeof(mdev->v4l2_dev.name));
+	strscpy(mdev->v4l2_dev.name, name, sizeof(mdev->v4l2_dev.name));
 	ret = v4l2_device_register(NULL, &mdev->v4l2_dev);
 	if (ret) {
 		pr_err("v4l2_device_register() failed\n");
diff --git a/drivers/staging/nvec/nvec_ps2.c b/drivers/staging/nvec/nvec_ps2.c
index 45db29262a9c..157009015c3b 100644
--- a/drivers/staging/nvec/nvec_ps2.c
+++ b/drivers/staging/nvec/nvec_ps2.c
@@ -112,8 +112,8 @@ static int nvec_mouse_probe(struct platform_device *pdev)
 	ser_dev->start = ps2_startstreaming;
 	ser_dev->stop = ps2_stopstreaming;
 
-	strlcpy(ser_dev->name, "nvec mouse", sizeof(ser_dev->name));
-	strlcpy(ser_dev->phys, "nvec", sizeof(ser_dev->phys));
+	strscpy(ser_dev->name, "nvec mouse", sizeof(ser_dev->name));
+	strscpy(ser_dev->phys, "nvec", sizeof(ser_dev->phys));
 
 	ps2_dev.ser_dev = ser_dev;
 	ps2_dev.notifier.notifier_call = nvec_ps2_notifier;
diff --git a/drivers/staging/octeon/ethernet-mdio.c b/drivers/staging/octeon/ethernet-mdio.c
index 0bf545849b11..1bb91a904afc 100644
--- a/drivers/staging/octeon/ethernet-mdio.c
+++ b/drivers/staging/octeon/ethernet-mdio.c
@@ -21,9 +21,9 @@
 static void cvm_oct_get_drvinfo(struct net_device *dev,
 				struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
-	strlcpy(info->version, UTS_RELEASE, sizeof(info->version));
-	strlcpy(info->bus_info, "Builtin", sizeof(info->bus_info));
+	strscpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
+	strscpy(info->version, UTS_RELEASE, sizeof(info->version));
+	strscpy(info->bus_info, "Builtin", sizeof(info->bus_info));
 }
 
 static int cvm_oct_nway_reset(struct net_device *dev)
diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index a0d6d90f4cc8..e9436a2d9d24 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -576,7 +576,7 @@ static struct notifier_block dcon_panic_nb = {
 
 static int dcon_detect(struct i2c_client *client, struct i2c_board_info *info)
 {
-	strlcpy(info->type, "olpc_dcon", I2C_NAME_SIZE);
+	strscpy(info->type, "olpc_dcon", I2C_NAME_SIZE);
 
 	return 0;
 }
diff --git a/drivers/staging/qlge/qlge_ethtool.c b/drivers/staging/qlge/qlge_ethtool.c
index d44b2dae9213..f1a853ce2442 100644
--- a/drivers/staging/qlge/qlge_ethtool.c
+++ b/drivers/staging/qlge/qlge_ethtool.c
@@ -416,15 +416,15 @@ static void ql_get_drvinfo(struct net_device *ndev,
 {
 	struct ql_adapter *qdev = netdev_priv(ndev);
 
-	strlcpy(drvinfo->driver, qlge_driver_name, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, qlge_driver_version,
+	strscpy(drvinfo->driver, qlge_driver_name, sizeof(drvinfo->driver));
+	strscpy(drvinfo->version, qlge_driver_version,
 		sizeof(drvinfo->version));
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 		 "v%d.%d.%d",
 		 (qdev->fw_rev_id & 0x00ff0000) >> 16,
 		 (qdev->fw_rev_id & 0x0000ff00) >> 8,
 		 (qdev->fw_rev_id & 0x000000ff));
-	strlcpy(drvinfo->bus_info, pci_name(qdev->pdev),
+	strscpy(drvinfo->bus_info, pci_name(qdev->pdev),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
index 8e10462f1fbe..da5a055f5841 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -1876,7 +1876,7 @@ static int rtw_wx_set_enc_ext(struct net_device *dev,
 		goto exit;
 	}
 
-	strlcpy((char *)param->u.crypt.alg, alg_name, IEEE_CRYPT_ALG_NAME_LEN);
+	strscpy((char *)param->u.crypt.alg, alg_name, IEEE_CRYPT_ALG_NAME_LEN);
 
 	if (pext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY)
 		param->u.crypt.set_tx = 1;
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_ethtool.c b/drivers/staging/rtl8192e/rtl8192e/rtl_ethtool.c
index 6ae7a67e767f..f4f7b74c8cd1 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_ethtool.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_ethtool.c
@@ -18,9 +18,9 @@ static void _rtl92e_ethtool_get_drvinfo(struct net_device *dev,
 {
 	struct r8192_priv *priv = rtllib_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(priv->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(priv->pdev), sizeof(info->bus_info));
 }
 
 static u32 _rtl92e_ethtool_get_link(struct net_device *dev)
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c
index f434a26cdb2f..afa92ddfa005 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c
@@ -484,7 +484,7 @@ int ieee80211_wx_get_name(struct ieee80211_device *ieee,
 			     struct iw_request_info *info,
 			     union iwreq_data *wrqu, char *extra)
 {
-	strlcpy(wrqu->name, "802.11", IFNAMSIZ);
+	strscpy(wrqu->name, "802.11", IFNAMSIZ);
 	if (ieee->modulation & IEEE80211_CCK_MODULATION) {
 		strlcat(wrqu->name, "b", IFNAMSIZ);
 		if (ieee->modulation & IEEE80211_OFDM_MODULATION)
diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
index cbaa7a489748..81de5a9e6b67 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -1784,7 +1784,7 @@ static int r871x_wx_set_enc_ext(struct net_device *dev,
 		return -ENOMEM;
 	param->cmd = IEEE_CMD_SET_ENCRYPTION;
 	eth_broadcast_addr(param->sta_addr);
-	strlcpy((char *)param->u.crypt.alg, alg_name, IEEE_CRYPT_ALG_NAME_LEN);
+	strscpy((char *)param->u.crypt.alg, alg_name, IEEE_CRYPT_ALG_NAME_LEN);
 	if (pext->ext_flags & IW_ENCODE_EXT_GROUP_KEY)
 		param->u.crypt.set_tx = 0;
 	if (pext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY)
diff --git a/drivers/staging/sm750fb/sm750.c b/drivers/staging/sm750fb/sm750.c
index 029f0d09e966..c237a8f8eb59 100644
--- a/drivers/staging/sm750fb/sm750.c
+++ b/drivers/staging/sm750fb/sm750.c
@@ -814,7 +814,7 @@ static int lynxfb_set_fbinfo(struct fb_info *info, int index)
 	fix->ywrapstep = crtc->ywrapstep;
 	fix->accel = FB_ACCEL_SMI;
 
-	strlcpy(fix->id, fixId[index], sizeof(fix->id));
+	strscpy(fix->id, fixId[index], sizeof(fix->id));
 
 	fix->smem_start = crtc->oScreen + sm750_dev->vidmem_start;
 	pr_info("fix->smem_start = %lx\n", fix->smem_start);
diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index 7a461fbb1566..f4e36f6106ee 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -726,8 +726,8 @@ static int iscsi_add_notunderstood_response(
 	}
 	INIT_LIST_HEAD(&extra_response->er_list);
 
-	strlcpy(extra_response->key, key, sizeof(extra_response->key));
-	strlcpy(extra_response->value, NOTUNDERSTOOD,
+	strscpy(extra_response->key, key, sizeof(extra_response->key));
+	strscpy(extra_response->value, NOTUNDERSTOOD,
 		sizeof(extra_response->value));
 
 	list_add_tail(&extra_response->er_list,
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 45ba07c6ec27..eb47d9170c53 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -1337,9 +1337,9 @@ void iscsit_collect_login_stats(
 		if (conn->param_list)
 			intrname = iscsi_find_param_from_key(INITIATORNAME,
 							     conn->param_list);
-		strlcpy(ls->last_intr_fail_name,
-		       (intrname ? intrname->value : "Unknown"),
-		       sizeof(ls->last_intr_fail_name));
+		strscpy(ls->last_intr_fail_name,
+			(intrname ? intrname->value : "Unknown"),
+			sizeof(ls->last_intr_fail_name));
 
 		ls->last_intr_fail_ip_family = conn->login_family;
 
@@ -1376,9 +1376,9 @@ void iscsit_fill_cxn_timeout_err_stats(struct iscsi_session *sess)
 		return;
 
 	spin_lock_bh(&tiqn->sess_err_stats.lock);
-	strlcpy(tiqn->sess_err_stats.last_sess_fail_rem_name,
-			sess->sess_ops->InitiatorName,
-			sizeof(tiqn->sess_err_stats.last_sess_fail_rem_name));
+	strscpy(tiqn->sess_err_stats.last_sess_fail_rem_name,
+		sess->sess_ops->InitiatorName,
+		sizeof(tiqn->sess_err_stats.last_sess_fail_rem_name));
 	tiqn->sess_err_stats.last_sess_failure_type =
 			ISCSI_SESS_ERR_CXN_TIMEOUT;
 	tiqn->sess_err_stats.cxn_timeout_errors++;
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 676215cd8847..46b3b7b54507 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -618,7 +618,7 @@ static void dev_set_t10_wwn_model_alias(struct se_device *dev)
 	 * here without potentially breaking existing setups, so continue to
 	 * truncate one byte shorter than what can be carried in INQUIRY.
 	 */
-	strlcpy(dev->t10_wwn.model, configname, INQUIRY_MODEL_LEN);
+	strscpy(dev->t10_wwn.model, configname, INQUIRY_MODEL_LEN);
 }
 
 static ssize_t emulate_model_alias_store(struct config_item *item,
@@ -644,7 +644,7 @@ static ssize_t emulate_model_alias_store(struct config_item *item,
 	if (flag) {
 		dev_set_t10_wwn_model_alias(dev);
 	} else {
-		strlcpy(dev->t10_wwn.model, dev->transport->inquiry_prod,
+		strscpy(dev->t10_wwn.model, dev->transport->inquiry_prod,
 			sizeof(dev->t10_wwn.model));
 	}
 	da->emulate_model_alias = flag;
@@ -1354,7 +1354,7 @@ static ssize_t target_wwn_vendor_id_store(struct config_item *item,
 	}
 
 	BUILD_BUG_ON(sizeof(dev->t10_wwn.vendor) != INQUIRY_VENDOR_LEN + 1);
-	strlcpy(dev->t10_wwn.vendor, stripped, sizeof(dev->t10_wwn.vendor));
+	strscpy(dev->t10_wwn.vendor, stripped, sizeof(dev->t10_wwn.vendor));
 
 	pr_debug("Target_Core_ConfigFS: Set emulated T10 Vendor Identification:"
 		 " %s\n", dev->t10_wwn.vendor);
@@ -1405,7 +1405,7 @@ static ssize_t target_wwn_product_id_store(struct config_item *item,
 	}
 
 	BUILD_BUG_ON(sizeof(dev->t10_wwn.model) != INQUIRY_MODEL_LEN + 1);
-	strlcpy(dev->t10_wwn.model, stripped, sizeof(dev->t10_wwn.model));
+	strscpy(dev->t10_wwn.model, stripped, sizeof(dev->t10_wwn.model));
 
 	pr_debug("Target_Core_ConfigFS: Set emulated T10 Model Identification: %s\n",
 		 dev->t10_wwn.model);
@@ -1456,7 +1456,8 @@ static ssize_t target_wwn_revision_store(struct config_item *item,
 	}
 
 	BUILD_BUG_ON(sizeof(dev->t10_wwn.revision) != INQUIRY_REVISION_LEN + 1);
-	strlcpy(dev->t10_wwn.revision, stripped, sizeof(dev->t10_wwn.revision));
+	strscpy(dev->t10_wwn.revision, stripped,
+		sizeof(dev->t10_wwn.revision));
 
 	pr_debug("Target_Core_ConfigFS: Set emulated T10 Revision: %s\n",
 		 dev->t10_wwn.revision);
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 405d82d44717..5b0f1842bbe8 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -798,10 +798,10 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	xcopy_lun->lun_tpg = &xcopy_pt_tpg;
 
 	/* Preload the default INQUIRY const values */
-	strlcpy(dev->t10_wwn.vendor, "LIO-ORG", sizeof(dev->t10_wwn.vendor));
-	strlcpy(dev->t10_wwn.model, dev->transport->inquiry_prod,
+	strscpy(dev->t10_wwn.vendor, "LIO-ORG", sizeof(dev->t10_wwn.vendor));
+	strscpy(dev->t10_wwn.model, dev->transport->inquiry_prod,
 		sizeof(dev->t10_wwn.model));
-	strlcpy(dev->t10_wwn.revision, dev->transport->inquiry_rev,
+	strscpy(dev->t10_wwn.revision, dev->transport->inquiry_rev,
 		sizeof(dev->t10_wwn.revision));
 
 	return dev;
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 590e6d072228..bb47dcc8295c 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2559,14 +2559,14 @@ static ssize_t tcmu_dev_config_store(struct config_item *item, const char *page,
 			pr_err("Unable to reconfigure device\n");
 			return ret;
 		}
-		strlcpy(udev->dev_config, page, TCMU_CONFIG_LEN);
+		strscpy(udev->dev_config, page, TCMU_CONFIG_LEN);
 
 		ret = tcmu_update_uio_info(udev);
 		if (ret)
 			return ret;
 		return count;
 	}
-	strlcpy(udev->dev_config, page, TCMU_CONFIG_LEN);
+	strscpy(udev->dev_config, page, TCMU_CONFIG_LEN);
 
 	return count;
 }
diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index c6d74bc1c90b..6da02752cfa8 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1111,7 +1111,7 @@ __thermal_cooling_device_register(struct device_node *np,
 	}
 
 	cdev->id = result;
-	strlcpy(cdev->type, type ? : "", sizeof(cdev->type));
+	strscpy(cdev->type, type ? : "", sizeof(cdev->type));
 	mutex_init(&cdev->lock);
 	INIT_LIST_HEAD(&cdev->thermal_instances);
 	cdev->np = np;
@@ -1422,7 +1422,7 @@ thermal_zone_device_register(const char *type, int trips, int mask,
 	}
 
 	tz->id = id;
-	strlcpy(tz->type, type, sizeof(tz->type));
+	strscpy(tz->type, type, sizeof(tz->type));
 	tz->ops = ops;
 	tz->tzp = tzp;
 	tz->device.class = &thermal_class;
diff --git a/drivers/thermal/thermal_hwmon.c b/drivers/thermal/thermal_hwmon.c
index 8b92e00ff236..35b31d82f97f 100644
--- a/drivers/thermal/thermal_hwmon.c
+++ b/drivers/thermal/thermal_hwmon.c
@@ -147,7 +147,7 @@ int thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&hwmon->tz_list);
-	strlcpy(hwmon->type, tz->type, THERMAL_NAME_LENGTH);
+	strscpy(hwmon->type, tz->type, THERMAL_NAME_LENGTH);
 	strreplace(hwmon->type, '-', '_');
 	hwmon->device = hwmon_device_register_with_info(&tz->device, hwmon->type,
 							hwmon, NULL, NULL);
diff --git a/drivers/tty/hvc/hvcs.c b/drivers/tty/hvc/hvcs.c
index 509d1042825a..62e7d31e3937 100644
--- a/drivers/tty/hvc/hvcs.c
+++ b/drivers/tty/hvc/hvcs.c
@@ -869,7 +869,7 @@ static void hvcs_set_pi(struct hvcs_partner_info *pi, struct hvcs_struct *hvcsd)
 	hvcsd->p_partition_ID  = pi->partition_ID;
 
 	/* copy the null-term char too */
-	strlcpy(hvcsd->p_location_code, pi->location_code,
+	strscpy(hvcsd->p_location_code, pi->location_code,
 		sizeof(hvcsd->p_location_code));
 }
 
diff --git a/drivers/tty/serial/earlycon.c b/drivers/tty/serial/earlycon.c
index b70877932d47..d4dc36a6ff9b 100644
--- a/drivers/tty/serial/earlycon.c
+++ b/drivers/tty/serial/earlycon.c
@@ -67,7 +67,7 @@ static void __init earlycon_init(struct earlycon_device *device,
 	if (*s)
 		earlycon->index = simple_strtoul(s, NULL, 10);
 	len = s - name;
-	strlcpy(earlycon->name, name, min(len + 1, sizeof(earlycon->name)));
+	strscpy(earlycon->name, name, min(len + 1, sizeof(earlycon->name)));
 	earlycon->data = &early_console_dev;
 }
 
@@ -123,7 +123,7 @@ static int __init parse_options(struct earlycon_device *device, char *options)
 		device->baud = simple_strtoul(options, NULL, 0);
 		length = min(strcspn(options, " ") + 1,
 			     (size_t)(sizeof(device->options)));
-		strlcpy(device->options, options, length);
+		strscpy(device->options, options, length);
 	}
 
 	return 0;
@@ -303,7 +303,7 @@ int __init of_setup_earlycon(const struct earlycon_id *match,
 
 	if (options) {
 		early_console_dev.baud = simple_strtoul(options, NULL, 0);
-		strlcpy(early_console_dev.options, options,
+		strscpy(early_console_dev.options, options,
 			sizeof(early_console_dev.options));
 	}
 	earlycon_init(&early_console_dev, match->name);
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index f41cba10b86b..616e0591eb1a 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2328,7 +2328,7 @@ uart_report_port(struct uart_driver *drv, struct uart_port *port)
 			 "MMIO 0x%llx", (unsigned long long)port->mapbase);
 		break;
 	default:
-		strlcpy(address, "*unknown*", sizeof(address));
+		strscpy(address, "*unknown*", sizeof(address));
 		break;
 	}
 
diff --git a/drivers/tty/serial/sunsu.c b/drivers/tty/serial/sunsu.c
index 319e5ceb6130..f6500295cd7d 100644
--- a/drivers/tty/serial/sunsu.c
+++ b/drivers/tty/serial/sunsu.c
@@ -1222,13 +1222,13 @@ static int sunsu_kbd_ms_init(struct uart_sunsu_port *up)
 	serio->id.type = SERIO_RS232;
 	if (up->su_type == SU_PORT_KBD) {
 		serio->id.proto = SERIO_SUNKBD;
-		strlcpy(serio->name, "sukbd", sizeof(serio->name));
+		strscpy(serio->name, "sukbd", sizeof(serio->name));
 	} else {
 		serio->id.proto = SERIO_SUN;
 		serio->id.extra = 1;
-		strlcpy(serio->name, "sums", sizeof(serio->name));
+		strscpy(serio->name, "sums", sizeof(serio->name));
 	}
-	strlcpy(serio->phys,
+	strscpy(serio->phys,
 		(!(up->port.line & 1) ? "su/serio0" : "su/serio1"),
 		sizeof(serio->phys));
 
diff --git a/drivers/tty/serial/sunzilog.c b/drivers/tty/serial/sunzilog.c
index 001e19d7c17d..579dc49de9c2 100644
--- a/drivers/tty/serial/sunzilog.c
+++ b/drivers/tty/serial/sunzilog.c
@@ -1307,15 +1307,14 @@ static void sunzilog_register_serio(struct uart_sunzilog_port *up)
 	serio->id.type = SERIO_RS232;
 	if (up->flags & SUNZILOG_FLAG_CONS_KEYB) {
 		serio->id.proto = SERIO_SUNKBD;
-		strlcpy(serio->name, "zskbd", sizeof(serio->name));
+		strscpy(serio->name, "zskbd", sizeof(serio->name));
 	} else {
 		serio->id.proto = SERIO_SUN;
 		serio->id.extra = 1;
-		strlcpy(serio->name, "zsms", sizeof(serio->name));
+		strscpy(serio->name, "zsms", sizeof(serio->name));
 	}
-	strlcpy(serio->phys,
-		((up->flags & SUNZILOG_FLAG_CONS_KEYB) ?
-		 "zs/serio0" : "zs/serio1"),
+	strscpy(serio->phys,
+		((up->flags & SUNZILOG_FLAG_CONS_KEYB) ? "zs/serio0" : "zs/serio1"),
 		sizeof(serio->phys));
 
 	serio->write = sunzilog_serio_write;
diff --git a/drivers/usb/atm/usbatm.c b/drivers/usb/atm/usbatm.c
index 56fe30d247da..b151a2a71f56 100644
--- a/drivers/usb/atm/usbatm.c
+++ b/drivers/usb/atm/usbatm.c
@@ -1024,7 +1024,7 @@ int usbatm_usb_probe(struct usb_interface *intf, const struct usb_device_id *id,
 	/* public fields */
 
 	instance->driver = driver;
-	strlcpy(instance->driver_name, driver->driver_name,
+	strscpy(instance->driver_name, driver->driver_name,
 		sizeof(instance->driver_name));
 
 	instance->usb_dev = usb_dev;
diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 533236366a03..853e9f1faf7b 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1335,8 +1335,7 @@ static int proc_getdriver(struct usb_dev_state *ps, void __user *arg)
 	if (!intf || !intf->dev.driver)
 		ret = -ENODATA;
 	else {
-		strlcpy(gd.driver, intf->dev.driver->name,
-				sizeof(gd.driver));
+		strscpy(gd.driver, intf->dev.driver->name, sizeof(gd.driver));
 		ret = (copy_to_user(arg, &gd, sizeof(gd)) ? -EFAULT : 0);
 	}
 	return ret;
diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 046f770a76da..2248ecef95f9 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -3649,7 +3649,7 @@ int ffs_name_dev(struct ffs_dev *dev, const char *name)
 
 	existing = _ffs_do_find_dev(name);
 	if (!existing)
-		strlcpy(dev->name, name, ARRAY_SIZE(dev->name));
+		strscpy(dev->name, name, ARRAY_SIZE(dev->name));
 	else if (existing != dev)
 		ret = -EBUSY;
 
diff --git a/drivers/usb/gadget/function/f_uvc.c b/drivers/usb/gadget/function/f_uvc.c
index 44b4352a2676..0296276bbc5c 100644
--- a/drivers/usb/gadget/function/f_uvc.c
+++ b/drivers/usb/gadget/function/f_uvc.c
@@ -424,7 +424,7 @@ uvc_register_video(struct uvc_device *uvc)
 	uvc->vdev.vfl_dir = VFL_DIR_TX;
 	uvc->vdev.lock = &uvc->video.mutex;
 	uvc->vdev.device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
-	strlcpy(uvc->vdev.name, cdev->gadget->name, sizeof(uvc->vdev.name));
+	strscpy(uvc->vdev.name, cdev->gadget->name, sizeof(uvc->vdev.name));
 
 	video_set_drvdata(&uvc->vdev, uvc);
 
diff --git a/drivers/usb/gadget/function/u_audio.c b/drivers/usb/gadget/function/u_audio.c
index e6d32c536781..cb9508d8ada4 100644
--- a/drivers/usb/gadget/function/u_audio.c
+++ b/drivers/usb/gadget/function/u_audio.c
@@ -560,15 +560,15 @@ int g_audio_setup(struct g_audio *g_audio, const char *pcm_name,
 	if (err < 0)
 		goto snd_fail;
 
-	strlcpy(pcm->name, pcm_name, sizeof(pcm->name));
+	strscpy(pcm->name, pcm_name, sizeof(pcm->name));
 	pcm->private_data = uac;
 	uac->pcm = pcm;
 
 	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_PLAYBACK, &uac_pcm_ops);
 	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &uac_pcm_ops);
 
-	strlcpy(card->driver, card_name, sizeof(card->driver));
-	strlcpy(card->shortname, card_name, sizeof(card->shortname));
+	strscpy(card->driver, card_name, sizeof(card->driver));
+	strscpy(card->shortname, card_name, sizeof(card->shortname));
 	sprintf(card->longname, "%s %i", card_name, card->dev->id);
 
 	snd_pcm_set_managed_buffer_all(pcm, SNDRV_DMA_TYPE_CONTINUOUS,
diff --git a/drivers/usb/gadget/function/u_ether.c b/drivers/usb/gadget/function/u_ether.c
index 31ea76adcc0d..c7c437da5568 100644
--- a/drivers/usb/gadget/function/u_ether.c
+++ b/drivers/usb/gadget/function/u_ether.c
@@ -142,10 +142,10 @@ static void eth_get_drvinfo(struct net_device *net, struct ethtool_drvinfo *p)
 {
 	struct eth_dev *dev = netdev_priv(net);
 
-	strlcpy(p->driver, "g_ether", sizeof(p->driver));
-	strlcpy(p->version, UETH__VERSION, sizeof(p->version));
-	strlcpy(p->fw_version, dev->gadget->name, sizeof(p->fw_version));
-	strlcpy(p->bus_info, dev_name(&dev->gadget->dev), sizeof(p->bus_info));
+	strscpy(p->driver, "g_ether", sizeof(p->driver));
+	strscpy(p->version, UETH__VERSION, sizeof(p->version));
+	strscpy(p->fw_version, dev->gadget->name, sizeof(p->fw_version));
+	strscpy(p->bus_info, dev_name(&dev->gadget->dev), sizeof(p->bus_info));
 }
 
 /* REVISIT can also support:
diff --git a/drivers/usb/gadget/function/uvc_v4l2.c b/drivers/usb/gadget/function/uvc_v4l2.c
index 4ca89eab6159..2240db4f6e95 100644
--- a/drivers/usb/gadget/function/uvc_v4l2.c
+++ b/drivers/usb/gadget/function/uvc_v4l2.c
@@ -67,9 +67,9 @@ uvc_v4l2_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
 	struct uvc_device *uvc = video_get_drvdata(vdev);
 	struct usb_composite_dev *cdev = uvc->func.config->cdev;
 
-	strlcpy(cap->driver, "g_uvc", sizeof(cap->driver));
-	strlcpy(cap->card, cdev->gadget->name, sizeof(cap->card));
-	strlcpy(cap->bus_info, dev_name(&cdev->gadget->dev),
+	strscpy(cap->driver, "g_uvc", sizeof(cap->driver));
+	strscpy(cap->card, cdev->gadget->name, sizeof(cap->card));
+	strscpy(cap->bus_info, dev_name(&cdev->gadget->dev),
 		sizeof(cap->bus_info));
 	return 0;
 }
diff --git a/drivers/usb/gadget/udc/omap_udc.c b/drivers/usb/gadget/udc/omap_udc.c
index 494da00398d7..73666efd30dd 100644
--- a/drivers/usb/gadget/udc/omap_udc.c
+++ b/drivers/usb/gadget/udc/omap_udc.c
@@ -2553,7 +2553,7 @@ omap_ep_setup(char *name, u8 addr, u8 type,
 
 	/* set up driver data structures */
 	BUG_ON(strlen(name) >= sizeof ep->name);
-	strlcpy(ep->name, name, sizeof ep->name);
+	strscpy(ep->name, name, sizeof ep->name);
 	INIT_LIST_HEAD(&ep->queue);
 	INIT_LIST_HEAD(&ep->iso);
 	ep->bEndpointAddress = addr;
diff --git a/drivers/usb/misc/usb251xb.c b/drivers/usb/misc/usb251xb.c
index 29fe5771c21b..ff4ac3d51899 100644
--- a/drivers/usb/misc/usb251xb.c
+++ b/drivers/usb/misc/usb251xb.c
@@ -544,7 +544,7 @@ static int usb251xb_get_ofdata(struct usb251xb *hub,
 		hub->lang_id = USB251XB_DEF_LANGUAGE_ID;
 
 	cproperty_char = of_get_property(np, "manufacturer", NULL);
-	strlcpy(str, cproperty_char ? : USB251XB_DEF_MANUFACTURER_STRING,
+	strscpy(str, cproperty_char ? : USB251XB_DEF_MANUFACTURER_STRING,
 		sizeof(str));
 	hub->manufacturer_len = strlen(str) & 0xFF;
 	memset(hub->manufacturer, 0, USB251XB_STRING_BUFSIZE);
@@ -554,7 +554,7 @@ static int usb251xb_get_ofdata(struct usb251xb *hub,
 			      USB251XB_STRING_BUFSIZE);
 
 	cproperty_char = of_get_property(np, "product", NULL);
-	strlcpy(str, cproperty_char ? : data->product_str, sizeof(str));
+	strscpy(str, cproperty_char ? : data->product_str, sizeof(str));
 	hub->product_len = strlen(str) & 0xFF;
 	memset(hub->product, 0, USB251XB_STRING_BUFSIZE);
 	len = min_t(size_t, USB251XB_STRING_BUFSIZE / 2, strlen(str));
@@ -563,7 +563,7 @@ static int usb251xb_get_ofdata(struct usb251xb *hub,
 			      USB251XB_STRING_BUFSIZE);
 
 	cproperty_char = of_get_property(np, "serial", NULL);
-	strlcpy(str, cproperty_char ? : USB251XB_DEF_SERIAL_STRING,
+	strscpy(str, cproperty_char ? : USB251XB_DEF_SERIAL_STRING,
 		sizeof(str));
 	hub->serial_len = strlen(str) & 0xFF;
 	memset(hub->serial, 0, USB251XB_STRING_BUFSIZE);
diff --git a/drivers/usb/storage/onetouch.c b/drivers/usb/storage/onetouch.c
index a989fe930e21..3ebd88b7aa2b 100644
--- a/drivers/usb/storage/onetouch.c
+++ b/drivers/usb/storage/onetouch.c
@@ -201,7 +201,7 @@ static int onetouch_connect_input(struct us_data *ss)
 	onetouch->dev = input_dev;
 
 	if (udev->manufacturer)
-		strlcpy(onetouch->name, udev->manufacturer,
+		strscpy(onetouch->name, udev->manufacturer,
 			sizeof(onetouch->name));
 	if (udev->product) {
 		if (udev->manufacturer)
diff --git a/drivers/usb/typec/tcpm/fusb302.c b/drivers/usb/typec/tcpm/fusb302.c
index 99562cc65ca6..d9f7ba9e446a 100644
--- a/drivers/usb/typec/tcpm/fusb302.c
+++ b/drivers/usb/typec/tcpm/fusb302.c
@@ -151,7 +151,7 @@ static void _fusb302_log(struct fusb302_chip *chip, const char *fmt,
 
 	if (fusb302_log_full(chip)) {
 		chip->logbuffer_head = max(chip->logbuffer_head - 1, 0);
-		strlcpy(tmpbuffer, "overflow", sizeof(tmpbuffer));
+		strscpy(tmpbuffer, "overflow", sizeof(tmpbuffer));
 	}
 
 	if (chip->logbuffer_head < 0 ||
diff --git a/drivers/usb/usbip/stub_main.c b/drivers/usb/usbip/stub_main.c
index f38e41800782..04b027a7bbbf 100644
--- a/drivers/usb/usbip/stub_main.c
+++ b/drivers/usb/usbip/stub_main.c
@@ -102,7 +102,7 @@ static int add_match_busid(char *busid)
 	for (i = 0; i < MAX_BUSID; i++) {
 		spin_lock(&busid_table[i].busid_lock);
 		if (!busid_table[i].name[0]) {
-			strlcpy(busid_table[i].name, busid, BUSID_SIZE);
+			strscpy(busid_table->name, busid, BUSID_SIZE);
 			if ((busid_table[i].status != STUB_BUSID_ALLOC) &&
 			    (busid_table[i].status != STUB_BUSID_REMOV))
 				busid_table[i].status = STUB_BUSID_ADDED;
diff --git a/drivers/video/console/sticore.c b/drivers/video/console/sticore.c
index 6a26a364f9bd..6263816ecbbe 100644
--- a/drivers/video/console/sticore.c
+++ b/drivers/video/console/sticore.c
@@ -289,7 +289,7 @@ static char default_sti_path[21] __read_mostly;
 static int __init sti_setup(char *str)
 {
 	if (str)
-		strlcpy (default_sti_path, str, sizeof (default_sti_path));
+		strscpy(default_sti_path, str, sizeof(default_sti_path));
 	
 	return 1;
 }
diff --git a/drivers/video/fbdev/aty/atyfb_base.c b/drivers/video/fbdev/aty/atyfb_base.c
index c8feff0ee8da..dc0599b5d446 100644
--- a/drivers/video/fbdev/aty/atyfb_base.c
+++ b/drivers/video/fbdev/aty/atyfb_base.c
@@ -3885,7 +3885,7 @@ static int __init atyfb_setup(char *options)
 			 && (!strncmp(this_opt, "Mach64:", 7))) {
 			static unsigned char m64_num;
 			static char mach64_str[80];
-			strlcpy(mach64_str, this_opt + 7, sizeof(mach64_str));
+			strscpy(mach64_str, this_opt + 7, sizeof(mach64_str));
 			if (!store_video_par(mach64_str, m64_num)) {
 				m64_num++;
 				mach64_count = m64_num;
diff --git a/drivers/video/fbdev/aty/radeon_base.c b/drivers/video/fbdev/aty/radeon_base.c
index 2fe690150420..bcac0fe26ce0 100644
--- a/drivers/video/fbdev/aty/radeon_base.c
+++ b/drivers/video/fbdev/aty/radeon_base.c
@@ -1980,7 +1980,7 @@ static int radeon_set_fbinfo(struct radeonfb_info *rinfo)
 	info->screen_base = rinfo->fb_base;
 	info->screen_size = rinfo->mapped_vram;
 	/* Fill fix common fields */
-	strlcpy(info->fix.id, rinfo->name, sizeof(info->fix.id));
+	strscpy(info->fix.id, rinfo->name, sizeof(info->fix.id));
         info->fix.smem_start = rinfo->fb_base_phys;
         info->fix.smem_len = rinfo->video_ram;
         info->fix.type = FB_TYPE_PACKED_PIXELS;
diff --git a/drivers/video/fbdev/bw2.c b/drivers/video/fbdev/bw2.c
index 0d9a6bb57a09..ffaccd9e0d67 100644
--- a/drivers/video/fbdev/bw2.c
+++ b/drivers/video/fbdev/bw2.c
@@ -182,7 +182,7 @@ static int bw2_ioctl(struct fb_info *info, unsigned int cmd, unsigned long arg)
 
 static void bw2_init_fix(struct fb_info *info, int linebytes)
 {
-	strlcpy(info->fix.id, "bwtwo", sizeof(info->fix.id));
+	strscpy(info->fix.id, "bwtwo", sizeof(info->fix.id));
 
 	info->fix.type = FB_TYPE_PACKED_PIXELS;
 	info->fix.visual = FB_VISUAL_MONO01;
diff --git a/drivers/video/fbdev/cirrusfb.c b/drivers/video/fbdev/cirrusfb.c
index 15a9ee7cd734..31b927a45b57 100644
--- a/drivers/video/fbdev/cirrusfb.c
+++ b/drivers/video/fbdev/cirrusfb.c
@@ -1998,7 +1998,7 @@ static int cirrusfb_set_fbinfo(struct fb_info *info)
 	}
 
 	/* Fill fix common fields */
-	strlcpy(info->fix.id, cirrusfb_board_info[cinfo->btype].name,
+	strscpy(info->fix.id, cirrusfb_board_info[cinfo->btype].name,
 		sizeof(info->fix.id));
 
 	/* monochrome: only 1 memory plane */
diff --git a/drivers/video/fbdev/clps711x-fb.c b/drivers/video/fbdev/clps711x-fb.c
index c5d15c6db287..619dc7d3aad6 100644
--- a/drivers/video/fbdev/clps711x-fb.c
+++ b/drivers/video/fbdev/clps711x-fb.c
@@ -327,7 +327,7 @@ static int clps711x_fb_probe(struct platform_device *pdev)
 	info->var.vmode = FB_VMODE_NONINTERLACED;
 	info->fix.type = FB_TYPE_PACKED_PIXELS;
 	info->fix.accel = FB_ACCEL_NONE;
-	strlcpy(info->fix.id, CLPS711X_FB_NAME, sizeof(info->fix.id));
+	strscpy(info->fix.id, CLPS711X_FB_NAME, sizeof(info->fix.id));
 	fb_videomode_to_var(&info->var, &cfb->mode);
 
 	ret = fb_alloc_cmap(&info->cmap, BIT(CLPS711X_FB_BPP_MAX), 0);
diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index cef437817b0d..e15b42b7dcce 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -444,7 +444,7 @@ static int __init fb_console_setup(char *this_opt)
 
 	while ((options = strsep(&this_opt, ",")) != NULL) {
 		if (!strncmp(options, "font:", 5)) {
-			strlcpy(fontname, options + 5, sizeof(fontname));
+			strscpy(fontname, options + 5, sizeof(fontname));
 			continue;
 		}
 		
diff --git a/drivers/video/fbdev/cyber2000fb.c b/drivers/video/fbdev/cyber2000fb.c
index d45355b9a58c..8f041f9b14c7 100644
--- a/drivers/video/fbdev/cyber2000fb.c
+++ b/drivers/video/fbdev/cyber2000fb.c
@@ -1134,7 +1134,7 @@ int cyber2000fb_attach(struct cyberpro_info *info, int idx)
 		info->fb_size	      = int_cfb_info->fb.fix.smem_len;
 		info->info	      = int_cfb_info;
 
-		strlcpy(info->dev_name, int_cfb_info->fb.fix.id,
+		strscpy(info->dev_name, int_cfb_info->fb.fix.id,
 			sizeof(info->dev_name));
 	}
 
@@ -1229,7 +1229,7 @@ static int cyber2000fb_ddc_getsda(void *data)
 
 static int cyber2000fb_setup_ddc_bus(struct cfb_info *cfb)
 {
-	strlcpy(cfb->ddc_adapter.name, cfb->fb.fix.id,
+	strscpy(cfb->ddc_adapter.name, cfb->fb.fix.id,
 		sizeof(cfb->ddc_adapter.name));
 	cfb->ddc_adapter.owner		= THIS_MODULE;
 	cfb->ddc_adapter.class		= I2C_CLASS_DDC;
@@ -1304,7 +1304,7 @@ static int cyber2000fb_i2c_getscl(void *data)
 
 static int cyber2000fb_i2c_register(struct cfb_info *cfb)
 {
-	strlcpy(cfb->i2c_adapter.name, cfb->fb.fix.id,
+	strscpy(cfb->i2c_adapter.name, cfb->fb.fix.id,
 		sizeof(cfb->i2c_adapter.name));
 	cfb->i2c_adapter.owner = THIS_MODULE;
 	cfb->i2c_adapter.algo_data = &cfb->i2c_algo;
@@ -1500,7 +1500,7 @@ static int cyber2000fb_setup(char *options)
 		if (strncmp(opt, "font:", 5) == 0) {
 			static char default_font_storage[40];
 
-			strlcpy(default_font_storage, opt + 5,
+			strscpy(default_font_storage, opt + 5,
 				sizeof(default_font_storage));
 			default_font = default_font_storage;
 			continue;
diff --git a/drivers/video/fbdev/ffb.c b/drivers/video/fbdev/ffb.c
index 948b73184433..e7330cd6cdf0 100644
--- a/drivers/video/fbdev/ffb.c
+++ b/drivers/video/fbdev/ffb.c
@@ -883,7 +883,7 @@ static void ffb_init_fix(struct fb_info *info)
 	} else
 		ffb_type_name = "Elite 3D";
 
-	strlcpy(info->fix.id, ffb_type_name, sizeof(info->fix.id));
+	strscpy(info->fix.id, ffb_type_name, sizeof(info->fix.id));
 
 	info->fix.type = FB_TYPE_PACKED_PIXELS;
 	info->fix.visual = FB_VISUAL_TRUECOLOR;
diff --git a/drivers/video/fbdev/geode/gx1fb_core.c b/drivers/video/fbdev/geode/gx1fb_core.c
index 5d34d89fb665..334f5eae1e00 100644
--- a/drivers/video/fbdev/geode/gx1fb_core.c
+++ b/drivers/video/fbdev/geode/gx1fb_core.c
@@ -410,13 +410,15 @@ static void __init gx1fb_setup(char *options)
 			continue;
 
 		if (!strncmp(this_opt, "mode:", 5))
-			strlcpy(mode_option, this_opt + 5, sizeof(mode_option));
+			strscpy(mode_option, this_opt + 5,
+				sizeof(mode_option));
 		else if (!strncmp(this_opt, "crt:", 4))
 			crt_option = !!simple_strtoul(this_opt + 4, NULL, 0);
 		else if (!strncmp(this_opt, "panel:", 6))
-			strlcpy(panel_option, this_opt + 6, sizeof(panel_option));
+			strscpy(panel_option, this_opt + 6,
+				sizeof(panel_option));
 		else
-			strlcpy(mode_option, this_opt, sizeof(mode_option));
+			strscpy(mode_option, this_opt, sizeof(mode_option));
 	}
 }
 #endif
diff --git a/drivers/video/fbdev/gxt4500.c b/drivers/video/fbdev/gxt4500.c
index e5475ae1e158..94588b809ebf 100644
--- a/drivers/video/fbdev/gxt4500.c
+++ b/drivers/video/fbdev/gxt4500.c
@@ -650,7 +650,7 @@ static int gxt4500_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	cardtype = ent->driver_data;
 	par->refclk_ps = cardinfo[cardtype].refclk_ps;
 	info->fix = gxt4500_fix;
-	strlcpy(info->fix.id, cardinfo[cardtype].cardname,
+	strscpy(info->fix.id, cardinfo[cardtype].cardname,
 		sizeof(info->fix.id));
 	info->pseudo_palette = par->pseudo_palette;
 
diff --git a/drivers/video/fbdev/i740fb.c b/drivers/video/fbdev/i740fb.c
index 52cce0db8bd3..1131c9d675d5 100644
--- a/drivers/video/fbdev/i740fb.c
+++ b/drivers/video/fbdev/i740fb.c
@@ -159,7 +159,7 @@ static int i740fb_setup_ddc_bus(struct fb_info *info)
 {
 	struct i740fb_par *par = info->par;
 
-	strlcpy(par->ddc_adapter.name, info->fix.id,
+	strscpy(par->ddc_adapter.name, info->fix.id,
 		sizeof(par->ddc_adapter.name));
 	par->ddc_adapter.owner		= THIS_MODULE;
 	par->ddc_adapter.class		= I2C_CLASS_DDC;
diff --git a/drivers/video/fbdev/imxfb.c b/drivers/video/fbdev/imxfb.c
index 884b16efa7e8..7d60a6271ef9 100644
--- a/drivers/video/fbdev/imxfb.c
+++ b/drivers/video/fbdev/imxfb.c
@@ -671,7 +671,7 @@ static int imxfb_init_fbinfo(struct platform_device *pdev)
 
 	fbi->devtype = pdev->id_entry->driver_data;
 
-	strlcpy(info->fix.id, IMX_NAME, sizeof(info->fix.id));
+	strscpy(info->fix.id, IMX_NAME, sizeof(info->fix.id));
 
 	info->fix.type			= FB_TYPE_PACKED_PIXELS;
 	info->fix.type_aux		= 0;
diff --git a/drivers/video/fbdev/matrox/matroxfb_base.c b/drivers/video/fbdev/matrox/matroxfb_base.c
index 570439b32655..c11b79b9f86f 100644
--- a/drivers/video/fbdev/matrox/matroxfb_base.c
+++ b/drivers/video/fbdev/matrox/matroxfb_base.c
@@ -2387,9 +2387,9 @@ static int __init matroxfb_setup(char *options) {
 		else if (!strncmp(this_opt, "mem:", 4))
 			mem = simple_strtoul(this_opt+4, NULL, 0);
 		else if (!strncmp(this_opt, "mode:", 5))
-			strlcpy(videomode, this_opt+5, sizeof(videomode));
+			strscpy(videomode, this_opt + 5, sizeof(videomode));
 		else if (!strncmp(this_opt, "outputs:", 8))
-			strlcpy(outputs, this_opt+8, sizeof(outputs));
+			strscpy(outputs, this_opt + 8, sizeof(outputs));
 		else if (!strncmp(this_opt, "dfp:", 4)) {
 			dfp_type = simple_strtoul(this_opt+4, NULL, 0);
 			dfp = 1;
@@ -2459,7 +2459,8 @@ static int __init matroxfb_setup(char *options) {
 			else if (!strcmp(this_opt, "dfp"))
 				dfp = value;
 			else {
-				strlcpy(videomode, this_opt, sizeof(videomode));
+				strscpy(videomode, this_opt,
+					sizeof(videomode));
 			}
 		}
 	}
diff --git a/drivers/video/fbdev/omap2/omapfb/omapfb-main.c b/drivers/video/fbdev/omap2/omapfb/omapfb-main.c
index a3decc7fadde..0fc0a5168fae 100644
--- a/drivers/video/fbdev/omap2/omapfb/omapfb-main.c
+++ b/drivers/video/fbdev/omap2/omapfb/omapfb-main.c
@@ -1331,7 +1331,7 @@ static void clear_fb_info(struct fb_info *fbi)
 {
 	memset(&fbi->var, 0, sizeof(fbi->var));
 	memset(&fbi->fix, 0, sizeof(fbi->fix));
-	strlcpy(fbi->fix.id, MODULE_NAME, sizeof(fbi->fix.id));
+	strscpy(fbi->fix.id, MODULE_NAME, sizeof(fbi->fix.id));
 }
 
 static int omapfb_free_all_fbmem(struct omapfb2_device *fbdev)
diff --git a/drivers/video/fbdev/pxa168fb.c b/drivers/video/fbdev/pxa168fb.c
index 47e6a1d0d229..d15295a707d2 100644
--- a/drivers/video/fbdev/pxa168fb.c
+++ b/drivers/video/fbdev/pxa168fb.c
@@ -643,7 +643,7 @@ static int pxa168fb_probe(struct platform_device *pdev)
 	info->flags = FBINFO_DEFAULT | FBINFO_PARTIAL_PAN_OK |
 		      FBINFO_HWACCEL_XPAN | FBINFO_HWACCEL_YPAN;
 	info->node = -1;
-	strlcpy(info->fix.id, mi->id, 16);
+	strscpy(info->fix.id, mi->id, 16);
 	info->fix.type = FB_TYPE_PACKED_PIXELS;
 	info->fix.type_aux = 0;
 	info->fix.xpanstep = 0;
diff --git a/drivers/video/fbdev/pxafb.c b/drivers/video/fbdev/pxafb.c
index f1551e00eb12..2abf2c377f62 100644
--- a/drivers/video/fbdev/pxafb.c
+++ b/drivers/video/fbdev/pxafb.c
@@ -2042,7 +2042,7 @@ static int __init pxafb_setup_options(void)
 		return -ENODEV;
 
 	if (options)
-		strlcpy(g_options, options, sizeof(g_options));
+		strscpy(g_options, options, sizeof(g_options));
 
 	return 0;
 }
diff --git a/drivers/video/fbdev/s3fb.c b/drivers/video/fbdev/s3fb.c
index 5c74253e7b2c..1ab1cc5efb47 100644
--- a/drivers/video/fbdev/s3fb.c
+++ b/drivers/video/fbdev/s3fb.c
@@ -248,7 +248,7 @@ static int s3fb_setup_ddc_bus(struct fb_info *info)
 {
 	struct s3fb_info *par = info->par;
 
-	strlcpy(par->ddc_adapter.name, info->fix.id,
+	strscpy(par->ddc_adapter.name, info->fix.id,
 		sizeof(par->ddc_adapter.name));
 	par->ddc_adapter.owner		= THIS_MODULE;
 	par->ddc_adapter.class		= I2C_CLASS_DDC;
diff --git a/drivers/video/fbdev/simplefb.c b/drivers/video/fbdev/simplefb.c
index 533a047d07a2..94e0cb0bd8cd 100644
--- a/drivers/video/fbdev/simplefb.c
+++ b/drivers/video/fbdev/simplefb.c
@@ -344,7 +344,7 @@ static int simplefb_regulators_get(struct simplefb_par *par,
 		if (!p || p == prop->name)
 			continue;
 
-		strlcpy(name, prop->name,
+		strscpy(name, prop->name,
 			strlen(prop->name) - strlen(SUPPLY_SUFFIX) + 1);
 		regulator = devm_regulator_get_optional(&pdev->dev, name);
 		if (IS_ERR(regulator)) {
diff --git a/drivers/video/fbdev/sis/sis_main.c b/drivers/video/fbdev/sis/sis_main.c
index 03c736f6f3d0..d5762ad4fdcf 100644
--- a/drivers/video/fbdev/sis/sis_main.c
+++ b/drivers/video/fbdev/sis/sis_main.c
@@ -1872,7 +1872,7 @@ sisfb_get_fix(struct fb_fix_screeninfo *fix, int con, struct fb_info *info)
 
 	memset(fix, 0, sizeof(struct fb_fix_screeninfo));
 
-	strlcpy(fix->id, ivideo->myid, sizeof(fix->id));
+	strscpy(fix->id, ivideo->myid, sizeof(fix->id));
 
 	mutex_lock(&info->mm_lock);
 	fix->smem_start  = ivideo->video_base + ivideo->video_offset;
@@ -5868,7 +5868,7 @@ static int sisfb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			ivideo->cardnumber++;
 	}
 
-	strlcpy(ivideo->myid, chipinfo->chip_name, sizeof(ivideo->myid));
+	strscpy(ivideo->myid, chipinfo->chip_name, sizeof(ivideo->myid));
 
 	ivideo->warncount = 0;
 	ivideo->chip_id = pdev->device;
diff --git a/drivers/video/fbdev/sm501fb.c b/drivers/video/fbdev/sm501fb.c
index 6a52eba64559..fce6cfbadfd6 100644
--- a/drivers/video/fbdev/sm501fb.c
+++ b/drivers/video/fbdev/sm501fb.c
@@ -1719,7 +1719,7 @@ static int sm501fb_init_fb(struct fb_info *fb, enum sm501_controller head,
 		enable = 0;
 	}
 
-	strlcpy(fb->fix.id, fbname, sizeof(fb->fix.id));
+	strscpy(fb->fix.id, fbname, sizeof(fb->fix.id));
 
 	memcpy(&par->ops,
 	       (head == HEAD_CRT) ? &sm501fb_ops_crt : &sm501fb_ops_pnl,
diff --git a/drivers/video/fbdev/sstfb.c b/drivers/video/fbdev/sstfb.c
index c05cdabeb11c..0c20a97df05b 100644
--- a/drivers/video/fbdev/sstfb.c
+++ b/drivers/video/fbdev/sstfb.c
@@ -1382,7 +1382,7 @@ static int sstfb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto fail;
 	}
 	sst_get_memsize(info, &fix->smem_len);
-	strlcpy(fix->id, spec->name, sizeof(fix->id));
+	strscpy(fix->id, spec->name, sizeof(fix->id));
 
 	printk(KERN_INFO "%s (revision %d) with %s dac\n",
 		fix->id, par->revision, par->dac_sw.name);
diff --git a/drivers/video/fbdev/sunxvr1000.c b/drivers/video/fbdev/sunxvr1000.c
index 15b079505a00..490bd9a14763 100644
--- a/drivers/video/fbdev/sunxvr1000.c
+++ b/drivers/video/fbdev/sunxvr1000.c
@@ -80,7 +80,7 @@ static int gfb_set_fbinfo(struct gfb_info *gp)
 	info->pseudo_palette = gp->pseudo_palette;
 
 	/* Fill fix common fields */
-	strlcpy(info->fix.id, "gfb", sizeof(info->fix.id));
+	strscpy(info->fix.id, "gfb", sizeof(info->fix.id));
         info->fix.smem_start = gp->fb_base_phys;
         info->fix.smem_len = gp->fb_size;
         info->fix.type = FB_TYPE_PACKED_PIXELS;
diff --git a/drivers/video/fbdev/sunxvr2500.c b/drivers/video/fbdev/sunxvr2500.c
index 1d3bacd9d5ac..1279b02234f8 100644
--- a/drivers/video/fbdev/sunxvr2500.c
+++ b/drivers/video/fbdev/sunxvr2500.c
@@ -84,7 +84,7 @@ static int s3d_set_fbinfo(struct s3d_info *sp)
 	info->pseudo_palette = sp->pseudo_palette;
 
 	/* Fill fix common fields */
-	strlcpy(info->fix.id, "s3d", sizeof(info->fix.id));
+	strscpy(info->fix.id, "s3d", sizeof(info->fix.id));
         info->fix.smem_start = sp->fb_base_phys;
         info->fix.smem_len = sp->fb_size;
         info->fix.type = FB_TYPE_PACKED_PIXELS;
diff --git a/drivers/video/fbdev/sunxvr500.c b/drivers/video/fbdev/sunxvr500.c
index 9daf17b11106..f7b463633ba0 100644
--- a/drivers/video/fbdev/sunxvr500.c
+++ b/drivers/video/fbdev/sunxvr500.c
@@ -207,7 +207,7 @@ static int e3d_set_fbinfo(struct e3d_info *ep)
 	info->pseudo_palette = ep->pseudo_palette;
 
 	/* Fill fix common fields */
-	strlcpy(info->fix.id, "e3d", sizeof(info->fix.id));
+	strscpy(info->fix.id, "e3d", sizeof(info->fix.id));
         info->fix.smem_start = ep->fb_base_phys;
         info->fix.smem_len = ep->fb_size;
         info->fix.type = FB_TYPE_PACKED_PIXELS;
diff --git a/drivers/video/fbdev/tcx.c b/drivers/video/fbdev/tcx.c
index 34b2e5b6e84a..017564efcabf 100644
--- a/drivers/video/fbdev/tcx.c
+++ b/drivers/video/fbdev/tcx.c
@@ -333,7 +333,7 @@ tcx_init_fix(struct fb_info *info, int linebytes)
 	else
 		tcx_name = "TCX24";
 
-	strlcpy(info->fix.id, tcx_name, sizeof(info->fix.id));
+	strscpy(info->fix.id, tcx_name, sizeof(info->fix.id));
 
 	info->fix.type = FB_TYPE_PACKED_PIXELS;
 	info->fix.visual = FB_VISUAL_PSEUDOCOLOR;
diff --git a/drivers/video/fbdev/tdfxfb.c b/drivers/video/fbdev/tdfxfb.c
index f056d80f6359..ac47024fa7e2 100644
--- a/drivers/video/fbdev/tdfxfb.c
+++ b/drivers/video/fbdev/tdfxfb.c
@@ -1266,7 +1266,7 @@ static int tdfxfb_setup_ddc_bus(struct tdfxfb_i2c_chan *chan, const char *name,
 {
 	int rc;
 
-	strlcpy(chan->adapter.name, name, sizeof(chan->adapter.name));
+	strscpy(chan->adapter.name, name, sizeof(chan->adapter.name));
 	chan->adapter.owner		= THIS_MODULE;
 	chan->adapter.class		= I2C_CLASS_DDC;
 	chan->adapter.algo_data		= &chan->algo;
@@ -1295,7 +1295,7 @@ static int tdfxfb_setup_i2c_bus(struct tdfxfb_i2c_chan *chan, const char *name,
 {
 	int rc;
 
-	strlcpy(chan->adapter.name, name, sizeof(chan->adapter.name));
+	strscpy(chan->adapter.name, name, sizeof(chan->adapter.name));
 	chan->adapter.owner		= THIS_MODULE;
 	chan->adapter.algo_data		= &chan->algo;
 	chan->adapter.dev.parent	= dev;
diff --git a/drivers/video/fbdev/tgafb.c b/drivers/video/fbdev/tgafb.c
index 666fbe2f671c..37f9f48ceaea 100644
--- a/drivers/video/fbdev/tgafb.c
+++ b/drivers/video/fbdev/tgafb.c
@@ -1345,7 +1345,7 @@ tgafb_init_fix(struct fb_info *info)
 		memory_size = 16777216;
 	}
 
-	strlcpy(info->fix.id, tga_type_name, sizeof(info->fix.id));
+	strscpy(info->fix.id, tga_type_name, sizeof(info->fix.id));
 
 	info->fix.type = FB_TYPE_PACKED_PIXELS;
 	info->fix.type_aux = 0;
diff --git a/drivers/video/fbdev/tridentfb.c b/drivers/video/fbdev/tridentfb.c
index 4d20cb557ff0..93117ce2218b 100644
--- a/drivers/video/fbdev/tridentfb.c
+++ b/drivers/video/fbdev/tridentfb.c
@@ -270,7 +270,7 @@ static int tridentfb_setup_ddc_bus(struct fb_info *info)
 {
 	struct tridentfb_par *par = info->par;
 
-	strlcpy(par->ddc_adapter.name, info->fix.id,
+	strscpy(par->ddc_adapter.name, info->fix.id,
 		sizeof(par->ddc_adapter.name));
 	par->ddc_adapter.owner		= THIS_MODULE;
 	par->ddc_adapter.class		= I2C_CLASS_DDC;
diff --git a/drivers/virt/vboxguest/vboxguest_core.c b/drivers/virt/vboxguest/vboxguest_core.c
index 0b43efddea22..cc6612cf2a9e 100644
--- a/drivers/virt/vboxguest/vboxguest_core.c
+++ b/drivers/virt/vboxguest/vboxguest_core.c
@@ -198,8 +198,7 @@ static int vbg_report_guest_info(struct vbg_dev *gdev)
 	req2->additions_revision = VBG_SVN_REV;
 	req2->additions_features =
 		VMMDEV_GUEST_INFO2_ADDITIONS_FEATURES_REQUESTOR_INFO;
-	strlcpy(req2->name, VBG_VERSION_STRING,
-		sizeof(req2->name));
+	strscpy(req2->name, VBG_VERSION_STRING, sizeof(req2->name));
 
 	/*
 	 * There are two protocols here:
diff --git a/drivers/w1/masters/sgi_w1.c b/drivers/w1/masters/sgi_w1.c
index e8c7fa68d3cc..d7fbc3c146e1 100644
--- a/drivers/w1/masters/sgi_w1.c
+++ b/drivers/w1/masters/sgi_w1.c
@@ -93,7 +93,7 @@ static int sgi_w1_probe(struct platform_device *pdev)
 
 	pdata = dev_get_platdata(&pdev->dev);
 	if (pdata) {
-		strlcpy(sdev->dev_id, pdata->dev_id, sizeof(sdev->dev_id));
+		strscpy(sdev->dev_id, pdata->dev_id, sizeof(sdev->dev_id));
 		sdev->bus_master.dev_id = sdev->dev_id;
 	}
 
diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 4acc4e899600..7e01ea2262cf 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1084,7 +1084,7 @@ static void scsiback_do_1lun_hotplug(struct vscsibk_info *info, int op,
 				"%s: writing %s", __func__, state);
 		return;
 	}
-	strlcpy(phy, val, VSCSI_NAMELEN);
+	strscpy(phy, val, VSCSI_NAMELEN);
 	kfree(val);
 
 	/* virtual SCSI device */
diff --git a/drivers/xen/xenbus/xenbus_probe_frontend.c b/drivers/xen/xenbus/xenbus_probe_frontend.c
index 480944606a3c..e186b8d15aaa 100644
--- a/drivers/xen/xenbus/xenbus_probe_frontend.c
+++ b/drivers/xen/xenbus/xenbus_probe_frontend.c
@@ -40,7 +40,7 @@ static int frontend_bus_id(char bus_id[XEN_BUS_ID_SIZE], const char *nodename)
 		return -EINVAL;
 	}
 
-	strlcpy(bus_id, nodename + 1, XEN_BUS_ID_SIZE);
+	strscpy(bus_id, nodename + 1, XEN_BUS_ID_SIZE);
 	if (!strchr(bus_id, '/')) {
 		pr_warn("bus_id %s no slash\n", bus_id);
 		return -EINVAL;
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index ae0c38ad1fcb..7553f8a15cb7 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -131,7 +131,7 @@ static umode_t p9mode2unixmode(struct v9fs_session_info *v9ses,
 		char type = 0, ext[32];
 		int major = -1, minor = -1;
 
-		strlcpy(ext, stat->extension, sizeof(ext));
+		strscpy(ext, stat->extension, sizeof(ext));
 		sscanf(ext, "%c %i %i", &type, &major, &minor);
 		switch (type) {
 		case 'c':
@@ -1137,7 +1137,7 @@ v9fs_stat2inode(struct p9_wstat *stat, struct inode *inode,
 			 * this even with .u extension. So check
 			 * for non NULL stat->extension
 			 */
-			strlcpy(ext, stat->extension, sizeof(ext));
+			strscpy(ext, stat->extension, sizeof(ext));
 			/* HARDLINKCOUNT %u */
 			sscanf(ext, "%13s %u", tag_name, &i_nlink);
 			if (!strncmp(tag_name, "HARDLINKCOUNT", 13))
diff --git a/fs/affs/super.c b/fs/affs/super.c
index c6c2a513ec92..aa1d339cb773 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -276,7 +276,7 @@ parse_options(char *options, kuid_t *uid, kgid_t *gid, int *mode, int *reserved,
 			char *vol = match_strdup(&args[0]);
 			if (!vol)
 				return 0;
-			strlcpy(volume, vol, 32);
+			strscpy(volume, vol, 32);
 			kfree(vol);
 			break;
 		}
diff --git a/fs/befs/btree.c b/fs/befs/btree.c
index 1b7e0f7128d6..53b36aa29978 100644
--- a/fs/befs/btree.c
+++ b/fs/befs/btree.c
@@ -500,7 +500,7 @@ befs_btree_read(struct super_block *sb, const befs_data_stream *ds,
 		goto error_alloc;
 	}
 
-	strlcpy(keybuf, keystart, keylen + 1);
+	strscpy(keybuf, keystart, keylen + 1);
 	*value = fs64_to_cpu(sb, valarray[cur_key]);
 	*keysize = keylen;
 
diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index c1ba13d19024..36013416ff59 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -375,7 +375,7 @@ static struct inode *befs_iget(struct super_block *sb, unsigned long ino)
 	if (S_ISLNK(inode->i_mode) && !(befs_ino->i_flags & BEFS_LONG_SYMLINK)){
 		inode->i_size = 0;
 		inode->i_blocks = befs_sb->block_size / VFS_BLOCK_SIZE;
-		strlcpy(befs_ino->i_data.symlink, raw_inode->data.symlink,
+		strscpy(befs_ino->i_data.symlink, raw_inode->data.symlink,
 			BEFS_SYMLINK_LEN);
 	} else {
 		int num_blks;
diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 81a8c87a5afb..13e46de67d24 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -2823,7 +2823,7 @@ int btrfsic_mount(struct btrfs_fs_info *fs_info,
 		bdevname(ds->bdev, ds->name);
 		ds->name[BDEVNAME_SIZE - 1] = '\0';
 		p = kbasename(ds->name);
-		strlcpy(ds->name, p, sizeof(ds->name));
+		strscpy(ds->name, p, sizeof(ds->name));
 		btrfsic_dev_state_hashtable_add(ds,
 						&btrfsic_dev_state_hashtable);
 	}
diff --git a/fs/char_dev.c b/fs/char_dev.c
index ba0ded7842a7..c6be63dfef04 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -150,7 +150,7 @@ __register_chrdev_region(unsigned int major, unsigned int baseminor,
 	cd->major = major;
 	cd->baseminor = baseminor;
 	cd->minorct = minorct;
-	strlcpy(cd->name, name, sizeof(cd->name));
+	strscpy(cd->name, name, sizeof(cd->name));
 
 	if (!prev) {
 		cd->next = curr;
diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index 9bd03a231032..27ca70b4857f 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -365,7 +365,7 @@ cifs_strndup_from_utf16(const char *src, const int maxlen,
 		dst = kmalloc(len, GFP_KERNEL);
 		if (!dst)
 			return NULL;
-		strlcpy(dst, src, len);
+		strscpy(dst, src, len);
 	}
 
 	return dst;
diff --git a/fs/cifs/cifsroot.c b/fs/cifs/cifsroot.c
index 9e91a5a40aae..56ec1b233f52 100644
--- a/fs/cifs/cifsroot.c
+++ b/fs/cifs/cifsroot.c
@@ -59,7 +59,7 @@ static int __init cifs_root_setup(char *line)
 			pr_err("Root-CIFS: UNC path too long\n");
 			return 1;
 		}
-		strlcpy(root_dev, line, len);
+		strscpy(root_dev, line, len);
 		srvaddr = parse_srvaddr(&line[2], s);
 		if (*s) {
 			int n = snprintf(root_opts,
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 28c1459fb0fc..7dacccaa6901 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -4944,7 +4944,7 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
 		}
 		bcc_ptr += length + 1;
 		bytes_left -= (length + 1);
-		strlcpy(tcon->treeName, tree, sizeof(tcon->treeName));
+		strscpy(tcon->treeName, tree, sizeof(tcon->treeName));
 
 		/* mostly informational -- no need to fail on error here */
 		kfree(tcon->nativeFileSystem);
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 445e80862865..c618762e4442 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1799,7 +1799,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 	tcon->tidStatus = CifsGood;
 	tcon->need_reconnect = false;
 	tcon->tid = rsp->sync_hdr.TreeId;
-	strlcpy(tcon->treeName, tree, sizeof(tcon->treeName));
+	strscpy(tcon->treeName, tree, sizeof(tcon->treeName));
 
 	if ((rsp->Capabilities & SMB2_SHARE_CAP_DFS) &&
 	    ((tcon->share_flags & SHI1005_FLAGS_DFS) == 0))
diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index 49c5f9407098..82fc7e6877a1 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -116,9 +116,9 @@ static ssize_t cluster_cluster_name_store(struct config_item *item,
 {
 	struct dlm_cluster *cl = config_item_to_cluster(item);
 
-	strlcpy(dlm_config.ci_cluster_name, buf,
-				sizeof(dlm_config.ci_cluster_name));
-	strlcpy(cl->cl_cluster_name, buf, sizeof(cl->cl_cluster_name));
+	strscpy(dlm_config.ci_cluster_name, buf,
+		sizeof(dlm_config.ci_cluster_name));
+	strscpy(cl->cl_cluster_name, buf, sizeof(cl->cl_cluster_name));
 	return len;
 }
 
diff --git a/fs/exec.c b/fs/exec.c
index 547a2390baf5..d7f534ce7842 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1224,7 +1224,7 @@ void __set_task_comm(struct task_struct *tsk, const char *buf, bool exec)
 {
 	task_lock(tsk);
 	trace_task_rename(tsk, buf);
-	strlcpy(tsk->comm, buf, sizeof(tsk->comm));
+	strscpy(tsk->comm, buf, sizeof(tsk->comm));
 	task_unlock(tsk);
 	perf_event_comm(tsk, exec);
 }
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 3ed8c048fb12..57aa6326a6af 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -809,7 +809,7 @@ static int ext4_sample_last_mounted(struct super_block *sb,
 	err = ext4_journal_get_write_access(handle, sbi->s_sbh);
 	if (err)
 		goto out_journal;
-	strlcpy(sbi->s_es->s_last_mounted, cp,
+	strscpy(sbi->s_es->s_last_mounted, cp,
 		sizeof(sbi->s_es->s_last_mounted));
 	ext4_handle_dirty_super(handle, sb);
 out_journal:
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 61fce59cb4d3..d1783f25cd10 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -381,8 +381,8 @@ static int init_names(struct gfs2_sbd *sdp, int silent)
 	if (!table[0])
 		table = sdp->sd_vfs->s_id;
 
-	strlcpy(sdp->sd_proto_name, proto, GFS2_FSNAME_LEN);
-	strlcpy(sdp->sd_table_name, table, GFS2_FSNAME_LEN);
+	strscpy(sdp->sd_proto_name, proto, GFS2_FSNAME_LEN);
+	strscpy(sdp->sd_table_name, table, GFS2_FSNAME_LEN);
 
 	table = sdp->sd_table_name;
 	while ((table = strchr(table, '/')))
@@ -1376,13 +1376,13 @@ static int gfs2_parse_param(struct fs_context *fc, struct fs_parameter *param)
 
 	switch (o) {
 	case Opt_lockproto:
-		strlcpy(args->ar_lockproto, param->string, GFS2_LOCKNAME_LEN);
+		strscpy(args->ar_lockproto, param->string, GFS2_LOCKNAME_LEN);
 		break;
 	case Opt_locktable:
-		strlcpy(args->ar_locktable, param->string, GFS2_LOCKNAME_LEN);
+		strscpy(args->ar_locktable, param->string, GFS2_LOCKNAME_LEN);
 		break;
 	case Opt_hostdata:
-		strlcpy(args->ar_hostdata, param->string, GFS2_LOCKNAME_LEN);
+		strscpy(args->ar_hostdata, param->string, GFS2_LOCKNAME_LEN);
 		break;
 	case Opt_spectator:
 		args->ar_spectator = 1;
diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index c070c0d8e3e9..88d860ccc5dc 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -100,7 +100,7 @@ static char *__dentry_name(struct dentry *dentry, char *name)
 	 */
 	BUG_ON(p + strlen(p) + 1 != name + PATH_MAX);
 
-	strlcpy(name, root, PATH_MAX);
+	strscpy(name, root, PATH_MAX);
 	if (len > p - name) {
 		__putname(name);
 		return NULL;
diff --git a/fs/lockd/host.c b/fs/lockd/host.c
index 0afb6d59bad0..ee57fef7c8c0 100644
--- a/fs/lockd/host.c
+++ b/fs/lockd/host.c
@@ -164,7 +164,7 @@ static struct nlm_host *nlm_alloc_host(struct nlm_lookup_host_info *ni,
 	host->h_addrbuf    = nsm->sm_addrbuf;
 	host->net	   = ni->net;
 	host->h_cred	   = get_cred(ni->cred),
-	strlcpy(host->nodename, utsname()->nodename, sizeof(host->nodename));
+	strscpy(host->nodename, utsname()->nodename, sizeof(host->nodename));
 
 out:
 	return host;
diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
index be7915c861ce..6702f6a642f0 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -408,7 +408,7 @@ struct nfs_client *nfs4_init_client(struct nfs_client *clp,
 			goto error;
 		ip_addr = (const char *)buf;
 	}
-	strlcpy(clp->cl_ipaddr, ip_addr, sizeof(clp->cl_ipaddr));
+	strscpy(clp->cl_ipaddr, ip_addr, sizeof(clp->cl_ipaddr));
 
 	error = nfs_idmap_new(clp);
 	if (error < 0) {
diff --git a/fs/nfs/nfsroot.c b/fs/nfs/nfsroot.c
index fa148308822c..56b333bf3343 100644
--- a/fs/nfs/nfsroot.c
+++ b/fs/nfs/nfsroot.c
@@ -139,7 +139,7 @@ static int __init nfs_root_setup(char *line)
 	ROOT_DEV = Root_NFS;
 
 	if (line[0] == '/' || line[0] == ',' || (line[0] >= '0' && line[0] <= '9')) {
-		strlcpy(nfs_root_parms, line, sizeof(nfs_root_parms));
+		strscpy(nfs_root_parms, line, sizeof(nfs_root_parms));
 	} else {
 		size_t n = strlen(line) + sizeof(NFS_ROOT) - 1;
 		if (n >= sizeof(nfs_root_parms))
@@ -164,7 +164,7 @@ __setup("nfsroot=", nfs_root_setup);
 static int __init root_nfs_copy(char *dest, const char *src,
 				     const size_t destlen)
 {
-	if (strlcpy(dest, src, destlen) > destlen)
+	if (strscpy(dest, src, destlen) > destlen)
 		return -1;
 	return 0;
 }
diff --git a/fs/nfsd/nfs4idmap.c b/fs/nfsd/nfs4idmap.c
index f92161ce1f97..e70a1a2999b7 100644
--- a/fs/nfsd/nfs4idmap.c
+++ b/fs/nfsd/nfs4idmap.c
@@ -82,8 +82,8 @@ ent_init(struct cache_head *cnew, struct cache_head *citm)
 	new->id = itm->id;
 	new->type = itm->type;
 
-	strlcpy(new->name, itm->name, sizeof(new->name));
-	strlcpy(new->authname, itm->authname, sizeof(new->authname));
+	strscpy(new->name, itm->name, sizeof(new->name));
+	strscpy(new->authname, itm->authname, sizeof(new->authname));
 }
 
 static void
@@ -548,7 +548,7 @@ idmap_name_to_id(struct svc_rqst *rqstp, int type, const char *name, u32 namelen
 		return nfserr_badowner;
 	memcpy(key.name, name, namelen);
 	key.name[namelen] = '\0';
-	strlcpy(key.authname, rqst_authname(rqstp), sizeof(key.authname));
+	strscpy(key.authname, rqst_authname(rqstp), sizeof(key.authname));
 	ret = idmap_lookup(rqstp, nametoid_lookup, &key, nn->nametoid_cache, &item);
 	if (ret == -ENOENT)
 		return nfserr_badowner;
@@ -584,7 +584,7 @@ static __be32 idmap_id_to_name(struct xdr_stream *xdr,
 	int ret;
 	struct nfsd_net *nn = net_generic(SVC_NET(rqstp), nfsd_net_id);
 
-	strlcpy(key.authname, rqst_authname(rqstp), sizeof(key.authname));
+	strscpy(key.authname, rqst_authname(rqstp), sizeof(key.authname));
 	ret = idmap_lookup(rqstp, idtoname_lookup, &key, nn->idtoname_cache, &item);
 	if (ret == -ENOENT)
 		return encode_ascii_id(xdr, id);
diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 27b1ad136150..1e1d5393dd03 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -754,8 +754,7 @@ nfsd_svc(int nrservs, struct net *net, const struct cred *cred)
 	if (nrservs == 0 && nn->nfsd_serv == NULL)
 		goto out;
 
-	strlcpy(nn->nfsd_name, utsname()->nodename,
-		sizeof(nn->nfsd_name));
+	strscpy(nn->nfsd_name, utsname()->nodename, sizeof(nn->nfsd_name));
 
 	error = nfsd_create_serv(net);
 	if (error)
diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index 583820ec63e2..be64d6b0d657 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -82,7 +82,7 @@ static int param_set_dlmfs_capabilities(const char *val,
 static int param_get_dlmfs_capabilities(char *buffer,
 					const struct kernel_param *kp)
 {
-	return strlcpy(buffer, DLMFS_CAPABILITIES,
+	return strscpy(buffer, DLMFS_CAPABILITIES,
 		       strlen(DLMFS_CAPABILITIES) + 1);
 }
 module_param_call(capabilities, param_set_dlmfs_capabilities,
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index a191094694c6..4a11af45bdb9 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -336,10 +336,10 @@ int ocfs2_cluster_connect(const char *stack_name,
 		goto out;
 	}
 
-	strlcpy(new_conn->cc_name, group, GROUP_NAME_MAX + 1);
+	strscpy(new_conn->cc_name, group, GROUP_NAME_MAX + 1);
 	new_conn->cc_namelen = grouplen;
 	if (cluster_name_len)
-		strlcpy(new_conn->cc_cluster_name, cluster_name,
+		strscpy(new_conn->cc_cluster_name, cluster_name,
 			CLUSTER_NAME_MAX + 1);
 	new_conn->cc_cluster_name_len = cluster_name_len;
 	new_conn->cc_recovery_handler = recovery_handler;
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 2febc76e9de7..18d09d16501b 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2173,9 +2173,9 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	if (ocfs2_clusterinfo_valid(osb)) {
 		osb->osb_stackflags =
 			OCFS2_RAW_SB(di)->s_cluster_info.ci_stackflags;
-		strlcpy(osb->osb_cluster_stack,
-		       OCFS2_RAW_SB(di)->s_cluster_info.ci_stack,
-		       OCFS2_STACK_LABEL_LEN + 1);
+		strscpy(osb->osb_cluster_stack,
+			OCFS2_RAW_SB(di)->s_cluster_info.ci_stack,
+			OCFS2_STACK_LABEL_LEN + 1);
 		if (strlen(osb->osb_cluster_stack) != OCFS2_STACK_LABEL_LEN) {
 			mlog(ML_ERROR,
 			     "couldn't mount because of an invalid "
@@ -2184,7 +2184,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 			status = -EINVAL;
 			goto bail;
 		}
-		strlcpy(osb->osb_cluster_name,
+		strscpy(osb->osb_cluster_name,
 			OCFS2_RAW_SB(di)->s_cluster_info.ci_cluster,
 			OCFS2_CLUSTER_NAME_LEN + 1);
 	} else {
@@ -2257,7 +2257,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		goto bail;
 	}
 
-	strlcpy(osb->vol_label, di->id2.i_super.s_label,
+	strscpy(osb->vol_label, di->id2.i_super.s_label,
 		OCFS2_MAX_VOL_LABEL_LEN);
 	osb->root_blkno = le64_to_cpu(di->id2.i_super.s_root_blkno);
 	osb->system_dir_blkno = le64_to_cpu(di->id2.i_super.s_system_dir_blkno);
diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index e502414b3556..ef2a5942ebc3 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -421,7 +421,7 @@ read_kcore(struct file *file, char __user *buffer, size_t buflen, loff_t *fpos)
 		char *notes;
 		size_t i = 0;
 
-		strlcpy(prpsinfo.pr_psargs, saved_command_line,
+		strscpy(prpsinfo.pr_psargs, saved_command_line,
 			sizeof(prpsinfo.pr_psargs));
 
 		notes = kzalloc(notes_len, GFP_KERNEL);
diff --git a/fs/reiserfs/procfs.c b/fs/reiserfs/procfs.c
index 155b82870333..4df31e538515 100644
--- a/fs/reiserfs/procfs.c
+++ b/fs/reiserfs/procfs.c
@@ -411,7 +411,7 @@ int reiserfs_proc_info_init(struct super_block *sb)
 	char *s;
 
 	/* Some block devices use /'s */
-	strlcpy(b, sb->s_id, BDEVNAME_SIZE);
+	strscpy(b, sb->s_id, BDEVNAME_SIZE);
 	s = strchr(b, '/');
 	if (s)
 		*s = '!';
@@ -441,7 +441,7 @@ int reiserfs_proc_info_done(struct super_block *sb)
 		char *s;
 
 		/* Some block devices use /'s */
-		strlcpy(b, sb->s_id, BDEVNAME_SIZE);
+		strscpy(b, sb->s_id, BDEVNAME_SIZE);
 		s = strchr(b, '/');
 		if (s)
 			*s = '!';
diff --git a/fs/super.c b/fs/super.c
index 98bb0629ee10..a141529f3f16 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -544,7 +544,7 @@ struct super_block *sget_fc(struct fs_context *fc,
 	fc->s_fs_info = NULL;
 	s->s_type = fc->fs_type;
 	s->s_iflags |= fc->s_iflags;
-	strlcpy(s->s_id, s->s_type->name, sizeof(s->s_id));
+	strscpy(s->s_id, s->s_type->name, sizeof(s->s_id));
 	list_add_tail(&s->s_list, &super_blocks);
 	hlist_add_head(&s->s_instances, &s->s_type->fs_supers);
 	spin_unlock(&sb_lock);
@@ -623,7 +623,7 @@ struct super_block *sget(struct file_system_type *type,
 		return ERR_PTR(err);
 	}
 	s->s_type = type;
-	strlcpy(s->s_id, type->name, sizeof(s->s_id));
+	strscpy(s->s_id, type->name, sizeof(s->s_id));
 	list_add_tail(&s->s_list, &super_blocks);
 	hlist_add_head(&s->s_instances, &type->fs_supers);
 	spin_unlock(&sb_lock);
diff --git a/fs/vboxsf/super.c b/fs/vboxsf/super.c
index d7816c01a4f6..4ba703197ed8 100644
--- a/fs/vboxsf/super.c
+++ b/fs/vboxsf/super.c
@@ -179,7 +179,7 @@ static int vboxsf_fill_super(struct super_block *sb, struct fs_context *fc)
 	}
 	folder_name->size = size;
 	folder_name->length = size - 1;
-	strlcpy(folder_name->string.utf8, fc->source, size);
+	strscpy(folder_name->string.utf8, fc->source, size);
 	err = vboxsf_map_folder(folder_name, &sbi->root);
 	kfree(folder_name);
 	if (err) {
diff --git a/include/linux/gameport.h b/include/linux/gameport.h
index 69081d899492..8c2f00018e89 100644
--- a/include/linux/gameport.h
+++ b/include/linux/gameport.h
@@ -110,7 +110,7 @@ static inline void gameport_free_port(struct gameport *gameport)
 
 static inline void gameport_set_name(struct gameport *gameport, const char *name)
 {
-	strlcpy(gameport->name, name, sizeof(gameport->name));
+	strscpy(gameport->name, name, sizeof(gameport->name));
 }
 
 /*
diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 8af13ba60c7e..4434bfb8f00d 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -75,7 +75,7 @@ extern struct suspend_stats suspend_stats;
 
 static inline void dpm_save_failed_dev(const char *name)
 {
-	strlcpy(suspend_stats.failed_devs[suspend_stats.last_failed_dev],
+	strscpy(suspend_stats.failed_devs[suspend_stats.last_failed_dev],
 		name,
 		sizeof(suspend_stats.failed_devs[0]));
 	suspend_stats.last_failed_dev++;
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 9fd217b24916..be1af72433b9 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -445,7 +445,7 @@ static inline void rvt_set_ibdev_name(struct rvt_dev_info *rdi,
 	 * to work by setting the name manually here.
 	 */
 	dev_set_name(&rdi->ibdev.dev, fmt, name, unit);
-	strlcpy(rdi->ibdev.name, dev_name(&rdi->ibdev.dev), IB_DEVICE_NAME_MAX);
+	strscpy(rdi->ibdev.name, dev_name(&rdi->ibdev.dev), IB_DEVICE_NAME_MAX);
 }
 
 /**
diff --git a/include/trace/events/kyber.h b/include/trace/events/kyber.h
index c0e7d24ca256..794b2d713558 100644
--- a/include/trace/events/kyber.h
+++ b/include/trace/events/kyber.h
@@ -31,8 +31,8 @@ TRACE_EVENT(kyber_latency,
 
 	TP_fast_assign(
 		__entry->dev		= disk_devt(dev_to_disk(kobj_to_dev(q->kobj.parent)));
-		strlcpy(__entry->domain, domain, sizeof(__entry->domain));
-		strlcpy(__entry->type, type, sizeof(__entry->type));
+		strscpy(__entry->domain, domain, sizeof(__entry->domain));
+		strscpy(__entry->type, type, sizeof(__entry->type));
 		__entry->percentile	= percentile;
 		__entry->numerator	= numerator;
 		__entry->denominator	= denominator;
@@ -60,7 +60,7 @@ TRACE_EVENT(kyber_adjust,
 
 	TP_fast_assign(
 		__entry->dev		= disk_devt(dev_to_disk(kobj_to_dev(q->kobj.parent)));
-		strlcpy(__entry->domain, domain, sizeof(__entry->domain));
+		strscpy(__entry->domain, domain, sizeof(__entry->domain));
 		__entry->depth		= depth;
 	),
 
@@ -82,7 +82,7 @@ TRACE_EVENT(kyber_throttled,
 
 	TP_fast_assign(
 		__entry->dev		= disk_devt(dev_to_disk(kobj_to_dev(q->kobj.parent)));
-		strlcpy(__entry->domain, domain, sizeof(__entry->domain));
+		strscpy(__entry->domain, domain, sizeof(__entry->domain));
 	),
 
 	TP_printk("%d,%d %s", MAJOR(__entry->dev), MINOR(__entry->dev),
diff --git a/include/trace/events/task.h b/include/trace/events/task.h
index 64d160930b0d..47b527464d1a 100644
--- a/include/trace/events/task.h
+++ b/include/trace/events/task.h
@@ -47,7 +47,7 @@ TRACE_EVENT(task_rename,
 	TP_fast_assign(
 		__entry->pid = task->pid;
 		memcpy(entry->oldcomm, task->comm, TASK_COMM_LEN);
-		strlcpy(entry->newcomm, comm, TASK_COMM_LEN);
+		strscpy(entry->newcomm, comm, TASK_COMM_LEN);
 		__entry->oom_score_adj = task->signal->oom_score_adj;
 	),
 
diff --git a/include/trace/events/wbt.h b/include/trace/events/wbt.h
index 9c66e59d859c..4661f0d27062 100644
--- a/include/trace/events/wbt.h
+++ b/include/trace/events/wbt.h
@@ -33,7 +33,7 @@ TRACE_EVENT(wbt_stat,
 	),
 
 	TP_fast_assign(
-		strlcpy(__entry->name, bdi_dev_name(bdi),
+		strscpy(__entry->name, bdi_dev_name(bdi),
 			ARRAY_SIZE(__entry->name));
 		__entry->rmean		= stat[0].mean;
 		__entry->rmin		= stat[0].min;
@@ -68,7 +68,7 @@ TRACE_EVENT(wbt_lat,
 	),
 
 	TP_fast_assign(
-		strlcpy(__entry->name, bdi_dev_name(bdi),
+		strscpy(__entry->name, bdi_dev_name(bdi),
 			ARRAY_SIZE(__entry->name));
 		__entry->lat = div_u64(lat, 1000);
 	),
@@ -105,7 +105,7 @@ TRACE_EVENT(wbt_step,
 	),
 
 	TP_fast_assign(
-		strlcpy(__entry->name, bdi_dev_name(bdi),
+		strscpy(__entry->name, bdi_dev_name(bdi),
 			ARRAY_SIZE(__entry->name));
 		__entry->msg	= msg;
 		__entry->step	= step;
@@ -141,7 +141,7 @@ TRACE_EVENT(wbt_timer,
 	),
 
 	TP_fast_assign(
-		strlcpy(__entry->name, bdi_dev_name(bdi),
+		strscpy(__entry->name, bdi_dev_name(bdi),
 			ARRAY_SIZE(__entry->name));
 		__entry->status		= status;
 		__entry->step		= step;
diff --git a/init/do_mounts.c b/init/do_mounts.c
index b5f9604d0c98..a1b98cc88cc6 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -318,7 +318,7 @@ EXPORT_SYMBOL_GPL(name_to_dev_t);
 
 static int __init root_dev_setup(char *line)
 {
-	strlcpy(saved_root_name, line, sizeof(saved_root_name));
+	strscpy(saved_root_name, line, sizeof(saved_root_name));
 	return 1;
 }
 
diff --git a/init/main.c b/init/main.c
index 32b2a8affafd..c3a8932b1bc1 100644
--- a/init/main.c
+++ b/init/main.c
@@ -417,7 +417,7 @@ static void __init setup_boot_config(const char *cmdline)
 	/* Cut out the bootconfig data even if we have no bootconfig option */
 	data = get_boot_config_from_initrd(&size, &csum);
 
-	strlcpy(tmp_cmdline, boot_command_line, COMMAND_LINE_SIZE);
+	strscpy(tmp_cmdline, boot_command_line, COMMAND_LINE_SIZE);
 	err = parse_args("bootconfig", tmp_cmdline, NULL, 0, 0, 0, NULL,
 			 bootconfig_params);
 
@@ -756,7 +756,7 @@ void __init parse_early_param(void)
 		return;
 
 	/* All fall through to do_early_param. */
-	strlcpy(tmp_cmdline, boot_command_line, COMMAND_LINE_SIZE);
+	strscpy(tmp_cmdline, boot_command_line, COMMAND_LINE_SIZE);
 	parse_early_options(tmp_cmdline);
 	done = 1;
 }
diff --git a/kernel/acct.c b/kernel/acct.c
index f175df8f6aa4..a9f42133c057 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -426,7 +426,7 @@ static void fill_ac(acct_t *ac)
 	memset(ac, 0, sizeof(acct_t));
 
 	ac->ac_version = ACCT_VERSION | ACCT_BYTEORDER;
-	strlcpy(ac->ac_comm, current->comm, sizeof(ac->ac_comm));
+	strscpy(ac->ac_comm, current->comm, sizeof(ac->ac_comm));
 
 	/* calculate run_time in nsec*/
 	run_time = ktime_get_ns();
diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 191c329e482a..31b4b572adf5 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -549,7 +549,7 @@ static ssize_t cgroup_release_agent_write(struct kernfs_open_file *of,
 	if (!cgrp)
 		return -ENODEV;
 	spin_lock(&release_agent_path_lock);
-	strlcpy(cgrp->root->release_agent_path, strstrip(buf),
+	strscpy(cgrp->root->release_agent_path, strstrip(buf),
 		sizeof(cgrp->root->release_agent_path));
 	spin_unlock(&release_agent_path_lock);
 	cgroup_kn_unlock(of->kn);
@@ -787,7 +787,7 @@ void cgroup1_release_agent(struct work_struct *work)
 		goto out_free;
 
 	spin_lock(&release_agent_path_lock);
-	strlcpy(agentbuf, cgrp->root->release_agent_path, PATH_MAX);
+	strscpy(agentbuf, cgrp->root->release_agent_path, PATH_MAX);
 	spin_unlock(&release_agent_path_lock);
 	if (!agentbuf[0])
 		goto out_free;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index dc568ca295bd..e2c375104099 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7654,7 +7654,7 @@ static void perf_event_comm_event(struct perf_comm_event *comm_event)
 	unsigned int size;
 
 	memset(comm, 0, sizeof(comm));
-	strlcpy(comm, comm_event->task->comm, sizeof(comm));
+	strscpy(comm, comm_event->task->comm, sizeof(comm));
 	size = ALIGN(strlen(comm)+1, sizeof(u64));
 
 	comm_event->comm = comm;
@@ -8098,7 +8098,7 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 	}
 
 cpy_name:
-	strlcpy(tmp, name, sizeof(tmp));
+	strscpy(tmp, name, sizeof(tmp));
 	name = tmp;
 got_name:
 	/*
@@ -8525,7 +8525,7 @@ void perf_event_ksymbol(u16 ksym_type, u64 addr, u32 len, bool unregister,
 	    ksym_type == PERF_RECORD_KSYMBOL_TYPE_UNKNOWN)
 		goto err;
 
-	strlcpy(name, sym, KSYM_NAME_LEN);
+	strscpy(name, sym, KSYM_NAME_LEN);
 	name_len = strlen(name) + 1;
 	while (!IS_ALIGNED(name_len, sizeof(u64)))
 		name[name_len++] = '\0';
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index fe9de067771c..3af1298185d8 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -505,7 +505,7 @@ static int get_ksymbol_bpf(struct kallsym_iter *iter)
 {
 	int ret;
 
-	strlcpy(iter->module_name, "bpf", MODULE_NAME_LEN);
+	strscpy(iter->module_name, "bpf", MODULE_NAME_LEN);
 	iter->exported = 0;
 	ret = bpf_get_kallsym(iter->pos - iter->pos_ftrace_mod_end,
 			      &iter->value, &iter->type,
@@ -525,7 +525,7 @@ static int get_ksymbol_bpf(struct kallsym_iter *iter)
  */
 static int get_ksymbol_kprobe(struct kallsym_iter *iter)
 {
-	strlcpy(iter->module_name, "__builtin__kprobes", MODULE_NAME_LEN);
+	strscpy(iter->module_name, "__builtin__kprobes", MODULE_NAME_LEN);
 	iter->exported = 0;
 	return kprobe_get_kallsym(iter->pos - iter->pos_bpf_end,
 				  &iter->value, &iter->type,
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 41fdbb7953c6..61fa188562d6 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -319,7 +319,7 @@ int kprobe_cache_get_kallsym(struct kprobe_insn_cache *c, unsigned int *symnum,
 	list_for_each_entry_rcu(kip, &c->pages, list) {
 		if ((*symnum)--)
 			continue;
-		strlcpy(sym, c->sym, KSYM_NAME_LEN);
+		strscpy(sym, c->sym, KSYM_NAME_LEN);
 		*type = 't';
 		*value = (unsigned long)kip->insns;
 		ret = 0;
diff --git a/kernel/module.c b/kernel/module.c
index 7f3ee5fdeb93..3ba4be5b6aa0 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1040,7 +1040,7 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
 	async_synchronize_full();
 
 	/* Store the name of the last unloaded module for diagnostic purposes */
-	strlcpy(last_unloaded_module, mod->name, sizeof(last_unloaded_module));
+	strscpy(last_unloaded_module, mod->name, sizeof(last_unloaded_module));
 
 	free_module(mod);
 	/* someone could wait for the module in add_unformed_module() */
@@ -4202,7 +4202,7 @@ int lookup_module_symbol_name(unsigned long addr, char *symname)
 			if (!sym)
 				goto out;
 
-			strlcpy(symname, sym, KSYM_NAME_LEN);
+			strscpy(symname, sym, KSYM_NAME_LEN);
 			preempt_enable();
 			return 0;
 		}
@@ -4228,9 +4228,9 @@ int lookup_module_symbol_attrs(unsigned long addr, unsigned long *size,
 			if (!sym)
 				goto out;
 			if (modname)
-				strlcpy(modname, mod->name, MODULE_NAME_LEN);
+				strscpy(modname, mod->name, MODULE_NAME_LEN);
 			if (name)
-				strlcpy(name, sym, KSYM_NAME_LEN);
+				strscpy(name, sym, KSYM_NAME_LEN);
 			preempt_enable();
 			return 0;
 		}
@@ -4257,8 +4257,9 @@ int module_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
 
 			*value = kallsyms_symbol_value(sym);
 			*type = kallsyms->typetab[symnum];
-			strlcpy(name, kallsyms_symbol_name(kallsyms, symnum), KSYM_NAME_LEN);
-			strlcpy(module_name, mod->name, MODULE_NAME_LEN);
+			strscpy(name, kallsyms_symbol_name(kallsyms, symnum),
+				KSYM_NAME_LEN);
+			strscpy(module_name, mod->name, MODULE_NAME_LEN);
 			*exported = is_exported(name, *value, mod);
 			preempt_enable();
 			return 0;
diff --git a/kernel/params.c b/kernel/params.c
index 164d79330849..1b8e685e3848 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -828,7 +828,7 @@ static void __init param_sysfs_builtin(void)
 			name_len = 0;
 		} else {
 			name_len = dot - kp->name + 1;
-			strlcpy(modname, kp->name, name_len);
+			strscpy(modname, kp->name, name_len);
 		}
 		kernel_add_sysfs_param(modname, kp, name_len);
 	}
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index bc1e3b5a97bd..049cab1f156a 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2160,7 +2160,7 @@ static int __add_preferred_console(char *name, int idx, char *options,
 		return -E2BIG;
 	if (!brl_options)
 		preferred_console = i;
-	strlcpy(c->name, name, sizeof(c->name));
+	strscpy(c->name, name, sizeof(c->name));
 	c->options = options;
 	c->user_specified = user_specified;
 	braille_set_options(c, brl_options);
diff --git a/kernel/relay.c b/kernel/relay.c
index b08d936d5fa7..ee5e992dac51 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -595,7 +595,7 @@ struct rchan *relay_open(const char *base_filename,
 	chan->private_data = private_data;
 	if (base_filename) {
 		chan->has_base_filename = 1;
-		strlcpy(chan->base_filename, base_filename, NAME_MAX);
+		strscpy(chan->base_filename, base_filename, NAME_MAX);
 	}
 	setup_callbacks(chan, cb);
 	kref_init(&chan->kref);
@@ -666,7 +666,7 @@ int relay_late_setup_files(struct rchan *chan,
 	if (!chan || !base_filename)
 		return -EINVAL;
 
-	strlcpy(chan->base_filename, base_filename, NAME_MAX);
+	strscpy(chan->base_filename, base_filename, NAME_MAX);
 
 	mutex_lock(&relay_channels_mutex);
 	/* Is chan already set up? */
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ae7ceba8fd4f..e3678606591c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -295,7 +295,7 @@ static inline void cfs_rq_tg_path(struct cfs_rq *cfs_rq, char *path, int len)
 	else if (cfs_rq && cfs_rq->tg->css.cgroup)
 		cgroup_path(cfs_rq->tg->css.cgroup, path, len);
 	else
-		strlcpy(path, "(null)", len);
+		strscpy(path, "(null)", len);
 }
 
 static inline bool list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq)
@@ -475,7 +475,7 @@ static inline struct cfs_rq *group_cfs_rq(struct sched_entity *grp)
 static inline void cfs_rq_tg_path(struct cfs_rq *cfs_rq, char *path, int len)
 {
 	if (path)
-		strlcpy(path, "(null)", len);
+		strscpy(path, "(null)", len);
 }
 
 static inline bool list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq)
@@ -11292,7 +11292,7 @@ char *sched_trace_cfs_rq_path(struct cfs_rq *cfs_rq, char *str, int len)
 {
 	if (!cfs_rq) {
 		if (str)
-			strlcpy(str, "(null)", len);
+			strscpy(str, "(null)", len);
 		else
 			return NULL;
 	}
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 02441ead3c3b..67d27caa6e52 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -1217,7 +1217,7 @@ static int __init boot_override_clocksource(char* str)
 {
 	mutex_lock(&clocksource_mutex);
 	if (str)
-		strlcpy(override_name, str, sizeof(override_name));
+		strscpy(override_name, str, sizeof(override_name));
 	mutex_unlock(&clocksource_mutex);
 	return 1;
 }
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 9c1bba8cc51b..36b7741e507e 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5487,7 +5487,7 @@ bool ftrace_filter_param __initdata;
 static int __init set_ftrace_notrace(char *str)
 {
 	ftrace_filter_param = true;
-	strlcpy(ftrace_notrace_buf, str, FTRACE_FILTER_SIZE);
+	strscpy(ftrace_notrace_buf, str, FTRACE_FILTER_SIZE);
 	return 1;
 }
 __setup("ftrace_notrace=", set_ftrace_notrace);
@@ -5495,7 +5495,7 @@ __setup("ftrace_notrace=", set_ftrace_notrace);
 static int __init set_ftrace_filter(char *str)
 {
 	ftrace_filter_param = true;
-	strlcpy(ftrace_filter_buf, str, FTRACE_FILTER_SIZE);
+	strscpy(ftrace_filter_buf, str, FTRACE_FILTER_SIZE);
 	return 1;
 }
 __setup("ftrace_filter=", set_ftrace_filter);
@@ -5507,14 +5507,14 @@ static int ftrace_graph_set_hash(struct ftrace_hash *hash, char *buffer);
 
 static int __init set_graph_function(char *str)
 {
-	strlcpy(ftrace_graph_buf, str, FTRACE_FILTER_SIZE);
+	strscpy(ftrace_graph_buf, str, FTRACE_FILTER_SIZE);
 	return 1;
 }
 __setup("ftrace_graph_filter=", set_graph_function);
 
 static int __init set_graph_notrace_function(char *str)
 {
-	strlcpy(ftrace_graph_notrace_buf, str, FTRACE_FILTER_SIZE);
+	strscpy(ftrace_graph_notrace_buf, str, FTRACE_FILTER_SIZE);
 	return 1;
 }
 __setup("ftrace_graph_notrace=", set_graph_notrace_function);
@@ -6264,8 +6264,8 @@ static int ftrace_get_trampoline_kallsym(unsigned int symnum,
 			continue;
 		*value = op->trampoline;
 		*type = 't';
-		strlcpy(name, FTRACE_TRAMPOLINE_SYM, KSYM_NAME_LEN);
-		strlcpy(module_name, FTRACE_TRAMPOLINE_MOD, MODULE_NAME_LEN);
+		strscpy(name, FTRACE_TRAMPOLINE_SYM, KSYM_NAME_LEN);
+		strscpy(module_name, FTRACE_TRAMPOLINE_MOD, MODULE_NAME_LEN);
 		*exported = 0;
 		return 0;
 	}
@@ -6584,7 +6584,7 @@ ftrace_func_address_lookup(struct ftrace_mod_map *mod_map,
 		if (off)
 			*off = addr - found_func->ip;
 		if (sym)
-			strlcpy(sym, found_func->name, KSYM_NAME_LEN);
+			strscpy(sym, found_func->name, KSYM_NAME_LEN);
 
 		return found_func->name;
 	}
@@ -6638,8 +6638,9 @@ int ftrace_mod_get_kallsym(unsigned int symnum, unsigned long *value,
 
 			*value = mod_func->ip;
 			*type = 'T';
-			strlcpy(name, mod_func->name, KSYM_NAME_LEN);
-			strlcpy(module_name, mod_map->mod->name, MODULE_NAME_LEN);
+			strscpy(name, mod_func->name, KSYM_NAME_LEN);
+			strscpy(module_name, mod_map->mod->name,
+				MODULE_NAME_LEN);
 			*exported = 1;
 			preempt_enable();
 			return 0;
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 7d53c5bdea3e..0ae08fd61654 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -174,7 +174,7 @@ static bool allocate_snapshot;
 
 static int __init set_cmdline_ftrace(char *str)
 {
-	strlcpy(bootup_tracer_buf, str, MAX_TRACER_SIZE);
+	strscpy(bootup_tracer_buf, str, MAX_TRACER_SIZE);
 	default_bootup_tracer = bootup_tracer_buf;
 	/* We are using ftrace early, expand it */
 	ring_buffer_expanded = true;
@@ -220,7 +220,7 @@ static char trace_boot_options_buf[MAX_TRACER_SIZE] __initdata;
 
 static int __init set_trace_boot_options(char *str)
 {
-	strlcpy(trace_boot_options_buf, str, MAX_TRACER_SIZE);
+	strscpy(trace_boot_options_buf, str, MAX_TRACER_SIZE);
 	return 0;
 }
 __setup("trace_options=", set_trace_boot_options);
@@ -230,7 +230,7 @@ static char *trace_boot_clock __initdata;
 
 static int __init set_trace_boot_clock(char *str)
 {
-	strlcpy(trace_boot_clock_buf, str, MAX_TRACER_SIZE);
+	strscpy(trace_boot_clock_buf, str, MAX_TRACER_SIZE);
 	trace_boot_clock = trace_boot_clock_buf;
 	return 0;
 }
@@ -2445,7 +2445,7 @@ static void __trace_find_cmdline(int pid, char comm[])
 
 	map = savedcmd->map_pid_to_cmdline[pid];
 	if (map != NO_CMDLINE_MAP)
-		strlcpy(comm, get_saved_cmdlines(map), TASK_COMM_LEN);
+		strscpy(comm, get_saved_cmdlines(map), TASK_COMM_LEN);
 	else
 		strcpy(comm, "<...>");
 }
diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index c22a152ef0b4..12564ed7e979 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -31,7 +31,7 @@ trace_boot_set_instance_options(struct trace_array *tr, struct xbc_node *node)
 
 	/* Common ftrace options */
 	xbc_node_for_each_array_value(node, "options", anode, p) {
-		if (strlcpy(buf, p, ARRAY_SIZE(buf)) >= ARRAY_SIZE(buf)) {
+		if (strscpy(buf, p, ARRAY_SIZE(buf)) >= ARRAY_SIZE(buf)) {
 			pr_err("String is too long: %s\n", p);
 			continue;
 		}
@@ -87,7 +87,7 @@ trace_boot_enable_events(struct trace_array *tr, struct xbc_node *node)
 	const char *p;
 
 	xbc_node_for_each_array_value(node, "events", anode, p) {
-		if (strlcpy(buf, p, ARRAY_SIZE(buf)) >= ARRAY_SIZE(buf)) {
+		if (strscpy(buf, p, ARRAY_SIZE(buf)) >= ARRAY_SIZE(buf)) {
 			pr_err("String is too long: %s\n", p);
 			continue;
 		}
@@ -199,14 +199,14 @@ trace_boot_init_one_event(struct trace_array *tr, struct xbc_node *gnode,
 
 	p = xbc_node_find_value(enode, "filter", NULL);
 	if (p && *p != '\0') {
-		if (strlcpy(buf, p, ARRAY_SIZE(buf)) >= ARRAY_SIZE(buf))
+		if (strscpy(buf, p, ARRAY_SIZE(buf)) >= ARRAY_SIZE(buf))
 			pr_err("filter string is too long: %s\n", p);
 		else if (apply_event_filter(file, buf) < 0)
 			pr_err("Failed to apply filter: %s\n", buf);
 	}
 
 	xbc_node_for_each_array_value(enode, "actions", anode, p) {
-		if (strlcpy(buf, p, ARRAY_SIZE(buf)) >= ARRAY_SIZE(buf))
+		if (strscpy(buf, p, ARRAY_SIZE(buf)) >= ARRAY_SIZE(buf))
 			pr_err("action string is too long: %s\n", p);
 		else if (trigger_process_regex(file, buf) < 0)
 			pr_err("Failed to apply an action: %s\n", buf);
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 47a71f96e5bc..fdc41f5b66c8 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -3199,7 +3199,7 @@ static char bootup_event_buf[COMMAND_LINE_SIZE] __initdata;
 
 static __init int setup_trace_event(char *str)
 {
-	strlcpy(bootup_event_buf, str, COMMAND_LINE_SIZE);
+	strscpy(bootup_event_buf, str, COMMAND_LINE_SIZE);
 	ring_buffer_expanded = true;
 	tracing_selftest_disabled = true;
 
diff --git a/kernel/trace/trace_events_inject.c b/kernel/trace/trace_events_inject.c
index 22bcf7c51d1e..c83b31358d53 100644
--- a/kernel/trace/trace_events_inject.c
+++ b/kernel/trace/trace_events_inject.c
@@ -215,7 +215,8 @@ static int parse_entry(char *str, struct trace_event_call *call, void **pentry)
 			char *addr = (char *)(unsigned long) val;
 
 			if (field->filter_type == FILTER_STATIC_STRING) {
-				strlcpy(entry + field->offset, addr, field->size);
+				strscpy(entry + field->offset, addr,
+					field->size);
 			} else if (field->filter_type == FILTER_DYN_STRING) {
 				int str_len = strlen(addr) + 1;
 				int str_loc = entry_size & 0xffff;
@@ -229,7 +230,8 @@ static int parse_entry(char *str, struct trace_event_call *call, void **pentry)
 				}
 				entry = *pentry;
 
-				strlcpy(entry + (entry_size - str_len), addr, str_len);
+				strscpy(entry + (entry_size - str_len), addr,
+					str_len);
 				str_item = (u32 *)(entry + field->offset);
 				*str_item = (str_len << 16) | str_loc;
 			} else {
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index b911e9f6d9f5..4a63cd835426 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -29,7 +29,7 @@ static bool kprobe_boot_events_enabled __initdata;
 
 static int __init set_kprobe_boot_events(char *str)
 {
-	strlcpy(kprobe_boot_events_buf, str, COMMAND_LINE_SIZE);
+	strscpy(kprobe_boot_events_buf, str, COMMAND_LINE_SIZE);
 	return 0;
 }
 __setup("kprobe_event=", set_kprobe_boot_events);
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index d2867ccc6aca..7864b8091bb8 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -242,7 +242,7 @@ int traceprobe_parse_event_name(const char **pevent, const char **pgroup,
 			trace_probe_log_err(offset, GROUP_TOO_LONG);
 			return -EINVAL;
 		}
-		strlcpy(buf, event, slash - event + 1);
+		strscpy(buf, event, slash - event + 1);
 		if (!is_good_name(buf)) {
 			trace_probe_log_err(offset, BAD_GROUP_NAME);
 			return -EINVAL;
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index bd7b3aaa93c3..69bc5aa20a92 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -745,7 +745,7 @@ static __init int ddebug_setup_query(char *str)
 		pr_warn("ddebug boot param string too large\n");
 		return 0;
 	}
-	strlcpy(ddebug_setup_string, str, DDEBUG_STRING_SIZE);
+	strscpy(ddebug_setup_string, str, DDEBUG_STRING_SIZE);
 	return 1;
 }
 
diff --git a/lib/earlycpio.c b/lib/earlycpio.c
index e83628882001..4391307526e5 100644
--- a/lib/earlycpio.c
+++ b/lib/earlycpio.c
@@ -126,7 +126,7 @@ struct cpio_data find_cpio_data(const char *path, void *data,
 				"File %s exceeding MAX_CPIO_FILE_NAME [%d]\n",
 				p, MAX_CPIO_FILE_NAME);
 			}
-			strlcpy(cd.name, p + mypathsize, MAX_CPIO_FILE_NAME);
+			strscpy(cd.name, p + mypathsize, MAX_CPIO_FILE_NAME);
 
 			cd.data = (void *)dptr;
 			cd.size = ch[C_FILESIZE];
diff --git a/mm/dmapool.c b/mm/dmapool.c
index a97c97232337..38cf2a77d2ef 100644
--- a/mm/dmapool.c
+++ b/mm/dmapool.c
@@ -156,7 +156,7 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
 	if (!retval)
 		return retval;
 
-	strlcpy(retval->name, name, sizeof(retval->name));
+	strscpy(retval->name, name, sizeof(retval->name));
 
 	retval->dev = dev;
 
diff --git a/mm/kasan/report.c b/mm/kasan/report.c
index 00a53f1355ae..aa80cf97e932 100644
--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -235,7 +235,7 @@ static bool __must_check tokenize_frame_descr(const char **frame_descr,
 		}
 
 		/* Copy token (+ 1 byte for '\0'). */
-		strlcpy(token, *frame_descr, tok_len + 1);
+		strscpy(token, *frame_descr, tok_len + 1);
 	}
 
 	/* Advance frame_descr past separator. */
diff --git a/mm/zswap.c b/mm/zswap.c
index fbb782924ccc..f5ca0b5c3221 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -560,7 +560,7 @@ static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
 	}
 	pr_debug("using %s zpool\n", zpool_get_type(pool->zpool));
 
-	strlcpy(pool->tfm_name, compressor, sizeof(pool->tfm_name));
+	strscpy(pool->tfm_name, compressor, sizeof(pool->tfm_name));
 	pool->tfm = alloc_percpu(struct crypto_comp *);
 	if (!pool->tfm) {
 		pr_err("percpu alloc failed\n");
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index ec8408d1638f..d9173d60faf7 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -658,9 +658,9 @@ static int vlan_ethtool_get_link_ksettings(struct net_device *dev,
 static void vlan_ethtool_get_drvinfo(struct net_device *dev,
 				     struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, vlan_fullname, sizeof(info->driver));
-	strlcpy(info->version, vlan_version, sizeof(info->version));
-	strlcpy(info->fw_version, "N/A", sizeof(info->fw_version));
+	strscpy(info->driver, vlan_fullname, sizeof(info->driver));
+	strscpy(info->version, vlan_version, sizeof(info->version));
+	strscpy(info->fw_version, "N/A", sizeof(info->fw_version));
 }
 
 static int vlan_ethtool_get_ts_info(struct net_device *dev,
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 269ee89d2c2b..dbe66440c347 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -753,7 +753,7 @@ static int ax25_getsockopt(struct socket *sock, int level, int optname,
 		ax25_dev = ax25->ax25_dev;
 
 		if (ax25_dev != NULL && ax25_dev->dev != NULL) {
-			strlcpy(devname, ax25_dev->dev->name, sizeof(devname));
+			strscpy(devname, ax25_dev->dev->name, sizeof(devname));
 			length = strlen(devname) + 1;
 		} else {
 			*devname = '\0';
diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index 3b4fa27a44e6..7ab3a8c1ff89 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -83,14 +83,14 @@ static void hidp_copy_session(struct hidp_session *session, struct hidp_conninfo
 		ci->product = session->input->id.product;
 		ci->version = session->input->id.version;
 		if (session->input->name)
-			strlcpy(ci->name, session->input->name, 128);
+			strscpy(ci->name, session->input->name, 128);
 		else
-			strlcpy(ci->name, "HID Boot Device", 128);
+			strscpy(ci->name, "HID Boot Device", 128);
 	} else if (session->hid) {
 		ci->vendor  = session->hid->vendor;
 		ci->product = session->hid->product;
 		ci->version = session->hid->version;
-		strlcpy(ci->name, session->hid->name, 128);
+		strscpy(ci->name, session->hid->name, 128);
 	}
 }
 
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 7730c8f3cb53..6d9de385d0aa 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -254,10 +254,10 @@ static int br_set_mac_address(struct net_device *dev, void *p)
 
 static void br_getinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, "bridge", sizeof(info->driver));
-	strlcpy(info->version, BR_VERSION, sizeof(info->version));
-	strlcpy(info->fw_version, "N/A", sizeof(info->fw_version));
-	strlcpy(info->bus_info, "N/A", sizeof(info->bus_info));
+	strscpy(info->driver, "bridge", sizeof(info->driver));
+	strscpy(info->version, BR_VERSION, sizeof(info->version));
+	strscpy(info->fw_version, "N/A", sizeof(info->fw_version));
+	strscpy(info->bus_info, "N/A", sizeof(info->bus_info));
 }
 
 static int br_get_link_ksettings(struct net_device *dev,
diff --git a/net/bridge/br_sysfs_if.c b/net/bridge/br_sysfs_if.c
index 7a59cdddd3ce..d88791ce391f 100644
--- a/net/bridge/br_sysfs_if.c
+++ b/net/bridge/br_sysfs_if.c
@@ -374,7 +374,7 @@ int br_sysfs_addif(struct net_bridge_port *p)
 			return err;
 	}
 
-	strlcpy(p->sysfs_name, p->dev->name, IFNAMSIZ);
+	strscpy(p->sysfs_name, p->dev->name, IFNAMSIZ);
 	return sysfs_create_link(br->ifobj, &p->kobj, p->sysfs_name);
 }
 
@@ -396,7 +396,7 @@ int br_sysfs_renameif(struct net_bridge_port *p)
 		netdev_notice(br->dev, "unable to rename link %s to %s",
 			      p->sysfs_name, p->dev->name);
 	else
-		strlcpy(p->sysfs_name, p->dev->name, IFNAMSIZ);
+		strscpy(p->sysfs_name, p->dev->name, IFNAMSIZ);
 
 	return err;
 }
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index ebe33b60efd6..a78d4070acac 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1308,7 +1308,7 @@ static inline int ebt_obj_to_user(char __user *um, const char *_name,
 	/* ebtables expects 31 bytes long names but xt_match names are 29 bytes
 	 * long. Copy 29 bytes and fill remaining bytes with zeroes.
 	 */
-	strlcpy(name, _name, sizeof(name));
+	strscpy(name, _name, sizeof(name));
 	if (copy_to_user(um, name, EBT_EXTENSION_MAXNAMELEN) ||
 	    put_user(revision, (u8 __user *)(um + EBT_EXTENSION_MAXNAMELEN)) ||
 	    put_user(datasize, (int __user *)(um + EBT_EXTENSION_MAXNAMELEN + 1)) ||
diff --git a/net/caif/caif_dev.c b/net/caif/caif_dev.c
index c10e5a55758d..3c122cfa6c99 100644
--- a/net/caif/caif_dev.c
+++ b/net/caif/caif_dev.c
@@ -341,8 +341,7 @@ void caif_enroll_dev(struct net_device *dev, struct caif_dev_common *caifdev,
 	mutex_lock(&caifdevs->lock);
 	list_add_rcu(&caifd->list, &caifdevs->list);
 
-	strlcpy(caifd->layer.name, dev->name,
-		sizeof(caifd->layer.name));
+	strscpy(caifd->layer.name, dev->name, sizeof(caifd->layer.name));
 	caifd->layer.transmit = transmit;
 	cfcnfg_add_phy_layer(cfg,
 				dev,
diff --git a/net/caif/caif_usb.c b/net/caif/caif_usb.c
index a0116b9503d9..eaa28e61fa35 100644
--- a/net/caif/caif_usb.c
+++ b/net/caif/caif_usb.c
@@ -175,7 +175,7 @@ static int cfusbl_device_notify(struct notifier_block *me, unsigned long what,
 		dev_add_pack(&caif_usb_type);
 	pack_added = true;
 
-	strlcpy(layer->name, dev->name, sizeof(layer->name));
+	strscpy(layer->name, dev->name, sizeof(layer->name));
 
 	return 0;
 }
diff --git a/net/caif/cfcnfg.c b/net/caif/cfcnfg.c
index 399239a14420..b8b4187ec195 100644
--- a/net/caif/cfcnfg.c
+++ b/net/caif/cfcnfg.c
@@ -268,14 +268,14 @@ static int caif_connect_req_to_link_param(struct cfcnfg *cnfg,
 	case CAIFPROTO_RFM:
 		l->linktype = CFCTRL_SRV_RFM;
 		l->u.datagram.connid = s->sockaddr.u.rfm.connection_id;
-		strlcpy(l->u.rfm.volume, s->sockaddr.u.rfm.volume,
+		strscpy(l->u.rfm.volume, s->sockaddr.u.rfm.volume,
 			sizeof(l->u.rfm.volume));
 		break;
 	case CAIFPROTO_UTIL:
 		l->linktype = CFCTRL_SRV_UTIL;
 		l->endpoint = 0x00;
 		l->chtype = 0x00;
-		strlcpy(l->u.utility.name, s->sockaddr.u.util.service,
+		strscpy(l->u.utility.name, s->sockaddr.u.util.service,
 			sizeof(l->u.utility.name));
 		caif_assert(sizeof(l->u.utility.name) > 10);
 		l->u.utility.paramlen = s->param.size;
diff --git a/net/caif/cfctrl.c b/net/caif/cfctrl.c
index 2809cbd6b7f7..cc405d8c7c30 100644
--- a/net/caif/cfctrl.c
+++ b/net/caif/cfctrl.c
@@ -258,7 +258,7 @@ int cfctrl_linkup_request(struct cflayer *layer,
 		tmp16 = cpu_to_le16(param->u.utility.fifosize_bufs);
 		cfpkt_add_body(pkt, &tmp16, 2);
 		memset(utility_name, 0, sizeof(utility_name));
-		strlcpy(utility_name, param->u.utility.name,
+		strscpy(utility_name, param->u.utility.name,
 			UTILITY_NAME_LENGTH);
 		cfpkt_add_body(pkt, utility_name, UTILITY_NAME_LENGTH);
 		tmp8 = param->u.utility.paramlen;
diff --git a/net/core/dev.c b/net/core/dev.c
index 8588ade790cb..188c9ad4fbe1 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -699,7 +699,7 @@ static int netdev_boot_setup_add(char *name, struct ifmap *map)
 	for (i = 0; i < NETDEV_BOOT_SETUP_MAX; i++) {
 		if (s[i].name[0] == '\0' || s[i].name[0] == ' ') {
 			memset(s[i].name, 0, sizeof(s[i].name));
-			strlcpy(s[i].name, name, IFNAMSIZ);
+			strscpy(s->name, name, IFNAMSIZ);
 			memcpy(&s[i].map, map, sizeof(s[i].map));
 			break;
 		}
@@ -1231,7 +1231,7 @@ static int dev_alloc_name_ns(struct net *net,
 	BUG_ON(!net);
 	ret = __dev_alloc_name(net, name, buf);
 	if (ret >= 0)
-		strlcpy(dev->name, buf, IFNAMSIZ);
+		strscpy(dev->name, buf, IFNAMSIZ);
 	return ret;
 }
 
@@ -1268,7 +1268,7 @@ static int dev_get_valid_name(struct net *net, struct net_device *dev,
 	else if (__dev_get_by_name(net, name))
 		return -EEXIST;
 	else if (dev->name != name)
-		strlcpy(dev->name, name, IFNAMSIZ);
+		strscpy(dev->name, name, IFNAMSIZ);
 
 	return 0;
 }
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 571f191c06d9..682a7febe388 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -466,7 +466,7 @@ net_dm_hw_trap_summary_probe(void *ignore, const struct devlink *devlink,
 		goto out;
 
 	hw_entry = &hw_entries->entries[hw_entries->num_entries];
-	strlcpy(hw_entry->trap_name, metadata->trap_name,
+	strscpy(hw_entry->trap_name, metadata->trap_name,
 		NET_DM_MAX_HW_TRAP_NAME_LEN - 1);
 	hw_entry->count = 1;
 	hw_entries->num_entries++;
diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 960948290001..03bfcac17aed 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -555,7 +555,7 @@ int netpoll_parse_options(struct netpoll *np, char *opt)
 		if ((delim = strchr(cur, ',')) == NULL)
 			goto parse_failed;
 		*delim = 0;
-		strlcpy(np->dev_name, cur, sizeof(np->dev_name));
+		strscpy(np->dev_name, cur, sizeof(np->dev_name));
 		cur = delim;
 	}
 	cur++;
@@ -609,7 +609,7 @@ int __netpoll_setup(struct netpoll *np, struct net_device *ndev)
 	int err;
 
 	np->dev = ndev;
-	strlcpy(np->dev_name, ndev->name, IFNAMSIZ);
+	strscpy(np->dev_name, ndev->name, IFNAMSIZ);
 
 	if (ndev->priv_flags & IFF_DISABLE_NETPOLL) {
 		np_err(np, "%s doesn't support polling, aborting\n",
diff --git a/net/dsa/master.c b/net/dsa/master.c
index c91de041a91d..faacc92c6bf2 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -58,7 +58,7 @@ static void dsa_master_get_regs(struct net_device *dev,
 	}
 
 	cpu_info = (struct ethtool_drvinfo *)data;
-	strlcpy(cpu_info->driver, "dsa", sizeof(cpu_info->driver));
+	strscpy(cpu_info->driver, "dsa", sizeof(cpu_info->driver));
 	data += sizeof(*cpu_info);
 	cpu_regs = (struct ethtool_regs *)data;
 	data += sizeof(*cpu_regs);
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 3bc5ca40c9fb..09055a159f6c 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -584,9 +584,9 @@ static netdev_tx_t dsa_slave_xmit(struct sk_buff *skb, struct net_device *dev)
 static void dsa_slave_get_drvinfo(struct net_device *dev,
 				  struct ethtool_drvinfo *drvinfo)
 {
-	strlcpy(drvinfo->driver, "dsa", sizeof(drvinfo->driver));
-	strlcpy(drvinfo->fw_version, "N/A", sizeof(drvinfo->fw_version));
-	strlcpy(drvinfo->bus_info, "platform", sizeof(drvinfo->bus_info));
+	strscpy(drvinfo->driver, "dsa", sizeof(drvinfo->driver));
+	strscpy(drvinfo->fw_version, "N/A", sizeof(drvinfo->fw_version));
+	strscpy(drvinfo->bus_info, "platform", sizeof(drvinfo->bus_info));
 }
 
 static int dsa_slave_get_regs_len(struct net_device *dev)
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index ec2cd7aab5ad..30fec06a45b3 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -703,13 +703,13 @@ static noinline_for_stack int ethtool_get_drvinfo(struct net_device *dev,
 
 	memset(&info, 0, sizeof(info));
 	info.cmd = ETHTOOL_GDRVINFO;
-	strlcpy(info.version, UTS_RELEASE, sizeof(info.version));
+	strscpy(info.version, UTS_RELEASE, sizeof(info.version));
 	if (ops->get_drvinfo) {
 		ops->get_drvinfo(dev, &info);
 	} else if (dev->dev.parent && dev->dev.parent->driver) {
-		strlcpy(info.bus_info, dev_name(dev->dev.parent),
+		strscpy(info.bus_info, dev_name(dev->dev.parent),
 			sizeof(info.bus_info));
-		strlcpy(info.driver, dev->dev.parent->driver->name,
+		strscpy(info.driver, dev->dev.parent->driver->name,
 			sizeof(info.driver));
 	} else {
 		return -EOPNOTSUPP;
diff --git a/net/ieee802154/trace.h b/net/ieee802154/trace.h
index 19c2e5d60e76..34b85a37e769 100644
--- a/net/ieee802154/trace.h
+++ b/net/ieee802154/trace.h
@@ -13,7 +13,7 @@
 
 #define MAXNAME		32
 #define WPAN_PHY_ENTRY	__array(char, wpan_phy_name, MAXNAME)
-#define WPAN_PHY_ASSIGN	strlcpy(__entry->wpan_phy_name,	 \
+#define WPAN_PHY_ASSIGN	strscpy(__entry->wpan_phy_name,	 \
 				wpan_phy_name(wpan_phy), \
 				MAXNAME)
 #define WPAN_PHY_PR_FMT	"%s"
diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index 922dd73e5740..c192a101dc7d 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -1108,7 +1108,7 @@ static int arp_req_get(struct arpreq *r, struct net_device *dev)
 			r->arp_flags = arp_state_to_flags(neigh);
 			read_unlock_bh(&neigh->lock);
 			r->arp_ha.sa_family = dev->type;
-			strlcpy(r->arp_dev, dev->name, sizeof(r->arp_dev));
+			strscpy(r->arp_dev, dev->name, sizeof(r->arp_dev));
 			err = 0;
 		}
 		neigh_release(neigh);
diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index ee65c9225178..fb0b981028fd 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -242,7 +242,7 @@ static struct net_device *__ip_tunnel_create(struct net *net,
 	if (parms->name[0]) {
 		if (!dev_valid_name(parms->name))
 			goto failed;
-		strlcpy(name, parms->name, IFNAMSIZ);
+		strscpy(name, parms->name, IFNAMSIZ);
 	} else {
 		if (strlen(ops->kind) > (IFNAMSIZ - 3))
 			goto failed;
@@ -1057,7 +1057,7 @@ int ip_tunnel_init_net(struct net *net, unsigned int ip_tnl_net_id,
 
 	memset(&parms, 0, sizeof(parms));
 	if (devname)
-		strlcpy(parms.name, devname, IFNAMSIZ);
+		strscpy(parms.name, devname, IFNAMSIZ);
 
 	rtnl_lock();
 	itn->fb_tunnel_dev = __ip_tunnel_create(net, ops, &parms);
diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index 561f15b5a944..af231eb76be7 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -1728,15 +1728,16 @@ static int __init ip_auto_config_setup(char *addrs)
 			case 4:
 				if ((dp = strchr(ip, '.'))) {
 					*dp++ = '\0';
-					strlcpy(utsname()->domainname, dp,
+					strscpy(utsname()->domainname, dp,
 						sizeof(utsname()->domainname));
 				}
-				strlcpy(utsname()->nodename, ip,
+				strscpy(utsname()->nodename, ip,
 					sizeof(utsname()->nodename));
 				ic_host_name_set = 1;
 				break;
 			case 5:
-				strlcpy(user_dev_name, ip, sizeof(user_dev_name));
+				strscpy(user_dev_name, ip,
+					sizeof(user_dev_name));
 				break;
 			case 6:
 				if (ic_proto_name(ip) == 0 &&
@@ -1783,8 +1784,7 @@ __setup("nfsaddrs=", nfsaddrs_config_setup);
 
 static int __init vendor_class_identifier_setup(char *addrs)
 {
-	if (strlcpy(vendor_class_identifier, addrs,
-		    sizeof(vendor_class_identifier))
+	if (strscpy(vendor_class_identifier, addrs, sizeof(vendor_class_identifier))
 	    >= sizeof(vendor_class_identifier))
 		pr_warn("DHCP: vendorclass too long, truncated to \"%s\"\n",
 			vendor_class_identifier);
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index cf6e1380b527..80291f2f1d1e 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -360,7 +360,7 @@ static struct ip6_tnl *ip6gre_tunnel_locate(struct net *net,
 	if (parms->name[0]) {
 		if (!dev_valid_name(parms->name))
 			return NULL;
-		strlcpy(name, parms->name, IFNAMSIZ);
+		strscpy(name, parms->name, IFNAMSIZ);
 	} else {
 		strcpy(name, "ip6gre%d");
 	}
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 648db3fe508f..76086413189c 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -323,7 +323,7 @@ static struct ip6_tnl *ip6_tnl_create(struct net *net, struct __ip6_tnl_parm *p)
 	if (p->name[0]) {
 		if (!dev_valid_name(p->name))
 			goto failed;
-		strlcpy(name, p->name, IFNAMSIZ);
+		strscpy(name, p->name, IFNAMSIZ);
 	} else {
 		sprintf(name, "ip6tnl%%d");
 	}
diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index 5f9c4fdc120d..f6a57b5c2181 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -211,7 +211,7 @@ static struct ip6_tnl *vti6_tnl_create(struct net *net, struct __ip6_tnl_parm *p
 	if (p->name[0]) {
 		if (!dev_valid_name(p->name))
 			goto failed;
-		strlcpy(name, p->name, IFNAMSIZ);
+		strscpy(name, p->name, IFNAMSIZ);
 	} else {
 		sprintf(name, "ip6_vti%%d");
 	}
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 5e7983cb6154..c18738855eec 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -256,7 +256,7 @@ static struct ip_tunnel *ipip6_tunnel_locate(struct net *net,
 	if (parms->name[0]) {
 		if (!dev_valid_name(parms->name))
 			goto failed;
-		strlcpy(name, parms->name, IFNAMSIZ);
+		strscpy(name, parms->name, IFNAMSIZ);
 	} else {
 		strcpy(name, "sit%d");
 	}
diff --git a/net/l2tp/l2tp_eth.c b/net/l2tp/l2tp_eth.c
index 6cd97c75445c..f2ae03c40473 100644
--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -254,7 +254,7 @@ static int l2tp_eth_create(struct net *net, struct l2tp_tunnel *tunnel,
 	int rc;
 
 	if (cfg->ifname) {
-		strlcpy(name, cfg->ifname, IFNAMSIZ);
+		strscpy(name, cfg->ifname, IFNAMSIZ);
 		name_assign_type = NET_NAME_USER;
 	} else {
 		strcpy(name, L2TP_ETH_DEV_NAME);
@@ -314,7 +314,7 @@ static int l2tp_eth_create(struct net *net, struct l2tp_tunnel *tunnel,
 		return rc;
 	}
 
-	strlcpy(session->ifname, dev->name, IFNAMSIZ);
+	strscpy(session->ifname, dev->name, IFNAMSIZ);
 	rcu_assign_pointer(spriv->dev, dev);
 
 	rtnl_unlock();
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 1be775979132..e3de6d57d4e7 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1861,7 +1861,7 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 		wdev = &sdata->wdev;
 
 		sdata->dev = NULL;
-		strlcpy(sdata->name, name, IFNAMSIZ);
+		strscpy(sdata->name, name, IFNAMSIZ);
 		ieee80211_assign_perm_addr(local, wdev->address, type);
 		memcpy(sdata->vif.addr, wdev->address, ETH_ALEN);
 	} else {
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 89723907a094..298e822707f9 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -17,7 +17,7 @@
 
 #define MAXNAME		32
 #define LOCAL_ENTRY	__array(char, wiphy_name, 32)
-#define LOCAL_ASSIGN	strlcpy(__entry->wiphy_name, wiphy_name(local->hw.wiphy), MAXNAME)
+#define LOCAL_ASSIGN	strscpy(__entry->wiphy_name, wiphy_name(local->hw.wiphy), MAXNAME)
 #define LOCAL_PR_FMT	"%s"
 #define LOCAL_PR_ARG	__entry->wiphy_name
 
diff --git a/net/mac802154/trace.h b/net/mac802154/trace.h
index df855c33daf2..4a337f9c9e75 100644
--- a/net/mac802154/trace.h
+++ b/net/mac802154/trace.h
@@ -14,7 +14,7 @@
 
 #define MAXNAME		32
 #define LOCAL_ENTRY	__array(char, wpan_phy_name, MAXNAME)
-#define LOCAL_ASSIGN	strlcpy(__entry->wpan_phy_name, \
+#define LOCAL_ASSIGN	strscpy(__entry->wpan_phy_name, \
 				wpan_phy_name(local->hw.phy), MAXNAME)
 #define LOCAL_PR_FMT	"%s"
 #define LOCAL_PR_ARG	__entry->wpan_phy_name
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 2b19189a930f..51b9a2001ffc 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -353,7 +353,7 @@ ip_set_init_comment(struct ip_set *set, struct ip_set_comment *comment,
 	c = kmalloc(sizeof(*c) + len + 1, GFP_ATOMIC);
 	if (unlikely(!c))
 		return;
-	strlcpy(c->str, ext->comment, len + 1);
+	strscpy(c->str, ext->comment, len + 1);
 	set->ext_size += sizeof(*c) + strlen(c->str) + 1;
 	rcu_assign_pointer(comment->c, c);
 }
@@ -1087,7 +1087,7 @@ static int ip_set_create(struct net *net, struct sock *ctnl,
 	if (!set)
 		return -ENOMEM;
 	spin_lock_init(&set->lock);
-	strlcpy(set->name, name, IPSET_MAXNAMELEN);
+	strscpy(set->name, name, IPSET_MAXNAMELEN);
 	set->family = family;
 	set->revision = revision;
 
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
index be5e95a0d876..aecdde3c7719 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -39,7 +39,7 @@ MODULE_ALIAS("ip_set_hash:net,iface");
 #define IP_SET_HASH_WITH_MULTI
 #define IP_SET_HASH_WITH_NET0
 
-#define STRLCPY(a, b)	strlcpy(a, b, IFNAMSIZ)
+#define STRLCPY(a, b)	strscpy(a, b, IFNAMSIZ)
 
 /* IPv4 variant */
 
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index d45dbcba8b49..05cc7ba5443f 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2609,7 +2609,7 @@ ip_vs_copy_service(struct ip_vs_service_entry *dst, struct ip_vs_service *src)
 	dst->addr = src->addr.ip;
 	dst->port = src->port;
 	dst->fwmark = src->fwmark;
-	strlcpy(dst->sched_name, sched_name, sizeof(dst->sched_name));
+	strscpy(dst->sched_name, sched_name, sizeof(dst->sched_name));
 	dst->flags = src->flags;
 	dst->timeout = src->timeout / HZ;
 	dst->netmask = src->netmask;
@@ -2803,13 +2803,13 @@ do_ip_vs_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 		mutex_lock(&ipvs->sync_mutex);
 		if (ipvs->sync_state & IP_VS_STATE_MASTER) {
 			d[0].state = IP_VS_STATE_MASTER;
-			strlcpy(d[0].mcast_ifn, ipvs->mcfg.mcast_ifn,
+			strscpy(d->mcast_ifn, ipvs->mcfg.mcast_ifn,
 				sizeof(d[0].mcast_ifn));
 			d[0].syncid = ipvs->mcfg.syncid;
 		}
 		if (ipvs->sync_state & IP_VS_STATE_BACKUP) {
 			d[1].state = IP_VS_STATE_BACKUP;
-			strlcpy(d[1].mcast_ifn, ipvs->bcfg.mcast_ifn,
+			strscpy(d->mcast_ifn, ipvs->bcfg.mcast_ifn,
 				sizeof(d[1].mcast_ifn));
 			d[1].syncid = ipvs->bcfg.syncid;
 		}
@@ -3559,7 +3559,7 @@ static int ip_vs_genl_new_daemon(struct netns_ipvs *ipvs, struct nlattr **attrs)
 	      attrs[IPVS_DAEMON_ATTR_MCAST_IFN] &&
 	      attrs[IPVS_DAEMON_ATTR_SYNC_ID]))
 		return -EINVAL;
-	strlcpy(c.mcast_ifn, nla_data(attrs[IPVS_DAEMON_ATTR_MCAST_IFN]),
+	strscpy(c.mcast_ifn, nla_data(attrs[IPVS_DAEMON_ATTR_MCAST_IFN]),
 		sizeof(c.mcast_ifn));
 	c.syncid = nla_get_u32(attrs[IPVS_DAEMON_ATTR_SYNC_ID]);
 
diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 6cb9f9474b05..8fe530751498 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -453,9 +453,9 @@ static int nf_log_proc_dostring(struct ctl_table *table, int write,
 		mutex_lock(&nf_log_mutex);
 		logger = nft_log_dereference(net->nf.nf_loggers[tindex]);
 		if (!logger)
-			strlcpy(buf, "NONE", sizeof(buf));
+			strscpy(buf, "NONE", sizeof(buf));
 		else
-			strlcpy(buf, logger->name, sizeof(buf));
+			strscpy(buf, logger->name, sizeof(buf));
 		mutex_unlock(&nf_log_mutex);
 		r = proc_dostring(&tmp, write, buffer, lenp, ppos);
 	}
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 23abf1578594..4f74f3898e81 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -609,7 +609,7 @@ static int nft_request_module(struct net *net, const char *fmt, ...)
 		return -ENOMEM;
 
 	req->done = false;
-	strlcpy(req->module, module_name, MODULE_NAME_LEN);
+	strscpy(req->module, module_name, MODULE_NAME_LEN);
 	list_add_tail(&req->list, &net->nft.module_list);
 
 	return -EAGAIN;
diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index c261d57a666a..4ab1da935086 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -46,7 +46,7 @@ static void nft_osf_eval(const struct nft_expr *expr, struct nft_regs *regs,
 			snprintf(os_match, NFT_OSF_MAXGENRELEN, "%s:%s",
 				 data.genre, data.version);
 		else
-			strlcpy(os_match, data.genre, NFT_OSF_MAXGENRELEN);
+			strscpy(os_match, data.genre, NFT_OSF_MAXGENRELEN);
 
 		strncpy((char *)dest, os_match, NFT_OSF_MAXGENRELEN);
 	}
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index af22dbe85e2c..0cf89c598a63 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -747,7 +747,7 @@ void xt_compat_match_from_user(struct xt_entry_match *m, void **dstptr,
 
 	msize += off;
 	m->u.user.match_size = msize;
-	strlcpy(name, match->name, sizeof(name));
+	strscpy(name, match->name, sizeof(name));
 	module_put(match->me);
 	strncpy(m->u.user.name, name, sizeof(m->u.user.name));
 
@@ -1130,7 +1130,7 @@ void xt_compat_target_from_user(struct xt_entry_target *t, void **dstptr,
 
 	tsize += off;
 	t->u.user.target_size = tsize;
-	strlcpy(name, target->name, sizeof(name));
+	strscpy(name, target->name, sizeof(name));
 	module_put(target->me);
 	strncpy(t->u.user.name, name, sizeof(t->u.user.name));
 
@@ -1736,7 +1736,7 @@ int xt_proto_init(struct net *net, u_int8_t af)
 	root_uid = make_kuid(net->user_ns, 0);
 	root_gid = make_kgid(net->user_ns, 0);
 
-	strlcpy(buf, xt_prefix[af], sizeof(buf));
+	strscpy(buf, xt_prefix[af], sizeof(buf));
 	strlcat(buf, FORMAT_TABLES, sizeof(buf));
 	proc = proc_create_net_data(buf, 0440, net->proc_net, &xt_table_seq_ops,
 			sizeof(struct seq_net_private),
@@ -1746,7 +1746,7 @@ int xt_proto_init(struct net *net, u_int8_t af)
 	if (uid_valid(root_uid) && gid_valid(root_gid))
 		proc_set_user(proc, root_uid, root_gid);
 
-	strlcpy(buf, xt_prefix[af], sizeof(buf));
+	strscpy(buf, xt_prefix[af], sizeof(buf));
 	strlcat(buf, FORMAT_MATCHES, sizeof(buf));
 	proc = proc_create_seq_private(buf, 0440, net->proc_net,
 			&xt_match_seq_ops, sizeof(struct nf_mttg_trav),
@@ -1756,7 +1756,7 @@ int xt_proto_init(struct net *net, u_int8_t af)
 	if (uid_valid(root_uid) && gid_valid(root_gid))
 		proc_set_user(proc, root_uid, root_gid);
 
-	strlcpy(buf, xt_prefix[af], sizeof(buf));
+	strscpy(buf, xt_prefix[af], sizeof(buf));
 	strlcat(buf, FORMAT_TARGETS, sizeof(buf));
 	proc = proc_create_seq_private(buf, 0440, net->proc_net,
 			 &xt_target_seq_ops, sizeof(struct nf_mttg_trav),
@@ -1771,12 +1771,12 @@ int xt_proto_init(struct net *net, u_int8_t af)
 
 #ifdef CONFIG_PROC_FS
 out_remove_matches:
-	strlcpy(buf, xt_prefix[af], sizeof(buf));
+	strscpy(buf, xt_prefix[af], sizeof(buf));
 	strlcat(buf, FORMAT_MATCHES, sizeof(buf));
 	remove_proc_entry(buf, net->proc_net);
 
 out_remove_tables:
-	strlcpy(buf, xt_prefix[af], sizeof(buf));
+	strscpy(buf, xt_prefix[af], sizeof(buf));
 	strlcat(buf, FORMAT_TABLES, sizeof(buf));
 	remove_proc_entry(buf, net->proc_net);
 out:
@@ -1790,15 +1790,15 @@ void xt_proto_fini(struct net *net, u_int8_t af)
 #ifdef CONFIG_PROC_FS
 	char buf[XT_FUNCTION_MAXNAMELEN];
 
-	strlcpy(buf, xt_prefix[af], sizeof(buf));
+	strscpy(buf, xt_prefix[af], sizeof(buf));
 	strlcat(buf, FORMAT_TABLES, sizeof(buf));
 	remove_proc_entry(buf, net->proc_net);
 
-	strlcpy(buf, xt_prefix[af], sizeof(buf));
+	strscpy(buf, xt_prefix[af], sizeof(buf));
 	strlcat(buf, FORMAT_TARGETS, sizeof(buf));
 	remove_proc_entry(buf, net->proc_net);
 
-	strlcpy(buf, xt_prefix[af], sizeof(buf));
+	strscpy(buf, xt_prefix[af], sizeof(buf));
 	strlcat(buf, FORMAT_MATCHES, sizeof(buf));
 	remove_proc_entry(buf, net->proc_net);
 #endif /*CONFIG_PROC_FS*/
diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
index 37253d399c6b..b424e93a043f 100644
--- a/net/netfilter/xt_RATEEST.c
+++ b/net/netfilter/xt_RATEEST.c
@@ -140,7 +140,7 @@ static int xt_rateest_tg_checkentry(const struct xt_tgchk_param *par)
 	if (!est)
 		goto err1;
 
-	strlcpy(est->name, info->name, sizeof(est->name));
+	strscpy(est->name, info->name, sizeof(est->name));
 	spin_lock_init(&est->lock);
 	est->refcnt		= 1;
 	est->params.interval	= info->interval;
diff --git a/net/openvswitch/vport-internal_dev.c b/net/openvswitch/vport-internal_dev.c
index 1e30d8df3ba5..07f8c28a44a8 100644
--- a/net/openvswitch/vport-internal_dev.c
+++ b/net/openvswitch/vport-internal_dev.c
@@ -68,7 +68,7 @@ static int internal_dev_stop(struct net_device *netdev)
 static void internal_dev_getinfo(struct net_device *netdev,
 				 struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, "openvswitch", sizeof(info->driver));
+	strscpy(info->driver, "openvswitch", sizeof(info->driver));
 }
 
 static const struct ethtool_ops internal_dev_ethtool_ops = {
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 7a18ffff8551..7817e6c81fdf 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1845,7 +1845,7 @@ static int packet_rcv_spkt(struct sk_buff *skb, struct net_device *dev,
 	 */
 
 	spkt->spkt_family = dev->type;
-	strlcpy(spkt->spkt_device, dev->name, sizeof(spkt->spkt_device));
+	strscpy(spkt->spkt_device, dev->name, sizeof(spkt->spkt_device));
 	spkt->spkt_protocol = skb->protocol;
 
 	/*
@@ -3481,7 +3481,7 @@ static int packet_getname_spkt(struct socket *sock, struct sockaddr *uaddr,
 	rcu_read_lock();
 	dev = dev_get_by_index_rcu(sock_net(sk), pkt_sk(sk)->ifindex);
 	if (dev)
-		strlcpy(uaddr->sa_data, dev->name, sizeof(uaddr->sa_data));
+		strscpy(uaddr->sa_data, dev->name, sizeof(uaddr->sa_data));
 	rcu_read_unlock();
 
 	return sizeof(*uaddr);
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index f66417d5d2c3..b4267008e1c1 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -951,7 +951,7 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 		if (tb[TCA_ACT_FLAGS])
 			flags = nla_get_bitfield32(tb[TCA_ACT_FLAGS]);
 	} else {
-		if (strlcpy(act_name, name, IFNAMSIZ) >= IFNAMSIZ) {
+		if (strscpy(act_name, name, IFNAMSIZ) >= IFNAMSIZ) {
 			NL_SET_ERR_MSG(extack, "TC action name too long");
 			err = -EINVAL;
 			goto err_out;
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 2a76a2f5ed88..be33e07358a5 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -194,7 +194,7 @@ EXPORT_SYMBOL(unregister_qdisc);
 void qdisc_get_default(char *name, size_t len)
 {
 	read_lock(&qdisc_mod_lock);
-	strlcpy(name, default_qdisc_ops->id, len);
+	strscpy(name, default_qdisc_ops->id, len);
 	read_unlock(&qdisc_mod_lock);
 }
 
diff --git a/net/sched/sch_teql.c b/net/sched/sch_teql.c
index 2f1f0a378408..b3a7cdea621d 100644
--- a/net/sched/sch_teql.c
+++ b/net/sched/sch_teql.c
@@ -489,7 +489,7 @@ static int __init teql_init(void)
 
 		master = netdev_priv(dev);
 
-		strlcpy(master->qops.id, dev->name, IFNAMSIZ);
+		strscpy(master->qops.id, dev->name, IFNAMSIZ);
 		err = register_qdisc(&master->qops);
 
 		if (err) {
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index c211b607239e..79eae30ae208 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -88,13 +88,13 @@ param_get_pool_mode(char *buf, const struct kernel_param *kp)
 	switch (*ip)
 	{
 	case SVC_POOL_AUTO:
-		return strlcpy(buf, "auto\n", 20);
+		return strscpy(buf, "auto\n", 20);
 	case SVC_POOL_GLOBAL:
-		return strlcpy(buf, "global\n", 20);
+		return strscpy(buf, "global\n", 20);
 	case SVC_POOL_PERCPU:
-		return strlcpy(buf, "percpu\n", 20);
+		return strscpy(buf, "percpu\n", 20);
 	case SVC_POOL_PERNODE:
-		return strlcpy(buf, "pernode\n", 20);
+		return strscpy(buf, "pernode\n", 20);
 	default:
 		return sprintf(buf, "%d\n", *ip);
 	}
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 7090bbee0ec5..839eef8b7b48 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -255,7 +255,7 @@ static void xs_format_common_peer_addresses(struct rpc_xprt *xprt)
 	switch (sap->sa_family) {
 	case AF_LOCAL:
 		sun = xs_addr_un(xprt);
-		strlcpy(buf, sun->sun_path, sizeof(buf));
+		strscpy(buf, sun->sun_path, sizeof(buf));
 		xprt->address_strings[RPC_DISPLAY_ADDR] =
 						kstrdup(buf, GFP_KERNEL);
 		break;
diff --git a/net/wireless/ethtool.c b/net/wireless/ethtool.c
index 24e18405cdb4..2613d6ac0fda 100644
--- a/net/wireless/ethtool.c
+++ b/net/wireless/ethtool.c
@@ -10,20 +10,20 @@ void cfg80211_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 	struct device *pdev = wiphy_dev(wdev->wiphy);
 
 	if (pdev->driver)
-		strlcpy(info->driver, pdev->driver->name,
+		strscpy(info->driver, pdev->driver->name,
 			sizeof(info->driver));
 	else
-		strlcpy(info->driver, "N/A", sizeof(info->driver));
+		strscpy(info->driver, "N/A", sizeof(info->driver));
 
-	strlcpy(info->version, init_utsname()->release, sizeof(info->version));
+	strscpy(info->version, init_utsname()->release, sizeof(info->version));
 
 	if (wdev->wiphy->fw_version[0])
-		strlcpy(info->fw_version, wdev->wiphy->fw_version,
+		strscpy(info->fw_version, wdev->wiphy->fw_version,
 			sizeof(info->fw_version));
 	else
-		strlcpy(info->fw_version, "N/A", sizeof(info->fw_version));
+		strscpy(info->fw_version, "N/A", sizeof(info->fw_version));
 
-	strlcpy(info->bus_info, dev_name(wiphy_dev(wdev->wiphy)),
+	strscpy(info->bus_info, dev_name(wiphy_dev(wdev->wiphy)),
 		sizeof(info->bus_info));
 }
 EXPORT_SYMBOL(cfg80211_get_drvinfo);
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 6e218a0acd4e..9a4225c15586 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -24,7 +24,7 @@
 
 #define MAXNAME		32
 #define WIPHY_ENTRY	__array(char, wiphy_name, 32)
-#define WIPHY_ASSIGN	strlcpy(__entry->wiphy_name, wiphy_name(wiphy), MAXNAME)
+#define WIPHY_ASSIGN	strscpy(__entry->wiphy_name, wiphy_name(wiphy), MAXNAME)
 #define WIPHY_PR_FMT	"%s"
 #define WIPHY_PR_ARG	__entry->wiphy_name
 
diff --git a/samples/trace_events/trace-events-sample.h b/samples/trace_events/trace-events-sample.h
index 13a35f7cbe66..9cb111dbd54e 100644
--- a/samples/trace_events/trace-events-sample.h
+++ b/samples/trace_events/trace-events-sample.h
@@ -242,7 +242,7 @@ TRACE_EVENT(foo_bar,
 	),
 
 	TP_fast_assign(
-		strlcpy(__entry->foo, foo, 10);
+		strscpy(__entry->foo, foo, 10);
 		__entry->bar	= bar;
 		memcpy(__get_dynamic_array(list), lst,
 		       __length_of(lst) * sizeof(int));
diff --git a/samples/v4l/v4l2-pci-skeleton.c b/samples/v4l/v4l2-pci-skeleton.c
index 3fa6582b4a68..d2dc1e7ed278 100644
--- a/samples/v4l/v4l2-pci-skeleton.c
+++ b/samples/v4l/v4l2-pci-skeleton.c
@@ -303,8 +303,8 @@ static int skeleton_querycap(struct file *file, void *priv,
 {
 	struct skeleton *skel = video_drvdata(file);
 
-	strlcpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
-	strlcpy(cap->card, "V4L2 PCI Skeleton", sizeof(cap->card));
+	strscpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
+	strscpy(cap->card, "V4L2 PCI Skeleton", sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "PCI:%s",
 		 pci_name(skel->pdev));
 	return 0;
@@ -609,11 +609,11 @@ static int skeleton_enum_input(struct file *file, void *priv,
 	i->type = V4L2_INPUT_TYPE_CAMERA;
 	if (i->index == 0) {
 		i->std = SKEL_TVNORMS;
-		strlcpy(i->name, "S-Video", sizeof(i->name));
+		strscpy(i->name, "S-Video", sizeof(i->name));
 		i->capabilities = V4L2_IN_CAP_STD;
 	} else {
 		i->std = 0;
-		strlcpy(i->name, "HDMI", sizeof(i->name));
+		strscpy(i->name, "HDMI", sizeof(i->name));
 		i->capabilities = V4L2_IN_CAP_DV_TIMINGS;
 	}
 	return 0;
@@ -857,7 +857,7 @@ static int skeleton_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* Initialize the video_device structure */
 	vdev = &skel->vdev;
-	strlcpy(vdev->name, KBUILD_MODNAME, sizeof(vdev->name));
+	strscpy(vdev->name, KBUILD_MODNAME, sizeof(vdev->name));
 	/*
 	 * There is nothing to clean up, so release is set to an empty release
 	 * function. The release callback must be non-NULL.
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 4f39fb93f278..854949111283 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -399,7 +399,7 @@ const char *ima_d_path(const struct path *path, char **pathbuf, char *namebuf)
 	}
 
 	if (!pathname) {
-		strlcpy(namebuf, path->dentry->d_name.name, NAME_MAX);
+		strscpy(namebuf, path->dentry->d_name.name, NAME_MAX);
 		pathname = namebuf;
 	}
 
diff --git a/security/keys/request_key_auth.c b/security/keys/request_key_auth.c
index 41e9735006d0..8f33cd170e42 100644
--- a/security/keys/request_key_auth.c
+++ b/security/keys/request_key_auth.c
@@ -178,7 +178,7 @@ struct key *request_key_auth_new(struct key *target, const char *op,
 	if (!rka->callout_info)
 		goto error_free_rka;
 	rka->callout_len = callout_len;
-	strlcpy(rka->op, op, sizeof(rka->op));
+	strscpy(rka->op, op, sizeof(rka->op));
 
 	/* see if the calling process is already servicing the key request of
 	 * another process */
diff --git a/sound/aoa/codecs/onyx.c b/sound/aoa/codecs/onyx.c
index 12028b3e2eee..1abee841cc45 100644
--- a/sound/aoa/codecs/onyx.c
+++ b/sound/aoa/codecs/onyx.c
@@ -1013,7 +1013,7 @@ static int onyx_i2c_probe(struct i2c_client *client,
 		goto fail;
 	}
 
-	strlcpy(onyx->codec.name, "onyx", MAX_CODEC_NAME_LEN);
+	strscpy(onyx->codec.name, "onyx", MAX_CODEC_NAME_LEN);
 	onyx->codec.owner = THIS_MODULE;
 	onyx->codec.init = onyx_init_codec;
 	onyx->codec.exit = onyx_exit_codec;
diff --git a/sound/aoa/codecs/tas.c b/sound/aoa/codecs/tas.c
index d3e37577b529..ac246dd3ab49 100644
--- a/sound/aoa/codecs/tas.c
+++ b/sound/aoa/codecs/tas.c
@@ -894,7 +894,7 @@ static int tas_i2c_probe(struct i2c_client *client,
 	/* seems that half is a saner default */
 	tas->drc_range = TAS3004_DRC_MAX / 2;
 
-	strlcpy(tas->codec.name, "tas", MAX_CODEC_NAME_LEN);
+	strscpy(tas->codec.name, "tas", MAX_CODEC_NAME_LEN);
 	tas->codec.owner = THIS_MODULE;
 	tas->codec.init = tas_init_codec;
 	tas->codec.exit = tas_exit_codec;
diff --git a/sound/aoa/codecs/toonie.c b/sound/aoa/codecs/toonie.c
index c2d014486c33..0da5af129492 100644
--- a/sound/aoa/codecs/toonie.c
+++ b/sound/aoa/codecs/toonie.c
@@ -126,7 +126,7 @@ static int __init toonie_init(void)
 	if (!toonie)
 		return -ENOMEM;
 
-	strlcpy(toonie->codec.name, "toonie", sizeof(toonie->codec.name));
+	strscpy(toonie->codec.name, "toonie", sizeof(toonie->codec.name));
 	toonie->codec.owner = THIS_MODULE;
 	toonie->codec.init = toonie_init_codec;
 	toonie->codec.exit = toonie_exit_codec;
diff --git a/sound/aoa/core/alsa.c b/sound/aoa/core/alsa.c
index b61081342266..be867f390700 100644
--- a/sound/aoa/core/alsa.c
+++ b/sound/aoa/core/alsa.c
@@ -28,10 +28,11 @@ int aoa_alsa_init(char *name, struct module *mod, struct device *dev)
 		return err;
 	aoa_card = alsa_card->private_data;
 	aoa_card->alsa_card = alsa_card;
-	strlcpy(alsa_card->driver, "AppleOnbdAudio", sizeof(alsa_card->driver));
-	strlcpy(alsa_card->shortname, name, sizeof(alsa_card->shortname));
-	strlcpy(alsa_card->longname, name, sizeof(alsa_card->longname));
-	strlcpy(alsa_card->mixername, name, sizeof(alsa_card->mixername));
+	strscpy(alsa_card->driver, "AppleOnbdAudio",
+		sizeof(alsa_card->driver));
+	strscpy(alsa_card->shortname, name, sizeof(alsa_card->shortname));
+	strscpy(alsa_card->longname, name, sizeof(alsa_card->longname));
+	strscpy(alsa_card->mixername, name, sizeof(alsa_card->mixername));
 	err = snd_card_register(aoa_card->alsa_card);
 	if (err < 0) {
 		printk(KERN_ERR "snd-aoa: couldn't register alsa card\n");
diff --git a/sound/aoa/fabrics/layout.c b/sound/aoa/fabrics/layout.c
index d2e85b83f7ed..a199be005754 100644
--- a/sound/aoa/fabrics/layout.c
+++ b/sound/aoa/fabrics/layout.c
@@ -948,8 +948,8 @@ static void layout_attached_codec(struct aoa_codec *codec)
 				ldev->gpio.methods->set_lineout(codec->gpio, 1);
 			ctl = snd_ctl_new1(&lineout_ctl, codec->gpio);
 			if (cc->connected & CC_LINEOUT_LABELLED_HEADPHONE)
-				strlcpy(ctl->id.name,
-					"Headphone Switch", sizeof(ctl->id.name));
+				strscpy(ctl->id.name, "Headphone Switch",
+				        sizeof(ctl->id.name));
 			ldev->lineout_ctrl = ctl;
 			aoa_snd_ctl_add(ctl);
 			ldev->have_lineout_detect =
@@ -962,14 +962,14 @@ static void layout_attached_codec(struct aoa_codec *codec)
 				ctl = snd_ctl_new1(&lineout_detect_choice,
 						   ldev);
 				if (cc->connected & CC_LINEOUT_LABELLED_HEADPHONE)
-					strlcpy(ctl->id.name,
+					strscpy(ctl->id.name,
 						"Headphone Detect Autoswitch",
 						sizeof(ctl->id.name));
 				aoa_snd_ctl_add(ctl);
 				ctl = snd_ctl_new1(&lineout_detected,
 						   ldev);
 				if (cc->connected & CC_LINEOUT_LABELLED_HEADPHONE)
-					strlcpy(ctl->id.name,
+					strscpy(ctl->id.name,
 						"Headphone Detected",
 						sizeof(ctl->id.name));
 				ldev->lineout_detected_ctrl = ctl;
diff --git a/sound/aoa/soundbus/sysfs.c b/sound/aoa/soundbus/sysfs.c
index a2d55e15afbb..dead3105689b 100644
--- a/sound/aoa/soundbus/sysfs.c
+++ b/sound/aoa/soundbus/sysfs.c
@@ -13,7 +13,7 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
 	int length;
 
 	if (*sdev->modalias) {
-		strlcpy(buf, sdev->modalias, sizeof(sdev->modalias) + 1);
+		strscpy(buf, sdev->modalias, sizeof(sdev->modalias) + 1);
 		strcat(buf, "\n");
 		length = strlen(buf);
 	} else {
diff --git a/sound/arm/aaci.c b/sound/arm/aaci.c
index a0996c47e58f..be1cf34a76ca 100644
--- a/sound/arm/aaci.c
+++ b/sound/arm/aaci.c
@@ -890,8 +890,9 @@ static struct aaci *aaci_init_card(struct amba_device *dev)
 
 	card->private_free = aaci_free_card;
 
-	strlcpy(card->driver, DRIVER_NAME, sizeof(card->driver));
-	strlcpy(card->shortname, "ARM AC'97 Interface", sizeof(card->shortname));
+	strscpy(card->driver, DRIVER_NAME, sizeof(card->driver));
+	strscpy(card->shortname, "ARM AC'97 Interface",
+		sizeof(card->shortname));
 	snprintf(card->longname, sizeof(card->longname),
 		 "%s PL%03x rev%u at 0x%08llx, irq %d",
 		 card->shortname, amba_part(dev), amba_rev(dev),
@@ -921,7 +922,7 @@ static int aaci_init_pcm(struct aaci *aaci)
 		pcm->private_data = aaci;
 		pcm->info_flags = 0;
 
-		strlcpy(pcm->name, DRIVER_NAME, sizeof(pcm->name));
+		strscpy(pcm->name, DRIVER_NAME, sizeof(pcm->name));
 
 		snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_PLAYBACK, &aaci_playback_ops);
 		snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &aaci_capture_ops);
diff --git a/sound/arm/pxa2xx-ac97.c b/sound/arm/pxa2xx-ac97.c
index ea8e233150c8..6322e6392594 100644
--- a/sound/arm/pxa2xx-ac97.c
+++ b/sound/arm/pxa2xx-ac97.c
@@ -235,7 +235,7 @@ static int pxa2xx_ac97_probe(struct platform_device *dev)
 	if (ret < 0)
 		goto err;
 
-	strlcpy(card->driver, dev->dev.driver->name, sizeof(card->driver));
+	strscpy(card->driver, dev->dev.driver->name, sizeof(card->driver));
 
 	ret = pxa2xx_ac97_pcm_new(card);
 	if (ret)
diff --git a/sound/core/compress_offload.c b/sound/core/compress_offload.c
index c1fec932c49d..e6f47d1fc308 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -1109,7 +1109,7 @@ static void snd_compress_proc_done(struct snd_compr *compr)
 
 static inline void snd_compress_set_id(struct snd_compr *compr, const char *id)
 {
-	strlcpy(compr->id, id, sizeof(compr->id));
+	strscpy(compr->id, id, sizeof(compr->id));
 }
 #else
 static inline int snd_compress_proc_init(struct snd_compr *compr)
diff --git a/sound/core/control.c b/sound/core/control.c
index 3b44378b9dec..8f41aba6acac 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -261,7 +261,7 @@ struct snd_kcontrol *snd_ctl_new1(const struct snd_kcontrol_new *ncontrol,
 	kctl->id.device = ncontrol->device;
 	kctl->id.subdevice = ncontrol->subdevice;
 	if (ncontrol->name) {
-		strlcpy(kctl->id.name, ncontrol->name, sizeof(kctl->id.name));
+		strscpy(kctl->id.name, ncontrol->name, sizeof(kctl->id.name));
 		if (strcmp(ncontrol->name, kctl->id.name) != 0)
 			pr_warn("ALSA: Control name '%s' truncated to '%s'\n",
 				ncontrol->name, kctl->id.name);
@@ -701,12 +701,12 @@ static int snd_ctl_card_info(struct snd_card *card, struct snd_ctl_file * ctl,
 		return -ENOMEM;
 	down_read(&snd_ioctl_rwsem);
 	info->card = card->number;
-	strlcpy(info->id, card->id, sizeof(info->id));
-	strlcpy(info->driver, card->driver, sizeof(info->driver));
-	strlcpy(info->name, card->shortname, sizeof(info->name));
-	strlcpy(info->longname, card->longname, sizeof(info->longname));
-	strlcpy(info->mixername, card->mixername, sizeof(info->mixername));
-	strlcpy(info->components, card->components, sizeof(info->components));
+	strscpy(info->id, card->id, sizeof(info->id));
+	strscpy(info->driver, card->driver, sizeof(info->driver));
+	strscpy(info->name, card->shortname, sizeof(info->name));
+	strscpy(info->longname, card->longname, sizeof(info->longname));
+	strscpy(info->mixername, card->mixername, sizeof(info->mixername));
+	strscpy(info->components, card->components, sizeof(info->components));
 	up_read(&snd_ioctl_rwsem);
 	if (copy_to_user(arg, info, sizeof(struct snd_ctl_card_info))) {
 		kfree(info);
@@ -2137,7 +2137,7 @@ int snd_ctl_enum_info(struct snd_ctl_elem_info *info, unsigned int channels,
 	WARN(strlen(names[info->value.enumerated.item]) >= sizeof(info->value.enumerated.name),
 	     "ALSA: too long item name '%s'\n",
 	     names[info->value.enumerated.item]);
-	strlcpy(info->value.enumerated.name,
+	strscpy(info->value.enumerated.name,
 		names[info->value.enumerated.item],
 		sizeof(info->value.enumerated.name));
 	return 0;
diff --git a/sound/core/ctljack.c b/sound/core/ctljack.c
index 9be4e282f2e0..709b1a9c2caa 100644
--- a/sound/core/ctljack.c
+++ b/sound/core/ctljack.c
@@ -35,7 +35,7 @@ static int get_available_index(struct snd_card *card, const char *name)
 
 	sid.index = 0;
 	sid.iface = SNDRV_CTL_ELEM_IFACE_CARD;
-	strlcpy(sid.name, name, sizeof(sid.name));
+	strscpy(sid.name, name, sizeof(sid.name));
 
 	while (snd_ctl_find_id(card, &sid)) {
 		sid.index++;
diff --git a/sound/core/hwdep.c b/sound/core/hwdep.c
index 0c029892880a..e01602bcd674 100644
--- a/sound/core/hwdep.c
+++ b/sound/core/hwdep.c
@@ -177,8 +177,8 @@ static int snd_hwdep_info(struct snd_hwdep *hw,
 	
 	memset(&info, 0, sizeof(info));
 	info.card = hw->card->number;
-	strlcpy(info.id, hw->id, sizeof(info.id));	
-	strlcpy(info.name, hw->name, sizeof(info.name));
+	strscpy(info.id, hw->id, sizeof(info.id));	
+	strscpy(info.name, hw->name, sizeof(info.name));
 	info.iface = hw->iface;
 	if (copy_to_user(_info, &info, sizeof(info)))
 		return -EFAULT;
@@ -379,7 +379,7 @@ int snd_hwdep_new(struct snd_card *card, char *id, int device,
 	hwdep->card = card;
 	hwdep->device = device;
 	if (id)
-		strlcpy(hwdep->id, id, sizeof(hwdep->id));
+		strscpy(hwdep->id, id, sizeof(hwdep->id));
 
 	snd_device_initialize(&hwdep->dev, card);
 	hwdep->dev.release = release_hwdep_device;
diff --git a/sound/core/init.c b/sound/core/init.c
index 764dbe673d48..7271a4cd8ce6 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -176,7 +176,7 @@ int snd_card_new(struct device *parent, int idx, const char *xid,
 	if (extra_size > 0)
 		card->private_data = (char *)card + sizeof(struct snd_card);
 	if (xid)
-		strlcpy(card->id, xid, sizeof(card->id));
+		strscpy(card->id, xid, sizeof(card->id));
 	err = 0;
 	mutex_lock(&snd_card_mutex);
 	if (idx < 0) /* first check the matching module-name slot */
@@ -625,7 +625,7 @@ static void snd_card_set_id_no_lock(struct snd_card *card, const char *src,
 	/* last resort... */
 	dev_err(card->dev, "unable to set card id (%s)\n", id);
 	if (card->proc_root->name)
-		strlcpy(card->id, card->proc_root->name, sizeof(card->id));
+		strscpy(card->id, card->proc_root->name, sizeof(card->id));
 }
 
 /**
diff --git a/sound/core/oss/mixer_oss.c b/sound/core/oss/mixer_oss.c
index f702c96a7478..49861951dfc2 100644
--- a/sound/core/oss/mixer_oss.c
+++ b/sound/core/oss/mixer_oss.c
@@ -87,8 +87,11 @@ static int snd_mixer_oss_info(struct snd_mixer_oss_file *fmixer,
 	struct mixer_info info;
 	
 	memset(&info, 0, sizeof(info));
-	strlcpy(info.id, mixer && mixer->id[0] ? mixer->id : card->driver, sizeof(info.id));
-	strlcpy(info.name, mixer && mixer->name[0] ? mixer->name : card->mixername, sizeof(info.name));
+	strscpy(info.id, mixer && mixer->id[0] ? mixer->id : card->driver,
+		sizeof(info.id));
+	strscpy(info.name,
+		mixer && mixer->name[0] ? mixer->name : card->mixername,
+		sizeof(info.name));
 	info.modify_counter = card->mixer_oss_change_count;
 	if (copy_to_user(_info, &info, sizeof(info)))
 		return -EFAULT;
@@ -103,8 +106,11 @@ static int snd_mixer_oss_info_obsolete(struct snd_mixer_oss_file *fmixer,
 	_old_mixer_info info;
 	
 	memset(&info, 0, sizeof(info));
-	strlcpy(info.id, mixer && mixer->id[0] ? mixer->id : card->driver, sizeof(info.id));
-	strlcpy(info.name, mixer && mixer->name[0] ? mixer->name : card->mixername, sizeof(info.name));
+	strscpy(info.id, mixer && mixer->id[0] ? mixer->id : card->driver,
+		sizeof(info.id));
+	strscpy(info.name,
+		mixer && mixer->name[0] ? mixer->name : card->mixername,
+		sizeof(info.name));
 	if (copy_to_user(_info, &info, sizeof(info)))
 		return -EFAULT;
 	return 0;
@@ -499,7 +505,7 @@ static struct snd_kcontrol *snd_mixer_oss_test_id(struct snd_mixer_oss *mixer, c
 	
 	memset(&id, 0, sizeof(id));
 	id.iface = SNDRV_CTL_ELEM_IFACE_MIXER;
-	strlcpy(id.name, name, sizeof(id.name));
+	strscpy(id.name, name, sizeof(id.name));
 	id.index = index;
 	return snd_ctl_find_id(card, &id);
 }
@@ -1355,7 +1361,8 @@ static int snd_mixer_oss_notify_handler(struct snd_card *card, int cmd)
 		mixer->oss_dev_alloc = 1;
 		mixer->card = card;
 		if (*card->mixername)
-			strlcpy(mixer->name, card->mixername, sizeof(mixer->name));
+			strscpy(mixer->name, card->mixername,
+				sizeof(mixer->name));
 		else
 			snprintf(mixer->name, sizeof(mixer->name),
 				 "mixer%i", card->number);
diff --git a/sound/core/pcm.c b/sound/core/pcm.c
index be5714f1bb58..e5947281e5fc 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -729,7 +729,7 @@ static int _snd_pcm_new(struct snd_card *card, const char *id, int device,
 	init_waitqueue_head(&pcm->open_wait);
 	INIT_LIST_HEAD(&pcm->list);
 	if (id)
-		strlcpy(pcm->id, id, sizeof(pcm->id));
+		strscpy(pcm->id, id, sizeof(pcm->id));
 
 	err = snd_pcm_new_stream(pcm, SNDRV_PCM_STREAM_PLAYBACK,
 				 playback_count);
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 47b155a49226..27fac9d1b74f 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -209,13 +209,13 @@ int snd_pcm_info(struct snd_pcm_substream *substream, struct snd_pcm_info *info)
 	info->device = pcm->device;
 	info->stream = substream->stream;
 	info->subdevice = substream->number;
-	strlcpy(info->id, pcm->id, sizeof(info->id));
-	strlcpy(info->name, pcm->name, sizeof(info->name));
+	strscpy(info->id, pcm->id, sizeof(info->id));
+	strscpy(info->name, pcm->name, sizeof(info->name));
 	info->dev_class = pcm->dev_class;
 	info->dev_subclass = pcm->dev_subclass;
 	info->subdevices_count = pstr->substream_count;
 	info->subdevices_avail = pstr->substream_count - pstr->substream_opened;
-	strlcpy(info->subname, substream->name, sizeof(info->subname));
+	strscpy(info->subname, substream->name, sizeof(info->subname));
 
 	return 0;
 }
diff --git a/sound/core/rawmidi.c b/sound/core/rawmidi.c
index c78720a3299c..9692fccc6377 100644
--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -1665,7 +1665,7 @@ int snd_rawmidi_new(struct snd_card *card, char *id, int device,
 	INIT_LIST_HEAD(&rmidi->streams[SNDRV_RAWMIDI_STREAM_OUTPUT].substreams);
 
 	if (id != NULL)
-		strlcpy(rmidi->id, id, sizeof(rmidi->id));
+		strscpy(rmidi->id, id, sizeof(rmidi->id));
 
 	snd_device_initialize(&rmidi->dev, card);
 	rmidi->dev.release = release_rawmidi_device;
diff --git a/sound/core/seq/oss/seq_oss_midi.c b/sound/core/seq/oss/seq_oss_midi.c
index 2ddfe2226651..3f82c196de46 100644
--- a/sound/core/seq/oss/seq_oss_midi.c
+++ b/sound/core/seq/oss/seq_oss_midi.c
@@ -173,7 +173,7 @@ snd_seq_oss_midi_check_new_port(struct snd_seq_port_info *pinfo)
 	snd_use_lock_init(&mdev->use_lock);
 
 	/* copy and truncate the name of synth device */
-	strlcpy(mdev->name, pinfo->name, sizeof(mdev->name));
+	strscpy(mdev->name, pinfo->name, sizeof(mdev->name));
 
 	/* create MIDI coder */
 	if (snd_midi_event_new(MAX_MIDI_EVENT_BUF, &mdev->coder) < 0) {
@@ -647,7 +647,7 @@ snd_seq_oss_midi_make_info(struct seq_oss_devinfo *dp, int dev, struct midi_info
 	inf->device = dev;
 	inf->dev_type = 0; /* FIXME: ?? */
 	inf->capabilities = 0; /* FIXME: ?? */
-	strlcpy(inf->name, mdev->name, sizeof(inf->name));
+	strscpy(inf->name, mdev->name, sizeof(inf->name));
 	snd_use_lock_free(&mdev->use_lock);
 	return 0;
 }
diff --git a/sound/core/seq/oss/seq_oss_synth.c b/sound/core/seq/oss/seq_oss_synth.c
index 11554d0412f0..136dc663887a 100644
--- a/sound/core/seq/oss/seq_oss_synth.c
+++ b/sound/core/seq/oss/seq_oss_synth.c
@@ -107,7 +107,7 @@ snd_seq_oss_synth_probe(struct device *_dev)
 	snd_use_lock_init(&rec->use_lock);
 
 	/* copy and truncate the name of synth device */
-	strlcpy(rec->name, dev->name, sizeof(rec->name));
+	strscpy(rec->name, dev->name, sizeof(rec->name));
 
 	/* registration */
 	spin_lock_irqsave(&register_lock, flags);
@@ -616,7 +616,7 @@ snd_seq_oss_synth_make_info(struct seq_oss_devinfo *dp, int dev, struct synth_in
 		inf->synth_subtype = 0;
 		inf->nr_voices = 16;
 		inf->device = dev;
-		strlcpy(inf->name, minf.name, sizeof(inf->name));
+		strscpy(inf->name, minf.name, sizeof(inf->name));
 	} else {
 		if ((rec = get_synthdev(dp, dev)) == NULL)
 			return -ENXIO;
@@ -624,7 +624,7 @@ snd_seq_oss_synth_make_info(struct seq_oss_devinfo *dp, int dev, struct synth_in
 		inf->synth_subtype = rec->synth_subtype;
 		inf->nr_voices = rec->nr_voices;
 		inf->device = dev;
-		strlcpy(inf->name, rec->name, sizeof(inf->name));
+		strscpy(inf->name, rec->name, sizeof(inf->name));
 		snd_use_lock_free(&rec->use_lock);
 	}
 	return 0;
diff --git a/sound/core/seq/seq_clientmgr.c b/sound/core/seq/seq_clientmgr.c
index cc93157fa950..59764401df97 100644
--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -1585,7 +1585,7 @@ static int snd_seq_ioctl_get_queue_info(struct snd_seq_client *client,
 	info->queue = q->queue;
 	info->owner = q->owner;
 	info->locked = q->locked;
-	strlcpy(info->name, q->name, sizeof(info->name));
+	strscpy(info->name, q->name, sizeof(info->name));
 	queuefree(q);
 
 	return 0;
diff --git a/sound/core/seq/seq_ports.c b/sound/core/seq/seq_ports.c
index 83be6b982a87..b9c2ce2b8d5a 100644
--- a/sound/core/seq/seq_ports.c
+++ b/sound/core/seq/seq_ports.c
@@ -327,7 +327,7 @@ int snd_seq_set_port_info(struct snd_seq_client_port * port,
 
 	/* set port name */
 	if (info->name[0])
-		strlcpy(port->name, info->name, sizeof(port->name));
+		strscpy(port->name, info->name, sizeof(port->name));
 	
 	/* set capabilities */
 	port->capability = info->capability;
@@ -356,7 +356,7 @@ int snd_seq_get_port_info(struct snd_seq_client_port * port,
 		return -EINVAL;
 
 	/* get port name */
-	strlcpy(info->name, port->name, sizeof(info->name));
+	strscpy(info->name, port->name, sizeof(info->name));
 	
 	/* get capabilities */
 	info->capability = port->capability;
@@ -654,7 +654,7 @@ int snd_seq_event_port_attach(int client,
 	/* Set up the port */
 	memset(&portinfo, 0, sizeof(portinfo));
 	portinfo.addr.client = client;
-	strlcpy(portinfo.name, portname ? portname : "Unnamed port",
+	strscpy(portinfo.name, portname ? portname : "Unnamed port",
 		sizeof(portinfo.name));
 
 	portinfo.capability = cap;
diff --git a/sound/core/timer.c b/sound/core/timer.c
index 765ea66665a8..6898b1ac0d7f 100644
--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -959,7 +959,7 @@ int snd_timer_new(struct snd_card *card, char *id, struct snd_timer_id *tid,
 	timer->tmr_device = tid->device;
 	timer->tmr_subdevice = tid->subdevice;
 	if (id)
-		strlcpy(timer->id, id, sizeof(timer->id));
+		strscpy(timer->id, id, sizeof(timer->id));
 	timer->sticks = 1;
 	INIT_LIST_HEAD(&timer->device_list);
 	INIT_LIST_HEAD(&timer->open_list_head);
@@ -1659,8 +1659,8 @@ static int snd_timer_user_ginfo(struct file *file,
 		ginfo->card = t->card ? t->card->number : -1;
 		if (t->hw.flags & SNDRV_TIMER_HW_SLAVE)
 			ginfo->flags |= SNDRV_TIMER_FLG_SLAVE;
-		strlcpy(ginfo->id, t->id, sizeof(ginfo->id));
-		strlcpy(ginfo->name, t->name, sizeof(ginfo->name));
+		strscpy(ginfo->id, t->id, sizeof(ginfo->id));
+		strscpy(ginfo->name, t->name, sizeof(ginfo->name));
 		ginfo->resolution = t->hw.resolution;
 		if (t->hw.resolution_min > 0) {
 			ginfo->resolution_min = t->hw.resolution_min;
@@ -1814,8 +1814,8 @@ static int snd_timer_user_info(struct file *file,
 	info->card = t->card ? t->card->number : -1;
 	if (t->hw.flags & SNDRV_TIMER_HW_SLAVE)
 		info->flags |= SNDRV_TIMER_FLG_SLAVE;
-	strlcpy(info->id, t->id, sizeof(info->id));
-	strlcpy(info->name, t->name, sizeof(info->name));
+	strscpy(info->id, t->id, sizeof(info->id));
+	strscpy(info->name, t->name, sizeof(info->name));
 	info->resolution = t->hw.resolution;
 	if (copy_to_user(_info, info, sizeof(*_info)))
 		err = -EFAULT;
diff --git a/sound/core/timer_compat.c b/sound/core/timer_compat.c
index 0103d16f6f9f..ee973b7b8044 100644
--- a/sound/core/timer_compat.c
+++ b/sound/core/timer_compat.c
@@ -61,8 +61,8 @@ static int snd_timer_user_info_compat(struct file *file,
 	info.card = t->card ? t->card->number : -1;
 	if (t->hw.flags & SNDRV_TIMER_HW_SLAVE)
 		info.flags |= SNDRV_TIMER_FLG_SLAVE;
-	strlcpy(info.id, t->id, sizeof(info.id));
-	strlcpy(info.name, t->name, sizeof(info.name));
+	strscpy(info.id, t->id, sizeof(info.id));
+	strscpy(info.name, t->name, sizeof(info.name));
 	info.resolution = t->hw.resolution;
 	if (copy_to_user(_info, &info, sizeof(*_info)))
 		return -EFAULT;
diff --git a/sound/drivers/opl3/opl3_oss.c b/sound/drivers/opl3/opl3_oss.c
index 7bf0d5f3fedd..c82c7c1c0714 100644
--- a/sound/drivers/opl3/opl3_oss.c
+++ b/sound/drivers/opl3/opl3_oss.c
@@ -97,7 +97,7 @@ void snd_opl3_init_seq_oss(struct snd_opl3 *opl3, char *name)
 		return;
 
 	opl3->oss_seq_dev = dev;
-	strlcpy(dev->name, name, sizeof(dev->name));
+	strscpy(dev->name, name, sizeof(dev->name));
 	arg = SNDRV_SEQ_DEVICE_ARGPTR(dev);
 	arg->type = SYNTH_TYPE_FM;
 	if (opl3->hardware < OPL3_HW_OPL3) {
diff --git a/sound/drivers/opl3/opl3_synth.c b/sound/drivers/opl3/opl3_synth.c
index 08c10ac9d6c8..97d30a833ac8 100644
--- a/sound/drivers/opl3/opl3_synth.c
+++ b/sound/drivers/opl3/opl3_synth.c
@@ -290,7 +290,7 @@ int snd_opl3_load_patch(struct snd_opl3 *opl3,
 	}
 
 	if (name)
-		strlcpy(patch->name, name, sizeof(patch->name));
+		strscpy(patch->name, name, sizeof(patch->name));
 
 	return 0;
 }
diff --git a/sound/firewire/bebob/bebob_hwdep.c b/sound/firewire/bebob/bebob_hwdep.c
index c362eb38ab90..8677e3ec8d14 100644
--- a/sound/firewire/bebob/bebob_hwdep.c
+++ b/sound/firewire/bebob/bebob_hwdep.c
@@ -80,7 +80,7 @@ hwdep_get_info(struct snd_bebob *bebob, void __user *arg)
 	info.card = dev->card->index;
 	*(__be32 *)&info.guid[0] = cpu_to_be32(dev->config_rom[3]);
 	*(__be32 *)&info.guid[4] = cpu_to_be32(dev->config_rom[4]);
-	strlcpy(info.device_name, dev_name(&dev->device),
+	strscpy(info.device_name, dev_name(&dev->device),
 		sizeof(info.device_name));
 
 	if (copy_to_user(arg, &info, sizeof(info)))
diff --git a/sound/firewire/dice/dice-hwdep.c b/sound/firewire/dice/dice-hwdep.c
index f69f7996762f..ffc0b97782d6 100644
--- a/sound/firewire/dice/dice-hwdep.c
+++ b/sound/firewire/dice/dice-hwdep.c
@@ -79,7 +79,7 @@ static int hwdep_get_info(struct snd_dice *dice, void __user *arg)
 	info.card = dev->card->index;
 	*(__be32 *)&info.guid[0] = cpu_to_be32(dev->config_rom[3]);
 	*(__be32 *)&info.guid[4] = cpu_to_be32(dev->config_rom[4]);
-	strlcpy(info.device_name, dev_name(&dev->device),
+	strscpy(info.device_name, dev_name(&dev->device),
 		sizeof(info.device_name));
 
 	if (copy_to_user(arg, &info, sizeof(info)))
diff --git a/sound/firewire/digi00x/digi00x-hwdep.c b/sound/firewire/digi00x/digi00x-hwdep.c
index 41c5857c612e..aadf7d724856 100644
--- a/sound/firewire/digi00x/digi00x-hwdep.c
+++ b/sound/firewire/digi00x/digi00x-hwdep.c
@@ -87,7 +87,7 @@ static int hwdep_get_info(struct snd_dg00x *dg00x, void __user *arg)
 	info.card = dev->card->index;
 	*(__be32 *)&info.guid[0] = cpu_to_be32(dev->config_rom[3]);
 	*(__be32 *)&info.guid[4] = cpu_to_be32(dev->config_rom[4]);
-	strlcpy(info.device_name, dev_name(&dev->device),
+	strscpy(info.device_name, dev_name(&dev->device),
 		sizeof(info.device_name));
 
 	if (copy_to_user(arg, &info, sizeof(info)))
diff --git a/sound/firewire/fireface/ff-hwdep.c b/sound/firewire/fireface/ff-hwdep.c
index e73e8d2865a5..4b2e0dff5ddb 100644
--- a/sound/firewire/fireface/ff-hwdep.c
+++ b/sound/firewire/fireface/ff-hwdep.c
@@ -79,7 +79,7 @@ static int hwdep_get_info(struct snd_ff *ff, void __user *arg)
 	info.card = dev->card->index;
 	*(__be32 *)&info.guid[0] = cpu_to_be32(dev->config_rom[3]);
 	*(__be32 *)&info.guid[4] = cpu_to_be32(dev->config_rom[4]);
-	strlcpy(info.device_name, dev_name(&dev->device),
+	strscpy(info.device_name, dev_name(&dev->device),
 		sizeof(info.device_name));
 
 	if (copy_to_user(arg, &info, sizeof(info)))
diff --git a/sound/firewire/fireworks/fireworks_hwdep.c b/sound/firewire/fireworks/fireworks_hwdep.c
index e93eb4616c5f..626c0c34b0b6 100644
--- a/sound/firewire/fireworks/fireworks_hwdep.c
+++ b/sound/firewire/fireworks/fireworks_hwdep.c
@@ -212,7 +212,7 @@ hwdep_get_info(struct snd_efw *efw, void __user *arg)
 	info.card = dev->card->index;
 	*(__be32 *)&info.guid[0] = cpu_to_be32(dev->config_rom[3]);
 	*(__be32 *)&info.guid[4] = cpu_to_be32(dev->config_rom[4]);
-	strlcpy(info.device_name, dev_name(&dev->device),
+	strscpy(info.device_name, dev_name(&dev->device),
 		sizeof(info.device_name));
 
 	if (copy_to_user(arg, &info, sizeof(info)))
diff --git a/sound/firewire/motu/motu-hwdep.c b/sound/firewire/motu/motu-hwdep.c
index 0764a477052a..b5ced5d27758 100644
--- a/sound/firewire/motu/motu-hwdep.c
+++ b/sound/firewire/motu/motu-hwdep.c
@@ -86,7 +86,7 @@ static int hwdep_get_info(struct snd_motu *motu, void __user *arg)
 	info.card = dev->card->index;
 	*(__be32 *)&info.guid[0] = cpu_to_be32(dev->config_rom[3]);
 	*(__be32 *)&info.guid[4] = cpu_to_be32(dev->config_rom[4]);
-	strlcpy(info.device_name, dev_name(&dev->device),
+	strscpy(info.device_name, dev_name(&dev->device),
 		sizeof(info.device_name));
 
 	if (copy_to_user(arg, &info, sizeof(info)))
diff --git a/sound/firewire/oxfw/oxfw-hwdep.c b/sound/firewire/oxfw/oxfw-hwdep.c
index eba33d050060..9e1b3e151bad 100644
--- a/sound/firewire/oxfw/oxfw-hwdep.c
+++ b/sound/firewire/oxfw/oxfw-hwdep.c
@@ -79,7 +79,7 @@ static int hwdep_get_info(struct snd_oxfw *oxfw, void __user *arg)
 	info.card = dev->card->index;
 	*(__be32 *)&info.guid[0] = cpu_to_be32(dev->config_rom[3]);
 	*(__be32 *)&info.guid[4] = cpu_to_be32(dev->config_rom[4]);
-	strlcpy(info.device_name, dev_name(&dev->device),
+	strscpy(info.device_name, dev_name(&dev->device),
 		sizeof(info.device_name));
 
 	if (copy_to_user(arg, &info, sizeof(info)))
diff --git a/sound/firewire/tascam/tascam-hwdep.c b/sound/firewire/tascam/tascam-hwdep.c
index 6f38335fe10b..74eed9505665 100644
--- a/sound/firewire/tascam/tascam-hwdep.c
+++ b/sound/firewire/tascam/tascam-hwdep.c
@@ -154,7 +154,7 @@ static int hwdep_get_info(struct snd_tscm *tscm, void __user *arg)
 	info.card = dev->card->index;
 	*(__be32 *)&info.guid[0] = cpu_to_be32(dev->config_rom[3]);
 	*(__be32 *)&info.guid[4] = cpu_to_be32(dev->config_rom[4]);
-	strlcpy(info.device_name, dev_name(&dev->device),
+	strscpy(info.device_name, dev_name(&dev->device),
 		sizeof(info.device_name));
 
 	if (copy_to_user(arg, &info, sizeof(info)))
diff --git a/sound/i2c/i2c.c b/sound/i2c/i2c.c
index a684faa771ef..847e3b6ca601 100644
--- a/sound/i2c/i2c.c
+++ b/sound/i2c/i2c.c
@@ -84,7 +84,7 @@ int snd_i2c_bus_create(struct snd_card *card, const char *name,
 		list_add_tail(&bus->buses, &master->buses);
 		bus->master = master;
 	}
-	strlcpy(bus->name, name, sizeof(bus->name));
+	strscpy(bus->name, name, sizeof(bus->name));
 	err = snd_device_new(card, SNDRV_DEV_BUS, bus, &ops);
 	if (err < 0) {
 		snd_i2c_bus_free(bus);
@@ -108,7 +108,7 @@ int snd_i2c_device_create(struct snd_i2c_bus *bus, const char *name,
 	if (device == NULL)
 		return -ENOMEM;
 	device->addr = addr;
-	strlcpy(device->name, name, sizeof(device->name));
+	strscpy(device->name, name, sizeof(device->name));
 	list_add_tail(&device->list, &bus->devices);
 	device->bus = bus;
 	*rdevice = device;
diff --git a/sound/isa/ad1848/ad1848.c b/sound/isa/ad1848/ad1848.c
index 593c6e959afe..47bffe623105 100644
--- a/sound/isa/ad1848/ad1848.c
+++ b/sound/isa/ad1848/ad1848.c
@@ -95,8 +95,8 @@ static int snd_ad1848_probe(struct device *dev, unsigned int n)
 	if (error < 0)
 		goto out;
 
-	strlcpy(card->driver, "AD1848", sizeof(card->driver));
-	strlcpy(card->shortname, chip->pcm->name, sizeof(card->shortname));
+	strscpy(card->driver, "AD1848", sizeof(card->driver));
+	strscpy(card->shortname, chip->pcm->name, sizeof(card->shortname));
 
 	if (!thinkpad[n])
 		snprintf(card->longname, sizeof(card->longname),
diff --git a/sound/isa/cs423x/cs4231.c b/sound/isa/cs423x/cs4231.c
index 2135963eba78..bcbea6962d7e 100644
--- a/sound/isa/cs423x/cs4231.c
+++ b/sound/isa/cs423x/cs4231.c
@@ -95,8 +95,8 @@ static int snd_cs4231_probe(struct device *dev, unsigned int n)
 	if (error < 0)
 		goto out;
 
-	strlcpy(card->driver, "CS4231", sizeof(card->driver));
-	strlcpy(card->shortname, chip->pcm->name, sizeof(card->shortname));
+	strscpy(card->driver, "CS4231", sizeof(card->driver));
+	strscpy(card->shortname, chip->pcm->name, sizeof(card->shortname));
 
 	if (dma2[n] < 0)
 		snprintf(card->longname, sizeof(card->longname),
diff --git a/sound/isa/cs423x/cs4236.c b/sound/isa/cs423x/cs4236.c
index fa3c39cff5f8..fb9d8a4b7084 100644
--- a/sound/isa/cs423x/cs4236.c
+++ b/sound/isa/cs423x/cs4236.c
@@ -405,8 +405,8 @@ static int snd_cs423x_probe(struct snd_card *card, int dev)
 		if (err < 0)
 			return err;
 	}
-	strlcpy(card->driver, chip->pcm->name, sizeof(card->driver));
-	strlcpy(card->shortname, chip->pcm->name, sizeof(card->shortname));
+	strscpy(card->driver, chip->pcm->name, sizeof(card->driver));
+	strscpy(card->shortname, chip->pcm->name, sizeof(card->shortname));
 	if (dma2[dev] < 0)
 		snprintf(card->longname, sizeof(card->longname),
 			 "%s at 0x%lx, irq %i, dma %i",
diff --git a/sound/isa/es1688/es1688.c b/sound/isa/es1688/es1688.c
index 64610571a5e1..766ab43aaf77 100644
--- a/sound/isa/es1688/es1688.c
+++ b/sound/isa/es1688/es1688.c
@@ -133,8 +133,8 @@ static int snd_es1688_probe(struct snd_card *card, unsigned int n)
 	if (error < 0)
 		return error;
 
-	strlcpy(card->driver, "ES1688", sizeof(card->driver));
-	strlcpy(card->shortname, chip->pcm->name, sizeof(card->shortname));
+	strscpy(card->driver, "ES1688", sizeof(card->driver));
+	strscpy(card->shortname, chip->pcm->name, sizeof(card->shortname));
 	snprintf(card->longname, sizeof(card->longname),
 		"%s at 0x%lx, irq %i, dma %i", chip->pcm->name, chip->port,
 		 chip->irq, chip->dma8);
diff --git a/sound/isa/sb/sb16_csp.c b/sound/isa/sb/sb16_csp.c
index 270af863e198..ec47eb2ff04f 100644
--- a/sound/isa/sb/sb16_csp.c
+++ b/sound/isa/sb/sb16_csp.c
@@ -388,7 +388,8 @@ static int snd_sb_csp_riff_load(struct snd_sb_csp * p,
 				return err;
 
 			/* fill in codec header */
-			strlcpy(p->codec_name, info.codec_name, sizeof(p->codec_name));
+			strscpy(p->codec_name, info.codec_name,
+				sizeof(p->codec_name));
 			p->func_nr = func_nr;
 			p->mode = le16_to_cpu(funcdesc_h.flags_play_rec);
 			switch (le16_to_cpu(funcdesc_h.VOC_type)) {
diff --git a/sound/isa/sb/sb_mixer.c b/sound/isa/sb/sb_mixer.c
index 3f703b4a304d..5de5506e7e60 100644
--- a/sound/isa/sb/sb_mixer.c
+++ b/sound/isa/sb/sb_mixer.c
@@ -482,7 +482,7 @@ int snd_sbmixer_add_ctl(struct snd_sb *chip, const char *name, int index, int ty
 	ctl = snd_ctl_new1(&newctls[type], chip);
 	if (! ctl)
 		return -ENOMEM;
-	strlcpy(ctl->id.name, name, sizeof(ctl->id.name));
+	strscpy(ctl->id.name, name, sizeof(ctl->id.name));
 	ctl->id.index = index;
 	ctl->private_value = value;
 	if ((err = snd_ctl_add(chip->card, ctl)) < 0)
diff --git a/sound/oss/dmasound/dmasound_core.c b/sound/oss/dmasound/dmasound_core.c
index 38f25e97538f..49679aa8631d 100644
--- a/sound/oss/dmasound/dmasound_core.c
+++ b/sound/oss/dmasound/dmasound_core.c
@@ -355,8 +355,8 @@ static int mixer_ioctl(struct file *file, u_int cmd, u_long arg)
 		{
 		    mixer_info info;
 		    memset(&info, 0, sizeof(info));
-		    strlcpy(info.id, dmasound.mach.name2, sizeof(info.id));
-		    strlcpy(info.name, dmasound.mach.name2, sizeof(info.name));
+		    strscpy(info.id, dmasound.mach.name2, sizeof(info.id));
+		    strscpy(info.name, dmasound.mach.name2, sizeof(info.name));
 		    info.modify_counter = mixer.modify_counter;
 		    if (copy_to_user((void __user *)arg, &info, sizeof(info)))
 			    return -EFAULT;
diff --git a/sound/pci/cs5535audio/cs5535audio_olpc.c b/sound/pci/cs5535audio/cs5535audio_olpc.c
index 4e295303b041..110d3209441b 100644
--- a/sound/pci/cs5535audio/cs5535audio_olpc.c
+++ b/sound/pci/cs5535audio/cs5535audio_olpc.c
@@ -158,13 +158,13 @@ int olpc_quirks(struct snd_card *card, struct snd_ac97 *ac97)
 	/* drop the original AD1888 HPF control */
 	memset(&elem, 0, sizeof(elem));
 	elem.iface = SNDRV_CTL_ELEM_IFACE_MIXER;
-	strlcpy(elem.name, "High Pass Filter Enable", sizeof(elem.name));
+	strscpy(elem.name, "High Pass Filter Enable", sizeof(elem.name));
 	snd_ctl_remove_id(card, &elem);
 
 	/* drop the original V_REFOUT control */
 	memset(&elem, 0, sizeof(elem));
 	elem.iface = SNDRV_CTL_ELEM_IFACE_MIXER;
-	strlcpy(elem.name, "V_REFOUT Enable", sizeof(elem.name));
+	strscpy(elem.name, "V_REFOUT Enable", sizeof(elem.name));
 	snd_ctl_remove_id(card, &elem);
 
 	/* add the OLPC-specific controls */
diff --git a/sound/pci/ctxfi/ctpcm.c b/sound/pci/ctxfi/ctpcm.c
index 3f48ad0e27e7..81dfc6a76b18 100644
--- a/sound/pci/ctxfi/ctpcm.c
+++ b/sound/pci/ctxfi/ctpcm.c
@@ -433,7 +433,7 @@ int ct_alsa_pcm_create(struct ct_atc *atc,
 	pcm->private_data = atc;
 	pcm->info_flags = 0;
 	pcm->dev_subclass = SNDRV_PCM_SUBCLASS_GENERIC_MIX;
-	strlcpy(pcm->name, device_name, sizeof(pcm->name));
+	strscpy(pcm->name, device_name, sizeof(pcm->name));
 
 	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_PLAYBACK, &ct_pcm_playback_ops);
 
diff --git a/sound/pci/emu10k1/emu10k1.c b/sound/pci/emu10k1/emu10k1.c
index 29b7720d7961..353934c88cbd 100644
--- a/sound/pci/emu10k1/emu10k1.c
+++ b/sound/pci/emu10k1/emu10k1.c
@@ -168,9 +168,9 @@ static int snd_card_emu10k1_probe(struct pci_dev *pci,
 	}
 #endif
  
-	strlcpy(card->driver, emu->card_capabilities->driver,
+	strscpy(card->driver, emu->card_capabilities->driver,
 		sizeof(card->driver));
-	strlcpy(card->shortname, emu->card_capabilities->name,
+	strscpy(card->shortname, emu->card_capabilities->name,
 		sizeof(card->shortname));
 	snprintf(card->longname, sizeof(card->longname),
 		 "%s (rev.%d, serial:0x%x) at 0x%lx, irq %i",
diff --git a/sound/pci/emu10k1/emu10k1_main.c b/sound/pci/emu10k1/emu10k1_main.c
index bd70e112ffd7..24a2fd706d69 100644
--- a/sound/pci/emu10k1/emu10k1_main.c
+++ b/sound/pci/emu10k1/emu10k1_main.c
@@ -1869,7 +1869,7 @@ int snd_emu10k1_create(struct snd_card *card,
 			emu->serial);
 
 	if (!*card->id && c->id)
-		strlcpy(card->id, c->id, sizeof(card->id));
+		strscpy(card->id, c->id, sizeof(card->id));
 
 	is_audigy = emu->audigy = c->emu10k2_chip;
 
diff --git a/sound/pci/emu10k1/emufx.c b/sound/pci/emu10k1/emufx.c
index 4e76ed0e91d5..81bc45d3a984 100644
--- a/sound/pci/emu10k1/emufx.c
+++ b/sound/pci/emu10k1/emufx.c
@@ -940,7 +940,8 @@ static int snd_emu10k1_list_controls(struct snd_emu10k1 *emu,
 			memset(gctl, 0, sizeof(*gctl));
 			id = &ctl->kcontrol->id;
 			gctl->id.iface = (__force int)id->iface;
-			strlcpy(gctl->id.name, id->name, sizeof(gctl->id.name));
+			strscpy(gctl->id.name, id->name,
+				sizeof(gctl->id.name));
 			gctl->id.index = id->index;
 			gctl->id.device = id->device;
 			gctl->id.subdevice = id->subdevice;
@@ -976,7 +977,7 @@ static int snd_emu10k1_icode_poke(struct snd_emu10k1 *emu,
 	err = snd_emu10k1_verify_controls(emu, icode, in_kernel);
 	if (err < 0)
 		goto __error;
-	strlcpy(emu->fx8010.name, icode->name, sizeof(emu->fx8010.name));
+	strscpy(emu->fx8010.name, icode->name, sizeof(emu->fx8010.name));
 	/* stop FX processor - this may be dangerous, but it's better to miss
 	   some samples than generate wrong ones - [jk] */
 	if (emu->audigy)
@@ -1015,7 +1016,7 @@ static int snd_emu10k1_icode_peek(struct snd_emu10k1 *emu,
 	int err;
 
 	mutex_lock(&emu->fx8010.lock);
-	strlcpy(icode->name, emu->fx8010.name, sizeof(icode->name));
+	strscpy(icode->name, emu->fx8010.name, sizeof(icode->name));
 	/* ok, do the main job */
 	err = snd_emu10k1_gpr_peek(emu, icode);
 	if (err >= 0)
diff --git a/sound/pci/es1968.c b/sound/pci/es1968.c
index 34332d008b27..c6be14c4f311 100644
--- a/sound/pci/es1968.c
+++ b/sound/pci/es1968.c
@@ -2768,7 +2768,7 @@ static int snd_es1968_create(struct snd_card *card,
 		if (!snd_tea575x_init(&chip->tea, THIS_MODULE)) {
 			dev_info(card->dev, "detected TEA575x radio type %s\n",
 				   get_tea575x_gpio(chip)->name);
-			strlcpy(chip->tea.card, get_tea575x_gpio(chip)->name,
+			strscpy(chip->tea.card, get_tea575x_gpio(chip)->name,
 				sizeof(chip->tea.card));
 			break;
 		}
diff --git a/sound/pci/fm801.c b/sound/pci/fm801.c
index 0a95032fd297..c6ad6235a669 100644
--- a/sound/pci/fm801.c
+++ b/sound/pci/fm801.c
@@ -1300,7 +1300,7 @@ static int snd_fm801_create(struct snd_card *card,
 		chip->tea575x_tuner |= tuner_only;
 	}
 	if (!(chip->tea575x_tuner & TUNER_DISABLED)) {
-		strlcpy(chip->tea.card, get_tea575x_gpio(chip)->name,
+		strscpy(chip->tea.card, get_tea575x_gpio(chip)->name,
 			sizeof(chip->tea.card));
 	}
 #endif
diff --git a/sound/pci/hda/hda_auto_parser.c b/sound/pci/hda/hda_auto_parser.c
index 4dc01647753c..1a001ecf7f63 100644
--- a/sound/pci/hda/hda_auto_parser.c
+++ b/sound/pci/hda/hda_auto_parser.c
@@ -764,7 +764,7 @@ int snd_hda_get_pin_label(struct hda_codec *codec, hda_nid_t nid,
 	}
 	if (!name)
 		return 0;
-	strlcpy(label, name, maxlen);
+	strscpy(label, name, maxlen);
 	return 1;
 }
 EXPORT_SYMBOL_GPL(snd_hda_get_pin_label);
diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index 4bb58e8b08a8..35c33dac0060 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -4009,7 +4009,7 @@ int snd_hda_add_imux_item(struct hda_codec *codec,
 			 sizeof(imux->items[imux->num_items].label),
 			 "%s %d", label, label_idx);
 	else
-		strlcpy(imux->items[imux->num_items].label, label,
+		strscpy(imux->items[imux->num_items].label, label,
 			sizeof(imux->items[imux->num_items].label));
 	imux->items[imux->num_items].index = index;
 	imux->num_items++;
diff --git a/sound/pci/hda/hda_controller.c b/sound/pci/hda/hda_controller.c
index 80016b7b6849..9087981cd1f7 100644
--- a/sound/pci/hda/hda_controller.c
+++ b/sound/pci/hda/hda_controller.c
@@ -735,7 +735,7 @@ int snd_hda_attach_pcm_stream(struct hda_bus *_bus, struct hda_codec *codec,
 			  &pcm);
 	if (err < 0)
 		return err;
-	strlcpy(pcm->name, cpcm->name, sizeof(pcm->name));
+	strscpy(pcm->name, cpcm->name, sizeof(pcm->name));
 	apcm = kzalloc(sizeof(*apcm), GFP_KERNEL);
 	if (apcm == NULL) {
 		snd_device_free(chip->card, pcm);
diff --git a/sound/pci/hda/hda_eld.c b/sound/pci/hda/hda_eld.c
index 136477ed46ae..9e97443795f8 100644
--- a/sound/pci/hda/hda_eld.c
+++ b/sound/pci/hda/hda_eld.c
@@ -260,7 +260,7 @@ int snd_hdmi_parse_eld(struct hda_codec *codec, struct parsed_hdmi_eld *e,
 		codec_info(codec, "HDMI: out of range MNL %d\n", mnl);
 		goto out_fail;
 	} else
-		strlcpy(e->monitor_name, buf + ELD_FIXED_BYTES, mnl + 1);
+		strscpy(e->monitor_name, buf + ELD_FIXED_BYTES, mnl + 1);
 
 	for (i = 0; i < e->sad_count; i++) {
 		if (ELD_FIXED_BYTES + mnl + 3 * (i + 1) > size) {
diff --git a/sound/pci/hda/hda_generic.c b/sound/pci/hda/hda_generic.c
index 8060cc86dfea..5e40944e7342 100644
--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -5721,7 +5721,7 @@ static void fill_pcm_stream_name(char *str, size_t len, const char *sfx,
 
 	if (*str)
 		return;
-	strlcpy(str, chip_name, len);
+	strscpy(str, chip_name, len);
 
 	/* drop non-alnum chars after a space */
 	for (p = strchr(str, ' '); p; p = strchr(p + 1, ' ')) {
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 6852668f1bcb..726d270cd585 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2037,7 +2037,7 @@ static int azx_first_init(struct azx *chip)
 		return -EBUSY;
 
 	strcpy(card->driver, "HDA-Intel");
-	strlcpy(card->shortname, driver_short_names[chip->driver_type],
+	strscpy(card->shortname, driver_short_names[chip->driver_type],
 		sizeof(card->shortname));
 	snprintf(card->longname, sizeof(card->longname),
 		 "%s at 0x%lx irq %i",
diff --git a/sound/pci/hda/hda_jack.c b/sound/pci/hda/hda_jack.c
index 588059428d8f..b8b568046592 100644
--- a/sound/pci/hda/hda_jack.c
+++ b/sound/pci/hda/hda_jack.c
@@ -530,7 +530,7 @@ static int add_jack_kctl(struct hda_codec *codec, hda_nid_t nid,
 		       !is_jack_detectable(codec, nid);
 
 	if (base_name)
-		strlcpy(name, base_name, sizeof(name));
+		strscpy(name, base_name, sizeof(name));
 	else
 		snd_hda_get_pin_label(codec, nid, cfg, name, sizeof(name), NULL);
 	if (phantom_jack)
diff --git a/sound/pci/ice1712/juli.c b/sound/pci/ice1712/juli.c
index e57a55cebc5a..f0f8324b08b6 100644
--- a/sound/pci/ice1712/juli.c
+++ b/sound/pci/ice1712/juli.c
@@ -413,7 +413,7 @@ static struct snd_kcontrol *ctl_find(struct snd_card *card,
 {
 	struct snd_ctl_elem_id sid = {0};
 
-	strlcpy(sid.name, name, sizeof(sid.name));
+	strscpy(sid.name, name, sizeof(sid.name));
 	sid.iface = SNDRV_CTL_ELEM_IFACE_MIXER;
 	return snd_ctl_find_id(card, &sid);
 }
diff --git a/sound/pci/ice1712/psc724.c b/sound/pci/ice1712/psc724.c
index 7aa3f92040d0..93e828d19b52 100644
--- a/sound/pci/ice1712/psc724.c
+++ b/sound/pci/ice1712/psc724.c
@@ -189,13 +189,13 @@ static void psc724_set_jack_state(struct snd_ice1712 *ice, bool hp_connected)
 	/* notify about master speaker mute change */
 	memset(&elem_id, 0, sizeof(elem_id));
 	elem_id.iface = SNDRV_CTL_ELEM_IFACE_MIXER;
-	strlcpy(elem_id.name, "Master Speakers Playback Switch",
-						sizeof(elem_id.name));
+	strscpy(elem_id.name, "Master Speakers Playback Switch",
+		sizeof(elem_id.name));
 	kctl = snd_ctl_find_id(ice->card, &elem_id);
 	snd_ctl_notify(ice->card, SNDRV_CTL_EVENT_MASK_VALUE, &kctl->id);
 	/* and headphone mute change */
-	strlcpy(elem_id.name, spec->wm8776.ctl[WM8776_CTL_HP_SW].name,
-						sizeof(elem_id.name));
+	strscpy(elem_id.name, spec->wm8776.ctl[WM8776_CTL_HP_SW].name,
+		sizeof(elem_id.name));
 	kctl = snd_ctl_find_id(ice->card, &elem_id);
 	snd_ctl_notify(ice->card, SNDRV_CTL_EVENT_MASK_VALUE, &kctl->id);
 }
diff --git a/sound/pci/ice1712/quartet.c b/sound/pci/ice1712/quartet.c
index 0e3e04aa9faf..0dfa093f7dca 100644
--- a/sound/pci/ice1712/quartet.c
+++ b/sound/pci/ice1712/quartet.c
@@ -771,7 +771,7 @@ static struct snd_kcontrol *ctl_find(struct snd_card *card,
 {
 	struct snd_ctl_elem_id sid = {0};
 
-	strlcpy(sid.name, name, sizeof(sid.name));
+	strscpy(sid.name, name, sizeof(sid.name));
 	sid.iface = SNDRV_CTL_ELEM_IFACE_MIXER;
 	return snd_ctl_find_id(card, &sid);
 }
diff --git a/sound/pci/ice1712/wm8776.c b/sound/pci/ice1712/wm8776.c
index d96008df880d..6eda86119dff 100644
--- a/sound/pci/ice1712/wm8776.c
+++ b/sound/pci/ice1712/wm8776.c
@@ -38,7 +38,7 @@ static void snd_wm8776_activate_ctl(struct snd_wm8776 *wm,
 	unsigned int index_offset;
 
 	memset(&elem_id, 0, sizeof(elem_id));
-	strlcpy(elem_id.name, ctl_name, sizeof(elem_id.name));
+	strscpy(elem_id.name, ctl_name, sizeof(elem_id.name));
 	elem_id.iface = SNDRV_CTL_ELEM_IFACE_MIXER;
 	kctl = snd_ctl_find_id(card, &elem_id);
 	if (!kctl)
diff --git a/sound/pci/lola/lola.c b/sound/pci/lola/lola.c
index cdd8db79bcfa..491c90f83fbc 100644
--- a/sound/pci/lola/lola.c
+++ b/sound/pci/lola/lola.c
@@ -669,7 +669,7 @@ static int lola_create(struct snd_card *card, struct pci_dev *pci,
 	}
 
 	strcpy(card->driver, "Lola");
-	strlcpy(card->shortname, "Digigram Lola", sizeof(card->shortname));
+	strscpy(card->shortname, "Digigram Lola", sizeof(card->shortname));
 	snprintf(card->longname, sizeof(card->longname),
 		 "%s at 0x%lx irq %i",
 		 card->shortname, chip->bar[0].addr, chip->irq);
diff --git a/sound/pci/lola/lola_pcm.c b/sound/pci/lola/lola_pcm.c
index f647c7ed00c4..684faaf40f31 100644
--- a/sound/pci/lola/lola_pcm.c
+++ b/sound/pci/lola/lola_pcm.c
@@ -601,7 +601,7 @@ int lola_create_pcm(struct lola *chip)
 			  &pcm);
 	if (err < 0)
 		return err;
-	strlcpy(pcm->name, "Digigram Lola", sizeof(pcm->name));
+	strscpy(pcm->name, "Digigram Lola", sizeof(pcm->name));
 	pcm->private_data = chip;
 	for (i = 0; i < 2; i++) {
 		if (chip->pcm[i].num_streams)
diff --git a/sound/pci/rme9652/hdspm.c b/sound/pci/rme9652/hdspm.c
index 4a1f576dd9cf..2f612fd71558 100644
--- a/sound/pci/rme9652/hdspm.c
+++ b/sound/pci/rme9652/hdspm.c
@@ -6336,8 +6336,8 @@ static int snd_hdspm_hwdep_ioctl(struct snd_hwdep *hw, struct file *file,
 		memset(&hdspm_version, 0, sizeof(hdspm_version));
 
 		hdspm_version.card_type = hdspm->io_type;
-		strlcpy(hdspm_version.cardname, hdspm->card_name,
-				sizeof(hdspm_version.cardname));
+		strscpy(hdspm_version.cardname, hdspm->card_name,
+			sizeof(hdspm_version.cardname));
 		hdspm_version.serial = hdspm->serial;
 		hdspm_version.firmware_rev = hdspm->firmware_rev;
 		hdspm_version.addons = 0;
diff --git a/sound/ppc/keywest.c b/sound/ppc/keywest.c
index 9554a0c506af..a6c1905039de 100644
--- a/sound/ppc/keywest.c
+++ b/sound/ppc/keywest.c
@@ -49,7 +49,7 @@ static int keywest_attach_adapter(struct i2c_adapter *adapter)
 		return -EINVAL; /* ignored */
 
 	memset(&info, 0, sizeof(struct i2c_board_info));
-	strlcpy(info.type, "keywest", I2C_NAME_SIZE);
+	strscpy(info.type, "keywest", I2C_NAME_SIZE);
 	info.addr = keywest_ctx->addr;
 	client = i2c_new_client_device(adapter, &info);
 	if (IS_ERR(client))
diff --git a/sound/soc/qcom/qdsp6/q6afe.c b/sound/soc/qcom/qdsp6/q6afe.c
index 0ca1e4aae518..095bbe27db1b 100644
--- a/sound/soc/qcom/qdsp6/q6afe.c
+++ b/sound/soc/qcom/qdsp6/q6afe.c
@@ -1707,8 +1707,8 @@ int q6afe_vote_lpass_core_hw(struct device *dev, uint32_t hw_block_id,
 	pkt->hdr.token = hw_block_id;
 	pkt->hdr.opcode = AFE_CMD_REMOTE_LPASS_CORE_HW_VOTE_REQUEST;
 	vote_cfg->hw_block_id = hw_block_id;
-	strlcpy(vote_cfg->client_name, client_name,
-			sizeof(vote_cfg->client_name));
+	strscpy(vote_cfg->client_name, client_name,
+		sizeof(vote_cfg->client_name));
 
 	ret = afe_apr_send_pkt(afe, pkt, NULL,
 			       AFE_CMD_RSP_REMOTE_LPASS_CORE_HW_VOTE_REQUEST);
diff --git a/sound/soc/sh/rcar/core.c b/sound/soc/sh/rcar/core.c
index 6e670b3e92a0..6dd5659db44c 100644
--- a/sound/soc/sh/rcar/core.c
+++ b/sound/soc/sh/rcar/core.c
@@ -1472,7 +1472,7 @@ static int rsnd_kctrl_info(struct snd_kcontrol *kctrl,
 		uinfo->value.enumerated.items = cfg->max;
 		if (uinfo->value.enumerated.item >= cfg->max)
 			uinfo->value.enumerated.item = cfg->max - 1;
-		strlcpy(uinfo->value.enumerated.name,
+		strscpy(uinfo->value.enumerated.name,
 			cfg->texts[uinfo->value.enumerated.item],
 			sizeof(uinfo->value.enumerated.name));
 	} else {
diff --git a/sound/usb/bcd2000/bcd2000.c b/sound/usb/bcd2000/bcd2000.c
index 010976d9ceb2..cd4a0bc6d278 100644
--- a/sound/usb/bcd2000/bcd2000.c
+++ b/sound/usb/bcd2000/bcd2000.c
@@ -300,7 +300,7 @@ static int bcd2000_init_midi(struct bcd2000 *bcd2k)
 	if (ret < 0)
 		return ret;
 
-	strlcpy(rmidi->name, bcd2k->card->shortname, sizeof(rmidi->name));
+	strscpy(rmidi->name, bcd2k->card->shortname, sizeof(rmidi->name));
 
 	rmidi->info_flags = SNDRV_RAWMIDI_INFO_DUPLEX;
 	rmidi->private_data = bcd2k;
diff --git a/sound/usb/caiaq/audio.c b/sound/usb/caiaq/audio.c
index 3b6bb2cbe886..4981753652a7 100644
--- a/sound/usb/caiaq/audio.c
+++ b/sound/usb/caiaq/audio.c
@@ -804,7 +804,7 @@ int snd_usb_caiaq_audio_init(struct snd_usb_caiaqdev *cdev)
 	}
 
 	cdev->pcm->private_data = cdev;
-	strlcpy(cdev->pcm->name, cdev->product_name, sizeof(cdev->pcm->name));
+	strscpy(cdev->pcm->name, cdev->product_name, sizeof(cdev->pcm->name));
 
 	memset(cdev->sub_playback, 0, sizeof(cdev->sub_playback));
 	memset(cdev->sub_capture, 0, sizeof(cdev->sub_capture));
diff --git a/sound/usb/caiaq/device.c b/sound/usb/caiaq/device.c
index 2af3b7eb0a88..e03481caf7f6 100644
--- a/sound/usb/caiaq/device.c
+++ b/sound/usb/caiaq/device.c
@@ -477,9 +477,9 @@ static int init_card(struct snd_usb_caiaqdev *cdev)
 	usb_string(usb_dev, usb_dev->descriptor.iProduct,
 		   cdev->product_name, CAIAQ_USB_STR_LEN);
 
-	strlcpy(card->driver, MODNAME, sizeof(card->driver));
-	strlcpy(card->shortname, cdev->product_name, sizeof(card->shortname));
-	strlcpy(card->mixername, cdev->product_name, sizeof(card->mixername));
+	strscpy(card->driver, MODNAME, sizeof(card->driver));
+	strscpy(card->shortname, cdev->product_name, sizeof(card->shortname));
+	strscpy(card->mixername, cdev->product_name, sizeof(card->mixername));
 
 	/* if the id was not passed as module option, fill it with a shortened
 	 * version of the product string which does not contain any
diff --git a/sound/usb/caiaq/midi.c b/sound/usb/caiaq/midi.c
index 512fbb3ee604..c656d0162432 100644
--- a/sound/usb/caiaq/midi.c
+++ b/sound/usb/caiaq/midi.c
@@ -125,7 +125,7 @@ int snd_usb_caiaq_midi_init(struct snd_usb_caiaqdev *device)
 	if (ret < 0)
 		return ret;
 
-	strlcpy(rmidi->name, device->product_name, sizeof(rmidi->name));
+	strscpy(rmidi->name, device->product_name, sizeof(rmidi->name));
 
 	rmidi->info_flags = SNDRV_RAWMIDI_INFO_DUPLEX;
 	rmidi->private_data = device;
diff --git a/sound/usb/card.c b/sound/usb/card.c
index 450a527f654b..711012f5a395 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -470,7 +470,7 @@ static void usb_audio_make_shortname(struct usb_device *dev,
 	else if (quirk && quirk->product_name)
 		s = quirk->product_name;
 	if (s && *s) {
-		strlcpy(card->shortname, s, sizeof(card->shortname));
+		strscpy(card->shortname, s, sizeof(card->shortname));
 		return;
 	}
 
@@ -502,7 +502,7 @@ static void usb_audio_make_longname(struct usb_device *dev,
 	if (preset && preset->profile_name)
 		s = preset->profile_name;
 	if (s && *s) {
-		strlcpy(card->longname, s, sizeof(card->longname));
+		strscpy(card->longname, s, sizeof(card->longname));
 		return;
 	}
 
diff --git a/sound/usb/hiface/chip.c b/sound/usb/hiface/chip.c
index b2d9623e9934..783b7e2896d2 100644
--- a/sound/usb/hiface/chip.c
+++ b/sound/usb/hiface/chip.c
@@ -80,12 +80,14 @@ static int hiface_chip_create(struct usb_interface *intf,
 		return ret;
 	}
 
-	strlcpy(card->driver, DRIVER_NAME, sizeof(card->driver));
+	strscpy(card->driver, DRIVER_NAME, sizeof(card->driver));
 
 	if (quirk && quirk->device_name)
-		strlcpy(card->shortname, quirk->device_name, sizeof(card->shortname));
+		strscpy(card->shortname, quirk->device_name,
+			sizeof(card->shortname));
 	else
-		strlcpy(card->shortname, "M2Tech generic audio", sizeof(card->shortname));
+		strscpy(card->shortname, "M2Tech generic audio",
+			sizeof(card->shortname));
 
 	strlcat(card->longname, card->shortname, sizeof(card->longname));
 	len = strlcat(card->longname, " at ", sizeof(card->longname));
diff --git a/sound/usb/hiface/pcm.c b/sound/usb/hiface/pcm.c
index d942179ca095..71f17f02f341 100644
--- a/sound/usb/hiface/pcm.c
+++ b/sound/usb/hiface/pcm.c
@@ -594,7 +594,7 @@ int hiface_pcm_init(struct hiface_chip *chip, u8 extra_freq)
 	pcm->private_data = rt;
 	pcm->private_free = hiface_pcm_free;
 
-	strlcpy(pcm->name, "USB-SPDIF Audio", sizeof(pcm->name));
+	strscpy(pcm->name, "USB-SPDIF Audio", sizeof(pcm->name));
 	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_PLAYBACK, &pcm_ops);
 	snd_pcm_set_managed_buffer_all(pcm, SNDRV_DMA_TYPE_VMALLOC,
 				       NULL, 0, 0);
diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 81e987eaf063..a7bc5347de94 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -119,7 +119,7 @@ check_mapped_name(const struct usbmix_name_map *p, char *buf, int buflen)
 		return 0;
 
 	buflen--;
-	return strlcpy(buf, p->name, buflen);
+	return strscpy(buf, p->name, buflen);
 }
 
 /* ignore the error value if ignore_ctl_error flag is set */
@@ -156,7 +156,7 @@ static int check_mapped_selector_name(struct mixer_build *state, int unitid,
 		return 0;
 	for (p = state->selector_map; p->id; p++) {
 		if (p->id == unitid && index < p->count)
-			return strlcpy(buf, p->names[index], buflen);
+			return strscpy(buf, p->names[index], buflen);
 	}
 	return 0;
 }
@@ -1556,7 +1556,7 @@ static void check_no_speaker_on_headset(struct snd_kcontrol *kctl,
 	if (!found)
 		return;
 
-	strlcpy(kctl->id.name, "Headphone", sizeof(kctl->id.name));
+	strscpy(kctl->id.name, "Headphone", sizeof(kctl->id.name));
 }
 
 static const struct usb_feature_control_info *get_feature_control_info(int control)
@@ -1691,7 +1691,8 @@ static void __build_feature_ctl(struct usb_mixer_interface *mixer,
 		break;
 	default:
 		if (!len)
-			strlcpy(kctl->id.name, audio_feature_info[control-1].name,
+			strscpy(kctl->id.name,
+				audio_feature_info[control - 1].name,
 				sizeof(kctl->id.name));
 		break;
 	}
@@ -1770,7 +1771,7 @@ static void get_connector_control_name(struct usb_mixer_interface *mixer,
 	int name_len = get_term_name(mixer->chip, term, name, name_size, 0);
 
 	if (name_len == 0)
-		strlcpy(name, "Unknown", name_size);
+		strscpy(name, "Unknown", name_size);
 
 	/*
 	 *  sound/core/ctljack.c has a convention of naming jack controls
@@ -2490,7 +2491,8 @@ static int build_audio_procunit(struct mixer_build *state, int unitid,
 		if (check_mapped_name(map, kctl->id.name, sizeof(kctl->id.name))) {
 			/* nothing */ ;
 		} else if (info->name) {
-			strlcpy(kctl->id.name, info->name, sizeof(kctl->id.name));
+			strscpy(kctl->id.name, info->name,
+				sizeof(kctl->id.name));
 		} else {
 			if (extension_unit)
 				nameid = uac_extension_unit_iExtension(desc, state->mixer->protocol);
@@ -2503,7 +2505,8 @@ static int build_audio_procunit(struct mixer_build *state, int unitid,
 							       kctl->id.name,
 							       sizeof(kctl->id.name));
 			if (!len)
-				strlcpy(kctl->id.name, name, sizeof(kctl->id.name));
+				strscpy(kctl->id.name, name,
+					sizeof(kctl->id.name));
 		}
 		append_ctl_name(kctl, " ");
 		append_ctl_name(kctl, valinfo->suffix);
@@ -2743,7 +2746,7 @@ static int parse_audio_selector_unit(struct mixer_build *state, int unitid,
 				    kctl->id.name, sizeof(kctl->id.name), 0);
 		/* ... or use the fixed string "USB" as the last resort */
 		if (!len)
-			strlcpy(kctl->id.name, "USB", sizeof(kctl->id.name));
+			strscpy(kctl->id.name, "USB", sizeof(kctl->id.name));
 
 		/* and add the proper suffix */
 		if (desc->bDescriptorSubtype == UAC2_CLOCK_SELECTOR ||
diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index df036a359f2f..1acd50cb31cb 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -2725,7 +2725,8 @@ static int snd_pioneer_djm_controls_info(struct snd_kcontrol *kctl, struct snd_c
 	if (info->value.enumerated.item >= count)
 		info->value.enumerated.item = count - 1;
 	name = group->options[info->value.enumerated.item].name;
-	strlcpy(info->value.enumerated.name, name, sizeof(info->value.enumerated.name));
+	strscpy(info->value.enumerated.name, name,
+		sizeof(info->value.enumerated.name));
 	info->type = SNDRV_CTL_ELEM_TYPE_ENUMERATED;
 	info->count = 1;
 	info->value.enumerated.items = count;
diff --git a/sound/usb/mixer_scarlett.c b/sound/usb/mixer_scarlett.c
index 49fcd2505443..691b95466d0f 100644
--- a/sound/usb/mixer_scarlett.c
+++ b/sound/usb/mixer_scarlett.c
@@ -569,7 +569,7 @@ static int add_new_ctl(struct usb_mixer_interface *mixer,
 	}
 	kctl->private_free = snd_usb_mixer_elem_free;
 
-	strlcpy(kctl->id.name, name, sizeof(kctl->id.name));
+	strscpy(kctl->id.name, name, sizeof(kctl->id.name));
 
 	err = snd_usb_mixer_add_control(&elem->head, kctl);
 	if (err < 0)
diff --git a/sound/usb/mixer_scarlett_gen2.c b/sound/usb/mixer_scarlett_gen2.c
index 4bbec56c7df3..560c2ade829d 100644
--- a/sound/usb/mixer_scarlett_gen2.c
+++ b/sound/usb/mixer_scarlett_gen2.c
@@ -961,7 +961,7 @@ static int scarlett2_add_new_ctl(struct usb_mixer_interface *mixer,
 	}
 	kctl->private_free = snd_usb_mixer_elem_free;
 
-	strlcpy(kctl->id.name, name, sizeof(kctl->id.name));
+	strscpy(kctl->id.name, name, sizeof(kctl->id.name));
 
 	err = snd_usb_mixer_add_control(&elem->head, kctl);
 	if (err < 0)
diff --git a/sound/usb/mixer_us16x08.c b/sound/usb/mixer_us16x08.c
index bd63a9ce6a70..b7b6f3834ed5 100644
--- a/sound/usb/mixer_us16x08.c
+++ b/sound/usb/mixer_us16x08.c
@@ -1076,7 +1076,7 @@ static int add_new_ctl(struct usb_mixer_interface *mixer,
 	else
 		kctl->private_free = snd_usb_mixer_elem_free;
 
-	strlcpy(kctl->id.name, name, sizeof(kctl->id.name));
+	strscpy(kctl->id.name, name, sizeof(kctl->id.name));
 
 	err = snd_usb_mixer_add_control(&elem->head, kctl);
 	if (err < 0)
diff --git a/sound/x86/intel_hdmi_audio.c b/sound/x86/intel_hdmi_audio.c
index 9f9fcd2749f2..5b351f4ca543 100644
--- a/sound/x86/intel_hdmi_audio.c
+++ b/sound/x86/intel_hdmi_audio.c
@@ -1790,7 +1790,7 @@ static int hdmi_lpe_audio_probe(struct platform_device *pdev)
 		/* setup private data which can be retrieved when required */
 		pcm->private_data = ctx;
 		pcm->info_flags = 0;
-		strlcpy(pcm->name, card->shortname, strlen(card->shortname));
+		strscpy(pcm->name, card->shortname, strlen(card->shortname));
 		/* setup the ops for playabck */
 		snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_PLAYBACK, &had_pcm_ops);
 
diff --git a/sound/xen/xen_snd_front_cfg.c b/sound/xen/xen_snd_front_cfg.c
index eda077c8087a..63b0398c3276 100644
--- a/sound/xen/xen_snd_front_cfg.c
+++ b/sound/xen/xen_snd_front_cfg.c
@@ -398,7 +398,7 @@ static int cfg_device(struct xen_snd_front_info *front_info,
 
 	str = xenbus_read(XBT_NIL, device_path, XENSND_FIELD_DEVICE_NAME, NULL);
 	if (!IS_ERR(str)) {
-		strlcpy(pcm_instance->name, str, sizeof(pcm_instance->name));
+		strscpy(pcm_instance->name, str, sizeof(pcm_instance->name));
 		kfree(str);
 	}
 
diff --git a/tools/perf/arch/x86/util/event.c b/tools/perf/arch/x86/util/event.c
index 047dc00eafa6..125ac1efd143 100644
--- a/tools/perf/arch/x86/util/event.c
+++ b/tools/perf/arch/x86/util/event.c
@@ -61,7 +61,7 @@ int perf_event__synthesize_extra_kmaps(struct perf_tool *tool,
 		event->mmap.pgoff = pos->pgoff;
 		event->mmap.pid   = machine->pid;
 
-		strlcpy(event->mmap.filename, kmap->name, PATH_MAX);
+		strscpy(event->mmap.filename, kmap->name, PATH_MAX);
 
 		if (perf_tool__process_synth_event(tool, event, machine,
 						   process) != 0) {
diff --git a/tools/perf/arch/x86/util/machine.c b/tools/perf/arch/x86/util/machine.c
index 31679c35d493..1ff0be147205 100644
--- a/tools/perf/arch/x86/util/machine.c
+++ b/tools/perf/arch/x86/util/machine.c
@@ -40,7 +40,7 @@ static int add_extra_kernel_map(struct extra_kernel_map_info *mi, u64 start,
 	mi->maps[mi->cnt].start = start;
 	mi->maps[mi->cnt].end   = end;
 	mi->maps[mi->cnt].pgoff = pgoff;
-	strlcpy(mi->maps[mi->cnt].name, name, KMAP_NAME_LEN);
+	strscpy(mi->maps[mi->cnt].name, name, KMAP_NAME_LEN);
 
 	mi->cnt += 1;
 
diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
index a25411926e48..55904d58d9aa 100644
--- a/tools/perf/builtin-buildid-cache.c
+++ b/tools/perf/builtin-buildid-cache.c
@@ -35,7 +35,7 @@ static int build_id_cache__kcore_buildid(const char *proc_dir, char *sbuildid)
 	char root_dir[PATH_MAX];
 	char *p;
 
-	strlcpy(root_dir, proc_dir, sizeof(root_dir));
+	strscpy(root_dir, proc_dir, sizeof(root_dir));
 
 	p = strrchr(root_dir, '/');
 	if (!p)
@@ -103,7 +103,7 @@ static int build_id_cache__kcore_existing(const char *from_dir, char *to_dir,
 			  to_dir, dent->d_name);
 		if (!compare_proc_modules(from, to) &&
 		    same_kallsyms_reloc(from_dir, to_subdir)) {
-			strlcpy(to_dir, to_subdir, to_dir_sz);
+			strscpy(to_dir, to_subdir, to_dir_sz);
 			ret = 0;
 			break;
 		}
@@ -120,7 +120,7 @@ static int build_id_cache__add_kcore(const char *filename, bool force)
 	char from_dir[PATH_MAX], to_dir[PATH_MAX];
 	char *p;
 
-	strlcpy(from_dir, filename, sizeof(from_dir));
+	strscpy(from_dir, filename, sizeof(from_dir));
 
 	p = strrchr(from_dir, '/');
 	if (!p || strcmp(p + 1, "kcore"))
diff --git a/tools/perf/jvmti/libjvmti.c b/tools/perf/jvmti/libjvmti.c
index fcca275e5bf9..04d6825d23c8 100644
--- a/tools/perf/jvmti/libjvmti.c
+++ b/tools/perf/jvmti/libjvmti.c
@@ -158,7 +158,7 @@ copy_class_filename(const char * class_sign, const char * file_name, char * resu
 		result[i] = '\0';
 	} else {
 		/* fallback case */
-		strlcpy(result, file_name, max_length);
+		strscpy(result, file_name, max_length);
 	}
 }
 
diff --git a/tools/perf/ui/tui/helpline.c b/tools/perf/ui/tui/helpline.c
index 298d6af82fdd..ed433d4aad61 100644
--- a/tools/perf/ui/tui/helpline.c
+++ b/tools/perf/ui/tui/helpline.c
@@ -25,7 +25,7 @@ static void tui_helpline__push(const char *msg)
 	SLsmg_set_color(0);
 	SLsmg_write_nstring((char *)msg, SLtt_Screen_Cols);
 	SLsmg_refresh();
-	strlcpy(ui_helpline__current, msg, sz);
+	strscpy(ui_helpline__current, msg, sz);
 }
 
 static int tui_helpline__show(const char *format, va_list ap)
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 6c8575e182ed..04c0afcffd0b 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -1952,7 +1952,7 @@ static int symbol__disassemble(struct symbol *sym, struct annotate_args *args)
 		kce.len = sym->end - sym->start;
 		if (!kcore_extract__create(&kce)) {
 			delete_extract = true;
-			strlcpy(symfs_filename, kce.extract_filename,
+			strscpy(symfs_filename, kce.extract_filename,
 				sizeof(symfs_filename));
 		}
 	} else if (dso__needs_decompress(dso)) {
diff --git a/tools/perf/util/auxtrace.c b/tools/perf/util/auxtrace.c
index 42a85c86421d..731632b379fc 100644
--- a/tools/perf/util/auxtrace.c
+++ b/tools/perf/util/auxtrace.c
@@ -1179,7 +1179,7 @@ void auxtrace_synth_error(struct perf_record_auxtrace_error *auxtrace_error, int
 	auxtrace_error->fmt = 1;
 	auxtrace_error->ip = ip;
 	auxtrace_error->time = timestamp;
-	strlcpy(auxtrace_error->msg, msg, MAX_AUXTRACE_ERROR_MSG);
+	strscpy(auxtrace_error->msg, msg, MAX_AUXTRACE_ERROR_MSG);
 
 	size = (void *)auxtrace_error->msg - (void *)auxtrace_error +
 	       strlen(auxtrace_error->msg) + 1;
diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 55c11e854fe4..358f69282bdb 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -321,7 +321,7 @@ static int decompress_kmodule(struct dso *dso, const char *name,
 		unlink(tmpbuf);
 
 	if (pathname && (fd >= 0))
-		strlcpy(pathname, tmpbuf, len);
+		strscpy(pathname, tmpbuf, len);
 
 	return fd;
 }
diff --git a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
index 697513f35154..0cf2becbc413 100644
--- a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
@@ -408,7 +408,7 @@ int intel_pt__strerror(int code, char *buf, size_t buflen)
 {
 	if (code < 1 || code >= INTEL_PT_ERR_MAX)
 		code = INTEL_PT_ERR_UNK;
-	strlcpy(buf, intel_pt_err_msgs[code], buflen);
+	strscpy(buf, intel_pt_err_msgs[code], buflen);
 	return 0;
 }
 
diff --git a/tools/perf/util/llvm-utils.c b/tools/perf/util/llvm-utils.c
index dbdffb6673fe..8f165a157de4 100644
--- a/tools/perf/util/llvm-utils.c
+++ b/tools/perf/util/llvm-utils.c
@@ -78,7 +78,7 @@ search_program(const char *def, const char *name,
 	if (def && def[0] != '\0') {
 		if (def[0] == '/') {
 			if (access(def, F_OK) == 0) {
-				strlcpy(output, def, PATH_MAX);
+				strscpy(output, def, PATH_MAX);
 				return 0;
 			}
 		} else if (def[0] != '\0')
@@ -97,7 +97,7 @@ search_program(const char *def, const char *name,
 	while (path) {
 		scnprintf(buf, sizeof(buf), "%s/%s", path, name);
 		if (access(buf, F_OK) == 0) {
-			strlcpy(output, buf, PATH_MAX);
+			strscpy(output, buf, PATH_MAX);
 			ret = 0;
 			break;
 		}
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 15385ea00190..96c75fcc6987 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1060,7 +1060,7 @@ int machine__create_extra_kernel_map(struct machine *machine,
 
 	kmap = map__kmap(map);
 
-	strlcpy(kmap->name, xm->name, KMAP_NAME_LEN);
+	strscpy(kmap->name, xm->name, KMAP_NAME_LEN);
 
 	maps__insert(&machine->kmaps, map);
 
@@ -1149,7 +1149,7 @@ int machine__map_x86_64_entry_trampolines(struct machine *machine,
 			.pgoff = pgoff,
 		};
 
-		strlcpy(xm.name, ENTRY_TRAMPOLINE_NAME, KMAP_NAME_LEN);
+		strscpy(xm.name, ENTRY_TRAMPOLINE_NAME, KMAP_NAME_LEN);
 
 		if (machine__create_extra_kernel_map(machine, kernel, &xm) < 0)
 			return -1;
@@ -1600,7 +1600,7 @@ static int machine__process_extra_kernel_map(struct machine *machine,
 	if (kernel == NULL)
 		return -1;
 
-	strlcpy(xm.name, event->mmap.filename, KMAP_NAME_LEN);
+	strscpy(xm.name, event->mmap.filename, KMAP_NAME_LEN);
 
 	return machine__create_extra_kernel_map(machine, kernel, &xm);
 }
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 3b273580fb84..44582665d0b0 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -2827,7 +2827,7 @@ void print_symbol_events(const char *event_glob, unsigned type,
 		if (!name_only && strlen(syms->alias))
 			snprintf(name, MAX_NAME_LEN, "%s OR %s", syms->symbol, syms->alias);
 		else
-			strlcpy(name, syms->symbol, MAX_NAME_LEN);
+			strscpy(name, syms->symbol, MAX_NAME_LEN);
 
 		evt_list[evt_i] = strdup(name);
 		if (evt_list[evt_i] == NULL)
diff --git a/tools/perf/util/probe-file.c b/tools/perf/util/probe-file.c
index 064b63a6a3f3..052b3c1d1ff0 100644
--- a/tools/perf/util/probe-file.c
+++ b/tools/perf/util/probe-file.c
@@ -424,7 +424,7 @@ static int probe_cache__open(struct probe_cache *pcache, const char *target,
 
 	if (target && build_id_cache__cached(target)) {
 		/* This is a cached buildid */
-		strlcpy(sbuildid, target, SBUILD_ID_SIZE);
+		strscpy(sbuildid, target, SBUILD_ID_SIZE);
 		dir_name = build_id_cache__linkname(sbuildid, NULL, 0);
 		goto found;
 	}
diff --git a/tools/perf/util/svghelper.c b/tools/perf/util/svghelper.c
index 96f941e01681..b43a19cc4dfd 100644
--- a/tools/perf/util/svghelper.c
+++ b/tools/perf/util/svghelper.c
@@ -332,7 +332,7 @@ static char *cpu_model(void)
 	if (file) {
 		while (fgets(buf, 255, file)) {
 			if (strstr(buf, "model name")) {
-				strlcpy(cpu_m, &buf[13], 255);
+				strscpy(cpu_m, &buf[13], 255);
 				break;
 			}
 		}
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 0d14abdf3d72..3a758dc400a1 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -2102,7 +2102,7 @@ static int find_matching_kcore(struct map *map, char *dir, size_t dir_sz)
 		scnprintf(kallsyms_filename, sizeof(kallsyms_filename),
 			  "%s/%s/kallsyms", dir, nd->s);
 		if (!validate_kcore_addresses(kallsyms_filename, map)) {
-			strlcpy(dir, kallsyms_filename, dir_sz);
+			strscpy(dir, kallsyms_filename, dir_sz);
 			ret = 0;
 			break;
 		}
diff --git a/tools/perf/util/synthetic-events.c b/tools/perf/util/synthetic-events.c
index d9c624377da7..6398ae244cd1 100644
--- a/tools/perf/util/synthetic-events.c
+++ b/tools/perf/util/synthetic-events.c
@@ -1718,7 +1718,7 @@ int perf_event__synthesize_event_update_unit(struct perf_tool *tool, struct evse
 	if (ev == NULL)
 		return -ENOMEM;
 
-	strlcpy(ev->data, evsel->unit, size + 1);
+	strscpy(ev->data, evsel->unit, size + 1);
 	err = process(tool, (union perf_event *)ev, NULL, NULL);
 	free(ev);
 	return err;
@@ -1753,7 +1753,7 @@ int perf_event__synthesize_event_update_name(struct perf_tool *tool, struct evse
 	if (ev == NULL)
 		return -ENOMEM;
 
-	strlcpy(ev->data, evsel->name, len + 1);
+	strscpy(ev->data, evsel->name, len + 1);
 	err = process(tool, (union perf_event *)ev, NULL, NULL);
 	free(ev);
 	return err;
-- 
2.29.2

