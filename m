Return-Path: <SRS0=kVII=BY=lists.openwall.com=kernel-hardening-return-19631-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52B9EC433DF
	for <kernel-hardening@archiver.kernel.org>; Fri, 14 Aug 2020 21:01:29 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8086C20768
	for <kernel-hardening@archiver.kernel.org>; Fri, 14 Aug 2020 21:01:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8086C20768
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19631-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24417 invoked by uid 550); 14 Aug 2020 21:01:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24395 invoked from network); 14 Aug 2020 21:01:19 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=pG3PD5q7lYnvp9GuLkcW6/Z3cuMbx52ESrO1Q4ZBpJ0=;
        b=k3drRMtgHagN/hl3wHJoFBIxIxK1yO3DX4VJD/luh0NEV1EOSHzVkOfueQwKIiSnp/
         CubOj/Mhpcwagb4uAwGZ1L12KBMyWpyQ4DV+lt1qEsvYcxyustl9ns7ZF3mj7n1qTpQD
         e/fhRapXORElk7LEfRONS+XDK0YMgBT7m/ROsrXERkF5/3EYT92gGZCFjwEySmPVWylR
         DXD/7qOe1iKk628yn3GsgbRM9Ql4pqAF0QezSlEKQEiZoo1OMs43W2emy6eDlFGEAYyF
         YfentjXoVzoTjKnqoACjQXdfYXO9XyWVrDgUBXfr/KTFJ3O2kE26ma4CCfFDBkrrrRcI
         E+aQ==
X-Gm-Message-State: AOAM530VT92urVtoiLG4M7LP64x+lEix/Piv8QaLyNlFQUjRwP88IS/N
	pRHm+LzjxBeOwMTkfdVigA8=
X-Google-Smtp-Source: ABdhPJyp9qEN+VtsU1SeeafU7f39HH3Vg7MPA5kcbAPpyaVhJwMIwmbO27RDjfET2bpzjG4Hxssd3Q==
X-Received: by 2002:a5d:6646:: with SMTP id f6mr4180198wrw.155.1597438868343;
        Fri, 14 Aug 2020 14:01:08 -0700 (PDT)
Subject: Re: [PATCH RFC 0/2] Break heap spraying needed for exploiting
 use-after-free
To: Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>,
 Will Deacon <will@kernel.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>,
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
 linux-kernel@vger.kernel.org, Andrey Konovalov <andreyknvl@google.com>,
 Alexander Popov <alex.popov@linux.com>
Cc: notify@kernel.org
References: <20200813151922.1093791-1-alex.popov@linux.com>
From: Alexander Popov <alex.popov@linux.com>
Autocrypt: addr=alex.popov@linux.com; prefer-encrypt=mutual; keydata=
 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
 j3lCqPk=
Message-ID: <4bc8bb86-613b-1217-6804-cb21a3356bff@linux.com>
Date: Sat, 15 Aug 2020 00:01:03 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200813151922.1093791-1-alex.popov@linux.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 13.08.2020 18:19, Alexander Popov wrote:
> Hello everyone! Requesting for your comments.
> 
> Use-after-free vulnerabilities in the Linux kernel are very popular for
> exploitation. A few examples:
>  https://googleprojectzero.blogspot.com/2018/09/a-cache-invalidation-bug-in-linux.html
>  https://googleprojectzero.blogspot.com/2019/11/bad-binder-android-in-wild-exploit.html?m=1
>  https://a13xp0p0v.github.io/2020/02/15/CVE-2019-18683.html
> 
> Use-after-free exploits usually employ heap spraying technique.
> Generally it aims to put controlled bytes at a predetermined memory
> location on the heap. Heap spraying for exploiting use-after-free in
> the Linux kernel relies on the fact that on kmalloc(), the slab allocator
> returns the address of the memory that was recently freed. So allocating
> a kernel object with the same size and controlled contents allows
> overwriting the vulnerable freed object.
> 
> I've found an easy way to break heap spraying for use-after-free
> exploitation. I simply extracted slab freelist quarantine from KASAN
> functionality and called it CONFIG_SLAB_QUARANTINE. Please see patch 1.
> 
> If this feature is enabled, freed allocations are stored in the quarantine
> and can't be instantly reallocated and overwritten by the exploit
> performing heap spraying.
> 
> In patch 2 you can see the lkdtm test showing how CONFIG_SLAB_QUARANTINE
> prevents immediate reallocation of a freed heap object.
> 
> I tested this patch series both for CONFIG_SLUB and CONFIG_SLAB.
> 
> CONFIG_SLAB_QUARANTINE disabled:
>   # echo HEAP_SPRAY > /sys/kernel/debug/provoke-crash/DIRECT
>   lkdtm: Performing direct entry HEAP_SPRAY
>   lkdtm: Performing heap spraying...
>   lkdtm: attempt 0: spray alloc addr 00000000f8699c7d vs freed addr 00000000f8699c7d
>   lkdtm: freed addr is reallocated!
>   lkdtm: FAIL! Heap spraying succeed :(
> 
> CONFIG_SLAB_QUARANTINE enabled:
>   # echo HEAP_SPRAY > /sys/kernel/debug/provoke-crash/DIRECT
>   lkdtm: Performing direct entry HEAP_SPRAY
>   lkdtm: Performing heap spraying...
>   lkdtm: attempt 0: spray alloc addr 000000009cafb63f vs freed addr 00000000173cce94
>   lkdtm: attempt 1: spray alloc addr 000000003096911f vs freed addr 00000000173cce94
>   lkdtm: attempt 2: spray alloc addr 00000000da60d755 vs freed addr 00000000173cce94
>   lkdtm: attempt 3: spray alloc addr 000000000b415070 vs freed addr 00000000173cce94
>   ...
>   lkdtm: attempt 126: spray alloc addr 00000000e80ef807 vs freed addr 00000000173cce94
>   lkdtm: attempt 127: spray alloc addr 00000000398fe535 vs freed addr 00000000173cce94
>   lkdtm: OK! Heap spraying hasn't succeed :)
> 
> I did a brief performance evaluation of this feature.
> 
> 1. Memory consumption. KASAN quarantine uses 1/32 of the memory.
> CONFIG_SLAB_QUARANTINE disabled:
>   # free -m
>                 total        used        free      shared  buff/cache   available
>   Mem:           1987          39        1862          10          86        1907
>   Swap:             0           0           0
> CONFIG_SLAB_QUARANTINE enabled:
>   # free -m
>                 total        used        free      shared  buff/cache   available
>   Mem:           1987         140        1760          10          87        1805
>   Swap:             0           0           0
> 
> 2. Performance penalty. I used `hackbench -s 256 -l 200 -g 15 -f 25 -P`.
> CONFIG_SLAB_QUARANTINE disabled (x86_64, CONFIG_SLUB):
>   Times: 3.088, 3.103, 3.068, 3.103, 3.107
>   Mean: 3.0938
>   Standard deviation: 0.0144
> CONFIG_SLAB_QUARANTINE enabled (x86_64, CONFIG_SLUB):
>   Times: 3.303, 3.329, 3.356, 3.314, 3.292
>   Mean: 3.3188 (+7.3%)
>   Standard deviation: 0.0223
> 
> I would appreciate your feedback!

While waiting for the feedback on these RFC patches, I compiled a list of topics
for further research:

 - Possible ways to overwrite a quarantined heap object by making a large amount
of allocations (with/without freeing them)

 - How init_on_free=1 affects heap spraying on a system with the heap quarantine

 - How releasing batches of quarantine objects right away affects heap spraying
reliability

 - Heap spraying on multi-core systems with the heap quarantine

 - More precise performance evaluation

 - Possible ways to improve the security properties and performance results
(KASAN quarantine has some interesting settings)

Best regards,
Alexander

> Alexander Popov (2):
>   mm: Extract SLAB_QUARANTINE from KASAN
>   lkdtm: Add heap spraying test
> 
>  drivers/misc/lkdtm/core.c  |   1 +
>  drivers/misc/lkdtm/heap.c  |  40 ++++++++++++++
>  drivers/misc/lkdtm/lkdtm.h |   1 +
>  include/linux/kasan.h      | 107 ++++++++++++++++++++-----------------
>  include/linux/slab_def.h   |   2 +-
>  include/linux/slub_def.h   |   2 +-
>  init/Kconfig               |  11 ++++
>  mm/Makefile                |   3 +-
>  mm/kasan/Makefile          |   2 +
>  mm/kasan/kasan.h           |  75 +++++++++++++-------------
>  mm/kasan/quarantine.c      |   2 +
>  mm/kasan/slab_quarantine.c |  99 ++++++++++++++++++++++++++++++++++
>  mm/slub.c                  |   2 +-
>  13 files changed, 258 insertions(+), 89 deletions(-)
>  create mode 100644 mm/kasan/slab_quarantine.c
> 

