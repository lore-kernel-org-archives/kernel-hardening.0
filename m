Return-Path: <SRS0=xgV5=XY=lists.openwall.com=kernel-hardening-return-16959-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE2B8C4360C
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Sep 2019 16:32:41 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D4821217F5
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Sep 2019 16:32:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a4OZUVlh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D4821217F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16959-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23956 invoked by uid 550); 29 Sep 2019 16:31:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23852 invoked from network); 29 Sep 2019 16:31:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T7IhH1xv5+capbeG5bF7ofSJAzqTe8PhYCxco5jaeO4=;
        b=a4OZUVlhhH1ZeCwrsyZzYVroy1ZQ6Kxns/aYuptJjCRjGvr4n02USUYxc7a/JXNU9i
         SAa6cDrt3lVDUVz0fkqLAs7EKB3YrF1VpTyJxOOlkEt+OjflLAoDmEQbZT6f1ZrvpQCS
         kLEoeDjrrlemrExA/LksDF69hOI+ufs812zHqsGHzRMXl8Qp/Q9OHTU9XOdqGd9wra4O
         HmTYxUOg/KUDvUzfLTGPuGuVeG0bp5/Eg3n8sDPrbUdXhPS0wf0pmV4FS1+i2AnxbCwO
         epTQKJ5Ykf+JRpy0BBYksxHiqmsW2OXIZ77Rdb2hUwJ7qv6oa8mHTjiO7tD23364Yzjc
         joeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T7IhH1xv5+capbeG5bF7ofSJAzqTe8PhYCxco5jaeO4=;
        b=dyjV7/KhU+Qfy+oMnyIgWuPxfIEIrJxFROJNFIcN0WFJsTliXwfDYrzrSEbe4+UCZ+
         crqLjCr31Xa6CWchi7PIJRjbeNyUBy4nvcZuJUp5ooloh9piTBt/SeU4RoQ2sK8WrQug
         dHi9vdDwbXkMy7zNDx09tKYDZNzrz5zuKU/KhAodrszVENbQ2uKu0Lvu2sRfpz0Z+YKT
         oOXwMj5M4dmzkLVXUUZJjuORwYqoAOOz4P4gT+usNWzCWVjnZZxSO6Tva4UhS5Ktopn3
         c/oFb7hMfWjUjrlUgS2JTVODXNOxkJANXbF/KRVrfhU4nlBIeTx0cE3/hqjg0WLxBkXs
         4IEQ==
X-Gm-Message-State: APjAAAWpyQEc9HDSIzM0sugaXYsGe3MaCPVTR2486tfV2RIlL/VOKHGE
	qnIdlNHvnvTwyob+Id4L0fhFQ1Az
X-Google-Smtp-Source: APXvYqwouNIfWU31Fqxu0BwmLCjMmMBhh2yWUjc1J35hCYWkEXiyjRudgiogcJyZ7mLvtz2UhCPjXA==
X-Received: by 2002:a1c:a404:: with SMTP id n4mr13848473wme.137.1569774654806;
        Sun, 29 Sep 2019 09:30:54 -0700 (PDT)
From: Romain Perier <romain.perier@gmail.com>
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>,
	Romain Perier <romain.perier@gmail.com>
Subject: [PRE-REVIEW PATCH 09/16] scsi: pm8001: Prepare to use the new tasklet API
Date: Sun, 29 Sep 2019 18:30:21 +0200
Message-Id: <20190929163028.9665-10-romain.perier@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929163028.9665-1-romain.perier@gmail.com>
References: <20190929163028.9665-1-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The future tasklet API will no longer allow to pass an arbitrary
"unsigned long" data parameter. The tasklet data structure will need to
be embedded into a data structure that will be retrieved from the tasklet
handler. Currently, there are no ways from the tasklet of the handler to
retrieve the parent data structure by using container_of(), mainly
because we cannot know the index of the tasklet in the array of tasklets.
This commits adds a intermediate data structure, that stores "irq_id",
that is the index of the irq_vector and of the tasklet, so
based on this index we will be able to use container_of() and retrieve
the root parent structure.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 42 +++++++++++++++++++------------
 drivers/scsi/pm8001/pm8001_sas.h  |  6 ++++-
 2 files changed, 31 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 3374f553c617..f508e8314188 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -204,7 +204,7 @@ static irqreturn_t pm8001_interrupt_handler_msix(int irq, void *opaque)
 	if (!PM8001_CHIP_DISP->is_our_interrupt(pm8001_ha))
 		return IRQ_NONE;
 #ifdef PM8001_USE_TASKLET
-	tasklet_schedule(&pm8001_ha->tasklet[irq_vector->irq_id]);
+	tasklet_schedule(&pm8001_ha->tasklet[irq_vector->irq_id].tasklet);
 #else
 	ret = PM8001_CHIP_DISP->isr(pm8001_ha, irq_vector->irq_id);
 #endif
@@ -228,7 +228,7 @@ static irqreturn_t pm8001_interrupt_handler_intx(int irq, void *dev_id)
 		return IRQ_NONE;
 
 #ifdef PM8001_USE_TASKLET
-	tasklet_schedule(&pm8001_ha->tasklet[0]);
+	tasklet_schedule(&pm8001_ha->tasklet[0].tasklet);
 #else
 	ret = PM8001_CHIP_DISP->isr(pm8001_ha, 0);
 #endif
@@ -477,13 +477,18 @@ static struct pm8001_hba_info *pm8001_pci_alloc(struct pci_dev *pdev,
 #ifdef PM8001_USE_TASKLET
 	/* Tasklet for non msi-x interrupt handler */
 	if ((!pdev->msix_cap || !pci_msi_enabled())
-	    || (pm8001_ha->chip_id == chip_8001))
-		tasklet_init(&pm8001_ha->tasklet[0], pm8001_tasklet,
+	    || (pm8001_ha->chip_id == chip_8001)) {
+		pm8001_ha->tasklet[0].irq_id = 0;
+		tasklet_init(&pm8001_ha->tasklet[0].tasklet, pm8001_tasklet,
 			(unsigned long)&(pm8001_ha->irq_vector[0]));
-	else
-		for (j = 0; j < PM8001_MAX_MSIX_VEC; j++)
-			tasklet_init(&pm8001_ha->tasklet[j], pm8001_tasklet,
+	} else {
+		for (j = 0; j < PM8001_MAX_MSIX_VEC; j++) {
+			pm8001_ha->tasklet[j].irq_id = j;
+			tasklet_init(&pm8001_ha->tasklet[j].tasklet,
+				pm8001_tasklet,
 				(unsigned long)&(pm8001_ha->irq_vector[j]));
+		}
+	}
 #endif
 	pm8001_ioremap(pm8001_ha);
 	if (!pm8001_alloc(pm8001_ha, ent))
@@ -1092,10 +1097,10 @@ static void pm8001_pci_remove(struct pci_dev *pdev)
 	/* For non-msix and msix interrupts */
 	if ((!pdev->msix_cap || !pci_msi_enabled()) ||
 	    (pm8001_ha->chip_id == chip_8001))
-		tasklet_kill(&pm8001_ha->tasklet[0]);
+		tasklet_kill(&pm8001_ha->tasklet[0].tasklet);
 	else
 		for (j = 0; j < PM8001_MAX_MSIX_VEC; j++)
-			tasklet_kill(&pm8001_ha->tasklet[j]);
+			tasklet_kill(&pm8001_ha->tasklet[j].tasklet);
 #endif
 	scsi_host_put(pm8001_ha->shost);
 	pm8001_free(pm8001_ha);
@@ -1142,10 +1147,10 @@ static int pm8001_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 	/* For non-msix and msix interrupts */
 	if ((!pdev->msix_cap || !pci_msi_enabled()) ||
 	    (pm8001_ha->chip_id == chip_8001))
-		tasklet_kill(&pm8001_ha->tasklet[0]);
+		tasklet_kill(&pm8001_ha->tasklet[0].tasklet);
 	else
 		for (j = 0; j < PM8001_MAX_MSIX_VEC; j++)
-			tasklet_kill(&pm8001_ha->tasklet[j]);
+			tasklet_kill(&pm8001_ha->tasklet[j].tasklet);
 #endif
 	device_state = pci_choose_state(pdev, state);
 	pm8001_printk("pdev=0x%p, slot=%s, entering "
@@ -1211,13 +1216,18 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
 #ifdef PM8001_USE_TASKLET
 	/*  Tasklet for non msi-x interrupt handler */
 	if ((!pdev->msix_cap || !pci_msi_enabled()) ||
-	    (pm8001_ha->chip_id == chip_8001))
-		tasklet_init(&pm8001_ha->tasklet[0], pm8001_tasklet,
+	    (pm8001_ha->chip_id == chip_8001)) {
+		pm8001_ha->tasklet[0].irq_id = 0;
+		tasklet_init(&pm8001_ha->tasklet[0].tasklet, pm8001_tasklet,
 			(unsigned long)&(pm8001_ha->irq_vector[0]));
-	else
-		for (j = 0; j < PM8001_MAX_MSIX_VEC; j++)
-			tasklet_init(&pm8001_ha->tasklet[j], pm8001_tasklet,
+	} else {
+		for (j = 0; j < PM8001_MAX_MSIX_VEC; j++) {
+			pm8001_ha->tasklet[j].irq_id = j;
+			tasklet_init(&pm8001_ha->tasklet[j].tasklet,
+				pm8001_tasklet,
 				(unsigned long)&(pm8001_ha->irq_vector[j]));
+		}
+	}
 #endif
 	PM8001_CHIP_DISP->interrupt_enable(pm8001_ha, 0);
 	if (pm8001_ha->chip_id != chip_8001) {
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index ff17c6aff63d..0199c64f6cc3 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -480,6 +480,10 @@ struct isr_param {
 	struct pm8001_hba_info *drv_inst;
 	u32 irq_id;
 };
+struct tsk_param {
+	struct tasklet_struct tasklet;
+	u32 irq_id;
+};
 struct pm8001_hba_info {
 	char			name[PM8001_NAME_LENGTH];
 	struct list_head	list;
@@ -532,7 +536,7 @@ struct pm8001_hba_info {
 	int			number_of_intr;/*will be used in remove()*/
 #endif
 #ifdef PM8001_USE_TASKLET
-	struct tasklet_struct	tasklet[PM8001_MAX_MSIX_VEC];
+	struct tsk_param	tasklet[PM8001_MAX_MSIX_VEC];
 #endif
 	u32			logging_level;
 	u32			fw_status;
-- 
2.23.0

