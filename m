MIME-Version: 1.0
Date: Mon, 25 Jun 2018 15:39:02 -0700
In-Reply-To: <20180625224014.134829-1-thgarnie@google.com>
Message-Id: <20180625224014.134829-15-thgarnie@google.com>
References: <20180625224014.134829-1-thgarnie@google.com>
Subject: [PATCH v5 14/27] x86/percpu: Adapt percpu for PIE support
From: Thomas Garnier <thgarnie@google.com>
Content-Type: text/plain; charset="UTF-8"
To: kernel-hardening@lists.openwall.com
Cc: Thomas Garnier <thgarnie@google.com>, Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Dennis Zhou <dennisszhou@gmail.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Borislav Petkov <bp@suse.de>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Kees Cook <keescook@chromium.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, Tom Lendacky <thomas.lendacky@amd.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Alexey Dobriyan <adobriyan@gmail.com>, Francis Deslauriers <francis.deslauriers@efficios.com>, Kate Stewart <kstewart@linuxfoundation.org>, David Woodhouse <dwmw@amazon.co.uk>, Masahiro Yamada <yamada.masahiro@socionext.com>, Cao jin <caoj.fnst@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
List-ID: <kernel-hardening.lists.openwall.com>

Perpcu uses a clever design where the .percu ELF section has a virtual
address of zero and the custom linux relocation code avoid relocating
specific symbols. It makes the code simple and easily adaptable with or
without SMP support.

This design is incompatible with PIE. While creating a PIE binary, the
copmiler tries to make everything relative. The compiler will attempt to
generate instructions with the distance between zero and any 64-bit
virtual address. It will fail as the relocation range cannot fit within
the possible instructions accessing a segment register.

This patch solves tihs problem by removing the zero mapping. The .percpu
symbols are now close to the base of the kernel and the compiler
generates appropriate relocations. To accomodate this change, the GS base
is adapted to be the difference between zero and the .percpu section
address. These changes are done only when PIE is enabled. The original
implementation is kept as-is by default.

The assembly and PER_CPU macros are changed to use relative references
when PIE is enabled.

The KALLSYMS_ABSOLUTE_PERCPU configuration is disabled with PIE given
percpu symbols are not absolute in this case.

Position Independent Executable (PIE) support will allow to extend the
KASLR randomization range 0xffffffff80000000.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/x86/entry/calling.h         |  2 +-
 arch/x86/entry/entry_64.S        |  4 ++--
 arch/x86/include/asm/percpu.h    | 25 +++++++++++++++++++------
 arch/x86/include/asm/processor.h |  4 +++-
 arch/x86/kernel/head_64.S        |  4 ++++
 arch/x86/kernel/setup_percpu.c   |  5 ++++-
 arch/x86/kernel/vmlinux.lds.S    | 13 +++++++++++--
 arch/x86/lib/cmpxchg16b_emu.S    |  8 ++++----
 arch/x86/xen/xen-asm.S           | 12 ++++++------
 init/Kconfig                     |  2 +-
 10 files changed, 55 insertions(+), 24 deletions(-)

diff --git a/arch/x86/entry/calling.h b/arch/x86/entry/calling.h
index 352e70cd33e8..d6c60e6b598f 100644
--- a/arch/x86/entry/calling.h
+++ b/arch/x86/entry/calling.h
@@ -218,7 +218,7 @@ For 32-bit we have the following conventions - kernel is built with
 .endm
 
 #define THIS_CPU_user_pcid_flush_mask   \
-	PER_CPU_VAR(cpu_tlbstate) + TLB_STATE_user_pcid_flush_mask
+	PER_CPU_VAR(cpu_tlbstate + TLB_STATE_user_pcid_flush_mask)
 
 .macro SWITCH_TO_USER_CR3_NOSTACK scratch_reg:req scratch_reg2:req
 	ALTERNATIVE "jmp .Lend_\@", "", X86_FEATURE_PTI
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index e738d8d0e308..2afd2e2a86db 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -359,7 +359,7 @@ ENTRY(__switch_to_asm)
 
 #ifdef CONFIG_STACKPROTECTOR
 	movq	TASK_stack_canary(%rsi), %rbx
-	movq	%rbx, PER_CPU_VAR(irq_stack_union)+stack_canary_offset
+	movq	%rbx, PER_CPU_VAR(irq_stack_union + stack_canary_offset)
 #endif
 
 #ifdef CONFIG_RETPOLINE
@@ -898,7 +898,7 @@ apicinterrupt IRQ_WORK_VECTOR			irq_work_interrupt		smp_irq_work_interrupt
 /*
  * Exception entry points.
  */
-#define CPU_TSS_IST(x) PER_CPU_VAR(cpu_tss_rw) + (TSS_ist + ((x) - 1) * 8)
+#define CPU_TSS_IST(x) PER_CPU_VAR(cpu_tss_rw + (TSS_ist + ((x) - 1) * 8))
 
 .macro idtentry sym do_sym has_error_code:req paranoid=0 shift_ist=-1
 ENTRY(\sym)
diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index e9202a0de8f0..e1f05ae6dd21 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -5,9 +5,11 @@
 #ifdef CONFIG_X86_64
 #define __percpu_seg		gs
 #define __percpu_mov_op		movq
+#define __percpu_rel		(%rip)
 #else
 #define __percpu_seg		fs
 #define __percpu_mov_op		movl
+#define __percpu_rel
 #endif
 
 #ifdef __ASSEMBLY__
@@ -28,10 +30,14 @@
 #define PER_CPU(var, reg)						\
 	__percpu_mov_op %__percpu_seg:this_cpu_off, reg;		\
 	lea var(reg), reg
-#define PER_CPU_VAR(var)	%__percpu_seg:var
+/* Compatible with Position Independent Code */
+#define PER_CPU_VAR(var)		%__percpu_seg:(var)##__percpu_rel
+/* Rare absolute reference */
+#define PER_CPU_VAR_ABS(var)		%__percpu_seg:var
 #else /* ! SMP */
 #define PER_CPU(var, reg)	__percpu_mov_op $var, reg
-#define PER_CPU_VAR(var)	var
+#define PER_CPU_VAR(var)	(var)##__percpu_rel
+#define PER_CPU_VAR_ABS(var)	var
 #endif	/* SMP */
 
 #ifdef CONFIG_X86_64_SMP
@@ -209,27 +215,34 @@ do {									\
 	pfo_ret__;					\
 })
 
+/* Position Independent code uses relative addresses only */
+#ifdef CONFIG_X86_PIE
+#define __percpu_stable_arg __percpu_arg(a1)
+#else
+#define __percpu_stable_arg __percpu_arg(P1)
+#endif
+
 #define percpu_stable_op(op, var)			\
 ({							\
 	typeof(var) pfo_ret__;				\
 	switch (sizeof(var)) {				\
 	case 1:						\
-		asm(op "b "__percpu_arg(P1)",%0"	\
+		asm(op "b "__percpu_stable_arg ",%0"	\
 		    : "=q" (pfo_ret__)			\
 		    : "p" (&(var)));			\
 		break;					\
 	case 2:						\
-		asm(op "w "__percpu_arg(P1)",%0"	\
+		asm(op "w "__percpu_stable_arg ",%0"	\
 		    : "=r" (pfo_ret__)			\
 		    : "p" (&(var)));			\
 		break;					\
 	case 4:						\
-		asm(op "l "__percpu_arg(P1)",%0"	\
+		asm(op "l "__percpu_stable_arg ",%0"	\
 		    : "=r" (pfo_ret__)			\
 		    : "p" (&(var)));			\
 		break;					\
 	case 8:						\
-		asm(op "q "__percpu_arg(P1)",%0"	\
+		asm(op "q "__percpu_stable_arg ",%0"	\
 		    : "=r" (pfo_ret__)			\
 		    : "p" (&(var)));			\
 		break;					\
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 25b5842a4646..6ee253d279d9 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -24,6 +24,7 @@ struct vm86;
 #include <asm/special_insns.h>
 #include <asm/fpu/types.h>
 #include <asm/unwind_hints.h>
+#include <asm/sections.h>
 
 #include <linux/personality.h>
 #include <linux/cache.h>
@@ -400,7 +401,8 @@ DECLARE_INIT_PER_CPU(irq_stack_union);
 
 static inline unsigned long cpu_kernelmode_gs_base(int cpu)
 {
-	return (unsigned long)per_cpu(irq_stack_union.gs_base, cpu);
+	return (unsigned long)per_cpu(irq_stack_union.gs_base, cpu) -
+		(unsigned long)__per_cpu_start;
 }
 
 DECLARE_PER_CPU(char *, irq_stack_ptr);
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 7fca19e1f556..fddeb3d81aa6 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -268,7 +268,11 @@ ENDPROC(start_cpu0)
 	GLOBAL(initial_code)
 	.quad	x86_64_start_kernel
 	GLOBAL(initial_gs)
+#ifdef CONFIG_X86_PIE
+	.quad	0
+#else
 	.quad	INIT_PER_CPU_VAR(irq_stack_union)
+#endif
 	GLOBAL(initial_stack)
 	/*
 	 * The SIZEOF_PTREGS gap is a convention which helps the in-kernel
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index ea554f812ee1..d61ecc3d2b6f 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -26,7 +26,7 @@
 DEFINE_PER_CPU_READ_MOSTLY(int, cpu_number);
 EXPORT_PER_CPU_SYMBOL(cpu_number);
 
-#ifdef CONFIG_X86_64
+#if defined(CONFIG_X86_64) && !defined(CONFIG_X86_PIE)
 #define BOOT_PERCPU_OFFSET ((unsigned long)__per_cpu_load)
 #else
 #define BOOT_PERCPU_OFFSET 0
@@ -40,6 +40,9 @@ unsigned long __per_cpu_offset[NR_CPUS] __ro_after_init = {
 };
 EXPORT_SYMBOL(__per_cpu_offset);
 
+/* Used to calculate gs_base for each CPU */
+EXPORT_SYMBOL(__per_cpu_start);
+
 /*
  * On x86_64 symbols referenced from code should be reachable using
  * 32bit relocations.  Reserve space for static percpu variables in
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 5e1458f609a1..f582fc4776dd 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -211,9 +211,14 @@ SECTIONS
 	/*
 	 * percpu offsets are zero-based on SMP.  PERCPU_VADDR() changes the
 	 * output PHDR, so the next output section - .init.text - should
-	 * start another segment - init.
+	 * start another segment - init. For Position Independent Code, the
+	 * per-cpu section cannot be zero-based because everything is relative.
 	 */
+#ifdef CONFIG_X86_PIE
+	PERCPU_SECTION(INTERNODE_CACHE_BYTES)
+#else
 	PERCPU_VADDR(INTERNODE_CACHE_BYTES, 0, :percpu)
+#endif
 	ASSERT(SIZEOF(.data..percpu) < CONFIG_PHYSICAL_START,
 	       "per-CPU data too large - increase CONFIG_PHYSICAL_START")
 #endif
@@ -389,7 +394,11 @@ SECTIONS
  * Per-cpu symbols which need to be offset from __per_cpu_load
  * for the boot processor.
  */
+#ifdef CONFIG_X86_PIE
+#define INIT_PER_CPU(x) init_per_cpu__##x = x
+#else
 #define INIT_PER_CPU(x) init_per_cpu__##x = x + __per_cpu_load
+#endif
 INIT_PER_CPU(gdt_page);
 INIT_PER_CPU(irq_stack_union);
 
@@ -399,7 +408,7 @@ INIT_PER_CPU(irq_stack_union);
 . = ASSERT((_end - _text <= KERNEL_IMAGE_SIZE),
 	   "kernel image bigger than KERNEL_IMAGE_SIZE");
 
-#ifdef CONFIG_SMP
+#if defined(CONFIG_SMP) && !defined(CONFIG_X86_PIE)
 . = ASSERT((irq_stack_union == 0),
            "irq_stack_union is not at start of per-cpu area");
 #endif
diff --git a/arch/x86/lib/cmpxchg16b_emu.S b/arch/x86/lib/cmpxchg16b_emu.S
index 9b330242e740..254950604ae4 100644
--- a/arch/x86/lib/cmpxchg16b_emu.S
+++ b/arch/x86/lib/cmpxchg16b_emu.S
@@ -33,13 +33,13 @@ ENTRY(this_cpu_cmpxchg16b_emu)
 	pushfq
 	cli
 
-	cmpq PER_CPU_VAR((%rsi)), %rax
+	cmpq PER_CPU_VAR_ABS((%rsi)), %rax
 	jne .Lnot_same
-	cmpq PER_CPU_VAR(8(%rsi)), %rdx
+	cmpq PER_CPU_VAR_ABS(8(%rsi)), %rdx
 	jne .Lnot_same
 
-	movq %rbx, PER_CPU_VAR((%rsi))
-	movq %rcx, PER_CPU_VAR(8(%rsi))
+	movq %rbx, PER_CPU_VAR_ABS((%rsi))
+	movq %rcx, PER_CPU_VAR_ABS(8(%rsi))
 
 	popfq
 	mov $1, %al
diff --git a/arch/x86/xen/xen-asm.S b/arch/x86/xen/xen-asm.S
index 8019edd0125c..a5d73d3218be 100644
--- a/arch/x86/xen/xen-asm.S
+++ b/arch/x86/xen/xen-asm.S
@@ -21,7 +21,7 @@
 ENTRY(xen_irq_enable_direct)
 	FRAME_BEGIN
 	/* Unmask events */
-	movb $0, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_mask
+	movb $0, PER_CPU_VAR(xen_vcpu_info + XEN_vcpu_info_mask)
 
 	/*
 	 * Preempt here doesn't matter because that will deal with any
@@ -30,7 +30,7 @@ ENTRY(xen_irq_enable_direct)
 	 */
 
 	/* Test for pending */
-	testb $0xff, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_pending
+	testb $0xff, PER_CPU_VAR(xen_vcpu_info + XEN_vcpu_info_pending)
 	jz 1f
 
 	call check_events
@@ -45,7 +45,7 @@ ENTRY(xen_irq_enable_direct)
  * non-zero.
  */
 ENTRY(xen_irq_disable_direct)
-	movb $1, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_mask
+	movb $1, PER_CPU_VAR(xen_vcpu_info + XEN_vcpu_info_mask)
 	ret
 ENDPROC(xen_irq_disable_direct)
 
@@ -59,7 +59,7 @@ ENDPROC(xen_irq_disable_direct)
  * x86 use opposite senses (mask vs enable).
  */
 ENTRY(xen_save_fl_direct)
-	testb $0xff, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_mask
+	testb $0xff, PER_CPU_VAR(xen_vcpu_info + XEN_vcpu_info_mask)
 	setz %ah
 	addb %ah, %ah
 	ret
@@ -80,7 +80,7 @@ ENTRY(xen_restore_fl_direct)
 #else
 	testb $X86_EFLAGS_IF>>8, %ah
 #endif
-	setz PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_mask
+	setz PER_CPU_VAR(xen_vcpu_info + XEN_vcpu_info_mask)
 	/*
 	 * Preempt here doesn't matter because that will deal with any
 	 * pending interrupts.  The pending check may end up being run
@@ -88,7 +88,7 @@ ENTRY(xen_restore_fl_direct)
 	 */
 
 	/* check for unmasked and pending */
-	cmpw $0x0001, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_pending
+	cmpw $0x0001, PER_CPU_VAR(xen_vcpu_info + XEN_vcpu_info_pending)
 	jnz 1f
 	call check_events
 1:
diff --git a/init/Kconfig b/init/Kconfig
index 83f7e824d61b..24b60536e26b 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1395,7 +1395,7 @@ config KALLSYMS_ALL
 config KALLSYMS_ABSOLUTE_PERCPU
 	bool
 	depends on KALLSYMS
-	default X86_64 && SMP
+	default X86_64 && SMP && !X86_PIE
 
 config KALLSYMS_BASE_RELATIVE
 	bool
-- 
2.18.0.rc2.346.g013aa6912e-goog
