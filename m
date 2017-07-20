MIME-Version: 1.0
In-Reply-To: <aa086315-722b-bff3-90bb-f479229ed104@redhat.com>
References: <CAKv+Gu8jey+uPSFoCsjQn9BeGiChZpS=iZ0v9nEWvkwcO1gFYg@mail.gmail.com>
 <20170713104950.GB26194@leverpostej> <CAKv+Gu9eSX-f4uv3gaNw9_eKV0soe2-CqSnMaTjjEhMifxe_8g@mail.gmail.com>
 <20170713161050.GG26194@leverpostej> <20170713175543.GA32528@leverpostej>
 <CAKv+Gu_v3PO7=JSgCTb3aZu3sg4cwYYjy68VJnr58vzaMYvhTw@mail.gmail.com>
 <20170714103258.GA16128@leverpostej> <CAKv+Gu-FvfPFQooCie6HwP=mBng3C0jp9p8WMkFwTxctDu4JBA@mail.gmail.com>
 <CAKv+Gu96YHXDta7=YdYO4=wtR3mGVdkzAkG6tSzS-vo7toiPXA@mail.gmail.com>
 <20170714140605.GB16687@leverpostej> <20170714212717.GB1086@leverpostej>
 <CAKv+Gu9EB1nJPwvZh1Nti8tPVivqbwrE60t2v5zZp02DyaScxA@mail.gmail.com>
 <39a5ad84-4124-5b33-146a-cd4e48f3762f@redhat.com> <CAKv+Gu8vPNCK0J_bgfPDyos_hDrir_rKc154wfKtF_NqJ0LywQ@mail.gmail.com>
 <aa086315-722b-bff3-90bb-f479229ed104@redhat.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Thu, 20 Jul 2017 06:35:44 +0100
Message-ID: <CAKv+Gu_JNNVvLaSt3PTOexJV4HzPUN0mLOm6YYRS8d=UOafopQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [RFC PATCH 6/6] arm64: add VMAP_STACK and
 detect out-of-bounds SP
To: Laura Abbott <labbott@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Takahiro Akashi <akashi.takahiro@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <dave.martin@arm.com>, James Morse <james.morse@arm.com>, Laura Abbott <labbott@fedoraproject.org>, Will Deacon <will.deacon@arm.com>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 20 July 2017 at 00:32, Laura Abbott <labbott@redhat.com> wrote:
> On 07/19/2017 01:08 AM, Ard Biesheuvel wrote:
>> On 18 July 2017 at 22:53, Laura Abbott <labbott@redhat.com> wrote:
>>> On 07/15/2017 05:03 PM, Ard Biesheuvel wrote:
>>>> On 14 July 2017 at 22:27, Mark Rutland <mark.rutland@arm.com> wrote:
>>>>> On Fri, Jul 14, 2017 at 03:06:06PM +0100, Mark Rutland wrote:
>>>>>> On Fri, Jul 14, 2017 at 01:27:14PM +0100, Ard Biesheuvel wrote:
>>>>>>> On 14 July 2017 at 11:48, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>>>>>>>> On 14 July 2017 at 11:32, Mark Rutland <mark.rutland@arm.com> wrote:
>>>>>>>>> On Thu, Jul 13, 2017 at 07:28:48PM +0100, Ard Biesheuvel wrote:
>>>>>>
>>>>>>>>>> OK, so here's a crazy idea: what if we
>>>>>>>>>> a) carve out a dedicated range in the VMALLOC area for stacks
>>>>>>>>>> b) for each stack, allocate a naturally aligned window of 2x the stack
>>>>>>>>>> size, and map the stack inside it, leaving the remaining space
>>>>>>>>>> unmapped
>>>>>>
>>>>>>>>> The logical ops (TST) and conditional branches (TB(N)Z, CB(N)Z) operate
>>>>>>>>> on XZR rather than SP, so to do this we need to get the SP value into a
>>>>>>>>> GPR.
>>>>>>>>>
>>>>>>>>> Previously, I assumed this meant we needed to corrupt a GPR (and hence
>>>>>>>>> stash that GPR in a sysreg), so I started writing code to free sysregs.
>>>>>>>>>
>>>>>>>>> However, I now realise I was being thick, since we can stash the GPR
>>>>>>>>> in the SP:
>>>>>>>>>
>>>>>>>>>         sub     sp, sp, x0      // sp = orig_sp - x0
>>>>>>>>>         add     x0, sp, x0      // x0 = x0 - (orig_sp - x0) == orig_sp
>>>>>>
>>>>>> That comment is off, and should say     x0 = x0 + (orig_sp - x0) == orig_sp
>>>>>>
>>>>>>>>>         sub     x0, x0, #S_FRAME_SIZE
>>>>>>>>>         tb(nz)  x0, #THREAD_SHIFT, overflow
>>>>>>>>>         add     x0, x0, #S_FRAME_SIZE
>>>>>>>>>         sub     x0, sp, x0
>>>>>>>
>>>>>>> You need a neg x0, x0 here I think
>>>>>>
>>>>>> Oh, whoops. I'd mis-simplified things.
>>>>>>
>>>>>> We can avoid that by storing orig_sp + orig_x0 in sp:
>>>>>>
>>>>>>       add     sp, sp, x0      // sp = orig_sp + orig_x0
>>>>>>       sub     x0, sp, x0      // x0 = orig_sp
>>>>>>       < check >
>>>>>>       sub     x0, sp, x0      // x0 = orig_x0
>>>>>>       sub     sp, sp, x0      // sp = orig_sp
>>>>>>
>>>>>> ... which works in a locally-built kernel where I've aligned all the
>>>>>> stacks.
>>>>>
>>>>> FWIW, I've pushed out a somewhat cleaned-up (and slightly broken!)
>>>>> version of said kernel source to my arm64/vmap-stack-align branch [1].
>>>>> That's still missing the backtrace handling, IRQ stack alignment is
>>>>> broken at least on 64K pages, and there's still more cleanup and rework
>>>>> to do.
>>>>>
>>>>
>>>> I have spent some time addressing the issues mentioned in the commit
>>>> log. Please take a look.
>>>>
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git vmap-arm64-mark
>>>>
>>>
>>> I used vmap-arm64-mark to compile kernels for a few days. It seemed to
>>> work well enough.
>>>
>>
>> Thanks for giving this a spin. Any comments on the performance impact?
>> (if you happened to notice any)
>>
>
> I didn't notice any performance impact but I also wasn't trying that
> hard. I did try this with a different configuration and ran into
> stackspace errors almost immediately:
>
> [ 0.358026] smp: Brought up 1 node, 8 CPUs
> [ 0.359359] SMP: Total of 8 processors activated.
> [ 0.359542] CPU features: detected feature: 32-bit EL0 Support
> [    0.361781] Insufficient stack space to handle exception!
> [    0.362075] CPU: 4 PID: 0 Comm: swapper/4 Not tainted 4.12.0-00018-ge9cf49d604ef-dirty #23
> [    0.362538] Hardware name: linux,dummy-virt (DT)
> [    0.362844] task: ffffffc03a8a3200 task.stack: ffffff8008e80000
> [    0.363389] PC is at __do_softirq+0x88/0x210
> [    0.363585] LR is at __do_softirq+0x78/0x210
> [    0.363859] pc : [<ffffff80080bfba8>] lr : [<ffffff80080bfb98>] pstate: 80000145
> [    0.364109] sp : ffffffc03bf65ea0
> [    0.364253] x29: ffffffc03bf66830 x28: 0000000000000002
> [    0.364547] x27: ffffff8008e83e20 x26: 00000000fffedb5a
> [    0.364777] x25: 0000000000000001 x24: 0000000000000000
> [    0.365017] x23: ffffff8008dc5900 x22: ffffff8008c37000
> [    0.365242] x21: 0000000000000003 x20: 0000000000000000
> [    0.365557] x19: ffffff8008d02000 x18: 0000000000040000
> [    0.365991] x17: 0000000000000000 x16: 0000000000000008
> [    0.366148] x15: ffffffc03a400228 x14: 0000000000000000
> [    0.366296] x13: ffffff8008a50b98 x12: ffffffc03a916480
> [    0.366442] x11: ffffff8008a50ba0 x10: 0000000000000008
> [    0.366624] x9 : 0000000000000004 x8 : ffffffc03bf6f630
> [    0.366779] x7 : 0000000000000020 x6 : 00000000fffedb5a
> [    0.366924] x5 : 00000000ffffffff x4 : 000000403326a000
> [    0.367071] x3 : 0000000000000101 x2 : ffffff8008ce8000
> [    0.367218] x1 : ffffff8008dc5900 x0 : 0000000000000200
> [    0.367382] Task stack: [0xffffff8008e80000..0xffffff8008e84000]
> [    0.367519] IRQ stack:  [0xffffffc03bf62000..0xffffffc03bf66000]

The IRQ stack is not 16K aligned ...

> [    0.367687] ESR: 0x00000000 -- Unknown/Uncategorized
> [    0.367868] FAR: 0x0000000000000000
> [    0.368059] Kernel panic - not syncing: kernel stack overflow
> [    0.368252] CPU: 4 PID: 0 Comm: swapper/4 Not tainted 4.12.0-00018-ge9cf49d604ef-dirty #23
> [    0.368427] Hardware name: linux,dummy-virt (DT)
> [    0.368612] Call trace:
> [    0.368774] [<ffffff8008087fd8>] dump_backtrace+0x0/0x228
> [    0.368979] [<ffffff80080882c8>] show_stack+0x10/0x20
> [    0.369270] [<ffffff80084602dc>] dump_stack+0x88/0xac
> [    0.369459] [<ffffff800816328c>] panic+0x120/0x278
> [    0.369582] [<ffffff8008088b40>] handle_bad_stack+0xd0/0xd8
> [    0.369799] [<ffffff80080bfb94>] __do_softirq+0x74/0x210
> [    0.370560] SMP: stopping secondary CPUs
> [    0.384269] Rebooting in 5 seconds..
>
> The config is based on what I use for booting my Hikey android
> board. I haven't been able to narrow down exactly which
> set of configs set this off.
>

... so for some reason, the percpu atom size change fails to take effect here.
