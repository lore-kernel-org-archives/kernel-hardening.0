From: Kees Cook <keescook@chromium.org>
Date: Mon, 27 Feb 2017 12:43:03 -0800
Message-Id: <1488228186-110679-6-git-send-email-keescook@chromium.org>
In-Reply-To: <1488228186-110679-1-git-send-email-keescook@chromium.org>
References: <1488228186-110679-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [RFC][PATCH 5/8] ARM: Implement __arch_rare_write_map/unmap()
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>, Hoeun Ryu <hoeun.ryu@gmail.com>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Based on grsecurity's ARM pax_{open,close}_kernel() implementation, this
allows HAVE_ARCH_RARE_WRITE to work on ARM.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm/Kconfig               |  1 +
 arch/arm/include/asm/domain.h  |  3 ++-
 arch/arm/include/asm/pgtable.h | 27 +++++++++++++++++++++++++++
 3 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 186c4c214e0a..c3e1369e7429 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -39,6 +39,7 @@ config ARM
 	select HAVE_ARCH_JUMP_LABEL if !XIP_KERNEL && !CPU_ENDIAN_BE32 && MMU
 	select HAVE_ARCH_KGDB if !CPU_ENDIAN_BE32 && MMU
 	select HAVE_ARCH_MMAP_RND_BITS if MMU
+	select HAVE_ARCH_RARE_WRITE if MMU && !ARM_LPAE && !CPU_USE_DOMAINS
 	select HAVE_ARCH_SECCOMP_FILTER if (AEABI && !OABI_COMPAT)
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARM_SMCCC if CPU_V7
diff --git a/arch/arm/include/asm/domain.h b/arch/arm/include/asm/domain.h
index 99d9f630d6b6..6c72f533382c 100644
--- a/arch/arm/include/asm/domain.h
+++ b/arch/arm/include/asm/domain.h
@@ -53,6 +53,7 @@
 #define DOMAIN_MANAGER	3
 #else
 #define DOMAIN_MANAGER	1
+#define DOMAIN_RARE_WRITE 3
 #endif
 
 #define domain_mask(dom)	((3) << (2 * (dom)))
@@ -115,7 +116,7 @@ static inline void set_domain(unsigned val)
 }
 #endif
 
-#ifdef CONFIG_CPU_USE_DOMAINS
+#if defined(CONFIG_CPU_USE_DOMAINS) || defined(CONFIG_HAVE_ARCH_RARE_WRITE)
 #define modify_domain(dom,type)					\
 	do {							\
 		unsigned int domain = get_domain();		\
diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index a8d656d9aec7..c9492f3e9581 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -56,6 +56,33 @@ extern void __pgd_error(const char *file, int line, pgd_t);
 #define pmd_ERROR(pmd)		__pmd_error(__FILE__, __LINE__, pmd)
 #define pgd_ERROR(pgd)		__pgd_error(__FILE__, __LINE__, pgd)
 
+#ifdef CONFIG_HAVE_ARCH_RARE_WRITE
+#include <asm/domain.h>
+#include <linux/preempt.h>
+
+static inline int test_domain(int domain, int domaintype)
+{
+	return (get_domain() & domain_val(domain, 3)) ==
+		domain_val(domain, domaintype);
+}
+
+static inline unsigned long __arch_rare_write_map(void)
+{
+	preempt_disable();
+	BUG_ON(test_domain(DOMAIN_KERNEL, DOMAIN_RARE_WRITE));
+	modify_domain(DOMAIN_KERNEL, DOMAIN_RARE_WRITE);
+	return 0;
+}
+
+static inline unsigned long __arch_rare_write_unmap(void)
+{
+	BUG_ON(test_domain(DOMAIN_KERNEL, DOMAIN_MANAGER));
+	modify_domain(DOMAIN_KERNEL, DOMAIN_MANAGER);
+	preempt_enable_no_resched();
+	return 0;
+}
+#endif
+
 /*
  * This is the lowest virtual address we can permit any user space
  * mapping to be mapped at.  This is particularly important for
-- 
2.7.4
