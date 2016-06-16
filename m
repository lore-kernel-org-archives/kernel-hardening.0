Reply-To: kernel-hardening@lists.openwall.com
From: Andy Lutomirski <luto@kernel.org>
Date: Wed, 15 Jun 2016 17:28:29 -0700
Message-Id: <73fa53f32b34bd672d0f0e8f596f7982c71090d2.1466036668.git.luto@kernel.org>
In-Reply-To: <cover.1466036668.git.luto@kernel.org>
References: <cover.1466036668.git.luto@kernel.org>
In-Reply-To: <cover.1466036668.git.luto@kernel.org>
References: <cover.1466036668.git.luto@kernel.org>
Subject: [kernel-hardening] [PATCH 07/13] x86/die: Don't try to recover from an OOPS on a non-default stack
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, x86@kernel.org, Borislav Petkov <bp@alien8.de>
Cc: Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Andy Lutomirski <luto@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

It's not going to work, because the scheduler will explode if we try
to schedule when running on an IST stack or similar.

This will matter when we let kernel stack overflows (which are #DF)
call die().

Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/x86/kernel/dumpstack.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 2bb25c3fe2e8..36effb39c9c9 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -247,6 +247,9 @@ void oops_end(unsigned long flags, struct pt_regs *regs, int signr)
 		return;
 	if (in_interrupt())
 		panic("Fatal exception in interrupt");
+	if (((current_stack_pointer() ^ (current_top_of_stack() - 1))
+	     & ~(THREAD_SIZE - 1)) != 0)
+		panic("Fatal exception on special stack");
 	if (panic_on_oops)
 		panic("Fatal exception");
 	do_exit(signr);
-- 
2.7.4
