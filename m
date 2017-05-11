MIME-Version: 1.0
In-Reply-To: <20170510081431.GA16610@infradead.org>
References: <20170428153213.137279-1-thgarnie@google.com> <CAJcbSZGQsRVg3QZ9QfLn2HBC+RP-7fUTab0bYDJ455d8y8GyNw@mail.gmail.com>
 <20170508073352.caqe3fqf7nuxypgi@gmail.com> <20170508124621.GA20705@kroah.com>
 <20170509064522.anusoikaalvlux3w@gmail.com> <20170509085659.GA32555@infradead.org>
 <CALCETrUh8NO2scaqEM48K70Fo2+V3=Cpyk4JurCDiCYp4nm_+g@mail.gmail.com>
 <CAK8P3a2j6h2MAx3h2NCtadcFsNuFcf158F5OV1e2SK37acZRRg@mail.gmail.com>
 <20170510080841.GG390@ZenIV.linux.org.uk> <20170510081431.GA16610@infradead.org>
From: Andy Lutomirski <luto@kernel.org>
Date: Wed, 10 May 2017 17:18:33 -0700
Message-ID: <CALCETrX2Vi8vKk3Cee7EfiGxFUjS+Htn1gzyr_PQ+e9ktnAmTg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [PATCH v9 1/4] syscalls: Verify address
 limit before returning to user-mode
To: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@kernel.org>, Greg KH <greg@kroah.com>, Thomas Garnier <thgarnie@google.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dave Hansen <dave.hansen@intel.com>, Thomas Gleixner <tglx@linutronix.de>, David Howells <dhowells@redhat.com>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Kees Cook <keescook@chromium.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Russell King <linux@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, linux-s390 <linux-s390@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, May 10, 2017 at 1:14 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, May 10, 2017 at 09:08:41AM +0100, Al Viro wrote:
>> On Wed, May 10, 2017 at 09:37:04AM +0200, Arnd Bergmann wrote:
>>
>> > > How about trying to remove all of them?  If we could actually get rid
>> > > of all of them, we could drop the arch support, and we'd get faster,
>> > > simpler, shorter uaccess code throughout the kernel.
>>
>> BTW, not all get_user() under KERNEL_DS are plain loads.  There is an
>> exception - probe_kernel_read().
>
> And various calls that looks like opencoded versions, e.g. drivers/dio
> or the ELF loader.
>
> But in the long run we'll just need a separate primitive for that,
> but that can wait until the set_fs calls outside the core code are
> gone.

I suspect that, on most arches, the primitive is called
__copy_from_user().  We could make the generic code do that except
where overridden.
