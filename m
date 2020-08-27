Return-Path: <SRS0=ensa=CF=lists.openwall.com=kernel-hardening-return-19674-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00F91C433E1
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Aug 2020 05:25:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 25D4920786
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Aug 2020 05:25:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 25D4920786
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codefail.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19674-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9360 invoked by uid 550); 27 Aug 2020 05:24:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 8084 invoked from network); 27 Aug 2020 05:24:43 -0000
From: "Christopher M. Riedl" <cmr@codefail.de>
To: linuxppc-dev@lists.ozlabs.org
Cc: kernel-hardening@lists.openwall.com
Subject: [PATCH v3 3/6] Add LKDTM test to hijack a patch mapping (powerpc,x86_64)
Date: Thu, 27 Aug 2020 00:26:56 -0500
Message-Id: <20200827052659.24922-4-cmr@codefail.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200827052659.24922-1-cmr@codefail.de>
References: <20200827052659.24922-1-cmr@codefail.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
X-Originating-IP: 198.54.122.47
X-SpamExperts-Domain: o3.privateemail.com
X-SpamExperts-Username: out-03
Authentication-Results: registrar-servers.com; auth=pass (plain) smtp.auth=out-03@o3.privateemail.com
X-SpamExperts-Outgoing-Class: ham
X-SpamExperts-Outgoing-Evidence: SB/global_tokens (0.00151812161313)
X-Recommended-Action: accept
X-Filter-ID: Mvzo4OR0dZXEDF/gcnlw0fJi3Ojdyt5h9PLOIGvr3lipSDasLI4SayDByyq9LIhVm21BwnYIoMwL
 iZdWQShhdkTNWdUk1Ol2OGx3IfrIJKyP9eGNFz9TW9u+Jt8z2T3Kq02yUY2BU41HLqp9U+7si8M8
 LdvJpZ7k99Lvu8YZXeI6p5bbhGYzvfahQ7X4A9L0Ye/JicEYVQv1wTfnWwJUGLoHT+TiZ2cHCmVO
 a6Hj9ogDjOgV+SX1eVkOYg0EXN5AJODXbtOodkPED+RkHjVGH2xZ/WG2ZLv5RT/cF5Q6687AHRjU
 JmjnvGEokRBTZJpViFKfD1jKgYfH+6S5qDVYoLU6Gc4zNg/uTrrCW7r3PPLbhw3Crbac1ieeuRax
 ITFpzO11BRKqT8B4uLrn7iz8uvLBMzbIQcSG8L0jOzL80Q1MxDcqDeEvahfPkDkTlH91LgaQnmF8
 H6pa6B8MTK1ligAJ9G0GMvMSOAhk0taEj8weJNI+C0vMCMVtmGEXbiaCRPGqg4v6OwYy/yt5Cj+T
 3txbXpCgbiKBsA+Ddi6maweYdUirBly/K12a4uqqibUj/dHBojDbLVZkEx6TcwTT039q0aZI3qbh
 XsaDdLgW9brs8lq6YeUVTmb2st+aVE9JYOaeuiH/yEdZH8S1+TgcJBOjh0vPxcQOjKKOrYIQYpwa
 mUdylUIKhf3z2GAHxH7IMNrut00GZ5qvF8IF7tMR7zZ0OXNO45l0fhWSb7cPfaHCB05zrkyiXmy/
 DNFzttkswov2GavqJ07j7hZY8mVbefiuK2KN35hXmy7nXQ2QuBuxX4OQOI/UQ6jnFfMBgzwOw1To
 H/cUtROfGg27pVfRPjU3fSpvtX7kDRT+AqQr2T3rxJw/s9JEmzH0m3M+UGtqmwXmy0jjO7Ny/FPn
 2HjX+xD+i2L8VSehE3P7KyWRnBVDPDo3pDJlUlQ25PasjIMI9uAIvgWsH+Wq0zDLDi3S8euO5TcD
 eKjrEmYPn2IVWRsZR6NeDQwp7lDA8K9tDm+p97/T4LRRVYxF+VXiiOfHJN40eTXlWiUAYdLmsJdA
 oPKCpWwKtkkGG+bEnfOEkWTNI3SjTCvjMfNBc9ze9o81pXKSQ+GI7QB7PH97h6/L6Wb57LVs51cV
 C2TOjdXlLnr1FFwa8AyQYqjO7qYtiXb+9Q==
X-Report-Abuse-To: spam@se5.registrar-servers.com

When live patching with STRICT_KERNEL_RWX, the CPU doing the patching
must temporarily remap the page(s) containing the patch site with +W
permissions. While this temporary mapping is in use another CPU could
write to the same mapping and maliciously alter kernel text. Implement a
LKDTM test to attempt to exploit such an opening from another (ie. not
the patching) CPU. The test is implemented on x86_64 and powerpc only.

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

Signed-off-by: Christopher M. Riedl <cmr@codefail.de>
---
 drivers/misc/lkdtm/core.c  |   1 +
 drivers/misc/lkdtm/lkdtm.h |   1 +
 drivers/misc/lkdtm/perms.c | 146 +++++++++++++++++++++++++++++++++++++
 3 files changed, 148 insertions(+)

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
index 8878538b2c13..8bd98e8f0443 100644
--- a/drivers/misc/lkdtm/lkdtm.h
+++ b/drivers/misc/lkdtm/lkdtm.h
@@ -60,6 +60,7 @@ void lkdtm_EXEC_USERSPACE(void);
 void lkdtm_EXEC_NULL(void);
 void lkdtm_ACCESS_USERSPACE(void);
 void lkdtm_ACCESS_NULL(void);
+void lkdtm_HIJACK_PATCH(void);
 
 /* lkdtm_refcount.c */
 void lkdtm_REFCOUNT_INC_OVERFLOW(void);
diff --git a/drivers/misc/lkdtm/perms.c b/drivers/misc/lkdtm/perms.c
index 2dede2ef658f..0ed32aba5216 100644
--- a/drivers/misc/lkdtm/perms.c
+++ b/drivers/misc/lkdtm/perms.c
@@ -9,6 +9,7 @@
 #include <linux/vmalloc.h>
 #include <linux/mman.h>
 #include <linux/uaccess.h>
+#include <linux/kthread.h>
 #include <asm/cacheflush.h>
 
 /* Whether or not to fill the target memory area with do_nothing(). */
@@ -222,6 +223,151 @@ void lkdtm_ACCESS_NULL(void)
 	pr_err("FAIL: survived bad write\n");
 }
 
+#if defined(CONFIG_PPC) || defined(CONFIG_X86_64)
+#if defined(CONFIG_STRICT_KERNEL_RWX) && defined(CONFIG_SMP)
+/*
+ * This is just a dummy location to patch-over.
+ */
+static void patching_target(void)
+{
+	return;
+}
+
+#ifdef CONFIG_PPC
+#include <asm/code-patching.h>
+struct ppc_inst * const patch_site = (struct ppc_inst *)&patching_target;
+#endif
+
+#ifdef CONFIG_X86_64
+#include <asm/text-patching.h>
+int * const patch_site = (int *)&patching_target;
+#endif
+
+static inline int lkdtm_do_patch(int data)
+{
+#ifdef CONFIG_PPC
+	return patch_instruction(patch_site, ppc_inst(data));
+#endif
+#ifdef CONFIG_X86_64
+	text_poke(patch_site, &data, sizeof(int));
+	return 0;
+#endif
+}
+
+static inline bool lkdtm_verify_patch(int data)
+{
+#ifdef CONFIG_PPC
+	return ppc_inst_equal(ppc_inst_read(READ_ONCE(patch_site)),
+			ppc_inst(data));
+#endif
+#ifdef CONFIG_X86_64
+	return READ_ONCE(*patch_site) == data;
+#endif
+}
+
+static int lkdtm_patching_cpu(void *data)
+{
+	int err = 0;
+	int val = 0xdeadbeef;
+
+	pr_info("starting patching_cpu=%d\n", smp_processor_id());
+	do {
+		err = lkdtm_do_patch(val);
+	} while (lkdtm_verify_patch(val) && !err && !kthread_should_stop());
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
+#ifdef CONFIG_PPC
+	struct ppc_inst original_insn = ppc_inst_read(READ_ONCE(patch_site));
+#endif
+#ifdef CONFIG_X86_64
+	int original_insn = READ_ONCE(*patch_site);
+#endif
+	struct task_struct *patching_kthrd;
+	int patching_cpu, hijacker_cpu, attempts;
+	unsigned long addr;
+	bool hijacked;
+	const int bad_data = 0xbad00bad;
+
+	if (num_online_cpus() < 2) {
+		pr_warn("need at least two cpus\n");
+		return;
+	}
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
+		hijacked = !__put_user(bad_data, (int *)addr);
+
+		if (hijacked) {
+			if (kthread_stop(patching_kthrd))
+				pr_err("error trying to stop patching thread\n");
+			break;
+		}
+	}
+	pr_info("hijack attempts: %d\n", attempts);
+
+	if (hijacked) {
+		if (lkdtm_verify_patch(bad_data))
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
+	/* Restore the original insn for any future lkdtm tests */
+#ifdef CONFIG_PPC
+	patch_instruction(patch_site, original_insn);
+#endif
+#ifdef CONFIG_X86_64
+	lkdtm_do_patch(original_insn);
+#endif
+}
+
+#else
+
+void lkdtm_HIJACK_PATCH(void)
+{
+	if (!IS_ENABLED(CONFIG_PPC) && !IS_ENABLED(CONFIG_X86_64))
+		pr_err("XFAIL: this test only runs on x86_64 or powerpc\n");
+	if (!IS_ENABLED(CONFIG_STRICT_KERNEL_RWX))
+		pr_err("XFAIL: this test requires CONFIG_STRICT_KERNEL_RWX\n");
+	if (!IS_ENABLED(CONFIG_SMP))
+		pr_err("XFAIL: this test requires CONFIG_SMP\n");
+}
+
+#endif /* CONFIG_STRICT_KERNEL_RWX && CONFIG_SMP */
+#endif /* CONFIG_PPC || CONFIG_X86_64 */
+
 void __init lkdtm_perms_init(void)
 {
 	/* Make sure we can write to __ro_after_init values during __init */
-- 
2.28.0

