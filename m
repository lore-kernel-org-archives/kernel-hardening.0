Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAE9FiQXPnXa_Ep2nk+y5boZ9Csdk_yoH5Ws8SaExn0-VHU9bBg@mail.gmail.com>
References: <1470071280-78706-1-git-send-email-thgarnie@google.com>
 <1470071280-78706-2-git-send-email-thgarnie@google.com> <CAE9FiQXPnXa_Ep2nk+y5boZ9Csdk_yoH5Ws8SaExn0-VHU9bBg@mail.gmail.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Tue, 2 Aug 2016 10:48:01 -0700
Message-ID: <CAJcbSZE1kPpL_hWLK70fGhgjP3xRBaZ=r32E9q1SBwhCbqOp5Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v1 1/2] x86/power/64: Support unaligned addresses for
 temporary mapping
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Aug 2, 2016 at 10:36 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Aug 1, 2016 at 10:07 AM, Thomas Garnier <thgarnie@google.com> wrote:
>> Correctly setup the temporary mapping for hibernation. Previous
>> implementation assumed the address was aligned on the PGD level. With
>> KASLR memory randomization enabled, the address is randomized on the PUD
>> level. This change supports unaligned address up to PMD.
>>
>> Signed-off-by: Thomas Garnier <thgarnie@google.com>
>> ---
>>  arch/x86/mm/ident_map.c | 18 ++++++++++--------
>>  1 file changed, 10 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/x86/mm/ident_map.c b/arch/x86/mm/ident_map.c
>> index ec21796..ea1ebf1 100644
>> --- a/arch/x86/mm/ident_map.c
>> +++ b/arch/x86/mm/ident_map.c
>> @@ -3,15 +3,16 @@
>>   * included by both the compressed kernel and the regular kernel.
>>   */
>>
>> -static void ident_pmd_init(unsigned long pmd_flag, pmd_t *pmd_page,
>> +static void ident_pmd_init(struct x86_mapping_info *info, pmd_t *pmd_page,
>>                            unsigned long addr, unsigned long end)
>>  {
>> -       addr &= PMD_MASK;
>> -       for (; addr < end; addr += PMD_SIZE) {
>> -               pmd_t *pmd = pmd_page + pmd_index(addr);
>> +       int off = info->kernel_mapping ? pmd_index(__PAGE_OFFSET) : 0;
>> +
>> +       for (addr &= PMD_MASK; addr < end; addr += PMD_SIZE) {
>> +               pmd_t *pmd = pmd_page + pmd_index(addr) + off;
>>
>>                 if (!pmd_present(*pmd))
>> -                       set_pmd(pmd, __pmd(addr | pmd_flag));
>> +                       set_pmd(pmd, __pmd(addr | info->pmd_flag));
>>         }
>>  }
>>
>> @@ -19,9 +20,10 @@ static int ident_pud_init(struct x86_mapping_info *info, pud_t *pud_page,
>>                           unsigned long addr, unsigned long end)
>>  {
>>         unsigned long next;
>> +       int off = info->kernel_mapping ? pud_index(__PAGE_OFFSET) : 0;
>>
>>         for (; addr < end; addr = next) {
>> -               pud_t *pud = pud_page + pud_index(addr);
>> +               pud_t *pud = pud_page + pud_index(addr) + off;
>>                 pmd_t *pmd;
>>
>>                 next = (addr & PUD_MASK) + PUD_SIZE;
>
> Is there any chance for (pud_index(addr) + off) or (pmd_index(addr) + off)
> bigger than 512?
>
> Looks like we need to change the loop from phys address to virtual
> address instead.
> to avoid the overflow.
>

That's a good point. I will take a look at it.

> Thanks
>
> Yinghai
