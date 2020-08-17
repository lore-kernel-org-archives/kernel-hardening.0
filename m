Return-Path: <SRS0=jgBU=B3=lists.openwall.com=kernel-hardening-return-19646-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D151DC433E1
	for <kernel-hardening@archiver.kernel.org>; Mon, 17 Aug 2020 17:54:30 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F2D342067C
	for <kernel-hardening@archiver.kernel.org>; Mon, 17 Aug 2020 17:54:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F2D342067C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19646-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9762 invoked by uid 550); 17 Aug 2020 17:54:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9739 invoked from network); 17 Aug 2020 17:54:21 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=zioXayb3aZ1+dwOWJvBfiHPq2HNW4QALEO2XKd3ld70=;
        b=BJ6j/zzXg/b/f/10YBUK6l7PLJHXAEBiwju/mw83XMQfd4XhgdY7snnoGpgykA4WFf
         6lZfQeAPAikzRUaCUvPILW1Hj9U0HmKKY929jWSqLrPftNLY7NGWCtTvkeg23sclAcld
         nMOzU7kP+b4OMaMBmLx+icyIP3vLE/y2YO751naHv37AiYKyu8qJ8X4P8pX/AbDpHmnO
         80gPelfDJ1HNDgkrmUkDLTVlrW+FafR55IuHgv/nF5RAwyJDeXQ4BJsn3QG9SY+jMIUd
         9R5YNQ7ukSLpe+eYJ2SSPX2wjCwYq/tr/jyKl6MiDyNgtJw+V7O1l/HqjrerdNI/bhfA
         YBuw==
X-Gm-Message-State: AOAM533q0Ox+OiZAvd+IMbwUpKCm1yhrv5i4nIvWGMPRnvb/6yEJJF1R
	Tb7TUb5CNYw+pPpEZoqafeg=
X-Google-Smtp-Source: ABdhPJzIjxWGJG7IRu20Xzg1ErsdYqzcEcGXzU5jfc0mRb4u7iMQ26jmEbVilrUIRoLoKxDCh9xp1A==
X-Received: by 2002:a17:906:528d:: with SMTP id c13mr16654442ejm.61.1597686850290;
        Mon, 17 Aug 2020 10:54:10 -0700 (PDT)
Subject: Re: [PATCH RFC 2/2] lkdtm: Add heap spraying test
To: Kees Cook <keescook@chromium.org>
Cc: Jann Horn <jannh@google.com>, Will Deacon <will@kernel.org>,
 Andrey Ryabinin <aryabinin@virtuozzo.com>,
 Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>,
 Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
 David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Masahiro Yamada <masahiroy@kernel.org>,
 Masami Hiramatsu <mhiramat@kernel.org>, Steven Rostedt
 <rostedt@goodmis.org>, Peter Zijlstra <peterz@infradead.org>,
 Krzysztof Kozlowski <krzk@kernel.org>,
 Patrick Bellasi <patrick.bellasi@arm.com>,
 David Howells <dhowells@redhat.com>, Eric Biederman <ebiederm@xmission.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Laura Abbott <labbott@redhat.com>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, kernel-hardening@lists.openwall.com,
 linux-kernel@vger.kernel.org, notify@kernel.org,
 Andrey Konovalov <andreyknvl@google.com>
References: <20200813151922.1093791-1-alex.popov@linux.com>
 <20200813151922.1093791-3-alex.popov@linux.com>
 <202008150952.E81C4A52F@keescook>
From: Alexander Popov <alex.popov@linux.com>
Autocrypt: addr=alex.popov@linux.com; prefer-encrypt=mutual; keydata=
 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
 j3lCqPk=
Message-ID: <37ec713d-10c8-0222-f624-27815b96da7a@linux.com>
Date: Mon, 17 Aug 2020 20:54:04 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <202008150952.E81C4A52F@keescook>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 15.08.2020 19:59, Kees Cook wrote:
> On Thu, Aug 13, 2020 at 06:19:22PM +0300, Alexander Popov wrote:
>> Add a simple test for CONFIG_SLAB_QUARANTINE.
>>
>> It performs heap spraying that aims to reallocate the recently freed heap
>> object. This technique is used for exploiting use-after-free
>> vulnerabilities in the kernel code.
>>
>> This test shows that CONFIG_SLAB_QUARANTINE breaks heap spraying
>> exploitation technique.
> 
> Yay tests!

Yes :)
I'm going to improve it to demonstrate the quarantine security properties.

>> Signed-off-by: Alexander Popov <alex.popov@linux.com>
>> ---
>>  drivers/misc/lkdtm/core.c  |  1 +
>>  drivers/misc/lkdtm/heap.c  | 40 ++++++++++++++++++++++++++++++++++++++
>>  drivers/misc/lkdtm/lkdtm.h |  1 +
>>  3 files changed, 42 insertions(+)
>>
>> diff --git a/drivers/misc/lkdtm/core.c b/drivers/misc/lkdtm/core.c
>> index a5e344df9166..78b7669c35eb 100644
>> --- a/drivers/misc/lkdtm/core.c
>> +++ b/drivers/misc/lkdtm/core.c
>> @@ -126,6 +126,7 @@ static const struct crashtype crashtypes[] = {
>>  	CRASHTYPE(SLAB_FREE_DOUBLE),
>>  	CRASHTYPE(SLAB_FREE_CROSS),
>>  	CRASHTYPE(SLAB_FREE_PAGE),
>> +	CRASHTYPE(HEAP_SPRAY),
>>  	CRASHTYPE(SOFTLOCKUP),
>>  	CRASHTYPE(HARDLOCKUP),
>>  	CRASHTYPE(SPINLOCKUP),
>> diff --git a/drivers/misc/lkdtm/heap.c b/drivers/misc/lkdtm/heap.c
>> index 1323bc16f113..a72a241e314a 100644
>> --- a/drivers/misc/lkdtm/heap.c
>> +++ b/drivers/misc/lkdtm/heap.c
>> @@ -205,6 +205,46 @@ static void ctor_a(void *region)
>>  static void ctor_b(void *region)
>>  { }
>>  
>> +#define HEAP_SPRAY_SIZE 128
>> +
>> +void lkdtm_HEAP_SPRAY(void)
>> +{
>> +	int *addr;
>> +	int *spray_addrs[HEAP_SPRAY_SIZE] = { 0 };
> 
> (the 0 isn't needed -- and it was left there, it should be NULL)

It is used in tear-down below.
I'll change it to { NULL }.

>> +	unsigned long i = 0;
>> +
>> +	addr = kmem_cache_alloc(a_cache, GFP_KERNEL);
> 
> I would prefer this test add its own cache (e.g. spray_cache), to avoid
> misbehaviors between tests. (e.g. the a and b caches already run the
> risk of getting corrupted weirdly.)

Ok, I'll do that.

>> +	if (!addr) {
>> +		pr_info("Unable to allocate memory in lkdtm-heap-a cache\n");
>> +		return;
>> +	}
>> +
>> +	*addr = 0x31337;
>> +	kmem_cache_free(a_cache, addr);
>> +
>> +	pr_info("Performing heap spraying...\n");
>> +	for (i = 0; i < HEAP_SPRAY_SIZE; i++) {
>> +		spray_addrs[i] = kmem_cache_alloc(a_cache, GFP_KERNEL);
>> +		*spray_addrs[i] = 0x31337;
>> +		pr_info("attempt %lu: spray alloc addr %p vs freed addr %p\n",
>> +						i, spray_addrs[i], addr);
> 
> That's 128 lines spewed into dmesg... I would leave this out.

Ok.

>> +		if (spray_addrs[i] == addr) {
>> +			pr_info("freed addr is reallocated!\n");
>> +			break;
>> +		}
>> +	}
>> +
>> +	if (i < HEAP_SPRAY_SIZE)
>> +		pr_info("FAIL! Heap spraying succeed :(\n");
> 
> I'd move this into the "if (spray_addrs[i] == addr)" test instead of the
> pr_info() that is there.
> 
>> +	else
>> +		pr_info("OK! Heap spraying hasn't succeed :)\n");
> 
> And then make this an "if (i == HEAP_SPRAY_SIZE)" test

Do you mean that I need to avoid the additional line in the test output,
printing only the final result?

>> +
>> +	for (i = 0; i < HEAP_SPRAY_SIZE; i++) {
>> +		if (spray_addrs[i])
>> +			kmem_cache_free(a_cache, spray_addrs[i]);
>> +	}
>> +}
>> +
>>  void __init lkdtm_heap_init(void)
>>  {
>>  	double_free_cache = kmem_cache_create("lkdtm-heap-double_free",
>> diff --git a/drivers/misc/lkdtm/lkdtm.h b/drivers/misc/lkdtm/lkdtm.h
>> index 8878538b2c13..dfafb4ae6f3a 100644
>> --- a/drivers/misc/lkdtm/lkdtm.h
>> +++ b/drivers/misc/lkdtm/lkdtm.h
>> @@ -45,6 +45,7 @@ void lkdtm_READ_BUDDY_AFTER_FREE(void);
>>  void lkdtm_SLAB_FREE_DOUBLE(void);
>>  void lkdtm_SLAB_FREE_CROSS(void);
>>  void lkdtm_SLAB_FREE_PAGE(void);
>> +void lkdtm_HEAP_SPRAY(void);
>>  
>>  /* lkdtm_perms.c */
>>  void __init lkdtm_perms_init(void);
>> -- 
>> 2.26.2
>>
> 
> I assume enabling the quarantine defense also ends up being seen in the
> SLAB_FREE_DOUBLE LKDTM test too, yes?

I'll experiment with that.

Thank you!

Best regards,
Alexander
