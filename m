Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 23 Mar 2012 00:46:27 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20120320172300.GA8888@gmail.com>
Message-ID: <alpine.LFD.2.02.1203230043470.2542@ionos>
References: <20120319231253.GA20893@www.outflux.net> <20120320133141.GC2918@peqn> <alpine.LFD.2.02.1203201758220.2542@ionos> <CAGXu5jKVx41+NSEWsw0YF74z5_heSQ6GOmkuDi1DXNPcO4sjTQ@mail.gmail.com> <20120320172300.GA8888@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH] futex: do not leak robust list to unprivileged process
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Serge Hallyn <serge.hallyn@canonical.com>, LKML <linux-kernel@vger.kernel.org>, Darren Hart <dvhart@linux.intel.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, "Eric W. Biederman" <ebiederm@xmission.com>, David Howells <dhowells@redhat.com>, kernel-hardening@lists.openwall.com, spender@grsecurity.net
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 20 Mar 2012, Ingo Molnar wrote:
> * Kees Cook <keescook@chromium.org> wrote:
> > On Tue, Mar 20, 2012 at 10:02 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > > I really wonder why we have this syscall at all.
> > 
> > The documentation I found yesterday while looking at this was: 
> > http://linux.die.net/man/2/get_robust_list
> > 
> > Which says "The system call is only available for debugging 
> > purposes and is not needed for normal operations. Both system 
> > calls are not available to application programs as functions; 
> > they can be called using the syscall(3) function."
> > 
> > Dropping the syscall entirely would certainly make it secure. 
> > ;)
> 
> The thinking was API completeness. In general it's possible for 
> a sufficiently privileged task to figure out all the state of a 
> task. We can query timers, fds - the robust list is such a 
> resource as well. The information leakage was obviously not 
> intended.

So I think it's safe to take Kees' patch as is. On top of that we
should add a WARN_ONCE when the syscall is invoked and schedule the
sucker for removal.

Thoughts ?

	 tglx
