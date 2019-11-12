Return-Path: <SRS0=Jv20=ZE=lists.openwall.com=kernel-hardening-return-17340-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDBE8C43331
	for <kernel-hardening@archiver.kernel.org>; Tue, 12 Nov 2019 03:14:39 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2C33C21783
	for <kernel-hardening@archiver.kernel.org>; Tue, 12 Nov 2019 03:14:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="rXFM8O9v"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2C33C21783
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17340-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23830 invoked by uid 550); 12 Nov 2019 03:14:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23793 invoked from network); 12 Nov 2019 03:14:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573528459;
	bh=K+7i6guXBy7OBTeC/GC0hvXhm7wVbU21bA+ugJ43buc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rXFM8O9vPBY6G0GJvTuhFspzQ/W5ijyRj7IS9GusKAab/a3UU6CRrOg8i0Tt0Gz5K
	 1avftcRqHrT0vtlbpNgzTeGRgyFevCyr4vONxCwHeowa8bbF5ipvzVmdB4YFfYCRGC
	 R74XdwLIMA6oLqzEgYvb1mz+7e+Vq5eolfJDIvHQ=
Date: Mon, 11 Nov 2019 19:14:17 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc: Kees Cook <keescook@chromium.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	=?iso-8859-1?Q?Jo=E3o?= Moreira <joao.moreira@lsc.ic.unicamp.br>,
	Sami Tolvanen <samitolvanen@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, x86@kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v4 3/8] crypto: x86/camellia: Use new glue function macros
Message-ID: <20191112031417.GB1433@sol.localdomain>
Mail-Followup-To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>,
	Kees Cook <keescook@chromium.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	=?iso-8859-1?Q?Jo=E3o?= Moreira <joao.moreira@lsc.ic.unicamp.br>,
	Sami Tolvanen <samitolvanen@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, x86@kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
References: <20191111214552.36717-1-keescook@chromium.org>
 <20191111214552.36717-4-keescook@chromium.org>
 <3059417.7DhL3USBNQ@positron.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3059417.7DhL3USBNQ@positron.chronox.de>
User-Agent: Mutt/1.12.2 (2019-09-21)

On Tue, Nov 12, 2019 at 03:41:52AM +0100, Stephan Müller wrote:
> Am Montag, 11. November 2019, 22:45:47 CET schrieb Kees Cook:
> 
> Hi Kees,
> 
> > Convert to function declaration macros from function prototype casts
> > to avoid triggering Control-Flow Integrity checks during indirect function
> > calls.
> > 
> > Co-developed-by: João Moreira <joao.moreira@lsc.ic.unicamp.br>
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> >  arch/x86/crypto/camellia_aesni_avx2_glue.c | 73 +++++++++-------------
> >  arch/x86/crypto/camellia_aesni_avx_glue.c  | 63 +++++++------------
> >  arch/x86/crypto/camellia_glue.c            | 29 +++------
> >  arch/x86/include/asm/crypto/camellia.h     | 58 ++++-------------
> >  4 files changed, 74 insertions(+), 149 deletions(-)
> > 
> > diff --git a/arch/x86/crypto/camellia_aesni_avx2_glue.c
> > b/arch/x86/crypto/camellia_aesni_avx2_glue.c index
> > a4f00128ea55..e32b4ded3b4e 100644
> > --- a/arch/x86/crypto/camellia_aesni_avx2_glue.c
> > +++ b/arch/x86/crypto/camellia_aesni_avx2_glue.c
> > @@ -19,20 +19,12 @@
> >  #define CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS 32
> > 
> >  /* 32-way AVX2/AES-NI parallel cipher functions */
> > -asmlinkage void camellia_ecb_enc_32way(struct camellia_ctx *ctx, u8 *dst,
> > -				       const u8 *src);
> > -asmlinkage void camellia_ecb_dec_32way(struct camellia_ctx *ctx, u8 *dst,
> > -				       const u8 *src);
> > -
> > -asmlinkage void camellia_cbc_dec_32way(struct camellia_ctx *ctx, u8 *dst,
> > -				       const u8 *src);
> 
> Could you please help me understand the following: the CBC (and other) macros 
> use an u128 pointer. This (and other) existing function prototypes however use 
> u8 pointers. With the existing code, a caller may use an u8 pointer. By using 
> the new macro, there is now an implicit cast from u8 to u128 pointers.
> 
> So, in theory the current use cases of these functions could use data pointers 
> that may not be aligned to 128 bit boundaries.
> 
> How did you conclude that the now implicit casting from u8 to u128 is correct 
> in all use cases for all modified function prototypes?
> 
> Thanks a lot.
> 
> > -asmlinkage void camellia_ctr_32way(struct camellia_ctx *ctx, u8 *dst,
> > -				   const u8 *src, le128 *iv);
> > -
> > -asmlinkage void camellia_xts_enc_32way(struct camellia_ctx *ctx, u8 *dst,
> > -				       const u8 *src, le128 *iv);
> > -asmlinkage void camellia_xts_dec_32way(struct camellia_ctx *ctx, u8 *dst,
> > -				       const u8 *src, le128 *iv);
> > +CRYPTO_FUNC(camellia_ecb_enc_32way);
> > +CRYPTO_FUNC(camellia_ecb_dec_32way);
> > +CRYPTO_FUNC_CBC(camellia_cbc_dec_32way);
> > +CRYPTO_FUNC_CTR(camellia_ctr_32way);
> > +CRYPTO_FUNC_XTS(camellia_xts_enc_32way);
> > +CRYPTO_FUNC_XTS(camellia_xts_dec_32way);

None of the x86 crypto algorithms except gcm(aes) set an alignmask, so there's
no alignment guarantee at all.  So the types really should be u8, not u128.  Can
you please keep the types as u8?  You can just change the types of the
common_glue*_t functions to take u8, and add the needed u8 casts in
glue_helper.c.  (glue_helper.c really shouldn't be using u128 pointers itself
either, but that can be fixed later.)

Also, I don't see the point of the macros, other than to obfuscate things.  To
keep things straightforward, I think we should keep the explicit function
prototypes for each algorithm.

Also, the CBC function wrapping is unneeded if the types are all made u8.

- Eric
