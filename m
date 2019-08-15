Return-Path: <SRS0=Zdp+=WL=lists.openwall.com=kernel-hardening-return-16791-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B752C31E40
	for <kernel-hardening@archiver.kernel.org>; Thu, 15 Aug 2019 05:03:40 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 936772133F
	for <kernel-hardening@archiver.kernel.org>; Thu, 15 Aug 2019 05:03:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 936772133F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=informatik.wtf
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16791-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27985 invoked by uid 550); 15 Aug 2019 05:03:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27859 invoked from network); 15 Aug 2019 05:03:06 -0000
From: "Christopher M. Riedl" <cmr@informatik.wtf>
To: linuxppc-dev@ozlabs.org,
	kernel-hardening@lists.openwall.com
Cc: Andrew Donnellan <ajd@linux.ibm.com>
Subject: [RFC PATCH v4 2/2] powerpc/xmon: Restrict when kernel is locked down
Date: Thu, 15 Aug 2019 00:06:16 -0500
Message-Id: <20190815050616.2547-3-cmr@informatik.wtf>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190815050616.2547-1-cmr@informatik.wtf>
References: <20190815050616.2547-1-cmr@informatik.wtf>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP

Xmon should be either fully or partially disabled depending on the
kernel lockdown state.

Put xmon into read-only mode for lockdown=integrity and completely
disable xmon when lockdown=confidentiality. Xmon checks the lockdown
state and takes appropriate action:

 (1) during xmon_setup to prevent early xmon'ing

 (2) when triggered via sysrq

 (3) when toggled via debugfs

 (4) when triggered via a previously enabled breakpoint

The following lockdown state transitions are handled:

 (1) lockdown=none -> lockdown=integrity
     set xmon read-only mode

 (2) lockdown=none -> lockdown=confidentiality
     clear all breakpoints, set xmon read-only mode,
     prevent re-entry into xmon

 (3) lockdown=integrity -> lockdown=confidentiality
     clear all breakpoints, set xmon read-only mode,
     prevent re-entry into xmon

Suggested-by: Andrew Donnellan <ajd@linux.ibm.com>
Signed-off-by: Christopher M. Riedl <cmr@informatik.wtf>
---
 arch/powerpc/xmon/xmon.c     | 59 ++++++++++++++++++++++++++++++++++--
 include/linux/security.h     |  2 ++
 security/lockdown/lockdown.c |  2 ++
 3 files changed, 60 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
index bb63ecc599fd..8fd79369974e 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -25,6 +25,7 @@
 #include <linux/nmi.h>
 #include <linux/ctype.h>
 #include <linux/highmem.h>
+#include <linux/security.h>
 
 #include <asm/debugfs.h>
 #include <asm/ptrace.h>
@@ -187,6 +188,9 @@ static void dump_tlb_44x(void);
 static void dump_tlb_book3e(void);
 #endif
 
+static void clear_all_bpt(void);
+static void xmon_init(int);
+
 #ifdef CONFIG_PPC64
 #define REG		"%.16lx"
 #else
@@ -283,10 +287,41 @@ Commands:\n\
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
+			xmon_on = 0;
+			xmon_init(0);
+			clear_all_bpt();
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
@@ -704,6 +739,9 @@ static int xmon_bpt(struct pt_regs *regs)
 	struct bpt *bp;
 	unsigned long offset;
 
+	if (xmon_is_locked_down())
+		return 0;
+
 	if ((regs->msr & (MSR_IR|MSR_PR|MSR_64BIT)) != (MSR_IR|MSR_64BIT))
 		return 0;
 
@@ -735,6 +773,9 @@ static int xmon_sstep(struct pt_regs *regs)
 
 static int xmon_break_match(struct pt_regs *regs)
 {
+	if (xmon_is_locked_down())
+		return 0;
+
 	if ((regs->msr & (MSR_IR|MSR_PR|MSR_64BIT)) != (MSR_IR|MSR_64BIT))
 		return 0;
 	if (dabr.enabled == 0)
@@ -745,6 +786,9 @@ static int xmon_break_match(struct pt_regs *regs)
 
 static int xmon_iabr_match(struct pt_regs *regs)
 {
+	if (xmon_is_locked_down())
+		return 0;
+
 	if ((regs->msr & (MSR_IR|MSR_PR|MSR_64BIT)) != (MSR_IR|MSR_64BIT))
 		return 0;
 	if (iabr == NULL)
@@ -3750,6 +3794,9 @@ static void xmon_init(int enable)
 #ifdef CONFIG_MAGIC_SYSRQ
 static void sysrq_handle_xmon(int key)
 {
+	if (xmon_is_locked_down())
+		return;
+
 	/* ensure xmon is enabled */
 	xmon_init(1);
 	debugger(get_irq_regs());
@@ -3771,7 +3818,6 @@ static int __init setup_xmon_sysrq(void)
 device_initcall(setup_xmon_sysrq);
 #endif /* CONFIG_MAGIC_SYSRQ */
 
-#ifdef CONFIG_DEBUG_FS
 static void clear_all_bpt(void)
 {
 	int i;
@@ -3793,8 +3839,12 @@ static void clear_all_bpt(void)
 	printf("xmon: All breakpoints cleared\n");
 }
 
+#ifdef CONFIG_DEBUG_FS
 static int xmon_dbgfs_set(void *data, u64 val)
 {
+	if (xmon_is_locked_down())
+		return 0;
+
 	xmon_on = !!val;
 	xmon_init(xmon_on);
 
@@ -3853,6 +3903,9 @@ early_param("xmon", early_parse_xmon);
 
 void __init xmon_setup(void)
 {
+	if (xmon_is_locked_down())
+		return;
+
 	if (xmon_on)
 		xmon_init(1);
 	if (xmon_early)
diff --git a/include/linux/security.h b/include/linux/security.h
index 807dc0d24982..379b74b5d545 100644
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
index f6c74cf6a798..79d1799a62ca 100644
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
2.22.0

