From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Tue, 23 May 2017 22:08:42 +0200
Message-Id: <20170523200837.655149481@linuxfoundation.org>
In-Reply-To: <20170523200821.666872592@linuxfoundation.org>
References: <20170523200821.666872592@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] [PATCH 4.11 161/197] stackprotector: Increase the per-task stack canarys random range from 32 bits to 64 bits on 64-bit platforms
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Daniel Micay <danielmicay@gmail.com>, Arjan van de Ven <arjan@linux.intel.com>, Rik van Riel <riel@redhat.com>, Kees Cook <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, kernel-hardening@lists.openwall.com, Ingo Molnar <mingo@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

4.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Micay <danielmicay@gmail.com>

commit 5ea30e4e58040cfd6434c2f33dc3ea76e2c15b05 upstream.

The stack canary is an 'unsigned long' and should be fully initialized to
random data rather than only 32 bits of random data.

Signed-off-by: Daniel Micay <danielmicay@gmail.com>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Arjan van Ven <arjan@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: kernel-hardening@lists.openwall.com
Link: http://lkml.kernel.org/r/20170504133209.3053-1-danielmicay@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -536,7 +536,7 @@ static struct task_struct *dup_task_stru
 	set_task_stack_end_magic(tsk);
 
 #ifdef CONFIG_CC_STACKPROTECTOR
-	tsk->stack_canary = get_random_int();
+	tsk->stack_canary = get_random_long();
 #endif
 
 	/*
