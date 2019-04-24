Date: Wed, 24 Apr 2019 16:25:48 -0700
From: akpm@linux-foundation.org
Subject: [to-be-updated]
 binfmt_elf-update-read_implies_exec-logic-for-modern-cpus.patch removed from
 -mm tree
Message-ID: <20190424232548.cXSxh%akpm@linux-foundation.org>
To: mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu, mark.rutland@arm.com, luto@amacapital.net, kernel-hardening@lists.openwall.com, jgg@mellanox.com, jannh@google.com, hpa@zytor.com, hecmargi@upv.es, dalias@libc.org, a.p.zijlstra@chello.nl, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>


The patch titled
     Subject: binfmt_elf: Update READ_IMPLIES_EXEC logic for modern CPUs
has been removed from the -mm tree.  Its filename was
     binfmt_elf-update-read_implies_exec-logic-for-modern-cpus.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: binfmt_elf: Update READ_IMPLIES_EXEC logic for modern CPUs

The READ_IMPLIES_EXEC work-around was designed for old CPUs lacking NX (to
have the visible permission flags on memory regions reflect reality: they
are all executable), and for old toolchains that lacked the ELF
PT_GNU_STACK marking (under the assumption than toolchains that couldn't
even specify memory protection flags may have it wrong for all memory
regions).

This logic is sensible, but was implemented in a way that equated having a
PT_GNU_STACK marked executable as being as "broken" as lacking the
PT_GNU_STACK marking entirely.  This is not a reasonable assumption for
CPUs that have had NX support from the start (or very close to the start).
This confusion has led to situations where modern 64-bit programs with
explicitly marked executable stack are forced into the READ_IMPLIES_EXEC
state when no such thing is needed.  (And leads to unexpected failures
when mmap()ing regions of device driver memory that wish to disallow
VM_EXEC[1].)

To fix this, elf_read_implies_exec() is adjusted on arm64 (where NX has
always existed and all toolchains include PT_GNU_STACK), and x86 is
adjusted to handle this combination of possible outcomes:

              CPU: | lacks NX  | has NX, ia32     | has NX, x86_64   |
 ELF:              |           |                  |                  |
 ------------------------------|------------------|------------------|
 missing GNU_STACK | needs RIE | needs RIE        | no RIE           |
 GNU_STACK == RWX  | needs RIE | no RIE: stack X  | no RIE: stack X  |
 GNU_STACK == RW   | needs RIE | no RIE: stack NX | no RIE: stack NX |

This has the effect of making binfmt_elf's EXSTACK_DEFAULT actually take
on the correct architecture default of being non-executable on arm64 and
x86_64, and being executable on ia32.

[1] https://lkml.kernel.org/r/20190418055759.GA3155@mellanox.com

Link: http://lkml.kernel.org/r/20190423181210.GA2443@beast
Signed-off-by: Kees Cook <keescook@chromium.org>
Suggested-by: Hector Marco-Gisbert <hecmargi@upv.es>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jann Horn <jannh@google.com>
Cc: Rich Felker <dalias@libc.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/elf.h |    9 ++++++++-
 arch/x86/include/asm/elf.h   |   24 +++++++++++++++++++++---
 2 files changed, 29 insertions(+), 4 deletions(-)

--- a/arch/arm64/include/asm/elf.h~binfmt_elf-update-read_implies_exec-logic-for-modern-cpus
+++ a/arch/arm64/include/asm/elf.h
@@ -107,7 +107,14 @@
  */
 #define elf_check_arch(x)		((x)->e_machine == EM_AARCH64)
 
-#define elf_read_implies_exec(ex,stk)	(stk != EXSTACK_DISABLE_X)
+/*
+ * 64-bit processes should not automatically gain READ_IMPLIES_EXEC. Only
+ * 32-bit processes without PT_GNU_STACK should trigger READ_IMPLIES_EXEC
+ * out of an abundance of caution against ancient toolchains not knowing
+ * how to mark memory protection flags correctly.
+ */
+#define elf_read_implies_exec(ex, stk)			\
+	(is_compat_task() && stk == EXSTACK_DEFAULT)
 
 #define CORE_DUMP_USE_REGSET
 #define ELF_EXEC_PAGESIZE	PAGE_SIZE
--- a/arch/x86/include/asm/elf.h~binfmt_elf-update-read_implies_exec-logic-for-modern-cpus
+++ a/arch/x86/include/asm/elf.h
@@ -280,10 +280,28 @@ extern u32 elf_hwcap2;
 
 /*
  * An executable for which elf_read_implies_exec() returns TRUE will
- * have the READ_IMPLIES_EXEC personality flag set automatically.
+ * have the READ_IMPLIES_EXEC personality flag set automatically. This
+ * is needed either to show the truth about a memory mapping (i.e. CPUs
+ * that lack NX have all memory implicitly executable, so this makes
+ * sure that the visible permissions reflect reality), or to deal with
+ * old toolchains on new CPUs. Old binaries entirely lacking a GNU_STACK
+ * indicate they were likely built with a toolchain that has no idea about
+ * memory permissions, and so we must default to the lowest reasonable
+ * common denominator for the architecture: on ia32 we assume all memory
+ * to be executable by default, and on x86_64 we assume all memory to be
+ * non-executable by default.
+ *
+ *              CPU: | lacks NX  | has NX, ia32     | has NX, x86_64   |
+ * ELF:              |           |                  |                  |
+ * ------------------------------|------------------|------------------|
+ * missing GNU_STACK | needs RIE | needs RIE        | no RIE           |
+ * GNU_STACK == RWX  | needs RIE | no RIE: stack X  | no RIE: stack X  |
+ * GNU_STACK == RW   | needs RIE | no RIE: stack NX | no RIE: stack NX |
+ *
  */
-#define elf_read_implies_exec(ex, executable_stack)	\
-	(executable_stack != EXSTACK_DISABLE_X)
+#define elf_read_implies_exec(ex, stk)				\
+	(!(__supported_pte_mask & _PAGE_NX) ? 1 :		\
+		(mmap_is_ia32() && stk == EXSTACK_DEFAULT))
 
 struct task_struct;
 
_

Patches currently in -mm which might be from keescook@chromium.org are

binfmt_elf-move-brk-out-of-mmap-when-doing-direct-loader-exec.patch
