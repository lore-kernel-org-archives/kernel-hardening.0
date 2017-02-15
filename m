MIME-Version: 1.0
In-Reply-To: <3b2210d0-b76d-48b6-c232-8304d915a755@oracle.com>
References: <20170214194259.75960-1-thgarnie@google.com> <20170214194259.75960-2-thgarnie@google.com>
 <3b2210d0-b76d-48b6-c232-8304d915a755@oracle.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Wed, 15 Feb 2017 07:41:45 -0800
Message-ID: <CAJcbSZGFfspzR3V62wAAVfCPLouMBDhr_5LjR44+Ay2sPNhAJQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 2/4] x86: Remap GDT tables in the Fixmap section
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Paul Gortmaker <paul.gortmaker@windriver.com>, Andy Lutomirski <luto@amacapital.net>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Jiri Kosina <jikos@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Juergen Gross <jgross@suse.com>, Rusty Russell <rusty@rustcorp.com.au>, Peter Zijlstra <peterz@infradead.org>, Christian Borntraeger <borntraeger@de.ibm.com>, "Luis R . Rodriguez" <mcgrof@kernel.org>, He Chen <he.chen@linux.intel.com>, Brian Gerst <brgerst@gmail.com>, Stanislaw Gruszka <sgruszka@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Adam Buchbinder <adam.buchbinder@gmail.com>, Dave Hansen <dave.hansen@intel.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Tim Chen <tim.c.chen@linux.intel.com>, Rik van Riel <riel@redhat.com>, Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Michael Ellerman <mpe@ellerman.id.au>, Joerg Roedel <joro@8bytes.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, the arch/x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, kasan-dev <kasan-dev@googlegroups.com>, Linux PM list <linux-pm@vger.kernel.org>, linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, lguest@lists.ozlabs.org, kvm list <kvm@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 15, 2017 at 7:37 AM, Boris Ostrovsky
<boris.ostrovsky@oracle.com> wrote:
> On 02/14/2017 02:42 PM, Thomas Garnier wrote:
>> diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
>> index 0dee6f59ea82..6399bab936cd 100644
>> --- a/arch/x86/xen/smp.c
>> +++ b/arch/x86/xen/smp.c
>> @@ -391,7 +391,7 @@ cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
>>       if (ctxt == NULL)
>>               return -ENOMEM;
>>
>> -     gdt = get_cpu_gdt_table(cpu);
>> +     gdt = get_cpu_gdt_rw(cpu);
>>
>>  #ifdef CONFIG_X86_32
>>       ctxt->user_regs.fs = __KERNEL_PERCPU;
>
>
> Which tree are these patches against? The chunk above cannot be applied
> to current Linus tree but it can be applied against Xen staging tree
> that has not been pulled yet.
>
> I can apply this manually but the series crashes PV guests so I want to
> make sure I am using right bits.
>

That was against linux-next (next-20170213 tag).

> -boris
>
>



-- 
Thomas
