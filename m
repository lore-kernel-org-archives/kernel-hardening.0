Return-Path: <SRS0=oEnD=XY=lists.openwall.com=kernel-hardening-return-16964-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF716C4360C
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Sep 2019 16:34:03 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 07137217F5
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Sep 2019 16:34:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="umf4dL87"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 07137217F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16964-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26231 invoked by uid 550); 29 Sep 2019 16:31:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26100 invoked from network); 29 Sep 2019 16:31:20 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4kcGYetB0zzCR4CpRWbP6n2dN4jaZBjHDsplRlGtGMg=;
        b=umf4dL87luyg67HxBTligZlGFtnD27vfEW0kYHEOiZdYi69bhuOJv3xyEJkynCaw8M
         vBC2qzce3s9dai0Tgomk3qT+T4ndhKZRSHzeDBvWG/82o4K5R7S95or15sQ3EDBbj1YM
         7QGlNtfhffZwNZ24K5uKtMx3LfdDCcsZjmQLQEVvrdzyF/U5cCJ4KiOFnGZvSO+XLRFu
         XYXB4TarflFMc2PWYoC5p63zFX87zcZgomx4ZrimDGIWoXCvbdxUVExdjuNmWYjzgBnk
         4W6R+Fa6WTvLPZxeztR1MtNaEIHJQyyqIceKPvuZVS7YnTZGWbTyEjLw6tLQb0qXmOMf
         0gRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4kcGYetB0zzCR4CpRWbP6n2dN4jaZBjHDsplRlGtGMg=;
        b=sy03t3inRV9I5cMCpUEaRpM9WBZF1G9jqmpuroCYixteOZ8pFGNmnKth9H59r3lXjj
         2ity+FpRZzfChSQNpH5oKKPJAbMXEXUSl7zjSzKOXIMOc9o9xcJ+9kv2wZm7Jixp8/Ya
         QIHbNR1bVgLPWVvUMikkKbEUV8aSf1aPaQM1SOuWnZtEL54MErP+UMaOIjg5AOq5RgV8
         JPF6LzwhhnUdq5pAGNM4pgfLO0E0QR8wv7ZE3g+ADKECBVDXjrOGHRWF+1oXCqe7lamj
         X7II+s+ab4L7QtvqfelEm+NO9gHBWqdroVNwPgkQ0mR83JjyMk6A+OjFa5UJpJcDwIpy
         beeA==
X-Gm-Message-State: APjAAAVCHQJt71+9fHdDXXDNAzQynD7zsHEm32qmtbU4KrUDTW6+301o
	VF0FJweyLYWYBnCYsjqnElo=
X-Google-Smtp-Source: APXvYqzdp5+BKdEhEMHMmPDmoo77ZrfD7E2BF02jkVwsVdLk9UmU7nA5rcNbWoI9tdAjmVarGbL6ZQ==
X-Received: by 2002:a5d:6284:: with SMTP id k4mr10295299wru.205.1569774668518;
        Sun, 29 Sep 2019 09:31:08 -0700 (PDT)
From: Romain Perier <romain.perier@gmail.com>
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>,
	Romain Perier <romain.perier@gmail.com>
Subject: [PRE-REVIEW PATCH 14/16] tasklet: Remove the data argument from DECLARE_TASKLET() macros
Date: Sun, 29 Sep 2019 18:30:26 +0200
Message-Id: <20190929163028.9665-15-romain.perier@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929163028.9665-1-romain.perier@gmail.com>
References: <20190929163028.9665-1-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that the .data field is removed from the tasklet_struct data
structure and the DECLARE_TASKLET() macros body, we can change its API
and remove the data argument. This commit updates the API of these
macros by removing the data argument, it also update all the calls to
these macros in a single shot.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 drivers/net/wan/farsync.c              | 4 ++--
 drivers/staging/most/dim2/dim2.c       | 2 +-
 drivers/staging/octeon/ethernet-tx.c   | 2 +-
 drivers/tty/vt/keyboard.c              | 2 +-
 drivers/usb/gadget/udc/snps_udc_core.c | 2 +-
 include/linux/interrupt.h              | 4 ++--
 kernel/backtracetest.c                 | 2 +-
 kernel/debug/debug_core.c              | 2 +-
 kernel/irq/resend.c                    | 2 +-
 net/atm/pppoatm.c                      | 2 +-
 sound/drivers/pcsp/pcsp_lib.c          | 2 +-
 11 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index d2da087191ba..093c520c6972 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -569,8 +569,8 @@ static void do_bottom_half_rx(struct fst_card_info *card);
 static void fst_process_tx_work_q(struct tasklet_struct *work_q);
 static void fst_process_int_work_q(struct tasklet_struct *work_q);
 
-static DECLARE_TASKLET(fst_tx_task, fst_process_tx_work_q, 0);
-static DECLARE_TASKLET(fst_int_task, fst_process_int_work_q, 0);
+static DECLARE_TASKLET(fst_tx_task, fst_process_tx_work_q);
+static DECLARE_TASKLET(fst_int_task, fst_process_int_work_q);
 
 static struct fst_card_info *fst_card_array[FST_MAX_CARDS];
 static spinlock_t fst_work_q_lock;
diff --git a/drivers/staging/most/dim2/dim2.c b/drivers/staging/most/dim2/dim2.c
index 70040562af45..d4ab9abc6456 100644
--- a/drivers/staging/most/dim2/dim2.c
+++ b/drivers/staging/most/dim2/dim2.c
@@ -730,7 +730,7 @@ static int dim2_probe(struct platform_device *pdev)
 	int ret, i;
 	u8 hal_ret;
 	int irq;
-	DECLARE_TASKLET(dim2_tasklet, dim2_tasklet_fn, 0);
+	DECLARE_TASKLET(dim2_tasklet, dim2_tasklet_fn);
 
 	enum { MLB_INT_IDX, AHB0_INT_IDX };
 
diff --git a/drivers/staging/octeon/ethernet-tx.c b/drivers/staging/octeon/ethernet-tx.c
index acb32a7c8b1d..f954f48e90ec 100644
--- a/drivers/staging/octeon/ethernet-tx.c
+++ b/drivers/staging/octeon/ethernet-tx.c
@@ -41,7 +41,7 @@
 #endif
 
 static void cvm_oct_tx_do_cleanup(struct tasklet_struct *unused);
-static DECLARE_TASKLET(cvm_oct_tx_cleanup_tasklet, cvm_oct_tx_do_cleanup, 0);
+static DECLARE_TASKLET(cvm_oct_tx_cleanup_tasklet, cvm_oct_tx_do_cleanup);
 
 /* Maximum number of SKBs to try to free per xmit packet. */
 #define MAX_SKB_TO_FREE (MAX_OUT_QUEUE_DEPTH * 2)
diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
index 06e54abcfac6..7d8f6a3688b1 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -1230,7 +1230,7 @@ static void kbd_bh(struct tasklet_struct *unused)
 	}
 }
 
-DECLARE_TASKLET_DISABLED(keyboard_tasklet, kbd_bh, 0);
+DECLARE_TASKLET_DISABLED(keyboard_tasklet, kbd_bh);
 
 #if defined(CONFIG_X86) || defined(CONFIG_IA64) || defined(CONFIG_ALPHA) ||\
     defined(CONFIG_MIPS) || defined(CONFIG_PPC) || defined(CONFIG_SPARC) ||\
diff --git a/drivers/usb/gadget/udc/snps_udc_core.c b/drivers/usb/gadget/udc/snps_udc_core.c
index b2d5ad004b0f..43e9b5a549b5 100644
--- a/drivers/usb/gadget/udc/snps_udc_core.c
+++ b/drivers/usb/gadget/udc/snps_udc_core.c
@@ -3151,7 +3151,7 @@ int udc_probe(struct udc *dev)
 	char		tmp[128];
 	u32		reg;
 	int		retval;
-	DECLARE_TASKLET(disconnect_tasklet, udc_tasklet_disconnect, 0);
+	DECLARE_TASKLET(disconnect_tasklet, udc_tasklet_disconnect);
 
 	/* device struct setup */
 	dev->gadget.ops = &udc_ops;
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index a01dea0a90bb..b5ac24b7fea2 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -600,10 +600,10 @@ struct tasklet_struct
 #define TASKLET_DATA_TYPE		unsigned long
 #define TASKLET_FUNC_TYPE		void (*)(TASKLET_DATA_TYPE)
 
-#define DECLARE_TASKLET(name, func, data) \
+#define DECLARE_TASKLET(name, func) \
 struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(0), (TASKLET_FUNC_TYPE)func }
 
-#define DECLARE_TASKLET_DISABLED(name, func, data) \
+#define DECLARE_TASKLET_DISABLED(name, func) \
 struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(1), (TASKLET_FUNC_TYPE)func }
 
 
diff --git a/kernel/backtracetest.c b/kernel/backtracetest.c
index b5b9e16f0083..02c6bc523697 100644
--- a/kernel/backtracetest.c
+++ b/kernel/backtracetest.c
@@ -29,7 +29,7 @@ static void backtrace_test_irq_callback(struct tasklet_struct *unused)
 	complete(&backtrace_work);
 }
 
-static DECLARE_TASKLET(backtrace_tasklet, &backtrace_test_irq_callback, 0);
+static DECLARE_TASKLET(backtrace_tasklet, &backtrace_test_irq_callback);
 
 static void backtrace_test_irq(void)
 {
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index ceac3a21cf41..2358a924f157 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -1004,7 +1004,7 @@ static void kgdb_tasklet_bpt(struct tasklet_struct *unused)
 	atomic_set(&kgdb_break_tasklet_var, 0);
 }
 
-static DECLARE_TASKLET(kgdb_tasklet_breakpoint, kgdb_tasklet_bpt, 0);
+static DECLARE_TASKLET(kgdb_tasklet_breakpoint, kgdb_tasklet_bpt);
 
 void kgdb_schedule_breakpoint(void)
 {
diff --git a/kernel/irq/resend.c b/kernel/irq/resend.c
index 7edb88afebb5..b82588c966d8 100644
--- a/kernel/irq/resend.c
+++ b/kernel/irq/resend.c
@@ -45,7 +45,7 @@ static void resend_irqs(struct tasklet_struct *unused)
 }
 
 /* Tasklet to handle resend: */
-static DECLARE_TASKLET(resend_tasklet, resend_irqs, 0);
+static DECLARE_TASKLET(resend_tasklet, resend_irqs);
 
 #endif
 
diff --git a/net/atm/pppoatm.c b/net/atm/pppoatm.c
index 1d9274194dc0..5c0452feeb48 100644
--- a/net/atm/pppoatm.c
+++ b/net/atm/pppoatm.c
@@ -394,7 +394,7 @@ static int pppoatm_assign_vcc(struct atm_vcc *atmvcc, void __user *arg)
 	 * Each PPPoATM instance has its own tasklet - this is just a
 	 * prototypical one used to initialize them
 	 */
-	static const DECLARE_TASKLET(tasklet_proto, pppoatm_wakeup_sender, 0);
+	static const DECLARE_TASKLET(tasklet_proto, pppoatm_wakeup_sender);
 	if (copy_from_user(&be, arg, sizeof be))
 		return -EFAULT;
 	if (be.encaps != PPPOATM_ENCAPS_AUTODETECT &&
diff --git a/sound/drivers/pcsp/pcsp_lib.c b/sound/drivers/pcsp/pcsp_lib.c
index fbeeecaac8d4..9e7a51fa6f07 100644
--- a/sound/drivers/pcsp/pcsp_lib.c
+++ b/sound/drivers/pcsp/pcsp_lib.c
@@ -36,7 +36,7 @@ static void pcsp_call_pcm_elapsed(struct tasklet_struct *unused)
 	}
 }
 
-static DECLARE_TASKLET(pcsp_pcm_tasklet, pcsp_call_pcm_elapsed, 0);
+static DECLARE_TASKLET(pcsp_pcm_tasklet, pcsp_call_pcm_elapsed);
 
 /* write the port and returns the next expire time in ns;
  * called at the trigger-start and in hrtimer callback
-- 
2.23.0

