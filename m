From: Ruslan Nikolaev <nruslan_devel@yahoo.com>
Subject: [PATCH v1 06/06]: Extending kernel support for PIC modules
Message-ID: <d01dcaf7-7fde-6bec-cdf9-3736d7d0894f@yahoo.com>
Date: Tue, 15 Jan 2019 14:03:13 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: kernel-hardening@lists.openwall.com
Cc: thgarnie@google.com, x86@kernel.org, kstewart@linuxfoundation.org, gregkh@linuxfoundation.org, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

Extending kernel support for PIC modules

The patch is by Hassan Nadeem and Ruslan Nikolaev. This extends
the prior PIE kernel patch (by Thomas Garnier) to also support
position-independent modules that can be placed anywhere in the
48/64-bit address space (for better KASLR).

Signed-off-by: Ruslan Nikolaev <nruslan_devel@yahoo.com>
---
  Makefile                                              |    4
  arch/x86/Kconfig                                      |   12
  arch/x86/Makefile                                     |   11
  arch/x86/crypto/aes-x86_64-asm_64.S                   |    5
  arch/x86/crypto/cast5-avx-x86_64-asm_64.S             |    9
  arch/x86/crypto/cast6-avx-x86_64-asm_64.S             |    9
  arch/x86/crypto/sha1-mb/sha1_mb_mgr_flush_avx2.S      |    3
  arch/x86/crypto/sha1-mb/sha1_mb_mgr_submit_avx2.S     |    3
  arch/x86/crypto/sha256-mb/sha256_mb_mgr_flush_avx2.S  |    3
  arch/x86/crypto/sha256-mb/sha256_mb_mgr_submit_avx2.S |    3
  arch/x86/crypto/sha512-mb/sha512_mb_mgr_flush_avx2.S  |    3
  arch/x86/crypto/sha512-mb/sha512_mb_mgr_submit_avx2.S |    3
  arch/x86/include/asm/alternative.h                    |   12
  arch/x86/include/asm/arch_hweight.h                   |    5
  arch/x86/include/asm/asm.h                            |   60 +++-
  arch/x86/include/asm/elf.h                            |    5
  arch/x86/include/asm/jump_label.h                     |    4
  arch/x86/include/asm/kvm_host.h                       |   15 -
  arch/x86/include/asm/module.h                         |   26 +
  arch/x86/include/asm/paravirt_types.h                 |    9
  arch/x86/include/asm/percpu.h                         |    2
  arch/x86/include/asm/uaccess.h                        |    6
  arch/x86/include/asm/xen/hypercall.h                  |   31 +-
  arch/x86/kernel/ftrace.c                              |   14
  arch/x86/kernel/module.c                              |  263 
++++++++++++++++--
  arch/x86/kernel/module.lds                            |    1
  arch/x86/kvm/emulate.c                                |    1
  arch/x86/tools/relocs.c                               |    4
  scripts/Makefile.modpost                              |    2
  scripts/recordmcount.c                                |    3
  30 files changed, 447 insertions(+), 84 deletions(-)

diff -uprN a/arch/x86/crypto/aes-x86_64-asm_64.S 
b/arch/x86/crypto/aes-x86_64-asm_64.S
--- a/arch/x86/crypto/aes-x86_64-asm_64.S	2019-01-15 11:20:45.259168260 
-0500
+++ b/arch/x86/crypto/aes-x86_64-asm_64.S	2019-01-15 11:34:00.001848665 
-0500
@@ -17,6 +17,7 @@

  #include <linux/linkage.h>
  #include <asm/asm-offsets.h>
+#include <asm/asm.h>

  #define R1	%rax
  #define R1E	%eax
@@ -83,11 +84,11 @@
  	ENDPROC(FUNC);

  #define round_mov(tab_off, reg_i, reg_o) \
-	leaq	tab_off(%rip), RBASE; \
+	_ASM_LEA_RIP(tab_off, RBASE);	\
  	movl	(RBASE,reg_i,4), reg_o;

  #define round_xor(tab_off, reg_i, reg_o) \
-	leaq	tab_off(%rip), RBASE; \
+	_ASM_LEA_RIP(tab_off, RBASE);	\
  	xorl	(RBASE,reg_i,4), reg_o;

  #define round(TAB,OFFSET,r1,r2,r3,r4,r5,r6,r7,r8,ra,rb,rc,rd) \
diff -uprN a/arch/x86/crypto/cast5-avx-x86_64-asm_64.S 
b/arch/x86/crypto/cast5-avx-x86_64-asm_64.S
--- a/arch/x86/crypto/cast5-avx-x86_64-asm_64.S	2019-01-15 
11:20:45.259168260 -0500
+++ b/arch/x86/crypto/cast5-avx-x86_64-asm_64.S	2019-01-15 
11:34:00.001848665 -0500
@@ -25,6 +25,7 @@

  #include <linux/linkage.h>
  #include <asm/frame.h>
+#include <asm/asm.h>

  .file "cast5-avx-x86_64-asm_64.S"

@@ -99,17 +100,17 @@

  #define lookup_32bit(src, dst, op1, op2, op3, interleave_op, il_reg) \
  	movzbl		src ## bh,       RID1d;    \
-	leaq		s1(%rip),        RID2;     \
+	_ASM_LEA_RIP(s1, RID2);                    \
  	movl		(RID2, RID1, 4), dst ## d; \
  	movzbl		src ## bl,       RID2d;    \
-	leaq		s2(%rip),        RID1;     \
+	_ASM_LEA_RIP(s2, RID1);                    \
  	op1		(RID1, RID2, 4), dst ## d; \
  	shrq $16,	src;                       \
  	movzbl		src ## bh,     RID1d;      \
-	leaq		s3(%rip),        RID2;     \
+	_ASM_LEA_RIP(s3, RID2);                    \
  	op2		(RID2, RID1, 4), dst ## d; \
  	movzbl		src ## bl,     RID2d;      \
-	leaq		s4(%rip),        RID1;     \
+	_ASM_LEA_RIP(s4, RID1);                    \
  	op3		(RID1, RID2, 4), dst ## d; \
  	interleave_op(il_reg);

diff -uprN a/arch/x86/crypto/cast6-avx-x86_64-asm_64.S 
b/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
--- a/arch/x86/crypto/cast6-avx-x86_64-asm_64.S	2019-01-15 
11:20:45.259168260 -0500
+++ b/arch/x86/crypto/cast6-avx-x86_64-asm_64.S	2019-01-15 
11:34:00.001848665 -0500
@@ -25,6 +25,7 @@

  #include <linux/linkage.h>
  #include <asm/frame.h>
+#include <asm/asm.h>
  #include "glue_helper-asm-avx.S"

  .file "cast6-avx-x86_64-asm_64.S"
@@ -99,17 +100,17 @@

  #define lookup_32bit(src, dst, op1, op2, op3, interleave_op, il_reg) \
  	movzbl		src ## bh,       RID1d;    \
-	leaq		s1(%rip),        RID2;     \
+	_ASM_LEA_RIP(s1, RID2);                    \
  	movl		(RID2, RID1, 4), dst ## d; \
  	movzbl		src ## bl,       RID2d;    \
-	leaq		s2(%rip),        RID1;     \
+	_ASM_LEA_RIP(s2, RID1);                    \
  	op1		(RID1, RID2, 4), dst ## d; \
  	shrq $16,	src;                       \
  	movzbl		src ## bh,     RID1d;      \
-	leaq		s3(%rip),        RID2;     \
+	_ASM_LEA_RIP(s3, RID2);                    \
  	op2		(RID2, RID1, 4), dst ## d; \
  	movzbl		src ## bl,     RID2d;      \
-	leaq		s4(%rip),        RID1;     \
+	_ASM_LEA_RIP(s4, RID1);                    \
  	op3		(RID1, RID2, 4), dst ## d; \
  	interleave_op(il_reg);

diff -uprN a/arch/x86/crypto/sha1-mb/sha1_mb_mgr_flush_avx2.S 
b/arch/x86/crypto/sha1-mb/sha1_mb_mgr_flush_avx2.S
--- a/arch/x86/crypto/sha1-mb/sha1_mb_mgr_flush_avx2.S	2019-01-15 
11:20:45.259168260 -0500
+++ b/arch/x86/crypto/sha1-mb/sha1_mb_mgr_flush_avx2.S	2019-01-15 
11:34:00.001848665 -0500
@@ -53,6 +53,7 @@
   */
  #include <linux/linkage.h>
  #include <asm/frame.h>
+#include <asm/asm.h>
  #include "sha1_mb_mgr_datastruct.S"


@@ -183,7 +184,7 @@ LABEL skip_ %I

  	# "state" and "args" are the same address, arg1
  	# len is arg2
-	call	sha1_x8_avx2
+	_ASM_CALL(sha1_x8_avx2)
  	# state and idx are intact


diff -uprN a/arch/x86/crypto/sha1-mb/sha1_mb_mgr_submit_avx2.S 
b/arch/x86/crypto/sha1-mb/sha1_mb_mgr_submit_avx2.S
--- a/arch/x86/crypto/sha1-mb/sha1_mb_mgr_submit_avx2.S	2019-01-15 
11:20:45.259168260 -0500
+++ b/arch/x86/crypto/sha1-mb/sha1_mb_mgr_submit_avx2.S	2019-01-15 
11:34:00.001848665 -0500
@@ -54,6 +54,7 @@

  #include <linux/linkage.h>
  #include <asm/frame.h>
+#include <asm/asm.h>
  #include "sha1_mb_mgr_datastruct.S"


@@ -163,7 +164,7 @@ start_loop:

  	# "state" and "args" are the same address, arg1
  	# len is arg2
-	call    sha1_x8_avx2
+	_ASM_CALL(sha1_x8_avx2)

  	# state and idx are intact

diff -uprN a/arch/x86/crypto/sha256-mb/sha256_mb_mgr_flush_avx2.S 
b/arch/x86/crypto/sha256-mb/sha256_mb_mgr_flush_avx2.S
--- a/arch/x86/crypto/sha256-mb/sha256_mb_mgr_flush_avx2.S	2019-01-15 
11:20:45.259168260 -0500
+++ b/arch/x86/crypto/sha256-mb/sha256_mb_mgr_flush_avx2.S	2019-01-15 
11:34:00.001848665 -0500
@@ -52,6 +52,7 @@
   */
  #include <linux/linkage.h>
  #include <asm/frame.h>
+#include <asm/asm.h>
  #include "sha256_mb_mgr_datastruct.S"

  .extern sha256_x8_avx2
@@ -181,7 +182,7 @@ LABEL skip_ %I

  	# "state" and "args" are the same address, arg1
  	# len is arg2
-	call	sha256_x8_avx2
+	_ASM_CALL(sha256_x8_avx2)
  	# state and idx are intact

  len_is_0:
diff -uprN a/arch/x86/crypto/sha256-mb/sha256_mb_mgr_submit_avx2.S 
b/arch/x86/crypto/sha256-mb/sha256_mb_mgr_submit_avx2.S
--- a/arch/x86/crypto/sha256-mb/sha256_mb_mgr_submit_avx2.S	2019-01-15 
11:20:45.259168260 -0500
+++ b/arch/x86/crypto/sha256-mb/sha256_mb_mgr_submit_avx2.S	2019-01-15 
11:34:00.001848665 -0500
@@ -53,6 +53,7 @@

  #include <linux/linkage.h>
  #include <asm/frame.h>
+#include <asm/asm.h>
  #include "sha256_mb_mgr_datastruct.S"

  .extern sha256_x8_avx2
@@ -164,7 +165,7 @@ start_loop:

  	# "state" and "args" are the same address, arg1
  	# len is arg2
-	call	sha256_x8_avx2
+	_ASM_CALL(sha256_x8_avx2)

  	# state and idx are intact

diff -uprN a/arch/x86/crypto/sha512-mb/sha512_mb_mgr_flush_avx2.S 
b/arch/x86/crypto/sha512-mb/sha512_mb_mgr_flush_avx2.S
--- a/arch/x86/crypto/sha512-mb/sha512_mb_mgr_flush_avx2.S	2019-01-15 
11:20:45.259168260 -0500
+++ b/arch/x86/crypto/sha512-mb/sha512_mb_mgr_flush_avx2.S	2019-01-15 
11:34:00.005850530 -0500
@@ -53,6 +53,7 @@

  #include <linux/linkage.h>
  #include <asm/frame.h>
+#include <asm/asm.h>
  #include "sha512_mb_mgr_datastruct.S"

  .extern sha512_x4_avx2
@@ -177,7 +178,7 @@ LABEL skip_ %I

          # "state" and "args" are the same address, arg1
          # len is arg2
-        call    sha512_x4_avx2
+	_ASM_CALL(sha512_x4_avx2)
          # state and idx are intact

  len_is_0:
diff -uprN a/arch/x86/crypto/sha512-mb/sha512_mb_mgr_submit_avx2.S 
b/arch/x86/crypto/sha512-mb/sha512_mb_mgr_submit_avx2.S
--- a/arch/x86/crypto/sha512-mb/sha512_mb_mgr_submit_avx2.S	2019-01-15 
11:20:45.259168260 -0500
+++ b/arch/x86/crypto/sha512-mb/sha512_mb_mgr_submit_avx2.S	2019-01-15 
11:34:00.005850530 -0500
@@ -53,6 +53,7 @@

  #include <linux/linkage.h>
  #include <asm/frame.h>
+#include <asm/asm.h>
  #include "sha512_mb_mgr_datastruct.S"

  .extern sha512_x4_avx2
@@ -167,7 +168,7 @@ start_loop:

  	# "state" and "args" are the same address, arg1
  	# len is arg2
-	call    sha512_x4_avx2
+	_ASM_CALL(sha512_x4_avx2)
  	# state and idx are intact

  len_is_0:
diff -uprN a/arch/x86/include/asm/alternative.h 
b/arch/x86/include/asm/alternative.h
--- a/arch/x86/include/asm/alternative.h	2019-01-15 11:20:45.263168301 -0500
+++ b/arch/x86/include/asm/alternative.h	2019-01-15 11:34:00.009852393 -0500
@@ -207,8 +207,8 @@ static inline int alternatives_text_rese

  /* Like alternative_io, but for replacing a direct call with another 
one. */
  #define alternative_call(oldfunc, newfunc, feature, output, input...)	\
-	asm volatile (ALTERNATIVE("call %P[old]", "call %P[new]", feature) \
-		: output : [old] "i" (oldfunc), [new] "i" (newfunc), ## input)
+	asm volatile (ALTERNATIVE(_ASM_CALL(%p[old]), _ASM_CALL(%p[new]), 
feature) \
+		: output : [old] "X" (oldfunc), [new] "X" (newfunc), ## input)

  /*
   * Like alternative_call, but there are two features and respective 
functions.
@@ -218,11 +218,11 @@ static inline int alternatives_text_rese
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
-		: [old] "i" (oldfunc), [new1] "i" (newfunc1),		      \
-		  [new2] "i" (newfunc2), ## input)
+		: [old] "X" (oldfunc), [new1] "X" (newfunc1),		      \
+		  [new2] "X" (newfunc2), ## input)

  /*
   * use this macro(s) if you need more than one output parameter
diff -uprN a/arch/x86/include/asm/arch_hweight.h 
b/arch/x86/include/asm/arch_hweight.h
--- a/arch/x86/include/asm/arch_hweight.h	2019-01-15 11:20:45.263168301 
-0500
+++ b/arch/x86/include/asm/arch_hweight.h	2019-01-15 11:34:00.009852393 
-0500
@@ -3,6 +3,7 @@
  #define _ASM_X86_HWEIGHT_H

  #include <asm/cpufeatures.h>
+#include <asm/asm.h>

  #ifdef CONFIG_64BIT
  /* popcnt %edi, %eax */
@@ -24,7 +25,7 @@ static __always_inline unsigned int __ar
  {
  	unsigned int res;

-	asm (ALTERNATIVE("call __sw_hweight32", POPCNT32, X86_FEATURE_POPCNT)
+	asm (ALTERNATIVE(_ASM_CALL(__sw_hweight32), POPCNT32, X86_FEATURE_POPCNT)
  			 : "="REG_OUT (res)
  			 : REG_IN (w));

@@ -52,7 +53,7 @@ static __always_inline unsigned long __a
  {
  	unsigned long res;

-	asm (ALTERNATIVE("call __sw_hweight64", POPCNT64, X86_FEATURE_POPCNT)
+	asm (ALTERNATIVE(_ASM_CALL(__sw_hweight64), POPCNT64, X86_FEATURE_POPCNT)
  			 : "="REG_OUT (res)
  			 : REG_IN (w));

diff -uprN a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
--- a/arch/x86/include/asm/asm.h	2019-01-15 11:20:45.267168340 -0500
+++ b/arch/x86/include/asm/asm.h	2019-01-15 11:34:00.009852393 -0500
@@ -2,6 +2,42 @@
  #ifndef _ASM_X86_ASM_H
  #define _ASM_X86_ASM_H

+/* PIC modules require an indirection through GOT for
+ * external symbols. _ASM_CALL() for internal functions
+ * is optimized by replacing indirect calls with direct ones
+ * followed by 1-byte NOP paddings per a call site;
+ * Similarly, _ASM_LEA_RIP() is optimized by replacing MOV
+ * to LEA and is used to load symbol addresses on x86-64.
+ *
+ * If RETPOLINE is enabled, use PLT stubs instead to
+ * better optimize local calls.
+ */
+#if defined(MODULE) && defined(CONFIG_X86_PIC)
+# ifdef __ASSEMBLY__
+#  define _ASM_LEA_RIP(v,a)	movq v##@GOTPCREL(%rip), a
+#  ifdef CONFIG_RETPOLINE
+#   define _ASM_CALL(f)		call f##@PLT
+#  else
+#   define _ASM_CALL(f)		call *##f##@GOTPCREL(%rip)
+#  endif
+# else
+#  define _ASM_LEA_RIP(v,a)	"movq " #v "@GOTPCREL(%%rip), " #a
+#  ifdef CONFIG_RETPOLINE
+#   define _ASM_CALL(f)		"call " #f "@PLT"
+#  else
+#   define _ASM_CALL(f)		"call *" #f "@GOTPCREL(%%rip)"
+#  endif
+# endif
+#else
+# ifdef __ASSEMBLY__
+#  define _ASM_CALL(f)		call f
+#  define _ASM_LEA_RIP(v,a)	leaq v##(%rip), a
+# else
+#  define _ASM_CALL(f)		"call " #f
+#  define _ASM_LEA_RIP(v,a)	"leaq " #v "(%%rip), " #a
+# endif
+#endif
+
  #ifdef __ASSEMBLY__
  # define __ASM_FORM(x)	x
  # define __ASM_FORM_RAW(x)     x
@@ -118,6 +154,24 @@
  # define CC_OUT(c) [_cc_ ## c] "=qm"
  #endif

+/* PLT relocations in x86_64 PIC modules are already relative.
+ * However, due to inconsistent GNU binutils behavior (e.g., i386),
+ * avoid PLT relocations in all other cases (binutils bug 23997).
+ */
+#if defined(MODULE) && defined(CONFIG_X86_PIC)
+# ifdef __ASSEMBLY__
+#  define _ASM_HANDLER(x)	x##@PLT
+# else
+#  define _ASM_HANDLER(x)	x "@PLT"
+# endif
+#else
+# ifdef __ASSEMBLY__
+#  define _ASM_HANDLER(x)	(x) - .
+# else
+#  define _ASM_HANDLER(x)	"(" x ") - ."
+# endif
+#endif
+
  /* Exception table entry */
  #ifdef __ASSEMBLY__
  # define _ASM_EXTABLE_HANDLE(from, to, handler)			\
@@ -125,7 +179,7 @@
  	.balign 4 ;						\
  	.long (from) - . ;					\
  	.long (to) - . ;					\
-	.long (handler) - . ;					\
+	.long _ASM_HANDLER(handler);				\
  	.popsection

  # define _ASM_EXTABLE(from, to)					\
@@ -171,13 +225,13 @@
  	.endm

  #else
-# define _EXPAND_EXTABLE_HANDLE(x) #x
+# define _EXPAND_EXTABLE_HANDLE(x) _ASM_HANDLER(#x)
  # define _ASM_EXTABLE_HANDLE(from, to, handler)			\
  	" .pushsection \"__ex_table\",\"a\"\n"			\
  	" .balign 4\n"						\
  	" .long (" #from ") - .\n"				\
  	" .long (" #to ") - .\n"				\
-	" .long (" _EXPAND_EXTABLE_HANDLE(handler) ") - .\n"	\
+	" .long " _EXPAND_EXTABLE_HANDLE(handler) "\n"		\
  	" .popsection\n"

  # define _ASM_EXTABLE(from, to)					\
diff -uprN a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
--- a/arch/x86/include/asm/elf.h	2019-01-15 11:20:45.263168301 -0500
+++ b/arch/x86/include/asm/elf.h	2019-01-15 11:34:00.009852393 -0500
@@ -63,7 +63,10 @@ typedef struct user_fxsr_struct elf_fpxr
  #define R_X86_64_8		14	/* Direct 8 bit sign extended  */
  #define R_X86_64_PC8		15	/* 8 bit sign extended pc relative */

-#define R_X86_64_NUM		16
+#define R_X86_64_GOTPCRELX	41
+#define R_X86_64_REX_GOTPCRELX	42
+
+#define R_X86_64_NUM		43

  /*
   * These are used to set parameters in the core dumps.
diff -uprN a/arch/x86/include/asm/jump_label.h 
b/arch/x86/include/asm/jump_label.h
--- a/arch/x86/include/asm/jump_label.h	2019-01-15 11:20:45.267168340 -0500
+++ b/arch/x86/include/asm/jump_label.h	2019-01-15 11:34:00.009852393 -0500
@@ -37,7 +37,7 @@ static __always_inline bool arch_static_
  		".byte " __stringify(STATIC_KEY_INIT_NOP) "\n\t"
  		".pushsection __jump_table,  \"aw\" \n\t"
  		_ASM_ALIGN "\n\t"
-		_ASM_PTR "1b, %l[l_yes], %P0 \n\t"
+		_ASM_PTR "1b, %l[l_yes], %p0 \n\t"
  		".popsection \n\t"
  		: :  "X" (&((char *)key)[branch]) : : l_yes);

@@ -53,7 +53,7 @@ static __always_inline bool arch_static_
  		"2:\n\t"
  		".pushsection __jump_table,  \"aw\" \n\t"
  		_ASM_ALIGN "\n\t"
-		_ASM_PTR "1b, %l[l_yes], %P0 \n\t"
+		_ASM_PTR "1b, %l[l_yes], %p0 \n\t"
  		".popsection \n\t"
  		: :  "X" (&((char *)key)[branch]) : : l_yes);

diff -uprN a/arch/x86/include/asm/kvm_host.h 
b/arch/x86/include/asm/kvm_host.h
--- a/arch/x86/include/asm/kvm_host.h	2019-01-15 11:20:45.267168340 -0500
+++ b/arch/x86/include/asm/kvm_host.h	2019-01-15 11:34:00.009852393 -0500
@@ -1394,20 +1394,31 @@ enum {
   */
  asmlinkage void kvm_spurious_fault(void);

+#if defined(MODULE) && defined(CONFIG_X86_PIC)
+# define ___kvm_check_rebooting					\
+	"pushq %%rax \n\t"					\
+	"movq kvm_rebooting@GOTPCREL(%%rip), %%rax \n\t"	\
+	"cmpb $0, (%%rax) \n\t"					\
+	"popq %%rax \n\t"
+#else
+# define ___kvm_check_rebooting					\
+	"cmpb $0, kvm_rebooting" __ASM_SEL(,(%%rip)) " \n\t"
+#endif
+
  #define ____kvm_handle_fault_on_reboot(insn, cleanup_insn)	\
  	"666: " insn "\n\t" \
  	"668: \n\t"                           \
  	".pushsection .fixup, \"ax\" \n" \
  	"667: \n\t" \
  	cleanup_insn "\n\t"		      \
-	"cmpb $0, kvm_rebooting" __ASM_SEL(,(%%rip)) " \n\t" \
+	___kvm_check_rebooting			\
  	"jne 668b \n\t"      		      \
  	__ASM_SIZE(push) "$0 \n\t"		\
  	__ASM_SIZE(push) "%%" _ASM_AX " \n\t"		\
  	_ASM_MOVABS " $666b, %%" _ASM_AX "\n\t"	\
  	_ASM_MOV " %%" _ASM_AX ", " __ASM_SEL(4,8) "(%%" _ASM_SP ") \n\t" \
  	__ASM_SIZE(pop) "%%" _ASM_AX " \n\t"		\
-	"call kvm_spurious_fault \n\t"	      \
+	_ASM_CALL(kvm_spurious_fault) " \n\t"	      \
  	".popsection \n\t" \
  	_ASM_EXTABLE(666b, 667b)

diff -uprN a/arch/x86/include/asm/module.h b/arch/x86/include/asm/module.h
--- a/arch/x86/include/asm/module.h	2019-01-15 11:20:45.267168340 -0500
+++ b/arch/x86/include/asm/module.h	2019-01-15 11:34:00.009852393 -0500
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
diff -uprN a/arch/x86/include/asm/paravirt_types.h 
b/arch/x86/include/asm/paravirt_types.h
--- a/arch/x86/include/asm/paravirt_types.h	2019-01-15 
11:20:45.263168301 -0500
+++ b/arch/x86/include/asm/paravirt_types.h	2019-01-15 
11:34:00.009852393 -0500
@@ -337,7 +337,7 @@ extern struct pv_lock_ops pv_lock_ops;
  #define PARAVIRT_PATCH(x)					\
  	(offsetof(struct paravirt_patch_template, x) / sizeof(void *))

-#ifdef CONFIG_X86_PIE
+#if defined(CONFIG_X86_PIE) || (defined(MODULE) && defined(CONFIG_X86_PIC))
  #define paravirt_opptr_call "a"
  #define paravirt_opptr_type "p"
  #else
@@ -355,7 +355,11 @@ extern struct pv_lock_ops pv_lock_ops;
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
@@ -364,6 +368,7 @@ extern struct pv_lock_ops pv_lock_ops;
  	"  .byte 772b-771b\n"				\
  	"  .short " clobber "\n"			\
  	".popsection\n"
+#endif

  /* Generate patchable code, with the default asm parameters. */
  #define paravirt_alt(insn_string)					\
diff -uprN a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
--- a/arch/x86/include/asm/percpu.h	2019-01-15 11:20:45.263168301 -0500
+++ b/arch/x86/include/asm/percpu.h	2019-01-15 11:34:00.009852393 -0500
@@ -216,7 +216,7 @@ do {									\
  })

  /* Position Independent code uses relative addresses only */
-#ifdef CONFIG_X86_PIE
+#if defined(CONFIG_X86_PIE) || (defined(MODULE) && defined(CONFIG_X86_PIC))
  #define __percpu_stable_arg __percpu_arg(a1)
  #else
  #define __percpu_stable_arg __percpu_arg(P1)
diff -uprN a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
--- a/arch/x86/include/asm/uaccess.h	2019-01-15 11:20:45.267168340 -0500
+++ b/arch/x86/include/asm/uaccess.h	2019-01-15 11:34:00.009852393 -0500
@@ -174,7 +174,7 @@ __typeof__(__builtin_choose_expr(sizeof(
  	register __inttype(*(ptr)) __val_gu asm("%"_ASM_DX);		\
  	__chk_user_ptr(ptr);						\
  	might_fault();							\
-	asm volatile("call __get_user_%P4"				\
+	asm volatile(_ASM_CALL(__get_user_%P4)				\
  		     : "=a" (__ret_gu), "=r" (__val_gu),		\
  			ASM_CALL_CONSTRAINT				\
  		     : "0" (ptr), "i" (sizeof(*(ptr))));		\
@@ -183,7 +183,7 @@ __typeof__(__builtin_choose_expr(sizeof(
  })

  #define __put_user_x(size, x, ptr, __ret_pu)			\
-	asm volatile("call __put_user_" #size : "=a" (__ret_pu)	\
+	asm volatile(_ASM_CALL(__put_user_##size) : "=a" (__ret_pu)	\
  		     : "0" ((typeof(*(ptr)))(x)), "c" (ptr) : "ebx")


@@ -213,7 +213,7 @@ __typeof__(__builtin_choose_expr(sizeof(
  		     : : "A" (x), "r" (addr))

  #define __put_user_x8(x, ptr, __ret_pu)				\
-	asm volatile("call __put_user_8" : "=a" (__ret_pu)	\
+	asm volatile(_ASM_CALL(__put_user_8) : "=a" (__ret_pu)	\
  		     : "A" ((typeof(*(ptr)))(x)), "c" (ptr) : "ebx")
  #else
  #define __put_user_asm_u64(x, ptr, retval, errret) \
diff -uprN a/arch/x86/include/asm/xen/hypercall.h 
b/arch/x86/include/asm/xen/hypercall.h
--- a/arch/x86/include/asm/xen/hypercall.h	2019-01-15 11:20:45.267168340 
-0500
+++ b/arch/x86/include/asm/xen/hypercall.h	2019-01-15 11:34:00.009852393 
-0500
@@ -88,9 +88,24 @@ struct xen_dm_op_buf;

  extern struct { char _entry[32]; } hypercall_page[];

-#define __HYPERCALL		"call hypercall_page+%c[offset]"
-#define __HYPERCALL_ENTRY(x)						\
+#if defined(MODULE) && defined(CONFIG_X86_PIC)
+# ifdef CONFIG_RETPOLINE
+#  define HYPERCALL(x)		long xen_hypercall_##x(void);
+#  include <asm/xen-hypercalls.h>
+#  undef HYPERCALL
+#  include <asm/nospec-branch.h>
+#  define __HYPERCALL(x)	CALL_NOSPEC
+#  define __HYPERCALL_ENTRY(x)						\
+	[thunk_target] "a" (xen_hypercall_##x)
+# else
+#  define __HYPERCALL(x)	"call *xen_hypercall_" #x "@GOTPCREL(%%rip)"
+#  define __HYPERCALL_ENTRY(x)
+# endif
+#else
+# define __HYPERCALL(x)		"call hypercall_page+%c[offset]"
+# define __HYPERCALL_ENTRY(x)						\
  	[offset] "i" (__HYPERVISOR_##x * sizeof(hypercall_page[0]))
+#endif

  #ifdef CONFIG_X86_32
  #define __HYPERCALL_RETREG	"eax"
@@ -146,7 +161,7 @@ extern struct { char _entry[32]; } hyper
  ({									\
  	__HYPERCALL_DECLS;						\
  	__HYPERCALL_0ARG();						\
-	asm volatile (__HYPERCALL					\
+	asm volatile (__HYPERCALL(name)					\
  		      : __HYPERCALL_0PARAM				\
  		      : __HYPERCALL_ENTRY(name)				\
  		      : __HYPERCALL_CLOBBER0);				\
@@ -157,7 +172,7 @@ extern struct { char _entry[32]; } hyper
  ({									\
  	__HYPERCALL_DECLS;						\
  	__HYPERCALL_1ARG(a1);						\
-	asm volatile (__HYPERCALL					\
+	asm volatile (__HYPERCALL(name)					\
  		      : __HYPERCALL_1PARAM				\
  		      : __HYPERCALL_ENTRY(name)				\
  		      : __HYPERCALL_CLOBBER1);				\
@@ -168,7 +183,7 @@ extern struct { char _entry[32]; } hyper
  ({									\
  	__HYPERCALL_DECLS;						\
  	__HYPERCALL_2ARG(a1, a2);					\
-	asm volatile (__HYPERCALL					\
+	asm volatile (__HYPERCALL(name)					\
  		      : __HYPERCALL_2PARAM				\
  		      : __HYPERCALL_ENTRY(name)				\
  		      : __HYPERCALL_CLOBBER2);				\
@@ -179,7 +194,7 @@ extern struct { char _entry[32]; } hyper
  ({									\
  	__HYPERCALL_DECLS;						\
  	__HYPERCALL_3ARG(a1, a2, a3);					\
-	asm volatile (__HYPERCALL					\
+	asm volatile (__HYPERCALL(name)					\
  		      : __HYPERCALL_3PARAM				\
  		      : __HYPERCALL_ENTRY(name)				\
  		      : __HYPERCALL_CLOBBER3);				\
@@ -190,7 +205,7 @@ extern struct { char _entry[32]; } hyper
  ({									\
  	__HYPERCALL_DECLS;						\
  	__HYPERCALL_4ARG(a1, a2, a3, a4);				\
-	asm volatile (__HYPERCALL					\
+	asm volatile (__HYPERCALL(name)					\
  		      : __HYPERCALL_4PARAM				\
  		      : __HYPERCALL_ENTRY(name)				\
  		      : __HYPERCALL_CLOBBER4);				\
@@ -201,7 +216,7 @@ extern struct { char _entry[32]; } hyper
  ({									\
  	__HYPERCALL_DECLS;						\
  	__HYPERCALL_5ARG(a1, a2, a3, a4, a5);				\
-	asm volatile (__HYPERCALL					\
+	asm volatile (__HYPERCALL(name)					\
  		      : __HYPERCALL_5PARAM				\
  		      : __HYPERCALL_ENTRY(name)				\
  		      : __HYPERCALL_CLOBBER5);				\
diff -uprN a/arch/x86/Kconfig b/arch/x86/Kconfig
--- a/arch/x86/Kconfig	2019-01-15 11:20:45.259168260 -0500
+++ b/arch/x86/Kconfig	2019-01-15 11:34:00.009852393 -0500
@@ -2238,9 +2238,19 @@ config X86_PIE
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
diff -uprN a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
--- a/arch/x86/kernel/ftrace.c	2019-01-15 11:20:45.271168382 -0500
+++ b/arch/x86/kernel/ftrace.c	2019-01-15 11:34:00.009852393 -0500
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
diff -uprN a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
--- a/arch/x86/kernel/module.c	2019-01-15 11:20:45.271168382 -0500
+++ b/arch/x86/kernel/module.c	2019-01-15 11:34:00.009852393 -0500
@@ -37,6 +37,9 @@
  #include <asm/pgtable.h>
  #include <asm/setup.h>
  #include <asm/unwind.h>
+#include <asm/insn.h>
+
+static unsigned int module_plt_size;

  #if 0
  #define DEBUGP(fmt, ...)				\
@@ -90,6 +93,12 @@ static u64 find_got_kernel_entry(Elf64_S

  	return 0;
  }
+#else
+static u64 find_got_kernel_entry(Elf64_Sym *sym, const Elf64_Rela *rela)
+{
+	return 0;
+}
+#endif

  static u64 module_emit_got_entry(struct module *mod, void *loc,
  				 const Elf64_Rela *rela, Elf64_Sym *sym)
@@ -111,7 +120,7 @@ static u64 module_emit_got_entry(struct
  	 * relocations are sorted, this will be the last entry we allocated.
  	 * (if one exists).
  	 */
-	if (i > 0 && got[i] == got[i - 2]) {
+	if (i > 0 && got[i] == got[i - 1]) {
  		ret = (u64)&got[i - 1];
  	} else {
  		gotsec->got_num_entries++;
@@ -119,7 +128,52 @@ static u64 module_emit_got_entry(struct
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

  #define cmp_3way(a,b)	((a) < (b) ? -1 : (a) > (b))
@@ -148,14 +202,17 @@ static bool duplicate_rel(const Elf64_Re
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

@@ -164,12 +221,133 @@ static unsigned int count_gots(Elf64_Sym
  			 * custom one for this module.
  			 */
  			if (!duplicate_rel(rela, i) &&
-			    !find_got_kernel_entry(s, rela + i))
-				ret++;
+			    !find_got_kernel_entry(s, rela + i)) {
+				(*num_got)++;
+				if (ELF64_R_TYPE(rela[i].r_info) ==
+				    R_X86_64_PLT32)
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
+			if (sym->st_shndx != SHN_UNDEF) {
+				/* is local symbol */
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
@@ -179,19 +357,25 @@ static unsigned int count_gots(Elf64_Sym
  int module_frob_arch_sections(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
  			      char *secstrings, struct module *mod)
  {
-	unsigned long gots = 0;
+	unsigned long num_got = 0;
+	unsigned long num_plt = 0;
  	Elf_Shdr *symtab = NULL;
  	Elf64_Sym *syms = NULL;
  	char *strings, *name;
  	int i;

+	apply_relaxations(ehdr, sechdrs, mod);
+
  	/*
-	 * Find the empty .got section so we can expand it to store the PLT
-	 * entries. Record the symtab address as well.
+	 * Find the empty .got and .plt sections so we can expand it
+	 * to store the GOT and PLT entries.
+	 * Record the symtab address as well.
  	 */
  	for (i = 0; i < ehdr->e_shnum; i++) {
  		if (!strcmp(secstrings + sechdrs[i].sh_name, ".got")) {
  			mod->arch.core.got = sechdrs + i;
+		} else if (!strcmp(secstrings + sechdrs[i].sh_name, ".plt")) {
+			mod->arch.core_plt.plt = sechdrs + i;
  		} else if (sechdrs[i].sh_type == SHT_SYMTAB) {
  			symtab = sechdrs + i;
  			syms = (Elf64_Sym *)symtab->sh_addr;
@@ -202,6 +386,10 @@ int module_frob_arch_sections(Elf_Ehdr *
  		pr_err("%s: module GOT section missing\n", mod->name);
  		return -ENOEXEC;
  	}
+	if (!mod->arch.core_plt.plt) {
+		pr_err("%s: module PLT section missing\n", mod->name);
+		return -ENOEXEC;
+	}
  	if (!syms) {
  		pr_err("%s: module symtab section missing\n", mod->name);
  		return -ENOEXEC;
@@ -217,15 +405,23 @@ int module_frob_arch_sections(Elf_Ehdr *
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

  	/*
  	 * If a _GLOBAL_OFFSET_TABLE_ symbol exists, make it absolute for
@@ -243,7 +439,6 @@ int module_frob_arch_sections(Elf_Ehdr *
  	}
  	return 0;
  }
-#endif

  void *module_alloc(unsigned long size)
  {
@@ -306,6 +501,23 @@ int apply_relocate(Elf32_Shdr *sechdrs,
  	return 0;
  }
  #else /*X86_64*/
+
+int check_relocation_pic_safe(Elf64_Rela *rel, Elf64_Sym *sym)
+{
+	bool isLocalSym = sym->st_shndx != SHN_UNDEF;
+
+	switch (ELF64_R_TYPE(rel->r_info)) {
+	case R_X86_64_32:
+	case R_X86_64_32S:
+	case R_X86_64_PC32:
+		if (!isLocalSym)
+			return -1;
+		break;
+	}
+
+	return 0;
+}
+
  int apply_relocate_add(Elf64_Shdr *sechdrs,
  		   const char *strtab,
  		   unsigned int symindex,
@@ -330,6 +542,10 @@ int apply_relocate_add(Elf64_Shdr *sechd
  		sym = (Elf64_Sym *)sechdrs[symindex].sh_addr
  			+ ELF64_R_SYM(rel[i].r_info);

+#ifdef CONFIG_X86_PIC
+		BUG_ON(check_relocation_pic_safe(&rel[i], sym));
+#endif
+
  		DEBUGP("type %d st_value %Lx r_addend %Lx loc %Lx\n",
  		       (int)ELF64_R_TYPE(rel[i].r_info),
  		       sym->st_value, rel[i].r_addend, (u64)loc);
@@ -358,21 +574,30 @@ int apply_relocate_add(Elf64_Shdr *sechd
  			if ((s64)val != *(s32 *)loc)
  				goto overflow;
  			break;
-#ifdef CONFIG_X86_PIE
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
+		case R_X86_64_PLT32:
+			val = module_emit_plt_entry(me, loc, rel + i, sym)
+				+ rel[i].r_addend;
+			if (*(u32 *)loc != 0)
+				goto invalid_relocation;
+			val -= (u64)loc;
+			*(u32 *)loc = val;
+			break;
  		default:
  			pr_err("%s: Unknown rela relocation: %llu\n",
  			       me->name, ELF64_R_TYPE(rel[i].r_info));
diff -uprN a/arch/x86/kernel/module.lds b/arch/x86/kernel/module.lds
--- a/arch/x86/kernel/module.lds	2019-01-15 11:20:45.271168382 -0500
+++ b/arch/x86/kernel/module.lds	2019-01-15 11:34:00.009852393 -0500
@@ -1,3 +1,4 @@
  SECTIONS {
  	.got (NOLOAD) : { BYTE(0) }
+	.plt (NOLOAD) : { BYTE(0) }
  }
diff -uprN a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
--- a/arch/x86/kvm/emulate.c	2019-01-15 11:20:45.275168421 -0500
+++ b/arch/x86/kvm/emulate.c	2019-01-15 11:34:00.013854257 -0500
@@ -428,7 +428,6 @@ static int fastop(struct x86_emulate_ctx
  	FOP_RET

  asm(".pushsection .fixup, \"ax\"\n"
-    ".global kvm_fastop_exception \n"
      "kvm_fastop_exception: xor %esi, %esi; ret\n"
      ".popsection");

diff -uprN a/arch/x86/Makefile b/arch/x86/Makefile
--- a/arch/x86/Makefile	2019-01-15 11:20:45.259168260 -0500
+++ b/arch/x86/Makefile	2019-01-15 11:34:00.013854257 -0500
@@ -136,6 +136,17 @@ else
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
diff -uprN a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
--- a/arch/x86/tools/relocs.c	2019-01-15 11:20:45.279168462 -0500
+++ b/arch/x86/tools/relocs.c	2019-01-15 11:34:00.013854257 -0500
@@ -210,6 +210,8 @@ static const char *rel_type(unsigned typ
  		REL_TYPE(R_X86_64_JUMP_SLOT),
  		REL_TYPE(R_X86_64_RELATIVE),
  		REL_TYPE(R_X86_64_GOTPCREL),
+		REL_TYPE(R_X86_64_REX_GOTPCRELX),
+		REL_TYPE(R_X86_64_GOTPCRELX),
  		REL_TYPE(R_X86_64_32),
  		REL_TYPE(R_X86_64_32S),
  		REL_TYPE(R_X86_64_16),
@@ -866,6 +868,8 @@ static int do_reloc64(struct section *se
  		offset += per_cpu_load_addr;

  	switch (r_type) {
+	case R_X86_64_REX_GOTPCRELX:
+	case R_X86_64_GOTPCRELX:
  	case R_X86_64_GOTPCREL:
  	case R_X86_64_NONE:
  		/* NONE can be ignored. */
diff -uprN a/Makefile b/Makefile
--- a/Makefile	2019-01-15 11:20:45.087166523 -0500
+++ b/Makefile	2019-01-15 11:34:00.013854257 -0500
@@ -1207,10 +1207,10 @@ all: modules
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
diff -uprN a/scripts/Makefile.modpost b/scripts/Makefile.modpost
--- a/scripts/Makefile.modpost	2019-01-15 11:20:45.399169674 -0500
+++ b/scripts/Makefile.modpost	2019-01-15 11:34:00.013854257 -0500
@@ -125,7 +125,7 @@ quiet_cmd_ld_ko_o = LD [M]  $@
                   -o $@ $(filter-out FORCE,$^) ;                         \
  	$(if $(ARCH_POSTLINK), $(MAKE) -f $(ARCH_POSTLINK) $@, true)

-$(modules): %.ko :%.o %.mod.o FORCE
+$(modules): %.ko :%.o %.mod.o $(MOD_EXTRA_LINK) FORCE
  	+$(call if_changed,ld_ko_o)

  targets += $(modules)
diff -uprN a/scripts/recordmcount.c b/scripts/recordmcount.c
--- a/scripts/recordmcount.c	2019-01-15 11:20:45.399169674 -0500
+++ b/scripts/recordmcount.c	2019-01-15 11:34:00.013854257 -0500
@@ -453,7 +453,8 @@ static int make_nop_x86(void *map, size_
  /* Swap the stub and nop for a got call if the binary is built with PIE */
  static int is_fake_mcount_x86_x64(Elf64_Rel const *rp)
  {
-	if (ELF64_R_TYPE(rp->r_info) == R_X86_64_GOTPCREL) {
+	if (ELF64_R_TYPE(rp->r_info) == R_X86_64_GOTPCREL ||
+	    ELF64_R_TYPE(rp->r_info) == R_X86_64_GOTPCRELX) {
  		ideal_nop = ideal_nop6_x86_64;
  		ideal_nop_x86_size = sizeof(ideal_nop6_x86_64);
  		stub_x86 = stub_got_x86;
