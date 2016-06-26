Reply-To: kernel-hardening@lists.openwall.com
From: Andy Lutomirski <luto@kernel.org>
Date: Sun, 26 Jun 2016 14:55:35 -0700
Message-Id: <5ec59addf4d5ee9ed8dc51f9e927867534d0f911.1466974736.git.luto@kernel.org>
In-Reply-To: <cover.1466974736.git.luto@kernel.org>
References: <cover.1466974736.git.luto@kernel.org>
In-Reply-To: <cover.1466974736.git.luto@kernel.org>
References: <cover.1466974736.git.luto@kernel.org>
Subject: [kernel-hardening] [PATCH v4 13/29] x86/dumpstack: Try harder to get a call trace on stack overflow
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Andy Lutomirski <luto@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

If we overflow the stack, print_context_stack will abort.  Detect
this case and rewind back into the valid part of the stack so that
we can trace it.

Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/x86/kernel/dumpstack.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 0d05f113805e..8a2113dfc154 100644
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
@@ -98,6 +98,14 @@ print_context_stack(struct task_struct *task,
 {
 	struct stack_frame *frame = (struct stack_frame *)bp;
 
+	/*
+	 * If we overflowed the stack into a guard page, jump back to the
+	 * bottom of the usable stack.
+	 */
+	if ((unsigned long)task_stack_page(task) - (unsigned long)stack <
+	    PAGE_SIZE)
+		stack = (unsigned long *)task_stack_page(task);
+
 	while (valid_stack_ptr(task, stack, sizeof(*stack), end)) {
 		unsigned long addr;
 
-- 
2.7.4
