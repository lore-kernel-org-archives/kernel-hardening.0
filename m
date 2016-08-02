Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: rjwysocki@gmail.com
In-Reply-To: <CAJcbSZFC-qeEySJYO9DFs=HfE087QHROW=opDRCmZo2WXB1gqw@mail.gmail.com>
References: <1470071280-78706-1-git-send-email-thgarnie@google.com>
 <1470071280-78706-3-git-send-email-thgarnie@google.com> <1771166.6Dy2cXd33p@vostro.rjw.lan>
 <CAJcbSZGUEg-udR3jG2V=16xmG3z_jE1V4WcDbbrV854E5WrT8g@mail.gmail.com>
 <CAJZ5v0gKGhymb-53_hRCMRuRCkdAcqyGSOkVzg=pULc7Nyqd7w@mail.gmail.com> <CAJcbSZFC-qeEySJYO9DFs=HfE087QHROW=opDRCmZo2WXB1gqw@mail.gmail.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Tue, 2 Aug 2016 23:08:03 +0200
Message-ID: <CAJZ5v0hiZwugdV6OjA7hAHAv5jhjgJM1vPAW-RHUHud0F=5KsQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v1 2/2] x86/power/64: Fix __PAGE_OFFSET usage on restore
To: Thomas Garnier <thgarnie@google.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Yinghai Lu <yinghai@kernel.org>, Pavel Machek <pavel@ucw.cz>, the arch/x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Aug 2, 2016 at 10:59 PM, Thomas Garnier <thgarnie@google.com> wrote:
> On Tue, Aug 2, 2016 at 1:47 PM, Rafael J. Wysocki <rafael@kernel.org> wrote:
>> On Tue, Aug 2, 2016 at 4:34 PM, Thomas Garnier <thgarnie@google.com> wrote:
>>> On Mon, Aug 1, 2016 at 5:38 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>>>> On Monday, August 01, 2016 10:08:00 AM Thomas Garnier wrote:
>>>>> When KASLR memory randomization is used, __PAGE_OFFSET is a global
>>>>> variable changed during boot. The assembly code was using the variable
>>>>> as an immediate value to calculate the cr3 physical address. The
>>>>> physical address was incorrect resulting to a GP fault.
>>>>>
>>>>> Signed-off-by: Thomas Garnier <thgarnie@google.com>
>>>>> ---
>>>>>  arch/x86/power/hibernate_asm_64.S | 12 +++++++++++-
>>>>>  1 file changed, 11 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/arch/x86/power/hibernate_asm_64.S b/arch/x86/power/hibernate_asm_64.S
>>>>> index 8eee0e9..8db4905 100644
>>>>> --- a/arch/x86/power/hibernate_asm_64.S
>>>>> +++ b/arch/x86/power/hibernate_asm_64.S
>>>>> @@ -23,6 +23,16 @@
>>>>>  #include <asm/processor-flags.h>
>>>>>  #include <asm/frame.h>
>>>>>
>>>>> +/*
>>>>> + * A global variable holds the page_offset when KASLR memory randomization
>>>>> + * is enabled.
>>>>> + */
>>>>> +#ifdef CONFIG_RANDOMIZE_MEMORY
>>>>> +#define __PAGE_OFFSET_REF __PAGE_OFFSET
>>>>> +#else
>>>>> +#define __PAGE_OFFSET_REF $__PAGE_OFFSET
>>>>> +#endif
>>>>> +
>>>>>  ENTRY(swsusp_arch_suspend)
>>>>>       movq    $saved_context, %rax
>>>>>       movq    %rsp, pt_regs_sp(%rax)
>>>>> @@ -72,7 +82,7 @@ ENTRY(restore_image)
>>>>>       /* code below has been relocated to a safe page */
>>>>>  ENTRY(core_restore_code)
>>>>>       /* switch to temporary page tables */
>>>>> -     movq    $__PAGE_OFFSET, %rcx
>>>>> +     movq    __PAGE_OFFSET_REF, %rcx
>>>>>       subq    %rcx, %rax
>>>>>       movq    %rax, %cr3
>>>>>       /* flush TLB */
>>>>>
>>>>
>>>> I'm not particularly liking the #ifdefs and they won't be really
>>>> necessary if the subtraction is carried out by the C code IMO.
>>>>
>>>> What about the patch below instead?
>>>>
>>>
>>> Yes, I think that's a good idea. I will test it and send PATCH v2.
>>
>> No need to send this patch again.  Please just let me know if it works
>> for you. :-)
>>
>
> It worked well when I tested it and I agree that's a better approach.

OK, thanks!

Let me add a changelog to it then.
