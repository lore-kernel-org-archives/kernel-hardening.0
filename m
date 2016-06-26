Reply-To: kernel-hardening@lists.openwall.com
From: Andy Lutomirski <luto@kernel.org>
Date: Sun, 26 Jun 2016 14:55:32 -0700
Message-Id: <37ac7589ff0ea147e8a21cda5eb84d3af1f6cd60.1466974736.git.luto@kernel.org>
In-Reply-To: <cover.1466974736.git.luto@kernel.org>
References: <cover.1466974736.git.luto@kernel.org>
In-Reply-To: <cover.1466974736.git.luto@kernel.org>
References: <cover.1466974736.git.luto@kernel.org>
Subject: [kernel-hardening] [PATCH v4 10/29] x86/die: Don't try to recover from an OOPS on a non-default stack
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Andy Lutomirski <luto@kernel.org>
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
index ef8017ca5ba9..352f022cfd5b 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -245,6 +245,9 @@ void oops_end(unsigned long flags, struct pt_regs *regs, int signr)
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
