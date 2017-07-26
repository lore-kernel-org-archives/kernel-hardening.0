MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <cdd42a1b-ce15-df8c-6bd1-b0943275986f@linux.com>
References: <20170706002718.GA102852@beast> <cdd42a1b-ce15-df8c-6bd1-b0943275986f@linux.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 25 Jul 2017 17:21:15 -0700
Message-ID: <CAGXu5jKRDhvqj0TU10W10hsdixN2P+hHzpYfSVvOFZy=hW72Mg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [v3] mm: Add SLUB free list pointer obfuscation
To: Alexander Popov <alex.popov@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>, Josh Triplett <josh@joshtriplett.org>, Andy Lutomirski <luto@kernel.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Tejun Heo <tj@kernel.org>, Daniel Mack <daniel@zonque.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Helge Deller <deller@gmx.de>, Rik van Riel <riel@redhat.com>, Linux-MM <linux-mm@kvack.org>, Tycho Andersen <tycho@docker.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jul 24, 2017 at 2:17 PM, Alexander Popov <alex.popov@linux.com> wrote:
> From 86f4f1f6deb76849e00c761fa30eeb479f789c35 Mon Sep 17 00:00:00 2001
> From: Alexander Popov <alex.popov@linux.com>
> Date: Mon, 24 Jul 2017 23:16:28 +0300
> Subject: [PATCH 2/2] mm/slub.c: add a naive detection of double free or
>  corruption
>
> On 06.07.2017 03:27, Kees Cook wrote:
>> This SLUB free list pointer obfuscation code is modified from Brad
>> Spengler/PaX Team's code in the last public patch of grsecurity/PaX based
>> on my understanding of the code. Changes or omissions from the original
>> code are mine and don't reflect the original grsecurity/PaX code.
>>
>> This adds a per-cache random value to SLUB caches that is XORed with
>> their freelist pointer address and value. This adds nearly zero overhead
>> and frustrates the very common heap overflow exploitation method of
>> overwriting freelist pointers. A recent example of the attack is written
>> up here: http://cyseclabs.com/blog/cve-2016-6187-heap-off-by-one-exploit
>>
>> This is based on patches by Daniel Micay, and refactored to minimize the
>> use of #ifdef.
>
> Hello!
>
> This is an addition to the SLAB_FREELIST_HARDENED feature. I'm sending it
> according the discussion here:
> http://www.openwall.com/lists/kernel-hardening/2017/07/17/9
>
> -- >8 --
>
> Add an assertion similar to "fasttop" check in GNU C Library allocator
> as a part of SLAB_FREELIST_HARDENED feature. An object added to a singly
> linked freelist should not point to itself. That helps to detect some
> double free errors (e.g. CVE-2017-2636) without slub_debug and KASAN.
>
> Signed-off-by: Alexander Popov <alex.popov@linux.com>
> ---
>  mm/slub.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index c92d636..f39d06e 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -290,6 +290,10 @@ static inline void set_freepointer(struct kmem_cache *s,
> void *object, void *fp)
>  {
>         unsigned long freeptr_addr = (unsigned long)object + s->offset;
>
> +#ifdef CONFIG_SLAB_FREELIST_HARDENED
> +       BUG_ON(object == fp); /* naive detection of double free or corruption */
> +#endif
> +
>         *(void **)freeptr_addr = freelist_ptr(s, fp, freeptr_addr);

What happens if, instead of BUG_ON, we do:

if (unlikely(WARN_RATELIMIT(object == fp, "double-free detected"))
        return;

That would ignore adding it back to the list, since it's already
there, yes? Or would this make SLUB go crazy? I can't tell from the
accounting details around callers to set_freepointer(). I assume it's
correct, since it's close to the same effect as BUG (i.e. we don't do
the update, but the cache remains visible to the system)

-Kees

-- 
Kees Cook
Pixel Security
