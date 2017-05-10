MIME-Version: 1.0
Sender: arndbergmann@gmail.com
In-Reply-To: <CALCETrUh8NO2scaqEM48K70Fo2+V3=Cpyk4JurCDiCYp4nm_+g@mail.gmail.com>
References: <20170428153213.137279-1-thgarnie@google.com> <CAJcbSZGQsRVg3QZ9QfLn2HBC+RP-7fUTab0bYDJ455d8y8GyNw@mail.gmail.com>
 <20170508073352.caqe3fqf7nuxypgi@gmail.com> <20170508124621.GA20705@kroah.com>
 <20170509064522.anusoikaalvlux3w@gmail.com> <20170509085659.GA32555@infradead.org>
 <CALCETrUh8NO2scaqEM48K70Fo2+V3=Cpyk4JurCDiCYp4nm_+g@mail.gmail.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 10 May 2017 09:37:04 +0200
Message-ID: <CAK8P3a2j6h2MAx3h2NCtadcFsNuFcf158F5OV1e2SK37acZRRg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [PATCH v9 1/4] syscalls: Verify address
 limit before returning to user-mode
To: Andy Lutomirski <luto@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@kernel.org>, Greg KH <greg@kroah.com>, Thomas Garnier <thgarnie@google.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dave Hansen <dave.hansen@intel.com>, Thomas Gleixner <tglx@linutronix.de>, David Howells <dhowells@redhat.com>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Kees Cook <keescook@chromium.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Russell King <linux@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, linux-s390 <linux-s390@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, May 9, 2017 at 3:00 PM, Andy Lutomirski <luto@kernel.org> wrote:
> On Tue, May 9, 2017 at 1:56 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> On Tue, May 09, 2017 at 08:45:22AM +0200, Ingo Molnar wrote:
>>> We only have ~115 code blocks in the kernel that set/restore KERNEL_DS, it would
>>> be a pity to add a runtime check to every system call ...
>>
>> I think we should simply strive to remove all of them that aren't
>> in core scheduler / arch code.  Basically evetyytime we do the
>>
>>         oldfs = get_fs();
>>         set_fs(KERNEL_DS);
>>         ..
>>         set_fs(oldfs);
>>
>> trick we're doing something wrong, and there should always be better
>> ways to archive it.  E.g. using iov_iter with a ITER_KVEC type
>> consistently would already remove most of them.
>
> How about trying to remove all of them?  If we could actually get rid
> of all of them, we could drop the arch support, and we'd get faster,
> simpler, shorter uaccess code throughout the kernel.
>
> The ones in kernel/compat.c are generally garbage.  They should be
> using compat_alloc_user_space().  Ditto for kernel/power/user.c.

compat_alloc_user_space() has some problems too, it adds
complexity to a rarely-tested code path and can add some noticeable
overhead in cases where user space access is slow because of
extra checks.

It's clearly better than set_fs(), but the way I prefer to convert the
code is to avoid both and instead move compat handlers next to
the native code, and splitting out the common code between native
and compat mode into a helper that takes a regular kernel pointer.

I think that's what both Al has done in the past on compat_ioctl()
and select() and what Christoph does in his latest series, but
it seems worth pointing out for others that decide to help out here.

     Arnd
