Date: Wed, 1 Nov 2017 10:35:33 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171031233533.GD3585@eros>
References: <1508986436-31966-1-git-send-email-me@tobin.cc>
 <20171027133301.GA612@tigerII.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171027133301.GA612@tigerII.localdomain>
Subject: [kernel-hardening] Re: [PATCH V8 0/2] printk: hash addresses printed with %p
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: kernel-hardening@lists.openwall.com, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Oct 27, 2017 at 10:33:01PM +0900, Sergey Senozhatsky wrote:
> On (10/26/17 13:53), Tobin C. Harding wrote:
> > Currently there are many places in the kernel where addresses are being
> > printed using an unadorned %p. Kernel pointers should be printed using
> > %pK allowing some control via the kptr_restrict sysctl. Exposing
> > addresses gives attackers sensitive information about the kernel layout
> > in memory.
> > 
> > We can reduce the attack surface by hashing all addresses printed with
> > %p. This will of course break some users, forcing code printing needed
> > addresses to be updated.
> > 
> > With this version we include hashing of malformed specifiers also.
> > Malformed specifiers include incomplete (e.g %pi) and also non-existent
> > specifiers. checkpatch should warn for non-existent specifiers but
> > AFAICT won't warn for incomplete specifiers.
> > 
> > Here is the behaviour that this set implements.
> > 
> > For kpt_restrict==0
> > 
> > Randomness not ready:
> >   printed with %p: 		(pointer)          # NOTE: with padding
> > Valid pointer:
> >   printed with %pK: 		deadbeefdeadbeef
> >   printed with %p: 		0xdeadbeef
> >   malformed specifier (eg %i):  0xdeadbeef
> > NULL pointer:
> >   printed with %pK: 		0000000000000000
> >   printed with %p: 		(null)               # NOTE: no padding
> >   malformed specifier (eg %i):  (null)
> 
> a quick question:
>  do we care about cases when kernel pointers are printed with %x/%X and
>  not with %p?

Yes. The question has been raised will we be here again in 6 years time
trying to fix all the uses of %x. And there are already 29K uses of
%[xX] in tree, which of these are leaking addresses? This is why Linus'
has commented that really effort should be directed at finding the leaks
as they happen (in procfs, sysfs, dmesg) instead of fixing this in
the code. So far I haven't been able to come up with any meaningful way
to do this on 32 bit machines. There is a patch adding a script to catch
leaks on 64 bit machines in flight.

This patch needs to be a small part of a continued effort to stop the
leaks if we want to have any hope of stopping them.

If you have any suggestions on dealing with %x please do say. We have
code changes, compiler warnings, and checkpatch - none of which
immediately seem great.

thanks,
Tobin.
