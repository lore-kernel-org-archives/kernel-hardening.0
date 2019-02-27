From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 1/3] x86/asm: Pin sensitive CR0 bits
Date: Wed, 27 Feb 2019 12:01:30 -0800
Message-Id: <20190227200132.24707-2-keescook@chromium.org>
In-Reply-To: <20190227200132.24707-1-keescook@chromium.org>
References: <20190227200132.24707-1-keescook@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Solar Designer <solar@openwall.com>, Greg KH <gregkh@linuxfoundation.org>, Jann Horn <jannh@google.com>, Sean Christopherson <sean.j.christopherson@intel.com>, Dominik Brodowski <linux@dominikbrodowski.net>, linux-kernel@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

With sensitive CR4 bits pinned now, it's possible that the WP bit for CR0
might become a target as well. Following the same reasoning for the CR4
pinning, this pins CR0's WP bit (but this can be done with a static value).

As before, to convince the compiler to not optimize away the check for the
WP bit after the set, this marks "val" as an output from the asm() block.
This protects against just jumping into the function past where the masking
happens; we must check that the mask was applied after we do the set). Due
to how this function can be built by the compiler (especially due to the
removal of frame pointers), jumping into the middle of the function
frequently doesn't require stack manipulation to construct a stack frame
(there may only a retq without pops, which is sufficient for use with
exploits like timer overwrites).

Additionally, this avoids WARN()ing before resetting the bit, just to
minimize any race conditions with leaving the bit unset.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/include/asm/special_insns.h | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
index fabda1400137..1f01dc3f6c64 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -25,7 +25,28 @@ static inline unsigned long native_read_cr0(void)
 
 static inline void native_write_cr0(unsigned long val)
 {
-	asm volatile("mov %0,%%cr0": : "r" (val), "m" (__force_order));
+	bool warn = false;
+
+again:
+	val |= X86_CR0_WP;
+	/*
+	 * In order to have the compiler not optimize away the check
+	 * after the cr4 write, mark "val" as being also an output ("+r")
+	 * by this asm() block so it will perform an explicit check, as
+	 * if it were "volatile".
+	 */
+	asm volatile("mov %0,%%cr0" : "+r" (val) : "m" (__force_order) : );
+	/*
+	 * If the MOV above was used directly as a ROP gadget we can
+	 * notice the lack of pinned bits in "val" and start the function
+	 * from the beginning to gain the WP bit for sure. And do it
+	 * without first taking the exception for a WARN().
+	 */
+	if ((val & X86_CR0_WP) != X86_CR0_WP) {
+		warn = true;
+		goto again;
+	}
+	WARN_ONCE(warn, "Attempt to unpin X86_CR0_WP, cr0 bypass attack?!\n");
 }
 
 static inline unsigned long native_read_cr2(void)
-- 
2.17.1
