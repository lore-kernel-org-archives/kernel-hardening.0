MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1494256932.1167.1.camel@gmail.com>
References: <20170428153213.137279-1-thgarnie@google.com> <CAJcbSZGQsRVg3QZ9QfLn2HBC+RP-7fUTab0bYDJ455d8y8GyNw@mail.gmail.com>
 <20170508073352.caqe3fqf7nuxypgi@gmail.com> <20170508075209.7aluvpwildw325rf@gmail.com>
 <1494256932.1167.1.camel@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 8 May 2017 08:26:23 -0700
Message-ID: <CAGXu5jL61K0bRSEg9a_LswNyrt3K1J57REbWVcvAXT54zWwtMA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [PATCH v9 1/4] syscalls: Verify address
 limit before returning to user-mode
To: Daniel Micay <danielmicay@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Garnier <thgarnie@google.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, David Howells <dhowells@redhat.com>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Russell King <linux@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, linux-s390 <linux-s390@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, May 8, 2017 at 8:22 AM, Daniel Micay <danielmicay@gmail.com> wrote:
> On Mon, 2017-05-08 at 09:52 +0200, Ingo Molnar wrote:
>>
>> ... it's just not usable in that form for a regular maintenance flow.
>>
>> So what would be more useful is to add a specific Sparse check that
>> only checks
>> KERNEL_DS, to add it as a regular (.config driven) build option and
>> make sure the
>> kernel build has zero warnings.
>>
>> From that point on we can declare that this kind of bug won't occur
>> anymore, if
>> the Sparse implementation of the check is correct.
>>
>> But there's a (big) problem with that development model: Sparse is not
>> part of the
>> kernel tree and adding a feature to it while making the kernel depend
>> on that
>> brand new feature is a logistical nightmare. The overhead is quite
>> similar to
>> adding new features to a compiler - it happens at a glacial pace and
>> is only done
>> for major features really, at considerable expense. I don't think this
>> is an
>> adequate model for 'extended syntax checking' of the kernel,
>> especially when it
>> comes to correctness that has such obvious security impact.
>>
>> Thanks,
>>
>>       Ingo
>
> There's the option of using GCC plugins now that the infrastructure was
> upstreamed from grsecurity. It can be used as part of the regular build
> process and as long as the analysis is pretty simple it shouldn't hurt
> compile time much.

Well, and that the situation may arise due to memory corruption, not
from poorly-matched set_fs() calls, which static analysis won't help
solve. We need to catch this bad kernel state because it is a very bad
state to run in.

-Kees

-- 
Kees Cook
Pixel Security
