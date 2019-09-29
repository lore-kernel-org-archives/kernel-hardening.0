Return-Path: <SRS0=XS2y=XY=lists.openwall.com=kernel-hardening-return-16963-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09C89C32793
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Sep 2019 16:33:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id EB806217F5
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Sep 2019 16:33:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r27cOgh5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EB806217F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16963-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26105 invoked by uid 550); 29 Sep 2019 16:31:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26013 invoked from network); 29 Sep 2019 16:31:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Pju0Yb+WunGJObPsS1Cgt+n9JUrhGCKjdzCtdTQcTg4=;
        b=r27cOgh5BuPKfb+6RcytTTqJMqBSpcvcZ1rjgRmX7bze8RK68ggl8bbXO131BV+D79
         JA6/EdsV38A7MOt6cl9oi5vuMgOHT7viiaWCx/kWL2wCifSOQZ76ti5ixnQVMk26C4Bk
         Ext7LufYim79Wt3fLIziM87+BESwoY53CiQuZy/bNywJI4Wtzr3NVQzOiqc+vKSaqSTR
         H0wJf+sOpPO7oVs6b4Y4L3V+KsvB629AXd+LQfJQQ5+VGHn2UXhcboXTcPKguFnwWmw4
         z9xEt85tqZo69KkGynjbW2qvojI0mrsZiAnZoALqt4UoQqCBJku1YohEThpQFF0kcJR/
         Z7Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pju0Yb+WunGJObPsS1Cgt+n9JUrhGCKjdzCtdTQcTg4=;
        b=kPUhBf0Hjzbp2AAR5jJoVHcz55DFQKSeLrr/GhmbUiJaXC93nWryL/ucS45fSYl7BU
         olT2t5twGur5LOsSNdXSX++zMNpy1Yq6jAuCGxlkTXgJZsWxWZSEP3LXu1JG2AREEhPQ
         cqUzXPvofHoyJ9Z9BXv7b2S7webRt+4TnE1B7ZbdyL44EfWHSQvzGU680CUz2Ae9om+1
         OcF4bU8li75rPhMRaVtBTBPgwCb08IfGNCJk7xd9lhOTXmSscEFjdm4OvY8XIp2yBKb4
         kFEZc/1igAfGW0jN4NDN442T8HvkX2qT5M3kPAMmG3XSfCJJikKiIc+3+RqIQmb0WCu4
         uavw==
X-Gm-Message-State: APjAAAWwu6c2di/U+starNhZgETVlUifF2mxc6s+Q52CTraso2hlhW1C
	YXEe6lk2mtd4jTsXEJObOUM=
X-Google-Smtp-Source: APXvYqwozXcSUOG4edYkrId0YRwAcgi0ukczQArQYs5qX5h2qdr/oimHdLSyie/rv8mjBEH2xdxwlA==
X-Received: by 2002:a1c:c742:: with SMTP id x63mr14034710wmf.126.1569774666901;
        Sun, 29 Sep 2019 09:31:06 -0700 (PDT)
From: Romain Perier <romain.perier@gmail.com>
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>,
	Romain Perier <romain.perier@gmail.com>,
	Romain Perier <romain.perier@viveris.fr>
Subject: [PRE-REVIEW PATCH 13/16] tasklet: Pass tasklet_struct pointer to callbacks unconditionally
Date: Sun, 29 Sep 2019 18:30:25 +0200
Message-Id: <20190929163028.9665-14-romain.perier@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929163028.9665-1-romain.perier@gmail.com>
References: <20190929163028.9665-1-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Romain Perier <romain.perier@viveris.fr>

Now that all tasklet callbacks are already taking their struct
tasklet_struct pointer as the callback argument, just do this
unconditionally and remove the .data field. It converts all
runtime code, init functions and the DECLARE_TASKLET() macros
to get rid of the .data argument. Moreover, all remaining use
or assignment of the .data field are removed in a single shot.

Signed-off-by: Romain Perier <romain.perier@viveris.fr>
---
 drivers/gpu/drm/i915/gt/intel_engine_cs.c        | 2 +-
 drivers/gpu/drm/i915/gt/intel_lrc.c              | 2 +-
 drivers/net/usb/usbnet.c                         | 1 -
 drivers/net/wireless/atmel/at76c50x-usb.c        | 1 -
 drivers/net/wireless/intersil/hostap/hostap_hw.c | 2 +-
 drivers/net/wireless/realtek/rtlwifi/usb.c       | 1 -
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c     | 1 -
 drivers/staging/most/dim2/dim2.c                 | 1 -
 drivers/usb/gadget/udc/snps_udc_core.c           | 1 -
 include/linux/interrupt.h                        | 9 ++++-----
 kernel/softirq.c                                 | 5 ++---
 net/atm/pppoatm.c                                | 1 -
 12 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_engine_cs.c b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
index 82630db0394b..357d14ae32d0 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_cs.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
@@ -1057,7 +1057,7 @@ bool intel_engine_is_idle(struct intel_engine_cs *engine)
 		if (tasklet_trylock(t)) {
 			/* Must wait for any GPU reset in progress. */
 			if (__tasklet_is_enabled(t))
-				t->func(t->data);
+				t->func(t);
 			tasklet_unlock(t);
 		}
 		local_bh_enable();
diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index d630dbc953ad..99f39047e49f 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -2616,7 +2616,7 @@ static void execlists_reset_finish(struct intel_engine_cs *engine)
 	 */
 	GEM_BUG_ON(!reset_in_progress(execlists));
 	if (!RB_EMPTY_ROOT(&execlists->queue.rb_root))
-		execlists->tasklet.func(execlists->tasklet.data);
+		execlists->tasklet.func(&execlists->tasklet);
 
 	if (__tasklet_enable(&execlists->tasklet))
 		/* And kick in case we missed a new request submission. */
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 1c4817c05d3c..14cedee27f2f 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1693,7 +1693,6 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 	skb_queue_head_init (&dev->done);
 	skb_queue_head_init(&dev->rxq_pause);
 	dev->bh.func = (TASKLET_FUNC_TYPE)usbnet_bh;
-	dev->bh.data = (TASKLET_DATA_TYPE)&dev->delay;
 	INIT_WORK (&dev->kevent, usbnet_deferred_kevent);
 	init_usb_anchor(&dev->deferred);
 	timer_setup(&dev->delay, usbnet_bh, 0);
diff --git a/drivers/net/wireless/atmel/at76c50x-usb.c b/drivers/net/wireless/atmel/at76c50x-usb.c
index 3a66538a0853..fd796a32c71d 100644
--- a/drivers/net/wireless/atmel/at76c50x-usb.c
+++ b/drivers/net/wireless/atmel/at76c50x-usb.c
@@ -1199,7 +1199,6 @@ static void at76_rx_callback(struct urb *urb)
 {
 	struct at76_priv *priv = urb->context;
 
-	priv->rx_tasklet.data = (unsigned long)urb;
 	tasklet_schedule(&priv->rx_tasklet);
 }
 
diff --git a/drivers/net/wireless/intersil/hostap/hostap_hw.c b/drivers/net/wireless/intersil/hostap/hostap_hw.c
index 187095e13294..ae656563a82d 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_hw.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_hw.c
@@ -3183,7 +3183,7 @@ prism2_init_local_data(struct prism2_helper_functions *funcs, int card_idx,
 	/* Initialize tasklets for handling hardware IRQ related operations
 	 * outside hw IRQ handler */
 #define HOSTAP_TASKLET_INIT(q, f, d) \
-do { memset((q), 0, sizeof(*(q))); (q)->func = (TASKLET_FUNC_TYPE)(f); (q)->data = (TASKLET_DATA_TYPE)(q); } \
+do { memset((q), 0, sizeof(*(q))); (q)->func = (TASKLET_FUNC_TYPE)(f); } \
 while (0)
 	HOSTAP_TASKLET_INIT(&local->bap_tasklet, hostap_bap_tasklet,
 			    (unsigned long) local);
diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index aae5c5aa1769..7e9bdbd2a6f4 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -311,7 +311,6 @@ static int _rtl_usb_init_rx(struct ieee80211_hw *hw)
 
 	skb_queue_head_init(&rtlusb->rx_queue);
 	rtlusb->rx_work_tasklet.func = (TASKLET_FUNC_TYPE)_rtl_rx_work;
-	rtlusb->rx_work_tasklet.data = (TASKLET_DATA_TYPE)&rtlusb->rx_work_tasklet;
 
 	return 0;
 }
diff --git a/drivers/net/wireless/zydas/zd1211rw/zd_usb.c b/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
index 0ebbd727a452..4275549f4d98 100644
--- a/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
@@ -1181,7 +1181,6 @@ static inline void init_usb_rx(struct zd_usb *usb)
 	ZD_ASSERT(rx->fragment_length == 0);
 	INIT_DELAYED_WORK(&rx->idle_work, zd_rx_idle_timer_handler);
 	rx->reset_timer_tasklet.func = (TASKLET_FUNC_TYPE)zd_usb_reset_rx_idle_timer_tasklet;
-	rx->reset_timer_tasklet.data = (TASKLET_DATA_TYPE)&rx->reset_timer_tasklet;
 }
 
 static inline void init_usb_tx(struct zd_usb *usb)
diff --git a/drivers/staging/most/dim2/dim2.c b/drivers/staging/most/dim2/dim2.c
index 98f0acca5c06..70040562af45 100644
--- a/drivers/staging/most/dim2/dim2.c
+++ b/drivers/staging/most/dim2/dim2.c
@@ -740,7 +740,6 @@ static int dim2_probe(struct platform_device *pdev)
 
 	dev->atx_idx = -1;
 	dev->dim2_tasklet = dim2_tasklet;
-	dev->dim2_tasklet.data = (TASKLET_DATA_TYPE)&dev->dim2_tasklet;
 
 	platform_set_drvdata(pdev, dev);
 
diff --git a/drivers/usb/gadget/udc/snps_udc_core.c b/drivers/usb/gadget/udc/snps_udc_core.c
index c9f29b7ad986..b2d5ad004b0f 100644
--- a/drivers/usb/gadget/udc/snps_udc_core.c
+++ b/drivers/usb/gadget/udc/snps_udc_core.c
@@ -3187,7 +3187,6 @@ int udc_probe(struct udc *dev)
 	udc = dev;
 
 	dev->disconnect_tasklet = disconnect_tasklet;
-	dev->disconnect_tasklet.data = (TASKLET_DATA_TYPE)&dev->disconnect_tasklet;
 
 	retval = usb_add_gadget_udc_release(udc->dev, &dev->gadget,
 					    gadget_release);
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 949bbaeaff0e..a01dea0a90bb 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -595,17 +595,16 @@ struct tasklet_struct
 	unsigned long state;
 	atomic_t count;
 	void (*func)(unsigned long);
-	unsigned long data;
 };
 
 #define TASKLET_DATA_TYPE		unsigned long
 #define TASKLET_FUNC_TYPE		void (*)(TASKLET_DATA_TYPE)
 
 #define DECLARE_TASKLET(name, func, data) \
-struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(0), (TASKLET_FUNC_TYPE)func, (TASKLET_DATA_TYPE)&name }
+struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(0), (TASKLET_FUNC_TYPE)func }
 
 #define DECLARE_TASKLET_DISABLED(name, func, data) \
-struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(1), (TASKLET_FUNC_TYPE)func, (TASKLET_DATA_TYPE)&name }
+struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(1), (TASKLET_FUNC_TYPE)func }
 
 
 enum
@@ -674,7 +673,7 @@ static inline void tasklet_enable(struct tasklet_struct *t)
 extern void tasklet_kill(struct tasklet_struct *t);
 extern void tasklet_kill_immediate(struct tasklet_struct *t, unsigned int cpu);
 extern void tasklet_init(struct tasklet_struct *t,
-			 void (*func)(unsigned long), unsigned long data);
+			 void (*func)(unsigned long));
 
 #define from_tasklet(var, callback_tasklet, tasklet_fieldname) \
 	container_of(callback_tasklet, typeof(*var), tasklet_fieldname)
@@ -682,7 +681,7 @@ extern void tasklet_init(struct tasklet_struct *t,
 static inline void tasklet_setup(struct tasklet_struct *t,
 				 void (*callback)(struct tasklet_struct *))
 {
-	tasklet_init(t, (TASKLET_FUNC_TYPE)callback, (TASKLET_DATA_TYPE)t);
+	tasklet_init(t, (TASKLET_FUNC_TYPE)callback);
 }
 
 /*
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 0427a86743a4..feb9ac8e6f0b 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -520,7 +520,7 @@ static void tasklet_action_common(struct softirq_action *a,
 				if (!test_and_clear_bit(TASKLET_STATE_SCHED,
 							&t->state))
 					BUG();
-				t->func(t->data);
+				t->func((TASKLET_DATA_TYPE)t);
 				tasklet_unlock(t);
 				continue;
 			}
@@ -547,13 +547,12 @@ static __latent_entropy void tasklet_hi_action(struct softirq_action *a)
 }
 
 void tasklet_init(struct tasklet_struct *t,
-		  void (*func)(unsigned long), unsigned long data)
+		  void (*func)(unsigned long))
 {
 	t->next = NULL;
 	t->state = 0;
 	atomic_set(&t->count, 0);
 	t->func = func;
-	t->data = data;
 }
 EXPORT_SYMBOL(tasklet_init);
 
diff --git a/net/atm/pppoatm.c b/net/atm/pppoatm.c
index fe45fba20be2..1d9274194dc0 100644
--- a/net/atm/pppoatm.c
+++ b/net/atm/pppoatm.c
@@ -417,7 +417,6 @@ static int pppoatm_assign_vcc(struct atm_vcc *atmvcc, void __user *arg)
 	pvcc->chan.mtu = atmvcc->qos.txtp.max_sdu - PPP_HDRLEN -
 	    (be.encaps == e_vc ? 0 : LLC_LEN);
 	pvcc->wakeup_tasklet = tasklet_proto;
-	pvcc->wakeup_tasklet.data = (TASKLET_DATA_TYPE)&pvcc->wakeup_tasklet;
 	err = ppp_register_channel(&pvcc->chan);
 	if (err != 0) {
 		kfree(pvcc);
-- 
2.23.0

