Return-Path: <SRS0=uyNU=6N=lists.openwall.com=kernel-hardening-return-18674-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B063C83001
	for <kernel-hardening@archiver.kernel.org>; Wed, 29 Apr 2020 02:05:28 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D143620731
	for <kernel-hardening@archiver.kernel.org>; Wed, 29 Apr 2020 02:05:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D143620731
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=informatik.wtf
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18674-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17962 invoked by uid 550); 29 Apr 2020 02:04:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17804 invoked from network); 29 Apr 2020 02:04:27 -0000
From: "Christopher M. Riedl" <cmr@informatik.wtf>
To: linuxppc-dev@lists.ozlabs.org,
	kernel-hardening@lists.openwall.com
Subject: [RFC PATCH v2 5/5] powerpc: Add LKDTM test to hijack a patch mapping
Date: Tue, 28 Apr 2020 21:05:31 -0500
Message-Id: <20200429020531.20684-6-cmr@informatik.wtf>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200429020531.20684-1-cmr@informatik.wtf>
References: <20200429020531.20684-1-cmr@informatik.wtf>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP

When live patching with STRICT_KERNEL_RWX, the CPU doing the patching
must use a temporary mapping which allows for writing to kernel text.
During the entire window of time when this temporary mapping is in use,
another CPU could write to the same mapping and maliciously alter kernel
text. Implement a LKDTM test to attempt to exploit such a openings when
a CPU is patching under STRICT_KERNEL_RWX. The test is only implemented
on powerpc for now.

The LKDTM "hijack" test works as follows:

	1. A CPU executes an infinite loop to patch an instruction.
	   This is the "patching" CPU.
	2. Another CPU attempts to write to the address of the temporary
	   mapping used by the "patching" CPU. This other CPU is the
	   "hijacker" CPU. The hijack either fails with a segfault or
	   succeeds, in which case some kernel text is now overwritten.

How to run the test:

	mount -t debugfs none /sys/kernel/debug
	(echo HIJACK_PATCH > /sys/kernel/debug/provoke-crash/DIRECT)

Signed-off-by: Christopher M. Riedl <cmr@informatik.wtf>
---
 drivers/misc/lkdtm/core.c  |  1 +
 drivers/misc/lkdtm/lkdtm.h |  1 +
 drivers/misc/lkdtm/perms.c | 99 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 101 insertions(+)

diff --git a/drivers/misc/lkdtm/core.c b/drivers/misc/lkdtm/core.c
index a5e344df9166..482e72f6a1e1 100644
--- a/drivers/misc/lkdtm/core.c
+++ b/drivers/misc/lkdtm/core.c
@@ -145,6 +145,7 @@ static const struct crashtype crashtypes[] = {
 	CRASHTYPE(WRITE_RO),
 	CRASHTYPE(WRITE_RO_AFTER_INIT),
 	CRASHTYPE(WRITE_KERN),
+	CRASHTYPE(HIJACK_PATCH),
 	CRASHTYPE(REFCOUNT_INC_OVERFLOW),
 	CRASHTYPE(REFCOUNT_ADD_OVERFLOW),
 	CRASHTYPE(REFCOUNT_INC_NOT_ZERO_OVERFLOW),
diff --git a/drivers/misc/lkdtm/lkdtm.h b/drivers/misc/lkdtm/lkdtm.h
index 601a2156a0d4..bfcf3542370d 100644
--- a/drivers/misc/lkdtm/lkdtm.h
+++ b/drivers/misc/lkdtm/lkdtm.h
@@ -62,6 +62,7 @@ void lkdtm_EXEC_USERSPACE(void);
 void lkdtm_EXEC_NULL(void);
 void lkdtm_ACCESS_USERSPACE(void);
 void lkdtm_ACCESS_NULL(void);
+void lkdtm_HIJACK_PATCH(void);
 
 /* lkdtm_refcount.c */
 void lkdtm_REFCOUNT_INC_OVERFLOW(void);
diff --git a/drivers/misc/lkdtm/perms.c b/drivers/misc/lkdtm/perms.c
index 62f76d506f04..547ce16e03e5 100644
--- a/drivers/misc/lkdtm/perms.c
+++ b/drivers/misc/lkdtm/perms.c
@@ -9,6 +9,7 @@
 #include <linux/vmalloc.h>
 #include <linux/mman.h>
 #include <linux/uaccess.h>
+#include <linux/kthread.h>
 #include <asm/cacheflush.h>
 
 /* Whether or not to fill the target memory area with do_nothing(). */
@@ -213,6 +214,104 @@ void lkdtm_ACCESS_NULL(void)
 	*ptr = tmp;
 }
 
+#if defined(CONFIG_PPC) && defined(CONFIG_STRICT_KERNEL_RWX)
+#include <include/asm/code-patching.h>
+
+extern unsigned long read_cpu_patching_addr(unsigned int cpu);
+
+static unsigned int * const patch_site = (unsigned int * const)&do_nothing;
+
+static int lkdtm_patching_cpu(void *data)
+{
+	int err = 0;
+
+	pr_info("starting patching_cpu=%d\n", smp_processor_id());
+	do {
+		err = patch_instruction(patch_site, 0xdeadbeef);
+	} while (*READ_ONCE(patch_site) == 0xdeadbeef &&
+			!err && !kthread_should_stop());
+
+	if (err)
+		pr_warn("patch_instruction returned error: %d\n", err);
+
+	set_current_state(TASK_INTERRUPTIBLE);
+	while (!kthread_should_stop()) {
+		schedule();
+		set_current_state(TASK_INTERRUPTIBLE);
+	}
+
+	return err;
+}
+
+void lkdtm_HIJACK_PATCH(void)
+{
+	struct task_struct *patching_kthrd;
+	int patching_cpu, hijacker_cpu, original_insn, attempts;
+	unsigned long addr;
+	bool hijacked;
+
+	if (num_online_cpus() < 2) {
+		pr_warn("need at least two cpus\n");
+		return;
+	}
+
+	original_insn = *READ_ONCE(patch_site);
+
+	hijacker_cpu = smp_processor_id();
+	patching_cpu = cpumask_any_but(cpu_online_mask, hijacker_cpu);
+
+	patching_kthrd = kthread_create_on_node(&lkdtm_patching_cpu, NULL,
+						cpu_to_node(patching_cpu),
+						"lkdtm_patching_cpu");
+	kthread_bind(patching_kthrd, patching_cpu);
+	wake_up_process(patching_kthrd);
+
+	addr = offset_in_page(patch_site) | read_cpu_patching_addr(patching_cpu);
+
+	pr_info("starting hijacker_cpu=%d\n", hijacker_cpu);
+	for (attempts = 0; attempts < 100000; ++attempts) {
+		/* Use __put_user to catch faults without an Oops */
+		hijacked = !__put_user(0xbad00bad, (unsigned int *)addr);
+
+		if (hijacked) {
+			if (kthread_stop(patching_kthrd))
+				goto out;
+			break;
+		}
+	}
+	pr_info("hijack attempts: %d\n", attempts);
+
+	if (hijacked) {
+		if (*READ_ONCE(patch_site) == 0xbad00bad)
+			pr_err("overwrote kernel text\n");
+		/*
+		 * There are window conditions where the hijacker cpu manages to
+		 * write to the patch site but the site gets overwritten again by
+		 * the patching cpu. We still consider that a "successful" hijack
+		 * since the hijacker cpu did not fault on the write.
+		 */
+		pr_err("FAIL: wrote to another cpu's patching area\n");
+	} else {
+		kthread_stop(patching_kthrd);
+	}
+
+out:
+	/* Restore the original insn for any future lkdtm tests */
+	patch_instruction(patch_site, original_insn);
+}
+
+#else
+
+void lkdtm_HIJACK_PATCH(void)
+{
+	if (!IS_ENABLED(CONFIG_PPC))
+		pr_err("XFAIL: this test is powerpc-only\n");
+	if (!IS_ENABLED(CONFIG_STRICT_KERNEL_RWX))
+		pr_err("XFAIL: this test requires CONFIG_STRICT_KERNEL_RWX\n");
+}
+
+#endif /* CONFIG_PPC && CONFIG_STRICT_KERNEL_RWX */
+
 void __init lkdtm_perms_init(void)
 {
 	/* Make sure we can write to __ro_after_init values during __init */
-- 
2.26.1

