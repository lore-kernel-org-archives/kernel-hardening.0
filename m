Return-Path: <SRS0=zGQs=FI=lists.openwall.com=kernel-hardening-return-20530-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11072C4361B
	for <kernel-hardening@archiver.kernel.org>; Fri,  4 Dec 2020 11:54:54 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DF4482251F
	for <kernel-hardening@archiver.kernel.org>; Fri,  4 Dec 2020 11:54:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DF4482251F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20530-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7821 invoked by uid 550); 4 Dec 2020 11:54:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7792 invoked from network); 4 Dec 2020 11:54:44 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=wHqmBeW2IFxVt4oHJizfcV3fQQX4Hgdaz39Wp4K7c0A=;
        b=AUMJiZNZ7IQtC1gTuyAedC965swkHGJmVQaBMQbxRkpdVlwlom8VTvTeJU7Z43xVjP
         Uq1HpO4EG51DhLD6G2UH+XSWMYo0Pt0k4q8UsWZr3pdXxk5kwmHxvDrSEwj0B7ZSVLq2
         h+LFv2D/aOyNJ+GtqMgMpbNJxZBO4TF0oFXxPZSX+bZjTyPSSaE4Oy0Q8r0Y3O+Kpmvn
         w7hOmIMQD1VJZ/9UAuWYyuidnoSRG7gU/O7xorCHdWeqNCjXDaN0AjTSwKPjwR6h2xUM
         sQZM+vFXFHGZAMJ/spJdJPeUMQE4skDckp5qmkcoxrDFKlbCVHP37+6OQBFRp5NTvpTa
         sCaw==
X-Gm-Message-State: AOAM531y8iAQGYhPmGWR0e54536Mit83pWYViH4mDhHZiul9ARRN/r7h
	1dioWWMnuvrLX+KG+Myfz/o=
X-Google-Smtp-Source: ABdhPJz3k3/M4l7ovBWHXv3cerqd8tc5RbeKIr8k7pXjJ8RslEzOgI+FhEYt0rRwwhaYS4XH6t8M9g==
X-Received: by 2002:a7b:c087:: with SMTP id r7mr3791014wmh.153.1607082872591;
        Fri, 04 Dec 2020 03:54:32 -0800 (PST)
Subject: Re: [PATCH RFC v2 2/6] mm/slab: Perform init_on_free earlier
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>, Kees Cook
 <keescook@chromium.org>, Jann Horn <jannh@google.com>,
 Will Deacon <will@kernel.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>,
 Dmitry Vyukov <dvyukov@google.com>, Christoph Lameter <cl@linux.com>,
 Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>,
 Joonsoo Kim <iamjoonsoo.kim@lge.com>, Masahiro Yamada
 <masahiroy@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, Peter Zijlstra <peterz@infradead.org>,
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
 <1772bc7d-e87f-0f62-52a8-e9d9ac99f5e3@linux.com>
 <20201203124914.25e63b013e9c69c79d481831@linux-foundation.org>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <9b9861c0-4c94-a51f-bbac-bd5e9b77d9e0@linux.com>
Date: Fri, 4 Dec 2020 14:54:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201203124914.25e63b013e9c69c79d481831@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 03.12.2020 23:49, Andrew Morton wrote:
> On Thu, 3 Dec 2020 22:50:27 +0300 Alexander Popov <alex.popov@linux.com> wrote:
> 
>> On 30.09.2020 15:50, Alexander Potapenko wrote:
>>> On Tue, Sep 29, 2020 at 8:35 PM Alexander Popov <alex.popov@linux.com> wrote:
>>>>
>>>> Currently in CONFIG_SLAB init_on_free happens too late, and heap
>>>> objects go to the heap quarantine being dirty. Lets move memory
>>>> clearing before calling kasan_slab_free() to fix that.
>>>>
>>>> Signed-off-by: Alexander Popov <alex.popov@linux.com>
>>> Reviewed-by: Alexander Potapenko <glider@google.com>
>>
>> Hello!
>>
>> Can this particular patch be considered for the mainline kernel?
> 
> All patches are considered ;) And merged if they're reviewed, tested,
> judged useful, etc.
> 
> If you think this particular patch should be fast-tracked then please
> send it as a non-RFC, standalone patch.  Please also enhance the
> changelog so that it actually explains what goes wrong.  Presumably
> "objects go to the heap quarantine being dirty" causes some
> user-visible problem?  What is that problem?

Ok, thanks!
I'll improve the commit message and send the patch separately.

Best regards,
Alexander
