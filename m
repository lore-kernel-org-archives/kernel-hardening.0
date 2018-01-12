From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 11 Jan 2018 16:46:45 -0800
Message-ID: <151571800589.27429.13615996439124092232.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v2 04/19] x86: implement ifence()
To: linux-kernel@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>, Tom Lendacky <thomas.lendacky@amd.com>, linux-arch@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Alan Cox <alan.cox@intel.com>, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, kernel-hardening@lists.openwall.com, tglx@linutronix.de, torvalds@linux-foundation.org, akpm@linux-foundation.org, Elena Reshetova <elena.reshetova@intel.com>, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

The new barrier, 'ifence', ensures that no instructions past the
boundary are speculatively executed.

Previously the kernel only needed this fence in 'rdtsc_ordered', but it
can also be used as a mitigation against Spectre variant1 attacks that
speculative access memory past an array bounds check.

'ifence', via 'ifence_array_ptr', is an opt-in fallback to the default
mitigation provided by '__array_ptr'. It is also proposed for blocking
speculation in the 'get_user' path to bypass 'access_ok' checks. For
now, just provide the common definition for later patches to build upon.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Suggested-by: Alan Cox <alan.cox@intel.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/include/asm/barrier.h |    4 ++++
 arch/x86/include/asm/msr.h     |    3 +--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/barrier.h b/arch/x86/include/asm/barrier.h
index 7fb336210e1b..b04f572d6d97 100644
--- a/arch/x86/include/asm/barrier.h
+++ b/arch/x86/include/asm/barrier.h
@@ -24,6 +24,10 @@
 #define wmb()	asm volatile("sfence" ::: "memory")
 #endif
 
+/* prevent speculative execution past this barrier */
+#define ifence() alternative_2("", "mfence", X86_FEATURE_MFENCE_RDTSC, \
+				   "lfence", X86_FEATURE_LFENCE_RDTSC)
+
 #ifdef CONFIG_X86_PPRO_FENCE
 #define dma_rmb()	rmb()
 #else
diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 07962f5f6fba..e426d2a33ff3 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -214,8 +214,7 @@ static __always_inline unsigned long long rdtsc_ordered(void)
 	 * that some other imaginary CPU is updating continuously with a
 	 * time stamp.
 	 */
-	alternative_2("", "mfence", X86_FEATURE_MFENCE_RDTSC,
-			  "lfence", X86_FEATURE_LFENCE_RDTSC);
+	ifence();
 	return rdtsc();
 }
 
