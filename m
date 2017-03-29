From: Kees Cook <keescook@chromium.org>
Date: Wed, 29 Mar 2017 11:16:00 -0700
Message-Id: <1490811363-93944-9-git-send-email-keescook@chromium.org>
In-Reply-To: <1490811363-93944-1-git-send-email-keescook@chromium.org>
References: <1490811363-93944-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [RFC v2][PATCH 08/11] ARM: Implement __arch_rare_write_begin/end()
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>, Hoeun Ryu <hoeun.ryu@gmail.com>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
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
index 0d4e71b42c77..57b8aeaf501c 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -45,6 +45,7 @@ config ARM
 	select HAVE_ARCH_JUMP_LABEL if !XIP_KERNEL && !CPU_ENDIAN_BE32 && MMU
 	select HAVE_ARCH_KGDB if !CPU_ENDIAN_BE32 && MMU
 	select HAVE_ARCH_MMAP_RND_BITS if MMU
+	select HAVE_ARCH_RARE_WRITE if MMU && !ARM_LPAE && !CPU_USE_DOMAINS
 	select HAVE_ARCH_SECCOMP_FILTER if (AEABI && !OABI_COMPAT)
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARM_SMCCC if CPU_V7
diff --git a/arch/arm/include/asm/domain.h b/arch/arm/include/asm/domain.h
index b5ca80ac823c..b3fb5c0a2efd 100644
--- a/arch/arm/include/asm/domain.h
+++ b/arch/arm/include/asm/domain.h
@@ -54,6 +54,7 @@
 #define DOMAIN_MANAGER	3
 #else
 #define DOMAIN_MANAGER	1
+#define DOMAIN_FORCE_MANAGER 3
 #endif
 
 #define domain_mask(dom)	((3) << (2 * (dom)))
@@ -118,7 +119,7 @@ static inline void set_domain(unsigned val)
 }
 #endif
 
-#ifdef CONFIG_CPU_USE_DOMAINS
+#if defined(CONFIG_CPU_USE_DOMAINS) || defined(CONFIG_HAVE_ARCH_RARE_WRITE)
 #define modify_domain(dom,type)					\
 	do {							\
 		unsigned int domain = get_domain();		\
diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index 1c462381c225..104923ea9eb5 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -57,6 +57,33 @@ extern void __pgd_error(const char *file, int line, pgd_t);
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
+static inline unsigned long __arch_rare_write_begin(void)
+{
+	preempt_disable();
+	BUG_ON(test_domain(DOMAIN_WR_RARE, DOMAIN_FORCE_MANAGER));
+	modify_domain(DOMAIN_WR_RARE, DOMAIN_FORCE_MANAGER);
+	return 0;
+}
+
+static inline unsigned long __arch_rare_write_end(void)
+{
+	BUG_ON(test_domain(DOMAIN_WR_RARE, DOMAIN_CLIENT));
+	modify_domain(DOMAIN_WR_RARE, DOMAIN_CLIENT);
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
