MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CA+55aFy58SHOCbJWtzB94PuT0d9UmdJ8QUZt+MjDYL9qbdfxbw@mail.gmail.com>
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
 <476DC76E7D1DF2438D32BFADF679FC563F4AF1B4@ORSMSX115.amr.corp.intel.com> <CA+55aFy58SHOCbJWtzB94PuT0d9UmdJ8QUZt+MjDYL9qbdfxbw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 13 Oct 2017 12:34:30 -0700
Message-ID: <CAGXu5jJns_OogyXTwZ7crasCuOSAZMkiLN6c0=y8bGpsP1YNTg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [RFC V2 0/6] add more kernel pointer filter options
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Roberts, William C" <william.c.roberts@intel.com>, Theodore Ts'o <tytso@mit.edu>, "Tobin C. Harding" <me@tobin.cc>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Oct 13, 2017 at 11:11 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Oct 13, 2017 at 9:32 AM, Roberts, William C
> <william.c.roberts@intel.com> wrote:
>>
>> I don't particularly hate this idea, and I actually discussed this before with others (not on the list)
>> before approaching it using kptr_restrict. The argument that we had against this approach was
>> that it would push people away from using %p and make it even that much harder to audit.
>
> So I think kptr_restrict was worth trying. I'm not saying it was a bad
> idea when it was introduced.
>
> It's just that it's six years later, we now have the knowledge that
> opt-in doesn't work for this (either), and that we should just admit
> that it didn't work very well.
>
> And even as a "failure", the global flag may well work fine for soem
> uses (ie Android), largely because hardly anybody actually _develops_
> using Android. So it may not have been a failure in that sense, and
> for all I know the Android use-case really sees it as a huge success
> (and extending on it there would have made sense).

That's precisely where this comes from: the original patches from
Tobin (and Greg) were trying to make this extension, based on the work
done in the Android kernels (which was based on work by William, etc).

>> I settled on using kptr_restrict for the ability to enable/disable. One of the use cases
>> we had was that a driver is found to be doing this silly thing, and an admin/user wants
>> to turn it off in dmesg until its fixed.
>
> Hopefully just making %p print out a hash will fix the silly things.

I'm unable to tell if you're universally opposed to a global flag, or
if you're acknowledging that it has use in certain environments.

I get the sense that unconditionally censoring (either through
omission or a hash) of %p will likely drive people to using %x, and
that'll be really hard to audit. (I suppose it'd be possible to build
a compiler plugin that would look for %x uses where the format
argument was cast from a pointer type, but it seems like it'd be best
to avoid even needing such things.)

Having a global flag for censorship of %p means the developer case can
be left unchanged (meaning less migration to %x). Or were you
suggesting a global flag that controls the censorship level (e.g.
something like "none", "hash", "all zero")?

-Kees

-- 
Kees Cook
Pixel Security
