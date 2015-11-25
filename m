Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 26 Nov 2015 00:45:42 +0100
From: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Message-ID: <20151125234542.GA10324@chrystal>
References: <CAGXu5j+Su3SC4gRmyXz2J1O7rY5eUe9-5KVGhCafy5iRZ4JnCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+Su3SC4gRmyXz2J1O7rY5eUe9-5KVGhCafy5iRZ4JnCA@mail.gmail.com>
Subject: [kernel-hardening] Re: status: GRKERNSEC_KSTACKOVERFLOW
To: Kees Cook <keescook@chromium.org>
Cc: Quentin Casasnovas <quentin.casasnovas@oracle.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 24, 2015 at 11:10:09AM -0800, Kees Cook wrote:
> Hi,
>

Hi Kees,

> I just wanted to check in and see how progress was going on the stack
> overflow feature. Anything we can help with?
>

Sorry for not following up on this, I've been busy and haven't had the time
to finish it properly.  I've pushed an initial WIP break up of the
KSTACK_OVERFLOW feature on my github:

  https://github.com/casasnovas/linux/tree/quentin-split-kstackoverflow

This is far from being complete though, and hasn't been cleaned at all.  I
didn't share it earlier because I don't think I fully understand it and
haven't tested it yet.  In "short", there's mention of guard pages in the
Kconfig help:

  If you say Y here, the kernel's process stacks will be allocated with
  vmalloc instead of the kernel's default allocator.  This introduces guard
                                                                      ^^^^^
  pages that in combination with the alloca checking of the STACKLEAK
  ^^^^^
  feature prevents all forms of kernel process stack overflow abuse.  Note
  that this is different from kernel stack buffer overflows. """

And I couldn't find anything about it in the code.  Maybe it's just coming
from a mis-interpretation of the above text, but I was expecting this to
mean there would be a PROT_NONE guard page after the end of the stack, so
that read/writes below it could be trapped.  It could also be that I missed
some parts in my initial break-up or simply am missing something.

It should also be noted that I did not find that the struct thread_info
(which is stuffed at the end of the stack) was protected in any way either.
So even if a write/read _below_ the stack could still be trapped if nothing
is currently mapped there, it looks like deep stack usage could still
overflow it and go unoticed.  Here again, I didn't spend a lot of time on
this and it might just be that I'm missing something.

In the very unlikely event where I didn't miss anything and the struct
thread_info can still be overflown and there isn't any guard page, maybe we
can improve on the current KSTACK_OVERFLOW feature by putting the struct
thread_info on a different page than the kernel stack, and not vmap() it
like the rest of the stack pages, but instead map a PROT_NONE page there.
That would mean the struct thread_info can still be accessed by using its
lowmem mapping (i.e. legit usage from the kernel) but not by deep kernel
stack usage.  Maybe the cost of adding an extra page per kernel stack is
too high though.

Finally, I'd like to find a real life example where one could overflow the
kernel stack, so it can be used to test the feature (once properly split)
and show it can happen, for real, before sending real patches for review.
I might have found such a case because of what appears to me like a gcc
bug, more on this in another follow up :)

tldr; Initial break up done, not even compile-tested yet and am probably
missing some bits.  Might have found a code path to trigger a kernel stack
overflow due to a gcc weirdness, I need to investigate it.

Any comments appreciated :)

Thanks,
Quentin
