Return-Path: <SRS0=iaJB=ZE=lists.openwall.com=kernel-hardening-return-17344-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D50CC43331
	for <kernel-hardening@archiver.kernel.org>; Tue, 12 Nov 2019 22:57:06 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C5DE321A49
	for <kernel-hardening@archiver.kernel.org>; Tue, 12 Nov 2019 22:57:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="IsPQL/hU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C5DE321A49
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17344-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1746 invoked by uid 550); 12 Nov 2019 22:56:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1704 invoked from network); 12 Nov 2019 22:56:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zpJ/TMpVSKZy+JXxk/4c68rZdEAtB+OaqfRaFt77y6Y=;
        b=IsPQL/hU3IhF+qfkUCRWUrXYZheaE/5EOnSVDyJp/WnzWjkB3a7igBYUvpzviMn6L3
         EWwKMMcbTBSkE9j6+lM7cjybdedxFAxjw34SjY8xUmExgVx9vkxyfsA7HCeOc5ODgssQ
         WFs7WhwKK8SIMbSuP6MoGhI6aOCwmBoWjhHQo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zpJ/TMpVSKZy+JXxk/4c68rZdEAtB+OaqfRaFt77y6Y=;
        b=oQv7mYnrzSYBxqn0UJ3hqxXqblbrhILHNSQ42ljiJjVFe2nb2ma10FBnSSWK5rU98A
         7pM0t0OmFQ8n4AJOoCYV+kgvVu+S34yh2T46u1JG4crUwzqRzy22tlqCQ7SEQ3UHLZeA
         s97ev20HsxIxJO5nIaJwkZD5TxEhdbfV6HZnaNi1c8djAwcEuKuhWytt447lTFNkxhBJ
         VzwIuNsZTogj+9vOOolJerTqOWV1KvHPxC8IMi46F7VRHvmcdYNvzXEMGwSTOoAtu4Jl
         gTMd1Rgj8gXvWZt4+/5/UDYogVTektBBP7esTDD2sCezYod1dP29pus2fCf09V0WLVYl
         ZuSw==
X-Gm-Message-State: APjAAAVXSuY4eTSRADi/qxX3d25P1MsEPCFrKoeuMFh5jaJemXBgg0kn
	EJ8O12yHw8trJbXykFTAXGQitcMUcSs=
X-Google-Smtp-Source: APXvYqwVpIPBQ69m+AEur+RE+tA3ua9JIQo1zSDy5Qc9XKebf2oGEun7RjUMRnM+saiWqFyl65X22A==
X-Received: by 2002:a17:90a:d102:: with SMTP id l2mr363545pju.132.1573599406393;
        Tue, 12 Nov 2019 14:56:46 -0800 (PST)
Date: Tue, 12 Nov 2019 14:56:44 -0800
From: Kees Cook <keescook@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>,
	=?iso-8859-1?Q?Jo=E3o?= Moreira <joao.moreira@lsc.ic.unicamp.br>,
	Sami Tolvanen <samitolvanen@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, x86@kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v4 3/8] crypto: x86/camellia: Use new glue function macros
Message-ID: <201911121452.AE2672AECB@keescook>
References: <20191111214552.36717-1-keescook@chromium.org>
 <20191111214552.36717-4-keescook@chromium.org>
 <3059417.7DhL3USBNQ@positron.chronox.de>
 <20191112031417.GB1433@sol.localdomain>
 <20191112031635.jm32vne33qxh7ojh@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112031635.jm32vne33qxh7ojh@gondor.apana.org.au>

On Tue, Nov 12, 2019 at 11:16:35AM +0800, Herbert Xu wrote:
> On Mon, Nov 11, 2019 at 07:14:17PM -0800, Eric Biggers wrote:
> >
> > Also, I don't see the point of the macros, other than to obfuscate things.  To
> > keep things straightforward, I think we should keep the explicit function
> > prototypes for each algorithm.
> 
> I agree.  Kees, please get rid of the macros.

Okay, if we do that, then we'll likely be dropping a lot of union logic
(since ecb and cbc end up with identical params and ctr and xts do too):

typedef void (*common_glue_func_t)(void *ctx, u8 *dst, const u8 *src);
typedef void (*common_glue_cbc_func_t)(void *ctx, u128 *dst, const u128 *src);
typedef void (*common_glue_ctr_func_t)(void *ctx, u128 *dst, const u128 *src,
                                       le128 *iv);
typedef void (*common_glue_xts_func_t)(void *ctx, u128 *dst, const u128 *src,
                                       le128 *iv);
...
struct common_glue_func_entry {
        unsigned int num_blocks; /* number of blocks that @fn will process */
        union { 
                common_glue_func_t ecb;
                common_glue_cbc_func_t cbc;
                common_glue_ctr_func_t ctr;
                common_glue_xts_func_t xts;
        } fn_u;
};

These would end up being just:

typedef void (*common_glue_func_t)(void *ctx, u8 *dst, const u8 *src);
typedef void (*common_glue_iv_func_t)(void *ctx, u8 *dst, const u8 *src,
                                       le128 *iv);
...
struct common_glue_func_entry {
        unsigned int num_blocks; /* number of blocks that @fn will process */
        union { 
                common_glue_func_t func;
                common_glue_iv_func_t iv_func;
        } fn_u;

Is that reasonable?

-- 
Kees Cook
