Date: Wed, 29 Nov 2017 06:54:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
Message-ID: <20171129065425.361903fc@gandalf.local.home>
In-Reply-To: <20171129042746.GF15500@eros>
References: <1511921105-3647-1-git-send-email-me@tobin.cc>
	<1511921105-3647-3-git-send-email-me@tobin.cc>
	<20171128213957.2edf5069@gandalf.local.home>
	<20171129042746.GF15500@eros>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH V11 2/5] vsprintf: refactor %pK code out of pointer()
To: "Tobin C. Harding" <me@tobin.cc>
Cc: kernel-hardening@lists.openwall.com, Linus Torvalds <torvalds@linux-foundation.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts,
 William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 29 Nov 2017 15:27:46 +1100
"Tobin C. Harding" <me@tobin.cc> wrote:

> On Tue, Nov 28, 2017 at 09:39:57PM -0500, Steven Rostedt wrote:
> > On Wed, 29 Nov 2017 13:05:02 +1100
> > "Tobin C. Harding" <me@tobin.cc> wrote:
> >   
> > > +		/*
> > > +		 * kptr_restrict==1 cannot be used in IRQ context
> > > +		 * because its test for CAP_SYSLOG would be meaningless.
> > > +		 */
> > > +		if (in_irq() || in_serving_softirq() || in_nmi())  
> > 
> > This could be replaced with:
> > 
> > 		if (!in_task())
> > 
> > Which is actually more efficient.  
> 
> thanks for the comment Steve. At this late stage in the game do you mind
> if I don't include this change in this set. The code line in question is
> only in the series because of refactoring. I'm comfortable arguing that
> improving efficiency is out of scope ;)

No problem. In fact, I can send this as a separate patch myself, on top
of your series.

-- Steve
