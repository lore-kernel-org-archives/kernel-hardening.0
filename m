Reply-To: kernel-hardening@lists.openwall.com
From: Mark Rutland <mark.rutland@arm.com>
Date: Thu, 15 Sep 2016 14:49:02 +0100
Message-Id: <1473947349-14521-2-git-send-email-mark.rutland@arm.com>
In-Reply-To: <1473947349-14521-1-git-send-email-mark.rutland@arm.com>
References: <1473947349-14521-1-git-send-email-mark.rutland@arm.com>
Subject: [kernel-hardening] [RFC PATCH 1/8] thread_info: include <current.h> for THREAD_INFO_IN_TASK
To: linux-arm-kernel@lists.infradead.org
Cc: akpm@linux-foundation.org, ard.biesheuvel@linaro.org, catalin.marinas@arm.com, james.morse@arm.com, keescook@chromium.org, linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, luto@kernel.org, mark.rutland@arm.com, suzuki.poulose@arm.com, takahiro.akashi@linaro.org, will.deacon@arm.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

When CONFIG_THREAD_INFO_IN_TASK is selected, the current_thread_info()
macro relies on current having been defined prior to its use. However,
not all users of current_thread_info() include <asm/current.h>, and thus
current is not guaranteed to be defined.

When CONFIG_THREAD_INFO_IN_TASK is not selected, it's possible that
get_current() / current are based upon current_thread_info(), and
<asm/current.h> includes <asm/thread_info.h>. Thus always including
<asm/current.h> would result in circular dependences on some platforms.

To ensure both cases work, this patch includes <asm/current.h>, but only
when CONFIG_THREAD_INFO_IN_TASK is selected.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org
---
 include/linux/thread_info.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index cb0ed34..d9622f7 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -25,6 +25,7 @@ struct thread_info {
 #endif
 
 #ifdef CONFIG_THREAD_INFO_IN_TASK
+#include <asm/current.h>
 #define current_thread_info() ((struct thread_info *)current)
 #endif
 
-- 
1.9.1
