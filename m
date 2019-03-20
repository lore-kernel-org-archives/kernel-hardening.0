From: "Reshetova, Elena" <elena.reshetova@intel.com>
Subject: RE: [RFC PATCH] x86/entry/64: randomize kernel stack offset upon
 syscall
Date: Wed, 20 Mar 2019 07:29:50 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612BA4C0E5D1@IRSMSX102.ger.corp.intel.com>
References: <20190320072715.3857-1-elena.reshetova@intel.com>
In-Reply-To: <20190320072715.3857-1-elena.reshetova@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "luto@kernel.org" <luto@kernel.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "luto@amacapital.net" <luto@amacapital.net>, "jpoimboe@redhat.com" <jpoimboe@redhat.com>, "keescook@chromium.org" <keescook@chromium.org>, "jannh@google.com" <jannh@google.com>, "Perla, Enrico" <enrico.perla@intel.com>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, "tglx@linutronix.de" <tglx@linutronix.de>, "peterz@infradead.org" <peterz@infradead.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

My apologies for the double posting: I just realized today that I used my o=
ther template to send this RFC, so it went to lkml and not kernel-hardening=
, where it should have gone at the first place.=20

> -----Original Message-----
> From: Reshetova, Elena
> Sent: Wednesday, March 20, 2019 9:27 AM
> To: luto@kernel.org
> Cc: kernel-hardening@lists.openwall.com; luto@amacapital.net;
> jpoimboe@redhat.com; keescook@chromium.org; jannh@google.com; Perla,
> Enrico <enrico.perla@intel.com>; mingo@redhat.com; bp@alien8.de;
> tglx@linutronix.de; peterz@infradead.org; gregkh@linuxfoundation.org; Res=
hetova,
> Elena <elena.reshetova@intel.com>
> Subject: [RFC PATCH] x86/entry/64: randomize kernel stack offset upon sys=
call
>=20
> If CONFIG_RANDOMIZE_KSTACK_OFFSET is selected,
> the kernel stack offset is randomized upon each
> entry to a system call after fixed location of pt_regs
> struct.
>=20
> This feature is based on the original idea from
> the PaX's RANDKSTACK feature:
> https://pax.grsecurity.net/docs/randkstack.txt
> All the credits for the original idea goes to the PaX team.
> However, the design and implementation of
> RANDOMIZE_KSTACK_OFFSET differs greatly from the RANDKSTACK
> feature (see below).
>=20
> Reasoning for the feature:
>=20
> This feature aims to make considerably harder various
> stack-based attacks that rely on deterministic stack
> structure.
> We have had many of such attacks in past [1],[2],[3]
> (just to name few), and as Linux kernel stack protections
> have been constantly improving (vmap-based stack
> allocation with guard pages, removal of thread_info,
> STACKLEAK), attackers have to find new ways for their
> exploits to work.
>=20
> It is important to note that we currently cannot show
> a concrete attack that would be stopped by this new
> feature (given that other existing stack protections
> are enabled), so this is an attempt to be on a proactive
> side vs. catching up with existing successful exploits.
>=20
> The main idea is that since the stack offset is
> randomized upon each system call, it is very hard for
> attacker to reliably land in any particular place on
> the thread stack when attack is performed.
> Also, since randomization is performed *after* pt_regs,
> the ptrace-based approach to discover randomization
> offset during a long-running syscall should not be
> possible.
>=20
> [1] jon.oberheide.org/files/infiltrate12-thestackisback.pdf
> [2] jon.oberheide.org/files/stackjacking-infiltrate11.pdf
> [3] googleprojectzero.blogspot.com/2016/06/exploiting-
> recursion-in-linux-kernel_20.html
>=20
> Design description:
>=20
> During most of the kernel's execution, it runs on the "thread
> stack", which is allocated at fork.c/dup_task_struct() and stored in
> a per-task variable (tsk->stack). Since stack is growing downward,
> the stack top can be always calculated using task_top_of_stack(tsk)
> function, which essentially returns an address of tsk->stack + stack
> size. When VMAP_STACK is enabled, the thread stack is allocated from
> vmalloc space.
>=20
> Thread stack is pretty deterministic on its structure - fixed in size,
> and upon every entry from a userspace to kernel on a
> syscall the thread stack is started to be constructed from an
> address fetched from a per-cpu cpu_current_top_of_stack variable.
> The first element to be pushed to the thread stack is the pt_regs struct
> that stores all required CPU registers and sys call parameters.
>=20
> The goal of RANDOMIZE_KSTACK_OFFSET feature is to add a random offset
> after the pt_regs has been pushed to the stack and the rest of thread
> stack (used during the syscall processing) every time a process issues
> a syscall. The source of randomness can be taken either from rdtsc or
> rdrand with performance implications listed below. The value of random
> offset is stored in a callee-saved register (r15 currently) and the
> maximum size of random offset is defined by __MAX_STACK_RANDOM_OFFSET
> value, which currently equals to 0xFF0.
>=20
> As a result this patch introduces 8 bits of randomness
> (bits 4 - 11 are randomized, bits 0-3 must be zero due to stack alignment=
)
> after pt_regs location on the thread stack.
> The amount of randomness can be adjusted based on how much of the
> stack space we wish/can trade for security.
>=20
> The main issue with this approach is that it slightly breaks the
> processing of last frame in the unwinder, so I have made a simple
> fix to the frame pointer unwinder (I guess others should be fixed
> similarly) and stack dump functionality to "jump" over the random hole
> at the end. My way of solving this is probably far from ideal,
> so I would really appreciate feedback on how to improve it.
>=20
> Performance:
>=20
> 1) lmbench: ./lat_syscall -N 1000000 null
>     base:                     Simple syscall: 0.1774 microseconds
>     random_offset (rdtsc):     Simple syscall: 0.1803 microseconds
>     random_offset (rdrand): Simple syscall: 0.3702 microseconds
>=20
> 2)  Andy's tests, misc-tests: ./timing_test_64 10M sys_enosys
>     base:                     10000000 loops in 1.62224s =3D 162.22 nsec =
/ loop
>     random_offset (rdtsc):     10000000 loops in 1.64660s =3D 164.66 nsec=
 / loop
>     random_offset (rdrand): 10000000 loops in 3.51315s =3D 351.32 nsec / =
loop
>=20
> Comparison to grsecurity RANDKSTACK feature:
>=20
> RANDKSTACK feature randomizes the location of the stack start
> (cpu_current_top_of_stack), i.e. location of pt_regs structure
> itself on the stack. Initially this patch followed the same approach,
> but during the recent discussions [4], it has been determined
> to be of a little value since, if ptrace functionality is available
> for an attacker, he can use PTRACE_PEEKUSR/PTRACE_POKEUSR api to read/wri=
te
> different offsets in the pt_regs struct, observe the cache
> behavior of the pt_regs accesses, and figure out the random stack offset.
>=20
> Another big difference is that randomization is done upon
> syscall entry and not the exit, as with RANDKSTACK.
>=20
> Also, as a result of the above two differences, the implementation
> of RANDKSTACK and RANDOMIZE_KSTACK_OFFSET has nothing in common.
>=20
> [4] https://www.openwall.com/lists/kernel-hardening/2019/02/08/6
>=20
> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> ---
>  arch/Kconfig                   | 15 +++++++++++++++
>  arch/x86/Kconfig               |  1 +
>  arch/x86/entry/calling.h       | 14 ++++++++++++++
>  arch/x86/entry/entry_64.S      |  6 ++++++
>  arch/x86/include/asm/frame.h   |  3 +++
>  arch/x86/kernel/dumpstack.c    | 10 +++++++++-
>  arch/x86/kernel/unwind_frame.c |  9 ++++++++-
>  7 files changed, 56 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 4cfb6de48f79..9a2557b0cfce 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -808,6 +808,21 @@ config VMAP_STACK
>  	  the stack to map directly to the KASAN shadow map using a formula
>  	  that is incorrect if the stack is in vmalloc space.
>=20
> +config HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET
> +	def_bool n
> +	help
> +	  An arch should select this symbol if it can support kernel stack
> +	  offset randomization.
> +
> +config RANDOMIZE_KSTACK_OFFSET
> +	default n
> +	bool "Randomize kernel stack offset on syscall entry"
> +	depends on HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET
> +	help
> +	  Enable this if you want the randomize kernel stack offset upon
> +	  each syscall entry. This causes kernel stack (after pt_regs) to
> +	  have a randomized offset upon executing each system call.
> +
>  config ARCH_OPTIONAL_KERNEL_RWX
>  	def_bool n
>=20
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index ade12ec4224b..5edcae945b73 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -131,6 +131,7 @@ config X86
>  	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
>  	select HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD if X86_64
>  	select HAVE_ARCH_VMAP_STACK		if X86_64
> +	select HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET  if X86_64
>  	select HAVE_ARCH_WITHIN_STACK_FRAMES
>  	select HAVE_CMPXCHG_DOUBLE
>  	select HAVE_CMPXCHG_LOCAL
> diff --git a/arch/x86/entry/calling.h b/arch/x86/entry/calling.h
> index efb0d1b1f15f..68502645d812 100644
> --- a/arch/x86/entry/calling.h
> +++ b/arch/x86/entry/calling.h
> @@ -345,6 +345,20 @@ For 32-bit we have the following conventions - kerne=
l is
> built with
>  #endif
>  .endm
>=20
> +.macro RANDOMIZE_KSTACK
> +#ifdef CONFIG_RANDOMIZE_KSTACK_OFFSET
> +	/* prepare a random offset in rax */
> +	pushq %rax
> +	xorq  %rax, %rax
> +	ALTERNATIVE "rdtsc", "rdrand %rax", X86_FEATURE_RDRAND
> +	andq  $__MAX_STACK_RANDOM_OFFSET, %rax
> +
> +	/* store offset in r15 */
> +	movq  %rax, %r15
> +	popq  %rax
> +#endif
> +.endm
> +
>  /*
>   * This does 'call enter_from_user_mode' unless we can avoid it based on
>   * kernel config or using the static jump infrastructure.
> diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
> index 1f0efdb7b629..0816ec680c21 100644
> --- a/arch/x86/entry/entry_64.S
> +++ b/arch/x86/entry/entry_64.S
> @@ -167,13 +167,19 @@ GLOBAL(entry_SYSCALL_64_after_hwframe)
>=20
>  	PUSH_AND_CLEAR_REGS rax=3D$-ENOSYS
>=20
> +	RANDOMIZE_KSTACK		/* stores randomized
> offset in r15 */
> +
>  	TRACE_IRQS_OFF
>=20
>  	/* IRQs are off. */
>  	movq	%rax, %rdi
>  	movq	%rsp, %rsi
> +	sub 	%r15, %rsp          /* substitute random offset from rsp
> */
>  	call	do_syscall_64		/* returns with IRQs
> disabled */
>=20
> +	/* need to restore the gap */
> +	add 	%r15, %rsp       /* add random offset back to rsp */
> +
>  	TRACE_IRQS_IRETQ		/* we're about to
> change IF */
>=20
>  	/*
> diff --git a/arch/x86/include/asm/frame.h b/arch/x86/include/asm/frame.h
> index 5cbce6fbb534..e1bb91504f6e 100644
> --- a/arch/x86/include/asm/frame.h
> +++ b/arch/x86/include/asm/frame.h
> @@ -4,6 +4,9 @@
>=20
>  #include <asm/asm.h>
>=20
> +#ifdef CONFIG_RANDOMIZE_KSTACK_OFFSET
> +#define __MAX_STACK_RANDOM_OFFSET 0xFF0
> +#endif
>  /*
>   * These are stack frame creation macros.  They should be used by every
>   * callable non-leaf asm function to make kernel stack traces more relia=
ble.
> diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
> index 2b5886401e5f..4146a4c3e9c6 100644
> --- a/arch/x86/kernel/dumpstack.c
> +++ b/arch/x86/kernel/dumpstack.c
> @@ -192,7 +192,6 @@ void show_trace_log_lvl(struct task_struct *task, str=
uct
> pt_regs *regs,
>  	 */
>  	for ( ; stack; stack =3D PTR_ALIGN(stack_info.next_sp, sizeof(long))) {
>  		const char *stack_name;
> -
>  		if (get_stack_info(stack, task, &stack_info,
> &visit_mask)) {
>  			/*
>  			 * We weren't on a valid stack.  It's
> possible that
> @@ -224,6 +223,9 @@ void show_trace_log_lvl(struct task_struct *task, str=
uct
> pt_regs *regs,
>  		 */
>  		for (; stack < stack_info.end; stack++) {
>  			unsigned long real_addr;
> +#ifdef CONFIG_RANDOMIZE_KSTACK_OFFSET
> +			unsigned long left_gap;
> +#endif
>  			int reliable =3D 0;
>  			unsigned long addr =3D
> READ_ONCE_NOCHECK(*stack);
>  			unsigned long *ret_addr_p =3D
> @@ -272,6 +274,12 @@ void show_trace_log_lvl(struct task_struct *task, st=
ruct
> pt_regs *regs,
>  			regs =3D unwind_get_entry_regs(&state,
> &partial);
>  			if (regs)
>=20
> 	show_regs_if_on_stack(&stack_info, regs, partial);
> +#ifdef CONFIG_RANDOMIZE_KSTACK_OFFSET
> +			left_gap =3D (unsigned long)regs -
> (unsigned long)stack;
> +			/* if we reached last frame, jump over
> the random gap*/
> +			if (left_gap <
> __MAX_STACK_RANDOM_OFFSET)
> +				stack =3D (unsigned long
> *)regs--;
> +#endif
>  		}
>=20
>  		if (stack_name)
> diff --git a/arch/x86/kernel/unwind_frame.c b/arch/x86/kernel/unwind_fram=
e.c
> index 3dc26f95d46e..656f36b1f1b3 100644
> --- a/arch/x86/kernel/unwind_frame.c
> +++ b/arch/x86/kernel/unwind_frame.c
> @@ -98,7 +98,14 @@ static inline unsigned long *last_frame(struct unwind_=
state
> *state)
>=20
>  static bool is_last_frame(struct unwind_state *state)
>  {
> -	return state->bp =3D=3D last_frame(state);
> +	if (state->bp =3D=3D last_frame(state))
> +		return true;
> +#ifdef CONFIG_RANDOMIZE_KSTACK_OFFSET
> +	if ((last_frame(state) - state->bp) < __MAX_STACK_RANDOM_OFFSET)
> +		return true;
> +#endif
> +	return false;
> +
>  }
>=20
>  #ifdef CONFIG_X86_32
> --
> 2.17.1
