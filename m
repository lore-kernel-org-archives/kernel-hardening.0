MIME-Version: 1.0
In-Reply-To: <0a95efad-1a3d-4aab-6d94-58dd583d275a@suse.cz>
References: <20180223170325.997716448@linuxfoundation.org> <20180223170354.028619665@linuxfoundation.org>
 <0a95efad-1a3d-4aab-6d94-58dd583d275a@suse.cz>
From: Jinpu Wang <jinpu.wang@profitbricks.com>
Date: Tue, 6 Mar 2018 17:11:20 +0100
Message-ID: <CAMGffEm3bRrshMftdpC4cTNppQuFUPyOniE3zZL7PJRinbVVfw@mail.gmail.com>
Subject: Re: [PATCH 4.4 178/193] x86/syscall: Sanitize syscall table
 de-references under speculation
Content-Type: text/plain; charset="UTF-8"
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, Andy Lutomirski <luto@kernel.org>, alan@linux.intel.com, David Woodhouse <dwmw@amazon.co.uk>, Jan Beulich <JBeulich@suse.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 6, 2018 at 3:21 PM, Jiri Slaby <jslaby@suse.cz> wrote:
> On 02/23/2018, 07:26 PM, Greg Kroah-Hartman wrote:
>> 4.4-stable review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>> From: Dan Williams <dan.j.williams@intel.com>
>>
>> (cherry picked from commit 2fbd7af5af8665d18bcefae3e9700be07e22b681)
>>
>> The syscall table base is a user controlled function pointer in kernel
>> space. Use array_index_nospec() to prevent any out of bounds speculation.
>>
>> While retpoline prevents speculating into a userspace directed target it
>> does not stop the pointer de-reference, the concern is leaking memory
>> relative to the syscall table base, by observing instruction cache
>> behavior.
>>
>> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>> Cc: linux-arch@vger.kernel.org
>> Cc: kernel-hardening@lists.openwall.com
>> Cc: gregkh@linuxfoundation.org
>> Cc: Andy Lutomirski <luto@kernel.org>
>> Cc: alan@linux.intel.com
>> Link: https://lkml.kernel.org/r/151727417984.33451.1216731042505722161.stgit@dwillia2-desk3.amr.corp.intel.com
>> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
>> [jwang: port to 4.4, no syscall_64]
>
> This is not complete IMO, the syscall is indeed there, only written in
> assembly in 4.4 yet.
>
> So this patch looks like it is missing these two hunks (from my
> SLE12-SP2 backport):
>
>> --- a/arch/x86/entry/entry_64.S
>> +++ b/arch/x86/entry/entry_64.S
>> @@ -184,6 +184,8 @@ entry_SYSCALL_64_fastpath:
>>        cmpl    $__NR_syscall_max, %eax
>>  #endif
>>        ja      1f                              /* return -ENOSYS (already in pt_regs->ax) */
>> +      sbb     %rcx, %rcx                      /* array_index_mask_nospec() */
>> +      and     %rcx, %rax
>>        movq    %r10, %rcx
>>  #ifdef CONFIG_RETPOLINE
>>        movq    sys_call_table(, %rax, 8), %rax
>> @@ -282,6 +284,8 @@ tracesys_phase2:
>>        cmpl    $__NR_syscall_max, %eax
>>  #endif
>>        ja      1f                              /* return -ENOSYS (already in pt_regs->ax) */
>> +      sbb     %rcx, %rcx                      /* array_index_mask_nospec() */
>> +      and     %rcx, %rax
>>        movq    %r10, %rcx                      /* fixup for C */
>>  #ifdef CONFIG_RETPOLINE
>>        movq    sys_call_table(, %rax, 8), %rax
>
> Discovered by Jan Beulich.
>
> thanks,
> --
> js
> suse labs

Thanks Jiri, yes, indeed, could you send a formal patch of the fix?

Thanks!
Jack Wang
