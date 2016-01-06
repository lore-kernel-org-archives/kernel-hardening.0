Reply-To: kernel-hardening@lists.openwall.com
References: <1450755641-7856-1-git-send-email-laura@labbott.name>
 <1450755641-7856-2-git-send-email-laura@labbott.name>
 <5679B701.9040802@suse.cz>
 <CAGXu5jLvS0jzi07QegCHoBoCc3wFhbcMOjCpmbe3KC2oJO9jPQ@mail.gmail.com>
From: Laura Abbott <laura@labbott.name>
Message-ID: <568C76AB.1060804@labbott.name>
Date: Tue, 5 Jan 2016 18:06:35 -0800
MIME-Version: 1.0
In-Reply-To: <CAGXu5jLvS0jzi07QegCHoBoCc3wFhbcMOjCpmbe3KC2oJO9jPQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC][PATCH 1/7] mm/slab_common.c: Add common support for slab
 saniziation
To: Kees Cook <keescook@chromium.org>, Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mathias Krause <minipli@googlemail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 1/5/16 4:17 PM, Kees Cook wrote:
> On Tue, Dec 22, 2015 at 12:48 PM, Vlastimil Babka <vbabka@suse.cz> wrote:
>> On 22.12.2015 4:40, Laura Abbott wrote:
>>> Each of the different allocators (SLAB/SLUB/SLOB) handles
>>> clearing of objects differently depending on configuration.
>>> Add common infrastructure for selecting sanitization levels
>>> (off, slow path only, partial, full) and marking caches as
>>> appropriate.
>>>
>>> All credit for the original work should be given to Brad Spengler and
>>> the PaX Team.
>>>
>>> Signed-off-by: Laura Abbott <laura@labbott.name>
>>>
>>> +#ifdef CONFIG_SLAB_MEMORY_SANITIZE
>>> +#ifdef CONFIG_X86_64
>>> +#define SLAB_MEMORY_SANITIZE_VALUE       '\xfe'
>>> +#else
>>> +#define SLAB_MEMORY_SANITIZE_VALUE       '\xff'
>>> +#endif
>>> +enum slab_sanitize_mode {
>>> +     /* No sanitization */
>>> +     SLAB_SANITIZE_OFF = 0,
>>> +
>>> +     /* Partial sanitization happens only on the slow path */
>>> +     SLAB_SANITIZE_PARTIAL_SLOWPATH = 1,
>>
>> Can you explain more about this variant? I wonder who might find it useful
>> except someone getting a false sense of security, but cheaper.
>> It sounds like wanting the cake and eat it too :)
>> I would be surprised if such IMHO half-solution existed in the original
>> PAX_MEMORY_SANITIZE too?
>>
>> Or is there something that guarantees that the objects freed on hotpath won't
>> stay there for long so the danger of leak is low? (And what about
>> use-after-free?) It depends on further slab activity, no? (I'm not that familiar
>> with SLUB, but I would expect the hotpath there being similar to SLAB freeing
>> the object on per-cpu array_cache. But, it seems the PARTIAL_SLOWPATH is not
>> implemented for SLAB, so there might be some fundamental difference I'm missing.)
>
> Perhaps the partial sanitize could be a separate patch so it's
> features were more logically separated?
>

I've done some more thinking and testing and I'm just going to drop the
slowpath idea. It helps some benchmarks but not enough. The concept is
out there if it's worth picking up later.

Thanks,
Laura
