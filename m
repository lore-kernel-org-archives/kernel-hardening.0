From: Alexander Popov <alex.popov@linux.com>
Date: Fri, 12 Jan 2018 17:19:26 +0300
Message-Id: <1515766769-9120-4-git-send-email-alex.popov@linux.com>
In-Reply-To: <1515766769-9120-1-git-send-email-alex.popov@linux.com>
References: <1515766769-9120-1-git-send-email-alex.popov@linux.com>
Subject: [kernel-hardening] [PATCH RFC v7 3/6] x86/entry: Erase kernel stack in syscall_trace_enter()
To: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, x86@kernel.org, alex.popov@linux.com
List-ID: <kernel-hardening.lists.openwall.com>

Make STACKLEAK erase kernel stack after ptrace/seccomp/auditing
not to leave any sensitive information on the stack for the syscall code.

This code is modified from Brad Spengler/PaX Team's code in the last
public patch of grsecurity/PaX based on our understanding of the code.
Changes or omissions from the original code are ours and don't reflect
the original grsecurity/PaX code.

Signed-off-by: Alexander Popov <alex.popov@linux.com>
---
 arch/x86/entry/common.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index d7d3cc2..cd38727 100644
--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -45,6 +45,12 @@ __visible inline void enter_from_user_mode(void)
 static inline void enter_from_user_mode(void) {}
 #endif
 
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+asmlinkage void erase_kstack(void);
+#else
+static void erase_kstack(void) {}
+#endif
+
 static void do_audit_syscall_entry(struct pt_regs *regs, u32 arch)
 {
 #ifdef CONFIG_X86_64
@@ -127,6 +133,7 @@ static long syscall_trace_enter(struct pt_regs *regs)
 
 	do_audit_syscall_entry(regs, arch);
 
+	erase_kstack();
 	return ret ?: regs->orig_ax;
 }
 
-- 
2.7.4
