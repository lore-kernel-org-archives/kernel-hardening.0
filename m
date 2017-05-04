From: Daniel Micay <danielmicay@gmail.com>
Date: Thu,  4 May 2017 09:32:09 -0400
Message-Id: <20170504133209.3053-1-danielmicay@gmail.com>
Subject: [kernel-hardening] [PATCH] use get_random_long for the per-task stack canary
To: Kees Cook <keescook@chromium.org>, Arjan van Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
Cc: Daniel Micay <danielmicay@gmail.com>, stable@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

The stack canary is an unsigned long and should be fully initialized to
random data rather than only 32 bits of random data.

Cc: stable@vger.kernel.org
Signed-off-by: Daniel Micay <danielmicay@gmail.com>
---
 kernel/fork.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 56d85fd81411..ff84ff82f56a 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -537,7 +537,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
 	set_task_stack_end_magic(tsk);
 
 #ifdef CONFIG_CC_STACKPROTECTOR
-	tsk->stack_canary = get_random_int();
+	tsk->stack_canary = get_random_long();
 #endif
 
 	/*
-- 
2.12.2
