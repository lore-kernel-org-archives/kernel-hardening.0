Return-Path: <SRS0=v+xs=XY=lists.openwall.com=kernel-hardening-return-16960-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4173C4360C
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Sep 2019 16:32:53 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E6E9E217F5
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Sep 2019 16:32:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hv83Pibs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E6E9E217F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16960-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24163 invoked by uid 550); 29 Sep 2019 16:31:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24025 invoked from network); 29 Sep 2019 16:31:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Vl+NFCZ45TToMoX7BZBnlmReDJfyIOGJxcWoH4cl/lQ=;
        b=Hv83PibskJThkGdU2LIpKQRb0TRqzHx1k0fG/GgzmmLqWF0mcJSwtA+5DT5HQXpILz
         AqYbPOnF9Nidya/pXkMOFx7xGq10m+wtDlpFVgRue4xVjq3nfXPHwx+qx/csBhGsRY42
         eabhLwF8Zytxwx+8Cih1KMRwuHLxM6TUCEr+VjvgsDNhuEOB1ZbUPusNGva/9KRNjOwM
         2MfaZYUpJN68Xd20TrJU8yNLlnEwrGgZ/Bllz2LjtWYBFQdcHWmrJVAS6JJJJ47SqRC8
         sJBLQPL7yaPzd41Xym3eirVUlzAx1TS7Ln+OukHhDctX1VbH8ldwUPl9NSSm1lj8rPRv
         l1hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vl+NFCZ45TToMoX7BZBnlmReDJfyIOGJxcWoH4cl/lQ=;
        b=YX3W1pXZwSk9y1oqKIy4zMIWb845tRMtNakIcUAI9ILsa+te4DDep+pMPcX4xP90NW
         7dE60fZqO8ef3N/uPLSRvlVKvXqo5UsHpqVof1PADx0tisXMJ1SfnfyvZJWCPWK8t2JQ
         EUx/YsSCAhNoJJR6iaMN07xxdphsvV3OtmJFjxgVKj3n1a6TzQr/VTjAisB4L+TLrGI9
         FjsytnnZb1YFJzR7rn9ouknLSorh0KX5kASn+zT7DCs8DCp++TL1/3pqAfKM52BDLKMo
         O4PRdhuiVqNmNCHZWOjiiUGjM7GG1T4s5XLHt+bm7Q1YXHJU+iJaHbxcXeRVpyiKam+4
         hrFQ==
X-Gm-Message-State: APjAAAWNn7O1rQ2L3BtgEoMJOt2JoUs6rEoKmH+zBKF9vMSuE+yhmxjH
	RfmZHU1qvdOEHz0O/0kieKk=
X-Google-Smtp-Source: APXvYqzNTGFuROTMP6Eq5Me8nZEAJKEy8ZwJsItCAJCL6ZconqAxkLQLycwG0gbixxh9rUbOqPjNzQ==
X-Received: by 2002:a5d:6a81:: with SMTP id s1mr10702468wru.246.1569774656426;
        Sun, 29 Sep 2019 09:30:56 -0700 (PDT)
From: Romain Perier <romain.perier@gmail.com>
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>,
	Romain Perier <romain.perier@gmail.com>
Subject: [PRE-REVIEW PATCH 10/16] scsi: pmcraid: Prepare to use the new tasklet API
Date: Sun, 29 Sep 2019 18:30:22 +0200
Message-Id: <20190929163028.9665-11-romain.perier@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929163028.9665-1-romain.perier@gmail.com>
References: <20190929163028.9665-1-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The future tasklet API will no longer allow to pass an arbitrary
"unsigned long" data parameter. The tasklet data structure will need to
be embedded into a data structure that will be retrieved from the tasklet
handler. Currently, with the current array of tasklets, there are no
ways to know precisely which tasklet is passed as argument of the
handler. This commit introduces a intermediate type "struct
pmcraid_tsk_param", that is used in this array. It contains the offset
of the given tasklet and the tasklet itself, so we will be able to use
container_of() on the pointer of the tasklet to retrieve the parents
data structure.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 drivers/scsi/pmcraid.c | 12 +++++++-----
 drivers/scsi/pmcraid.h |  9 +++++++--
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 7eb88fe1eb0b..2e44e3954bb0 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4198,7 +4198,7 @@ static irqreturn_t pmcraid_isr_msix(int irq, void *dev_id)
 		}
 	}
 
-	tasklet_schedule(&(pinstance->isr_tasklet[hrrq_id]));
+	tasklet_schedule(&(pinstance->isr_tasklet[hrrq_id].tasklet));
 
 	return IRQ_HANDLED;
 }
@@ -4267,7 +4267,7 @@ static irqreturn_t pmcraid_isr(int irq, void *dev_id)
 				pinstance->int_regs.ioa_host_interrupt_clr_reg);
 
 			tasklet_schedule(
-					&(pinstance->isr_tasklet[hrrq_id]));
+				&(pinstance->isr_tasklet[hrrq_id].tasklet));
 		}
 	}
 
@@ -4884,10 +4884,12 @@ static int pmcraid_allocate_config_buffers(struct pmcraid_instance *pinstance)
 static void pmcraid_init_tasklets(struct pmcraid_instance *pinstance)
 {
 	int i;
-	for (i = 0; i < pinstance->num_hrrq; i++)
-		tasklet_init(&pinstance->isr_tasklet[i],
+	for (i = 0; i < pinstance->num_hrrq; i++) {
+		pinstance->isr_tasklet[i].isr_tasklet_id = i;
+		tasklet_init(&pinstance->isr_tasklet[i].tasklet,
 			     pmcraid_tasklet_function,
 			     (unsigned long)&pinstance->hrrq_vector[i]);
+	}
 }
 
 /**
@@ -4902,7 +4904,7 @@ static void pmcraid_kill_tasklets(struct pmcraid_instance *pinstance)
 {
 	int i;
 	for (i = 0; i < pinstance->num_hrrq; i++)
-		tasklet_kill(&pinstance->isr_tasklet[i]);
+		tasklet_kill(&pinstance->isr_tasklet[i].tasklet);
 }
 
 /**
diff --git a/drivers/scsi/pmcraid.h b/drivers/scsi/pmcraid.h
index a4f7eb8f50a3..58b2acd37541 100644
--- a/drivers/scsi/pmcraid.h
+++ b/drivers/scsi/pmcraid.h
@@ -617,6 +617,11 @@ struct pmcraid_isr_param {
 	u8 hrrq_id;			/* hrrq entry index */
 };
 
+/* Tasklet parameters (one for each enabled tasklet) */
+struct pmcraid_tsk_param {
+	struct tasklet_struct tasklet;
+	u8 isr_tasklet_id;		/* isr_tasklet entry index */
+};
 
 /* AEN message header sent as part of event data to applications */
 struct pmcraid_aen_msg {
@@ -752,8 +757,8 @@ struct pmcraid_instance {
 	spinlock_t free_pool_lock;		/* free pool lock */
 	spinlock_t pending_pool_lock;		/* pending pool lock */
 
-	/* Tasklet to handle deferred processing */
-	struct tasklet_struct isr_tasklet[PMCRAID_NUM_MSIX_VECTORS];
+	/* Tasklet parameters and tasklets to handle deferred processing */
+	struct pmcraid_tsk_param isr_tasklet[PMCRAID_NUM_MSIX_VECTORS];
 
 	/* Work-queue (Shared) for deferred reset processing */
 	struct work_struct worker_q;
-- 
2.23.0

