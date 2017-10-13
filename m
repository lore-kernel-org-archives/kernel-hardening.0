MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CAGXu5jLKRP-XPT2JEoN0bGsZjX98XhNNQBTYYSFz2NnLvE=EYg@mail.gmail.com>
References: <1506816410-10230-1-git-send-email-me@tobin.cc>
 <CA+55aFxzD=+H_M+Sg_8YRf-JYV-+-yn1c=dFhJWFzSh5yWt9Gg@mail.gmail.com>
 <ArOl6I7GkZ912O0tP7uFPe5JRJTftclvQHVtSHw0hsmxk5IJXexp9M3zQPefcGCXcx27lzX7A1s74XFa9gXEA5yRA5hC1BaNqhD7QgN3JRo=@protonmail.ch>
 <CA+55aFzGsRFPtMFRv3G0FPNs6YAD3S2U94o58Lgg1MnmHwCxvA@mail.gmail.com>
 <476DC76E7D1DF2438D32BFADF679FC563EAF4F29@ORSMSX103.amr.corp.intel.com>
 <CA+55aFwEZCT6=BCdmaNn5LGeU8g-2qi4OnM9MTOep3NOZVXjMg@mail.gmail.com>
 <20171005021915.GK16685@eros> <CA+55aFwac2BzgZs-X1_VhekkuGfuLqNui2+2DbvLiDyptS-rXQ@mail.gmail.com>
 <476DC76E7D1DF2438D32BFADF679FC563F4AD0AF@ORSMSX115.amr.corp.intel.com>
 <CA+55aFxjsKRhuzpQjRff6b6emJBFHtefUwnDfv+zgrxmUDvqkw@mail.gmail.com>
 <20171007234453.vojizsbxec4gygku@thunk.org> <CA+55aFy2CQ_AFahTQynumDL6ocZD5R23v=HXLYS6w_E1tpY-1Q@mail.gmail.com>
 <476DC76E7D1DF2438D32BFADF679FC563F4AF1B4@ORSMSX115.amr.corp.intel.com>
 <CA+55aFy58SHOCbJWtzB94PuT0d9UmdJ8QUZt+MjDYL9qbdfxbw@mail.gmail.com>
 <CAGXu5jJns_OogyXTwZ7crasCuOSAZMkiLN6c0=y8bGpsP1YNTg@mail.gmail.com>
 <CA+55aFxZo5kZEiZFYj5mns3Tsgb0JLC_rae2ThObeM5xrC8Mug@mail.gmail.com> <CAGXu5jLKRP-XPT2JEoN0bGsZjX98XhNNQBTYYSFz2NnLvE=EYg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Oct 2017 14:45:38 -0700
Message-ID: <CA+55aFybUX-bvO2HAN-7H2-LrT9vztpqhRki3xzgeGm0aPPMQQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [RFC V2 0/6] add more kernel pointer filter options
To: Kees Cook <keescook@chromium.org>
Cc: "Roberts, William C" <william.c.roberts@intel.com>, Theodore Ts'o <tytso@mit.edu>, "Tobin C. Harding" <me@tobin.cc>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Oct 13, 2017 at 1:47 PM, Kees Cook <keescook@chromium.org> wrote:
>
> Is the correct path to:
> - unconditionally convert %p to reporting a 32-bit hash
> - actively start removing as much %p use as possible
> - do something to discourage %x on pointers (checkpatch.pl?)

I don't know if we even need to remove %p if we just unconditionally hash it.

I _think_ that what will happen if we just start hashing %p is that
99% of existing %p cases will just stay around, because many of them
are likely effectively stale. Maybe they were useful for driver
development, but they probably aren't any more.

The 1% that will cause people to look at the code may well be painful,
though. We are potentially talking more than just a handful here.

We *may* actually want to introduce %pX as a way to opt _out_ of the
hashing, so that  %p users that really do want an address can keep it
- while making it  really easy to grep for (and then maybe
kptr_restrict=4 would say "even %pX gets hashed anyway").

As to %x and pointers, I'm not sure how to do that with checkpatch.
And I don't even think it's about pointers. If people care about the
physical addresses leaking (and the %pa format kind of indicates
people do), the most common physical addresses likely are %x printouts
before those addresses were made into pointers at all. Those physical
addresses often came from somewhere else where they were just integers
(eg PCI BAR values etc).

So realistically, that's where the "let's try to come up with scripts
to find those things" comes in.

... and just perhaps generally talk about this "don't leak pointers or
physical addresses to random user space" so that people are more aware
of it in general.

That, btw, might be a side effect of %p being hashed in the first
place. People will go "WTF?" for a while, and just _explaining_ the %p
hashing might make people more aware of this issue in the first place.

Or maybe I'm just unrealistically optimistic, and what will _actually_
happen if we start hashing %p output is just a lot and lot of
complaining and whining and tons of breakage. ;(

> Can we do something more about %x?
>
> Do we want to remove %pK also?

I'm not sure we need to. But there may be %pK users that simply think
that getting a hashed address is better than getting just zeroes, and
that would thus prefer going back to %p.

           Linus
