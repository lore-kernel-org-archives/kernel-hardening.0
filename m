Return-Path: <SRS0=WFKd=ZF=lists.openwall.com=kernel-hardening-return-17360-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36BDDC432C3
	for <kernel-hardening@archiver.kernel.org>; Wed, 13 Nov 2019 19:55:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2DEFC206E1
	for <kernel-hardening@archiver.kernel.org>; Wed, 13 Nov 2019 19:55:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Azpy8mEr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2DEFC206E1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17360-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1562 invoked by uid 550); 13 Nov 2019 19:55:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1524 invoked from network); 13 Nov 2019 19:55:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573674932;
	bh=+xX4T292kmZPyjMt+ZzYlLxnM6bEpvKK3p+NvavvN0k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Azpy8mErVREYVRWovo3eozNIltWgJcIC5YxDopltuq44onMyzJgGEadjNQI9KHmPy
	 2pRznMLAHamRApspgu6qWIJ7V4jLJBQbBid+7FNy/F366JeIIwev2krbtIGRpmPkAb
	 uY7Vpnwoq/i1hPDUky3WFScLdvA0Wrui55BNOPdM=
Date: Wed, 13 Nov 2019 11:55:30 -0800
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
Subject: Re: [PATCH v5 8/8] crypto, x86/sha: Eliminate casts on asm
 implementations
Message-ID: <20191113195529.GD221701@gmail.com>
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
 <20191113182516.13545-9-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113182516.13545-9-keescook@chromium.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Nov 13, 2019 at 10:25:16AM -0800, Kees Cook wrote:
> In order to avoid CFI function prototype mismatches, this removes the
> casts on assembly implementations of sha1/256/512 accelerators. The
> safety checks from BUILD_BUG_ON() remain.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/x86/crypto/sha1_ssse3_glue.c   | 61 ++++++++++++-----------------
>  arch/x86/crypto/sha256_ssse3_glue.c | 31 +++++++--------
>  arch/x86/crypto/sha512_ssse3_glue.c | 28 ++++++-------
>  3 files changed, 50 insertions(+), 70 deletions(-)
> 
> diff --git a/arch/x86/crypto/sha1_ssse3_glue.c b/arch/x86/crypto/sha1_ssse3_glue.c
> index 639d4c2fd6a8..a151d899f37a 100644
> --- a/arch/x86/crypto/sha1_ssse3_glue.c
> +++ b/arch/x86/crypto/sha1_ssse3_glue.c
> @@ -27,11 +27,8 @@
>  #include <crypto/sha1_base.h>
>  #include <asm/simd.h>
>  
> -typedef void (sha1_transform_fn)(u32 *digest, const char *data,
> -				unsigned int rounds);
> -
>  static int sha1_update(struct shash_desc *desc, const u8 *data,
> -			     unsigned int len, sha1_transform_fn *sha1_xform)
> +			     unsigned int len, sha1_block_fn *sha1_xform)
>  {
>  	struct sha1_state *sctx = shash_desc_ctx(desc);
>  
> @@ -39,48 +36,44 @@ static int sha1_update(struct shash_desc *desc, const u8 *data,
>  	    (sctx->count % SHA1_BLOCK_SIZE) + len < SHA1_BLOCK_SIZE)
>  		return crypto_sha1_update(desc, data, len);
>  
> -	/* make sure casting to sha1_block_fn() is safe */
> +	/* make sure sha1_block_fn() use in generic routines is safe */
>  	BUILD_BUG_ON(offsetof(struct sha1_state, state) != 0);

This update to the comment makes no sense, since sha1_block_fn() is obviously
safe in the helpers, and this says nothing about the assembly functions.
Instead this should say something like:

	/*
	 * Make sure that struct sha1_state begins directly with the 160-bit
	 * SHA1 internal state, as this is what the assembly functions expect.
	 */

Likewise for SHA-256 and SHA-512, except for those it would be a 256-bit and
512-bit internal state respectively.

> -asmlinkage void sha1_transform_ssse3(u32 *digest, const char *data,
> -				     unsigned int rounds);
> +asmlinkage void sha1_transform_ssse3(struct sha1_state *digest,
> +				     u8 const *data, int rounds);

'u8 const' is unconventional.  Please use 'const u8' instead.

Also, this function prototype is also given in a comment in the corresponding
assembly file.  Can you please update that too, and also leave a comment in the
assembly file like "struct sha1_state is assumed to begin with u32 state[5]."?

Likewise for all the other SHA-1, and SHA-256, and SHA-512 assembly functions,
except it would be u32 state[8] for SHA-256 and u64 state[8] for SHA-512.

- Eric
