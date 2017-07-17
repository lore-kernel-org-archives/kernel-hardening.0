MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <c86c66c3-29d8-0b04-b4d1-f9f8192d8c4a@linux.com>
References: <1500309907-9357-1-git-send-email-alex.popov@linux.com>
 <20170717175459.GC14983@bombadil.infradead.org> <alpine.DEB.2.20.1707171303230.12109@nuc-kabylake>
 <c86c66c3-29d8-0b04-b4d1-f9f8192d8c4a@linux.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 17 Jul 2017 12:11:40 -0700
Message-ID: <CAGXu5jK5j2pSVca9XGJhJ6pnF04p7S=K1Z432nzG2y4LfKhYjg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 1/1] mm/slub.c: add a naive detection of double free or corruption
To: Alexander Popov <alex.popov@linux.com>
Cc: Christopher Lameter <cl@linux.com>, Matthew Wilcox <willy@infradead.org>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jul 17, 2017 at 12:01 PM, Alexander Popov <alex.popov@linux.com> wrote:
> Hello Christopher,
>
> Thanks for your reply.
>
> On 17.07.2017 21:04, Christopher Lameter wrote:
>> On Mon, 17 Jul 2017, Matthew Wilcox wrote:
>>
>>> On Mon, Jul 17, 2017 at 07:45:07PM +0300, Alexander Popov wrote:
>>>> Add an assertion similar to "fasttop" check in GNU C Library allocator:
>>>> an object added to a singly linked freelist should not point to itself.
>>>> That helps to detect some double free errors (e.g. CVE-2017-2636) without
>>>> slub_debug and KASAN. Testing with hackbench doesn't show any noticeable
>>>> performance penalty.
>>>
>>>>  {
>>>> +   BUG_ON(object == fp); /* naive detection of double free or corruption */
>>>>     *(void **)(object + s->offset) = fp;
>>>>  }
>>>
>>> Is BUG() the best response to this situation?  If it's a corruption, then
>>> yes, but if we spot a double-free, then surely we should WARN() and return
>>> without doing anything?
>>
>> The double free debug checking already does the same thing in a more
>> thourough way (this one only checks if the last free was the same
>> address). So its duplicating a check that already exists.
>
> Yes, absolutely. Enabled slub_debug (or KASAN with its quarantine) can detect
> more double-free errors. But it introduces much bigger performance penalty and
> it's disabled by default.
>
>> However, this one is always on.
>
> Yes, I would propose to have this relatively cheap check enabled by default. I
> think it will block a good share of double-free errors. Currently it's really
> easy to turn such a double-free into use-after-free and exploit it, since, as I
> wrote, next two kmalloc() calls return the same address. So we could make
> exploiting harder for a relatively low price.
>
> Christopher, if I change BUG_ON() to VM_BUG_ON(), it will be disabled by default
> again, right?

Let's merge this with the proposed CONFIG_FREELIST_HARDENED, then the
performance change is behind a config, and we gain the rest of the
freelist protections at the same time:

http://www.openwall.com/lists/kernel-hardening/2017/07/06/1

-Kees

-- 
Kees Cook
Pixel Security
