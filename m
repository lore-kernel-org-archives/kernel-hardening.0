MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CAGXu5jJns_OogyXTwZ7crasCuOSAZMkiLN6c0=y8bGpsP1YNTg@mail.gmail.com>
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
 <CA+55aFy58SHOCbJWtzB94PuT0d9UmdJ8QUZt+MjDYL9qbdfxbw@mail.gmail.com> <CAGXu5jJns_OogyXTwZ7crasCuOSAZMkiLN6c0=y8bGpsP1YNTg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Oct 2017 13:22:56 -0700
Message-ID: <CA+55aFxZo5kZEiZFYj5mns3Tsgb0JLC_rae2ThObeM5xrC8Mug@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [RFC V2 0/6] add more kernel pointer filter options
To: Kees Cook <keescook@chromium.org>
Cc: "Roberts, William C" <william.c.roberts@intel.com>, Theodore Ts'o <tytso@mit.edu>, "Tobin C. Harding" <me@tobin.cc>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Oct 13, 2017 at 12:34 PM, Kees Cook <keescook@chromium.org> wrote:
> On Fri, Oct 13, 2017 at 11:11 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> And even as a "failure", the global flag may well work fine for soem
>> uses (ie Android), largely because hardly anybody actually _develops_
>> using Android. So it may not have been a failure in that sense, and
>> for all I know the Android use-case really sees it as a huge success
>> (and extending on it there would have made sense).
>
> That's precisely where this comes from: the original patches from
> Tobin (and Greg) were trying to make this extension, based on the work
> done in the Android kernels (which was based on work by William, etc).

Yes, but what I want so-called "security" people and Andoid people to
acknowledge is that it was

 (a) a hack

 (b) not actually real security

 (c) didn't actually help long-term development at all, and in fact
likely held real improvements *back* because it was "whatever, we
don't have a problem".

It's security theater. Particularly with the opt-in, it was never
anything more. There are _very_ few %pK users in the kernel, and those
that are there could generally have been just removed entirely, or
have been made to check the flag _locally_ instead of globally, and
been made better in the process.

The new extension that raised kptr_restrict to 4 was just more of the
same. It was in no way real security. It's exactly the same as the TSA
"advisory system" color coding.

Do you seriously believe that color coded threat levels were a good
thing? The whole "kptr_restrict=4" is exactly the same thing as the
TSA "threat level red". It's a joke. It doesn't actually _fix_
anything.

Guys, it took me five seconds to come up with that

    dmesg | egrep '[0-9a-f]{16}'

pattern, and find several printouts that weren't %pK, and that
wouldn't have been caught by the new "strict" color coding EITHER.

Seriously. It's BS.

It's BS exactly the same way profiling by the TSA is BS. Sure, if you
stop  "brown single male" passengers, you probably will stop
something. But you don't really _fix_ anything.

The "%p" pattern is just the kernel equivalent of "brown single male".
It's not a real security fix, it never has been, and it never will be.
There are probably _more_ places that export physical addresses with
%x than with %pa.

So what I suggested was that we actually look at what the kernel
exports, and we make it easy to just shut _real_ problems down.

The whole "let's make %p print a hashed address" is not the real
security part. That's just the "make it easy to do something secure by
_default_" part. The real security is actually scanning for bad
things, not profiling the escape sequences.

Is "scan for potential actual; leaks" some kind of absolute security?
No. But at least it's not just silly games.

>> Hopefully just making %p print out a hash will fix the silly things.
>
> I'm unable to tell if you're universally opposed to a global flag, or
> if you're acknowledging that it has use in certain environments.

I'm acknowledging that it's a complete hack that may have made sense
in a particular setting, but it's not one that actually fixes any real
security issues, and in particular, it's one that has likely held
people back from doing *real* security.

And as a maintainer of the kernel, to me that "long term actual
development" is a whole lot more important than "silly hack that might
close a random escape or two".

So yes, I'm actually opposed to the global flag, because we seriously
have 6+ years of reality staring us in the face: it fixed exactly
nothing. It fixed /proc/kallsyms,m but did so _badly_. It fixed a
handful of other places. But it didn't really and truly add any real
security.

Are people really in denial about this? Really?

              Linus
