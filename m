Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC PATCH] x86/entry/64: randomize kernel stack offset upon system call
From: Andy Lutomirski <luto@amacapital.net>
In-Reply-To: <1549628149-11881-2-git-send-email-elena.reshetova@intel.com>
Date: Fri, 8 Feb 2019 08:34:36 -0800
Content-Transfer-Encoding: quoted-printable
Message-Id: <1D62D311-DD73-43BD-9ED1-8B9450842B89@amacapital.net>
References: <1549628149-11881-1-git-send-email-elena.reshetova@intel.com> <1549628149-11881-2-git-send-email-elena.reshetova@intel.com>
To: Elena Reshetova <elena.reshetova@intel.com>, jpoimboe@redhat.com
Cc: kernel-hardening@lists.openwall.com, luto@kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, peterz@infradead.org, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>



> On Feb 8, 2019, at 4:15 AM, Elena Reshetova <elena.reshetova@intel.com> wr=
ote:
>=20
> If CONFIG_RANDOMIZE_KSTACK_OFFSET is selected,
> the kernel stack offset is randomized upon each
> exit from a system call via the trampoline stack.
>=20
> This feature is based on the original idea from
> the PaX's RANDKSTACK feature:
> https://pax.grsecurity.net/docs/randkstack.txt
> All the credits for the original idea goes to the PaX team.
> However, the implementation of RANDOMIZE_KSTACK_OFFSET
> differs greatly from the RANDKSTACK feature (see below).
>=20
> Reasoning for the feature:
>=20
> This feature should make considerably harder various
> stack-based attacks that are based upon overflowing
> a kernel stack into adjusted kernel stack with a
> possibility to jump over a guard page.
> Since the stack offset is randomized upon each
> system call, it is very hard for attacker to reliably
> land in any particular place on the adjusted stack.
>=20

I think we need a better justification. With VLAs gone, it should be statica=
lly impossible to overflow past a guard page.

> Design description:
>=20
> During most of the kernel's execution, it runs on the "thread
> stack", which is allocated at fork.c/dup_task_struct() and stored in
> a per-task variable (tsk->stack). Since stack is growing downwards,
> the stack top can be always calculated using task_top_of_stack(tsk)
> function, which essentially returns an address of tsk->stack + stack
> size. When VMAP_STACK is enabled, the thread stack is allocated from
> vmalloc space.
>=20
> Thread stack is pretty deterministic on its structure - fixed in size,
> and upon every enter from a userspace to kernel on a
> syscall the thread stack is started to be constructed from an
> address fetched from a per-cpu cpu_current_top_of_stack variable.
> This variable is required since there is no way to reference "current"
> from the kernel entry/exit code, so the value of task_top_of_stack(tsk)
> is "shadowed" in a per-cpu variable each time the kernel context
> switches to a new task.
>=20
> The RANDOMIZE_KSTACK_OFFSET feature works by randomizing the value of
> task_top_of_stack(tsk) every time a process exits from a syscall. As
> a result the thread stack for that process will be constructed from a
> random offset from a fixed tsk->stack + stack size value upon subsequent
> syscall.
>=20

There is a vastly simpler way to do this: leave pt_regs in place and subtrac=
t a random multiple of 8 before pushing anything else onto the stack.  This g=
ets most of the benefit with much less complexity.

It=E2=80=99s maybe even better. If you can overflow a stack buffer to rewrit=
e pt_regs, you gain control of all registers. If the stack to pt_regs offset=
 is randomized, then this gets much harder.


>  - random bits are taken from get_random_long() instead of
>    rdtsc() for a better randomness. This however has a big
>    performance impact (see above the numbers) and additionally
>    if we happen to hit a point when a generator needs to be
>    reseeded, we might have an issue.

NAK.  I do not want entry code calling non-arch C code that is not explicitl=
y intended to be used from entry code like this. You may be violating all ki=
nds of rules about context tracking and even stack usage.

Just use ALTERNATIVE to select between RDTSC and RDRAND.  This isn=E2=80=99t=
 used for crypto =E2=80=94 refusing to =E2=80=9Ctrust=E2=80=9D the CPU here m=
akes no sense.

I think that, if you make these two changes, you=E2=80=99ll have a very stra=
ightforward 50-ish line patch.  The only real complication is how to find pt=
_regs on the way out. I think you could use RBP for this =E2=80=94 just make=
 it look like you have a regular frame-pointer-using stack frame between do_=
syscall_whatever and pt_regs. Josh Poimboeuf can help make sure you get all t=
he unwinding details right. It should be straightforward.=
