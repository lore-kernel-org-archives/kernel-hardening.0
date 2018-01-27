From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 26 Jan 2018 23:55:29 -0800
Message-ID: <151703972912.26578.6792656143278523491.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151703971300.26578.1185595719337719486.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151703971300.26578.1185595719337719486.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v5 03/12] x86: implement array_idx_mask
To: tglx@linutronix.de
Cc: linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, gregkh@linuxfoundation.org, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, torvalds@linux-foundation.org, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

'array_idx' uses a mask to sanitize user controllable array indexes,
i.e. generate a 0 mask if idx >= sz, and a ~0 mask otherwise. While the
default array_idx_mask handles the carry-bit from the (index - size)
result in software. The x86 'array_idx_mask' does the same, but the
carry-bit is handled in the processor CF flag without conditional
instructions in the control flow.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/include/asm/barrier.h |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/x86/include/asm/barrier.h b/arch/x86/include/asm/barrier.h
index 01727dbc294a..30419b674ebd 100644
--- a/arch/x86/include/asm/barrier.h
+++ b/arch/x86/include/asm/barrier.h
@@ -24,6 +24,28 @@
 #define wmb()	asm volatile("sfence" ::: "memory")
 #endif
 
+/**
+ * array_idx_mask - generate a mask for array_idx() that is ~0UL when
+ * the bounds check succeeds and 0 otherwise
+ *
+ *     mask = 0 - (idx < sz);
+ */
+#define array_idx_mask array_idx_mask
+static inline unsigned long array_idx_mask(unsigned long idx, unsigned long sz)
+{
+	unsigned long mask;
+
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
