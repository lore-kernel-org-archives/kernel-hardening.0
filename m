Reply-To: kernel-hardening@lists.openwall.com
From: Andy Lutomirski <luto@kernel.org>
Date: Sun, 26 Jun 2016 14:55:47 -0700
Message-Id: <2730161a8000f2b5cef009483d92fee81fe900d5.1466974736.git.luto@kernel.org>
In-Reply-To: <cover.1466974736.git.luto@kernel.org>
References: <cover.1466974736.git.luto@kernel.org>
In-Reply-To: <cover.1466974736.git.luto@kernel.org>
References: <cover.1466974736.git.luto@kernel.org>
Subject: [kernel-hardening] [PATCH v4 25/29] um: Stop conflating task_struct::stack with thread_info
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Andy Lutomirski <luto@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

From: Linus Torvalds <torvalds@linux-foundation.org>

thread_info may move in the future, so use the accessors.

[changelog written by Andy]
Message-Id: <CA+55aFxvZhBu9U1cqpVm4frv0p5mqu=0TxsSqE-=95ft8HvCVA@mail.gmail.com>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/x86/um/ptrace_32.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/um/ptrace_32.c b/arch/x86/um/ptrace_32.c
index ebd4dd6ef73b..14e8f6a628c2 100644
--- a/arch/x86/um/ptrace_32.c
+++ b/arch/x86/um/ptrace_32.c
@@ -191,7 +191,7 @@ int peek_user(struct task_struct *child, long addr, long data)
 
 static int get_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
 {
-	int err, n, cpu = ((struct thread_info *) child->stack)->cpu;
+	int err, n, cpu = task_thread_info(child)->cpu;
 	struct user_i387_struct fpregs;
 
 	err = save_i387_registers(userspace_pid[cpu],
@@ -208,7 +208,7 @@ static int get_fpregs(struct user_i387_struct __user *buf, struct task_struct *c
 
 static int set_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
 {
-	int n, cpu = ((struct thread_info *) child->stack)->cpu;
+	int n, cpu = task_thread_info(child)->cpu;
 	struct user_i387_struct fpregs;
 
 	n = copy_from_user(&fpregs, buf, sizeof(fpregs));
@@ -221,7 +221,7 @@ static int set_fpregs(struct user_i387_struct __user *buf, struct task_struct *c
 
 static int get_fpxregs(struct user_fxsr_struct __user *buf, struct task_struct *child)
 {
-	int err, n, cpu = ((struct thread_info *) child->stack)->cpu;
+	int err, n, cpu = task_thread_info(child)->cpu;
 	struct user_fxsr_struct fpregs;
 
 	err = save_fpx_registers(userspace_pid[cpu], (unsigned long *) &fpregs);
@@ -237,7 +237,7 @@ static int get_fpxregs(struct user_fxsr_struct __user *buf, struct task_struct *
 
 static int set_fpxregs(struct user_fxsr_struct __user *buf, struct task_struct *child)
 {
-	int n, cpu = ((struct thread_info *) child->stack)->cpu;
+	int n, cpu = task_thread_info(child)->cpu;
 	struct user_fxsr_struct fpregs;
 
 	n = copy_from_user(&fpregs, buf, sizeof(fpregs));
-- 
2.7.4
