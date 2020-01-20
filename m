Return-Path: <SRS0=1APS=3J=lists.openwall.com=kernel-hardening-return-17600-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8095CC2D0DB
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Jan 2020 11:14:33 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DDF3420674
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Jan 2020 11:14:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DDF3420674
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17600-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7202 invoked by uid 550); 20 Jan 2020 11:14:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 6141 invoked from network); 20 Jan 2020 11:14:25 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=WTrlGhs59LAijTepaX8teYcfP4R2wr8PKeRF3cIoZ0k=;
        b=BemYwMOXf1eR+0b/uxsmheQ3sqCLDINs1Baml4vvsfr8AiQ/+zBWd2P68x688stENR
         0zyKcw6n5ZouvZmgT13mVmlNBO4CXFPfg/S5auHfbDOGLj3M/i/4ZuO7eqnCqSC9frKw
         iqnryZXapYoWUIyO8HCjoAqTtImLFcT9HvRnEnHKedsclRA3g5G+enuLbsrYJbNlSdDK
         FvdSKGXVk1SRgb5c8LTWosvRPlJDiPe0qpvcT1bNsbqOWuB8wbwPGFqOmhSJmZ3CnN8U
         EmIK1+9tw4D+owahsg4oyLIaoeYbFn0HAfQPfX7b1s28CBGE3+XbTV85ciMINnWQMDyK
         ju2w==
X-Gm-Message-State: APjAAAUDQs9CAFi0SKkMi9wXtnU3l8LYRcIv152clUhGK5YdcPCqTciX
	eKNpQzNn89Cq3M7mD4Ze7lU=
X-Google-Smtp-Source: APXvYqxsxF2pkFMlDoibbwLhvA/mXy9eZXBCy9GDircNX9HUt/S5dO7+aPEtBqLj6E+TwiyjeuMmhQ==
X-Received: by 2002:a05:600c:210e:: with SMTP id u14mr17916690wml.28.1579518854095;
        Mon, 20 Jan 2020 03:14:14 -0800 (PST)
Date: Mon, 20 Jan 2020 12:14:11 +0100
From: Michal Hocko <mhocko@kernel.org>
To: Daniel Axtens <dja@axtens.net>
Cc: kernel-hardening@lists.openwall.com, linux-mm@kvack.org,
	keescook@chromium.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
Subject: Re: [PATCH 4/5] [VERY RFC] mm: kmalloc(_node): return NULL
 immediately for SIZE_MAX
Message-ID: <20200120111411.GX18451@dhcp22.suse.cz>
References: <20200120074344.504-1-dja@axtens.net>
 <20200120074344.504-5-dja@axtens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200120074344.504-5-dja@axtens.net>
User-Agent: Mutt/1.12.2 (2019-09-21)

On Mon 20-01-20 18:43:43, Daniel Axtens wrote:
> kmalloc is sometimes compiled with an size that at compile time may be
> equal to SIZE_MAX.
> 
> For example, struct_size(struct, array member, array elements) returns the
> size of a structure that has an array as the last element, containing a
> given number of elements, or SIZE_MAX on overflow.
> 
> However, struct_size operates in (arguably) unintuitive ways at compile time.
> Consider the following snippet:
> 
> struct foo {
> 	int a;
> 	int b[0];
> };
> 
> struct foo *alloc_foo(int elems)
> {
> 	struct foo *result;
> 	size_t size = struct_size(result, b, elems);
> 	if (__builtin_constant_p(size)) {
> 		BUILD_BUG_ON(size == SIZE_MAX);
> 	}
> 	result = kmalloc(size, GFP_KERNEL);
> 	return result;
> }
> 
> I expected that size would only be constant if alloc_foo() was called
> within that translation unit with a constant number of elements, and the
> compiler had decided to inline it. I'd therefore expect that 'size' is only
> SIZE_MAX if the constant provided was a huge number.
> 
> However, instead, this function hits the BUILD_BUG_ON, even if never
> called.
> 
> include/linux/compiler.h:394:38: error: call to ‘__compiletime_assert_32’ declared with attribute error: BUILD_BUG_ON failed: size == SIZE_MAX

This sounds more like a bug to me. Have you tried to talk to compiler
guys?

> This is with gcc 9.2.1, and I've also observed it with an gcc 8 series
> compiler.
> 
> My best explanation of this is:
> 
>  - elems is a signed int, so a small negative number will become a very
>    large unsigned number when cast to a size_t, leading to overflow.
> 
>  - Then, the only way in which size can be a constant is if we hit the
>    overflow case, in which 'size' will be 'SIZE_MAX'.
> 
>  - So the compiler takes that value into the body of the if statement and
>    blows up.
> 
> But I could be totally wrong.
> 
> Anyway, this is relevant to slab.h because kmalloc() and kmalloc_node()
> check if the supplied size is a constant and take a faster path if so. A
> number of callers of those functions use struct_size to determine the size
> of a memory allocation. Therefore, at compile time, those functions will go
> down the constant path, specialising for the overflow case.
> 
> When my next patch is applied, gcc will then throw a warning any time
> kmalloc_large could be called with a SIZE_MAX size, as gcc deems SIZE_MAX
> to be too big an allocation.
> 
> So, make functions that check __builtin_constant_p check also against
> SIZE_MAX in the constant path, and immediately return NULL if we hit it.

I am not sure I am happy about an additional conditional path in the hot
path of the allocator. Especially when we already have a check for
KMALLOC_MAX_CACHE_SIZE.
-- 
Michal Hocko
SUSE Labs
