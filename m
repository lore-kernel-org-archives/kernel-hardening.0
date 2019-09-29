Return-Path: <SRS0=g7+X=XY=lists.openwall.com=kernel-hardening-return-16961-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44ED7C4360C
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Sep 2019 16:33:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C3874217F5
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Sep 2019 16:33:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XvYMB7xv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C3874217F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16961-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25848 invoked by uid 550); 29 Sep 2019 16:31:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25792 invoked from network); 29 Sep 2019 16:31:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TUwvrZDGVJfl7zwdrE45SzC3+NkCFPnrCcjcevc9mWs=;
        b=XvYMB7xv2MTJQtI+tuB0oVeYiIryiqPSMwIwFgxRoSuLd+r7FpAPzNG13byXDgU+0G
         k15jbA8pcsgL+M9/TxmJnGvdzWi5dp1IBnYXEzK3LcHymFv7eCWeA0vJxrFe6tF1X2j9
         ulPN3dK0I+YWULqb24T3oAf/Amo7WryoxE0o51DzO49wGErpAE4aQ5n2uo13DKWrVwES
         B5HnFG+EuML9En019VZJTg6XeR2yFY6arAlH50XsilS3iqgRmF3rNbBzyUx/qWSlHC/P
         LQmniyaW3+3/dFKMQa0IR297vG3z/RWCPu/azcnuwxLNibaCBPRR4ndbtQ1p+swbuUNJ
         UQrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TUwvrZDGVJfl7zwdrE45SzC3+NkCFPnrCcjcevc9mWs=;
        b=M7E6CDcOukTT9SAfOV834Z+2K8Kd0xKa8vHAdiKpYcMcWta75bRJidEdDyXkV4Rrsv
         ZLDQaUz+uTUKGqJkmUx4qI8pbPT19NfQ0qZsrSvsDBlkD/oauyPazzAnrUUpw8xzwnP8
         UAbdAu5wzJPxIGloIzzO7QWhSK9iKYw7K1HTX8R4RZS0yCz/ZWcwN7TngSn5oNjNjPDm
         +1T+v0PhTIe67YMAF7g/yvuTnE8CDFaZS2g3F/ipYqKaeUpQcAMRCbUCGakTm4jvBeA2
         tCWhLP7ACmSDOjcQu2jgXDC66LlnkMod0zcW6oNAP8M65gjRzjcE90zG8Zq7vNyBXxKQ
         UsgQ==
X-Gm-Message-State: APjAAAVTac/H48wTODE4wcVkA7ted/NlQN3RptjqV1n/HQdFJ4dSA6IS
	BDAQt2FwDOeOVIHQNfThfvs=
X-Google-Smtp-Source: APXvYqx1jw18pbrIryqxEcY5F0UhQ6KdcZqWamcA52BOtj+JwDFPLhb9/G+FD6/34r0Vk2NFCEYFbw==
X-Received: by 2002:a7b:ce0a:: with SMTP id m10mr14293429wmc.121.1569774664487;
        Sun, 29 Sep 2019 09:31:04 -0700 (PDT)
From: Romain Perier <romain.perier@gmail.com>
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>,
	Romain Perier <romain.perier@gmail.com>
Subject: [PRE-REVIEW PATCH 12/16] tasklet: Pass tasklet_struct pointer as .data in DECLARE_TASKLET
Date: Sun, 29 Sep 2019 18:30:24 +0200
Message-Id: <20190929163028.9665-13-romain.perier@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929163028.9665-1-romain.perier@gmail.com>
References: <20190929163028.9665-1-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that all tasklet initializations have been replaced, this updates
the core of the DECLARE_TASKLET macros by passing the pointer of the
tasklet structure as .data, so current static tasklets will continue to
work by deadling with the tasklet_struct pointer in their handler,
without have to change the API of the macro. It also updates all
callbacks of all tasklets statically allocated via DECLARE_TASKLET() for
extracting the the parent data structure of the tasklet by using
from_tasklet().

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 arch/mips/lasat/picvue_proc.c          |  2 +-
 drivers/input/keyboard/omap-keypad.c   | 14 ++++++++------
 drivers/input/serio/hil_mlc.c          |  4 ++--
 drivers/net/wan/farsync.c              |  8 ++++----
 drivers/s390/crypto/ap_bus.c           |  8 ++++----
 drivers/staging/most/dim2/dim2.c       | 20 +++++++++++---------
 drivers/staging/octeon/ethernet-tx.c   |  4 ++--
 drivers/tty/vt/keyboard.c              |  2 +-
 drivers/usb/gadget/udc/amd5536udc.h    |  1 +
 drivers/usb/gadget/udc/snps_udc_core.c | 17 ++++++++---------
 drivers/usb/host/fhci-hcd.c            |  5 +++--
 drivers/usb/host/fhci-sched.c          |  8 ++++----
 drivers/usb/host/fhci.h                |  2 +-
 include/linux/interrupt.h              | 10 +++++-----
 kernel/backtracetest.c                 |  2 +-
 kernel/debug/debug_core.c              |  2 +-
 kernel/irq/resend.c                    |  2 +-
 net/atm/pppoatm.c                      |  7 ++++---
 net/iucv/iucv.c                        |  4 ++--
 sound/drivers/pcsp/pcsp_lib.c          |  2 +-
 20 files changed, 65 insertions(+), 59 deletions(-)

diff --git a/arch/mips/lasat/picvue_proc.c b/arch/mips/lasat/picvue_proc.c
index 8126f15b8e09..ebb5b4c3079b 100644
--- a/arch/mips/lasat/picvue_proc.c
+++ b/arch/mips/lasat/picvue_proc.c
@@ -30,7 +30,7 @@ static int scroll_dir, scroll_interval;
 
 static struct timer_list timer;
 
-static void pvc_display(unsigned long data)
+static void pvc_display(struct tasklet_struct *unused)
 {
 	int i;
 
diff --git a/drivers/input/keyboard/omap-keypad.c b/drivers/input/keyboard/omap-keypad.c
index 5fe7a5633e33..f202ea05f647 100644
--- a/drivers/input/keyboard/omap-keypad.c
+++ b/drivers/input/keyboard/omap-keypad.c
@@ -27,7 +27,7 @@
 
 #undef NEW_BOARD_LEARNING_MODE
 
-static void omap_kp_tasklet(unsigned long);
+static void omap_kp_tasklet(struct tasklet_struct *);
 static void omap_kp_timer(struct timer_list *);
 
 static unsigned char keypad_state[8];
@@ -44,9 +44,9 @@ struct omap_kp {
 	unsigned long delay;
 	unsigned int debounce;
 	unsigned short keymap[];
+	struct tasklet_struct kp_tasklet;
 };
 
-static DECLARE_TASKLET_DISABLED(kp_tasklet, omap_kp_tasklet, 0);
 
 static unsigned int *row_gpios;
 static unsigned int *col_gpios;
@@ -88,9 +88,10 @@ static void omap_kp_scan_keypad(struct omap_kp *omap_kp, unsigned char *state)
 	udelay(2);
 }
 
-static void omap_kp_tasklet(unsigned long data)
+static void omap_kp_tasklet(struct tasklet_struct *t)
 {
-	struct omap_kp *omap_kp_data = (struct omap_kp *) data;
+	struct omap_kp *omap_kp_data = from_tasklet(omap_kp_data, t,
+						    kp_tasklet);
 	unsigned short *keycodes = omap_kp_data->input->keycode;
 	unsigned int row_shift = get_count_order(omap_kp_data->cols);
 	unsigned char new_state[8], changed, key_down = 0;
@@ -181,6 +182,7 @@ static int omap_kp_probe(struct platform_device *pdev)
 	struct omap_kp_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	int i, col_idx, row_idx, ret;
 	unsigned int row_shift, keycodemax;
+	DECLARE_TASKLET_DISABLED(kp_tasklet, omap_kp_tasklet, 0);
 
 	if (!pdata->rows || !pdata->cols || !pdata->keymap_data) {
 		printk(KERN_ERR "No rows, cols or keymap_data from pdata\n");
@@ -222,8 +224,8 @@ static int omap_kp_probe(struct platform_device *pdev)
 
 	timer_setup(&omap_kp->timer, omap_kp_timer, 0);
 
-	/* get the irq and init timer*/
-	kp_tasklet.data = (unsigned long) omap_kp;
+	omap_kp->kp_tasklet = kp_tasklet;
+	omap_kp->kp_tasklet.data = (TASKLET_DATA_TYPE)&omap_kp->kp_tasklet;
 	tasklet_enable(&kp_tasklet);
 
 	ret = device_create_file(&pdev->dev, &dev_attr_enable);
diff --git a/drivers/input/serio/hil_mlc.c b/drivers/input/serio/hil_mlc.c
index e1423f7648d6..d7a4ea4f0695 100644
--- a/drivers/input/serio/hil_mlc.c
+++ b/drivers/input/serio/hil_mlc.c
@@ -76,7 +76,7 @@ static DEFINE_RWLOCK(hil_mlcs_lock);
 static struct timer_list	hil_mlcs_kicker;
 static int			hil_mlcs_probe;
 
-static void hil_mlcs_process(unsigned long unused);
+static void hil_mlcs_process(struct tasklet_struct *unused);
 static DECLARE_TASKLET_DISABLED(hil_mlcs_tasklet, hil_mlcs_process, 0);
 
 
@@ -757,7 +757,7 @@ static int hilse_donode(hil_mlc *mlc)
 }
 
 /******************** tasklet context functions **************************/
-static void hil_mlcs_process(unsigned long unused)
+static void hil_mlcs_process(struct tasklet_struct *unused)
 {
 	struct list_head *tmp;
 
diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index 1901ec7948d8..d2da087191ba 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -566,8 +566,8 @@ MODULE_DEVICE_TABLE(pci, fst_pci_dev_id);
 
 static void do_bottom_half_tx(struct fst_card_info *card);
 static void do_bottom_half_rx(struct fst_card_info *card);
-static void fst_process_tx_work_q(unsigned long work_q);
-static void fst_process_int_work_q(unsigned long work_q);
+static void fst_process_tx_work_q(struct tasklet_struct *work_q);
+static void fst_process_int_work_q(struct tasklet_struct *work_q);
 
 static DECLARE_TASKLET(fst_tx_task, fst_process_tx_work_q, 0);
 static DECLARE_TASKLET(fst_int_task, fst_process_int_work_q, 0);
@@ -600,7 +600,7 @@ fst_q_work_item(u64 * queue, int card_index)
 }
 
 static void
-fst_process_tx_work_q(unsigned long /*void **/work_q)
+fst_process_tx_work_q(struct tasklet_struct * /*void **/work_q)
 {
 	unsigned long flags;
 	u64 work_txq;
@@ -630,7 +630,7 @@ fst_process_tx_work_q(unsigned long /*void **/work_q)
 }
 
 static void
-fst_process_int_work_q(unsigned long /*void **/work_q)
+fst_process_int_work_q(struct tasklet_struct * /*void **/work_q)
 {
 	unsigned long flags;
 	u64 work_intq;
diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index a76b8a8bcbbb..a013effd2536 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -90,7 +90,7 @@ static DECLARE_WORK(ap_scan_work, ap_scan_bus);
 /*
  * Tasklet & timer for AP request polling and interrupts
  */
-static void ap_tasklet_fn(unsigned long);
+static void ap_tasklet_fn(struct tasklet_struct *t);
 static DECLARE_TASKLET(ap_tasklet, ap_tasklet_fn, 0);
 static DECLARE_WAIT_QUEUE_HEAD(ap_poll_wait);
 static struct task_struct *ap_poll_kthread;
@@ -419,11 +419,11 @@ static void ap_interrupt_handler(struct airq_struct *airq, bool floating)
 
 /**
  * ap_tasklet_fn(): Tasklet to poll all AP devices.
- * @dummy: Unused variable
+ * @unused: Unused variable
  *
  * Poll all AP devices on the bus.
  */
-static void ap_tasklet_fn(unsigned long dummy)
+static void ap_tasklet_fn(struct tasklet_struct *unused)
 {
 	struct ap_card *ac;
 	struct ap_queue *aq;
@@ -497,7 +497,7 @@ static int ap_poll_thread(void *data)
 			try_to_freeze();
 			continue;
 		}
-		ap_tasklet_fn(0);
+		ap_tasklet_fn(&ap_tasklet);
 	}
 
 	return 0;
diff --git a/drivers/staging/most/dim2/dim2.c b/drivers/staging/most/dim2/dim2.c
index 64c979155a49..98f0acca5c06 100644
--- a/drivers/staging/most/dim2/dim2.c
+++ b/drivers/staging/most/dim2/dim2.c
@@ -46,8 +46,7 @@ MODULE_PARM_DESC(fcnt, "Num of frames per sub-buffer for sync channels as a powe
 
 static DEFINE_SPINLOCK(dim_lock);
 
-static void dim2_tasklet_fn(unsigned long data);
-static DECLARE_TASKLET(dim2_tasklet, dim2_tasklet_fn, 0);
+static void dim2_tasklet_fn(struct tasklet_struct *t);
 
 /**
  * struct hdm_channel - private structure to keep channel specific data
@@ -102,6 +101,7 @@ struct dim2_hdm {
 	void (*on_netinfo)(struct most_interface *most_iface,
 			   unsigned char link_state, unsigned char *addrs);
 	void (*disable_platform)(struct platform_device *);
+	struct tasklet_struct dim2_tasklet;
 };
 
 struct dim2_platform_data {
@@ -351,13 +351,13 @@ static irqreturn_t dim2_mlb_isr(int irq, void *_dev)
 
 /**
  * dim2_tasklet_fn - tasklet function
- * @data: private data
+ * @t: instance of the running tasklet
  *
  * Service each initialized channel, if needed
  */
-static void dim2_tasklet_fn(unsigned long data)
+static void dim2_tasklet_fn(struct tasklet_struct *t)
 {
-	struct dim2_hdm *dev = (struct dim2_hdm *)data;
+	struct dim2_hdm *dev = from_tasklet(dev, t, dim2_tasklet);
 	unsigned long flags;
 	int ch_idx;
 
@@ -393,8 +393,7 @@ static irqreturn_t dim2_ahb_isr(int irq, void *_dev)
 	dim_service_ahb_int_irq(get_active_channels(dev, buffer));
 	spin_unlock_irqrestore(&dim_lock, flags);
 
-	dim2_tasklet.data = (unsigned long)dev;
-	tasklet_schedule(&dim2_tasklet);
+	tasklet_schedule(&dev->dim2_tasklet);
 	return IRQ_HANDLED;
 }
 
@@ -641,14 +640,14 @@ static int poison_channel(struct most_interface *most_iface, int ch_idx)
 	if (!hdm_ch->is_initialized)
 		return -EPERM;
 
-	tasklet_disable(&dim2_tasklet);
+	tasklet_disable(&dev->dim2_tasklet);
 	spin_lock_irqsave(&dim_lock, flags);
 	hal_ret = dim_destroy_channel(&hdm_ch->ch);
 	hdm_ch->is_initialized = false;
 	if (ch_idx == dev->atx_idx)
 		dev->atx_idx = -1;
 	spin_unlock_irqrestore(&dim_lock, flags);
-	tasklet_enable(&dim2_tasklet);
+	tasklet_enable(&dev->dim2_tasklet);
 	if (hal_ret != DIM_NO_ERROR) {
 		pr_err("HAL Failed to close channel %s\n", hdm_ch->name);
 		ret = -EFAULT;
@@ -731,6 +730,7 @@ static int dim2_probe(struct platform_device *pdev)
 	int ret, i;
 	u8 hal_ret;
 	int irq;
+	DECLARE_TASKLET(dim2_tasklet, dim2_tasklet_fn, 0);
 
 	enum { MLB_INT_IDX, AHB0_INT_IDX };
 
@@ -739,6 +739,8 @@ static int dim2_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	dev->atx_idx = -1;
+	dev->dim2_tasklet = dim2_tasklet;
+	dev->dim2_tasklet.data = (TASKLET_DATA_TYPE)&dev->dim2_tasklet;
 
 	platform_set_drvdata(pdev, dev);
 
diff --git a/drivers/staging/octeon/ethernet-tx.c b/drivers/staging/octeon/ethernet-tx.c
index c64728fc21f2..acb32a7c8b1d 100644
--- a/drivers/staging/octeon/ethernet-tx.c
+++ b/drivers/staging/octeon/ethernet-tx.c
@@ -40,7 +40,7 @@
 #define GET_SKBUFF_QOS(skb) 0
 #endif
 
-static void cvm_oct_tx_do_cleanup(unsigned long arg);
+static void cvm_oct_tx_do_cleanup(struct tasklet_struct *unused);
 static DECLARE_TASKLET(cvm_oct_tx_cleanup_tasklet, cvm_oct_tx_do_cleanup, 0);
 
 /* Maximum number of SKBs to try to free per xmit packet. */
@@ -674,7 +674,7 @@ void cvm_oct_tx_shutdown_dev(struct net_device *dev)
 	}
 }
 
-static void cvm_oct_tx_do_cleanup(unsigned long arg)
+static void cvm_oct_tx_do_cleanup(struct tasklet_struct *unused)
 {
 	int port;
 
diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
index 515fc095e3b4..06e54abcfac6 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -1214,7 +1214,7 @@ void vt_kbd_con_stop(int console)
  * handle the scenario when keyboard handler is not registered yet
  * but we already getting updates from the VT to update led state.
  */
-static void kbd_bh(unsigned long dummy)
+static void kbd_bh(struct tasklet_struct *unused)
 {
 	unsigned int leds;
 	unsigned long flags;
diff --git a/drivers/usb/gadget/udc/amd5536udc.h b/drivers/usb/gadget/udc/amd5536udc.h
index dfdef6a28904..72b89fb1b3fd 100644
--- a/drivers/usb/gadget/udc/amd5536udc.h
+++ b/drivers/usb/gadget/udc/amd5536udc.h
@@ -573,6 +573,7 @@ struct udc {
 	struct notifier_block		nb;
 	struct delayed_work		drd_work;
 	struct workqueue_struct		*drd_wq;
+	struct tasklet_struct		disconnect_tasklet;
 	u32				conn_type;
 };
 
diff --git a/drivers/usb/gadget/udc/snps_udc_core.c b/drivers/usb/gadget/udc/snps_udc_core.c
index 3fcded31405a..c9f29b7ad986 100644
--- a/drivers/usb/gadget/udc/snps_udc_core.c
+++ b/drivers/usb/gadget/udc/snps_udc_core.c
@@ -36,7 +36,7 @@
 #include <asm/unaligned.h>
 #include "amd5536udc.h"
 
-static void udc_tasklet_disconnect(unsigned long);
+static void udc_tasklet_disconnect(struct tasklet_struct *t);
 static void udc_setup_endpoints(struct udc *dev);
 static void udc_soft_reset(struct udc *dev);
 static struct udc_request *udc_alloc_bna_dummy(struct udc_ep *ep);
@@ -95,11 +95,6 @@ static struct timer_list udc_pollstall_timer;
 static int stop_pollstall_timer;
 static DECLARE_COMPLETION(on_pollstall_exit);
 
-/* tasklet for usb disconnect */
-static DECLARE_TASKLET(disconnect_tasklet, udc_tasklet_disconnect,
-		(unsigned long) &udc);
-
-
 /* endpoint names used for print */
 static const char ep0_string[] = "ep0in";
 static const struct {
@@ -1655,13 +1650,13 @@ static void usb_disconnect(struct udc *dev)
 	 * the spinlock needed to process the disconnect.
 	 */
 
-	tasklet_schedule(&disconnect_tasklet);
+	tasklet_schedule(&dev->disconnect_tasklet);
 }
 
 /* Tasklet for disconnect to be outside of interrupt context */
-static void udc_tasklet_disconnect(unsigned long par)
+static void udc_tasklet_disconnect(struct tasklet_struct *t)
 {
-	struct udc *dev = (struct udc *)(*((struct udc **) par));
+	struct udc *dev = from_tasklet(dev, t, disconnect_tasklet);
 	u32 tmp;
 
 	DBG(dev, "Tasklet disconnect\n");
@@ -3156,6 +3151,7 @@ int udc_probe(struct udc *dev)
 	char		tmp[128];
 	u32		reg;
 	int		retval;
+	DECLARE_TASKLET(disconnect_tasklet, udc_tasklet_disconnect, 0);
 
 	/* device struct setup */
 	dev->gadget.ops = &udc_ops;
@@ -3190,6 +3186,9 @@ int udc_probe(struct udc *dev)
 
 	udc = dev;
 
+	dev->disconnect_tasklet = disconnect_tasklet;
+	dev->disconnect_tasklet.data = (TASKLET_DATA_TYPE)&dev->disconnect_tasklet;
+
 	retval = usb_add_gadget_udc_release(udc->dev, &dev->gadget,
 					    gadget_release);
 	if (retval)
diff --git a/drivers/usb/host/fhci-hcd.c b/drivers/usb/host/fhci-hcd.c
index 04733876c9c6..27e9b637a38e 100644
--- a/drivers/usb/host/fhci-hcd.c
+++ b/drivers/usb/host/fhci-hcd.c
@@ -210,8 +210,9 @@ static int fhci_mem_init(struct fhci_hcd *fhci)
 	INIT_LIST_HEAD(&fhci->empty_tds);
 
 	/* initialize work queue to handle done list */
-	fhci_tasklet.data = (unsigned long)fhci;
-	fhci->process_done_task = &fhci_tasklet;
+	fhci->process_done_task = fhci_tasklet;
+	fhci->process_done_task.data =
+		(TASKLET_DATA_TYPE)&fhci->process_done_task;
 
 	for (i = 0; i < MAX_TDS; i++) {
 		struct td *td;
diff --git a/drivers/usb/host/fhci-sched.c b/drivers/usb/host/fhci-sched.c
index 3235d5307403..a04a049c7cd9 100644
--- a/drivers/usb/host/fhci-sched.c
+++ b/drivers/usb/host/fhci-sched.c
@@ -628,13 +628,13 @@ irqreturn_t fhci_irq(struct usb_hcd *hcd)
  * is process_del_list(),which unlinks URBs by scanning EDs,instead of scanning
  * the (re-reversed) done list as this does.
  */
-static void process_done_list(unsigned long data)
+static void process_done_list(struct tasklet_struct *t)
 {
 	struct urb *urb;
 	struct ed *ed;
 	struct td *td;
 	struct urb_priv *urb_priv;
-	struct fhci_hcd *fhci = (struct fhci_hcd *)data;
+	struct fhci_hcd *fhci = from_tasklet(fhci, t, process_done_task);
 
 	disable_irq(fhci->timer->irq);
 	disable_irq(fhci_to_hcd(fhci)->irq);
@@ -682,8 +682,8 @@ DECLARE_TASKLET(fhci_tasklet, process_done_list, 0);
 /* transfer complted callback */
 u32 fhci_transfer_confirm_callback(struct fhci_hcd *fhci)
 {
-	if (!fhci->process_done_task->state)
-		tasklet_schedule(fhci->process_done_task);
+	if (!fhci->process_done_task.state)
+		tasklet_schedule(&fhci->process_done_task);
 	return 0;
 }
 
diff --git a/drivers/usb/host/fhci.h b/drivers/usb/host/fhci.h
index 2ce5031d866d..196f9a15ebd0 100644
--- a/drivers/usb/host/fhci.h
+++ b/drivers/usb/host/fhci.h
@@ -254,7 +254,7 @@ struct fhci_hcd {
 	struct virtual_root_hub *vroot_hub; /* the virtual root hub */
 	int active_urbs;
 	struct fhci_controller_list *hc_list;
-	struct tasklet_struct *process_done_task; /* tasklet for done list */
+	struct tasklet_struct process_done_task; /* tasklet for done list */
 
 	struct list_head empty_eds;
 	struct list_head empty_tds;
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index f5332ae2dbeb..949bbaeaff0e 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -598,11 +598,14 @@ struct tasklet_struct
 	unsigned long data;
 };
 
+#define TASKLET_DATA_TYPE		unsigned long
+#define TASKLET_FUNC_TYPE		void (*)(TASKLET_DATA_TYPE)
+
 #define DECLARE_TASKLET(name, func, data) \
-struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(0), func, data }
+struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(0), (TASKLET_FUNC_TYPE)func, (TASKLET_DATA_TYPE)&name }
 
 #define DECLARE_TASKLET_DISABLED(name, func, data) \
-struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(1), func, data }
+struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(1), (TASKLET_FUNC_TYPE)func, (TASKLET_DATA_TYPE)&name }
 
 
 enum
@@ -673,9 +676,6 @@ extern void tasklet_kill_immediate(struct tasklet_struct *t, unsigned int cpu);
 extern void tasklet_init(struct tasklet_struct *t,
 			 void (*func)(unsigned long), unsigned long data);
 
-#define TASKLET_DATA_TYPE		unsigned long
-#define TASKLET_FUNC_TYPE		void (*)(TASKLET_DATA_TYPE)
-
 #define from_tasklet(var, callback_tasklet, tasklet_fieldname) \
 	container_of(callback_tasklet, typeof(*var), tasklet_fieldname)
 
diff --git a/kernel/backtracetest.c b/kernel/backtracetest.c
index a2a97fa3071b..b5b9e16f0083 100644
--- a/kernel/backtracetest.c
+++ b/kernel/backtracetest.c
@@ -23,7 +23,7 @@ static void backtrace_test_normal(void)
 
 static DECLARE_COMPLETION(backtrace_work);
 
-static void backtrace_test_irq_callback(unsigned long data)
+static void backtrace_test_irq_callback(struct tasklet_struct *unused)
 {
 	dump_stack();
 	complete(&backtrace_work);
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index f76d6f77dd5e..ceac3a21cf41 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -998,7 +998,7 @@ static void kgdb_unregister_callbacks(void)
  * such as is the case with kgdboe, where calling a breakpoint in the
  * I/O driver itself would be fatal.
  */
-static void kgdb_tasklet_bpt(unsigned long ing)
+static void kgdb_tasklet_bpt(struct tasklet_struct *unused)
 {
 	kgdb_breakpoint();
 	atomic_set(&kgdb_break_tasklet_var, 0);
diff --git a/kernel/irq/resend.c b/kernel/irq/resend.c
index 98c04ca5fa43..7edb88afebb5 100644
--- a/kernel/irq/resend.c
+++ b/kernel/irq/resend.c
@@ -27,7 +27,7 @@ static DECLARE_BITMAP(irqs_resend, IRQ_BITMAP_BITS);
 /*
  * Run software resends of IRQ's
  */
-static void resend_irqs(unsigned long arg)
+static void resend_irqs(struct tasklet_struct *unused)
 {
 	struct irq_desc *desc;
 	int irq;
diff --git a/net/atm/pppoatm.c b/net/atm/pppoatm.c
index 45d8e1d5d033..fe45fba20be2 100644
--- a/net/atm/pppoatm.c
+++ b/net/atm/pppoatm.c
@@ -101,9 +101,10 @@ static inline struct pppoatm_vcc *chan_to_pvcc(const struct ppp_channel *chan)
  * doesn't want to be called in interrupt context, so we do it from
  * a tasklet
  */
-static void pppoatm_wakeup_sender(unsigned long arg)
+static void pppoatm_wakeup_sender(struct tasklet_struct *t)
 {
-	ppp_output_wakeup((struct ppp_channel *) arg);
+	struct pppoatm_vcc *pvcc = from_tasklet(pvcc, t, wakeup_tasklet);
+	ppp_output_wakeup(&pvcc->chan);
 }
 
 static void pppoatm_release_cb(struct atm_vcc *atmvcc)
@@ -416,7 +417,7 @@ static int pppoatm_assign_vcc(struct atm_vcc *atmvcc, void __user *arg)
 	pvcc->chan.mtu = atmvcc->qos.txtp.max_sdu - PPP_HDRLEN -
 	    (be.encaps == e_vc ? 0 : LLC_LEN);
 	pvcc->wakeup_tasklet = tasklet_proto;
-	pvcc->wakeup_tasklet.data = (unsigned long) &pvcc->chan;
+	pvcc->wakeup_tasklet.data = (TASKLET_DATA_TYPE)&pvcc->wakeup_tasklet;
 	err = ppp_register_channel(&pvcc->chan);
 	if (err != 0) {
 		kfree(pvcc);
diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index 9a2d023842fe..d186c76f63b6 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -127,7 +127,7 @@ static LIST_HEAD(iucv_task_queue);
 /*
  * The tasklet for fast delivery of iucv interrupts.
  */
-static void iucv_tasklet_fn(unsigned long);
+static void iucv_tasklet_fn(struct tasklet_struct);
 static DECLARE_TASKLET(iucv_tasklet, iucv_tasklet_fn,0);
 
 /*
@@ -1726,7 +1726,7 @@ static void iucv_message_pending(struct iucv_irq_data *data)
  * iucv_external_interrupt, calls the appropriate action handler
  * and then frees the buffer.
  */
-static void iucv_tasklet_fn(unsigned long ignored)
+static void iucv_tasklet_fn(struct tasklet_struct *unused)
 {
 	typedef void iucv_irq_fn(struct iucv_irq_data *);
 	static iucv_irq_fn *irq_fn[] = {
diff --git a/sound/drivers/pcsp/pcsp_lib.c b/sound/drivers/pcsp/pcsp_lib.c
index 8f0f05bbc081..fbeeecaac8d4 100644
--- a/sound/drivers/pcsp/pcsp_lib.c
+++ b/sound/drivers/pcsp/pcsp_lib.c
@@ -26,7 +26,7 @@ MODULE_PARM_DESC(nforce_wa, "Apply NForce chipset workaround "
  * Call snd_pcm_period_elapsed in a tasklet
  * This avoids spinlock messes and long-running irq contexts
  */
-static void pcsp_call_pcm_elapsed(unsigned long priv)
+static void pcsp_call_pcm_elapsed(struct tasklet_struct *unused)
 {
 	if (atomic_read(&pcsp_chip.timer_active)) {
 		struct snd_pcm_substream *substream;
-- 
2.23.0

