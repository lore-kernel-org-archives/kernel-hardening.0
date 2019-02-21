From: Russell Currey <ruscur@russell.cc>
Subject: [PATCH 3/7] powerpc/mm: Add a framework for Kernel Userspace Access Protection
Date: Thu, 21 Feb 2019 20:35:57 +1100
Message-Id: <20190221093601.27920-4-ruscur@russell.cc>
In-Reply-To: <20190221093601.27920-1-ruscur@russell.cc>
References: <20190221093601.27920-1-ruscur@russell.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: linuxppc-dev@lists.ozlabs.org
Cc: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@c-s.fr, kernel-hardening@lists.openwall.com, Russell Currey <ruscur@russell.cc>
List-ID: <kernel-hardening.lists.openwall.com>

From: Christophe Leroy <christophe.leroy@c-s.fr>

This patch implements a framework for Kernel Userspace Access
Protection.

Then subarches will have to possibility to provide their own
implementation by providing setup_kuap() and lock/unlock_user_access()

Some platform will need to know the area accessed and whether it is
accessed from read, write or both. Therefore source, destination and
size and handed over to the two functions.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
[ruscur: remove 64-bit exception handling code]
Signed-off-by: Russell Currey <ruscur@russell.cc>
---
 .../admin-guide/kernel-parameters.txt         |  2 +-
 arch/powerpc/include/asm/exception-64e.h      |  3 ++
 arch/powerpc/include/asm/exception-64s.h      |  3 ++
 arch/powerpc/include/asm/futex.h              |  4 ++
 arch/powerpc/include/asm/kup.h                | 21 ++++++++++
 arch/powerpc/include/asm/paca.h               |  3 ++
 arch/powerpc/include/asm/processor.h          |  3 ++
 arch/powerpc/include/asm/ptrace.h             |  3 ++
 arch/powerpc/include/asm/uaccess.h            | 38 +++++++++++++++----
 arch/powerpc/kernel/asm-offsets.c             |  7 ++++
 arch/powerpc/kernel/entry_32.S                |  8 +++-
 arch/powerpc/kernel/process.c                 |  3 ++
 arch/powerpc/lib/checksum_wrappers.c          |  4 ++
 arch/powerpc/mm/fault.c                       | 17 +++++++--
 arch/powerpc/mm/init-common.c                 | 10 +++++
 arch/powerpc/platforms/Kconfig.cputype        | 12 ++++++
 16 files changed, 127 insertions(+), 14 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 8448a56a9eb9..0a76dbb39011 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2808,7 +2808,7 @@
 			noexec=on: enable non-executable mappings (default)
 			noexec=off: disable non-executable mappings
 
-	nosmap		[X86]
+	nosmap		[X86,PPC]
 			Disable SMAP (Supervisor Mode Access Prevention)
 			even if it is supported by processor.
 
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
index 3b4767ed3ec5..8ae2d7855cfe 100644
--- a/arch/powerpc/include/asm/exception-64s.h
+++ b/arch/powerpc/include/asm/exception-64s.h
@@ -264,6 +264,9 @@ BEGIN_FTR_SECTION_NESTED(943)						\
 	std	ra,offset(r13);						\
 END_FTR_SECTION_NESTED(ftr,ftr,943)
 
+#define UNLOCK_USER_ACCESS(reg)
+#define LOCK_USER_ACCESS(reg)
+
 #define EXCEPTION_PROLOG_0(area)					\
 	GET_PACA(r13);							\
 	std	r9,area+EX_R9(r13);	/* save r9 */			\
diff --git a/arch/powerpc/include/asm/futex.h b/arch/powerpc/include/asm/futex.h
index 88b38b37c21b..f85facf3739b 100644
--- a/arch/powerpc/include/asm/futex.h
+++ b/arch/powerpc/include/asm/futex.h
@@ -35,6 +35,7 @@ static inline int arch_futex_atomic_op_inuser(int op, int oparg, int *oval,
 {
 	int oldval = 0, ret;
 
+	unlock_user_access(uaddr, NULL, sizeof(*uaddr));
 	pagefault_disable();
 
 	switch (op) {
@@ -62,6 +63,7 @@ static inline int arch_futex_atomic_op_inuser(int op, int oparg, int *oval,
 	if (!ret)
 		*oval = oldval;
 
+	lock_user_access(uaddr, NULL, sizeof(*uaddr));
 	return ret;
 }
 
@@ -75,6 +77,7 @@ futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
 	if (!access_ok(uaddr, sizeof(u32)))
 		return -EFAULT;
 
+	unlock_user_access(uaddr, NULL, sizeof(*uaddr));
         __asm__ __volatile__ (
         PPC_ATOMIC_ENTRY_BARRIER
 "1:     lwarx   %1,0,%3         # futex_atomic_cmpxchg_inatomic\n\
@@ -95,6 +98,7 @@ futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
         : "cc", "memory");
 
 	*uval = prev;
+	lock_user_access(uaddr, NULL, sizeof(*uaddr));
         return ret;
 }
 
diff --git a/arch/powerpc/include/asm/kup.h b/arch/powerpc/include/asm/kup.h
index af4b5f854ca4..2ac540fb488f 100644
--- a/arch/powerpc/include/asm/kup.h
+++ b/arch/powerpc/include/asm/kup.h
@@ -4,6 +4,8 @@
 
 #ifndef __ASSEMBLY__
 
+#include <asm/pgtable.h>
+
 void setup_kup(void);
 
 #ifdef CONFIG_PPC_KUEP
@@ -12,6 +14,25 @@ void setup_kuep(bool disabled);
 static inline void setup_kuep(bool disabled) { }
 #endif
 
+#ifdef CONFIG_PPC_KUAP
+void setup_kuap(bool disabled);
+#else
+static inline void setup_kuap(bool disabled) { }
+static inline void unlock_user_access(void __user *to, const void __user *from,
+				      unsigned long size) { }
+static inline void lock_user_access(void __user *to, const void __user *from,
+				    unsigned long size) { }
+#endif
+
 #endif /* !__ASSEMBLY__ */
 
+#ifndef CONFIG_PPC_KUAP
+
+#ifdef CONFIG_PPC32
+#define LOCK_USER_ACCESS(val, sp, sr, srmax, curr)
+#define REST_USER_ACCESS(val, sp, sr, srmax, curr)
+#endif
+
+#endif
+
 #endif /* _ASM_POWERPC_KUP_H_ */
diff --git a/arch/powerpc/include/asm/paca.h b/arch/powerpc/include/asm/paca.h
index e843bc5d1a0f..56236f6d8c89 100644
--- a/arch/powerpc/include/asm/paca.h
+++ b/arch/powerpc/include/asm/paca.h
@@ -169,6 +169,9 @@ struct paca_struct {
 	u64 saved_r1;			/* r1 save for RTAS calls or PM or EE=0 */
 	u64 saved_msr;			/* MSR saved here by enter_rtas */
 	u16 trap_save;			/* Used when bad stack is encountered */
+#ifdef CONFIG_PPC_KUAP
+	u8 user_access_allowed;		/* can the kernel access user memory? */
+#endif
 	u8 irq_soft_mask;		/* mask for irq soft masking */
 	u8 irq_happened;		/* irq happened while soft-disabled */
 	u8 io_sync;			/* writel() needs spin_unlock sync */
diff --git a/arch/powerpc/include/asm/processor.h b/arch/powerpc/include/asm/processor.h
index ee58526cb6c2..4a9a10e86828 100644
--- a/arch/powerpc/include/asm/processor.h
+++ b/arch/powerpc/include/asm/processor.h
@@ -250,6 +250,9 @@ struct thread_struct {
 #ifdef CONFIG_PPC32
 	void		*pgdir;		/* root of page-table tree */
 	unsigned long	ksp_limit;	/* if ksp <= ksp_limit stack overflow */
+#ifdef CONFIG_PPC_KUAP
+	unsigned long	kuap;		/* state of user access protection */
+#endif
 #endif
 	/* Debug Registers */
 	struct debug_reg debug;
diff --git a/arch/powerpc/include/asm/ptrace.h b/arch/powerpc/include/asm/ptrace.h
index 0b8a735b6d85..0321ba5b3d12 100644
--- a/arch/powerpc/include/asm/ptrace.h
+++ b/arch/powerpc/include/asm/ptrace.h
@@ -55,6 +55,9 @@ struct pt_regs
 #ifdef CONFIG_PPC64
 	unsigned long ppr;
 	unsigned long __pad;	/* Maintain 16 byte interrupt stack alignment */
+#elif defined(CONFIG_PPC_KUAP)
+	unsigned long kuap;
+	unsigned long __pad[3];	/* Maintain 16 byte interrupt stack alignment */
 #endif
 };
 #endif
diff --git a/arch/powerpc/include/asm/uaccess.h b/arch/powerpc/include/asm/uaccess.h
index e3a731793ea2..9db6a4c7c058 100644
--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -6,6 +6,7 @@
 #include <asm/processor.h>
 #include <asm/page.h>
 #include <asm/extable.h>
+#include <asm/kup.h>
 
 /*
  * The fs value determines whether argument validity checking should be
@@ -141,6 +142,7 @@ extern long __put_user_bad(void);
 #define __put_user_size(x, ptr, size, retval)			\
 do {								\
 	retval = 0;						\
+	unlock_user_access(ptr, NULL, size);			\
 	switch (size) {						\
 	  case 1: __put_user_asm(x, ptr, retval, "stb"); break;	\
 	  case 2: __put_user_asm(x, ptr, retval, "sth"); break;	\
@@ -148,6 +150,7 @@ do {								\
 	  case 8: __put_user_asm2(x, ptr, retval); break;	\
 	  default: __put_user_bad();				\
 	}							\
+	lock_user_access(ptr, NULL, size);			\
 } while (0)
 
 #define __put_user_nocheck(x, ptr, size)			\
@@ -240,6 +243,7 @@ do {								\
 	__chk_user_ptr(ptr);					\
 	if (size > sizeof(x))					\
 		(x) = __get_user_bad();				\
+	unlock_user_access(NULL, ptr, size);			\
 	switch (size) {						\
 	case 1: __get_user_asm(x, ptr, retval, "lbz"); break;	\
 	case 2: __get_user_asm(x, ptr, retval, "lhz"); break;	\
@@ -247,6 +251,7 @@ do {								\
 	case 8: __get_user_asm2(x, ptr, retval);  break;	\
 	default: (x) = __get_user_bad();			\
 	}							\
+	lock_user_access(NULL, ptr, size);			\
 } while (0)
 
 /*
@@ -306,15 +311,21 @@ extern unsigned long __copy_tofrom_user(void __user *to,
 static inline unsigned long
 raw_copy_in_user(void __user *to, const void __user *from, unsigned long n)
 {
-	return __copy_tofrom_user(to, from, n);
+	unsigned long ret;
+
+	unlock_user_access(to, from, n);
+	ret = __copy_tofrom_user(to, from, n);
+	lock_user_access(to, from, n);
+	return ret;
 }
 #endif /* __powerpc64__ */
 
 static inline unsigned long raw_copy_from_user(void *to,
 		const void __user *from, unsigned long n)
 {
+	unsigned long ret;
 	if (__builtin_constant_p(n) && (n <= 8)) {
-		unsigned long ret = 1;
+		ret = 1;
 
 		switch (n) {
 		case 1:
@@ -339,14 +350,18 @@ static inline unsigned long raw_copy_from_user(void *to,
 	}
 
 	barrier_nospec();
-	return __copy_tofrom_user((__force void __user *)to, from, n);
+	unlock_user_access(NULL, from, n);
+	ret = __copy_tofrom_user((__force void __user *)to, from, n);
+	lock_user_access(NULL, from, n);
+	return ret;
 }
 
 static inline unsigned long raw_copy_to_user(void __user *to,
 		const void *from, unsigned long n)
 {
+	unsigned long ret;
 	if (__builtin_constant_p(n) && (n <= 8)) {
-		unsigned long ret = 1;
+		ret = 1;
 
 		switch (n) {
 		case 1:
@@ -366,17 +381,24 @@ static inline unsigned long raw_copy_to_user(void __user *to,
 			return 0;
 	}
 
-	return __copy_tofrom_user(to, (__force const void __user *)from, n);
+	unlock_user_access(to, NULL, n);
+	ret = __copy_tofrom_user(to, (__force const void __user *)from, n);
+	lock_user_access(to, NULL, n);
+	return ret;
 }
 
 extern unsigned long __clear_user(void __user *addr, unsigned long size);
 
 static inline unsigned long clear_user(void __user *addr, unsigned long size)
 {
+	unsigned long ret = size;
 	might_fault();
-	if (likely(access_ok(addr, size)))
-		return __clear_user(addr, size);
-	return size;
+	if (likely(access_ok(addr, size))) {
+		unlock_user_access(addr, NULL, size);
+		ret = __clear_user(addr, size);
+		lock_user_access(addr, NULL, size);
+	}
+	return ret;
 }
 
 extern long strncpy_from_user(char *dst, const char __user *src, long count);
diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index 9ffc72ded73a..98e94299e728 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -93,6 +93,9 @@ int main(void)
 	OFFSET(THREAD_INFO, task_struct, stack);
 	DEFINE(THREAD_INFO_GAP, _ALIGN_UP(sizeof(struct thread_info), 16));
 	OFFSET(KSP_LIMIT, thread_struct, ksp_limit);
+#ifdef CONFIG_PPC_KUAP
+	OFFSET(KUAP, thread_struct, kuap);
+#endif
 #endif /* CONFIG_PPC64 */
 
 #ifdef CONFIG_LIVEPATCH
@@ -260,6 +263,7 @@ int main(void)
 	OFFSET(ACCOUNT_STARTTIME_USER, paca_struct, accounting.starttime_user);
 	OFFSET(ACCOUNT_USER_TIME, paca_struct, accounting.utime);
 	OFFSET(ACCOUNT_SYSTEM_TIME, paca_struct, accounting.stime);
+	OFFSET(PACA_USER_ACCESS_ALLOWED, paca_struct, user_access_allowed);
 	OFFSET(PACA_TRAP_SAVE, paca_struct, trap_save);
 	OFFSET(PACA_NAPSTATELOST, paca_struct, nap_state_lost);
 	OFFSET(PACA_SPRG_VDSO, paca_struct, sprg_vdso);
@@ -320,6 +324,9 @@ int main(void)
 	 */
 	STACK_PT_REGS_OFFSET(_DEAR, dar);
 	STACK_PT_REGS_OFFSET(_ESR, dsisr);
+#ifdef CONFIG_PPC_KUAP
+	STACK_PT_REGS_OFFSET(_KUAP, kuap);
+#endif
 #else /* CONFIG_PPC64 */
 	STACK_PT_REGS_OFFSET(SOFTE, softe);
 	STACK_PT_REGS_OFFSET(_PPR, ppr);
diff --git a/arch/powerpc/kernel/entry_32.S b/arch/powerpc/kernel/entry_32.S
index 0768dfd8a64e..f8f2268f8b12 100644
--- a/arch/powerpc/kernel/entry_32.S
+++ b/arch/powerpc/kernel/entry_32.S
@@ -36,6 +36,7 @@
 #include <asm/asm-405.h>
 #include <asm/feature-fixups.h>
 #include <asm/barrier.h>
+#include <asm/kup.h>
 
 /*
  * MSR_KERNEL is > 0x10000 on 4xx/Book-E since it include MSR_CE.
@@ -156,6 +157,7 @@ transfer_to_handler:
 	stw	r12,_CTR(r11)
 	stw	r2,_XER(r11)
 	mfspr	r12,SPRN_SPRG_THREAD
+	LOCK_USER_ACCESS(r2, r11, r9, r0, r12)
 	addi	r2,r12,-THREAD
 	tovirt(r2,r2)			/* set r2 to current */
 	beq	2f			/* if from user, fix up THREAD.regs */
@@ -442,6 +444,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_NEED_PAIRED_STWCX)
 	ACCOUNT_CPU_USER_EXIT(r4, r5, r7)
 3:
 #endif
+	REST_USER_ACCESS(r7, r1, r4, r5, r2)
 	lwz	r4,_LINK(r1)
 	lwz	r5,_CCR(r1)
 	mtlr	r4
@@ -739,7 +742,8 @@ fast_exception_return:
 	beq	1f			/* if not, we've got problems */
 #endif
 
-2:	REST_4GPRS(3, r11)
+2:	REST_USER_ACCESS(r3, r11, r4, r5, r2)
+	REST_4GPRS(3, r11)
 	lwz	r10,_CCR(r11)
 	REST_GPR(1, r11)
 	mtcr	r10
@@ -957,6 +961,8 @@ END_MMU_FTR_SECTION_IFSET(MMU_FTR_TYPE_47x)
 1:
 #endif /* CONFIG_TRACE_IRQFLAGS */
 
+	REST_USER_ACCESS(r3, r1, r4, r5, r2)
+
 	lwz	r0,GPR0(r1)
 	lwz	r2,GPR2(r1)
 	REST_4GPRS(3, r1)
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index ce393df243aa..995ef82a583d 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -1771,6 +1771,9 @@ void start_thread(struct pt_regs *regs, unsigned long start, unsigned long sp)
 	regs->mq = 0;
 	regs->nip = start;
 	regs->msr = MSR_USER;
+#ifdef CONFIG_PPC_KUAP
+	regs->kuap = KUAP_START;
+#endif
 #else
 	if (!is_32bit_task()) {
 		unsigned long entry;
diff --git a/arch/powerpc/lib/checksum_wrappers.c b/arch/powerpc/lib/checksum_wrappers.c
index 890d4ddd91d6..48e0c91e0083 100644
--- a/arch/powerpc/lib/checksum_wrappers.c
+++ b/arch/powerpc/lib/checksum_wrappers.c
@@ -28,6 +28,7 @@ __wsum csum_and_copy_from_user(const void __user *src, void *dst,
 {
 	unsigned int csum;
 
+	unlock_user_access(NULL, src, len);
 	might_sleep();
 
 	*err_ptr = 0;
@@ -60,6 +61,7 @@ __wsum csum_and_copy_from_user(const void __user *src, void *dst,
 	}
 
 out:
+	lock_user_access(NULL, src, len);
 	return (__force __wsum)csum;
 }
 EXPORT_SYMBOL(csum_and_copy_from_user);
@@ -69,6 +71,7 @@ __wsum csum_and_copy_to_user(const void *src, void __user *dst, int len,
 {
 	unsigned int csum;
 
+	unlock_user_access(dst, NULL, len);
 	might_sleep();
 
 	*err_ptr = 0;
@@ -97,6 +100,7 @@ __wsum csum_and_copy_to_user(const void *src, void __user *dst, int len,
 	}
 
 out:
+	lock_user_access(dst, NULL, len);
 	return (__force __wsum)csum;
 }
 EXPORT_SYMBOL(csum_and_copy_to_user);
diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index ad65e336721a..5f4a5391f41e 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -223,9 +223,11 @@ static int mm_fault_error(struct pt_regs *regs, unsigned long addr,
 }
 
 /* Is this a bad kernel fault ? */
-static bool bad_kernel_fault(bool is_exec, unsigned long error_code,
+static bool bad_kernel_fault(struct pt_regs *regs, unsigned long error_code,
 			     unsigned long address)
 {
+	int is_exec = TRAP(regs) == 0x400;
+
 	/* NX faults set DSISR_PROTFAULT on the 8xx, DSISR_NOEXEC_OR_G on others */
 	if (is_exec && (error_code & (DSISR_NOEXEC_OR_G | DSISR_KEYFAULT |
 				      DSISR_PROTFAULT))) {
@@ -236,7 +238,13 @@ static bool bad_kernel_fault(bool is_exec, unsigned long error_code,
 				   address, from_kuid(&init_user_ns,
 						      current_uid()));
 	}
-	return is_exec || (address >= TASK_SIZE);
+	if (!is_exec && address < TASK_SIZE && (error_code & DSISR_PROTFAULT) &&
+	    !search_exception_tables(regs->nip))
+		printk_ratelimited(KERN_CRIT "Kernel attempted to access user"
+				   " page (%lx) - exploit attempt? (uid: %d)\n",
+				   address, from_kuid(&init_user_ns,
+						      current_uid()));
+	return is_exec || (address >= TASK_SIZE) || !search_exception_tables(regs->nip);
 }
 
 static bool bad_stack_expansion(struct pt_regs *regs, unsigned long address,
@@ -456,9 +464,10 @@ static int __do_page_fault(struct pt_regs *regs, unsigned long address,
 
 	/*
 	 * The kernel should never take an execute fault nor should it
-	 * take a page fault to a kernel address.
+	 * take a page fault to a kernel address or a page fault to a user
+	 * address outside of dedicated places
 	 */
-	if (unlikely(!is_user && bad_kernel_fault(is_exec, error_code, address)))
+	if (unlikely(!is_user && bad_kernel_fault(regs, error_code, address)))
 		return SIGSEGV;
 
 	/*
diff --git a/arch/powerpc/mm/init-common.c b/arch/powerpc/mm/init-common.c
index 83f95a5565d6..ecaedfff9992 100644
--- a/arch/powerpc/mm/init-common.c
+++ b/arch/powerpc/mm/init-common.c
@@ -27,6 +27,7 @@
 #include <asm/kup.h>
 
 static bool disable_kuep = !IS_ENABLED(CONFIG_PPC_KUEP);
+static bool disable_kuap = !IS_ENABLED(CONFIG_PPC_KUAP);
 
 static int __init parse_nosmep(char *p)
 {
@@ -36,9 +37,18 @@ static int __init parse_nosmep(char *p)
 }
 early_param("nosmep", parse_nosmep);
 
+static int __init parse_nosmap(char *p)
+{
+	disable_kuap = true;
+	pr_warn("Disabling Kernel Userspace Access Protection\n");
+	return 0;
+}
+early_param("nosmap", parse_nosmap);
+
 void __init setup_kup(void)
 {
 	setup_kuep(disable_kuep);
+	setup_kuap(disable_kuap);
 }
 
 #define CTOR(shift) static void ctor_##shift(void *addr) \
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index 410c3443652c..7fa5ddbdce12 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -351,6 +351,18 @@ config PPC_KUEP
 
 	  If you're unsure, say Y.
 
+config PPC_HAVE_KUAP
+	bool
+
+config PPC_KUAP
+	bool "Kernel Userspace Access Protection"
+	depends on PPC_HAVE_KUAP
+	default y
+	help
+	  Enable support for Kernel Userspace Access Protection (KUAP)
+
+	  If you're unsure, say Y.
+
 config ARCH_ENABLE_HUGEPAGE_MIGRATION
 	def_bool y
 	depends on PPC_BOOK3S_64 && HUGETLB_PAGE && MIGRATION
-- 
2.20.1
