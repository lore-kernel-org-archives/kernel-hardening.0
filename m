From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 13 Jan 2018 10:17:40 -0800
Message-ID: <151586745989.5820.17196364421122234994.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151586744180.5820.13215059696964205856.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151586744180.5820.13215059696964205856.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v3 3/9] arm: implement ifence_array_ptr()
To: linux-kernel@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>, linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, gregkh@linuxfoundation.org, Russell King <linux@armlinux.org.uk>, tglx@linutronix.de, torvalds@linux-foundation.org, akpm@linux-foundation.org, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

From: Mark Rutland <mark.rutland@arm.com>

This patch implements ifence_array_ptr() for arm, using an
LDR+MOVCS+CSDB sequence to inhibit speculative use of the returned
value.

Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/arm/include/asm/barrier.h |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm/include/asm/barrier.h b/arch/arm/include/asm/barrier.h
index 40f5c410fd8c..919235ed6e68 100644
--- a/arch/arm/include/asm/barrier.h
+++ b/arch/arm/include/asm/barrier.h
@@ -59,6 +59,30 @@ extern void arm_heavy_mb(void);
 #define dma_wmb()	barrier()
 #endif
 
+#define ifence_array_ptr(arr, idx, sz)					\
+({									\
+	typeof(&(arr)[0]) __nap_arr = (arr);				\
+	typeof(idx) __nap_idx = (idx);					\
+	typeof(sz) __nap_sz = (sz);					\
+									\
+	unsigned long __nap_ptr = (unsigned long)__nap_arr +		\
+				  sizeof(__nap_arr[0]) * idx;		\
+									\
+	asm volatile(							\
+	"	cmp	%[i], %[s]\n"					\
+	"	bcs	1f\n"						\
+	"	ldr	%[p], %[pp]\n"					\
+	"1:	movcs	%[p], #0\n"					\
+	"	.inst	0xe320f018 @ CSDB\n"				\
+	: [p] "=&r" (__nap_ptr)						\
+	: [pp] "m" (__nap_ptr),						\
+	  [i] "r" ((unsigned long)__nap_idx),				\
+	  [s] "r" ((unsigned long)__nap_sz)				\
+	: "cc");							\
+									\
+	(typeof(&(__nap_arr)[0]))__nap_ptr;				\
+})
+
 #define __smp_mb()	dmb(ish)
 #define __smp_rmb()	__smp_mb()
 #define __smp_wmb()	dmb(ishst)
