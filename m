Date: Fri, 12 May 2017 21:45:56 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
Message-ID: <20170512204556.GP22219@n2100.armlinux.org.uk>
References: <CAJcbSZEoRyewUtBHvqmNZL9FtT_q42Vmmd-EuC50x-ZRASiHHg@mail.gmail.com>
 <CA+55aFwvQfs_X+paQF6Luc0Rq+W3J2fKuHRou7=ANcquDdXdDA@mail.gmail.com>
 <20170512072802.5a686f23@mschwideX1>
 <CAGXu5j+EatK=DYONRkgovwLgytAnbG8jnAZaMSLckZFNVj3gig@mail.gmail.com>
 <20170512075458.09a3a1ce@mschwideX1>
 <CAGXu5jL9vUrn4kpjO+qa4cHmWBypeqP17OGbrMs=5Nz0YpQMZw@mail.gmail.com>
 <CA+55aFzbiBqsYb7vwO=+L4Vp_GOgPu+DBOrq4fBnyzq5DbBehg@mail.gmail.com>
 <CAGXu5j+xmyJ6RhtPw9rUgs7k3sZ1KKWffvyGGG--oPfu9W42ng@mail.gmail.com>
 <20170512202106.GO22219@n2100.armlinux.org.uk>
 <20170512203044.GI4626@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170512203044.GI4626@worktop.programming.kicks-ass.net>
Sender: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [kernel-hardening] Re: [PATCH v9 1/4] syscalls: Verify address
 limit before returning to user-mode
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Brian Gerst <brgerst@gmail.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>, Dave Hansen <dave.hansen@intel.com>, "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, linux-s390 <linux-s390@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Christian Borntraeger <borntraeger@de.ibm.com>, =?iso-8859-1?Q?Ren=E9?= Nyffenegger <mail@renenyffenegger.ch>, Greg KH <greg@kroah.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Rik van Riel <riel@redhat.com>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>, Borislav Petkov <bp@alien8.de>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Daniel Micay <danielmicay@gmail.com>, James Morse <james.morse@arm.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Garnier <thgarnie@google.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, May 12, 2017 at 10:30:44PM +0200, Peter Zijlstra wrote:
> On Fri, May 12, 2017 at 09:21:06PM +0100, Russell King - ARM Linux wrote:
> > On Fri, May 12, 2017 at 12:30:02PM -0700, Kees Cook wrote:
> > > I'm clearly not explaining things well enough. I shouldn't say
> > > "corruption", I should say "malicious manipulation". The methodology
> > > of attacks against the stack are quite different from the other kinds
> > > of attacks like use-after-free, heap overflow, etc. Being able to
> > > exhaust the kernel stack (either due to deep recursion or unbounded
> > > alloca())
> > 
> > I really hope we don't have alloca() use in the kernel.  Do you have
> > evidence to support that assertion?
> > 
> > IMHO alloca() (or similar) should not be present in any kernel code
> > because we have a limited stack - we have kmalloc() etc for that kind
> > of thing.
> 
> On stack variable length arrays get implemented by the compiler doing
> alloca(), and we sadly have a few of those around.

I hope their size is appropriately limited, but something tells me it
would be foolish to assume that.

> But yes, fully agreed on the desirability of alloca() and things.

Hmm, I wonder if -fno-builtin-alloca would prevent those... it looks
like it certainly would prevent an explicit alloca() call.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
