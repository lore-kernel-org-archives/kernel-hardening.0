MIME-Version: 1.0
In-Reply-To: <20180206192925.qkmghwsbaysr4iv2@hermes.olymp>
References: <151632009605.21271.11304291057104672116.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151632014097.21271.16980532033566583357.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180206192925.qkmghwsbaysr4iv2@hermes.olymp>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 6 Feb 2018 11:48:45 -0800
Message-ID: <CAPcyv4ihN6fy5-vBtfA0PuwXvCAj8-rMhtQmevh5sdYxbH3Yfw@mail.gmail.com>
Subject: Re: [PATCH v4 07/10] x86: narrow out of bounds syscalls to sys_read
 under speculation
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Luis Henriques <lhenriques@suse.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Greg KH <gregkh@linuxfoundation.org>, X86 ML <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 6, 2018 at 11:29 AM, Luis Henriques <lhenriques@suse.com> wrote=
:
> On Thu, Jan 18, 2018 at 04:02:21PM -0800, Dan Williams wrote:
>> The syscall table base is a user controlled function pointer in kernel
>> space. Like, 'get_user, use 'MASK_NOSPEC' to prevent any out of bounds
>> speculation. While retpoline prevents speculating into the user
>> controlled target it does not stop the pointer de-reference, the concern
>> is leaking memory relative to the syscall table base.
>
> This patch seems to cause a regression.  An easy way to reproduce what
> I'm seeing is to run the samples/statx/test-statx.  Here's what I see
> when I have this patchset applied:
>
> # ./test-statx /tmp
> statx(/tmp) =3D -1
> /tmp: Bad file descriptor
>
> Reverting this single patch seems to fix it.

Just to clarify, when you say "this patch" you mean:

     2fbd7af5af86 x86/syscall: Sanitize syscall table de-references
under speculation

...not this early MASK_NOSPEC version of the patch, right?

>
> Cheers,
> --
> Lu=C3=ADs
>
>>
>> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Cc: x86@kernel.org
>> Cc: Andy Lutomirski <luto@kernel.org>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  arch/x86/entry/entry_64.S   |    2 ++
>>  arch/x86/include/asm/smap.h |    9 ++++++++-
>>  2 files changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
>> index 4f8e1d35a97c..2320017077d4 100644
>> --- a/arch/x86/entry/entry_64.S
>> +++ b/arch/x86/entry/entry_64.S
>> @@ -35,6 +35,7 @@
>>  #include <asm/asm.h>
>>  #include <asm/smap.h>
>>  #include <asm/pgtable_types.h>
>> +#include <asm/smap.h>
>>  #include <asm/export.h>
>>  #include <asm/frame.h>
>>  #include <asm/nospec-branch.h>
>> @@ -264,6 +265,7 @@ entry_SYSCALL_64_fastpath:
>>       cmpl    $__NR_syscall_max, %eax
>>  #endif
>>       ja      1f                              /* return -ENOSYS (already=
 in pt_regs->ax) */
>> +     MASK_NOSPEC %r11 %rax                   /* sanitize syscall_nr wrt=
 speculation */
>>       movq    %r10, %rcx
>>
>>       /*
>> diff --git a/arch/x86/include/asm/smap.h b/arch/x86/include/asm/smap.h
>> index 2b4ad4c6a226..3b5b2cf58dc6 100644
>> --- a/arch/x86/include/asm/smap.h
>> +++ b/arch/x86/include/asm/smap.h
>> @@ -35,7 +35,14 @@
>>   * this directs the cpu to speculate with a NULL ptr rather than
>>   * something targeting kernel memory.
>>   *
>> - * assumes CF is set from a previous 'cmp TASK_addr_limit, %ptr'
>> + * In the syscall entry path it is possible to speculate past the
>> + * validation of the system call number. Use MASK_NOSPEC to sanitize th=
e
>> + * syscall array index to zero (sys_read) rather than an arbitrary
>> + * target.
>> + *
>> + * assumes CF is set from a previous 'cmp' i.e.:
>> + *     cmp TASK_addr_limit, %ptr
>> + *     cmp __NR_syscall_max, %idx
>>   */
>>  .macro MASK_NOSPEC mask val
>>       sbb \mask, \mask
>>
>>
