Subject: [PATCH v6 05/13] x86: introduce __uaccess_begin_nospec
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 29 Jan 2018 17:02:39 -0800
Message-ID: <151727415922.33451.5796614273104346583.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151727412964.33451.17213780323040673404.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151727412964.33451.17213780323040673404.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-arch@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>, Andi Kleen <ak@linux.intel.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, gregkh@linuxfoundation.org, x86@kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, torvalds@linux-foundation.org, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

For __get_user() paths, do not allow the kernel to speculate on the
value of a user controlled pointer. In addition to the 'stac'
instruction for Supervisor Mode Access Protection (SMAP), a
barrier_nospec() causes the access_ok() result to resolve in the
pipeline before the CPU might take any speculative action on the pointer
value. Given the cost of 'stac' the speculation barrier is placed after
'stac' to hopefully overlap the cost of disabling SMAP with the cost of
flushing the instruction pipeline.

Since __get_user is a major kernel interface that deals with user
controlled pointers, the __uaccess_begin_nospec() mechanism will prevent
speculative execution past an access_ok() permission check. While
speculative execution past access_ok() is not enough to lead to a kernel
memory leak, it is a necessary precondition.

To be clear, __uaccess_begin_nospec() is addressing a class of potential
problems near __get_user() usages.

Note, that while the barrier_nospec() in __uaccess_begin_nospec() is
used to protect __get_user(), pointer masking similar to
array_index_nospec() will be used for get_user() since it incorporates a
bounds check near the usage.

There are no functional changes in this patch.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Suggested-by: Andi Kleen <ak@linux.intel.com>
Suggested-by: Ingo Molnar <mingo@redhat.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/include/asm/uaccess.h |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 574dff4d2913..663e9bde9fc9 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -124,6 +124,11 @@ extern int __get_user_bad(void);
 
 #define __uaccess_begin() stac()
 #define __uaccess_end()   clac()
+#define __uaccess_begin_nospec()	\
+({					\
+	stac();				\
+	barrier_nospec();		\
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
