From: Russell Currey <ruscur@russell.cc>
Subject: [PATCH 7/7] powerpc/64s: Implement KUAP for Radix MMU
Date: Thu, 21 Feb 2019 20:36:01 +1100
Message-Id: <20190221093601.27920-8-ruscur@russell.cc>
In-Reply-To: <20190221093601.27920-1-ruscur@russell.cc>
References: <20190221093601.27920-1-ruscur@russell.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: linuxppc-dev@lists.ozlabs.org
Cc: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@c-s.fr, kernel-hardening@lists.openwall.com, Russell Currey <ruscur@russell.cc>
List-ID: <kernel-hardening.lists.openwall.com>

Kernel Userspace Access Prevention utilises a feature of the Radix MMU
which disallows read and write access to userspace addresses. By
utilising this, the kernel is prevented from accessing user data from
outside of trusted paths that perform proper safety checks, such as
copy_{to/from}_user() and friends.

Userspace access is disabled from early boot and is only enabled when
performing an operation like copy_{to/from}_user().  The register that
controls this (AMR) does not prevent userspace from accessing other
userspace, so there is no need to save and restore when entering and
exiting userspace.

This feature has a slight performance impact which I roughly measured
to be 3% slower in the worst case (performing 1GB of 1 byte
read()/write() syscalls), and is gated behind the CONFIG_PPC_KUAP
option for performance-critical builds.

This feature can be tested by using the lkdtm driver (CONFIG_LKDTM=y)
and performing the following:

  # (echo ACCESS_USERSPACE) > [debugfs]/provoke-crash/DIRECT

If enabled, this should send SIGSEGV to the thread.

A big limitation of the current implementation is that user access
is left unlocked if an exception is taken while user access is unlocked
(i.e. if an interrupt is taken during copy_to_user()). This should be
resolved in future, and is why the state is tracked in the PACA even
though nothing currently uses it.

Signed-off-by: Russell Currey <ruscur@russell.cc>
---
 .../powerpc/include/asm/book3s/64/kup-radix.h | 36 +++++++++++++++++++
 arch/powerpc/include/asm/kup.h                |  4 +++
 arch/powerpc/include/asm/mmu.h                |  9 ++++-
 arch/powerpc/include/asm/reg.h                |  1 +
 arch/powerpc/mm/pgtable-radix.c               | 16 +++++++++
 arch/powerpc/mm/pkeys.c                       |  7 ++--
 arch/powerpc/platforms/Kconfig.cputype        |  1 +
 7 files changed, 71 insertions(+), 3 deletions(-)
 create mode 100644 arch/powerpc/include/asm/book3s/64/kup-radix.h

diff --git a/arch/powerpc/include/asm/book3s/64/kup-radix.h b/arch/powerpc/include/asm/book3s/64/kup-radix.h
new file mode 100644
index 000000000000..5cfdea954418
--- /dev/null
+++ b/arch/powerpc/include/asm/book3s/64/kup-radix.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_POWERPC_KUP_RADIX_H
+#define _ASM_POWERPC_KUP_RADIX_H
+
+#ifndef __ASSEMBLY__
+#ifdef CONFIG_PPC_KUAP
+#include <asm/reg.h>
+/*
+ * We do have the ability to individually lock/unlock reads and writes rather
+ * than both at once, however it's a significant performance hit due to needing
+ * to do a read-modify-write, which adds a mfspr, which is slow.  As a result,
+ * locking/unlocking both at once is preferred.
+ */
+static inline void unlock_user_access(void __user *to, const void __user *from,
+				      unsigned long size)
+{
+	if (!mmu_has_feature(MMU_FTR_RADIX_KUAP))
+		return;
+
+	mtspr(SPRN_AMR, 0);
+	isync();
+	get_paca()->user_access_allowed = 1;
+}
+
+static inline void lock_user_access(void __user *to, const void __user *from,
+				    unsigned long size)
+{
+	if (!mmu_has_feature(MMU_FTR_RADIX_KUAP))
+		return;
+
+	mtspr(SPRN_AMR, RADIX_AMR_LOCKED);
+	get_paca()->user_access_allowed = 0;
+}
+#endif /* CONFIG_PPC_KUAP */
+#endif /* __ASSEMBLY__ */
+#endif
diff --git a/arch/powerpc/include/asm/kup.h b/arch/powerpc/include/asm/kup.h
index 2ac540fb488f..af583fd5a027 100644
--- a/arch/powerpc/include/asm/kup.h
+++ b/arch/powerpc/include/asm/kup.h
@@ -2,6 +2,10 @@
 #ifndef _ASM_POWERPC_KUP_H_
 #define _ASM_POWERPC_KUP_H_
 
+#ifdef CONFIG_PPC_BOOK3S_64
+#include <asm/book3s/64/kup-radix.h>
+#endif
+
 #ifndef __ASSEMBLY__
 
 #include <asm/pgtable.h>
diff --git a/arch/powerpc/include/asm/mmu.h b/arch/powerpc/include/asm/mmu.h
index 25607604a7a5..ea703de9be9b 100644
--- a/arch/powerpc/include/asm/mmu.h
+++ b/arch/powerpc/include/asm/mmu.h
@@ -107,6 +107,10 @@
  */
 #define MMU_FTR_1T_SEGMENT		ASM_CONST(0x40000000)
 
+/* Supports KUAP (key 0 controlling userspace addresses) on radix
+ */
+#define MMU_FTR_RADIX_KUAP		ASM_CONST(0x80000000)
+
 /* MMU feature bit sets for various CPUs */
 #define MMU_FTRS_DEFAULT_HPTE_ARCH_V2	\
 	MMU_FTR_HPTE_TABLE | MMU_FTR_PPCAS_ARCH_V2
@@ -164,7 +168,10 @@ enum {
 #endif
 #ifdef CONFIG_PPC_RADIX_MMU
 		MMU_FTR_TYPE_RADIX |
-#endif
+#ifdef CONFIG_PPC_KUAP
+		MMU_FTR_RADIX_KUAP |
+#endif /* CONFIG_PPC_KUAP */
+#endif /* CONFIG_PPC_RADIX_MMU */
 		0,
 };
 
diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
index 1c98ef1f2d5b..0e789e2c5bc3 100644
--- a/arch/powerpc/include/asm/reg.h
+++ b/arch/powerpc/include/asm/reg.h
@@ -246,6 +246,7 @@
 #define SPRN_DSCR	0x11
 #define SPRN_CFAR	0x1c	/* Come From Address Register */
 #define SPRN_AMR	0x1d	/* Authority Mask Register */
+#define   RADIX_AMR_LOCKED	0xC000000000000000UL /* Read & Write disabled */
 #define SPRN_UAMOR	0x9d	/* User Authority Mask Override Register */
 #define SPRN_AMOR	0x15d	/* Authority Mask Override Register */
 #define SPRN_ACOP	0x1F	/* Available Coprocessor Register */
diff --git a/arch/powerpc/mm/pgtable-radix.c b/arch/powerpc/mm/pgtable-radix.c
index 224bcd4be5ae..b621cef4825e 100644
--- a/arch/powerpc/mm/pgtable-radix.c
+++ b/arch/powerpc/mm/pgtable-radix.c
@@ -29,6 +29,7 @@
 #include <asm/powernv.h>
 #include <asm/sections.h>
 #include <asm/trace.h>
+#include <asm/uaccess.h>
 
 #include <trace/events/thp.h>
 
@@ -553,6 +554,21 @@ void __init setup_kuep(bool disabled)
 }
 #endif
 
+#ifdef CONFIG_PPC_KUAP
+void __init setup_kuap(bool disabled)
+{
+	if (disabled || !early_radix_enabled())
+		return;
+
+	if (smp_processor_id() == boot_cpuid) {
+		pr_info("Activating Kernel Userspace Access Prevention\n");
+		cur_cpu_spec->mmu_features |= MMU_FTR_RADIX_KUAP;
+	}
+
+	mtspr(SPRN_AMR, RADIX_AMR_LOCKED);
+}
+#endif
+
 void __init radix__early_init_mmu(void)
 {
 	unsigned long lpcr;
diff --git a/arch/powerpc/mm/pkeys.c b/arch/powerpc/mm/pkeys.c
index 587807763737..2223f4b4b1bf 100644
--- a/arch/powerpc/mm/pkeys.c
+++ b/arch/powerpc/mm/pkeys.c
@@ -7,6 +7,7 @@
 
 #include <asm/mman.h>
 #include <asm/mmu_context.h>
+#include <asm/mmu.h>
 #include <asm/setup.h>
 #include <linux/pkeys.h>
 #include <linux/of_device.h>
@@ -267,7 +268,8 @@ int __arch_set_user_pkey_access(struct task_struct *tsk, int pkey,
 
 void thread_pkey_regs_save(struct thread_struct *thread)
 {
-	if (static_branch_likely(&pkey_disabled))
+	if (static_branch_likely(&pkey_disabled) &&
+	    !mmu_has_feature(MMU_FTR_RADIX_KUAP))
 		return;
 
 	/*
@@ -281,7 +283,8 @@ void thread_pkey_regs_save(struct thread_struct *thread)
 void thread_pkey_regs_restore(struct thread_struct *new_thread,
 			      struct thread_struct *old_thread)
 {
-	if (static_branch_likely(&pkey_disabled))
+	if (static_branch_likely(&pkey_disabled) &&
+	    !mmu_has_feature(MMU_FTR_RADIX_KUAP))
 		return;
 
 	if (old_thread->amr != new_thread->amr)
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index 25cc7d36b27d..67b2ed9bb9f3 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -321,6 +321,7 @@ config PPC_RADIX_MMU
 	depends on PPC_BOOK3S_64
 	select ARCH_HAS_GIGANTIC_PAGE if (MEMORY_ISOLATION && COMPACTION) || CMA
 	select PPC_HAVE_KUEP
+	select PPC_HAVE_KUAP
 	default y
 	help
 	  Enable support for the Power ISA 3.0 Radix style MMU. Currently this
-- 
2.20.1
