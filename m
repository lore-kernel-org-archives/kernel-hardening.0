From: Mark Rutland <mark.rutland@arm.com>
Date: Mon,  7 Aug 2017 19:35:56 +0100
Message-Id: <1502130965-18710-6-git-send-email-mark.rutland@arm.com>
In-Reply-To: <1502130965-18710-1-git-send-email-mark.rutland@arm.com>
References: <1502130965-18710-1-git-send-email-mark.rutland@arm.com>
Subject: [kernel-hardening] [PATCH 05/14] arm64: clean up THREAD_* definitions
To: linux-arm-kernel@lists.infradead.org
Cc: ard.biesheuvel@linaro.org, catalin.marinas@arm.com, james.morse@arm.com, labbott@redhat.com, linux-kernel@vger.kernel.org, luto@amacapital.net, mark.rutland@arm.com, matt@codeblueprint.co.uk, will.deacon@arm.com, kernel-hardening@lists.openwall.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

Currently we define THREAD_SIZE and THREAD_SIZE order separately, with
the latter dependent on particular CONFIG_ARM64_*K_PAGES definitions.
This is somewhat opaque, and will get in the way of future modifications
to THREAD_SIZE.

This patch cleans this up, defining both in terms of a common
THREAD_SHIFT, and using PAGE_SHIFT to calculate THREAD_SIZE_ORDER,
rather than using a number of definitions dependent on config symbols.
Subsequent patches will make use of this to alter the stack size used in
some configurations.

At the same time, these are moved into <asm/memory.h>, which will avoid
circular include issues in subsequent patches. To ensure that existing
code isn't adversely affected, <asm/thread_info.h> is updated to
transitively include these definitions.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/memory.h      | 8 ++++++++
 arch/arm64/include/asm/thread_info.h | 9 +--------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index 77d55dc..8ab4774 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -102,6 +102,14 @@
 #define KASAN_SHADOW_SIZE	(0)
 #endif
 
+#define THREAD_SHIFT		14
+
+#if THREAD_SHIFT >= PAGE_SHIFT
+#define THREAD_SIZE_ORDER	(THREAD_SHIFT - PAGE_SHIFT)
+#endif
+
+#define THREAD_SIZE		(UL(1) << THREAD_SHIFT)
+
 /*
  * Memory types available.
  */
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index b29ab0e..aa04b73 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -23,18 +23,11 @@
 
 #include <linux/compiler.h>
 
-#ifdef CONFIG_ARM64_4K_PAGES
-#define THREAD_SIZE_ORDER	2
-#elif defined(CONFIG_ARM64_16K_PAGES)
-#define THREAD_SIZE_ORDER	0
-#endif
-
-#define THREAD_SIZE		16384
-
 #ifndef __ASSEMBLY__
 
 struct task_struct;
 
+#include <asm/memory.h>
 #include <asm/stack_pointer.h>
 #include <asm/types.h>
 
-- 
1.9.1
