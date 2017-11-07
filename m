Date: Tue, 7 Nov 2017 17:44:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
Message-ID: <20171107174413.00e51a3f@gandalf.local.home>
In-Reply-To: <CA+55aFw-GgR7DmXsD1dmYWbxuVhg+u0oKwuwNEM4RnuVyA0NDw@mail.gmail.com>
References: <1509945567-11801-1-git-send-email-me@tobin.cc>
	<CA+55aFzPeCuvjscBNj6ANzfRUDsjT6Ntn9Grr915CrSpOfNSnA@mail.gmail.com>
	<CAGXu5j+o6cf0PrnxD+W+09F7UY6JL+h7Bn5_4T2C0Z_fTZAx-w@mail.gmail.com>
	<CA+55aFw-GgR7DmXsD1dmYWbxuVhg+u0oKwuwNEM4RnuVyA0NDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v3] scripts: add leaking_addresses.pl
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, "Tobin C. Harding" <me@tobin.cc>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Joe Perches <joe@perches.com>, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William
 C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 7 Nov 2017 13:44:01 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > Looking other places that stand out, it seems like
> > /proc/lockdep_chains and /proc/lockdep (CONFIG_LOCKDEP=y) has a ton of
> > %p usage. It's unclear to me if a hash is sufficient for meaningful
> > debugging there?  
> 
> Maybe not, but that is also _so_ esoteric that I suspect the right fix
> is to just make it root-only readable.

Also note, I don't believe anyone should be running a LOCKDEP
configured kernel in a production (secured) environment. As it adds
quite a bit of overhead. It's something you run on test environments to
make sure it doesn't detect any possible deadlocks.

> 
> I've never used it, we should check with people who have. I get the
> feeling that this is purely for PeterZ debugging.

I've used it. But then again, I also debug lockdep ;-)

> 
> The very first commit that introduced that code actually has a
> 
>     (FIXME: should go into debugfs)
> 
> so I suspect it never should have been user-readable to begin with. I
> guess it makes some things easier, but it really is *very* different
> from things like profiling.

Want me to whip up a patch to move the file?

-- Steve

> 
> Profiling you often *cannot* do as root - some things you profile
> really shouldn't be run as root, and might even refuse to do so. So
> requiring you to be root just to get a kernel profile is very bad.
> 
> But looking at lockdep stats? Yeah, 'sudo' isn't so big of a deal.
> 
> 
