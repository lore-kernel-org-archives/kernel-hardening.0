Date: Tue, 25 Jul 2017 16:26:50 +0100
From: Dave Martin <Dave.Martin@arm.com>
Message-ID: <20170725152649.GE6321@e103592.cambridge.arm.com>
References: <1500480092-28480-1-git-send-email-mark.rutland@arm.com>
 <1500480092-28480-8-git-send-email-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1500480092-28480-8-git-send-email-mark.rutland@arm.com>
Subject: [kernel-hardening] Re: [PATCH 07/11] arm64: add basic pointer authentication support
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, arnd@arndb.de, jiong.wang@arm.com, marc.zyngier@arm.com, catalin.marinas@arm.com, yao.qi@arm.com, suzuki.poulose@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jul 19, 2017 at 05:01:28PM +0100, Mark Rutland wrote:
> This patch adds basic support for pointer authentication, allowing
> userspace to make use of APIAKey. The kernel maintains an APIAKey value
> for each process (shared by all threads within), which is initialised to
> a random value at exec() time.
> 
> Instructions using other keys (APIBKey, APDAKey, APDBKey) are disabled,
> and will behave as NOPs. These may be made use of in future patches.
> 
> No support is added for the generic key (APGAKey), though this cannot be
> trapped or made to behave as a NOP. Its presence is not advertised with
> a hwcap.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> ---
>  arch/arm64/Kconfig                    | 23 +++++++++
>  arch/arm64/include/asm/mmu.h          |  5 ++
>  arch/arm64/include/asm/mmu_context.h  | 25 +++++++++-
>  arch/arm64/include/asm/pointer_auth.h | 89 +++++++++++++++++++++++++++++++++++
>  arch/arm64/include/uapi/asm/hwcap.h   |  1 +
>  arch/arm64/kernel/cpufeature.c        | 11 +++++
>  arch/arm64/kernel/cpuinfo.c           |  1 +
>  7 files changed, 153 insertions(+), 2 deletions(-)
>  create mode 100644 arch/arm64/include/asm/pointer_auth.h
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index dfd9086..15a9931 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -962,6 +962,29 @@ config ARM64_UAO
>  
>  endmenu
>  
> +menu "ARMv8.3 architectural features"
> +
> +config ARM64_POINTER_AUTHENTICATION
> +	bool "Enable support for pointer authentication"
> +	default y
> +	help
> +	  Pointer authentication (part of the ARMv8.3 Extensions) provides
> +	  instructions for signing and authenticating pointers against secret
> +	  keys, which can be used to mitigate Return Oriented Programming (ROP)
> +	  and other attacks.
> +
> +	  This option enables these instructions at EL0 (i.e. for userspace).
> +
> +	  Choosing this option will cause the kernel to initialise secret keys
> +	  for each process at exec() time, with these keys being
> +	  context-switched along with the process.
> +
> +	  The feature is detected at runtime. If the feature is not present in
> +	  hardware it will not be advertised to userspace nor will it be
> +	  enabled.

Should we describe which keys are supported here, or will this option
always turn on all the keys/instructions that the kernel implements to
date?

> +
> +endmenu
> +
>  config ARM64_MODULE_CMODEL_LARGE
>  	bool
>  
> diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
> index 5468c83..6a848f3 100644
> --- a/arch/arm64/include/asm/mmu.h
> +++ b/arch/arm64/include/asm/mmu.h
> @@ -16,10 +16,15 @@
>  #ifndef __ASM_MMU_H
>  #define __ASM_MMU_H
>  
> +#include <asm/pointer_auth.h>
> +
>  typedef struct {
>  	atomic64_t	id;
>  	void		*vdso;
>  	unsigned long	flags;
> +#ifdef CONFIG_ARM64_POINTER_AUTHENTICATION
> +	struct ptrauth_keys	ptrauth_keys;
> +#endif
>  } mm_context_t;
>  
>  /*
> diff --git a/arch/arm64/include/asm/mmu_context.h b/arch/arm64/include/asm/mmu_context.h
> index 3257895a..06757a5 100644
> --- a/arch/arm64/include/asm/mmu_context.h
> +++ b/arch/arm64/include/asm/mmu_context.h
> @@ -31,7 +31,6 @@
>  #include <asm/cacheflush.h>
>  #include <asm/cpufeature.h>
>  #include <asm/proc-fns.h>
> -#include <asm-generic/mm_hooks.h>
>  #include <asm/cputype.h>
>  #include <asm/pgtable.h>
>  #include <asm/sysreg.h>
> @@ -154,7 +153,14 @@ static inline void cpu_replace_ttbr1(pgd_t *pgd)
>  #define destroy_context(mm)		do { } while(0)
>  void check_and_switch_context(struct mm_struct *mm, unsigned int cpu);
>  
> -#define init_new_context(tsk,mm)	({ atomic64_set(&(mm)->context.id, 0); 0; })
> +static inline int init_new_context(struct task_struct *tsk,
> +			struct mm_struct *mm)
> +{
> +	atomic64_set(&mm->context.id, 0);
> +	mm_ctx_ptrauth_init(&mm->context);

For this stuff in general, I wonder whether we should move this code
away from mm and to thread_strct and the process/thread paths, otherwise
we'll just have to move it all around later if ptrauth is ever to be
supported per-thread.

This would also remove the need to have individually overridable arch
mm hooks.

Adding an extra 16 bytes to thread_struct is probably not the end of the
world.  thread_struct is already well over half a K.  We could de-dupe
by refcounting or similar, but it may not be worth the complexity.

> +
> +	return 0;
> +}
>  
>  /*
>   * This is called when "tsk" is about to enter lazy TLB mode.
> @@ -200,6 +206,8 @@ static inline void __switch_mm(struct mm_struct *next)
>  		return;
>  	}
>  
> +	mm_ctx_ptrauth_switch(&next->context);
> +
>  	check_and_switch_context(next, cpu);
>  }
>  
> @@ -226,6 +234,19 @@ static inline void __switch_mm(struct mm_struct *next)
>  
>  void verify_cpu_asid_bits(void);
>  
> +static inline void arch_dup_mmap(struct mm_struct *oldmm,
> +				 struct mm_struct *mm)
> +{
> +	mm_ctx_ptrauth_dup(&oldmm->context, &mm->context);
> +}
> +#define arch_dup_mmap arch_dup_mmap
> +
> +/*
> + * We need to override arch_dup_mmap before including the generic hooks, which
> + * are otherwise sufficient for us.
> + */
> +#include <asm-generic/mm_hooks.h>
> +
>  #endif /* !__ASSEMBLY__ */
>  
>  #endif /* !__ASM_MMU_CONTEXT_H */
> diff --git a/arch/arm64/include/asm/pointer_auth.h b/arch/arm64/include/asm/pointer_auth.h
> new file mode 100644
> index 0000000..964da0c
> --- /dev/null
> +++ b/arch/arm64/include/asm/pointer_auth.h
> @@ -0,0 +1,89 @@
> +/*
> + * Copyright (C) 2016 ARM Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +#ifndef __ASM_POINTER_AUTH_H
> +#define __ASM_POINTER_AUTH_H
> +
> +#include <linux/random.h>
> +
> +#include <asm/cpufeature.h>
> +#include <asm/sysreg.h>
> +
> +#ifdef CONFIG_ARM64_POINTER_AUTHENTICATION
> +/*
> + * Each key is a 128-bit quantity which is split accross a pair of 64-bit
> + * registers (Lo and Hi).
> + */
> +struct ptrauth_key {
> +	unsigned long lo, hi;
> +};
> +
> +/*
> + * We give each process its own instruction A key (APIAKey), which is shared by
> + * all threads. This is inherited upon fork(), and reinitialised upon exec*().
> + * All other keys are currently unused, with APIBKey, APDAKey, and APBAKey
> + * instructions behaving as NOPs.
> + */
> +struct ptrauth_keys {
> +	struct ptrauth_key apia;
> +};
> +
> +static inline void ptrauth_keys_init(struct ptrauth_keys *keys)
> +{
> +	if (!cpus_have_const_cap(ARM64_HAS_ADDRESS_AUTH))
> +		return;
> +
> +	get_random_bytes(keys, sizeof(*keys));
> +}
> +
> +#define __ptrauth_key_install(k, v)			\
> +do {							\
> +	write_sysreg_s(v.lo, SYS_ ## k ## KEYLO_EL1);	\
> +	write_sysreg_s(v.hi, SYS_ ## k ## KEYHI_EL1);	\

(v)

though moderately crazy usage would be required in order for this to go
wrong.

> +} while (0)
> +
> +static inline void ptrauth_keys_switch(struct ptrauth_keys *keys)
> +{
> +	if (!cpus_have_const_cap(ARM64_HAS_ADDRESS_AUTH))
> +		return;
> +
> +	__ptrauth_key_install(APIA, keys->apia);
> +}
> +
> +static inline void ptrauth_keys_dup(struct ptrauth_keys *old,
> +				    struct ptrauth_keys *new)
> +{
> +	if (!cpus_have_const_cap(ARM64_HAS_ADDRESS_AUTH))
> +		return;
> +
> +	*new = *old;

This seems an odd thing to do.  Surely, by design we never want two
processes to share the same keys?  Don't we always proceed to nuke
the keys via mm_ctx_ptrauth_init() anyway?

> +}
> +
> +#define mm_ctx_ptrauth_init(ctx) \
> +	ptrauth_keys_init(&(ctx)->ptrauth_keys)
> +
> +#define mm_ctx_ptrauth_switch(ctx) \
> +	ptrauth_keys_switch(&(ctx)->ptrauth_keys)
> +
> +#define mm_ctx_ptrauth_dup(oldctx, newctx) \
> +	ptrauth_keys_dup(&(oldctx)->ptrauth_keys, &(newctx)->ptrauth_keys)

[...]

Cheers
---Dave
