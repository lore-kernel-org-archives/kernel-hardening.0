MIME-Version: 1.0
In-Reply-To: <05d9c4a7-8acb-5997-1dd6-d534398e6f54@zytor.com>
References: <20170404174727.35478-1-thgarnie@google.com> <20170404174727.35478-2-thgarnie@google.com>
 <05d9c4a7-8acb-5997-1dd6-d534398e6f54@zytor.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Tue, 4 Apr 2017 12:21:48 -0700
Message-ID: <CAJcbSZGWX23QTWmM4a_07ui-8Xyz4H2NLj1LXFFbZvnv9tc_XQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v6 2/4] x86/syscalls: Specific usage of verify_pre_usermode_state
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Kees Cook <keescook@chromium.org>, Rik van Riel <riel@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Russell King <linux@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, linux-s390 <linux-s390@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, linux-arm-kernel@lists.infradead.org, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 4, 2017 at 11:27 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/04/17 10:47, Thomas Garnier wrote:
>> diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
>> index 516593e66bd6..12fa851c7fa8 100644
>> --- a/arch/x86/include/asm/pgtable_64_types.h
>> +++ b/arch/x86/include/asm/pgtable_64_types.h
>> @@ -78,4 +78,15 @@ typedef struct { pteval_t pte; } pte_t;
>>
>>  #define EARLY_DYNAMIC_PAGE_TABLES    64
>>
>> +/*
>> + * User space process size. 47bits minus one guard page.  The guard
>> + * page is necessary on Intel CPUs: if a SYSCALL instruction is at
>> + * the highest possible canonical userspace address, then that
>> + * syscall will enter the kernel with a non-canonical return
>> + * address, and SYSRET will explode dangerously.  We avoid this
>> + * particular problem by preventing anything from being mapped
>> + * at the maximum canonical address.
>> + */
>> +#define TASK_SIZE_MAX        ((_AC(1, UL) << 47) - PAGE_SIZE)
>> +
>>  #endif /* _ASM_X86_PGTABLE_64_DEFS_H */
>> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
>> index 3cada998a402..e80822582d3e 100644
>> --- a/arch/x86/include/asm/processor.h
>> +++ b/arch/x86/include/asm/processor.h
>> @@ -825,17 +825,6 @@ static inline void spin_lock_prefetch(const void *x)
>>  #define KSTK_ESP(task)               (task_pt_regs(task)->sp)
>>
>>  #else
>> -/*
>> - * User space process size. 47bits minus one guard page.  The guard
>> - * page is necessary on Intel CPUs: if a SYSCALL instruction is at
>> - * the highest possible canonical userspace address, then that
>> - * syscall will enter the kernel with a non-canonical return
>> - * address, and SYSRET will explode dangerously.  We avoid this
>> - * particular problem by preventing anything from being mapped
>> - * at the maximum canonical address.
>> - */
>> -#define TASK_SIZE_MAX        ((1UL << 47) - PAGE_SIZE)
>> -
>>  /* This decides where the kernel will search for a free chunk of vm
>>   * space during mmap's.
>>   */
>>
>
> This should be an entirely separate patch; if nothing else you need to
> explain it in the comments.

I will explain it in the commit message, it should be easier than a
separate patch.

>
> Also, you say this is for "x86", but I still don't see any code for i386
> whatsoever.  Have you verified *all* the i386 and i386-compat paths to
> make sure they go via prepare_exit_to_usermode()?  [Cc: Andy]

I did but I will do it again for the next iteration.

>
> Finally, I can't really believe I'm the only person for whom "Specific
> usage of verity_pre_usermode_state" is completely opaque.

I agree, I will improve it.

>
>         -hpa
>



-- 
Thomas
