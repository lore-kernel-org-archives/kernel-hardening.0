Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 16 Jun 2016 13:56:48 +0200
From: Borislav Petkov <bp@alien8.de>
Message-ID: <20160616115648.GB4688@pd.tnic>
References: <cover.1466036668.git.luto@kernel.org>
 <efcd79bf4106d61f1cd258c2caa87f3a0618eeac.1466036668.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <efcd79bf4106d61f1cd258c2caa87f3a0618eeac.1466036668.git.luto@kernel.org>
Subject: [kernel-hardening] Re: [PATCH 09/13] x86/dumpstack: When dumping stack bytes due to
 OOPS, start with regs->sp
To: Andy Lutomirski <luto@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, x86@kernel.org, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 15, 2016 at 05:28:31PM -0700, Andy Lutomirski wrote:
> The comment suggests that show_stack(NULL, NULL) should backtrace
> the current context, but the code doesn't match the comment.  If
> regs are given, start the "Stack:" hexdump at regs->sp.
> 
> Signed-off-by: Andy Lutomirski <luto@kernel.org>

Very nice:

[    0.020008] unchecked MSR access error: RDMSR from 0x1b0 at rIP: 0xffffffff8102849f (init_intel_energy_perf.part.3+0xf/0xd0)
[    0.024003]  0000000000000000 ffffffff81c03f10 ffffffff81028a2f 0000000000000000
[    0.028799]  ffffffff81cad5e0 ffffffff81d5e920 ffffffff81c03f38 ffffffff810271f5
[    0.034887]  ffffffffffffffff ffff88007efd18c0 ffffffff81d5e920 ffffffff81c03f48
[    0.038883] Call Trace:
[    0.040009]  [<ffffffff81028a2f>] init_intel+0xdf/0x2b0
[    0.042055]  [<ffffffff810271f5>] identify_cpu+0x2f5/0x4f0
[    0.044005]  [<ffffffff81cdc198>] identify_boot_cpu+0x10/0x7a
[    0.045577]  [<ffffffff81cdc236>] check_bugs+0x9/0x2d
[    0.047033]  [<ffffffff81cd1ece>] start_kernel+0x3bd/0x3d9
[    0.048005]  [<ffffffff81cd1294>] x86_64_start_reservations+0x2f/0x31
[    0.049668]  [<ffffffff81cd13fe>] x86_64_start_kernel+0x168/0x176

That's exactly what I wanted to see! Thanks for the hints.

Here's what I did:

---
diff --git a/arch/x86/include/asm/kdebug.h b/arch/x86/include/asm/kdebug.h
index e5f5dc9787d5..1ef9d581b5d9 100644
--- a/arch/x86/include/asm/kdebug.h
+++ b/arch/x86/include/asm/kdebug.h
@@ -26,6 +26,7 @@ extern void die(const char *, struct pt_regs *,long);
 extern int __must_check __die(const char *, struct pt_regs *, long);
 extern void show_trace(struct task_struct *t, struct pt_regs *regs,
 		       unsigned long *sp, unsigned long bp);
+extern void show_stack_regs(struct pt_regs *regs);
 extern void __show_regs(struct pt_regs *regs, int all);
 extern unsigned long oops_begin(void);
 extern void oops_end(unsigned long, struct pt_regs *, int signr);
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 400a2e17c1d1..0c3436535b4a 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -206,6 +206,11 @@ void show_stack(struct task_struct *task, unsigned long *sp)
 	show_stack_log_lvl(task, NULL, sp, bp, "");
 }
 
+void show_stack_regs(struct pt_regs *regs)
+{
+	show_stack_log_lvl(current, regs, (unsigned long *)regs->sp, regs->bp, "");
+}
+
 static arch_spinlock_t die_lock = __ARCH_SPIN_LOCK_UNLOCKED;
 static int die_owner = -1;
 static unsigned int die_nest_count;
diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
index 4bb53b89f3c5..fafc771568c7 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -1,6 +1,7 @@
 #include <linux/module.h>
 #include <asm/uaccess.h>
 #include <asm/traps.h>
+#include <asm/kdebug.h>
 
 typedef bool (*ex_handler_t)(const struct exception_table_entry *,
 			    struct pt_regs *, int);
@@ -46,8 +47,9 @@ EXPORT_SYMBOL(ex_handler_ext);
 bool ex_handler_rdmsr_unsafe(const struct exception_table_entry *fixup,
 			     struct pt_regs *regs, int trapnr)
 {
-	WARN_ONCE(1, "unchecked MSR access error: RDMSR from 0x%x\n",
-		  (unsigned int)regs->cx);
+	if (pr_warn_once("unchecked MSR access error: RDMSR from 0x%x at rIP: 0x%lx (%pF)\n",
+			 (unsigned int)regs->cx, regs->ip, (void *)regs->ip))
+		show_stack_regs(regs);
 
 	/* Pretend that the read succeeded and returned 0. */
 	regs->ip = ex_fixup_addr(fixup);
@@ -60,9 +62,10 @@ EXPORT_SYMBOL(ex_handler_rdmsr_unsafe);
 bool ex_handler_wrmsr_unsafe(const struct exception_table_entry *fixup,
 			     struct pt_regs *regs, int trapnr)
 {
-	WARN_ONCE(1, "unchecked MSR access error: WRMSR to 0x%x (tried to write 0x%08x%08x)\n",
-		  (unsigned int)regs->cx,
-		  (unsigned int)regs->dx, (unsigned int)regs->ax);
+	if (pr_warn_once("unchecked MSR access error: WRMSR to 0x%x (tried to write 0x%08x%08x) at rIP: 0x%lx (%pF)\n",
+			 (unsigned int)regs->cx, (unsigned int)regs->dx,
+			 (unsigned int)regs->ax,  regs->ip, (void *)regs->ip))
+		show_stack_regs(regs);
 
 	/* Pretend that the write succeeded. */
 	regs->ip = ex_fixup_addr(fixup);
diff --git a/include/linux/printk.h b/include/linux/printk.h
index f4da695fd615..0a961657e2a0 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -309,20 +309,25 @@ extern asmlinkage void dump_stack(void) __cold;
 #define printk_once(fmt, ...)					\
 ({								\
 	static bool __print_once __read_mostly;			\
+	int __ret_print_once = !__print_once;			\
 								\
 	if (!__print_once) {					\
 		__print_once = true;				\
 		printk(fmt, ##__VA_ARGS__);			\
 	}							\
+	__ret_print_once;					\
 })
+
 #define printk_deferred_once(fmt, ...)				\
 ({								\
 	static bool __print_once __read_mostly;			\
+	int __ret_print_once = !__print_once;			\
 								\
 	if (!__print_once) {					\
 		__print_once = true;				\
 		printk_deferred(fmt, ##__VA_ARGS__);		\
 	}							\
+	__ret_print_once;					\
 })
 #else
 #define printk_once(fmt, ...)					\

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
