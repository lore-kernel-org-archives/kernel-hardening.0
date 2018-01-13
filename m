From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 13 Jan 2018 10:17:52 -0800
Message-ID: <151586747212.5820.3578033403380651896.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151586744180.5820.13215059696964205856.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151586744180.5820.13215059696964205856.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v3 5/9] x86: implement ifence_array_ptr() and
 array_ptr_mask()
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, gregkh@linuxfoundation.org, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de, torvalds@linux-foundation.org, akpm@linux-foundation.org, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

'ifence_array_ptr' is provided as an alternative to the default
'__array_ptr' implementation that uses a mask to sanitize user
controllable pointers. Later patches will allow it to be selected via
the kernel command line. The '__array_ptr' implementation otherwise
appears safe for current generation cpus across multiple architectures.

'array_ptr_mask' is used by the default 'array_ptr' implementation to
cheaply calculate an array bounds mask.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/include/asm/barrier.h |   46 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/arch/x86/include/asm/barrier.h b/arch/x86/include/asm/barrier.h
index b04f572d6d97..1b507f9e2cc7 100644
--- a/arch/x86/include/asm/barrier.h
+++ b/arch/x86/include/asm/barrier.h
@@ -28,6 +28,52 @@
 #define ifence() alternative_2("", "mfence", X86_FEATURE_MFENCE_RDTSC, \
 				   "lfence", X86_FEATURE_LFENCE_RDTSC)
 
+/**
+ * ifence_array_ptr - Generate a pointer to an array element,
+ * ensuring the pointer is bounded under speculation.
+ *
+ * @arr: the base of the array
+ * @idx: the index of the element
+ * @sz: the number of elements in the array
+ *
+ * If @idx falls in the interval [0, @sz), returns the pointer to
+ * @arr[@idx], otherwise returns NULL.
+ */
+#define ifence_array_ptr(arr, idx, sz)					\
+({									\
+	typeof(*(arr)) *__arr = (arr), *__ret;				\
+	typeof(idx) __idx = (idx);					\
+	typeof(sz) __sz = (sz);						\
+									\
+	__ret = __idx < __sz ? __arr + __idx : NULL;			\
+	ifence();							\
+	__ret;								\
+})
+
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
