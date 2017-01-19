Reply-To: kernel-hardening@lists.openwall.com
From: Laura Abbott <labbott@redhat.com>
Date: Wed, 18 Jan 2017 17:29:05 -0800
Message-Id: <1484789346-21012-2-git-send-email-labbott@redhat.com>
In-Reply-To: <1484789346-21012-1-git-send-email-labbott@redhat.com>
References: <1484789346-21012-1-git-send-email-labbott@redhat.com>
Subject: [kernel-hardening] [PATCH 1/2] security: Change name of CONFIG_DEBUG_RODATA
To: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@redhat.com>, Jason Wessel <jason.wessel@windriver.com>, Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Helge Deller <deller@gmx.de>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Rob Herring <robh@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Mark Rutland <mark.rutland@arm.com>, Jessica Yu <jeyu@redhat.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org, linux-pm@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


Despite the word 'debug' in CONFIG_DEBUG_RODATA, this kernel option
provides key security features that are to be expected on a modern
system. Change the name to CONFIG_HARDENED_PAGE_MAPPINGS which more
accurately describes what this option is intended to do.

Signed-off-by: Laura Abbott <labbott@redhat.com>
---
 Documentation/DocBook/kgdb.tmpl            |  8 ++++----
 Documentation/security/self-protection.txt |  2 +-
 arch/arm/Kconfig                           |  1 +
 arch/arm/configs/aspeed_g4_defconfig       |  2 +-
 arch/arm/configs/aspeed_g5_defconfig       |  2 +-
 arch/arm/include/asm/cacheflush.h          |  2 +-
 arch/arm/kernel/patch.c                    |  2 +-
 arch/arm/kernel/vmlinux.lds.S              |  8 ++++----
 arch/arm/mm/Kconfig                        | 14 +-------------
 arch/arm/mm/init.c                         |  4 ++--
 arch/arm64/Kconfig                         |  4 +---
 arch/arm64/Kconfig.debug                   |  2 +-
 arch/parisc/Kconfig                        |  1 +
 arch/parisc/Kconfig.debug                  | 11 -----------
 arch/parisc/configs/712_defconfig          |  2 +-
 arch/parisc/configs/c3000_defconfig        |  2 +-
 arch/parisc/mm/init.c                      |  2 +-
 arch/s390/Kconfig                          |  4 +---
 arch/x86/Kconfig                           |  4 +---
 include/linux/init.h                       |  4 ++--
 init/main.c                                |  4 ++--
 kernel/configs/android-recommended.config  |  2 +-
 kernel/power/hibernate.c                   |  2 +-
 kernel/power/power.h                       |  4 ++--
 kernel/power/snapshot.c                    |  4 ++--
 security/Kconfig                           | 16 ++++++++++++++++
 26 files changed, 51 insertions(+), 62 deletions(-)

diff --git a/Documentation/DocBook/kgdb.tmpl b/Documentation/DocBook/kgdb.tmpl
index f3abca7..a79b638 100644
--- a/Documentation/DocBook/kgdb.tmpl
+++ b/Documentation/DocBook/kgdb.tmpl
@@ -115,12 +115,12 @@
     </para>
     <para>
     If the architecture that you are using supports the kernel option
-    CONFIG_DEBUG_RODATA, you should consider turning it off.  This
+    CONFIG_HARDENED_PAGE_MAPPINGS, you should consider turning it off.  This
     option will prevent the use of software breakpoints because it
     marks certain regions of the kernel's memory space as read-only.
     If kgdb supports it for the architecture you are using, you can
     use hardware breakpoints if you desire to run with the
-    CONFIG_DEBUG_RODATA option turned on, else you need to turn off
+    CONFIG_HARDENED_PAGE_MAPPINGS option turned on, else you need to turn off
     this option.
     </para>
     <para>
@@ -135,7 +135,7 @@
     <para>Here is an example set of .config symbols to enable or
     disable for kgdb:
     <itemizedlist>
-    <listitem><para># CONFIG_DEBUG_RODATA is not set</para></listitem>
+    <listitem><para># CONFIG_HARDENED_PAGE_MAPPINGS is not set</para></listitem>
     <listitem><para>CONFIG_FRAME_POINTER=y</para></listitem>
     <listitem><para>CONFIG_KGDB=y</para></listitem>
     <listitem><para>CONFIG_KGDB_SERIAL_CONSOLE=y</para></listitem>
@@ -166,7 +166,7 @@
     </para>
     <para>Here is an example set of .config symbols to enable/disable kdb:
     <itemizedlist>
-    <listitem><para># CONFIG_DEBUG_RODATA is not set</para></listitem>
+    <listitem><para># CONFIG_HARDENED_PAGE_MAPPINGS is not set</para></listitem>
     <listitem><para>CONFIG_FRAME_POINTER=y</para></listitem>
     <listitem><para>CONFIG_KGDB=y</para></listitem>
     <listitem><para>CONFIG_KGDB_SERIAL_CONSOLE=y</para></listitem>
diff --git a/Documentation/security/self-protection.txt b/Documentation/security/self-protection.txt
index 3010576..da8cb36 100644
--- a/Documentation/security/self-protection.txt
+++ b/Documentation/security/self-protection.txt
@@ -51,7 +51,7 @@ kernel, they are implemented in a way where the memory is temporarily
 made writable during the update, and then returned to the original
 permissions.)
 
-In support of this are (the poorly named) CONFIG_DEBUG_RODATA and
+In support of this are CONFIG_HARDENED_PAGE_MAPPINGS and
 CONFIG_DEBUG_SET_MODULE_RONX, which seek to make sure that code is not
 writable, data is not executable, and read-only data is neither writable
 nor executable.
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 186c4c2..09aff28 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -7,6 +7,7 @@ config ARM
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select ARCH_HAS_GCOV_PROFILE_ALL
+	select ARCH_HAS_HARDENED_MAPPINGS if MMU && !XIP_KERNEL
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_USE_BUILTIN_BSWAP
diff --git a/arch/arm/configs/aspeed_g4_defconfig b/arch/arm/configs/aspeed_g4_defconfig
index ca39c04..8ccc216 100644
--- a/arch/arm/configs/aspeed_g4_defconfig
+++ b/arch/arm/configs/aspeed_g4_defconfig
@@ -25,7 +25,7 @@ CONFIG_MODULE_UNLOAD=y
 # CONFIG_ARCH_MULTI_V7 is not set
 CONFIG_ARCH_ASPEED=y
 CONFIG_MACH_ASPEED_G4=y
-CONFIG_DEBUG_RODATA=y
+CONFIG_HARDENED_PAGE_MAPPINGS=y
 CONFIG_AEABI=y
 CONFIG_UACCESS_WITH_MEMCPY=y
 CONFIG_SECCOMP=y
diff --git a/arch/arm/configs/aspeed_g5_defconfig b/arch/arm/configs/aspeed_g5_defconfig
index 4f366b0..90c5ce4 100644
--- a/arch/arm/configs/aspeed_g5_defconfig
+++ b/arch/arm/configs/aspeed_g5_defconfig
@@ -26,7 +26,7 @@ CONFIG_ARCH_MULTI_V6=y
 # CONFIG_ARCH_MULTI_V7 is not set
 CONFIG_ARCH_ASPEED=y
 CONFIG_MACH_ASPEED_G5=y
-CONFIG_DEBUG_RODATA=y
+CONFIG_HARDENED_PAGE_MAPPINGS=y
 CONFIG_AEABI=y
 CONFIG_UACCESS_WITH_MEMCPY=y
 CONFIG_SECCOMP=y
diff --git a/arch/arm/include/asm/cacheflush.h b/arch/arm/include/asm/cacheflush.h
index bdd283b..c3a7a72 100644
--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -490,7 +490,7 @@ static inline int set_memory_x(unsigned long addr, int numpages) { return 0; }
 static inline int set_memory_nx(unsigned long addr, int numpages) { return 0; }
 #endif
 
-#ifdef CONFIG_DEBUG_RODATA
+#ifdef CONFIG_HARDENED_PAGE_MAPPINGS
 void set_kernel_text_rw(void);
 void set_kernel_text_ro(void);
 #else
diff --git a/arch/arm/kernel/patch.c b/arch/arm/kernel/patch.c
index 69bda1a..9da1bf5 100644
--- a/arch/arm/kernel/patch.c
+++ b/arch/arm/kernel/patch.c
@@ -26,7 +26,7 @@ static void __kprobes *patch_map(void *addr, int fixmap, unsigned long *flags)
 
 	if (module && IS_ENABLED(CONFIG_DEBUG_SET_MODULE_RONX))
 		page = vmalloc_to_page(addr);
-	else if (!module && IS_ENABLED(CONFIG_DEBUG_RODATA))
+	else if (!module && IS_ENABLED(CONFIG_HARDENED_PAGE_MAPPINGS))
 		page = virt_to_page(addr);
 	else
 		return addr;
diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index f7f55df..5c6a2e8 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -97,7 +97,7 @@ SECTIONS
 		HEAD_TEXT
 	}
 
-#ifdef CONFIG_DEBUG_RODATA
+#ifdef CONFIG_HARDENED_PAGE_MAPPINGS
 	. = ALIGN(1<<SECTION_SHIFT);
 #endif
 
@@ -158,7 +158,7 @@ SECTIONS
 
 	NOTES
 
-#ifdef CONFIG_DEBUG_RODATA
+#ifdef CONFIG_HARDENED_PAGE_MAPPINGS
 	. = ALIGN(1<<SECTION_SHIFT);
 #else
 	. = ALIGN(PAGE_SIZE);
@@ -230,7 +230,7 @@ SECTIONS
 	PERCPU_SECTION(L1_CACHE_BYTES)
 #endif
 
-#ifdef CONFIG_DEBUG_RODATA
+#ifdef CONFIG_HARDENED_PAGE_MAPPINGS
 	. = ALIGN(1<<SECTION_SHIFT);
 #else
 	. = ALIGN(THREAD_SIZE);
@@ -325,7 +325,7 @@ SECTIONS
 	STABS_DEBUG
 }
 
-#ifdef CONFIG_DEBUG_RODATA
+#ifdef CONFIG_HARDENED_PAGE_MAPPINGS
 /*
  * Without CONFIG_DEBUG_ALIGN_RODATA, __start_rodata_section_aligned will
  * be the first section-aligned location after __start_rodata. Otherwise,
diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index f68e8ec..e770dc9 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -1051,21 +1051,9 @@ config ARCH_SUPPORTS_BIG_ENDIAN
 	  This option specifies the architecture can support big endian
 	  operation.
 
-config DEBUG_RODATA
-	bool "Make kernel text and rodata read-only"
-	depends on MMU && !XIP_KERNEL
-	default y if CPU_V7
-	help
-	  If this is set, kernel text and rodata memory will be made
-	  read-only, and non-text kernel memory will be made non-executable.
-	  The tradeoff is that each region is padded to section-size (1MiB)
-	  boundaries (because their permissions are different and splitting
-	  the 1M pages into 4K ones causes TLB performance problems), which
-	  can waste memory.
-
 config DEBUG_ALIGN_RODATA
 	bool "Make rodata strictly non-executable"
-	depends on DEBUG_RODATA
+	depends on HARDENED_PAGE_MAPPINGS
 	default y
 	help
 	  If this is set, rodata will be made explicitly non-executable. This
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 370581a..303bee4 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -572,7 +572,7 @@ void __init mem_init(void)
 	}
 }
 
-#ifdef CONFIG_DEBUG_RODATA
+#ifdef CONFIG_HARDENED_PAGE_MAPPINGS
 struct section_perm {
 	const char *name;
 	unsigned long start;
@@ -741,7 +741,7 @@ void set_kernel_text_ro(void)
 
 #else
 static inline void fix_kernmem_perms(void) { }
-#endif /* CONFIG_DEBUG_RODATA */
+#endif /* CONFIG_HARDENED_PAGE_MAPPINGS */
 
 void free_tcmmem(void)
 {
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 1117421..06fed56 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -11,6 +11,7 @@ config ARM64
 	select ARCH_HAS_ELF_RANDOMIZE
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_GIGANTIC_PAGE
+	select ARCH_HAS_HARDENED_MAPPINGS
 	select ARCH_HAS_KCOV
 	select ARCH_HAS_SG_CHAIN
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
@@ -123,9 +124,6 @@ config ARCH_PHYS_ADDR_T_64BIT
 config MMU
 	def_bool y
 
-config DEBUG_RODATA
-	def_bool y
-
 config ARM64_PAGE_SHIFT
 	int
 	default 16 if ARM64_64K_PAGES
diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug
index d1ebd46..a26d27f 100644
--- a/arch/arm64/Kconfig.debug
+++ b/arch/arm64/Kconfig.debug
@@ -83,7 +83,7 @@ config DEBUG_SET_MODULE_RONX
 	  If in doubt, say Y.
 
 config DEBUG_ALIGN_RODATA
-	depends on DEBUG_RODATA
+	depends on ARCH_HAS_HARDENED_MAPPINGS
 	bool "Align linker sections up to SECTION_SIZE"
 	help
 	  If this option is enabled, sections that may potentially be marked as
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 3a71f38..7c73eaa 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -8,6 +8,7 @@ config PARISC
 	select HAVE_SYSCALL_TRACEPOINTS
 	select ARCH_WANT_FRAME_POINTERS
 	select ARCH_HAS_ELF_RANDOMIZE
+	select ARCH_HAS_HARDENED_MAPPINGS
 	select RTC_CLASS
 	select RTC_DRV_GENERIC
 	select INIT_ALL_POSSIBLE
diff --git a/arch/parisc/Kconfig.debug b/arch/parisc/Kconfig.debug
index 68b7cbd..0d856b9 100644
--- a/arch/parisc/Kconfig.debug
+++ b/arch/parisc/Kconfig.debug
@@ -5,15 +5,4 @@ source "lib/Kconfig.debug"
 config TRACE_IRQFLAGS_SUPPORT
 	def_bool y
 
-config DEBUG_RODATA
-       bool "Write protect kernel read-only data structures"
-       depends on DEBUG_KERNEL
-       default y
-       help
-         Mark the kernel read-only data as write-protected in the pagetables,
-         in order to catch accidental (and incorrect) writes to such const
-         data. This option may have a slight performance impact because a
-         portion of the kernel code won't be covered by a TLB anymore.
-         If in doubt, say "N".
-
 endmenu
diff --git a/arch/parisc/configs/712_defconfig b/arch/parisc/configs/712_defconfig
index db8f56b..f1a4732 100644
--- a/arch/parisc/configs/712_defconfig
+++ b/arch/parisc/configs/712_defconfig
@@ -182,7 +182,7 @@ CONFIG_DEBUG_FS=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_MUTEXES=y
 # CONFIG_RCU_CPU_STALL_DETECTOR is not set
-CONFIG_DEBUG_RODATA=y
+CONFIG_HARDENED_PAGE_MAPPINGS=y
 CONFIG_CRYPTO_NULL=m
 CONFIG_CRYPTO_TEST=m
 CONFIG_CRYPTO_HMAC=y
diff --git a/arch/parisc/configs/c3000_defconfig b/arch/parisc/configs/c3000_defconfig
index fb92b89..03e88e2 100644
--- a/arch/parisc/configs/c3000_defconfig
+++ b/arch/parisc/configs/c3000_defconfig
@@ -166,7 +166,7 @@ CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_MUTEXES=y
 # CONFIG_DEBUG_BUGVERBOSE is not set
 # CONFIG_RCU_CPU_STALL_DETECTOR is not set
-CONFIG_DEBUG_RODATA=y
+CONFIG_HARDENED_PAGE_MAPPINGS=y
 CONFIG_CRYPTO_NULL=m
 CONFIG_CRYPTO_TEST=m
 CONFIG_CRYPTO_MD5=m
diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
index e02ada3..f76f8ad 100644
--- a/arch/parisc/mm/init.c
+++ b/arch/parisc/mm/init.c
@@ -545,7 +545,7 @@ void free_initmem(void)
 }
 
 
-#ifdef CONFIG_DEBUG_RODATA
+#ifdef CONFIG_HARDENED_PAGE_MAPPINGS
 void mark_rodata_ro(void)
 {
 	/* rodata memory was already mapped with KERNEL_RO access rights by
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index c6722112..8e70ae5 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -62,15 +62,13 @@ config PCI_QUIRKS
 config ARCH_SUPPORTS_UPROBES
 	def_bool y
 
-config DEBUG_RODATA
-	def_bool y
-
 config S390
 	def_bool y
 	select ARCH_HAS_DEVMEM_IS_ALLOWED
 	select ARCH_HAS_ELF_RANDOMIZE
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_GIGANTIC_PAGE
+	select ARCH_HAS_HARDENED_MAPPINGS
 	select ARCH_HAS_KCOV
 	select ARCH_HAS_SG_CHAIN
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e487493..9d80cd8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -50,6 +50,7 @@ config X86
 	select ARCH_HAS_ELF_RANDOMIZE
 	select ARCH_HAS_FAST_MULTIPLIER
 	select ARCH_HAS_GCOV_PROFILE_ALL
+	select ARCH_HAS_HARDENED_MAPPINGS
 	select ARCH_HAS_KCOV			if X86_64
 	select ARCH_HAS_MMIO_FLUSH
 	select ARCH_HAS_PMEM_API		if X86_64
@@ -309,9 +310,6 @@ config ARCH_SUPPORTS_UPROBES
 config FIX_EARLYCON_MEM
 	def_bool y
 
-config DEBUG_RODATA
-	def_bool y
-
 config PGTABLE_LEVELS
 	int
 	default 4 if X86_64
diff --git a/include/linux/init.h b/include/linux/init.h
index 885c3e6..9967bc9 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -126,10 +126,10 @@ void prepare_namespace(void);
 void __init load_default_modules(void);
 int __init init_rootfs(void);
 
-#if defined(CONFIG_DEBUG_RODATA) || defined(CONFIG_DEBUG_SET_MODULE_RONX)
+#if defined(CONFIG_HARDENED_PAGE_MAPPINGS) || defined(CONFIG_DEBUG_SET_MODULE_RONX)
 extern bool rodata_enabled;
 #endif
-#ifdef CONFIG_DEBUG_RODATA
+#ifdef CONFIG_HARDENED_PAGE_MAPPINGS
 void mark_rodata_ro(void);
 #endif
 
diff --git a/init/main.c b/init/main.c
index b0c9d6f..4b3bcc4 100644
--- a/init/main.c
+++ b/init/main.c
@@ -925,7 +925,7 @@ static int try_to_run_init_process(const char *init_filename)
 
 static noinline void __init kernel_init_freeable(void);
 
-#if defined(CONFIG_DEBUG_RODATA) || defined(CONFIG_DEBUG_SET_MODULE_RONX)
+#if defined(CONFIG_HARDENED_PAGE_MAPPINGS) || defined(CONFIG_DEBUG_SET_MODULE_RONX)
 bool rodata_enabled __ro_after_init = true;
 static int __init set_debug_rodata(char *str)
 {
@@ -934,7 +934,7 @@ static int __init set_debug_rodata(char *str)
 __setup("rodata=", set_debug_rodata);
 #endif
 
-#ifdef CONFIG_DEBUG_RODATA
+#ifdef CONFIG_HARDENED_PAGE_MAPPINGS
 static void mark_readonly(void)
 {
 	if (rodata_enabled)
diff --git a/kernel/configs/android-recommended.config b/kernel/configs/android-recommended.config
index 297756b..b796bc8 100644
--- a/kernel/configs/android-recommended.config
+++ b/kernel/configs/android-recommended.config
@@ -11,7 +11,7 @@ CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=8192
 CONFIG_COMPACTION=y
-CONFIG_DEBUG_RODATA=y
+CONFIG_HARDENED_PAGE_MAPPINGS=y
 CONFIG_DM_CRYPT=y
 CONFIG_DM_UEVENT=y
 CONFIG_DM_VERITY=y
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index b26dbc4..f7a3ea3 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -1156,7 +1156,7 @@ static int __init hibernate_setup(char *str)
 	} else if (!strncmp(str, "no", 2)) {
 		noresume = 1;
 		nohibernate = 1;
-	} else if (IS_ENABLED(CONFIG_DEBUG_RODATA)
+	} else if (IS_ENABLED(CONFIG_HARDENED_PAGE_MAPPINGS)
 		   && !strncmp(str, "protect_image", 13)) {
 		enable_restore_image_protection();
 	}
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 1dfa0da..dc2c7b8 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -61,12 +61,12 @@ extern int hibernation_snapshot(int platform_mode);
 extern int hibernation_restore(int platform_mode);
 extern int hibernation_platform_enter(void);
 
-#ifdef CONFIG_DEBUG_RODATA
+#ifdef CONFIG_HARDENED_PAGE_MAPPINGS
 /* kernel/power/snapshot.c */
 extern void enable_restore_image_protection(void);
 #else
 static inline void enable_restore_image_protection(void) {}
-#endif /* CONFIG_DEBUG_RODATA */
+#endif /* CONFIG_HARDENED_PAGE_MAPPINGS */
 
 #else /* !CONFIG_HIBERNATION */
 
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 2d8e2b2..a7c793e 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -38,7 +38,7 @@
 
 #include "power.h"
 
-#ifdef CONFIG_DEBUG_RODATA
+#ifdef CONFIG_HARDENED_PAGE_MAPPINGS
 static bool hibernate_restore_protection;
 static bool hibernate_restore_protection_active;
 
@@ -73,7 +73,7 @@ static inline void hibernate_restore_protection_begin(void) {}
 static inline void hibernate_restore_protection_end(void) {}
 static inline void hibernate_restore_protect_page(void *page_address) {}
 static inline void hibernate_restore_unprotect_page(void *page_address) {}
-#endif /* CONFIG_DEBUG_RODATA */
+#endif /* CONFIG_HARDENED_PAGE_MAPPINGS */
 
 static int swsusp_page_is_free(struct page *);
 static void swsusp_set_page_forbidden(struct page *);
diff --git a/security/Kconfig b/security/Kconfig
index 118f454..ad6ce82 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -158,6 +158,22 @@ config HARDENED_USERCOPY_PAGESPAN
 	  been removed. This config is intended to be used only while
 	  trying to find such users.
 
+config ARCH_HAS_HARDENED_MAPPINGS
+	def_bool n
+
+config HARDENED_PAGE_MAPPINGS
+	bool "Mark kernel mappings with stricter permissions (RO/W^X)"
+	default y
+	depends on ARCH_HAS_HARDENED_MAPPINGS
+	help
+          If this is set, kernel text and rodata memory will be made read-only,
+	  and non-text memory will be made non-executable. This provides
+	  protection against certain security attacks (e.g. executing the heap
+	  or modifying text).
+
+	  Unless your system has known restrictions or performance issues, it
+	  is recommended to say Y here.
+
 source security/selinux/Kconfig
 source security/smack/Kconfig
 source security/tomoyo/Kconfig
-- 
2.7.4
