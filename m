Reply-To: kernel-hardening@lists.openwall.com
From: Andy Lutomirski <luto@kernel.org>
Date: Sun, 26 Jun 2016 14:55:34 -0700
Message-Id: <2b6ce8977c1fc11fbcc2f97e7e79eef776fd5b8d.1466974736.git.luto@kernel.org>
In-Reply-To: <cover.1466974736.git.luto@kernel.org>
References: <cover.1466974736.git.luto@kernel.org>
In-Reply-To: <cover.1466974736.git.luto@kernel.org>
References: <cover.1466974736.git.luto@kernel.org>
Subject: [kernel-hardening] [PATCH v4 12/29] x86/dumpstack: When dumping stack bytes due to OOPS, start with regs->sp
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Andy Lutomirski <luto@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

The comment suggests that show_stack(NULL, NULL) should backtrace
the current context, but the code doesn't match the comment.  If
regs are given, start the "Stack:" hexdump at regs->sp.

Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/x86/kernel/dumpstack_32.c | 4 +++-
 arch/x86/kernel/dumpstack_64.c | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index fef917e79b9d..948d77da3881 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -96,7 +96,9 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 	int i;
 
 	if (sp == NULL) {
-		if (task)
+		if (regs)
+			sp = (unsigned long *)regs->sp;
+		else if (task)
 			sp = (unsigned long *)task->thread.sp;
 		else
 			sp = (unsigned long *)&sp;
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index d558a8a49016..a81e1ef73bf2 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -264,7 +264,9 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 	 * back trace for this cpu:
 	 */
 	if (sp == NULL) {
-		if (task)
+		if (regs)
+			sp = (unsigned long *)regs->sp;
+		else if (task)
 			sp = (unsigned long *)task->thread.sp;
 		else
 			sp = (unsigned long *)&sp;
-- 
2.7.4
