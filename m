Return-Path: <SRS0=0JSv=B4=lists.openwall.com=kernel-hardening-return-19653-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9247EC433E1
	for <kernel-hardening@archiver.kernel.org>; Tue, 18 Aug 2020 09:09:14 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BBFFB206B5
	for <kernel-hardening@archiver.kernel.org>; Tue, 18 Aug 2020 09:09:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BBFFB206B5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19653-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7202 invoked by uid 550); 18 Aug 2020 09:09:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7182 invoked from network); 18 Aug 2020 09:09:05 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:reply-to:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=eGZFS/MFRoESH0uw3pVgleAg17asJndqbfQ7lo0he2A=;
        b=PXwTg+FKYNQ39Gau3/fMPdyephlHw/DfiYWKG7oZi6+gIx1NqI5ZUbfgu7NX+Y4a+e
         O8yp0i5Wg6yDl+W0siJJ/yeUG103KHxtAFAcz1tcM/TDZ/v1lk6bSoaruPYw2wBehVab
         VXDjk2yGNCxCv+UvgIgq+9g64dcTsC2sJrrmTA7qXw2LE/qvIFdqTfPKJ9GZbJMnXl2f
         ZhXJLdyQG+4TjllfiphC2zN+eqR6vENnsJxjmq0dLCDOmk97FpdvIGkskyqhtZPf5CoF
         2PjyxYd8gjzBJ8ZL24X191bI9bltWLA6mS/EfxpEb675mX9wz5wWeCxYf33Wf2p22Rln
         1KjA==
X-Gm-Message-State: AOAM533Ccmmrhh+HU1U+R3v3T6BXOSCSmdSD5JhszAIft13Q62cdAs42
	7R1Co0rVnvuiMtbobmkIzhk=
X-Google-Smtp-Source: ABdhPJwKOD+rCSX5D1E0LXxIO7IZs224VoY7MK9Lc4scLMhhbqpEB7TdI65+pKF7gnh1HugJCfiqZA==
X-Received: by 2002:a05:6402:12d7:: with SMTP id k23mr19002534edx.312.1597741734012;
        Tue, 18 Aug 2020 02:08:54 -0700 (PDT)
From: Alexander Popov <alex.popov@linux.com>
Subject: Re: [PATCH RFC 0/2] Break heap spraying needed for exploiting
 use-after-free
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
 <202008150935.4C2F32559F@keescook>
Autocrypt: addr=alex.popov@linux.com; prefer-encrypt=mutual; keydata=
 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
 j3lCqPk=
Message-ID: <e72ac0d5-80b1-b8a3-2436-cc027f81fefa@linux.com>
Date: Tue, 18 Aug 2020 12:08:47 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <202008150935.4C2F32559F@keescook>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 15.08.2020 19:39, Kees Cook wrote:
> On Thu, Aug 13, 2020 at 06:19:20PM +0300, Alexander Popov wrote:
>> I've found an easy way to break heap spraying for use-after-free
>> exploitation. I simply extracted slab freelist quarantine from KASAN
>> functionality and called it CONFIG_SLAB_QUARANTINE. Please see patch 1.
> 
> Ah yeah, good idea. :)
> 
>> [...]
>> I did a brief performance evaluation of this feature.
>>
>> 1. Memory consumption. KASAN quarantine uses 1/32 of the memory.
>> CONFIG_SLAB_QUARANTINE disabled:
>>   # free -m
>>                 total        used        free      shared  buff/cache   available
>>   Mem:           1987          39        1862          10          86        1907
>>   Swap:             0           0           0
>> CONFIG_SLAB_QUARANTINE enabled:
>>   # free -m
>>                 total        used        free      shared  buff/cache   available
>>   Mem:           1987         140        1760          10          87        1805
>>   Swap:             0           0           0
> 
> 1/32 of memory doesn't seem too bad for someone interested in this defense.

This can be configured. Quote from linux/mm/kasan/quarantine.c:
/*
 * The fraction of physical memory the quarantine is allowed to occupy.
 * Quarantine doesn't support memory shrinker with SLAB allocator, so we keep
 * the ratio low to avoid OOM.
 */
#define QUARANTINE_FRACTION 32

>> 2. Performance penalty. I used `hackbench -s 256 -l 200 -g 15 -f 25 -P`.
>> CONFIG_SLAB_QUARANTINE disabled (x86_64, CONFIG_SLUB):
>>   Times: 3.088, 3.103, 3.068, 3.103, 3.107
>>   Mean: 3.0938
>>   Standard deviation: 0.0144
>> CONFIG_SLAB_QUARANTINE enabled (x86_64, CONFIG_SLUB):
>>   Times: 3.303, 3.329, 3.356, 3.314, 3.292
>>   Mean: 3.3188 (+7.3%)
>>   Standard deviation: 0.0223
> 
> That's rather painful, but hackbench can produce some big deltas given
> it can be an unrealistic workload for most systems. I'd be curious to
> see the "building a kernel" timings, which tends to be much more
> realistic for "busy system" without hammering one particular subsystem
> (though it's a bit VFS heavy, obviously).

I have new results.

CPU: Intel Core i7-6500U CPU @ 2.50GHz

Test: time make O=../build_out/defconfig/ -j2

CONFIG_SLAB_QUARANTINE disabled:
  Times: 10m52.978s 10m50.161s 10m45.601s
  Mean: 649.58s
  Standard deviation: 3.04

CONFIG_SLAB_QUARANTINE enabled:
  Times: 10m56.256s 10m51.919s 10m47.903s
  Mean: 652.026s (+0,38%)
  Standard deviation: 3.41

This test shows much lower performance penalty.

More ideas of tests?

Best regards,
Alexander
