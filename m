Reply-To: kernel-hardening@lists.openwall.com
From: Mark Rutland <mark.rutland@arm.com>
Date: Thu, 15 Sep 2016 14:49:04 +0100
Message-Id: <1473947349-14521-4-git-send-email-mark.rutland@arm.com>
In-Reply-To: <1473947349-14521-1-git-send-email-mark.rutland@arm.com>
References: <1473947349-14521-1-git-send-email-mark.rutland@arm.com>
Subject: [kernel-hardening] [RFC PATCH 3/8] arm64: thread_info remove stale items
To: linux-arm-kernel@lists.infradead.org
Cc: akpm@linux-foundation.org, ard.biesheuvel@linaro.org, catalin.marinas@arm.com, james.morse@arm.com, keescook@chromium.org, linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, luto@kernel.org, mark.rutland@arm.com, suzuki.poulose@arm.com, takahiro.akashi@linaro.org, will.deacon@arm.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

We have a comment claiming __switch_to() cares about where cpu_context
is located relative to cpu_domain in thread_info. However arm64 has
never had a thread_info::cpu_domain field, and neither __switch_to nor
cpu_switch_to care where the cpu_context field is relative to others.

Additionally, the init_thread_info alias is never used anywhere in the
kernel, and will shortly become problematic when thread_info is moved
into task_struct.

This patch removes both.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/thread_info.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index abd64bd..796af24 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -42,7 +42,6 @@ typedef unsigned long mm_segment_t;
 
 /*
  * low level task data that entry.S needs immediate access to.
- * __switch_to() assumes cpu_context follows immediately after cpu_domain.
  */
 struct thread_info {
 	unsigned long		flags;		/* low level flags */
@@ -60,7 +59,6 @@ struct thread_info {
 	.addr_limit	= KERNEL_DS,					\
 }
 
-#define init_thread_info	(init_thread_union.thread_info)
 #define init_stack		(init_thread_union.stack)
 
 /*
-- 
1.9.1
