Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170118223629.GQ27312@n2100.armlinux.org.uk>
References: <20170118135310.GA4733@pjb1027-Latitude-E5410> <e5433e24-7a3d-25a4-26a3-9d02644cc3f4@redhat.com>
 <20170118223629.GQ27312@n2100.armlinux.org.uk>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 18 Jan 2017 15:35:37 -0800
Message-ID: <CAGXu5jJrKEgx5N2BPSaQ56GJtcuS9jzun7X6SFXBkTF4CnKwNQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] ARM: mm: add testcases for RODATA
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Laura Abbott <labbott@redhat.com>, Jinbum Park <jinb.park7@gmail.com>, Mark Rutland <mark.rutland@arm.com>, Florian Fainelli <f.fainelli@gmail.com>, Pawel Moll <pawel.moll@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kernel-janitors@vger.kernel.org, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Will Deacon <will.deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, Vladimir Murzin <vladimir.murzin@arm.com>, Andy Gross <andy.gross@linaro.org>, Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Jonathan Austin <jonathan.austin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 18, 2017 at 2:36 PM, Russell King - ARM Linux
<linux@armlinux.org.uk> wrote:
> On Wed, Jan 18, 2017 at 11:20:54AM -0800, Laura Abbott wrote:
>> On 01/18/2017 05:53 AM, Jinbum Park wrote:
>> > diff --git a/arch/arm/include/asm/cacheflush.h b/arch/arm/include/asm/cacheflush.h
>> > index bdd283b..741e2e8 100644
>> > --- a/arch/arm/include/asm/cacheflush.h
>> > +++ b/arch/arm/include/asm/cacheflush.h
>> > @@ -498,6 +498,16 @@ static inline void set_kernel_text_rw(void) { }
>> >  static inline void set_kernel_text_ro(void) { }
>> >  #endif
>> >
>> > +#ifdef CONFIG_DEBUG_RODATA_TEST
>> > +extern const int rodata_test_data;
>> > +int rodata_test(void);
>> > +#else
>> > +static inline int rodata_test(void)
>> > +{
>> > +   return 0;
>> > +}
>> > +#endif
>> > +
>
> I don't see why this needs to be in cacheflush.h - it doesn't seem to
> have anything to do with cache flushing, and placing it in here means
> that if you change the state of CONFIG_DEBUG_RODATA_TEST, most likely
> the entire kernel gets rebuilt.  Please put it in a separate header
> file.
>
>> > diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
>> > index 4127f57..3c15f3b 100644
>> > --- a/arch/arm/mm/init.c
>> > +++ b/arch/arm/mm/init.c
>> > @@ -716,6 +716,7 @@ void fix_kernmem_perms(void)
>> >  int __mark_rodata_ro(void *unused)
>> >  {
>> >     update_sections_early(ro_perms, ARRAY_SIZE(ro_perms));
>> > +   rodata_test();
>>
>> We don't do anything with this return value, should we at least
>> spit out a warning?
>>
>> >     return 0;
>> >  }
>> >
>> > @@ -740,6 +741,11 @@ void set_kernel_text_ro(void)
>> >  static inline void fix_kernmem_perms(void) { }
>> >  #endif /* CONFIG_DEBUG_RODATA */
>> >
>> > +#ifdef CONFIG_DEBUG_RODATA_TEST
>> > +const int rodata_test_data = 0xC3;

Oh, I missed this the first time: this may be misleading: 0xc3 is x86
"ret", and is used on x86 for it's test_nx.c file. (Which, IIRC,
hasn't worked correctly for years now since the exception tables were
made relative on x86. Getting this fixed too would be nice!)

>> This isn't accessed outside of test_rodata.c, it can just
>> be moved there.

Just for background, on x86 it's referenced by both test_rodata.c and test_nx.c.

> I think the intention was to place it in some .c file which gets built
> into the kernel, rather than a module, so testing whether read-only
> data in the kernel image is read-only.
>
> If it's placed in a module, then you're only checking that read-only
> data in the module is read-only (which is another test which should
> be done!)
>
> In any case, placing it in arch/arm/mm/init.c seems unnecessary, I'd
> rather it went in its own separate file.
>
>> > diff --git a/arch/arm/mm/test_rodata.c b/arch/arm/mm/test_rodata.c
>> > new file mode 100644
>> > index 0000000..133d092
>> > --- /dev/null
>> > +++ b/arch/arm/mm/test_rodata.c
>> > @@ -0,0 +1,79 @@
>> > +/*
>> > + * test_rodata.c: functional test for mark_rodata_ro function
>> > + *
>> > + * (C) Copyright 2017 Jinbum Park <jinb.park7@gmail.com>
>> > + *
>> > + * This program is free software; you can redistribute it and/or
>> > + * modify it under the terms of the GNU General Public License
>> > + * as published by the Free Software Foundation; version 2
>> > + * of the License.
>> > + */
>> > +#include <asm/cacheflush.h>
>> > +#include <asm/sections.h>
>> > +
>> > +int rodata_test(void)
>> > +{
>> > +   unsigned long result;
>> > +   unsigned long start, end;
>> > +
>> > +   /* test 1: read the value */
>> > +   /* If this test fails, some previous testrun has clobbered the state */
>> > +
>> > +   if (!rodata_test_data) {
>> > +           pr_err("rodata_test: test 1 fails (start data)\n");
>> > +           return -ENODEV;
>> > +   }
>> > +
>> > +   /* test 2: write to the variable; this should fault */
>> > +   /*
>> > +    * If this test fails, we managed to overwrite the data
>> > +    *
>> > +    * This is written in assembly to be able to catch the
>> > +    * exception that is supposed to happen in the correct
>> > +    * case
>> > +   */
>> > +
>> > +   result = 1;
>> > +   asm volatile(
>> > +           "0:     str %[zero], [%[rodata_test]]\n"
>> > +           "       mov %[rslt], %[zero]\n"
>> > +           "1:\n"
>> > +           ".pushsection .text.fixup,\"ax\"\n"
>> > +           ".align 2\n"
>> > +           "2:\n"
>> > +           "b 1b\n"
>> > +           ".popsection\n"
>> > +           ".pushsection __ex_table,\"a\"\n"
>> > +           ".align 3\n"
>> > +           ".long 0b, 2b\n"
>> > +           ".popsection\n"
>> > +           : [rslt] "=r" (result)
>> > +           : [zero] "r" (0UL), [rodata_test] "r" (&rodata_test_data)
>> > +   );
>> > +
>> > +   if (!result) {
>> > +           pr_err("rodata_test: test data was not read only\n");
>> > +           return -ENODEV;
>> > +   }
>> > +
>> > +   /* test 3: check the value hasn't changed */
>> > +   /* If this test fails, we managed to overwrite the data */
>> > +   if (!rodata_test_data) {
>> > +           pr_err("rodata_test: Test 3 fails (end data)\n");
>> > +           return -ENODEV;
>> > +   }
>>
>> I'm confused why we are checking this again when we have the result
>> check above. Is there a case where we would still have result = 1
>> but rodata_test_data overwritten?
>
> Seems sensible when you consider that "result" tests that _a_ fault
> happened.  Verifying that the data wasn't changed seems like a belt
> and braces approach, which ensures that the location really has not
> been modified.
>
> IOW, the test is "make sure that read-only data is not modified" not
> "make sure that writing to read-only data causes a fault".  They're
> two subtly different tests.
>
>> As Mark mentioned, this is possibly redundant with LKDTM. It
>> would be good to explain what benefit this is bringing in addition
>> to LKDTM.
>
> Finding https://lwn.net/Articles/198690/ and github links, it doesn't
> seem obvious that LKDTM actually does this.  It seems more focused on
> creating crashdumps than testing that (in this instance) write
> protection works - and it seems to be a destructive test.

The WRITE_RO and EXEC_RODATA tests perform similar tests, but yes, it
is intentionally destructive: it is exercising the entire protection
and kernel oops, etc.

-Kees

-- 
Kees Cook
Nexus Security
