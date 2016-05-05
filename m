Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Thu,  5 May 2016 15:13:46 -0700
Message-Id: <1462486436-3707-2-git-send-email-keescook@chromium.org>
In-Reply-To: <1462486436-3707-1-git-send-email-keescook@chromium.org>
References: <1462486436-3707-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v6 01/11] x86/boot: Clean up pointer casting
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@redhat.com>, Baoquan He <bhe@redhat.com>, Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Currently extract_kernel() defines the input and output buffer pointers
as "unsigned char *" since that's effectively what they are. It passes
these to the decompressor routine and to the ELF parser, which both
logically deal with buffer pointers too. There is some casting ("unsigned
long") done to validate the numerical value of the pointers, but it is
relatively limited.

However, choose_random_location() operates almost exclusively on the
numerical representation of these pointers, so it ended up carrying
a lot of "unsigned long" casts. With the future physical/virtual split
these casts were going to multiply, so this attempts to solve the
problem by doing all the casting in choose_random_location()'s entry
and return instead of through-out the code. Adjusts argument names to
be more meaningful, and changes one us of "choice" to "output" to make
the future physical/virtual split more clear (i.e. "choice" should be
strictly a function return value and not used as an intermediate).

Suggested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/boot/compressed/kaslr.c | 20 ++++++++++++++------
 arch/x86/boot/compressed/misc.h  | 10 +++++-----
 2 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/kaslr.c
index f1818d95d726..2072d82c1911 100644
--- a/arch/x86/boot/compressed/kaslr.c
+++ b/arch/x86/boot/compressed/kaslr.c
@@ -305,12 +305,21 @@ static unsigned long find_random_addr(unsigned long minimum,
 	return slots_fetch_random();
 }
 
-unsigned char *choose_random_location(unsigned char *input,
+unsigned char *choose_random_location(unsigned char *input_ptr,
 				      unsigned long input_size,
-				      unsigned char *output,
+				      unsigned char *output_ptr,
 				      unsigned long output_size)
 {
-	unsigned long choice = (unsigned long)output;
+	/*
+	 * The caller of choose_random_location() uses unsigned char * for
+	 * buffer pointers since it performs decompression, elf parsing, etc.
+	 * Since this code examines addresses much more numerically,
+	 * unsigned long is used internally here. Instead of sprinkling
+	 * more casts into extract_kernel, do them here and at return.
+	 */
+	unsigned long input = (unsigned long)input_ptr;
+	unsigned long output = (unsigned long)output_ptr;
+	unsigned long choice = output;
 	unsigned long random_addr;
 
 #ifdef CONFIG_HIBERNATION
@@ -328,11 +337,10 @@ unsigned char *choose_random_location(unsigned char *input,
 	boot_params->hdr.loadflags |= KASLR_FLAG;
 
 	/* Record the various known unsafe memory ranges. */
-	mem_avoid_init((unsigned long)input, input_size,
-		       (unsigned long)output, output_size);
+	mem_avoid_init(input, input_size, output, output_size);
 
 	/* Walk e820 and find a random address. */
-	random_addr = find_random_addr(choice, output_size);
+	random_addr = find_random_addr(output, output_size);
 	if (!random_addr) {
 		warn("KASLR disabled: could not find suitable E820 region!");
 		goto out;
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 9887e0d4aaeb..1f23d022d241 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -67,20 +67,20 @@ int cmdline_find_option_bool(const char *option);
 
 #if CONFIG_RANDOMIZE_BASE
 /* kaslr.c */
-unsigned char *choose_random_location(unsigned char *input,
+unsigned char *choose_random_location(unsigned char *input_ptr,
 				      unsigned long input_size,
-				      unsigned char *output,
+				      unsigned char *output_ptr,
 				      unsigned long output_size);
 /* cpuflags.c */
 bool has_cpuflag(int flag);
 #else
 static inline
-unsigned char *choose_random_location(unsigned char *input,
+unsigned char *choose_random_location(unsigned char *input_ptr,
 				      unsigned long input_size,
-				      unsigned char *output,
+				      unsigned char *output_ptr,
 				      unsigned long output_size)
 {
-	return output;
+	return output_ptr;
 }
 #endif
 
-- 
2.6.3
