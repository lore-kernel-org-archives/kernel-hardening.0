From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Sun,  3 Sep 2017 13:07:44 +0100
Message-Id: <20170903120757.14968-17-ard.biesheuvel@linaro.org>
In-Reply-To: <20170903120757.14968-1-ard.biesheuvel@linaro.org>
References: <20170903120757.14968-1-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v2 16/29] ARM: kernel: switch to relative exception tables
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

To avoid having to relocate the contents of extable entries at
runtime when running with KASLR enabled, wire up the existing
support for emitting them as relative references. This ensures
these quantities are invariant under runtime relocation.

Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/include/asm/Kbuild           |  1 -
 arch/arm/include/asm/assembler.h      |  6 +++---
 arch/arm/include/asm/extable.h        | 19 +++++++++++++++++
 arch/arm/include/asm/futex.h          |  2 +-
 arch/arm/include/asm/uaccess.h        |  8 +++----
 arch/arm/include/asm/word-at-a-time.h |  2 +-
 arch/arm/kernel/entry-armv.S          |  6 +++---
 arch/arm/kernel/swp_emulate.c         |  4 ++--
 arch/arm/lib/backtrace.S              |  8 +++----
 arch/arm/lib/getuser.S                | 22 ++++++++++----------
 arch/arm/lib/putuser.S                | 12 +++++------
 arch/arm/mm/alignment.c               | 14 ++++++-------
 arch/arm/mm/extable.c                 |  2 +-
 arch/arm/nwfpe/entry.S                |  2 +-
 scripts/sortextable.c                 |  2 +-
 15 files changed, 64 insertions(+), 46 deletions(-)

diff --git a/arch/arm/include/asm/Kbuild b/arch/arm/include/asm/Kbuild
index 721ab5ecfb9b..f2d67fa34eb3 100644
--- a/arch/arm/include/asm/Kbuild
+++ b/arch/arm/include/asm/Kbuild
@@ -3,7 +3,6 @@ generic-y += current.h
 generic-y += early_ioremap.h
 generic-y += emergency-restart.h
 generic-y += exec.h
-generic-y += extable.h
 generic-y += irq_regs.h
 generic-y += kdebug.h
 generic-y += local.h
diff --git a/arch/arm/include/asm/assembler.h b/arch/arm/include/asm/assembler.h
index a0906c1fc65d..ae43859a9000 100644
--- a/arch/arm/include/asm/assembler.h
+++ b/arch/arm/include/asm/assembler.h
@@ -247,7 +247,7 @@
 9999:	x;					\
 	.pushsection __ex_table,"a";		\
 	.align	3;				\
-	.long	9999b,9001f;			\
+	.long	9999b - ., 9001f - .;		\
 	.popsection
 
 #ifdef CONFIG_SMP
@@ -383,7 +383,7 @@ THUMB(	orr	\reg , \reg , #PSR_T_BIT	)
 
 	.pushsection __ex_table,"a"
 	.align	3
-	.long	9999b, \abort
+	.long	9999b - ., \abort - .
 	.popsection
 	.endm
 
@@ -424,7 +424,7 @@ THUMB(	orr	\reg , \reg , #PSR_T_BIT	)
 
 	.pushsection __ex_table,"a"
 	.align	3
-	.long	9999b, \abort
+	.long	9999b - ., \abort - .
 	.popsection
 	.endr
 	.endm
diff --git a/arch/arm/include/asm/extable.h b/arch/arm/include/asm/extable.h
new file mode 100644
index 000000000000..c85d1f4404b7
--- /dev/null
+++ b/arch/arm/include/asm/extable.h
@@ -0,0 +1,19 @@
+#ifndef __ASM_EXTABLE_H
+#define __ASM_EXTABLE_H
+
+/*
+ * The exception table consists of pairs of relative offsets: the first
+ * is the relative offset to an instruction that is allowed to fault,
+ * and the second is the relative offset at which the program should
+ * continue. No registers are modified, so it is entirely up to the
+ * continuation code to figure out what to do.
+ */
+
+struct exception_table_entry {
+	int insn, fixup;
+};
+
+#define ARCH_HAS_RELATIVE_EXTABLE
+
+extern int fixup_exception(struct pt_regs *regs);
+#endif
diff --git a/arch/arm/include/asm/futex.h b/arch/arm/include/asm/futex.h
index 6795368ad023..31760d0ab76b 100644
--- a/arch/arm/include/asm/futex.h
+++ b/arch/arm/include/asm/futex.h
@@ -11,7 +11,7 @@
 	"3:\n"							\
 	"	.pushsection __ex_table,\"a\"\n"		\
 	"	.align	3\n"					\
-	"	.long	1b, 4f, 2b, 4f\n"			\
+	"	.long	1b - ., 4f - ., 2b - ., 4f - .\n"	\
 	"	.popsection\n"					\
 	"	.pushsection .text.fixup,\"ax\"\n"		\
 	"	.align	2\n"					\
diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
index 0bf2347495f1..62b9bb7d991a 100644
--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -295,7 +295,7 @@ do {									\
 	"	.popsection\n"					\
 	"	.pushsection __ex_table,\"a\"\n"		\
 	"	.align	3\n"					\
-	"	.long	1b, 3b\n"				\
+	"	.long	1b - ., 3b - .\n"			\
 	"	.popsection"					\
 	: "+r" (err), "=&r" (x)					\
 	: "r" (addr), "i" (-EFAULT)				\
@@ -385,7 +385,7 @@ do {									\
 	"	.popsection\n"					\
 	"	.pushsection __ex_table,\"a\"\n"		\
 	"	.align	3\n"					\
-	"	.long	1b, 3b\n"				\
+	"	.long	1b - ., 3b - .\n"			\
 	"	.popsection"					\
 	: "+r" (err)						\
 	: "r" (x), "r" (__pu_addr), "i" (-EFAULT)		\
@@ -435,8 +435,8 @@ do {									\
 	"	.popsection\n"					\
 	"	.pushsection __ex_table,\"a\"\n"		\
 	"	.align	3\n"					\
-	"	.long	1b, 4b\n"				\
-	"	.long	2b, 4b\n"				\
+	"	.long	1b - ., 4b - .\n"			\
+	"	.long	2b - ., 4b - .\n"			\
 	"	.popsection"					\
 	: "+r" (err), "+r" (__pu_addr)				\
 	: "r" (x), "i" (-EFAULT)				\
diff --git a/arch/arm/include/asm/word-at-a-time.h b/arch/arm/include/asm/word-at-a-time.h
index 5831dce4b51c..d433c686d9ca 100644
--- a/arch/arm/include/asm/word-at-a-time.h
+++ b/arch/arm/include/asm/word-at-a-time.h
@@ -86,7 +86,7 @@ static inline unsigned long load_unaligned_zeropad(const void *addr)
 	"	.popsection\n"
 	"	.pushsection __ex_table,\"a\"\n"
 	"	.align	3\n"
-	"	.long	1b, 3b\n"
+	"	.long	1b - ., 3b - .\n"
 	"	.popsection"
 	: "=&r" (ret), "=&r" (offset)
 	: "r" (addr), "Qo" (*(unsigned long *)addr));
diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index c731f0d2b2af..1c7c12123b18 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -570,10 +570,10 @@ ENDPROC(__und_usr)
 	ret	r9
 	.popsection
 	.pushsection __ex_table,"a"
-	.long	1b, 4b
+	.long	1b - ., 4b - .
 #if CONFIG_ARM_THUMB && __LINUX_ARM_ARCH__ >= 6 && CONFIG_CPU_V7
-	.long	2b, 4b
-	.long	3b, 4b
+	.long	2b - ., 4b - .
+	.long	3b - ., 4b - .
 #endif
 	.popsection
 
diff --git a/arch/arm/kernel/swp_emulate.c b/arch/arm/kernel/swp_emulate.c
index 3bda08bee674..a783e9c0b266 100644
--- a/arch/arm/kernel/swp_emulate.c
+++ b/arch/arm/kernel/swp_emulate.c
@@ -50,8 +50,8 @@
 	"	.previous\n"					\
 	"	.section	 __ex_table,\"a\"\n"		\
 	"	.align		3\n"				\
-	"	.long		0b, 3b\n"			\
-	"	.long		1b, 3b\n"			\
+	"	.long		0b - ., 3b - .\n"		\
+	"	.long		1b - ., 3b - .\n"		\
 	"	.previous"					\
 	: "=&r" (res), "+r" (data), "=&r" (temp)		\
 	: "r" (addr), "i" (-EAGAIN), "i" (-EFAULT)		\
diff --git a/arch/arm/lib/backtrace.S b/arch/arm/lib/backtrace.S
index 7d7952e5a3b1..84a8df7aa63c 100644
--- a/arch/arm/lib/backtrace.S
+++ b/arch/arm/lib/backtrace.S
@@ -107,10 +107,10 @@ ENDPROC(c_backtrace)
 		
 		.pushsection __ex_table,"a"
 		.align	3
-		.long	1001b, 1006b
-		.long	1002b, 1006b
-		.long	1003b, 1006b
-		.long	1004b, 1006b
+		.long	1001b - ., 1006b - .
+		.long	1002b - ., 1006b - .
+		.long	1003b - ., 1006b - .
+		.long	1004b - ., 1006b - .
 		.popsection
 
 .Lbad:		.asciz	"Backtrace aborted due to bad frame pointer <%p>\n"
diff --git a/arch/arm/lib/getuser.S b/arch/arm/lib/getuser.S
index df73914e81c8..d47b4776d308 100644
--- a/arch/arm/lib/getuser.S
+++ b/arch/arm/lib/getuser.S
@@ -133,17 +133,17 @@ ENDPROC(__get_user_bad)
 ENDPROC(__get_user_bad8)
 
 .pushsection __ex_table, "a"
-	.long	1b, __get_user_bad
-	.long	2b, __get_user_bad
-	.long	3b, __get_user_bad
-	.long	4b, __get_user_bad
-	.long	5b, __get_user_bad8
-	.long	6b, __get_user_bad8
+	.long	1b - ., __get_user_bad - .
+	.long	2b - ., __get_user_bad - .
+	.long	3b - ., __get_user_bad - .
+	.long	4b - ., __get_user_bad - .
+	.long	5b - ., __get_user_bad8 - .
+	.long	6b - ., __get_user_bad8 - .
 #ifdef __ARMEB__
-	.long   7b, __get_user_bad
-	.long	8b, __get_user_bad8
-	.long	9b, __get_user_bad8
-	.long	10b, __get_user_bad8
-	.long	11b, __get_user_bad8
+	.long   7b - ., __get_user_bad - .
+	.long	8b - ., __get_user_bad8 - .
+	.long	9b - ., __get_user_bad8 - .
+	.long	10b - ., __get_user_bad8 - .
+	.long	11b - ., __get_user_bad8 - .
 #endif
 .popsection
diff --git a/arch/arm/lib/putuser.S b/arch/arm/lib/putuser.S
index 38d660d3705f..6b854197ff48 100644
--- a/arch/arm/lib/putuser.S
+++ b/arch/arm/lib/putuser.S
@@ -89,10 +89,10 @@ __put_user_bad:
 ENDPROC(__put_user_bad)
 
 .pushsection __ex_table, "a"
-	.long	1b, __put_user_bad
-	.long	2b, __put_user_bad
-	.long	3b, __put_user_bad
-	.long	4b, __put_user_bad
-	.long	5b, __put_user_bad
-	.long	6b, __put_user_bad
+	.long	1b - ., __put_user_bad - .
+	.long	2b - ., __put_user_bad - .
+	.long	3b - ., __put_user_bad - .
+	.long	4b - ., __put_user_bad - .
+	.long	5b - ., __put_user_bad - .
+	.long	6b - ., __put_user_bad - .
 .popsection
diff --git a/arch/arm/mm/alignment.c b/arch/arm/mm/alignment.c
index 2c96190e018b..2c74cb826b6a 100644
--- a/arch/arm/mm/alignment.c
+++ b/arch/arm/mm/alignment.c
@@ -209,7 +209,7 @@ union offset_union {
 	"	.popsection\n"				\
 	"	.pushsection __ex_table,\"a\"\n"	\
 	"	.align	3\n"				\
-	"	.long	1b, 3b\n"			\
+	"	.long	1b - ., 3b - .\n"		\
 	"	.popsection\n"				\
 	: "=r" (err), "=&r" (val), "=r" (addr)		\
 	: "0" (err), "2" (addr))
@@ -269,8 +269,8 @@ union offset_union {
 		"	.popsection\n"				\
 		"	.pushsection __ex_table,\"a\"\n"	\
 		"	.align	3\n"				\
-		"	.long	1b, 4b\n"			\
-		"	.long	2b, 4b\n"			\
+		"	.long	1b - ., 4b - .\n"		\
+		"	.long	2b - ., 4b - .\n"		\
 		"	.popsection\n"				\
 		: "=r" (err), "=&r" (v), "=&r" (a)		\
 		: "0" (err), "1" (v), "2" (a));			\
@@ -309,10 +309,10 @@ union offset_union {
 		"	.popsection\n"				\
 		"	.pushsection __ex_table,\"a\"\n"	\
 		"	.align	3\n"				\
-		"	.long	1b, 6b\n"			\
-		"	.long	2b, 6b\n"			\
-		"	.long	3b, 6b\n"			\
-		"	.long	4b, 6b\n"			\
+		"	.long	1b - ., 6b - .\n"		\
+		"	.long	2b - ., 6b - .\n"		\
+		"	.long	3b - ., 6b - .\n"		\
+		"	.long	4b - ., 6b - .\n"		\
 		"	.popsection\n"				\
 		: "=r" (err), "=&r" (v), "=&r" (a)		\
 		: "0" (err), "1" (v), "2" (a));			\
diff --git a/arch/arm/mm/extable.c b/arch/arm/mm/extable.c
index f436f7439e46..6a8b85bf0cac 100644
--- a/arch/arm/mm/extable.c
+++ b/arch/arm/mm/extable.c
@@ -10,7 +10,7 @@ int fixup_exception(struct pt_regs *regs)
 
 	fixup = search_exception_tables(instruction_pointer(regs));
 	if (fixup) {
-		regs->ARM_pc = fixup->fixup;
+		regs->ARM_pc = (unsigned long)&fixup->fixup + fixup->fixup;
 #ifdef CONFIG_THUMB2_KERNEL
 		/* Clear the IT state to avoid nasty surprises in the fixup */
 		regs->ARM_cpsr &= ~PSR_IT_MASK;
diff --git a/arch/arm/nwfpe/entry.S b/arch/arm/nwfpe/entry.S
index 39c20afad7ed..c4fe13b31705 100644
--- a/arch/arm/nwfpe/entry.S
+++ b/arch/arm/nwfpe/entry.S
@@ -121,5 +121,5 @@ next:
 
 	.pushsection __ex_table,"a"
 	.align	3
-	.long	.Lx1, .Lfix
+	.long	.Lx1 - ., .Lfix - .
 	.popsection
diff --git a/scripts/sortextable.c b/scripts/sortextable.c
index 365a907f98b3..56a4c6714da7 100644
--- a/scripts/sortextable.c
+++ b/scripts/sortextable.c
@@ -314,6 +314,7 @@ do_file(char const *const fname)
 		break;
 
 	case EM_S390:
+	case EM_ARM:
 	case EM_AARCH64:
 	case EM_PARISC:
 	case EM_PPC:
@@ -322,7 +323,6 @@ do_file(char const *const fname)
 		break;
 	case EM_ARCOMPACT:
 	case EM_ARCV2:
-	case EM_ARM:
 	case EM_MICROBLAZE:
 	case EM_MIPS:
 	case EM_XTENSA:
-- 
2.11.0
