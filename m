Return-Path: <SRS0=oLYl=NW=lists.openwall.com=kernel-hardening-return-21370-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 795F0C4320E
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 00:04:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CB6B660F4B
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 00:04:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CB6B660F4B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 8191 invoked by uid 550); 31 Aug 2021 00:00:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7472 invoked from network); 31 Aug 2021 00:00:34 -0000
X-IronPort-AV: E=McAfee;i="6200,9189,10092"; a="197933750"
X-IronPort-AV: E=Sophos;i="5.84,364,1620716400"; 
   d="scan'208";a="197933750"
X-IronPort-AV: E=Sophos;i="5.84,364,1620716400"; 
   d="scan'208";a="530713039"
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: dave.hansen@intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	x86@kernel.org,
	akpm@linux-foundation.org,
	keescook@chromium.org,
	shakeelb@google.com,
	vbabka@suse.cz,
	rppt@kernel.org
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>,
	linux-mm@kvack.org,
	linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 19/19] x86/mm: Add PKS table debug checking
Date: Mon, 30 Aug 2021 16:59:27 -0700
Message-Id: <20210830235927.6443-20-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210830235927.6443-1-rick.p.edgecombe@intel.com>
References: <20210830235927.6443-1-rick.p.edgecombe@intel.com>

Add a runtime checker that scans the currently used page tables to check
that they are all protected on the direct map, in the case of PKS
tables. Use the recently added page table traverser.

There are many possible ways to modify and allocate page tables. In
order to catch any missed cases, just traverse the active tables every
second and check the direct map protection for each.

This feature is intended for debugging only. Another way to do this
without the awkward timers, is to check each page while contructing the
PTE. It may be useful for enhance the protection as well. But this could
miss any strange wrong page table modifications hidden away somewhere in
the kernel. So for debug time, the scanner is a little more thorough.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/mm/pat/set_memory.c | 43 ++++++++++++++++++++++++++++++++++++
 mm/Kconfig                   |  5 +++++
 2 files changed, 48 insertions(+)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 6acf25999b0f..945b3d3e1231 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -19,6 +19,8 @@
 #include <linux/vmstat.h>
 #include <linux/kernel.h>
 #include <linux/pkeys.h>
+#include <linux/kthread.h>
+#include <linux/delay.h>
 
 #include <asm/e820/api.h>
 #include <asm/processor.h>
@@ -2703,6 +2705,45 @@ static void traverse_mm(struct mm_struct *mm, traverse_cb cb)
 	traverse_pgd(mm->pgd, cb, 0);
 }
 
+#ifdef CONFIG_PKS_PG_TABLES_DEBUG
+static void check_table_protected(unsigned long pfn, void *vaddr, void *vend)
+{
+	if (is_dmap_protected((unsigned long)__va(pfn << PAGE_SHIFT)))
+		return;
+
+	pr_warn("Found unprotected page, pfn: %lx maps address:0x%p\n", pfn, vaddr);
+}
+
+static int table_scan_fn(void *data)
+{
+	while (1) {
+		msleep(MSEC_PER_SEC);
+		mmap_read_lock(current->active_mm);
+		traverse_mm(current->active_mm, &check_table_protected);
+		mmap_read_unlock(current->active_mm);
+	}
+	return 0;
+}
+
+static void __init init_pks_table_scan(void)
+{
+	struct task_struct *thread;
+	int cpu;
+
+	pr_info("Starting pks_table_debug thread on %d cpus\n", num_online_cpus());
+	for (cpu = 0; cpu < num_online_cpus(); cpu++) {
+		thread = kthread_create_on_cpu(table_scan_fn, NULL, cpu, "pks_table_debug");
+		if (IS_ERR(thread)) {
+			pr_err("Failed to create pks_table_debug threads\n");
+			break;
+		}
+		wake_up_process(thread);
+	}
+}
+#else
+static void __init init_pks_table_scan(void) { }
+#endif
+
 static void free_maybe_reserved(struct page *page)
 {
 	if (PageReserved(page))
@@ -2776,6 +2817,8 @@ static int __init init_pks_dmap_tables(void)
 	 */
 	traverse_mm(&init_mm, &ensure_table_protected);
 
+	init_pks_table_scan();
+
 	return 0;
 out_err:
 	while ((cur = llist_del_first(&tables_to_covert))) {
diff --git a/mm/Kconfig b/mm/Kconfig
index 1f4fc85cbd2c..87a4963c63c6 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -863,6 +863,11 @@ config PKS_PG_TABLES_SOFT_ALWAYS
 	  still like to get notifications of illegitimate attempts to modify
 	  them.
 
+config PKS_PG_TABLES_DEBUG
+	def_bool y
+	depends on PKS_PG_TABLES
+
+
 config PERCPU_STATS
 	bool "Collect percpu memory statistics"
 	help
-- 
2.17.1

