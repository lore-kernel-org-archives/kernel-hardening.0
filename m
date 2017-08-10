From: Thomas Garnier <thgarnie@google.com>
Date: Thu, 10 Aug 2017 10:26:11 -0700
Message-Id: <20170810172615.51965-20-thgarnie@google.com>
In-Reply-To: <20170810172615.51965-1-thgarnie@google.com>
References: <20170810172615.51965-1-thgarnie@google.com>
Subject: [kernel-hardening] [RFC v2 19/23] x86: Support global stack cookie
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Garnier <thgarnie@google.com>, Matthias Kaehlcke <mka@chromium.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Tom Lendacky <thomas.lendacky@amd.com>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Brian Gerst <brgerst@gmail.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Chris Metcalf <cmetcalf@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Nicolas Pitre <nicolas.pitre@linaro.org>, Christopher Li <sparse@chrisli.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Lukas Wunner <lukas@wunner.de>, Mika Westerberg <mika.westerberg@linux.intel.com>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Markus Trippelsdorf <markus@trippelsdorf.de>, Steven Rostedt <rostedt@goodmis.org>, Kees Cook <keescook@chromium.org>, Rik van Riel <riel@redhat.com>, David Howells <dhowells@redhat.com>, Waiman Long <longman@redhat.com>, Kyle Huey <me@kylehuey.com>, Peter Foley <pefoley2@pefoley.com>, Tim Chen <tim.c.chen@linux.intel.com>, Catalin Marinas <catalin.marinas@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Michal Hocko <mhocko@suse.com>, Matthew Wilcox <mawilcox@microsoft.com>, "H . J . Lu" <hjl.tools@gmail.com>, Paul Bolle <pebolle@tiscali.nl>, Rob Landley <rob@landley.net>, Baoquan He <bhe@redhat.com>, Daniel Micay <danielmicay@gmail.com>
Cc: x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org, kvm@vger.kernel.org, linux-pm@vger.kernel.org, linux-arch@vger.kernel.org, linux-sparse@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Add an off-by-default configuration option to use a global stack cookie
instead of the default TLS. This configuration option will only be used
with PIE binaries.

For kernel stack cookie, the compiler uses the mcmodel=kernel to switch
between the fs segment to gs segment. A PIE binary does not use
mcmodel=kernel because it can be relocated anywhere, therefore the
compiler will default to the fs segment register. This is going to be
fixed with a compiler change allowing to pick the segment register as
done on PowerPC. In the meantime, this configuration can be used to
support older compilers.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/x86/Kconfig                      |  4 ++++
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
 12 files changed, 48 insertions(+), 13 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index da37ba375e63..2632fa8e8945 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2128,6 +2128,10 @@ config RANDOMIZE_MEMORY_PHYSICAL_PADDING
 
 	   If unsure, leave at the default value.
 
+config X86_GLOBAL_STACKPROTECTOR
+	bool
+	depends on CC_STACKPROTECTOR
+
 config HOTPLUG_CPU
 	bool "Support for hot-pluggable CPUs"
 	depends on SMP
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 1e902f926be3..66af2704f096 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -58,6 +58,15 @@ endif
 KBUILD_CFLAGS += -mno-sse -mno-mmx -mno-sse2 -mno-3dnow
 KBUILD_CFLAGS += $(call cc-option,-mno-avx,)
 
+ifdef CONFIG_X86_GLOBAL_STACKPROTECTOR
+        ifeq ($(call cc-option, -mstack-protector-guard=global),)
+                $(error Cannot use CONFIG_X86_GLOBAL_STACKPROTECTOR: \
+                        -mstack-protector-guard=global not supported \
+                        by compiler)
+        endif
+        KBUILD_CFLAGS += -mstack-protector-guard=global
+endif
+
 ifeq ($(CONFIG_X86_32),y)
         BITS := 32
         UTS_MACHINE := i386
diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index 48ef7bb32c42..91b4f2c4f837 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -237,7 +237,8 @@ ENTRY(__switch_to_asm)
 	movl	%esp, TASK_threadsp(%eax)
 	movl	TASK_threadsp(%edx), %esp
 
-#ifdef CONFIG_CC_STACKPROTECTOR
+#if defined(CONFIG_CC_STACKPROTECTOR) && \
+	!defined(CONFIG_X86_GLOBAL_STACKPROTECTOR)
 	movl	TASK_stack_canary(%edx), %ebx
 	movl	%ebx, PER_CPU_VAR(stack_canary)+stack_canary_offset
 #endif
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index c1f9b29d4c24..566380112a4f 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -395,7 +395,8 @@ ENTRY(__switch_to_asm)
 	movq	%rsp, TASK_threadsp(%rdi)
 	movq	TASK_threadsp(%rsi), %rsp
 
-#ifdef CONFIG_CC_STACKPROTECTOR
+#if defined(CONFIG_CC_STACKPROTECTOR) && \
+	!defined(CONFIG_X86_GLOBAL_STACKPROTECTOR)
 	movq	TASK_stack_canary(%rsi), %rbx
 	movq	%rbx, PER_CPU_VAR(irq_stack_union + stack_canary_offset)
 #endif
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 14fc21e2df08..842b3b5d5e36 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -394,7 +394,8 @@ DECLARE_PER_CPU(char *, irq_stack_ptr);
 DECLARE_PER_CPU(unsigned int, irq_count);
 extern asmlinkage void ignore_sysret(void);
 #else	/* X86_64 */
-#ifdef CONFIG_CC_STACKPROTECTOR
+#if defined(CONFIG_CC_STACKPROTECTOR) && \
+	defined(CONFIG_X86_GLOBAL_STACKPROTECTOR)
 /*
  * Make sure stack canary segment base is cached-aligned:
  *   "For Intel Atom processors, avoid non zero segment base address
diff --git a/arch/x86/include/asm/stackprotector.h b/arch/x86/include/asm/stackprotector.h
index 8abedf1d650e..66462d778dc5 100644
--- a/arch/x86/include/asm/stackprotector.h
+++ b/arch/x86/include/asm/stackprotector.h
@@ -51,6 +51,10 @@
 #define GDT_STACK_CANARY_INIT						\
 	[GDT_ENTRY_STACK_CANARY] = GDT_ENTRY_INIT(0x4090, 0, 0x18),
 
+#ifdef CONFIG_X86_GLOBAL_STACKPROTECTOR
+extern unsigned long __stack_chk_guard;
+#endif
+
 /*
  * Initialize the stackprotector canary value.
  *
@@ -62,7 +66,7 @@ static __always_inline void boot_init_stack_canary(void)
 	u64 canary;
 	u64 tsc;
 
-#ifdef CONFIG_X86_64
+#if defined(CONFIG_X86_64) && !defined(CONFIG_X86_GLOBAL_STACKPROTECTOR)
 	BUILD_BUG_ON(offsetof(union irq_stack_union, stack_canary) != 40);
 #endif
 	/*
@@ -76,17 +80,22 @@ static __always_inline void boot_init_stack_canary(void)
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
@@ -99,7 +108,7 @@ static inline void setup_stack_canary_segment(int cpu)
 
 static inline void load_stack_canary_segment(void)
 {
-#ifdef CONFIG_X86_32
+#if defined(CONFIG_X86_32) && !defined(CONFIG_X86_GLOBAL_STACKPROTECTOR)
 	asm("mov %0, %%gs" : : "r" (__KERNEL_STACK_CANARY) : "memory");
 #endif
 }
@@ -115,7 +124,7 @@ static inline void setup_stack_canary_segment(int cpu)
 
 static inline void load_stack_canary_segment(void)
 {
-#ifdef CONFIG_X86_32
+#if defined(CONFIG_X86_32) && !defined(CONFIG_X86_GLOBAL_STACKPROTECTOR)
 	asm volatile ("mov %0, %%gs" : : "r" (0));
 #endif
 }
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index de827d6ac8c2..b30a12cd021e 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -30,7 +30,8 @@
 void common(void) {
 	BLANK();
 	OFFSET(TASK_threadsp, task_struct, thread.sp);
-#ifdef CONFIG_CC_STACKPROTECTOR
+#if defined(CONFIG_CC_STACKPROTECTOR) && \
+	!defined(CONFIG_X86_GLOBAL_STACKPROTECTOR)
 	OFFSET(TASK_stack_canary, task_struct, stack_canary);
 #endif
 
diff --git a/arch/x86/kernel/asm-offsets_32.c b/arch/x86/kernel/asm-offsets_32.c
index 880aa093268d..9deb60866eab 100644
--- a/arch/x86/kernel/asm-offsets_32.c
+++ b/arch/x86/kernel/asm-offsets_32.c
@@ -57,7 +57,8 @@ void foo(void)
 	/* Size of SYSENTER_stack */
 	DEFINE(SIZEOF_SYSENTER_stack, sizeof(((struct tss_struct *)0)->SYSENTER_stack));
 
-#ifdef CONFIG_CC_STACKPROTECTOR
+#if defined(CONFIG_CC_STACKPROTECTOR) && \
+	!defined(CONFIG_X86_GLOBAL_STACKPROTECTOR)
 	BLANK();
 	OFFSET(stack_canary_offset, stack_canary, canary);
 #endif
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index 99332f550c48..297bcdfc520a 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -65,7 +65,8 @@ int main(void)
 	OFFSET(TSS_sp0, tss_struct, x86_tss.sp0);
 	BLANK();
 
-#ifdef CONFIG_CC_STACKPROTECTOR
+#if defined(CONFIG_CC_STACKPROTECTOR) && \
+	!defined(CONFIG_X86_GLOBAL_STACKPROTECTOR)
 	DEFINE(stack_canary_offset, offsetof(union irq_stack_union, stack_canary));
 	BLANK();
 #endif
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 31300767ec0f..9e8608fc10a4 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1454,7 +1454,8 @@ DEFINE_PER_CPU(unsigned long, cpu_current_top_of_stack) =
 	(unsigned long)&init_thread_union + THREAD_SIZE;
 EXPORT_PER_CPU_SYMBOL(cpu_current_top_of_stack);
 
-#ifdef CONFIG_CC_STACKPROTECTOR
+#if defined(CONFIG_CC_STACKPROTECTOR) && \
+	!defined(CONFIG_X86_GLOBAL_STACKPROTECTOR)
 DEFINE_PER_CPU_ALIGNED(struct stack_canary, stack_canary);
 #endif
 
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 0332664eb158..6989bfb0a628 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -411,7 +411,8 @@ setup_once:
 	addl $8,%edi
 	loop 2b
 
-#ifdef CONFIG_CC_STACKPROTECTOR
+#if defined(CONFIG_CC_STACKPROTECTOR) && \
+	!defined(CONFIG_X86_GLOBAL_STACKPROTECTOR)
 	/*
 	 * Configure the stack canary. The linker can't handle this by
 	 * relocation.  Manually set base address in stack canary
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index bd6b85fac666..66ea1a35413e 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -73,6 +73,11 @@ EXPORT_PER_CPU_SYMBOL(cpu_tss);
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
2.14.0.434.g98096fd7a8-goog
