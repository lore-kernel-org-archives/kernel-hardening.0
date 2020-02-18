Return-Path: <SRS0=bsXh=4G=lists.openwall.com=kernel-hardening-return-17825-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B08FC34031
	for <kernel-hardening@archiver.kernel.org>; Tue, 18 Feb 2020 20:55:21 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4C6E0206F4
	for <kernel-hardening@archiver.kernel.org>; Tue, 18 Feb 2020 20:55:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4C6E0206F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17825-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 29814 invoked by uid 550); 18 Feb 2020 20:55:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29777 invoked from network); 18 Feb 2020 20:55:12 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Agn6nQMcqhupiGPj+A5XxBu1pX2cGpximgh4Q8Dc0iM=;
        b=LdiTRu44r9r7a4bwlcQtWqfXgg1ON1t0WJSLkSICpr5RlWQiZzS79myw+cZzmW46op
         u2vVcQYvJ9OlwiXigi1QAWgmiTf5jkhn1vkr2Dy3j0sSek3LCMNkmj1QmdBEBgFog9BO
         96fpCbZl8+Mg5PxAROZWf+TUSc6kuQAHj3Cx2LwzEefqlZioZUDJ91f2y1ficzBCs3kg
         NOmimPvZoC2cbayyVkSYRJiYEIYEdVwvjcHLmSpe+3o881U13mD2yYVoq3j29PWAmc41
         ENiSO1ivDxzhpS11tkGPM677YLEEgTj6i5T8DpgqhJdCLUCfFnDJgUAyy59FMNgaCsMk
         By6A==
X-Gm-Message-State: APjAAAVGQ+/32pnU94YiCBBpf5UXhMgmtT0m55s4Kl9LSv0TLmtuuULY
	W+nBCTvesCoFWlxLeUWcBjw=
X-Google-Smtp-Source: APXvYqyILXQb2c2JMbxt4Gjj0RvriP68vptzY4kKMIaRYkRQ7wv5S5YAY3Y2n1U2kXE2AKMuvCicqA==
X-Received: by 2002:a1c:bdc6:: with SMTP id n189mr5210371wmf.102.1582059300997;
        Tue, 18 Feb 2020 12:55:00 -0800 (PST)
Subject: Re: Maybe inappropriate use BUG_ON() in CONFIG_SLAB_FREELIST_HARDENED
To: Andrey Konovalov <andreyknvl@google.com>, zerons <zeronsaxm@gmail.com>
Cc: kernel-hardening@lists.openwall.com, Shawn <citypw@gmail.com>,
 spender@grsecurity.net, Jann Horn <jannh@google.com>
References: <e535d698-5268-e5fc-a238-0649c509cc4f@gmail.com>
 <CAAeHK+y-FdpH20Z7HsB0U+mgD9CK0gECCqShXFtFWpFp01jAmA@mail.gmail.com>
From: Alexander Popov <alex.popov@linux.com>
Autocrypt: addr=alex.popov@linux.com; prefer-encrypt=mutual; keydata=
 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
 j3lCqPk=
Message-ID: <84b3a89a-cd20-1e49-8d98-53b74dd3f9d1@linux.com>
Date: Tue, 18 Feb 2020 23:54:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAAeHK+y-FdpH20Z7HsB0U+mgD9CK0gECCqShXFtFWpFp01jAmA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

Hello!

Thanks for adding me to this discussion.
Let me also add Jann Horn.

On 17.02.2020 18:15, Andrey Konovalov wrote:
> On Thu, Feb 13, 2020 at 4:43 PM zerons <zeronsaxm@gmail.com> wrote:
>> In slub.c(https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/mm/slub.c?h=v5.4.19#n305),
>> for SLAB_FREELIST_HARDENED, an extra detection of the double free bug has been added.
>>
>> This patch can (maybe only) detect something like this: kfree(a) kfree(a).
>> However, it does nothing when another process calls kfree(b) between the two kfree above.

Yes, that's correct.

>> The problem is, if the panic_on_oops option is not set(Ubuntu 16.04/18.04 default option),
>> for a bug which kfree an object twice in a row, if another process can preempt the process
>> triggered this bug and then call kmalloc() to get the object, the patch doesn't work.

In theory, that is true.

However, let me show a counterexample from practice.

I developed this check after I exploited CVE-2017-2636 (race condition causing
double free). Please see the detailed write-up about the exploit:
https://a13xp0p0v.github.io/2017/03/24/CVE-2017-2636.html

There was a linked list with data buffers, and one of these buffers was added to
the list twice. Double free happened when the driver cleaned up its resources
and freed the buffers in this list. So double kfree() happened quite close to
each other.

I spent a lot of time trying to insert some kmalloc() between these kfree(), but
didn't succeed. That is difficult because slab caches are per-CPU, and heap
spray on other CPUs doesn't overwrite the needed kernel address.

The vulnerable kernel task didn't call scheduler between double kfree(). I
didn't manage to preempt it. But I solved that trouble by spraying _after_
double kfree().

>> Without this extra detection, the kernel could be unstable while the attacker
>> trying to do the race.

Could you bring more details? Which kind of instability do you mean?

When I did heap spray with sk_buffs after double kfree(), I got two sk_buff
items with sk_buff.head pointing to the same memory. Receiving one sk_buff
created use-after-free on another one. That is how double free turns into
use-after-free.

The check which we discuss now breaks that method.

Best regards,
Alexander
