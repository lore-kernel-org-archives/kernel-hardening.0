From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 20 Jan 2018 13:06:14 -0800
Message-ID: <151648237483.34747.13227539186037154356.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151648235823.34747.15181877619346237802.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151648235823.34747.15181877619346237802.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v4.1 03/10] x86: implement array_ptr_mask()
To: tglx@linutronix.de
Cc: linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, gregkh@linuxfoundation.org, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, torvalds@linux-foundation.org, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

'array_ptr' uses a mask to sanitize user controllable pointers.  The x86
'array_ptr_mask' is an assembler optimized way to generate a 0 or ~0
mask if an array index is out-of-bounds or in-bounds.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/include/asm/barrier.h |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/x86/include/asm/barrier.h b/arch/x86/include/asm/barrier.h
index 01727dbc294a..e8fd92008eab 100644
--- a/arch/x86/include/asm/barrier.h
+++ b/arch/x86/include/asm/barrier.h
@@ -24,6 +24,30 @@
 #define wmb()	asm volatile("sfence" ::: "memory")
 #endif
 
+/**
+ * array_ptr_mask - generate a mask for array_ptr() that is ~0UL when
+ * the bounds check succeeds and 0 otherwise
+ */
+#define array_ptr_mask array_ptr_mask
+static inline unsigned long array_ptr_mask(unsigned long idx, unsigned long sz)
+{
+	unsigned long mask;
+
+	/*
+	 * mask = index - size, if that result is >= 0 then the index is
+	 * invalid and the mask is 0 else ~0
+	 */
+#ifdef CONFIG_X86_32
+	asm ("cmpl %1,%2; sbbl %0,%0;"
+#else
+	asm ("cmpq %1,%2; sbbq %0,%0;"
+#endif
+			:"=r" (mask)
+			:"r"(sz),"r" (idx)
+			:"cc");
+	return mask;
+}
+
 #ifdef CONFIG_X86_PPRO_FENCE
 #define dma_rmb()	rmb()
 #else
