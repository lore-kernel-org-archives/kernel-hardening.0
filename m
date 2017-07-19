References: <1500309907-9357-1-git-send-email-alex.popov@linux.com>
 <20170717175459.GC14983@bombadil.infradead.org>
 <alpine.DEB.2.20.1707171303230.12109@nuc-kabylake>
 <c86c66c3-29d8-0b04-b4d1-f9f8192d8c4a@linux.com>
 <CAGXu5jK5j2pSVca9XGJhJ6pnF04p7S=K1Z432nzG2y4LfKhYjg@mail.gmail.com>
 <1edb137c-356f-81d6-4592-f5dfc68e8ea9@linux.com>
 <CAGXu5jL0bFpWqUm9d2X7zpTO_CwPp94ywcLYoFyNcLuiwX8qAQ@mail.gmail.com>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <5f0ec56c-5cf1-58f7-5652-a5caedf3df88@linux.com>
Date: Wed, 19 Jul 2017 11:38:57 +0300
MIME-Version: 1.0
In-Reply-To: <CAGXu5jL0bFpWqUm9d2X7zpTO_CwPp94ywcLYoFyNcLuiwX8qAQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 1/1] mm/slub.c: add a naive detection of double free or
 corruption
To: Kees Cook <keescook@chromium.org>
Cc: Christopher Lameter <cl@linux.com>, Matthew Wilcox <willy@infradead.org>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 18.07.2017 23:04, Kees Cook wrote:
> On Tue, Jul 18, 2017 at 12:56 PM, Alexander Popov <alex.popov@linux.com> wrote:
>> On 17.07.2017 22:11, Kees Cook wrote:
>>> Let's merge this with the proposed CONFIG_FREELIST_HARDENED, then the
>>> performance change is behind a config, and we gain the rest of the
>>> freelist protections at the same time:
>>>
>>> http://www.openwall.com/lists/kernel-hardening/2017/07/06/1
>>
>> Hello Kees,
>>
>> If I change BUG_ON() to VM_BUG_ON(), this check will work at least on Fedora
>> since it has CONFIG_DEBUG_VM enabled. Debian based distros have this option
>> disabled. Do you like that more than having this check under
>> CONFIG_FREELIST_HARDENED?
> 
> I think there are two issues: first, this should likely be under
> CONFIG_FREELIST_HARDENED since Christoph hasn't wanted to make these
> changes enabled by default (if I'm understanding his earlier review
> comments to me).

Ok, I'll rebase onto FREELIST_HARDENED and test it all together.

> The second issue is what to DO when a double-free is
> discovered. Is there any way to make it safe/survivable? If not, I
> think it should just be BUG_ON(). If it can be made safe, then likely
> a WARN_ONCE and do whatever is needed to prevent the double-free.

Please correct me if I'm wrong. It seems to me that double-free is a dangerous
situation that indicates some serious kernel bug (which might be maliciously
exploited). So I would not trust / rely on the process which experiences a
double-free error in the kernel mode.

But I guess the reaction to it should depend on the Linux kernel policy of
handling faults. Is it defined explicitly?

Anyway, if we try to mitigate the effect from a double-free error _here_ (for
example, skip putting the duplicated object to the freelist), I think we should
do the same for other cases of double-free and memory corruptions.

>> If you insist on putting this check under CONFIG_FREELIST_HARDENED, should I
>> rebase onto your patch and send again?
> 
> That would be preferred for me -- I'd like to have both checks. :)

Ok.

Best regards,
Alexander
