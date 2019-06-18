From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v3 3/3] x86/asm: Pin sensitive CR0 bits
Date: Mon, 17 Jun 2019 21:55:03 -0700
Message-Id: <20190618045503.39105-4-keescook@chromium.org>
In-Reply-To: <20190618045503.39105-1-keescook@chromium.org>
References: <20190618045503.39105-1-keescook@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kees Cook <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org, Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

With sensitive CR4 bits pinned now, it's possible that the WP bit for
CR0 might become a target as well. Following the same reasoning for
the CR4 pinning, this pins CR0's WP bit (but this can be done with a
static value).

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/include/asm/special_insns.h | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
index c8c8143ab27b..b2e84d113f2a 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -31,7 +31,20 @@ static inline unsigned long native_read_cr0(void)
 
 static inline void native_write_cr0(unsigned long val)
 {
-	asm volatile("mov %0,%%cr0": : "r" (val), "m" (__force_order));
+	unsigned long bits_missing = 0;
+
+set_register:
+	asm volatile("mov %0,%%cr0": "+r" (val), "+m" (__force_order));
+
+	if (static_branch_likely(&cr_pinning)) {
+		if (unlikely((val & X86_CR0_WP) != X86_CR0_WP)) {
+			bits_missing = X86_CR0_WP;
+			val |= bits_missing;
+			goto set_register;
+		}
+		/* Warn after we've set the missing bits. */
+		WARN_ONCE(bits_missing, "CR0 WP bit went missing!?\n");
+	}
 }
 
 static inline unsigned long native_read_cr2(void)
-- 
2.17.1
