Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <e5433e24-7a3d-25a4-26a3-9d02644cc3f4@redhat.com>
References: <20170118135310.GA4733@pjb1027-Latitude-E5410> <e5433e24-7a3d-25a4-26a3-9d02644cc3f4@redhat.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 18 Jan 2017 13:20:32 -0800
Message-ID: <CAGXu5j+GpsyrAz=ELYpUaKjYCY33-RhxczhaB=Rucmdc+7SO-A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] ARM: mm: add testcases for RODATA
To: Laura Abbott <labbott@redhat.com>
Cc: Jinbum Park <jinb.park7@gmail.com>, Russell King <linux@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@kernel.org>, andy.gross@linaro.org, Vladimir Murzin <vladimir.murzin@arm.com>, f.fainelli@gmail.com, Pawel Moll <pawel.moll@arm.com>, Jonathan Austin <jonathan.austin@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arjan van de Ven <arjan@linux.intel.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, kernel-janitors@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 18, 2017 at 11:20 AM, Laura Abbott <labbott@redhat.com> wrote:
> On 01/18/2017 05:53 AM, Jinbum Park wrote:
>> This patch adds testcases for the CONFIG_DEBUG_RODATA option.
>> It's similar to x86's testcases.
>> It tests read-only mapped data and page-size aligned rodata section.
>>
>> Signed-off-by: Jinbum Park <jinb.park7@gmail.com>
>> ---
>>  arch/arm/Kconfig.debug            |  5 +++
>>  arch/arm/include/asm/cacheflush.h | 10 +++++
>>  arch/arm/mm/Makefile              |  1 +
>>  arch/arm/mm/init.c                |  6 +++
>>  arch/arm/mm/test_rodata.c         | 80 +++++++++++++++++++++++++++++++++++++++
>>  5 files changed, 102 insertions(+)
>>  create mode 100644 arch/arm/mm/test_rodata.c
>>
>> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
>> index d83f7c3..511e5e1 100644
>> --- a/arch/arm/Kconfig.debug
>> +++ b/arch/arm/Kconfig.debug
>> @@ -1749,6 +1749,11 @@ config DEBUG_SET_MODULE_RONX
>>         against certain classes of kernel exploits.
>>         If in doubt, say "N".
>>
>> +config DEBUG_RODATA_TEST
>> +     bool "Testcase for the marking rodata read-only"
>> +     ---help---
>> +       This option enables a testcase for the setting rodata read-only.
>> +
>>  source "drivers/hwtracing/coresight/Kconfig"
>>
>>  endmenu
>> diff --git a/arch/arm/include/asm/cacheflush.h b/arch/arm/include/asm/cacheflush.h
>> index bdd283b..741e2e8 100644
>> --- a/arch/arm/include/asm/cacheflush.h
>> +++ b/arch/arm/include/asm/cacheflush.h
>> @@ -498,6 +498,16 @@ static inline void set_kernel_text_rw(void) { }
>>  static inline void set_kernel_text_ro(void) { }
>>  #endif
>>
>> +#ifdef CONFIG_DEBUG_RODATA_TEST
>> +extern const int rodata_test_data;
>> +int rodata_test(void);
>> +#else
>> +static inline int rodata_test(void)
>> +{
>> +     return 0;
>> +}
>> +#endif
>> +
>>  void flush_uprobe_xol_access(struct page *page, unsigned long uaddr,
>>                            void *kaddr, unsigned long len);
>>
>> diff --git a/arch/arm/mm/Makefile b/arch/arm/mm/Makefile
>> index b3dea80..dbb76ff 100644
>> --- a/arch/arm/mm/Makefile
>> +++ b/arch/arm/mm/Makefile
>> @@ -15,6 +15,7 @@ endif
>>  obj-$(CONFIG_ARM_PTDUMP)     += dump.o
>>  obj-$(CONFIG_MODULES)                += proc-syms.o
>>  obj-$(CONFIG_DEBUG_VIRTUAL)  += physaddr.o
>> +obj-$(CONFIG_DEBUG_RODATA_TEST)      += test_rodata.o
>>
>>  obj-$(CONFIG_ALIGNMENT_TRAP) += alignment.o
>>  obj-$(CONFIG_HIGHMEM)                += highmem.o
>> diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
>> index 4127f57..3c15f3b 100644
>> --- a/arch/arm/mm/init.c
>> +++ b/arch/arm/mm/init.c
>> @@ -716,6 +716,7 @@ void fix_kernmem_perms(void)
>>  int __mark_rodata_ro(void *unused)
>>  {
>>       update_sections_early(ro_perms, ARRAY_SIZE(ro_perms));
>> +     rodata_test();
>
> We don't do anything with this return value, should we at least
> spit out a warning?
>
>>       return 0;
>>  }
>>
>> @@ -740,6 +741,11 @@ void set_kernel_text_ro(void)
>>  static inline void fix_kernmem_perms(void) { }
>>  #endif /* CONFIG_DEBUG_RODATA */
>>
>> +#ifdef CONFIG_DEBUG_RODATA_TEST
>> +const int rodata_test_data = 0xC3;
>
> This isn't accessed outside of test_rodata.c, it can just
> be moved there.
>
>> +EXPORT_SYMBOL_GPL(rodata_test_data);
>> +#endif
>> +
>>  void free_tcmmem(void)
>>  {
>>  #ifdef CONFIG_HAVE_TCM
>> diff --git a/arch/arm/mm/test_rodata.c b/arch/arm/mm/test_rodata.c
>> new file mode 100644
>> index 0000000..133d092
>> --- /dev/null
>> +++ b/arch/arm/mm/test_rodata.c
>> @@ -0,0 +1,79 @@
>> +/*
>> + * test_rodata.c: functional test for mark_rodata_ro function
>> + *
>> + * (C) Copyright 2017 Jinbum Park <jinb.park7@gmail.com>
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License
>> + * as published by the Free Software Foundation; version 2
>> + * of the License.
>> + */
>> +#include <asm/cacheflush.h>
>> +#include <asm/sections.h>
>> +
>> +int rodata_test(void)
>> +{
>> +     unsigned long result;
>> +     unsigned long start, end;
>> +
>> +     /* test 1: read the value */
>> +     /* If this test fails, some previous testrun has clobbered the state */
>> +
>> +     if (!rodata_test_data) {
>> +             pr_err("rodata_test: test 1 fails (start data)\n");
>> +             return -ENODEV;
>> +     }
>> +
>> +     /* test 2: write to the variable; this should fault */
>> +     /*
>> +      * If this test fails, we managed to overwrite the data
>> +      *
>> +      * This is written in assembly to be able to catch the
>> +      * exception that is supposed to happen in the correct
>> +      * case
>> +     */
>> +
>> +     result = 1;
>> +     asm volatile(
>> +             "0:     str %[zero], [%[rodata_test]]\n"
>> +             "       mov %[rslt], %[zero]\n"
>> +             "1:\n"
>> +             ".pushsection .text.fixup,\"ax\"\n"
>> +             ".align 2\n"
>> +             "2:\n"
>> +             "b 1b\n"
>> +             ".popsection\n"
>> +             ".pushsection __ex_table,\"a\"\n"
>> +             ".align 3\n"
>> +             ".long 0b, 2b\n"
>> +             ".popsection\n"
>> +             : [rslt] "=r" (result)
>> +             : [zero] "r" (0UL), [rodata_test] "r" (&rodata_test_data)
>> +     );
>> +
>> +     if (!result) {
>> +             pr_err("rodata_test: test data was not read only\n");
>> +             return -ENODEV;
>> +     }
>> +
>> +     /* test 3: check the value hasn't changed */
>> +     /* If this test fails, we managed to overwrite the data */
>> +     if (!rodata_test_data) {
>> +             pr_err("rodata_test: Test 3 fails (end data)\n");
>> +             return -ENODEV;
>> +     }
>
> I'm confused why we are checking this again when we have the result
> check above. Is there a case where we would still have result = 1
> but rodata_test_data overwritten?
>
>> +
>> +     /* test 4: check if the rodata section is 4Kb aligned */
>> +     start = (unsigned long)__start_rodata;
>> +     end = (unsigned long)__end_rodata;
>> +     if (start & (PAGE_SIZE - 1)) {
>> +             pr_err("rodata_test: .rodata is not 4k aligned\n");
>> +             return -ENODEV;
>> +     }
>> +     if (end & (PAGE_SIZE - 1)) {
>> +             pr_err("rodata_test: .rodata end is not 4k aligned\n");
>> +             return -ENODEV;
>> +     }
>
> Why does this need to be page aligned (yes, I know why but this
> test case does not make it clear)
>
> Better yet, this should be a build time assertion not a runtime
> one.
>
>> +
>> +     return 0;
>> +}
>>
>
> As Mark mentioned, this is possibly redundant with LKDTM. It
> would be good to explain what benefit this is bringing in addition
> to LKDTM.

The only thing I could think of would be to make failures block the
boot. (Though that would mean changing x86 too.) That's kind of like
the W^X test, which spits out a BUG IIRC.

-Kees

-- 
Kees Cook
Nexus Security
