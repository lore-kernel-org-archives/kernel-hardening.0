References: <20170311000501.46607-1-thgarnie@google.com>
 <20170311000501.46607-2-thgarnie@google.com>
 <20170311094200.GA27700@gmail.com>
 <733ed189-6c01-2975-a81a-6fbfe4b7b593@zytor.com>
 <2d9aad2a-a677-40d2-c179-379fb6e9f194@zytor.com>
 <CAJcbSZG6F3DsiBMjizTbzaccvU5_RKdspU06wQ8yi+JT+EW2Jw@mail.gmail.com>
 <CALCETrVVo4aQosdjfUPBf=JWyVWE_cHavbBKX5Swv_HbV__RNw@mail.gmail.com>
From: "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <958a2750-4a5a-b4a3-daf0-6095c073c2a3@zytor.com>
Date: Tue, 14 Mar 2017 09:30:34 -0700
MIME-Version: 1.0
In-Reply-To: <CALCETrVVo4aQosdjfUPBf=JWyVWE_cHavbBKX5Swv_HbV__RNw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v3 2/4] x86/syscalls: Specific usage of
 verify_pre_usermode_state
To: Andy Lutomirski <luto@amacapital.net>, Thomas Garnier <thgarnie@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>, Dave Hansen <dave.hansen@intel.com>, =?UTF-8?Q?Ren=c3=a9_Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Petr Mladek <pmladek@suse.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Helge Deller <deller@gmx.de>, Rik van Riel <riel@redhat.com>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Frederic Weisbecker <fweisbec@gmail.com>, Stanislav Kinsburskiy <skinsbursky@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Borislav Petkov <bp@alien8.de>, Josh Poimboeuf <jpoimboe@redhat.com>, Brian Gerst <brgerst@gmail.com>, Jan Beulich <JBeulich@suse.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Fenghua Yu <fenghua.yu@intel.com>, He Chen <he.chen@linux.intel.com>, Russell King <linux@armlinux.org.uk>, Vladimir Murzin <vladimir.murzin@arm.com>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, "David A . Long" <dave.long@linaro.org>, Pratyush Anand <panand@redhat.com>, Laura Abbott <labbott@redhat.com>, Andre Przywara <andre.przywara@arm.com>, Chris Metcalf <cmetcalf@mellanox.com>, linux-s390 <linux-s390@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 03/14/17 08:39, Andy Lutomirski wrote:
>>
>> Ingo: Which approach do you favor? I want to keep the fast path as
>> fast as possible obviously.
> 
> Even though my name isn't Ingo, Linus keeps trying to get me to be the
> actual maintainer of this file.  :)  How about (sorry about whitespace
> damage):
> 
> #ifdef CONFIG_BUG_ON_DATA_CORRUPTION
>        movq    PER_CPU_VAR(current_task), %rax
>        bt $63, TASK_addr_limit(%rax)
>        jc     syscall_return_slowpath
> #endif
> 
> Now the kernel is totally unchanged if the config option is off and
> it's fast and simple if the option is on.
> 

The idea as far as I understand was that the option was about whether or
not to clobber the broken value or BUG on it, not to remove the check.
My point, though, was that we can bail out to the slow path if there is
a discrepancy and worry about BUG or not there; performance doesn't
matter one iota if this triggers regardless of the remediation.

It isn't clear that using bt would be faster, though; although it saves
an instruction that instruction can be hoisted arbitrarily and so is
extremely likely to be hidden in the pipeline.  cmp (which is really a
variant of sub) is one of the basic ALU instructions that are
super-optimized on every CPU, whereas bt is substantially slower on some
implementations.

This version is also "slightly less secure" since it would make it
possible to overwrite the guard page at the end of TASK_SIZE_MAX if one
could figure out a way to put an arbitrary value into this variable, but
I doubt that matters in any way.

	-hpa
