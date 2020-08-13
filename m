Return-Path: <SRS0=2d3G=BX=lists.openwall.com=kernel-hardening-return-19616-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EA91C433E1
	for <kernel-hardening@archiver.kernel.org>; Thu, 13 Aug 2020 11:33:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DABD120771
	for <kernel-hardening@archiver.kernel.org>; Thu, 13 Aug 2020 11:33:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=rasmusvillemoes.dk header.i=@rasmusvillemoes.dk header.b="ejivrTcN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DABD120771
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=rasmusvillemoes.dk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19616-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7493 invoked by uid 550); 13 Aug 2020 11:33:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7471 invoked from network); 13 Aug 2020 11:33:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CKBHpRq2gdYecMDnHVd5fZCbJkMkjf8ao+KHmXIXSMg=;
        b=ejivrTcNuBz6f3oxo1Y3zzsM8DitmA3VJUE1qaeuEwlJPxUAvWFXytt/iywwB7qCGy
         5MD82jHYBj5HiDAf7kqp4ks7+5ToBEqHq8nGc08BLB5vvo5QQS/eV3bJ4iGfykjfdDRM
         rZvrV7fxjdhXqS6mmXipjtnrPgGvLYh5D2JQ4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CKBHpRq2gdYecMDnHVd5fZCbJkMkjf8ao+KHmXIXSMg=;
        b=lwAofCFfD5insNC4NqS34Y64I2UGGWeLcwIXrNLgJanQu6ZW5+reiRuS0FUiDHE7Y0
         +0pWOHik5pt2NbHnv2qvbSIXzD33EPvGs3XmyoXtwDGrkkfYqZscfKxfEb1SOTnoDlGn
         woVKmyDPkbBbxBCnU0FA4Rw53klcY89P1LOCkjRBXbo4N/auzq3tbu6j1khyKLTuF0cU
         bv2F3cdDK0XEsFWQhdtKPHYPEXicoZk7m8FOsY25k0RV6AomWFBmXIy7c3o9wjVI5GvY
         ynpw9A3wGpkIctClJav2NDeCoXMkBqaiU1LrA3TO78dpTr6xoYdD92Od/26+gheHy5ET
         UoGw==
X-Gm-Message-State: AOAM531SFJomOdrqYeE8xZUHVuzF81FSy64nSuqPq8dHF4u8O5QFBUAQ
	eQ9Dwl1zXvkxssjxiWr1gis3yRPNgfrTXA==
X-Google-Smtp-Source: ABdhPJyoUHvy/tjrCSKGg//t2kcgYLKwm9obdrTFz24GkBvRPgwiMB83dvHU/dDl+wqiLNW3FXvczg==
X-Received: by 2002:a05:651c:314:: with SMTP id a20mr1762778ljp.434.1597318387708;
        Thu, 13 Aug 2020 04:33:07 -0700 (PDT)
Subject: Re: [PATCH] overflow: Add __must_check attribute to check_*() helpers
To: Matthew Wilcox <willy@infradead.org>, Kees Cook <keescook@chromium.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>, Jason Gunthorpe
 <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
References: <202008121450.405E4A3@keescook>
 <20200813112327.GF17456@casper.infradead.org>
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <3e498585-f22f-25b8-9385-feadd55fdc7b@rasmusvillemoes.dk>
Date: Thu, 13 Aug 2020 13:33:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200813112327.GF17456@casper.infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 13/08/2020 13.23, Matthew Wilcox wrote:
> On Wed, Aug 12, 2020 at 02:51:52PM -0700, Kees Cook wrote:
>> +/*
>> + * Allows to effectively us apply __must_check to a macro so we can have
>> + * both the type-agnostic benefits of the macros while also being able to
>> + * enforce that the return value is, in fact, checked.
>> + */
>> +static inline bool __must_check __must_check_bool(bool condition)
>> +{
>> +	return unlikely(condition);
>> +}
> 
> I'm fine with the concept, but this is a weirdly-generically-named
> function that has a very specific unlikely() in it.  So I'd call
> this __must_check_overflow() and then it's obvious that overflow is
> unlikely(), whereas it's not obvious that __must_check_bool() is going
> to be unlikely().

Incidentally, __must_check_overflow was what was actually Suggested-by
me - though I didn't think too hard about that name, I certainly agree
with your reasoning.

I still don't know if (un)likely annotations actually matter when used
this way, but at least the same pattern is used in kernel/sched/, so
probably.

Rasmus
