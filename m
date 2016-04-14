Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Thu, 14 Apr 2016 15:28:57 -0700
Message-Id: <1460672954-32567-5-git-send-email-keescook@chromium.org>
In-Reply-To: <1460672954-32567-1-git-send-email-keescook@chromium.org>
References: <1460672954-32567-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v5 04/21] x86, boot: Move compressed kernel to end of decompression buffer
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Yinghai Lu <yinghai@kernel.org>, Baoquan He <bhe@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

From: Yinghai Lu <yinghai@kernel.org>

This change makes later calculations about where the kernel is located
easier to reason about. To better understand this change, we must first
clarify what VO and ZO are. They were introduced in commits by hpa:

77d1a49 x86, boot: make symbols from the main vmlinux available
37ba7ab x86, boot: make kernel_alignment adjustable; new bzImage fields

Specifically:

VO:
- uncompressed kernel image
- size: VO__end - VO__text ("VO_INIT_SIZE" define)

ZO:
- bootable compressed kernel image (boot/compressed/vmlinux)
- head text + compressed kernel (VO and relocs table) + decompressor code
- size: ZO__end - ZO_startup_32 ("ZO_INIT_SIZE" define, though see below)

The INIT_SIZE definition is used to find the larger of the two image sizes:

 #define ZO_INIT_SIZE    (ZO__end - ZO_startup_32 + ZO_z_extract_offset)
 #define VO_INIT_SIZE    (VO__end - VO__text)
 #if ZO_INIT_SIZE > VO_INIT_SIZE
 #define INIT_SIZE ZO_INIT_SIZE
 #else
 #define INIT_SIZE VO_INIT_SIZE
 #endif

The current code uses extract_offset to decide where to position the
copied ZO (i.e. ZO starts at extract_offset). (This is why ZO_INIT_SIZE
currently includes the extract_offset.)

When INIT_SIZE is bigger than VO_INIT_SIZE (uncommon but possible),
the copied ZO occupies the memory from extract_offset to the end of
decompression buffer. It overlaps with the soon-to-be-uncompressed kernel
like this:

                            |-----compressed kernel image------|
                            V                                  V
0                       extract_offset                      +INIT_SIZE
|-----------|---------------|-------------------------|--------|
            |               |                         |        |
          VO__text      startup_32 of ZO          VO__end    ZO__end
            ^                                         ^
            |-------uncompressed kernel image---------|

When INIT_SIZE is equal to VO_INIT_SIZE (likely) there's still space
left from end of ZO to the end of decompressing buffer, like below.

                            |-compressed kernel image-|
                            V                         V
0                       extract_offset                      +INIT_SIZE
|-----------|---------------|-------------------------|--------|
            |               |                         |        |
          VO__text      startup_32 of ZO          ZO__end    VO__end
            ^                                                  ^
            |------------uncompressed kernel image-------------|

To simplify calculations and avoid special cases, it is cleaner to
always place the compressed kernel image in memory so that ZO__end
is at the end of the decompression buffer, instead of placing that
start extract_offset as is currently done.

This patch adds BP_init_size (which is the INIT_SIZE as passed in from
the boot_params) into asm-offsets.c to make it visible to the assembly
code. Then when moving the ZO, it calculates the starting position of
the copied ZO (via BP_init_size and the ZO run size) so that the VO__end
will be at the end of the decompression buffer. To make the position
calculation safe, the end of ZO is page aligned (and a comment is added
to the existing VO alignment for good measure).

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
[kees: rewrote changelog]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/boot/compressed/head_32.S     | 11 +++++++++--
 arch/x86/boot/compressed/head_64.S     |  8 ++++++--
 arch/x86/boot/compressed/mkpiggy.c     |  3 ---
 arch/x86/boot/compressed/vmlinux.lds.S |  1 +
 arch/x86/kernel/asm-offsets.c          |  1 +
 arch/x86/kernel/vmlinux.lds.S          |  2 +-
 6 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index 8ef964ddc18e..0c140f99c602 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -148,7 +148,9 @@ preferred_addr:
 1:
 
 	/* Target address to relocate to for decompression */
-	addl	$z_extract_offset, %ebx
+	movl    BP_init_size(%esi), %eax
+	subl    $_end, %eax
+	addl    %eax, %ebx
 
 	/* Set up the stack */
 	leal	boot_stack_end(%ebx), %esp
@@ -210,8 +212,13 @@ relocated:
 				/* push arguments for decompress_kernel: */
 	pushl	$z_run_size	/* size of kernel with .bss and .brk */
 	pushl	$z_output_len	/* decompressed length, end of relocs */
-	leal	z_extract_offset_negative(%ebx), %ebp
+
+	movl    BP_init_size(%esi), %eax
+	subl    $_end, %eax
+	movl    %ebx, %ebp
+	subl    %eax, %ebp
 	pushl	%ebp		/* output address */
+
 	pushl	$z_input_len	/* input_len */
 	leal	input_data(%ebx), %eax
 	pushl	%eax		/* input_data */
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index b0c0d16ef58d..67dd8d300c61 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -102,7 +102,9 @@ ENTRY(startup_32)
 1:
 
 	/* Target address to relocate to for decompression */
-	addl	$z_extract_offset, %ebx
+	movl	BP_init_size(%esi), %eax
+	subl	$_end, %eax
+	addl	%eax, %ebx
 
 /*
  * Prepare for entering 64 bit mode
@@ -330,7 +332,9 @@ preferred_addr:
 1:
 
 	/* Target address to relocate to for decompression */
-	leaq	z_extract_offset(%rbp), %rbx
+	movl	BP_init_size(%rsi), %ebx
+	subl	$_end, %ebx
+	addq	%rbp, %rbx
 
 	/* Set up the stack */
 	leaq	boot_stack_end(%rbx), %rsp
diff --git a/arch/x86/boot/compressed/mkpiggy.c b/arch/x86/boot/compressed/mkpiggy.c
index d8222f213182..b980046c3329 100644
--- a/arch/x86/boot/compressed/mkpiggy.c
+++ b/arch/x86/boot/compressed/mkpiggy.c
@@ -85,9 +85,6 @@ int main(int argc, char *argv[])
 	printf("z_output_len = %lu\n", (unsigned long)olen);
 	printf(".globl z_extract_offset\n");
 	printf("z_extract_offset = 0x%lx\n", offs);
-	/* z_extract_offset_negative allows simplification of head_32.S */
-	printf(".globl z_extract_offset_negative\n");
-	printf("z_extract_offset_negative = -0x%lx\n", offs);
 	printf(".globl z_run_size\n");
 	printf("z_run_size = %lu\n", run_size);
 
diff --git a/arch/x86/boot/compressed/vmlinux.lds.S b/arch/x86/boot/compressed/vmlinux.lds.S
index 34d047c98284..e24e0a0c90c9 100644
--- a/arch/x86/boot/compressed/vmlinux.lds.S
+++ b/arch/x86/boot/compressed/vmlinux.lds.S
@@ -70,5 +70,6 @@ SECTIONS
 		_epgtable = . ;
 	}
 #endif
+	. = ALIGN(PAGE_SIZE);	/* keep ZO size page aligned */
 	_end = .;
 }
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index 5c042466f274..674134e9f5e5 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -80,6 +80,7 @@ void common(void) {
 	OFFSET(BP_hardware_subarch, boot_params, hdr.hardware_subarch);
 	OFFSET(BP_version, boot_params, hdr.version);
 	OFFSET(BP_kernel_alignment, boot_params, hdr.kernel_alignment);
+	OFFSET(BP_init_size, boot_params, hdr.init_size);
 	OFFSET(BP_pref_address, boot_params, hdr.pref_address);
 	OFFSET(BP_code32_start, boot_params, hdr.code32_start);
 
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 4c941f88d405..9297a002d8e5 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -334,7 +334,7 @@ SECTIONS
 		__brk_limit = .;
 	}
 
-	. = ALIGN(PAGE_SIZE);
+	. = ALIGN(PAGE_SIZE);		/* keep VO_INIT_SIZE page aligned */
 	_end = .;
 
         STABS_DEBUG
-- 
2.6.3
