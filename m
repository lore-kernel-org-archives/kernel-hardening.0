Date: Tue, 28 Aug 2018 22:14:16 +0200
In-Reply-To: <20180828201421.157735-1-jannh@google.com>
Message-Id: <20180828201421.157735-3-jannh@google.com>
Mime-Version: 1.0
References: <20180828201421.157735-1-jannh@google.com>
Subject: [PATCH v3 2/7] x86: inline kprobe_exceptions_notify() into do_general_protection()
From: Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Andy Lutomirski <luto@kernel.org>, kernel-hardening@lists.openwall.com, jannh@google.com
Cc: linux-kernel@vger.kernel.org, dvyukov@google.com, Masami Hiramatsu <mhiramat@kernel.org>, "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>, Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>, "David S. Miller" <davem@davemloft.net>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Borislav Petkov <bp@alien8.de>
List-ID: <kernel-hardening.lists.openwall.com>

The opaque plumbing of #GP from do_general_protection() through
notify_die() into kprobe_exceptions_notify() makes it hard to understand
what's going on.

Suggested-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Jann Horn <jannh@google.com>
---
 arch/x86/kernel/kprobes/core.c | 31 +------------------------------
 arch/x86/kernel/traps.c        | 10 ++++++++++
 2 files changed, 11 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index b0d1e81c96bb..467ac22691b0 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -1028,42 +1028,13 @@ int kprobe_fault_handler(struct pt_regs *regs, int trapnr)
 		if (fixup_exception(regs, trapnr))
 			return 1;
 
-		/*
-		 * fixup routine could not handle it,
-		 * Let do_page_fault() fix it.
-		 */
+		/* fixup routine could not handle it. */
 	}
 
 	return 0;
 }
 NOKPROBE_SYMBOL(kprobe_fault_handler);
 
-/*
- * Wrapper routine for handling exceptions.
- */
-int kprobe_exceptions_notify(struct notifier_block *self, unsigned long val,
-			     void *data)
-{
-	struct die_args *args = data;
-	int ret = NOTIFY_DONE;
-
-	if (args->regs && user_mode(args->regs))
-		return ret;
-
-	if (val == DIE_GPF) {
-		/*
-		 * To be potentially processing a kprobe fault and to
-		 * trust the result from kprobe_running(), we have
-		 * be non-preemptible.
-		 */
-		if (!preemptible() && kprobe_running() &&
-		    kprobe_fault_handler(args->regs, args->trapnr))
-			ret = NOTIFY_STOP;
-	}
-	return ret;
-}
-NOKPROBE_SYMBOL(kprobe_exceptions_notify);
-
 bool arch_within_kprobe_blacklist(unsigned long addr)
 {
 	bool is_in_entry_trampoline_section = false;
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index e6db475164ed..bf9ab1aaa175 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -556,6 +556,16 @@ do_general_protection(struct pt_regs *regs, long error_code)
 
 		tsk->thread.error_code = error_code;
 		tsk->thread.trap_nr = X86_TRAP_GP;
+
+		/*
+		 * To be potentially processing a kprobe fault and to
+		 * trust the result from kprobe_running(), we have to
+		 * be non-preemptible.
+		 */
+		if (!preemptible() && kprobe_running() &&
+		    kprobe_fault_handler(regs, X86_TRAP_GP))
+			return;
+
 		if (notify_die(DIE_GPF, "general protection fault", regs, error_code,
 			       X86_TRAP_GP, SIGSEGV) != NOTIFY_STOP)
 			die("general protection fault", regs, error_code);
-- 
2.19.0.rc0.228.g281dcd1b4d0-goog
