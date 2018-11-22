From: Russell Currey <ruscur@russell.cc>
Subject: [PATCH 4/4] powerpc/64s: Implement KUAP for Radix MMU
Date: Fri, 23 Nov 2018 01:04:16 +1100
Message-Id: <20181122140416.3447-5-ruscur@russell.cc>
In-Reply-To: <20181122140416.3447-1-ruscur@russell.cc>
References: <20181122140416.3447-1-ruscur@russell.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: linuxppc-dev@lists.ozlabs.org
Cc: mpe@ellerman.id.au, benh@kernel.crashing.org, kernel-hardening@lists.openwall.com, christophe.leroy@c-s.fr, Russell Currey <ruscur@russell.cc>
List-ID: <kernel-hardening.lists.openwall.com>

Kernel Userspace Access Prevention utilises a feature of
the Radix MMU which disallows read and write access to userspace
addresses.  By utilising this, the kernel is prevented from accessing
user data from outside of trusted paths that perform proper safety checks,
such as copy_{to/from}_user() and friends.

Userspace access is disabled from early boot and is only enabled when:

        - exiting the kernel and entering userspace
        - performing an operation like copy_{to/from}_user()
        - context switching to a process that has access enabled

and similarly, access is disabled again when exiting userspace and entering
the kernel.

This feature has a slight performance impact which I roughly measured to be
3% slower in the worst case (performing 1GB of 1 byte read()/write()
syscalls), and is gated behind the CONFIG_PPC_KUAP option for
performance-critical builds.

This feature can be tested by using the lkdtm driver (CONFIG_LKDTM=y) and
performing the following:

        echo ACCESS_USERSPACE > [debugfs]/provoke-crash/DIRECT

if enabled, this should send SIGSEGV to the thread.

Signed-off-by: Russell Currey <ruscur@russell.cc>
---
 arch/powerpc/include/asm/book3s/64/radix.h | 43 ++++++++++++++++++++++
 arch/powerpc/include/asm/exception-64e.h   |  3 ++
 arch/powerpc/include/asm/exception-64s.h   | 19 +++++++++-
 arch/powerpc/include/asm/mmu.h             |  9 ++++-
 arch/powerpc/include/asm/reg.h             |  1 +
 arch/powerpc/kernel/entry_64.S             | 16 +++++++-
 arch/powerpc/mm/pgtable-radix.c            | 12 ++++++
 arch/powerpc/mm/pkeys.c                    |  7 +++-
 arch/powerpc/platforms/Kconfig.cputype     |  1 +
 9 files changed, 105 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/radix.h b/arch/powerpc/include/asm/book3s/64/radix.h
index 7d1a3d1543fc..9af93d05e6fa 100644
--- a/arch/powerpc/include/asm/book3s/64/radix.h
+++ b/arch/powerpc/include/asm/book3s/64/radix.h
@@ -284,5 +284,48 @@ static inline unsigned long radix__get_tree_size(void)
 int radix__create_section_mapping(unsigned long start, unsigned long end, int nid);
 int radix__remove_section_mapping(unsigned long start, unsigned long end);
 #endif /* CONFIG_MEMORY_HOTPLUG */
+
+#ifdef CONFIG_PPC_KUAP
+#include <asm/reg.h>
+/*
+ * We do have the ability to individually lock/unlock reads and writes rather
+ * than both at once, however it's a significant performance hit due to needing
+ * to do a read-modify-write, which adds a mfspr, which is slow.  As a result,
+ * locking/unlocking both at once is preferred.
+ */
+static inline void __unlock_user_rd_access(void)
+{
+	if (!mmu_has_feature(MMU_FTR_RADIX_KUAP))
+		return;
+
+	mtspr(SPRN_AMR, 0);
+	isync();
+}
+
+static inline void __lock_user_rd_access(void)
+{
+	if (!mmu_has_feature(MMU_FTR_RADIX_KUAP))
+		return;
+
+	mtspr(SPRN_AMR, AMR_LOCKED);
+}
+
+static inline void __unlock_user_wr_access(void)
+{
+	if (!mmu_has_feature(MMU_FTR_RADIX_KUAP))
+		return;
+
+	mtspr(SPRN_AMR, 0);
+	isync();
+}
+
+static inline void __lock_user_wr_access(void)
+{
+	if (!mmu_has_feature(MMU_FTR_RADIX_KUAP))
+		return;
+
+	mtspr(SPRN_AMR, AMR_LOCKED);
+}
+#endif /* CONFIG_PPC_KUAP */
 #endif /* __ASSEMBLY__ */
 #endif
diff --git a/arch/powerpc/include/asm/exception-64e.h b/arch/powerpc/include/asm/exception-64e.h
index 555e22d5e07f..bf25015834ee 100644
--- a/arch/powerpc/include/asm/exception-64e.h
+++ b/arch/powerpc/include/asm/exception-64e.h
@@ -215,5 +215,8 @@ exc_##label##_book3e:
 #define RFI_TO_USER							\
 	rfi
 
+#define UNLOCK_USER_ACCESS(reg)
+#define LOCK_USER_ACCESS(reg)
+
 #endif /* _ASM_POWERPC_EXCEPTION_64E_H */
 
diff --git a/arch/powerpc/include/asm/exception-64s.h b/arch/powerpc/include/asm/exception-64s.h
index 3b4767ed3ec5..d92614c66d87 100644
--- a/arch/powerpc/include/asm/exception-64s.h
+++ b/arch/powerpc/include/asm/exception-64s.h
@@ -264,6 +264,19 @@ BEGIN_FTR_SECTION_NESTED(943)						\
 	std	ra,offset(r13);						\
 END_FTR_SECTION_NESTED(ftr,ftr,943)
 
+#define LOCK_USER_ACCESS(reg)							\
+BEGIN_MMU_FTR_SECTION_NESTED(944)					\
+	LOAD_REG_IMMEDIATE(reg,AMR_LOCKED);				\
+	mtspr	SPRN_AMR,reg;						\
+END_MMU_FTR_SECTION_NESTED(MMU_FTR_RADIX_KUAP,MMU_FTR_RADIX_KUAP,944)
+
+#define UNLOCK_USER_ACCESS(reg)							\
+BEGIN_MMU_FTR_SECTION_NESTED(945)					\
+	li	reg,0;							\
+	mtspr	SPRN_AMR,reg;						\
+	isync;								\
+END_MMU_FTR_SECTION_NESTED(MMU_FTR_RADIX_KUAP,MMU_FTR_RADIX_KUAP,945)
+
 #define EXCEPTION_PROLOG_0(area)					\
 	GET_PACA(r13);							\
 	std	r9,area+EX_R9(r13);	/* save r9 */			\
@@ -500,7 +513,11 @@ END_FTR_SECTION_NESTED(ftr,ftr,943)
 	beq	4f;			/* if from kernel mode		*/ \
 	ACCOUNT_CPU_USER_ENTRY(r13, r9, r10);				   \
 	SAVE_PPR(area, r9);						   \
-4:	EXCEPTION_PROLOG_COMMON_2(area)					   \
+4:	lbz	r9,PACA_USER_ACCESS_ALLOWED(r13);			   \
+	cmpwi	cr1,r9,0;						   \
+	beq	5f;							   \
+	LOCK_USER_ACCESS(r9);						   \
+5:	EXCEPTION_PROLOG_COMMON_2(area)					\
 	EXCEPTION_PROLOG_COMMON_3(n)					   \
 	ACCOUNT_STOLEN_TIME
 
diff --git a/arch/powerpc/include/asm/mmu.h b/arch/powerpc/include/asm/mmu.h
index 5631a906af55..a1450d56d0db 100644
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
@@ -143,7 +147,10 @@ enum {
 		MMU_FTR_KERNEL_RO | MMU_FTR_68_BIT_VA |
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
index de52c3166ba4..d9598e6790d8 100644
--- a/arch/powerpc/include/asm/reg.h
+++ b/arch/powerpc/include/asm/reg.h
@@ -246,6 +246,7 @@
 #define SPRN_DSCR	0x11
 #define SPRN_CFAR	0x1c	/* Come From Address Register */
 #define SPRN_AMR	0x1d	/* Authority Mask Register */
+#define   AMR_LOCKED	0xC000000000000000UL /* Read & Write disabled */
 #define SPRN_UAMOR	0x9d	/* User Authority Mask Override Register */
 #define SPRN_AMOR	0x15d	/* Authority Mask Override Register */
 #define SPRN_ACOP	0x1F	/* Available Coprocessor Register */
diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index 7b1693adff2a..d5879f32bd34 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -297,7 +297,12 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
 	b	.	/* prevent speculative execution */
 
 	/* exit to kernel */
-1:	ld	r2,GPR2(r1)
+1:	/* if the AMR was unlocked before, unlock it again */
+	lbz	r2,PACA_USER_ACCESS_ALLOWED(r13)
+	cmpwi	cr1,0
+	bne	2f
+	UNLOCK_USER_ACCESS(r2)
+2:	ld	r2,GPR2(r1)
 	ld	r1,GPR1(r1)
 	mtlr	r4
 	mtcr	r5
@@ -983,7 +988,14 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
 	RFI_TO_USER
 	b	.	/* prevent speculative execution */
 
-1:	mtspr	SPRN_SRR1,r3
+1:	/* exit to kernel */
+	/* if the AMR was unlocked before, unlock it again */
+	lbz	r2,PACA_USER_ACCESS_ALLOWED(r13)
+	cmpwi	cr1,0
+	bne	2f
+	UNLOCK_USER_ACCESS(r2)
+
+2:	mtspr	SPRN_SRR1,r3
 
 	ld	r2,_CCR(r1)
 	mtcrf	0xFF,r2
diff --git a/arch/powerpc/mm/pgtable-radix.c b/arch/powerpc/mm/pgtable-radix.c
index f08a459b4255..b064b542e09f 100644
--- a/arch/powerpc/mm/pgtable-radix.c
+++ b/arch/powerpc/mm/pgtable-radix.c
@@ -29,6 +29,7 @@
 #include <asm/powernv.h>
 #include <asm/sections.h>
 #include <asm/trace.h>
+#include <asm/uaccess.h>
 
 #include <trace/events/thp.h>
 
@@ -550,6 +551,17 @@ void setup_kuep(bool disabled)
 	mtspr(SPRN_IAMR, (1ul << 62));
 }
 
+void setup_kuap(bool disabled)
+{
+	if (disabled)
+		return;
+
+	pr_warn("Activating Kernel Userspace Access Prevention\n");
+
+	cur_cpu_spec->mmu_features |= MMU_FTR_RADIX_KUAP;
+	mtspr(SPRN_AMR, AMR_LOCKED);
+}
+
 void __init radix__early_init_mmu(void)
 {
 	unsigned long lpcr;
diff --git a/arch/powerpc/mm/pkeys.c b/arch/powerpc/mm/pkeys.c
index b271b283c785..bb3cf915016f 100644
--- a/arch/powerpc/mm/pkeys.c
+++ b/arch/powerpc/mm/pkeys.c
@@ -7,6 +7,7 @@
 
 #include <asm/mman.h>
 #include <asm/setup.h>
+#include <asm/uaccess.h>
 #include <linux/pkeys.h>
 #include <linux/of_device.h>
 
@@ -266,7 +267,8 @@ int __arch_set_user_pkey_access(struct task_struct *tsk, int pkey,
 
 void thread_pkey_regs_save(struct thread_struct *thread)
 {
-	if (static_branch_likely(&pkey_disabled))
+	if (static_branch_likely(&pkey_disabled) &&
+	    !mmu_has_feature(MMU_FTR_RADIX_KUAP))
 		return;
 
 	/*
@@ -280,7 +282,8 @@ void thread_pkey_regs_save(struct thread_struct *thread)
 void thread_pkey_regs_restore(struct thread_struct *new_thread,
 			      struct thread_struct *old_thread)
 {
-	if (static_branch_likely(&pkey_disabled))
+	if (static_branch_likely(&pkey_disabled) &&
+	    !mmu_has_feature(MMU_FTR_RADIX_KUAP))
 		return;
 
 	if (old_thread->amr != new_thread->amr)
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index e6831d0ec159..5fbfa041194d 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -335,6 +335,7 @@ config PPC_RADIX_MMU
 	depends on PPC_BOOK3S_64
 	select ARCH_HAS_GIGANTIC_PAGE if (MEMORY_ISOLATION && COMPACTION) || CMA
 	select PPC_HAVE_KUEP
+	select PPC_HAVE_KUAP
 	default y
 	help
 	  Enable support for the Power ISA 3.0 Radix style MMU. Currently this
-- 
2.19.1
