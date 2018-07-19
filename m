Date: Thu, 19 Jul 2018 12:07:58 +0100
From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 1/2] arm64: Introduce current_stack_type
Message-ID: <20180719110757.jh4cnitfrz6pasho@lakrids.cambridge.arm.com>
References: <20180718211013.14512-1-labbott@redhat.com>
 <20180718211013.14512-2-labbott@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180718211013.14512-2-labbott@redhat.com>
To: Laura Abbott <labbott@redhat.com>
Cc: Alexander Popov <alex.popov@linux.com>, Kees Cook <keescook@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, james.morse@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Laura,

On Wed, Jul 18, 2018 at 02:10:12PM -0700, Laura Abbott wrote:
> 
> In preparation for enabling the stackleak plugin on arm64,
> we need a way to get the bounds of the current stack.
> Introduce a new primitive current_stack_type which is similar
> to x86's get_stack_info. Utilize that to rework
> on_accessible_stack slightly as well.
> 
> Signed-off-by: Laura Abbott <labbott@redhat.com>
> ---
> So this did end up looking quite a bit like get_stack_info but I didn't
> really see the need to integrate this more than this. I do think
> actually enumerating the types makes things a bit cleaner.
> ---
>  arch/arm64/include/asm/sdei.h       |  8 ++-
>  arch/arm64/include/asm/stacktrace.h | 94 ++++++++++++++++++++++++-----
>  arch/arm64/kernel/ptrace.c          |  2 +-
>  arch/arm64/kernel/sdei.c            | 21 ++++++-
>  4 files changed, 103 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/sdei.h b/arch/arm64/include/asm/sdei.h
> index e073e6886685..34f7b203845b 100644
> --- a/arch/arm64/include/asm/sdei.h
> +++ b/arch/arm64/include/asm/sdei.h
> @@ -40,15 +40,17 @@ asmlinkage unsigned long __sdei_handler(struct pt_regs *regs,
>  unsigned long sdei_arch_get_entry_point(int conduit);
>  #define sdei_arch_get_entry_point(x)	sdei_arch_get_entry_point(x)
>  
> -bool _on_sdei_stack(unsigned long sp);
> -static inline bool on_sdei_stack(unsigned long sp)
> +bool _on_sdei_stack(unsigned long sp, unsigned long *, unsigned long *);
> +static inline bool on_sdei_stack(unsigned long sp,
> +				unsigned long *stack_low,
> +				unsigned long *stack_high)
>  {
>  	if (!IS_ENABLED(CONFIG_VMAP_STACK))
>  		return false;
>  	if (!IS_ENABLED(CONFIG_ARM_SDE_INTERFACE))
>  		return false;
>  	if (in_nmi())
> -		return _on_sdei_stack(sp);
> +		return _on_sdei_stack(sp, stack_low, stack_high);
>  
>  	return false;
>  }
> diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
> index 902f9edacbea..9855a0425e64 100644
> --- a/arch/arm64/include/asm/stacktrace.h
> +++ b/arch/arm64/include/asm/stacktrace.h
> @@ -39,7 +39,9 @@ extern void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk);
>  
>  DECLARE_PER_CPU(unsigned long *, irq_stack_ptr);
>  
> -static inline bool on_irq_stack(unsigned long sp)
> +static inline bool on_irq_stack(unsigned long sp,
> +				unsigned long *stack_low,
> +				unsigned long *stack_high)
>  {
>  	unsigned long low = (unsigned long)raw_cpu_read(irq_stack_ptr);
>  	unsigned long high = low + IRQ_STACK_SIZE;
> @@ -47,47 +49,109 @@ static inline bool on_irq_stack(unsigned long sp)
>  	if (!low)
>  		return false;
>  
> -	return (low <= sp && sp < high);
> +	if (sp < low || sp >= high)
> +		return false;
> +
> +	if (stack_low && stack_high) {
> +		*stack_low = low;
> +		*stack_high = high;
> +	}
> +
> +	return true;
>  }

Rather than having to pass separete pointers to low/high, could we
please wrap them up as a struct, e.g.

struct stack_info {
	unsigned long low, high;
	stack_type type;
}

... and pass a single pointer to that? e.g.

static inline bool on_irq_stack(unsigned long sp, struct stack_info *info)
{
	unsigned long low = (unsigned long)raw_cpu_read(irq_stack_ptr);
	unsigned long high = low + IRQ_STACK_SIZE;

	if (!low)
		return false;
	
	if (sp < low || sp >= high)
		return false;
	
	if (info) {
		info->low = low;
		info->high = high;
		info->type = STACK_TYPE_IRQ;
	}

	return true;
}

That simplified the prototypes, and will allow us to distinguish the two
SDEI stacks (which we'll need for making stack unwiding robust to
cross-stack loops).

> -static inline bool on_task_stack(struct task_struct *tsk, unsigned long sp)
> +static inline bool on_task_stack(struct task_struct *tsk, unsigned long sp,
> +				unsigned long *stack_low,
> +				unsigned long *stack_high)
>  {
>  	unsigned long low = (unsigned long)task_stack_page(tsk);
>  	unsigned long high = low + THREAD_SIZE;
>  
> -	return (low <= sp && sp < high);
> +	if (sp < low || sp >= high)
> +		return false;
> +
> +	if (stack_low && stack_high) {
> +		*stack_low = low;
> +		*stack_high = high;
> +	}
> +
> +	return true;
>  }
>  
>  #ifdef CONFIG_VMAP_STACK
>  DECLARE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)], overflow_stack);
>  
> -static inline bool on_overflow_stack(unsigned long sp)
> +static inline bool on_overflow_stack(unsigned long sp,
> +				unsigned long *stack_low,
> +				unsigned long *stack_high)
>  {
>  	unsigned long low = (unsigned long)raw_cpu_ptr(overflow_stack);
>  	unsigned long high = low + OVERFLOW_STACK_SIZE;
>  
> -	return (low <= sp && sp < high);
> +	if (sp < low || sp >= high)
> +		return false;
> +
> +	if (stack_low && stack_high) {
> +		*stack_low = low;
> +		*stack_high = high;
> +	}
> +
> +	return true;
>  }
>  #else
> -static inline bool on_overflow_stack(unsigned long sp) { return false; }
> +static inline bool on_overflow_stack(unsigned long sp,
> +			unsigned long *stack_low,
> +			unsigned long *stack_high) { return false; }
>  #endif
>  
> +enum stack_type {
> +	STACK_TYPE_UNKNOWN,
> +	STACK_TYPE_TASK,
> +	STACK_TYPE_IRQ,
> +	STACK_TYPE_OVERFLOW,
> +	STACK_TYPE_SDEI,
> +};

For SDEI we'll need STACK_TYPE_SDEI_NORMAL and STACK_TYPE_SDEI_CRITICAL,
at least for stack unwinding.

> +
> +static inline enum stack_type current_stack_type(struct task_struct *tsk,
> +						unsigned long sp,
> +						unsigned long *stack_low,
> +						unsigned long *stack_high)
> +{
> +	if (on_task_stack(tsk, sp, stack_low, stack_high))
> +		return STACK_TYPE_TASK;
> +	if (on_irq_stack(sp, stack_low, stack_high))
> +		return STACK_TYPE_IRQ;
> +	if (on_overflow_stack(sp, stack_low, stack_high))
> +		return STACK_TYPE_OVERFLOW;
> +	if (on_sdei_stack(sp, stack_low, stack_high))
> +		return STACK_TYPE_SDEI;
> +	return STACK_TYPE_UNKNOWN;
> +}
> +
>  /*
>   * We can only safely access per-cpu stacks from current in a non-preemptible
>   * context.
>   */
>  static inline bool on_accessible_stack(struct task_struct *tsk, unsigned long sp)
>  {
> -	if (on_task_stack(tsk, sp))
> +	enum stack_type type;
> +	unsigned long low, high;
> +
> +	type = current_stack_type(tsk, sp, &low, &high);
> +
> +	switch (type) {
> +	case STACK_TYPE_TASK:
>  		return true;
> -	if (tsk != current || preemptible())
> +	case STACK_TYPE_IRQ:
> +	case STACK_TYPE_OVERFLOW:
> +	case STACK_TYPE_SDEI:
> +		if (tsk != current || preemptible())
> +			return false;
> +		else
> +			return true;
> +	case STACK_TYPE_UNKNOWN:
>  		return false;
> -	if (on_irq_stack(sp))
> -		return true;
> -	if (on_overflow_stack(sp))
> -		return true;
> -	if (on_sdei_stack(sp))
> -		return true;
> +	}
>  
>  	return false;
>  }

With the stacut stack_info, I think we can leave the logic of
on_accessible_stack() as-is, modulo a new info parameter that we pass on
into each on_<foo>_stack(), and then we don't neeed a separate
current_stack_type() function.

> diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
> index 5c338ce5a7fa..a6b3a2be7561 100644
> --- a/arch/arm64/kernel/ptrace.c
> +++ b/arch/arm64/kernel/ptrace.c
> @@ -132,7 +132,7 @@ static bool regs_within_kernel_stack(struct pt_regs *regs, unsigned long addr)
>  {
>  	return ((addr & ~(THREAD_SIZE - 1))  ==
>  		(kernel_stack_pointer(regs) & ~(THREAD_SIZE - 1))) ||
> -		on_irq_stack(addr);
> +		on_irq_stack(addr, NULL, NULL);
>  }
>  
>  /**
> diff --git a/arch/arm64/kernel/sdei.c b/arch/arm64/kernel/sdei.c
> index 6b8d90d5ceae..8e18913a53fd 100644
> --- a/arch/arm64/kernel/sdei.c
> +++ b/arch/arm64/kernel/sdei.c
> @@ -88,7 +88,9 @@ static int init_sdei_stacks(void)
>  	return err;
>  }
>  
> -bool _on_sdei_stack(unsigned long sp)
> +bool _on_sdei_stack(unsigned long sp,
> +		unsigned long *stack_low,
> +		unsigned long *stack_high)
>  {
>  	unsigned long low, high;
>  
> @@ -98,13 +100,26 @@ bool _on_sdei_stack(unsigned long sp)
>  	low = (unsigned long)raw_cpu_read(sdei_stack_critical_ptr);
>  	high = low + SDEI_STACK_SIZE;
>  
> -	if (low <= sp && sp < high)
> +	if (low <= sp && sp < high) {
> +		if (stack_low && stack_high) {
> +			*stack_low = low;
> +			*stack_high = high;
> +		}
>  		return true;
> +	}
>  
>  	low = (unsigned long)raw_cpu_read(sdei_stack_normal_ptr);
>  	high = low + SDEI_STACK_SIZE;
>  
> -	return (low <= sp && sp < high);
> +	if (low <= sp && sp < high) {
> +		if (stack_low && stack_high) {
> +			*stack_low = low;
> +			*stack_high = high;
> +		}
> +		return true;
> +	}
> +
> +	return false;
>  }

We should probably split this into separate on_sdei_normal_stack() and
on_sdei_critical_stack() functions.

Then we can do:

bool on_sdei_<foo>_stack(...)
{
	if (<out of bounds>)
		return false;
	
	if (info) {
		<assign info fields>;
	}

	return true;
}

bool _on_sdei_stack(unsigned long sp, struct stack_info *info)
{
	if (on_sedi_critical_stack(sp, info))
		return true;
	if (on_sdei_normal_stack(sp, info))
		return true;
	
	return false;
}

... which is a little nicer for legibility.

Otherwise, this looks good to me.

Thanks,
Mark.
