Date: Wed, 25 Apr 2018 12:23:32 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCHv3 07/11] arm64: add basic pointer authentication support
Message-ID: <20180425112331.hke7afxnslyrwf3h@armageddon.cambridge.arm.com>
References: <20180417183735.56985-1-mark.rutland@arm.com>
 <20180417183735.56985-8-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180417183735.56985-8-mark.rutland@arm.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, drjones@redhat.com, cdall@kernel.org, arnd@arndb.de, suzuki.poulose@arm.com, marc.zyngier@arm.com, awallis@codeaurora.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, ramana.radhakrishnan@arm.com, kvmarm@lists.cs.columbia.edu
List-ID: <kernel-hardening.lists.openwall.com>

Hi Mark,

On Tue, Apr 17, 2018 at 07:37:31PM +0100, Mark Rutland wrote:
> diff --git a/arch/arm64/include/asm/mmu_context.h b/arch/arm64/include/asm/mmu_context.h
> index 39ec0b8a689e..caf0d3010112 100644
> --- a/arch/arm64/include/asm/mmu_context.h
> +++ b/arch/arm64/include/asm/mmu_context.h
> @@ -29,7 +29,6 @@
>  #include <asm/cacheflush.h>
>  #include <asm/cpufeature.h>
>  #include <asm/proc-fns.h>
> -#include <asm-generic/mm_hooks.h>
>  #include <asm/cputype.h>
>  #include <asm/pgtable.h>
>  #include <asm/sysreg.h>
> @@ -168,7 +167,14 @@ static inline void cpu_replace_ttbr1(pgd_t *pgdp)
>  #define destroy_context(mm)		do { } while(0)
>  void check_and_switch_context(struct mm_struct *mm, unsigned int cpu);
>  
> -#define init_new_context(tsk,mm)	({ atomic64_set(&(mm)->context.id, 0); 0; })
> +static inline int init_new_context(struct task_struct *tsk,
> +			struct mm_struct *mm)
> +{
> +	atomic64_set(&mm->context.id, 0);
> +	mm_ctx_ptrauth_init(&mm->context);
> +
> +	return 0;
> +}
>  
>  #ifdef CONFIG_ARM64_SW_TTBR0_PAN
>  static inline void update_saved_ttbr0(struct task_struct *tsk,
> @@ -216,6 +222,8 @@ static inline void __switch_mm(struct mm_struct *next)
>  		return;
>  	}
>  
> +	mm_ctx_ptrauth_switch(&next->context);
> +
>  	check_and_switch_context(next, cpu);
>  }
>  
> @@ -241,6 +249,19 @@ switch_mm(struct mm_struct *prev, struct mm_struct *next,
>  void verify_cpu_asid_bits(void);
>  void post_ttbr_update_workaround(void);
>  
> +static inline void arch_dup_mmap(struct mm_struct *oldmm,
> +				 struct mm_struct *mm)
> +{
> +	mm_ctx_ptrauth_dup(&oldmm->context, &mm->context);
> +}
> +#define arch_dup_mmap arch_dup_mmap

IIUC, we could skip the arch_dup_mmap() and init_new_context() here for
the fork() case since the ptrauth_keys would be copied as part of the
dup_mm(). There is another situation where init_new_context() is called
bprm_mm_init() -> mm_alloc() -> mm_init() -> init_new_context().
However, in this case the core code also calls arch_bprm_mm_init(). So I
think we only need to update the latter to get a new random key.

> diff --git a/arch/arm64/include/asm/pointer_auth.h b/arch/arm64/include/asm/pointer_auth.h
> new file mode 100644
> index 000000000000..a2e8fb91fdee
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

Nitpick: 2018. You could also use the SPDX header, save some lines.

-- 
Catalin
