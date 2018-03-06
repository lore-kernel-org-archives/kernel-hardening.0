Subject: Re: [PATCH 4.4 178/193] x86/syscall: Sanitize syscall table
 de-references under speculation
From: Jiri Slaby <jslaby@suse.cz>
References: <20180223170325.997716448@linuxfoundation.org>
 <20180223170354.028619665@linuxfoundation.org>
 <0a95efad-1a3d-4aab-6d94-58dd583d275a@suse.cz>
Message-ID: <10c08ff1-ba52-24a1-c915-42dd0eb175aa@suse.cz>
Date: Tue, 6 Mar 2018 17:02:39 +0100
MIME-Version: 1.0
In-Reply-To: <0a95efad-1a3d-4aab-6d94-58dd583d275a@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, Andy Lutomirski <luto@kernel.org>, alan@linux.intel.com, David Woodhouse <dwmw@amazon.co.uk>, Jack Wang <jinpu.wang@profitbricks.com>, Jan Beulich <JBeulich@suse.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 03/06/2018, 03:21 PM, Jiri Slaby wrote:
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

Which is not completely correct either. The preceding comparison should
write:
    cmpl    $NR_syscalls, %eax
    jae     1f
to have sbb correctly working even on the last syscall number.

thanks,
-- 
js
suse labs
