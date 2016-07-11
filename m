Reply-To: kernel-hardening@lists.openwall.com
From: Andy Lutomirski <luto@kernel.org>
Date: Mon, 11 Jul 2016 13:53:58 -0700
Message-Id: <e6a9327942cc033f7d225b8202ecfc3ec3c6dec8.1468270393.git.luto@kernel.org>
In-Reply-To: <cover.1468270393.git.luto@kernel.org>
References: <cover.1468270393.git.luto@kernel.org>
In-Reply-To: <cover.1468270393.git.luto@kernel.org>
References: <cover.1468270393.git.luto@kernel.org>
Subject: [kernel-hardening] [PATCH v5 25/32] um: Stop conflating task_struct::stack with thread_info
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Andy Lutomirski <luto@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

From: Linus Torvalds <torvalds@linux-foundation.org>

thread_info may move in the future, so use the accessors.

Andy Lutomirski wrote this changelog message and changed
"task_thread_info(child)->cpu" to "task_cpu(child)".

Message-Id: <CA+55aFxvZhBu9U1cqpVm4frv0p5mqu=0TxsSqE-=95ft8HvCVA@mail.gmail.com>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/x86/um/ptrace_32.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/um/ptrace_32.c b/arch/x86/um/ptrace_32.c
index ebd4dd6ef73b..2a6f781ce9cf 100644
--- a/arch/x86/um/ptrace_32.c
+++ b/arch/x86/um/ptrace_32.c
@@ -191,7 +191,7 @@ int peek_user(struct task_struct *child, long addr, long data)
 
 static int get_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
 {
-	int err, n, cpu = ((struct thread_info *) child->stack)->cpu;
+	int err, n, cpu = task_cpu(child);
 	struct user_i387_struct fpregs;
 
 	err = save_i387_registers(userspace_pid[cpu],
@@ -208,7 +208,7 @@ static int get_fpregs(struct user_i387_struct __user *buf, struct task_struct *c
 
 static int set_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
 {
-	int n, cpu = ((struct thread_info *) child->stack)->cpu;
+	int n, cpu = task_cpu(child);
 	struct user_i387_struct fpregs;
 
 	n = copy_from_user(&fpregs, buf, sizeof(fpregs));
@@ -221,7 +221,7 @@ static int set_fpregs(struct user_i387_struct __user *buf, struct task_struct *c
 
 static int get_fpxregs(struct user_fxsr_struct __user *buf, struct task_struct *child)
 {
-	int err, n, cpu = ((struct thread_info *) child->stack)->cpu;
+	int err, n, cpu = task_cpu(child);
 	struct user_fxsr_struct fpregs;
 
 	err = save_fpx_registers(userspace_pid[cpu], (unsigned long *) &fpregs);
@@ -237,7 +237,7 @@ static int get_fpxregs(struct user_fxsr_struct __user *buf, struct task_struct *
 
 static int set_fpxregs(struct user_fxsr_struct __user *buf, struct task_struct *child)
 {
-	int n, cpu = ((struct thread_info *) child->stack)->cpu;
+	int n, cpu = task_cpu(child);
 	struct user_fxsr_struct fpregs;
 
 	n = copy_from_user(&fpregs, buf, sizeof(fpregs));
-- 
2.7.4
