Date: Mon, 13 Nov 2017 17:08:07 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171113060807.GK11398@eros>
References: <1510050731-32446-1-git-send-email-me@tobin.cc>
 <1510322194.19812.3.camel@gmail.com>
 <20171112222119.GL19752@eros>
 <1510551988.30178.10.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1510551988.30178.10.camel@gmail.com>
Subject: Re: [kernel-hardening] [PATCH v4] scripts: add leaking_addresses.pl
To: kaiwan.billimoria@gmail.com
Cc: kernel-hardening@lists.openwall.com, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 13, 2017 at 11:16:28AM +0530, kaiwan.billimoria@gmail.com wrote:
> On Mon, 2017-11-13 at 09:21 +1100, Tobin C. Harding wrote:
> > On Fri, Nov 10, 2017 at 07:26:34PM +0530, kaiwan.billimoria@gmail.com
> >  wrote:
> > > On Tue, 2017-11-07 at 21:32 +1100, Tobin C. Harding wrote:
> > > > Currently we are leaking addresses from the kernel to user space.
> > > > This
> > > > script is an attempt to find some of those leakages. Script
> > > > parses
> > > > `dmesg` output and /proc and /sys files for hex strings that look
> > > > like
> > > > kernel addresses.
> > > > 
> > > > Only works for 64 bit kernels, the reason being that kernel
> > > > addresses
> > > > on 64 bit kernels have 'ffff' as the leading bit pattern making
> > > > greping
> > > > possible. On 32 kernels we don't have this luxury.
> > > 
> > > Tobin C. Harding <me@tobin.cc> wrote:
> > > > Only works for 64 bit kernels, the reason being that kernel
> > > > addresses
> > > > on 64 bit kernels have 'ffff' as the leading bit pattern making
> > > > greping
> > > > possible. On 32 kernels we don't have this luxury.
> > > 
> > > [RFC] leaking_addresses.pl - enhance it to work for 32-bit kernels
> > > as well
> > > 
> > > (Firstly, apologies if I've got the protocol horribly wrong- should
> > > this
> > > be a new thread altogether?)
> > 
> > I think this patch will need to wait until the patch set that is
> > currently in flight is either merged or dropped.
> > 
> Thanks for looking at it!
> Okay; blocking on merge || drop...  :-)

So, Linus has requested that I set up a tree for the development of
this. I have to work out the details of how to do that and then I'll
email you so you can get the pull the current version. I can then take
your patch via LKML as per usual.

> > We can work this out pragmatically, Perl can give us an architecture
> > string then a few regexs can ascertain which architecture we are
> > running
> > on. This is in the inflight patch set. 
> > 
> > > The patch below does Not take into account (yet) stuff like:
> > >  - exactly which files & dirs should be skipped on 32-bit (will it
> > > be
> > > identical to 64-bit?; unsure..)
> > 
> > As per discussion later in this thread we may need to consider
> > architecture specific lists for files/directories to skip. 
> Right
> > 
> > >  - it currently hard-codes a global 'PAGE_OFFSET_32BIT=0xc0000000'
> > > , just
> > >  so I can test quickly; must figure whether to query it or pass it;
> > >  Suggestions?
> > 
> > Perhaps we should have a command line option for this.
> > 
> > 	--kernel-base-address
> 
> Why not just detect it programatically? We could devise a series of
> fallbacks; something like:
> - if .config exists in the kernel source tree root, grep it for
> PAGE_OFFSET
> - if not, grep the arch-specific (arch/<arch>/configs/<config-file>)
> for the same
> - if for some reason we don't have enough info regarding specific
> platform and thus the defconfig filename (could happen for ARM, PPC?),
> we then fail and request the user to pass it as a parameter.
> 
> > >  - the 'false positives'; again, what differs for 32-bit?

Sounds good to me.

thanks,
Tobin.
