Return-Path: <SRS0=QLjg=XC=lists.openwall.com=kernel-hardening-return-16870-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C62C6C43331
	for <kernel-hardening@archiver.kernel.org>; Sat,  7 Sep 2019 06:08:33 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id EFA1E206BB
	for <kernel-hardening@archiver.kernel.org>; Sat,  7 Sep 2019 06:08:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EFA1E206BB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=informatik.wtf
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16870-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 12104 invoked by uid 550); 7 Sep 2019 06:08:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 12006 invoked from network); 7 Sep 2019 06:08:16 -0000
From: "Christopher M. Riedl" <cmr@informatik.wtf>
To: linuxppc-dev@ozlabs.org,
	kernel-hardening@lists.openwall.com
Cc: ajd@linux.ibm.com,
	dja@axtens.net
Subject: [PATCH v7 2/2] powerpc/xmon: Restrict when kernel is locked down
Date: Sat,  7 Sep 2019 01:11:24 -0500
Message-Id: <20190907061124.1947-3-cmr@informatik.wtf>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190907061124.1947-1-cmr@informatik.wtf>
References: <20190907061124.1947-1-cmr@informatik.wtf>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP

Xmon should be either fully or partially disabled depending on the
kernel lockdown state.

Put xmon into read-only mode for lockdown=integrity and prevent user
entry into xmon when lockdown=confidentiality. Xmon checks the lockdown
state on every attempted entry:

 (1) during early xmon'ing

 (2) when triggered via sysrq

 (3) when toggled via debugfs

 (4) when triggered via a previously enabled breakpoint

The following lockdown state transitions are handled:

 (1) lockdown=none -> lockdown=integrity
     set xmon read-only mode

 (2) lockdown=none -> lockdown=confidentiality
     clear all breakpoints, set xmon read-only mode,
     prevent user re-entry into xmon

 (3) lockdown=integrity -> lockdown=confidentiality
     clear all breakpoints, set xmon read-only mode,
     prevent user re-entry into xmon

Suggested-by: Andrew Donnellan <ajd@linux.ibm.com>
Signed-off-by: Christopher M. Riedl <cmr@informatik.wtf>
---
 arch/powerpc/xmon/xmon.c     | 103 ++++++++++++++++++++++++++++-------
 include/linux/security.h     |   2 +
 security/lockdown/lockdown.c |   2 +
 3 files changed, 86 insertions(+), 21 deletions(-)

diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
index ed94de614938..6eaf8ab532f6 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -25,6 +25,7 @@
 #include <linux/nmi.h>
 #include <linux/ctype.h>
 #include <linux/highmem.h>
+#include <linux/security.h>
 
 #include <asm/debugfs.h>
 #include <asm/ptrace.h>
@@ -187,6 +188,8 @@ static void dump_tlb_44x(void);
 static void dump_tlb_book3e(void);
 #endif
 
+static void clear_all_bpt(void);
+
 #ifdef CONFIG_PPC64
 #define REG		"%.16lx"
 #else
@@ -283,10 +286,38 @@ Commands:\n\
 "  U	show uptime information\n"
 "  ?	help\n"
 "  # n	limit output to n lines per page (for dp, dpa, dl)\n"
-"  zr	reboot\n\
-  zh	halt\n"
+"  zr	reboot\n"
+"  zh	halt\n"
 ;
 
+#ifdef CONFIG_SECURITY
+static bool xmon_is_locked_down(void)
+{
+	static bool lockdown;
+
+	if (!lockdown) {
+		lockdown = !!security_locked_down(LOCKDOWN_XMON_RW);
+		if (lockdown) {
+			printf("xmon: Disabled due to kernel lockdown\n");
+			xmon_is_ro = true;
+		}
+	}
+
+	if (!xmon_is_ro) {
+		xmon_is_ro = !!security_locked_down(LOCKDOWN_XMON_WR);
+		if (xmon_is_ro)
+			printf("xmon: Read-only due to kernel lockdown\n");
+	}
+
+	return lockdown;
+}
+#else /* CONFIG_SECURITY */
+static inline bool xmon_is_locked_down(void)
+{
+	return false;
+}
+#endif
+
 static struct pt_regs *xmon_regs;
 
 static inline void sync(void)
@@ -438,7 +469,10 @@ static bool wait_for_other_cpus(int ncpus)
 
 	return false;
 }
-#endif /* CONFIG_SMP */
+#else /* CONFIG_SMP */
+static inline void get_output_lock(void) {}
+static inline void release_output_lock(void) {}
+#endif
 
 static inline int unrecoverable_excp(struct pt_regs *regs)
 {
@@ -455,6 +489,7 @@ static int xmon_core(struct pt_regs *regs, int fromipi)
 	int cmd = 0;
 	struct bpt *bp;
 	long recurse_jmp[JMP_BUF_LEN];
+	bool locked_down;
 	unsigned long offset;
 	unsigned long flags;
 #ifdef CONFIG_SMP
@@ -465,6 +500,8 @@ static int xmon_core(struct pt_regs *regs, int fromipi)
 	local_irq_save(flags);
 	hard_irq_disable();
 
+	locked_down = xmon_is_locked_down();
+
 	tracing_enabled = tracing_is_on();
 	tracing_off();
 
@@ -516,7 +553,8 @@ static int xmon_core(struct pt_regs *regs, int fromipi)
 
 	if (!fromipi) {
 		get_output_lock();
-		excprint(regs);
+		if (!locked_down)
+			excprint(regs);
 		if (bp) {
 			printf("cpu 0x%x stopped at breakpoint 0x%tx (",
 			       cpu, BP_NUM(bp));
@@ -568,10 +606,14 @@ static int xmon_core(struct pt_regs *regs, int fromipi)
 		}
 		remove_bpts();
 		disable_surveillance();
-		/* for breakpoint or single step, print the current instr. */
-		if (bp || TRAP(regs) == 0xd00)
-			ppc_inst_dump(regs->nip, 1, 0);
-		printf("enter ? for help\n");
+
+		if (!locked_down) {
+			/* for breakpoint or single step, print curr insn */
+			if (bp || TRAP(regs) == 0xd00)
+				ppc_inst_dump(regs->nip, 1, 0);
+			printf("enter ? for help\n");
+		}
+
 		mb();
 		xmon_gate = 1;
 		barrier();
@@ -595,8 +637,9 @@ static int xmon_core(struct pt_regs *regs, int fromipi)
 			spin_cpu_relax();
 			touch_nmi_watchdog();
 		} else {
-			cmd = cmds(regs);
-			if (cmd != 0) {
+			if (!locked_down)
+				cmd = cmds(regs);
+			if (locked_down || cmd != 0) {
 				/* exiting xmon */
 				insert_bpts();
 				xmon_gate = 0;
@@ -633,13 +676,16 @@ static int xmon_core(struct pt_regs *regs, int fromipi)
 			       "can't continue\n");
 		remove_bpts();
 		disable_surveillance();
-		/* for breakpoint or single step, print the current instr. */
-		if (bp || TRAP(regs) == 0xd00)
-			ppc_inst_dump(regs->nip, 1, 0);
-		printf("enter ? for help\n");
+		if (!locked_down) {
+			/* for breakpoint or single step, print current insn */
+			if (bp || TRAP(regs) == 0xd00)
+				ppc_inst_dump(regs->nip, 1, 0);
+			printf("enter ? for help\n");
+		}
 	}
 
-	cmd = cmds(regs);
+	if (!locked_down)
+		cmd = cmds(regs);
 
 	insert_bpts();
 	in_xmon = 0;
@@ -668,7 +714,10 @@ static int xmon_core(struct pt_regs *regs, int fromipi)
 		}
 	}
 #endif
-	insert_cpu_bpts();
+	if (locked_down)
+		clear_all_bpt();
+	else
+		insert_cpu_bpts();
 
 	touch_nmi_watchdog();
 	local_irq_restore(flags);
@@ -3747,6 +3796,11 @@ static void xmon_init(int enable)
 #ifdef CONFIG_MAGIC_SYSRQ
 static void sysrq_handle_xmon(int key)
 {
+	if (xmon_is_locked_down()) {
+		clear_all_bpt();
+		xmon_init(0);
+		return;
+	}
 	/* ensure xmon is enabled */
 	xmon_init(1);
 	debugger(get_irq_regs());
@@ -3768,7 +3822,6 @@ static int __init setup_xmon_sysrq(void)
 device_initcall(setup_xmon_sysrq);
 #endif /* CONFIG_MAGIC_SYSRQ */
 
-#ifdef CONFIG_DEBUG_FS
 static void clear_all_bpt(void)
 {
 	int i;
@@ -3786,18 +3839,22 @@ static void clear_all_bpt(void)
 		iabr = NULL;
 		dabr.enabled = 0;
 	}
-
-	printf("xmon: All breakpoints cleared\n");
 }
 
+#ifdef CONFIG_DEBUG_FS
 static int xmon_dbgfs_set(void *data, u64 val)
 {
 	xmon_on = !!val;
 	xmon_init(xmon_on);
 
 	/* make sure all breakpoints removed when disabling */
-	if (!xmon_on)
+	if (!xmon_on) {
 		clear_all_bpt();
+		get_output_lock();
+		printf("xmon: All breakpoints cleared\n");
+		release_output_lock();
+	}
+
 	return 0;
 }
 
@@ -3823,7 +3880,11 @@ static int xmon_early __initdata;
 
 static int __init early_parse_xmon(char *p)
 {
-	if (!p || strncmp(p, "early", 5) == 0) {
+	if (xmon_is_locked_down()) {
+		xmon_init(0);
+		xmon_early = 0;
+		xmon_on = 0;
+	} else if (!p || strncmp(p, "early", 5) == 0) {
 		/* just "xmon" is equivalent to "xmon=early" */
 		xmon_init(1);
 		xmon_early = 1;
diff --git a/include/linux/security.h b/include/linux/security.h
index 429f9f03372b..ba9d308689b6 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -116,12 +116,14 @@ enum lockdown_reason {
 	LOCKDOWN_MODULE_PARAMETERS,
 	LOCKDOWN_MMIOTRACE,
 	LOCKDOWN_DEBUGFS,
+	LOCKDOWN_XMON_WR,
 	LOCKDOWN_INTEGRITY_MAX,
 	LOCKDOWN_KCORE,
 	LOCKDOWN_KPROBES,
 	LOCKDOWN_BPF_READ,
 	LOCKDOWN_PERF,
 	LOCKDOWN_TRACEFS,
+	LOCKDOWN_XMON_RW,
 	LOCKDOWN_CONFIDENTIALITY_MAX,
 };
 
diff --git a/security/lockdown/lockdown.c b/security/lockdown/lockdown.c
index 0068cec77c05..db85182d3f11 100644
--- a/security/lockdown/lockdown.c
+++ b/security/lockdown/lockdown.c
@@ -31,12 +31,14 @@ static char *lockdown_reasons[LOCKDOWN_CONFIDENTIALITY_MAX+1] = {
 	[LOCKDOWN_MODULE_PARAMETERS] = "unsafe module parameters",
 	[LOCKDOWN_MMIOTRACE] = "unsafe mmio",
 	[LOCKDOWN_DEBUGFS] = "debugfs access",
+	[LOCKDOWN_XMON_WR] = "xmon write access",
 	[LOCKDOWN_INTEGRITY_MAX] = "integrity",
 	[LOCKDOWN_KCORE] = "/proc/kcore access",
 	[LOCKDOWN_KPROBES] = "use of kprobes",
 	[LOCKDOWN_BPF_READ] = "use of bpf to read kernel RAM",
 	[LOCKDOWN_PERF] = "unsafe use of perf",
 	[LOCKDOWN_TRACEFS] = "use of tracefs",
+	[LOCKDOWN_XMON_RW] = "xmon read and write access",
 	[LOCKDOWN_CONFIDENTIALITY_MAX] = "confidentiality",
 };
 
-- 
2.23.0

