Date: Thu, 26 Jan 2017 16:10:12 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
Message-ID: <20170126071010.GE23406@linaro.org>
References: <1485351983-13873-1-git-send-email-kpark3469@gmail.com>
 <20170125135410.GF27026@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170125135410.GF27026@arm.com>
Subject: [kernel-hardening] Re: [PATCH] arm64: usercopy: Implement stack frame object validation
To: Will Deacon <will.deacon@arm.com>
Cc: kpark3469@gmail.com, kernel-hardening@lists.openwall.com, catalin.marinas@arm.com, keescook@chromium.org, mark.rutland@arm.com, james.morse@arm.com, panand@redhat.com, keun-o.park@darkmatter.ae
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 25, 2017 at 01:54:10PM +0000, Will Deacon wrote:
> [Adding Akashi, since he'a had fun and games with arm64 stack unwinding
>  and I bet he can find a problem with this patch!]

I have had hard time to play with that :)

> On Wed, Jan 25, 2017 at 05:46:23PM +0400, kpark3469@gmail.com wrote:
> > From: Sahara <keun-o.park@darkmatter.ae>
> > 
> > This implements arch_within_stack_frames() for arm64 that should
> > validate if a given object is contained by a kernel stack frame.
> > 
> > Signed-off-by: Sahara <keun-o.park@darkmatter.ae>
> > ---
> >  arch/arm64/Kconfig                   |  1 +
> >  arch/arm64/include/asm/thread_info.h | 55 ++++++++++++++++++++++++++++++++++++
> >  2 files changed, 56 insertions(+)
> > 
> > diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> > index 1117421..8bf70b4 100644
> > --- a/arch/arm64/Kconfig
> > +++ b/arch/arm64/Kconfig
> > @@ -97,6 +97,7 @@ config ARM64
> >  	select HAVE_SYSCALL_TRACEPOINTS
> >  	select HAVE_KPROBES
> >  	select HAVE_KRETPROBES if HAVE_KPROBES
> > +	select HAVE_ARCH_WITHIN_STACK_FRAMES
> >  	select IOMMU_DMA if IOMMU_SUPPORT
> >  	select IRQ_DOMAIN
> >  	select IRQ_FORCED_THREADING
> > diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
> > index 46c3b93..f610c44 100644
> > --- a/arch/arm64/include/asm/thread_info.h
> > +++ b/arch/arm64/include/asm/thread_info.h
> > @@ -68,7 +68,62 @@ struct thread_info {
> >  #define thread_saved_fp(tsk)	\
> >  	((unsigned long)(tsk->thread.cpu_context.fp))
> >  
> > +/*
> > + * Walks up the stack frames to make sure that the specified object is
> > + * entirely contained by a single stack frame.
> > + *
> > + * Returns:
> > + *		 1 if within a frame
> > + *		-1 if placed across a frame boundary (or outside stack)
> > + *		 0 unable to determine (no frame pointers, etc)
> > + */
> > +static inline int arch_within_stack_frames(const void * const stack,
> > +					   const void * const stackend,
> > +					   const void *obj, unsigned long len)
> > +{
> > +#if defined(CONFIG_FRAME_POINTER)

nitpick: s/#if defined()/#ifdef/, or just remove this guard?

> > +	const void *oldframe;
> > +	const void *callee_fp = NULL;
> > +	const void *caller_fp = NULL;
> > +
> > +	oldframe = __builtin_frame_address(1);
> > +	if (oldframe) {
> > +		callee_fp = __builtin_frame_address(2);
> > +		if (callee_fp)
> > +			caller_fp = __builtin_frame_address(3);
> > +	}
> > +	/*
> > +	 * low ----------------------------------------------> high
> > +	 * [callee_fp][lr][args][local vars][caller_fp'][lr']
> > +	 *                ^----------------^
> > +	 *               allow copies only within here
> > +	 */
> 
> Which compilers have you tested this with? The GCC folks don't guarantee a
> frame layout, and they have changed it in the past,

I don't know whether any changes have been made before or not, but

> so I suspect this is
> pretty fragile. In particularly, if __builtin_frame_address just points
> at the frame record, then I don't think you can make assumptions about the
> placement of local variables and arguments with respect to that.
> 
> Will

Yes and no.

AAPCS64 says,
- The stack implementation is full-descending (5.2.2)
- A process may only access (for reading or writing) the closed interval
  of the entire stack delimited by [SP, stack-base - 1]. (5.2.2.1)
- The location of the frame record within a stack frame is not specified
  (5.2.3)

To my best knowledge, dynamically allocated object (local variable) may be
allocated below the current frame pointer, decrementing the stack pointer.
Take a look at a simple example:

===8<===
#include <stdio.h>
#include <stdlib.h>

int main(int ac, char **av) {
	int array_size;
	register unsigned long sp asm("sp");

	if (ac < 2) {
		printf("No argument\n");
		return 1;
	}
	array_size = atoi(av[1]);
	printf("frame pointer: %lx\n", __builtin_frame_address(0));
	printf("Before dynamic alloc: %lx\n", sp);
	{
		long array[array_size];

		printf("After dynamic alloc: %lx\n", sp);
	}

	return 0;
}
===>8===

and the result (with gcc 5.3) is:
  frame pointer:        ffffe32bacd0
  Before dynamic alloc: ffffe32bacd0
  After dynamic alloc:  ffffe32bac70

Given this fact,

> > +	/*
> > +	 * low ----------------------------------------------> high
> > +	 * [callee_fp][lr][args][local vars][caller_fp'][lr']
> > +	 *                ^----------------^
> > +	 *               allow copies only within here
> > +	 */

this picture may not always be precise in that "local variables" are
local to the callee, OR possibly local to the *caller*.
However, the range check is done here in a while loop that walks through
the whole callstack chain, and so I assume that it would work in most cases
except the case that a callee function hits that usage.

I think there are a few (not many) places of such code in the kernel,
(around net IIRC, but don' know they call usercopy functions or not).

Thanks,
-Takahiro AKASHI
