Return-Path: <SRS0=ks15=2A=lists.openwall.com=kernel-hardening-return-17491-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E2C4C43603
	for <kernel-hardening@archiver.kernel.org>; Tue, 10 Dec 2019 22:55:29 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9DA132053B
	for <kernel-hardening@archiver.kernel.org>; Tue, 10 Dec 2019 22:55:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="d2py0cvz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9DA132053B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17491-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17490 invoked by uid 550); 10 Dec 2019 22:55:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17445 invoked from network); 10 Dec 2019 22:55:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K560JhN8jjr2klsKF9w2lMytMSQAi8SNYSkAmDUvHLo=;
        b=d2py0cvzfnsbNyUDrtVzKgSJWvhm8kxMowvABHkfsSsgwQbUG2CiBIVO2T2uANuZod
         k9bUCXc7tw8c2LiiEZksQoAOG+iMBfg6g2SZQqvGrz/lp/vKz4RfYIW56G8Z0mZJ6GJS
         Soq728u1FMuTAiVsiiR0NTc7qKBQEmyn1soma03BgVzJ2a23QfqBDM/Qx3d6fNxviEAH
         jQ1pYzJ2rcZFdrC9pkt8vd/MC9SC0Yi772lhAbxMEKwth4+VWCVRnCo52QIOLvieSob0
         apevRHXoI13Zd+CPVtcSyDFuBDA9b53plI99DzXNmXPf/7jytHGy67YLHQUj0Q8emAFQ
         qTZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K560JhN8jjr2klsKF9w2lMytMSQAi8SNYSkAmDUvHLo=;
        b=HlpH/RY+5MBFLqa6g9ML71SnfgTyQAebRTuqMXayCoXDCZXXL5xtNhylqqwOGpm5+l
         HF/Vs6wQmTQ0iF51539aZMrue9xn8EDSOWTPYl5y9FdDx+W5Gh4RDl2rfjXtY5+HXPrm
         R98MIx641/jGUt3uX7O6+6oVuBxQqSqFEUqbAuT1JoRnuNFjUBr3UM7rGSlQLsLHQiwV
         fHWAXh2+brU04m0G6QUU1KmSIevrNScCc4p5q05lUfKmikUjIisKoz4X29RcyOxYPYB3
         Vm6IxTJI0OEeRyzFsTvkM8HdVu6iTC9iZGzmHbaZVmNXmGz9tD3H0pBC6Fb2o/lL5p6P
         Cv2Q==
X-Gm-Message-State: APjAAAXJb5k6sjSz8d7bRw1f4GDcR+lDXFHjeJr5CEfQMyEG0pG9B8Mj
	eRqhD1kYrKrFIGRDzLondFx4lKnLRwk=
X-Google-Smtp-Source: APXvYqyxzzVD3MrlcD7MqBqyebaS33cuqvNUhV/9QBTalYssrGV5bjjfLSxN/qrslOYwh7rGVWjTfQ==
X-Received: by 2002:a17:902:ac88:: with SMTP id h8mr37617802plr.131.1576018508279;
        Tue, 10 Dec 2019 14:55:08 -0800 (PST)
Subject: Re: [PATCH 07/11] io_uring: use atomic_t for refcounts
To: Kees Cook <keescook@chromium.org>
Cc: Jann Horn <jannh@google.com>, io-uring <io-uring@vger.kernel.org>,
 Will Deacon <will@kernel.org>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>
References: <20191210155742.5844-1-axboe@kernel.dk>
 <20191210155742.5844-8-axboe@kernel.dk>
 <CAG48ez3yh7zRhMyM+VhH1g9Gp81_3FMjwAyj3TB6HQYETpxHmA@mail.gmail.com>
 <02ba41a9-14f2-e3be-f43f-99f311c662ef@kernel.dk>
 <201912101445.CF208B717@keescook>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <d6ff9af3-5e72-329c-4aed-cbe6d9373235@kernel.dk>
Date: Tue, 10 Dec 2019 15:55:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <201912101445.CF208B717@keescook>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 12/10/19 3:46 PM, Kees Cook wrote:
> On Tue, Dec 10, 2019 at 03:21:04PM -0700, Jens Axboe wrote:
>> On 12/10/19 3:04 PM, Jann Horn wrote:
>>> [context preserved for additional CCs]
>>>
>>> On Tue, Dec 10, 2019 at 4:57 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>> Recently had a regression that turned out to be because
>>>> CONFIG_REFCOUNT_FULL was set.
>>>
>>> I assume "regression" here refers to a performance regression? Do you
>>> have more concrete numbers on this? Is one of the refcounting calls
>>> particularly problematic compared to the others?
>>
>> Yes, a performance regression. io_uring is using io-wq now, which does
>> an extra get/put on the work item to make it safe against async cancel.
>> That get/put translates into a refcount_inc and refcount_dec per work
>> item, and meant that we went from 0.5% refcount CPU in the test case to
>> 1.5%. That's a pretty substantial increase.
>>
>>> I really don't like it when raw atomic_t is used for refcounting
>>> purposes - not only because that gets rid of the overflow checks, but
>>> also because it is less clear semantically.
>>
>> Not a huge fan either, but... It's hard to give up 1% of extra CPU. You
>> could argue I could just turn off REFCOUNT_FULL, and I could. Maybe
>> that's what I should do. But I'd prefer to just drop the refcount on the
>> io_uring side and keep it on for other potential useful cases.
> 
> There is no CONFIG_REFCOUNT_FULL any more. Will Deacon's version came
> out as nearly identical to the x86 asm version. Can you share the
> workload where you saw this? We really don't want to regression refcount
> protections, especially in the face of new APIs.
> 
> Will, do you have a moment to dig into this?

Ah, hopefully it'll work out ok, then. The patch came from testing the
full backport on 5.2.

Do you have a link to the "nearly identical"? I can backport that
patch and try on 5.2.


-- 
Jens Axboe

