From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 2/3] x86/asm: Avoid taking an exception before cr4 restore
Date: Wed, 27 Feb 2019 12:01:31 -0800
Message-Id: <20190227200132.24707-3-keescook@chromium.org>
In-Reply-To: <20190227200132.24707-1-keescook@chromium.org>
References: <20190227200132.24707-1-keescook@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Solar Designer <solar@openwall.com>, Greg KH <gregkh@linuxfoundation.org>, Jann Horn <jannh@google.com>, Sean Christopherson <sean.j.christopherson@intel.com>, Dominik Brodowski <linux@dominikbrodowski.net>, linux-kernel@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Instead of taking a full WARN() exception before restoring a potentially
missed CR4 bit, this retains the missing bit for later reporting. This
matches the logic done for the CR0 pinning. Additionally updates the
comments to note the required use of "volatile".

Suggested-by: Solar Designer <solar@openwall.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/include/asm/special_insns.h | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
index 1f01dc3f6c64..6020cb1de66e 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -97,18 +97,24 @@ extern volatile unsigned long cr4_pin;
 
 static inline void native_write_cr4(unsigned long val)
 {
+	unsigned long warn = 0;
+
 again:
 	val |= cr4_pin;
 	asm volatile("mov %0,%%cr4": : "r" (val), "m" (__force_order));
 	/*
 	 * If the MOV above was used directly as a ROP gadget we can
 	 * notice the lack of pinned bits in "val" and start the function
-	 * from the beginning to gain the cr4_pin bits for sure.
+	 * from the beginning to gain the cr4_pin bits for sure. Note
+	 * that "val" must be volatile to keep the compiler from
+	 * optimizing away this check.
 	 */
-	if (WARN_ONCE((val & cr4_pin) != cr4_pin,
-		      "Attempt to unpin cr4 bits: %lx, cr4 bypass attack?!",
-		      ~val & cr4_pin))
+	if ((val & cr4_pin) != cr4_pin) {
+		warn = ~val & cr4_pin;
 		goto again;
+	}
+	WARN_ONCE(warn, "Attempt to unpin cr4 bits: %lx; bypass attack?!\n",
+		  warn);
 }
 
 #ifdef CONFIG_X86_64
-- 
2.17.1
