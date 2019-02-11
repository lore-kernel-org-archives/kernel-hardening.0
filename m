From: Igor Stoppa <igor.stoppa@gmail.com>
Subject: [RFC PATCH v4 02/12] __wr_after_init: x86_64: memset_user()
Date: Tue, 12 Feb 2019 01:27:39 +0200
Message-Id: <afc5b052d43606a3d53e674fb2e36abbf984c516.1549927666.git.igor.stoppa@huawei.com>
In-Reply-To: <cover.1549927666.git.igor.stoppa@huawei.com>
References: <cover.1549927666.git.igor.stoppa@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: Igor Stoppa <igor.stoppa@huawei.com>, Andy Lutomirski <luto@amacapital.net>, Nadav Amit <nadav.amit@gmail.com>, Matthew Wilcox <willy@infradead.org>, Peter Zijlstra <peterz@infradead.org>, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@linux.intel.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Thiago Jung Bauermann <bauerman@linux.ibm.com>, Ahmed Soliman <ahmedsoliman@mena.vt.edu>, linux-integrity@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

x86_64 specific version of memset() for user space, memset_user()

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
 arch/x86/include/asm/uaccess_64.h |  6 ++++
 arch/x86/lib/usercopy_64.c        | 51 +++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+)

diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index a9d637bc301d..f194bfce4866 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -213,4 +213,10 @@ copy_user_handle_tail(char *to, char *from, unsigned len);
 unsigned long
 mcsafe_handle_tail(char *to, char *from, unsigned len);
 
+unsigned long __must_check
+memset_user(void __user *mem, int c, unsigned long len);
+
+unsigned long __must_check
+__memset_user(void __user *mem, int c, unsigned long len);
+
 #endif /* _ASM_X86_UACCESS_64_H */
diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index ee42bb0cbeb3..e61963585354 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -9,6 +9,57 @@
 #include <linux/uaccess.h>
 #include <linux/highmem.h>
 
+/*
+ * Memset Userspace
+ */
+
+unsigned long __memset_user(void __user *addr, int c, unsigned long size)
+{
+	long __d0;
+	unsigned long  pattern = 0x0101010101010101UL * (0xFFUL & c);
+
+	might_fault();
+	/* no memory constraint: gcc doesn't know about this memory */
+	stac();
+	asm volatile(
+		"	movq %[pattern], %%rdx\n"
+		"	testq  %[size8],%[size8]\n"
+		"	jz     4f\n"
+		"0:	mov %%rdx,(%[dst])\n"
+		"	addq   $8,%[dst]\n"
+		"	decl %%ecx ; jnz   0b\n"
+		"4:	movq  %[size1],%%rcx\n"
+		"	testl %%ecx,%%ecx\n"
+		"	jz     2f\n"
+		"1:	movb   %%dl,(%[dst])\n"
+		"	incq   %[dst]\n"
+		"	decl %%ecx ; jnz  1b\n"
+		"2:\n"
+		".section .fixup,\"ax\"\n"
+		"3:	lea 0(%[size1],%[size8],8),%[size8]\n"
+		"	jmp 2b\n"
+		".previous\n"
+		_ASM_EXTABLE_UA(0b, 3b)
+		_ASM_EXTABLE_UA(1b, 2b)
+		: [size8] "=&c"(size), [dst] "=&D" (__d0)
+		: [size1] "r" (size & 7), "[size8]" (size / 8),
+		  "[dst]" (addr), [pattern] "r" (pattern)
+		: "rdx");
+
+	clac();
+	return size;
+}
+EXPORT_SYMBOL(__memset_user);
+
+unsigned long memset_user(void __user *to, int c, unsigned long n)
+{
+	if (access_ok(to, n))
+		return __memset_user(to, c, n);
+	return n;
+}
+EXPORT_SYMBOL(memset_user);
+
+
 /*
  * Zero Userspace
  */
-- 
2.19.1
