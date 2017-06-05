From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon,  5 Jun 2017 18:16:54 +0200
Message-Id: <20170605153021.008595891@linuxfoundation.org>
In-Reply-To: <20170605153020.953645204@linuxfoundation.org>
References: <20170605153020.953645204@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] [PATCH 3.18 01/33] Revert "stackprotector: Increase the per-task stack canarys random range from 32 bits to 64 bits on 64-bit platforms"
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, =?UTF-8?q?Philip=20M=C3=BCller?= <philm@manjaro.org>, Daniel Micay <danielmicay@gmail.com>, Arjan van de Ven <arjan@linux.intel.com>, Rik van Riel <riel@redhat.com>, Kees Cook <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, kernel-hardening@lists.openwall.com, Ingo Molnar <mingo@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 609a3e81550b0b4ea87197b0f59455a7bcff975a which is
commit 5ea30e4e58040cfd6434c2f33dc3ea76e2c15b05 upstream.

It shouldn't have been backported to 3.18, as we do not have
get_random_long() in that kernel tree.

Reported-by: Philip Müller <philm@manjaro.org>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Arjan van Ven <arjan@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: kernel-hardening@lists.openwall.com
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -338,7 +338,7 @@ static struct task_struct *dup_task_stru
 	set_task_stack_end_magic(tsk);
 
 #ifdef CONFIG_CC_STACKPROTECTOR
-	tsk->stack_canary = get_random_long();
+	tsk->stack_canary = get_random_int();
 #endif
 
 	/*
