Reply-To: kernel-hardening@lists.openwall.com
From: Andy Lutomirski <luto@kernel.org>
Date: Thu, 23 Jun 2016 21:23:08 -0700
Message-Id: <f76b49739625fce1264428155540ca7161925511.1466741835.git.luto@kernel.org>
In-Reply-To: <cover.1466741835.git.luto@kernel.org>
References: <cover.1466741835.git.luto@kernel.org>
In-Reply-To: <cover.1466741835.git.luto@kernel.org>
References: <cover.1466741835.git.luto@kernel.org>
Subject: [kernel-hardening] [PATCH v4 13/16] x86/dumpstack: Try harder to get a call trace on stack overflow
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Andy Lutomirski <luto@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

If we overflow the stack, print_context_stack will abort.  Detect
this case and rewind back into the valid part of the stack so that
we can trace it.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/x86/kernel/dumpstack.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 4592bc4ed3e1..4538f7ca9072 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -87,7 +87,7 @@ static inline int valid_stack_ptr(struct task_struct *task,
 		else
 			return 0;
 	}
-	return p > t && p < t + THREAD_SIZE - size;
+	return p >= t && p < t + THREAD_SIZE - size;
 }
 
 unsigned long
@@ -98,6 +98,13 @@ print_context_stack(struct task_struct *task,
 {
 	struct stack_frame *frame = (struct stack_frame *)bp;
 
+	/*
+	 * If we overflowed the stack into a guard page, jump back to the
+	 * bottom of the usable stack.
+	 */
+	if ((unsigned long)task->stack - (unsigned long)stack < PAGE_SIZE)
+		stack = (unsigned long *)task->stack;
+
 	while (valid_stack_ptr(task, stack, sizeof(*stack), end)) {
 		unsigned long addr;
 
-- 
2.5.5
