Return-Path: <SRS0=VjTB=WB=lists.openwall.com=kernel-hardening-return-16712-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD914C0650F
	for <kernel-hardening@archiver.kernel.org>; Mon,  5 Aug 2019 17:27:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0DDC7208C3
	for <kernel-hardening@archiver.kernel.org>; Mon,  5 Aug 2019 17:27:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="imI8ehCE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0DDC7208C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=alien8.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16712-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24154 invoked by uid 550); 5 Aug 2019 17:27:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24136 invoked from network); 5 Aug 2019 17:27:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1565026059;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=2QVPLbhsy20zMJ+NXXK+HZcnVcTlAcrhhTtVL45jsVM=;
	b=imI8ehCE6z+AgYM1F9afvhQXnJ7ocjyBg6yZTzMm3cIUdO/lzWMYYMn3TpFJlvEKDfj9ES
	u8mOD2pdT0W2rMy7qFyQW2WfENFqc5ZXfEfrAPY+cbCvdQNgChWCMYJnxeETCvSMl3w/Cm
	WDXGjLA5oz5Fs+Lin4NUH0ztZWIVI3w=
Date: Mon, 5 Aug 2019 19:27:33 +0200
From: Borislav Petkov <bp@alien8.de>
To: Kees Cook <keescook@chromium.org>
Cc: Thomas Garnier <thgarnie@chromium.org>,
	kernel-hardening@lists.openwall.com, kristen@linux.intel.com,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 01/11] x86/crypto: Adapt assembly for PIE support
Message-ID: <20190805172733.GE18785@zn.tnic>
References: <20190730191303.206365-1-thgarnie@chromium.org>
 <20190730191303.206365-2-thgarnie@chromium.org>
 <20190805163202.GD18785@zn.tnic>
 <201908050952.BC1F7C3@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201908050952.BC1F7C3@keescook>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Aug 05, 2019 at 09:54:44AM -0700, Kees Cook wrote:
> I think there was some long-ago feedback from someone (Ingo?) about
> giving context for the patch so looking at one individually would let
> someone know that it was part of a larger series.

Strange. But then we'd have to "mark" all patches which belong to a
larger series this way, no? And we don't do that...

> Do you think it should just be dropped in each patch?

I think reading it once is enough. If the change alone in some commit
message is not clear why it is being done - to support PIE - then sure,
by all means. But slapping it everywhere...

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
