Date: Tue, 9 May 2017 12:08:12 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
Message-ID: <20170509170812.uyfkvblwofhxpk4e@treble>
References: <1494271972-140319-1-git-send-email-keescook@chromium.org>
 <1494271972-140319-3-git-send-email-keescook@chromium.org>
 <20170508225308.a6uznrhdm7pgyhcg@treble>
 <CAGXu5j+J=o7hHceQn6pFtCmQcfUtSrtZ9uP8fLo0gkDWNdetAA@mail.gmail.com>
 <20170509015829.iycvxxbyblfgklsg@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20170509015829.iycvxxbyblfgklsg@treble>
Subject: [kernel-hardening] Re: [PATCH v3 2/2] x86/refcount: Implement fast refcount overflow
 protection
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, PaX Team <pageexec@freemail.hu>, Jann Horn <jannh@google.com>, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, May 08, 2017 at 08:58:29PM -0500, Josh Poimboeuf wrote:
> On Mon, May 08, 2017 at 04:31:11PM -0700, Kees Cook wrote:
> > On Mon, May 8, 2017 at 3:53 PM, Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> > > On Mon, May 08, 2017 at 12:32:52PM -0700, Kees Cook wrote:
> > >> +#define REFCOUNT_EXCEPTION                           \
> > >> +     "movl $0x7fffffff, %[counter]\n\t"              \
> > >> +     "int $"__stringify(X86_REFCOUNT_VECTOR)"\n"     \
> > >> +     "0:\n\t"                                        \
> > >> +     _ASM_EXTABLE(0b, 0b)
> > >
> > > Despite the objtool warnings going away, this still uses the exception
> > > table in a new way, which will confuse objtool.  I need to do some more
> > > thinking about the best way to fix it, either as a change to your patch
> > > or a change to objtool.
> > 
> > In that it's not a "true" exception?
> 
> Right.  And also that it doesn't need the "fixup" since it would return
> to the same address anyway.

How about the following on top of your patch?  It uses #UD (invalid
opcode).  Notice it's mostly code deletions :-)


diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index bba6976..50bc269 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -789,15 +789,6 @@ ENTRY(spurious_interrupt_bug)
 	jmp	common_exception
 END(spurious_interrupt_bug)
 
-#ifdef CONFIG_FAST_REFCOUNT
-ENTRY(refcount_error)
-	ASM_CLAC
-	pushl   $0
-	pushl   $do_refcount_error
-	jmp     common_exception
-ENDPROC(refcount_error)
-#endif
-
 #ifdef CONFIG_XEN
 ENTRY(xen_hypervisor_callback)
 	pushl	$-1				/* orig_ax = -1 => not a system call */
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 783045d..607d72c 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -855,9 +855,6 @@ idtentry coprocessor_error		do_coprocessor_error		has_error_code=0
 idtentry alignment_check		do_alignment_check		has_error_code=1
 idtentry simd_coprocessor_error		do_simd_coprocessor_error	has_error_code=0
 
-#ifdef CONFIG_FAST_REFCOUNT
-idtentry refcount_error			do_refcount_error		has_error_code=0
-#endif
 
 	/*
 	 * Reload gs selector with exception handling
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index d117776..6ca9fd6 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -48,9 +48,6 @@
 
 #define IA32_SYSCALL_VECTOR		0x80
 
-/* Refcount overflow reporting exception. */
-#define X86_REFCOUNT_VECTOR		0x81
-
 /*
  * Vectors 0x30-0x3f are used for ISA interrupts.
  *   round up to the next 16-vector boundary
diff --git a/arch/x86/include/asm/refcount.h b/arch/x86/include/asm/refcount.h
index 6e8bbd7..653a985 100644
--- a/arch/x86/include/asm/refcount.h
+++ b/arch/x86/include/asm/refcount.h
@@ -8,15 +8,16 @@
  */
 #include <linux/refcount.h>
 #include <asm/irq_vectors.h>
+#include <asm/bug.h>
 
 #define REFCOUNT_EXCEPTION				\
 	"movl $0x7fffffff, %[counter]\n\t"		\
-	"int $"__stringify(X86_REFCOUNT_VECTOR)"\n"	\
-	"0:\n\t"					\
-	_ASM_EXTABLE(0b, 0b)
+	"1:\t" ASM_UD0 "\n"				\
+	"2:\n\t"					\
+	_ASM_EXTABLE(1b, 2b)
 
 #define REFCOUNT_CHECK					\
-	"jns 0f\n\t"					\
+	"jns 2f\n\t"					\
 	REFCOUNT_EXCEPTION
 
 static __always_inline void refcount_add(unsigned int i, refcount_t *r)
diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index e4d8db7..01fd0a7 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -38,10 +38,6 @@ asmlinkage void machine_check(void);
 #endif /* CONFIG_X86_MCE */
 asmlinkage void simd_coprocessor_error(void);
 
-#ifdef CONFIG_FAST_REFCOUNT
-asmlinkage void refcount_error(void);
-#endif
-
 #ifdef CONFIG_TRACING
 asmlinkage void trace_page_fault(void);
 #define trace_stack_segment stack_segment
@@ -58,7 +54,6 @@ asmlinkage void trace_page_fault(void);
 #define trace_alignment_check alignment_check
 #define trace_simd_coprocessor_error simd_coprocessor_error
 #define trace_async_page_fault async_page_fault
-#define trace_refcount_error refcount_error
 #endif
 
 dotraplinkage void do_divide_error(struct pt_regs *, long);
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 0b2dbcc..7de95b7 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -220,8 +220,8 @@ do_trap_no_signal(struct task_struct *tsk, int trapnr, char *str,
 	if (!user_mode(regs)) {
 		if (fixup_exception(regs, trapnr)) {
 			if (IS_ENABLED(CONFIG_FAST_REFCOUNT) &&
-			    trapnr == X86_REFCOUNT_VECTOR)
-				refcount_error_report(regs, str);
+			    trapnr == X86_TRAP_UD)
+				refcount_error_report(regs);
 
 			return 0;
 		}
@@ -332,10 +332,6 @@ DO_ERROR(X86_TRAP_NP,     SIGBUS,  "segment not present",	segment_not_present)
 DO_ERROR(X86_TRAP_SS,     SIGBUS,  "stack segment",		stack_segment)
 DO_ERROR(X86_TRAP_AC,     SIGBUS,  "alignment check",		alignment_check)
 
-#ifdef CONFIG_FAST_REFCOUNT
-DO_ERROR(X86_REFCOUNT_VECTOR, SIGILL, "refcount overflow",	refcount_error)
-#endif
-
 #ifdef CONFIG_VMAP_STACK
 __visible void __noreturn handle_stack_overflow(const char *message,
 						struct pt_regs *regs,
@@ -1026,11 +1022,6 @@ void __init trap_init(void)
 	set_bit(IA32_SYSCALL_VECTOR, used_vectors);
 #endif
 
-#ifdef CONFIG_FAST_REFCOUNT
-	set_intr_gate(X86_REFCOUNT_VECTOR, refcount_error);
-	set_bit(X86_REFCOUNT_VECTOR, used_vectors);
-#endif
-
 	/*
 	 * Set the IDT descriptor to a fixed read-only location, so that the
 	 * "sidt" instruction will not leak the location of the kernel, and
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 94f87d5..53c9326 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -276,7 +276,7 @@ extern int oops_may_print(void);
 void do_exit(long error_code) __noreturn;
 void complete_and_exit(struct completion *, long) __noreturn;
 
-void refcount_error_report(struct pt_regs *regs, const char *kind);
+void refcount_error_report(struct pt_regs *regs);
 
 /* Internal, do not use. */
 int __must_check _kstrtoul(const char *s, unsigned int base, unsigned long *res);
diff --git a/kernel/panic.c b/kernel/panic.c
index c95b919..2c4ce79 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -605,7 +605,7 @@ EXPORT_SYMBOL(__stack_chk_fail);
 #ifdef CONFIG_FAST_REFCOUNT
 static DEFINE_RATELIMIT_STATE(refcount_ratelimit, 15 * HZ, 3);
 
-void refcount_error_report(struct pt_regs *regs, const char *kind)
+void refcount_error_report(struct pt_regs *regs)
 {
 	/* Always make sure triggering process will be terminated. */
 	do_send_sig_info(SIGKILL, SEND_SIG_FORCED, current, true);
@@ -613,8 +613,7 @@ void refcount_error_report(struct pt_regs *regs, const char *kind)
 	if (!__ratelimit(&refcount_ratelimit))
 		return;
 
-	pr_emerg("%s detected in: %s:%d, uid/euid: %u/%u\n",
-		kind ? kind : "refcount error",
+	pr_emerg("refcount error detected in: %s:%d, uid/euid: %u/%u\n",
 		current->comm, task_pid_nr(current),
 		from_kuid_munged(&init_user_ns, current_uid()),
 		from_kuid_munged(&init_user_ns, current_euid()));
