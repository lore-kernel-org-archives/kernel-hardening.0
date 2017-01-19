Reply-To: kernel-hardening@lists.openwall.com
From: Laura Abbott <labbott@redhat.com>
Date: Wed, 18 Jan 2017 17:29:06 -0800
Message-Id: <1484789346-21012-3-git-send-email-labbott@redhat.com>
In-Reply-To: <1484789346-21012-1-git-send-email-labbott@redhat.com>
References: <1484789346-21012-1-git-send-email-labbott@redhat.com>
Subject: [kernel-hardening] [PATCH 2/2] security: Change name of CONFIG_DEBUG_SET_MODULE_RONX
To: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@redhat.com>, Jason Wessel <jason.wessel@windriver.com>, Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Helge Deller <deller@gmx.de>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Rob Herring <robh@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Mark Rutland <mark.rutland@arm.com>, Jessica Yu <jeyu@redhat.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org, linux-pm@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


Despite the word 'debug' in CONFIG_DEBUG_SET_MODULE_RONX, this kernel
option provides key security features that are to be expected on a
modern system. Change the name to CONFIG_HARDENED_MODULE_MAPPINGS which
more accurately describes what this option is intended to do.

Signed-off-by: Laura Abbott <labbott@redhat.com>
---
 Documentation/security/self-protection.txt |  2 +-
 arch/arm/Kconfig                           |  1 +
 arch/arm/Kconfig.debug                     | 11 -----------
 arch/arm/configs/aspeed_g4_defconfig       |  2 +-
 arch/arm/configs/aspeed_g5_defconfig       |  2 +-
 arch/arm/kernel/patch.c                    |  2 +-
 arch/arm64/Kconfig                         |  1 +
 arch/arm64/Kconfig.debug                   | 11 -----------
 arch/arm64/kernel/insn.c                   |  2 +-
 arch/s390/Kconfig                          |  1 +
 arch/s390/Kconfig.debug                    |  3 ---
 arch/x86/Kconfig                           |  1 +
 arch/x86/Kconfig.debug                     | 11 -----------
 include/linux/filter.h                     |  4 ++--
 include/linux/init.h                       |  2 +-
 include/linux/module.h                     |  2 +-
 init/main.c                                |  2 +-
 kernel/module.c                            |  6 +++---
 security/Kconfig                           | 16 ++++++++++++++++
 19 files changed, 33 insertions(+), 49 deletions(-)

diff --git a/Documentation/security/self-protection.txt b/Documentation/security/self-protection.txt
index da8cb36..eb018a1 100644
--- a/Documentation/security/self-protection.txt
+++ b/Documentation/security/self-protection.txt
@@ -52,7 +52,7 @@ made writable during the update, and then returned to the original
 permissions.)
 
 In support of this are CONFIG_HARDENED_PAGE_MAPPINGS and
-CONFIG_DEBUG_SET_MODULE_RONX, which seek to make sure that code is not
+CONFIG_HARDENED_MODULE_MAPPINGS, which seek to make sure that code is not
 writable, data is not executable, and read-only data is neither writable
 nor executable.
 
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 09aff28..ef852e4 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -8,6 +8,7 @@ config ARM
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_HARDENED_MAPPINGS if MMU && !XIP_KERNEL
+	select ARCH_HAS_HARDENED_MODULE_MAPPINGS if MMU
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_USE_BUILTIN_BSWAP
diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index d83f7c3..426d271 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -1738,17 +1738,6 @@ config PID_IN_CONTEXTIDR
 	  additional instructions during context switch. Say Y here only if you
 	  are planning to use hardware trace tools with this kernel.
 
-config DEBUG_SET_MODULE_RONX
-	bool "Set loadable kernel module data as NX and text as RO"
-	depends on MODULES && MMU
-	---help---
-	  This option helps catch unintended modifications to loadable
-	  kernel module's text and read-only data. It also prevents execution
-	  of module data. Such protection may interfere with run-time code
-	  patching and dynamic kernel tracing - and they might also protect
-	  against certain classes of kernel exploits.
-	  If in doubt, say "N".
-
 source "drivers/hwtracing/coresight/Kconfig"
 
 endmenu
diff --git a/arch/arm/configs/aspeed_g4_defconfig b/arch/arm/configs/aspeed_g4_defconfig
index 8ccc216..ffe2656 100644
--- a/arch/arm/configs/aspeed_g4_defconfig
+++ b/arch/arm/configs/aspeed_g4_defconfig
@@ -79,7 +79,7 @@ CONFIG_DEBUG_LL_UART_8250=y
 CONFIG_DEBUG_UART_PHYS=0x1e784000
 CONFIG_DEBUG_UART_VIRT=0xe8784000
 CONFIG_EARLY_PRINTK=y
-CONFIG_DEBUG_SET_MODULE_RONX=y
+CONFIG_HARDENED_MODULE_MAPPINGS=y
 # CONFIG_XZ_DEC_X86 is not set
 # CONFIG_XZ_DEC_POWERPC is not set
 # CONFIG_XZ_DEC_IA64 is not set
diff --git a/arch/arm/configs/aspeed_g5_defconfig b/arch/arm/configs/aspeed_g5_defconfig
index 90c5ce4..2ea444e 100644
--- a/arch/arm/configs/aspeed_g5_defconfig
+++ b/arch/arm/configs/aspeed_g5_defconfig
@@ -81,7 +81,7 @@ CONFIG_DEBUG_LL_UART_8250=y
 CONFIG_DEBUG_UART_PHYS=0x1e784000
 CONFIG_DEBUG_UART_VIRT=0xe8784000
 CONFIG_EARLY_PRINTK=y
-CONFIG_DEBUG_SET_MODULE_RONX=y
+CONFIG_HARDENED_MODULE_MAPPINGS=y
 # CONFIG_XZ_DEC_X86 is not set
 # CONFIG_XZ_DEC_POWERPC is not set
 # CONFIG_XZ_DEC_IA64 is not set
diff --git a/arch/arm/kernel/patch.c b/arch/arm/kernel/patch.c
index 9da1bf5..eb73a76 100644
--- a/arch/arm/kernel/patch.c
+++ b/arch/arm/kernel/patch.c
@@ -24,7 +24,7 @@ static void __kprobes *patch_map(void *addr, int fixmap, unsigned long *flags)
 	bool module = !core_kernel_text(uintaddr);
 	struct page *page;
 
-	if (module && IS_ENABLED(CONFIG_DEBUG_SET_MODULE_RONX))
+	if (module && IS_ENABLED(CONFIG_HARDENED_MODULE_MAPPINGS))
 		page = vmalloc_to_page(addr);
 	else if (!module && IS_ENABLED(CONFIG_HARDENED_PAGE_MAPPINGS))
 		page = virt_to_page(addr);
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 06fed56..2fe0e98 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -12,6 +12,7 @@ config ARM64
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_GIGANTIC_PAGE
 	select ARCH_HAS_HARDENED_MAPPINGS
+	select ARCH_HAS_HARDENED_MODULE_MAPPINGS
 	select ARCH_HAS_KCOV
 	select ARCH_HAS_SG_CHAIN
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug
index a26d27f..1eebe1f 100644
--- a/arch/arm64/Kconfig.debug
+++ b/arch/arm64/Kconfig.debug
@@ -71,17 +71,6 @@ config DEBUG_WX
 
 	  If in doubt, say "Y".
 
-config DEBUG_SET_MODULE_RONX
-	bool "Set loadable kernel module data as NX and text as RO"
-	depends on MODULES
-	default y
-	help
-	  Is this is set, kernel module text and rodata will be made read-only.
-	  This is to help catch accidental or malicious attempts to change the
-	  kernel's executable code.
-
-	  If in doubt, say Y.
-
 config DEBUG_ALIGN_RODATA
 	depends on ARCH_HAS_HARDENED_MAPPINGS
 	bool "Align linker sections up to SECTION_SIZE"
diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
index 94b62c1..31bd53f 100644
--- a/arch/arm64/kernel/insn.c
+++ b/arch/arm64/kernel/insn.c
@@ -93,7 +93,7 @@ static void __kprobes *patch_map(void *addr, int fixmap)
 	bool module = !core_kernel_text(uintaddr);
 	struct page *page;
 
-	if (module && IS_ENABLED(CONFIG_DEBUG_SET_MODULE_RONX))
+	if (module && IS_ENABLED(CONFIG_HARDENED_MODULE_MAPPINGS))
 		page = vmalloc_to_page(addr);
 	else if (!module)
 		page = pfn_to_page(PHYS_PFN(__pa(addr)));
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 8e70ae5..b1e6ed5 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -69,6 +69,7 @@ config S390
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_GIGANTIC_PAGE
 	select ARCH_HAS_HARDENED_MAPPINGS
+	select ARCH_HAS_HARDENED_MODULE_MAPPINGS
 	select ARCH_HAS_KCOV
 	select ARCH_HAS_SG_CHAIN
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
diff --git a/arch/s390/Kconfig.debug b/arch/s390/Kconfig.debug
index 26c5d5be..57f8ea9 100644
--- a/arch/s390/Kconfig.debug
+++ b/arch/s390/Kconfig.debug
@@ -17,7 +17,4 @@ config S390_PTDUMP
 	  kernel.
 	  If in doubt, say "N"
 
-config DEBUG_SET_MODULE_RONX
-	def_bool y
-	depends on MODULES
 endmenu
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9d80cd8..38ce850 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -51,6 +51,7 @@ config X86
 	select ARCH_HAS_FAST_MULTIPLIER
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_HARDENED_MAPPINGS
+	select ARCH_HAS_HARDENED_MODULE_MAPPINGS
 	select ARCH_HAS_KCOV			if X86_64
 	select ARCH_HAS_MMIO_FLUSH
 	select ARCH_HAS_PMEM_API		if X86_64
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 67eec55..69cdd0b 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -109,17 +109,6 @@ config DEBUG_WX
 
 	  If in doubt, say "Y".
 
-config DEBUG_SET_MODULE_RONX
-	bool "Set loadable kernel module data as NX and text as RO"
-	depends on MODULES
-	---help---
-	  This option helps catch unintended modifications to loadable
-	  kernel module's text and read-only data. It also prevents execution
-	  of module data. Such protection may interfere with run-time code
-	  patching and dynamic kernel tracing - and they might also protect
-	  against certain classes of kernel exploits.
-	  If in doubt, say "N".
-
 config DEBUG_NX_TEST
 	tristate "Testcase for the NX non-executable stack feature"
 	depends on DEBUG_KERNEL && m
diff --git a/include/linux/filter.h b/include/linux/filter.h
index e4eb254..5426940 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -545,7 +545,7 @@ static inline bool bpf_prog_was_classic(const struct bpf_prog *prog)
 
 #define bpf_classic_proglen(fprog) (fprog->len * sizeof(fprog->filter[0]))
 
-#ifdef CONFIG_DEBUG_SET_MODULE_RONX
+#ifdef CONFIG_HARDENED_MODULE_MAPPINGS
 static inline void bpf_prog_lock_ro(struct bpf_prog *fp)
 {
 	set_memory_ro((unsigned long)fp, fp->pages);
@@ -563,7 +563,7 @@ static inline void bpf_prog_lock_ro(struct bpf_prog *fp)
 static inline void bpf_prog_unlock_ro(struct bpf_prog *fp)
 {
 }
-#endif /* CONFIG_DEBUG_SET_MODULE_RONX */
+#endif /* CONFIG_HARDENED_MODULE_MAPPINGS */
 
 int sk_filter_trim_cap(struct sock *sk, struct sk_buff *skb, unsigned int cap);
 static inline int sk_filter(struct sock *sk, struct sk_buff *skb)
diff --git a/include/linux/init.h b/include/linux/init.h
index 9967bc9..5d6b0b2 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -126,7 +126,7 @@ void prepare_namespace(void);
 void __init load_default_modules(void);
 int __init init_rootfs(void);
 
-#if defined(CONFIG_HARDENED_PAGE_MAPPINGS) || defined(CONFIG_DEBUG_SET_MODULE_RONX)
+#if defined(CONFIG_HARDENED_PAGE_MAPPINGS) || defined(CONFIG_HARDENED_MODULE_MAPPINGS)
 extern bool rodata_enabled;
 #endif
 #ifdef CONFIG_HARDENED_PAGE_MAPPINGS
diff --git a/include/linux/module.h b/include/linux/module.h
index 7c84273..a4f6926 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -764,7 +764,7 @@ extern int module_sysfs_initialized;
 
 #define __MODULE_STRING(x) __stringify(x)
 
-#ifdef CONFIG_DEBUG_SET_MODULE_RONX
+#ifdef CONFIG_HARDENED_MODULE_MAPPINGS
 extern void set_all_modules_text_rw(void);
 extern void set_all_modules_text_ro(void);
 extern void module_enable_ro(const struct module *mod, bool after_init);
diff --git a/init/main.c b/init/main.c
index 4b3bcc4..1545399 100644
--- a/init/main.c
+++ b/init/main.c
@@ -925,7 +925,7 @@ static int try_to_run_init_process(const char *init_filename)
 
 static noinline void __init kernel_init_freeable(void);
 
-#if defined(CONFIG_HARDENED_PAGE_MAPPINGS) || defined(CONFIG_DEBUG_SET_MODULE_RONX)
+#if defined(CONFIG_HARDENED_PAGE_MAPPINGS) || defined(CONFIG_HARDENED_MODULE_MAPPINGS)
 bool rodata_enabled __ro_after_init = true;
 static int __init set_debug_rodata(char *str)
 {
diff --git a/kernel/module.c b/kernel/module.c
index 38d4270..eb2f865 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -74,9 +74,9 @@
 /*
  * Modules' sections will be aligned on page boundaries
  * to ensure complete separation of code and data, but
- * only when CONFIG_DEBUG_SET_MODULE_RONX=y
+ * only when CONFIG_HARDENED_MODULE_MAPPINGS=y
  */
-#ifdef CONFIG_DEBUG_SET_MODULE_RONX
+#ifdef CONFIG_HARDENED_MODULE_MAPPINGS
 # define debug_align(X) ALIGN(X, PAGE_SIZE)
 #else
 # define debug_align(X) (X)
@@ -1847,7 +1847,7 @@ static void mod_sysfs_teardown(struct module *mod)
 	mod_sysfs_fini(mod);
 }
 
-#ifdef CONFIG_DEBUG_SET_MODULE_RONX
+#ifdef CONFIG_HARDENED_MODULE_MAPPINGS
 /*
  * LKM RO/NX protection: protect module's text/ro-data
  * from modification and any data from execution.
diff --git a/security/Kconfig b/security/Kconfig
index ad6ce82..0f98d6b 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -174,6 +174,22 @@ config HARDENED_PAGE_MAPPINGS
 	  Unless your system has known restrictions or performance issues, it
 	  is recommended to say Y here.
 
+config ARCH_HAS_HARDENED_MODULE_MAPPINGS
+	def_bool n
+
+config HARDENED_MODULE_MAPPINGS
+	bool "Mark module mappings with stricter permissions (RO/W^X)"
+	default y
+	depends on ARCH_HAS_HARDENED_MODULE_MAPPINGS
+	help
+	  If this is set, module text and rodata memory will be made read-only,
+	  and non-text memory will be made non-executable. This provides
+	  protection against certain security vulnerabilities (e.g. modifying
+	  code)
+
+	  Unless your system has known restrictions or performance issues, it
+	  is recommended to say Y here.
+
 source security/selinux/Kconfig
 source security/smack/Kconfig
 source security/tomoyo/Kconfig
-- 
2.7.4
