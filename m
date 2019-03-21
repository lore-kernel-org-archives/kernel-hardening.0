From: Ruslan Nikolaev <nruslan_devel@yahoo.com>
Subject: [PATCH v2 01/01]: Prerequisites for PIC modules
Message-ID: <04e2b8e3-81cb-4dd9-d056-7361d6bf8323@yahoo.com>
Date: Wed, 20 Mar 2019 21:30:28 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: kernel-hardening@lists.openwall.com
Cc: thgarnie@google.com, x86@kernel.org, kstewart@linuxfoundation.org, gregkh@linuxfoundation.org, keescook@chromium.org, jpoimboe@redhat.com
List-ID: <kernel-hardening.lists.openwall.com>

The patchset extends the prior PIE kernel patch (by Thomas Garnier) to also
support position-independent modules that can be placed anywhere in the
48/64-bit address space (for better KASLR). The patch extends PIE v6.

The first part provides some fixes for the PIE patch as well as
some improvements/prerequisites for position-independent modules.
It also avoids generating the same object file in several places for
the kernel and modules.

Signed-off-by: Ruslan Nikolaev <rnikola@vt.edu>
Signed-off-by: Hassan Nadeem <hnadeem@vt.edu>
---
  arch/x86/crypto/aes-x86_64-asm_64.S       |   81 
++++++++++++++++++------------
  arch/x86/crypto/camellia-x86_64-asm_64.S  |    5 +
  arch/x86/crypto/cast5-avx-x86_64-asm_64.S |    9 +--
  arch/x86/crypto/cast6-avx-x86_64-asm_64.S |    9 +--
  arch/x86/include/asm/asm.h                |   67 +++++++++++++++++++++++-
  arch/x86/kernel/kvm.c                     |    8 +-
  lib/zstd/Makefile                         |    2
  lib/zstd/entropy_common_dec.c             |    2
  lib/zstd/fse_decompress_dec.c             |    2
  lib/zstd/zstd_common_dec.c                |    2
  10 files changed, 138 insertions(+), 49 deletions(-)

diff -uprN a/arch/x86/crypto/aes-x86_64-asm_64.S 
b/arch/x86/crypto/aes-x86_64-asm_64.S
--- a/arch/x86/crypto/aes-x86_64-asm_64.S	2019-03-16 10:50:57.093692118 
-0400
+++ b/arch/x86/crypto/aes-x86_64-asm_64.S	2019-03-20 19:42:23.627815384 
-0400
@@ -17,6 +17,7 @@

  #include <linux/linkage.h>
  #include <asm/asm-offsets.h>
+#include <asm/asm.h>

  #define R1	%rax
  #define R1E	%eax
@@ -48,12 +49,34 @@
  #define R10	%r10
  #define R11	%r11

-/* Hold global for PIE support */
+/* Hold global for PIE/PIC support */
  #define RBASE	%r12

-#define prologue(FUNC,KEY,B128,B192,r1,r2,r5,r6,r7,r8,r9,r10,r11) \
+#if defined(CONFIG_X86_PIE) || (defined(MODULE) && defined(CONFIG_X86_PIC))
+# define rbase_save			\
+	pushq   RBASE;
+# define rbase_restore			\
+	popq    RBASE;
+# define rbase_load(tab)		\
+	_ASM_LEA(tab, %rip, RBASE);
+# define round_mov(tab, tab_off, reg_i, reg_o)	\
+	movl    tab_off(RBASE,reg_i,4), reg_o;
+# define round_xor(tab, tab_off, reg_i, reg_o)	\
+	xorl    tab_off(RBASE,reg_i,4), reg_o;
+#else
+# define rbase_save
+# define rbase_restore
+# define rbase_load(tab)
+# define round_mov(tab, tab_off, reg_i, reg_o)	\
+	movl    tab+tab_off(,reg_i,4), reg_o;
+# define round_xor(tab, tab_off, reg_i, reg_o)	\
+	xorl    tab+tab_off(,reg_i,4), reg_o;
+#endif
+
+#define prologue(FUNC,KEY,B128,B192,TAB,r1,r2,r5,r6,r7,r8,r9,r10,r11) \
  	ENTRY(FUNC);			\
-	pushq	RBASE;			\
+	rbase_save			\
+	rbase_load(TAB)			\
  	movq	r1,r2;			\
  	leaq	KEY+48(r8),r9;		\
  	movq	r10,r11;		\
@@ -78,70 +101,62 @@
  	movl	r6 ## E,4(r9);		\
  	movl	r7 ## E,8(r9);		\
  	movl	r8 ## E,12(r9);		\
-	popq	RBASE;			\
+	rbase_restore			\
  	ret;				\
  	ENDPROC(FUNC);

-#define round_mov(tab_off, reg_i, reg_o) \
-	leaq	tab_off(%rip), RBASE; \
-	movl	(RBASE,reg_i,4), reg_o;
-
-#define round_xor(tab_off, reg_i, reg_o) \
-	leaq	tab_off(%rip), RBASE; \
-	xorl	(RBASE,reg_i,4), reg_o;
-
  #define round(TAB,OFFSET,r1,r2,r3,r4,r5,r6,r7,r8,ra,rb,rc,rd) \
  	movzbl	r2 ## H,r5 ## E;	\
  	movzbl	r2 ## L,r6 ## E;	\
-	round_mov(TAB+1024, r5, r5 ## E)\
+	round_mov(TAB, 1024, r5, r5 ## E)\
  	movw	r4 ## X,r2 ## X;	\
-	round_mov(TAB, r6, r6 ## E)	\
+	round_mov(TAB, 0, r6, r6 ## E)	\
  	roll	$16,r2 ## E;		\
  	shrl	$16,r4 ## E;		\
  	movzbl	r4 ## L,r7 ## E;	\
  	movzbl	r4 ## H,r4 ## E;	\
  	xorl	OFFSET(r8),ra ## E;	\
  	xorl	OFFSET+4(r8),rb ## E;	\
-	round_xor(TAB+3072, r4, r5 ## E)\
-	round_xor(TAB+2048, r7, r6 ## E)\
+	round_xor(TAB, 3072, r4, r5 ## E)\
+	round_xor(TAB, 2048, r7, r6 ## E)\
  	movzbl	r1 ## L,r7 ## E;	\
  	movzbl	r1 ## H,r4 ## E;	\
-	round_mov(TAB+1024, r4, r4 ## E)\
+	round_mov(TAB, 1024, r4, r4 ## E)\
  	movw	r3 ## X,r1 ## X;	\
  	roll	$16,r1 ## E;		\
  	shrl	$16,r3 ## E;		\
-	round_xor(TAB, r7, r5 ## E)	\
+	round_xor(TAB, 0, r7, r5 ## E)	\
  	movzbl	r3 ## L,r7 ## E;	\
  	movzbl	r3 ## H,r3 ## E;	\
-	round_xor(TAB+3072, r3, r4 ## E)\
-	round_xor(TAB+2048, r7, r5 ## E)\
+	round_xor(TAB, 3072, r3, r4 ## E)\
+	round_xor(TAB, 2048, r7, r5 ## E)\
  	movzbl	r1 ## L,r7 ## E;	\
  	movzbl	r1 ## H,r3 ## E;	\
  	shrl	$16,r1 ## E;		\
-	round_xor(TAB+3072, r3, r6 ## E)\
-	round_mov(TAB+2048, r7, r3 ## E)\
+	round_xor(TAB, 3072, r3, r6 ## E)\
+	round_mov(TAB, 2048, r7, r3 ## E)\
  	movzbl	r1 ## L,r7 ## E;	\
  	movzbl	r1 ## H,r1 ## E;	\
-	round_xor(TAB+1024, r1, r6 ## E)\
-	round_xor(TAB, r7, r3 ## E)	\
+	round_xor(TAB, 1024, r1, r6 ## E)\
+	round_xor(TAB, 0, r7, r3 ## E)	\
  	movzbl	r2 ## H,r1 ## E;	\
  	movzbl	r2 ## L,r7 ## E;	\
  	shrl	$16,r2 ## E;		\
-	round_xor(TAB+3072, r1, r3 ## E)\
-	round_xor(TAB+2048, r7, r4 ## E)\
+	round_xor(TAB, 3072, r1, r3 ## E)\
+	round_xor(TAB, 2048, r7, r4 ## E)\
  	movzbl	r2 ## H,r1 ## E;	\
  	movzbl	r2 ## L,r2 ## E;	\
  	xorl	OFFSET+8(r8),rc ## E;	\
  	xorl	OFFSET+12(r8),rd ## E;	\
-	round_xor(TAB+1024, r1, r3 ## E)\
-	round_xor(TAB, r2, r4 ## E)
+	round_xor(TAB, 1024, r1, r3 ## E)\
+	round_xor(TAB, 0, r2, r4 ## E)

  #define move_regs(r1,r2,r3,r4) \
  	movl	r3 ## E,r1 ## E;	\
  	movl	r4 ## E,r2 ## E;

-#define entry(FUNC,KEY,B128,B192) \
-	prologue(FUNC,KEY,B128,B192,R2,R8,R1,R3,R4,R6,R10,R5,R11)
+#define entry(FUNC,KEY,B128,B192,TAB) \
+	prologue(FUNC,KEY,B128,B192,TAB,R2,R8,R1,R3,R4,R6,R10,R5,R11)

  #define return(FUNC) epilogue(FUNC,R8,R2,R5,R6,R3,R4,R11)

@@ -161,7 +176,7 @@

  /* void aes_enc_blk(stuct crypto_tfm *tfm, u8 *out, const u8 *in) */

-	entry(aes_enc_blk,0,.Le128,.Le192)
+	entry(aes_enc_blk,0,.Le128,.Le192,crypto_ft_tab)
  	encrypt_round(crypto_ft_tab,-96)
  	encrypt_round(crypto_ft_tab,-80)
  .Le192:	encrypt_round(crypto_ft_tab,-64)
@@ -175,12 +190,13 @@
  	encrypt_round(crypto_ft_tab, 64)
  	encrypt_round(crypto_ft_tab, 80)
  	encrypt_round(crypto_ft_tab, 96)
+	rbase_load(crypto_fl_tab)
  	encrypt_final(crypto_fl_tab,112)
  	return(aes_enc_blk)

  /* void aes_dec_blk(struct crypto_tfm *tfm, u8 *out, const u8 *in) */

-	entry(aes_dec_blk,240,.Ld128,.Ld192)
+	entry(aes_dec_blk,240,.Ld128,.Ld192,crypto_it_tab)
  	decrypt_round(crypto_it_tab,-96)
  	decrypt_round(crypto_it_tab,-80)
  .Ld192:	decrypt_round(crypto_it_tab,-64)
@@ -194,5 +210,6 @@
  	decrypt_round(crypto_it_tab, 64)
  	decrypt_round(crypto_it_tab, 80)
  	decrypt_round(crypto_it_tab, 96)
+	rbase_load(crypto_il_tab)
  	decrypt_final(crypto_il_tab,112)
  	return(aes_dec_blk)
diff -uprN a/arch/x86/crypto/camellia-x86_64-asm_64.S 
b/arch/x86/crypto/camellia-x86_64-asm_64.S
--- a/arch/x86/crypto/camellia-x86_64-asm_64.S	2019-03-16 
10:50:57.093692118 -0400
+++ b/arch/x86/crypto/camellia-x86_64-asm_64.S	2019-03-20 
19:42:23.627815384 -0400
@@ -21,6 +21,7 @@
   */

  #include <linux/linkage.h>
+#include <asm/asm.h>

  .file "camellia-x86_64-asm_64.S"
  .text
@@ -92,10 +93,10 @@
  #define RXORbl %r9b

  #define xor2ror16(T0, T1, tmp1, tmp2, ab, dst) \
-	leaq T0(%rip), 			tmp1; \
+	_ASM_LEA(T0, %rip, tmp1); \
  	movzbl ab ## bl,		tmp2 ## d; \
  	xorq (tmp1, tmp2, 8),		dst; \
-	leaq T1(%rip), 			tmp2; \
+	_ASM_LEA(T1, %rip, tmp2); \
  	movzbl ab ## bh,		tmp1 ## d; \
  	xorq (tmp2, tmp1, 8),		dst; \
  	rorq $16,			ab;
diff -uprN a/arch/x86/crypto/cast5-avx-x86_64-asm_64.S 
b/arch/x86/crypto/cast5-avx-x86_64-asm_64.S
--- a/arch/x86/crypto/cast5-avx-x86_64-asm_64.S	2019-03-16 
10:50:57.093692118 -0400
+++ b/arch/x86/crypto/cast5-avx-x86_64-asm_64.S	2019-03-20 
19:42:23.627815384 -0400
@@ -25,6 +25,7 @@

  #include <linux/linkage.h>
  #include <asm/frame.h>
+#include <asm/asm.h>

  .file "cast5-avx-x86_64-asm_64.S"

@@ -99,17 +100,17 @@

  #define lookup_32bit(src, dst, op1, op2, op3, interleave_op, il_reg) \
  	movzbl		src ## bh,       RID1d;    \
-	leaq		s1(%rip),        RID2;     \
+	_ASM_LEA(s1, %rip, RID2);                  \
  	movl		(RID2, RID1, 4), dst ## d; \
  	movzbl		src ## bl,       RID2d;    \
-	leaq		s2(%rip),        RID1;     \
+	_ASM_LEA(s2, %rip, RID1);                  \
  	op1		(RID1, RID2, 4), dst ## d; \
  	shrq $16,	src;                       \
  	movzbl		src ## bh,     RID1d;      \
-	leaq		s3(%rip),        RID2;     \
+	_ASM_LEA(s3, %rip, RID2);                  \
  	op2		(RID2, RID1, 4), dst ## d; \
  	movzbl		src ## bl,     RID2d;      \
-	leaq		s4(%rip),        RID1;     \
+	_ASM_LEA(s4, %rip, RID1);                  \
  	op3		(RID1, RID2, 4), dst ## d; \
  	interleave_op(il_reg);

diff -uprN a/arch/x86/crypto/cast6-avx-x86_64-asm_64.S 
b/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
--- a/arch/x86/crypto/cast6-avx-x86_64-asm_64.S	2019-03-16 
10:50:57.093692118 -0400
+++ b/arch/x86/crypto/cast6-avx-x86_64-asm_64.S	2019-03-20 
19:42:23.627815384 -0400
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
+	_ASM_LEA(s1, %rip, RID2);                  \
  	movl		(RID2, RID1, 4), dst ## d; \
  	movzbl		src ## bl,       RID2d;    \
-	leaq		s2(%rip),        RID1;     \
+	_ASM_LEA(s2, %rip, RID1);                  \
  	op1		(RID1, RID2, 4), dst ## d; \
  	shrq $16,	src;                       \
  	movzbl		src ## bh,     RID1d;      \
-	leaq		s3(%rip),        RID2;     \
+	_ASM_LEA(s3, %rip, RID2);                  \
  	op2		(RID2, RID1, 4), dst ## d; \
  	movzbl		src ## bl,     RID2d;      \
-	leaq		s4(%rip),        RID1;     \
+	_ASM_LEA(s4, %rip, RID1);                  \
  	op3		(RID1, RID2, 4), dst ## d; \
  	interleave_op(il_reg);

diff -uprN a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
--- a/arch/x86/include/asm/asm.h	2019-03-16 10:50:57.097692208 -0400
+++ b/arch/x86/include/asm/asm.h	2019-03-20 19:42:23.631815425 -0400
@@ -2,6 +2,48 @@
  #ifndef _ASM_X86_ASM_H
  #define _ASM_X86_ASM_H

+/*
+ * PIC modules require an indirection through GOT for
+ * external symbols. _ASM_CALL/_ASM_JMP for internal functions
+ * is optimized by replacing indirect calls with direct ones
+ * followed by 1-byte NOP paddings per a call site;
+ * Similarly, _ASM_LEA is optimized by replacing MOV
+ * to LEA and is used to load symbol addresses on x86-64.
+ * If RETPOLINE is enabled, use PLT stubs instead to
+ * avoid overheads for local calls.
+ */
+#if defined(MODULE) && defined(CONFIG_X86_PIC)
+# ifdef __ASSEMBLY__
+#  define _ASM_LEA(v,r,a)	movq v##@GOTPCREL(##r##), a
+#  ifdef CONFIG_RETPOLINE
+#   define _ASM_CALL(f)		call f##@PLT
+#   define _ASM_JMP(f)		jmp f##@PLT
+#  else
+#   define _ASM_CALL(f)		call *##f##@GOTPCREL(%rip)
+#   define _ASM_JMP(f)		jmp *##f##@GOTPCREL(%rip)
+#  endif
+# else
+#  define _ASM_LEA(v,r,a)	"movq " #v "@GOTPCREL(" #r "), " #a
+#  ifdef CONFIG_RETPOLINE
+#   define _ASM_CALL(f)		"call " #f "@PLT"
+#   define _ASM_JMP(f)		"jmp " #f "@PLT"
+#  else
+#   define _ASM_CALL(f)		"call *" #f "@GOTPCREL(%%rip)"
+#   define _ASM_JMP(f)		"jmp *" #f "@GOTPCREL(%%rip)"
+#  endif
+# endif
+#else
+# ifdef __ASSEMBLY__
+#  define _ASM_CALL(f)		call f
+#  define _ASM_JMP(f)		jmp f
+#  define _ASM_LEA(v,r,a)	leaq v##(##r##), a
+# else
+#  define _ASM_CALL(f)		"call " #f
+#  define _ASM_JMP(f)		"jmp " #f
+#  define _ASM_LEA(v,r,a)	"leaq " #v "(" #r "), " #a
+# endif
+#endif
+
  #ifdef __ASSEMBLY__
  # define __ASM_FORM(x)	x
  # define __ASM_FORM_RAW(x)     x
@@ -118,6 +160,25 @@
  # define CC_OUT(c) [_cc_ ## c] "=qm"
  #endif

+/*
+ * PLT relocations in x86_64 PIC modules are already relative.
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
@@ -125,7 +186,7 @@
  	.balign 4 ;						\
  	.long (from) - . ;					\
  	.long (to) - . ;					\
-	.long (handler) - . ;					\
+	.long _ASM_HANDLER(handler);				\
  	.popsection

  # define _ASM_EXTABLE(from, to)					\
@@ -174,13 +235,13 @@
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
diff -uprN a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
--- a/arch/x86/kernel/kvm.c	2019-03-16 10:50:57.101692298 -0400
+++ b/arch/x86/kernel/kvm.c	2019-03-20 19:42:23.635815466 -0400
@@ -826,10 +826,12 @@ asm(
  ".global __raw_callee_save___kvm_vcpu_is_preempted;"
  ".type __raw_callee_save___kvm_vcpu_is_preempted, @function;"
  "__raw_callee_save___kvm_vcpu_is_preempted:"
-"leaq	__per_cpu_offset(%rip), %rax;"
+"pushq	%rdi;"
+_ASM_LEA(__per_cpu_offset, %rip, %rax) ";"
  "movq	(%rax,%rdi,8), %rax;"
-"addq	" __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rip), %rax;"
-"cmpb	$0, (%rax);"
+"leaq	" __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rip), %rdi;"
+"cmpb	$0, (%rax,%rdi,1);"
+"popq	%rdi;"
  "setne	%al;"
  "ret;"
  ".popsection");
diff -uprN a/lib/zstd/entropy_common_dec.c b/lib/zstd/entropy_common_dec.c
--- a/lib/zstd/entropy_common_dec.c	1969-12-31 19:00:00.000000000 -0500
+++ b/lib/zstd/entropy_common_dec.c	2019-03-20 19:42:23.635815466 -0400
@@ -0,0 +1,2 @@
+// SPDX-License-Identifier: BSD-2-Clause OR GPL-2.0
+#include "entropy_common.c"
diff -uprN a/lib/zstd/fse_decompress_dec.c b/lib/zstd/fse_decompress_dec.c
--- a/lib/zstd/fse_decompress_dec.c	1969-12-31 19:00:00.000000000 -0500
+++ b/lib/zstd/fse_decompress_dec.c	2019-03-20 19:42:23.635815466 -0400
@@ -0,0 +1,2 @@
+// SPDX-License-Identifier: BSD-2-Clause OR GPL-2.0
+#include "fse_decompress.c"
diff -uprN a/lib/zstd/Makefile b/lib/zstd/Makefile
--- a/lib/zstd/Makefile	2019-03-13 17:01:32.000000000 -0400
+++ b/lib/zstd/Makefile	2019-03-20 19:42:23.635815466 -0400
@@ -6,4 +6,4 @@ ccflags-y += -O3
  zstd_compress-y := fse_compress.o huf_compress.o compress.o \
  		   entropy_common.o fse_decompress.o zstd_common.o
  zstd_decompress-y := huf_decompress.o decompress.o \
-		     entropy_common.o fse_decompress.o zstd_common.o
+		     entropy_common_dec.o fse_decompress_dec.o zstd_common_dec.o
diff -uprN a/lib/zstd/zstd_common_dec.c b/lib/zstd/zstd_common_dec.c
--- a/lib/zstd/zstd_common_dec.c	1969-12-31 19:00:00.000000000 -0500
+++ b/lib/zstd/zstd_common_dec.c	2019-03-20 19:42:23.635815466 -0400
@@ -0,0 +1,2 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+#include "zstd_common.c"
