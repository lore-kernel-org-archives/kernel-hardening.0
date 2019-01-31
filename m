From: Thomas Garnier <thgarnie@chromium.org>
Subject: [PATCH v6 20/27] x86: Support global stack cookie
Date: Thu, 31 Jan 2019 11:24:27 -0800
Message-Id: <20190131192533.34130-21-thgarnie@chromium.org>
In-Reply-To: <20190131192533.34130-1-thgarnie@chromium.org>
References: <20190131192533.34130-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com, Thomas Garnier <thgarnie@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Andy Lutomirski <luto@kernel.org>, Thomas Garnier <thgarnie@google.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Juergen Gross <jgross@suse.com>, Joerg Roedel <jroedel@suse.de>, Jia Zhang <qianyue.zj@alibaba-inc.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org
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

Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
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
index 0519da6f8ee4..263d81c570b2 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2221,6 +2221,18 @@ config RANDOMIZE_MEMORY_PHYSICAL_PADDING
 
 	   If unsure, leave at the default value.
 
+config X86_GLOBAL_STACKPROTECTOR
+	bool "Stack cookie using a global variable"
+	depends on CC_STACKPROTECTOR_AUTO
+	default n
+	help
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
index 76bc4dc03d5e..65d6d9a1dd22 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -132,6 +132,15 @@ else
         KBUILD_CFLAGS += -mcmodel=kernel
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
index d309f30cf7af..1a4abb98664b 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -655,7 +655,8 @@ ENTRY(__switch_to_asm)
 	movl	%esp, TASK_threadsp(%eax)
 	movl	TASK_threadsp(%edx), %esp
 
-#ifdef CONFIG_STACKPROTECTOR
+#if defined(CONFIG_STACKPROTECTOR) && \
+	!defined(CONFIG_X86_GLOBAL_STACKPROTECTOR)
 	movl	TASK_stack_canary(%edx), %ebx
 	movl	%ebx, PER_CPU_VAR(stack_canary)+stack_canary_offset
 #endif
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index fc15fe058d3c..1ae9c85241dc 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -296,7 +296,8 @@ ENTRY(__switch_to_asm)
 	movq	%rsp, TASK_threadsp(%rdi)
 	movq	TASK_threadsp(%rsi), %rsp
 
-#ifdef CONFIG_STACKPROTECTOR
+#if defined(CONFIG_STACKPROTECTOR) && \
+	!defined(CONFIG_X86_GLOBAL_STACKPROTECTOR)
 	movq	TASK_stack_canary(%rsi), %rbx
 	movq	%rbx, PER_CPU_VAR(irq_stack_union + stack_canary_offset)
 #endif
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 18f1e8269ad7..d322b1789d94 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -416,7 +416,8 @@ extern asmlinkage void ignore_sysret(void);
 void save_fsgs_for_kvm(void);
 #endif
 #else	/* X86_64 */
-#ifdef CONFIG_STACKPROTECTOR
+#if defined(CONFIG_STACKPROTECTOR) && \
+	!defined(CONFIG_X86_GLOBAL_STACKPROTECTOR)
 /*
  * Make sure stack canary segment base is cached-aligned:
  *   "For Intel Atom processors, avoid non zero segment base address
diff --git a/arch/x86/include/asm/stackprotector.h b/arch/x86/include/asm/stackprotector.h
index 8ec97a62c245..4e120cf36782 100644
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
index 168543d077d7..bd6d7beffc1c 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -33,7 +33,8 @@ static void __used common(void)
 {
 	BLANK();
 	OFFSET(TASK_threadsp, task_struct, thread.sp);
-#ifdef CONFIG_STACKPROTECTOR
+#if defined(CONFIG_STACKPROTECTOR) && \
+	!defined(CONFIG_X86_GLOBAL_STACKPROTECTOR)
 	OFFSET(TASK_stack_canary, task_struct, stack_canary);
 #endif
 
diff --git a/arch/x86/kernel/asm-offsets_32.c b/arch/x86/kernel/asm-offsets_32.c
index 82826f2275cc..775b0a7692f3 100644
--- a/arch/x86/kernel/asm-offsets_32.c
+++ b/arch/x86/kernel/asm-offsets_32.c
@@ -56,7 +56,8 @@ void foo(void)
 	       offsetof(struct cpu_entry_area, tss.x86_tss.sp1) -
 	       offsetofend(struct cpu_entry_area, entry_stack_page.stack));
 
-#ifdef CONFIG_STACKPROTECTOR
+#if defined(CONFIG_STACKPROTECTOR) && \
+	!defined(CONFIG_X86_GLOBAL_STACKPROTECTOR)
 	BLANK();
 	OFFSET(stack_canary_offset, stack_canary, canary);
 #endif
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index ddced33184b5..5bb1247afd6b 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -70,7 +70,8 @@ int main(void)
 	OFFSET(TSS_ist, tss_struct, x86_tss.ist);
 	BLANK();
 
-#ifdef CONFIG_STACKPROTECTOR
+#if defined(CONFIG_STACKPROTECTOR) && \
+	!defined(CONFIG_X86_GLOBAL_STACKPROTECTOR)
 	DEFINE(stack_canary_offset, offsetof(union irq_stack_union, stack_canary));
 	BLANK();
 #endif
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index cb28e98a0659..70aaf94fcf26 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1613,7 +1613,8 @@ DEFINE_PER_CPU(unsigned long, cpu_current_top_of_stack) =
 	(unsigned long)&init_thread_union + THREAD_SIZE;
 EXPORT_PER_CPU_SYMBOL(cpu_current_top_of_stack);
 
-#ifdef CONFIG_STACKPROTECTOR
+#if defined(CONFIG_STACKPROTECTOR) && \
+	!defined(CONFIG_X86_GLOBAL_STACKPROTECTOR)
 DEFINE_PER_CPU_ALIGNED(struct stack_canary, stack_canary);
 #endif
 
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 30f9cb2c0b55..6afa948d211a 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -375,7 +375,8 @@ ENDPROC(startup_32_smp)
  */
 __INIT
 setup_once:
-#ifdef CONFIG_STACKPROTECTOR
+#if defined(CONFIG_STACKPROTECTOR) && \
+	!defined(CONFIG_X86_GLOBAL_STACKPROTECTOR)
 	/*
 	 * Configure the stack canary. The linker can't handle this by
 	 * relocation.  Manually set base address in stack canary
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 90ae0ca51083..582113ffb011 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -90,6 +90,11 @@ EXPORT_PER_CPU_SYMBOL(cpu_tss_rw);
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
2.20.1.495.gaa96b0ce6b-goog
