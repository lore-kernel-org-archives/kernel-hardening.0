References: <20170706002718.GA102852@beast>
 <cdd42a1b-ce15-df8c-6bd1-b0943275986f@linux.com>
 <CAGXu5jKRDhvqj0TU10W10hsdixN2P+hHzpYfSVvOFZy=hW72Mg@mail.gmail.com>
 <alpine.DEB.2.20.1707260906230.6341@nuc-kabylake>
 <CAGXu5jLkOjDKSZ48jOyh2voP17xXMeEnqzV_=8dGSvFmqdCZCA@mail.gmail.com>
 <alpine.DEB.2.20.1707261154140.9167@nuc-kabylake>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <515333f5-1815-8591-503e-c0cf6941670e@linux.com>
Date: Fri, 28 Jul 2017 01:48:56 +0300
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.20.1707261154140.9167@nuc-kabylake>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [v3] mm: Add SLUB free list pointer obfuscation
To: Christopher Lameter <cl@linux.com>, Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>, Josh Triplett <josh@joshtriplett.org>, Andy Lutomirski <luto@kernel.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Tejun Heo <tj@kernel.org>, Daniel Mack <daniel@zonque.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Helge Deller <deller@gmx.de>, Rik van Riel <riel@redhat.com>, Linux-MM <linux-mm@kvack.org>, Tycho Andersen <tycho@docker.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, alex.popov@linux.com
List-ID: <kernel-hardening.lists.openwall.com>

Hello Christopher and Kees,

On 26.07.2017 19:55, Christopher Lameter wrote:
> On Wed, 26 Jul 2017, Kees Cook wrote:
> 
>>>> What happens if, instead of BUG_ON, we do:
>>>>
>>>> if (unlikely(WARN_RATELIMIT(object == fp, "double-free detected"))
>>>>         return;
>>>
>>> This may work for the free fastpath but the set_freepointer function is
>>> use in multiple other locations. Maybe just add this to the fastpath
>>> instead of to this fucnction?
>>
>> Do you mean do_slab_free()?
> 
> Yes inserting these lines into do_slab_free() would simple ignore the
> double free operation in the fast path and that would be safe.

I don't really like ignoring double-free. I think, that:
  - it will hide dangerous bugs in the kernel,
  - it can make some kernel exploits more stable.
I would rather add BUG_ON to set_freepointer() behind SLAB_FREELIST_HARDENED. Is
it fine?

At the same time avoiding the consequences of some double-free errors is better
than not doing that. It may be considered as kernel "self-healing", I don't
know. I can prepare a second patch for do_slab_free(), as you described. Would
you like it?

Best regards,
Alexander
