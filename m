From: Igor Stoppa <igor.stoppa@gmail.com>
Subject: [RFC PATCH v4 05/12] __wr_after_init: arm64: memset_user()
Date: Tue, 12 Feb 2019 01:27:42 +0200
Message-Id: <165661e29f9a2a6aa36e51ae79a06f03b7c8718e.1549927666.git.igor.stoppa@huawei.com>
In-Reply-To: <cover.1549927666.git.igor.stoppa@huawei.com>
References: <cover.1549927666.git.igor.stoppa@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: Igor Stoppa <igor.stoppa@huawei.com>, Andy Lutomirski <luto@amacapital.net>, Nadav Amit <nadav.amit@gmail.com>, Matthew Wilcox <willy@infradead.org>, Peter Zijlstra <peterz@infradead.org>, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@linux.intel.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Thiago Jung Bauermann <bauerman@linux.ibm.com>, Ahmed Soliman <ahmedsoliman@mena.vt.edu>, linux-integrity@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

arm64 specific version of memset() for user space, memset_user()

In the __wr_after_init scenario, write-rare variables have:
- a primary read-only mapping in kernel memory space
- an alternate, writable mapping, implemented as user-space mapping

The write rare implementation expects the arch code to privide a
memset_user() function, which is currently missing.

clear_user() is the base for memset_user()

Signed-off-by: Igor Stoppa <igor.stoppa@huawei.com>

CC: Andy Lutomirski <luto@amacapital.net>
CC: Nadav Amit <nadav.amit@gmail.com>
CC: Matthew Wilcox <willy@infradead.org>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Kees Cook <keescook@chromium.org>
CC: Dave Hansen <dave.hansen@linux.intel.com>
CC: Mimi Zohar <zohar@linux.vnet.ibm.com>
CC: Thiago Jung Bauermann <bauerman@linux.ibm.com>
CC: Ahmed Soliman <ahmedsoliman@mena.vt.edu>
CC: linux-integrity@vger.kernel.org
CC: kernel-hardening@lists.openwall.com
CC: linux-mm@kvack.org
CC: linux-kernel@vger.kernel.org
---
 arch/arm64/include/asm/uaccess.h   |  9 +++++
 arch/arm64/lib/Makefile            |  2 +-
 arch/arm64/lib/memset_user.S (new) | 63 ++++++++++++++++++++++++++++++++
 3 files changed, 73 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
index 547d7a0c9d05..0094f92a8f1b 100644
--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -415,6 +415,15 @@ extern unsigned long __must_check __arch_copy_in_user(void __user *to, const voi
 #define INLINE_COPY_TO_USER
 #define INLINE_COPY_FROM_USER
 
+extern unsigned long __must_check __arch_memset_user(void __user *to, int c, unsigned long n);
+static inline unsigned long __must_check __memset_user(void __user *to, int c, unsigned long n)
+{
+	if (access_ok(to, n))
+		n = __arch_memset_user(__uaccess_mask_ptr(to), c, n);
+	return n;
+}
+#define memset_user	__memset_user
+
 extern unsigned long __must_check __arch_clear_user(void __user *to, unsigned long n);
 static inline unsigned long __must_check __clear_user(void __user *to, unsigned long n)
 {
diff --git a/arch/arm64/lib/Makefile b/arch/arm64/lib/Makefile
index 5540a1638baf..614b090888de 100644
--- a/arch/arm64/lib/Makefile
+++ b/arch/arm64/lib/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-lib-y		:= clear_user.o delay.o copy_from_user.o		\
+lib-y		:= clear_user.o memset_user.o delay.o copy_from_user.o	\
 		   copy_to_user.o copy_in_user.o copy_page.o		\
 		   clear_page.o memchr.o memcpy.o memmove.o memset.o	\
 		   memcmp.o strcmp.o strncmp.o strlen.o strnlen.o	\
diff --git a/arch/arm64/lib/memset_user.S b/arch/arm64/lib/memset_user.S
new file mode 100644
index 000000000000..1bfbda3d112b
--- /dev/null
+++ b/arch/arm64/lib/memset_user.S
@@ -0,0 +1,63 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * memset_user.S - memset for userspace on arm64
+ *
+ * (C) Copyright 2018 Huawey Technologies Co. Ltd.
+ * Author: Igor Stoppa <igor.stoppa@huawei.com>
+ *
+ * Based on arch/arm64/lib/clear_user.S
+ */
+
+#include <linux/linkage.h>
+
+#include <asm/asm-uaccess.h>
+
+	.text
+
+/* Prototype: int __arch_memset_user(void *addr, int c, size_t n)
+ * Purpose  : set n bytes of user memory at "addr" to the value "c"
+ * Params   : x0 - addr, user memory address to set
+ *          : x1 - c, byte value
+ *          : x2 - n, number of bytes to set
+ * Returns  : number of bytes NOT set
+ *
+ * Alignment fixed up by hardware.
+ */
+ENTRY(__arch_memset_user)
+	uaccess_enable_not_uao x3, x4, x5
+	// replicate the byte to the whole register
+	and	x1, x1, 0xff
+	lsl	x3, x1, 8
+	orr	x1, x3, x1
+	lsl	x3, x1, 16
+	orr 	x1, x3, x1
+	lsl	x3, x1, 32
+	orr	x1, x3, x1
+	mov	x3, x2			// save the size for fixup return
+	subs	x2, x2, #8
+	b.mi	2f
+1:
+uao_user_alternative 9f, str, sttr, x1, x0, 8
+	subs	x2, x2, #8
+	b.pl	1b
+2:	adds	x2, x2, #4
+	b.mi	3f
+uao_user_alternative 9f, str, sttr, x1, x0, 4
+	sub	x2, x2, #4
+3:	adds	x2, x2, #2
+	b.mi	4f
+uao_user_alternative 9f, strh, sttrh, w1, x0, 2
+	sub	x2, x2, #2
+4:	adds	x2, x2, #1
+	b.mi	5f
+uao_user_alternative 9f, strb, sttrb, w1, x0, 0
+5:	mov	x0, #0
+	uaccess_disable_not_uao x3, x4
+	ret
+ENDPROC(__arch_memset_user)
+
+	.section .fixup,"ax"
+	.align	2
+9:	mov	x0, x3			// return the original size
+	ret
+	.previous
-- 
2.19.1
