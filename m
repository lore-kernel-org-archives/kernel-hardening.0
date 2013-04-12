Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Fri, 12 Apr 2013 13:13:47 -0700
Message-Id: <1365797627-20874-7-git-send-email-keescook@chromium.org>
In-Reply-To: <1365797627-20874-1-git-send-email-keescook@chromium.org>
References: <1365797627-20874-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 6/6] x86: kaslr: relocate base offset at boot
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

This creates CONFIG_RANDOMIZE_BASE, so that the base offset of the kernel
can be randomized at boot.

This makes kernel vulnerabilities harder to reliably exploit, especially
from remote attacks and local processes in seccomp containers. Keeping the
location of kernel addresses secret becomes very important when using this
feature, so enabling kptr_restrict and dmesg_restrict is recommended.
Besides direct address leaks, several other attacks are possible to bypass
this on local systems, including cache timing[1]. However, the benefits of
this feature in certain environments (e.g. remote services, heavily
confined local processes) exceed the perceived weaknesses[2].

Current entropy is low, since the kernel has basically a minimum 2MB
alignment and has been built with -2G memory addressing. As a result,
available entropy will be 8 bits in the best case. The e820 entries on a
given system may further limit the available memory. This is still be
enough for attacks that must guess the base address to fail 99% of the
time.

This feature is presently incompatible with hibernation.

When built into the kernel, the "noaslr" kernel command line option will
disable the feature.

Heavily based on work by Dan Rosenberg[3] and Neill Clift.

[1] http://www.internetsociety.org/sites/default/files/Practical%20Timing%20Side%20Channel%20Attacks%20Against%20Kernel%20Space%20ASLR.pdf
[2] http://forums.grsecurity.net/viewtopic.php?f=7&t=3367
[3] http://lkml.indiana.edu/hypermail/linux/kernel/1105.3/index.html#00520

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Eric Northup <digitaleric@google.com>
---
 Documentation/kernel-parameters.txt  |    4 +
 arch/x86/Kconfig                     |   51 +++++++++++--
 arch/x86/Makefile                    |    3 +
 arch/x86/boot/compressed/head_32.S   |   20 ++++-
 arch/x86/boot/compressed/head_64.S   |  135 ++++++++++++++++++++++++++++++++--
 arch/x86/include/asm/page_32_types.h |    2 +
 arch/x86/include/asm/page_64_types.h |    4 -
 arch/x86/include/asm/page_types.h    |    4 +
 arch/x86/kernel/asm-offsets.c        |   14 ++++
 arch/x86/kernel/setup.c              |   24 ++++++
 10 files changed, 240 insertions(+), 21 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4609e81..e1b8993 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1839,6 +1839,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	noapic		[SMP,APIC] Tells the kernel to not make use of any
 			IOAPICs that may be present in the system.
 
+	noaslr		[X86]
+			Disable kernel base offset ASLR (Address Space
+			Layout Randomization) if built into the kernel.
+
 	noautogroup	Disable scheduler automatic task group creation.
 
 	nobats		[PPC] Do not use BATs for mapping kernel lowmem
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 70c0f3d..6fe1a3b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1649,8 +1649,8 @@ config PHYSICAL_START
 	  If kernel is a not relocatable (CONFIG_RELOCATABLE=n) then
 	  bzImage will decompress itself to above physical address and
 	  run from there. Otherwise, bzImage will run from the address where
-	  it has been loaded by the boot loader and will ignore above physical
-	  address.
+	  it has been loaded by the boot loader, using the above physical
+	  address as a lower bound.
 
 	  In normal kdump cases one does not have to set/change this option
 	  as now bzImage can be compiled as a completely relocatable image
@@ -1696,15 +1696,49 @@ config RELOCATABLE
 
 	  Note: If CONFIG_RELOCATABLE=y, then the kernel runs from the address
 	  it has been loaded at and the compile time physical address
-	  (CONFIG_PHYSICAL_START) is ignored.
-
-# Relocation on x86-32 needs some additional build support
+	  (CONFIG_PHYSICAL_START) is solely used as a lower bound.
+
+config RANDOMIZE_BASE
+	 bool "Randomize the address of the kernel image"
+	 depends on RELOCATABLE
+	 depends on !HIBERNATION
+	 default n
+	 ---help---
+	   Randomizes the phyiscal and virtual address at which the
+	   kernel image is decompressed, as a security feature that
+	   deters exploit attempts relying on knowledge of the location
+	   of kernel internals.
+
+	   This feature also uses a fixed mapping to move the IDT
+	   (if not already done as a fix for the F00F bug), to avoid
+	   exposing the location of kernel internals relative to the
+	   original IDT. This has the additional security benefit of
+	   marking the new virtual address of the IDT read-only.
+
+	   Entropy is generated using the RDRAND instruction if it
+	   is supported.  If not, then RDTSC is used, if supported. If
+	   neither RDRAND nor RDTSC are supported, then no randomness
+	   is introduced. Support for the CPUID instruction is required
+	   to check for the availability of these two instructions.
+
+config RANDOMIZE_BASE_MAX_OFFSET
+	hex "Maximum ASLR offset allowed"
+	depends on RANDOMIZE_BASE
+	default "0x10000000"
+	range 0x0 0x10000000
+	---help---
+	 Determines the maximal offset in bytes that will be applied to the
+	 kernel when Address Space Layout Randomization (ASLR) is active.
+	 Physical memory layout and kernel size may limit this further.
+	 This must be a power of two.
+
+# Relocation on x86-32/64 needs some additional build support
 config X86_NEED_RELOCS
 	def_bool y
-	depends on X86_32 && RELOCATABLE
+	depends on RELOCATABLE
 
 config PHYSICAL_ALIGN
-	hex "Alignment value to which kernel should be aligned" if X86_32
+	hex "Alignment value to which kernel should be aligned"
 	default "0x1000000"
 	range 0x2000 0x1000000
 	---help---
@@ -1724,6 +1758,9 @@ config PHYSICAL_ALIGN
 	  end result is that kernel runs from a physical address meeting
 	  above alignment restrictions.
 
+	  Generally when using CONFIG_RANDOMIZE_BASE, this is safe to
+	  lower to 0x200000.
+
 	  Don't change this unless you know what you are doing.
 
 config HOTPLUG_CPU
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 5c47726..4f280bd 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -60,6 +60,9 @@ else
 	# Use -mpreferred-stack-boundary=3 if supported.
 	KBUILD_CFLAGS += $(call cc-option,-mno-sse -mpreferred-stack-boundary=3)
 
+        ifdef CONFIG_RANDOMIZE_BASE
+                LDFLAGS_vmlinux := --emit-relocs
+        endif
         # FIXME - should be integrated in Makefile.cpu (Makefile_32.cpu)
         cflags-$(CONFIG_MK8) += $(call cc-option,-march=k8)
         cflags-$(CONFIG_MPSC) += $(call cc-option,-march=nocona)
diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index 1e3184f..957b1c7 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -29,6 +29,7 @@
 #include <asm/page_types.h>
 #include <asm/boot.h>
 #include <asm/asm-offsets.h>
+#include <asm/cpufeature.h>
 
 	__HEAD
 ENTRY(startup_32)
@@ -111,15 +112,29 @@ preferred_addr:
  */
 
 #ifdef CONFIG_RELOCATABLE
+#ifdef CONFIG_RANDOMIZE_BASE
+	/* Setup boot stack for calls */
+	leal	boot_stack_end(%ebp), %esp
+	call	select_aslr_address /* Select ASLR address */
+	movl	%eax, %ebx
+	/* LOAD_PHSYICAL_ADDR is the minimum safe address we can
+	 * decompress at */
+	cmpl	$LOAD_PHYSICAL_ADDR, %ebx
+	jae	1f
+	movl	$LOAD_PHYSICAL_ADDR, %ebx
+1:
+#else /* CONFIG_RANDOMIZE_BASE */
 	movl	%ebp, %ebx
 	movl	BP_kernel_alignment(%esi), %eax
 	decl	%eax
 	addl    %eax, %ebx
 	notl	%eax
 	andl    %eax, %ebx
-#else
+#endif /* CONFIG_RANDOMIZE_BASE */
+
+#else /* CONFIG_RELOCATABLE */
 	movl	$LOAD_PHYSICAL_ADDR, %ebx
-#endif
+#endif /* CONFIG_RELOCATABLE */
 
 	/* Target address to relocate to for decompression */
 	addl	$z_extract_offset, %ebx
@@ -235,3 +250,4 @@ boot_heap:
 boot_stack:
 	.fill BOOT_STACK_SIZE, 1, 0
 boot_stack_end:
+	.globl	boot_stack_end
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index c1d383d..fc37910 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -59,7 +59,7 @@ ENTRY(startup_32)
 1:
 
 /*
- * Calculate the delta between where we were compiled to run
+ * Calculate the delta between where we were linked to load
  * at and where we were actually loaded at.  This can only be done
  * with a short local call on x86.  Nothing  else will tell us what
  * address we are running at.  The reserved chunk of the real-mode
@@ -78,10 +78,10 @@ ENTRY(startup_32)
 
 	call	verify_cpu
 	testl	%eax, %eax
-	jnz	no_longmode
+	jnz	hang
 
 /*
- * Compute the delta between where we were compiled to run at
+ * Compute the delta between where we were linked to load at
  * and where the code will actually run at.
  *
  * %ebp contains the address we are loaded at by the boot loader and %ebx
@@ -90,15 +90,32 @@ ENTRY(startup_32)
  */
 
 #ifdef CONFIG_RELOCATABLE
+#ifdef CONFIG_RANDOMIZE_BASE
+	call	select_aslr_address /* Select ASLR offset */
+	movl	%eax, %ebx
+	/* LOAD_PHYSICAL_ADDR is the minimum safe address we can
+	 * decompress at */
+	cmpl	$LOAD_PHYSICAL_ADDR, %ebx
+	jae	1f
+	movl	$LOAD_PHYSICAL_ADDR, %ebx
+#else /* CONFIG_RANDOMIZE_BASE */
 	movl	%ebp, %ebx
 	movl	BP_kernel_alignment(%esi), %eax
 	decl	%eax
 	addl	%eax, %ebx
 	notl	%eax
 	andl	%eax, %ebx
-#else
+#endif /* CONFIG_RANDOMIZE_BASE */
+
+#ifdef CONFIG_RANDOMIZE_BASE
+1:	movl	%ebx, %eax
+	subl	$LOAD_PHYSICAL_ADDR, %eax
+        movl	%eax, aslr_offset(%ebp)
+	incl	aslr_in_32bit(%ebp) /* say 32 bit code ran */
+#endif /* CONFIG_RANDOMIZE_BASE */
+#else /* CONFIG_RELOCATABLE */
 	movl	$LOAD_PHYSICAL_ADDR, %ebx
-#endif
+#endif /* CONFIG_RELOCATABLE */
 
 	/* Target address to relocate to for decompression */
 	addl	$z_extract_offset, %ebx
@@ -266,14 +283,30 @@ preferred_addr:
 	/* Start with the delta to where the kernel will run at. */
 #ifdef CONFIG_RELOCATABLE
 	leaq	startup_32(%rip) /* - $startup_32 */, %rbp
+#ifdef CONFIG_RANDOMIZE_BASE
+	leaq	boot_stack_end(%rip), %rsp
+	testl	$1, aslr_in_32bit(%rip)
+	jne	1f
+	call	select_aslr_address
+	movq	%rax, %rbp
+	jmp	2f
+1:	movl	aslr_offset(%rip), %eax
+	addq	%rax, %rbp
+	/* LOAD_PHYSICAL_ADDR is the minimum safe address we can
+	 * decompress at. */
+	cmpq	$LOAD_PHYSICAL_ADDR, %rbp
+	jae	2f
+	movq	$LOAD_PHYSICAL_ADDR, %rbp
+2:
+#endif	/* CONFIG_RANDOMIZE_BASE */
 	movl	BP_kernel_alignment(%rsi), %eax
 	decl	%eax
 	addq	%rax, %rbp
 	notq	%rax
 	andq	%rax, %rbp
-#else
+#else /* CONFIG_RELOCATABLE */
 	movq	$LOAD_PHYSICAL_ADDR, %rbp
-#endif
+#endif /* CONFIG_RELOCATABLE */
 
 	/* Target address to relocate to for decompression */
 	leaq	z_extract_offset(%rbp), %rbx
@@ -343,13 +376,85 @@ relocated:
 	call	decompress_kernel
 	popq	%rsi
 
+#ifdef CONFIG_RANDOMIZE_BASE
+/*
+ * Find the address of the relocations.
+ */
+	leaq	z_output_len(%rbp), %rdi
+
+/*
+ * Calculate the delta between where vmlinux was linked to load
+ * and where it was actually loaded.
+ */
+	movq	%rbp, %rbx
+	subq	$LOAD_PHYSICAL_ADDR, %rbx
+	je	3f	/* Nothing to be done if loaded at linked addr. */
+/*
+ * The kernel contains a table of relocation addresses. Those addresses
+ * have the final load address of the kernel in virtual memory.
+ * We are currently working in the self map. So we need to create an
+ * adjustment for kernel memory addresses to the self map. This will
+ * involve subtracting out the base address of the kernel.
+ */
+	movq	$-__START_KERNEL_map, %rdx /* Literal is too big for add etc */
+	addq	%rbx, %rdx
+/*
+ * Process relocations. 32 bit relocations first then 64 bit after.
+ * Two sets of binary relocations are added to the end of the
+ * kernel before compression. Each relocation table entry is the kernel
+ * address of the location which needs to be updated stored as a 32 bit
+ * value which is sign extended to 64 bits.
+ *
+ * Format is:
+ *
+ * kernel bits...
+ * 0 - zero terminator for 64 bit relocations
+ * 64 bit relocation repeated
+ * 0 - zero terminator for 32 bit relocations
+ * 32 bit relocation repeated
+ *
+ * So we work backwards from the end of the decompressed image.
+ */
+1:	subq	$4, %rdi
+	movslq	(%rdi), %rcx
+	testq	%rcx, %rcx
+	je	2f
+	addq	%rdx, %rcx
+/*
+ * Relocation can't be before the image or
+ * after the current position of the current relocation.
+ * This is a cheap bounds check. It could be more exact
+ * and limit to the end of the image prior to the relocations
+ * but allowing relocations themselves to be fixed up will not
+ * do any harm.
+ */
+	cmpq	%rbp, %rcx
+	jb	hang
+	cmpq	%rdi, %rcx
+	jae	hang
+	addl	%ebx, (%rcx)	/* 32 bit relocation */
+	jmp	1b
+2:	subq	$4, %rdi
+	movslq	(%rdi), %rcx
+	testq	%rcx, %rcx
+	je	3f
+	addq	%rdx, %rcx
+	cmpq	%rbp, %rcx
+	jb	hang
+	cmpq	%rdi, %rcx
+	jae	hang
+	addq	%rbx, (%rcx)	/* 64 bit relocation */
+	jmp	2b
+3:
+#endif /* CONFIG_RANDOMIZE_BASE */
+
 /*
  * Jump to the decompressed kernel.
  */
 	jmp	*%rbp
 
 	.code32
-no_longmode:
+hang:
 	/* This isn't an x86-64 CPU so hang */
 1:
 	hlt
@@ -369,6 +474,19 @@ gdt:
 	.quad   0x0000000000000000	/* TS continued */
 gdt_end:
 
+#ifdef CONFIG_RANDOMIZE_BASE
+aslr_offset:
+	.long	0			/* Offset selected for ASLR */
+/*
+ * Set if ASLR ran in 32 bit mode. For 64 bit loaders the 32 bit code
+ * doesn't run and we need to do the offset calculation there for the
+ * first time.
+ */
+aslr_in_32bit:
+	.long	0
+
+#endif /* CONFIG_RANDOMIZE_BASE */
+
 /*
  * Stack and heap for uncompression
  */
@@ -379,6 +497,7 @@ boot_heap:
 boot_stack:
 	.fill BOOT_STACK_SIZE, 1, 0
 boot_stack_end:
+	.globl	boot_stack_end
 
 /*
  * Space for page tables (not in .bss so not zeroed)
diff --git a/arch/x86/include/asm/page_32_types.h b/arch/x86/include/asm/page_32_types.h
index ef17af0..996582c 100644
--- a/arch/x86/include/asm/page_32_types.h
+++ b/arch/x86/include/asm/page_32_types.h
@@ -15,6 +15,8 @@
  */
 #define __PAGE_OFFSET		_AC(CONFIG_PAGE_OFFSET, UL)
 
+#define __START_KERNEL		(__PAGE_OFFSET + __PHYSICAL_START)
+
 #define THREAD_SIZE_ORDER	1
 #define THREAD_SIZE		(PAGE_SIZE << THREAD_SIZE_ORDER)
 
diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
index 8b491e6..c0dfe38 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -32,10 +32,6 @@
  */
 #define __PAGE_OFFSET           _AC(0xffff880000000000, UL)
 
-#define __PHYSICAL_START	((CONFIG_PHYSICAL_START +	 	\
-				  (CONFIG_PHYSICAL_ALIGN - 1)) &	\
-				 ~(CONFIG_PHYSICAL_ALIGN - 1))
-
 #define __START_KERNEL		(__START_KERNEL_map + __PHYSICAL_START)
 #define __START_KERNEL_map	_AC(0xffffffff80000000, UL)
 
diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
index 54c9787..b6f9b49 100644
--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -33,6 +33,10 @@
 	(((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0 ) | \
 	 VM_READ | VM_WRITE | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 
+#define __PHYSICAL_START	((CONFIG_PHYSICAL_START +		\
+				  (CONFIG_PHYSICAL_ALIGN - 1)) &	\
+				 ~(CONFIG_PHYSICAL_ALIGN - 1))
+
 #ifdef CONFIG_X86_64
 #include <asm/page_64_types.h>
 #else
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index 2861082..7e014b7 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -70,6 +70,20 @@ void common(void) {
 	OFFSET(BP_pref_address, boot_params, hdr.pref_address);
 	OFFSET(BP_code32_start, boot_params, hdr.code32_start);
 
+	OFFSET(BP_scratch, boot_params, scratch);
+	OFFSET(BP_loadflags, boot_params, hdr.loadflags);
+	OFFSET(BP_hardware_subarch, boot_params, hdr.hardware_subarch);
+	OFFSET(BP_version, boot_params, hdr.version);
+	OFFSET(BP_kernel_alignment, boot_params, hdr.kernel_alignment);
+	OFFSET(BP_e820_map, boot_params, e820_map);
+	OFFSET(BP_e820_entries, boot_params, e820_entries);
+	OFFSET(BP_cmd_line_ptr, boot_params, hdr.cmd_line_ptr);
+
+	OFFSET(E820_addr, e820entry, addr);
+	OFFSET(E820_size, e820entry, size);
+	OFFSET(E820_type, e820entry, type);
+	DEFINE(E820_entry_size, sizeof(struct e820entry));
+
 	BLANK();
 	DEFINE(PTREGS_SIZE, sizeof(struct pt_regs));
 }
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 90d8cc9..fd9e68f 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -801,6 +801,18 @@ static void __init trim_low_memory_range(void)
 }
 	
 /*
+ * Dump out kernel offset information on panic.
+ */
+static int
+dump_kernel_offset(struct notifier_block *self, unsigned long v, void *p)
+{
+	pr_emerg("Kernel Offset: 0x%lx\n",
+		 (unsigned long)&_text - __START_KERNEL);
+
+	return 0;
+}
+
+/*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
  * passed the efi memmap, systab, etc., so we should use these data structures
  * for initialization.  Note, the efi init code path is determined by the
@@ -1220,3 +1232,15 @@ void __init i386_reserve_resources(void)
 }
 
 #endif /* CONFIG_X86_32 */
+
+static struct notifier_block kernel_offset_notifier = {
+	.notifier_call = dump_kernel_offset
+};
+
+static int __init register_kernel_offset_dumper(void)
+{
+	atomic_notifier_chain_register(&panic_notifier_list,
+					&kernel_offset_notifier);
+	return 0;
+}
+__initcall(register_kernel_offset_dumper);
-- 
1.7.9.5
