Return-Path: <SRS0=8lEM=2B=lists.openwall.com=kernel-hardening-return-17492-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97DFEC2D0C6
	for <kernel-hardening@archiver.kernel.org>; Wed, 11 Dec 2019 09:39:33 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F2996214D8
	for <kernel-hardening@archiver.kernel.org>; Wed, 11 Dec 2019 09:39:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F2996214D8
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gondor.apana.org.au
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17492-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13907 invoked by uid 550); 11 Dec 2019 09:39:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13855 invoked from network); 11 Dec 2019 09:39:24 -0000
Date: Wed, 11 Dec 2019 17:38:44 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kees Cook <keescook@chromium.org>
Cc: =?iso-8859-1?Q?Jo=E3o?= Moreira <joao.moreira@intel.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Stephan Mueller <smueller@chronox.de>, x86@kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v7] crypto: x86: Regularize glue function prototypes
Message-ID: <20191211093844.vwguh6yjgab5hza5@gondor.apana.org.au>
References: <201911262205.FD985935F@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201911262205.FD985935F@keescook>
User-Agent: NeoMutt/20170113 (1.7.2)

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
> ---
> v7:
> - added João's SoB (ebiggers)
> - corrected aesni .S prototype comments (ebiggers)
> - collapsed glue series into a single patch (ebiggers)
> v6: https://lore.kernel.org/lkml/20191122010334.12081-1-keescook@chromium.org
> v5: https://lore.kernel.org/lkml/20191113182516.13545-1-keescook@chromium.org
> v4: https://lore.kernel.org/lkml/20191111214552.36717-1-keescook@chromium.org
> v3: https://lore.kernel.org/lkml/20190507161321.34611-1-keescook@chromium.org
> ---
>  arch/x86/crypto/aesni-intel_asm.S          |  8 +--
>  arch/x86/crypto/aesni-intel_glue.c         | 45 ++++++-------
>  arch/x86/crypto/camellia_aesni_avx2_glue.c | 74 ++++++++++-----------
>  arch/x86/crypto/camellia_aesni_avx_glue.c  | 72 +++++++++------------
>  arch/x86/crypto/camellia_glue.c            | 45 +++++++------
>  arch/x86/crypto/cast6_avx_glue.c           | 68 +++++++++-----------
>  arch/x86/crypto/glue_helper.c              | 23 ++++---
>  arch/x86/crypto/serpent_avx2_glue.c        | 65 +++++++++----------
>  arch/x86/crypto/serpent_avx_glue.c         | 63 +++++++++---------
>  arch/x86/crypto/serpent_sse2_glue.c        | 30 +++++----
>  arch/x86/crypto/twofish_avx_glue.c         | 75 ++++++++++------------
>  arch/x86/crypto/twofish_glue_3way.c        | 37 ++++++-----
>  arch/x86/include/asm/crypto/camellia.h     | 63 +++++++++---------
>  arch/x86/include/asm/crypto/glue_helper.h  | 18 ++----
>  arch/x86/include/asm/crypto/serpent-avx.h  | 20 +++---
>  arch/x86/include/asm/crypto/serpent-sse2.h | 28 ++++----
>  arch/x86/include/asm/crypto/twofish.h      | 19 +++---
>  crypto/cast6_generic.c                     | 18 +++---
>  crypto/serpent_generic.c                   |  6 +-
>  include/crypto/cast6.h                     |  4 +-
>  include/crypto/serpent.h                   |  4 +-
>  include/crypto/xts.h                       |  2 -
>  22 files changed, 374 insertions(+), 413 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
