Date: Fri, 4 May 2018 12:09:08 +0100
From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 2/2] arm64: Clear the stack
Message-ID: <20180504110907.c2dw33kjmyybso6t@lakrids.cambridge.arm.com>
References: <20180502203326.9491-1-labbott@redhat.com>
 <20180502203326.9491-3-labbott@redhat.com>
 <20180503071917.xm2xvgagvzkworay@salmiak>
 <dd6ad26c-1d2c-88f3-8f01-e68d2b31d6ea@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd6ad26c-1d2c-88f3-8f01-e68d2b31d6ea@linux.com>
To: Alexander Popov <alex.popov@linux.com>
Cc: Laura Abbott <labbott@redhat.com>, Kees Cook <keescook@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, May 03, 2018 at 08:33:38PM +0300, Alexander Popov wrote:
> Hello Mark and Laura,
> 
> Let me join the discussion. Mark, thanks for your feedback!
> 
> On 03.05.2018 10:19, Mark Rutland wrote:
> > Hi Laura,
> > 
> > On Wed, May 02, 2018 at 01:33:26PM -0700, Laura Abbott wrote:
> >>
> >> Implementation of stackleak based heavily on the x86 version
> >>
> >> Signed-off-by: Laura Abbott <labbott@redhat.com>
> >> ---
> >> Now written in C instead of a bunch of assembly.
> > 
> > This looks neat!
> > 
> > I have a few minor comments below.
> > 
> >> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
> >> index bf825f38d206..0ceea613c65b 100644
> >> --- a/arch/arm64/kernel/Makefile
> >> +++ b/arch/arm64/kernel/Makefile
> >> @@ -55,6 +55,9 @@ arm64-reloc-test-y := reloc_test_core.o reloc_test_syms.o
> >>  arm64-obj-$(CONFIG_CRASH_DUMP)		+= crash_dump.o
> >>  arm64-obj-$(CONFIG_ARM_SDE_INTERFACE)	+= sdei.o
> >>  
> >> +arm64-obj-$(CONFIG_GCC_PLUGIN_STACKLEAK) += erase.o
> >> +KASAN_SANITIZE_erase.o	:= n
> > 
> > I suspect we want to avoid the full set of instrumentation suspects here, e.g.
> > GKOV, KASAN, UBSAN, and KCOV.
> 
> I've disabled KASAN instrumentation for that file on x86 because erase_kstack()
> intentionally writes to the stack and causes KASAN false positive reports.
> 
> But I didn't see any conflicts with other types of instrumentation that you
> mentioned.

The rationale is that any of these can result in implicit calls to C
functions at arbitrary points during erase_kstack(). That could
interfere with the search for poison, and/or leave data on the stack
which is not erased.

They won't result in hard failures, as KASAN would, but we should
probably avoid them regardless.

[...]

> >> +asmlinkage void erase_kstack(void)
> >> +{
> >> +	unsigned long p = current->thread.lowest_stack;
> >> +	unsigned long boundary = p & ~(THREAD_SIZE - 1);
> >> +	unsigned long poison = 0;
> >> +	const unsigned long check_depth = STACKLEAK_POISON_CHECK_DEPTH /
> >> +							sizeof(unsigned long);
> >> +
> >> +	/*
> >> +	 * Let's search for the poison value in the stack.
> >> +	 * Start from the lowest_stack and go to the bottom.
> >> +	 */
> >> +	while (p > boundary && poison <= check_depth) {
> >> +		if (*(unsigned long *)p == STACKLEAK_POISON)
> >> +			poison++;
> >> +		else
> >> +			poison = 0;
> >> +
> >> +		p -= sizeof(unsigned long);
> >> +	}
> >> +
> >> +	/*
> >> +	 * One long int at the bottom of the thread stack is reserved and
> >> +	 * should not be poisoned (see CONFIG_SCHED_STACK_END_CHECK).
> >> +	 */
> >> +	if (p == boundary)
> >> +		p += sizeof(unsigned long);
> > 
> > I wonder if end_of_stack() should be taught about CONFIG_SCHED_STACK_END_CHECK,
> > given that's supposed to return the last *usable* long on the stack, and we
> > don't account for this elsewhere.
> 
> I would be afraid to change the meaning of end_of_stack()... Currently it
> considers that magic long as usable (include/linux/sched/task_stack.h):
> 
> #define task_stack_end_corrupted(task) \
> 		(*(end_of_stack(task)) != STACK_END_MAGIC)
> 
> 
> > If we did, then IIUC we could do:
> > 
> > 	unsigned long boundary = (unsigned long)end_of_stack(current);
> > 
> > ... at the start of the function, and not have to worry about this explicitly.
> 
> I should mention that erase_kstack() can be called from x86 trampoline stack.
> That's why the boundary is calculated from the lowest_stack.

Ok. Under what circumstances does that happen?

It seems a little scary that curent::thread::lowest_stack might not be
on current's task stack. Is that reset when transitioning to/from the
trampoile stack?

[...]

> >> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> >> +void __used check_alloca(unsigned long size)
> >> +{
> >> +	unsigned long sp, stack_left;
> >> +
> >> +	sp = current_stack_pointer;
> >> +
> >> +	stack_left = sp & (THREAD_SIZE - 1);
> >> +	BUG_ON(stack_left < 256 || size >= stack_left - 256);
> >> +}
> > 
> > Is this arbitrary, or is there something special about 256?
> > 
> > Even if this is arbitrary, can we give it some mnemonic?
> 
> It's just a reasonable number. We can introduce a macro for it.

I'm just not sure I see the point in the offset, given things like
VMAP_STACK exist. BUG_ON() handling will likely require *more* than 256
bytes of stack, so it seems superfluous, as we'd be relying on stack
overflow detection at that point.

I can see that we should take the CONFIG_SCHED_STACK_END_CHECK offset
into account, though.

> >> +EXPORT_SYMBOL(check_alloca);
> >> +#endif
> >> diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
> >> index a34e9290a699..25dd2a14560d 100644
> >> --- a/drivers/firmware/efi/libstub/Makefile
> >> +++ b/drivers/firmware/efi/libstub/Makefile
> >> @@ -20,7 +20,8 @@ cflags-$(CONFIG_EFI_ARMSTUB)	+= -I$(srctree)/scripts/dtc/libfdt
> >>  KBUILD_CFLAGS			:= $(cflags-y) -DDISABLE_BRANCH_PROFILING \
> >>  				   -D__NO_FORTIFY \
> >>  				   $(call cc-option,-ffreestanding) \
> >> -				   $(call cc-option,-fno-stack-protector)
> >> +				   $(call cc-option,-fno-stack-protector) \
> >> +				   $(DISABLE_STACKLEAK_PLUGIN)
> >>  
> >>  GCOV_PROFILE			:= n
> >>  KASAN_SANITIZE			:= n
> > 
> > I believe we'll also need to do this for the KVM hyp code in arch/arm64/kvm/hyp/.
> 
> Could you please give more details on that? Why STACKLEAK breaks it?

In the hyp/EL2 exception level, we only map the hyp text, and not the
rest of the kernel. So erase_kstack and check_alloca won't be mapped,
and attempt to branch to them will fault.

Even if it were mapped, things like BUG_ON(), get_current(), etc do not
work at hyp.

Additionally, the hyp code is mapped as a different virtual address from
the rest of the kernel, so if any of the STACKLEAK code happens to use
an absolute address, this will not work correctly.

Thanks,
Mark.
