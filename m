Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Fri, 28 Apr 2017 08:33:23 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20170428063323.ntnc4tk7do2dor76@gmail.com>
References: <20170426183425.32158-1-thgarnie@google.com>
 <20170427064917.phwo6yl4v4q43fql@gmail.com>
 <CAJcbSZENjCgn3TNDGzCBBSOXMvbTX8mBO7Trugdb5VRzhxwmHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJcbSZENjCgn3TNDGzCBBSOXMvbTX8mBO7Trugdb5VRzhxwmHg@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v8 1/4] syscalls: Verify address limit before returning
 to user-mode
To: Thomas Garnier <thgarnie@google.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, =?iso-8859-1?Q?Ren=E9?= Nyffenegger <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Kees Cook <keescook@chromium.org>, Rik van Riel <riel@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Russell King <linux@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, linux-s390 <linux-s390@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, linux-arm-kernel@lists.infradead.org, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


* Thomas Garnier <thgarnie@google.com> wrote:

> > BTW., a further simplification would be:
> >
> > #ifndef ADDR_LIMIT_CHECK_PRE
> > # define ADDR_LIMIT_CHECK_PRE ...
> > #endif
> >
> > This way architectures could override this generic functionality simply by
> > defining the helpers. Architectures that don't do that get the generic version.
> 
> I don't think architectures need to do that. The optimizations are
> embedding the checks on their architecture-specific code to make it
> faster and remove the size impact. The pre/post is fine for the rest.

Indeed, only the generic code needs to turn off that code - architectures will 
place these callbacks elsewhere.

Thanks,

	Ingo
