From: "Christopher M. Riedl" <cmr@informatik.wtf>
Subject: [RFC PATCH v2] powerpc/xmon: restrict when kernel is locked down
Date: Fri, 24 May 2019 07:38:18 -0500
Message-Id: <20190524123816.1773-1-cmr@informatik.wtf>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: linuxppc-dev@ozlabs.org, kernel-hardening@lists.openwall.com
Cc: ajd@linux.ibm.com, mjg59@google.com, dja@axtens.net, "Christopher M. Riedl" <cmr@informatik.wtf>
List-ID: <kernel-hardening.lists.openwall.com>

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
     clear all breakpoints, set xmon read-only mode

 (2) lockdown=none -> lockdown=confidentiality
     clear all breakpoints, prevent re-entry into xmon

 (3) lockdown=integrity -> lockdown=confidentiality
     prevent re-entry into xmon

Suggested-by: Andrew Donnellan <ajd@linux.ibm.com>
Signed-off-by: Christopher M. Riedl <cmr@informatik.wtf>
---

Applies on top of this series:
	https://patchwork.kernel.org/cover/10884631/

I've done some limited testing of the scenarios mentioned in the commit
message on a single CPU QEMU config.

v1->v2:
	Fix subject line
	Submit to linuxppc-dev and kernel-hardening

 arch/powerpc/xmon/xmon.c | 56 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 55 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
index 3e7be19aa208..8c4a5a0c28f0 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -191,6 +191,9 @@ static void dump_tlb_44x(void);
 static void dump_tlb_book3e(void);
 #endif
 
+static void clear_all_bpt(void);
+static void xmon_init(int);
+
 #ifdef CONFIG_PPC64
 #define REG		"%.16lx"
 #else
@@ -291,6 +294,39 @@ Commands:\n\
   zh	halt\n"
 ;
 
+#ifdef CONFIG_LOCK_DOWN_KERNEL
+static bool xmon_check_lockdown(void)
+{
+	static bool lockdown = false;
+
+	if (!lockdown) {
+		lockdown = kernel_is_locked_down("Using xmon",
+						 LOCKDOWN_CONFIDENTIALITY);
+		if (lockdown) {
+			printf("xmon: Disabled by strict kernel lockdown\n");
+			xmon_on = 0;
+			xmon_init(0);
+		}
+	}
+
+	if (!xmon_is_ro) {
+		xmon_is_ro = kernel_is_locked_down("Using xmon write-access",
+						   LOCKDOWN_INTEGRITY);
+		if (xmon_is_ro) {
+			printf("xmon: Read-only due to kernel lockdown\n");
+			clear_all_bpt();
+		}
+	}
+
+	return lockdown;
+}
+#else
+inline static bool xmon_check_lockdown(void)
+{
+	return false;
+}
+#endif /* CONFIG_LOCK_DOWN_KERNEL */
+
 static struct pt_regs *xmon_regs;
 
 static inline void sync(void)
@@ -708,6 +744,9 @@ static int xmon_bpt(struct pt_regs *regs)
 	struct bpt *bp;
 	unsigned long offset;
 
+	if (xmon_check_lockdown())
+		return 0;
+
 	if ((regs->msr & (MSR_IR|MSR_PR|MSR_64BIT)) != (MSR_IR|MSR_64BIT))
 		return 0;
 
@@ -739,6 +778,9 @@ static int xmon_sstep(struct pt_regs *regs)
 
 static int xmon_break_match(struct pt_regs *regs)
 {
+	if (xmon_check_lockdown())
+		return 0;
+
 	if ((regs->msr & (MSR_IR|MSR_PR|MSR_64BIT)) != (MSR_IR|MSR_64BIT))
 		return 0;
 	if (dabr.enabled == 0)
@@ -749,6 +791,9 @@ static int xmon_break_match(struct pt_regs *regs)
 
 static int xmon_iabr_match(struct pt_regs *regs)
 {
+	if (xmon_check_lockdown())
+		return 0;
+
 	if ((regs->msr & (MSR_IR|MSR_PR|MSR_64BIT)) != (MSR_IR|MSR_64BIT))
 		return 0;
 	if (iabr == NULL)
@@ -3742,6 +3787,9 @@ static void xmon_init(int enable)
 #ifdef CONFIG_MAGIC_SYSRQ
 static void sysrq_handle_xmon(int key)
 {
+	if (xmon_check_lockdown())
+		return;
+
 	/* ensure xmon is enabled */
 	xmon_init(1);
 	debugger(get_irq_regs());
@@ -3763,7 +3811,6 @@ static int __init setup_xmon_sysrq(void)
 device_initcall(setup_xmon_sysrq);
 #endif /* CONFIG_MAGIC_SYSRQ */
 
-#ifdef CONFIG_DEBUG_FS
 static void clear_all_bpt(void)
 {
 	int i;
@@ -3785,8 +3832,12 @@ static void clear_all_bpt(void)
 	printf("xmon: All breakpoints cleared\n");
 }
 
+#ifdef CONFIG_DEBUG_FS
 static int xmon_dbgfs_set(void *data, u64 val)
 {
+	if (xmon_check_lockdown())
+		return 0;
+
 	xmon_on = !!val;
 	xmon_init(xmon_on);
 
@@ -3845,6 +3896,9 @@ early_param("xmon", early_parse_xmon);
 
 void __init xmon_setup(void)
 {
+	if (xmon_check_lockdown())
+		return;
+
 	if (xmon_on)
 		xmon_init(1);
 	if (xmon_early)
-- 
2.21.0
