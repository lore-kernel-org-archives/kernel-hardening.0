Return-Path: <SRS0=Z5fR=ZE=lists.openwall.com=kernel-hardening-return-17339-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CAD3C17448
	for <kernel-hardening@archiver.kernel.org>; Tue, 12 Nov 2019 02:42:21 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 050032084F
	for <kernel-hardening@archiver.kernel.org>; Tue, 12 Nov 2019 02:42:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="OAwlyQdY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 050032084F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=chronox.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17339-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11397 invoked by uid 550); 12 Nov 2019 02:42:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11358 invoked from network); 12 Nov 2019 02:42:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1573526519;
	s=strato-dkim-0002; d=chronox.de;
	h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
	bh=iAdOM9FoOA/9t091XfMnqCQeQoqJwT8ySqKDkF49mi8=;
	b=OAwlyQdYBTlZ1/m3dzwP0vwPvysFcsT9znuCCO4i9w/tLYn2FviI28yDwiXbhAvWSY
	Al1mzw879WJO1Pcqm7s9MTfaWHU6AK0hF3nZucBwCNvU6N+CvLKNhl4nGfoszZx1hODT
	iiKVRs/H4u2KyosMlD9nM+gppNoAhWD2u94xEHYcVvaMASNAIfdjcOo5jL37/dW4jrDz
	J1QAzJh22mlsfKTfFL9GWMpX1PeFiINuNJIDL2XG0DxNxAzoNJNbpOzqpV+38+8T1LcK
	1ySx2DfGdO3Z75Yxl5Lg/eLy6SmzwjCBBdwWKpipRNKUHZ7TTrt+AEJD1phkq3zM2/6y
	yNOA==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9zWgDMLyyzTHyZb69qn/xQ3l1emqDBm3cL6VhEyGWhThurAC8gyGEsg=="
X-RZG-CLASS-ID: mo00
From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To: Kees Cook <keescook@chromium.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, =?ISO-8859-1?Q?Jo=E3o?= Moreira <joao.moreira@lsc.ic.unicamp.br>, Eric Biggers <ebiggers@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, "David S. Miller" <davem@davemloft.net>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v4 3/8] crypto: x86/camellia: Use new glue function macros
Date: Tue, 12 Nov 2019 03:41:52 +0100
Message-ID: <3059417.7DhL3USBNQ@positron.chronox.de>
In-Reply-To: <20191111214552.36717-4-keescook@chromium.org>
References: <20191111214552.36717-1-keescook@chromium.org> <20191111214552.36717-4-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Am Montag, 11. November 2019, 22:45:47 CET schrieb Kees Cook:

Hi Kees,

> Convert to function declaration macros from function prototype casts
> to avoid triggering Control-Flow Integrity checks during indirect function
> calls.
>=20
> Co-developed-by: Jo=E3o Moreira <joao.moreira@lsc.ic.unicamp.br>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/x86/crypto/camellia_aesni_avx2_glue.c | 73 +++++++++-------------
>  arch/x86/crypto/camellia_aesni_avx_glue.c  | 63 +++++++------------
>  arch/x86/crypto/camellia_glue.c            | 29 +++------
>  arch/x86/include/asm/crypto/camellia.h     | 58 ++++-------------
>  4 files changed, 74 insertions(+), 149 deletions(-)
>=20
> diff --git a/arch/x86/crypto/camellia_aesni_avx2_glue.c
> b/arch/x86/crypto/camellia_aesni_avx2_glue.c index
> a4f00128ea55..e32b4ded3b4e 100644
> --- a/arch/x86/crypto/camellia_aesni_avx2_glue.c
> +++ b/arch/x86/crypto/camellia_aesni_avx2_glue.c
> @@ -19,20 +19,12 @@
>  #define CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS 32
>=20
>  /* 32-way AVX2/AES-NI parallel cipher functions */
> -asmlinkage void camellia_ecb_enc_32way(struct camellia_ctx *ctx, u8 *dst,
> -				       const u8 *src);
> -asmlinkage void camellia_ecb_dec_32way(struct camellia_ctx *ctx, u8 *dst,
> -				       const u8 *src);
> -
> -asmlinkage void camellia_cbc_dec_32way(struct camellia_ctx *ctx, u8 *dst,
> -				       const u8 *src);

Could you please help me understand the following: the CBC (and other) macr=
os=20
use an u128 pointer. This (and other) existing function prototypes however =
use=20
u8 pointers. With the existing code, a caller may use an u8 pointer. By usi=
ng=20
the new macro, there is now an implicit cast from u8 to u128 pointers.

So, in theory the current use cases of these functions could use data point=
ers=20
that may not be aligned to 128 bit boundaries.

How did you conclude that the now implicit casting from u8 to u128 is corre=
ct=20
in all use cases for all modified function prototypes?

Thanks a lot.

> -asmlinkage void camellia_ctr_32way(struct camellia_ctx *ctx, u8 *dst,
> -				   const u8 *src, le128 *iv);
> -
> -asmlinkage void camellia_xts_enc_32way(struct camellia_ctx *ctx, u8 *dst,
> -				       const u8 *src, le128 *iv);
> -asmlinkage void camellia_xts_dec_32way(struct camellia_ctx *ctx, u8 *dst,
> -				       const u8 *src, le128 *iv);
> +CRYPTO_FUNC(camellia_ecb_enc_32way);
> +CRYPTO_FUNC(camellia_ecb_dec_32way);
> +CRYPTO_FUNC_CBC(camellia_cbc_dec_32way);
> +CRYPTO_FUNC_CTR(camellia_ctr_32way);
> +CRYPTO_FUNC_XTS(camellia_xts_enc_32way);
> +CRYPTO_FUNC_XTS(camellia_xts_dec_32way);
>=20
>  static const struct common_glue_ctx camellia_enc =3D {
>  	.num_funcs =3D 4,
> @@ -40,16 +32,16 @@ static const struct common_glue_ctx camellia_enc =3D {
>=20
>  	.funcs =3D { {
>  		.num_blocks =3D CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS,
> -		.fn_u =3D { .ecb =3D GLUE_FUNC_CAST(camellia_ecb_enc_32way) }
> +		.fn_u =3D { .ecb =3D camellia_ecb_enc_32way }
>  	}, {
>  		.num_blocks =3D CAMELLIA_AESNI_PARALLEL_BLOCKS,
> -		.fn_u =3D { .ecb =3D GLUE_FUNC_CAST(camellia_ecb_enc_16way) }
> +		.fn_u =3D { .ecb =3D camellia_ecb_enc_16way }
>  	}, {
>  		.num_blocks =3D 2,
> -		.fn_u =3D { .ecb =3D GLUE_FUNC_CAST(camellia_enc_blk_2way) }
> +		.fn_u =3D { .ecb =3D camellia_enc_blk_2way }
>  	}, {
>  		.num_blocks =3D 1,
> -		.fn_u =3D { .ecb =3D GLUE_FUNC_CAST(camellia_enc_blk) }
> +		.fn_u =3D { .ecb =3D camellia_enc_blk }
>  	} }
>  };
>=20
> @@ -59,16 +51,16 @@ static const struct common_glue_ctx camellia_ctr =3D {
>=20
>  	.funcs =3D { {
>  		.num_blocks =3D CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS,
> -		.fn_u =3D { .ctr =3D GLUE_CTR_FUNC_CAST(camellia_ctr_32way) }
> +		.fn_u =3D { .ctr =3D camellia_ctr_32way }
>  	}, {
>  		.num_blocks =3D CAMELLIA_AESNI_PARALLEL_BLOCKS,
> -		.fn_u =3D { .ctr =3D GLUE_CTR_FUNC_CAST(camellia_ctr_16way) }
> +		.fn_u =3D { .ctr =3D camellia_ctr_16way }
>  	}, {
>  		.num_blocks =3D 2,
> -		.fn_u =3D { .ctr =3D GLUE_CTR_FUNC_CAST(camellia_crypt_ctr_2way) }
> +		.fn_u =3D { .ctr =3D camellia_crypt_ctr_2way }
>  	}, {
>  		.num_blocks =3D 1,
> -		.fn_u =3D { .ctr =3D GLUE_CTR_FUNC_CAST(camellia_crypt_ctr) }
> +		.fn_u =3D { .ctr =3D camellia_crypt_ctr }
>  	} }
>  };
>=20
> @@ -78,13 +70,13 @@ static const struct common_glue_ctx camellia_enc_xts =
=3D {
>=20
>  	.funcs =3D { {
>  		.num_blocks =3D CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS,
> -		.fn_u =3D { .xts =3D GLUE_XTS_FUNC_CAST(camellia_xts_enc_32way) }
> +		.fn_u =3D { .xts =3D camellia_xts_enc_32way }
>  	}, {
>  		.num_blocks =3D CAMELLIA_AESNI_PARALLEL_BLOCKS,
> -		.fn_u =3D { .xts =3D GLUE_XTS_FUNC_CAST(camellia_xts_enc_16way) }
> +		.fn_u =3D { .xts =3D camellia_xts_enc_16way }
>  	}, {
>  		.num_blocks =3D 1,
> -		.fn_u =3D { .xts =3D GLUE_XTS_FUNC_CAST(camellia_xts_enc) }
> +		.fn_u =3D { .xts =3D camellia_xts_enc }
>  	} }
>  };
>=20
> @@ -94,16 +86,16 @@ static const struct common_glue_ctx camellia_dec =3D {
>=20
>  	.funcs =3D { {
>  		.num_blocks =3D CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS,
> -		.fn_u =3D { .ecb =3D GLUE_FUNC_CAST(camellia_ecb_dec_32way) }
> +		.fn_u =3D { .ecb =3D camellia_ecb_dec_32way }
>  	}, {
>  		.num_blocks =3D CAMELLIA_AESNI_PARALLEL_BLOCKS,
> -		.fn_u =3D { .ecb =3D GLUE_FUNC_CAST(camellia_ecb_dec_16way) }
> +		.fn_u =3D { .ecb =3D camellia_ecb_dec_16way }
>  	}, {
>  		.num_blocks =3D 2,
> -		.fn_u =3D { .ecb =3D GLUE_FUNC_CAST(camellia_dec_blk_2way) }
> +		.fn_u =3D { .ecb =3D camellia_dec_blk_2way }
>  	}, {
>  		.num_blocks =3D 1,
> -		.fn_u =3D { .ecb =3D GLUE_FUNC_CAST(camellia_dec_blk) }
> +		.fn_u =3D { .ecb =3D camellia_dec_blk }
>  	} }
>  };
>=20
> @@ -113,16 +105,16 @@ static const struct common_glue_ctx camellia_dec_cb=
c =3D
> {
>=20
>  	.funcs =3D { {
>  		.num_blocks =3D CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS,
> -		.fn_u =3D { .cbc =3D GLUE_CBC_FUNC_CAST(camellia_cbc_dec_32way) }
> +		.fn_u =3D { .cbc =3D camellia_cbc_dec_32way }
>  	}, {
>  		.num_blocks =3D CAMELLIA_AESNI_PARALLEL_BLOCKS,
> -		.fn_u =3D { .cbc =3D GLUE_CBC_FUNC_CAST(camellia_cbc_dec_16way) }
> +		.fn_u =3D { .cbc =3D camellia_cbc_dec_16way }
>  	}, {
>  		.num_blocks =3D 2,
> -		.fn_u =3D { .cbc =3D GLUE_CBC_FUNC_CAST(camellia_decrypt_cbc_2way) }
> +		.fn_u =3D { .cbc =3D camellia_decrypt_cbc_2way }
>  	}, {
>  		.num_blocks =3D 1,
> -		.fn_u =3D { .cbc =3D GLUE_CBC_FUNC_CAST(camellia_dec_blk) }
> +		.fn_u =3D { .cbc =3D camellia_dec_blk_cbc }
>  	} }
>  };
>=20
> @@ -132,13 +124,13 @@ static const struct common_glue_ctx camellia_dec_xt=
s =3D
> {
>=20
>  	.funcs =3D { {
>  		.num_blocks =3D CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS,
> -		.fn_u =3D { .xts =3D GLUE_XTS_FUNC_CAST(camellia_xts_dec_32way) }
> +		.fn_u =3D { .xts =3D camellia_xts_dec_32way }
>  	}, {
>  		.num_blocks =3D CAMELLIA_AESNI_PARALLEL_BLOCKS,
> -		.fn_u =3D { .xts =3D GLUE_XTS_FUNC_CAST(camellia_xts_dec_16way) }
> +		.fn_u =3D { .xts =3D camellia_xts_dec_16way }
>  	}, {
>  		.num_blocks =3D 1,
> -		.fn_u =3D { .xts =3D GLUE_XTS_FUNC_CAST(camellia_xts_dec) }
> +		.fn_u =3D { .xts =3D camellia_xts_dec }
>  	} }
>  };
>=20
> @@ -161,8 +153,7 @@ static int ecb_decrypt(struct skcipher_request *req)
>=20
>  static int cbc_encrypt(struct skcipher_request *req)
>  {
> -	return glue_cbc_encrypt_req_128bit(GLUE_FUNC_CAST(camellia_enc_blk),
> -					   req);
> +	return glue_cbc_encrypt_req_128bit(camellia_enc_blk, req);
>  }
>=20
>  static int cbc_decrypt(struct skcipher_request *req)
> @@ -180,8 +171,7 @@ static int xts_encrypt(struct skcipher_request *req)
>  	struct crypto_skcipher *tfm =3D crypto_skcipher_reqtfm(req);
>  	struct camellia_xts_ctx *ctx =3D crypto_skcipher_ctx(tfm);
>=20
> -	return glue_xts_req_128bit(&camellia_enc_xts, req,
> -				   XTS_TWEAK_CAST(camellia_enc_blk),
> +	return glue_xts_req_128bit(&camellia_enc_xts, req, camellia_enc_blk,
>  				   &ctx->tweak_ctx, &ctx->crypt_ctx, false);
>  }
>=20
> @@ -190,8 +180,7 @@ static int xts_decrypt(struct skcipher_request *req)
>  	struct crypto_skcipher *tfm =3D crypto_skcipher_reqtfm(req);
>  	struct camellia_xts_ctx *ctx =3D crypto_skcipher_ctx(tfm);
>=20
> -	return glue_xts_req_128bit(&camellia_dec_xts, req,
> -				   XTS_TWEAK_CAST(camellia_enc_blk),
> +	return glue_xts_req_128bit(&camellia_dec_xts, req, camellia_enc_blk,
>  				   &ctx->tweak_ctx, &ctx->crypt_ctx, true);
>  }
>=20
> diff --git a/arch/x86/crypto/camellia_aesni_avx_glue.c
> b/arch/x86/crypto/camellia_aesni_avx_glue.c index
> f28d282779b8..70445c8d8540 100644
> --- a/arch/x86/crypto/camellia_aesni_avx_glue.c
> +++ b/arch/x86/crypto/camellia_aesni_avx_glue.c
> @@ -6,7 +6,6 @@
>   */
>=20
>  #include <asm/crypto/camellia.h>
> -#include <asm/crypto/glue_helper.h>
>  #include <crypto/algapi.h>
>  #include <crypto/internal/simd.h>
>  #include <crypto/xts.h>
> @@ -18,41 +17,22 @@
>  #define CAMELLIA_AESNI_PARALLEL_BLOCKS 16
>=20
>  /* 16-way parallel cipher functions (avx/aes-ni) */
> -asmlinkage void camellia_ecb_enc_16way(struct camellia_ctx *ctx, u8 *dst,
> -				       const u8 *src);
>  EXPORT_SYMBOL_GPL(camellia_ecb_enc_16way);
> -
> -asmlinkage void camellia_ecb_dec_16way(struct camellia_ctx *ctx, u8 *dst,
> -				       const u8 *src);
>  EXPORT_SYMBOL_GPL(camellia_ecb_dec_16way);
> -
> -asmlinkage void camellia_cbc_dec_16way(struct camellia_ctx *ctx, u8 *dst,
> -				       const u8 *src);
>  EXPORT_SYMBOL_GPL(camellia_cbc_dec_16way);
> -
> -asmlinkage void camellia_ctr_16way(struct camellia_ctx *ctx, u8 *dst,
> -				   const u8 *src, le128 *iv);
>  EXPORT_SYMBOL_GPL(camellia_ctr_16way);
> -
> -asmlinkage void camellia_xts_enc_16way(struct camellia_ctx *ctx, u8 *dst,
> -				       const u8 *src, le128 *iv);
>  EXPORT_SYMBOL_GPL(camellia_xts_enc_16way);
> -
> -asmlinkage void camellia_xts_dec_16way(struct camellia_ctx *ctx, u8 *dst,
> -				       const u8 *src, le128 *iv);
>  EXPORT_SYMBOL_GPL(camellia_xts_dec_16way);
>=20
>  void camellia_xts_enc(void *ctx, u128 *dst, const u128 *src, le128 *iv)
>  {
> -	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
> -				  GLUE_FUNC_CAST(camellia_enc_blk));
> +	glue_xts_crypt_128bit_one(ctx, dst, src, iv, camellia_enc_blk);
>  }
>  EXPORT_SYMBOL_GPL(camellia_xts_enc);
>=20
>  void camellia_xts_dec(void *ctx, u128 *dst, const u128 *src, le128 *iv)
>  {
> -	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
> -				  GLUE_FUNC_CAST(camellia_dec_blk));
> +	glue_xts_crypt_128bit_one(ctx, dst, src, iv, camellia_dec_blk);
>  }
>  EXPORT_SYMBOL_GPL(camellia_xts_dec);
>=20
> @@ -62,13 +42,13 @@ static const struct common_glue_ctx camellia_enc =3D {
>=20
>  	.funcs =3D { {
>  		.num_blocks =3D CAMELLIA_AESNI_PARALLEL_BLOCKS,
> -		.fn_u =3D { .ecb =3D GLUE_FUNC_CAST(camellia_ecb_enc_16way) }
> +		.fn_u =3D { .ecb =3D camellia_ecb_enc_16way }
>  	}, {
>  		.num_blocks =3D 2,
> -		.fn_u =3D { .ecb =3D GLUE_FUNC_CAST(camellia_enc_blk_2way) }
> +		.fn_u =3D { .ecb =3D camellia_enc_blk_2way }
>  	}, {
>  		.num_blocks =3D 1,
> -		.fn_u =3D { .ecb =3D GLUE_FUNC_CAST(camellia_enc_blk) }
> +		.fn_u =3D { .ecb =3D camellia_enc_blk }
>  	} }
>  };
>=20
> @@ -78,13 +58,13 @@ static const struct common_glue_ctx camellia_ctr =3D {
>=20
>  	.funcs =3D { {
>  		.num_blocks =3D CAMELLIA_AESNI_PARALLEL_BLOCKS,
> -		.fn_u =3D { .ctr =3D GLUE_CTR_FUNC_CAST(camellia_ctr_16way) }
> +		.fn_u =3D { .ctr =3D camellia_ctr_16way }
>  	}, {
>  		.num_blocks =3D 2,
> -		.fn_u =3D { .ctr =3D GLUE_CTR_FUNC_CAST(camellia_crypt_ctr_2way) }
> +		.fn_u =3D { .ctr =3D camellia_crypt_ctr_2way }
>  	}, {
>  		.num_blocks =3D 1,
> -		.fn_u =3D { .ctr =3D GLUE_CTR_FUNC_CAST(camellia_crypt_ctr) }
> +		.fn_u =3D { .ctr =3D camellia_crypt_ctr }
>  	} }
>  };
>=20
> @@ -94,10 +74,10 @@ static const struct common_glue_ctx camellia_enc_xts =
=3D {
>=20
>  	.funcs =3D { {
>  		.num_blocks =3D CAMELLIA_AESNI_PARALLEL_BLOCKS,
> -		.fn_u =3D { .xts =3D GLUE_XTS_FUNC_CAST(camellia_xts_enc_16way) }
> +		.fn_u =3D { .xts =3D camellia_xts_enc_16way }
>  	}, {
>  		.num_blocks =3D 1,
> -		.fn_u =3D { .xts =3D GLUE_XTS_FUNC_CAST(camellia_xts_enc) }
> +		.fn_u =3D { .xts =3D camellia_xts_enc }
>  	} }
>  };
>=20
> @@ -107,13 +87,13 @@ static const struct common_glue_ctx camellia_dec =3D=
 {
>=20
>  	.funcs =3D { {
>  		.num_blocks =3D CAMELLIA_AESNI_PARALLEL_BLOCKS,
> -		.fn_u =3D { .ecb =3D GLUE_FUNC_CAST(camellia_ecb_dec_16way) }
> +		.fn_u =3D { .ecb =3D camellia_ecb_dec_16way }
>  	}, {
>  		.num_blocks =3D 2,
> -		.fn_u =3D { .ecb =3D GLUE_FUNC_CAST(camellia_dec_blk_2way) }
> +		.fn_u =3D { .ecb =3D camellia_dec_blk_2way }
>  	}, {
>  		.num_blocks =3D 1,
> -		.fn_u =3D { .ecb =3D GLUE_FUNC_CAST(camellia_dec_blk) }
> +		.fn_u =3D { .ecb =3D camellia_dec_blk }
>  	} }
>  };
>=20
> @@ -123,13 +103,13 @@ static const struct common_glue_ctx camellia_dec_cb=
c =3D
> {
>=20
>  	.funcs =3D { {
>  		.num_blocks =3D CAMELLIA_AESNI_PARALLEL_BLOCKS,
> -		.fn_u =3D { .cbc =3D GLUE_CBC_FUNC_CAST(camellia_cbc_dec_16way) }
> +		.fn_u =3D { .cbc =3D camellia_cbc_dec_16way }
>  	}, {
>  		.num_blocks =3D 2,
> -		.fn_u =3D { .cbc =3D GLUE_CBC_FUNC_CAST(camellia_decrypt_cbc_2way) }
> +		.fn_u =3D { .cbc =3D camellia_decrypt_cbc_2way }
>  	}, {
>  		.num_blocks =3D 1,
> -		.fn_u =3D { .cbc =3D GLUE_CBC_FUNC_CAST(camellia_dec_blk) }
> +		.fn_u =3D { .cbc =3D camellia_dec_blk_cbc }
>  	} }
>  };
>=20
> @@ -139,10 +119,10 @@ static const struct common_glue_ctx camellia_dec_xt=
s =3D
> {
>=20
>  	.funcs =3D { {
>  		.num_blocks =3D CAMELLIA_AESNI_PARALLEL_BLOCKS,
> -		.fn_u =3D { .xts =3D GLUE_XTS_FUNC_CAST(camellia_xts_dec_16way) }
> +		.fn_u =3D { .xts =3D camellia_xts_dec_16way }
>  	}, {
>  		.num_blocks =3D 1,
> -		.fn_u =3D { .xts =3D GLUE_XTS_FUNC_CAST(camellia_xts_dec) }
> +		.fn_u =3D { .xts =3D camellia_xts_dec }
>  	} }
>  };
>=20
> @@ -165,8 +145,7 @@ static int ecb_decrypt(struct skcipher_request *req)
>=20
>  static int cbc_encrypt(struct skcipher_request *req)
>  {
> -	return glue_cbc_encrypt_req_128bit(GLUE_FUNC_CAST(camellia_enc_blk),
> -					   req);
> +	return glue_cbc_encrypt_req_128bit(camellia_enc_blk, req);
>  }
>=20
>  static int cbc_decrypt(struct skcipher_request *req)
> @@ -207,7 +186,7 @@ static int xts_encrypt(struct skcipher_request *req)
>  	struct camellia_xts_ctx *ctx =3D crypto_skcipher_ctx(tfm);
>=20
>  	return glue_xts_req_128bit(&camellia_enc_xts, req,
> -				   XTS_TWEAK_CAST(camellia_enc_blk),
> +				   camellia_enc_blk,
>  				   &ctx->tweak_ctx, &ctx->crypt_ctx, false);
>  }
>=20
> @@ -217,7 +196,7 @@ static int xts_decrypt(struct skcipher_request *req)
>  	struct camellia_xts_ctx *ctx =3D crypto_skcipher_ctx(tfm);
>=20
>  	return glue_xts_req_128bit(&camellia_dec_xts, req,
> -				   XTS_TWEAK_CAST(camellia_enc_blk),
> +				   camellia_enc_blk,
>  				   &ctx->tweak_ctx, &ctx->crypt_ctx, true);
>  }
>=20
> diff --git a/arch/x86/crypto/camellia_glue.c
> b/arch/x86/crypto/camellia_glue.c index 7c62db56ffe1..98d459e322e6 100644
> --- a/arch/x86/crypto/camellia_glue.c
> +++ b/arch/x86/crypto/camellia_glue.c
> @@ -18,19 +18,11 @@
>  #include <asm/crypto/glue_helper.h>
>=20
>  /* regular block cipher functions */
> -asmlinkage void __camellia_enc_blk(struct camellia_ctx *ctx, u8 *dst,
> -				   const u8 *src, bool xor);
>  EXPORT_SYMBOL_GPL(__camellia_enc_blk);
> -asmlinkage void camellia_dec_blk(struct camellia_ctx *ctx, u8 *dst,
> -				 const u8 *src);
>  EXPORT_SYMBOL_GPL(camellia_dec_blk);
>=20
>  /* 2-way parallel cipher functions */
> -asmlinkage void __camellia_enc_blk_2way(struct camellia_ctx *ctx, u8 *ds=
t,
> -					const u8 *src, bool xor);
>  EXPORT_SYMBOL_GPL(__camellia_enc_blk_2way);
> -asmlinkage void camellia_dec_blk_2way(struct camellia_ctx *ctx, u8 *dst,
> -				      const u8 *src);
>  EXPORT_SYMBOL_GPL(camellia_dec_blk_2way);
>=20
>  static void camellia_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8
> *src) @@ -1305,7 +1297,7 @@ void camellia_crypt_ctr_2way(void *ctx, u128
> *dst, const u128 *src, le128 *iv) le128_to_be128(&ctrblks[1], iv);
>  	le128_inc(iv);
>=20
> -	camellia_enc_blk_xor_2way(ctx, (u8 *)dst, (u8 *)ctrblks);
> +	camellia_enc_blk_2way_xor(ctx, (u8 *)dst, (u8 *)ctrblks);
>  }
>  EXPORT_SYMBOL_GPL(camellia_crypt_ctr_2way);
>=20
> @@ -1315,10 +1307,10 @@ static const struct common_glue_ctx camellia_enc =
=3D {
>=20
>  	.funcs =3D { {
>  		.num_blocks =3D 2,
> -		.fn_u =3D { .ecb =3D GLUE_FUNC_CAST(camellia_enc_blk_2way) }
> +		.fn_u =3D { .ecb =3D camellia_enc_blk_2way }
>  	}, {
>  		.num_blocks =3D 1,
> -		.fn_u =3D { .ecb =3D GLUE_FUNC_CAST(camellia_enc_blk) }
> +		.fn_u =3D { .ecb =3D camellia_enc_blk }
>  	} }
>  };
>=20
> @@ -1328,10 +1320,10 @@ static const struct common_glue_ctx camellia_ctr =
=3D {
>=20
>  	.funcs =3D { {
>  		.num_blocks =3D 2,
> -		.fn_u =3D { .ctr =3D GLUE_CTR_FUNC_CAST(camellia_crypt_ctr_2way) }
> +		.fn_u =3D { .ctr =3D camellia_crypt_ctr_2way }
>  	}, {
>  		.num_blocks =3D 1,
> -		.fn_u =3D { .ctr =3D GLUE_CTR_FUNC_CAST(camellia_crypt_ctr) }
> +		.fn_u =3D { .ctr =3D camellia_crypt_ctr }
>  	} }
>  };
>=20
> @@ -1341,10 +1333,10 @@ static const struct common_glue_ctx camellia_dec =
=3D {
>=20
>  	.funcs =3D { {
>  		.num_blocks =3D 2,
> -		.fn_u =3D { .ecb =3D GLUE_FUNC_CAST(camellia_dec_blk_2way) }
> +		.fn_u =3D { .ecb =3D camellia_dec_blk_2way }
>  	}, {
>  		.num_blocks =3D 1,
> -		.fn_u =3D { .ecb =3D GLUE_FUNC_CAST(camellia_dec_blk) }
> +		.fn_u =3D { .ecb =3D camellia_dec_blk }
>  	} }
>  };
>=20
> @@ -1354,10 +1346,10 @@ static const struct common_glue_ctx camellia_dec_=
cbc
> =3D {
>=20
>  	.funcs =3D { {
>  		.num_blocks =3D 2,
> -		.fn_u =3D { .cbc =3D GLUE_CBC_FUNC_CAST(camellia_decrypt_cbc_2way) }
> +		.fn_u =3D { .cbc =3D camellia_decrypt_cbc_2way }
>  	}, {
>  		.num_blocks =3D 1,
> -		.fn_u =3D { .cbc =3D GLUE_CBC_FUNC_CAST(camellia_dec_blk) }
> +		.fn_u =3D { .cbc =3D camellia_dec_blk_cbc }
>  	} }
>  };
>=20
> @@ -1373,8 +1365,7 @@ static int ecb_decrypt(struct skcipher_request *req)
>=20
>  static int cbc_encrypt(struct skcipher_request *req)
>  {
> -	return glue_cbc_encrypt_req_128bit(GLUE_FUNC_CAST(camellia_enc_blk),
> -					   req);
> +	return glue_cbc_encrypt_req_128bit(camellia_enc_blk, req);
>  }
>=20
>  static int cbc_decrypt(struct skcipher_request *req)
> diff --git a/arch/x86/include/asm/crypto/camellia.h
> b/arch/x86/include/asm/crypto/camellia.h index a5d86fc0593f..8053b01f8418
> 100644
> --- a/arch/x86/include/asm/crypto/camellia.h
> +++ b/arch/x86/include/asm/crypto/camellia.h
> @@ -2,6 +2,7 @@
>  #ifndef ASM_X86_CAMELLIA_H
>  #define ASM_X86_CAMELLIA_H
>=20
> +#include <asm/crypto/glue_helper.h>
>  #include <crypto/b128ops.h>
>  #include <linux/crypto.h>
>  #include <linux/kernel.h>
> @@ -32,56 +33,21 @@ extern int xts_camellia_setkey(struct crypto_skcipher
> *tfm, const u8 *key, unsigned int keylen);
>=20
>  /* regular block cipher functions */
> -asmlinkage void __camellia_enc_blk(struct camellia_ctx *ctx, u8 *dst,
> -				   const u8 *src, bool xor);
> -asmlinkage void camellia_dec_blk(struct camellia_ctx *ctx, u8 *dst,
> -				 const u8 *src);
> +CRYPTO_FUNC_XOR(camellia_enc_blk);
> +CRYPTO_FUNC(camellia_dec_blk);
> +CRYPTO_FUNC_WRAP_CBC(camellia_dec_blk);
>=20
>  /* 2-way parallel cipher functions */
> -asmlinkage void __camellia_enc_blk_2way(struct camellia_ctx *ctx, u8 *ds=
t,
> -					const u8 *src, bool xor);
> -asmlinkage void camellia_dec_blk_2way(struct camellia_ctx *ctx, u8 *dst,
> -				      const u8 *src);
> +CRYPTO_FUNC_XOR(camellia_enc_blk_2way);
> +CRYPTO_FUNC(camellia_dec_blk_2way);
>=20
>  /* 16-way parallel cipher functions (avx/aes-ni) */
> -asmlinkage void camellia_ecb_enc_16way(struct camellia_ctx *ctx, u8 *dst,
> -				       const u8 *src);
> -asmlinkage void camellia_ecb_dec_16way(struct camellia_ctx *ctx, u8 *dst,
> -				       const u8 *src);
> -
> -asmlinkage void camellia_cbc_dec_16way(struct camellia_ctx *ctx, u8 *dst,
> -				       const u8 *src);
> -asmlinkage void camellia_ctr_16way(struct camellia_ctx *ctx, u8 *dst,
> -				   const u8 *src, le128 *iv);
> -
> -asmlinkage void camellia_xts_enc_16way(struct camellia_ctx *ctx, u8 *dst,
> -				       const u8 *src, le128 *iv);
> -asmlinkage void camellia_xts_dec_16way(struct camellia_ctx *ctx, u8 *dst,
> -				       const u8 *src, le128 *iv);
> -
> -static inline void camellia_enc_blk(struct camellia_ctx *ctx, u8 *dst,
> -				    const u8 *src)
> -{
> -	__camellia_enc_blk(ctx, dst, src, false);
> -}
> -
> -static inline void camellia_enc_blk_xor(struct camellia_ctx *ctx, u8 *ds=
t,
> -					const u8 *src)
> -{
> -	__camellia_enc_blk(ctx, dst, src, true);
> -}
> -
> -static inline void camellia_enc_blk_2way(struct camellia_ctx *ctx, u8 *d=
st,
> -					 const u8 *src)
> -{
> -	__camellia_enc_blk_2way(ctx, dst, src, false);
> -}
> -
> -static inline void camellia_enc_blk_xor_2way(struct camellia_ctx *ctx, u8
> *dst, -					     const u8 *src)
> -{
> -	__camellia_enc_blk_2way(ctx, dst, src, true);
> -}
> +CRYPTO_FUNC(camellia_ecb_enc_16way);
> +CRYPTO_FUNC(camellia_ecb_dec_16way);
> +CRYPTO_FUNC_CBC(camellia_cbc_dec_16way);
> +CRYPTO_FUNC_CTR(camellia_ctr_16way);
> +CRYPTO_FUNC_XTS(camellia_xts_enc_16way);
> +CRYPTO_FUNC_XTS(camellia_xts_dec_16way);
>=20
>  /* glue helpers */
>  extern void camellia_decrypt_cbc_2way(void *ctx, u128 *dst, const u128
> *src);


Ciao
Stephan


