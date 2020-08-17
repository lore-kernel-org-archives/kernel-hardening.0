Return-Path: <SRS0=jU3Y=B3=lists.openwall.com=kernel-hardening-return-19645-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49F7FC433E1
	for <kernel-hardening@archiver.kernel.org>; Mon, 17 Aug 2020 17:32:42 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 454C920716
	for <kernel-hardening@archiver.kernel.org>; Mon, 17 Aug 2020 17:32:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 454C920716
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19645-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1251 invoked by uid 550); 17 Aug 2020 17:32:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1231 invoked from network); 17 Aug 2020 17:32:32 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=KF+Lijn2GoIDaHXMKcv5dyj265MiB5w1dhwFUWa9B/E=;
        b=Y9FyHFUi491XT/FzhMvOWU5YV+y6D4ufVaQDoke1BKrx1y1E947weP2KaF2xPjwwYp
         /rYgiErMt6BHUrj7gcMDICJtyQVmiTOVK+DANYosGQIDa4RLY8QjLcErw8yaoB+DtsmF
         GstNBoNHzA+HEwpX3xE9wCONlASRE4qS0RxkZk/T80cXXyYPaJ/b6+9r9aXC0elWi7C5
         kjUeB/2eDzSNU2gfdYcmjTFNLlKcEgUQ5la4j/3ORGuKh2D1VLuT1X+69M4C66bglSRg
         WgqEuYQKLm7j+CMKG8NtOlAKX/ztyljDckt3Bdb3d/JQPS8juE7UAe9QvybsoHtFTyf8
         DY/g==
X-Gm-Message-State: AOAM531IDfalpXQsU1Yx5t3Ml4Dp6K2w8xciA4MZNKYpqZJIj48culOB
	JqMxqwqYlOVtzDPfz7D1oJk=
X-Google-Smtp-Source: ABdhPJxx4kyfB4OB5VvM7hPY7AUBVoAfwI72XJxabVD1RD2sncUAFLIE99/Or/L07gLNi5YR7gc2gA==
X-Received: by 2002:adf:bc45:: with SMTP id a5mr16073823wrh.215.1597685541159;
        Mon, 17 Aug 2020 10:32:21 -0700 (PDT)
Subject: Re: [PATCH RFC 1/2] mm: Extract SLAB_QUARANTINE from KASAN
To: Kees Cook <keescook@chromium.org>,
 Andrey Konovalov <andreyknvl@google.com>
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
 linux-kernel@vger.kernel.org, notify@kernel.org
References: <20200813151922.1093791-1-alex.popov@linux.com>
 <20200813151922.1093791-2-alex.popov@linux.com>
 <202008150939.A994680@keescook>
From: Alexander Popov <alex.popov@linux.com>
Autocrypt: addr=alex.popov@linux.com; prefer-encrypt=mutual; keydata=
 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
 j3lCqPk=
Message-ID: <82edcbac-a856-cf9e-b86d-69a4315ea8e4@linux.com>
Date: Mon, 17 Aug 2020 20:32:13 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <202008150939.A994680@keescook>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 15.08.2020 19:52, Kees Cook wrote:
> On Thu, Aug 13, 2020 at 06:19:21PM +0300, Alexander Popov wrote:
>> Heap spraying is an exploitation technique that aims to put controlled
>> bytes at a predetermined memory location on the heap. Heap spraying for
>> exploiting use-after-free in the Linux kernel relies on the fact that on
>> kmalloc(), the slab allocator returns the address of the memory that was
>> recently freed. Allocating a kernel object with the same size and
>> controlled contents allows overwriting the vulnerable freed object.
>>
>> Let's extract slab freelist quarantine from KASAN functionality and
>> call it CONFIG_SLAB_QUARANTINE. This feature breaks widespread heap
>> spraying technique used for exploiting use-after-free vulnerabilities
>> in the kernel code.
>>
>> If this feature is enabled, freed allocations are stored in the quarantine
>> and can't be instantly reallocated and overwritten by the exploit
>> performing heap spraying.
> 
> It may be worth clarifying that this is specifically only direct UAF and
> doesn't help with spray-and-overflow-into-a-neighboring-object attacks
> (i.e. both tend to use sprays, but the former doesn't depend on a write
> overflow).

Right, thank you.

>> Signed-off-by: Alexander Popov <alex.popov@linux.com>
>> ---
>>  include/linux/kasan.h      | 107 ++++++++++++++++++++-----------------
>>  include/linux/slab_def.h   |   2 +-
>>  include/linux/slub_def.h   |   2 +-
>>  init/Kconfig               |  11 ++++
>>  mm/Makefile                |   3 +-
>>  mm/kasan/Makefile          |   2 +
>>  mm/kasan/kasan.h           |  75 +++++++++++++-------------
>>  mm/kasan/quarantine.c      |   2 +
>>  mm/kasan/slab_quarantine.c |  99 ++++++++++++++++++++++++++++++++++
>>  mm/slub.c                  |   2 +-
>>  10 files changed, 216 insertions(+), 89 deletions(-)
>>  create mode 100644 mm/kasan/slab_quarantine.c
>>
>> diff --git a/include/linux/kasan.h b/include/linux/kasan.h
>> index 087fba34b209..b837216f760c 100644
>> --- a/include/linux/kasan.h
>> +++ b/include/linux/kasan.h

[...]

>>  #else /* CONFIG_KASAN_GENERIC */
>> +static inline void kasan_record_aux_stack(void *ptr) {}
>> +#endif /* CONFIG_KASAN_GENERIC */
>>  
>> +#if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_SLAB_QUARANTINE)
>> +void kasan_cache_shrink(struct kmem_cache *cache);
>> +void kasan_cache_shutdown(struct kmem_cache *cache);
>> +#else /* CONFIG_KASAN_GENERIC || CONFIG_SLAB_QUARANTINE */
>>  static inline void kasan_cache_shrink(struct kmem_cache *cache) {}
>>  static inline void kasan_cache_shutdown(struct kmem_cache *cache) {}
>> -static inline void kasan_record_aux_stack(void *ptr) {}
>> -
>> -#endif /* CONFIG_KASAN_GENERIC */
>> +#endif /* CONFIG_KASAN_GENERIC || CONFIG_SLAB_QUARANTINE */
> 
> In doing this extraction, I wonder if function naming should be changed?
> If it's going to live a new life outside of KASAN proper, maybe call
> these functions quarantine_cache_*()? But perhaps that's too much
> churn...

These functions are kasan handlers that are called by allocator.
I.e. allocator calls kasan handlers, and then kasan handlers call
quarantine_put(), quarantine_reduce() and quarantine_remove_cache() among other
things.

Andrey Konovalov wrote:
> If quarantine is to be used without the rest of KASAN, I'd prefer for
> it to be separated from KASAN completely: move to e.g. mm/quarantine.c
> and don't mention KASAN in function/config names.

Hmm, making quarantine completely separate from KASAN would bring troubles.

Currently, in many special places the allocator calls KASAN handlers:
  kasan_cache_create()
  kasan_slab_free()
  kasan_kmalloc_large()
  kasan_krealloc()
  kasan_slab_alloc()
  kasan_kmalloc()
  kasan_cache_shrink()
  kasan_cache_shutdown()
  and some others.
These functions do a lot of interesting things and also work with the quarantine
using these helpers:
  quarantine_put()
  quarantine_reduce()
  quarantine_remove_cache()

Making quarantine completely separate from KASAN would require to move some
internal logic of these KASAN handlers to allocator code.

In this patch I used another approach, that doesn't require changing the API
between allocators and KASAN. I added linux/mm/kasan/slab_quarantine.c with slim
KASAN handlers that implement the minimal functionality needed for quarantine.

Do you think that it's a bad solution?

>>  #ifdef CONFIG_KASAN_SW_TAGS
>>  
>> diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
>> index 9eb430c163c2..fc7548f27512 100644
>> --- a/include/linux/slab_def.h
>> +++ b/include/linux/slab_def.h
>> @@ -72,7 +72,7 @@ struct kmem_cache {
>>  	int obj_offset;
>>  #endif /* CONFIG_DEBUG_SLAB */
>>  
>> -#ifdef CONFIG_KASAN
>> +#if defined(CONFIG_KASAN) || defined(CONFIG_SLAB_QUARANTINE)
>>  	struct kasan_cache kasan_info;
>>  #endif
>>  
>> diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
>> index 1be0ed5befa1..71020cee9fd2 100644
>> --- a/include/linux/slub_def.h
>> +++ b/include/linux/slub_def.h
>> @@ -124,7 +124,7 @@ struct kmem_cache {
>>  	unsigned int *random_seq;
>>  #endif
>>  
>> -#ifdef CONFIG_KASAN
>> +#if defined(CONFIG_KASAN) || defined(CONFIG_SLAB_QUARANTINE)
>>  	struct kasan_cache kasan_info;
>>  #endif
>>  
>> diff --git a/init/Kconfig b/init/Kconfig
>> index d6a0b31b13dc..de5aa061762f 100644
>> --- a/init/Kconfig
>> +++ b/init/Kconfig
>> @@ -1931,6 +1931,17 @@ config SLAB_FREELIST_HARDENED
>>  	  sanity-checking than others. This option is most effective with
>>  	  CONFIG_SLUB.
>>  
>> +config SLAB_QUARANTINE
>> +	bool "Enable slab freelist quarantine"
>> +	depends on !KASAN && (SLAB || SLUB)
>> +	help
>> +	  Enable slab freelist quarantine to break heap spraying technique
>> +	  used for exploiting use-after-free vulnerabilities in the kernel
>> +	  code. If this feature is enabled, freed allocations are stored
>> +	  in the quarantine and can't be instantly reallocated and
>> +	  overwritten by the exploit performing heap spraying.
>> +	  This feature is a part of KASAN functionality.
>> +
> 
> To make this available to distros, I think this needs to be more than
> just a CONFIG. I'd love to see this CONFIG control the availability, but
> have a boot param control a ro-after-init static branch for these
> functions (like is done for init_on_alloc, hardened usercopy, etc). Then
> the branch can be off by default for regular distro users, and more
> cautious folks could enable it with a boot param without having to roll
> their own kernels.

Good point, thanks, added to TODO list.

>> [...]
>> +struct kasan_track {
>> +	u32 pid;
> 
> pid_t?

Ok, I can change it (here I only moved the current definition of kasan_track).

>> +	depot_stack_handle_t stack;
>> +};
>> [...]
>> +#if defined(CONFIG_KASAN_GENERIC) && \
>> +	(defined(CONFIG_SLAB) || defined(CONFIG_SLUB)) || \
>> +	defined(CONFIG_SLAB_QUARANTINE)
> 
> This seems a bit messy. Perhaps an invisible CONFIG to do this logic and
> then the files can test for that? CONFIG_USE_SLAB_QUARANTINE or
> something?

Ok, thanks, I'll try that.

>> [...]
>> + * Heap spraying is an exploitation technique that aims to put controlled
>> + * bytes at a predetermined memory location on the heap. Heap spraying for
>> + * exploiting use-after-free in the Linux kernel relies on the fact that on
>> + * kmalloc(), the slab allocator returns the address of the memory that was
>> + * recently freed. Allocating a kernel object with the same size and
>> + * controlled contents allows overwriting the vulnerable freed object.
>> + *
>> + * If freed allocations are stored in the quarantine, they can't be
>> + * instantly reallocated and overwritten by the exploit performing
>> + * heap spraying.
> 
> I would clarify this with the details of what is actually happening:

Ok.

> the allocation isn't _moved_ to a quarantine, yes? It's only marked as not
> available for allocation?

The allocation is put into the quarantine queues, where all allocations wait for
actual freeing.

>> + */
>> +
>> +#include <linux/kasan.h>
>> +#include <linux/bug.h>
>> +#include <linux/slab.h>
>> +#include <linux/mm.h>
>> +#include "../slab.h"
>> +#include "kasan.h"
>> +
>> +void kasan_cache_create(struct kmem_cache *cache, unsigned int *size,
>> +			slab_flags_t *flags)
>> +{
>> +	cache->kasan_info.alloc_meta_offset = 0;
>> +
>> +	if (cache->flags & SLAB_TYPESAFE_BY_RCU || cache->ctor ||
>> +	     cache->object_size < sizeof(struct kasan_free_meta)) {
>> +		cache->kasan_info.free_meta_offset = *size;
>> +		*size += sizeof(struct kasan_free_meta);
>> +		BUG_ON(*size > KMALLOC_MAX_SIZE);
> 
> Please don't use BUG_ON()[1].

Ok!

> Interesting!
> 
> -Kees
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#bug-and-bug-on
> 

