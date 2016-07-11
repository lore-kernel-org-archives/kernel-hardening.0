Reply-To: kernel-hardening@lists.openwall.com
From: Andy Lutomirski <luto@kernel.org>
Date: Mon, 11 Jul 2016 13:53:56 -0700
Message-Id: <3dcc5eccd7516153174c8e2c54387b73beb30bb6.1468270393.git.luto@kernel.org>
In-Reply-To: <cover.1468270393.git.luto@kernel.org>
References: <cover.1468270393.git.luto@kernel.org>
In-Reply-To: <cover.1468270393.git.luto@kernel.org>
References: <cover.1468270393.git.luto@kernel.org>
Subject: [kernel-hardening] [PATCH v5 23/32] printk: When dumping regs, show the stack, not thread_info
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Andy Lutomirski <luto@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

We currently show:

  task: <current> ti: <current_thread_info()> task.ti: <task_thread_info(current)>"

"ti" and "task.ti" are redundant, and neither is actually what we
want to show, which the the base of the thread stack.  Change the
display to show the stack pointer explicitly.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 kernel/printk/printk.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 60cdf6386763..d4de33934dac 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -3177,9 +3177,8 @@ void show_regs_print_info(const char *log_lvl)
 {
 	dump_stack_print_info(log_lvl);
 
-	printk("%stask: %p ti: %p task.ti: %p\n",
-	       log_lvl, current, current_thread_info(),
-	       task_thread_info(current));
+	printk("%stask: %p task.stack: %p\n",
+	       log_lvl, current, task_stack_page(current));
 }
 
 #endif
-- 
2.7.4
