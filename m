Message-Id: <20170203132737.468315344@infradead.org>
Date: Fri, 03 Feb 2017 14:26:01 +0100
From: Peter Zijlstra <peterz@infradead.org>
References: <20170203132558.474916683@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=peterz-x86-warn-ud2.patch
Subject: [kernel-hardening] [PATCH 3/5] x86: Implement __WARN using UD2
To: elena.reshetova@intel.com, gregkh@linuxfoundation.org, keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@kernel.org, h.peter.anvin@intel.com, will.deacon@arm.com, dwindsor@gmail.com, dhowells@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

By using "UD2" for WARNs we remove the function call and its possible
__FILE__ and __LINE__ immediate arguments from the instruction stream.

Total image size will not change much, what we win in the instrucion
stream we'll loose because of the __bug_table entries. Still, saves on
I$ footprint and the total image size does go down a bit.

  text            data     bss    dec              hex    filename                     size
  10475740        4428992  974848 15879580         f24d9c defconfig-build/vmlinux.pre  25215824
  10451804        4428992  974848 15855644         f1f01c defconfig-build/vmlinux.post 25211288

In particular this makes:

0000000000001490 <ihold>:
    1490:       55                      push   %rbp
    1491:       8b 87 48 01 00 00       mov    0x148(%rdi),%eax
    1497:       48 89 e5                mov    %rsp,%rbp
    149a:       eb 0a                   jmp    14a6 <ihold+0x16>
    149c:       f0 0f b1 97 48 01 00    lock cmpxchg %edx,0x148(%rdi)
    14a3:       00 
    14a4:       74 20                   je     14c6 <ihold+0x36>
    14a6:       85 c0                   test   %eax,%eax
    14a8:       8d 50 01                lea    0x1(%rax),%edx
    14ab:       74 06                   je     14b3 <ihold+0x23>
    14ad:       85 d2                   test   %edx,%edx
    14af:       75 eb                   jne    149c <ihold+0xc>
    14b1:       5d                      pop    %rbp
    14b2:       c3                      retq   
    14b3:       be 8d 00 00 00          mov    $0x8d,%esi
    14b8:       48 c7 c7 00 00 00 00    mov    $0x0,%rdi
                        14bb: R_X86_64_32S      .rodata.str1.1+0x35
    14bf:       e8 00 00 00 00          callq  14c4 <ihold+0x34>
                        14c0: R_X86_64_PC32     warn_slowpath_null-0x4
    14c4:       5d                      pop    %rbp
    14c5:       c3                      retq   
    14c6:       83 fa ff                cmp    $0xffffffff,%edx
    14c9:       75 e6                   jne    14b1 <ihold+0x21>
    14cb:       be 80 00 00 00          mov    $0x80,%esi
    14d0:       48 c7 c7 00 00 00 00    mov    $0x0,%rdi
                        14d3: R_X86_64_32S      .rodata.str1.1+0x35
    14d7:       e8 00 00 00 00          callq  14dc <ihold+0x4c>
                        14d8: R_X86_64_PC32     warn_slowpath_null-0x4
    14dc:       5d                      pop    %rbp
    14dd:       c3                      retq   
    14de:       66 90                   xchg   %ax,%ax

Look like:

0000000000001400 <ihold>:
    1400:       55                      push   %rbp
    1401:       8b 87 48 01 00 00       mov    0x148(%rdi),%eax
    1407:       48 89 e5                mov    %rsp,%rbp
    140a:       eb 0a                   jmp    1416 <ihold+0x16>
    140c:       f0 0f b1 97 48 01 00    lock cmpxchg %edx,0x148(%rdi)
    1413:       00 
    1414:       74 11                   je     1427 <ihold+0x27>
    1416:       85 c0                   test   %eax,%eax
    1418:       8d 50 01                lea    0x1(%rax),%edx
    141b:       74 06                   je     1423 <ihold+0x23>
    141d:       85 d2                   test   %edx,%edx
    141f:       75 eb                   jne    140c <ihold+0xc>
    1421:       5d                      pop    %rbp
    1422:       c3                      retq   
    1423:       0f 0b                   ud2    
    1425:       5d                      pop    %rbp
    1426:       c3                      retq   
    1427:       83 fa ff                cmp    $0xffffffff,%edx
    142a:       75 f5                   jne    1421 <ihold+0x21>
    142c:       0f 0b                   ud2    
    142e:       5d                      pop    %rbp
    142f:       c3                      retq  

Note that custom x86 code could do better using the exception table
with a custom exception handler looking at the regs->ax value to
determine which of the failure cases was hit, removing a bunch of
compares from the actual code path.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/include/asm/bug.h  |   36 +++++++++++++++++++++++++++++-------
 arch/x86/kernel/dumpstack.c |    3 ---
 arch/x86/kernel/traps.c     |   33 +++++++++++++++++++++++++++------
 3 files changed, 56 insertions(+), 16 deletions(-)

--- a/arch/x86/include/asm/bug.h
+++ b/arch/x86/include/asm/bug.h
@@ -11,26 +11,48 @@
 # define __BUG_C0	"2:\t.long 1b - 2b, %c0 - 2b\n"
 #endif
 
-#define BUG()							\
+#define _BUG_FLAGS(flags)					\
 do {								\
 	asm volatile("1:\tud2\n"				\
 		     ".pushsection __bug_table,\"a\"\n"		\
 		     __BUG_C0					\
-		     "\t.word %c1, 0\n"				\
-		     "\t.org 2b+%c2\n"				\
+		     "\t.word %c1, %c2\n"			\
+		     "\t.org 2b+%c3\n"				\
 		     ".popsection"				\
 		     : : "i" (__FILE__), "i" (__LINE__),	\
-		     "i" (sizeof(struct bug_entry)));		\
-	unreachable();						\
+			 "i" (flags),				\
+			 "i" (sizeof(struct bug_entry)));	\
 } while (0)
 
 #else
+
+#ifdef CONFIG_X86_32
+# define __BUG_C0	"2:\t.long 1b\n"
+#else
+# define __BUG_C0	"2:\t.long 1b - 2b\n"
+#endif
+
+#define _BUG_FLAGS(flags)					\
+do {								\
+	asm volatile("1:\tud2\n"				\
+		     ".pushsection __bug_table,\"a\"\n"		\
+		     __BUG_C0					\
+		     "\t.word %c0\n"				\
+		     "\t.org 2b+%c1\n"				\
+		     ".popsection"				\
+		     : : "i" (flags),				\
+			 "i" (sizeof(struct bug_entry)));	\
+} while (0)
+
+#endif
+
 #define BUG()							\
 do {								\
-	asm volatile("ud2");					\
+	_BUG_FLAGS(0);						\
 	unreachable();						\
 } while (0)
-#endif
+
+#define __WARN_TAINT(taint)	_BUG_FLAGS(BUGFLAG_TAINT(taint))
 
 #include <asm-generic/bug.h>
 
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -287,9 +287,6 @@ void die(const char *str, struct pt_regs
 	unsigned long flags = oops_begin();
 	int sig = SIGSEGV;
 
-	if (!user_mode(regs))
-		report_bug(regs->ip, regs);
-
 	if (__die(str, regs, err))
 		sig = 0;
 	oops_end(flags, regs, sig);
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -168,6 +168,24 @@ void ist_end_non_atomic(void)
 	preempt_disable();
 }
 
+static int fixup_bug(struct pt_regs *regs, int trapnr)
+{
+	if (trapnr != X86_TRAP_UD)
+		return 0;
+
+	switch (report_bug(regs->ip, regs)) {
+	case BUG_TRAP_TYPE_NONE:
+	case BUG_TRAP_TYPE_BUG:
+		break;
+
+	case BUG_TRAP_TYPE_WARN:
+		regs->ip += 2;
+		return 1;
+	}
+
+	return 0;
+}
+
 static nokprobe_inline int
 do_trap_no_signal(struct task_struct *tsk, int trapnr, char *str,
 		  struct pt_regs *regs,	long error_code)
@@ -186,12 +204,15 @@ do_trap_no_signal(struct task_struct *ts
 	}
 
 	if (!user_mode(regs)) {
-		if (!fixup_exception(regs, trapnr)) {
-			tsk->thread.error_code = error_code;
-			tsk->thread.trap_nr = trapnr;
-			die(str, regs, error_code);
-		}
-		return 0;
+		if (fixup_exception(regs, trapnr))
+			return 0;
+
+		if (fixup_bug(regs, trapnr))
+			return 0;
+
+		tsk->thread.error_code = error_code;
+		tsk->thread.trap_nr = trapnr;
+		die(str, regs, error_code);
 	}
 
 	return -1;
