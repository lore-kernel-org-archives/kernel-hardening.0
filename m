Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Thu, 14 Apr 2016 15:29:01 -0700
Message-Id: <1460672954-32567-9-git-send-email-keescook@chromium.org>
In-Reply-To: <1460672954-32567-1-git-send-email-keescook@chromium.org>
References: <1460672954-32567-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v5 08/21] x86, KASLR: Clean up unused code from old run_size
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Josh Triplett <josh@joshtriplett.org>, Andrew Morton <akpm@linux-foundation.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Junjie Mao <eternal.n08@gmail.com>, Baoquan He <bhe@redhat.com>, Matt Redfearn <matt.redfearn@imgtec.com>, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

From: Yinghai Lu <yinghai@kernel.org>

Since run_size is now calculated in misc.c, the old script and associated
argument passing is no longer needed. This patch removes them.

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Junjie Mao <eternal.n08@gmail.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Baoquan He <bhe@redhat.com>
[kees: rewrote changelog]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/boot/compressed/Makefile  |  4 +---
 arch/x86/boot/compressed/head_32.S |  3 +--
 arch/x86/boot/compressed/head_64.S |  3 ---
 arch/x86/boot/compressed/misc.c    |  6 ++----
 arch/x86/boot/compressed/mkpiggy.c | 10 ++-------
 arch/x86/tools/calc_run_size.sh    | 42 --------------------------------------
 6 files changed, 6 insertions(+), 62 deletions(-)
 delete mode 100644 arch/x86/tools/calc_run_size.sh

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 323674a9d6db..81a8d0fd34eb 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -109,10 +109,8 @@ suffix-$(CONFIG_KERNEL_XZ)	:= xz
 suffix-$(CONFIG_KERNEL_LZO) 	:= lzo
 suffix-$(CONFIG_KERNEL_LZ4) 	:= lz4
 
-RUN_SIZE = $(shell $(OBJDUMP) -h vmlinux | \
-	     $(CONFIG_SHELL) $(srctree)/arch/x86/tools/calc_run_size.sh)
 quiet_cmd_mkpiggy = MKPIGGY $@
-      cmd_mkpiggy = $(obj)/mkpiggy $< $(RUN_SIZE) > $@ || ( rm -f $@ ; false )
+      cmd_mkpiggy = $(obj)/mkpiggy $< > $@ || ( rm -f $@ ; false )
 
 targets += piggy.S
 $(obj)/piggy.S: $(obj)/vmlinux.bin.$(suffix-y) $(obj)/mkpiggy FORCE
diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index 0c140f99c602..122b32faf3ef 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -210,7 +210,6 @@ relocated:
  * Do the decompression, and jump to the new kernel..
  */
 				/* push arguments for decompress_kernel: */
-	pushl	$z_run_size	/* size of kernel with .bss and .brk */
 	pushl	$z_output_len	/* decompressed length, end of relocs */
 
 	movl    BP_init_size(%esi), %eax
@@ -226,7 +225,7 @@ relocated:
 	pushl	%eax		/* heap area */
 	pushl	%esi		/* real mode pointer */
 	call	decompress_kernel /* returns kernel location in %eax */
-	addl	$28, %esp
+	addl	$24, %esp
 
 /*
  * Jump to the decompressed kernel.
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 67dd8d300c61..36914515dd76 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -407,8 +407,6 @@ relocated:
  * Do the decompression, and jump to the new kernel..
  */
 	pushq	%rsi			/* Save the real mode argument */
-	movq	$z_run_size, %r9	/* size of kernel with .bss and .brk */
-	pushq	%r9
 	movq	%rsi, %rdi		/* real mode address */
 	leaq	boot_heap(%rip), %rsi	/* malloc area for uncompression */
 	leaq	input_data(%rip), %rdx  /* input_data */
@@ -416,7 +414,6 @@ relocated:
 	movq	%rbp, %r8		/* output target address */
 	movq	$z_output_len, %r9	/* decompressed length, end of relocs */
 	call	decompress_kernel	/* returns kernel location in %rax */
-	popq	%r9
 	popq	%rsi
 
 /*
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 4d878a7b9fab..6adb5b827aca 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -393,9 +393,9 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
 				  unsigned char *input_data,
 				  unsigned long input_len,
 				  unsigned char *output,
-				  unsigned long output_len,
-				  unsigned long run_size)
+				  unsigned long output_len)
 {
+	const unsigned long run_size = VO__end - VO__text;
 	unsigned char *output_orig = output;
 
 	real_mode = rmode;
@@ -416,8 +416,6 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
 	lines = real_mode->screen_info.orig_video_lines;
 	cols = real_mode->screen_info.orig_video_cols;
 
-	run_size = VO__end - VO__text;
-
 	console_init();
 	debug_putstr("early console in decompress_kernel\n");
 
diff --git a/arch/x86/boot/compressed/mkpiggy.c b/arch/x86/boot/compressed/mkpiggy.c
index a613c84d9b88..c51486429bdc 100644
--- a/arch/x86/boot/compressed/mkpiggy.c
+++ b/arch/x86/boot/compressed/mkpiggy.c
@@ -34,13 +34,11 @@ int main(int argc, char *argv[])
 {
 	uint32_t olen;
 	long ilen;
-	unsigned long run_size;
 	FILE *f = NULL;
 	int retval = 1;
 
-	if (argc < 3) {
-		fprintf(stderr, "Usage: %s compressed_file run_size\n",
-				argv[0]);
+	if (argc < 2) {
+		fprintf(stderr, "Usage: %s compressed_file\n", argv[0]);
 		goto bail;
 	}
 
@@ -65,15 +63,11 @@ int main(int argc, char *argv[])
 	ilen = ftell(f);
 	olen = get_unaligned_le32(&olen);
 
-	run_size = atoi(argv[2]);
-
 	printf(".section \".rodata..compressed\",\"a\",@progbits\n");
 	printf(".globl z_input_len\n");
 	printf("z_input_len = %lu\n", ilen);
 	printf(".globl z_output_len\n");
 	printf("z_output_len = %lu\n", (unsigned long)olen);
-	printf(".globl z_run_size\n");
-	printf("z_run_size = %lu\n", run_size);
 
 	printf(".globl input_data, input_data_end\n");
 	printf("input_data:\n");
diff --git a/arch/x86/tools/calc_run_size.sh b/arch/x86/tools/calc_run_size.sh
deleted file mode 100644
index 1a4c17bb3910..000000000000
--- a/arch/x86/tools/calc_run_size.sh
+++ /dev/null
@@ -1,42 +0,0 @@
-#!/bin/sh
-#
-# Calculate the amount of space needed to run the kernel, including room for
-# the .bss and .brk sections.
-#
-# Usage:
-# objdump -h a.out | sh calc_run_size.sh
-
-NUM='\([0-9a-fA-F]*[ \t]*\)'
-OUT=$(sed -n 's/^[ \t0-9]*.b[sr][sk][ \t]*'"$NUM$NUM$NUM$NUM"'.*/\1\4/p')
-if [ -z "$OUT" ] ; then
-	echo "Never found .bss or .brk file offset" >&2
-	exit 1
-fi
-
-OUT=$(echo ${OUT# })
-sizeA=$(printf "%d" 0x${OUT%% *})
-OUT=${OUT#* }
-offsetA=$(printf "%d" 0x${OUT%% *})
-OUT=${OUT#* }
-sizeB=$(printf "%d" 0x${OUT%% *})
-OUT=${OUT#* }
-offsetB=$(printf "%d" 0x${OUT%% *})
-
-run_size=$(( $offsetA + $sizeA + $sizeB ))
-
-# BFD linker shows the same file offset in ELF.
-if [ "$offsetA" -ne "$offsetB" ] ; then
-	# Gold linker shows them as consecutive.
-	endB=$(( $offsetB + $sizeB ))
-	if [ "$endB" != "$run_size" ] ; then
-		printf "sizeA: 0x%x\n" $sizeA >&2
-		printf "offsetA: 0x%x\n" $offsetA >&2
-		printf "sizeB: 0x%x\n" $sizeB >&2
-		printf "offsetB: 0x%x\n" $offsetB >&2
-		echo ".bss and .brk are non-contiguous" >&2
-		exit 1
-	fi
-fi
-
-printf "%d\n" $run_size
-exit 0
-- 
2.6.3
