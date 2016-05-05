Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Thu,  5 May 2016 15:13:54 -0700
Message-Id: <1462486436-3707-10-git-send-email-keescook@chromium.org>
In-Reply-To: <1462486436-3707-1-git-send-email-keescook@chromium.org>
References: <1462486436-3707-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v6 09/11] x86/KASLR: Randomize virtual address separately
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Baoquan He <bhe@redhat.com>, Ingo Molnar <mingo@redhat.com>, Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
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
 arch/x86/boot/compressed/kaslr.c | 42 +++++++++++++++++++----------------
 arch/x86/boot/compressed/misc.c  | 47 +++++++++++++++++++++++++---------------
 arch/x86/boot/compressed/misc.h  | 22 ++++++++++---------
 3 files changed, 64 insertions(+), 47 deletions(-)

diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/kaslr.c
index 3672c7388e5a..58d0871be037 100644
--- a/arch/x86/boot/compressed/kaslr.c
+++ b/arch/x86/boot/compressed/kaslr.c
@@ -426,10 +426,11 @@ static unsigned long find_random_virt_addr(unsigned long minimum,
 	return random_addr * CONFIG_PHYSICAL_ALIGN + minimum;
 }
 
-unsigned char *choose_random_location(unsigned char *input_ptr,
-				      unsigned long input_size,
-				      unsigned char *output_ptr,
-				      unsigned long output_size)
+void choose_random_location(unsigned char *input_ptr,
+				unsigned long input_size,
+				unsigned char **output_ptr,
+				unsigned long output_size,
+				unsigned char **virt_addr)
 {
 	/*
 	 * The caller of choose_random_location() uses unsigned char * for
@@ -439,19 +440,21 @@ unsigned char *choose_random_location(unsigned char *input_ptr,
 	 * more casts into extract_kernel, do them here and at return.
 	 */
 	unsigned long input = (unsigned long)input_ptr;
-	unsigned long output = (unsigned long)output_ptr;
-	unsigned long choice = output;
+	unsigned long output = (unsigned long)*output_ptr;
 	unsigned long random_addr;
 
+	/* By default, keep output position unchanged. */
+	*virt_addr = *output_ptr;
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
 
@@ -464,17 +467,18 @@ unsigned char *choose_random_location(unsigned char *input_ptr,
 	random_addr = find_random_phys_addr(output, output_size);
 	if (!random_addr) {
 		warn("KASLR disabled: could not find suitable E820 region!");
-		goto out;
+	} else {
+		/* Update the new physical address location. */
+		if (output != random_addr) {
+			fill_pagetable(random_addr, output_size);
+			switch_pagetable();
+			*output_ptr = (unsigned char *)random_addr;
+		}
 	}
 
-	/* Always enforce the minimum. */
-	if (random_addr < choice)
-		goto out;
-
-	choice = random_addr;
-
-	fill_pagetable(choice, output_size);
-	switch_pagetable();
-out:
-	return (unsigned char *)choice;
+	/* Pick random virtual address starting from LOAD_PHYSICAL_ADDR. */
+	if (IS_ENABLED(CONFIG_X86_64))
+		random_addr = find_random_virt_addr(LOAD_PHYSICAL_ADDR,
+						 output_size);
+	*virt_addr = (unsigned char *)random_addr;
 }
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 9536d778149e..e2b2fbf08ed9 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -170,7 +170,8 @@ void __puthex(unsigned long value)
 }
 
 #if CONFIG_X86_NEED_RELOCS
-static void handle_relocations(void *output, unsigned long output_len)
+static void handle_relocations(void *output, unsigned long output_len,
+			       void *virt_addr)
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
+		delta = (unsigned long)virt_addr - LOAD_PHYSICAL_ADDR;
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
+				      void *virt_addr)
 { }
 #endif
 
@@ -327,7 +338,7 @@ asmlinkage __visible void *extract_kernel(void *rmode, memptr heap,
 				  unsigned long output_len)
 {
 	const unsigned long kernel_total_size = VO__end - VO__text;
-	unsigned char *output_orig = output;
+	unsigned char *virt_addr = output;
 
 	/* Retain x86 boot parameters pointer passed from startup_32/64. */
 	boot_params = rmode;
@@ -366,12 +377,15 @@ asmlinkage __visible void *extract_kernel(void *rmode, memptr heap,
 	 * the entire decompressed kernel plus relocation table, or the
 	 * entire decompressed kernel plus .bss and .brk sections.
 	 */
-	output = choose_random_location(input_data, input_len, output,
-					max(output_len, kernel_total_size));
+	choose_random_location(input_data, input_len, &output,
+				max(output_len, kernel_total_size),
+				&virt_addr);
 
 	/* Validate memory location choices. */
 	if ((unsigned long)output & (MIN_KERNEL_ALIGN - 1))
-		error("Destination address inappropriately aligned");
+		error("Destination physical address inappropriately aligned");
+	if ((unsigned long)virt_addr & (MIN_KERNEL_ALIGN - 1))
+		error("Destination virtual address inappropriately aligned");
 #ifdef CONFIG_X86_64
 	if (heap > 0x3fffffffffffUL)
 		error("Destination address too large");
@@ -381,19 +395,16 @@ asmlinkage __visible void *extract_kernel(void *rmode, memptr heap,
 #endif
 #ifndef CONFIG_RELOCATABLE
 	if ((unsigned long)output != LOAD_PHYSICAL_ADDR)
-		error("Wrong destination address");
+		error("Destination address does not match LOAD_PHYSICAL_ADDR");
+	if (output != virt_addr)
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
index ffacded0e66a..1a58fce66458 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -67,20 +67,22 @@ int cmdline_find_option_bool(const char *option);
 
 #if CONFIG_RANDOMIZE_BASE
 /* kaslr.c */
-unsigned char *choose_random_location(unsigned char *input_ptr,
-				      unsigned long input_size,
-				      unsigned char *output_ptr,
-				      unsigned long output_size);
+void choose_random_location(unsigned char *input_ptr,
+			    unsigned long input_size,
+			    unsigned char **output_ptr,
+			    unsigned long output_size,
+			    unsigned char **virt_addr);
 /* cpuflags.c */
 bool has_cpuflag(int flag);
 #else
-static inline
-unsigned char *choose_random_location(unsigned char *input_ptr,
-				      unsigned long input_size,
-				      unsigned char *output_ptr,
-				      unsigned long output_size)
+static inline void choose_random_location(unsigned char *input_ptr,
+					  unsigned long input_size,
+					  unsigned char **output_ptr,
+					  unsigned long output_size,
+					  unsigned char **virt_addr)
 {
-	return output_ptr;
+	/* No change from existing output location. */
+	*virt_addr = *output_ptr;
 }
 #endif
 
-- 
2.6.3
