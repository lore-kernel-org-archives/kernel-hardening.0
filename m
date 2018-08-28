Date: Tue, 28 Aug 2018 22:14:17 +0200
In-Reply-To: <20180828201421.157735-1-jannh@google.com>
Message-Id: <20180828201421.157735-4-jannh@google.com>
Mime-Version: 1.0
References: <20180828201421.157735-1-jannh@google.com>
Subject: [PATCH v3 3/7] x86: stop calling fixup_exception() from kprobe_fault_handler()
From: Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Andy Lutomirski <luto@kernel.org>, kernel-hardening@lists.openwall.com, jannh@google.com
Cc: linux-kernel@vger.kernel.org, dvyukov@google.com, Masami Hiramatsu <mhiramat@kernel.org>, "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>, Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>, "David S. Miller" <davem@davemloft.net>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Borislav Petkov <bp@alien8.de>
List-ID: <kernel-hardening.lists.openwall.com>

This removes the call into exception fixup that was added in
commit c28f896634f2 ("[PATCH] kprobes: fix broken fault handling for
x86_64").

On X86, kprobe_fault_handler() is called from two places:
do_general_protection() (for #GP) and kprobes_fault() (for #PF).
In both paths, the fixup_exception() call in the kprobe fault handler is
redundant.

For #GP, fixup_exception() is called immediately before
kprobe_fault_handler() is invoked - if someone wanted to fix up our #GP,
they've already done so, no need to try again. (This assumes that the
kprobe's fault handler isn't going to do something crazy like changing RIP
so that it suddenly points to an instruction that does userspace access.)

For #PF on a kernel address from kernel space, after the kprobe fault
handler has run, we'll go into no_context(), which calls fixup_exception().

Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Jann Horn <jannh@google.com>
---
 arch/x86/kernel/kprobes/core.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 467ac22691b0..7315ac202aad 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -1021,13 +1021,6 @@ int kprobe_fault_handler(struct pt_regs *regs, int trapnr)
 		if (cur->fault_handler && cur->fault_handler(cur, regs, trapnr))
 			return 1;
 
-		/*
-		 * In case the user-specified fault handler returned
-		 * zero, try to fix up.
-		 */
-		if (fixup_exception(regs, trapnr))
-			return 1;
-
 		/* fixup routine could not handle it. */
 	}
 
-- 
2.19.0.rc0.228.g281dcd1b4d0-goog
