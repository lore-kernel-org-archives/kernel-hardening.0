Date: Tue, 3 Jul 2018 13:14:41 +0100
From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] arm64: Clear the stack
Message-ID: <20180703121440.v4olvwqb3ykgt5fm@lakrids.cambridge.arm.com>
References: <20180629190553.7282-1-labbott@redhat.com>
 <9733d929-3c6a-40e1-6110-8f79975323d3@linux.com>
 <1b97aa7d-2b6c-a5df-0caa-1cd16e18a816@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b97aa7d-2b6c-a5df-0caa-1cd16e18a816@redhat.com>
To: Laura Abbott <labbott@redhat.com>, will.deacon@arm.com, catalin.marinas@arm.com
Cc: alex.popov@linux.com, Kees Cook <keescook@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, james.morse@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jul 02, 2018 at 11:48:05AM -0700, Laura Abbott wrote:
> On 07/02/2018 06:02 AM, Alexander Popov wrote:
> > On 29.06.2018 22:05, Laura Abbott wrote:
> > > Implementation of stackleak based heavily on the x86 version
> > > 
> > > Signed-off-by: Laura Abbott <labbott@redhat.com>
> > > ---
> > > Changes since last time:
> > > - Minor name change in entry.S
> > > - Converted to use the generic interfaces so there's minimal additions.
> > > - Added the fast syscall path.
> > > - Addition of on_thread_stack and current_top_of_stack
> > > - Disable stackleak on hyp per suggestion
> > > - Added a define for check_alloca. I'm still not sure about keeping it
> > >    since the x86 version got reworked?
> > > 
> > > I've mostly kept this as one patch with a minimal commit text. I can
> > > split it up and elaborate more before final merging.
> > > ---

[...]

> > > diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> > > index ec2ee720e33e..31c9da7d401e 100644
> > > --- a/arch/arm64/kernel/entry.S
> > > +++ b/arch/arm64/kernel/entry.S
> > > @@ -401,6 +401,11 @@ tsk	.req	x28		// current thread_info
> > >   	.text
> > > +	.macro	stackleak_erase
> > 
> > Could you rename the macro to STACKLEAK_ERASE for similarity with x86?
> > 
> 
> Mark Rutland had previously asked for this to be lowercase.
> I really don't care one way or the other so I'll defer to
> someone else to have the final word.

Will, Catalin, could you chime in either way?

I'd previously asked for lower-case for consistency with our other
assembly macros.

[...]

> > > diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
> > > index f08a2ed9db0d..9f0f135f8b66 100644
> > > --- a/arch/arm64/kernel/process.c
> > > +++ b/arch/arm64/kernel/process.c
> > > @@ -493,3 +493,19 @@ void arch_setup_new_exec(void)
> > >   {
> > >   	current->mm->context.flags = is_compat_task() ? MMCF_AARCH32 : 0;
> > >   }
> > > +
> > > +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> > > +#define MIN_STACK_LEFT	256
> > > +
> > > +void __used stackleak_check_alloca(unsigned long size)
> > > +{
> > > +	unsigned long sp, stack_left;
> > > +
> > > +	sp = current_stack_pointer;
> > > +
> > > +	stack_left = sp & (THREAD_SIZE - 1);
> > > +	BUG_ON(stack_left < MIN_STACK_LEFT ||
> > > +		size >= stack_left - MIN_STACK_LEFT);
> > > +}
> > > +EXPORT_SYMBOL(stackleak_check_alloca);
> > > +#endif
> > 
> > This code should be updated.
> > You may remember the troubles I had with MIN_STACK_LEFT:
> > http://openwall.com/lists/kernel-hardening/2018/05/11/12
> > Please see that thread where Mark Rutland and I worked out the solution.
> > 
> 
> Ah yeah, I missed the details in that thread. Thanks for
> that pointer.
> 
> > By the way, different stacks on x86_64 have different sizes. Is it false for arm64?
> 
> Currently everything except the overflow stack looks to be
> the same size but there's also another stack I missed.

Assuming I've followed the code correctly, we currently have:

stack		size		alignment (minimum)
---------------------------------------------------
task		THREAD_SIZE	THREAD_ALIGN
irq		THREAD_SIZE	16
overflow	SZ_4K		16
sdei_normal	THREAD_SIZE	THREAD_ALIGN
sdei_critical	THREAD_SIZE	THREAD_ALIGN

... since IRQ_STACK_SIZE is defined as THREAD_SIZE, and SDEI_STACK_SIZE
is defined as IRQ_STACK_SIZE.

So we can't just mask the sp, unfortunately.

> It might be cleaner just to use on_accessible_stack and then another
> function to get the top of stack. This also might just be
> reimplementing what x86 already has? (Mark, Ard?)

It looks like we could build a get_stack_info() as they have.

We could probably clean up our stack traced atop of that, too.

Thanks,
Mark.
