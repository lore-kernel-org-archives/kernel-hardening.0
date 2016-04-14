Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Thu, 14 Apr 2016 15:29:11 -0700
Message-Id: <1460672954-32567-19-git-send-email-keescook@chromium.org>
In-Reply-To: <1460672954-32567-1-git-send-email-keescook@chromium.org>
References: <1460672954-32567-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v5 18/21] x86, KASLR: Randomize virtual address separately
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Baoquan He <bhe@redhat.com>, Yinghai Lu <yinghai@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

From: Baoquan He <bhe@redhat.com>

The current KASLR implementation randomizes the physical and virtual
address of kernel together (both are offset by the same amount). It
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
virtual address range. 32-bit does not support a separate virtual
address, so it continues to use the physical offset for its virtual
offset.

Signed-off-by: Baoquan He <bhe@redhat.com>
[kees: rewrote changelog, limited virtual split to 64-bit only]
[kees: fix CONFIG_RANDOMIZE_BASE=n boot failure]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/boot/compressed/aslr.c | 45 +++++++++++++++++++++--------------------
 arch/x86/boot/compressed/misc.c | 39 ++++++++++++++++++++---------------
 arch/x86/boot/compressed/misc.h | 20 +++++++++---------
 3 files changed, 57 insertions(+), 47 deletions(-)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index c58215d5a80d..53ceaa0a08b9 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -391,7 +391,7 @@ static void process_e820_entry(struct e820entry *entry,
 	}
 }
 
-static unsigned long find_random_addr(unsigned long minimum,
+static unsigned long find_random_phy_addr(unsigned long minimum,
 				      unsigned long size)
 {
 	int i;
@@ -431,23 +431,24 @@ static unsigned long find_random_virt_offset(unsigned long minimum,
 	return random * CONFIG_PHYSICAL_ALIGN + minimum;
 }
 
-unsigned char *choose_kernel_location(unsigned char *input,
-				      unsigned long input_size,
-				      unsigned char *output,
-				      unsigned long output_size)
+void choose_kernel_location(unsigned char *input,
+				unsigned long input_size,
+				unsigned char **output,
+				unsigned long output_size,
+				unsigned char **virt_offset)
 {
-	unsigned long choice = (unsigned long)output;
 	unsigned long random;
+	*virt_offset = (unsigned char *)LOAD_PHYSICAL_ADDR;
 
 #ifdef CONFIG_HIBERNATION
 	if (!cmdline_find_option_bool("kaslr")) {
 		debug_putstr("KASLR disabled by default...\n");
-		goto out;
+		return;
 	}
 #else
 	if (cmdline_find_option_bool("nokaslr")) {
 		debug_putstr("KASLR disabled by cmdline...\n");
-		goto out;
+		return;
 	}
 #endif
 
@@ -455,23 +456,23 @@ unsigned char *choose_kernel_location(unsigned char *input,
 
 	/* Record the various known unsafe memory ranges. */
 	mem_avoid_init((unsigned long)input, input_size,
-		       (unsigned long)output);
+		       (unsigned long)*output);
 
 	/* Walk e820 and find a random address. */
-	random = find_random_addr(choice, output_size);
-	if (!random) {
+	random = find_random_phy_addr((unsigned long)*output, output_size);
+	if (!random)
 		debug_putstr("KASLR could not find suitable E820 region...\n");
-		goto out;
+	else {
+		if ((unsigned long)*output != random) {
+			fill_pagetable(random, output_size);
+			switch_pagetable();
+			*output = (unsigned char *)random;
+		}
 	}
 
-	/* Always enforce the minimum. */
-	if (random < choice)
-		goto out;
-
-	choice = random;
-
-	fill_pagetable(choice, output_size);
-	switch_pagetable();
-out:
-	return (unsigned char *)choice;
+	/* Pick random virtual address starting from LOAD_PHYSICAL_ADDR. */
+	if (IS_ENABLED(CONFIG_X86_64))
+		random = find_random_virt_offset(LOAD_PHYSICAL_ADDR,
+						 output_size);
+	*virt_offset = (unsigned char *)random;
 }
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index c47ac162d3bd..3d5b0eda0711 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -251,7 +251,8 @@ void error(char *x)
 }
 
 #if CONFIG_X86_NEED_RELOCS
-static void handle_relocations(void *output, unsigned long output_len)
+static void handle_relocations(void *output, unsigned long output_len,
+			       void *virt_offset)
 {
 	int *reloc;
 	unsigned long delta, map, ptr;
@@ -263,11 +264,6 @@ static void handle_relocations(void *output, unsigned long output_len)
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
@@ -279,6 +275,20 @@ static void handle_relocations(void *output, unsigned long output_len)
 	map = delta - __START_KERNEL_map;
 
 	/*
+	 * 32-bit always performs relocations. 64-bit relocations are only
+	 * needed if KASLR has chosen a different starting address offset
+	 * from __START_KERNEL_map.
+	 */
+	if (IS_ENABLED(CONFIG_X86_64))
+		delta = (unsigned long)virt_offset - LOAD_PHYSICAL_ADDR;
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
@@ -331,7 +341,8 @@ static void handle_relocations(void *output, unsigned long output_len)
 #endif
 }
 #else
-static inline void handle_relocations(void *output, unsigned long output_len)
+static inline void handle_relocations(void *output, unsigned long output_len,
+				      void *virt_offset)
 { }
 #endif
 
@@ -391,7 +402,7 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
 				  unsigned long output_len)
 {
 	const unsigned long run_size = VO__end - VO__text;
-	unsigned char *output_orig = output;
+	unsigned char *virt_offset;
 
 	real_mode = rmode;
 
@@ -429,9 +440,10 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
 	 * the entire decompressed kernel plus relocation table, or the
 	 * entire decompressed kernel plus .bss and .brk sections.
 	 */
-	output = choose_kernel_location(input_data, input_len, output,
+	choose_kernel_location(input_data, input_len, &output,
 					output_len > run_size ? output_len
-							      : run_size);
+							      : run_size,
+					&virt_offset);
 
 	/* Validate memory location choices. */
 	if ((unsigned long)output & (MIN_KERNEL_ALIGN - 1))
@@ -452,12 +464,7 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
 	__decompress(input_data, input_len, NULL, NULL, output, output_len,
 			NULL, error);
 	parse_elf(output);
-	/*
-	 * 32-bit always performs relocations. 64-bit relocations are only
-	 * needed if kASLR has chosen a different load address.
-	 */
-	if (!IS_ENABLED(CONFIG_X86_64) || output != output_orig)
-		handle_relocations(output, output_len);
+	handle_relocations(output, output_len, virt_offset);
 	debug_putstr("done.\nBooting the kernel.\n");
 	return output;
 }
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 39d0e9a53736..0b455406a850 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -69,20 +69,22 @@ int cmdline_find_option_bool(const char *option);
 
 #if CONFIG_RANDOMIZE_BASE
 /* aslr.c */
-unsigned char *choose_kernel_location(unsigned char *input,
-				      unsigned long input_size,
-				      unsigned char *output,
-				      unsigned long output_size);
+void choose_kernel_location(unsigned char *input,
+				unsigned long input_size,
+				unsigned char **output,
+				unsigned long output_size,
+				unsigned char **virt_offset);
 /* cpuflags.c */
 bool has_cpuflag(int flag);
 #else
 static inline
-unsigned char *choose_kernel_location(unsigned char *input,
-				      unsigned long input_size,
-				      unsigned char *output,
-				      unsigned long output_size)
+void choose_kernel_location(unsigned char *input,
+				unsigned long input_size,
+				unsigned char **output,
+				unsigned long output_size,
+				unsigned char **virt_offset)
 {
-	return output;
+	*virt_offset = *output;
 }
 #endif
 
-- 
2.6.3
