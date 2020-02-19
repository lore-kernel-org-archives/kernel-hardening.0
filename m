Return-Path: <SRS0=dloB=4H=lists.openwall.com=kernel-hardening-return-17828-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87FA0C34031
	for <kernel-hardening@archiver.kernel.org>; Wed, 19 Feb 2020 00:08:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B182524656
	for <kernel-hardening@archiver.kernel.org>; Wed, 19 Feb 2020 00:08:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sYYSXB08"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B182524656
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17828-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28463 invoked by uid 550); 19 Feb 2020 00:08:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28358 invoked from network); 19 Feb 2020 00:08:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=iAnwqX/AAGd26TFtb0myYOOPt2TU78CQZiCptAhki6M=;
        b=sYYSXB08w4w7CLMRT3/eNDx6xYva8cYEFTCuJQR4rh30Mullg9eZPGtxoD1mkVM562
         qadEoq/TXeLxpXMKTCLBB81ggPREoj6H3j99DsaWGjos6Iv2MW4hGhE6MqdaSqPtEvoS
         onQCQXI5swqMYQy6JUA4UFH3ODTe0Inj7zi0AQdoA3IaQTVXLJ2qKNMkyDMhboK9PZqP
         6+YGjfOGlwGI5VSXEpTlnSBOzBhsV1jpt3wTqfGr+bkOLRdvaWmj+DumCJeDJk52OzTm
         PgRgNf1gqwBqXUmrJGX3Q52KCvBbk7XtYFQgYhw0gPs6CtuQSKOJll9v8A/ezPLF5eEJ
         AQSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=iAnwqX/AAGd26TFtb0myYOOPt2TU78CQZiCptAhki6M=;
        b=jJDybHCxavCvZ1YsGM0VbGFUJhVoa0+3NdKOFmd9ucwI75Qg9GrmmcNOOUBR+AyP4/
         Kh2HJhf7+dLBhoHilol07P48mtOTakw18l58q6t2rpXWok27IobUdOfGQcd4nS427AA3
         hJZOs8e4z+ji+5QR+j8YGll9WEbwTxsLPSSn5FQsLWobz4C1fqRTAoQLHFhBCnGRdbp2
         d+WWcgRaSW71vdV9mKCOo8/xLrWZ19ZFLnYF+8TOTJ/nJg4hIZ8itmE85wKaF5D5axee
         cBcr+7JKCW4DtS3iSzPq41wNwqohYtTzMU8M0cn6yI/MwUEKKfapPaYDJWXciR0Oitqh
         2D6w==
X-Gm-Message-State: APjAAAWPDoirZtGDyh49wFF6LNIml31VqUkgGb7SL9Pejmb0pP8w+A/x
	Hv/RADvtqq+T7AMTzCCvH4fn8CFsnXxsCpXgnH4=
X-Google-Smtp-Source: APXvYqyEM4p/A8Dl5zz+8866IE6ZO7JWpwVqiWbBAAG9TUdmyrC5F892d6R7GtnA+eKeMUIgQtNYLB6Qlf3RSSdVxGQ=
X-Received: by 2002:a0c:c250:: with SMTP id w16mr18163747qvh.24.1582070910338;
 Tue, 18 Feb 2020 16:08:30 -0800 (PST)
Date: Tue, 18 Feb 2020 16:08:07 -0800
In-Reply-To: <20200219000817.195049-1-samitolvanen@google.com>
Message-Id: <20200219000817.195049-3-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200219000817.195049-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [PATCH v8 02/12] scs: add accounting
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, james.morse@arm.com
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

This change adds accounting for the memory allocated for shadow stacks.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 drivers/base/node.c    |  6 ++++++
 fs/proc/meminfo.c      |  4 ++++
 include/linux/mmzone.h |  3 +++
 kernel/scs.c           | 20 ++++++++++++++++++++
 mm/page_alloc.c        |  6 ++++++
 mm/vmstat.c            |  3 +++
 6 files changed, 42 insertions(+)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 98a31bafc8a2..874a8b428438 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -415,6 +415,9 @@ static ssize_t node_read_meminfo(struct device *dev,
 		       "Node %d AnonPages:      %8lu kB\n"
 		       "Node %d Shmem:          %8lu kB\n"
 		       "Node %d KernelStack:    %8lu kB\n"
+#ifdef CONFIG_SHADOW_CALL_STACK
+		       "Node %d ShadowCallStack:%8lu kB\n"
+#endif
 		       "Node %d PageTables:     %8lu kB\n"
 		       "Node %d NFS_Unstable:   %8lu kB\n"
 		       "Node %d Bounce:         %8lu kB\n"
@@ -438,6 +441,9 @@ static ssize_t node_read_meminfo(struct device *dev,
 		       nid, K(node_page_state(pgdat, NR_ANON_MAPPED)),
 		       nid, K(i.sharedram),
 		       nid, sum_zone_node_page_state(nid, NR_KERNEL_STACK_KB),
+#ifdef CONFIG_SHADOW_CALL_STACK
+		       nid, sum_zone_node_page_state(nid, NR_KERNEL_SCS_BYTES) / 1024,
+#endif
 		       nid, K(sum_zone_node_page_state(nid, NR_PAGETABLE)),
 		       nid, K(node_page_state(pgdat, NR_UNSTABLE_NFS)),
 		       nid, K(sum_zone_node_page_state(nid, NR_BOUNCE)),
diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index 8c1f1bb1a5ce..49768005a79e 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -103,6 +103,10 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 	show_val_kb(m, "SUnreclaim:     ", sunreclaim);
 	seq_printf(m, "KernelStack:    %8lu kB\n",
 		   global_zone_page_state(NR_KERNEL_STACK_KB));
+#ifdef CONFIG_SHADOW_CALL_STACK
+	seq_printf(m, "ShadowCallStack:%8lu kB\n",
+		   global_zone_page_state(NR_KERNEL_SCS_BYTES) / 1024);
+#endif
 	show_val_kb(m, "PageTables:     ",
 		    global_zone_page_state(NR_PAGETABLE));
 
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 462f6873905a..0a6f395abc68 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -200,6 +200,9 @@ enum zone_stat_item {
 	NR_MLOCK,		/* mlock()ed pages found and moved off LRU */
 	NR_PAGETABLE,		/* used for pagetables */
 	NR_KERNEL_STACK_KB,	/* measured in KiB */
+#if IS_ENABLED(CONFIG_SHADOW_CALL_STACK)
+	NR_KERNEL_SCS_BYTES,	/* measured in bytes */
+#endif
 	/* Second 128 byte cacheline */
 	NR_BOUNCE,
 #if IS_ENABLED(CONFIG_ZSMALLOC)
diff --git a/kernel/scs.c b/kernel/scs.c
index 28abed21950c..5245e992c692 100644
--- a/kernel/scs.c
+++ b/kernel/scs.c
@@ -12,6 +12,7 @@
 #include <linux/scs.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <linux/vmstat.h>
 #include <asm/scs.h>
 
 static inline void *__scs_base(struct task_struct *tsk)
@@ -89,6 +90,11 @@ static void scs_free(void *s)
 	vfree_atomic(s);
 }
 
+static struct page *__scs_page(struct task_struct *tsk)
+{
+	return vmalloc_to_page(__scs_base(tsk));
+}
+
 static int scs_cleanup(unsigned int cpu)
 {
 	int i;
@@ -135,6 +141,11 @@ static inline void scs_free(void *s)
 	kmem_cache_free(scs_cache, s);
 }
 
+static struct page *__scs_page(struct task_struct *tsk)
+{
+	return virt_to_page(__scs_base(tsk));
+}
+
 void __init scs_init(void)
 {
 	scs_cache = kmem_cache_create("scs_cache", SCS_SIZE, SCS_SIZE,
@@ -153,6 +164,12 @@ void scs_task_reset(struct task_struct *tsk)
 	task_set_scs(tsk, __scs_base(tsk));
 }
 
+static void scs_account(struct task_struct *tsk, int account)
+{
+	mod_zone_page_state(page_zone(__scs_page(tsk)), NR_KERNEL_SCS_BYTES,
+		account * SCS_SIZE);
+}
+
 int scs_prepare(struct task_struct *tsk, int node)
 {
 	void *s;
@@ -162,6 +179,8 @@ int scs_prepare(struct task_struct *tsk, int node)
 		return -ENOMEM;
 
 	task_set_scs(tsk, s);
+	scs_account(tsk, 1);
+
 	return 0;
 }
 
@@ -182,6 +201,7 @@ void scs_release(struct task_struct *tsk)
 
 	WARN_ON(scs_corrupted(tsk));
 
+	scs_account(tsk, -1);
 	task_set_scs(tsk, NULL);
 	scs_free(s);
 }
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3c4eb750a199..1381b9d84e4c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5340,6 +5340,9 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
 			" managed:%lukB"
 			" mlocked:%lukB"
 			" kernel_stack:%lukB"
+#ifdef CONFIG_SHADOW_CALL_STACK
+			" shadow_call_stack:%lukB"
+#endif
 			" pagetables:%lukB"
 			" bounce:%lukB"
 			" free_pcp:%lukB"
@@ -5362,6 +5365,9 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
 			K(zone_managed_pages(zone)),
 			K(zone_page_state(zone, NR_MLOCK)),
 			zone_page_state(zone, NR_KERNEL_STACK_KB),
+#ifdef CONFIG_SHADOW_CALL_STACK
+			zone_page_state(zone, NR_KERNEL_SCS_BYTES) / 1024,
+#endif
 			K(zone_page_state(zone, NR_PAGETABLE)),
 			K(zone_page_state(zone, NR_BOUNCE)),
 			K(free_pcp),
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 78d53378db99..d0650391c8c1 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1119,6 +1119,9 @@ const char * const vmstat_text[] = {
 	"nr_mlock",
 	"nr_page_table_pages",
 	"nr_kernel_stack",
+#if IS_ENABLED(CONFIG_SHADOW_CALL_STACK)
+	"nr_shadow_call_stack_bytes",
+#endif
 	"nr_bounce",
 #if IS_ENABLED(CONFIG_ZSMALLOC)
 	"nr_zspages",
-- 
2.25.0.265.gbab2e86ba0-goog

