Return-Path: <SRS0=UGHm=FH=lists.openwall.com=kernel-hardening-return-20526-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 657DCC433FE
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Dec 2020 19:50:53 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 43FFC221F5
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Dec 2020 19:50:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 43FFC221F5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20526-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27653 invoked by uid 550); 3 Dec 2020 19:50:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26606 invoked from network); 3 Dec 2020 19:50:43 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=X2sJjf4rgVoTYeRjWgx/Ub3m34veUfOcx8dQYIctFxw=;
        b=fXlMoItWLNLtU7BQ+Snx99ldZ2r8fA6NADhVKJnylLB2XL+JzwumBPildmmlMwaWPy
         xQu/e6WRVShMLMeuKUXHIaXEcIsFViAEPKhksO5HkahEHsQ0fkZ5CR3DyMFc0SyTLVWH
         fQRnlZqtTTKfXK8Vi1LWFewfY1CMcw4kslDe2bvpdhstt+6ycMX4BuUWyGeWM7A+B8Av
         g+lC+6XXDddgiNcy0AZAMNUY2qZezdAU9zPdKFgIJC+IKwPg39J39jfdKnRFv6QOr4so
         jRpJVTyYl18tJUcioPqoxE8G/lRD7WHPSLsxKpMar7SR9xyDnD01brTArl9vzet0z49Z
         h4ww==
X-Gm-Message-State: AOAM531kLbG7Xtei8PUcmeQsZYswmUAVlAx1IPZqS9GouDShqVdkLtNs
	tVkc4iFr317CkgoYipC8k8M=
X-Google-Smtp-Source: ABdhPJyfsPBdYDGguP/sCzXs4LIQiAGtpaD/uX1/KBO6z1qFGuTTkmUz2C+FOvXUurAvBiWZ6cU0mA==
X-Received: by 2002:adf:a495:: with SMTP id g21mr873975wrb.213.1607025032556;
        Thu, 03 Dec 2020 11:50:32 -0800 (PST)
Subject: Re: [PATCH RFC v2 2/6] mm/slab: Perform init_on_free earlier
To: Alexander Potapenko <glider@google.com>
Cc: Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>,
 Will Deacon <will@kernel.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>,
 Dmitry Vyukov <dvyukov@google.com>, Christoph Lameter <cl@linux.com>,
 Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>,
 Joonsoo Kim <iamjoonsoo.kim@lge.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Masahiro Yamada <masahiroy@kernel.org>,
 Masami Hiramatsu <mhiramat@kernel.org>, Steven Rostedt
 <rostedt@goodmis.org>, Peter Zijlstra <peterz@infradead.org>,
 Krzysztof Kozlowski <krzk@kernel.org>,
 Patrick Bellasi <patrick.bellasi@arm.com>,
 David Howells <dhowells@redhat.com>, Eric Biederman <ebiederm@xmission.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Laura Abbott <labbott@redhat.com>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Daniel Micay <danielmicay@gmail.com>,
 Andrey Konovalov <andreyknvl@google.com>,
 Matthew Wilcox <willy@infradead.org>, Pavel Machek <pavel@denx.de>,
 Valentin Schneider <valentin.schneider@arm.com>,
 kasan-dev <kasan-dev@googlegroups.com>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 LKML <linux-kernel@vger.kernel.org>, notify@kernel.org
References: <20200929183513.380760-1-alex.popov@linux.com>
 <20200929183513.380760-3-alex.popov@linux.com>
 <CAG_fn=WY9OFKuy6utMHOgyr+1DYNsuzVruGCGHMDnEnaLY6s9g@mail.gmail.com>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <1772bc7d-e87f-0f62-52a8-e9d9ac99f5e3@linux.com>
Date: Thu, 3 Dec 2020 22:50:27 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <CAG_fn=WY9OFKuy6utMHOgyr+1DYNsuzVruGCGHMDnEnaLY6s9g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 30.09.2020 15:50, Alexander Potapenko wrote:
> On Tue, Sep 29, 2020 at 8:35 PM Alexander Popov <alex.popov@linux.com> wrote:
>>
>> Currently in CONFIG_SLAB init_on_free happens too late, and heap
>> objects go to the heap quarantine being dirty. Lets move memory
>> clearing before calling kasan_slab_free() to fix that.
>>
>> Signed-off-by: Alexander Popov <alex.popov@linux.com>
> Reviewed-by: Alexander Potapenko <glider@google.com>

Hello!

Can this particular patch be considered for the mainline kernel?


Note: I summarized the results of the experiment with the Linux kernel heap
quarantine in a short article, for future reference:
https://a13xp0p0v.github.io/2020/11/30/slab-quarantine.html

Best regards,
Alexander

>> ---
>>  mm/slab.c | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/slab.c b/mm/slab.c
>> index 3160dff6fd76..5140203c5b76 100644
>> --- a/mm/slab.c
>> +++ b/mm/slab.c
>> @@ -3414,6 +3414,9 @@ static void cache_flusharray(struct kmem_cache *cachep, struct array_cache *ac)
>>  static __always_inline void __cache_free(struct kmem_cache *cachep, void *objp,
>>                                          unsigned long caller)
>>  {
>> +       if (unlikely(slab_want_init_on_free(cachep)))
>> +               memset(objp, 0, cachep->object_size);
>> +
>>         /* Put the object into the quarantine, don't touch it for now. */
>>         if (kasan_slab_free(cachep, objp, _RET_IP_))
>>                 return;
>> @@ -3432,8 +3435,6 @@ void ___cache_free(struct kmem_cache *cachep, void *objp,
>>         struct array_cache *ac = cpu_cache_get(cachep);
>>
>>         check_irq_off();
>> -       if (unlikely(slab_want_init_on_free(cachep)))
>> -               memset(objp, 0, cachep->object_size);
>>         kmemleak_free_recursive(objp, cachep->flags);
>>         objp = cache_free_debugcheck(cachep, objp, caller);
>>         memcg_slab_free_hook(cachep, virt_to_head_page(objp), objp);
>> --
>> 2.26.2
>>
> 
> 

