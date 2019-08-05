Return-Path: <SRS0=XIyB=WB=lists.openwall.com=kernel-hardening-return-16710-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7588C433FF
	for <kernel-hardening@archiver.kernel.org>; Mon,  5 Aug 2019 16:32:27 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 301EF2086D
	for <kernel-hardening@archiver.kernel.org>; Mon,  5 Aug 2019 16:32:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="YwSydi+q"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 301EF2086D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=alien8.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16710-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13807 invoked by uid 550); 5 Aug 2019 16:32:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13789 invoked from network); 5 Aug 2019 16:32:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1565022728;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=g+cTmbSEFfoz2KUZz+uvRnfYrlj//AwDFvYHV2OvsKQ=;
	b=YwSydi+q2UAgpz8CC6RgebD3zV7GEPqVPv5pRN0M6jox/WccOZt9CR/6wdUcBGgHFie+wH
	jGJIrKZSCnOA/4dXXVZ8d+KRrEUpIJO9cO/h4qAWyis7lZ28NvwoVi/AS9506pyVZldV3P
	1Z2Jbc3INpkKJPe/0i3ikL9HuH4XOog=
Date: Mon, 5 Aug 2019 18:32:02 +0200
From: Borislav Petkov <bp@alien8.de>
To: Thomas Garnier <thgarnie@chromium.org>
Cc: kernel-hardening@lists.openwall.com, kristen@linux.intel.com,
	keescook@chromium.org, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 01/11] x86/crypto: Adapt assembly for PIE support
Message-ID: <20190805163202.GD18785@zn.tnic>
References: <20190730191303.206365-1-thgarnie@chromium.org>
 <20190730191303.206365-2-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190730191303.206365-2-thgarnie@chromium.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Jul 30, 2019 at 12:12:45PM -0700, Thomas Garnier wrote:
> Change the assembly code to use only relative references of symbols for the
> kernel to be PIE compatible.
> 
> Position Independent Executable (PIE) support will allow to extend the
> KASLR randomization range below 0xffffffff80000000.

I believe in previous reviews I asked about why this sentence is being
replicated in every commit message and now it is still in every commit
message except in 2/11.

Why do you need it everywhere and not once in the 0th mail?

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
