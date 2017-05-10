Date: Tue, 9 May 2017 23:46:55 -0700
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20170510064655.GA4115@infradead.org>
References: <20170428153213.137279-1-thgarnie@google.com>
 <CAJcbSZGQsRVg3QZ9QfLn2HBC+RP-7fUTab0bYDJ455d8y8GyNw@mail.gmail.com>
 <20170508073352.caqe3fqf7nuxypgi@gmail.com>
 <20170508124621.GA20705@kroah.com>
 <20170509064522.anusoikaalvlux3w@gmail.com>
 <20170509085659.GA32555@infradead.org>
 <CALCETrUh8NO2scaqEM48K70Fo2+V3=Cpyk4JurCDiCYp4nm_+g@mail.gmail.com>
 <20170509130250.GA11381@infradead.org>
 <20170509160322.GA15902@infradead.org>
 <CAGXu5jKHVMRMKDfn+=kkbm+JkWPhoEtDwKx=QXAYxg1p9bn7PQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKHVMRMKDfn+=kkbm+JkWPhoEtDwKx=QXAYxg1p9bn7PQ@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [PATCH v9 1/4] syscalls: Verify address
 limit before returning to user-mode
To: Kees Cook <keescook@chromium.org>
Cc: Christoph Hellwig <hch@infradead.org>, Andy Lutomirski <luto@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Greg KH <greg@kroah.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Dave Hansen <dave.hansen@intel.com>, "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-s390 <linux-s390@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Russell King <linux@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, =?iso-8859-1?Q?Ren=E9?= Nyffenegger <mail@renenyffenegger.ch>, Catalin Marinas <catalin.marinas@arm.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Rik van Riel <riel@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Brian Gerst <brgerst@gmail.com>, Borislav Petkov <bp@alien8.de>, Josh Poimboeuf <jpoimboe@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Linux API <linux-api@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, James Morse <james.morse@arm.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Garnier <thgarnie@google.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, May 09, 2017 at 09:50:32AM -0700, Kees Cook wrote:
> http://git.infradead.org/users/hch/vfs.git/commitdiff/018e0e9030777121fe87e89d43066691e7366587
> This accidentally(?) removes the kernel-doc comments.

That was sort of intentional, the kerneldoc boilerplate adds very little
value for method instances.

> http://git.infradead.org/users/hch/vfs.git/commitdiff/78b62c730254fc39fa888cdbdca08fde6e09a798
> Could this be made defensive? (Return 0 if ret wraps, for example?) I
> see what the comment says, but not everyone will read that. :(

It's a straight copy of iov_length, and I'd rather keep it that way.
