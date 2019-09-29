Return-Path: <SRS0=jsZ1=XY=lists.openwall.com=kernel-hardening-return-16957-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5EA2C4360C
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Sep 2019 16:32:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DF85D217F5
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Sep 2019 16:32:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ERdPmd3f"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DF85D217F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16957-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23612 invoked by uid 550); 29 Sep 2019 16:31:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22505 invoked from network); 29 Sep 2019 16:31:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OFNGerxtycznBqDpvyYGYTsjUJEWGDuuwRt2p5xq6KE=;
        b=ERdPmd3fW3zPhl9Bp9cri51JrCLgscCgj65WhXWKdsc91r7v+KGSSo9YZBmizIrz0r
         d0/UmNiWV4m5r3TzALlzBvDhMvatb324hMh9aVtYz/A/JZT8h2boKKZ8k0lmW/MNwEP8
         uUQRZLGcpaOqIPJPTZOIZzMQ0F/ZnXgt0ZkrCwao9XDOFfR8zty79pibNvMJjDDK6C+n
         yx7t2YCJOD8ADut8OVnAz8Ix6XOsKWo5zY8jeH60EUzLbBaed+CE9IUBLi37N+1RdT6h
         kfLc6DOjmasraylV7u4NL6dVNYn9XozJEFBebZFcHrY695/0b5oolG8+Gz0BHYQUZGn6
         4YoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OFNGerxtycznBqDpvyYGYTsjUJEWGDuuwRt2p5xq6KE=;
        b=L4K7YNhGbWkmVcl073nsBHaAGUxjAcFnMGsc6LfcGigN3mbhQMngXMsgfrbBh+N+LY
         NWiP2yTf2TBHeqpBouCIa8Xj9BC3pR76PPm5i3+uH5tAcYYWeuHrD5W/uq9Md7UuCoAn
         VpZ7j2R3Z/A5PLdlIXA2UYqzPwYBPEcgE8WH6DG9jKgGnnjtV3PLyvmV+gWtk1Zpe5SK
         SvBri/YKIMPyBGGpdZdrb1LQ/Bqg+BMaGlhZRYC/Qs6SdDTZGWuFiFQG4G0rv7coeoZr
         CtGWIOrHzREjA/LLySFoQCUmTI7LlFCgWu+YbqBP5BDiKi+5IOtbnXMzSwF127pQvCHv
         s6oA==
X-Gm-Message-State: APjAAAVTn3tcrltE3AtqYbeqtEQ+0n4zyOsjFBkPn+ZIeCLrG24//p2K
	Q0zEFOjiONGQmO6MyiUh77M=
X-Google-Smtp-Source: APXvYqz+Ux8s8GEEhsjBOEMoRFSFRK8zfYWfSkoA5s6LRVatmQTAvW624DvDv4TdTemjOnKke+SDKg==
X-Received: by 2002:a05:6000:1184:: with SMTP id g4mr10349197wrx.361.1569774651555;
        Sun, 29 Sep 2019 09:30:51 -0700 (PDT)
From: Romain Perier <romain.perier@gmail.com>
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>,
	Romain Perier <romain.perier@gmail.com>
Subject: [PRE-REVIEW PATCH 07/16] qed: Prepare to use the new tasklet API
Date: Sun, 29 Sep 2019 18:30:19 +0200
Message-Id: <20190929163028.9665-8-romain.perier@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929163028.9665-1-romain.perier@gmail.com>
References: <20190929163028.9665-1-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The future tasklet API will no longer allow to pass an arbitrary
"unsigned long" data parameter. The tasklet data structure will need to
be embedded into a data structure that will be retrieved from the tasklet
handler. For this, the parent structure will be retrieved by the help of
container_of(), which means that tasklet must be statically allocated
into the parent structure and not allocated via kmalloc(). This commit,
remove the dynamic allocation of the tasklet in each "struct qed_hwfn".
Before each reused the tasklet will be killed, disabled then reinit,
redefining its internal data structure state, so it can be reused for
another purpose without requiring the need to reallocate a new object
dynamically (which can be subject to use-after-free, double-free or
memleak issues).

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 drivers/net/ethernet/qlogic/qed/qed.h      |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_int.c  | 22 +---------------------
 drivers/net/ethernet/qlogic/qed/qed_main.c | 14 +++++++-------
 3 files changed, 9 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index 89fe091c958d..e180df1d340e 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -592,7 +592,7 @@ struct qed_hwfn {
 	struct qed_consq		*p_consq;
 
 	/* Slow-Path definitions */
-	struct tasklet_struct		*sp_dpc;
+	struct tasklet_struct		sp_dpc;
 	bool				b_sp_dpc_enabled;
 
 	struct qed_ptt			*p_main_ptt;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.c b/drivers/net/ethernet/qlogic/qed/qed_int.c
index 9f5113639eaf..7e1ef7b281b5 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.c
@@ -2279,34 +2279,15 @@ u64 qed_int_igu_read_sisr_reg(struct qed_hwfn *p_hwfn)
 
 static void qed_int_sp_dpc_setup(struct qed_hwfn *p_hwfn)
 {
-	tasklet_init(p_hwfn->sp_dpc,
+	tasklet_init(&p_hwfn->sp_dpc,
 		     qed_int_sp_dpc, (unsigned long)p_hwfn);
 	p_hwfn->b_sp_dpc_enabled = true;
 }
 
-static int qed_int_sp_dpc_alloc(struct qed_hwfn *p_hwfn)
-{
-	p_hwfn->sp_dpc = kmalloc(sizeof(*p_hwfn->sp_dpc), GFP_KERNEL);
-	if (!p_hwfn->sp_dpc)
-		return -ENOMEM;
-
-	return 0;
-}
-
-static void qed_int_sp_dpc_free(struct qed_hwfn *p_hwfn)
-{
-	kfree(p_hwfn->sp_dpc);
-	p_hwfn->sp_dpc = NULL;
-}
-
 int qed_int_alloc(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 {
 	int rc = 0;
 
-	rc = qed_int_sp_dpc_alloc(p_hwfn);
-	if (rc)
-		return rc;
-
 	rc = qed_int_sp_sb_alloc(p_hwfn, p_ptt);
 	if (rc)
 		return rc;
@@ -2320,7 +2301,6 @@ void qed_int_free(struct qed_hwfn *p_hwfn)
 {
 	qed_int_sp_sb_free(p_hwfn);
 	qed_int_sb_attn_free(p_hwfn);
-	qed_int_sp_dpc_free(p_hwfn);
 }
 
 void qed_int_setup(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 2ce70097d018..743c4561e251 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -678,7 +678,7 @@ static irqreturn_t qed_single_int(int irq, void *dev_instance)
 
 		/* Slowpath interrupt */
 		if (unlikely(status & 0x1)) {
-			tasklet_schedule(hwfn->sp_dpc);
+			tasklet_schedule(&hwfn->sp_dpc);
 			status &= ~0x1;
 			rc = IRQ_HANDLED;
 		}
@@ -724,7 +724,7 @@ int qed_slowpath_irq_req(struct qed_hwfn *hwfn)
 			 id, cdev->pdev->bus->number,
 			 PCI_SLOT(cdev->pdev->devfn), hwfn->abs_pf_id);
 		rc = request_irq(cdev->int_params.msix_table[id].vector,
-				 qed_msix_sp_int, 0, hwfn->name, hwfn->sp_dpc);
+				 qed_msix_sp_int, 0, hwfn->name, &hwfn->sp_dpc);
 	} else {
 		unsigned long flags = 0;
 
@@ -756,8 +756,8 @@ static void qed_slowpath_tasklet_flush(struct qed_hwfn *p_hwfn)
 	 * enable function makes this sequence a flush-like operation.
 	 */
 	if (p_hwfn->b_sp_dpc_enabled) {
-		tasklet_disable(p_hwfn->sp_dpc);
-		tasklet_enable(p_hwfn->sp_dpc);
+		tasklet_disable(&p_hwfn->sp_dpc);
+		tasklet_enable(&p_hwfn->sp_dpc);
 	}
 }
 
@@ -786,7 +786,7 @@ static void qed_slowpath_irq_free(struct qed_dev *cdev)
 				break;
 			synchronize_irq(cdev->int_params.msix_table[i].vector);
 			free_irq(cdev->int_params.msix_table[i].vector,
-				 cdev->hwfns[i].sp_dpc);
+				 &cdev->hwfns[i].sp_dpc);
 		}
 	} else {
 		if (QED_LEADING_HWFN(cdev)->b_int_requested)
@@ -805,11 +805,11 @@ static int qed_nic_stop(struct qed_dev *cdev)
 		struct qed_hwfn *p_hwfn = &cdev->hwfns[i];
 
 		if (p_hwfn->b_sp_dpc_enabled) {
-			tasklet_disable(p_hwfn->sp_dpc);
+			tasklet_disable(&p_hwfn->sp_dpc);
 			p_hwfn->b_sp_dpc_enabled = false;
 			DP_VERBOSE(cdev, NETIF_MSG_IFDOWN,
 				   "Disabled sp tasklet [hwfn %d] at %p\n",
-				   i, p_hwfn->sp_dpc);
+				   i, &p_hwfn->sp_dpc);
 		}
 	}
 
-- 
2.23.0

