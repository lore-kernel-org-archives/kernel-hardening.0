MIME-Version: 1.0
In-Reply-To: <CAGXu5j+rO=1vOZ+L7DkJc=Ad3YTMFZvOeWQiW14inHRP=rN9fg@mail.gmail.com>
References: <1486014168-1279-1-git-send-email-bhsharma@redhat.com>
 <1486014168-1279-2-git-send-email-bhsharma@redhat.com> <CAGXu5j+rO=1vOZ+L7DkJc=Ad3YTMFZvOeWQiW14inHRP=rN9fg@mail.gmail.com>
From: Bhupesh Sharma <bhsharma@redhat.com>
Date: Thu, 2 Feb 2017 23:34:10 +0530
Message-ID: <CACi5LpNskCJL8OG-7Mi1_Q+2BEJgvstt2v7n8KmB0Y=W=BTvyA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 1/2] powerpc: mm: support ARCH_MMAP_RND_BITS
To: Kees Cook <keescook@chromium.org>
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Daniel Cashman <dcashman@google.com>, Michael Ellerman <mpe@ellerman.id.au>, Bhupesh SHARMA <bhupesh.linux@gmail.com>, Alexander Graf <agraf@suse.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Anatolij Gustschin <agust@denx.de>, Alistair Popple <alistair@popple.id.au>, Matt Porter <mporter@kernel.crashing.org>, Vitaly Bordug <vitb@kernel.crashing.org>, Scott Wood <oss@buserror.net>, Kumar Gala <galak@kernel.crashing.org>, Daniel Cashman <dcashman@android.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Kees,

On Thu, Feb 2, 2017 at 7:55 PM, Kees Cook <keescook@chromium.org> wrote:
> On Wed, Feb 1, 2017 at 9:42 PM, Bhupesh Sharma <bhsharma@redhat.com> wrote:
>> powerpc: arch_mmap_rnd() uses hard-coded values, (23-PAGE_SHIFT) for
>> 32-bit and (30-PAGE_SHIFT) for 64-bit, to generate the random offset
>> for the mmap base address.
>>
>> This value represents a compromise between increased
>> ASLR effectiveness and avoiding address-space fragmentation.
>> Replace it with a Kconfig option, which is sensibly bounded, so that
>> platform developers may choose where to place this compromise.
>> Keep default values as new minimums.
>>
>> This patch makes sure that now powerpc mmap arch_mmap_rnd() approach
>> is similar to other ARCHs like x86, arm64 and arm.
>>
>> Cc: Alexander Graf <agraf@suse.com>
>> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> Cc: Paul Mackerras <paulus@samba.org>
>> Cc: Michael Ellerman <mpe@ellerman.id.au>
>> Cc: Anatolij Gustschin <agust@denx.de>
>> Cc: Alistair Popple <alistair@popple.id.au>
>> Cc: Matt Porter <mporter@kernel.crashing.org>
>> Cc: Vitaly Bordug <vitb@kernel.crashing.org>
>> Cc: Scott Wood <oss@buserror.net>
>> Cc: Kumar Gala <galak@kernel.crashing.org>
>> Cc: Daniel Cashman <dcashman@android.com>
>> Cc: Kees Cook <keescook@chromium.org>
>> Signed-off-by: Bhupesh Sharma <bhsharma@redhat.com>
>> ---
>>  arch/powerpc/Kconfig   | 34 ++++++++++++++++++++++++++++++++++
>>  arch/powerpc/mm/mmap.c |  7 ++++---
>>  2 files changed, 38 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
>> index a8ee573fe610..b4a843f68705 100644
>> --- a/arch/powerpc/Kconfig
>> +++ b/arch/powerpc/Kconfig
>> @@ -22,6 +22,38 @@ config MMU
>>         bool
>>         default y
>>
>> +config ARCH_MMAP_RND_BITS_MIN
>> +       default 5 if PPC_256K_PAGES && 32BIT
>> +       default 12 if PPC_256K_PAGES && 64BIT
>> +       default 7 if PPC_64K_PAGES && 32BIT
>> +       default 14 if PPC_64K_PAGES && 64BIT
>> +       default 9 if PPC_16K_PAGES && 32BIT
>> +       default 16 if PPC_16K_PAGES && 64BIT
>> +       default 11 if PPC_4K_PAGES && 32BIT
>> +       default 18 if PPC_4K_PAGES && 64BIT
>> +
>> +# max bits determined by the following formula:
>> +#  VA_BITS - PAGE_SHIFT - 4
>> +#  for e.g for 64K page and 64BIT = 48 - 16 - 4 = 28
>> +config ARCH_MMAP_RND_BITS_MAX
>> +       default 10 if PPC_256K_PAGES && 32BIT
>> +       default 26 if PPC_256K_PAGES && 64BIT
>> +       default 12 if PPC_64K_PAGES && 32BIT
>> +       default 28 if PPC_64K_PAGES && 64BIT
>> +       default 14 if PPC_16K_PAGES && 32BIT
>> +       default 30 if PPC_16K_PAGES && 64BIT
>> +       default 16 if PPC_4K_PAGES && 32BIT
>> +       default 32 if PPC_4K_PAGES && 64BIT
>> +
>> +config ARCH_MMAP_RND_COMPAT_BITS_MIN
>> +       default 5 if PPC_256K_PAGES
>> +       default 7 if PPC_64K_PAGES
>> +       default 9 if PPC_16K_PAGES
>> +       default 11
>> +
>> +config ARCH_MMAP_RND_COMPAT_BITS_MAX
>> +       default 16
>> +
>>  config HAVE_SETUP_PER_CPU_AREA
>>         def_bool PPC64
>>
>> @@ -100,6 +132,8 @@ config PPC
>>         select HAVE_EFFICIENT_UNALIGNED_ACCESS if !(CPU_LITTLE_ENDIAN && POWER7_CPU)
>>         select HAVE_KPROBES
>>         select HAVE_ARCH_KGDB
>> +       select HAVE_ARCH_MMAP_RND_BITS
>> +       select HAVE_ARCH_MMAP_RND_COMPAT_BITS if COMPAT
>>         select HAVE_KRETPROBES
>>         select HAVE_ARCH_TRACEHOOK
>>         select HAVE_MEMBLOCK
>> diff --git a/arch/powerpc/mm/mmap.c b/arch/powerpc/mm/mmap.c
>> index 2f1e44362198..babf59faab3b 100644
>> --- a/arch/powerpc/mm/mmap.c
>> +++ b/arch/powerpc/mm/mmap.c
>> @@ -60,11 +60,12 @@ unsigned long arch_mmap_rnd(void)
>>  {
>>         unsigned long rnd;
>>
>> -       /* 8MB for 32bit, 1GB for 64bit */
>> +#ifdef CONFIG_COMPAT
>>         if (is_32bit_task())
>> -               rnd = get_random_long() % (1<<(23-PAGE_SHIFT));
>> +               rnd = get_random_long() & ((1UL << mmap_rnd_compat_bits) - 1);
>>         else
>> -               rnd = get_random_long() % (1UL<<(30-PAGE_SHIFT));
>> +#endif
>> +               rnd = get_random_long() & ((1UL << mmap_rnd_bits) - 1);
>>
>>         return rnd << PAGE_SHIFT;
>>  }
>
> Awesome! This looks good to me based on my earlier analysis.
>
> Reviewed-by: Kees Cook <keescook@chromium.org>

Many thanks.
Regards,
Bhupesh
