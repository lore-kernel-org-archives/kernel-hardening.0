Date: Fri, 12 May 2017 23:57:55 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Message-ID: <20170512225755.GU390@ZenIV.linux.org.uk>
References: <CAGXu5j+EatK=DYONRkgovwLgytAnbG8jnAZaMSLckZFNVj3gig@mail.gmail.com>
 <20170512075458.09a3a1ce@mschwideX1>
 <CAGXu5jL9vUrn4kpjO+qa4cHmWBypeqP17OGbrMs=5Nz0YpQMZw@mail.gmail.com>
 <CA+55aFzbiBqsYb7vwO=+L4Vp_GOgPu+DBOrq4fBnyzq5DbBehg@mail.gmail.com>
 <CAGXu5j+xmyJ6RhtPw9rUgs7k3sZ1KKWffvyGGG--oPfu9W42ng@mail.gmail.com>
 <20170512202106.GO22219@n2100.armlinux.org.uk>
 <20170512210645.GS390@ZenIV.linux.org.uk>
 <CAGXu5jJu=VTqp2tzkPB4RAVxdGC+_SSQwrUwdzWpu24AA-zEcg@mail.gmail.com>
 <20170512214144.GT390@ZenIV.linux.org.uk>
 <1494625675.29205.21.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1494625675.29205.21.camel@redhat.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [kernel-hardening] Re: [PATCH v9 1/4] syscalls: Verify address
 limit before returning to user-mode
To: Rik van Riel <riel@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Russell King - ARM Linux <linux@armlinux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Mark Rutland <mark.rutland@arm.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Greg KH <greg@kroah.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Dave Hansen <dave.hansen@intel.com>, "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, linux-s390 <linux-s390@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Will Deacon <will.deacon@arm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, =?iso-8859-1?Q?Ren=E9?= Nyffenegger <mail@renenyffenegger.ch>, Catalin Marinas <catalin.marinas@arm.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Arnd Bergmann <arnd@arndb.de>, Brian Gerst <brgerst@gmail.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Linux API <linux-api@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, Daniel Micay <danielmicay@gmail.com>, James Morse <james.morse@arm.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Thomas Garnier <thgarnie@google.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, May 12, 2017 at 05:47:55PM -0400, Rik van Riel wrote:

> > Seriously, look at these beasts.  Overwriting ->addr_limit is nowhere
> > near
> > the top threat.  If attacker can overwrite thread_info, you have
> > lost.
> 
> That is why THREAD_INFO_IN_TASK exists. It moves
> the struct thread_info to a location away from the
> stack, which means a stack overflow will not overwrite
> the thread_info.

... in which case such attacks on ->addr_limit also become a non-issue.

AFAICS, we are mixing several unrelated issues here:
	* amount of places where set_fs() is called.  Sure, reducing it
is a good idea and we want to move to primitives like kernel_write() et.al.
Fewer users => lower odds of screwing it up.
	* making sure that remaining callers are properly paired.  Ditto.
	* switching to ->read_iter()/->write_iter() where it makes sense.
Again, no problem with that.
	* providing sane environment for places like perf/oprofile.  Again,
a good idea, and set_fs(USER_DS) is only a part of what's needed there.
	* switching _everything_ to ->read_iter()/->write_iter().  Flat-out
insane and AFAICS nobody is signing up for that.
	* getting rid of set_fs() entirely.  I'm afraid that it's not feasible
without the previous one and frankly, I don't see much point.
	* sanity-checking on return to userland.  Maybe useful, maybe not.
	* taking thread_info out of the way of stack overflows.  Reasonable,
but has very little to do with the rest of that.
	* protecting against Lovecraftian horrors slithering in from the outer
space only to commit unspeakable acts against ->addr_limit and ignoring much
tastier targets next to it, but then what do you expect from degenerate
spawn of Great Old Ones - sanity?
