Return-Path: <SRS0=BVGy=3Z=lists.openwall.com=kernel-hardening-return-17681-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82AAEC35247
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 Feb 2020 22:41:49 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A8A65214AF
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 Feb 2020 22:41:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A8A65214AF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17681-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10231 invoked by uid 550); 5 Feb 2020 22:40:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10136 invoked from network); 5 Feb 2020 22:39:59 -0000
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,407,1574150400"; 
   d="scan'208";a="225092471"
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	hpa@zytor.com,
	arjan@linux.intel.com,
	keescook@chromium.org
Cc: rick.p.edgecombe@intel.com,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	Kristen Carlson Accardi <kristen@linux.intel.com>
Subject: [RFC PATCH 11/11] x86/boot: Move "boot heap" out of .bss
Date: Wed,  5 Feb 2020 14:39:50 -0800
Message-Id: <20200205223950.1212394-12-kristen@linux.intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200205223950.1212394-1-kristen@linux.intel.com>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kees Cook <keescook@chromium.org>

Currently the on-disk decompression image includes the "dynamic" heap
region that is used for malloc() during kernel extraction, relocation,
and decompression ("boot_heap" of BOOT_HEAP_SIZE bytes in the .bss
section). It makes no sense to balloon the bzImage with "boot_heap"
as it is zeroed at boot, and acts much more like a "brk" region.

This seems to be a trivial change because head_{64,32}.S already only
copies up to the start of the .bss section, so any growth in the .bss
area was already not meaningful when placing the image in memory. The
.bss size is, however, reflected in the boot params "init_size", so the
memory range calculations included the "boot_heap" region. Instead of
wasting the on-disk image size bytes, just account for this heap area
when identifying the mem_avoid ranges, and leave it out of the .bss
section entirely. For good measure, also zero initialize it, as this
was already happening for when zeroing the entire .bss section.

While the bzImage size is dominated by the compressed vmlinux, the
difference removes 64KB for all compressors except bzip2, which removes
4MB. For example, this is less than 1% under CONFIG_KERNEL_XZ:

-rw-r--r-- 1 kees kees 7813168 Feb  2 23:39 arch/x86/boot/bzImage.stock-xz
-rw-r--r-- 1 kees kees 7747632 Feb  2 23:42 arch/x86/boot/bzImage.brk-xz

but much more pronounced under CONFIG_KERNEL_BZIP2 (~27%):

-rw-r--r-- 1 kees kees 15231024 Feb  2 23:44 arch/x86/boot/bzImage.stock-bzip2
-rw-r--r-- 1 kees kees 11036720 Feb  2 23:47 arch/x86/boot/bzImage.brk-bzip2

For the future fine-grain KASLR work, this will avoid significant pain,
as the ELF section parser will use much more memory during boot and
filling the bzImage with megabytes of zeros seemed like a poor idea. :)

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
---
 arch/x86/boot/compressed/head_32.S     | 5 ++---
 arch/x86/boot/compressed/head_64.S     | 7 +++----
 arch/x86/boot/compressed/kaslr.c       | 2 +-
 arch/x86/boot/compressed/misc.c        | 3 +++
 arch/x86/boot/compressed/vmlinux.lds.S | 1 +
 5 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index f2dfd6d083ef..1f3de8efd40e 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -59,6 +59,7 @@
 	.hidden _ebss
 	.hidden _got
 	.hidden _egot
+	.hidden _brk
 
 	__HEAD
 SYM_FUNC_START(startup_32)
@@ -249,7 +250,7 @@ SYM_FUNC_START_LOCAL_NOALIGN(.Lrelocated)
 	pushl	$z_input_len	/* input_len */
 	leal	input_data(%ebx), %eax
 	pushl	%eax		/* input_data */
-	leal	boot_heap(%ebx), %eax
+	leal	_brk(%ebx), %eax
 	pushl	%eax		/* heap area */
 	pushl	%esi		/* real mode pointer */
 	call	extract_kernel	/* returns kernel location in %eax */
@@ -276,8 +277,6 @@ efi32_config:
  */
 	.bss
 	.balign 4
-boot_heap:
-	.fill BOOT_HEAP_SIZE, 1, 0
 boot_stack:
 	.fill BOOT_STACK_SIZE, 1, 0
 boot_stack_end:
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index ee60b81944a7..850bc5220a8d 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -42,6 +42,7 @@
 	.hidden _ebss
 	.hidden _got
 	.hidden _egot
+	.hidden _brk
 
 	__HEAD
 	.code32
@@ -534,7 +535,7 @@ SYM_FUNC_START_LOCAL_NOALIGN(.Lrelocated)
  */
 	pushq	%rsi			/* Save the real mode argument */
 	movq	%rsi, %rdi		/* real mode address */
-	leaq	boot_heap(%rip), %rsi	/* malloc area for uncompression */
+	leaq	_brk(%rip), %rsi	/* malloc area for uncompression */
 	leaq	input_data(%rip), %rdx  /* input_data */
 	movl	$z_input_len, %ecx	/* input_len */
 	movq	%rbp, %r8		/* output target address */
@@ -701,12 +702,10 @@ SYM_DATA_END(efi64_config)
 #endif /* CONFIG_EFI_STUB */
 
 /*
- * Stack and heap for uncompression
+ * Stack for placement and uncompression
  */
 	.bss
 	.balign 4
-SYM_DATA_LOCAL(boot_heap,	.fill BOOT_HEAP_SIZE, 1, 0)
-
 SYM_DATA_START_LOCAL(boot_stack)
 	.fill BOOT_STACK_SIZE, 1, 0
 SYM_DATA_END_LABEL(boot_stack, SYM_L_LOCAL, boot_stack_end)
diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/kaslr.c
index ae4dce76a9bd..da64d2cdbb42 100644
--- a/arch/x86/boot/compressed/kaslr.c
+++ b/arch/x86/boot/compressed/kaslr.c
@@ -397,7 +397,7 @@ static void handle_mem_options(void)
 static void mem_avoid_init(unsigned long input, unsigned long input_size,
 			   unsigned long output)
 {
-	unsigned long init_size = boot_params->hdr.init_size;
+	unsigned long init_size = boot_params->hdr.init_size + BOOT_HEAP_SIZE;
 	u64 initrd_start, initrd_size;
 	u64 cmd_line, cmd_line_size;
 	char *ptr;
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 977da0911ce7..cb12da264b59 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -463,6 +463,9 @@ asmlinkage __visible void *extract_kernel(void *rmode, memptr heap,
 
 	debug_putstr("early console in extract_kernel\n");
 
+	/* Zero what is effectively our .brk section. */
+	memset((void *)heap, 0, BOOT_HEAP_SIZE);
+	debug_putaddr(heap);
 	free_mem_ptr     = heap;	/* Heap */
 	free_mem_end_ptr = heap + BOOT_HEAP_SIZE;
 
diff --git a/arch/x86/boot/compressed/vmlinux.lds.S b/arch/x86/boot/compressed/vmlinux.lds.S
index 508cfa6828c5..3ce690474940 100644
--- a/arch/x86/boot/compressed/vmlinux.lds.S
+++ b/arch/x86/boot/compressed/vmlinux.lds.S
@@ -73,4 +73,5 @@ SECTIONS
 #endif
 	. = ALIGN(PAGE_SIZE);	/* keep ZO size page aligned */
 	_end = .;
+	_brk = .;
 }
-- 
2.24.1

