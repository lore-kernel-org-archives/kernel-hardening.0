Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Tue, 9 May 2017 08:45:22 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20170509064522.anusoikaalvlux3w@gmail.com>
References: <20170428153213.137279-1-thgarnie@google.com>
 <CAJcbSZGQsRVg3QZ9QfLn2HBC+RP-7fUTab0bYDJ455d8y8GyNw@mail.gmail.com>
 <20170508073352.caqe3fqf7nuxypgi@gmail.com>
 <20170508124621.GA20705@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170508124621.GA20705@kroah.com>
Subject: Re: [kernel-hardening] Re: [PATCH v9 1/4] syscalls: Verify address
 limit before returning to user-mode
To: Greg KH <greg@kroah.com>
Cc: Thomas Garnier <thgarnie@google.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, David Howells <dhowells@redhat.com>, =?iso-8859-1?Q?Ren=E9?= Nyffenegger <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Kees Cook <keescook@chromium.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Russell King <linux@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, linux-s390 <linux-s390@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, linux-arm-kernel@lists.infradead.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
List-ID: <kernel-hardening.lists.openwall.com>


* Greg KH <greg@kroah.com> wrote:

> What about a simple coccinelle script to test for this type of thing?
> We write it once, add it to the in-kernel body of tests, and then 0-day
> runs it on all trees all the time.  That should catch this type of
> issue, like all of the other "bad programming bus" that the tool
> currently catches.

Yeah, that would work - but today most of our coccinelle scripts are still pretty 
verbose, and I think it's important to make this a different category of 
coccinelle script, which is .config driven where a loud warning yells at us.

I.e. force the 'zero warnings tolerated' model.

I also noticed that Coccinelle builds are pretty slow, so it would still make 
sense to have a performance oriented static checking facility that does not have 
the performance baggage of high level functional languages.

I.e. either integrate it into Sparse - or start a kernel integrated static 
analysis tooling project that would only follow control flow initially - which is 
what we need here I believe.

We only have ~115 code blocks in the kernel that set/restore KERNEL_DS, it would 
be a pity to add a runtime check to every system call ...

We could also add a runtime check to oops handling to make sure we don't leak 
KERNEL_DS through kernel crashes, to ease worries about CVE-2010-4258.

Thanks,

	Ingo
