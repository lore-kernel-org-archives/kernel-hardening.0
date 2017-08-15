From: Mark Rutland <mark.rutland@arm.com>
Date: Tue, 15 Aug 2017 13:50:37 +0100
Message-Id: <1502801449-29246-3-git-send-email-mark.rutland@arm.com>
In-Reply-To: <1502801449-29246-1-git-send-email-mark.rutland@arm.com>
References: <1502801449-29246-1-git-send-email-mark.rutland@arm.com>
Subject: [kernel-hardening] [PATCHv2 02/14] fork: allow arch-override of VMAP stack alignment
To: linux-arm-kernel@lists.infradead.org
Cc: ard.biesheuvel@linaro.org, catalin.marinas@arm.com, james.morse@arm.com, labbott@redhat.com, linux-kernel@vger.kernel.org, luto@amacapital.net, mark.rutland@arm.com, matt@codeblueprint.co.uk, will.deacon@arm.com, kernel-hardening@lists.openwall.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

In some cases, an architecture might wish its stacks to be aligned to a
boundary larger than THREAD_SIZE. For example, using an alignment of
double THREAD_SIZE can allow for stack overflows smaller than
THREAD_SIZE to be detected by checking a single bit of the stack
pointer.

This patch allows architectures to override the alignment of VMAP'd
stacks, by defining THREAD_ALIGN. Where not defined, this defaults to
THREAD_SIZE, as is the case today.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org
---
 kernel/fork.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 17921b0..696d692 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -217,7 +217,10 @@ static unsigned long *alloc_thread_stack_node(struct task_struct *tsk, int node)
 		return s->addr;
 	}
 
-	stack = __vmalloc_node_range(THREAD_SIZE, THREAD_SIZE,
+#ifndef THREAD_ALIGN
+#define THREAD_ALIGN	THREAD_SIZE
+#endif
+	stack = __vmalloc_node_range(THREAD_SIZE, THREAD_ALIGN,
 				     VMALLOC_START, VMALLOC_END,
 				     THREADINFO_GFP,
 				     PAGE_KERNEL,
-- 
1.9.1
