Return-Path: <SRS0=AB0t=4P=lists.openwall.com=kernel-hardening-return-17981-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B8C0C11D3D
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Feb 2020 18:50:28 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BE797246FC
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Feb 2020 18:50:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="GklqgiNX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE797246FC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17981-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3945 invoked by uid 550); 27 Feb 2020 18:49:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3798 invoked from network); 27 Feb 2020 18:49:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tZTI1WKOfKcUGuqkPLx5fh8/0duDs7Ezr+5qHoGz4tY=;
        b=GklqgiNXeNchROgyC1BDr/uKshy3XOAwg/V7eA31LU8HpeMPQxp2F9ilEeKURDOSJP
         uXxuJwLLDx996zP1QRfYEMDPuBOI2E1PnHExPDrJ43nwK5khJSPgWU6JT2rmr29+WU/u
         ho8QR+KKHnR+iX/rYRf/Pracpbyaz3NUqtexg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tZTI1WKOfKcUGuqkPLx5fh8/0duDs7Ezr+5qHoGz4tY=;
        b=UKTgGK4eZ5ntILtgoO0Mnj49rATqnVTltx5SnBCkmCqbPFfF+7IXatPkzBOMqPeL42
         mK8mvInS+rCeMDC8zRXd1n7ARSYkhH/UBqPPbzEi7Nd7sQ8VeG8a2AvY0EPk0unDvR4Y
         EJY8DV83Fl3imP62C/kg15TpqqSXS58caI2HDnXPufOlCDnX+yozOlUYNx64L0qY0L1/
         njvj4Q3fNI8AwpFejq1l0QsmMzeuJ00PoXrM29D3rg/H2tC/VLNMxpI+/r1LAITzvLPT
         OsSsJ94LM2Sm0kXBpUyAq/s1SUMidZlk/yH0MK7RrzuPymzk9/n9tzecC1ONOlJytzDT
         bk/Q==
X-Gm-Message-State: APjAAAXviq1m3u92Flh+jrmC/2O8nPhrGnQk2hzGKsWHNMYbrrzEaKxc
	fEq2qZokcWR1qm8wfYmqeD7DDQ==
X-Google-Smtp-Source: APXvYqx1M8rIsrCkimvQNj4LaDpY7NXABU85kVIFBPe0471ED+onlrECMMc1xhJz0b/EeVW39Wkhqw==
X-Received: by 2002:a17:90a:cb11:: with SMTP id z17mr366666pjt.122.1582829370031;
        Thu, 27 Feb 2020 10:49:30 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrey Ryabinin <aryabinin@virtuozzo.com>,
	Elena Petrova <lenaptr@google.com>,
	Andrey Konovalov <andreyknvl@google.com>,
	Alexander Potapenko <glider@google.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	syzkaller@googlegroups.com
Subject: [PATCH v4 3/6] lkdtm/bugs: Add arithmetic overflow and array bounds checks
Date: Thu, 27 Feb 2020 10:49:18 -0800
Message-Id: <20200227184921.30215-4-keescook@chromium.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200227184921.30215-1-keescook@chromium.org>
References: <20200227184921.30215-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Adds LKDTM tests for arithmetic overflow (both signed and unsigned),
as well as array bounds checking.

Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
---
 drivers/misc/lkdtm/bugs.c  | 75 ++++++++++++++++++++++++++++++++++++++
 drivers/misc/lkdtm/core.c  |  3 ++
 drivers/misc/lkdtm/lkdtm.h |  3 ++
 3 files changed, 81 insertions(+)

diff --git a/drivers/misc/lkdtm/bugs.c b/drivers/misc/lkdtm/bugs.c
index de87693cf557..e4c61ffea35c 100644
--- a/drivers/misc/lkdtm/bugs.c
+++ b/drivers/misc/lkdtm/bugs.c
@@ -11,6 +11,7 @@
 #include <linux/sched/signal.h>
 #include <linux/sched/task_stack.h>
 #include <linux/uaccess.h>
+#include <linux/slab.h>
 
 #ifdef CONFIG_X86_32
 #include <asm/desc.h>
@@ -175,6 +176,80 @@ void lkdtm_HUNG_TASK(void)
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
+	volatile int i;
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
index ee0d6e721441..2e04719b503c 100644
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
index c56d23e37643..8391081c6f13 100644
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
2.20.1

