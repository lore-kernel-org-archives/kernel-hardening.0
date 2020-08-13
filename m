Return-Path: <SRS0=4gzZ=BX=lists.openwall.com=kernel-hardening-return-19622-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46EDDC433E1
	for <kernel-hardening@archiver.kernel.org>; Thu, 13 Aug 2020 15:20:18 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9EF022078D
	for <kernel-hardening@archiver.kernel.org>; Thu, 13 Aug 2020 15:20:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9EF022078D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19622-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3456 invoked by uid 550); 13 Aug 2020 15:19:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3393 invoked from network); 13 Aug 2020 15:19:57 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sWVYbnLUoQh2/bQ8PJoxS/2ocrG/gYbDVzBuksdzAMQ=;
        b=Et7BtefpKa31t7H1dnnETFq7Rim+ltp+IdVzwBrdiPpSYyctZd5+pjefRTAoo5Dy3f
         nos/kEcrmpe/vYzWCPRKcaPIg2B2Yduz/JoBEDCRhVVQmrjIJeanC4F/up8WPJD6cDYt
         bgC1kRz+i+LT1DcID+KbPETGhhADALc5ysEo2fFrD5eTonoA+qt2a5ck+eMbzHnbLX7H
         JgNbkYyV+nR5vyKwzdD6ZhOIZE5KQuNu8S2aM2shpGbZ/AU1B1D2WLPZNechmKoQpi/2
         pxZY1jTXtkQW0Ws1Q9Qdzi0J4+pFlgytmFoyWTSuiD5FBd2JRugFyi9HwZvZhNpVLAlR
         x9Rw==
X-Gm-Message-State: AOAM530pZ8bO4ZYNMoa2PRyAu8DuULyuAO5OeuwwLpWTOwqDfQf/iE6z
	s942HLSxZz4zBtvQ+3lp+8Y=
X-Google-Smtp-Source: ABdhPJwKxFGbrbkYgxZpXwjaDbyI5I0M4/6XBG+VYoGVV0KtiAQ9ydy+etzJBWJI2Bu24vC6GiUcYw==
X-Received: by 2002:a1c:de88:: with SMTP id v130mr4675656wmg.98.1597331986347;
        Thu, 13 Aug 2020 08:19:46 -0700 (PDT)
From: Alexander Popov <alex.popov@linux.com>
To: Kees Cook <keescook@chromium.org>,
	Jann Horn <jannh@google.com>,
	Will Deacon <will@kernel.org>,
	Andrey Ryabinin <aryabinin@virtuozzo.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Patrick Bellasi <patrick.bellasi@arm.com>,
	David Howells <dhowells@redhat.com>,
	Eric Biederman <ebiederm@xmission.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Laura Abbott <labbott@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org,
	Alexander Popov <alex.popov@linux.com>
Cc: notify@kernel.org
Subject: [PATCH RFC 2/2] lkdtm: Add heap spraying test
Date: Thu, 13 Aug 2020 18:19:22 +0300
Message-Id: <20200813151922.1093791-3-alex.popov@linux.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200813151922.1093791-1-alex.popov@linux.com>
References: <20200813151922.1093791-1-alex.popov@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a simple test for CONFIG_SLAB_QUARANTINE.

It performs heap spraying that aims to reallocate the recently freed heap
object. This technique is used for exploiting use-after-free
vulnerabilities in the kernel code.

This test shows that CONFIG_SLAB_QUARANTINE breaks heap spraying
exploitation technique.

Signed-off-by: Alexander Popov <alex.popov@linux.com>
---
 drivers/misc/lkdtm/core.c  |  1 +
 drivers/misc/lkdtm/heap.c  | 40 ++++++++++++++++++++++++++++++++++++++
 drivers/misc/lkdtm/lkdtm.h |  1 +
 3 files changed, 42 insertions(+)

diff --git a/drivers/misc/lkdtm/core.c b/drivers/misc/lkdtm/core.c
index a5e344df9166..78b7669c35eb 100644
--- a/drivers/misc/lkdtm/core.c
+++ b/drivers/misc/lkdtm/core.c
@@ -126,6 +126,7 @@ static const struct crashtype crashtypes[] = {
 	CRASHTYPE(SLAB_FREE_DOUBLE),
 	CRASHTYPE(SLAB_FREE_CROSS),
 	CRASHTYPE(SLAB_FREE_PAGE),
+	CRASHTYPE(HEAP_SPRAY),
 	CRASHTYPE(SOFTLOCKUP),
 	CRASHTYPE(HARDLOCKUP),
 	CRASHTYPE(SPINLOCKUP),
diff --git a/drivers/misc/lkdtm/heap.c b/drivers/misc/lkdtm/heap.c
index 1323bc16f113..a72a241e314a 100644
--- a/drivers/misc/lkdtm/heap.c
+++ b/drivers/misc/lkdtm/heap.c
@@ -205,6 +205,46 @@ static void ctor_a(void *region)
 static void ctor_b(void *region)
 { }
 
+#define HEAP_SPRAY_SIZE 128
+
+void lkdtm_HEAP_SPRAY(void)
+{
+	int *addr;
+	int *spray_addrs[HEAP_SPRAY_SIZE] = { 0 };
+	unsigned long i = 0;
+
+	addr = kmem_cache_alloc(a_cache, GFP_KERNEL);
+	if (!addr) {
+		pr_info("Unable to allocate memory in lkdtm-heap-a cache\n");
+		return;
+	}
+
+	*addr = 0x31337;
+	kmem_cache_free(a_cache, addr);
+
+	pr_info("Performing heap spraying...\n");
+	for (i = 0; i < HEAP_SPRAY_SIZE; i++) {
+		spray_addrs[i] = kmem_cache_alloc(a_cache, GFP_KERNEL);
+		*spray_addrs[i] = 0x31337;
+		pr_info("attempt %lu: spray alloc addr %p vs freed addr %p\n",
+						i, spray_addrs[i], addr);
+		if (spray_addrs[i] == addr) {
+			pr_info("freed addr is reallocated!\n");
+			break;
+		}
+	}
+
+	if (i < HEAP_SPRAY_SIZE)
+		pr_info("FAIL! Heap spraying succeed :(\n");
+	else
+		pr_info("OK! Heap spraying hasn't succeed :)\n");
+
+	for (i = 0; i < HEAP_SPRAY_SIZE; i++) {
+		if (spray_addrs[i])
+			kmem_cache_free(a_cache, spray_addrs[i]);
+	}
+}
+
 void __init lkdtm_heap_init(void)
 {
 	double_free_cache = kmem_cache_create("lkdtm-heap-double_free",
diff --git a/drivers/misc/lkdtm/lkdtm.h b/drivers/misc/lkdtm/lkdtm.h
index 8878538b2c13..dfafb4ae6f3a 100644
--- a/drivers/misc/lkdtm/lkdtm.h
+++ b/drivers/misc/lkdtm/lkdtm.h
@@ -45,6 +45,7 @@ void lkdtm_READ_BUDDY_AFTER_FREE(void);
 void lkdtm_SLAB_FREE_DOUBLE(void);
 void lkdtm_SLAB_FREE_CROSS(void);
 void lkdtm_SLAB_FREE_PAGE(void);
+void lkdtm_HEAP_SPRAY(void);
 
 /* lkdtm_perms.c */
 void __init lkdtm_perms_init(void);
-- 
2.26.2

