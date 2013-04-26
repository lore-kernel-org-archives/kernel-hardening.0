Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Fri, 26 Apr 2013 12:03:20 -0700
Message-Id: <1367003005-5560-2-git-send-email-keescook@chromium.org>
In-Reply-To: <1367003005-5560-1-git-send-email-keescook@chromium.org>
References: <1367003005-5560-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 1/6] x86: kaslr: move ELF relocation handling to C
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

Moves the relocation handling into C, after decompression. Only
kernels that need relocation support will use the code. The new
CONFIG_RANDOMIZE_BASE does not yet do anything except turn on this logic
for 64-bit kernels.

Based on work by Neill Clift and Michael Davidson.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
v2:
 - made CONFIG_RANDOMIZE_BASE interactively selectable.
---
 arch/x86/Kconfig                     |   11 +++--
 arch/x86/Makefile                    |    8 ++--
 arch/x86/boot/compressed/head_32.S   |   31 ++------------
 arch/x86/boot/compressed/head_64.S   |    1 +
 arch/x86/boot/compressed/misc.c      |   77 +++++++++++++++++++++++++++++++++-
 arch/x86/include/asm/page_32_types.h |    2 +
 arch/x86/include/asm/page_64_types.h |    5 ---
 arch/x86/include/asm/page_types.h    |    6 +++
 8 files changed, 100 insertions(+), 41 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 15b5cef..6f59afe 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1699,13 +1699,18 @@ config RELOCATABLE
 	  it has been loaded at and the compile time physical address
 	  (CONFIG_PHYSICAL_START) is ignored.
 
-# Relocation on x86-32 needs some additional build support
+config RANDOMIZE_BASE
+	bool "Enable 64-bit relocation support (for KASLR)"
+	depends on RELOCATABLE
+	default n
+
+# Relocation on x86 needs some additional build support
 config X86_NEED_RELOCS
 	def_bool y
-	depends on X86_32 && RELOCATABLE
+	depends on RANDOMIZE_BASE || (X86_32 && RELOCATABLE)
 
 config PHYSICAL_ALIGN
-	hex "Alignment value to which kernel should be aligned" if X86_32
+	hex "Alignment value to which kernel should be aligned"
 	default "0x1000000"
 	range 0x2000 0x1000000
 	---help---
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 5c47726..43f8cef 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -16,6 +16,10 @@ endif
 # e.g.: obj-y += foo_$(BITS).o
 export BITS
 
+ifdef CONFIG_X86_NEED_RELOCS
+        LDFLAGS_vmlinux := --emit-relocs
+endif
+
 ifeq ($(CONFIG_X86_32),y)
         BITS := 32
         UTS_MACHINE := i386
@@ -25,10 +29,6 @@ ifeq ($(CONFIG_X86_32),y)
         KBUILD_AFLAGS += $(biarch)
         KBUILD_CFLAGS += $(biarch)
 
-        ifdef CONFIG_RELOCATABLE
-                LDFLAGS_vmlinux := --emit-relocs
-        endif
-
         KBUILD_CFLAGS += -msoft-float -mregparm=3 -freg-struct-return
 
         # Never want PIC in a 32-bit kernel, prevent breakage with GCC built
diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index 1e3184f..5d6f689 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -181,8 +181,9 @@ relocated:
 /*
  * Do the decompression, and jump to the new kernel..
  */
-	leal	z_extract_offset_negative(%ebx), %ebp
 				/* push arguments for decompress_kernel: */
+	pushl	$z_output_len	/* decompressed length */
+	leal	z_extract_offset_negative(%ebx), %ebp
 	pushl	%ebp		/* output address */
 	pushl	$z_input_len	/* input_len */
 	leal	input_data(%ebx), %eax
@@ -191,33 +192,7 @@ relocated:
 	pushl	%eax		/* heap area */
 	pushl	%esi		/* real mode pointer */
 	call	decompress_kernel
-	addl	$20, %esp
-
-#if CONFIG_RELOCATABLE
-/*
- * Find the address of the relocations.
- */
-	leal	z_output_len(%ebp), %edi
-
-/*
- * Calculate the delta between where vmlinux was compiled to run
- * and where it was actually loaded.
- */
-	movl	%ebp, %ebx
-	subl	$LOAD_PHYSICAL_ADDR, %ebx
-	jz	2f	/* Nothing to be done if loaded at compiled addr. */
-/*
- * Process relocations.
- */
-
-1:	subl	$4, %edi
-	movl	(%edi), %ecx
-	testl	%ecx, %ecx
-	jz	2f
-	addl	%ebx, -__PAGE_OFFSET(%ebx, %ecx)
-	jmp	1b
-2:
-#endif
+	addl	$24, %esp
 
 /*
  * Jump to the decompressed kernel.
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index c1d383d..81ca174 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -340,6 +340,7 @@ relocated:
 	leaq	input_data(%rip), %rdx  /* input_data */
 	movl	$z_input_len, %ecx	/* input_len */
 	movq	%rbp, %r8		/* output target address */
+	movq	$z_output_len, %r9	/* decompressed length */
 	call	decompress_kernel
 	popq	%rsi
 
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 7cb56c6..b756a04 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -267,6 +267,79 @@ static void error(char *x)
 		asm("hlt");
 }
 
+#if CONFIG_X86_NEED_RELOCS
+static void handle_relocations(void *output, unsigned long output_len)
+{
+	int *reloc;
+	unsigned long delta, map, ptr;
+	unsigned long min_addr = (unsigned long)output;
+	unsigned long max_addr = min_addr + output_len;
+
+	/*
+	 * Calculate the delta between where vmlinux was linked to load
+	 * and where it was actually loaded.
+	 */
+	delta = min_addr - LOAD_PHYSICAL_ADDR;
+	if (!delta) {
+		debug_putstr("No relocation needed... ");
+		return;
+	}
+	debug_putstr("Performing relocations... ");
+
+	/*
+	 * The kernel contains a table of relocation addresses. Those
+	 * addresses have the final load address of the kernel in virtual
+	 * memory. We are currently working in the self map. So we need to
+	 * create an adjustment for kernel memory addresses to the self map.
+	 * This will involve subtracting out the base address of the kernel.
+	 */
+	map = delta - __START_KERNEL_map;
+
+	/*
+	 * Process relocations: 32 bit relocations first then 64 bit after.
+	 * Two sets of binary relocations are added to the end of the kernel
+	 * before compression. Each relocation table entry is the kernel
+	 * address of the location which needs to be updated stored as a
+	 * 32-bit value which is sign extended to 64 bits.
+	 *
+	 * Format is:
+	 *
+	 * kernel bits...
+	 * 0 - zero terminator for 64 bit relocations
+	 * 64 bit relocation repeated
+	 * 0 - zero terminator for 32 bit relocations
+	 * 32 bit relocation repeated
+	 *
+	 * So we work backwards from the end of the decompressed image.
+	 */
+	for (reloc = output + output_len - sizeof(*reloc); *reloc; reloc--) {
+		int extended = *reloc;
+		extended += map;
+
+		ptr = (unsigned long)extended;
+		if (ptr < min_addr || ptr > max_addr)
+			error("32-bit relocation outside of kernel!\n");
+
+		*(uint32_t *)ptr += delta;
+	}
+#ifdef CONFIG_X86_64
+	for (reloc--; *reloc; reloc--) {
+		long extended = *reloc;
+		extended += map;
+
+		ptr = (unsigned long)extended;
+		if (ptr < min_addr || ptr > max_addr)
+			error("64-bit relocation outside of kernel!\n");
+
+		*(uint64_t *)ptr += delta;
+	}
+#endif
+}
+#else
+static inline void handle_relocations(void *output, unsigned long output_len)
+{ }
+#endif
+
 static void parse_elf(void *output)
 {
 #ifdef CONFIG_X86_64
@@ -321,7 +394,8 @@ static void parse_elf(void *output)
 asmlinkage void decompress_kernel(void *rmode, memptr heap,
 				  unsigned char *input_data,
 				  unsigned long input_len,
-				  unsigned char *output)
+				  unsigned char *output,
+				  unsigned long output_len)
 {
 	real_mode = rmode;
 
@@ -361,6 +435,7 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
 	debug_putstr("\nDecompressing Linux... ");
 	decompress(input_data, input_len, NULL, NULL, output, NULL, error);
 	parse_elf(output);
+	handle_relocations(output, output_len);
 	debug_putstr("done.\nBooting the kernel.\n");
 	return;
 }
diff --git a/arch/x86/include/asm/page_32_types.h b/arch/x86/include/asm/page_32_types.h
index ef17af0..f48b17d 100644
--- a/arch/x86/include/asm/page_32_types.h
+++ b/arch/x86/include/asm/page_32_types.h
@@ -15,6 +15,8 @@
  */
 #define __PAGE_OFFSET		_AC(CONFIG_PAGE_OFFSET, UL)
 
+#define __START_KERNEL_map	__PAGE_OFFSET
+
 #define THREAD_SIZE_ORDER	1
 #define THREAD_SIZE		(PAGE_SIZE << THREAD_SIZE_ORDER)
 
diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
index 8b491e6..203e98a 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -32,11 +32,6 @@
  */
 #define __PAGE_OFFSET           _AC(0xffff880000000000, UL)
 
-#define __PHYSICAL_START	((CONFIG_PHYSICAL_START +	 	\
-				  (CONFIG_PHYSICAL_ALIGN - 1)) &	\
-				 ~(CONFIG_PHYSICAL_ALIGN - 1))
-
-#define __START_KERNEL		(__START_KERNEL_map + __PHYSICAL_START)
 #define __START_KERNEL_map	_AC(0xffffffff80000000, UL)
 
 /* See Documentation/x86/x86_64/mm.txt for a description of the memory map. */
diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
index 54c9787..086c2fa 100644
--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -33,6 +33,12 @@
 	(((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0 ) | \
 	 VM_READ | VM_WRITE | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 
+#define __PHYSICAL_START	((CONFIG_PHYSICAL_START +		\
+				  (CONFIG_PHYSICAL_ALIGN - 1)) &	\
+				 ~(CONFIG_PHYSICAL_ALIGN - 1))
+
+#define __START_KERNEL		(__START_KERNEL_map + __PHYSICAL_START)
+
 #ifdef CONFIG_X86_64
 #include <asm/page_64_types.h>
 #else
-- 
1.7.9.5
