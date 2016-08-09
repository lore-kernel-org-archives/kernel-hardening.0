Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <68119f42-cb1b-fd3e-3820-7cf235e607e5@nextfour.com>
References: <1470681607-36883-1-git-send-email-thgarnie@google.com>
 <1470681607-36883-2-git-send-email-thgarnie@google.com> <68119f42-cb1b-fd3e-3820-7cf235e607e5@nextfour.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Tue, 9 Aug 2016 07:47:21 -0700
Message-ID: <CAJcbSZFS4Ddt5=QuW+J_p2V4=50VppAgVdydXEjbsTX_e+q7Sg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH v1 2/2] x86/KASLR: Increase BRK pages for KASLR memory randomization
To: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>, Joerg Roedel <jroedel@suse.de>, Dave Young <dyoung@redhat.com>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Lv Zheng <lv.zheng@intel.com>, Baoquan He <bhe@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mark Salter <msalter@redhat.com>, Aleksey Makarov <aleksey.makarov@linaro.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Christian Borntraeger <borntraeger@de.ibm.com>, Fabian Frederick <fabf@skynet.be>, Toshi Kani <toshi.kani@hp.com>, Dan Williams <dan.j.williams@intel.com>, the arch/x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 8, 2016 at 10:16 PM, Mika Penttil=C3=A4
<mika.penttila@nextfour.com> wrote:
> On 08/08/2016 09:40 PM, Thomas Garnier wrote:
>> Default implementation expects 6 pages maximum are needed for low page
>> allocations. If KASLR memory randomization is enabled, the worse case
>> of e820 layout would require 12 pages (no large pages). It is due to the
>> PUD level randomization and the variable e820 memory layout.
>>
>> This bug was found while doing extensive testing of KASLR memory
>> randomization on different type of hardware.
>>
>> Signed-off-by: Thomas Garnier <thgarnie@google.com>
>> ---
>> Based on next-20160805
>> ---
>>  arch/x86/mm/init.c | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
>> index 6209289..3a27e6a 100644
>> --- a/arch/x86/mm/init.c
>> +++ b/arch/x86/mm/init.c
>> @@ -130,6 +130,14 @@ void  __init early_alloc_pgt_buf(void)
>>       unsigned long tables =3D INIT_PGT_BUF_SIZE;
>>       phys_addr_t base;
>>
>> +     /*
>> +      * Depending on the machine e860 memory layout and the PUD alignem=
ent.
>> +      * We may need twice more pages when KASLR memoy randomization is
>> +      * enabled.
>> +      */
>> +     if (IS_ENABLED(CONFIG_RANDOMIZE_MEMORY))
>> +             tables *=3D 2;
>> +
>>       base =3D __pa(extend_brk(tables, PAGE_SIZE));
>>
>>       pgt_buf_start =3D base >> PAGE_SHIFT;
>>
>
> You should increase the reserve also :
> RESERVE_BRK(early_pgt_alloc, INIT_PGT_BUF_SIZE);

Yes, that's right. I will resend v2 changing INIT_PGD_BUF_SIZE.

>
>
> --Mika
>
