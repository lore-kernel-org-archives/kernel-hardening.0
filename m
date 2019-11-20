Return-Path: <SRS0=Ne22=ZM=lists.openwall.com=kernel-hardening-return-17405-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06ED5C432C0
	for <kernel-hardening@archiver.kernel.org>; Wed, 20 Nov 2019 01:07:19 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5033A20708
	for <kernel-hardening@archiver.kernel.org>; Wed, 20 Nov 2019 01:07:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="a82EApFV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5033A20708
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17405-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25902 invoked by uid 550); 20 Nov 2019 01:06:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25778 invoked from network); 20 Nov 2019 01:06:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0T61AzxnAvwa4rB+CZumfDDidufAJnp+U8GPCQMxTB4=;
        b=a82EApFVTEe9phvCSrJOP3TlCmeHwEbc7lBntv/Y4A3SIjXWLzIYaza53B34WSAvIO
         M/p/3ECy6DvVgT1DcT27ZKc9hqk61OMYWbeg8Ie4sWtPigLH57V9lJaYWI9PwzZgGuQN
         +goyCf8HKTHNdfpJZrJyL8SxxITM+b1kefwFs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0T61AzxnAvwa4rB+CZumfDDidufAJnp+U8GPCQMxTB4=;
        b=Nf/iZF9dOTWItmVOBMofCzGW9TQY6EG/BJrFuCWkCQ6qJUvN2PNdIo7C+5KdBPD/Qh
         thlASSlaCux0IN+izLW7OVtrTd9aSw9yqfRoHedug/UDPO65OM6Zwzta+1kXVsdjZwEV
         yhEmMfvvW3DwuqB0HxhIBB59LUKSIsmqmyy/I1uAWyjwtl0UyXXTUfsjtIfp6B1Bpgjd
         LpS2pL64H6t/MWGPQYNxbo4mR4iCZ6aR1d28lWhXbtYOj85CkRprk1Gy7eJu24t0EUxI
         1px9l609K75l9LCX44OvByAVv8xngIoP/C/tZnXNrQaqutdTQypFQS21GeTBUteb3IHN
         3oDw==
X-Gm-Message-State: APjAAAVeNjeDqsE+QHRVA+A9S9Ls6Hmhyi64RFiXAiXNoghCTNzpQ1XT
	CmvOOoZgLzuym+08Bj8UELTHFA==
X-Google-Smtp-Source: APXvYqwMjjdQ2rf3CZ9jjyiv4G3ZP7tQU+Lm0RTG8f4dInndtCYLfPklkPViLPE1GjBEoqneZ6KF6w==
X-Received: by 2002:a17:902:561:: with SMTP id 88mr155318plf.127.1574212003854;
        Tue, 19 Nov 2019 17:06:43 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Kees Cook <keescook@chromium.org>,
	Elena Petrova <lenaptr@google.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: [PATCH 3/3] lkdtm/bugs: Add arithmetic overflow and array bounds checks
Date: Tue, 19 Nov 2019 17:06:36 -0800
Message-Id: <20191120010636.27368-4-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191120010636.27368-1-keescook@chromium.org>
References: <20191120010636.27368-1-keescook@chromium.org>

Adds LKDTM tests for arithmetic overflow (both signed and unsigned),
as well as array bounds checking.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/misc/lkdtm/bugs.c  | 75 ++++++++++++++++++++++++++++++++++++++
 drivers/misc/lkdtm/core.c  |  3 ++
 drivers/misc/lkdtm/lkdtm.h |  3 ++
 3 files changed, 81 insertions(+)

diff --git a/drivers/misc/lkdtm/bugs.c b/drivers/misc/lkdtm/bugs.c
index 7284a22b1a09..8b4ef30f53c6 100644
--- a/drivers/misc/lkdtm/bugs.c
+++ b/drivers/misc/lkdtm/bugs.c
@@ -11,6 +11,7 @@
 #include <linux/sched/signal.h>
 #include <linux/sched/task_stack.h>
 #include <linux/uaccess.h>
+#include <linux/slab.h>
 
 struct lkdtm_list {
 	struct list_head node;
@@ -171,6 +172,80 @@ void lkdtm_HUNG_TASK(void)
 	schedule();
 }
 
+volatile unsigned int huge = INT_MAX - 2;
+volatile unsigned int ignored;
+
+void lkdtm_OVERFLOW_SIGNED(void)
+{
+	int value;
+
+	value = huge;
+	pr_info("Normal signed addition ...\n");
+	value += 1;
+	ignored = value;
+
+	pr_info("Overflowing signed addition ...\n");
+	value += 4;
+	ignored = value;
+}
+
+
+void lkdtm_OVERFLOW_UNSIGNED(void)
+{
+	unsigned int value;
+
+	value = huge;
+	pr_info("Normal unsigned addition ...\n");
+	value += 1;
+	ignored = value;
+
+	pr_info("Overflowing unsigned addition ...\n");
+	value += 4;
+	ignored = value;
+}
+
+/* Intentially using old-style flex array definition of 1 byte. */
+struct array_bounds_flex_array {
+	int one;
+	int two;
+	char data[1];
+};
+
+struct array_bounds {
+	int one;
+	int two;
+	char data[8];
+	int three;
+};
+
+void lkdtm_ARRAY_BOUNDS(void)
+{
+	struct array_bounds_flex_array *not_checked;
+	struct array_bounds *checked;
+	int i;
+
+	not_checked = kmalloc(sizeof(*not_checked) * 2, GFP_KERNEL);
+	checked = kmalloc(sizeof(*checked) * 2, GFP_KERNEL);
+
+	pr_info("Array access within bounds ...\n");
+	/* For both, touch all bytes in the actual member size. */
+	for (i = 0; i < sizeof(checked->data); i++)
+		checked->data[i] = 'A';
+	/*
+	 * For the uninstrumented flex array member, also touch 1 byte
+	 * beyond to verify it is correctly uninstrumented.
+	 */
+	for (i = 0; i < sizeof(not_checked->data) + 1; i++)
+		not_checked->data[i] = 'A';
+
+	pr_info("Array access beyond bounds ...\n");
+	for (i = 0; i < sizeof(checked->data) + 1; i++)
+		checked->data[i] = 'B';
+
+	kfree(not_checked);
+	kfree(checked);
+}
+
 void lkdtm_CORRUPT_LIST_ADD(void)
 {
 	/*
diff --git a/drivers/misc/lkdtm/core.c b/drivers/misc/lkdtm/core.c
index cbc4c9045a99..25879f7b0768 100644
--- a/drivers/misc/lkdtm/core.c
+++ b/drivers/misc/lkdtm/core.c
@@ -129,6 +129,9 @@ static const struct crashtype crashtypes[] = {
 	CRASHTYPE(HARDLOCKUP),
 	CRASHTYPE(SPINLOCKUP),
 	CRASHTYPE(HUNG_TASK),
+	CRASHTYPE(OVERFLOW_SIGNED),
+	CRASHTYPE(OVERFLOW_UNSIGNED),
+	CRASHTYPE(ARRAY_BOUNDS),
 	CRASHTYPE(EXEC_DATA),
 	CRASHTYPE(EXEC_STACK),
 	CRASHTYPE(EXEC_KMALLOC),
diff --git a/drivers/misc/lkdtm/lkdtm.h b/drivers/misc/lkdtm/lkdtm.h
index ab446e0bde97..2cd0c5031eea 100644
--- a/drivers/misc/lkdtm/lkdtm.h
+++ b/drivers/misc/lkdtm/lkdtm.h
@@ -22,6 +22,9 @@ void lkdtm_SOFTLOCKUP(void);
 void lkdtm_HARDLOCKUP(void);
 void lkdtm_SPINLOCKUP(void);
 void lkdtm_HUNG_TASK(void);
+void lkdtm_OVERFLOW_SIGNED(void);
+void lkdtm_OVERFLOW_UNSIGNED(void);
+void lkdtm_ARRAY_BOUNDS(void);
 void lkdtm_CORRUPT_LIST_ADD(void);
 void lkdtm_CORRUPT_LIST_DEL(void);
 void lkdtm_CORRUPT_USER_DS(void);
-- 
2.17.1

