MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <20171005021915.GK16685@eros>
References: <1506816410-10230-1-git-send-email-me@tobin.cc>
 <CA+55aFxzD=+H_M+Sg_8YRf-JYV-+-yn1c=dFhJWFzSh5yWt9Gg@mail.gmail.com>
 <ArOl6I7GkZ912O0tP7uFPe5JRJTftclvQHVtSHw0hsmxk5IJXexp9M3zQPefcGCXcx27lzX7A1s74XFa9gXEA5yRA5hC1BaNqhD7QgN3JRo=@protonmail.ch>
 <CA+55aFzGsRFPtMFRv3G0FPNs6YAD3S2U94o58Lgg1MnmHwCxvA@mail.gmail.com>
 <476DC76E7D1DF2438D32BFADF679FC563EAF4F29@ORSMSX103.amr.corp.intel.com>
 <CA+55aFwEZCT6=BCdmaNn5LGeU8g-2qi4OnM9MTOep3NOZVXjMg@mail.gmail.com> <20171005021915.GK16685@eros>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 Oct 2017 20:10:32 -0700
Message-ID: <CA+55aFwac2BzgZs-X1_VhekkuGfuLqNui2+2DbvLiDyptS-rXQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [RFC V2 0/6] add more kernel pointer filter options
To: "Tobin C. Harding" <me@tobin.cc>
Cc: "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 4, 2017 at 7:19 PM, Tobin C. Harding <me@tobin.cc> wrote:
>
> This sounds like just the job for an upcoming kernel hacker, with a lot of time
> and not much experience, to do something laborious that no one else wants to do
> and learn a bunch about the kernel.

Heh.

We _have_ been doing it, but we definitely have only done it on a
random case-by-cased basis as something comes up.

So what would be great is to have something actively looking for these
things - and by "something" I mean mostly scripting.

And yes, as Kees and Daniel mentioned, it's definitely not just dmesg.
In fact, the primary things tend to be /proc and /sys, not dmesg
itself.

Another example of this would be commit 31b0b385f69d ("nf_conntrack:
avoid kernel pointer value leak in slab name"), where the fact that
the slab name had a pointer in it leaked it in the _filenames_ in
/sys, because we export slab statistics under /sys/kernel/slab/. And
each file was readable only by root, but the file *names* were
readable by everybody.

(That separate slab thing then got removed entirely later, so that
slab no longer exists at all, but it's an odd example of how the leaks
can be in the meta-data, not in the file contents themselves.

But again, I think that kind of leak would have been fairly obvious if
we just had some scripting that looked for interfaces that the kernel
exposed, and looked for that hex pattern.

In fact, that was how I noticved that one: not a grep, but an entirely
unrelated "find /sys..." that made me go "why are there kernel
addresses in there.."

So we've found them occasionally simply by mistake - and it would be
great if we found them because we actively went _looking_ for them.

> So what if we drop this patch set and
>
> 1. Find and fix every place in the kernel that leaks addresses.
> 2. Verify that checkpatch.pl warns for all potential future leakage.
> 2. Add a script to check dmesg output for future hardening.

Very ambitious (particularly that "*every* place"), but I certainly
think it would be the better end result, yes.

And I do think we would be really well off if we aimed for simply
getting rid of all the variations of %p that output hex addresses
entirely.

Don't get me wrong: I think the various _fancy_ versions of "%pXYZ"
are great, ie things like "%pS" to show the symbol name etc.

But plain %p has definitely been a problem, and I don't think %pa is
great either. So aiming to get rid of them entirely is probably a good
idea.

So I am not opposed to hobbling %p per se. It's literally just the
'kptr_restrict' model I detest. I'd rather get rid of %p (and %pa)
_entirely_ and make valid users have to work a bit extra for it,
because I think the 6+ years of kptr_restrict has shown that model of
"let people who care just enable it again" to simply not work.

                   Linus
