MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <505961f9-b266-191a-f4b7-931410a55149@redhat.com>
References: <20170620030112.GA140256@beast> <505961f9-b266-191a-f4b7-931410a55149@redhat.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 20 Jun 2017 11:08:33 -0700
Message-ID: <CAGXu5jKRLNvb2Gy77Q4pTes6oHEypG=GCB56twb8A7jvz=FpLg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH] mm: Add SLUB free list pointer obfuscation
To: Laura Abbott <labbott@redhat.com>
Cc: Christoph Lameter <cl@linux.com>, Daniel Micay <danielmicay@gmail.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Tejun Heo <tj@kernel.org>, Daniel Mack <daniel@zonque.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Helge Deller <deller@gmx.de>, Rik van Riel <riel@redhat.com>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 20, 2017 at 11:05 AM, Laura Abbott <labbott@redhat.com> wrote:
> On 06/19/2017 08:01 PM, Kees Cook wrote:
>> This SLUB free list pointer obfuscation code is modified from Brad
>> Spengler/PaX Team's code in the last public patch of grsecurity/PaX based
>> on my understanding of the code. Changes or omissions from the original
>> code are mine and don't reflect the original grsecurity/PaX code.
>>
>> This adds a per-cache random value to SLUB caches that is XORed with
>> their freelist pointers. This adds nearly zero overhead and frustrates the
>> very common heap overflow exploitation method of overwriting freelist
>> pointers. A recent example of the attack is written up here:
>> http://cyseclabs.com/blog/cve-2016-6187-heap-off-by-one-exploit
>>
>> This is based on patches by Daniel Micay, and refactored to avoid lots
>> of #ifdef code.
>>
>> Suggested-by: Daniel Micay <danielmicay@gmail.com>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  include/linux/slub_def.h |  4 ++++
>>  init/Kconfig             | 10 ++++++++++
>>  mm/slub.c                | 32 +++++++++++++++++++++++++++-----
>>  3 files changed, 41 insertions(+), 5 deletions(-)
>>
>> diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
>> index 07ef550c6627..0258d6d74e9c 100644
>> --- a/include/linux/slub_def.h
>> +++ b/include/linux/slub_def.h
>> @@ -93,6 +93,10 @@ struct kmem_cache {
>>  #endif
>>  #endif
>>
>> +#ifdef CONFIG_SLAB_HARDENED
>> +     unsigned long random;
>> +#endif
>> +
>>  #ifdef CONFIG_NUMA
>>       /*
>>        * Defragmentation by allocating from a remote node.
>> diff --git a/init/Kconfig b/init/Kconfig
>> index 1d3475fc9496..eb91082546bf 100644
>> --- a/init/Kconfig
>> +++ b/init/Kconfig
>> @@ -1900,6 +1900,16 @@ config SLAB_FREELIST_RANDOM
>>         security feature reduces the predictability of the kernel slab
>>         allocator against heap overflows.
>>
>> +config SLAB_HARDENED
>> +     bool "Harden slab cache infrastructure"
>> +     default y
>> +     depends on SLAB_FREELIST_RANDOM && SLUB> +      help
>> +       Many kernel heap attacks try to target slab cache metadata and
>> +       other infrastructure. This options makes minor performance
>> +       sacrifies to harden the kernel slab allocator against common
>> +       exploit methods.
>> +
>
> Going to bikeshed on SLAB_HARDENED unless this is intended to be used for
> more things. Perhaps SLAB_FREELIST_HARDENED?

Daniel's tree has a bunch of changes attached to that config name, but
it's unclear to me how many would be accepted upstream. I would be
fine with SLAB_FREELIST_HARDENED.

> What's the reason for the dependency on SLAB_FREELIST_RANDOM?

Looking at it again, I suspect the idea was to collect other configs
under SLAB_HARDENED. It should likely be either be a select or just
dropped.

-Kees

-- 
Kees Cook
Pixel Security
