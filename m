Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Thu, 25 Apr 2013 14:54:17 -0700
Message-Id: <1366926860-26776-4-git-send-email-keescook@chromium.org>
In-Reply-To: <1366926860-26776-1-git-send-email-keescook@chromium.org>
References: <1366926860-26776-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 3/6] x86: kaslr: return location from decompress_kernel
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

This allows decompress_kernel to return a new location for the kernel to
be relocated to. With CONFIG_RANDOMIZE_BASE, the choose_kernel_location
routine will select a new location to decompress the kernel, and is
presently a no-op. The logic for bypassing this routine with "noaslr"
on the kernel command line is handled.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 Documentation/kernel-parameters.txt |    4 ++++
 arch/x86/boot/compressed/Makefile   |    2 +-
 arch/x86/boot/compressed/aslr.c     |   21 +++++++++++++++++++++
 arch/x86/boot/compressed/cmdline.c  |    2 +-
 arch/x86/boot/compressed/head_32.S  |    2 +-
 arch/x86/boot/compressed/head_64.S  |    2 +-
 arch/x86/boot/compressed/misc.c     |    7 +++++--
 arch/x86/boot/compressed/misc.h     |   22 ++++++++++++++++------
 8 files changed, 50 insertions(+), 12 deletions(-)
 create mode 100644 arch/x86/boot/compressed/aslr.c

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 8ccbf27..eb1c62c 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1862,6 +1862,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	noapic		[SMP,APIC] Tells the kernel to not make use of any
 			IOAPICs that may be present in the system.
 
+	noaslr		[X86]
+			Disable kernel base offset ASLR (Address Space
+			Layout Randomization) if built into the kernel.
+
 	noautogroup	Disable scheduler automatic task group creation.
 
 	nobats		[PPC] Do not use BATs for mapping kernel lowmem
diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index d854390..fa2629b 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -26,7 +26,7 @@ HOST_EXTRACFLAGS += -I$(srctree)/tools/include
 
 VMLINUX_OBJS = $(obj)/vmlinux.lds $(obj)/head_$(BITS).o $(obj)/misc.o \
 	$(obj)/string.o $(obj)/cmdline.o $(obj)/early_serial_console.o \
-	$(obj)/piggy.o $(obj)/cpuflags.o
+	$(obj)/piggy.o $(obj)/cpuflags.o $(obj)/aslr.o
 
 $(obj)/eboot.o: KBUILD_CFLAGS += -fshort-wchar -mno-red-zone
 
diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
new file mode 100644
index 0000000..d5331ee
--- /dev/null
+++ b/arch/x86/boot/compressed/aslr.c
@@ -0,0 +1,21 @@
+#include "misc.h"
+
+#ifdef CONFIG_RANDOMIZE_BASE
+
+unsigned char *choose_kernel_location(unsigned char *hint, unsigned long size)
+{
+	unsigned char *choice = hint;
+	unsigned long random;
+
+	if (cmdline_find_option_bool("noaslr")) {
+		debug_putstr("KASLR disabled...\n");
+		goto out;
+	}
+
+	/* XXX: choose random location. */
+
+out:
+	return choice;
+}
+
+#endif /* CONFIG_RANDOMIZE_BASE */
diff --git a/arch/x86/boot/compressed/cmdline.c b/arch/x86/boot/compressed/cmdline.c
index bffd73b..b68e303 100644
--- a/arch/x86/boot/compressed/cmdline.c
+++ b/arch/x86/boot/compressed/cmdline.c
@@ -1,6 +1,6 @@
 #include "misc.h"
 
-#ifdef CONFIG_EARLY_PRINTK
+#if CONFIG_EARLY_PRINTK || CONFIG_RANDOMIZE_BASE
 
 static unsigned long fs;
 static inline void set_fs(unsigned long seg)
diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index 5d6f689..a48631a 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -198,7 +198,7 @@ relocated:
  * Jump to the decompressed kernel.
  */
 	xorl	%ebx, %ebx
-	jmp	*%ebp
+	jmp	*%eax
 
 /*
  * Stack and heap for uncompression
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 81ca174..bfd9be8 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -347,7 +347,7 @@ relocated:
 /*
  * Jump to the decompressed kernel.
  */
-	jmp	*%rbp
+	jmp	*%rax
 
 	.code32
 no_longmode:
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index b756a04..15a3ea8 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -391,7 +391,7 @@ static void parse_elf(void *output)
 	free(phdrs);
 }
 
-asmlinkage void decompress_kernel(void *rmode, memptr heap,
+asmlinkage void *decompress_kernel(void *rmode, memptr heap,
 				  unsigned char *input_data,
 				  unsigned long input_len,
 				  unsigned char *output,
@@ -418,6 +418,9 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
 	free_mem_ptr     = heap;	/* Heap */
 	free_mem_end_ptr = heap + BOOT_HEAP_SIZE;
 
+	output = choose_kernel_location(output, output_len);
+
+	/* Validate memory location choices. */
 	if ((unsigned long)output & (MIN_KERNEL_ALIGN - 1))
 		error("Destination address inappropriately aligned");
 #ifdef CONFIG_X86_64
@@ -437,5 +440,5 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
 	parse_elf(output);
 	handle_relocations(output, output_len);
 	debug_putstr("done.\nBooting the kernel.\n");
-	return;
+	return output;
 }
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 674019d..2a5c7aa 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -39,23 +39,33 @@ static inline void debug_putstr(const char *s)
 
 #endif
 
-#ifdef CONFIG_EARLY_PRINTK
-
+#if CONFIG_EARLY_PRINTK || CONFIG_RANDOMIZE_BASE
 /* cmdline.c */
 int cmdline_find_option(const char *option, char *buffer, int bufsize);
 int cmdline_find_option_bool(const char *option);
+#endif
+
+#if CONFIG_RANDOMIZE_BASE
+/* aslr.c */
+unsigned char *choose_kernel_location(unsigned char *hint, unsigned long size);
+/* cpuflags.c */
+bool has_cpuflag(int flag);
+#else
+static inline unsigned char *choose_kernel_location(unsigned char *hint,
+						    unsigned long size)
+{
+	return hint;
+}
+#endif
 
+#ifdef CONFIG_EARLY_PRINTK
 /* early_serial_console.c */
 extern int early_serial_base;
 void console_init(void);
-
 #else
-
-/* early_serial_console.c */
 static const int early_serial_base;
 static inline void console_init(void)
 { }
-
 #endif
 
 #endif
-- 
1.7.9.5
