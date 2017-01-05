Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20170105081114.GD2098@gmail.com>
References: <20170104221630.831-1-thgarnie@google.com> <20170105081114.GD2098@gmail.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Thu, 5 Jan 2017 08:39:05 -0800
Message-ID: <CAJcbSZFgmPYWQQx1POAAtOHD9q7evEPf-47Enh1MdvwDF=CEYQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC] x86/mm/KASLR: Remap GDTs at fixed location
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave@sr71.net>, Chen Yucong <slaoub@gmail.com>, Arjan van de Ven <arjan@linux.intel.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Anna-Maria Gleixner <anna-maria@linutronix.de>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Michael Ellerman <mpe@ellerman.id.au>, Juergen Gross <jgross@suse.com>, Richard Weinberger <richard@nod.at>, the arch/x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 5, 2017 at 12:11 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Thomas Garnier <thgarnie@google.com> wrote:
>
>> Each processor holds a GDT in its per-cpu structure. The sgdt
>> instruction gives the base address of the current GDT. This address can
>> be used to bypass KASLR memory randomization. With another bug, an
>> attacker could target other per-cpu structures or deduce the base of the
>> main memory section (PAGE_OFFSET).
>>
>> In this change, a space is reserved at the end of the memory range
>> available for KASLR memory randomization. The space is big enough to hold
>> the maximum number of CPUs (as defined by setup_max_cpus). Each GDT is
>> mapped at specific offset based on the target CPU. Note that if there is
>> not enough space available, the GDTs are not remapped.
>>
>> The document was changed to mention GDT remapping for KASLR. This patch
>> also include dump page tables support.
>>
>> This patch was tested on multiple hardware configurations and for
>> hibernation support.
>
>>  void kernel_randomize_memory(void);
>> +void kernel_randomize_smp(void);
>> +void* kaslr_get_gdt_remap(int cpu);
>
> Yeah, no fundamental objections from me to the principle, but I get some bad vibes
> from the naming here: seeing that kernel_randomize_smp() actually makes things
> less random.
>

I agree, I went back and forth on the name. I will change it to
something better.

> Also, don't we want to do this unconditionally and not allow remapping failures?
>
> The GDT is fairly small, plus making the SGDT instruction expose fewer kernel
> internals would be (marginally) useful on non-randomized kernels as well.
>
> It also makes the code more common, more predictable, more debuggable and less
> complex overall - which is pretty valuable in terms of long term security as well.
>

Okay, I will add BUG_ON on failures to remap.

> Thanks,
>
>         Ingo

Ingo: I saw the 5-level page table support being sent through. Do you
want me to wait for it to be -next? (Given it will need to be changed
too).

-- 
Thomas
