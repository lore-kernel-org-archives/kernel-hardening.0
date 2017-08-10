From: Thomas Garnier <thgarnie@google.com>
Date: Thu, 10 Aug 2017 10:25:53 -0700
Message-Id: <20170810172615.51965-2-thgarnie@google.com>
In-Reply-To: <20170810172615.51965-1-thgarnie@google.com>
References: <20170810172615.51965-1-thgarnie@google.com>
Subject: [kernel-hardening] [RFC v2 01/23] x86/crypto: Adapt assembly for PIE support
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Garnier <thgarnie@google.com>, Matthias Kaehlcke <mka@chromium.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Tom Lendacky <thomas.lendacky@amd.com>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Brian Gerst <brgerst@gmail.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Chris Metcalf <cmetcalf@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Nicolas Pitre <nicolas.pitre@linaro.org>, Christopher Li <sparse@chrisli.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Lukas Wunner <lukas@wunner.de>, Mika Westerberg <mika.westerberg@linux.intel.com>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Markus Trippelsdorf <markus@trippelsdorf.de>, Steven Rostedt <rostedt@goodmis.org>, Kees Cook <keescook@chromium.org>, Rik van Riel <riel@redhat.com>, David Howells <dhowells@redhat.com>, Waiman Long <longman@redhat.com>, Kyle Huey <me@kylehuey.com>, Peter Foley <pefoley2@pefoley.com>, Tim Chen <tim.c.chen@linux.intel.com>, Catalin Marinas <catalin.marinas@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Michal Hocko <mhocko@suse.com>, Matthew Wilcox <mawilcox@microsoft.com>, "H . J . Lu" <hjl.tools@gmail.com>, Paul Bolle <pebolle@tiscali.nl>, Rob Landley <rob@landley.net>, Baoquan He <bhe@redhat.com>, Daniel Micay <danielmicay@gmail.com>
Cc: x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org, kvm@vger.kernel.org, linux-pm@vger.kernel.org, linux-arch@vger.kernel.org, linux-sparse@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Change the assembly code to use only relative references of symbols for the
kernel to be PIE compatible.

Position Independent Executable (PIE) support will allow to extended the
KASLR randomization range below the -2G memory limit.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/x86/crypto/aes-x86_64-asm_64.S          | 45 ++++++++-----
 arch/x86/crypto/aesni-intel_asm.S            | 14 ++--
 arch/x86/crypto/aesni-intel_avx-x86_64.S     |  6 +-
 arch/x86/crypto/camellia-aesni-avx-asm_64.S  | 42 ++++++------
 arch/x86/crypto/camellia-aesni-avx2-asm_64.S | 44 ++++++-------
 arch/x86/crypto/camellia-x86_64-asm_64.S     |  8 ++-
 arch/x86/crypto/cast5-avx-x86_64-asm_64.S    | 50 ++++++++-------
 arch/x86/crypto/cast6-avx-x86_64-asm_64.S    | 44 +++++++------
 arch/x86/crypto/des3_ede-asm_64.S            | 96 ++++++++++++++++++----------
 arch/x86/crypto/ghash-clmulni-intel_asm.S    |  4 +-
 arch/x86/crypto/glue_helper-asm-avx.S        |  4 +-
 arch/x86/crypto/glue_helper-asm-avx2.S       |  6 +-
 12 files changed, 211 insertions(+), 152 deletions(-)

diff --git a/arch/x86/crypto/aes-x86_64-asm_64.S b/arch/x86/crypto/aes-x86_64-asm_64.S
index 8739cf7795de..86fa068e5e81 100644
--- a/arch/x86/crypto/aes-x86_64-asm_64.S
+++ b/arch/x86/crypto/aes-x86_64-asm_64.S
@@ -48,8 +48,12 @@
 #define R10	%r10
 #define R11	%r11
 
+/* Hold global for PIE suport */
+#define RBASE	%r12
+
 #define prologue(FUNC,KEY,B128,B192,r1,r2,r5,r6,r7,r8,r9,r10,r11) \
 	ENTRY(FUNC);			\
+	pushq	RBASE;			\
 	movq	r1,r2;			\
 	leaq	KEY+48(r8),r9;		\
 	movq	r10,r11;		\
@@ -74,54 +78,63 @@
 	movl	r6 ## E,4(r9);		\
 	movl	r7 ## E,8(r9);		\
 	movl	r8 ## E,12(r9);		\
+	popq	RBASE;			\
 	ret;				\
 	ENDPROC(FUNC);
 
+#define round_mov(tab_off, reg_i, reg_o) \
+	leaq	tab_off(%rip), RBASE; \
+	movl	(RBASE,reg_i,4), reg_o;
+
+#define round_xor(tab_off, reg_i, reg_o) \
+	leaq	tab_off(%rip), RBASE; \
+	xorl	(RBASE,reg_i,4), reg_o;
+
 #define round(TAB,OFFSET,r1,r2,r3,r4,r5,r6,r7,r8,ra,rb,rc,rd) \
 	movzbl	r2 ## H,r5 ## E;	\
 	movzbl	r2 ## L,r6 ## E;	\
-	movl	TAB+1024(,r5,4),r5 ## E;\
+	round_mov(TAB+1024, r5, r5 ## E)\
 	movw	r4 ## X,r2 ## X;	\
-	movl	TAB(,r6,4),r6 ## E;	\
+	round_mov(TAB, r6, r6 ## E)	\
 	roll	$16,r2 ## E;		\
 	shrl	$16,r4 ## E;		\
 	movzbl	r4 ## L,r7 ## E;	\
 	movzbl	r4 ## H,r4 ## E;	\
 	xorl	OFFSET(r8),ra ## E;	\
 	xorl	OFFSET+4(r8),rb ## E;	\
-	xorl	TAB+3072(,r4,4),r5 ## E;\
-	xorl	TAB+2048(,r7,4),r6 ## E;\
+	round_xor(TAB+3072, r4, r5 ## E)\
+	round_xor(TAB+2048, r7, r6 ## E)\
 	movzbl	r1 ## L,r7 ## E;	\
 	movzbl	r1 ## H,r4 ## E;	\
-	movl	TAB+1024(,r4,4),r4 ## E;\
+	round_mov(TAB+1024, r4, r4 ## E)\
 	movw	r3 ## X,r1 ## X;	\
 	roll	$16,r1 ## E;		\
 	shrl	$16,r3 ## E;		\
-	xorl	TAB(,r7,4),r5 ## E;	\
+	round_xor(TAB, r7, r5 ## E)	\
 	movzbl	r3 ## L,r7 ## E;	\
 	movzbl	r3 ## H,r3 ## E;	\
-	xorl	TAB+3072(,r3,4),r4 ## E;\
-	xorl	TAB+2048(,r7,4),r5 ## E;\
+	round_xor(TAB+3072, r3, r4 ## E)\
+	round_xor(TAB+2048, r7, r5 ## E)\
 	movzbl	r1 ## L,r7 ## E;	\
 	movzbl	r1 ## H,r3 ## E;	\
 	shrl	$16,r1 ## E;		\
-	xorl	TAB+3072(,r3,4),r6 ## E;\
-	movl	TAB+2048(,r7,4),r3 ## E;\
+	round_xor(TAB+3072, r3, r6 ## E)\
+	round_mov(TAB+2048, r7, r3 ## E)\
 	movzbl	r1 ## L,r7 ## E;	\
 	movzbl	r1 ## H,r1 ## E;	\
-	xorl	TAB+1024(,r1,4),r6 ## E;\
-	xorl	TAB(,r7,4),r3 ## E;	\
+	round_xor(TAB+1024, r1, r6 ## E)\
+	round_xor(TAB, r7, r3 ## E)	\
 	movzbl	r2 ## H,r1 ## E;	\
 	movzbl	r2 ## L,r7 ## E;	\
 	shrl	$16,r2 ## E;		\
-	xorl	TAB+3072(,r1,4),r3 ## E;\
-	xorl	TAB+2048(,r7,4),r4 ## E;\
+	round_xor(TAB+3072, r1, r3 ## E)\
+	round_xor(TAB+2048, r7, r4 ## E)\
 	movzbl	r2 ## H,r1 ## E;	\
 	movzbl	r2 ## L,r2 ## E;	\
 	xorl	OFFSET+8(r8),rc ## E;	\
 	xorl	OFFSET+12(r8),rd ## E;	\
-	xorl	TAB+1024(,r1,4),r3 ## E;\
-	xorl	TAB(,r2,4),r4 ## E;
+	round_xor(TAB+1024, r1, r3 ## E)\
+	round_xor(TAB, r2, r4 ## E)
 
 #define move_regs(r1,r2,r3,r4) \
 	movl	r3 ## E,r1 ## E;	\
diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index 16627fec80b2..5f73201dff32 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -325,7 +325,8 @@ _get_AAD_rest0\num_initial_blocks\operation:
 	vpshufb and an array of shuffle masks */
 	movq	   %r12, %r11
 	salq	   $4, %r11
-	movdqu	   aad_shift_arr(%r11), \TMP1
+	leaq	   aad_shift_arr(%rip), %rax
+	movdqu	   (%rax,%r11,), \TMP1
 	PSHUFB_XMM \TMP1, %xmm\i
 _get_AAD_rest_final\num_initial_blocks\operation:
 	PSHUFB_XMM   %xmm14, %xmm\i # byte-reflect the AAD data
@@ -584,7 +585,8 @@ _get_AAD_rest0\num_initial_blocks\operation:
 	vpshufb and an array of shuffle masks */
 	movq	   %r12, %r11
 	salq	   $4, %r11
-	movdqu	   aad_shift_arr(%r11), \TMP1
+	leaq	   aad_shift_arr(%rip), %rax
+	movdqu	   (%rax,%r11,), \TMP1
 	PSHUFB_XMM \TMP1, %xmm\i
 _get_AAD_rest_final\num_initial_blocks\operation:
 	PSHUFB_XMM   %xmm14, %xmm\i # byte-reflect the AAD data
@@ -2722,7 +2724,7 @@ ENDPROC(aesni_cbc_dec)
  */
 .align 4
 _aesni_inc_init:
-	movaps .Lbswap_mask, BSWAP_MASK
+	movaps .Lbswap_mask(%rip), BSWAP_MASK
 	movaps IV, CTR
 	PSHUFB_XMM BSWAP_MASK CTR
 	mov $1, TCTR_LOW
@@ -2850,12 +2852,12 @@ ENTRY(aesni_xts_crypt8)
 	cmpb $0, %cl
 	movl $0, %ecx
 	movl $240, %r10d
-	leaq _aesni_enc4, %r11
-	leaq _aesni_dec4, %rax
+	leaq _aesni_enc4(%rip), %r11
+	leaq _aesni_dec4(%rip), %rax
 	cmovel %r10d, %ecx
 	cmoveq %rax, %r11
 
-	movdqa .Lgf128mul_x_ble_mask, GF128MUL_MASK
+	movdqa .Lgf128mul_x_ble_mask(%rip), GF128MUL_MASK
 	movups (IVP), IV
 
 	mov 480(KEYP), KLEN
diff --git a/arch/x86/crypto/aesni-intel_avx-x86_64.S b/arch/x86/crypto/aesni-intel_avx-x86_64.S
index faecb1518bf8..488605b19fe8 100644
--- a/arch/x86/crypto/aesni-intel_avx-x86_64.S
+++ b/arch/x86/crypto/aesni-intel_avx-x86_64.S
@@ -454,7 +454,8 @@ _get_AAD_rest0\@:
 	vpshufb and an array of shuffle masks */
 	movq    %r12, %r11
 	salq    $4, %r11
-	movdqu  aad_shift_arr(%r11), \T1
+	leaq	aad_shift_arr(%rip), %rax
+	movdqu  (%rax,%r11,), \T1
 	vpshufb \T1, reg_i, reg_i
 _get_AAD_rest_final\@:
 	vpshufb SHUF_MASK(%rip), reg_i, reg_i
@@ -1761,7 +1762,8 @@ _get_AAD_rest0\@:
 	vpshufb and an array of shuffle masks */
 	movq    %r12, %r11
 	salq    $4, %r11
-	movdqu  aad_shift_arr(%r11), \T1
+	leaq	aad_shift_arr(%rip), %rax
+	movdqu  (%rax,%r11,), \T1
 	vpshufb \T1, reg_i, reg_i
 _get_AAD_rest_final\@:
 	vpshufb SHUF_MASK(%rip), reg_i, reg_i
diff --git a/arch/x86/crypto/camellia-aesni-avx-asm_64.S b/arch/x86/crypto/camellia-aesni-avx-asm_64.S
index f7c495e2863c..46feaea52632 100644
--- a/arch/x86/crypto/camellia-aesni-avx-asm_64.S
+++ b/arch/x86/crypto/camellia-aesni-avx-asm_64.S
@@ -52,10 +52,10 @@
 	/* \
 	 * S-function with AES subbytes \
 	 */ \
-	vmovdqa .Linv_shift_row, t4; \
-	vbroadcastss .L0f0f0f0f, t7; \
-	vmovdqa .Lpre_tf_lo_s1, t0; \
-	vmovdqa .Lpre_tf_hi_s1, t1; \
+	vmovdqa .Linv_shift_row(%rip), t4; \
+	vbroadcastss .L0f0f0f0f(%rip), t7; \
+	vmovdqa .Lpre_tf_lo_s1(%rip), t0; \
+	vmovdqa .Lpre_tf_hi_s1(%rip), t1; \
 	\
 	/* AES inverse shift rows */ \
 	vpshufb t4, x0, x0; \
@@ -68,8 +68,8 @@
 	vpshufb t4, x6, x6; \
 	\
 	/* prefilter sboxes 1, 2 and 3 */ \
-	vmovdqa .Lpre_tf_lo_s4, t2; \
-	vmovdqa .Lpre_tf_hi_s4, t3; \
+	vmovdqa .Lpre_tf_lo_s4(%rip), t2; \
+	vmovdqa .Lpre_tf_hi_s4(%rip), t3; \
 	filter_8bit(x0, t0, t1, t7, t6); \
 	filter_8bit(x7, t0, t1, t7, t6); \
 	filter_8bit(x1, t0, t1, t7, t6); \
@@ -83,8 +83,8 @@
 	filter_8bit(x6, t2, t3, t7, t6); \
 	\
 	/* AES subbytes + AES shift rows */ \
-	vmovdqa .Lpost_tf_lo_s1, t0; \
-	vmovdqa .Lpost_tf_hi_s1, t1; \
+	vmovdqa .Lpost_tf_lo_s1(%rip), t0; \
+	vmovdqa .Lpost_tf_hi_s1(%rip), t1; \
 	vaesenclast t4, x0, x0; \
 	vaesenclast t4, x7, x7; \
 	vaesenclast t4, x1, x1; \
@@ -95,16 +95,16 @@
 	vaesenclast t4, x6, x6; \
 	\
 	/* postfilter sboxes 1 and 4 */ \
-	vmovdqa .Lpost_tf_lo_s3, t2; \
-	vmovdqa .Lpost_tf_hi_s3, t3; \
+	vmovdqa .Lpost_tf_lo_s3(%rip), t2; \
+	vmovdqa .Lpost_tf_hi_s3(%rip), t3; \
 	filter_8bit(x0, t0, t1, t7, t6); \
 	filter_8bit(x7, t0, t1, t7, t6); \
 	filter_8bit(x3, t0, t1, t7, t6); \
 	filter_8bit(x6, t0, t1, t7, t6); \
 	\
 	/* postfilter sbox 3 */ \
-	vmovdqa .Lpost_tf_lo_s2, t4; \
-	vmovdqa .Lpost_tf_hi_s2, t5; \
+	vmovdqa .Lpost_tf_lo_s2(%rip), t4; \
+	vmovdqa .Lpost_tf_hi_s2(%rip), t5; \
 	filter_8bit(x2, t2, t3, t7, t6); \
 	filter_8bit(x5, t2, t3, t7, t6); \
 	\
@@ -443,7 +443,7 @@ ENDPROC(roundsm16_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab)
 	transpose_4x4(c0, c1, c2, c3, a0, a1); \
 	transpose_4x4(d0, d1, d2, d3, a0, a1); \
 	\
-	vmovdqu .Lshufb_16x16b, a0; \
+	vmovdqu .Lshufb_16x16b(%rip), a0; \
 	vmovdqu st1, a1; \
 	vpshufb a0, a2, a2; \
 	vpshufb a0, a3, a3; \
@@ -482,7 +482,7 @@ ENDPROC(roundsm16_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab)
 #define inpack16_pre(x0, x1, x2, x3, x4, x5, x6, x7, y0, y1, y2, y3, y4, y5, \
 		     y6, y7, rio, key) \
 	vmovq key, x0; \
-	vpshufb .Lpack_bswap, x0, x0; \
+	vpshufb .Lpack_bswap(%rip), x0, x0; \
 	\
 	vpxor 0 * 16(rio), x0, y7; \
 	vpxor 1 * 16(rio), x0, y6; \
@@ -533,7 +533,7 @@ ENDPROC(roundsm16_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab)
 	vmovdqu x0, stack_tmp0; \
 	\
 	vmovq key, x0; \
-	vpshufb .Lpack_bswap, x0, x0; \
+	vpshufb .Lpack_bswap(%rip), x0, x0; \
 	\
 	vpxor x0, y7, y7; \
 	vpxor x0, y6, y6; \
@@ -1016,7 +1016,7 @@ ENTRY(camellia_ctr_16way)
 	subq $(16 * 16), %rsp;
 	movq %rsp, %rax;
 
-	vmovdqa .Lbswap128_mask, %xmm14;
+	vmovdqa .Lbswap128_mask(%rip), %xmm14;
 
 	/* load IV and byteswap */
 	vmovdqu (%rcx), %xmm0;
@@ -1065,7 +1065,7 @@ ENTRY(camellia_ctr_16way)
 
 	/* inpack16_pre: */
 	vmovq (key_table)(CTX), %xmm15;
-	vpshufb .Lpack_bswap, %xmm15, %xmm15;
+	vpshufb .Lpack_bswap(%rip), %xmm15, %xmm15;
 	vpxor %xmm0, %xmm15, %xmm0;
 	vpxor %xmm1, %xmm15, %xmm1;
 	vpxor %xmm2, %xmm15, %xmm2;
@@ -1133,7 +1133,7 @@ camellia_xts_crypt_16way:
 	subq $(16 * 16), %rsp;
 	movq %rsp, %rax;
 
-	vmovdqa .Lxts_gf128mul_and_shl1_mask, %xmm14;
+	vmovdqa .Lxts_gf128mul_and_shl1_mask(%rip), %xmm14;
 
 	/* load IV */
 	vmovdqu (%rcx), %xmm0;
@@ -1209,7 +1209,7 @@ camellia_xts_crypt_16way:
 
 	/* inpack16_pre: */
 	vmovq (key_table)(CTX, %r8, 8), %xmm15;
-	vpshufb .Lpack_bswap, %xmm15, %xmm15;
+	vpshufb .Lpack_bswap(%rip), %xmm15, %xmm15;
 	vpxor 0 * 16(%rax), %xmm15, %xmm0;
 	vpxor %xmm1, %xmm15, %xmm1;
 	vpxor %xmm2, %xmm15, %xmm2;
@@ -1264,7 +1264,7 @@ ENTRY(camellia_xts_enc_16way)
 	 */
 	xorl %r8d, %r8d; /* input whitening key, 0 for enc */
 
-	leaq __camellia_enc_blk16, %r9;
+	leaq __camellia_enc_blk16(%rip), %r9;
 
 	jmp camellia_xts_crypt_16way;
 ENDPROC(camellia_xts_enc_16way)
@@ -1282,7 +1282,7 @@ ENTRY(camellia_xts_dec_16way)
 	movl $24, %eax;
 	cmovel %eax, %r8d;  /* input whitening key, last for dec */
 
-	leaq __camellia_dec_blk16, %r9;
+	leaq __camellia_dec_blk16(%rip), %r9;
 
 	jmp camellia_xts_crypt_16way;
 ENDPROC(camellia_xts_dec_16way)
diff --git a/arch/x86/crypto/camellia-aesni-avx2-asm_64.S b/arch/x86/crypto/camellia-aesni-avx2-asm_64.S
index eee5b3982cfd..93da327fec83 100644
--- a/arch/x86/crypto/camellia-aesni-avx2-asm_64.S
+++ b/arch/x86/crypto/camellia-aesni-avx2-asm_64.S
@@ -69,12 +69,12 @@
 	/* \
 	 * S-function with AES subbytes \
 	 */ \
-	vbroadcasti128 .Linv_shift_row, t4; \
-	vpbroadcastd .L0f0f0f0f, t7; \
-	vbroadcasti128 .Lpre_tf_lo_s1, t5; \
-	vbroadcasti128 .Lpre_tf_hi_s1, t6; \
-	vbroadcasti128 .Lpre_tf_lo_s4, t2; \
-	vbroadcasti128 .Lpre_tf_hi_s4, t3; \
+	vbroadcasti128 .Linv_shift_row(%rip), t4; \
+	vpbroadcastd .L0f0f0f0f(%rip), t7; \
+	vbroadcasti128 .Lpre_tf_lo_s1(%rip), t5; \
+	vbroadcasti128 .Lpre_tf_hi_s1(%rip), t6; \
+	vbroadcasti128 .Lpre_tf_lo_s4(%rip), t2; \
+	vbroadcasti128 .Lpre_tf_hi_s4(%rip), t3; \
 	\
 	/* AES inverse shift rows */ \
 	vpshufb t4, x0, x0; \
@@ -120,8 +120,8 @@
 	vinserti128 $1, t2##_x, x6, x6; \
 	vextracti128 $1, x1, t3##_x; \
 	vextracti128 $1, x4, t2##_x; \
-	vbroadcasti128 .Lpost_tf_lo_s1, t0; \
-	vbroadcasti128 .Lpost_tf_hi_s1, t1; \
+	vbroadcasti128 .Lpost_tf_lo_s1(%rip), t0; \
+	vbroadcasti128 .Lpost_tf_hi_s1(%rip), t1; \
 	vaesenclast t4##_x, x2##_x, x2##_x; \
 	vaesenclast t4##_x, t6##_x, t6##_x; \
 	vinserti128 $1, t6##_x, x2, x2; \
@@ -136,16 +136,16 @@
 	vinserti128 $1, t2##_x, x4, x4; \
 	\
 	/* postfilter sboxes 1 and 4 */ \
-	vbroadcasti128 .Lpost_tf_lo_s3, t2; \
-	vbroadcasti128 .Lpost_tf_hi_s3, t3; \
+	vbroadcasti128 .Lpost_tf_lo_s3(%rip), t2; \
+	vbroadcasti128 .Lpost_tf_hi_s3(%rip), t3; \
 	filter_8bit(x0, t0, t1, t7, t6); \
 	filter_8bit(x7, t0, t1, t7, t6); \
 	filter_8bit(x3, t0, t1, t7, t6); \
 	filter_8bit(x6, t0, t1, t7, t6); \
 	\
 	/* postfilter sbox 3 */ \
-	vbroadcasti128 .Lpost_tf_lo_s2, t4; \
-	vbroadcasti128 .Lpost_tf_hi_s2, t5; \
+	vbroadcasti128 .Lpost_tf_lo_s2(%rip), t4; \
+	vbroadcasti128 .Lpost_tf_hi_s2(%rip), t5; \
 	filter_8bit(x2, t2, t3, t7, t6); \
 	filter_8bit(x5, t2, t3, t7, t6); \
 	\
@@ -482,7 +482,7 @@ ENDPROC(roundsm32_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab)
 	transpose_4x4(c0, c1, c2, c3, a0, a1); \
 	transpose_4x4(d0, d1, d2, d3, a0, a1); \
 	\
-	vbroadcasti128 .Lshufb_16x16b, a0; \
+	vbroadcasti128 .Lshufb_16x16b(%rip), a0; \
 	vmovdqu st1, a1; \
 	vpshufb a0, a2, a2; \
 	vpshufb a0, a3, a3; \
@@ -521,7 +521,7 @@ ENDPROC(roundsm32_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab)
 #define inpack32_pre(x0, x1, x2, x3, x4, x5, x6, x7, y0, y1, y2, y3, y4, y5, \
 		     y6, y7, rio, key) \
 	vpbroadcastq key, x0; \
-	vpshufb .Lpack_bswap, x0, x0; \
+	vpshufb .Lpack_bswap(%rip), x0, x0; \
 	\
 	vpxor 0 * 32(rio), x0, y7; \
 	vpxor 1 * 32(rio), x0, y6; \
@@ -572,7 +572,7 @@ ENDPROC(roundsm32_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab)
 	vmovdqu x0, stack_tmp0; \
 	\
 	vpbroadcastq key, x0; \
-	vpshufb .Lpack_bswap, x0, x0; \
+	vpshufb .Lpack_bswap(%rip), x0, x0; \
 	\
 	vpxor x0, y7, y7; \
 	vpxor x0, y6, y6; \
@@ -1112,7 +1112,7 @@ ENTRY(camellia_ctr_32way)
 	vmovdqu (%rcx), %xmm0;
 	vmovdqa %xmm0, %xmm1;
 	inc_le128(%xmm0, %xmm15, %xmm14);
-	vbroadcasti128 .Lbswap128_mask, %ymm14;
+	vbroadcasti128 .Lbswap128_mask(%rip), %ymm14;
 	vinserti128 $1, %xmm0, %ymm1, %ymm0;
 	vpshufb %ymm14, %ymm0, %ymm13;
 	vmovdqu %ymm13, 15 * 32(%rax);
@@ -1158,7 +1158,7 @@ ENTRY(camellia_ctr_32way)
 
 	/* inpack32_pre: */
 	vpbroadcastq (key_table)(CTX), %ymm15;
-	vpshufb .Lpack_bswap, %ymm15, %ymm15;
+	vpshufb .Lpack_bswap(%rip), %ymm15, %ymm15;
 	vpxor %ymm0, %ymm15, %ymm0;
 	vpxor %ymm1, %ymm15, %ymm1;
 	vpxor %ymm2, %ymm15, %ymm2;
@@ -1242,13 +1242,13 @@ camellia_xts_crypt_32way:
 	subq $(16 * 32), %rsp;
 	movq %rsp, %rax;
 
-	vbroadcasti128 .Lxts_gf128mul_and_shl1_mask_0, %ymm12;
+	vbroadcasti128 .Lxts_gf128mul_and_shl1_mask_0(%rip), %ymm12;
 
 	/* load IV and construct second IV */
 	vmovdqu (%rcx), %xmm0;
 	vmovdqa %xmm0, %xmm15;
 	gf128mul_x_ble(%xmm0, %xmm12, %xmm13);
-	vbroadcasti128 .Lxts_gf128mul_and_shl1_mask_1, %ymm13;
+	vbroadcasti128 .Lxts_gf128mul_and_shl1_mask_1(%rip), %ymm13;
 	vinserti128 $1, %xmm0, %ymm15, %ymm0;
 	vpxor 0 * 32(%rdx), %ymm0, %ymm15;
 	vmovdqu %ymm15, 15 * 32(%rax);
@@ -1325,7 +1325,7 @@ camellia_xts_crypt_32way:
 
 	/* inpack32_pre: */
 	vpbroadcastq (key_table)(CTX, %r8, 8), %ymm15;
-	vpshufb .Lpack_bswap, %ymm15, %ymm15;
+	vpshufb .Lpack_bswap(%rip), %ymm15, %ymm15;
 	vpxor 0 * 32(%rax), %ymm15, %ymm0;
 	vpxor %ymm1, %ymm15, %ymm1;
 	vpxor %ymm2, %ymm15, %ymm2;
@@ -1383,7 +1383,7 @@ ENTRY(camellia_xts_enc_32way)
 
 	xorl %r8d, %r8d; /* input whitening key, 0 for enc */
 
-	leaq __camellia_enc_blk32, %r9;
+	leaq __camellia_enc_blk32(%rip), %r9;
 
 	jmp camellia_xts_crypt_32way;
 ENDPROC(camellia_xts_enc_32way)
@@ -1401,7 +1401,7 @@ ENTRY(camellia_xts_dec_32way)
 	movl $24, %eax;
 	cmovel %eax, %r8d;  /* input whitening key, last for dec */
 
-	leaq __camellia_dec_blk32, %r9;
+	leaq __camellia_dec_blk32(%rip), %r9;
 
 	jmp camellia_xts_crypt_32way;
 ENDPROC(camellia_xts_dec_32way)
diff --git a/arch/x86/crypto/camellia-x86_64-asm_64.S b/arch/x86/crypto/camellia-x86_64-asm_64.S
index 310319c601ed..b8c81e2f9973 100644
--- a/arch/x86/crypto/camellia-x86_64-asm_64.S
+++ b/arch/x86/crypto/camellia-x86_64-asm_64.S
@@ -92,11 +92,13 @@
 #define RXORbl %r9b
 
 #define xor2ror16(T0, T1, tmp1, tmp2, ab, dst) \
+	leaq T0(%rip), 			tmp1; \
 	movzbl ab ## bl,		tmp2 ## d; \
+	xorq (tmp1, tmp2, 8),		dst; \
+	leaq T1(%rip), 			tmp2; \
 	movzbl ab ## bh,		tmp1 ## d; \
-	rorq $16,			ab; \
-	xorq T0(, tmp2, 8),		dst; \
-	xorq T1(, tmp1, 8),		dst;
+	xorq (tmp2, tmp1, 8),		dst; \
+	rorq $16,			ab;
 
 /**********************************************************************
   1-way camellia
diff --git a/arch/x86/crypto/cast5-avx-x86_64-asm_64.S b/arch/x86/crypto/cast5-avx-x86_64-asm_64.S
index b4a8806234ea..ae2976b56b27 100644
--- a/arch/x86/crypto/cast5-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/cast5-avx-x86_64-asm_64.S
@@ -98,16 +98,20 @@
 
 
 #define lookup_32bit(src, dst, op1, op2, op3, interleave_op, il_reg) \
-	movzbl		src ## bh,     RID1d;    \
-	movzbl		src ## bl,     RID2d;    \
-	shrq $16,	src;                     \
-	movl		s1(, RID1, 4), dst ## d; \
-	op1		s2(, RID2, 4), dst ## d; \
-	movzbl		src ## bh,     RID1d;    \
-	movzbl		src ## bl,     RID2d;    \
-	interleave_op(il_reg);			 \
-	op2		s3(, RID1, 4), dst ## d; \
-	op3		s4(, RID2, 4), dst ## d;
+	movzbl		src ## bh,       RID1d;    \
+	leaq		s1(%rip),        RID2;     \
+	movl		(RID2, RID1, 4), dst ## d; \
+	movzbl		src ## bl,       RID2d;    \
+	leaq		s2(%rip),        RID1;     \
+	op1		(RID1, RID2, 4), dst ## d; \
+	shrq $16,	src;                       \
+	movzbl		src ## bh,     RID1d;      \
+	leaq		s3(%rip),        RID2;     \
+	op2		(RID2, RID1, 4), dst ## d; \
+	movzbl		src ## bl,     RID2d;      \
+	leaq		s4(%rip),        RID1;     \
+	op3		(RID1, RID2, 4), dst ## d; \
+	interleave_op(il_reg);
 
 #define dummy(d) /* do nothing */
 
@@ -166,15 +170,15 @@
 	subround(l ## 3, r ## 3, l ## 4, r ## 4, f);
 
 #define enc_preload_rkr() \
-	vbroadcastss	.L16_mask,                RKR;      \
+	vbroadcastss	.L16_mask(%rip),          RKR;      \
 	/* add 16-bit rotation to key rotations (mod 32) */ \
 	vpxor		kr(CTX),                  RKR, RKR;
 
 #define dec_preload_rkr() \
-	vbroadcastss	.L16_mask,                RKR;      \
+	vbroadcastss	.L16_mask(%rip),          RKR;      \
 	/* add 16-bit rotation to key rotations (mod 32) */ \
 	vpxor		kr(CTX),                  RKR, RKR; \
-	vpshufb		.Lbswap128_mask,          RKR, RKR;
+	vpshufb		.Lbswap128_mask(%rip),    RKR, RKR;
 
 #define transpose_2x4(x0, x1, t0, t1) \
 	vpunpckldq		x1, x0, t0; \
@@ -249,9 +253,9 @@ __cast5_enc_blk16:
 	pushq %rbp;
 	pushq %rbx;
 
-	vmovdqa .Lbswap_mask, RKM;
-	vmovd .Lfirst_mask, R1ST;
-	vmovd .L32_mask, R32;
+	vmovdqa .Lbswap_mask(%rip), RKM;
+	vmovd .Lfirst_mask(%rip), R1ST;
+	vmovd .L32_mask(%rip), R32;
 	enc_preload_rkr();
 
 	inpack_blocks(RL1, RR1, RTMP, RX, RKM);
@@ -285,7 +289,7 @@ __cast5_enc_blk16:
 	popq %rbx;
 	popq %rbp;
 
-	vmovdqa .Lbswap_mask, RKM;
+	vmovdqa .Lbswap_mask(%rip), RKM;
 
 	outunpack_blocks(RR1, RL1, RTMP, RX, RKM);
 	outunpack_blocks(RR2, RL2, RTMP, RX, RKM);
@@ -321,9 +325,9 @@ __cast5_dec_blk16:
 	pushq %rbp;
 	pushq %rbx;
 
-	vmovdqa .Lbswap_mask, RKM;
-	vmovd .Lfirst_mask, R1ST;
-	vmovd .L32_mask, R32;
+	vmovdqa .Lbswap_mask(%rip), RKM;
+	vmovd .Lfirst_mask(%rip), R1ST;
+	vmovd .L32_mask(%rip), R32;
 	dec_preload_rkr();
 
 	inpack_blocks(RL1, RR1, RTMP, RX, RKM);
@@ -354,7 +358,7 @@ __cast5_dec_blk16:
 	round(RL, RR, 1, 2);
 	round(RR, RL, 0, 1);
 
-	vmovdqa .Lbswap_mask, RKM;
+	vmovdqa .Lbswap_mask(%rip), RKM;
 	popq %rbx;
 	popq %rbp;
 
@@ -508,8 +512,8 @@ ENTRY(cast5_ctr_16way)
 
 	vpcmpeqd RKR, RKR, RKR;
 	vpaddq RKR, RKR, RKR; /* low: -2, high: -2 */
-	vmovdqa .Lbswap_iv_mask, R1ST;
-	vmovdqa .Lbswap128_mask, RKM;
+	vmovdqa .Lbswap_iv_mask(%rip), R1ST;
+	vmovdqa .Lbswap128_mask(%rip), RKM;
 
 	/* load IV and byteswap */
 	vmovq (%rcx), RX;
diff --git a/arch/x86/crypto/cast6-avx-x86_64-asm_64.S b/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
index 952d3156a933..6bd52210a3c1 100644
--- a/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
@@ -98,16 +98,20 @@
 
 
 #define lookup_32bit(src, dst, op1, op2, op3, interleave_op, il_reg) \
-	movzbl		src ## bh,     RID1d;    \
-	movzbl		src ## bl,     RID2d;    \
-	shrq $16,	src;                     \
-	movl		s1(, RID1, 4), dst ## d; \
-	op1		s2(, RID2, 4), dst ## d; \
-	movzbl		src ## bh,     RID1d;    \
-	movzbl		src ## bl,     RID2d;    \
-	interleave_op(il_reg);			 \
-	op2		s3(, RID1, 4), dst ## d; \
-	op3		s4(, RID2, 4), dst ## d;
+	movzbl		src ## bh,       RID1d;    \
+	leaq		s1(%rip),        RID2;     \
+	movl		(RID2, RID1, 4), dst ## d; \
+	movzbl		src ## bl,       RID2d;    \
+	leaq		s2(%rip),        RID1;     \
+	op1		(RID1, RID2, 4), dst ## d; \
+	shrq $16,	src;                       \
+	movzbl		src ## bh,     RID1d;      \
+	leaq		s3(%rip),        RID2;     \
+	op2		(RID2, RID1, 4), dst ## d; \
+	movzbl		src ## bl,     RID2d;      \
+	leaq		s4(%rip),        RID1;     \
+	op3		(RID1, RID2, 4), dst ## d; \
+	interleave_op(il_reg);
 
 #define dummy(d) /* do nothing */
 
@@ -190,10 +194,10 @@
 	qop(RD, RC, 1);
 
 #define shuffle(mask) \
-	vpshufb		mask,            RKR, RKR;
+	vpshufb		mask(%rip),            RKR, RKR;
 
 #define preload_rkr(n, do_mask, mask) \
-	vbroadcastss	.L16_mask,                RKR;      \
+	vbroadcastss	.L16_mask(%rip),          RKR;      \
 	/* add 16-bit rotation to key rotations (mod 32) */ \
 	vpxor		(kr+n*16)(CTX),           RKR, RKR; \
 	do_mask(mask);
@@ -273,9 +277,9 @@ __cast6_enc_blk8:
 	pushq %rbp;
 	pushq %rbx;
 
-	vmovdqa .Lbswap_mask, RKM;
-	vmovd .Lfirst_mask, R1ST;
-	vmovd .L32_mask, R32;
+	vmovdqa .Lbswap_mask(%rip), RKM;
+	vmovd .Lfirst_mask(%rip), R1ST;
+	vmovd .L32_mask(%rip), R32;
 
 	inpack_blocks(RA1, RB1, RC1, RD1, RTMP, RX, RKRF, RKM);
 	inpack_blocks(RA2, RB2, RC2, RD2, RTMP, RX, RKRF, RKM);
@@ -299,7 +303,7 @@ __cast6_enc_blk8:
 	popq %rbx;
 	popq %rbp;
 
-	vmovdqa .Lbswap_mask, RKM;
+	vmovdqa .Lbswap_mask(%rip), RKM;
 
 	outunpack_blocks(RA1, RB1, RC1, RD1, RTMP, RX, RKRF, RKM);
 	outunpack_blocks(RA2, RB2, RC2, RD2, RTMP, RX, RKRF, RKM);
@@ -319,9 +323,9 @@ __cast6_dec_blk8:
 	pushq %rbp;
 	pushq %rbx;
 
-	vmovdqa .Lbswap_mask, RKM;
-	vmovd .Lfirst_mask, R1ST;
-	vmovd .L32_mask, R32;
+	vmovdqa .Lbswap_mask(%rip), RKM;
+	vmovd .Lfirst_mask(%rip), R1ST;
+	vmovd .L32_mask(%rip), R32;
 
 	inpack_blocks(RA1, RB1, RC1, RD1, RTMP, RX, RKRF, RKM);
 	inpack_blocks(RA2, RB2, RC2, RD2, RTMP, RX, RKRF, RKM);
@@ -345,7 +349,7 @@ __cast6_dec_blk8:
 	popq %rbx;
 	popq %rbp;
 
-	vmovdqa .Lbswap_mask, RKM;
+	vmovdqa .Lbswap_mask(%rip), RKM;
 	outunpack_blocks(RA1, RB1, RC1, RD1, RTMP, RX, RKRF, RKM);
 	outunpack_blocks(RA2, RB2, RC2, RD2, RTMP, RX, RKRF, RKM);
 
diff --git a/arch/x86/crypto/des3_ede-asm_64.S b/arch/x86/crypto/des3_ede-asm_64.S
index f3e91647ca27..d532ff94b70a 100644
--- a/arch/x86/crypto/des3_ede-asm_64.S
+++ b/arch/x86/crypto/des3_ede-asm_64.S
@@ -138,21 +138,29 @@
 	movzbl RW0bl, RT2d; \
 	movzbl RW0bh, RT3d; \
 	shrq $16, RW0; \
-	movq s8(, RT0, 8), RT0; \
-	xorq s6(, RT1, 8), to; \
+	leaq s8(%rip), RW1; \
+	movq (RW1, RT0, 8), RT0; \
+	leaq s6(%rip), RW1; \
+	xorq (RW1, RT1, 8), to; \
 	movzbl RW0bl, RL1d; \
 	movzbl RW0bh, RT1d; \
 	shrl $16, RW0d; \
-	xorq s4(, RT2, 8), RT0; \
-	xorq s2(, RT3, 8), to; \
+	leaq s4(%rip), RW1; \
+	xorq (RW1, RT2, 8), RT0; \
+	leaq s2(%rip), RW1; \
+	xorq (RW1, RT3, 8), to; \
 	movzbl RW0bl, RT2d; \
 	movzbl RW0bh, RT3d; \
-	xorq s7(, RL1, 8), RT0; \
-	xorq s5(, RT1, 8), to; \
-	xorq s3(, RT2, 8), RT0; \
+	leaq s7(%rip), RW1; \
+	xorq (RW1, RL1, 8), RT0; \
+	leaq s5(%rip), RW1; \
+	xorq (RW1, RT1, 8), to; \
+	leaq s3(%rip), RW1; \
+	xorq (RW1, RT2, 8), RT0; \
 	load_next_key(n, RW0); \
 	xorq RT0, to; \
-	xorq s1(, RT3, 8), to; \
+	leaq s1(%rip), RW1; \
+	xorq (RW1, RT3, 8), to; \
 
 #define load_next_key(n, RWx) \
 	movq (((n) + 1) * 8)(CTX), RWx;
@@ -362,65 +370,89 @@ ENDPROC(des3_ede_x86_64_crypt_blk)
 	movzbl RW0bl, RT3d; \
 	movzbl RW0bh, RT1d; \
 	shrq $16, RW0; \
-	xorq s8(, RT3, 8), to##0; \
-	xorq s6(, RT1, 8), to##0; \
+	leaq s8(%rip), RT2; \
+	xorq (RT2, RT3, 8), to##0; \
+	leaq s6(%rip), RT2; \
+	xorq (RT2, RT1, 8), to##0; \
 	movzbl RW0bl, RT3d; \
 	movzbl RW0bh, RT1d; \
 	shrq $16, RW0; \
-	xorq s4(, RT3, 8), to##0; \
-	xorq s2(, RT1, 8), to##0; \
+	leaq s4(%rip), RT2; \
+	xorq (RT2, RT3, 8), to##0; \
+	leaq s2(%rip), RT2; \
+	xorq (RT2, RT1, 8), to##0; \
 	movzbl RW0bl, RT3d; \
 	movzbl RW0bh, RT1d; \
 	shrl $16, RW0d; \
-	xorq s7(, RT3, 8), to##0; \
-	xorq s5(, RT1, 8), to##0; \
+	leaq s7(%rip), RT2; \
+	xorq (RT2, RT3, 8), to##0; \
+	leaq s5(%rip), RT2; \
+	xorq (RT2, RT1, 8), to##0; \
 	movzbl RW0bl, RT3d; \
 	movzbl RW0bh, RT1d; \
 	load_next_key(n, RW0); \
-	xorq s3(, RT3, 8), to##0; \
-	xorq s1(, RT1, 8), to##0; \
+	leaq s3(%rip), RT2; \
+	xorq (RT2, RT3, 8), to##0; \
+	leaq s1(%rip), RT2; \
+	xorq (RT2, RT1, 8), to##0; \
 		xorq from##1, RW1; \
 		movzbl RW1bl, RT3d; \
 		movzbl RW1bh, RT1d; \
 		shrq $16, RW1; \
-		xorq s8(, RT3, 8), to##1; \
-		xorq s6(, RT1, 8), to##1; \
+		leaq s8(%rip), RT2; \
+		xorq (RT2, RT3, 8), to##1; \
+		leaq s6(%rip), RT2; \
+		xorq (RT2, RT1, 8), to##1; \
 		movzbl RW1bl, RT3d; \
 		movzbl RW1bh, RT1d; \
 		shrq $16, RW1; \
-		xorq s4(, RT3, 8), to##1; \
-		xorq s2(, RT1, 8), to##1; \
+		leaq s4(%rip), RT2; \
+		xorq (RT2, RT3, 8), to##1; \
+		leaq s2(%rip), RT2; \
+		xorq (RT2, RT1, 8), to##1; \
 		movzbl RW1bl, RT3d; \
 		movzbl RW1bh, RT1d; \
 		shrl $16, RW1d; \
-		xorq s7(, RT3, 8), to##1; \
-		xorq s5(, RT1, 8), to##1; \
+		leaq s7(%rip), RT2; \
+		xorq (RT2, RT3, 8), to##1; \
+		leaq s5(%rip), RT2; \
+		xorq (RT2, RT1, 8), to##1; \
 		movzbl RW1bl, RT3d; \
 		movzbl RW1bh, RT1d; \
 		do_movq(RW0, RW1); \
-		xorq s3(, RT3, 8), to##1; \
-		xorq s1(, RT1, 8), to##1; \
+		leaq s3(%rip), RT2; \
+		xorq (RT2, RT3, 8), to##1; \
+		leaq s1(%rip), RT2; \
+		xorq (RT2, RT1, 8), to##1; \
 			xorq from##2, RW2; \
 			movzbl RW2bl, RT3d; \
 			movzbl RW2bh, RT1d; \
 			shrq $16, RW2; \
-			xorq s8(, RT3, 8), to##2; \
-			xorq s6(, RT1, 8), to##2; \
+			leaq s8(%rip), RT2; \
+			xorq (RT2, RT3, 8), to##2; \
+			leaq s6(%rip), RT2; \
+			xorq (RT2, RT1, 8), to##2; \
 			movzbl RW2bl, RT3d; \
 			movzbl RW2bh, RT1d; \
 			shrq $16, RW2; \
-			xorq s4(, RT3, 8), to##2; \
-			xorq s2(, RT1, 8), to##2; \
+			leaq s4(%rip), RT2; \
+			xorq (RT2, RT3, 8), to##2; \
+			leaq s2(%rip), RT2; \
+			xorq (RT2, RT1, 8), to##2; \
 			movzbl RW2bl, RT3d; \
 			movzbl RW2bh, RT1d; \
 			shrl $16, RW2d; \
-			xorq s7(, RT3, 8), to##2; \
-			xorq s5(, RT1, 8), to##2; \
+			leaq s7(%rip), RT2; \
+			xorq (RT2, RT3, 8), to##2; \
+			leaq s5(%rip), RT2; \
+			xorq (RT2, RT1, 8), to##2; \
 			movzbl RW2bl, RT3d; \
 			movzbl RW2bh, RT1d; \
 			do_movq(RW0, RW2); \
-			xorq s3(, RT3, 8), to##2; \
-			xorq s1(, RT1, 8), to##2;
+			leaq s3(%rip), RT2; \
+			xorq (RT2, RT3, 8), to##2; \
+			leaq s1(%rip), RT2; \
+			xorq (RT2, RT1, 8), to##2;
 
 #define __movq(src, dst) \
 	movq src, dst;
diff --git a/arch/x86/crypto/ghash-clmulni-intel_asm.S b/arch/x86/crypto/ghash-clmulni-intel_asm.S
index f94375a8dcd1..d56a281221fb 100644
--- a/arch/x86/crypto/ghash-clmulni-intel_asm.S
+++ b/arch/x86/crypto/ghash-clmulni-intel_asm.S
@@ -97,7 +97,7 @@ ENTRY(clmul_ghash_mul)
 	FRAME_BEGIN
 	movups (%rdi), DATA
 	movups (%rsi), SHASH
-	movaps .Lbswap_mask, BSWAP
+	movaps .Lbswap_mask(%rip), BSWAP
 	PSHUFB_XMM BSWAP DATA
 	call __clmul_gf128mul_ble
 	PSHUFB_XMM BSWAP DATA
@@ -114,7 +114,7 @@ ENTRY(clmul_ghash_update)
 	FRAME_BEGIN
 	cmp $16, %rdx
 	jb .Lupdate_just_ret	# check length
-	movaps .Lbswap_mask, BSWAP
+	movaps .Lbswap_mask(%rip), BSWAP
 	movups (%rdi), DATA
 	movups (%rcx), SHASH
 	PSHUFB_XMM BSWAP DATA
diff --git a/arch/x86/crypto/glue_helper-asm-avx.S b/arch/x86/crypto/glue_helper-asm-avx.S
index 02ee2308fb38..8a49ab1699ef 100644
--- a/arch/x86/crypto/glue_helper-asm-avx.S
+++ b/arch/x86/crypto/glue_helper-asm-avx.S
@@ -54,7 +54,7 @@
 #define load_ctr_8way(iv, bswap, x0, x1, x2, x3, x4, x5, x6, x7, t0, t1, t2) \
 	vpcmpeqd t0, t0, t0; \
 	vpsrldq $8, t0, t0; /* low: -1, high: 0 */ \
-	vmovdqa bswap, t1; \
+	vmovdqa bswap(%rip), t1; \
 	\
 	/* load IV and byteswap */ \
 	vmovdqu (iv), x7; \
@@ -99,7 +99,7 @@
 
 #define load_xts_8way(iv, src, dst, x0, x1, x2, x3, x4, x5, x6, x7, tiv, t0, \
 		      t1, xts_gf128mul_and_shl1_mask) \
-	vmovdqa xts_gf128mul_and_shl1_mask, t0; \
+	vmovdqa xts_gf128mul_and_shl1_mask(%rip), t0; \
 	\
 	/* load IV */ \
 	vmovdqu (iv), tiv; \
diff --git a/arch/x86/crypto/glue_helper-asm-avx2.S b/arch/x86/crypto/glue_helper-asm-avx2.S
index a53ac11dd385..e04c80467bd2 100644
--- a/arch/x86/crypto/glue_helper-asm-avx2.S
+++ b/arch/x86/crypto/glue_helper-asm-avx2.S
@@ -67,7 +67,7 @@
 	vmovdqu (iv), t2x; \
 	vmovdqa t2x, t3x; \
 	inc_le128(t2x, t0x, t1x); \
-	vbroadcasti128 bswap, t1; \
+	vbroadcasti128 bswap(%rip), t1; \
 	vinserti128 $1, t2x, t3, t2; /* ab: le0 ; cd: le1 */ \
 	vpshufb t1, t2, x0; \
 	\
@@ -124,13 +124,13 @@
 		       tivx, t0, t0x, t1, t1x, t2, t2x, t3, \
 		       xts_gf128mul_and_shl1_mask_0, \
 		       xts_gf128mul_and_shl1_mask_1) \
-	vbroadcasti128 xts_gf128mul_and_shl1_mask_0, t1; \
+	vbroadcasti128 xts_gf128mul_and_shl1_mask_0(%rip), t1; \
 	\
 	/* load IV and construct second IV */ \
 	vmovdqu (iv), tivx; \
 	vmovdqa tivx, t0x; \
 	gf128mul_x_ble(tivx, t1x, t2x); \
-	vbroadcasti128 xts_gf128mul_and_shl1_mask_1, t2; \
+	vbroadcasti128 xts_gf128mul_and_shl1_mask_1(%rip), t2; \
 	vinserti128 $1, tivx, t0, tiv; \
 	vpxor (0*32)(src), tiv, x0; \
 	vmovdqu tiv, (0*32)(dst); \
-- 
2.14.0.434.g98096fd7a8-goog
