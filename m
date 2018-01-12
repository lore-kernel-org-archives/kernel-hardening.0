From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 11 Jan 2018 16:47:02 -0800
Message-ID: <151571802258.27429.932636277047687877.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v2 07/19] x86: introduce __uaccess_begin_nospec and
 ASM_IFENCE
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de, torvalds@linux-foundation.org, akpm@linux-foundation.org, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

For 'get_user' paths, do not allow the kernel to speculate on the value
of a user controlled pointer. In addition to the 'stac' instruction for
Supervisor Mode Access Protection, an 'ifence' causes the 'access_ok'
result to resolve in the pipeline before the cpu might take any
speculative action on the pointer value.

Since this is a major kernel interface that deals with user controlled
data, the '__uaccess_begin_nospec' mechanism will prevent speculative
execution past an 'access_ok' permission check. While speculative
execution past 'access_ok' is not enough to lead to a kernel memory
leak, it is a necessary precondition.

To be clear, '__uaccess_begin_nospec' and ASM_IFENCE are not addressing
any known issues with 'get_user' they are addressing a class of
potential problems that could be near 'get_user' usages. In other words,
these helpers are for hygiene not clinical fixes.

There are no functional changes in this patch.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Suggested-by: Andi Kleen <ak@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: x86@kernel.org
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/include/asm/smap.h    |    4 ++++
 arch/x86/include/asm/uaccess.h |   10 ++++++++++
 2 files changed, 14 insertions(+)

diff --git a/arch/x86/include/asm/smap.h b/arch/x86/include/asm/smap.h
index db333300bd4b..0b59707e0b46 100644
--- a/arch/x86/include/asm/smap.h
+++ b/arch/x86/include/asm/smap.h
@@ -40,6 +40,10 @@
 
 #endif /* CONFIG_X86_SMAP */
 
+#define ASM_IFENCE \
+	ALTERNATIVE_2 "", "mfence", X86_FEATURE_MFENCE_RDTSC, \
+			  "lfence", X86_FEATURE_LFENCE_RDTSC
+
 #else /* __ASSEMBLY__ */
 
 #include <asm/alternative.h>
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 574dff4d2913..a31fd4fc6483 100644
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
@@ -487,6 +492,11 @@ struct __large_struct { unsigned long buf[100]; };
 	__uaccess_begin();						\
 	barrier();
 
+#define uaccess_try_nospec do {						\
+	current->thread.uaccess_err = 0;				\
+	__uaccess_begin_nospec();					\
+	barrier();
+
 #define uaccess_catch(err)						\
 	__uaccess_end();						\
 	(err) |= (current->thread.uaccess_err ? -EFAULT : 0);		\
