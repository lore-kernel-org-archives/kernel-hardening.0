Message-ID: <1507159277.1273.43.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Wed, 04 Oct 2017 19:21:17 -0400
In-Reply-To: <476DC76E7D1DF2438D32BFADF679FC563EAF4F29@ORSMSX103.amr.corp.intel.com>
References: <1506816410-10230-1-git-send-email-me@tobin.cc>
	 <CA+55aFxzD=+H_M+Sg_8YRf-JYV-+-yn1c=dFhJWFzSh5yWt9Gg@mail.gmail.com>
	 <ArOl6I7GkZ912O0tP7uFPe5JRJTftclvQHVtSHw0hsmxk5IJXexp9M3zQPefcGCXcx27lzX7A1s74XFa9gXEA5yRA5hC1BaNqhD7QgN3JRo=@protonmail.ch>
	 <CA+55aFzGsRFPtMFRv3G0FPNs6YAD3S2U94o58Lgg1MnmHwCxvA@mail.gmail.com>
	 <476DC76E7D1DF2438D32BFADF679FC563EAF4F29@ORSMSX103.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [RFC V2 0/6] add more kernel pointer filter
 options
To: "Roberts, William C" <william.c.roberts@intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Jordan Glover <Golden_Miller83@protonmail.ch>
Cc: "Tobin C. Harding" <me@tobin.cc>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 2017-10-04 at 21:58 +0000, Roberts, William C wrote:
> > -----Original Message-----
> > From: linus971@gmail.com [mailto:linus971@gmail.com] On Behalf Of
> > Linus
> > Torvalds
> > Sent: Wednesday, October 4, 2017 12:19 PM
> > To: Jordan Glover <Golden_Miller83@protonmail.ch>
> > Cc: Tobin C. Harding <me@tobin.cc>; Greg KH <gregkh@linuxfoundation.
> > org>;
> > Petr Mladek <pmladek@suse.com>; Joe Perches <joe@perches.com>; Ian
> > Campbell <ijc@hellion.org.uk>; Sergey Senozhatsky
> > <sergey.senozhatsky@gmail.com>; kernel-hardening@lists.openwall.com;
> > Catalin Marinas <catalin.marinas@arm.com>; Will Deacon
> > <will.deacon@arm.com>; Steven Rostedt <rostedt@goodmis.org>;
> > Roberts,
> > William C <william.c.roberts@intel.com>; Chris Fries <cfries@google.
> > com>; Dave
> > Weinstein <olorin@google.com>
> > Subject: Re: [kernel-hardening] [RFC V2 0/6] add more kernel pointer
> > filter
> > options
> > 
> > On Wed, Oct 4, 2017 at 11:58 AM, Jordan Glover
> > <Golden_Miller83@protonmail.ch> wrote:
> > > If we knew where those leaks are hiding they will be fixed
> > > already.
> > > The only thing we knew is that bugs/leaks are there. It's always
> > > better to just fix all the code but it isn't realistic.
> > 
> > Honestly, what's the difference between setting kptr_restrict to 4
> > and just using
> > a sed-script (or maybe some coccinelle) to remove all existing plain
> > %p users?
> 
> I can already see the hate filled irate response I'll get to this
> statement, thankfully I will
> be away not caring.
> 
> The kernel proper is in a place where it can attempt to defend itself
> against stupidity, either in
> tree or out of tree. Will it stop everything? Obviously not, like you
> said %x or disabling.
> 
> I agree with you 100% kptr restrict is odd, and I don't think anyone
> should have had to opt in to be
> cleansed via kptr_restrict value via %pK. Opt-in never works. One nice
> thing now, is that checkpatch
> has checking of %p usages and warns.
>  
> As far as broken things, I can't comment on desktop systems where I
> think it's harder to make that claim.
> I see value in embedded systems where I am shipping the whole image,
> So I know when/what will
> break.
> 
> If this was in-tree, Android would be setting this to 4 immediately
> FWIW.

It's already shipping on Pixel phones in production as of Android 8.0,
but they didn't pull it into the common kernel LTS branches yet:

https://android.googlesource.com/kernel/msm.git/+/00e1c16fbac282b99a769b939dd215cbdc775ecb%5E%21/#F0

Google backports many KSPP changes to their LTS kernels and they aren't
limiting that to changes that are already upstream. It can all just be
dropped without impacting app compatibility so it doesn't matter if the
finalized upstream approach ends up being different.

It's a similar situation to perf_event_paranoid=3 which is mandatory for
all Android devices since the August 2016 security patch despite being
rejected upstream. There's a test checking for it and integration into
the profiling tools which know how to turn it back down via the USB
debugging shell (ADB). Debian had perf_event_paranoid=3 even earlier so
it's on the vast majority of Linux devices already.

They just end up being permanent downstream patches if they're rejected
without providing an alternative on par with it.
