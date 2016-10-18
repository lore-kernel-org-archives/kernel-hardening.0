Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1476802761-24340-3-git-send-email-colin@cvidal.org>
References: <1476802761-24340-1-git-send-email-colin@cvidal.org> <1476802761-24340-3-git-send-email-colin@cvidal.org>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 18 Oct 2016 14:29:15 -0700
Message-ID: <CAGXu5jJXRxCvO6YiBWt4-mWMO_pbrurViWcFODbN2NtjJ3PSmQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC 2/2] arm: implementation for HARDENED_ATOMIC
To: Colin Vidal <colin@cvidal.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Reshetova, Elena" <elena.reshetova@intel.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, David Windsor <dave@progbits.org>, Hans Liljestrand <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 18, 2016 at 7:59 AM, Colin Vidal <colin@cvidal.org> wrote:
> This adds arm-specific code in order to support HARDENED_ATOMIC
> feature. When overflow is detected in atomic_t, atomic64_t or
> atomic_long_t, an exception is raised and call
> hardened_atomic_overflow.

Can you include some notes that this was originally in PaX/grsecurity,
and detail what is different from their implemention?

>
> Signed-off-by: Colin Vidal <colin@cvidal.org>
> ---
>  arch/arm/Kconfig              |   1 +
>  arch/arm/include/asm/atomic.h | 434 +++++++++++++++++++++++++++++-------------
>  arch/arm/mm/fault.c           |  15 ++
>  3 files changed, 320 insertions(+), 130 deletions(-)
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index b5d529f..fcf4a64 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -36,6 +36,7 @@ config ARM
>         select HAVE_ARCH_AUDITSYSCALL if (AEABI && !OABI_COMPAT)
>         select HAVE_ARCH_BITREVERSE if (CPU_32v7M || CPU_32v7) && !CPU_32v6
>         select HAVE_ARCH_HARDENED_USERCOPY
> +       select HAVE_ARCH_HARDENED_ATOMIC
>         select HAVE_ARCH_JUMP_LABEL if !XIP_KERNEL && !CPU_ENDIAN_BE32 && MMU
>         select HAVE_ARCH_KGDB if !CPU_ENDIAN_BE32 && MMU
>         select HAVE_ARCH_MMAP_RND_BITS if MMU
> diff --git a/arch/arm/include/asm/atomic.h b/arch/arm/include/asm/atomic.h
> index 66d0e21..fdaee17 100644
> --- a/arch/arm/include/asm/atomic.h
> +++ b/arch/arm/include/asm/atomic.h
> @@ -17,18 +17,52 @@
>  #include <linux/irqflags.h>
>  #include <asm/barrier.h>
>  #include <asm/cmpxchg.h>
> +#include <linux/bug.h>
>
>  #define ATOMIC_INIT(i) { (i) }
>
>  #ifdef __KERNEL__
>
> +#ifdef CONFIG_HARDENED_ATOMIC
> +#define HARDENED_ATOMIC_INSN "bkpt 0xf103"

In PaX, I see a check for THUMB2 config:

#ifdef CONFIG_THUMB2_KERNEL
#define REFCOUNT_TRAP_INSN "bkpt        0xf1"
#else
#define REFCOUNT_TRAP_INSN "bkpt        0xf103"
#endif

That should probably stay unless I'm misunderstanding something. Also,
for your new ISNS define name, I'd leave "TRAP" in the name, since
that describes more clearly what it does.

Beyond these things, it looks great to me -- though I'm hardly an ARM expert. :)

Were you able to test on ARM with this for overflow with the lkdtm tests?

-Kees

-- 
Kees Cook
Nexus Security
