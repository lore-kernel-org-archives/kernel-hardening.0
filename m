Sender: Hans Liljestrand <ishkamiel@gmail.com>
Date: Tue, 25 Jul 2017 11:17:00 +0300
From: Hans Liljestrand <liljestrandh@gmail.com>
Message-ID: <20170725081700.q3prib2h3tvodg2h@ishxps>
References: <20170724133824.27223-1-LiljestrandH@gmail.com>
 <20170724133824.27223-6-LiljestrandH@gmail.com>
 <CAGXu5j+nu2V1Uy0qAbXxN1QzsnZwarA6ddPN5ORBkEQXQKa=+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAGXu5j+nu2V1Uy0qAbXxN1QzsnZwarA6ddPN5ORBkEQXQKa=+g@mail.gmail.com>
Subject: [kernel-hardening] Re: [RFC PATCH 5/5] lkdtm: Add kernel MPX testing
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Reshetova, Elena" <elena.reshetova@intel.com>, Dave Hansen <dave.hansen@intel.com>, "H. Peter Anvin" <hpa@zytor.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jul 24, 2017 at 08:11:15PM -0700, Kees Cook wrote:
>On Mon, Jul 24, 2017 at 6:38 AM, Hans Liljestrand
><liljestrandh@gmail.com> wrote:
>> Tests MPXK functionality via lkdtm test cases. Currently tests basic
>> bound propagation and instrumentation for memcpy and kmalloc.
>>
>> Signed-off-by: Hans Liljestrand <LiljestrandH@gmail.com>
>> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
>> ---
>>  drivers/misc/Makefile          |   7 +++
>>  drivers/misc/lkdtm.h           |   7 +++
>>  drivers/misc/lkdtm_core.c      |   6 +++
>>  drivers/misc/lkdtm_mpxk.c      | 115 +++++++++++++++++++++++++++++++++++++++++
>>  drivers/misc/lkdtm_mpxk.h      |  11 ++++
>>  drivers/misc/lkdtm_mpxk_base.c |  65 +++++++++++++++++++++++
>
>Organizationally speaking, I'd prefer this was all in one file: lkdtm_mpxk.c

Okay. I originally separated these to make sure we don't run into issues with 
linking, but since that hasn't proven to be an issue in these kinds of cases 
there's no reason to put them all into one.

>
>>  6 files changed, 211 insertions(+)
>>  create mode 100644 drivers/misc/lkdtm_mpxk.c
>>  create mode 100644 drivers/misc/lkdtm_mpxk.h
>>  create mode 100644 drivers/misc/lkdtm_mpxk_base.c
>>
>> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
>> index 81ef3e67acc9..58d9ba43e081 100644
>> --- a/drivers/misc/Makefile
>> +++ b/drivers/misc/Makefile
>> @@ -64,6 +64,13 @@ lkdtm-$(CONFIG_LKDTM)                += lkdtm_usercopy.o
>>
>>  KCOV_INSTRUMENT_lkdtm_rodata.o := n
>>
>> +ifdef CONFIG_X86_INTEL_MPX_KERNEL
>> +       lkdtm-$(CONFIG_LKDTM)           += lkdtm_mpxk.o
>> +       lkdtm-$(CONFIG_LKDTM)           += lkdtm_mpxk_base.o
>> +       CFLAGS_lkdtm_mpxk.o             += $(MPXK_CFLAGS)
>> +       CFLAGS_lkdtm_mpxk_base.o        += $(MPXK_CFLAGS)
>> +endif
>
>Operationally, I'd like to find a way for these tests to be added
>unconditionally (i.e. built with either CONFIG_X86_INTEL_MPX_KERNEL
>enabled or disabled.) They would, obviously, all fail without MPXK.

Sure. The compiler intrinsic functions probably will not get recognized, but I 
can instead conditionally replace them with with nop macros (in lkdtm_mpxk.c).

>
>> +
>>  OBJCOPYFLAGS :=
>>  OBJCOPYFLAGS_lkdtm_rodata_objcopy.o := \
>>                         --set-section-flags .text=alloc,readonly \
>> diff --git a/drivers/misc/lkdtm.h b/drivers/misc/lkdtm.h
>> index 3b4976396ec4..46cecd01db92 100644
>> --- a/drivers/misc/lkdtm.h
>> +++ b/drivers/misc/lkdtm.h
>> @@ -29,6 +29,13 @@ void lkdtm_CORRUPT_LIST_ADD(void);
>>  void lkdtm_CORRUPT_LIST_DEL(void);
>>  void lkdtm_CORRUPT_USER_DS(void);
>>
>> +#ifdef CONFIG_X86_INTEL_MPX_KERNEL
>> +void lkdtm_MPXK_LOAD_BOUNDS(void);
>> +void lkdtm_MPXK_FUNCTION_ARGS(void);
>> +void lkdtm_MPXK_KMALLOC(void);
>> +void lkdtm_MPXK_MEMCPY(void);
>> +#endif
>> +
>
>It would allow dropping all these ifdefs too.
>
>>  /* lkdtm_heap.c */
>>  void lkdtm_OVERWRITE_ALLOCATION(void);
>>  void lkdtm_WRITE_AFTER_FREE(void);
>> diff --git a/drivers/misc/lkdtm_core.c b/drivers/misc/lkdtm_core.c
>> index 42d2b8e31e6b..74e258ddc5fe 100644
>> --- a/drivers/misc/lkdtm_core.c
>> +++ b/drivers/misc/lkdtm_core.c
>> @@ -235,6 +235,12 @@ struct crashtype crashtypes[] = {
>>         CRASHTYPE(USERCOPY_STACK_FRAME_FROM),
>>         CRASHTYPE(USERCOPY_STACK_BEYOND),
>>         CRASHTYPE(USERCOPY_KERNEL),
>> +#ifdef CONFIG_X86_INTEL_MPX_KERNEL
>> +       CRASHTYPE(MPXK_LOAD_BOUNDS),
>> +       CRASHTYPE(MPXK_FUNCTION_ARGS),
>> +       CRASHTYPE(MPXK_KMALLOC),
>> +       CRASHTYPE(MPXK_MEMCPY)
>> +#endif
>>  };
>>
>>
>> diff --git a/drivers/misc/lkdtm_mpxk.c b/drivers/misc/lkdtm_mpxk.c
>> new file mode 100644
>> index 000000000000..b957d3641378
>> --- /dev/null
>> +++ b/drivers/misc/lkdtm_mpxk.c
>> @@ -0,0 +1,115 @@
>> +#undef pr_fmt
>> +#include "lkdtm_mpxk.h"
>> +#include <linux/list.h>
>> +#include <linux/sched.h>
>> +#include <linux/time.h>
>> +#include <linux/slab.h>
>> +#include <linux/printk.h>
>> +#include <asm/mpxk.h>
>> +
>> +/** lkdtm_MPXK_LOAD_BOUNDS - test mpxk_bound_load
>> + *
>> + * Tests mpxk_load_bounds function by passing pointers into function via an
>> + * array. The bounds for the array itself are passed via the bnd0 register, but
>> + * MPX cannot do that for the internal pointers, hence it uses BNDSTX+BNDLDX.
>> + * MPXK therefore must use mpxk_load_bounds to retrieve the bounds inside the
>> + * called function.
>> + */
>> +void lkdtm_MPXK_LOAD_BOUNDS(void)
>> +{
>> +       int i;
>> +       char *arr[10];
>> +
>> +       for (i = 0; i < 10; i++)
>> +               arr[i] = kmalloc(16, GFP_KERNEL);
>> +
>> +       pr_info("attempting good ptr write\n");
>> +       mpxk_write_arr_i(arr, 2, 0);
>> +
>> +       /* This could succeed because mpxk_load_bounds retrieved the size based
>> +        * on the pointer value via ksize, which in turn doesn't necessarily
>> +        * return the exact size that was passed into kmalloc. The size is none
>> +        * the less guaranteed to be "safe" in that it will not be reserved
>> +        * elsewhere.
>> +        */
>> +       pr_info("attempting exact (+1) bad ptr write (can succeed)");
>> +       mpxk_write_arr_i(arr, 4, 16);
>> +
>> +       pr_info("attempting real bad ptr write (should be caught)\n");
>> +       mpxk_write_arr_i(arr, 5, 1024);
>> +
>> +       for (i = 0; i < 10; i++)
>> +               kfree(arr[i]);
>> +}
>
>Instead of these mpxk_write_arr_i() wrappers, I'd prefer just seeing a
>direct use of the standard kernel APIs or memory accesses. 

I'm not sure if I understand what you mean by this?

The reason I use the awkward wrapper is that I try to force the compiler to 
not optimize away the specific compile time instrumentation I want to test.  
If I just inline the above tests the compiler might optimize in a way that 
eliminates the mpxk_load_bounds call. By forcing the pointers in via an array 
I make sure the "test-site" cannot get the bounds from anywhere else.

That said, I agree that the mpxk_write_arr_i stuff looks horrible and that 
this could probably be done in some better way. Any advice on how to do that 
without having the compiler potentially mess things up?

>The "SOFT
>TEST" stuff doesn't make sense to me here -- lkdtm should either pass
>loudly (with WARN, BUG, etc) or fail quietly.

Yes sorry about the SOFT_TEST stuff, that is a remnant of my own testing. Will 
remove!

Thanks again!
-hans

>
>-Kees
>
>-- 
>Kees Cook
>Pixel Security
