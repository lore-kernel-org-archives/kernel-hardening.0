Date: Thu, 9 Nov 2017 13:08:57 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171109020857.GC19752@eros>
References: <1510050731-32446-1-git-send-email-me@tobin.cc>
 <87k1z12cof.fsf@concordia.ellerman.id.au>
 <20171108224832.GD27823@eros>
 <87y3ng1djj.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y3ng1djj.fsf@concordia.ellerman.id.au>
Subject: Re: [kernel-hardening] [PATCH v4] scripts: add leaking_addresses.pl
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: kernel-hardening@lists.openwall.com, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 09, 2017 at 11:49:52AM +1100, Michael Ellerman wrote:
> "Tobin C. Harding" <me@tobin.cc> writes:
> 
> > On Wed, Nov 08, 2017 at 11:10:56PM +1100, Michael Ellerman wrote:
> >> "Tobin C. Harding" <me@tobin.cc> writes:
> > [snip]
> >
> > Hi Michael,
> >
> > I'm working an adding support for ppc64 to leaking_addresses.pl, I've
> > added the kernel address regular expression that you suggested.
> 
> Thanks!
> 
> > I'd like to add the false positive for vsyscall addresses. Excuse my
> > ignorance but does PowerPC use a constant address range for vsyscall like x86_64
> > does? The ppc64 machine I have access to does not output anything for
> >
> > 	$ cat /proc/PID/tasks/PID/smaps		or
> > 	$ cat /proc/PID/tasks/PID/maps
> 
> No we only have the vdso style vsyscall, which is mapped at user
> addresses and is subject to ASLR, so you shouldn't need to worry about
> it.

Great. I'll add you to the CC list for the next spin. In line with my
aim of having the most confusing patches to follow the next version will
likely be

[PATCH 0/X v2] scripts/leaking_addresses: add summary report

thanks,
Tobin.
