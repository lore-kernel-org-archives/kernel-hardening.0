Return-Path: <SRS0=6wlq=2I=lists.openwall.com=kernel-hardening-return-17507-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35CBBC43603
	for <kernel-hardening@archiver.kernel.org>; Wed, 18 Dec 2019 12:46:36 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 868F12146E
	for <kernel-hardening@archiver.kernel.org>; Wed, 18 Dec 2019 12:46:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="CObDVqos"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 868F12146E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=alien8.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17507-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1624 invoked by uid 550); 18 Dec 2019 12:46:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1603 invoked from network); 18 Dec 2019 12:46:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1576673170;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=yXwLnW+PoY25pshD8Wq5cZaWHHz1WD1asE9i3LHbFgo=;
	b=CObDVqosp5y7Z8sELy68i2YofwvsnqQOrexIoHXuwx4iBrrN1Ec2LK/g2G2LFmAiahNTHg
	KIiIEFVVTQ/7/vwqbtJd3690sOFs622Qt+IGBBhv3TTl1kj/mGgkbqwxQazwVNQmuphqqd
	SBLhof85IDWs90nsRlzcY4JsHr0Bl6I=
Date: Wed, 18 Dec 2019 13:46:04 +0100
From: Borislav Petkov <bp@alien8.de>
To: Thomas Garnier <thgarnie@chromium.org>
Cc: kernel-hardening@lists.openwall.com, kristen@linux.intel.com,
	keescook@chromium.org, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 01/11] x86/crypto: Adapt assembly for PIE support
Message-ID: <20191218124604.GE24886@zn.tnic>
References: <20191205000957.112719-1-thgarnie@chromium.org>
 <20191205000957.112719-2-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191205000957.112719-2-thgarnie@chromium.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Dec 04, 2019 at 04:09:38PM -0800, Thomas Garnier wrote:
> Change the assembly code to use only relative references of symbols for the
> kernel to be PIE compatible.
> 
> Position Independent Executable (PIE) support will allow to extend the
> KASLR randomization range below 0xffffffff80000000.

FFS, how many times do we have to talk about this auto-sprinkled
sentence?!

https://lkml.kernel.org/r/20190805163202.GD18785@zn.tnic

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
