From: Laura Abbott <labbott@redhat.com>
Date: Mon,  6 Feb 2017 16:31:58 -0800
Message-Id: <1486427518-14819-3-git-send-email-labbott@redhat.com>
In-Reply-To: <1486427518-14819-1-git-send-email-labbott@redhat.com>
References: <1486427518-14819-1-git-send-email-labbott@redhat.com>
Subject: [kernel-hardening] [PATCHv3 2/2] arch: Rename CONFIG_DEBUG_RODATA and CONFIG_DEBUG_MODULE_RONX
To: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@redhat.com>, Jason Wessel <jason.wessel@windriver.com>, Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Helge Deller <deller@gmx.de>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Rob Herring <robh@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Mark Rutland <mark.rutland@arm.com>, Jessica Yu <jeyu@redhat.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org, linux-pm@vger.kernel.org, kernel-hardening@lists.openwall.com, Robin Murphy <robin.murphy@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

Both of these options are poorly named. The features they provide are
necessary for system security and should not be considered debug only.
Change the names to CONFIG_STRICT_KERNEL_RWX and
CONFIG_STRICT_MODULE_RWX to better describe what these options do.

Signed-off-by: Laura Abbott <labbott@redhat.com>
---
v3: Minor config text tweek per Kees. Corrected the change of config names in
the arm config files.
---
 Documentation/DocBook/kgdb.tmpl            | 8 ++++----
 Documentation/security/self-protection.txt | 4 ++--
 arch/Kconfig                               | 4 ++--
 arch/arm/configs/aspeed_g4_defconfig       | 4 ++--
 arch/arm/configs/aspeed_g5_defconfig       | 4 ++--
 arch/arm/include/asm/cacheflush.h          | 2 +-
 arch/arm/kernel/patch.c                    | 4 ++--
 arch/arm/kernel/vmlinux.lds.S              | 8 ++++----
 arch/arm/mm/Kconfig                        | 2 +-
 arch/arm/mm/init.c                         | 4 ++--
 arch/arm64/Kconfig.debug                   | 2 +-
 arch/arm64/kernel/insn.c                   | 2 +-
 arch/parisc/configs/712_defconfig          | 1 -
 arch/parisc/configs/c3000_defconfig        | 1 -
 arch/parisc/mm/init.c                      | 2 +-
 include/linux/filter.h                     | 4 ++--
 include/linux/init.h                       | 4 ++--
 include/linux/module.h                     | 2 +-
 init/main.c                                | 4 ++--
 kernel/configs/android-recommended.config  | 2 +-
 kernel/module.c                            | 6 +++---
 kernel/power/hibernate.c                   | 2 +-
 kernel/power/power.h                       | 4 ++--
 kernel/power/snapshot.c                    | 4 ++--
 24 files changed, 41 insertions(+), 43 deletions(-)

diff --git a/Documentation/DocBook/kgdb.tmpl b/Documentation/DocBook/kgdb.tmpl
index f3abca7..856ac20 100644
--- a/Documentation/DocBook/kgdb.tmpl
+++ b/Documentation/DocBook/kgdb.tmpl
@@ -115,12 +115,12 @@
     </para>
     <para>
     If the architecture that you are using supports the kernel option
-    CONFIG_DEBUG_RODATA, you should consider turning it off.  This
+    CONFIG_STRICT_KERNEL_RWX, you should consider turning it off.  This
     option will prevent the use of software breakpoints because it
     marks certain regions of the kernel's memory space as read-only.
     If kgdb supports it for the architecture you are using, you can
     use hardware breakpoints if you desire to run with the
-    CONFIG_DEBUG_RODATA option turned on, else you need to turn off
+    CONFIG_STRICT_KERNEL_RWX option turned on, else you need to turn off
     this option.
     </para>
     <para>
@@ -135,7 +135,7 @@
     <para>Here is an example set of .config symbols to enable or
     disable for kgdb:
     <itemizedlist>
-    <listitem><para># CONFIG_DEBUG_RODATA is not set</para></listitem>
+    <listitem><para># CONFIG_STRICT_KERNEL_RWX is not set</para></listitem>
     <listitem><para>CONFIG_FRAME_POINTER=y</para></listitem>
     <listitem><para>CONFIG_KGDB=y</para></listitem>
     <listitem><para>CONFIG_KGDB_SERIAL_CONSOLE=y</para></listitem>
@@ -166,7 +166,7 @@
     </para>
     <para>Here is an example set of .config symbols to enable/disable kdb:
     <itemizedlist>
-    <listitem><para># CONFIG_DEBUG_RODATA is not set</para></listitem>
+    <listitem><para># CONFIG_STRICT_KERNEL_RWX is not set</para></listitem>
     <listitem><para>CONFIG_FRAME_POINTER=y</para></listitem>
     <listitem><para>CONFIG_KGDB=y</para></listitem>
     <listitem><para>CONFIG_KGDB_SERIAL_CONSOLE=y</para></listitem>
diff --git a/Documentation/security/self-protection.txt b/Documentation/security/self-protection.txt
index f41dd00..141acfe 100644
--- a/Documentation/security/self-protection.txt
+++ b/Documentation/security/self-protection.txt
@@ -51,8 +51,8 @@ kernel, they are implemented in a way where the memory is temporarily
 made writable during the update, and then returned to the original
 permissions.)
 
-In support of this are (the poorly named) CONFIG_DEBUG_RODATA and
-CONFIG_DEBUG_SET_MODULE_RONX, which seek to make sure that code is not
+In support of this are CONFIG_STRICT_KERNEL_RWX and
+CONFIG_STRICT_MODULE_RWX, which seek to make sure that code is not
 writable, data is not executable, and read-only data is neither writable
 nor executable.
 
diff --git a/arch/Kconfig b/arch/Kconfig
index 3f8b8be..33f5a55 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -790,7 +790,7 @@ config ARCH_OPTIONAL_KERNEL_RWX_DEFAULT
 config ARCH_HAS_STRICT_KERNEL_RWX
 	def_bool n
 
-config DEBUG_RODATA
+config STRICT_KERNEL_RWX
 	bool "Make kernel text and rodata read-only" if ARCH_OPTIONAL_KERNEL_RWX
 	depends on ARCH_HAS_STRICT_KERNEL_RWX
 	default !ARCH_OPTIONAL_KERNEL_RWX || ARCH_OPTIONAL_KERNEL_RWX_DEFAULT
@@ -806,7 +806,7 @@ config DEBUG_RODATA
 config ARCH_HAS_STRICT_MODULE_RWX
 	def_bool n
 
-config DEBUG_SET_MODULE_RONX
+config STRICT_MODULE_RWX
 	bool "Set loadable kernel module data as NX and text as RO" if ARCH_OPTIONAL_KERNEL_RWX
 	depends on ARCH_HAS_STRICT_MODULE_RWX && MODULES
 	default !ARCH_OPTIONAL_KERNEL_RWX || ARCH_OPTIONAL_KERNEL_RWX_DEFAULT
diff --git a/arch/arm/configs/aspeed_g4_defconfig b/arch/arm/configs/aspeed_g4_defconfig
index ca39c04..05b99bc 100644
--- a/arch/arm/configs/aspeed_g4_defconfig
+++ b/arch/arm/configs/aspeed_g4_defconfig
@@ -25,7 +25,6 @@ CONFIG_MODULE_UNLOAD=y
 # CONFIG_ARCH_MULTI_V7 is not set
 CONFIG_ARCH_ASPEED=y
 CONFIG_MACH_ASPEED_G4=y
-CONFIG_DEBUG_RODATA=y
 CONFIG_AEABI=y
 CONFIG_UACCESS_WITH_MEMCPY=y
 CONFIG_SECCOMP=y
@@ -79,7 +78,8 @@ CONFIG_DEBUG_LL_UART_8250=y
 CONFIG_DEBUG_UART_PHYS=0x1e784000
 CONFIG_DEBUG_UART_VIRT=0xe8784000
 CONFIG_EARLY_PRINTK=y
-CONFIG_DEBUG_SET_MODULE_RONX=y
+CONFIG_STRICT_MODULE_RWX=y
+CONFIG_STRICT_KERNEL_RWX=y
 # CONFIG_XZ_DEC_X86 is not set
 # CONFIG_XZ_DEC_POWERPC is not set
 # CONFIG_XZ_DEC_IA64 is not set
diff --git a/arch/arm/configs/aspeed_g5_defconfig b/arch/arm/configs/aspeed_g5_defconfig
index 4f366b0..05a16d5 100644
--- a/arch/arm/configs/aspeed_g5_defconfig
+++ b/arch/arm/configs/aspeed_g5_defconfig
@@ -26,7 +26,6 @@ CONFIG_ARCH_MULTI_V6=y
 # CONFIG_ARCH_MULTI_V7 is not set
 CONFIG_ARCH_ASPEED=y
 CONFIG_MACH_ASPEED_G5=y
-CONFIG_DEBUG_RODATA=y
 CONFIG_AEABI=y
 CONFIG_UACCESS_WITH_MEMCPY=y
 CONFIG_SECCOMP=y
@@ -81,7 +80,8 @@ CONFIG_DEBUG_LL_UART_8250=y
 CONFIG_DEBUG_UART_PHYS=0x1e784000
 CONFIG_DEBUG_UART_VIRT=0xe8784000
 CONFIG_EARLY_PRINTK=y
-CONFIG_DEBUG_SET_MODULE_RONX=y
+CONFIG_STRICT_MODULE_RWX=y
+CONFIG_STRICT_KERNEL_RWX=y
 # CONFIG_XZ_DEC_X86 is not set
 # CONFIG_XZ_DEC_POWERPC is not set
 # CONFIG_XZ_DEC_IA64 is not set
diff --git a/arch/arm/include/asm/cacheflush.h b/arch/arm/include/asm/cacheflush.h
index bdd283b..02454fa 100644
--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -490,7 +490,7 @@ static inline int set_memory_x(unsigned long addr, int numpages) { return 0; }
 static inline int set_memory_nx(unsigned long addr, int numpages) { return 0; }
 #endif
 
-#ifdef CONFIG_DEBUG_RODATA
+#ifdef CONFIG_STRICT_KERNEL_RWX
 void set_kernel_text_rw(void);
 void set_kernel_text_ro(void);
 #else
diff --git a/arch/arm/kernel/patch.c b/arch/arm/kernel/patch.c
index 69bda1a..020560b 100644
--- a/arch/arm/kernel/patch.c
+++ b/arch/arm/kernel/patch.c
@@ -24,9 +24,9 @@ static void __kprobes *patch_map(void *addr, int fixmap, unsigned long *flags)
 	bool module = !core_kernel_text(uintaddr);
 	struct page *page;
 
-	if (module && IS_ENABLED(CONFIG_DEBUG_SET_MODULE_RONX))
+	if (module && IS_ENABLED(CONFIG_STRICT_MODULE_RWX))
 		page = vmalloc_to_page(addr);
-	else if (!module && IS_ENABLED(CONFIG_DEBUG_RODATA))
+	else if (!module && IS_ENABLED(CONFIG_STRICT_KERNEL_RWX))
 		page = virt_to_page(addr);
 	else
 		return addr;
diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index f7f55df..ce18007 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -97,7 +97,7 @@ SECTIONS
 		HEAD_TEXT
 	}
 
-#ifdef CONFIG_DEBUG_RODATA
+#ifdef CONFIG_STRICT_KERNEL_RWX
 	. = ALIGN(1<<SECTION_SHIFT);
 #endif
 
@@ -158,7 +158,7 @@ SECTIONS
 
 	NOTES
 
-#ifdef CONFIG_DEBUG_RODATA
+#ifdef CONFIG_STRICT_KERNEL_RWX
 	. = ALIGN(1<<SECTION_SHIFT);
 #else
 	. = ALIGN(PAGE_SIZE);
@@ -230,7 +230,7 @@ SECTIONS
 	PERCPU_SECTION(L1_CACHE_BYTES)
 #endif
 
-#ifdef CONFIG_DEBUG_RODATA
+#ifdef CONFIG_STRICT_KERNEL_RWX
 	. = ALIGN(1<<SECTION_SHIFT);
 #else
 	. = ALIGN(THREAD_SIZE);
@@ -325,7 +325,7 @@ SECTIONS
 	STABS_DEBUG
 }
 
-#ifdef CONFIG_DEBUG_RODATA
+#ifdef CONFIG_STRICT_KERNEL_RWX
 /*
  * Without CONFIG_DEBUG_ALIGN_RODATA, __start_rodata_section_aligned will
  * be the first section-aligned location after __start_rodata. Otherwise,
diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index 419a035..35e3a56 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -1053,7 +1053,7 @@ config ARCH_SUPPORTS_BIG_ENDIAN
 
 config DEBUG_ALIGN_RODATA
 	bool "Make rodata strictly non-executable"
-	depends on DEBUG_RODATA
+	depends on STRICT_KERNEL_RWX
 	default y
 	help
 	  If this is set, rodata will be made explicitly non-executable. This
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 370581a..4be0bee 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -572,7 +572,7 @@ void __init mem_init(void)
 	}
 }
 
-#ifdef CONFIG_DEBUG_RODATA
+#ifdef CONFIG_STRICT_KERNEL_RWX
 struct section_perm {
 	const char *name;
 	unsigned long start;
@@ -741,7 +741,7 @@ void set_kernel_text_ro(void)
 
 #else
 static inline void fix_kernmem_perms(void) { }
-#endif /* CONFIG_DEBUG_RODATA */
+#endif /* CONFIG_STRICT_KERNEL_RWX */
 
 void free_tcmmem(void)
 {
diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug
index 939815e..560a8d8 100644
--- a/arch/arm64/Kconfig.debug
+++ b/arch/arm64/Kconfig.debug
@@ -72,7 +72,7 @@ config DEBUG_WX
 	  If in doubt, say "Y".
 
 config DEBUG_ALIGN_RODATA
-	depends on DEBUG_RODATA
+	depends on STRICT_KERNEL_RWX
 	bool "Align linker sections up to SECTION_SIZE"
 	help
 	  If this option is enabled, sections that may potentially be marked as
diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
index 94b62c1..67f9cb9 100644
--- a/arch/arm64/kernel/insn.c
+++ b/arch/arm64/kernel/insn.c
@@ -93,7 +93,7 @@ static void __kprobes *patch_map(void *addr, int fixmap)
 	bool module = !core_kernel_text(uintaddr);
 	struct page *page;
 
-	if (module && IS_ENABLED(CONFIG_DEBUG_SET_MODULE_RONX))
+	if (module && IS_ENABLED(CONFIG_STRICT_MODULE_RWX))
 		page = vmalloc_to_page(addr);
 	else if (!module)
 		page = pfn_to_page(PHYS_PFN(__pa(addr)));
diff --git a/arch/parisc/configs/712_defconfig b/arch/parisc/configs/712_defconfig
index db8f56b..143d026 100644
--- a/arch/parisc/configs/712_defconfig
+++ b/arch/parisc/configs/712_defconfig
@@ -182,7 +182,6 @@ CONFIG_DEBUG_FS=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_MUTEXES=y
 # CONFIG_RCU_CPU_STALL_DETECTOR is not set
-CONFIG_DEBUG_RODATA=y
 CONFIG_CRYPTO_NULL=m
 CONFIG_CRYPTO_TEST=m
 CONFIG_CRYPTO_HMAC=y
diff --git a/arch/parisc/configs/c3000_defconfig b/arch/parisc/configs/c3000_defconfig
index fb92b89..8e8f0e3 100644
--- a/arch/parisc/configs/c3000_defconfig
+++ b/arch/parisc/configs/c3000_defconfig
@@ -166,7 +166,6 @@ CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_MUTEXES=y
 # CONFIG_DEBUG_BUGVERBOSE is not set
 # CONFIG_RCU_CPU_STALL_DETECTOR is not set
-CONFIG_DEBUG_RODATA=y
 CONFIG_CRYPTO_NULL=m
 CONFIG_CRYPTO_TEST=m
 CONFIG_CRYPTO_MD5=m
diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
index e02ada3..a055e5b 100644
--- a/arch/parisc/mm/init.c
+++ b/arch/parisc/mm/init.c
@@ -545,7 +545,7 @@ void free_initmem(void)
 }
 
 
-#ifdef CONFIG_DEBUG_RODATA
+#ifdef CONFIG_STRICT_KERNEL_RWX
 void mark_rodata_ro(void)
 {
 	/* rodata memory was already mapped with KERNEL_RO access rights by
diff --git a/include/linux/filter.h b/include/linux/filter.h
index e4eb254..c2d2827 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -545,7 +545,7 @@ static inline bool bpf_prog_was_classic(const struct bpf_prog *prog)
 
 #define bpf_classic_proglen(fprog) (fprog->len * sizeof(fprog->filter[0]))
 
-#ifdef CONFIG_DEBUG_SET_MODULE_RONX
+#ifdef CONFIG_STRICT_MODULE_RWX
 static inline void bpf_prog_lock_ro(struct bpf_prog *fp)
 {
 	set_memory_ro((unsigned long)fp, fp->pages);
@@ -563,7 +563,7 @@ static inline void bpf_prog_lock_ro(struct bpf_prog *fp)
 static inline void bpf_prog_unlock_ro(struct bpf_prog *fp)
 {
 }
-#endif /* CONFIG_DEBUG_SET_MODULE_RONX */
+#endif /* CONFIG_STRICT_MODULE_RWX */
 
 int sk_filter_trim_cap(struct sock *sk, struct sk_buff *skb, unsigned int cap);
 static inline int sk_filter(struct sock *sk, struct sk_buff *skb)
diff --git a/include/linux/init.h b/include/linux/init.h
index 885c3e6..79af096 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -126,10 +126,10 @@ void prepare_namespace(void);
 void __init load_default_modules(void);
 int __init init_rootfs(void);
 
-#if defined(CONFIG_DEBUG_RODATA) || defined(CONFIG_DEBUG_SET_MODULE_RONX)
+#if defined(CONFIG_STRICT_KERNEL_RWX) || defined(CONFIG_STRICT_MODULE_RWX)
 extern bool rodata_enabled;
 #endif
-#ifdef CONFIG_DEBUG_RODATA
+#ifdef CONFIG_STRICT_KERNEL_RWX
 void mark_rodata_ro(void);
 #endif
 
diff --git a/include/linux/module.h b/include/linux/module.h
index cc7cba2..e270da2 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -764,7 +764,7 @@ extern int module_sysfs_initialized;
 
 #define __MODULE_STRING(x) __stringify(x)
 
-#ifdef CONFIG_DEBUG_SET_MODULE_RONX
+#ifdef CONFIG_STRICT_MODULE_RWX
 extern void set_all_modules_text_rw(void);
 extern void set_all_modules_text_ro(void);
 extern void module_enable_ro(const struct module *mod, bool after_init);
diff --git a/init/main.c b/init/main.c
index b0c9d6f..0b7bae2 100644
--- a/init/main.c
+++ b/init/main.c
@@ -925,7 +925,7 @@ static int try_to_run_init_process(const char *init_filename)
 
 static noinline void __init kernel_init_freeable(void);
 
-#if defined(CONFIG_DEBUG_RODATA) || defined(CONFIG_DEBUG_SET_MODULE_RONX)
+#if defined(CONFIG_STRICT_KERNEL_RWX) || defined(CONFIG_STRICT_MODULE_RWX)
 bool rodata_enabled __ro_after_init = true;
 static int __init set_debug_rodata(char *str)
 {
@@ -934,7 +934,7 @@ static int __init set_debug_rodata(char *str)
 __setup("rodata=", set_debug_rodata);
 #endif
 
-#ifdef CONFIG_DEBUG_RODATA
+#ifdef CONFIG_STRICT_KERNEL_RWX
 static void mark_readonly(void)
 {
 	if (rodata_enabled)
diff --git a/kernel/configs/android-recommended.config b/kernel/configs/android-recommended.config
index 297756b..99127ed 100644
--- a/kernel/configs/android-recommended.config
+++ b/kernel/configs/android-recommended.config
@@ -11,7 +11,7 @@ CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=8192
 CONFIG_COMPACTION=y
-CONFIG_DEBUG_RODATA=y
+CONFIG_STRICT_KERNEL_RWX=y
 CONFIG_DM_CRYPT=y
 CONFIG_DM_UEVENT=y
 CONFIG_DM_VERITY=y
diff --git a/kernel/module.c b/kernel/module.c
index 3d8f126..58856a4 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -74,9 +74,9 @@
 /*
  * Modules' sections will be aligned on page boundaries
  * to ensure complete separation of code and data, but
- * only when CONFIG_DEBUG_SET_MODULE_RONX=y
+ * only when CONFIG_STRICT_MODULE_RWX=y
  */
-#ifdef CONFIG_DEBUG_SET_MODULE_RONX
+#ifdef CONFIG_STRICT_MODULE_RWX
 # define debug_align(X) ALIGN(X, PAGE_SIZE)
 #else
 # define debug_align(X) (X)
@@ -1844,7 +1844,7 @@ static void mod_sysfs_teardown(struct module *mod)
 	mod_sysfs_fini(mod);
 }
 
-#ifdef CONFIG_DEBUG_SET_MODULE_RONX
+#ifdef CONFIG_STRICT_MODULE_RWX
 /*
  * LKM RO/NX protection: protect module's text/ro-data
  * from modification and any data from execution.
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index b26dbc4..86385af 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -1156,7 +1156,7 @@ static int __init hibernate_setup(char *str)
 	} else if (!strncmp(str, "no", 2)) {
 		noresume = 1;
 		nohibernate = 1;
-	} else if (IS_ENABLED(CONFIG_DEBUG_RODATA)
+	} else if (IS_ENABLED(CONFIG_STRICT_KERNEL_RWX)
 		   && !strncmp(str, "protect_image", 13)) {
 		enable_restore_image_protection();
 	}
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 1dfa0da..7fdc40d 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -61,12 +61,12 @@ extern int hibernation_snapshot(int platform_mode);
 extern int hibernation_restore(int platform_mode);
 extern int hibernation_platform_enter(void);
 
-#ifdef CONFIG_DEBUG_RODATA
+#ifdef CONFIG_STRICT_KERNEL_RWX
 /* kernel/power/snapshot.c */
 extern void enable_restore_image_protection(void);
 #else
 static inline void enable_restore_image_protection(void) {}
-#endif /* CONFIG_DEBUG_RODATA */
+#endif /* CONFIG_STRICT_KERNEL_RWX */
 
 #else /* !CONFIG_HIBERNATION */
 
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 2d8e2b2..905d5bb 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -38,7 +38,7 @@
 
 #include "power.h"
 
-#ifdef CONFIG_DEBUG_RODATA
+#ifdef CONFIG_STRICT_KERNEL_RWX
 static bool hibernate_restore_protection;
 static bool hibernate_restore_protection_active;
 
@@ -73,7 +73,7 @@ static inline void hibernate_restore_protection_begin(void) {}
 static inline void hibernate_restore_protection_end(void) {}
 static inline void hibernate_restore_protect_page(void *page_address) {}
 static inline void hibernate_restore_unprotect_page(void *page_address) {}
-#endif /* CONFIG_DEBUG_RODATA */
+#endif /* CONFIG_STRICT_KERNEL_RWX */
 
 static int swsusp_page_is_free(struct page *);
 static void swsusp_set_page_forbidden(struct page *);
-- 
2.7.4
