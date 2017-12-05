From: Alexander Popov <alex.popov@linux.com>
Date: Wed,  6 Dec 2017 02:33:44 +0300
Message-Id: <1512516827-29797-4-git-send-email-alex.popov@linux.com>
In-Reply-To: <1512516827-29797-1-git-send-email-alex.popov@linux.com>
References: <1512516827-29797-1-git-send-email-alex.popov@linux.com>
Subject: [kernel-hardening] [PATCH RFC v6 3/6] x86/entry: Erase kernel stack in syscall_trace_enter()
To: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, x86@kernel.org, alex.popov@linux.com
List-ID: <kernel-hardening.lists.openwall.com>

Make STACKLEAK erase kernel stack after ptrace/seccomp/auditing
not to leave any sensitive information on the stack for the syscall code.

This code is modified from Brad Spengler/PaX Team's code in the last
public patch of grsecurity/PaX based on our understanding of the code.
Changes or omissions from the original code are ours and don't reflect
the original grsecurity/PaX code.

Signed-off-by: Alexander Popov <alex.popov@linux.com>
---
 arch/x86/entry/common.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index d7d3cc2..d45b7cf 100644
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
@@ -81,11 +87,15 @@ static long syscall_trace_enter(struct pt_regs *regs)
 		emulated = true;
 
 	if ((emulated || (work & _TIF_SYSCALL_TRACE)) &&
-	    tracehook_report_syscall_entry(regs))
+	    tracehook_report_syscall_entry(regs)) {
+		erase_kstack();
 		return -1L;
+	}
 
-	if (emulated)
+	if (emulated) {
+		erase_kstack();
 		return -1L;
+	}
 
 #ifdef CONFIG_SECCOMP
 	/*
@@ -117,8 +127,10 @@ static long syscall_trace_enter(struct pt_regs *regs)
 		}
 
 		ret = __secure_computing(&sd);
-		if (ret == -1)
+		if (ret == -1) {
+			erase_kstack();
 			return ret;
+		}
 	}
 #endif
 
@@ -127,6 +139,7 @@ static long syscall_trace_enter(struct pt_regs *regs)
 
 	do_audit_syscall_entry(regs, arch);
 
+	erase_kstack();
 	return ret ?: regs->orig_ax;
 }
 
-- 
2.7.4
