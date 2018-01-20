From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 20 Jan 2018 13:06:20 -0800
Message-ID: <151648237995.34747.11429159249031494944.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151648235823.34747.15181877619346237802.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151648235823.34747.15181877619346237802.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v4.1 04/10] x86: introduce __uaccess_begin_nospec and ifence
To: tglx@linutronix.de
Cc: linux-arch@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>, Andi Kleen <ak@linux.intel.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, gregkh@linuxfoundation.org, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, torvalds@linux-foundation.org, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

For '__get_user' paths, do not allow the kernel to speculate on the
value of a user controlled pointer. In addition to the 'stac'
instruction for Supervisor Mode Access Protection, an 'ifence' causes
the 'access_ok' result to resolve in the pipeline before the cpu might
take any speculative action on the pointer value.

Since __get_user is a major kernel interface that deals with user
controlled pointers, the '__uaccess_begin_nospec' mechanism will prevent
speculative execution past an 'access_ok' permission check. While
speculative execution past 'access_ok' is not enough to lead to a kernel
memory leak, it is a necessary precondition.

To be clear, '__uaccess_begin_nospec' is addressing a class of potential
problems near '__get_user' usages.

Note, that while ifence is used to protect '__get_user', pointer masking
will be used for 'get_user' since it incorporates a bounds check near
the usage.

There are no functional changes in this patch.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Suggested-by: Andi Kleen <ak@linux.intel.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: x86@kernel.org
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/include/asm/barrier.h |    4 ++++
 arch/x86/include/asm/msr.h     |    3 +--
 arch/x86/include/asm/uaccess.h |    9 +++++++++
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/barrier.h b/arch/x86/include/asm/barrier.h
index e8fd92008eab..6c9c81e8049f 100644
--- a/arch/x86/include/asm/barrier.h
+++ b/arch/x86/include/asm/barrier.h
@@ -48,6 +48,10 @@ static inline unsigned long array_ptr_mask(unsigned long idx, unsigned long sz)
 	return mask;
 }
 
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
 
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 574dff4d2913..626caf58183a 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -124,6 +124,11 @@ extern int __get_user_bad(void);
 
 #define __uaccess_begin() stac()
 #define __uaccess_end()   clac()
+#define __uaccess_begin_nospec()	\
+({					\
+	stac();				\
+	ifence();			\
+})
 
 /*
  * This is a type: either unsigned long, if the argument fits into
@@ -487,6 +492,10 @@ struct __large_struct { unsigned long buf[100]; };
 	__uaccess_begin();						\
 	barrier();
 
+#define uaccess_try_nospec do {						\
+	current->thread.uaccess_err = 0;				\
+	__uaccess_begin_nospec();					\
+
 #define uaccess_catch(err)						\
 	__uaccess_end();						\
 	(err) |= (current->thread.uaccess_err ? -EFAULT : 0);		\
