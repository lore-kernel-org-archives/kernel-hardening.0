MIME-Version: 1.0
In-Reply-To: <867402A5-BED8-4A44-9770-7D3B153BEE82@amacapital.net>
References: <151648235823.34747.15181877619346237802.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151648239535.34747.4422108674633222531.stgit@dwillia2-desk3.amr.corp.intel.com>
 <867402A5-BED8-4A44-9770-7D3B153BEE82@amacapital.net>
From: Jann Horn <jannh@google.com>
Date: Sun, 21 Jan 2018 20:31:01 +0100
Message-ID: <CAG48ez3dWLJEoiUOLKRD3e8uJmAz87FNQB5MOLTxJg=y3KahRw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v4.1 07/10] x86: narrow out of
 bounds syscalls to sys_read under speculation
To: Andy Lutomirski <luto@amacapital.net>
Cc: Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, linux-arch <linux-arch@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jan 21, 2018 at 8:16 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Jan 20, 2018, at 1:06 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>> The syscall table base is a user controlled function pointer in kernel
>> space. Like, 'get_user, use 'MASK_NOSPEC' to prevent any out of bounds
>> speculation. While retpoline prevents speculating into the user
>> controlled target it does not stop the pointer de-reference, the concern
>> is leaking memory relative to the syscall table base.
>>
>> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Cc: x86@kernel.org
>> Cc: Andy Lutomirski <luto@kernel.org>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>> arch/x86/entry/entry_64.S   |    2 ++
>> arch/x86/include/asm/smap.h |    9 ++++++++-
>> 2 files changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
>> index 63f4320602a3..584f6d2236b3 100644
>> --- a/arch/x86/entry/entry_64.S
>> +++ b/arch/x86/entry/entry_64.S
>> @@ -35,6 +35,7 @@
>> #include <asm/asm.h>
>> #include <asm/smap.h>
>> #include <asm/pgtable_types.h>
>> +#include <asm/smap.h>
>> #include <asm/export.h>
>> #include <asm/frame.h>
>> #include <asm/nospec-branch.h>
>> @@ -260,6 +261,7 @@ entry_SYSCALL_64_fastpath:
>>    cmpl    $__NR_syscall_max, %eax
>> #endif
>>    ja    1f                /* return -ENOSYS (already in pt_regs->ax) */
>> +    MASK_NOSPEC %r11 %rax            /* sanitize syscall_nr wrt speculation */
>
> What's the threat you're protecting against?  No one does any computation or data dependent loads based on the value being read.  Or are you worried about ASLR leaks due to merely speculatively loading from a bogus address.

AFAIU the threat is that you could potentially use variant 1 to get
speculative RIP control using the indirect call through the syscall
table. (I haven't tested myself whether that'd work, and I don't know
how well that would work especially when the limit for the comparison
is coming from an immediate, but apparently Dan thinks it's a
potential problem?)
In other words, this would again be an attack against the indirect
call "call *sys_call_table(, %rax, 8)", but this time, the attack
would rely on the indirect branch being resolved *properly* based on
the address read from memory instead of relying on a misprediction;
but using an index into the syscall array that is out of bounds, after
mispredicting the conditional jump for verifying that the syscall
number is in bounds. This could still work even with retpolines if the
CPU can correct mispredictions within speculative execution.
