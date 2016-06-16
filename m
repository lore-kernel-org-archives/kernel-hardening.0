Reply-To: kernel-hardening@lists.openwall.com
From: Andy Lutomirski <luto@kernel.org>
Date: Wed, 15 Jun 2016 17:28:32 -0700
Message-Id: <f3202c855a2a61ae4c37d8b3835e00fb384c56b9.1466036668.git.luto@kernel.org>
In-Reply-To: <cover.1466036668.git.luto@kernel.org>
References: <cover.1466036668.git.luto@kernel.org>
In-Reply-To: <cover.1466036668.git.luto@kernel.org>
References: <cover.1466036668.git.luto@kernel.org>
Subject: [kernel-hardening] [PATCH 10/13] x86/dumpstack: Try harder to get a call trace on stack overflow
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, x86@kernel.org, Borislav Petkov <bp@alien8.de>
Cc: Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Andy Lutomirski <luto@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

If we overflow the stack, print_context_stack will abort.  Detect
this case and rewind back into the valid part of the stack so that
we can trace it.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/x86/kernel/dumpstack.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index d4d085e27d04..400a2e17c1d1 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -100,6 +100,13 @@ print_context_stack(struct thread_info *tinfo,
 {
 	struct stack_frame *frame = (struct stack_frame *)bp;
 
+	/*
+	 * If we overflowed the stack into a guard page, jump back to the
+	 * bottom of the usable stack.
+	 */
+	if ((unsigned long)tinfo - (unsigned long)stack < PAGE_SIZE)
+		stack = (unsigned long *)tinfo + 1;
+
 	while (valid_stack_ptr(tinfo, stack, sizeof(*stack), end)) {
 		unsigned long addr;
 
-- 
2.7.4
