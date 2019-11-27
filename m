Return-Path: <SRS0=Z357=ZT=lists.openwall.com=kernel-hardening-return-17442-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99E7AC432C0
	for <kernel-hardening@archiver.kernel.org>; Wed, 27 Nov 2019 18:01:46 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id EBD5F20872
	for <kernel-hardening@archiver.kernel.org>; Wed, 27 Nov 2019 18:01:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="HPN7uf5P"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EBD5F20872
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17442-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32282 invoked by uid 550); 27 Nov 2019 18:01:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32245 invoked from network); 27 Nov 2019 18:01:39 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574877687;
	bh=DqpIVPpSNRYaQEY8qH901L06azIBYeg8eGVRD3v38ok=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HPN7uf5PWAbcDCgYiwF4fFKQrfACX9EBB8jN7v59ShMpiCDzuvyga3x4d/5ms0cFP
	 cvl8GIhLVQbEbnOlAoFDQZXuyPKOKoi7hI2Gd2IFXpvIRK9plXluFd5jLNelQp5PUr
	 rDpAsmZRnaRsh+DdSezcD+mg44xMbQYDDQ/5fk5w=
Date: Wed, 27 Nov 2019 10:01:25 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	=?iso-8859-1?Q?Jo=E3o?= Moreira <joao.moreira@intel.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Stephan Mueller <smueller@chronox.de>, x86@kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v7] crypto: x86: Regularize glue function prototypes
Message-ID: <20191127180125.GA49214@sol.localdomain>
References: <201911262205.FD985935F@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201911262205.FD985935F@keescook>
User-Agent: Mutt/1.12.2 (2019-09-21)

On Tue, Nov 26, 2019 at 10:08:02PM -0800, Kees Cook wrote:
> The crypto glue performed function prototype casting via macros to make
> indirect calls to assembly routines. Instead of performing casts at the
> call sites (which trips Control Flow Integrity prototype checking), switch
> each prototype to a common standard set of arguments which allows the
> removal of the existing macros. In order to keep pointer math unchanged,
> internal casting between u128 pointers and u8 pointers is added.
> 
> Co-developed-by: João Moreira <joao.moreira@intel.com>
> Signed-off-by: João Moreira <joao.moreira@intel.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

- Eric
