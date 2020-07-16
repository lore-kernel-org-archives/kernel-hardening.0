Return-Path: <SRS0=g9Wo=A3=lists.openwall.com=kernel-hardening-return-19335-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B067C433E0
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 03:09:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BB68420775
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 03:09:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ntnEdubb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB68420775
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19335-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10119 invoked by uid 550); 16 Jul 2020 03:09:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10081 invoked from network); 16 Jul 2020 03:09:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/eo13gw5fJCvhJnxKm6L26qmA1xy2iBEtE20aAjPg9o=;
        b=ntnEdubbdqpGPgOV96gJLeIOeDJD9bl8sWEZchgJzsbJoRlAxafbTPHiU+bBiSM9Ay
         Bb6I6dJreCIWt+SNvx3uSnD715S/LsJbtTBKRxlploZohP5A0IMBAo41xfxzSg+BNCgv
         UyZA7zqZ2jt8SIod07xOd5QbCCRaueqNa4gOI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/eo13gw5fJCvhJnxKm6L26qmA1xy2iBEtE20aAjPg9o=;
        b=eacQLV2Mm9NFdgU/780Q8EYXb2EweZ4EMnhqIgnnvvXtzzzUoXXTGMqxDZfdMqyfTN
         SzBxH4RAIum8u34RkDHac+NL1SSm75j9CHi/4edkf00lOk4jfMO2ObnnTDLUFUh0v2sy
         Fme+BL03Hc74jS5qc+CVOScv75u80J8/FhOzhni5H3IZ8pJLZIYWA2bW2KSUHHHYdtwg
         2Q9vS564PHQdjSMXOm/UqRwzbhht9Pi56xDxbkgUoKaZyQtrv8koqqCCiBbeimcazEUv
         le9ApL+tdvu/r+FQcMWGVkxoXqqgbX8xNMFrrEovPf4FSzSVPRbGXLWUh9bBZvoNxcj+
         px2w==
X-Gm-Message-State: AOAM531h/O+pDcoScv+zEWWHAw7gFFy5Y59rl/VmUmrJ94FYAzShXoAK
	j9+mnqhm1NGkuez+VmlhY0yFTg==
X-Google-Smtp-Source: ABdhPJyJvjSFUmwOZKl8hOEZtdbgisML9TaMY9zA2DquJ5wPNkSNvu+LzxqBXFwknWNq3+GQp8EoZw==
X-Received: by 2002:a17:902:ee8b:: with SMTP id a11mr1923650pld.26.1594868932899;
        Wed, 15 Jul 2020 20:08:52 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kees Cook <keescook@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Allen Pais <allen.lkml@gmail.com>,
	Oscar Carter <oscar.carter@gmx.com>,
	Romain Perier <romain.perier@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Kevin Curtis <kevin.curtis@farsite.co.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	Jiri Slaby <jslaby@suse.com>,
	Felipe Balbi <balbi@kernel.org>,
	Jason Wessel <jason.wessel@windriver.com>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Mitchell Blank Jr <mitch@sfgoth.com>,
	Julian Wiedmann <jwi@linux.ibm.com>,
	Karsten Graul <kgraul@linux.ibm.com>,
	Ursula Braun <ubraun@linux.ibm.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Christian Gromm <christian.gromm@microchip.com>,
	Nishka Dasgupta <nishkadg.linux@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Stephen Boyd <swboyd@chromium.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Wambui Karuga <wambui.karugax@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Chris Packham <chris.packham@alliedtelesis.co.nz>,
	Kyungtae Kim <kt0755@gmail.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Peter Zijlstra <peterz@infradead.org>,
	Will Deacon <will@kernel.org>,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-s390@vger.kernel.org,
	devel@driverdev.osuosl.org,
	linux-usb@vger.kernel.org,
	kgdb-bugreport@lists.sourceforge.net,
	alsa-devel@alsa-project.org,
	kernel-hardening@lists.openwall.com
Subject: [PATCH 0/3] Modernize tasklet callback API
Date: Wed, 15 Jul 2020 20:08:44 -0700
Message-Id: <20200716030847.1564131-1-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This is the infrastructure changes to prepare the tasklet API for
conversion to passing the tasklet struct as the callback argument instead
of an arbitrary unsigned long. The first patch details why this is useful
(it's the same rationale as the timer_struct changes from a bit ago:
less abuse during memory corruption attacks, more in line with existing
ways of doing things in the kernel, save a little space in struct,
etc). Notably, the existing tasklet API use is much less messy, so there
is less to clean up.

It's not clear to me which tree this should go through... Greg since it
starts with a USB clean-up, -tip for timer or interrupt, or if I should
just carry it. I'm open to suggestions, but if I don't hear otherwise,
I'll just carry it.

My goal is to have this merged for v5.9-rc1 so that during the v5.10
development cycle the new API will be available. The entire tree of
changes is here[1] currently, but to split it up by maintainer the
infrastructure changes need to be landed first.

Review and Acks appreciated! :)

Thanks,

-Kees

[1] https://github.com/allenpais/tasklets/commits/tasklets_V2

Kees Cook (2):
  usb: gadget: udc: Avoid tasklet passing a global
  treewide: Replace DECLARE_TASKLET() with DECLARE_TASKLET_OLD()

Romain Perier (1):
  tasklet: Introduce new initialization API

 drivers/input/keyboard/omap-keypad.c   |  2 +-
 drivers/input/serio/hil_mlc.c          |  2 +-
 drivers/net/wan/farsync.c              |  4 +--
 drivers/s390/crypto/ap_bus.c           |  2 +-
 drivers/staging/most/dim2/dim2.c       |  2 +-
 drivers/staging/octeon/ethernet-tx.c   |  2 +-
 drivers/tty/vt/keyboard.c              |  2 +-
 drivers/usb/gadget/udc/snps_udc_core.c |  6 ++---
 drivers/usb/host/fhci-sched.c          |  2 +-
 include/linux/interrupt.h              | 37 ++++++++++++++++++++++----
 kernel/backtracetest.c                 |  2 +-
 kernel/debug/debug_core.c              |  2 +-
 kernel/irq/resend.c                    |  2 +-
 kernel/softirq.c                       | 18 ++++++++++++-
 net/atm/pppoatm.c                      |  2 +-
 net/iucv/iucv.c                        |  2 +-
 sound/drivers/pcsp/pcsp_lib.c          |  2 +-
 17 files changed, 66 insertions(+), 25 deletions(-)

-- 
2.25.1

