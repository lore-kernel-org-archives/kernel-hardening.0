Return-Path: <SRS0=ZSg1=ZF=lists.openwall.com=kernel-hardening-return-17359-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D7C7C432C3
	for <kernel-hardening@archiver.kernel.org>; Wed, 13 Nov 2019 19:39:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5070D206E1
	for <kernel-hardening@archiver.kernel.org>; Wed, 13 Nov 2019 19:39:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="t/PHoEW1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5070D206E1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17359-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24155 invoked by uid 550); 13 Nov 2019 19:39:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24115 invoked from network); 13 Nov 2019 19:39:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573673954;
	bh=HsvU11smOFDGrf69/g+/FIML+LQLnRDAJ8s/djvWqRw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t/PHoEW1ZmuCrYHEfFY0AdYVluyMHGKtKysou2eB6LMTTeJy7mmMCdolbWiKcRp+4
	 LF7nK/gDW2CrG3qfiFFuwEv+JClkGhppSHxY5m860q42xNnjA6pObpEpim1FfNqv5A
	 6xeGaz4tCFuvIiaCG6/Y82I2sU9Ba1qdmJvr+lAY=
Date: Wed, 13 Nov 2019 11:39:12 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	=?iso-8859-1?Q?Jo=E3o?= Moreira <joao.moreira@intel.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Stephan Mueller <smueller@chronox.de>, x86@kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v5 3/8] crypto: x86/camellia: Remove glue function macro
 usage
Message-ID: <20191113193911.GC221701@gmail.com>
Mail-Followup-To: Kees Cook <keescook@chromium.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	=?iso-8859-1?Q?Jo=E3o?= Moreira <joao.moreira@intel.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Stephan Mueller <smueller@chronox.de>, x86@kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
References: <20191113182516.13545-1-keescook@chromium.org>
 <20191113182516.13545-4-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191113182516.13545-4-keescook@chromium.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Nov 13, 2019 at 10:25:11AM -0800, Kees Cook wrote:
> In order to remove the callsite function casts, regularize the function
> prototypes for helpers to avoid triggering Control-Flow Integrity checks
> during indirect function calls. Where needed, to avoid changes to
> pointer math, u8 pointers are internally cast back to u128 pointers.
> 
> Co-developed-by: João Moreira <joao.moreira@intel.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/x86/crypto/camellia_aesni_avx2_glue.c | 74 ++++++++++------------
>  arch/x86/crypto/camellia_aesni_avx_glue.c  | 74 ++++++++++------------
>  arch/x86/crypto/camellia_glue.c            | 45 +++++++------
>  arch/x86/include/asm/crypto/camellia.h     | 64 ++++++++-----------
>  4 files changed, 119 insertions(+), 138 deletions(-)
> 
> diff --git a/arch/x86/crypto/camellia_aesni_avx2_glue.c b/arch/x86/crypto/camellia_aesni_avx2_glue.c
> index a4f00128ea55..a68d54fc2dde 100644
> --- a/arch/x86/crypto/camellia_aesni_avx2_glue.c
> +++ b/arch/x86/crypto/camellia_aesni_avx2_glue.c
> @@ -19,20 +19,17 @@
>  #define CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS 32
>  
>  /* 32-way AVX2/AES-NI parallel cipher functions */
> -asmlinkage void camellia_ecb_enc_32way(struct camellia_ctx *ctx, u8 *dst,
> -				       const u8 *src);
> -asmlinkage void camellia_ecb_dec_32way(struct camellia_ctx *ctx, u8 *dst,
> -				       const u8 *src);
> +asmlinkage void camellia_ecb_enc_32way(void *ctx, u8 *dst, const u8 *src);
> +asmlinkage void camellia_ecb_dec_32way(void *ctx, u8 *dst, const u8 *src);
>  
> -asmlinkage void camellia_cbc_dec_32way(struct camellia_ctx *ctx, u8 *dst,
> -				       const u8 *src);
> -asmlinkage void camellia_ctr_32way(struct camellia_ctx *ctx, u8 *dst,
> -				   const u8 *src, le128 *iv);
> +asmlinkage void camellia_cbc_dec_32way(void *ctx, u8 *dst, const u8 *src);
> +asmlinkage void camellia_ctr_32way(void *ctx, u8 *dst, const u8 *src,
> +				   le128 *iv);
>  
> -asmlinkage void camellia_xts_enc_32way(struct camellia_ctx *ctx, u8 *dst,
> -				       const u8 *src, le128 *iv);
> -asmlinkage void camellia_xts_dec_32way(struct camellia_ctx *ctx, u8 *dst,
> -				       const u8 *src, le128 *iv);
> +asmlinkage void camellia_xts_enc_32way(void *ctx, u8 *dst, const u8 *src,
> +				       le128 *iv);
> +asmlinkage void camellia_xts_dec_32way(void *ctx, u8 *dst, const u8 *src,
> +				       le128 *iv);

As long as the type of all the 'ctx' arguments is being changed anyway, can you
please make them const, as they should have been all along?  This applies to all
the algorithms.  I.e., something like this:

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index f47afa5ae8ca56..d7d2a5864fde6d 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -83,8 +83,8 @@ struct gcm_context_data {
 
 asmlinkage int aesni_set_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
 			     unsigned int key_len);
-asmlinkage void aesni_enc(void *ctx, u8 *out, const u8 *in);
-asmlinkage void aesni_dec(void *ctx, u8 *out, const u8 *in);
+asmlinkage void aesni_enc(const void *ctx, u8 *out, const u8 *in);
+asmlinkage void aesni_dec(const void *ctx, u8 *out, const u8 *in);
 asmlinkage void aesni_ecb_enc(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len);
 asmlinkage void aesni_ecb_dec(struct crypto_aes_ctx *ctx, u8 *out,
@@ -104,7 +104,7 @@ static void (*aesni_ctr_enc_tfm)(struct crypto_aes_ctx *ctx, u8 *out,
 asmlinkage void aesni_ctr_enc(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv);
 
-asmlinkage void aesni_xts_crypt8(struct crypto_aes_ctx *ctx, u8 *out,
+asmlinkage void aesni_xts_crypt8(const struct crypto_aes_ctx *ctx, u8 *out,
 				 const u8 *in, bool enc, le128 *iv);
 
 /* asmlinkage void aesni_gcm_enc()
@@ -548,24 +548,24 @@ static int xts_aesni_setkey(struct crypto_skcipher *tfm, const u8 *key,
 }
 
 
-static void aesni_xts_enc(void *ctx, u8 *dst, const u8 *src, le128 *iv)
+static void aesni_xts_enc(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
 {
 	glue_xts_crypt_128bit_one(ctx, (u128 *)dst, (const u128 *)src, iv,
 				  aesni_enc);
 }
 
-static void aesni_xts_dec(void *ctx, u8 *dst, const u8 *src, le128 *iv)
+static void aesni_xts_dec(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
 {
 	glue_xts_crypt_128bit_one(ctx, (u128 *)dst, (const u128 *)src, iv,
 				  aesni_dec);
 }
 
-static void aesni_xts_enc8(void *ctx, u8 *dst, const u8 *src, le128 *iv)
+static void aesni_xts_enc8(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
 {
 	aesni_xts_crypt8(ctx, dst, src, true, iv);
 }
 
-static void aesni_xts_dec8(void *ctx, u8 *dst, const u8 *src, le128 *iv)
+static void aesni_xts_dec8(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
 {
 	aesni_xts_crypt8(ctx, dst, src, false, iv);
 }
diff --git a/arch/x86/crypto/camellia_aesni_avx2_glue.c b/arch/x86/crypto/camellia_aesni_avx2_glue.c
index a68d54fc2dde47..a8cc2c83fe1bb0 100644
--- a/arch/x86/crypto/camellia_aesni_avx2_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx2_glue.c
@@ -19,16 +19,16 @@
 #define CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS 32
 
 /* 32-way AVX2/AES-NI parallel cipher functions */
-asmlinkage void camellia_ecb_enc_32way(void *ctx, u8 *dst, const u8 *src);
-asmlinkage void camellia_ecb_dec_32way(void *ctx, u8 *dst, const u8 *src);
+asmlinkage void camellia_ecb_enc_32way(const void *ctx, u8 *dst, const u8 *src);
+asmlinkage void camellia_ecb_dec_32way(const void *ctx, u8 *dst, const u8 *src);
 
-asmlinkage void camellia_cbc_dec_32way(void *ctx, u8 *dst, const u8 *src);
-asmlinkage void camellia_ctr_32way(void *ctx, u8 *dst, const u8 *src,
+asmlinkage void camellia_cbc_dec_32way(const void *ctx, u8 *dst, const u8 *src);
+asmlinkage void camellia_ctr_32way(const void *ctx, u8 *dst, const u8 *src,
 				   le128 *iv);
 
-asmlinkage void camellia_xts_enc_32way(void *ctx, u8 *dst, const u8 *src,
+asmlinkage void camellia_xts_enc_32way(const void *ctx, u8 *dst, const u8 *src,
 				       le128 *iv);
-asmlinkage void camellia_xts_dec_32way(void *ctx, u8 *dst, const u8 *src,
+asmlinkage void camellia_xts_dec_32way(const void *ctx, u8 *dst, const u8 *src,
 				       le128 *iv);
 
 static const struct common_glue_ctx camellia_enc = {
diff --git a/arch/x86/crypto/camellia_aesni_avx_glue.c b/arch/x86/crypto/camellia_aesni_avx_glue.c
index 9b0b65df8a7b3f..9a12b3b6548f09 100644
--- a/arch/x86/crypto/camellia_aesni_avx_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx_glue.c
@@ -18,35 +18,35 @@
 #define CAMELLIA_AESNI_PARALLEL_BLOCKS 16
 
 /* 16-way parallel cipher functions (avx/aes-ni) */
-asmlinkage void camellia_ecb_enc_16way(void *ctx, u8 *dst, const u8 *src);
+asmlinkage void camellia_ecb_enc_16way(const void *ctx, u8 *dst, const u8 *src);
 EXPORT_SYMBOL_GPL(camellia_ecb_enc_16way);
 
-asmlinkage void camellia_ecb_dec_16way(void *ctx, u8 *dst, const u8 *src);
+asmlinkage void camellia_ecb_dec_16way(const void *ctx, u8 *dst, const u8 *src);
 EXPORT_SYMBOL_GPL(camellia_ecb_dec_16way);
 
-asmlinkage void camellia_cbc_dec_16way(void *ctx, u8 *dst, const u8 *src);
+asmlinkage void camellia_cbc_dec_16way(const void *ctx, u8 *dst, const u8 *src);
 EXPORT_SYMBOL_GPL(camellia_cbc_dec_16way);
 
-asmlinkage void camellia_ctr_16way(void *ctx, u8 *dst, const u8 *src,
+asmlinkage void camellia_ctr_16way(const void *ctx, u8 *dst, const u8 *src,
 				   le128 *iv);
 EXPORT_SYMBOL_GPL(camellia_ctr_16way);
 
-asmlinkage void camellia_xts_enc_16way(void *ctx, u8 *dst, const u8 *src,
+asmlinkage void camellia_xts_enc_16way(const void *ctx, u8 *dst, const u8 *src,
 				       le128 *iv);
 EXPORT_SYMBOL_GPL(camellia_xts_enc_16way);
 
-asmlinkage void camellia_xts_dec_16way(void *ctx, u8 *dst, const u8 *src,
+asmlinkage void camellia_xts_dec_16way(const void *ctx, u8 *dst, const u8 *src,
 				       le128 *iv);
 EXPORT_SYMBOL_GPL(camellia_xts_dec_16way);
 
-void camellia_xts_enc(void *ctx, u8 *dst, const u8 *src, le128 *iv)
+void camellia_xts_enc(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
 {
 	glue_xts_crypt_128bit_one(ctx, (u128 *)dst, (const u128 *)src, iv,
 				  camellia_enc_blk);
 }
 EXPORT_SYMBOL_GPL(camellia_xts_enc);
 
-void camellia_xts_dec(void *ctx, u8 *dst, const u8 *src, le128 *iv)
+void camellia_xts_dec(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
 {
 	glue_xts_crypt_128bit_one(ctx, (u128 *)dst, (const u128 *)src, iv,
 				  camellia_dec_blk);
diff --git a/arch/x86/crypto/camellia_glue.c b/arch/x86/crypto/camellia_glue.c
index 975fe9a2ac584c..5f3ed5af68d70a 100644
--- a/arch/x86/crypto/camellia_glue.c
+++ b/arch/x86/crypto/camellia_glue.c
@@ -18,17 +18,17 @@
 #include <asm/crypto/glue_helper.h>
 
 /* regular block cipher functions */
-asmlinkage void __camellia_enc_blk(void *ctx, u8 *dst, const u8 *src,
+asmlinkage void __camellia_enc_blk(const void *ctx, u8 *dst, const u8 *src,
 				   bool xor);
 EXPORT_SYMBOL_GPL(__camellia_enc_blk);
-asmlinkage void camellia_dec_blk(void *ctx, u8 *dst, const u8 *src);
+asmlinkage void camellia_dec_blk(const void *ctx, u8 *dst, const u8 *src);
 EXPORT_SYMBOL_GPL(camellia_dec_blk);
 
 /* 2-way parallel cipher functions */
-asmlinkage void __camellia_enc_blk_2way(void *ctx, u8 *dst, const u8 *src,
+asmlinkage void __camellia_enc_blk_2way(const void *ctx, u8 *dst, const u8 *src,
 					bool xor);
 EXPORT_SYMBOL_GPL(__camellia_enc_blk_2way);
-asmlinkage void camellia_dec_blk_2way(void *ctx, u8 *dst, const u8 *src);
+asmlinkage void camellia_dec_blk_2way(const void *ctx, u8 *dst, const u8 *src);
 EXPORT_SYMBOL_GPL(camellia_dec_blk_2way);
 
 static void camellia_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
@@ -1265,7 +1265,7 @@ static int camellia_setkey_skcipher(struct crypto_skcipher *tfm, const u8 *key,
 	return camellia_setkey(&tfm->base, key, key_len);
 }
 
-void camellia_decrypt_cbc_2way(void *ctx, u8 *d, const u8 *s)
+void camellia_decrypt_cbc_2way(const void *ctx, u8 *d, const u8 *s)
 {
 	u128 *dst = (u128 *)d;
 	const u128 *src = (const u128 *)s;
@@ -1277,7 +1277,7 @@ void camellia_decrypt_cbc_2way(void *ctx, u8 *d, const u8 *s)
 }
 EXPORT_SYMBOL_GPL(camellia_decrypt_cbc_2way);
 
-void camellia_crypt_ctr(void *ctx, u8 *d, const u8 *s, le128 *iv)
+void camellia_crypt_ctr(const void *ctx, u8 *d, const u8 *s, le128 *iv)
 {
 	be128 ctrblk;
 	u128 *dst = (u128 *)d;
@@ -1293,7 +1293,7 @@ void camellia_crypt_ctr(void *ctx, u8 *d, const u8 *s, le128 *iv)
 }
 EXPORT_SYMBOL_GPL(camellia_crypt_ctr);
 
-void camellia_crypt_ctr_2way(void *ctx, u8 *d, const u8 *s, le128 *iv)
+void camellia_crypt_ctr_2way(const void *ctx, u8 *d, const u8 *s, le128 *iv)
 {
 	be128 ctrblks[2];
 	u128 *dst = (u128 *)d;
diff --git a/arch/x86/crypto/cast6_avx_glue.c b/arch/x86/crypto/cast6_avx_glue.c
index 299cef14a762fd..cf6d7a860ac348 100644
--- a/arch/x86/crypto/cast6_avx_glue.c
+++ b/arch/x86/crypto/cast6_avx_glue.c
@@ -20,16 +20,16 @@
 
 #define CAST6_PARALLEL_BLOCKS 8
 
-asmlinkage void cast6_ecb_enc_8way(void *ctx, u8 *dst, const u8 *src);
-asmlinkage void cast6_ecb_dec_8way(void *ctx, u8 *dst, const u8 *src);
+asmlinkage void cast6_ecb_enc_8way(const void *ctx, u8 *dst, const u8 *src);
+asmlinkage void cast6_ecb_dec_8way(const void *ctx, u8 *dst, const u8 *src);
 
-asmlinkage void cast6_cbc_dec_8way(void *ctx, u8 *dst, const u8 *src);
-asmlinkage void cast6_ctr_8way(void *ctx, u8 *dst, const u8 *src,
+asmlinkage void cast6_cbc_dec_8way(const void *ctx, u8 *dst, const u8 *src);
+asmlinkage void cast6_ctr_8way(const void *ctx, u8 *dst, const u8 *src,
 			       le128 *iv);
 
-asmlinkage void cast6_xts_enc_8way(void *ctx, u8 *dst, const u8 *src,
+asmlinkage void cast6_xts_enc_8way(const void *ctx, u8 *dst, const u8 *src,
 				   le128 *iv);
-asmlinkage void cast6_xts_dec_8way(void *ctx, u8 *dst, const u8 *src,
+asmlinkage void cast6_xts_dec_8way(const void *ctx, u8 *dst, const u8 *src,
 				   le128 *iv);
 
 static int cast6_setkey_skcipher(struct crypto_skcipher *tfm,
@@ -38,19 +38,19 @@ static int cast6_setkey_skcipher(struct crypto_skcipher *tfm,
 	return cast6_setkey(&tfm->base, key, keylen);
 }
 
-static void cast6_xts_enc(void *ctx, u8 *dst, const u8 *src, le128 *iv)
+static void cast6_xts_enc(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
 {
 	glue_xts_crypt_128bit_one(ctx, (u128 *)dst, (const u128 *)src, iv,
 				  __cast6_encrypt);
 }
 
-static void cast6_xts_dec(void *ctx, u8 *dst, const u8 *src, le128 *iv)
+static void cast6_xts_dec(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
 {
 	glue_xts_crypt_128bit_one(ctx, (u128 *)dst, (const u128 *)src, iv,
 				  __cast6_decrypt);
 }
 
-static void cast6_crypt_ctr(void *ctx, u8 *d, const u8 *s, le128 *iv)
+static void cast6_crypt_ctr(const void *ctx, u8 *d, const u8 *s, le128 *iv)
 {
 	be128 ctrblk;
 	u128 *dst = (u128 *)d;
diff --git a/arch/x86/crypto/glue_helper.c b/arch/x86/crypto/glue_helper.c
index 2eb1fc01718709..685330cb45cd35 100644
--- a/arch/x86/crypto/glue_helper.c
+++ b/arch/x86/crypto/glue_helper.c
@@ -359,8 +359,8 @@ int glue_xts_req_128bit(const struct common_glue_ctx *gctx,
 }
 EXPORT_SYMBOL_GPL(glue_xts_req_128bit);
 
-void glue_xts_crypt_128bit_one(void *ctx, u128 *dst, const u128 *src, le128 *iv,
-			       common_glue_func_t fn)
+void glue_xts_crypt_128bit_one(const void *ctx, u128 *dst, const u128 *src,
+			       le128 *iv, common_glue_func_t fn)
 {
 	le128 ivblk = *iv;
 
diff --git a/arch/x86/crypto/serpent_avx2_glue.c b/arch/x86/crypto/serpent_avx2_glue.c
index c24b2ac79ade1f..f973ace44ad358 100644
--- a/arch/x86/crypto/serpent_avx2_glue.c
+++ b/arch/x86/crypto/serpent_avx2_glue.c
@@ -19,15 +19,15 @@
 #define SERPENT_AVX2_PARALLEL_BLOCKS 16
 
 /* 16-way AVX2 parallel cipher functions */
-asmlinkage void serpent_ecb_enc_16way(void *ctx, u8 *dst, const u8 *src);
-asmlinkage void serpent_ecb_dec_16way(void *ctx, u8 *dst, const u8 *src);
-asmlinkage void serpent_cbc_dec_16way(void *ctx, u8 *dst, const u8 *src);
+asmlinkage void serpent_ecb_enc_16way(const void *ctx, u8 *dst, const u8 *src);
+asmlinkage void serpent_ecb_dec_16way(const void *ctx, u8 *dst, const u8 *src);
+asmlinkage void serpent_cbc_dec_16way(const void *ctx, u8 *dst, const u8 *src);
 
-asmlinkage void serpent_ctr_16way(void *ctx, u8 *dst, const u8 *src,
+asmlinkage void serpent_ctr_16way(const void *ctx, u8 *dst, const u8 *src,
 				  le128 *iv);
-asmlinkage void serpent_xts_enc_16way(void *ctx, u8 *dst, const u8 *src,
+asmlinkage void serpent_xts_enc_16way(const void *ctx, u8 *dst, const u8 *src,
 				      le128 *iv);
-asmlinkage void serpent_xts_dec_16way(void *ctx, u8 *dst, const u8 *src,
+asmlinkage void serpent_xts_dec_16way(const void *ctx, u8 *dst, const u8 *src,
 				      le128 *iv);
 
 static int serpent_setkey_skcipher(struct crypto_skcipher *tfm,
diff --git a/arch/x86/crypto/serpent_avx_glue.c b/arch/x86/crypto/serpent_avx_glue.c
index 48eaf27afc1226..13555edd710285 100644
--- a/arch/x86/crypto/serpent_avx_glue.c
+++ b/arch/x86/crypto/serpent_avx_glue.c
@@ -20,28 +20,31 @@
 #include <asm/crypto/serpent-avx.h>
 
 /* 8-way parallel cipher functions */
-asmlinkage void serpent_ecb_enc_8way_avx(void *ctx, u8 *dst, const u8 *src);
+asmlinkage void serpent_ecb_enc_8way_avx(const void *ctx, u8 *dst,
+					 const u8 *src);
 EXPORT_SYMBOL_GPL(serpent_ecb_enc_8way_avx);
 
-asmlinkage void serpent_ecb_dec_8way_avx(void *ctx, u8 *dst, const u8 *src);
+asmlinkage void serpent_ecb_dec_8way_avx(const void *ctx, u8 *dst,
+					 const u8 *src);
 EXPORT_SYMBOL_GPL(serpent_ecb_dec_8way_avx);
 
-asmlinkage void serpent_cbc_dec_8way_avx(void *ctx, u8 *dst, const u8 *src);
+asmlinkage void serpent_cbc_dec_8way_avx(const void *ctx, u8 *dst,
+					 const u8 *src);
 EXPORT_SYMBOL_GPL(serpent_cbc_dec_8way_avx);
 
-asmlinkage void serpent_ctr_8way_avx(void *ctx, u8 *dst, const u8 *src,
+asmlinkage void serpent_ctr_8way_avx(const void *ctx, u8 *dst, const u8 *src,
 				     le128 *iv);
 EXPORT_SYMBOL_GPL(serpent_ctr_8way_avx);
 
-asmlinkage void serpent_xts_enc_8way_avx(void *ctx, u8 *dst, const u8 *src,
-					 le128 *iv);
+asmlinkage void serpent_xts_enc_8way_avx(const void *ctx, u8 *dst,
+					 const u8 *src, le128 *iv);
 EXPORT_SYMBOL_GPL(serpent_xts_enc_8way_avx);
 
-asmlinkage void serpent_xts_dec_8way_avx(void *ctx, u8 *dst, const u8 *src,
-					 le128 *iv);
+asmlinkage void serpent_xts_dec_8way_avx(const void *ctx, u8 *dst,
+					 const u8 *src, le128 *iv);
 EXPORT_SYMBOL_GPL(serpent_xts_dec_8way_avx);
 
-void __serpent_crypt_ctr(void *ctx, u8 *d, const u8 *s, le128 *iv)
+void __serpent_crypt_ctr(const void *ctx, u8 *d, const u8 *s, le128 *iv)
 {
 	be128 ctrblk;
 	u128 *dst = (u128 *)d;
@@ -55,14 +58,14 @@ void __serpent_crypt_ctr(void *ctx, u8 *d, const u8 *s, le128 *iv)
 }
 EXPORT_SYMBOL_GPL(__serpent_crypt_ctr);
 
-void serpent_xts_enc(void *ctx, u8 *dst, const u8 *src, le128 *iv)
+void serpent_xts_enc(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
 {
 	glue_xts_crypt_128bit_one(ctx, (u128 *)dst, (const u128 *)src,
 				  iv, __serpent_encrypt);
 }
 EXPORT_SYMBOL_GPL(serpent_xts_enc);
 
-void serpent_xts_dec(void *ctx, u8 *dst, const u8 *src, le128 *iv)
+void serpent_xts_dec(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
 {
 	glue_xts_crypt_128bit_one(ctx, (u128 *)dst, (const u128 *)src,
 				  iv, __serpent_decrypt);
diff --git a/arch/x86/crypto/serpent_sse2_glue.c b/arch/x86/crypto/serpent_sse2_glue.c
index a052610070c9f0..4fed8d26b91a4e 100644
--- a/arch/x86/crypto/serpent_sse2_glue.c
+++ b/arch/x86/crypto/serpent_sse2_glue.c
@@ -31,7 +31,7 @@ static int serpent_setkey_skcipher(struct crypto_skcipher *tfm,
 	return __serpent_setkey(crypto_skcipher_ctx(tfm), key, keylen);
 }
 
-static void serpent_decrypt_cbc_xway(void *ctx, u8 *d, const u8 *s)
+static void serpent_decrypt_cbc_xway(const void *ctx, u8 *d, const u8 *s)
 {
 	u128 ivs[SERPENT_PARALLEL_BLOCKS - 1];
 	u128 *dst = (u128 *)d;
@@ -47,7 +47,7 @@ static void serpent_decrypt_cbc_xway(void *ctx, u8 *d, const u8 *s)
 		u128_xor(dst + (j + 1), dst + (j + 1), ivs + j);
 }
 
-static void serpent_crypt_ctr(void *ctx, u8 *d, const u8 *s, le128 *iv)
+static void serpent_crypt_ctr(const void *ctx, u8 *d, const u8 *s, le128 *iv)
 {
 	be128 ctrblk;
 	u128 *dst = (u128 *)d;
@@ -60,7 +60,8 @@ static void serpent_crypt_ctr(void *ctx, u8 *d, const u8 *s, le128 *iv)
 	u128_xor(dst, src, (u128 *)&ctrblk);
 }
 
-static void serpent_crypt_ctr_xway(void *ctx, u8 *d, const u8 *s, le128 *iv)
+static void serpent_crypt_ctr_xway(const void *ctx, u8 *d, const u8 *s,
+				   le128 *iv)
 {
 	be128 ctrblks[SERPENT_PARALLEL_BLOCKS];
 	u128 *dst = (u128 *)d;
diff --git a/arch/x86/crypto/twofish_avx_glue.c b/arch/x86/crypto/twofish_avx_glue.c
index f5d1f6e175f255..05ca87a14c0ad6 100644
--- a/arch/x86/crypto/twofish_avx_glue.c
+++ b/arch/x86/crypto/twofish_avx_glue.c
@@ -22,15 +22,16 @@
 #define TWOFISH_PARALLEL_BLOCKS 8
 
 /* 8-way parallel cipher functions */
-asmlinkage void twofish_ecb_enc_8way(void *ctx, u8 *dst, const u8 *src);
-asmlinkage void twofish_ecb_dec_8way(void *ctx, u8 *dst, const u8 *src);
+asmlinkage void twofish_ecb_enc_8way(const void *ctx, u8 *dst, const u8 *src);
+asmlinkage void twofish_ecb_dec_8way(const void *ctx, u8 *dst, const u8 *src);
 
-asmlinkage void twofish_cbc_dec_8way(void *ctx, u8 *dst, const u8 *src);
-asmlinkage void twofish_ctr_8way(void *ctx, u8 *dst, const u8 *src, le128 *iv);
+asmlinkage void twofish_cbc_dec_8way(const void *ctx, u8 *dst, const u8 *src);
+asmlinkage void twofish_ctr_8way(const void *ctx, u8 *dst, const u8 *src,
+				 le128 *iv);
 
-asmlinkage void twofish_xts_enc_8way(void *ctx, u8 *dst, const u8 *src,
+asmlinkage void twofish_xts_enc_8way(const void *ctx, u8 *dst, const u8 *src,
 				     le128 *iv);
-asmlinkage void twofish_xts_dec_8way(void *ctx, u8 *dst, const u8 *src,
+asmlinkage void twofish_xts_dec_8way(const void *ctx, u8 *dst, const u8 *src,
 				     le128 *iv);
 
 static int twofish_setkey_skcipher(struct crypto_skcipher *tfm,
@@ -39,18 +40,18 @@ static int twofish_setkey_skcipher(struct crypto_skcipher *tfm,
 	return twofish_setkey(&tfm->base, key, keylen);
 }
 
-static inline void twofish_enc_blk_3way(void *ctx, u8 *dst, const u8 *src)
+static inline void twofish_enc_blk_3way(const void *ctx, u8 *dst, const u8 *src)
 {
 	__twofish_enc_blk_3way(ctx, dst, src, false);
 }
 
-static void twofish_xts_enc(void *ctx, u8 *dst, const u8 *src, le128 *iv)
+static void twofish_xts_enc(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
 {
 	glue_xts_crypt_128bit_one(ctx, (u128 *)dst, (const u128 *)src,
 				  iv, twofish_enc_blk);
 }
 
-static void twofish_xts_dec(void *ctx, u8 *dst, const u8 *src, le128 *iv)
+static void twofish_xts_dec(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
 {
 	glue_xts_crypt_128bit_one(ctx, (u128 *)dst, (const u128 *)src,
 				  iv, twofish_dec_blk);
diff --git a/arch/x86/crypto/twofish_glue_3way.c b/arch/x86/crypto/twofish_glue_3way.c
index 180d9b263a942e..768af6075479c1 100644
--- a/arch/x86/crypto/twofish_glue_3way.c
+++ b/arch/x86/crypto/twofish_glue_3way.c
@@ -25,17 +25,18 @@ static int twofish_setkey_skcipher(struct crypto_skcipher *tfm,
 	return twofish_setkey(&tfm->base, key, keylen);
 }
 
-static inline void twofish_enc_blk_3way(void *ctx, u8 *dst, const u8 *src)
+static inline void twofish_enc_blk_3way(const void *ctx, u8 *dst, const u8 *src)
 {
 	__twofish_enc_blk_3way(ctx, dst, src, false);
 }
 
-static inline void twofish_enc_blk_xor_3way(void *ctx, u8 *dst, const u8 *src)
+static inline void twofish_enc_blk_xor_3way(const void *ctx, u8 *dst,
+					    const u8 *src)
 {
 	__twofish_enc_blk_3way(ctx, dst, src, true);
 }
 
-void twofish_dec_blk_cbc_3way(void *ctx, u8 *d, const u8 *s)
+void twofish_dec_blk_cbc_3way(const void *ctx, u8 *d, const u8 *s)
 {
 	u128 ivs[2];
 	u128 *dst = (u128 *)d;
@@ -51,7 +52,7 @@ void twofish_dec_blk_cbc_3way(void *ctx, u8 *d, const u8 *s)
 }
 EXPORT_SYMBOL_GPL(twofish_dec_blk_cbc_3way);
 
-void twofish_enc_blk_ctr(void *ctx, u8 *d, const u8 *s, le128 *iv)
+void twofish_enc_blk_ctr(const void *ctx, u8 *d, const u8 *s, le128 *iv)
 {
 	be128 ctrblk;
 	u128 *dst = (u128 *)d;
@@ -68,7 +69,7 @@ void twofish_enc_blk_ctr(void *ctx, u8 *d, const u8 *s, le128 *iv)
 }
 EXPORT_SYMBOL_GPL(twofish_enc_blk_ctr);
 
-void twofish_enc_blk_ctr_3way(void *ctx, u8 *d, const u8 *s, le128 *iv)
+void twofish_enc_blk_ctr_3way(const void *ctx, u8 *d, const u8 *s, le128 *iv)
 {
 	be128 ctrblks[3];
 	u128 *dst = (u128 *)d;
diff --git a/arch/x86/include/asm/crypto/camellia.h b/arch/x86/include/asm/crypto/camellia.h
index 771d73597e2e07..f1592619dd651b 100644
--- a/arch/x86/include/asm/crypto/camellia.h
+++ b/arch/x86/include/asm/crypto/camellia.h
@@ -32,55 +32,60 @@ extern int xts_camellia_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			       unsigned int keylen);
 
 /* regular block cipher functions */
-asmlinkage void __camellia_enc_blk(void *ctx, u8 *dst, const u8 *src,
+asmlinkage void __camellia_enc_blk(const void *ctx, u8 *dst, const u8 *src,
 				   bool xor);
-asmlinkage void camellia_dec_blk(void *ctx, u8 *dst, const u8 *src);
+asmlinkage void camellia_dec_blk(const void *ctx, u8 *dst, const u8 *src);
 
 /* 2-way parallel cipher functions */
-asmlinkage void __camellia_enc_blk_2way(void *ctx, u8 *dst, const u8 *src,
+asmlinkage void __camellia_enc_blk_2way(const void *ctx, u8 *dst, const u8 *src,
 					bool xor);
-asmlinkage void camellia_dec_blk_2way(void *ctx, u8 *dst, const u8 *src);
+asmlinkage void camellia_dec_blk_2way(const void *ctx, u8 *dst, const u8 *src);
 
 /* 16-way parallel cipher functions (avx/aes-ni) */
-asmlinkage void camellia_ecb_enc_16way(void *ctx, u8 *dst, const u8 *src);
-asmlinkage void camellia_ecb_dec_16way(void *ctx, u8 *dst, const u8 *src);
+asmlinkage void camellia_ecb_enc_16way(const void *ctx, u8 *dst, const u8 *src);
+asmlinkage void camellia_ecb_dec_16way(const void *ctx, u8 *dst, const u8 *src);
 
-asmlinkage void camellia_cbc_dec_16way(void *ctx, u8 *dst, const u8 *src);
-asmlinkage void camellia_ctr_16way(void *ctx, u8 *dst, const u8 *src,
+asmlinkage void camellia_cbc_dec_16way(const void *ctx, u8 *dst, const u8 *src);
+asmlinkage void camellia_ctr_16way(const void *ctx, u8 *dst, const u8 *src,
 				   le128 *iv);
 
-asmlinkage void camellia_xts_enc_16way(void *ctx, u8 *dst, const u8 *src,
+asmlinkage void camellia_xts_enc_16way(const void *ctx, u8 *dst, const u8 *src,
 				       le128 *iv);
-asmlinkage void camellia_xts_dec_16way(void *ctx, u8 *dst, const u8 *src,
+asmlinkage void camellia_xts_dec_16way(const void *ctx, u8 *dst, const u8 *src,
 				       le128 *iv);
 
-static inline void camellia_enc_blk(void *ctx, u8 *dst, const u8 *src)
+static inline void camellia_enc_blk(const void *ctx, u8 *dst, const u8 *src)
 {
 	__camellia_enc_blk(ctx, dst, src, false);
 }
 
-static inline void camellia_enc_blk_xor(void *ctx, u8 *dst, const u8 *src)
+static inline void camellia_enc_blk_xor(const void *ctx, u8 *dst, const u8 *src)
 {
 	__camellia_enc_blk(ctx, dst, src, true);
 }
 
-static inline void camellia_enc_blk_2way(void *ctx, u8 *dst, const u8 *src)
+static inline void camellia_enc_blk_2way(const void *ctx, u8 *dst,
+					 const u8 *src)
 {
 	__camellia_enc_blk_2way(ctx, dst, src, false);
 }
 
-static inline void camellia_enc_blk_xor_2way(void *ctx, u8 *dst, const u8 *src)
+static inline void camellia_enc_blk_xor_2way(const void *ctx, u8 *dst,
+					     const u8 *src)
 {
 	__camellia_enc_blk_2way(ctx, dst, src, true);
 }
 
 /* glue helpers */
-extern void camellia_decrypt_cbc_2way(void *ctx, u8 *dst, const u8 *src);
-extern void camellia_crypt_ctr(void *ctx, u8 *dst, const u8 *src, le128 *iv);
-extern void camellia_crypt_ctr_2way(void *ctx, u8 *dst, const u8 *src,
+extern void camellia_decrypt_cbc_2way(const void *ctx, u8 *dst, const u8 *src);
+extern void camellia_crypt_ctr(const void *ctx, u8 *dst, const u8 *src,
+			       le128 *iv);
+extern void camellia_crypt_ctr_2way(const void *ctx, u8 *dst, const u8 *src,
 				    le128 *iv);
 
-extern void camellia_xts_enc(void *ctx, u8 *dst, const u8 *src, le128 *iv);
-extern void camellia_xts_dec(void *ctx, u8 *dst, const u8 *src, le128 *iv);
+extern void camellia_xts_enc(const void *ctx, u8 *dst, const u8 *src,
+			     le128 *iv);
+extern void camellia_xts_dec(const void *ctx, u8 *dst, const u8 *src,
+			     le128 *iv);
 
 #endif /* ASM_X86_CAMELLIA_H */
diff --git a/arch/x86/include/asm/crypto/glue_helper.h b/arch/x86/include/asm/crypto/glue_helper.h
index d08a7085015f1a..a457cfc7dfb988 100644
--- a/arch/x86/include/asm/crypto/glue_helper.h
+++ b/arch/x86/include/asm/crypto/glue_helper.h
@@ -11,11 +11,11 @@
 #include <asm/fpu/api.h>
 #include <crypto/b128ops.h>
 
-typedef void (*common_glue_func_t)(void *ctx, u8 *dst, const u8 *src);
-typedef void (*common_glue_cbc_func_t)(void *ctx, u8 *dst, const u8 *src);
-typedef void (*common_glue_ctr_func_t)(void *ctx, u8 *dst, const u8 *src,
+typedef void (*common_glue_func_t)(const void *ctx, u8 *dst, const u8 *src);
+typedef void (*common_glue_cbc_func_t)(const void *ctx, u8 *dst, const u8 *src);
+typedef void (*common_glue_ctr_func_t)(const void *ctx, u8 *dst, const u8 *src,
 				       le128 *iv);
-typedef void (*common_glue_xts_func_t)(void *ctx, u8 *dst, const u8 *src,
+typedef void (*common_glue_xts_func_t)(const void *ctx, u8 *dst, const u8 *src,
 				       le128 *iv);
 
 struct common_glue_func_entry {
@@ -111,7 +111,8 @@ extern int glue_xts_req_128bit(const struct common_glue_ctx *gctx,
 			       common_glue_func_t tweak_fn, void *tweak_ctx,
 			       void *crypt_ctx, bool decrypt);
 
-extern void glue_xts_crypt_128bit_one(void *ctx, u128 *dst, const u128 *src,
-				      le128 *iv, common_glue_func_t fn);
+extern void glue_xts_crypt_128bit_one(const void *ctx, u128 *dst,
+				      const u128 *src, le128 *iv,
+				      common_glue_func_t fn);
 
 #endif /* _CRYPTO_GLUE_HELPER_H */
diff --git a/arch/x86/include/asm/crypto/serpent-avx.h b/arch/x86/include/asm/crypto/serpent-avx.h
index bced308db5fa8c..251c2c89d7cfe9 100644
--- a/arch/x86/include/asm/crypto/serpent-avx.h
+++ b/arch/x86/include/asm/crypto/serpent-avx.h
@@ -15,22 +15,26 @@ struct serpent_xts_ctx {
 	struct serpent_ctx crypt_ctx;
 };
 
-asmlinkage void serpent_ecb_enc_8way_avx(void *ctx, u8 *dst, const u8 *src);
-asmlinkage void serpent_ecb_dec_8way_avx(void *ctx, u8 *dst, const u8 *src);
-
-asmlinkage void serpent_cbc_dec_8way_avx(void *ctx, u8 *dst, const u8 *src);
-asmlinkage void serpent_ctr_8way_avx(void *ctx, u8 *dst, const u8 *src,
+asmlinkage void serpent_ecb_enc_8way_avx(const void *ctx, u8 *dst,
+					 const u8 *src);
+asmlinkage void serpent_ecb_dec_8way_avx(const void *ctx, u8 *dst,
+					 const u8 *src);
+
+asmlinkage void serpent_cbc_dec_8way_avx(const void *ctx, u8 *dst,
+					 const u8 *src);
+asmlinkage void serpent_ctr_8way_avx(const void *ctx, u8 *dst, const u8 *src,
 				     le128 *iv);
 
-asmlinkage void serpent_xts_enc_8way_avx(void *ctx, u8 *dst, const u8 *src,
-					 le128 *iv);
-asmlinkage void serpent_xts_dec_8way_avx(void *ctx, u8 *dst, const u8 *src,
-					 le128 *iv);
+asmlinkage void serpent_xts_enc_8way_avx(const void *ctx, u8 *dst,
+					 const u8 *src, le128 *iv);
+asmlinkage void serpent_xts_dec_8way_avx(const void *ctx, u8 *dst,
+					 const u8 *src, le128 *iv);
 
-extern void __serpent_crypt_ctr(void *ctx, u8 *dst, const u8 *src, le128 *iv);
+extern void __serpent_crypt_ctr(const void *ctx, u8 *dst, const u8 *src,
+				le128 *iv);
 
-extern void serpent_xts_enc(void *ctx, u8 *dst, const u8 *src, le128 *iv);
-extern void serpent_xts_dec(void *ctx, u8 *dst, const u8 *src, le128 *iv);
+extern void serpent_xts_enc(const void *ctx, u8 *dst, const u8 *src, le128 *iv);
+extern void serpent_xts_dec(const void *ctx, u8 *dst, const u8 *src, le128 *iv);
 
 extern int xts_serpent_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			      unsigned int keylen);
diff --git a/arch/x86/include/asm/crypto/serpent-sse2.h b/arch/x86/include/asm/crypto/serpent-sse2.h
index 491a5a7d4e15cc..860ca248914b17 100644
--- a/arch/x86/include/asm/crypto/serpent-sse2.h
+++ b/arch/x86/include/asm/crypto/serpent-sse2.h
@@ -9,25 +9,23 @@
 
 #define SERPENT_PARALLEL_BLOCKS 4
 
-asmlinkage void __serpent_enc_blk_4way(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage void __serpent_enc_blk_4way(const struct serpent_ctx *ctx, u8 *dst,
 				       const u8 *src, bool xor);
-asmlinkage void serpent_dec_blk_4way(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage void serpent_dec_blk_4way(const struct serpent_ctx *ctx, u8 *dst,
 				     const u8 *src);
 
-static inline void serpent_enc_blk_xway(struct serpent_ctx *ctx, u8 *dst,
-					const u8 *src)
+static inline void serpent_enc_blk_xway(const void *ctx, u8 *dst, const u8 *src)
 {
 	__serpent_enc_blk_4way(ctx, dst, src, false);
 }
 
-static inline void serpent_enc_blk_xway_xor(struct serpent_ctx *ctx, u8 *dst,
-					    const u8 *src)
+static inline void serpent_enc_blk_xway_xor(const struct serpent_ctx *ctx,
+					    u8 *dst, const u8 *src)
 {
 	__serpent_enc_blk_4way(ctx, dst, src, true);
 }
 
-static inline void serpent_dec_blk_xway(struct serpent_ctx *ctx, u8 *dst,
-					const u8 *src)
+static inline void serpent_dec_blk_xway(const void *ctx, u8 *dst, const u8 *src)
 {
 	serpent_dec_blk_4way(ctx, dst, src);
 }
@@ -36,23 +34,23 @@ static inline void serpent_dec_blk_xway(struct serpent_ctx *ctx, u8 *dst,
 
 #define SERPENT_PARALLEL_BLOCKS 8
 
-asmlinkage void __serpent_enc_blk_8way(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage void __serpent_enc_blk_8way(const struct serpent_ctx *ctx, u8 *dst,
 				       const u8 *src, bool xor);
-asmlinkage void serpent_dec_blk_8way(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage void serpent_dec_blk_8way(const struct serpent_ctx *ctx, u8 *dst,
 				     const u8 *src);
 
-static inline void serpent_enc_blk_xway(void *ctx, u8 *dst, const u8 *src)
+static inline void serpent_enc_blk_xway(const void *ctx, u8 *dst, const u8 *src)
 {
 	__serpent_enc_blk_8way(ctx, dst, src, false);
 }
 
-static inline void serpent_enc_blk_xway_xor(struct serpent_ctx *ctx, u8 *dst,
-				       const u8 *src)
+static inline void serpent_enc_blk_xway_xor(const struct serpent_ctx *ctx,
+					    u8 *dst, const u8 *src)
 {
 	__serpent_enc_blk_8way(ctx, dst, src, true);
 }
 
-static inline void serpent_dec_blk_xway(void *ctx, u8 *dst, const u8 *src)
+static inline void serpent_dec_blk_xway(const void *ctx, u8 *dst, const u8 *src)
 {
 	serpent_dec_blk_8way(ctx, dst, src);
 }
diff --git a/arch/x86/include/asm/crypto/twofish.h b/arch/x86/include/asm/crypto/twofish.h
index 148e0bb267e073..2c377a8042e17f 100644
--- a/arch/x86/include/asm/crypto/twofish.h
+++ b/arch/x86/include/asm/crypto/twofish.h
@@ -7,18 +7,19 @@
 #include <crypto/b128ops.h>
 
 /* regular block cipher functions from twofish_x86_64 module */
-asmlinkage void twofish_enc_blk(void *ctx, u8 *dst, const u8 *src);
-asmlinkage void twofish_dec_blk(void *ctx, u8 *dst, const u8 *src);
+asmlinkage void twofish_enc_blk(const void *ctx, u8 *dst, const u8 *src);
+asmlinkage void twofish_dec_blk(const void *ctx, u8 *dst, const u8 *src);
 
 /* 3-way parallel cipher functions */
-asmlinkage void __twofish_enc_blk_3way(void *ctx, u8 *dst, const u8 *src,
+asmlinkage void __twofish_enc_blk_3way(const void *ctx, u8 *dst, const u8 *src,
 				       bool xor);
-asmlinkage void twofish_dec_blk_3way(void *ctx, u8 *dst, const u8 *src);
+asmlinkage void twofish_dec_blk_3way(const void *ctx, u8 *dst, const u8 *src);
 
 /* helpers from twofish_x86_64-3way module */
-extern void twofish_dec_blk_cbc_3way(void *ctx, u8 *dst, const u8 *src);
-extern void twofish_enc_blk_ctr(void *ctx, u8 *dst, const u8 *src, le128 *iv);
-extern void twofish_enc_blk_ctr_3way(void *ctx, u8 *dst, const u8 *src,
+extern void twofish_dec_blk_cbc_3way(const void *ctx, u8 *dst, const u8 *src);
+extern void twofish_enc_blk_ctr(const void *ctx, u8 *dst, const u8 *src,
+				le128 *iv);
+extern void twofish_enc_blk_ctr_3way(const void *ctx, u8 *dst, const u8 *src,
 				     le128 *iv);
 
 #endif /* ASM_X86_TWOFISH_H */
diff --git a/crypto/cast6_generic.c b/crypto/cast6_generic.c
index c51121bedf68fe..85328522c5ca18 100644
--- a/crypto/cast6_generic.c
+++ b/crypto/cast6_generic.c
@@ -154,7 +154,7 @@ int cast6_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen)
 EXPORT_SYMBOL_GPL(cast6_setkey);
 
 /*forward quad round*/
-static inline void Q(u32 *block, u8 *Kr, u32 *Km)
+static inline void Q(u32 *block, const u8 *Kr, const u32 *Km)
 {
 	u32 I;
 	block[2] ^= F1(block[3], Kr[0], Km[0]);
@@ -164,7 +164,7 @@ static inline void Q(u32 *block, u8 *Kr, u32 *Km)
 }
 
 /*reverse quad round*/
-static inline void QBAR(u32 *block, u8 *Kr, u32 *Km)
+static inline void QBAR(u32 *block, const u8 *Kr, const u32 *Km)
 {
 	u32 I;
 	block[3] ^= F1(block[0], Kr[3], Km[3]);
@@ -173,14 +173,14 @@ static inline void QBAR(u32 *block, u8 *Kr, u32 *Km)
 	block[2] ^= F1(block[3], Kr[0], Km[0]);
 }
 
-void __cast6_encrypt(void *ctx, u8 *outbuf, const u8 *inbuf)
+void __cast6_encrypt(const void *ctx, u8 *outbuf, const u8 *inbuf)
 {
-	struct cast6_ctx *c = ctx;
+	const struct cast6_ctx *c = ctx;
 	const __be32 *src = (const __be32 *)inbuf;
 	__be32 *dst = (__be32 *)outbuf;
 	u32 block[4];
-	u32 *Km;
-	u8 *Kr;
+	const u32 *Km;
+	const u8 *Kr;
 
 	block[0] = be32_to_cpu(src[0]);
 	block[1] = be32_to_cpu(src[1]);
@@ -212,14 +212,14 @@ static void cast6_encrypt(struct crypto_tfm *tfm, u8 *outbuf, const u8 *inbuf)
 	__cast6_encrypt(crypto_tfm_ctx(tfm), outbuf, inbuf);
 }
 
-void __cast6_decrypt(void *ctx, u8 *outbuf, const u8 *inbuf)
+void __cast6_decrypt(const void *ctx, u8 *outbuf, const u8 *inbuf)
 {
-	struct cast6_ctx *c = ctx;
+	const struct cast6_ctx *c = ctx;
 	const __be32 *src = (const __be32 *)inbuf;
 	__be32 *dst = (__be32 *)outbuf;
 	u32 block[4];
-	u32 *Km;
-	u8 *Kr;
+	const u32 *Km;
+	const u8 *Kr;
 
 	block[0] = be32_to_cpu(src[0]);
 	block[1] = be32_to_cpu(src[1]);
diff --git a/crypto/serpent_generic.c b/crypto/serpent_generic.c
index 6309fdc7746603..492c1d0bfe068e 100644
--- a/crypto/serpent_generic.c
+++ b/crypto/serpent_generic.c
@@ -449,9 +449,9 @@ int serpent_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen)
 }
 EXPORT_SYMBOL_GPL(serpent_setkey);
 
-void __serpent_encrypt(void *c, u8 *dst, const u8 *src)
+void __serpent_encrypt(const void *c, u8 *dst, const u8 *src)
 {
-	struct serpent_ctx *ctx = c;
+	const struct serpent_ctx *ctx = c;
 	const u32 *k = ctx->expkey;
 	const __le32 *s = (const __le32 *)src;
 	__le32	*d = (__le32 *)dst;
@@ -515,9 +515,9 @@ static void serpent_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	__serpent_encrypt(ctx, dst, src);
 }
 
-void __serpent_decrypt(void *c, u8 *dst, const u8 *src)
+void __serpent_decrypt(const void *c, u8 *dst, const u8 *src)
 {
-	struct serpent_ctx *ctx = c;
+	const struct serpent_ctx *ctx = c;
 	const u32 *k = ctx->expkey;
 	const __le32 *s = (const __le32 *)src;
 	__le32	*d = (__le32 *)dst;
diff --git a/include/crypto/cast6.h b/include/crypto/cast6.h
index b6c3a0324959dd..4c8d0c72f78d48 100644
--- a/include/crypto/cast6.h
+++ b/include/crypto/cast6.h
@@ -19,7 +19,7 @@ int __cast6_setkey(struct cast6_ctx *ctx, const u8 *key,
 		   unsigned int keylen, u32 *flags);
 int cast6_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen);
 
-void __cast6_encrypt(void *ctx, u8 *dst, const u8 *src);
-void __cast6_decrypt(void *ctx, u8 *dst, const u8 *src);
+void __cast6_encrypt(const void *ctx, u8 *dst, const u8 *src);
+void __cast6_decrypt(const void *ctx, u8 *dst, const u8 *src);
 
 #endif
diff --git a/include/crypto/serpent.h b/include/crypto/serpent.h
index 986659db593947..75c7eaa2085358 100644
--- a/include/crypto/serpent.h
+++ b/include/crypto/serpent.h
@@ -22,7 +22,7 @@ int __serpent_setkey(struct serpent_ctx *ctx, const u8 *key,
 		     unsigned int keylen);
 int serpent_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen);
 
-void __serpent_encrypt(void *ctx, u8 *dst, const u8 *src);
-void __serpent_decrypt(void *ctx, u8 *dst, const u8 *src);
+void __serpent_encrypt(const void *ctx, u8 *dst, const u8 *src);
+void __serpent_decrypt(const void *ctx, u8 *dst, const u8 *src);
 
 #endif
