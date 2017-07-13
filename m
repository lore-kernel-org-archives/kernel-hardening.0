MIME-Version: 1.0
In-Reply-To: <20170713104950.GB26194@leverpostej>
References: <1499898783-25732-1-git-send-email-mark.rutland@arm.com>
 <1499898783-25732-7-git-send-email-mark.rutland@arm.com> <CAKv+Gu8jey+uPSFoCsjQn9BeGiChZpS=iZ0v9nEWvkwcO1gFYg@mail.gmail.com>
 <20170713104950.GB26194@leverpostej>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Thu, 13 Jul 2017 12:49:48 +0100
Message-ID: <CAKv+Gu9eSX-f4uv3gaNw9_eKV0soe2-CqSnMaTjjEhMifxe_8g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [RFC PATCH 6/6] arm64: add VMAP_STACK and detect out-of-bounds SP
To: Mark Rutland <mark.rutland@arm.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Takahiro Akashi <akashi.takahiro@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <dave.martin@arm.com>, James Morse <james.morse@arm.com>, Laura Abbott <labbott@fedoraproject.org>, Will Deacon <will.deacon@arm.com>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 13 July 2017 at 11:49, Mark Rutland <mark.rutland@arm.com> wrote:
> On Thu, Jul 13, 2017 at 07:58:50AM +0100, Ard Biesheuvel wrote:
>> Hi Mark,
>
> Hi,
>
>> On 12 July 2017 at 23:33, Mark Rutland <mark.rutland@arm.com> wrote:
>> > +#ifdef CONFIG_VMAP_STACK
>> > +.macro detect_bad_stack
>> > +       msr     sp_el0, x0
>> > +       get_thread_info x0
>> > +       ldr     x0, [x0, #TSK_TI_CUR_STK]
>> > +       sub     x0, sp, x0
>> > +       and     x0, x0, #~(THREAD_SIZE - 1)
>> > +       cbnz    x0, __bad_stack
>> > +       mrs     x0, sp_el0
>>
>> The typical prologue looks like
>>
>> stp x29, x30, [sp, #-xxx]!
>> stp x27, x28, [sp, #xxx]
>> ...
>> mov x29, sp
>>
>> which means that in most cases where we do run off the stack, sp will
>> still be pointing into it when the exception is taken. This means we
>> will fault recursively in the handler before having had the chance to
>> accurately record the exception context.
>
> True; I had mostly been thinking about kernel_entry, where we do an
> explicit subtraction from the SP before any stores.
>
>> Given that the max displacement of a store instruction is 512 bytes,
>> and that the frame size we are about to stash exceeds that, should we
>> already consider it a stack fault if sp is within 512 bytes (or
>> S_FRAME_SIZE) of the base of the stack?
>
> Good point.
>
> I've flip-flopped on this point while writing this reply.
>
> My original line of thinking was that it was best to rely on the
> recursive fault to push the SP out-of-bounds. That keeps the overflow
> detection simple/fast, and hopefully robust to unexpected exceptions,
> (expected?) probes to the guard page, etc.
>
> I also agree that it's annoying to lose the information associated with the
> initial fault.
>
> My fear is that we can't catch those cases robustly and efficiently. At
> minimum, I believe we'd need to check:
>
> * FAR_EL1 is out-of-bounds for the stack. You have a suitable check for
>   this.
>
> * FAR_EL1 is valid (looking at the ESR_ELx.{EC,ISS}, etc). I'm not sure
>   exactly what we need to check here, and I'm not sure what we want to
>   do about reserved ESR_ELx encodings.
>
> * The base register for the access was the SP (e.g. so this isn't a
>   probe_kernel_read() or similar).
>
> ... so my current feeling is that relying on the recursive fault is the
> best bet, even if we lose some information from the initial fault.
>

There are two related issues at play here that we shouldn't conflate:
- checking whether we have sufficient stack space left to be able to
handle the exception in the first place,
- figuring out whether *this* exception was caused by a faulting
dereference of the stack pointer (which could be with writeback, or
even via some intermediate register: x29 is often used as a pseudo
stack pointer IIRC, although it should never point below sp itself)

Given that the very first stp in kernel_entry will fault if we have
less than S_FRAME_SIZE bytes of stack left, I think we should check
that we have at least that much space available. That way, the context
is preserved, and we could restart the outer exception if we wanted
to, or point our pt_regs pointer to it etc.

When and how we diagnose the condition as a kernel stack overflow is a
separate issue, and can well wait until we're in C code.

> Along with that, we should ensure that we get a reliable backtrace, so
> that we have the PC from the initial fault, and can acquire the relevant
> regs from a dump of the stack and/or the regs at the point of the
> recursive fault.
>
> FWIW, currently this series gives you something like:
>
> [ 0.263544] Stack out-of-bounds!
> [ 0.263544]  sp: 0xffff000009fbfed0
> [ 0.263544]  tsk stack: [0xffff000009fc0000..0xffff000009fd0000]
> [    0.263544]  irq stack: [0xffff80097fe100a0..0xffff80097fe200a0]
> [    0.304862] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 4.12.0-00006-g0c4fb26-dirty #73
> [    0.312830] Hardware name: ARM Juno development board (r1) (DT)
> [    0.318847] task: ffff800940d8a200 task.stack: ffff000009fc0000
> [    0.324872] PC is at el1_sync+0x20/0xc8
> [    0.328773] LR is at force_overflow+0xc/0x18
> [    0.333113] pc : [<ffff000008082460>] lr : [<ffff00000808c75c>] pstate: 600003c5
> [    0.340636] sp : ffff000009fbfed0
> [    0.344004] x29: ffff000009fc0000 x28: 0000000000000000
> [    0.349409] x27: 0000000000000000 x26: 0000000000000000
> [    0.354812] x25: 0000000000000000 x24: 0000000000000000
> [    0.360214] x23: 0000000000000000 x22: 0000000000000000
> [    0.365617] x21: 0000000000000000 x20: 0000000000000001
> [    0.371020] x19: 0000000000000001 x18: 0000000000000030
> [    0.376422] x17: 0000000000000000 x16: 0000000000000000
> [    0.381826] x15: 0000000000000008 x14: 000000000fb506bc
> [    0.387228] x13: 0000000000000000 x12: 0000000000000000
> [    0.392631] x11: 0000000000000000 x10: 0000000000000141
> [    0.398034] x9 : 0000000000000000 x8 : ffff80097fdf93e8
> [    0.403437] x7 : ffff80097fdf9410 x6 : 0000000000000001
> [    0.408839] x5 : ffff000008ebcb80 x4 : ffff000008eb65d8
> [    0.414242] x3 : 00000000000f4240 x2 : 0000000000000002
> [    0.419644] x1 : ffff800940d8a200 x0 : 0000000000000001
> [    0.425048] Kernel panic - not syncing: stack out-of-bounds
> [    0.430714] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 4.12.0-00006-g0c4fb26-dirty #73
> [    0.438679] Hardware name: ARM Juno development board (r1) (DT)
> [    0.444697] Call trace:
> [    0.447185] [<ffff000008086f68>] dump_backtrace+0x0/0x230
> [    0.452676] [<ffff00000808725c>] show_stack+0x14/0x20
> [    0.457815] [<ffff00000838760c>] dump_stack+0x9c/0xc0
> [    0.462953] [<ffff00000816d5a0>] panic+0x11c/0x294
> [    0.467825] [<ffff000008087a70>] __pte_error+0x0/0x28
> [    0.472961] [<ffff00000808c75c>] force_overflow+0xc/0x18
> [    0.478364] SMP: stopping secondary CPUs
> [    0.482356] ---[ end Kernel panic - not syncing: stack out-of-bounds
>
> ... that __pte_error() is because the last instruction in handle_bad_stack is a
> tail-call to panic, and __pte_error happens to be next in the text.
>
> I haven't yet dug into why the stacktrace ends abruptly. I think I need
> to update stack walkers to understand the new stack, but I may also have
> forgotten to do something with the frame record in the entry path.
>
> [...]
>
>> > +#ifdef CONFIG_VMAP_STACK
>> > +DEFINE_PER_CPU(unsigned long [IRQ_STACK_SIZE/sizeof(long)], bad_stack) __aligned(16);
>> > +
>>
>> Surely, we don't need a 16 KB or 64 KB stack here?
>
> For most cases, we do not need such a big stack. We can probably drop
> this down to something much smaller (1K, as with your series, sounds
> sufficient).
>
> The one case I was worried about was overflows on the emergency stack
> itself. I believe that for dumping memory we might need to fix up
> exceptions, and if that goes wrong we could go recursive.
>
> I'd planned to update current_stack when jumping to the emergency stack,
> and use the same (initial) bounds detection, requiring the emergency
> stack to be the same size. In the case of an emergency stack overflow,
> we'd go to a (stackless) wfi/wfe loop.
>
> However, I deleted bits of that code while trying to debug an unrelated
> issue, and didn't restore it.
>
> I guess it depends on whether we want to try to handle that case.
>
> Thanks,
> Mark.
