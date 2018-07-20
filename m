Date: Fri, 20 Jul 2018 07:38:37 +0100
From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCHv2 1/2] arm64: Add stack information to on_accessible_stack
Message-ID: <20180720063837.5c5nxypv4urumz2m@salmiak>
References: <20180719232806.3397-1-labbott@redhat.com>
 <20180719232806.3397-2-labbott@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180719232806.3397-2-labbott@redhat.com>
To: Laura Abbott <labbott@redhat.com>
Cc: Alexander Popov <alex.popov@linux.com>, Kees Cook <keescook@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jul 19, 2018 at 04:28:05PM -0700, Laura Abbott wrote:
> 
> In preparation for enabling the stackleak plugin on arm64,
> we need a way to get the bounds of the current stack. Extend
> on_accessible_stack to get this information.
> 
> Signed-off-by: Laura Abbott <labbott@redhat.com>
> ---
> v2: Switched to using struct stack_info for argument passing.
> on_accessible_stack is now the primary API. Split STACK_TYPE_SDEI
> into STACK_TYPE_SDEI_NORMAL and STACK_TYPE_SDEI_CRITICAL.

[...]

> -static inline bool on_irq_stack(unsigned long sp)
> +static inline bool on_irq_stack(unsigned long sp,
> +				struct stack_info *info)
>  {
>  	unsigned long low = (unsigned long)raw_cpu_read(irq_stack_ptr);
>  	unsigned long high = low + IRQ_STACK_SIZE;
> @@ -47,46 +63,79 @@ static inline bool on_irq_stack(unsigned long sp)
>  	if (!low)
>  		return false;
>  
> -	return (low <= sp && sp < high);
> +	if (sp < low || sp >= high)
> +		return false;
> +
> +	if (info) {
> +		info->low = low;
> +		info->high = high;
> +		info->type = STACK_TYPE_IRQ;
> +	}
> +
> +	return true;
>  }

[...]

> -bool _on_sdei_stack(unsigned long sp)
> +bool on_sdei_normal_stack(unsigned long sp,
> +			struct stack_info *info)
> +{
> +	unsigned long low = (unsigned long)raw_cpu_read(sdei_stack_normal_ptr);
> +	unsigned long high = low + SDEI_STACK_SIZE;
> +
> +	if (low <= sp && sp < high) {
> +		if (info) {
> +			info->low = low;
> +			info->high = high;
> +			info->type = STACK_TYPE_SDEI_NORMAL;
> +		}
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +bool on_sdei_critical_stack(unsigned long sp,
> +			struct stack_info *info)
> +{
> +	unsigned long low = (unsigned long)raw_cpu_read(sdei_stack_critical_ptr);
> +	unsigned long high = low + SDEI_STACK_SIZE;
> +
> +	if (low <= sp && sp < high) {
> +		if (info) {
> +			info->low = low;
> +			info->high = high;
> +			info->type = STACK_TYPE_SDEI_CRITICAL;
> +		}
> +		return true;
> +	}
> +
> +	return false;
> +}

Minor nit, but it would be good to avoid the nested conditionals for these two
by bailing out early when the SP is out of bounds, as with the other
on_<foo>_stack() functions, e.g.

bool on_sdei_normal_stack(unsigned long sp,
			struct stack_info *info)
{
	unsigned long low = (unsigned long)raw_cpu_read(sdei_stack_normal_ptr);
	unsigned long high = low + SDEI_STACK_SIZE;

	if (sp < low || sp >= high)
		return false;

	if (info) {
		info->low = low;
		info->high = high;
		info->type = STACK_TYPE_SDEI_NORMAL;
	}

	return true;
}

Otherwise, this all looks good to me. With that:

Reviewed-by: Mark Rutland <mark.rutland@arm.com>

Thanks for working on this!

Mark.
