Date: Wed, 25 Jan 2017 13:54:10 +0000
From: Will Deacon <will.deacon@arm.com>
Message-ID: <20170125135410.GF27026@arm.com>
References: <1485351983-13873-1-git-send-email-kpark3469@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1485351983-13873-1-git-send-email-kpark3469@gmail.com>
Subject: [kernel-hardening] Re: [PATCH] arm64: usercopy: Implement stack frame object validation
To: kpark3469@gmail.com
Cc: kernel-hardening@lists.openwall.com, catalin.marinas@arm.com, keescook@chromium.org, mark.rutland@arm.com, james.morse@arm.com, panand@redhat.com, keun-o.park@darkmatter.ae, takahiro.akashi@linaro.org
List-ID: <kernel-hardening.lists.openwall.com>

[Adding Akashi, since he'a had fun and games with arm64 stack unwinding
 and I bet he can find a problem with this patch!]

On Wed, Jan 25, 2017 at 05:46:23PM +0400, kpark3469@gmail.com wrote:
> From: Sahara <keun-o.park@darkmatter.ae>
> 
> This implements arch_within_stack_frames() for arm64 that should
> validate if a given object is contained by a kernel stack frame.
> 
> Signed-off-by: Sahara <keun-o.park@darkmatter.ae>
> ---
>  arch/arm64/Kconfig                   |  1 +
>  arch/arm64/include/asm/thread_info.h | 55 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 56 insertions(+)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 1117421..8bf70b4 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -97,6 +97,7 @@ config ARM64
>  	select HAVE_SYSCALL_TRACEPOINTS
>  	select HAVE_KPROBES
>  	select HAVE_KRETPROBES if HAVE_KPROBES
> +	select HAVE_ARCH_WITHIN_STACK_FRAMES
>  	select IOMMU_DMA if IOMMU_SUPPORT
>  	select IRQ_DOMAIN
>  	select IRQ_FORCED_THREADING
> diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
> index 46c3b93..f610c44 100644
> --- a/arch/arm64/include/asm/thread_info.h
> +++ b/arch/arm64/include/asm/thread_info.h
> @@ -68,7 +68,62 @@ struct thread_info {
>  #define thread_saved_fp(tsk)	\
>  	((unsigned long)(tsk->thread.cpu_context.fp))
>  
> +/*
> + * Walks up the stack frames to make sure that the specified object is
> + * entirely contained by a single stack frame.
> + *
> + * Returns:
> + *		 1 if within a frame
> + *		-1 if placed across a frame boundary (or outside stack)
> + *		 0 unable to determine (no frame pointers, etc)
> + */
> +static inline int arch_within_stack_frames(const void * const stack,
> +					   const void * const stackend,
> +					   const void *obj, unsigned long len)
> +{
> +#if defined(CONFIG_FRAME_POINTER)
> +	const void *oldframe;
> +	const void *callee_fp = NULL;
> +	const void *caller_fp = NULL;
> +
> +	oldframe = __builtin_frame_address(1);
> +	if (oldframe) {
> +		callee_fp = __builtin_frame_address(2);
> +		if (callee_fp)
> +			caller_fp = __builtin_frame_address(3);
> +	}
> +	/*
> +	 * low ----------------------------------------------> high
> +	 * [callee_fp][lr][args][local vars][caller_fp'][lr']
> +	 *                ^----------------^
> +	 *               allow copies only within here
> +	 */

Which compilers have you tested this with? The GCC folks don't guarantee a
frame layout, and they have changed it in the past, so I suspect this is
pretty fragile. In particularly, if __builtin_frame_address just points
at the frame record, then I don't think you can make assumptions about the
placement of local variables and arguments with respect to that.

Will
