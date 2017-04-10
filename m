MIME-Version: 1.0
In-Reply-To: <1490730347-5165-1-git-send-email-bhsharma@redhat.com>
References: <1490730347-5165-1-git-send-email-bhsharma@redhat.com>
From: Bhupesh Sharma <bhsharma@redhat.com>
Date: Mon, 10 Apr 2017 22:50:26 +0530
Message-ID: <CACi5LpMwX5iQaOT=0nnm+6bMuob2PLHW6sTj_sW+SPwQn6hVxQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3] powerpc: mm: support ARCH_MMAP_RND_BITS
To: linuxppc-dev@lists.ozlabs.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Steve Best <sbest@redhat.com>, "Gustavo Luiz Duarte (IBM)" <gduarte@redhat.com>
Cc: Daniel Cashman <dcashman@google.com>, Michael Ellerman <mpe@ellerman.id.au>, Bhupesh SHARMA <bhupesh.linux@gmail.com>, Kees Cook <keescook@chromium.org>, Bhupesh Sharma <bhsharma@redhat.com>, Alexander Graf <agraf@suse.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Anatolij Gustschin <agust@denx.de>, Alistair Popple <alistair@popple.id.au>, Matt Porter <mporter@kernel.crashing.org>, Vitaly Bordug <vitb@kernel.crashing.org>, Scott Wood <oss@buserror.net>, Kumar Gala <galak@kernel.crashing.org>, Daniel Cashman <dcashman@android.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Michael,

On Wed, Mar 29, 2017 at 1:15 AM, Bhupesh Sharma <bhsharma@redhat.com> wrote:
> powerpc arch_mmap_rnd() currently uses hard-coded values - (23-PAGE_SHIFT) for
> 32-bit and (30-PAGE_SHIFT) for 64-bit, to generate the random offset
> for the mmap base address for a ASLR ELF.
>
> This patch makes sure that powerpc mmap arch_mmap_rnd() implementation
> is similar to other ARCHs (like x86, arm64) and uses mmap_rnd_bits
> and helpers to generate the mmap address randomization.
>
> The maximum and minimum randomization range values represent
> a compromise between increased ASLR effectiveness and avoiding
> address-space fragmentation.
>
> Using the Kconfig option and suitable /proc tunable, platform
> developers may choose where to place this compromise.
>
> Also this patch keeps the default values as new minimums.
>
> Signed-off-by: Bhupesh Sharma <bhsharma@redhat.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> ---
> * Changes since v2:
> v2 can be seen here (https://patchwork.kernel.org/patch/9551509/)
>     - Changed a few minimum and maximum randomization ranges as per Michael's suggestion.
>     - Corrected Kees's email address in the Reviewed-by line.
>     - Added further comments in kconfig to explain how the address ranges were worked out.
>
> * Changes since v1:
> v1 can be seen here (https://lists.ozlabs.org/pipermail/linuxppc-dev/2017-February/153594.html)
>     - No functional change in this patch.
>     - Dropped PATCH 2/2 from v1 as recommended by Kees Cook.
>
>  arch/powerpc/Kconfig   | 44 ++++++++++++++++++++++++++++++++++++++++++++
>  arch/powerpc/mm/mmap.c |  7 ++++---
>  2 files changed, 48 insertions(+), 3 deletions(-)
>
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index 97a8bc8..84aae67 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -22,6 +22,48 @@ config MMU
>         bool
>         default y
>
> +# min bits determined by the following formula:
> +# VA_BITS - PAGE_SHIFT - CONSTANT
> +# where,
> +#      VA_BITS = 46 bits for 64BIT and 4GB - 1 Page = 31 bits for 32BIT
> +#      CONSTANT = 16 for 64BIT and 8 for 32BIT
> +config ARCH_MMAP_RND_BITS_MIN
> +       default 5 if PPC_256K_PAGES && 32BIT  # 31 - 18 - 8 = 5
> +       default 7 if PPC_64K_PAGES && 32BIT   # 31 - 16 - 8 = 7
> +       default 9 if PPC_16K_PAGES && 32BIT   # 31 - 14 - 8 = 9
> +       default 11 if PPC_4K_PAGES && 32BIT   # 31 - 12 - 8 = 11
> +       default 12 if PPC_256K_PAGES && 64BIT # 46 - 18 - 16 = 12
> +       default 14 if PPC_64K_PAGES && 64BIT  # 46 - 16 - 16 = 14
> +       default 16 if PPC_16K_PAGES && 64BIT  # 46 - 14 - 16 = 16
> +       default 18 if PPC_4K_PAGES && 64BIT   # 46 - 12 - 16 = 18
> +
> +# max bits determined by the following formula:
> +# VA_BITS - PAGE_SHIFT - CONSTANT
> +# where,
> +#      VA_BITS = 46 bits for 64BIT, and 4GB - 1 Page = 31 bits for 32BIT
> +#      CONSTANT = 2, both for 64BIT and 32BIT
> +config ARCH_MMAP_RND_BITS_MAX
> +       default 11 if PPC_256K_PAGES && 32BIT # 31 - 18 - 2 = 11
> +       default 13 if PPC_64K_PAGES && 32BIT  # 31 - 16 - 2 = 13
> +       default 15 if PPC_16K_PAGES && 32BIT  # 31 - 14 - 2 = 15
> +       default 17 if PPC_4K_PAGES && 32BIT   # 31 - 12 - 2 = 17
> +       default 26 if PPC_256K_PAGES && 64BIT # 46 - 18 - 2 = 26
> +       default 28 if PPC_64K_PAGES && 64BIT  # 46 - 16 - 2 = 28
> +       default 30 if PPC_16K_PAGES && 64BIT  # 46 - 14 - 2 = 30
> +       default 32 if PPC_4K_PAGES && 64BIT   # 46 - 12 - 2 = 32
> +
> +config ARCH_MMAP_RND_COMPAT_BITS_MIN
> +       default 5 if PPC_256K_PAGES
> +       default 7 if PPC_64K_PAGES
> +       default 9 if PPC_16K_PAGES
> +       default 11
> +
> +config ARCH_MMAP_RND_COMPAT_BITS_MAX
> +       default 11 if PPC_256K_PAGES
> +       default 13 if PPC_64K_PAGES
> +       default 15 if PPC_16K_PAGES
> +       default 17
> +
>  config HAVE_SETUP_PER_CPU_AREA
>         def_bool PPC64
>
> @@ -142,6 +184,8 @@ config PPC
>         select HAVE_IRQ_EXIT_ON_IRQ_STACK
>         select HAVE_KERNEL_GZIP
>         select HAVE_KPROBES
> +       select HAVE_ARCH_MMAP_RND_BITS
> +       select HAVE_ARCH_MMAP_RND_COMPAT_BITS if COMPAT
>         select HAVE_KRETPROBES
>         select HAVE_LIVEPATCH                   if HAVE_DYNAMIC_FTRACE_WITH_REGS
>         select HAVE_MEMBLOCK
> diff --git a/arch/powerpc/mm/mmap.c b/arch/powerpc/mm/mmap.c
> index a5d9ef5..92a9355 100644
> --- a/arch/powerpc/mm/mmap.c
> +++ b/arch/powerpc/mm/mmap.c
> @@ -61,11 +61,12 @@ unsigned long arch_mmap_rnd(void)
>  {
>         unsigned long rnd;
>
> -       /* 8MB for 32bit, 1GB for 64bit */
> +#ifdef CONFIG_COMPAT
>         if (is_32bit_task())
> -               rnd = get_random_long() % (1<<(23-PAGE_SHIFT));
> +               rnd = get_random_long() & ((1UL << mmap_rnd_compat_bits) - 1);
>         else
> -               rnd = get_random_long() % (1UL<<(30-PAGE_SHIFT));
> +#endif
> +               rnd = get_random_long() & ((1UL << mmap_rnd_bits) - 1);
>
>         return rnd << PAGE_SHIFT;
>  }
> --
> 2.7.4
>

Ping. Any comments on this one?

Regards,
Bhupesh
