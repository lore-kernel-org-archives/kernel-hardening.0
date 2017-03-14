MIME-Version: 1.0
In-Reply-To: <2d9aad2a-a677-40d2-c179-379fb6e9f194@zytor.com>
References: <20170311000501.46607-1-thgarnie@google.com> <20170311000501.46607-2-thgarnie@google.com>
 <20170311094200.GA27700@gmail.com> <733ed189-6c01-2975-a81a-6fbfe4b7b593@zytor.com>
 <2d9aad2a-a677-40d2-c179-379fb6e9f194@zytor.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Tue, 14 Mar 2017 08:17:08 -0700
Message-ID: <CAJcbSZG6F3DsiBMjizTbzaccvU5_RKdspU06wQ8yi+JT+EW2Jw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 2/4] x86/syscalls: Specific usage of verify_pre_usermode_state
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>, Dave Hansen <dave.hansen@intel.com>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Petr Mladek <pmladek@suse.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Helge Deller <deller@gmx.de>, Rik van Riel <riel@redhat.com>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Frederic Weisbecker <fweisbec@gmail.com>, Stanislav Kinsburskiy <skinsbursky@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Borislav Petkov <bp@alien8.de>, Josh Poimboeuf <jpoimboe@redhat.com>, Brian Gerst <brgerst@gmail.com>, Jan Beulich <JBeulich@suse.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Fenghua Yu <fenghua.yu@intel.com>, He Chen <he.chen@linux.intel.com>, Russell King <linux@armlinux.org.uk>, Vladimir Murzin <vladimir.murzin@arm.com>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, "David A . Long" <dave.long@linaro.org>, Pratyush Anand <panand@redhat.com>, Laura Abbott <labbott@redhat.com>, Andre Przywara <andre.przywara@arm.com>, Chris Metcalf <cmetcalf@mellanox.com>, linux-s390 <linux-s390@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, linux-arm-kernel@lists.infradead.org, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 14, 2017 at 2:40 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 03/13/17 17:04, H. Peter Anvin wrote:
>> On 03/11/17 01:42, Ingo Molnar wrote:
>>>>
>>>> +   /*
>>>> +    * Check user-mode state on fast path return, the same check is done
>>>> +    * under the slow path through syscall_return_slowpath.
>>>> +    */
>>>> +#ifdef CONFIG_BUG_ON_DATA_CORRUPTION
>>>> +   call    verify_pre_usermode_state
>>>> +#else
>>>> +   /*
>>>> +    * Similar to set_fs(USER_DS) in verify_pre_usermode_state without a
>>>> +    * warning.
>>>> +    */
>>>> +   movq    PER_CPU_VAR(current_task), %rax
>>>> +   movq    $TASK_SIZE_MAX, %rcx
>>>> +   cmp     %rcx, TASK_addr_limit(%rax)
>>>> +   jz      1f
>>>> +   movq    %rcx, TASK_addr_limit(%rax)
>>>> +1:
>>>> +#endif
>>>> +
>>
>> How about simply doing...
>>
>>       movq    PER_CPU_VAR(current_task), %rax
>>       movq    $TASK_SIZE_MAX, %rcx
>> #ifdef CONFIG_BUG_ON_DATA_CORRUPTION
>>       cmpq    %rcx, TASK_addr_limit(%rax)
>>       jne     syscall_return_slowpath
>> #else
>>       movq    %rcx, TASK_addr_limit(%rax)
>> #endif
>>
>> ... and let the slow path take care of BUG.  This should be much faster,
>> even with the BUG, and is simpler to boot.
>>
>
> In fact, we could even to the cmpq/jne unconditionally.  I'm guessing
> the occasional branch mispredict will be offset by occasionally touching
> a clean cacheline in the case of an unconditional store.
>
> Since this is something that should never happen, performance doesn't
> matter.

Ingo: Which approach do you favor? I want to keep the fast path as
fast as possible obviously.

>
>         -hpa
>
>



-- 
Thomas
