MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CA+55aFxZo5kZEiZFYj5mns3Tsgb0JLC_rae2ThObeM5xrC8Mug@mail.gmail.com>
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
 <CAGXu5jJns_OogyXTwZ7crasCuOSAZMkiLN6c0=y8bGpsP1YNTg@mail.gmail.com> <CA+55aFxZo5kZEiZFYj5mns3Tsgb0JLC_rae2ThObeM5xrC8Mug@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 13 Oct 2017 13:47:07 -0700
Message-ID: <CAGXu5jLKRP-XPT2JEoN0bGsZjX98XhNNQBTYYSFz2NnLvE=EYg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [RFC V2 0/6] add more kernel pointer filter options
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Roberts, William C" <william.c.roberts@intel.com>, Theodore Ts'o <tytso@mit.edu>, "Tobin C. Harding" <me@tobin.cc>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Oct 13, 2017 at 1:22 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> I'm acknowledging that it's a complete hack that may have made sense
> in a particular setting, but it's not one that actually fixes any real
> security issues, and in particular, it's one that has likely held
> people back from doing *real* security.
>
> And as a maintainer of the kernel, to me that "long term actual
> development" is a whole lot more important than "silly hack that might
> close a random escape or two".
>
> So yes, I'm actually opposed to the global flag, because we seriously
> have 6+ years of reality staring us in the face: it fixed exactly
> nothing. It fixed /proc/kallsyms,m but did so _badly_. It fixed a
> handful of other places. But it didn't really and truly add any real
> security.
>
> Are people really in denial about this? Really?

I totally agree that %pK isn't actually useful. (I think of %pK and a
global flag controlling %p behavior as separate things.) The original
patch I was talking about fully acknowledges this (%pK not actually
working) and was about changing %p behavior. Some other solution was
needed that didn't drive developers into using %x for everything
instead.

> The whole "let's make %p print a hashed address" is not the real
> security part. That's just the "make it easy to do something secure by
> _default_" part. The real security is actually scanning for bad
> things, not profiling the escape sequences.

So yes, it's trivial to scan for stuff in dmesg, but it's much less
trivial to find the cases where some /proc entry only has %p reports
under certain runtime conditions. (e.g. print the allocation address
of a pending wifi association timer or something: visible only during
a brief window, and something not obvious to a casual scan of /proc
entry contents, but an attacker might be able to influence and peek
at.)

I'm also fine with eliminating the use of %p in source, but that's a
serious game of whack-a-mole, and I don't think it scales. So, yeah,
while I do like the %p-hash idea, I remain concerned that we'll just
have this whole discussion again in a few years, trying to figure out
what to do about the now heavily-used %x.

Is the correct path to:
- unconditionally convert %p to reporting a 32-bit hash
- actively start removing as much %p use as possible
- do something to discourage %x on pointers (checkpatch.pl?)

Can we do something more about %x?

Do we want to remove %pK also?

-Kees

-- 
Kees Cook
Pixel Security
