Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Tue, 9 May 2017 08:34:04 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20170509063404.pngn4otdmbbrvou3@gmail.com>
References: <20170428153213.137279-1-thgarnie@google.com>
 <CAJcbSZGQsRVg3QZ9QfLn2HBC+RP-7fUTab0bYDJ455d8y8GyNw@mail.gmail.com>
 <20170508073352.caqe3fqf7nuxypgi@gmail.com>
 <CAGXu5jKZRESgGhZ6GEoO784Q1G8V0DPcwM1T2PpyTqvEAsrUdg@mail.gmail.com>
 <20170508140230.23kxf2kfeazeo4zr@gmail.com>
 <CAGXu5jJ4iY7QZ9wRu5dmm7RHtLh_V6TQh4huWwLCYPKOr63aiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJ4iY7QZ9wRu5dmm7RHtLh_V6TQh4huWwLCYPKOr63aiA@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v9 1/4] syscalls: Verify address limit before returning
 to user-mode
To: Kees Cook <keescook@chromium.org>
Cc: Thomas Garnier <thgarnie@google.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, David Howells <dhowells@redhat.com>, =?iso-8859-1?Q?Ren=E9?= Nyffenegger <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Russell King <linux@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, linux-s390 <linux-s390@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
List-ID: <kernel-hardening.lists.openwall.com>


* Kees Cook <keescook@chromium.org> wrote:

> On Mon, May 8, 2017 at 7:02 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > * Kees Cook <keescook@chromium.org> wrote:
> >
> >> > And yes, I realize that there were other such bugs and that such bugs might
> >> > occur in the future - but why not push the overhead of the security check to
> >> > the kernel build phase? I.e. I'm wondering how well we could do static
> >> > analysis during kernel build - would a limited mode of Sparse be good enough
> >> > for that? Or we could add a new static checker to tools/, built from first
> >> > principles and used primarily for extended syntactical checking.
> >>
> >> Static analysis is just not going to cover all cases. We've had vulnerabilities
> >> where interrupt handlers left KERNEL_DS set, for example. [...]
> >
> > Got any commit ID of that bug - was it because a function executed by the
> > interrupt handler leaked KERNEL_DS?
> 
> Ah, it was an exception handler, but the one I was thinking of was this:
> https://lwn.net/Articles/419141/

Ok, so that's CVE-2010-4258, where an oops with KERNEL_DS set was used to escalate 
privileges, due to the kernel's oops handler not cleaning up the KERNEL_DS. The 
exploit used another bug, a crash in a network protocol handler, to execute the 
oops handler with KERNEL_DS set.

The explanation of the exploit itself points out that it's a very interesting bug 
and I agree, it's not a general kernel bug but a bug in a very narrow code path 
(oops handling) that caused this, and I don't see how that example can be turned 
into a general example: it was a bug in oops handling to let the process continue 
execution (and perform the CLEARTID operation) *and* leak the address limit at 
KERNEL_DS.

By similar argument a bug in the runtime checking of the address limit may allow 
exploits. Consider the oops path cleanup a similarly sensitive code path as the 
address limit check.

To handle this category of exploits it would be enough to add a runtime check to 
the _oops handling code itself_ (to make sure we've set addr_limit back to USER_DS 
even if we crash in a KERNEL_DS code area), not to every system call!

That check would avoid that particular historic pattern, if combined with static 
analysis that ensured that KERNEL_DS is always set/restored correctly. (Which btw. 
I believe some of the regular static scans of the kernel are already doing today.)

Furthermore, to go back to your original argument:

> Static analysis is just not going to cover all cases.

it's not even true that a runtime check will 'cover all cases': for example a 
similar bug to CVE-2010-4258 could still be exploited:

 - Note that the actual put_user() was not prevented via the runtime check - the
   runtime check would run *after* the buggy put_user() was done. The runtime 
   check warns or panics after the fact, which might (or might not) be enough to 
   prevent the exploit.

 - Also note that a slightly different form of the bug would still be exploitable, 
   even with the runtime check: for example if the task-shutdown code can be made 
   to unconditionally set KERNEL_DS, but after the put_user(), then the runtime
   check would not 'cover all cases'.

So the argument for doing this runtime check after every system call is very 
dubious.

Thanks,

	Ingo
