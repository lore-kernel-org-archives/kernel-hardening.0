Date: Mon, 20 Nov 2017 16:39:46 +0100
From: Petr Mladek <pmladek@suse.com>
Message-ID: <20171120153946.6ifryf2uk4oorvq5@pathway.suse.cz>
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
Cc: "Tobin C. Harding" <me@tobin.cc>, kernel-hardening@lists.openwall.com, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon 2017-11-13 11:16:28, kaiwan.billimoria@gmail.com wrote:
> On Mon, 2017-11-13 at 09:21 +1100, Tobin C. Harding wrote:
> > On Fri, Nov 10, 2017 at 07:26:34PM +0530, kaiwan.billimoria@gmail.com
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

You might also check /proc/config.gz.

Best Regards,
Petr
