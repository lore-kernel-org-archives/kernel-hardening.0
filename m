Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Mon,  9 May 2016 13:22:10 -0700
Message-Id: <1462825332-10505-8-git-send-email-keescook@chromium.org>
In-Reply-To: <1462825332-10505-1-git-send-email-keescook@chromium.org>
References: <1462825332-10505-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v7 7/9] x86/KASLR: Randomize virtual address separately
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Baoquan He <bhe@redhat.com>, Borislav Petkov <bp@suse.de>, Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

From: Baoquan He <bhe@redhat.com>

The current KASLR implementation randomizes the physical and virtual
addresses of the kernel together (both are offset by the same amount). It
calculates the delta of the physical address where vmlinux was linked
to load and where it is finally loaded. If the delta is not equal to 0
(i.e. the kernel was relocated), relocation handling needs be done.

On 64-bit, this patch randomizes both the physical address where kernel
is decompressed and the virtual address where kernel text is mapped and
will execute from. We now have two values being chosen, so the function
arguments are reorganized to pass by pointer so they can be directly
updated. Since relocation handling only depends on the virtual address,
we must check the virtual delta, not the physical delta for processing
kernel relocations. This also populates the page table for the new
virtual address range. 32-bit does not support a separate virtual address,
so it continues to use the physical offset for its virtual offset.

Additionally updates the sanity checks done on the resulting kernel
addresses since they are potentially separate now.

Signed-off-by: Baoquan He <bhe@redhat.com>
[kees: rewrote changelog, limited virtual split to 64-bit only, update checks]
[kees: fix CONFIG_RANDOMIZE_BASE=n boot failure]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/boot/compressed/kaslr.c | 44 ++++++++++++++++++++----------------
 arch/x86/boot/compressed/misc.c  | 49 ++++++++++++++++++++++++----------------
 arch/x86/boot/compressed/misc.h  | 22 ++++++++++--------
 3 files changed, 66 insertions(+), 49 deletions(-)

diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/kaslr.c
index c4b1e4b05cb6..1d1338f04bbd 100644
--- a/arch/x86/boot/compressed/kaslr.c
+++ b/arch/x86/boot/compressed/kaslr.c
@@ -463,46 +463,50 @@ static unsigned long find_random_virt_addr(unsigned long minimum,
  * Since this function examines addresses much more numerically,
  * it takes the input and output pointers as 'unsigned long'.
  */
-unsigned char *choose_random_location(unsigned long input,
-				      unsigned long input_size,
-				      unsigned long output,
-				      unsigned long output_size)
+void choose_random_location(unsigned long input,
+			    unsigned long input_size,
+			    unsigned long *output,
+			    unsigned long output_size,
+			    unsigned long *virt_addr)
 {
-	unsigned long choice = output;
 	unsigned long random_addr;
 
+	/* By default, keep output position unchanged. */
+	*virt_addr = *output;
+
 #ifdef CONFIG_HIBERNATION
 	if (!cmdline_find_option_bool("kaslr")) {
 		warn("KASLR disabled: 'kaslr' not on cmdline (hibernation selected).");
-		goto out;
+		return;
 	}
 #else
 	if (cmdline_find_option_bool("nokaslr")) {
 		warn("KASLR disabled: 'nokaslr' on cmdline.");
-		goto out;
+		return;
 	}
 #endif
 
 	boot_params->hdr.loadflags |= KASLR_FLAG;
 
 	/* Record the various known unsafe memory ranges. */
-	mem_avoid_init(input, input_size, output);
+	mem_avoid_init(input, input_size, *output);
 
 	/* Walk e820 and find a random address. */
-	random_addr = find_random_phys_addr(output, output_size);
+	random_addr = find_random_phys_addr(*output, output_size);
 	if (!random_addr) {
 		warn("KASLR disabled: could not find suitable E820 region!");
-		goto out;
+	} else {
+		/* Update the new physical address location. */
+		if (*output != random_addr) {
+			add_identity_map(random_addr, output_size);
+			finalize_identity_maps();
+			*output = random_addr;
+		}
 	}
 
-	/* Always enforce the minimum. */
-	if (random_addr < choice)
-		goto out;
-
-	choice = random_addr;
-
-	add_identity_map(choice, output_size);
-	finalize_identity_maps();
-out:
-	return (unsigned char *)choice;
+	/* Pick random virtual address starting from LOAD_PHYSICAL_ADDR. */
+	if (IS_ENABLED(CONFIG_X86_64))
+		random_addr = find_random_virt_addr(LOAD_PHYSICAL_ADDR,
+						 output_size);
+	*virt_addr = random_addr;
 }
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index f14db4e21654..b3c5a5f030ce 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -170,7 +170,8 @@ void __puthex(unsigned long value)
 }
 
 #if CONFIG_X86_NEED_RELOCS
-static void handle_relocations(void *output, unsigned long output_len)
+static void handle_relocations(void *output, unsigned long output_len,
+			       unsigned long virt_addr)
 {
 	int *reloc;
 	unsigned long delta, map, ptr;
@@ -182,11 +183,6 @@ static void handle_relocations(void *output, unsigned long output_len)
 	 * and where it was actually loaded.
 	 */
 	delta = min_addr - LOAD_PHYSICAL_ADDR;
-	if (!delta) {
-		debug_putstr("No relocation needed... ");
-		return;
-	}
-	debug_putstr("Performing relocations... ");
 
 	/*
 	 * The kernel contains a table of relocation addresses. Those
@@ -198,6 +194,20 @@ static void handle_relocations(void *output, unsigned long output_len)
 	map = delta - __START_KERNEL_map;
 
 	/*
+	 * 32-bit always performs relocations. 64-bit relocations are only
+	 * needed if KASLR has chosen a different starting address offset
+	 * from __START_KERNEL_map.
+	 */
+	if (IS_ENABLED(CONFIG_X86_64))
+		delta = virt_addr - LOAD_PHYSICAL_ADDR;
+
+	if (!delta) {
+		debug_putstr("No relocation needed... ");
+		return;
+	}
+	debug_putstr("Performing relocations... ");
+
+	/*
 	 * Process relocations: 32 bit relocations first then 64 bit after.
 	 * Three sets of binary relocations are added to the end of the kernel
 	 * before compression. Each relocation table entry is the kernel
@@ -250,7 +260,8 @@ static void handle_relocations(void *output, unsigned long output_len)
 #endif
 }
 #else
-static inline void handle_relocations(void *output, unsigned long output_len)
+static inline void handle_relocations(void *output, unsigned long output_len,
+				      unsigned long virt_addr)
 { }
 #endif
 
@@ -327,7 +338,7 @@ asmlinkage __visible void *extract_kernel(void *rmode, memptr heap,
 				  unsigned long output_len)
 {
 	const unsigned long kernel_total_size = VO__end - VO__text;
-	unsigned char *output_orig = output;
+	unsigned long virt_addr = (unsigned long)output;
 
 	/* Retain x86 boot parameters pointer passed from startup_32/64. */
 	boot_params = rmode;
@@ -366,13 +377,16 @@ asmlinkage __visible void *extract_kernel(void *rmode, memptr heap,
 	 * the entire decompressed kernel plus relocation table, or the
 	 * entire decompressed kernel plus .bss and .brk sections.
 	 */
-	output = choose_random_location((unsigned long)input_data, input_len,
-					(unsigned long)output,
-					max(output_len, kernel_total_size));
+	choose_random_location((unsigned long)input_data, input_len,
+				(unsigned long *)&output,
+				max(output_len, kernel_total_size),
+				&virt_addr);
 
 	/* Validate memory location choices. */
 	if ((unsigned long)output & (MIN_KERNEL_ALIGN - 1))
-		error("Destination address inappropriately aligned");
+		error("Destination physical address inappropriately aligned");
+	if (virt_addr & (MIN_KERNEL_ALIGN - 1))
+		error("Destination virtual address inappropriately aligned");
 #ifdef CONFIG_X86_64
 	if (heap > 0x3fffffffffffUL)
 		error("Destination address too large");
@@ -382,19 +396,16 @@ asmlinkage __visible void *extract_kernel(void *rmode, memptr heap,
 #endif
 #ifndef CONFIG_RELOCATABLE
 	if ((unsigned long)output != LOAD_PHYSICAL_ADDR)
-		error("Wrong destination address");
+		error("Destination address does not match LOAD_PHYSICAL_ADDR");
+	if ((unsigned long)output != virt_addr)
+		error("Destination virtual address changed when not relocatable");
 #endif
 
 	debug_putstr("\nDecompressing Linux... ");
 	__decompress(input_data, input_len, NULL, NULL, output, output_len,
 			NULL, error);
 	parse_elf(output);
-	/*
-	 * 32-bit always performs relocations. 64-bit relocations are only
-	 * needed if kASLR has chosen a different load address.
-	 */
-	if (!IS_ENABLED(CONFIG_X86_64) || output != output_orig)
-		handle_relocations(output, output_len);
+	handle_relocations(output, output_len, virt_addr);
 	debug_putstr("done.\nBooting the kernel.\n");
 	return output;
 }
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index b6fec1ff10e4..a6a5f3463c17 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -67,20 +67,22 @@ int cmdline_find_option_bool(const char *option);
 
 #if CONFIG_RANDOMIZE_BASE
 /* kaslr.c */
-unsigned char *choose_random_location(unsigned long input_ptr,
-				      unsigned long input_size,
-				      unsigned long output_ptr,
-				      unsigned long output_size);
+void choose_random_location(unsigned long input,
+			    unsigned long input_size,
+			    unsigned long *output,
+			    unsigned long output_size,
+			    unsigned long *virt_addr);
 /* cpuflags.c */
 bool has_cpuflag(int flag);
 #else
-static inline
-unsigned char *choose_random_location(unsigned long input_ptr,
-				      unsigned long input_size,
-				      unsigned long output_ptr,
-				      unsigned long output_size)
+static inline void choose_random_location(unsigned long input,
+					  unsigned long input_size,
+					  unsigned long *output,
+					  unsigned long output_size,
+					  unsigned long *virt_addr)
 {
-	return (unsigned char *)output_ptr;
+	/* No change from existing output location. */
+	*virt_addr = *output;
 }
 #endif
 
-- 
2.6.3
