Date: Mon, 8 May 2017 21:48:58 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Message-ID: <20170508204858.GT29622@ZenIV.linux.org.uk>
References: <20170428153213.137279-1-thgarnie@google.com>
 <CAJcbSZGQsRVg3QZ9QfLn2HBC+RP-7fUTab0bYDJ455d8y8GyNw@mail.gmail.com>
 <20170508073352.caqe3fqf7nuxypgi@gmail.com>
 <CAGXu5jKZRESgGhZ6GEoO784Q1G8V0DPcwM1T2PpyTqvEAsrUdg@mail.gmail.com>
 <20170508140230.23kxf2kfeazeo4zr@gmail.com>
 <CAG48ez0Hz=CimkPwuq903tgJkGj8gXUtiQJJb-P2zUes6bd6Hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez0Hz=CimkPwuq903tgJkGj8gXUtiQJJb-P2zUes6bd6Hw@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Subject: [kernel-hardening] Re: [PATCH v9 1/4] syscalls: Verify address limit before returning
 to user-mode
To: Jann Horn <jannh@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, David Howells <dhowells@redhat.com>, =?iso-8859-1?Q?Ren=E9?= Nyffenegger <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Russell King <linux@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, linux-s390 <linux-s390@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, May 08, 2017 at 04:06:35PM +0200, Jann Horn wrote:

> I think Kees might be talking about
> https://bugs.chromium.org/p/project-zero/issues/detail?id=822, fixed in
> commit e6978e4bf181fb3b5f8cb6f71b4fe30fbf1b655c. The issue was that
> perf code that can run in pretty much any context called access_ok().

And that commit has *NOT* solved the problem.  perf_callchain_user()
can be called synchronously, without passing through that code.
Tracepoint shite...

That set_fs() should be done in get_perf_callchain(), just around the call of
perf_callchain_user().  Along with pagefault_disable(), actually.

BTW, that's a nice example demonstrating why doing that on the kernel
boundary is wrong.  Wider (in theory) area being "protected" => easier
to miss the ways not crossing its border.
