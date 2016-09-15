Reply-To: kernel-hardening@lists.openwall.com
From: Mark Rutland <mark.rutland@arm.com>
Date: Thu, 15 Sep 2016 14:49:05 +0100
Message-Id: <1473947349-14521-5-git-send-email-mark.rutland@arm.com>
In-Reply-To: <1473947349-14521-1-git-send-email-mark.rutland@arm.com>
References: <1473947349-14521-1-git-send-email-mark.rutland@arm.com>
Subject: [kernel-hardening] [RFC PATCH 4/8] arm64: asm-offsets: remove unused definitions
To: linux-arm-kernel@lists.infradead.org
Cc: akpm@linux-foundation.org, ard.biesheuvel@linaro.org, catalin.marinas@arm.com, james.morse@arm.com, keescook@chromium.org, linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, luto@kernel.org, mark.rutland@arm.com, suzuki.poulose@arm.com, takahiro.akashi@linaro.org, will.deacon@arm.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Subsequent patches will move the thread_info::{task,cpu} fields, and the
current TI_{TASK,CPU} offset definitions are not used anywhere.

This patch removes the redundant definitions.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/kernel/asm-offsets.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 05070b7..ee764eb 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -38,8 +38,6 @@ int main(void)
   DEFINE(TI_FLAGS,		offsetof(struct thread_info, flags));
   DEFINE(TI_PREEMPT,		offsetof(struct thread_info, preempt_count));
   DEFINE(TI_ADDR_LIMIT,		offsetof(struct thread_info, addr_limit));
-  DEFINE(TI_TASK,		offsetof(struct thread_info, task));
-  DEFINE(TI_CPU,		offsetof(struct thread_info, cpu));
   BLANK();
   DEFINE(THREAD_CPU_CONTEXT,	offsetof(struct task_struct, thread.cpu_context));
   BLANK();
-- 
1.9.1
