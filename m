Return-Path: <SRS0=vDfd=DG=lists.openwall.com=kernel-hardening-return-20023-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14B86C4727C
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 18:36:28 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 28B262074A
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 18:36:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 28B262074A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20023-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26012 invoked by uid 550); 29 Sep 2020 18:36:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25940 invoked from network); 29 Sep 2020 18:36:03 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2bxuhq/r6r8osy7pzVzO/JXpG1ASc+MUIPI5gsA7kxI=;
        b=uek3RWgWECbGyBN4iaBCNp1jjLAlR4vrI2czzV+O9UXIVkYF4wI8P8lQrh8kRXEbcX
         uTZMelJjE1TGEbrgzFGNt3/U5KCQ/NxT1aqbzgqUUeMBeQ8LUHCVVRelIKDlJ3a5ig9a
         GMU81gIzdtJgEwJ7jPrT6SG7plOVu/A2LxHayReOCPtM2pmGuu0vSLVuFpPjGT2XNc9A
         xKN5swiEAlz2sb7BwSoYzwDIRtGTa4L7f++xqcrNzFYgS1oVl6GiBYPsGKE+feFSku7e
         6KuEkg1+/rDBSpFv4d7EBc4m6qlTTjQ/aF3xrDyZKYWZGF0GL35hyR9TyeXhijGFuLc1
         HxxQ==
X-Gm-Message-State: AOAM532tmKx9kL7Bx3e5tdOEL8v00bgQoCxVBJ7I0wvP3D5QBXiVSmNY
	AlFVQlSbuBaDlzvmWROp8uc=
X-Google-Smtp-Source: ABdhPJy9A5JEn21mEASXT5hiuePaz0JL4sNUqlLTquEiKyft5GG7jNH5pWMw/hXwHiK/QazBvkyuwg==
X-Received: by 2002:a1c:5685:: with SMTP id k127mr6197810wmb.135.1601404551593;
        Tue, 29 Sep 2020 11:35:51 -0700 (PDT)
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
	Daniel Micay <danielmicay@gmail.com>,
	Andrey Konovalov <andreyknvl@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Pavel Machek <pavel@denx.de>,
	Valentin Schneider <valentin.schneider@arm.com>,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org,
	Alexander Popov <alex.popov@linux.com>
Cc: notify@kernel.org
Subject: [PATCH RFC v2 3/6] mm: Integrate SLAB_QUARANTINE with init_on_free
Date: Tue, 29 Sep 2020 21:35:10 +0300
Message-Id: <20200929183513.380760-4-alex.popov@linux.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200929183513.380760-1-alex.popov@linux.com>
References: <20200929183513.380760-1-alex.popov@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Having slab quarantine without memory erasing is harmful.
If the quarantined objects are not cleaned and contain data, then:
  1. they will be useful for use-after-free exploitation,
  2. there is no chance to detect use-after-free access.
So we want the quarantined objects to be erased.
Enable init_on_free that cleans objects before placing them into
the quarantine. CONFIG_PAGE_POISONING should be disabled since it
cuts off init_on_free.

Signed-off-by: Alexander Popov <alex.popov@linux.com>
---
 init/Kconfig    |  3 ++-
 mm/page_alloc.c | 22 ++++++++++++++++++++++
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/init/Kconfig b/init/Kconfig
index 358c8ce818f4..cd4cee71fd4e 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1933,7 +1933,8 @@ config SLAB_FREELIST_HARDENED
 
 config SLAB_QUARANTINE
 	bool "Enable slab freelist quarantine"
-	depends on !KASAN && (SLAB || SLUB)
+	depends on !KASAN && (SLAB || SLUB) && !PAGE_POISONING
+	select INIT_ON_FREE_DEFAULT_ON
 	help
 	  Enable slab freelist quarantine to delay reusing of freed slab
 	  objects. If this feature is enabled, freed objects are stored
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index fab5e97dc9ca..f67118e88500 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -168,6 +168,27 @@ static int __init early_init_on_alloc(char *buf)
 }
 early_param("init_on_alloc", early_init_on_alloc);
 
+#ifdef CONFIG_SLAB_QUARANTINE
+static int __init early_init_on_free(char *buf)
+{
+	/*
+	 * Having slab quarantine without memory erasing is harmful.
+	 * If the quarantined objects are not cleaned and contain data, then:
+	 *  1. they will be useful for use-after-free exploitation,
+	 *  2. use-after-free access may not be detected.
+	 * So we want the quarantined objects to be erased.
+	 *
+	 * Enable init_on_free that cleans objects before placing them into
+	 * the quarantine. CONFIG_PAGE_POISONING should be disabled since it
+	 * cuts off init_on_free.
+	 */
+	BUILD_BUG_ON(!IS_ENABLED(CONFIG_INIT_ON_FREE_DEFAULT_ON));
+	BUILD_BUG_ON(IS_ENABLED(CONFIG_PAGE_POISONING));
+	pr_info("mem auto-init: init_on_free is on for CONFIG_SLAB_QUARANTINE\n");
+
+	return 0;
+}
+#else /* CONFIG_SLAB_QUARANTINE */
 static int __init early_init_on_free(char *buf)
 {
 	int ret;
@@ -184,6 +205,7 @@ static int __init early_init_on_free(char *buf)
 		static_branch_disable(&init_on_free);
 	return ret;
 }
+#endif /* CONFIG_SLAB_QUARANTINE */
 early_param("init_on_free", early_init_on_free);
 
 /*
-- 
2.26.2

