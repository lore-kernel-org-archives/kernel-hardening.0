From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.4 176/193] x86: Introduce barrier_nospec
Date: Fri, 23 Feb 2018 19:26:49 +0100
Message-Id: <20180223170353.649405309@linuxfoundation.org>
In-Reply-To: <20180223170325.997716448@linuxfoundation.org>
References: <20180223170325.997716448@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, linux-arch@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Al Viro <viro@zeniv.linux.org.uk>, alan@linux.intel.com, David Woodhouse <dwmw@amazon.co.uk>, Jack Wang <jinpu.wang@profitbricks.com>
List-ID: <kernel-hardening.lists.openwall.com>

4.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

(cherry picked from commit b3d7ad85b80bbc404635dca80f5b129f6242bc7a)

Rename the open coded form of this instruction sequence from
rdtsc_ordered() into a generic barrier primitive, barrier_nospec().

One of the mitigations for Spectre variant1 vulnerabilities is to fence
speculative execution after successfully validating a bounds check. I.e.
force the result of a bounds check to resolve in the instruction pipeline
to ensure speculative execution honors that result before potentially
operating on out-of-bounds data.

No functional changes.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Suggested-by: Andi Kleen <ak@linux.intel.com>
Suggested-by: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arch@vger.kernel.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com
Cc: gregkh@linuxfoundation.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: alan@linux.intel.com
Link: https://lkml.kernel.org/r/151727415361.33451.9049453007262764675.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
[jwang: cherry pick to 4.4]
Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/barrier.h |    4 ++++
 arch/x86/include/asm/msr.h     |    3 +--
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/barrier.h
+++ b/arch/x86/include/asm/barrier.h
@@ -48,6 +48,10 @@ static inline unsigned long array_index_
 /* Override the default implementation from linux/nospec.h. */
 #define array_index_mask_nospec array_index_mask_nospec
 
+/* Prevent speculative execution past this barrier. */
+#define barrier_nospec() alternative_2("", "mfence", X86_FEATURE_MFENCE_RDTSC, \
+					   "lfence", X86_FEATURE_LFENCE_RDTSC)
+
 #ifdef CONFIG_X86_PPRO_FENCE
 #define dma_rmb()	rmb()
 #else
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -147,8 +147,7 @@ static __always_inline unsigned long lon
 	 * that some other imaginary CPU is updating continuously with a
 	 * time stamp.
 	 */
-	alternative_2("", "mfence", X86_FEATURE_MFENCE_RDTSC,
-			  "lfence", X86_FEATURE_LFENCE_RDTSC);
+	barrier_nospec();
 	return rdtsc();
 }
 
