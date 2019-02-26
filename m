From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 2/3] x86/asm: Avoid taking an exception before cr4 restore
Date: Tue, 26 Feb 2019 15:36:46 -0800
Message-Id: <20190226233647.28547-3-keescook@chromium.org>
In-Reply-To: <20190226233647.28547-1-keescook@chromium.org>
References: <20190226233647.28547-1-keescook@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Sean Christopherson <sean.j.christopherson@intel.com>, Dominik Brodowski <linux@dominikbrodowski.net>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Instead of taking a full WARN() exception before restoring a potentially
missed CR4 bit, this retains the missing bit for later reporting. This
matches the logic done for the CR0 pinning.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/include/asm/special_insns.h | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
index 8416d6b31084..6f649eaecc73 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -97,6 +97,8 @@ extern volatile unsigned long cr4_pin;
 
 static inline void native_write_cr4(unsigned long val)
 {
+	unsigned long warn = 0;
+
 again:
 	val |= cr4_pin;
 	asm volatile("mov %0,%%cr4": : "r" (val), "m" (__force_order));
@@ -105,10 +107,12 @@ static inline void native_write_cr4(unsigned long val)
 	 * notice the lack of pinned bits in "val" and start the function
 	 * from the beginning to gain the cr4_pin bits for sure.
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
