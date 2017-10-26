From: Mark Rutland <mark.rutland@arm.com>
Date: Thu, 26 Oct 2017 10:09:41 +0100
Message-Id: <20171026090942.7041-2-mark.rutland@arm.com>
In-Reply-To: <20171026090942.7041-1-mark.rutland@arm.com>
References: <20171026090942.7041-1-mark.rutland@arm.com>
Subject: [kernel-hardening] [RFC PATCH 1/2] arm64: write __range_ok() in C
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, Will Deacon <will.deacon@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

Currently arm64's __range_ok() is written in assembly for efficiency.

This hides the logic from the compiler, preventing the compiler from
making some optimizations, such as re-ordering instructions or folding
multiple calls to __range_ok().

This patch uses GCC's __builtin_uaddl_overflow() to provide an
equivalent, efficient check, while giving the compiler the visibility it
needs to optimize the check. In testing with v4.14-rc5 using the Linaro
17.05 GCC 6.3.1 toolchain, this has no impact on the kernel Image size,
(but results in a smaller vmlinux).

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/uaccess.h | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
index fc0f9eb66039..36f84ec92b9d 100644
--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -70,17 +70,20 @@ static inline void set_fs(mm_segment_t fs)
  *
  * This needs 65-bit arithmetic.
  */
+static bool __range_ok_c(unsigned long addr, unsigned long size)
+{
+	unsigned long result;
+
+	if (__builtin_uaddl_overflow(addr, size, &result))
+		return false;
+
+	return result < current_thread_info()->addr_limit;
+}
+
 #define __range_ok(addr, size)						\
 ({									\
-	unsigned long __addr = (unsigned long)(addr);			\
-	unsigned long flag, roksum;					\
 	__chk_user_ptr(addr);						\
-	asm("adds %1, %1, %3; ccmp %1, %4, #2, cc; cset %0, ls"		\
-		: "=&r" (flag), "=&r" (roksum)				\
-		: "1" (__addr), "Ir" (size),				\
-		  "r" (current_thread_info()->addr_limit)		\
-		: "cc");						\
-	flag;								\
+	__range_ok_c((unsigned long)(addr), (unsigned long)(size));	\
 })
 
 /*
-- 
2.11.0
