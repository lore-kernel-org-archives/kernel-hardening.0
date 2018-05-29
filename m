From: Thomas Garnier <thgarnie@google.com>
Subject: [PATCH v4 20/27] x86: Support global stack cookie
Date: Tue, 29 May 2018 15:15:21 -0700
Message-Id: <20180529221625.33541-21-thgarnie@google.com>
In-Reply-To: <20180529221625.33541-1-thgarnie@google.com>
References: <20180529221625.33541-1-thgarnie@google.com>
To: kernel-hardening@lists.openwall.com
Cc: Thomas Garnier <thgarnie@google.com>, Skip Vitaly Kuznetsov <vkuznets@redhat.com>, Skip Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Skip Michael Kelley <mhkelley@outlook.com>, Skip Josh Poimboeuf <jpoimboe@redhat.com>, "Skip Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Skip Kees Cook <keescook@chromium.org>, Skip Tobias Klauser <tklauser@distanz.ch>, Skip Nadav Amit <namit@vmware.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Borislav Petkov <bp@alien8.de>, David Woodhouse <dwmw@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dave Hansen <dave.hansen@linux.intel.com>, Dominik Brodowski <linux@dominikbrodowski.net>, Kate Stewart <kstewart@linuxfoundation.org>, Rik van Riel <riel@redhat.com>, Philippe Ombredanne <pombredanne@nexb.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Juergen Gross <jgross@suse.com>, Jia Zhang <qianyue.zj@alibaba-inc.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Ricardo Neri <ricardo.neri-calderon@linux.intel.com>, Tom Lendacky <thomas.lendacky@amd.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Add an off-by-default configuration option to use a global stack cookie
instead of the default TLS. This configuration option will only be used
with PIE binaries.

For kernel stack cookie, the compiler uses the mcmodel=kernel to switch
between the fs segment to gs segment. A PIE binary does not use
mcmodel=kernel because it can be relocated anywhere, therefore the
compiler will default to the fs segment register. This is fixed on the
latest version of gcc.

If the segment selector is available, it will be automatically added. If
the automatic configuration was selected, a warning is written and the
global variable stack cookie is used. If a specific stack mode was
selected (regular or strong) and the compiler does not support selecting
the segment register, an error is emitted.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/x86/Kconfig                      | 12 ++++++++++++
 arch/x86/Makefile                     |  9 +++++++++
 arch/x86/entry/entry_32.S             |  3 ++-
 arch/x86/entry/entry_64.S             |  3 ++-
 arch/x86/include/asm/processor.h      |  3 ++-
 arch/x86/include/asm/stackprotector.h | 19 ++++++++++++++-----
 arch/x86/kernel/asm-offsets.c         |  3 ++-
 arch/x86/kernel/asm-offsets_32.c      |  3 ++-
 arch/x86/kernel/asm-offsets_64.c      |  3 ++-
 arch/x86/kernel/cpu/common.c          |  3 ++-
 arch/x86/kernel/head_32.S             |  3 ++-
 arch/x86/kernel/process.c             |  5 +++++
 12 files changed, 56 insertions(+), 13 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1434ec78e556..177e712201d1 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2198,6 +2198,18 @@ config RANDOMIZE_MEMORY_PHYSICAL_PADDING
 
 	   If unsure, leave at the default value.
 
+config X86_GLOBAL_STACKPROTECTOR
+	bool "Stack cookie using a global variable"
+	depends on CC_STACKPROTECTOR_AUTO
+	default n
+	---help---
+	   This option turns on the "stack-protector" GCC feature using a global
+	   variable instead of a segment register. It is useful when the
+	   compiler does not support custom segment registers when building a
+	   position independent (PIE) binary.
+
+	   If unsure, say N
+
 config HOTPLUG_CPU
 	bool "Support for hot-pluggable CPUs"
 	depends on SMP
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 60135cbd905c..277ffc57ae13 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -141,6 +141,15 @@ else
         KBUILD_CFLAGS += $(call cc-option,-funit-at-a-time)
 endif
 
+ifdef CONFIG_X86_GLOBAL_STACKPROTECTOR
+        ifeq ($(call cc-option, -mstack-protector-guard=global),)
+                $(error Cannot use CONFIG_X86_GLOBAL_STACKPROTECTOR: \
+                        -mstack-protector-guard=global not supported \
+                        by compiler)
+        endif
+        KBUILD_CFLAGS += -mstack-protector-guard=global
+endif
+
 ifdef CONFIG_X86_X32
 	x32_ld_ok := $(call try-run,\
 			/bin/echo -e '1: .quad 1b' | \
diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index bef8e2b202a8..b7d5bc710ae7 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -239,7 +239,8 @@ ENTRY(__switch_to_asm)
 	movl	%esp, TASK_threadsp(%eax)
 	movl	TASK_threadsp(%edx), %esp
 
-#ifdef CONFIG_CC_STACKPROTECTOR
+#if defined(CONFIG_CC_STACKPROTECTOR) && \
+	!defined(CONFIG_X86_GLOBAL_STACKPROTECTOR)
 	movl	TASK_stack_canary(%edx), %ebx
 	movl	%ebx, PER_CPU_VAR(stack_canary)+stack_canary_offset
 #endif
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index f9b42ca4bf60..a3d1ca4ec516 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -357,7 +357,8 @@ ENTRY(__switch_to_asm)
 	movq	%rsp, TASK_threadsp(%rdi)
 	movq	TASK_threadsp(%rsi), %rsp
 
-#ifdef CONFIG_CC_STACKPROTECTOR
+#if defined(CONFIG_CC_STACKPROTECTOR) && \
+	!defined(CONFIG_X86_GLOBAL_STACKPROTECTOR)
 	movq	TASK_stack_canary(%rsi), %rbx
 	movq	%rbx, PER_CPU_VAR(irq_stack_union + stack_canary_offset)
 #endif
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 8162b5a24d8c..566fa5c56148 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -414,7 +414,8 @@ extern asmlinkage void ignore_sysret(void);
 void save_fsgs_for_kvm(void);
 #endif
 #else	/* X86_64 */
-#ifdef CONFIG_CC_STACKPROTECTOR
+#if defined(CONFIG_CC_STACKPROTECTOR) && \
+	!defined(CONFIG_X86_GLOBAL_STACKPROTECTOR)
 /*
  * Make sure stack canary segment base is cached-aligned:
  *   "For Intel Atom processors, avoid non zero segment base address
diff --git a/arch/x86/include/asm/stackprotector.h b/arch/x86/include/asm/stackprotector.h
index 371b3a4af000..5063f57d99f5 100644
--- a/arch/x86/include/asm/stackprotector.h
+++ b/arch/x86/include/asm/stackprotector.h
@@ -52,6 +52,10 @@
 #define GDT_STACK_CANARY_INIT						\
 	[GDT_ENTRY_STACK_CANARY] = GDT_ENTRY_INIT(0x4090, 0, 0x18),
 
+#ifdef CONFIG_X86_GLOBAL_STACKPROTECTOR
+extern unsigned long __stack_chk_guard;
+#endif
+
 /*
  * Initialize the stackprotector canary value.
  *
@@ -63,7 +67,7 @@ static __always_inline void boot_init_stack_canary(void)
 	u64 canary;
 	u64 tsc;
 
-#ifdef CONFIG_X86_64
+#if defined(CONFIG_X86_64) && !defined(CONFIG_X86_GLOBAL_STACKPROTECTOR)
 	BUILD_BUG_ON(offsetof(union irq_stack_union, stack_canary) != 40);
 #endif
 	/*
@@ -77,17 +81,22 @@ static __always_inline void boot_init_stack_canary(void)
 	canary += tsc + (tsc << 32UL);
 	canary &= CANARY_MASK;
 
+#ifdef CONFIG_X86_GLOBAL_STACKPROTECTOR
+	if (__stack_chk_guard == 0)
+		__stack_chk_guard = canary ?: 1;
+#else /* !CONFIG_X86_GLOBAL_STACKPROTECTOR */
 	current->stack_canary = canary;
 #ifdef CONFIG_X86_64
 	this_cpu_write(irq_stack_union.stack_canary, canary);
-#else
+#else /* CONFIG_X86_32 */
 	this_cpu_write(stack_canary.canary, canary);
 #endif
+#endif
 }
 
 static inline void setup_stack_canary_segment(int cpu)
 {
-#ifdef CONFIG_X86_32
+#if defined(CONFIG_X86_32) && !defined(CONFIG_X86_GLOBAL_STACKPROTECTOR)
 	unsigned long canary = (unsigned long)&per_cpu(stack_canary, cpu);
 	struct desc_struct *gdt_table = get_cpu_gdt_rw(cpu);
 	struct desc_struct desc;
@@ -100,7 +109,7 @@ static inline void setup_stack_canary_segment(int cpu)
 
 static inline void load_stack_canary_segment(void)
 {
-#ifdef CONFIG_X86_32
+#if defined(CONFIG_X86_32) && !defined(CONFIG_X86_GLOBAL_STACKPROTECTOR)
 	asm("mov %0, %%gs" : : "r" (__KERNEL_STACK_CANARY) : "memory");
 #endif
 }
@@ -116,7 +125,7 @@ static inline void setup_stack_canary_segment(int cpu)
 
 static inline void load_stack_canary_segment(void)
 {
-#ifdef CONFIG_X86_32
+#if defined(CONFIG_X86_32) && !defined(CONFIG_X86_GLOBAL_STACKPROTECTOR)
 	asm volatile ("mov %0, %%gs" : : "r" (0));
 #endif
 }
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index 76417a9aab73..4c9e1b667bda 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -32,7 +32,8 @@
 void common(void) {
 	BLANK();
 	OFFSET(TASK_threadsp, task_struct, thread.sp);
-#ifdef CONFIG_CC_STACKPROTECTOR
+#if defined(CONFIG_CC_STACKPROTECTOR) && \
+	!defined(CONFIG_X86_GLOBAL_STACKPROTECTOR)
 	OFFSET(TASK_stack_canary, task_struct, stack_canary);
 #endif
 
diff --git a/arch/x86/kernel/asm-offsets_32.c b/arch/x86/kernel/asm-offsets_32.c
index f91ba53e06c8..cf8ef55a8b82 100644
--- a/arch/x86/kernel/asm-offsets_32.c
+++ b/arch/x86/kernel/asm-offsets_32.c
@@ -50,7 +50,8 @@ void foo(void)
 	DEFINE(TSS_sysenter_sp0, offsetof(struct cpu_entry_area, tss.x86_tss.sp0) -
 	       offsetofend(struct cpu_entry_area, entry_stack_page.stack));
 
-#ifdef CONFIG_CC_STACKPROTECTOR
+#if defined(CONFIG_CC_STACKPROTECTOR) && \
+	!defined(CONFIG_X86_GLOBAL_STACKPROTECTOR)
 	BLANK();
 	OFFSET(stack_canary_offset, stack_canary, canary);
 #endif
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index bf51e51d808d..a3c7e14f6434 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -69,7 +69,8 @@ int main(void)
 	OFFSET(TSS_sp1, tss_struct, x86_tss.sp1);
 	BLANK();
 
-#ifdef CONFIG_CC_STACKPROTECTOR
+#if defined(CONFIG_CC_STACKPROTECTOR) && \
+	!defined(CONFIG_X86_GLOBAL_STACKPROTECTOR)
 	DEFINE(stack_canary_offset, offsetof(union irq_stack_union, stack_canary));
 	BLANK();
 #endif
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index a7f5b4c81c68..4d7bd08f97d6 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1577,7 +1577,8 @@ DEFINE_PER_CPU(unsigned long, cpu_current_top_of_stack) =
 	(unsigned long)&init_thread_union + THREAD_SIZE;
 EXPORT_PER_CPU_SYMBOL(cpu_current_top_of_stack);
 
-#ifdef CONFIG_CC_STACKPROTECTOR
+#if defined(CONFIG_CC_STACKPROTECTOR) && \
+	!defined(CONFIG_X86_GLOBAL_STACKPROTECTOR)
 DEFINE_PER_CPU_ALIGNED(struct stack_canary, stack_canary);
 #endif
 
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index b59e4fb40fd9..0e849242de91 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -375,7 +375,8 @@ ENDPROC(startup_32_smp)
  */
 __INIT
 setup_once:
-#ifdef CONFIG_CC_STACKPROTECTOR
+#if defined(CONFIG_CC_STACKPROTECTOR) && \
+	!defined(CONFIG_X86_GLOBAL_STACKPROTECTOR)
 	/*
 	 * Configure the stack canary. The linker can't handle this by
 	 * relocation.  Manually set base address in stack canary
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 30ca2d1a9231..ace68dbfedf5 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -87,6 +87,11 @@ EXPORT_PER_CPU_SYMBOL(cpu_tss_rw);
 DEFINE_PER_CPU(bool, __tss_limit_invalid);
 EXPORT_PER_CPU_SYMBOL_GPL(__tss_limit_invalid);
 
+#ifdef CONFIG_X86_GLOBAL_STACKPROTECTOR
+unsigned long __stack_chk_guard __read_mostly;
+EXPORT_SYMBOL(__stack_chk_guard);
+#endif
+
 /*
  * this gets called so that we can store lazy state into memory and copy the
  * current task into the new thread.
-- 
2.17.0.921.gf22659ad46-goog
