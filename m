Date: Fri, 1 Dec 2017 15:15:26 +0900
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Message-ID: <20171201061526.GA482@jagdpanzerIV>
References: <1511921105-3647-1-git-send-email-me@tobin.cc>
 <20171129152040.ed5b28c198093de8968aac9b@linux-foundation.org>
 <28ab447e24684c58a5e03af44edd6d5a@AcuMS.aculab.com>
 <20171130102638.GA434@jagdpanzerIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171130102638.GA434@jagdpanzerIV>
Subject: [kernel-hardening] Re: [PATCH V11 0/5] hash addresses printed with %p
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: David Laight <David.Laight@ACULAB.COM>, 'Andrew Morton' <akpm@linux-foundation.org>, "Tobin C. Harding" <me@tobin.cc>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, Radim =?iso-8859-1?Q?Krcm=E1r?= <rkrcmar@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On (11/30/17 19:26), Sergey Senozhatsky wrote:
> On (11/30/17 10:23), David Laight wrote:
> [..]
> > > Maybe I'm being thick, but...  if we're rendering these addresses
> > > unusable by hashing them, why not just print something like
> > > "<obscured>" in their place?  That loses the uniqueness thing but I
> > > wonder how valuable that is in practice?
> > 
> > My worry is that is you get a kernel 'oops' print with actual register
> > values you have no easy way of tying an address or address+offset to
> > the corresponding hash(address) printed elsewhere.
> 
> print the existing hash:pointer mappings in panic()? [if we can do that]

by this I meant
	"when oops_in_progress == 1 then print hash:pointer for %p,
	 not just hash".

	-ss
