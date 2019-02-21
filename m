From: Russell Currey <ruscur@russell.cc>
Subject: [PATCH 2/7] powerpc: Add skeleton for Kernel Userspace Execution Prevention
Date: Thu, 21 Feb 2019 20:35:56 +1100
Message-Id: <20190221093601.27920-3-ruscur@russell.cc>
In-Reply-To: <20190221093601.27920-1-ruscur@russell.cc>
References: <20190221093601.27920-1-ruscur@russell.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: linuxppc-dev@lists.ozlabs.org
Cc: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@c-s.fr, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

From: Christophe Leroy <christophe.leroy@c-s.fr>

This patch adds a skeleton for Kernel Userspace Execution Prevention.

Then subarches implementing it have to define CONFIG_PPC_HAVE_KUEP
and provide setup_kuep() function.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 Documentation/admin-guide/kernel-parameters.txt |  2 +-
 arch/powerpc/include/asm/kup.h                  |  6 ++++++
 arch/powerpc/mm/fault.c                         |  3 ++-
 arch/powerpc/mm/init-common.c                   | 11 +++++++++++
 arch/powerpc/platforms/Kconfig.cputype          | 12 ++++++++++++
 5 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 858b6c0b9a15..8448a56a9eb9 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2812,7 +2812,7 @@
 			Disable SMAP (Supervisor Mode Access Prevention)
 			even if it is supported by processor.
 
-	nosmep		[X86]
+	nosmep		[X86,PPC]
 			Disable SMEP (Supervisor Mode Execution Prevention)
 			even if it is supported by processor.
 
diff --git a/arch/powerpc/include/asm/kup.h b/arch/powerpc/include/asm/kup.h
index 7a88b8b9b54d..af4b5f854ca4 100644
--- a/arch/powerpc/include/asm/kup.h
+++ b/arch/powerpc/include/asm/kup.h
@@ -6,6 +6,12 @@
 
 void setup_kup(void);
 
+#ifdef CONFIG_PPC_KUEP
+void setup_kuep(bool disabled);
+#else
+static inline void setup_kuep(bool disabled) { }
+#endif
+
 #endif /* !__ASSEMBLY__ */
 
 #endif /* _ASM_POWERPC_KUP_H_ */
diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index 887f11bcf330..ad65e336721a 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -230,8 +230,9 @@ static bool bad_kernel_fault(bool is_exec, unsigned long error_code,
 	if (is_exec && (error_code & (DSISR_NOEXEC_OR_G | DSISR_KEYFAULT |
 				      DSISR_PROTFAULT))) {
 		printk_ratelimited(KERN_CRIT "kernel tried to execute"
-				   " exec-protected page (%lx) -"
+				   " %s page (%lx) -"
 				   "exploit attempt? (uid: %d)\n",
+				   address >= TASK_SIZE ? "exec-protected" : "user",
 				   address, from_kuid(&init_user_ns,
 						      current_uid()));
 	}
diff --git a/arch/powerpc/mm/init-common.c b/arch/powerpc/mm/init-common.c
index 36d28e872289..83f95a5565d6 100644
--- a/arch/powerpc/mm/init-common.c
+++ b/arch/powerpc/mm/init-common.c
@@ -26,8 +26,19 @@
 #include <asm/pgtable.h>
 #include <asm/kup.h>
 
+static bool disable_kuep = !IS_ENABLED(CONFIG_PPC_KUEP);
+
+static int __init parse_nosmep(char *p)
+{
+	disable_kuep = true;
+	pr_warn("Disabling Kernel Userspace Execution Prevention\n");
+	return 0;
+}
+early_param("nosmep", parse_nosmep);
+
 void __init setup_kup(void)
 {
+	setup_kuep(disable_kuep);
 }
 
 #define CTOR(shift) static void ctor_##shift(void *addr) \
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index 8c7464c3f27f..410c3443652c 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -339,6 +339,18 @@ config PPC_RADIX_MMU_DEFAULT
 
 	  If you're unsure, say Y.
 
+config PPC_HAVE_KUEP
+	bool
+
+config PPC_KUEP
+	bool "Kernel Userspace Execution Prevention"
+	depends on PPC_HAVE_KUEP
+	default y
+	help
+	  Enable support for Kernel Userspace Execution Prevention (KUEP)
+
+	  If you're unsure, say Y.
+
 config ARCH_ENABLE_HUGEPAGE_MIGRATION
 	def_bool y
 	depends on PPC_BOOK3S_64 && HUGETLB_PAGE && MIGRATION
-- 
2.20.1
