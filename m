From: Jack Wang <jinpu.wang@profitbricks.com>
Subject: [stable 4.4 13/29] x86: Introduce barrier_nospec
Date: Fri, 23 Feb 2018 11:42:02 +0100
Message-Id: <1519382538-15143-14-git-send-email-jinpu.wangl@profitbricks.com>
In-Reply-To: <1519382538-15143-1-git-send-email-jinpu.wangl@profitbricks.com>
References: <1519382538-15143-1-git-send-email-jinpu.wangl@profitbricks.com>
To: gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, linux-arch@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Al Viro <viro@zeniv.linux.org.uk>, alan@linux.intel.com, David Woodhouse <dwmw@amazon.co.uk>, Jack Wang <jinpu.wang@profitbricks.com>
List-ID: <kernel-hardening.lists.openwall.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[jwang: cherry pick to 4.4]
Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
---
 arch/x86/include/asm/barrier.h | 4 ++++
 arch/x86/include/asm/msr.h     | 3 +--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/barrier.h b/arch/x86/include/asm/barrier.h
index b5028e3..814ef83 100644
--- a/arch/x86/include/asm/barrier.h
+++ b/arch/x86/include/asm/barrier.h
@@ -48,6 +48,10 @@ static inline unsigned long array_index_mask_nospec(unsigned long index,
 /* Override the default implementation from linux/nospec.h. */
 #define array_index_mask_nospec array_index_mask_nospec
 
+/* Prevent speculative execution past this barrier. */
+#define barrier_nospec() alternative_2("", "mfence", X86_FEATURE_MFENCE_RDTSC, \
+					   "lfence", X86_FEATURE_LFENCE_RDTSC)
+
 #ifdef CONFIG_X86_PPRO_FENCE
 #define dma_rmb()	rmb()
 #else
diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 77d8b28..5a10ac8 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -147,8 +147,7 @@ static __always_inline unsigned long long rdtsc_ordered(void)
 	 * that some other imaginary CPU is updating continuously with a
 	 * time stamp.
 	 */
-	alternative_2("", "mfence", X86_FEATURE_MFENCE_RDTSC,
-			  "lfence", X86_FEATURE_LFENCE_RDTSC);
+	barrier_nospec();
 	return rdtsc();
 }
 
-- 
2.7.4
