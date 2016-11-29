Reply-To: kernel-hardening@lists.openwall.com
References: <1480008765-3876-1-git-send-email-matt.redfearn@imgtec.com>
 <CAGXu5jLT-V3+3_KSAfxbN3yY22xRh3tvs1wpL+mwk1En8MC6Bg@mail.gmail.com>
 <a8dd7013-979a-6352-cc75-68383a111ff0@imgtec.com>
 <CAGXu5j+VNnaVtARQL=Xcdy3jtd+Tt+Akp5gKHOu5hvVRfiSbyg@mail.gmail.com>
From: Dan Cashman <dcashman@android.com>
Message-ID: <74bc3b7a-d2ed-0865-e07a-e9e5da65710f@android.com>
Date: Mon, 28 Nov 2016 16:47:03 -0800
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+VNnaVtARQL=Xcdy3jtd+Tt+Akp5gKHOu5hvVRfiSbyg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] MIPS: Add support for ARCH_MMAP_RND_{COMPAT_}BITS
To: Kees Cook <keescook@chromium.org>, Matt Redfearn <matt.redfearn@imgtec.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, Linux MIPS Mailing List <linux-mips@linux-mips.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

As can be seen from the following comment in arch/arm64/Kconfig:
""
# max bits determined by the following formula:
#  VA_BITS - PAGE_SHIFT - 3
config ARCH_MMAP_RND_BITS_MAX
"""

The max value was determined based on the available address space 
(VA_BITS - PAGE_SHIFT) and an account of how far mmap_base could be 
moved (the "- 3" part).  MIPS uses the same calculation for the MAX_GAP 
in arch/mips/mm/mmap.c, namely 5/6 the TASK_SIZE, so I'd expect a 
similar formula for MIPS from a cursory first-glance.

These values likely will stick, so it'd be best to get them to be as 
large as possible from the get-go.  I imagine something similar to ARM64 
would be set up based on the following in 
arch/mips/include/asm/processor.h, but of course defer to the mips 
maintainer:

"""
#ifdef CONFIG_MIPS_VA_BITS_48
#define TASK_SIZE64     (0x1UL << 
((cpu_data[0].vmbits>48)?48:cpu_data[0].vmbits))
#else
#define TASK_SIZE64     0x10000000000UL
#endif
"""

Thanks,
Dan

On 11/28/16 10:17 AM, Kees Cook wrote:
> On Mon, Nov 28, 2016 at 8:10 AM, Matt Redfearn <matt.redfearn@imgtec.com> wrote:
>> Hi Kees
>>
>>
>>
>> On 25/11/16 20:00, Kees Cook wrote:
>>>
>>> On Thu, Nov 24, 2016 at 9:32 AM, Matt Redfearn <matt.redfearn@imgtec.com>
>>> wrote:
>>>>
>>>> arch_mmap_rnd() uses hard-coded limits of 16MB for the randomisation
>>>> of mmap within 32bit processes and 256MB in 64bit processes. Since v4.4
>>>> other arches support tuning this value in /proc/sys/vm/mmap_rnd_bits.
>>>> Add support for this to MIPS.
>>>>
>>>> Set the minimum(default) number of bits randomisation for 32bit to 8 -
>>>> which with 4k pagesize is unchanged from the current 16MB total
>>>> randomness. The minimum(default) for 64bit is 12bits, again with 4k
>>>> pagesize this is the same as the current 256MB.
>>>>
>>>> This patch is necessary for MIPS32 to pass the Android CTS tests, with
>>>> the number of random bits set to 15.
>>>>
>>>> Signed-off-by: Matt Redfearn <matt.redfearn@imgtec.com>
>>>> ---
>>>>
>>>>   arch/mips/Kconfig   | 16 ++++++++++++++++
>>>>   arch/mips/mm/mmap.c | 10 +++++-----
>>>>   2 files changed, 21 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
>>>> index b3c5bde43d34..d72cf6129b2c 100644
>>>> --- a/arch/mips/Kconfig
>>>> +++ b/arch/mips/Kconfig
>>>> @@ -13,6 +13,8 @@ config MIPS
>>>>          select HAVE_PERF_EVENTS
>>>>          select PERF_USE_VMALLOC
>>>>          select HAVE_ARCH_KGDB
>>>> +       select HAVE_ARCH_MMAP_RND_BITS if MMU
>>>> +       select HAVE_ARCH_MMAP_RND_COMPAT_BITS if MMU && COMPAT
>>>>          select HAVE_ARCH_SECCOMP_FILTER
>>>>          select HAVE_ARCH_TRACEHOOK
>>>>          select HAVE_CBPF_JIT if !CPU_MICROMIPS
>>>> @@ -3073,6 +3075,20 @@ config MMU
>>>>          bool
>>>>          default y
>>>>
>>>> +config ARCH_MMAP_RND_BITS_MIN
>>>> +       default 12 if 64BIT
>>>> +       default 8
>>>> +
>>>> +config ARCH_MMAP_RND_BITS_MAX
>>>> +       default 18 if 64BIT
>>>> +       default 15
>>>> +
>>>> +config ARCH_MMAP_RND_COMPAT_BITS_MIN
>>>> +       default 8
>>>> +
>>>> +config ARCH_MMAP_RND_COMPAT_BITS_MAX
>>>> +       default 15
>>>> +
>>>>   config I8253
>>>>          bool
>>>>          select CLKSRC_I8253
>>>> diff --git a/arch/mips/mm/mmap.c b/arch/mips/mm/mmap.c
>>>> index d08ea3ff0f53..d6d92c02308d 100644
>>>> --- a/arch/mips/mm/mmap.c
>>>> +++ b/arch/mips/mm/mmap.c
>>>> @@ -146,14 +146,14 @@ unsigned long arch_mmap_rnd(void)
>>>>   {
>>>>          unsigned long rnd;
>>>>
>>>> -       rnd = get_random_long();
>>>> -       rnd <<= PAGE_SHIFT;
>>>> +#ifdef CONFIG_COMPAT
>>>>          if (TASK_IS_32BIT_ADDR)
>>>> -               rnd &= 0xfffffful;
>>>> +               rnd = get_random_long() & ((1UL << mmap_rnd_compat_bits)
>>>> - 1);
>>>>          else
>>>> -               rnd &= 0xffffffful;
>>>> +#endif /* CONFIG_COMPAT */
>>>> +               rnd = get_random_long() & ((1UL << mmap_rnd_bits) - 1);
>>>>
>>>> -       return rnd;
>>>> +       return rnd << PAGE_SHIFT;
>>>>   }
>>>>
>>>>   void arch_pick_mmap_layout(struct mm_struct *mm)
>>>> --
>>>> 2.7.4
>>>>
>>> Excellent!
>>>
>>> Reviewed-by: Kees Cook <keescook@chromium.org>
>>>
>>> Out of curiosity, how were the maxs of 15 and 18 chosen?
>>
>>
>> The maximum of 15 bits for 32 bit processes was the minimum required to pass
>> the Android CTS tests with Nougat using 4k pages, but with 64k pages would
>> be on the limit of the virtual address space. For 64 bit processes, I just
>> allowed an 3 extra bits of randomness within the larger virtual address
>> space, similar to the ARM64 limit.
>
> arm64's limit depends on the VA size. What does MIPS's 64-bit VA space
> look like? e.g. by default on arm64 with 4k pages, the VA space is 39
> bits, which gives 24 bits of entropy (rather than 18 here, which seems
> low to me for a 64-bit userspace).
>
> -Kees
>
