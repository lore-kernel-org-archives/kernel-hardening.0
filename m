Date: Thu, 9 Nov 2017 11:58:14 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171109005814.GG27823@eros>
References: <1510112259-11572-1-git-send-email-me@tobin.cc>
 <1510112259-11572-6-git-send-email-me@tobin.cc>
 <20171108101643.GG2652@pathway.suse.cz>
 <20171108115120.GA2522@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171108115120.GA2522@kroah.com>
Subject: [kernel-hardening] Re: [PATCH 5/7] scripts/leaking_addresses: add emailing results
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Petr Mladek <pmladek@suse.com>, Linus Torvalds <torvalds@linux-foundation.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts,
 William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, kernel-hardening@lists.openwall.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Nov 08, 2017 at 12:51:20PM +0100, Greg KH wrote:
> On Wed, Nov 08, 2017 at 11:16:43AM +0100, Petr Mladek wrote:
> > On Wed 2017-11-08 14:37:37, Tobin C. Harding wrote:
> > > Developers may not have the time (or inclination) to investigate script
> > > output. This information is, however, useful. If we add functionality to
> > > the script to email results for further investigation.
> > > 
> > > Add --send-report flag to email scan results (to Tobin C. Harding).
> > 
> > I am not sure that it is wise to make spaming one person
> > so easy ;-)
> 
> I agree, I would strongly discourage this, as you will end up getting
> reports from really old kernels for the next 20+ years.  We have seen
> that happen for every time we have added a "report this to foo@baz" in a
> kernel log message.
> 
> If you _really_ want to do this, at least point it at a mailing list.

Will remove --send-report for next version.

thanks,
Tobin.
