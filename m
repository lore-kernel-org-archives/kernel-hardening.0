Return-Path: <SRS0=dMJ4=WB=lists.openwall.com=kernel-hardening-return-16711-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E392EC0650F
	for <kernel-hardening@archiver.kernel.org>; Mon,  5 Aug 2019 16:55:05 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3D38F2147A
	for <kernel-hardening@archiver.kernel.org>; Mon,  5 Aug 2019 16:55:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="m1WiCliO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3D38F2147A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16711-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30446 invoked by uid 550); 5 Aug 2019 16:54:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30428 invoked from network); 5 Aug 2019 16:54:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/bwTUWzlU15HZ3M3k+xzvMhkRem/kSeFzTKEw/QWQzc=;
        b=m1WiCliOfPATXps4NT1o26440TW93JM6y2lFBOkkl4UhZIoKRcjxYe4kOb96Wn9q6h
         fU92SqEpY3M+gulqXCmLPdu25VQ+vkJE7VEF5ROpGC+I6ihwkw8VdifqIJstsIdfw+4y
         F5XWa5mRp29t7u8AwCOBpgh3ewJl+iyP0XbLw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/bwTUWzlU15HZ3M3k+xzvMhkRem/kSeFzTKEw/QWQzc=;
        b=AV1yddhGKvRfofXjqhZObML3+/pH83Wz5PvgmUL6ev1jmQGqQkkqI7INInkX3S5dYI
         W7JIg/Qtne7ITYLEsWtDaQWlLdgy7XDl2rhU4NBi+BwCiMi8ftKehhtcj1Vf9pA4sWK2
         QZ0tkH9IfsGEJXcmtA8Tj0aGv+WHVVBkA0LLVwTVunjrGTN8eX+KywP7NswJ+9I4EyI8
         gVLumvU6QYptmK6gT9MsNj04adqDZNg0TcEQVvTY1bXiqVlb7QTgNb0xpNi+j7Fr3yYi
         HTn9pIq10f7hkaU8tfcjWs67fZED1PpM1v9Td7e0z/UZKpepwGhhBavBSXTpljAEUFjM
         I/og==
X-Gm-Message-State: APjAAAXukgAkq85ZqCVM30w4bl8VWq/hjqowyuBSDlAfXdSyJ/58wXVg
	fKgQR7TXTW7ucSb+IWZym2t3TQ==
X-Google-Smtp-Source: APXvYqw41x1+VlUG+f6ebMnURHbQ6wfQ/1Cp9FeJ/wPnnO1VWKcg8M+qfvWaeC6+kSoRPCXxLawOSw==
X-Received: by 2002:aa7:82da:: with SMTP id f26mr74409261pfn.82.1565024086360;
        Mon, 05 Aug 2019 09:54:46 -0700 (PDT)
Date: Mon, 5 Aug 2019 09:54:44 -0700
From: Kees Cook <keescook@chromium.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Thomas Garnier <thgarnie@chromium.org>,
	kernel-hardening@lists.openwall.com, kristen@linux.intel.com,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 01/11] x86/crypto: Adapt assembly for PIE support
Message-ID: <201908050952.BC1F7C3@keescook>
References: <20190730191303.206365-1-thgarnie@chromium.org>
 <20190730191303.206365-2-thgarnie@chromium.org>
 <20190805163202.GD18785@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805163202.GD18785@zn.tnic>

On Mon, Aug 05, 2019 at 06:32:02PM +0200, Borislav Petkov wrote:
> On Tue, Jul 30, 2019 at 12:12:45PM -0700, Thomas Garnier wrote:
> > Change the assembly code to use only relative references of symbols for the
> > kernel to be PIE compatible.
> > 
> > Position Independent Executable (PIE) support will allow to extend the
> > KASLR randomization range below 0xffffffff80000000.
> 
> I believe in previous reviews I asked about why this sentence is being
> replicated in every commit message and now it is still in every commit
> message except in 2/11.
> 
> Why do you need it everywhere and not once in the 0th mail?

I think there was some long-ago feedback from someone (Ingo?) about
giving context for the patch so looking at one individually would let
someone know that it was part of a larger series. This is a distant
memory, though. Do you think it should just be dropped in each patch?

-- 
Kees Cook
