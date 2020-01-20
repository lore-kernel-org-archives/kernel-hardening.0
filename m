Return-Path: <SRS0=M31D=3J=lists.openwall.com=kernel-hardening-return-17592-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D58FCC32771
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Jan 2020 04:55:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2E6682073A
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Jan 2020 04:55:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="oHxM02Cr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E6682073A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=axtens.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17592-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21860 invoked by uid 550); 20 Jan 2020 04:54:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21716 invoked from network); 20 Jan 2020 04:54:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pOmFCBblhkqj3gkmP+37nPe0hJ5NkRyIggkMoZ1sHnY=;
        b=oHxM02Cr48GBC2n2ErbUXAGiQbp9a9tIcZ01GW7OKYJz7SZdJx/qhAqSqjyNPLtZHc
         iXgHOE9I9QQlka8lEeceHuV/2cuIprxB8oep2Vgu9GlkUbjY9SELUov3xaKqMu7+FpNS
         NJ3D9mZpMq9jHjQyR1ePY6oL3wPxcf7nalshU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pOmFCBblhkqj3gkmP+37nPe0hJ5NkRyIggkMoZ1sHnY=;
        b=sCnXbU4JQ73RuPUj3b5zKVErXd3ps5BkYv0sPE2D0IehYOh/WUXW2aRR8buG5NBmZg
         eWXdynrWb8ctUpdPrgZZsDEfG0oHhsVeFhdUDfzyFmzCTqjZjIR6DNNF62H2VKRCQcrN
         4U8BUIP9uRKpU6nDEgPWGDJaM27OIMv5kot+88Q7RMH7bYBx22R3CjmTPfI/ywZWzu5c
         l70NRySVlCKaCMESjAE4QmnFGMiqfLkrxPpUaKtfIAt+yTF21hz+FsnBE07fG6/7EQt3
         u8LBU7eQZ1Px2M07Wx/rnruVzlMzY7tzrHMNqpH6CtuEfvRXhnpLv0C5b9V9Cimv6bFJ
         P3hQ==
X-Gm-Message-State: APjAAAX5Uk+16S0zrcGJq9dyD81PW3UB1ha88MK1uVE7Duc0j3OfPeSs
	qsHxMV8nAoimo1Mzm8MMYF+lo70wf1o=
X-Google-Smtp-Source: APXvYqx7MFbc9YXjaXN7u01v6rADAHDuX6xKBxQb86CEcWZHxmIXyxvsRMsN6v83PEIaZCaoJ+1MrA==
X-Received: by 2002:a63:a4b:: with SMTP id z11mr56030367pgk.97.1579496078651;
        Sun, 19 Jan 2020 20:54:38 -0800 (PST)
From: Daniel Axtens <dja@axtens.net>
To: kernel-hardening@lists.openwall.com,
	akpm@linux-foundation.org,
	keescook@chromium.org
Cc: linux-kernel@vger.kernel.org,
	Daniel Axtens <dja@axtens.net>
Subject: [PATCH v2 2/2] lkdtm: tests for FORTIFY_SOURCE
Date: Mon, 20 Jan 2020 15:54:24 +1100
Message-Id: <20200120045424.16147-3-dja@axtens.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200120045424.16147-1-dja@axtens.net>
References: <20200120045424.16147-1-dja@axtens.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add code to test both:

 - runtime detection of the overrun of a structure. This covers the
   __builtin_object_size(x, 0) case. This test is called FORTIFY_OBJECT.

 - runtime detection of the overrun of a char array within a structure.
   This covers the __builtin_object_size(x, 1) case which can be used
   for some string functions. This test is called FORTIFY_SUBOBJECT.

Suggested-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Daniel Axtens <dja@axtens.net>
---
 drivers/misc/lkdtm/bugs.c  | 51 ++++++++++++++++++++++++++++++++++++++
 drivers/misc/lkdtm/core.c  |  2 ++
 drivers/misc/lkdtm/lkdtm.h |  2 ++
 3 files changed, 55 insertions(+)

diff --git a/drivers/misc/lkdtm/bugs.c b/drivers/misc/lkdtm/bugs.c
index a4fdad04809a..77bf01ce7e0c 100644
--- a/drivers/misc/lkdtm/bugs.c
+++ b/drivers/misc/lkdtm/bugs.c
@@ -11,6 +11,7 @@
 #include <linux/sched/signal.h>
 #include <linux/sched/task_stack.h>
 #include <linux/uaccess.h>
+#include <linux/slab.h>
 
 #ifdef CONFIG_X86_32
 #include <asm/desc.h>
@@ -376,3 +377,53 @@ void lkdtm_DOUBLE_FAULT(void)
 	panic("tried to double fault but didn't die\n");
 }
 #endif
+
+void lkdtm_FORTIFY_OBJECT(void)
+{
+	struct target {
+		char a[10];
+	} target[2] = {};
+	int result;
+
+	/*
+	 * Using volatile prevents the compiler from determining the value of
+	 * 'size' at compile time. Without that, we would get a compile error
+	 * rather than a runtime error.
+	 */
+	volatile int size = 11;
+
+	pr_info("trying to read past the end of a struct\n");
+
+	result = memcmp(&target[0], &target[1], size);
+
+	/* Print result to prevent the code from being eliminated */
+	pr_err("FAIL: fortify did not catch an object overread!\n"
+	       "\"%d\" was the memcmp result.\n", result);
+}
+
+void lkdtm_FORTIFY_SUBOBJECT(void)
+{
+	struct target {
+		char a[10];
+		char b[10];
+	} target;
+	char *src;
+
+	src = kmalloc(20, GFP_KERNEL);
+	strscpy(src, "over ten bytes", 20);
+
+	pr_info("trying to strcpy past the end of a member of a struct\n");
+
+	/*
+	 * strncpy(target.a, src, 20); will hit a compile error because the
+	 * compiler knows at build time that target.a < 20 bytes. Use strcpy()
+	 * to force a runtime error.
+	 */
+	strcpy(target.a, src);
+
+	/* Use target.a to prevent the code from being eliminated */
+	pr_err("FAIL: fortify did not catch an sub-object overrun!\n"
+	       "\"%s\" was copied.\n", target.a);
+
+	kfree(src);
+}
diff --git a/drivers/misc/lkdtm/core.c b/drivers/misc/lkdtm/core.c
index ee0d6e721441..78d22a23b4f9 100644
--- a/drivers/misc/lkdtm/core.c
+++ b/drivers/misc/lkdtm/core.c
@@ -117,6 +117,8 @@ static const struct crashtype crashtypes[] = {
 	CRASHTYPE(STACK_GUARD_PAGE_TRAILING),
 	CRASHTYPE(UNSET_SMEP),
 	CRASHTYPE(UNALIGNED_LOAD_STORE_WRITE),
+	CRASHTYPE(FORTIFY_OBJECT),
+	CRASHTYPE(FORTIFY_SUBOBJECT),
 	CRASHTYPE(OVERWRITE_ALLOCATION),
 	CRASHTYPE(WRITE_AFTER_FREE),
 	CRASHTYPE(READ_AFTER_FREE),
diff --git a/drivers/misc/lkdtm/lkdtm.h b/drivers/misc/lkdtm/lkdtm.h
index c56d23e37643..13f13421dc19 100644
--- a/drivers/misc/lkdtm/lkdtm.h
+++ b/drivers/misc/lkdtm/lkdtm.h
@@ -31,6 +31,8 @@ void lkdtm_UNSET_SMEP(void);
 #ifdef CONFIG_X86_32
 void lkdtm_DOUBLE_FAULT(void);
 #endif
+void lkdtm_FORTIFY_OBJECT(void);
+void lkdtm_FORTIFY_SUBOBJECT(void);
 
 /* lkdtm_heap.c */
 void __init lkdtm_heap_init(void);
-- 
2.20.1

