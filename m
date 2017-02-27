From: Kees Cook <keescook@chromium.org>
Date: Mon, 27 Feb 2017 12:43:02 -0800
Message-Id: <1488228186-110679-5-git-send-email-keescook@chromium.org>
In-Reply-To: <1488228186-110679-1-git-send-email-keescook@chromium.org>
References: <1488228186-110679-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [RFC][PATCH 4/8] x86: Implement __arch_rare_write_map/unmap()
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>, Hoeun Ryu <hoeun.ryu@gmail.com>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Based on PaX's x86 pax_{open,close}_kernel() implementation, this
allows HAVE_ARCH_RARE_WRITE to work on x86.

There is missing work to sort out some header file issues where preempt.h
is missing, though it can't be included in pg_table.h unconditionally...
some other solution will be needed, perhaps an entirely separate header
file for rare_write()-related defines...

This patch is also missing paravirt support.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/Kconfig               |  1 +
 arch/x86/include/asm/pgtable.h | 31 +++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e487493bbd47..6d4d6f73d4b8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -102,6 +102,7 @@ config X86
 	select HAVE_ARCH_KMEMCHECK
 	select HAVE_ARCH_MMAP_RND_BITS		if MMU
 	select HAVE_ARCH_MMAP_RND_COMPAT_BITS	if MMU && COMPAT
+	select HAVE_ARCH_RARE_WRITE
 	select HAVE_ARCH_SECCOMP_FILTER
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 437feb436efa..86e78e97738f 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -90,6 +90,37 @@ extern struct mm_struct *pgd_page_get_mm(struct page *page);
 
 #endif	/* CONFIG_PARAVIRT */
 
+/* TODO: Bad hack to deal with preempt macros being missing sometimes. */
+#ifndef preempt_disable
+#include <linux/preempt.h>
+#endif
+
+static inline unsigned long __arch_rare_write_map(void)
+{
+	unsigned long cr0;
+
+	preempt_disable();
+	barrier();
+	cr0 = read_cr0() ^ X86_CR0_WP;
+	BUG_ON(cr0 & X86_CR0_WP);
+	write_cr0(cr0);
+	barrier();
+	return cr0 ^ X86_CR0_WP;
+}
+
+static inline unsigned long __arch_rare_write_unmap(void)
+{
+	unsigned long cr0;
+
+	barrier();
+	cr0 = read_cr0() ^ X86_CR0_WP;
+	BUG_ON(!(cr0 & X86_CR0_WP));
+	write_cr0(cr0);
+	barrier();
+	preempt_enable_no_resched();
+	return cr0 ^ X86_CR0_WP;
+}
+
 /*
  * The following only work if pte_present() is true.
  * Undefined behaviour if not..
-- 
2.7.4
