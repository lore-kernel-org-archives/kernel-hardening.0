MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CA+55aFwEZCT6=BCdmaNn5LGeU8g-2qi4OnM9MTOep3NOZVXjMg@mail.gmail.com>
References: <1506816410-10230-1-git-send-email-me@tobin.cc>
 <CA+55aFxzD=+H_M+Sg_8YRf-JYV-+-yn1c=dFhJWFzSh5yWt9Gg@mail.gmail.com>
 <ArOl6I7GkZ912O0tP7uFPe5JRJTftclvQHVtSHw0hsmxk5IJXexp9M3zQPefcGCXcx27lzX7A1s74XFa9gXEA5yRA5hC1BaNqhD7QgN3JRo=@protonmail.ch>
 <CA+55aFzGsRFPtMFRv3G0FPNs6YAD3S2U94o58Lgg1MnmHwCxvA@mail.gmail.com>
 <476DC76E7D1DF2438D32BFADF679FC563EAF4F29@ORSMSX103.amr.corp.intel.com> <CA+55aFwEZCT6=BCdmaNn5LGeU8g-2qi4OnM9MTOep3NOZVXjMg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 Oct 2017 17:09:33 -0700
Message-ID: <CA+55aFxhnwjyLsVc54UVKCSm+-DSkOar5XV919J-Cg6i3NXC5Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [RFC V2 0/6] add more kernel pointer filter options
To: "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Jordan Glover <Golden_Miller83@protonmail.ch>, "Tobin C. Harding" <me@tobin.cc>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 4, 2017 at 4:52 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> It also shows
>
>     software IO TLB [mem PA-PB] (64MB) mapped at [VA-VB]
>
> for example.  And THIS IS IMPORTANT! The physical address is shown
> with "%#010llx".

Oh, and I added Tejun for the percpu printout, but didn't add Bjorn
for this one.

Like the percpu one, I suspect that this pr_info() isn't really
important enough to stay, and while it doesn't sound nearly as
interesting as the percpu virtual address to an attacker, it probably
isn't important enough to leak kernel (and hardware) data for.

Bjorn?

I suspect we could try to make people aware of these kinds of things.
The nice zero-day robots etc probably aren't wondeful for this (since
they'll have fairly limited hardware), but maybe we could have a
script that makes it easy to just say

 "does dmesg seem to contain interesting numbers that really shouldn't
be leaked?"

That "egrep 'ffff[0-9a-f]{12}" is certainly not very good - not only
is it 64-bit specific, but it triggers, for example, on a "mask:
0xffffffffffffffff" from the clocksource code. But Something
*slightly* smarter could be something we could probably encourage
people to run occasionally.

... and if nothing else, maybe it makes developers more aware of the
"I shouldn't be leaking kernel data in dmesg" issue in general.

More so than just special-casing %p handling in odd ways and ignoring
all the other ways we can leak.

For example: x86 removed the raw stack dump last year (commit
0ee1dd9f5e7e: "x86/dumpstack: Remove raw stack dump"), because we
decided that triggering a BUG_ON() obviously does need to expose some
kernel data, but the stack wasn't worth it (and definitely tends to
contain nasty information). ARM has not (see "dump_mem()". Again,
that's not using %p. It uses to use %lx.

So is %p really the problem?

               Linus
