Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Fri, 12 Apr 2013 13:13:46 -0700
Message-Id: <1365797627-20874-6-git-send-email-keescook@chromium.org>
In-Reply-To: <1365797627-20874-1-git-send-email-keescook@chromium.org>
References: <1365797627-20874-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 5/6] x86: kaslr: routines to choose random base offset
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

This provides routines for selecting a randomized kernel base offset,
bounded by the e820 entries. It tries to use RDRAND and falls back to
RDTSC. If "noaslr" is on the kernel command line, no offset will be used.

Heavily based on work by Dan Rosenberg and Neill Clift.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Eric Northup <digitaleric@google.com>
---
 arch/x86/boot/compressed/Makefile |    2 +-
 arch/x86/boot/compressed/aslr.S   |  228 +++++++++++++++++++++++++++++++++++++
 2 files changed, 229 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/boot/compressed/aslr.S

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 0dac175..feaf203 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -26,7 +26,7 @@ HOST_EXTRACFLAGS += -I$(srctree)/tools/include
 
 VMLINUX_OBJS = $(obj)/vmlinux.lds $(obj)/head_$(BITS).o $(obj)/misc.o \
 	$(obj)/string.o $(obj)/cmdline.o $(obj)/early_serial_console.o \
-	$(obj)/piggy.o
+	$(obj)/piggy.o $(obj)/aslr.o
 
 $(obj)/eboot.o: KBUILD_CFLAGS += -fshort-wchar -mno-red-zone
 
diff --git a/arch/x86/boot/compressed/aslr.S b/arch/x86/boot/compressed/aslr.S
new file mode 100644
index 0000000..37cdef4
--- /dev/null
+++ b/arch/x86/boot/compressed/aslr.S
@@ -0,0 +1,228 @@
+/*
+ *  arch/x86/boot/compressed/aslr.S
+ *
+ * Support routine for Kernel Address Space Layout Randomization used by both
+ * the 32 and 64 bit boot code.
+ *
+ */
+	.text
+
+#include <asm/boot.h>
+#include <asm/asm-offsets.h>
+#include <asm/cpufeature.h>
+#include <asm/processor-flags.h>
+#include <asm/e820.h>
+
+#ifdef CONFIG_RANDOMIZE_BASE
+
+	.globl	select_aslr_address
+	.code32
+
+/*
+ * Get the physical memory limit for the run from the physical load position of
+ * the kernel. The kernel loads at LOAD_PHYSICAL_ADDR and we need to know how
+ * much physical memory is available for use after that point to make sure the
+ * relocated kernel will fit. Returns the limit in eax.
+ */
+get_physical_run_end:
+	pushl	%edi
+	pushl	%esi
+	pushl	%ebx
+	pushl	%edx
+	pushl	%ecx
+	movzbl	BP_e820_entries(%esi), %edi
+	leal	BP_e820_map(%esi), %esi
+	testl	%edi, %edi
+	jz	5f
+1:	cmpl	$E820_RAM, E820_type(%esi)
+	jnz	4f
+	movl	E820_addr(%esi), %eax
+	movl	E820_addr+4(%esi), %edx
+	testl	%edx, %edx /* Start address is too big for 32 bit */
+	jnz	4f
+	cmpl	$LOAD_PHYSICAL_ADDR, %eax
+	ja	4f
+	movl	E820_size(%esi), %ecx
+	movl	E820_size+4(%esi), %ebx
+	addl	%eax, %ecx
+	adcl	%edx, %ebx
+	jz	2f /* end address not beyond 32bit*/
+/* For a large run set the limit as 2^32-1 */
+	xorl	%ecx, %ecx
+	decl	%ecx
+	jmp	3f
+2:	cmpl	$LOAD_PHYSICAL_ADDR, %ecx
+	jb	4f
+3:
+	movl	%ecx, %eax
+	jmp	6f
+
+4:	addl	$E820_entry_size, %esi
+	decl	%edi
+	jnz	1b
+5:	xorl	%eax, %eax /* Fail */
+6:	popl	%ecx
+	popl	%edx
+	popl	%ebx
+	popl	%esi
+	popl	%edi
+	ret
+
+/*
+ * Get a random value to be used for the ASLR kernel offset.
+ * Returns the value in eax.
+ */
+get_aslr_offset:
+	pushl	%ebx
+	pushl	%edx
+	pushl	%ecx
+	call	find_cmdline_option
+	testl	%eax, %eax
+	jne	4f
+	/* Standard check for cpuid */
+	pushfl	/* Push original flags */
+	pushfl
+	popl	%eax
+	movl	%eax, %ebx
+	xorl	$X86_EFLAGS_ID, %eax
+	pushl	%eax
+	popfl
+	pushfl
+	popl	%eax
+	popfl	/* Pop original flags */
+	cmpl	%eax, %ebx
+	/* Say zero offset if we can't change the flag */
+	movl	$0, %eax
+	je	4f
+
+	/* Check for cpuid 1 */
+	cpuid
+	cmpl	$0x1, %eax
+	jb	4f
+
+	movl	$0x1, %eax
+	cpuid
+	xor	%eax, %eax
+
+	/* RDRAND is bit 30 */
+	btl	$(X86_FEATURE_RDRAND & 31), %ecx
+	jc	1f
+
+	/* RDTSC is bit 4 */
+	btl	$(X86_FEATURE_TSC & 31), %edx
+	jc	3f
+
+	/* Nothing is supported */
+	jmp	4f
+1:
+	/*
+	 * RDRAND sets carry bit on success, otherwise we should try
+	 * again up to 16 times.
+	 */
+	movl	$0x10, %ecx
+2:
+	/* rdrand %eax */
+	.byte	0x0f, 0xc7, 0xf0
+	jc	4f
+	loop	2b
+
+	/* Fall through: if RDRAND is supported but fails, use RDTSC,
+	 * which is guaranteed to be supported.
+	 */
+3:
+	rdtsc
+	/*
+	 * Since this is time related get some of the least significant bits
+	 * past the alignment mask
+	*/
+	shll	$0x0c, %eax
+	/* Fix the maximal offset allowed */
+4:	andl	$CONFIG_RANDOMIZE_BASE_MAX_OFFSET-1, %eax
+	popl	%ecx
+	popl	%edx
+	popl	%ebx
+	ret
+
+/*
+ * Select the ASLR address to use. We can get called once either in 32
+ * or 64 bit mode. The latter if we have a 64 bit loader.
+ * Uses ebp as the input base and returns the result in eax.
+ */
+select_aslr_address:
+	pushl	%edx
+	pushl	%ebx
+	pushl	%ecx
+	pushl	%edi
+	call	get_aslr_offset
+	pushl	%eax
+	call	get_physical_run_end
+	movl	%eax, %edx
+	popl	%eax
+1:	movl	%ebp, %ebx
+	addl	%eax, %ebx
+	movl	BP_kernel_alignment(%esi), %edi
+	decl	%edi
+	addl	%edi, %ebx
+	notl	%edi
+	andl	%edi, %ebx
+	/* Make sure we don't copy beyond run */
+	leal	boot_stack_end(%ebx), %ecx
+	leal	z_extract_offset(%ecx), %ecx
+	cmpl	%edx, %ecx
+	jb	2f
+	shrl	$1, %eax /* Shink offset */
+	jne	1b /* Move on if offset zero */
+	mov	%ebp, %ebx
+2:	movl	%ebx, %eax
+	popl	%edi
+	popl	%ecx
+	popl	%ebx
+	popl	%edx
+	ret
+
+/*
+ * Find the "noaslr" option if present on the command line.
+ */
+find_cmdline_option:
+
+#define ASLR_STRLEN 6
+
+	pushl	%ecx
+	pushl	%edi
+	xorl	%eax, %eax /* Assume we fail */
+	movl	BP_cmd_line_ptr(%esi), %edi
+	testl	%edi, %edi
+	je	6f
+	/* Calculate string length */
+	leal	-1(%edi), %ecx
+1:	incl	%ecx
+	cmpb	$0, (%ecx)
+	jne	1b
+	subl	%edi, %ecx
+2:	cmpl	$ASLR_STRLEN, %ecx
+	jb	6f
+	cmpl	$0x73616f6e, (%edi) /* noas */
+	jne	4f
+	cmpb	$0x6c, 4(%edi) /* l */
+	jne	4f
+	cmpb	$0x72, 5(%edi) /* r */
+	jne	4f
+	/* If at the start then no beginning separator required */
+	cmpl	%edi, BP_cmd_line_ptr(%esi)
+	je	3f
+	cmpb	$0x20, -1(%edi)
+	ja	4f
+	/* If at the end then no end separator required */
+3:	cmpl	$ASLR_STRLEN, %ecx
+	je	5f
+	cmpb	$0x20, ASLR_STRLEN(%edi)
+	jbe	5f
+4:	incl	%edi
+	decl	%ecx
+	jmp	2b
+5:	incl	%eax /* Sucess */
+6:	popl	%edi
+	popl	%ecx
+	ret
+
+#endif /* CONFIG_RANDOMIZE_BASE */
-- 
1.7.9.5
