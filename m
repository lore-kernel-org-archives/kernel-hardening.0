Reply-To: kernel-hardening@lists.openwall.com
From: Jann Horn <jann@thejh.net>
Date: Mon, 31 Oct 2016 15:04:01 +0100
Message-Id: <1477922641-2221-1-git-send-email-jann@thejh.net>
Subject: [kernel-hardening] [PATCH] fork: make whole stack_canary random
To: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Daniel Micay <danielmicay@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On machines with sizeof(unsigned long)==8, this ensures that the more
significant 32 bits of stack_canary are random, too.
stack_canary is defined as unsigned long, all the architectures with stack
protector support already pick the stack_canary of init as a random
unsigned long, and get_random_long() should be as fast as get_random_int(),
so there seems to be no good reason against this.

This should help if someone tries to guess a stack canary with brute force.

(This change has been made in PaX already, with a different RNG.)

Signed-off-by: Jann Horn <jann@thejh.net>
---
 kernel/fork.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 623259fc794d..d577e2c5d14f 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -518,7 +518,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
 	set_task_stack_end_magic(tsk);
 
 #ifdef CONFIG_CC_STACKPROTECTOR
-	tsk->stack_canary = get_random_int();
+	tsk->stack_canary = get_random_long();
 #endif
 
 	/*
-- 
2.1.4
