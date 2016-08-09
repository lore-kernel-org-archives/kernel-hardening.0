Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160809165416.GC19374@nazgul.tnic>
References: <1470760554-129111-1-git-send-email-thgarnie@google.com>
 <1470760554-129111-2-git-send-email-thgarnie@google.com> <20160809165416.GC19374@nazgul.tnic>
From: Thomas Garnier <thgarnie@google.com>
Date: Tue, 9 Aug 2016 10:02:35 -0700
Message-ID: <CAJcbSZGN7=psPxnUyTPSzM7NKYWHC1trZt4hTECz24Mx=kLOWQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH v2 2/2] x86/KASLR: Increase BRK pages for KASLR memory randomization
To: Borislav Petkov <bp@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Joerg Roedel <jroedel@suse.de>, Dave Young <dyoung@redhat.com>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Lv Zheng <lv.zheng@intel.com>, Baoquan He <bhe@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mark Salter <msalter@redhat.com>, Aleksey Makarov <aleksey.makarov@linaro.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Christian Borntraeger <borntraeger@de.ibm.com>, Fabian Frederick <fabf@skynet.be>, Toshi Kani <toshi.kani@hp.com>, Dan Williams <dan.j.williams@intel.com>, the arch/x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Aug 9, 2016 at 9:54 AM, Borislav Petkov <bp@suse.de> wrote:
> On Tue, Aug 09, 2016 at 09:35:54AM -0700, Thomas Garnier wrote:
>> Default implementation expects 6 pages maximum are needed for low page
>> allocations. If KASLR memory randomization is enabled, the worse case
>> of e820 layout would require 12 pages (no large pages). It is due to the
>> PUD level randomization and the variable e820 memory layout.
>>
>> This bug was found while doing extensive testing of KASLR memory
>> randomization on different type of hardware.
>>
>> Fixes: 021182e52fe0 ("Enable KASLR for physical mapping memory regions")
>> Signed-off-by: Thomas Garnier <thgarnie@google.com>
>> ---
>> Based on next-20160805
>> ---
>>  arch/x86/mm/init.c | 14 ++++++++++++--
>>  1 file changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
>> index 6209289..796e7af 100644
>> --- a/arch/x86/mm/init.c
>> +++ b/arch/x86/mm/init.c
>> @@ -122,8 +122,18 @@ __ref void *alloc_low_pages(unsigned int num)
>>       return __va(pfn << PAGE_SHIFT);
>>  }
>>
>> -/* need 3 4k for initial PMD_SIZE,  3 4k for 0-ISA_END_ADDRESS */
>> -#define INIT_PGT_BUF_SIZE    (6 * PAGE_SIZE)
>> +/*
>> + * By default need 3 4k for initial PMD_SIZE,  3 4k for 0-ISA_END_ADDRE=
SS.
>> + * With KASLR memory randomization, depending on the machine e860 memor=
y layout
>> + * and the PUD alignement. We may need twice more pages when KASLR memo=
y
>> + * randomization is enabled.
>
> Can you please integrate all review feedback before you send your next
> versions?
>
> There's no "e860" thing and
> s/memoy/memory/ and
> s/alignement/alignment/
>
> IOW, just integrate a spellchecker into your workflow.

Will do, thanks.

>
> Thanks.
>
> --
> Regards/Gruss,
>     Boris.
>
> ECO tip #101: Trim your mails when you reply.
>
> SUSE Linux GmbH, GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton=
, HRB 21284 (AG N=C3=BCrnberg)
> --
