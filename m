Date: Thu, 9 Nov 2017 16:45:48 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171109054548.GF19752@eros>
References: <1510192229-20038-1-git-send-email-me@tobin.cc>
 <20171108223555.52c01531@vmware.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171108223555.52c01531@vmware.local.home>
Subject: [kernel-hardening] Re: [PATCH] kallsyms: don't leak address when printing symbol
To: Steven Rostedt <rostedt@goodmis.org>
Cc: kernel-hardening@lists.openwall.com, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts,
 William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wil.deacon@arm.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, David Miller <davem@davemloft.net>, Network Development <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Nov 08, 2017 at 10:35:55PM -0500, Steven Rostedt wrote:
> On Thu,  9 Nov 2017 12:50:29 +1100
> "Tobin C. Harding" <me@tobin.cc> wrote:
> 
> > Currently if a pointer is printed using %p[ssB] and the symbol is not
> > found (kallsyms_lookup() fails) then we print the actual address. This
> > leaks kernel addresses. We should instead print something _safe_.
> > 
> > Print "<no-symbol>" instead of kernel address.
> 
> Ug, ftrace requires this to work as is, as it uses it to print some
> addresses that may or may not be a symbol.
> 
> If anything, can this return a success or failure if it were to find a
> symbol or not, and then something like ftrace could decide to use %x if
> it does not.

Thanks for the feed back Steve. Propagating the error back up through
the call chain may require a little bit of thought so we don't upset the
apple cart. sprint_symbol() never currently (as far as I can see)
returns an error. I can go through the other callers of sprint_symbol()
(there aren't many) and check if it is going to upset anything.

> And yes, ftrace leaks kernel addresses all over the place, that's just
> the nature of tracing the kernel.

Would it be good for you (for this change and future changes aimed at
closing leaks) if any changes like this include patches to ftrace to
maintain the current behaviour?

You have been on the CC list for the printk hashing and what not since
the start I believe so you know I'm a noob, feel free to scream bloody
murder if I'm breaching protocol.

thanks,
Tobin.
