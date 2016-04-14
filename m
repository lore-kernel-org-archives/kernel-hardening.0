Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Thu, 14 Apr 2016 15:28:54 -0700
Message-Id: <1460672954-32567-2-git-send-email-keescook@chromium.org>
In-Reply-To: <1460672954-32567-1-git-send-email-keescook@chromium.org>
References: <1460672954-32567-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v5 01/21] x86, KASLR: Remove unneeded boot_params argument
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Yinghai Lu <yinghai@kernel.org>, Baoquan He <bhe@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

From: Yinghai Lu <yinghai@kernel.org>

Since the boot_params can be found using the real_mode global variable,
there is no need to pass around a pointer to it. This slightly simplifies
the choose_kernel_location function and its callers.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
[kees: rewrote changelog]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/boot/compressed/aslr.c | 5 ++---
 arch/x86/boot/compressed/misc.c | 2 +-
 arch/x86/boot/compressed/misc.h | 6 ++----
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index 6a9b96b4624d..622aa881c6ab 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -295,8 +295,7 @@ static unsigned long find_random_addr(unsigned long minimum,
 	return slots_fetch_random();
 }
 
-unsigned char *choose_kernel_location(struct boot_params *boot_params,
-				      unsigned char *input,
+unsigned char *choose_kernel_location(unsigned char *input,
 				      unsigned long input_size,
 				      unsigned char *output,
 				      unsigned long output_size)
@@ -316,7 +315,7 @@ unsigned char *choose_kernel_location(struct boot_params *boot_params,
 	}
 #endif
 
-	boot_params->hdr.loadflags |= KASLR_FLAG;
+	real_mode->hdr.loadflags |= KASLR_FLAG;
 
 	/* Record the various known unsafe memory ranges. */
 	mem_avoid_init((unsigned long)input, input_size,
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 79dac1758e7c..f35ad9eb1bf1 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -428,7 +428,7 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
 	 * the entire decompressed kernel plus relocation table, or the
 	 * entire decompressed kernel plus .bss and .brk sections.
 	 */
-	output = choose_kernel_location(real_mode, input_data, input_len, output,
+	output = choose_kernel_location(input_data, input_len, output,
 					output_len > run_size ? output_len
 							      : run_size);
 
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 3783dc3e10b3..dcf01c22400e 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -67,8 +67,7 @@ int cmdline_find_option_bool(const char *option);
 
 #if CONFIG_RANDOMIZE_BASE
 /* aslr.c */
-unsigned char *choose_kernel_location(struct boot_params *boot_params,
-				      unsigned char *input,
+unsigned char *choose_kernel_location(unsigned char *input,
 				      unsigned long input_size,
 				      unsigned char *output,
 				      unsigned long output_size);
@@ -76,8 +75,7 @@ unsigned char *choose_kernel_location(struct boot_params *boot_params,
 bool has_cpuflag(int flag);
 #else
 static inline
-unsigned char *choose_kernel_location(struct boot_params *boot_params,
-				      unsigned char *input,
+unsigned char *choose_kernel_location(unsigned char *input,
 				      unsigned long input_size,
 				      unsigned char *output,
 				      unsigned long output_size)
-- 
2.6.3
