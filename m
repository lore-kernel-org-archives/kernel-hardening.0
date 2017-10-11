From: Thomas Garnier <thgarnie@google.com>
Date: Wed, 11 Oct 2017 13:30:14 -0700
Message-Id: <20171011203027.11248-15-thgarnie@google.com>
In-Reply-To: <20171011203027.11248-1-thgarnie@google.com>
References: <20171011203027.11248-1-thgarnie@google.com>
Subject: [kernel-hardening] [PATCH v1 14/27] x86/percpu: Adapt percpu for PIE support
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Garnier <thgarnie@google.com>, Kees Cook <keescook@chromium.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Matthias Kaehlcke <mka@chromium.org>, Tom Lendacky <thomas.lendacky@amd.com>, Andy Lutomirski <luto@kernel.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Borislav Petkov <bp@suse.de>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Juergen Gross <jgross@suse.com>, Chris Wright <chrisw@sous-sol.org>, Alok Kataria <akataria@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Andrew Morton <akpm@linux-foundation.org>, Alexey Dobriyan <adobriyan@gmail.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Nicolas Pitre <nicolas.pitre@linaro.org>, Borislav Petkov <bp@alien8.de>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christopher Li <sparse@chrisli.org>, Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@akamai.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Dou Liyang <douly.fnst@cn.fujitsu.com>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Lukas Wunner <lukas@wunner.de>, Masahiro Yamada <yamada.masahiro@socionext.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Markus Trippelsdorf <markus@trippelsdorf.de>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Rik van Riel <riel@redhat.com>, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Waiman Long <longman@redhat.com>, Kyle Huey <me@kylehuey.com>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@suse.com>, Peter Foley <pefoley2@pefoley.com>, Paul Bolle <pebolle@tiscali.nl>, Jiri Kosina <jkosina@suse.cz>, "H . J . Lu" <hjl.tools@gmail.com>, Rob Landley <rob@landley.net>, Baoquan He <bhe@redhat.com>, =?UTF-8?q?Jan=20H=20=2E=20Sch=C3=B6nherr?= <jschoenh@amazon.de>, Daniel Micay <danielmicay@gmail.com>
Cc: x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xenproject.org, linux-arch@vger.kernel.org, linux-sparse@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Perpcu uses a clever design where the .percu ELF section has a virtual
address of zero and the relocation code avoid relocating specific
symbols. It makes the code simple and easily adaptable with or without
SMP support.

This design is incompatible with PIE because generated code always try to
access the zero virtual address relative to the default mapping address.
It becomes impossible when KASLR is configured to go below -2G. This
patch solves this problem by removing the zero mapping and adapting the GS
base to be relative to the expected address. These changes are done only
when PIE is enabled. The original implementation is kept as-is
by default.

The assembly and PER_CPU macros are changed to use relative references
when PIE is enabled.

The KALLSYMS_ABSOLUTE_PERCPU configuration is disabled with PIE given
percpu symbols are not absolute in this case.

Position Independent Executable (PIE) support will allow to extended the
KASLR randomization range below the -2G memory limit.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/x86/entry/entry_64.S      |  4 ++--
 arch/x86/include/asm/percpu.h  | 25 +++++++++++++++++++------
 arch/x86/kernel/cpu/common.c   |  4 +++-
 arch/x86/kernel/head_64.S      |  4 ++++
 arch/x86/kernel/setup_percpu.c |  2 +-
 arch/x86/kernel/vmlinux.lds.S  | 13 +++++++++++--
 arch/x86/lib/cmpxchg16b_emu.S  |  8 ++++----
 arch/x86/xen/xen-asm.S         | 12 ++++++------
 init/Kconfig                   |  2 +-
 9 files changed, 51 insertions(+), 23 deletions(-)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 15bd5530d2ae..d3a52d2342af 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -392,7 +392,7 @@ ENTRY(__switch_to_asm)
 
 #ifdef CONFIG_CC_STACKPROTECTOR
 	movq	TASK_stack_canary(%rsi), %rbx
-	movq	%rbx, PER_CPU_VAR(irq_stack_union)+stack_canary_offset
+	movq	%rbx, PER_CPU_VAR(irq_stack_union + stack_canary_offset)
 #endif
 
 	/* restore callee-saved registers */
@@ -808,7 +808,7 @@ apicinterrupt IRQ_WORK_VECTOR			irq_work_interrupt		smp_irq_work_interrupt
 /*
  * Exception entry points.
  */
-#define CPU_TSS_IST(x) PER_CPU_VAR(cpu_tss) + (TSS_ist + ((x) - 1) * 8)
+#define CPU_TSS_IST(x) PER_CPU_VAR(cpu_tss + (TSS_ist + ((x) - 1) * 8))
 
 .macro idtentry sym do_sym has_error_code:req paranoid=0 shift_ist=-1
 ENTRY(\sym)
diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index b21a475fd7ed..07250f1099b5 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -4,9 +4,11 @@
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
@@ -27,10 +29,14 @@
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
@@ -208,27 +214,34 @@ do {									\
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
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 03f9a1a8a314..fac71a3ee0b5 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -461,7 +461,9 @@ void load_percpu_segment(int cpu)
 	loadsegment(fs, __KERNEL_PERCPU);
 #else
 	__loadsegment_simple(gs, 0);
-	wrmsrl(MSR_GS_BASE, (unsigned long)per_cpu(irq_stack_union.gs_base, cpu));
+	wrmsrl(MSR_GS_BASE,
+	       (unsigned long)per_cpu(irq_stack_union.gs_base, cpu) -
+	       (unsigned long)__per_cpu_start);
 #endif
 	load_stack_canary_segment();
 }
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 32d1899f48df..df5198e310fc 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -274,7 +274,11 @@ ENDPROC(start_cpu0)
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
index 28dafed6c682..271829a1cc38 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -25,7 +25,7 @@
 DEFINE_PER_CPU_READ_MOSTLY(int, cpu_number);
 EXPORT_PER_CPU_SYMBOL(cpu_number);
 
-#ifdef CONFIG_X86_64
+#if defined(CONFIG_X86_64) && !defined(CONFIG_X86_PIE)
 #define BOOT_PERCPU_OFFSET ((unsigned long)__per_cpu_load)
 #else
 #define BOOT_PERCPU_OFFSET 0
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index f05f00acac89..48268d059ebe 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -186,9 +186,14 @@ SECTIONS
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
@@ -364,7 +369,11 @@ SECTIONS
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
 
@@ -374,7 +383,7 @@ INIT_PER_CPU(irq_stack_union);
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
index dcd31fa39b5d..495d7f42f254 100644
--- a/arch/x86/xen/xen-asm.S
+++ b/arch/x86/xen/xen-asm.S
@@ -20,7 +20,7 @@
 ENTRY(xen_irq_enable_direct)
 	FRAME_BEGIN
 	/* Unmask events */
-	movb $0, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_mask
+	movb $0, PER_CPU_VAR(xen_vcpu_info + XEN_vcpu_info_mask)
 
 	/*
 	 * Preempt here doesn't matter because that will deal with any
@@ -29,7 +29,7 @@ ENTRY(xen_irq_enable_direct)
 	 */
 
 	/* Test for pending */
-	testb $0xff, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_pending
+	testb $0xff, PER_CPU_VAR(xen_vcpu_info + XEN_vcpu_info_pending)
 	jz 1f
 
 	call check_events
@@ -44,7 +44,7 @@ ENTRY(xen_irq_enable_direct)
  * non-zero.
  */
 ENTRY(xen_irq_disable_direct)
-	movb $1, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_mask
+	movb $1, PER_CPU_VAR(xen_vcpu_info + XEN_vcpu_info_mask)
 	ret
 ENDPROC(xen_irq_disable_direct)
 
@@ -58,7 +58,7 @@ ENDPROC(xen_irq_disable_direct)
  * x86 use opposite senses (mask vs enable).
  */
 ENTRY(xen_save_fl_direct)
-	testb $0xff, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_mask
+	testb $0xff, PER_CPU_VAR(xen_vcpu_info + XEN_vcpu_info_mask)
 	setz %ah
 	addb %ah, %ah
 	ret
@@ -79,7 +79,7 @@ ENTRY(xen_restore_fl_direct)
 #else
 	testb $X86_EFLAGS_IF>>8, %ah
 #endif
-	setz PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_mask
+	setz PER_CPU_VAR(xen_vcpu_info + XEN_vcpu_info_mask)
 	/*
 	 * Preempt here doesn't matter because that will deal with any
 	 * pending interrupts.  The pending check may end up being run
@@ -87,7 +87,7 @@ ENTRY(xen_restore_fl_direct)
 	 */
 
 	/* check for unmasked and pending */
-	cmpw $0x0001, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_pending
+	cmpw $0x0001, PER_CPU_VAR(xen_vcpu_info + XEN_vcpu_info_pending)
 	jnz 1f
 	call check_events
 1:
diff --git a/init/Kconfig b/init/Kconfig
index 78cb2461012e..ccb1d8daf241 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1201,7 +1201,7 @@ config KALLSYMS_ALL
 config KALLSYMS_ABSOLUTE_PERCPU
 	bool
 	depends on KALLSYMS
-	default X86_64 && SMP
+	default X86_64 && SMP && !X86_PIE
 
 config KALLSYMS_BASE_RELATIVE
 	bool
-- 
2.15.0.rc0.271.g36b669edcc-goog
