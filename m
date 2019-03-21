From: Ruslan Nikolaev <nruslan_devel@yahoo.com>
Subject: [PATCH v2 02/02]: Support for PIC modules
Message-ID: <ce973664-08e5-20d2-46bf-1c3f58b1d5e3@yahoo.com>
Date: Wed, 20 Mar 2019 21:38:59 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: kernel-hardening@lists.openwall.com
Cc: thgarnie@google.com, x86@kernel.org, kstewart@linuxfoundation.org, gregkh@linuxfoundation.org, keescook@chromium.org, jpoimboe@redhat.com
List-ID: <kernel-hardening.lists.openwall.com>

The patchset extends the prior PIE kernel patch (by Thomas Garnier) to also
support position-independent modules that can be placed anywhere in the
48/64-bit address space (for better KASLR). The patch extends PIE v6.

The second part implements support for position-independent modules.

Signed-off-by: Ruslan Nikolaev <rnikola@vt.edu>
Signed-off-by: Hassan Nadeem <hnadeem@vt.edu>
---
  Makefile                              |    8
  arch/x86/Kconfig                      |   12 +
  arch/x86/Makefile                     |   11 +
  arch/x86/include/asm/alternative.h    |    6
  arch/x86/include/asm/arch_hweight.h   |    5
  arch/x86/include/asm/elf.h            |    3
  arch/x86/include/asm/jump_label.h     |    4
  arch/x86/include/asm/kvm_host.h       |   15 +
  arch/x86/include/asm/module.h         |   26 ++-
  arch/x86/include/asm/paravirt.h       |    2
  arch/x86/include/asm/paravirt_types.h |    9 -
  arch/x86/include/asm/percpu.h         |    8
  arch/x86/include/asm/uaccess.h        |   60 ++++++-
  arch/x86/include/asm/xen/hypercall.h  |   20 ++
  arch/x86/kernel/Makefile              |    3
  arch/x86/kernel/alternative.c         |   24 ++
  arch/x86/kernel/ftrace.c              |   14 -
  arch/x86/kernel/module-plt-stub.S     |   23 ++
  arch/x86/kernel/module.c              |  286 
++++++++++++++++++++++++++++++----
  arch/x86/kernel/module.lds            |    1
  arch/x86/kvm/emulate.c                |    1
  arch/x86/kvm/vmx/vmenter.S            |   15 +
  arch/x86/module-lib/Makefile          |    3
  arch/x86/module-lib/retpoline.S       |   47 +++++
  arch/x86/tools/relocs.c               |    4
  arch/x86/xen/xen-head.S               |    2
  scripts/Makefile.modpost              |    2
  scripts/recordmcount.c                |    3
  tools/objtool/check.c                 |   40 +++-
  29 files changed, 570 insertions(+), 87 deletions(-)

diff -uprN a/arch/x86/include/asm/alternative.h 
b/arch/x86/include/asm/alternative.h
--- a/arch/x86/include/asm/alternative.h	2019-03-16 10:50:57.097692208 -0400
+++ b/arch/x86/include/asm/alternative.h	2019-03-20 19:42:23.631815425 -0400
@@ -207,7 +207,7 @@ static inline int alternatives_text_rese

  /* Like alternative_io, but for replacing a direct call with another 
one. */
  #define alternative_call(oldfunc, newfunc, feature, output, input...)	\
-	asm volatile (ALTERNATIVE("call %P[old]", "call %P[new]", feature) \
+	asm volatile (ALTERNATIVE(_ASM_CALL(%p[old]), _ASM_CALL(%p[new]), 
feature) \
  		: output : [old] "X" (oldfunc), [new] "X" (newfunc), ## input)

  /*
@@ -218,8 +218,8 @@ static inline int alternatives_text_rese
   */
  #define alternative_call_2(oldfunc, newfunc1, feature1, newfunc2, 
feature2,   \
  			   output, input...)				      \
-	asm volatile (ALTERNATIVE_2("call %P[old]", "call %P[new1]", feature1,\
-		"call %P[new2]", feature2)				      \
+	asm volatile (ALTERNATIVE_2(_ASM_CALL(%p[old]), _ASM_CALL(%p[new1]), 
feature1,\
+		_ASM_CALL(%p[new2]), feature2)				      \
  		: output, ASM_CALL_CONSTRAINT				      \
  		: [old] "X" (oldfunc), [new1] "X" (newfunc1),		      \
  		  [new2] "X" (newfunc2), ## input)
diff -uprN a/arch/x86/include/asm/arch_hweight.h 
b/arch/x86/include/asm/arch_hweight.h
--- a/arch/x86/include/asm/arch_hweight.h	2019-03-13 17:01:32.000000000 
-0400
+++ b/arch/x86/include/asm/arch_hweight.h	2019-03-20 19:42:23.631815425 
-0400
@@ -3,6 +3,7 @@
  #define _ASM_X86_HWEIGHT_H

  #include <asm/cpufeatures.h>
+#include <asm/asm.h>

  #ifdef CONFIG_64BIT
  #define REG_IN "D"
@@ -18,7 +19,7 @@ static __always_inline unsigned int __ar
  {
  	unsigned int res;

-	asm (ALTERNATIVE("call __sw_hweight32", "popcntl %1, %0", 
X86_FEATURE_POPCNT)
+	asm (ALTERNATIVE(_ASM_CALL(__sw_hweight32), "popcntl %1, %0", 
X86_FEATURE_POPCNT)
  			 : "="REG_OUT (res)
  			 : REG_IN (w));

@@ -46,7 +47,7 @@ static __always_inline unsigned long __a
  {
  	unsigned long res;

-	asm (ALTERNATIVE("call __sw_hweight64", "popcntq %1, %0", 
X86_FEATURE_POPCNT)
+	asm (ALTERNATIVE(_ASM_CALL(__sw_hweight64), "popcntq %1, %0", 
X86_FEATURE_POPCNT)
  			 : "="REG_OUT (res)
  			 : REG_IN (w));

diff -uprN a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
--- a/arch/x86/include/asm/elf.h	2019-03-13 17:01:32.000000000 -0400
+++ b/arch/x86/include/asm/elf.h	2019-03-20 19:42:23.631815425 -0400
@@ -65,6 +65,9 @@ typedef struct user_fxsr_struct elf_fpxr
  #define R_X86_64_PC8		15	/* 8 bit sign extended pc relative */
  #define R_X86_64_PC64		24	/* Place relative 64-bit signed */

+#define R_X86_64_GOTPCRELX	41	/* Relaxed R_X86_64_GOTPCREL */
+#define R_X86_64_REX_GOTPCRELX	42	/* ... with the REX prefix */
+
  /*
   * These are used to set parameters in the core dumps.
   */
diff -uprN a/arch/x86/include/asm/jump_label.h 
b/arch/x86/include/asm/jump_label.h
--- a/arch/x86/include/asm/jump_label.h	2019-03-16 10:50:57.097692208 -0400
+++ b/arch/x86/include/asm/jump_label.h	2019-03-20 19:42:23.631815425 -0400
@@ -25,7 +25,7 @@ static __always_inline bool arch_static_
  		".pushsection __jump_table,  \"aw\" \n\t"
  		_ASM_ALIGN "\n\t"
  		".long 1b - ., %l[l_yes] - . \n\t"
-		_ASM_PTR "%P0 - .\n\t"
+		_ASM_PTR "%p0 - .\n\t"
  		".popsection \n\t"
  		: :  "X" (&((char *)key)[branch]) : : l_yes);

@@ -42,7 +42,7 @@ static __always_inline bool arch_static_
  		".pushsection __jump_table,  \"aw\" \n\t"
  		_ASM_ALIGN "\n\t"
  		".long 1b - ., %l[l_yes] - . \n\t"
-		_ASM_PTR "%P0 - .\n\t"
+		_ASM_PTR "%p0 - .\n\t"
  		".popsection \n\t"
  		: : "X" (&((char *)key)[branch]) : : l_yes);

diff -uprN a/arch/x86/include/asm/kvm_host.h 
b/arch/x86/include/asm/kvm_host.h
--- a/arch/x86/include/asm/kvm_host.h	2019-03-16 10:50:57.101692298 -0400
+++ b/arch/x86/include/asm/kvm_host.h	2019-03-20 19:42:23.631815425 -0400
@@ -1494,20 +1494,31 @@ enum {
   */
  asmlinkage void kvm_spurious_fault(void);

+#if defined(MODULE) && defined(CONFIG_X86_PIC)
+# define ____kvm_check_rebooting					\
+	"pushq %%rax \n\t"					\
+	"movq kvm_rebooting@GOTPCREL(%%rip), %%rax \n\t"	\
+	"cmpb $0, (%%rax) \n\t"					\
+	"popq %%rax \n\t"
+#else
+# define ____kvm_check_rebooting					\
+	"cmpb $0, kvm_rebooting" __ASM_SEL(,(%%rip)) " \n\t"
+#endif
+
  #define ____kvm_handle_fault_on_reboot(insn, cleanup_insn)	\
  	"666: " insn "\n\t" \
  	"668: \n\t"                           \
  	".pushsection .fixup, \"ax\" \n" \
  	"667: \n\t" \
  	cleanup_insn "\n\t"		      \
-	"cmpb $0, kvm_rebooting" __ASM_SEL(, (%%rip)) " \n\t" \
+	____kvm_check_rebooting \
  	"jne 668b \n\t"      		      \
  	__ASM_SIZE(push) "$0 \n\t"		\
  	__ASM_SIZE(push) "%%" _ASM_AX " \n\t"		\
  	_ASM_MOVABS " $666b, %%" _ASM_AX "\n\t"	\
  	_ASM_MOV " %%" _ASM_AX ", " __ASM_SEL(4, 8) "(%%" _ASM_SP ") \n\t" \
  	__ASM_SIZE(pop) "%%" _ASM_AX " \n\t"		\
-	"jmp kvm_spurious_fault \n\t"	      \
+	_ASM_JMP(kvm_spurious_fault) " \n\t"	      \
  	".popsection \n\t" \
  	_ASM_EXTABLE(666b, 667b)

diff -uprN a/arch/x86/include/asm/module.h b/arch/x86/include/asm/module.h
--- a/arch/x86/include/asm/module.h	2019-03-16 10:50:57.105692388 -0400
+++ b/arch/x86/include/asm/module.h	2019-03-20 19:42:23.631815425 -0400
@@ -5,13 +5,32 @@
  #include <asm-generic/module.h>
  #include <asm/orc_types.h>

-#ifdef CONFIG_X86_PIE
+extern const char __THUNK_FOR_PLT[];
+extern const unsigned int __THUNK_FOR_PLT_SIZE;
+
+#define PLT_ENTRY_ALIGNMENT	16
+struct plt_entry {
+#ifdef CONFIG_RETPOLINE
+	u8 mov_ins[3];
+	u32 rel_addr;
+	u8 thunk[0];
+#else
+	u16 jmp_ins;
+	u32 rel_addr;
+#endif
+} __packed __aligned(PLT_ENTRY_ALIGNMENT);
+
  struct mod_got_sec {
  	struct elf64_shdr	*got;
  	int			got_num_entries;
  	int			got_max_entries;
  };
-#endif
+
+struct mod_plt_sec {
+	struct elf64_shdr	*plt;
+	int			plt_num_entries;
+	int			plt_max_entries;
+};

  struct mod_arch_specific {
  #ifdef CONFIG_UNWINDER_ORC
@@ -19,9 +38,8 @@ struct mod_arch_specific {
  	int *orc_unwind_ip;
  	struct orc_entry *orc_unwind;
  #endif
-#ifdef CONFIG_X86_PIE
  	struct mod_got_sec	core;
-#endif
+	struct mod_plt_sec	core_plt;
  };

  #ifdef CONFIG_X86_64
diff -uprN a/arch/x86/include/asm/paravirt.h 
b/arch/x86/include/asm/paravirt.h
--- a/arch/x86/include/asm/paravirt.h	2019-03-13 17:01:32.000000000 -0400
+++ b/arch/x86/include/asm/paravirt.h	2019-03-20 19:42:23.631815425 -0400
@@ -741,7 +741,7 @@ bool __raw_callee_save___native_vcpu_is_
  	    PV_THUNK_NAME(func) ":"					\
  	    FRAME_BEGIN							\
  	    PV_SAVE_ALL_CALLER_REGS					\
-	    "call " #func ";"						\
+	    _ASM_CALL(func) ";"						\
  	    PV_RESTORE_ALL_CALLER_REGS					\
  	    FRAME_END							\
  	    "ret;"							\
diff -uprN a/arch/x86/include/asm/paravirt_types.h 
b/arch/x86/include/asm/paravirt_types.h
--- a/arch/x86/include/asm/paravirt_types.h	2019-03-16 
10:50:57.097692208 -0400
+++ b/arch/x86/include/asm/paravirt_types.h	2019-03-20 
19:42:23.631815425 -0400
@@ -342,7 +342,7 @@ extern struct paravirt_patch_template pv
  #define PARAVIRT_PATCH(x)					\
  	(offsetof(struct paravirt_patch_template, x) / sizeof(void *))

-#ifdef CONFIG_X86_PIE
+#if defined(CONFIG_X86_PIE) || (defined(MODULE) && defined(CONFIG_X86_PIC))
  #define paravirt_opptr_call "a"
  #define paravirt_opptr_type "p"
  #else
@@ -360,7 +360,11 @@ extern struct paravirt_patch_template pv
   * Generate some code, and mark it as patchable by the
   * apply_paravirt() alternate instruction patcher.
   */
-#define _paravirt_alt(insn_string, type, clobber)	\
+#if defined(MODULE) && defined(CONFIG_X86_PIC)
+# define _paravirt_alt(insn_string, type, clobber)	\
+	insn_string "\n"
+#else
+# define _paravirt_alt(insn_string, type, clobber)	\
  	"771:\n\t" insn_string "\n" "772:\n"		\
  	".pushsection .parainstructions,\"a\"\n"	\
  	_ASM_ALIGN "\n"					\
@@ -369,6 +373,7 @@ extern struct paravirt_patch_template pv
  	"  .byte 772b-771b\n"				\
  	"  .short " clobber "\n"			\
  	".popsection\n"
+#endif

  /* Generate patchable code, with the default asm parameters. */
  #define paravirt_alt(insn_string)					\
diff -uprN a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
--- a/arch/x86/include/asm/percpu.h	2019-03-16 10:50:57.097692208 -0400
+++ b/arch/x86/include/asm/percpu.h	2019-03-20 19:42:23.631815425 -0400
@@ -216,7 +216,7 @@ do {									\
  })

  /* Position Independent code uses relative addresses only */
-#ifdef CONFIG_X86_PIE
+#if defined(CONFIG_X86_PIE) || (defined(MODULE) && defined(CONFIG_X86_PIC))
  #define __percpu_stable_arg __percpu_arg(a1)
  #else
  #define __percpu_stable_arg __percpu_arg(P1)
@@ -502,6 +502,12 @@ do {									\
   * is not supported on early AMD64 processors so we must be able to 
emulate
   * it in software.  The address used in the cmpxchg16 instruction must be
   * aligned to a 16 byte boundary.
+ *
+ * ATTN: For PIC modules, it will not work due to the direct call.
+ * Technically, _ASM_CALL should be used here instead of 'call'. However,
+ * this will not work properly when RETPOLINE is enabled because %rax is
+ * clobbered. Luckily, this macro seems to be only used by mm/slub.c so
+ * far which cannot be compiled as a module.
   */
  #define percpu_cmpxchg16b_double(pcp1, pcp2, o1, o2, n1, n2)		\
  ({									\
diff -uprN a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
--- a/arch/x86/include/asm/uaccess.h	2019-03-13 17:01:32.000000000 -0400
+++ b/arch/x86/include/asm/uaccess.h	2019-03-20 19:42:23.631815425 -0400
@@ -11,6 +11,7 @@
  #include <asm/page.h>
  #include <asm/smap.h>
  #include <asm/extable.h>
+#include <asm/nospec-branch.h>

  /*
   * The fs value determines whether argument validity checking should be
@@ -165,13 +166,55 @@ __typeof__(__builtin_choose_expr(sizeof(
   * Clang/LLVM cares about the size of the register, but still wants
   * the base register for something that ends up being a pair.
   */
+#if defined(CONFIG_RETPOLINE) && defined(MODULE) && defined(CONFIG_X86_PIC)
+/*
+ * Handle specially for PIC modules when RETPOLINE is enabled
+ * to avoid %rax from being clobbered by the corresponding PLT stub.
+ */
+#define get_user(x, ptr)						\
+({									\
+	void *__target;							\
+	int __ret_gu;							\
+	register __inttype(*(ptr)) __val_gu asm("%"_ASM_DX);		\
+	__chk_user_ptr(ptr);						\
+	might_fault();							\
+	switch (sizeof(*(ptr))) {					\
+	case 1:								\
+		__target = &__get_user_1;				\
+		break;							\
+	case 2:								\
+		__target = &__get_user_2;				\
+		break;							\
+	case 4:								\
+		__target = &__get_user_4;				\
+		break;							\
+	case 8:								\
+		__target = &__get_user_8;				\
+		break;							\
+	default:							\
+		__target = &__get_user_bad;				\
+		break;							\
+	}								\
+	asm volatile(CALL_NOSPEC					\
+		     : "=a" (__ret_gu), "=r" (__val_gu),		\
+			ASM_CALL_CONSTRAINT				\
+		     : "0" (ptr), [thunk_target] "r" (__target));	\
+	(x) = (__force __typeof__(*(ptr))) __val_gu;			\
+	__builtin_expect(__ret_gu, 0);					\
+})
+
+#define __put_user_x(size, x, ptr, __ret_pu)				\
+	asm volatile(CALL_NOSPEC : "=a" (__ret_pu)			\
+		     : "0" ((typeof(*(ptr)))(x)), "c" (ptr),		\
+			[thunk_target] "r" (&__put_user_##size) : "ebx")
+#else
  #define get_user(x, ptr)						\
  ({									\
  	int __ret_gu;							\
  	register __inttype(*(ptr)) __val_gu asm("%"_ASM_DX);		\
  	__chk_user_ptr(ptr);						\
  	might_fault();							\
-	asm volatile("call __get_user_%P4"				\
+	asm volatile(_ASM_CALL(__get_user_%P4)				\
  		     : "=a" (__ret_gu), "=r" (__val_gu),		\
  			ASM_CALL_CONSTRAINT				\
  		     : "0" (ptr), "i" (sizeof(*(ptr))));		\
@@ -180,9 +223,9 @@ __typeof__(__builtin_choose_expr(sizeof(
  })

  #define __put_user_x(size, x, ptr, __ret_pu)			\
-	asm volatile("call __put_user_" #size : "=a" (__ret_pu)	\
+	asm volatile(_ASM_CALL(__put_user_##size) : "=a" (__ret_pu)	\
  		     : "0" ((typeof(*(ptr)))(x)), "c" (ptr) : "ebx")
-
+#endif


  #ifdef CONFIG_X86_32
@@ -204,9 +247,16 @@ __typeof__(__builtin_choose_expr(sizeof(
  		     _ASM_EXTABLE_EX(2b, 3b)				\
  		     : : "A" (x), "r" (addr))

+#if defined(CONFIG_RETPOLINE) && defined(MODULE) && defined(CONFIG_X86_PIC)
  #define __put_user_x8(x, ptr, __ret_pu)				\
-	asm volatile("call __put_user_8" : "=a" (__ret_pu)	\
+	asm volatile(CALL_NOSPEC : "=a" (__ret_pu)		\
+		     : "A" ((typeof(*(ptr)))(x)), "c" (ptr),	\
+			[thunk_target] "r" (&__put_user_8) : "ebx")
+#else
+#define __put_user_x8(x, ptr, __ret_pu)				\
+	asm volatile(_ASM_CALL(__put_user_8) : "=a" (__ret_pu)	\
  		     : "A" ((typeof(*(ptr)))(x)), "c" (ptr) : "ebx")
+#endif
  #else
  #define __put_user_goto_u64(x, ptr, label) \
  	__put_user_goto(x, ptr, "q", "", "er", label)
@@ -264,7 +314,7 @@ extern void __put_user_8(void);
  		__put_user_x8(__pu_val, ptr, __ret_pu);		\
  		break;						\
  	default:						\
-		__put_user_x(X, __pu_val, ptr, __ret_pu);	\
+		__put_user_x(bad, __pu_val, ptr, __ret_pu);	\
  		break;						\
  	}							\
  	__builtin_expect(__ret_pu, 0);				\
diff -uprN a/arch/x86/include/asm/xen/hypercall.h 
b/arch/x86/include/asm/xen/hypercall.h
--- a/arch/x86/include/asm/xen/hypercall.h	2019-03-13 17:01:32.000000000 
-0400
+++ b/arch/x86/include/asm/xen/hypercall.h	2019-03-20 19:42:23.631815425 
-0400
@@ -88,9 +88,25 @@ struct xen_dm_op_buf;

  extern struct { char _entry[32]; } hypercall_page[];

-#define __HYPERCALL		"call hypercall_page+%c[offset]"
-#define __HYPERCALL_ENTRY(x)						\
+#if defined(MODULE) && defined(CONFIG_X86_PIC)
+# define HYPERCALL(x)		long xen_hypercall_##x(void);
+# include <asm/xen-hypercalls.h>
+# undef HYPERCALL
+# ifdef CONFIG_RETPOLINE
+#  include <asm/nospec-branch.h>
+#  define __HYPERCALL		CALL_NOSPEC
+#  define __HYPERCALL_ENTRY(x)						\
+	[thunk_target] "a" (xen_hypercall_##x)
+# else
+#  define __HYPERCALL		"call *%p[name]@GOTPCREL(%%rip)"
+#  define __HYPERCALL_ENTRY(x)						\
+	[name] "X" (xen_hypercall_##x)
+# endif
+#else
+# define __HYPERCALL		"call hypercall_page+%c[offset]"
+# define __HYPERCALL_ENTRY(x)						\
  	[offset] "i" (__HYPERVISOR_##x * sizeof(hypercall_page[0]))
+#endif

  #ifdef CONFIG_X86_32
  #define __HYPERCALL_RETREG	"eax"
diff -uprN a/arch/x86/Kconfig b/arch/x86/Kconfig
--- a/arch/x86/Kconfig	2019-03-16 10:50:57.109692478 -0400
+++ b/arch/x86/Kconfig	2019-03-20 19:42:23.631815425 -0400
@@ -2244,9 +2244,19 @@ config X86_PIE
  	select DYNAMIC_MODULE_BASE
  	select MODULE_REL_CRCS if MODVERSIONS

+config X86_PIC
+	bool
+	prompt "Enable PIC modules"
+	depends on X86_64
+	default y
+	select MODULE_REL_CRCS if MODVERSIONS
+	---help---
+	  Compile position-independent modules which can
+	  be placed anywhere in the 64-bit address space.
+
  config RANDOMIZE_BASE_LARGE
  	bool "Increase the randomization range of the kernel image"
-	depends on X86_64 && RANDOMIZE_BASE
+	depends on X86_64 && RANDOMIZE_BASE && X86_PIC
  	select X86_PIE
  	select X86_MODULE_PLTS if MODULES
  	default n
diff -uprN a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
--- a/arch/x86/kernel/alternative.c	2019-03-13 17:01:32.000000000 -0400
+++ b/arch/x86/kernel/alternative.c	2019-03-20 19:42:23.635815466 -0400
@@ -280,13 +280,14 @@ recompute_jump(struct alt_instr *a, u8 *
  	s32 n_dspl, o_dspl;
  	int repl_len;

-	if (a->replacementlen != 5)
+	if (a->replacementlen != 5 && !(a->replacementlen == 6
+			&& repl_insn[5] == 0x90)) /* NOP padded */
  		return;

  	o_dspl = *(s32 *)(insnbuf + 1);

  	/* next_rip of the replacement JMP */
-	next_rip = repl_insn + a->replacementlen;
+	next_rip = repl_insn + 5;
  	/* target rip of the replacement JMP */
  	tgt_rip  = next_rip + o_dspl;
  	n_dspl = tgt_rip - orig_insn;
@@ -311,7 +312,7 @@ two_byte_jmp:

  	insnbuf[0] = 0xeb;
  	insnbuf[1] = (s8)n_dspl;
-	add_nops(insnbuf + 2, 3);
+	add_nops(insnbuf + 2, a->replacementlen - 2);

  	repl_len = 2;
  	goto done;
@@ -321,6 +322,7 @@ five_byte_jmp:

  	insnbuf[0] = 0xe9;
  	*(s32 *)&insnbuf[1] = n_dspl;
+	add_nops(insnbuf + 5, a->replacementlen - 5);

  	repl_len = 5;

@@ -406,16 +408,28 @@ void __init_or_module noinline apply_alt
  		insnbuf_sz = a->replacementlen;

  		/*
-		 * 0xe8 is a relative jump; fix the offset.
+		 * 0xe8 is a relative CALL, fix the offset;
+		 * also support the NOP padding for relaxed relocations.
+		 *
+		 * 0xff 0x15 and 0xff 0x25 are CALL/JMPs which use
+		 * RIP-relative addresses; fix the offset for them as well.
  		 *
  		 * Instruction length is checked before the opcode to avoid
  		 * accessing uninitialized bytes for zero-length replacements.
  		 */
-		if (a->replacementlen == 5 && *insnbuf == 0xe8) {
+		if ((a->replacementlen == 5 && insnbuf[0] == 0xe8) ||
+			(a->replacementlen == 6 && insnbuf[0] == 0xe8
+                                && insnbuf[5] == 0x90)) { /* NOP padded */
  			*(s32 *)(insnbuf + 1) += replacement - instr;
  			DPRINTK("Fix CALL offset: 0x%x, CALL 0x%lx",
  				*(s32 *)(insnbuf + 1),
  				(unsigned long)instr + *(s32 *)(insnbuf + 1) + 5);
+		} else if (a->replacementlen == 6 && insnbuf[0] == 0xff &&
+				(insnbuf[1] == 0x15 || insnbuf[1] == 0x25)) {
+			*(s32 *)(insnbuf + 2) += replacement - instr;
+			DPRINTK("Fix CALL/JMP(RIP) offset: 0x%x, CALL/JMP(RIP) 0x%lx",
+				*(s32 *)(insnbuf + 2),
+				(unsigned long)instr + *(s32 *)(insnbuf + 2) + 6);
  		}

  		if (a->replacementlen && is_jmp(replacement[0]))
diff -uprN a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
--- a/arch/x86/kernel/ftrace.c	2019-03-16 10:50:57.105692388 -0400
+++ b/arch/x86/kernel/ftrace.c	2019-03-20 19:42:23.635815466 -0400
@@ -144,13 +144,6 @@ ftrace_modify_initial_code(unsigned long
  {
  	unsigned char replaced[MCOUNT_INSN_SIZE + 1];

-	/*
-	 * If PIE is not enabled default to the original approach to code
-	 * modification.
-	 */
-	if (!IS_ENABLED(CONFIG_X86_PIE))
-		return ftrace_modify_code_direct(ip, old_code, new_code);
-
  	ftrace_expected = old_code;

  	/* Ensure the instructions point to a call to the GOT */
@@ -159,9 +152,12 @@ ftrace_modify_initial_code(unsigned long
  		return -EFAULT;
  	}

+	/*
+	 * For non-PIC code, default to the original approach to code
+	 * modification.
+	 */
  	if (memcmp(replaced, got_call_preinsn, sizeof(got_call_preinsn))) {
-		WARN_ONCE(1, "invalid function call");
-		return -EINVAL;
+		return ftrace_modify_code_direct(ip, old_code, new_code);
  	}

  	/*
diff -uprN a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
--- a/arch/x86/kernel/Makefile	2019-03-16 10:50:57.097692208 -0400
+++ b/arch/x86/kernel/Makefile	2019-03-20 19:42:23.635815466 -0400
@@ -105,7 +105,8 @@ obj-$(CONFIG_KEXEC_CORE)	+= relocate_ker
  obj-$(CONFIG_KEXEC_FILE)	+= kexec-bzimage64.o
  obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
  obj-y				+= kprobes/
-obj-$(CONFIG_MODULES)		+= module.o
+obj-$(CONFIG_MODULES)		+= module.o module-plt-stub.o
+OBJECT_FILES_NON_STANDARD_module-plt-stub.o := y
  obj-$(CONFIG_DOUBLEFAULT)	+= doublefault.o
  obj-$(CONFIG_KGDB)		+= kgdb.o
  obj-$(CONFIG_VM86)		+= vm86_32.o
diff -uprN a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
--- a/arch/x86/kernel/module.c	2019-03-16 10:50:57.105692388 -0400
+++ b/arch/x86/kernel/module.c	2019-03-20 19:42:23.635815466 -0400
@@ -37,6 +37,9 @@
  #include <asm/pgtable.h>
  #include <asm/setup.h>
  #include <asm/unwind.h>
+#include <asm/insn.h>
+
+static unsigned int module_plt_size;

  #if 0
  #define DEBUGP(fmt, ...)				\
@@ -90,6 +93,17 @@ static u64 find_got_kernel_entry(Elf64_S

  	return 0;
  }
+#else
+static u64 find_got_kernel_entry(Elf64_Sym *sym, const Elf64_Rela *rela)
+{
+	return 0;
+}
+#endif
+
+static inline bool is_local_symbol(Elf64_Sym *sym)
+{
+	return sym->st_shndx != SHN_UNDEF;
+}

  static u64 module_emit_got_entry(struct module *mod, void *loc,
  				 const Elf64_Rela *rela, Elf64_Sym *sym)
@@ -111,7 +125,7 @@ static u64 module_emit_got_entry(struct
  	 * relocations are sorted, this will be the last entry we allocated.
  	 * (if one exists).
  	 */
-	if (i > 0 && got[i] == got[i - 2]) {
+	if (i > 0 && got[i] == got[i - 1]) {
  		ret = (u64)&got[i - 1];
  	} else {
  		gotsec->got_num_entries++;
@@ -119,7 +133,52 @@ static u64 module_emit_got_entry(struct
  		ret = (u64)&got[i];
  	}

-	return ret + rela->r_addend;
+	return ret;
+}
+
+static bool plt_entries_equal(const struct plt_entry *a,
+				     const struct plt_entry *b)
+{
+	void *a_val, *b_val;
+
+	a_val = (void *)a + (s64)a->rel_addr;
+	b_val = (void *)b + (s64)b->rel_addr;
+
+	return a_val == b_val;
+}
+
+static void get_plt_entry(struct plt_entry *plt_entry, struct module *mod,
+		void *loc, const Elf64_Rela *rela, Elf64_Sym *sym)
+{
+	u64 abs_val = module_emit_got_entry(mod, loc, rela, sym);
+	u32 rel_val = abs_val - (u64)&plt_entry->rel_addr
+			- sizeof(plt_entry->rel_addr);
+
+	memcpy(plt_entry, __THUNK_FOR_PLT, __THUNK_FOR_PLT_SIZE);
+	plt_entry->rel_addr = rel_val;
+}
+
+static u64 module_emit_plt_entry(struct module *mod, void *loc,
+				 const Elf64_Rela *rela, Elf64_Sym *sym)
+{
+	struct mod_plt_sec *pltsec = &mod->arch.core_plt;
+	int i = pltsec->plt_num_entries;
+	void *plt = (void *)pltsec->plt->sh_addr + (u64)i * module_plt_size;
+
+	get_plt_entry(plt, mod, loc, rela, sym);
+
+	/*
+	 * Check if the entry we just created is a duplicate. Given that the
+	 * relocations are sorted, this will be the last entry we allocated.
+	 * (if one exists).
+	 */
+	if (i > 0 && plt_entries_equal(plt, plt - module_plt_size))
+		return (u64)(plt - module_plt_size);
+
+	pltsec->plt_num_entries++;
+	BUG_ON(pltsec->plt_num_entries > pltsec->plt_max_entries);
+
+	return (u64)plt;
  }

  #define cmp_3way(a, b)	((a) < (b) ? -1 : (a) > (b))
@@ -148,14 +207,17 @@ static bool duplicate_rel(const Elf64_Re
  	return num > 0 && cmp_rela(rela + num, rela + num - 1) == 0;
  }

-static unsigned int count_gots(Elf64_Sym *syms, Elf64_Rela *rela, int num)
+static void count_gots_plts(unsigned long *num_got, unsigned long *num_plt,
+		Elf64_Sym *syms, Elf64_Rela *rela, int num)
  {
-	unsigned int ret = 0;
  	Elf64_Sym *s;
  	int i;

  	for (i = 0; i < num; i++) {
  		switch (ELF64_R_TYPE(rela[i].r_info)) {
+		case R_X86_64_PLT32:
+		case R_X86_64_REX_GOTPCRELX:
+		case R_X86_64_GOTPCRELX:
  		case R_X86_64_GOTPCREL:
  			s = syms + ELF64_R_SYM(rela[i].r_info);

@@ -164,12 +226,132 @@ static unsigned int count_gots(Elf64_Sym
  			 * custom one for this module.
  			 */
  			if (!duplicate_rel(rela, i) &&
-			    !find_got_kernel_entry(s, rela + i))
-				ret++;
+			    !find_got_kernel_entry(s, rela + i)) {
+				(*num_got)++;
+				if (ELF64_R_TYPE(rela[i].r_info) ==
+				    R_X86_64_PLT32 && !is_local_symbol(s))
+					(*num_plt)++;
+			}
  			break;
  		}
  	}
-	return ret;
+}
+
+
+/*
+ * call *foo@GOTPCREL(%rip) ---> call foo nop
+ * jmp *foo@GOTPCREL(%rip)  ---> jmp foo nop
+ */
+static int do_relax_GOTPCRELX(Elf64_Rela *rel, void *loc)
+{
+	struct insn insn;
+	void *ins_addr = loc - 2;
+
+	kernel_insn_init(&insn, ins_addr, MAX_INSN_SIZE);
+	insn_get_length(&insn);
+
+	/* 1 byte for opcode, 1 byte for modrm, 4 bytes for m32 */
+	if (insn.length != 6 || insn.opcode.value != 0xFF)
+		return -1;
+
+	switch (insn.modrm.value) {
+	case 0x15: /* CALL */
+		*(u8 *)ins_addr = 0xe8;
+		break;
+	case 0x25: /* JMP */
+		*(u8 *)ins_addr = 0xe9;
+		break;
+	default:
+		return -1;
+	}
+	memset(ins_addr + 1, 0, 4);
+	*((u8 *)ins_addr + 5) = 0x90; /* NOP */
+
+	/* Update the relocation */
+	rel->r_info &= ~ELF64_R_TYPE(~0LU);
+	rel->r_info |= R_X86_64_PC32;
+	rel->r_offset--;
+
+	return 0;
+}
+
+
+/*
+ * mov foo@GOTPCREL(%rip), %reg ---> lea foo(%rip), %reg
+ * */
+static int do_relax_REX_GOTPCRELX(Elf64_Rela *rel, void *loc)
+{
+	struct insn insn;
+	void *ins_addr = loc - 3;
+
+	kernel_insn_init(&insn, ins_addr, MAX_INSN_SIZE);
+	insn_get_length(&insn);
+
+	/* 1 byte for REX, 1 byte for opcode, 1 byte for modrm,
+	 * 4 bytes for m32.
+	 */
+	if (insn.length != 7)
+		return -1;
+
+	/* Not the MOV instruction, could be ADD, SUB etc. */
+	if (insn.opcode.value != 0x8b)
+		return 0;
+	*((u8 *)ins_addr + 1) = 0x8d; /* LEA */
+
+	/* Update the relocation. */
+	rel->r_info &= ~ELF64_R_TYPE(~0LU);
+	rel->r_info |= R_X86_64_PC32;
+
+	return 0;
+}
+
+static int apply_relaxations(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
+			     struct module *mod)
+{
+	Elf64_Sym *syms = NULL;
+	int i, j;
+
+	for (i = 0; i < ehdr->e_shnum; i++) {
+		if (sechdrs[i].sh_type == SHT_SYMTAB)
+			syms = (Elf64_Sym *)sechdrs[i].sh_addr;
+	}
+
+	if (!syms) {
+		pr_err("%s: module symtab section missing\n", mod->name);
+		return -ENOEXEC;
+	}
+
+	for (i = 0; i < ehdr->e_shnum; i++) {
+		Elf64_Rela *rels = (void *)ehdr + sechdrs[i].sh_offset;
+
+		if (sechdrs[i].sh_type != SHT_RELA)
+			continue;
+
+		for (j = 0; j < sechdrs[i].sh_size / sizeof(*rels); j++) {
+			Elf64_Rela *rel = &rels[j];
+			Elf64_Sym *sym = &syms[ELF64_R_SYM(rel->r_info)];
+			void *loc = (void *)sechdrs[sechdrs[i].sh_info].sh_addr
+					+ rel->r_offset;
+
+			if (is_local_symbol(sym)) {
+				switch (ELF64_R_TYPE(rel->r_info)) {
+				case R_X86_64_GOTPCRELX:
+					if (do_relax_GOTPCRELX(rel, loc))
+						BUG();
+					break;
+				case R_X86_64_REX_GOTPCRELX:
+					if (do_relax_REX_GOTPCRELX(rel, loc))
+						BUG();
+					break;
+				case R_X86_64_GOTPCREL:
+					/* cannot be relaxed, ignore it */
+					break;
+				}
+			}
+		}
+	}
+
+	return 0;
  }

  /*
@@ -179,29 +361,42 @@ static unsigned int count_gots(Elf64_Sym
  int module_frob_arch_sections(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
  			      char *secstrings, struct module *mod)
  {
-	unsigned long gots = 0;
+	unsigned long num_got = 0;
+	unsigned long num_plt = 0;
  	Elf_Shdr *symtab = NULL;
  	Elf64_Sym *syms = NULL;
  	char *strings, *name;
-	int i;
+	int i, got_idx = -1;
+
+	apply_relaxations(ehdr, sechdrs, mod);

  	/*
-	 * Find the empty .got section so we can expand it to store the PLT
-	 * entries. Record the symtab address as well.
+	 * Find the empty .got and .plt sections so we can expand it
+	 * to store the GOT and PLT entries.
+	 * Record the symtab address as well.
  	 */
  	for (i = 0; i < ehdr->e_shnum; i++) {
  		if (!strcmp(secstrings + sechdrs[i].sh_name, ".got")) {
-			mod->arch.core.got = sechdrs + i;
+			got_idx = i;
+		} else if (!strcmp(secstrings + sechdrs[i].sh_name, ".plt")) {
+			mod->arch.core_plt.plt = sechdrs + i;
  		} else if (sechdrs[i].sh_type == SHT_SYMTAB) {
  			symtab = sechdrs + i;
  			syms = (Elf64_Sym *)symtab->sh_addr;
  		}
  	}

-	if (!mod->arch.core.got) {
+	if (got_idx < 0) {
  		pr_err("%s: module GOT section missing\n", mod->name);
  		return -ENOEXEC;
  	}
+
+	mod->arch.core.got = sechdrs + got_idx;
+
+	if (!mod->arch.core_plt.plt) {
+		pr_err("%s: module PLT section missing\n", mod->name);
+		return -ENOEXEC;
+	}
  	if (!syms) {
  		pr_err("%s: module symtab section missing\n", mod->name);
  		return -ENOEXEC;
@@ -217,33 +412,36 @@ int module_frob_arch_sections(Elf_Ehdr *
  		/* sort by type, symbol index and addend */
  		sort(rels, numrels, sizeof(Elf64_Rela), cmp_rela, NULL);

-		gots += count_gots(syms, rels, numrels);
+		count_gots_plts(&num_got, &num_plt, syms, rels, numrels);
  	}

  	mod->arch.core.got->sh_type = SHT_NOBITS;
  	mod->arch.core.got->sh_flags = SHF_ALLOC;
  	mod->arch.core.got->sh_addralign = L1_CACHE_BYTES;
-	mod->arch.core.got->sh_size = (gots + 1) * sizeof(u64);
+	mod->arch.core.got->sh_size = (num_got + 1) * sizeof(u64);
  	mod->arch.core.got_num_entries = 0;
-	mod->arch.core.got_max_entries = gots;
+	mod->arch.core.got_max_entries = num_got;
+
+	module_plt_size = ALIGN(__THUNK_FOR_PLT_SIZE, PLT_ENTRY_ALIGNMENT);
+	mod->arch.core_plt.plt->sh_type = SHT_NOBITS;
+	mod->arch.core_plt.plt->sh_flags = SHF_EXECINSTR | SHF_ALLOC;
+	mod->arch.core_plt.plt->sh_addralign = L1_CACHE_BYTES;
+	mod->arch.core_plt.plt->sh_size = (num_plt + 1) * module_plt_size;
+	mod->arch.core_plt.plt_num_entries = 0;
+	mod->arch.core_plt.plt_max_entries = num_plt;

-	/*
-	 * If a _GLOBAL_OFFSET_TABLE_ symbol exists, make it absolute for
-	 * modules to correctly reference it. Similar to s390 implementation.
-	 */
  	strings = (void *) ehdr + sechdrs[symtab->sh_link].sh_offset;
  	for (i = 0; i < symtab->sh_size/sizeof(Elf_Sym); i++) {
  		if (syms[i].st_shndx != SHN_UNDEF)
  			continue;
  		name = strings + syms[i].st_name;
  		if (!strcmp(name, "_GLOBAL_OFFSET_TABLE_")) {
-			syms[i].st_shndx = SHN_ABS;
+			syms[i].st_shndx = got_idx;
  			break;
  		}
  	}
  	return 0;
  }
-#endif

  void *module_alloc(unsigned long size)
  {
@@ -306,6 +504,29 @@ int apply_relocate(Elf32_Shdr *sechdrs,
  	return 0;
  }
  #else /*X86_64*/
+
+int check_relocation_pic_safe(Elf64_Rela *rel, Elf64_Sym *sym,
+		   const char *strtab, struct module *mod)
+{
+	bool isLocalSym = is_local_symbol(sym);
+
+	switch (ELF64_R_TYPE(rel->r_info)) {
+	case R_X86_64_32:
+	case R_X86_64_32S:
+	case R_X86_64_PC32:
+		if (!isLocalSym)
+			goto fail;
+		break;
+	}
+
+	return 0;
+
+fail:
+	pr_err("Non PIC Relocation in `%s', relocation type %d, symbol %s\n",
+		mod->name, (int)ELF64_R_TYPE(rel->r_info), &strtab[sym->st_name]);
+	return -1;
+}
+
  int apply_relocate_add(Elf64_Shdr *sechdrs,
  		   const char *strtab,
  		   unsigned int symindex,
@@ -330,6 +551,10 @@ int apply_relocate_add(Elf64_Shdr *sechd
  		sym = (Elf64_Sym *)sechdrs[symindex].sh_addr
  			+ ELF64_R_SYM(rel[i].r_info);

+#ifdef CONFIG_X86_PIC
+		BUG_ON(check_relocation_pic_safe(&rel[i], sym, strtab, me));
+#endif
+
  		DEBUGP("type %d st_value %Lx r_addend %Lx loc %Lx\n",
  		       (int)ELF64_R_TYPE(rel[i].r_info),
  		       sym->st_value, rel[i].r_addend, (u64)loc);
@@ -358,18 +583,25 @@ int apply_relocate_add(Elf64_Shdr *sechd
  			if ((s64)val != *(s32 *)loc)
  				goto overflow;
  			break;
-#ifdef CONFIG_X86_PIE
+		case R_X86_64_PLT32:
+			if (!is_local_symbol(sym))
+				val = module_emit_plt_entry(me, loc, rel + i,
+					sym) + rel[i].r_addend;
+			goto pc32_reloc;
+		case R_X86_64_REX_GOTPCRELX:
+		case R_X86_64_GOTPCRELX:
  		case R_X86_64_GOTPCREL:
-			val = module_emit_got_entry(me, loc, rel + i, sym);
+			val = module_emit_got_entry(me, loc, rel + i, sym)
+				+ rel[i].r_addend;
  			/* fallthrough */
-#endif
  		case R_X86_64_PC32:
-		case R_X86_64_PLT32:
+pc32_reloc:
  			if (*(u32 *)loc != 0)
  				goto invalid_relocation;
  			val -= (u64)loc;
  			*(u32 *)loc = val;
-			if (IS_ENABLED(CONFIG_X86_PIE) &&
+			if ((IS_ENABLED(CONFIG_X86_PIE) ||
+				IS_ENABLED(CONFIG_X86_PIC)) &&
  			    (s64)val != *(s32 *)loc)
  				goto overflow;
  			break;
diff -uprN a/arch/x86/kernel/module.lds b/arch/x86/kernel/module.lds
--- a/arch/x86/kernel/module.lds	2019-03-16 10:50:57.105692388 -0400
+++ b/arch/x86/kernel/module.lds	2019-03-20 19:42:23.635815466 -0400
@@ -1,3 +1,4 @@
  SECTIONS {
  	.got (NOLOAD) : { BYTE(0) }
+	.plt (NOLOAD) : { BYTE(0) }
  }
diff -uprN a/arch/x86/kernel/module-plt-stub.S 
b/arch/x86/kernel/module-plt-stub.S
--- a/arch/x86/kernel/module-plt-stub.S	1969-12-31 19:00:00.000000000 -0500
+++ b/arch/x86/kernel/module-plt-stub.S	2019-03-20 19:42:23.635815466 -0400
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#include <linux/stringify.h>
+#include <linux/linkage.h>
+#include <asm/dwarf2.h>
+#include <asm/cpufeatures.h>
+#include <asm/alternative-asm.h>
+#include <asm/export.h>
+#include <asm/nospec-branch.h>
+
+/* The following code is used for PLT generation only
+   and should never be executed directly. */
+.section .rodata
+.globl __THUNK_FOR_PLT
+.globl __THUNK_FOR_PLT_SIZE
+__THUNK_FOR_PLT:
+#ifdef CONFIG_RETPOLINE
+	movq 0(%rip), %rax
+	JMP_NOSPEC %rax
+#else
+	jmpq   *0(%rip)
+#endif
+__THUNK_FOR_PLT_SIZE: .long . - __THUNK_FOR_PLT
diff -uprN a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
--- a/arch/x86/kvm/emulate.c	2019-03-13 17:01:32.000000000 -0400
+++ b/arch/x86/kvm/emulate.c	2019-03-20 19:42:23.635815466 -0400
@@ -428,7 +428,6 @@ static int fastop(struct x86_emulate_ctx
  	FOP_RET

  asm(".pushsection .fixup, \"ax\"\n"
-    ".global kvm_fastop_exception \n"
      "kvm_fastop_exception: xor %esi, %esi; ret\n"
      ".popsection");

diff -uprN a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
--- a/arch/x86/kvm/vmx/vmenter.S	2019-03-13 17:01:32.000000000 -0400
+++ b/arch/x86/kvm/vmx/vmenter.S	2019-03-20 19:42:23.635815466 -0400
@@ -18,6 +18,17 @@
   * they VM-Fail, whereas a successful VM-Enter + VM-Exit will jump
   * to vmx_vmexit.
   */
+#if defined(MODULE) && defined(CONFIG_X86_PIC)
+# define ____kvm_check_rebooting			\
+	pushq %rax;					\
+	movq kvm_rebooting@GOTPCREL(%rip), %rax;	\
+	cmpb $0, (%rax);				\
+	popq %rax
+#else
+# define ____kvm_check_rebooting			\
+	cmpb $0, kvm_rebooting(%rip)
+#endif
+
  ENTRY(vmx_vmenter)
  	/* EFLAGS.ZF is set if VMCS.LAUNCHED == 0 */
  	je 2f
@@ -28,9 +39,9 @@ ENTRY(vmx_vmenter)
  2:	vmlaunch
  	ret

-3:	cmpb $0, kvm_rebooting
+3:	____kvm_check_rebooting
  	jne 4f
-	call kvm_spurious_fault
+	_ASM_CALL(kvm_spurious_fault)
  4:	ret

  	.pushsection .fixup, "ax"
diff -uprN a/arch/x86/Makefile b/arch/x86/Makefile
--- a/arch/x86/Makefile	2019-03-16 10:50:57.109692478 -0400
+++ b/arch/x86/Makefile	2019-03-20 19:42:23.635815466 -0400
@@ -131,6 +131,17 @@ else
          KBUILD_CFLAGS += $(cflags-y)

          KBUILD_CFLAGS += -mno-red-zone
+
+ifdef CONFIG_X86_PIC
+        KBUILD_CFLAGS_MODULE += -fPIC -mcmodel=small 
-fno-stack-protector -fvisibility=hidden
+  ifdef CONFIG_RETPOLINE
+        MOD_EXTRA_LINK += $(srctree)/arch/$(SRCARCH)/module-lib/retpoline.o
+  else
+        KBUILD_CFLAGS_MODULE += -fno-plt
+  endif
+endif
+        KBUILD_LDFLAGS_MODULE += -T $(srctree)/arch/x86/kernel/module.lds
+
  ifdef CONFIG_X86_PIE
          KBUILD_CFLAGS += -fPIE
          KBUILD_LDFLAGS_MODULE += -T $(srctree)/arch/x86/kernel/module.lds
diff -uprN a/arch/x86/module-lib/Makefile b/arch/x86/module-lib/Makefile
--- a/arch/x86/module-lib/Makefile	1969-12-31 19:00:00.000000000 -0500
+++ b/arch/x86/module-lib/Makefile	2019-03-20 19:42:23.635815466 -0400
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_RETPOLINE) += retpoline.o
\ No newline at end of file
diff -uprN a/arch/x86/module-lib/retpoline.S 
b/arch/x86/module-lib/retpoline.S
--- a/arch/x86/module-lib/retpoline.S	1969-12-31 19:00:00.000000000 -0500
+++ b/arch/x86/module-lib/retpoline.S	2019-03-20 19:42:23.635815466 -0400
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#include <linux/stringify.h>
+#include <linux/linkage.h>
+#include <asm/dwarf2.h>
+#include <asm/cpufeatures.h>
+#include <asm/alternative-asm.h>
+#include <asm/export.h>
+#include <asm/nospec-branch.h>
+
+.macro THUNK reg
+	.section .text.__x86.indirect_thunk
+
+ENTRY(__x86_indirect_thunk_\reg)
+	CFI_STARTPROC
+	JMP_NOSPEC %\reg
+	CFI_ENDPROC
+ENDPROC(__x86_indirect_thunk_\reg)
+.endm
+
+/*
+ * Despite being an assembler file we can't just use .irp here
+ * because __KSYM_DEPS__ only uses the C preprocessor and would
+ * only see one instance of "__x86_indirect_thunk_\reg" rather
+ * than one per register with the correct names. So we do it
+ * the simple and nasty way...
+ */
+#define GENERATE_THUNK(reg) THUNK reg
+
+GENERATE_THUNK(_ASM_AX)
+GENERATE_THUNK(_ASM_BX)
+GENERATE_THUNK(_ASM_CX)
+GENERATE_THUNK(_ASM_DX)
+GENERATE_THUNK(_ASM_SI)
+GENERATE_THUNK(_ASM_DI)
+GENERATE_THUNK(_ASM_BP)
+#ifdef CONFIG_64BIT
+GENERATE_THUNK(r8)
+GENERATE_THUNK(r9)
+GENERATE_THUNK(r10)
+GENERATE_THUNK(r11)
+GENERATE_THUNK(r12)
+GENERATE_THUNK(r13)
+GENERATE_THUNK(r14)
+GENERATE_THUNK(r15)
+#endif
+
diff -uprN a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
--- a/arch/x86/tools/relocs.c	2019-03-16 10:50:57.109692478 -0400
+++ b/arch/x86/tools/relocs.c	2019-03-20 19:42:23.635815466 -0400
@@ -212,6 +212,8 @@ static const char *rel_type(unsigned typ
  		REL_TYPE(R_X86_64_JUMP_SLOT),
  		REL_TYPE(R_X86_64_RELATIVE),
  		REL_TYPE(R_X86_64_GOTPCREL),
+		REL_TYPE(R_X86_64_REX_GOTPCRELX),
+		REL_TYPE(R_X86_64_GOTPCRELX),
  		REL_TYPE(R_X86_64_32),
  		REL_TYPE(R_X86_64_32S),
  		REL_TYPE(R_X86_64_16),
@@ -871,6 +873,8 @@ static int do_reloc64(struct section *se
  		offset += per_cpu_load_addr;

  	switch (r_type) {
+	case R_X86_64_REX_GOTPCRELX:
+	case R_X86_64_GOTPCRELX:
  	case R_X86_64_GOTPCREL:
  	case R_X86_64_NONE:
  		/* NONE can be ignored. */
diff -uprN a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
--- a/arch/x86/xen/xen-head.S	2019-03-16 10:50:57.101692298 -0400
+++ b/arch/x86/xen/xen-head.S	2019-03-20 19:42:23.635815466 -0400
@@ -13,6 +13,7 @@
  #include <asm/page_types.h>
  #include <asm/percpu.h>
  #include <asm/unwind_hints.h>
+#include <asm/export.h>

  #include <xen/interface/elfnote.h>
  #include <xen/interface/features.h>
@@ -66,6 +67,7 @@ ENTRY(hypercall_page)
  	.endr

  #define HYPERCALL(n) \
+	EXPORT_SYMBOL_GPL(xen_hypercall_##n); \
  	.equ xen_hypercall_##n, hypercall_page + __HYPERVISOR_##n * 32; \
  	.type xen_hypercall_##n, @function; .size xen_hypercall_##n, 32
  #include <asm/xen-hypercalls.h>
diff -uprN a/Makefile b/Makefile
--- a/Makefile	2019-03-16 10:50:57.109692478 -0400
+++ b/Makefile	2019-03-20 19:42:23.635815466 -0400
@@ -1259,10 +1259,10 @@ all: modules
  # using awk while concatenating to the final file.

  PHONY += modules
-modules: $(vmlinux-dirs) $(if $(KBUILD_BUILTIN),vmlinux) modules.builtin
+modules: $(vmlinux-dirs) $(if $(KBUILD_BUILTIN),vmlinux) 
modules.builtin $(MOD_EXTRA_LINK)
  	$(Q)$(AWK) '!x[$$0]++' $(vmlinux-dirs:%=$(objtree)/%/modules.order) > 
$(objtree)/modules.order
  	@$(kecho) '  Building modules, stage 2.';
-	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost
+	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost 
MOD_EXTRA_LINK=$(MOD_EXTRA_LINK)

  modules.builtin: $(vmlinux-dirs:%=%/modules.builtin)
  	$(Q)$(AWK) '!x[$$0]++' $^ > $(objtree)/modules.builtin
@@ -1273,7 +1273,7 @@ modules.builtin: $(vmlinux-dirs:%=%/modu

  # Target to prepare building external modules
  PHONY += modules_prepare
-modules_prepare: prepare
+modules_prepare: prepare $(MOD_EXTRA_LINK)

  # Target to install modules
  PHONY += modules_install
@@ -1557,7 +1557,7 @@ $(module-dirs): prepare $(objtree)/Modul

  modules: $(module-dirs)
  	@$(kecho) '  Building modules, stage 2.';
-	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost
+	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost 
MOD_EXTRA_LINK=$(MOD_EXTRA_LINK)

  PHONY += modules_install
  modules_install: _emodinst_ _emodinst_post
diff -uprN a/scripts/Makefile.modpost b/scripts/Makefile.modpost
--- a/scripts/Makefile.modpost	2019-03-13 17:01:32.000000000 -0400
+++ b/scripts/Makefile.modpost	2019-03-20 19:42:23.635815466 -0400
@@ -125,7 +125,7 @@ quiet_cmd_ld_ko_o = LD [M]  $@
                   -o $@ $(filter-out FORCE,$^) ;                         \
  	$(if $(ARCH_POSTLINK), $(MAKE) -f $(ARCH_POSTLINK) $@, true)

-$(modules): %.ko :%.o %.mod.o FORCE
+$(modules): %.ko :%.o %.mod.o $(MOD_EXTRA_LINK) FORCE
  	+$(call if_changed,ld_ko_o)

  targets += $(modules)
diff -uprN a/scripts/recordmcount.c b/scripts/recordmcount.c
--- a/scripts/recordmcount.c	2019-03-16 10:50:57.105692388 -0400
+++ b/scripts/recordmcount.c	2019-03-20 19:42:23.635815466 -0400
@@ -452,7 +452,8 @@ static int make_nop_x86(void *map, size_
  /* Swap the stub and nop for a got call if the binary is built with PIE */
  static int is_fake_mcount_x86_x64(Elf64_Rel const *rp)
  {
-	if (ELF64_R_TYPE(rp->r_info) == R_X86_64_GOTPCREL) {
+	if (ELF64_R_TYPE(rp->r_info) == R_X86_64_GOTPCREL ||
+	    ELF64_R_TYPE(rp->r_info) == R_X86_64_GOTPCRELX) {
  		ideal_nop = ideal_nop6_x86_64;
  		ideal_nop_x86_size = sizeof(ideal_nop6_x86_64);
  		stub_x86 = stub_got_x86;
diff -uprN a/tools/objtool/check.c b/tools/objtool/check.c
--- a/tools/objtool/check.c	2019-03-13 17:01:32.000000000 -0400
+++ b/tools/objtool/check.c	2019-03-20 19:42:23.635815466 -0400
@@ -179,7 +179,7 @@ static int __dead_end_function(struct ob
  		return 0;

  	insn = find_insn(file, func->sec, func->offset);
-	if (!insn->func)
+	if (!insn || !insn->func)
  		return 0;

  	func_for_each_insn_all(file, func, insn) {
@@ -233,6 +233,8 @@ static int __dead_end_function(struct ob

  static int dead_end_function(struct objtool_file *file, struct symbol 
*func)
  {
+	if (!func)
+		return 0;
  	return __dead_end_function(file, func, 0);
  }

@@ -581,7 +583,7 @@ static int add_call_destinations(struct
  	struct rela *rela;

  	for_each_insn(file, insn) {
-		if (insn->type != INSN_CALL)
+		if (insn->type != INSN_CALL && insn->type != INSN_CALL_DYNAMIC)
  			continue;

  		rela = find_rela_by_dest_range(insn->sec, insn->offset,
@@ -590,8 +592,8 @@ static int add_call_destinations(struct
  			dest_off = insn->offset + insn->len + insn->immediate;
  			insn->call_dest = find_symbol_by_offset(insn->sec,
  								dest_off);
-
-			if (!insn->call_dest && !insn->ignore) {
+			if (!insn->call_dest && !insn->ignore &&
+			    insn->type != INSN_CALL_DYNAMIC) {
  				WARN_FUNC("unsupported intra-function call",
  					  insn->sec, insn->offset);
  				if (retpoline)
@@ -602,8 +604,9 @@ static int add_call_destinations(struct
  		} else if (rela->sym->type == STT_SECTION) {
  			insn->call_dest = find_symbol_by_offset(rela->sym->sec,
  								rela->addend+4);
-			if (!insn->call_dest ||
-			    insn->call_dest->type != STT_FUNC) {
+			if ((!insn->call_dest ||
+			     insn->call_dest->type != STT_FUNC) &&
+			    insn->type != INSN_CALL_DYNAMIC) {
  				WARN_FUNC("can't find call dest symbol at %s+0x%x",
  					  insn->sec, insn->offset,
  					  rela->sym->sec->name,
@@ -836,6 +839,12 @@ static int add_switch_table(struct objto
  	struct symbol *pfunc = insn->func->pfunc;
  	unsigned int prev_offset = 0;

+	/* If PC32 relocations are used (as in PIC), the following logic
+	 * can be broken in many ways.
+	 */
+	if (file->ignore_unreachables)
+		return 0;
+
  	list_for_each_entry_from(rela, &table->rela_sec->rela_list, list) {
  		if (rela == next_table)
  			break;
@@ -1272,7 +1281,7 @@ static int decode_sections(struct objtoo

  static bool is_fentry_call(struct instruction *insn)
  {
-	if (insn->type == INSN_CALL &&
+	if (insn->call_dest &&
  	    insn->call_dest->type == STT_NOTYPE &&
  	    !strcmp(insn->call_dest->name, "__fentry__"))
  		return true;
@@ -1917,6 +1926,7 @@ static int validate_branch(struct objtoo
  			return 0;

  		case INSN_CALL:
+		case INSN_CALL_DYNAMIC:
  			if (is_fentry_call(insn))
  				break;

@@ -1926,8 +1936,6 @@ static int validate_branch(struct objtoo
  			if (ret == -1)
  				return 1;

-			/* fallthrough */
-		case INSN_CALL_DYNAMIC:
  			if (!no_fp && func && !has_valid_stack_frame(&state)) {
  				WARN_FUNC("call without frame pointer save/setup",
  					  sec, insn->offset);
@@ -1957,12 +1965,15 @@ static int validate_branch(struct objtoo
  			break;

  		case INSN_JUMP_DYNAMIC:
+			/* XXX: Does not work properly with PIC code. */
+#if 0
  			if (func && list_empty(&insn->alts) &&
  			    has_modified_stack_frame(&state)) {
  				WARN_FUNC("sibling call from callable instruction with modified 
stack frame",
  					  sec, insn->offset);
  				return 1;
  			}
+#endif

  			return 0;

@@ -2043,6 +2054,11 @@ static int validate_retpoline(struct obj
  		if (!strcmp(insn->sec->name, ".init.text") && !module)
  			continue;

+		/* ignore ftrace calls in PIC code */
+		if (!insn->call_dest ||
+		    !strcmp(insn->call_dest->name, "__fentry__"))
+			continue;
+
  		WARN_FUNC("indirect %s found in RETPOLINE build",
  			  insn->sec, insn->offset,
  			  insn->type == INSN_JUMP_DYNAMIC ? "jump" : "call");
@@ -2055,13 +2071,15 @@ static int validate_retpoline(struct obj

  static bool is_kasan_insn(struct instruction *insn)
  {
-	return (insn->type == INSN_CALL &&
+	return ((insn->type == INSN_CALL || insn->type == INSN_CALL_DYNAMIC) &&
+		insn->call_dest &&
  		!strcmp(insn->call_dest->name, "__asan_handle_no_return"));
  }

  static bool is_ubsan_insn(struct instruction *insn)
  {
-	return (insn->type == INSN_CALL &&
+	return ((insn->type == INSN_CALL || insn->type == INSN_CALL_DYNAMIC) &&
+		insn->call_dest &&
  		!strcmp(insn->call_dest->name,
  			"__ubsan_handle_builtin_unreachable"));
  }
