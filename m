Return-Path: <SRS0=hbf2=2B=lists.openwall.com=kernel-hardening-return-17497-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93003C43603
	for <kernel-hardening@archiver.kernel.org>; Wed, 11 Dec 2019 17:00:48 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DD6EB214AF
	for <kernel-hardening@archiver.kernel.org>; Wed, 11 Dec 2019 17:00:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="gTkHIIYI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DD6EB214AF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17497-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7342 invoked by uid 550); 11 Dec 2019 17:00:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7299 invoked from network); 11 Dec 2019 17:00:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aiOSRjp/3HRFxheJM9EeY6VMMDKekJfhGlBwlo3tspE=;
        b=gTkHIIYImCIIs+Sd4NnGSmtGhaKLxnlMBjccL6/IgXDrB/wB8uNsrg/i0JLEagoSsu
         cIoGQ0ZsbqQ5t3O+l9ZEb0/bXZJQS34p6qvYUWvL2dlxRiCs416JTB+llaKJBlgBeXiA
         Cwep7MyFsmJrTu0hJC3akH4s7NBjF0VBn5eaAl0jAbNgB1JNITonTVM4FLHd6FBMrix0
         xZ6ayP0NPjoxzsbN1EGpemPOc8KcAMBplju+2oMFyELw4lqOxOeEOENgksXwR9I2IZNT
         L8WWilRzBmUJuXzZ+zT6x7w3Q4QPvpxei83DLlsL1vbBeVW7fyCwm+p1OM79PBQ1NBii
         MdAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aiOSRjp/3HRFxheJM9EeY6VMMDKekJfhGlBwlo3tspE=;
        b=i8HM7T3HmGJ2hkXs9OQmyDTyDUjLdfMGdImkJa2b0isyUeo/szvtXv3F+SDxaBmOo0
         YY+xIq68ho2aiaD9FafTYZ0N/u9kMPHHqvJaCbWloOnf2195fVb5HduMnlWqBpsoMRX9
         rzUWxqfKqu1infO0hyJaqLNUQWqY7FaQaos74reGzhv0/TJGOpZdW1U59xfJTT8aOYny
         ufcdpeyoDPGobgd/S4EKRJYS/4wCuUYMw6KjH0YwRKYMGYNORB0+35D0AidQiST5cwfo
         MHyhz2y44z8YxhZwTsraWTfuRmFBBip/XgQ0nm0cLWLD6tRQYV7H0qQzjI+3mlazWnMe
         IBEQ==
X-Gm-Message-State: APjAAAXQEzHGD1Fn8x9DegjH96lYWeRXy3LsVfHn/YcZapMlDFxJUs20
	4ruZBm7Cxyf/ULNEJvzujDjyD9RzMis=
X-Google-Smtp-Source: APXvYqx2pjygH4+O3cdwmFd5louaeyGg/v/caErz92Souf53k6sOCvu3wtWU3GP7dpW0kGXbcmRmIA==
X-Received: by 2002:a63:d351:: with SMTP id u17mr5144691pgi.84.1576083627779;
        Wed, 11 Dec 2019 09:00:27 -0800 (PST)
Subject: Re: [PATCH 07/11] io_uring: use atomic_t for refcounts
To: Kees Cook <keescook@chromium.org>, Will Deacon <will@kernel.org>
Cc: Jann Horn <jannh@google.com>, io-uring <io-uring@vger.kernel.org>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>
References: <20191210155742.5844-1-axboe@kernel.dk>
 <20191210155742.5844-8-axboe@kernel.dk>
 <CAG48ez3yh7zRhMyM+VhH1g9Gp81_3FMjwAyj3TB6HQYETpxHmA@mail.gmail.com>
 <02ba41a9-14f2-e3be-f43f-99f311c662ef@kernel.dk>
 <201912101445.CF208B717@keescook>
 <d6ff9af3-5e72-329c-4aed-cbe6d9373235@kernel.dk>
 <20191211102012.GA4123@willie-the-truck> <201912110851.88536F3F@keescook>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <82a67aff-08a7-48f4-2cd1-17ea465c9123@kernel.dk>
Date: Wed, 11 Dec 2019 10:00:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <201912110851.88536F3F@keescook>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 12/11/19 9:56 AM, Kees Cook wrote:
> On Wed, Dec 11, 2019 at 10:20:13AM +0000, Will Deacon wrote:
>> On Tue, Dec 10, 2019 at 03:55:05PM -0700, Jens Axboe wrote:
>>> On 12/10/19 3:46 PM, Kees Cook wrote:
>>>> On Tue, Dec 10, 2019 at 03:21:04PM -0700, Jens Axboe wrote:
>>>>> On 12/10/19 3:04 PM, Jann Horn wrote:
>>>>>> [context preserved for additional CCs]
>>>>>>
>>>>>> On Tue, Dec 10, 2019 at 4:57 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>> Recently had a regression that turned out to be because
>>>>>>> CONFIG_REFCOUNT_FULL was set.
>>>>>>
>>>>>> I assume "regression" here refers to a performance regression? Do you
>>>>>> have more concrete numbers on this? Is one of the refcounting calls
>>>>>> particularly problematic compared to the others?
>>>>>
>>>>> Yes, a performance regression. io_uring is using io-wq now, which does
>>>>> an extra get/put on the work item to make it safe against async cancel.
>>>>> That get/put translates into a refcount_inc and refcount_dec per work
>>>>> item, and meant that we went from 0.5% refcount CPU in the test case to
>>>>> 1.5%. That's a pretty substantial increase.
>>>>>
>>>>>> I really don't like it when raw atomic_t is used for refcounting
>>>>>> purposes - not only because that gets rid of the overflow checks, but
>>>>>> also because it is less clear semantically.
>>>>>
>>>>> Not a huge fan either, but... It's hard to give up 1% of extra CPU. You
>>>>> could argue I could just turn off REFCOUNT_FULL, and I could. Maybe
>>>>> that's what I should do. But I'd prefer to just drop the refcount on the
>>>>> io_uring side and keep it on for other potential useful cases.
>>>>
>>>> There is no CONFIG_REFCOUNT_FULL any more. Will Deacon's version came
>>>> out as nearly identical to the x86 asm version. Can you share the
>>>> workload where you saw this? We really don't want to regression refcount
>>>> protections, especially in the face of new APIs.
>>>>
>>>> Will, do you have a moment to dig into this?
>>>
>>> Ah, hopefully it'll work out ok, then. The patch came from testing the
>>> full backport on 5.2.
> 
> Oh good! I thought we had some kind of impossible workload. :)
> 
>>> Do you have a link to the "nearly identical"? I can backport that
>>> patch and try on 5.2.
>>
>> You could try my refcount/full branch, which is what ended up getting merged
>> during the merge window:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/will/linux.git/log/?h=refcount/full
> 
> Yeah, as you can see in the measured tight-loop timings in
> https://git.kernel.org/linus/dcb786493f3e48da3272b710028d42ec608cfda1
> there was 0.1% difference for Will's series compared to the x86 assembly
> version, where as the old FULL was almost 70%.

That looks very promising! Hopefully the patch is moot at that point, I
dropped it from the series yesterday in any case. I'll revisit as soon
as I can and holler if there's an issue.

-- 
Jens Axboe

