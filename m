Reply-To: kernel-hardening@lists.openwall.com
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 30 Dec 2015 16:26:07 +0100
Message-Id: <1451489172-17420-9-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1451489172-17420-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1451489172-17420-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v2 08/13] arm64: use relative references in exception tables
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, linux-kernel@vger.kernel.org
Cc: stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, arnd@arndb.de, marc.zyngier@arm.com, christoffer.dall@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

Instead of using absolute addresses for both the exception location and
the fixup, use offsets relative to the exception table entry values. This
is a prerequisite for KASLR, since absolute exception table entries are
subject to dynamic relocation, which is incompatible with the sorting of
the exception table that occurs at build time.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/Kconfig                   |   1 +
 arch/arm64/include/asm/assembler.h   |   2 +-
 arch/arm64/include/asm/futex.h       |   4 +-
 arch/arm64/include/asm/uaccess.h     |  16 +--
 arch/arm64/kernel/armv8_deprecated.c |   4 +-
 arch/arm64/mm/extable.c              | 102 +++++++++++++++++++-
 scripts/sortextable.c                |   2 +-
 7 files changed, 116 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 827e78f33944..54eeab140bca 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -7,6 +7,7 @@ config ARM64
 	select ARCH_HAS_ELF_RANDOMIZE
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_SG_CHAIN
+	select ARCH_HAS_SORT_EXTABLE
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_USE_CMPXCHG_LOCKREF
 	select ARCH_SUPPORTS_ATOMIC_RMW
diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 12eff928ef8b..8094d50f05bc 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -98,7 +98,7 @@
 9999:	x;					\
 	.section __ex_table,"a";		\
 	.align	3;				\
-	.quad	9999b,l;			\
+	.long	(9999b - .), (l - .);		\
 	.previous
 
 /*
diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
index 007a69fc4f40..35e73e255ad3 100644
--- a/arch/arm64/include/asm/futex.h
+++ b/arch/arm64/include/asm/futex.h
@@ -44,7 +44,7 @@
 "	.popsection\n"							\
 "	.pushsection __ex_table,\"a\"\n"				\
 "	.align	3\n"							\
-"	.quad	1b, 4b, 2b, 4b\n"					\
+"	.long	(1b - .), (4b - .), (2b - .), (4b - .)\n"		\
 "	.popsection\n"							\
 	ALTERNATIVE("nop", SET_PSTATE_PAN(1), ARM64_HAS_PAN,		\
 		    CONFIG_ARM64_PAN)					\
@@ -135,7 +135,7 @@ futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
 "	.popsection\n"
 "	.pushsection __ex_table,\"a\"\n"
 "	.align	3\n"
-"	.quad	1b, 4b, 2b, 4b\n"
+"	.long	(1b - .), (4b - .), (2b - .), (4b - .)\n"
 "	.popsection\n"
 	: "+r" (ret), "=&r" (val), "+Q" (*uaddr), "=&r" (tmp)
 	: "r" (oldval), "r" (newval), "Ir" (-EFAULT)
diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
index b2ede967fe7d..064efe4b0063 100644
--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -36,11 +36,11 @@
 #define VERIFY_WRITE 1
 
 /*
- * The exception table consists of pairs of addresses: the first is the
- * address of an instruction that is allowed to fault, and the second is
- * the address at which the program should continue.  No registers are
- * modified, so it is entirely up to the continuation code to figure out
- * what to do.
+ * The exception table consists of pairs of relative offsets: the first
+ * is the relative offset to an instruction that is allowed to fault,
+ * and the second is the relative offset at which the program should
+ * continue. No registers are modified, so it is entirely up to the
+ * continuation code to figure out what to do.
  *
  * All the routines below use bits of fixup code that are out of line
  * with the main instruction path.  This means when everything is well,
@@ -50,7 +50,7 @@
 
 struct exception_table_entry
 {
-	unsigned long insn, fixup;
+	int insn, fixup;
 };
 
 extern int fixup_exception(struct pt_regs *regs);
@@ -125,7 +125,7 @@ static inline void set_fs(mm_segment_t fs)
 	"	.previous\n"						\
 	"	.section __ex_table,\"a\"\n"				\
 	"	.align	3\n"						\
-	"	.quad	1b, 3b\n"					\
+	"	.long	(1b - .), (3b - .)\n"				\
 	"	.previous"						\
 	: "+r" (err), "=&r" (x)						\
 	: "r" (addr), "i" (-EFAULT))
@@ -192,7 +192,7 @@ do {									\
 	"	.previous\n"						\
 	"	.section __ex_table,\"a\"\n"				\
 	"	.align	3\n"						\
-	"	.quad	1b, 3b\n"					\
+	"	.long	(1b - .), (3b - .)\n"				\
 	"	.previous"						\
 	: "+r" (err)							\
 	: "r" (x), "r" (addr), "i" (-EFAULT))
diff --git a/arch/arm64/kernel/armv8_deprecated.c b/arch/arm64/kernel/armv8_deprecated.c
index 937f5e58a4d3..8f21b1363387 100644
--- a/arch/arm64/kernel/armv8_deprecated.c
+++ b/arch/arm64/kernel/armv8_deprecated.c
@@ -299,8 +299,8 @@ static void register_insn_emulation_sysctl(struct ctl_table *table)
 	"	.popsection"					\
 	"	.pushsection	 __ex_table,\"a\"\n"		\
 	"	.align		3\n"				\
-	"	.quad		0b, 4b\n"			\
-	"	.quad		1b, 4b\n"			\
+	"	.long		(0b - .), (4b - .)\n"		\
+	"	.long		(1b - .), (4b - .)\n"		\
 	"	.popsection\n"					\
 	ALTERNATIVE("nop", SET_PSTATE_PAN(1), ARM64_HAS_PAN,	\
 		CONFIG_ARM64_PAN)				\
diff --git a/arch/arm64/mm/extable.c b/arch/arm64/mm/extable.c
index 79444279ba8c..d803e3e5d3da 100644
--- a/arch/arm64/mm/extable.c
+++ b/arch/arm64/mm/extable.c
@@ -3,15 +3,115 @@
  */
 
 #include <linux/module.h>
+#include <linux/sort.h>
 #include <linux/uaccess.h>
 
+static unsigned long ex_insn_addr(const struct exception_table_entry *x)
+{
+	return (unsigned long)&x->insn + x->insn;
+}
+
+static unsigned long ex_fixup_addr(const struct exception_table_entry *x)
+{
+	return (unsigned long)&x->fixup + x->fixup;
+}
+
 int fixup_exception(struct pt_regs *regs)
 {
 	const struct exception_table_entry *fixup;
 
 	fixup = search_exception_tables(instruction_pointer(regs));
 	if (fixup)
-		regs->pc = fixup->fixup;
+		regs->pc = ex_fixup_addr(fixup);
 
 	return fixup != NULL;
 }
+
+/*
+ * Search one exception table for an entry corresponding to the
+ * given instruction address, and return the address of the entry,
+ * or NULL if none is found.
+ * We use a binary search, and thus we assume that the table is
+ * already sorted.
+ */
+const struct exception_table_entry *
+search_extable(const struct exception_table_entry *first,
+	       const struct exception_table_entry *last,
+	       unsigned long value)
+{
+	while (first <= last) {
+		const struct exception_table_entry *mid;
+		unsigned long addr;
+
+		mid = ((last - first) >> 1) + first;
+		addr = ex_insn_addr(mid);
+		if (addr < value)
+			first = mid + 1;
+		else if (addr > value)
+			last = mid - 1;
+		else
+			return mid;
+        }
+        return NULL;
+}
+
+static int cmp_ex(const void *a, const void *b)
+{
+	const struct exception_table_entry *x = a, *y = b;
+
+	return x->insn - y->insn;
+}
+
+/*
+ * The exception table needs to be sorted so that the binary
+ * search that we use to find entries in it works properly.
+ * This is used both for the kernel exception table and for
+ * the exception tables of modules that get loaded.
+ *
+ */
+void sort_extable(struct exception_table_entry *start,
+		  struct exception_table_entry *finish)
+{
+	struct exception_table_entry *p;
+	int i;
+
+	/* Convert all entries to being relative to the start of the section */
+	i = 0;
+	for (p = start; p < finish; p++) {
+		p->insn += i;
+		i += 4;
+		p->fixup += i;
+		i += 4;
+	}
+
+	sort(start, finish - start, sizeof(struct exception_table_entry),
+	     cmp_ex, NULL);
+
+	/* Denormalize all entries */
+	i = 0;
+	for (p = start; p < finish; p++) {
+		p->insn -= i;
+		i += 4;
+		p->fixup -= i;
+		i += 4;
+	}
+}
+
+#ifdef CONFIG_MODULES
+/*
+ * If the exception table is sorted, any referring to the module init
+ * will be at the beginning or the end.
+ */
+void trim_init_extable(struct module *m)
+{
+	/* trim the beginning */
+	while (m->num_exentries && within_module_init(m->extable[0].insn, m)) {
+		m->extable++;
+		m->num_exentries--;
+	}
+	/* trim the end */
+	while (m->num_exentries &&
+		within_module_init(m->extable[m->num_exentries-1].insn, m))
+		m->num_exentries--;
+}
+#endif /* CONFIG_MODULES */
diff --git a/scripts/sortextable.c b/scripts/sortextable.c
index c2423d913b46..af247c70fb66 100644
--- a/scripts/sortextable.c
+++ b/scripts/sortextable.c
@@ -282,12 +282,12 @@ do_file(char const *const fname)
 	case EM_386:
 	case EM_X86_64:
 	case EM_S390:
+	case EM_AARCH64:
 		custom_sort = sort_relative_table;
 		break;
 	case EM_ARCOMPACT:
 	case EM_ARCV2:
 	case EM_ARM:
-	case EM_AARCH64:
 	case EM_MICROBLAZE:
 	case EM_MIPS:
 	case EM_XTENSA:
-- 
2.5.0
