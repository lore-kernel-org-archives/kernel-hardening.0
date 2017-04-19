MIME-Version: 1.0
In-Reply-To: <1492612181-8484-1-git-send-email-mpe@ellerman.id.au>
References: <1492612181-8484-1-git-send-email-mpe@ellerman.id.au>
From: Bhupesh Sharma <bhsharma@redhat.com>
Date: Thu, 20 Apr 2017 00:05:38 +0530
Message-ID: <CACi5LpNepcyCgWj-bYnSWqNRDtE97wVJ6=shM2mRP3i0ROx+qg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] powerpc/mm: Add support for runtime configuration of ASLR limits
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@ozlabs.org, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Michael,

On Wed, Apr 19, 2017 at 7:59 PM, Michael Ellerman <mpe@ellerman.id.au> wrote:
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

Thanks for the patch. I have a couple of comments:

(A) As Aneesh noted in the review of my v2 patch (see [1]), we need to
handle the configurable 512TB case as well. Right?

> Finally we can wire up the value in arch_mmap_rnd().
>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>

(b) I am wondering if I missed your comments on my v2 on the same
subject - may be you missed my reminder message (see [2]).

I am just starting off on PPC related enhancements that we find useful
while working on Redhat/Fedora PPC systems (I have mainly been
associated with ARM and peripheral driver development in the past),
and would have been motivated further if I could get responses to my
queries which I had raised earlier on the list (see [3]) - especially
the branch to base newer version of patches on.

Also I am not sure how the PPC subsystem handles S-O-Bs of earlier
contributions on the same subject (as it varies from one
maintainer/subsystem to the other), so I leave it up to you.

That being said, I will try to improve any new patches I plan to send
out on PPC mailing list in future.

[1] https://lkml.org/lkml/2017/4/13/57
[2] https://lkml.org/lkml/2017/4/10/796
[3] https://lkml.org/lkml/2017/4/17/3

Thanks,
Bhupesh

> ---
>  arch/powerpc/Kconfig   | 44 ++++++++++++++++++++++++++++++++++++++++++++
>  arch/powerpc/mm/mmap.c | 11 ++++++-----
>  2 files changed, 50 insertions(+), 5 deletions(-)
>
>
> This is based on my next branch which has the 128TB changes:
>   https://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.git/log/?h=next
>
> I would definitely appreciate someone checking my math, and any test results.
>
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index 97a8bc8a095c..608ee0b7b79f 100644
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
> +       default ARCH_MMAP_RND_COMPAT_BITS_MIN
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
>
