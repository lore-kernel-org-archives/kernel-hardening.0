Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <1455561864-4217-1-git-send-email-labbott@fedoraproject.org>
References: <1455561864-4217-1-git-send-email-labbott@fedoraproject.org>
Date: Thu, 18 Feb 2016 17:39:10 +0900
Message-ID: <CAAmzW4MQYtWtCwhPF9VSQdK=rcy0t1-hThNNu9fBduS395J6iA@mail.gmail.com>
From: Joonsoo Kim <js1304@gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCHv2 0/4] Improve performance for SLAB_POISON
To: Laura Abbott <labbott@fedoraproject.org>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Linux Memory Management List <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

2016-02-16 3:44 GMT+09:00 Laura Abbott <labbott@fedoraproject.org>:
> Hi,
>
> This is a follow up to my previous series
> (http://lkml.kernel.org/g/<1453770913-32287-1-git-send-email-labbott@fedoraproject.org>)
> This series takes the suggestion of Christoph Lameter and only focuses on
> optimizing the slow path where the debug processing runs. The two main
> optimizations in this series are letting the consistency checks be skipped and
> relaxing the cmpxchg restrictions when we are not doing consistency checks.
> With hackbench -g 20 -l 1000 averaged over 100 runs:
>
> Before slub_debug=P
> mean 15.607
> variance .086
> stdev .294
>
> After slub_debug=P
> mean 10.836
> variance .155
> stdev .394
>
> This still isn't as fast as what is in grsecurity unfortunately so there's still
> work to be done. Profiling ___slab_alloc shows that 25-50% of time is spent in
> deactivate_slab. I haven't looked too closely to see if this is something that
> can be optimized.

There is something to be optimized. deactivate_slab() deactivate objects of
freelist one by one and it's useless. And, it deactivates freelist
with two phases.
Deactivating objects except last one and then deactivating last object with
node lock. It would be also optimized although I didn't think deeply.

Thanks.
