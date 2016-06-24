Reply-To: kernel-hardening@lists.openwall.com
From: Andy Lutomirski <luto@kernel.org>
Date: Thu, 23 Jun 2016 21:23:11 -0700
Message-Id: <c85b0bbcdc877ff0b4e10a0b205d9623f4350428.1466741835.git.luto@kernel.org>
In-Reply-To: <cover.1466741835.git.luto@kernel.org>
References: <cover.1466741835.git.luto@kernel.org>
In-Reply-To: <cover.1466741835.git.luto@kernel.org>
References: <cover.1466741835.git.luto@kernel.org>
Subject: [kernel-hardening] [PATCH v4 16/16] x86/mm: Improve stack-overflow #PF handling
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Andy Lutomirski <luto@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

If we get a page fault indicating kernel stack overflow, invoke
handle_stack_overflow().  To prevent us from overflowing the stack
again while handling the overflow (because we are likely to have
very little stack space left), call handle_stack_overflow() on the
double-fault stack

Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/x86/include/asm/traps.h |  6 ++++++
 arch/x86/kernel/traps.c      |  6 +++---
 arch/x86/mm/fault.c          | 39 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index c3496619740a..01fd0a7f48cd 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -117,6 +117,12 @@ extern void ist_exit(struct pt_regs *regs);
 extern void ist_begin_non_atomic(struct pt_regs *regs);
 extern void ist_end_non_atomic(void);
 
+#ifdef CONFIG_VMAP_STACK
+void __noreturn handle_stack_overflow(const char *message,
+				      struct pt_regs *regs,
+				      unsigned long fault_address);
+#endif
+
 /* Interrupts/Exceptions */
 enum {
 	X86_TRAP_DE = 0,	/*  0, Divide-by-zero */
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 9cb7ea781176..b389c0539eb9 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -293,9 +293,9 @@ DO_ERROR(X86_TRAP_SS,     SIGBUS,  "stack segment",		stack_segment)
 DO_ERROR(X86_TRAP_AC,     SIGBUS,  "alignment check",		alignment_check)
 
 #ifdef CONFIG_VMAP_STACK
-static void __noreturn handle_stack_overflow(const char *message,
-					     struct pt_regs *regs,
-					     unsigned long fault_address)
+__visible void __noreturn handle_stack_overflow(const char *message,
+						struct pt_regs *regs,
+						unsigned long fault_address)
 {
 	printk(KERN_EMERG "BUG: stack guard page was hit at %p (stack is %p..%p)\n",
 		 (void *)fault_address, current->stack,
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 7d1fa7cd2374..c68b81f5659f 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -753,6 +753,45 @@ no_context(struct pt_regs *regs, unsigned long error_code,
 		return;
 	}
 
+#ifdef CONFIG_VMAP_STACK
+	/*
+	 * Stack overflow?  During boot, we can fault near the initial
+	 * stack in the direct map, but that's not an overflow -- check
+	 * that we're in vmalloc space to avoid this.
+	 *
+	 * Check this after trying fixup_exception, since there are handful
+	 * of kernel code paths that wander off the top of the stack but
+	 * handle any faults that occur.  Once those are fixed, we can
+	 * move this above fixup_exception.
+	 */
+	if (is_vmalloc_addr((void *)address) &&
+	    (((unsigned long)tsk->stack - 1 - address < PAGE_SIZE) ||
+	     address - ((unsigned long)tsk->stack + THREAD_SIZE) < PAGE_SIZE)) {
+		register void *__sp asm("rsp");
+		unsigned long stack =
+			this_cpu_read(orig_ist.ist[DOUBLEFAULT_STACK]) -
+			sizeof(void *);
+		/*
+		 * We're likely to be running with very little stack space
+		 * left.  It's plausible that we'd hit this condition but
+		 * double-fault even before we get this far, in which case
+		 * we're fine: the double-fault handler will deal with it.
+		 *
+		 * We don't want to make it all the way into the oops code
+		 * and then double-fault, though, because we're likely to
+		 * break the console driver and lose most of the stack dump.
+		 */
+		asm volatile ("movq %[stack], %%rsp\n\t"
+			      "call handle_stack_overflow\n\t"
+			      "1: jmp 1b"
+			      : "+r" (__sp)
+			      : "D" ("kernel stack overflow (page fault)"),
+				"S" (regs), "d" (address),
+				[stack] "rm" (stack));
+		unreachable();
+	}
+#endif
+
 	/*
 	 * 32-bit:
 	 *
-- 
2.5.5
