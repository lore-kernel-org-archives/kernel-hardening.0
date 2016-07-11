Reply-To: kernel-hardening@lists.openwall.com
From: Andy Lutomirski <luto@kernel.org>
Date: Mon, 11 Jul 2016 13:54:03 -0700
Message-Id: <e3696f6ad079ee12ce50317a53f14ff3adb84ad1.1468270393.git.luto@kernel.org>
In-Reply-To: <cover.1468270393.git.luto@kernel.org>
References: <cover.1468270393.git.luto@kernel.org>
In-Reply-To: <cover.1468270393.git.luto@kernel.org>
References: <cover.1468270393.git.luto@kernel.org>
Subject: [kernel-hardening] [PATCH v5 30/32] x86/dumpstack: Pin the target stack in save_stack_trace_tsk()
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Andy Lutomirski <luto@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

This will prevent a crash if the target task dies before or while
dumping its stack once we start freeing task stacks early.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/x86/kernel/stacktrace.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index 9ee98eefc44d..cc0826409a21 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -79,9 +79,14 @@ void save_stack_trace_regs(struct pt_regs *regs, struct stack_trace *trace)
 
 void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
 {
+	if (!try_get_task_stack(tsk))
+		return;
+
 	dump_trace(tsk, NULL, NULL, 0, &save_stack_ops_nosched, trace);
 	if (trace->nr_entries < trace->max_entries)
 		trace->entries[trace->nr_entries++] = ULONG_MAX;
+
+	put_task_stack(tsk);
 }
 EXPORT_SYMBOL_GPL(save_stack_trace_tsk);
 
-- 
2.7.4
