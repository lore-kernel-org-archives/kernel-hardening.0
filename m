Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1480008765-3876-1-git-send-email-matt.redfearn@imgtec.com>
References: <1480008765-3876-1-git-send-email-matt.redfearn@imgtec.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 25 Nov 2016 12:00:26 -0800
Message-ID: <CAGXu5jLT-V3+3_KSAfxbN3yY22xRh3tvs1wpL+mwk1En8MC6Bg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] MIPS: Add support for ARCH_MMAP_RND_{COMPAT_}BITS
To: Matt Redfearn <matt.redfearn@imgtec.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, Linux MIPS Mailing List <linux-mips@linux-mips.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, LKML <linux-kernel@vger.kernel.org>, Daniel Cashman <dcashman@android.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 24, 2016 at 9:32 AM, Matt Redfearn <matt.redfearn@imgtec.com> wrote:
> arch_mmap_rnd() uses hard-coded limits of 16MB for the randomisation
> of mmap within 32bit processes and 256MB in 64bit processes. Since v4.4
> other arches support tuning this value in /proc/sys/vm/mmap_rnd_bits.
> Add support for this to MIPS.
>
> Set the minimum(default) number of bits randomisation for 32bit to 8 -
> which with 4k pagesize is unchanged from the current 16MB total
> randomness. The minimum(default) for 64bit is 12bits, again with 4k
> pagesize this is the same as the current 256MB.
>
> This patch is necessary for MIPS32 to pass the Android CTS tests, with
> the number of random bits set to 15.
>
> Signed-off-by: Matt Redfearn <matt.redfearn@imgtec.com>
> ---
>
>  arch/mips/Kconfig   | 16 ++++++++++++++++
>  arch/mips/mm/mmap.c | 10 +++++-----
>  2 files changed, 21 insertions(+), 5 deletions(-)
>
> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
> index b3c5bde43d34..d72cf6129b2c 100644
> --- a/arch/mips/Kconfig
> +++ b/arch/mips/Kconfig
> @@ -13,6 +13,8 @@ config MIPS
>         select HAVE_PERF_EVENTS
>         select PERF_USE_VMALLOC
>         select HAVE_ARCH_KGDB
> +       select HAVE_ARCH_MMAP_RND_BITS if MMU
> +       select HAVE_ARCH_MMAP_RND_COMPAT_BITS if MMU && COMPAT
>         select HAVE_ARCH_SECCOMP_FILTER
>         select HAVE_ARCH_TRACEHOOK
>         select HAVE_CBPF_JIT if !CPU_MICROMIPS
> @@ -3073,6 +3075,20 @@ config MMU
>         bool
>         default y
>
> +config ARCH_MMAP_RND_BITS_MIN
> +       default 12 if 64BIT
> +       default 8
> +
> +config ARCH_MMAP_RND_BITS_MAX
> +       default 18 if 64BIT
> +       default 15
> +
> +config ARCH_MMAP_RND_COMPAT_BITS_MIN
> +       default 8
> +
> +config ARCH_MMAP_RND_COMPAT_BITS_MAX
> +       default 15
> +
>  config I8253
>         bool
>         select CLKSRC_I8253
> diff --git a/arch/mips/mm/mmap.c b/arch/mips/mm/mmap.c
> index d08ea3ff0f53..d6d92c02308d 100644
> --- a/arch/mips/mm/mmap.c
> +++ b/arch/mips/mm/mmap.c
> @@ -146,14 +146,14 @@ unsigned long arch_mmap_rnd(void)
>  {
>         unsigned long rnd;
>
> -       rnd = get_random_long();
> -       rnd <<= PAGE_SHIFT;
> +#ifdef CONFIG_COMPAT
>         if (TASK_IS_32BIT_ADDR)
> -               rnd &= 0xfffffful;
> +               rnd = get_random_long() & ((1UL << mmap_rnd_compat_bits) - 1);
>         else
> -               rnd &= 0xffffffful;
> +#endif /* CONFIG_COMPAT */
> +               rnd = get_random_long() & ((1UL << mmap_rnd_bits) - 1);
>
> -       return rnd;
> +       return rnd << PAGE_SHIFT;
>  }
>
>  void arch_pick_mmap_layout(struct mm_struct *mm)
> --
> 2.7.4
>

Excellent!

Reviewed-by: Kees Cook <keescook@chromium.org>

Out of curiosity, how were the maxs of 15 and 18 chosen?

-Kees

-- 
Kees Cook
Nexus Security
