MIME-Version: 1.0
In-Reply-To: <1492698980-19510-1-git-send-email-mpe@ellerman.id.au>
References: <1492698980-19510-1-git-send-email-mpe@ellerman.id.au>
From: Bhupesh Sharma <bhsharma@redhat.com>
Date: Fri, 21 Apr 2017 12:19:41 +0530
Message-ID: <CACi5LpNJW9y9q-3qUtj3d9m8oC7i=1vKuDnbiDeiekxP0gH8zA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2] powerpc/mm: Add support for runtime configuration of
 ASLR limits
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@ozlabs.org, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Michael,

Thanks for the v2. It looks good.

On Thu, Apr 20, 2017 at 8:06 PM, Michael Ellerman <mpe@ellerman.id.au> wrote:
> Add powerpc support for mmap_rnd_bits and mmap_rnd_compat_bits, which are two
> sysctls that allow a user to configure the number of bits of randomness used for
> ASLR.
>
> Because of the way the Kconfig for ARCH_MMAP_RND_BITS is defined, we have to
> construct at least the MIN value in Kconfig, vs in a header which would be more
> natural. Given that we just go ahead and do it all in Kconfig.
>
> At least according to the code (the documentation makes no mention of it), the
> value is defined as the number of bits of randomisation *of the page*, not the
> address. This makes some sense, with larger page sizes more of the low bits are
> forced to zero, which would reduce the randomisation if we didn't take the
> PAGE_SIZE into account. However it does mean the min/max values have to change
> depending on the PAGE_SIZE in order to actually limit the amount of address
> space consumed by the randomisation.
>
> The result of that is that we have to define the default values based on both
> 32-bit vs 64-bit, but also the configured PAGE_SIZE. Furthermore now that we
> have 128TB address space support on Book3S, we also have to take that into
> account.
>
> Finally we can wire up the value in arch_mmap_rnd().
>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> Signed-off-by: Bhupesh Sharma <bhsharma@redhat.com>
> ---
>  arch/powerpc/Kconfig   | 44 ++++++++++++++++++++++++++++++++++++++++++++
>  arch/powerpc/mm/mmap.c | 11 ++++++-----
>  2 files changed, 50 insertions(+), 5 deletions(-)
>
> v2: Fix the 32-bit MAX value incorrectly using MIN as spotted by Kees.
>
> Kees/Bhupesh, would love a Review/Ack/Tested-by from you, I'll plan to merge
> this later today (Friday) my time.
>
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index 97a8bc8a095c..6f0503951e94 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -22,6 +22,48 @@ config MMU
>         bool
>         default y
>
> +config ARCH_MMAP_RND_BITS_MAX
> +       # On Book3S 64, the default virtual address space for 64-bit processes
> +       # is 2^47 (128TB). As a maximum, allow randomisation to consume up to
> +       # 32T of address space (2^45), which should ensure a reasonable gap
> +       # between bottom-up and top-down allocations for applications that
> +       # consume "normal" amounts of address space. Book3S 64 only supports 64K
> +       # and 4K page sizes.
> +       default 29 if PPC_BOOK3S_64 && PPC_64K_PAGES # 29 = 45 (32T) - 16 (64K)
> +       default 33 if PPC_BOOK3S_64                  # 33 = 45 (32T) - 12 (4K)
> +       #
> +       # On all other 64-bit platforms (currently only Book3E), the virtual
> +       # address space is 2^46 (64TB). Allow randomisation to consume up to 16T
> +       # of address space (2^44). Only 4K page sizes are supported.
> +       default 32 if 64BIT     # 32 = 44 (16T) - 12 (4K)
> +       #
> +       # For 32-bit, use the compat values, as they're the same.
> +       default ARCH_MMAP_RND_COMPAT_BITS_MAX
> +
> +config ARCH_MMAP_RND_BITS_MIN
> +       # Allow randomisation to consume up to 1GB of address space (2^30).
> +       default 14 if 64BIT && PPC_64K_PAGES    # 14 = 30 (1GB) - 16 (64K)
> +       default 18 if 64BIT                     # 18 = 30 (1GB) - 12 (4K)
> +       #
> +       # For 32-bit, use the compat values, as they're the same.
> +       default ARCH_MMAP_RND_COMPAT_BITS_MIN
> +
> +config ARCH_MMAP_RND_COMPAT_BITS_MAX
> +       # Total virtual address space for 32-bit processes is 2^31 (2GB).
> +       # Allow randomisation to consume up to 512MB of address space (2^29).
> +       default 11 if PPC_256K_PAGES    # 11 = 29 (512MB) - 18 (256K)
> +       default 13 if PPC_64K_PAGES     # 13 = 29 (512MB) - 16 (64K)
> +       default 15 if PPC_16K_PAGES     # 15 = 29 (512MB) - 14 (16K)
> +       default 17                      # 17 = 29 (512MB) - 12 (4K)
> +
> +config ARCH_MMAP_RND_COMPAT_BITS_MIN
> +       # Total virtual address space for 32-bit processes is 2^31 (2GB).
> +       # Allow randomisation to consume up to 8MB of address space (2^23).
> +       default 5 if PPC_256K_PAGES     #  5 = 23 (8MB) - 18 (256K)
> +       default 7 if PPC_64K_PAGES      #  7 = 23 (8MB) - 16 (64K)
> +       default 9 if PPC_16K_PAGES      #  9 = 23 (8MB) - 14 (16K)
> +       default 11                      # 11 = 23 (8MB) - 12 (4K)
> +
>  config HAVE_SETUP_PER_CPU_AREA
>         def_bool PPC64
>
> @@ -120,6 +162,8 @@ config PPC
>         select HAVE_ARCH_HARDENED_USERCOPY
>         select HAVE_ARCH_JUMP_LABEL
>         select HAVE_ARCH_KGDB
> +       select HAVE_ARCH_MMAP_RND_BITS
> +       select HAVE_ARCH_MMAP_RND_COMPAT_BITS   if COMPAT
>         select HAVE_ARCH_SECCOMP_FILTER
>         select HAVE_ARCH_TRACEHOOK
>         select HAVE_CBPF_JIT                    if !PPC64
> diff --git a/arch/powerpc/mm/mmap.c b/arch/powerpc/mm/mmap.c
> index a5d9ef59debe..6141cfff634e 100644
> --- a/arch/powerpc/mm/mmap.c
> +++ b/arch/powerpc/mm/mmap.c
> @@ -59,13 +59,14 @@ static inline int mmap_is_legacy(void)
>
>  unsigned long arch_mmap_rnd(void)
>  {
> -       unsigned long rnd;
> +       unsigned long shift, rnd;
>
> -       /* 8MB for 32bit, 1GB for 64bit */
> +       shift = mmap_rnd_bits;
> +#ifdef CONFIG_COMPAT
>         if (is_32bit_task())
> -               rnd = get_random_long() % (1<<(23-PAGE_SHIFT));
> -       else
> -               rnd = get_random_long() % (1UL<<(30-PAGE_SHIFT));
> +               shift = mmap_rnd_compat_bits;
> +#endif
> +       rnd = get_random_long() % (1 << shift);
>
>         return rnd << PAGE_SHIFT;
>  }
> --
> 2.7.4

I used a simple program to dump the load address used for a ASLR elf
on the RHEL PPC64LE platform using the above patch:

1. Create a test PIE program which shows its own memory map:

$ cat show_mmap_pie.c
#include <stdlib.h>
#include <stdio.h>

int main(void){
    char command[1024];
    sprintf(command,"cat /proc/%d/maps",getpid());
    system(command);
    return 0;
}

2. Compile it as a PIE:

$ gcc -o show_mmap_pie -fpie -pie show_mmap_pie.c

3. After applying the patch, we can increase the randomization range
on  RHEL PPC64LE system with 64K page size:

# cat /proc/sys/vm/mmap_rnd_bits
14

# ./show_mmap_pie

4c050000-4c060000 r-xp 00000000 fd:00 102212985
  /root/show_mmap_pie
4c060000-4c070000 r--p 00000000 fd:00 102212985
  /root/show_mmap_pie
4c070000-4c080000 rw-p 00010000 fd:00 102212985
  /root/show_mmap_pie
7fffa0460000-7fffa0620000 r-xp 00000000 fd:00 33617825
  /usr/lib64/libc-2.17.so
7fffa0620000-7fffa0630000 r--p 001b0000 fd:00 33617825
  /usr/lib64/libc-2.17.so
7fffa0630000-7fffa0640000 rw-p 001c0000 fd:00 33617825
  /usr/lib64/libc-2.17.so
7fffa0650000-7fffa0670000 r-xp 00000000 00:00 0                          [vdso]
7fffa0670000-7fffa06a0000 r-xp 00000000 fd:00 33617818
  /usr/lib64/ld-2.17.so
7fffa06a0000-7fffa06b0000 r--p 00020000 fd:00 33617818
  /usr/lib64/ld-2.17.so
7fffa06b0000-7fffa06c0000 rw-p 00030000 fd:00 33617818
  /usr/lib64/ld-2.17.so
7fffe3fe0000-7fffe4010000 rw-p 00000000 00:00 0                          [stack]

# echo 28 > /proc/sys/vm/mmap_rnd_bits

# ./show_mmap_pie
202e31d0000-202e31e0000 r-xp 00000000 fd:00 102212985
  /root/show_mmap_pie
202e31e0000-202e31f0000 r--p 00000000 fd:00 102212985
  /root/show_mmap_pie
202e31f0000-202e3200000 rw-p 00010000 fd:00 102212985
  /root/show_mmap_pie
7ef112640000-7ef112800000 r-xp 00000000 fd:00 33617825
  /usr/lib64/libc-2.17.so
7ef112800000-7ef112810000 r--p 001b0000 fd:00 33617825
  /usr/lib64/libc-2.17.so
7ef112810000-7ef112820000 rw-p 001c0000 fd:00 33617825
  /usr/lib64/libc-2.17.so
7ef112830000-7ef112850000 r-xp 00000000 00:00 0                          [vdso]
7ef112850000-7ef112880000 r-xp 00000000 fd:00 33617818
  /usr/lib64/ld-2.17.so
7ef112880000-7ef112890000 r--p 00020000 fd:00 33617818
  /usr/lib64/ld-2.17.so
7ef112890000-7ef1128a0000 rw-p 00030000 fd:00 33617818
  /usr/lib64/ld-2.17.so
7fffd3070000-7fffd30a0000 rw-p 00000000 00:00 0                          [stack]

So, you can add my Tested-by for this patch as well.

Regards,
Bhupesh
