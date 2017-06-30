Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
In-Reply-To: <20170630153502.3327030-1-arnd@arndb.de>
Date: Fri, 30 Jun 2017 15:49:41 +0000
Content-Transfer-Encoding: quoted-printable
Message-Id: <9291740E-3BD1-454C-A3EB-46E35F073D0E@linaro.org>
References: <20170630153502.3327030-1-arnd@arndb.de>
Subject: [kernel-hardening] Re: [PATCH] ARM: fix randomized task_struct
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Russell King <linux@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>



> On 30 Jun 2017, at 15:34, Arnd Bergmann <arnd@arndb.de> wrote:
>=20
> With the new task struct randomization, we can run into a build
> failure for certain random seeds:
>=20
> arch/arm/kernel/entry-armv.S: Assembler messages:
> arch/arm/kernel/entry-armv.S:803: Error: bad immediate value for offset (4=
096)
>=20
> Only two constants in asm-offset.h are affected, and I'm changing
> both of them here to work correctly in all configurations.
>=20
> One more macro has the problem, but is currently unused, so this
> removes it instead of adding complexity.
>=20
> Suggested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Fixes: c33d8b12fbbd ("task_struct: Allow randomized layout")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> arch/arm/kernel/entry-armv.S |  5 ++++-
> arch/arm/mm/proc-macros.S    | 10 ++++------
> 2 files changed, 8 insertions(+), 7 deletions(-)
>=20
> diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
> index 9f157e7c51e7..db6d22b23bd8 100644
> --- a/arch/arm/kernel/entry-armv.S
> +++ b/arch/arm/kernel/entry-armv.S
> @@ -797,7 +797,10 @@ ENTRY(__switch_to)
> #if defined(CONFIG_CC_STACKPROTECTOR) && !defined(CONFIG_SMP)
>    ldr    r7, [r2, #TI_TASK]
>    ldr    r8, =3D__stack_chk_guard
> -    ldr    r7, [r7, #TSK_STACK_CANARY]
> +    .if (TSK_STACK_CANARY > PAGE_MASK)

Shouldn't this be ~PAGE_MASK?

I think=20

.if (TSK_STACK_CANARY & PAGE_MASK) !=3D 0

is better and clearer as well

> +    add    r7, r7, #TSK_STACK_CANARY & PAGE_MASK
> +    .endif
> +    ldr    r7, [r7, #TSK_STACK_CANARY & ~PAGE_MASK]
> #endif
> #ifdef CONFIG_CPU_USE_DOMAINS
>    mcr    p15, 0, r6, c3, c0, 0        @ Set domain register
> diff --git a/arch/arm/mm/proc-macros.S b/arch/arm/mm/proc-macros.S
> index 0d40c285bd86..2c5f2a0a708b 100644
> --- a/arch/arm/mm/proc-macros.S
> +++ b/arch/arm/mm/proc-macros.S
> @@ -25,11 +25,6 @@
>    ldr    \rd, [\rn, #VMA_VM_FLAGS]
>    .endm
>=20
> -    .macro    tsk_mm, rd, rn
> -    ldr    \rd, [\rn, #TI_TASK]
> -    ldr    \rd, [\rd, #TSK_ACTIVE_MM]
> -    .endm
> -
> /*
>  * act_mm - get current->active_mm
>  */
> @@ -37,7 +32,10 @@
>    bic    \rd, sp, #8128
>    bic    \rd, \rd, #63
>    ldr    \rd, [\rd, #TI_TASK]
> -    ldr    \rd, [\rd, #TSK_ACTIVE_MM]
> +    .if (TSK_ACTIVE_MM > PAGE_MASK)
> +    add    \rd, \rd, #TSK_ACTIVE_MM & PAGE_MASK
> +    .endif
> +    ldr    \rd, [\rd, #TSK_ACTIVE_MM & ~PAGE_MASK]
>    .endm
>=20
> /*
> --=20
> 2.9.0
>=20
