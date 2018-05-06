From: Alexander Popov <alex.popov@linux.com>
Subject: [PATCH 2/2] arm64: Clear the stack
References: <20180502203326.9491-1-labbott@redhat.com>
 <20180502203326.9491-3-labbott@redhat.com>
 <20180503071917.xm2xvgagvzkworay@salmiak>
 <dd6ad26c-1d2c-88f3-8f01-e68d2b31d6ea@linux.com>
 <20180504110907.c2dw33kjmyybso6t@lakrids.cambridge.arm.com>
Message-ID: <4badae50-be9b-2c6d-854b-57ab48664800@linux.com>
Date: Sun, 6 May 2018 11:22:28 +0300
MIME-Version: 1.0
In-Reply-To: <20180504110907.c2dw33kjmyybso6t@lakrids.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Mark Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>
Cc: Laura Abbott <labbott@redhat.com>, Kees Cook <keescook@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 04.05.2018 14:09, Mark Rutland wrote:
> On Thu, May 03, 2018 at 08:33:38PM +0300, Alexander Popov wrote:
>> Hello Mark and Laura,
>>
>> Let me join the discussion. Mark, thanks for your feedback!
>>
>> On 03.05.2018 10:19, Mark Rutland wrote:
>>> Hi Laura,
>>>
>>> On Wed, May 02, 2018 at 01:33:26PM -0700, Laura Abbott wrote:
>>>>
>>>> Implementation of stackleak based heavily on the x86 version
>>>>
>>>> Signed-off-by: Laura Abbott <labbott@redhat.com>
>>>> ---
>>>> Now written in C instead of a bunch of assembly.
>>>
>>> This looks neat!
>>>
>>> I have a few minor comments below.
>>>
>>>> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
>>>> index bf825f38d206..0ceea613c65b 100644
>>>> --- a/arch/arm64/kernel/Makefile
>>>> +++ b/arch/arm64/kernel/Makefile
>>>> @@ -55,6 +55,9 @@ arm64-reloc-test-y := reloc_test_core.o reloc_test_syms.o
>>>>  arm64-obj-$(CONFIG_CRASH_DUMP)		+= crash_dump.o
>>>>  arm64-obj-$(CONFIG_ARM_SDE_INTERFACE)	+= sdei.o
>>>>  
>>>> +arm64-obj-$(CONFIG_GCC_PLUGIN_STACKLEAK) += erase.o
>>>> +KASAN_SANITIZE_erase.o	:= n
>>>
>>> I suspect we want to avoid the full set of instrumentation suspects here, e.g.
>>> GKOV, KASAN, UBSAN, and KCOV.
>>
>> I've disabled KASAN instrumentation for that file on x86 because erase_kstack()
>> intentionally writes to the stack and causes KASAN false positive reports.
>>
>> But I didn't see any conflicts with other types of instrumentation that you
>> mentioned.
> 
> The rationale is that any of these can result in implicit calls to C
> functions at arbitrary points during erase_kstack(). That could
> interfere with the search for poison, and/or leave data on the stack
> which is not erased.
> 
> They won't result in hard failures, as KASAN would, but we should
> probably avoid them regardless.

Thanks, Mark! Agree about KCOV, I'll switch it off for that file.

And I think I should _not_ disable UBSAN for that file. I didn't make any
intentional UB, so if UBSAN finds anything, that will be a true positive report.

> [...]
> 
>>>> +asmlinkage void erase_kstack(void)
>>>> +{
>>>> +	unsigned long p = current->thread.lowest_stack;
>>>> +	unsigned long boundary = p & ~(THREAD_SIZE - 1);
>>>> +	unsigned long poison = 0;
>>>> +	const unsigned long check_depth = STACKLEAK_POISON_CHECK_DEPTH /
>>>> +							sizeof(unsigned long);
>>>> +
>>>> +	/*
>>>> +	 * Let's search for the poison value in the stack.
>>>> +	 * Start from the lowest_stack and go to the bottom.
>>>> +	 */
>>>> +	while (p > boundary && poison <= check_depth) {
>>>> +		if (*(unsigned long *)p == STACKLEAK_POISON)
>>>> +			poison++;
>>>> +		else
>>>> +			poison = 0;
>>>> +
>>>> +		p -= sizeof(unsigned long);
>>>> +	}
>>>> +
>>>> +	/*
>>>> +	 * One long int at the bottom of the thread stack is reserved and
>>>> +	 * should not be poisoned (see CONFIG_SCHED_STACK_END_CHECK).
>>>> +	 */
>>>> +	if (p == boundary)
>>>> +		p += sizeof(unsigned long);
>>>
>>> I wonder if end_of_stack() should be taught about CONFIG_SCHED_STACK_END_CHECK,
>>> given that's supposed to return the last *usable* long on the stack, and we
>>> don't account for this elsewhere.
>>
>> I would be afraid to change the meaning of end_of_stack()... Currently it
>> considers that magic long as usable (include/linux/sched/task_stack.h):
>>
>> #define task_stack_end_corrupted(task) \
>> 		(*(end_of_stack(task)) != STACK_END_MAGIC)
>>
>>
>>> If we did, then IIUC we could do:
>>>
>>> 	unsigned long boundary = (unsigned long)end_of_stack(current);
>>>
>>> ... at the start of the function, and not have to worry about this explicitly.
>>
>> I should mention that erase_kstack() can be called from x86 trampoline stack.
>> That's why the boundary is calculated from the lowest_stack.
> 
> Ok. Under what circumstances does that happen?
> 
> It seems a little scary that curent::thread::lowest_stack might not be
> on current's task stack. 

Yes, indeed. That's why I check against that, please see BUG_ON() in
erase_kstack() for x86.

1. Calculate the boundary from the lowest_stack.
2. Search for poison between lowest_stack and boundary.
3. Now ready to write the poison.
4. Reset the boundary to current_stack_pointer if we are on the thread stack and
to current_top_of_stack otherwise (we are on the trampoline stack).
5. BUG_ON(boundary - p >= THREAD_SIZE);
6. Write poison till the boundary.

> Is that reset when transitioning to/from the
> trampoile stack?

We switch to the trampoline stack from the current thread stack just before
returning to the userspace. Please search for "trampoline stack" in
arch/x86/entry/entry_64.S.

> [...]
> 
>>>> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
>>>> +void __used check_alloca(unsigned long size)
>>>> +{
>>>> +	unsigned long sp, stack_left;
>>>> +
>>>> +	sp = current_stack_pointer;
>>>> +
>>>> +	stack_left = sp & (THREAD_SIZE - 1);
>>>> +	BUG_ON(stack_left < 256 || size >= stack_left - 256);
>>>> +}
>>>
>>> Is this arbitrary, or is there something special about 256?
>>>
>>> Even if this is arbitrary, can we give it some mnemonic?
>>
>> It's just a reasonable number. We can introduce a macro for it.
> 
> I'm just not sure I see the point in the offset, given things like
> VMAP_STACK exist. BUG_ON() handling will likely require *more* than 256
> bytes of stack, so it seems superfluous, as we'd be relying on stack
> overflow detection at that point.
> 
> I can see that we should take the CONFIG_SCHED_STACK_END_CHECK offset
> into account, though.

Mark, thank you for such an important remark!

In Kconfig STACKLEAK implies but doesn't depend on VMAP_STACK. In fact x86_32
doesn't have VMAP_STACK at all but can have STACKLEAK.

[Adding Andy Lutomirski]

I've made some additional experiments: I exhaust the thread stack to have only
(MIN_STACK_LEFT - 1) bytes left and then force alloca. If VMAP_STACK is
disabled, BUG_ON() handling causes stack depth overflow, which is detected by
SCHED_STACK_END_CHECK. If VMAP_STACK is enabled, the kernel hangs on BUG_ON()
handling! Enabling CONFIG_PROVE_LOCKING gives the needed report from VMAP_STACK:

[   43.543962] lkdtm: try a large alloca of 14647 bytes (sp 18446683600580263344)...
[   43.545188] BUG: stack guard page was hit at 00000000830608b8 (stack is 000000009375e943..00000000cb7f52d9)
[   43.545189] kernel stack overflow (double-fault): 0000 [#1] SMP PTI
[   43.545189] Dumping ftrace buffer:
[   43.545190]    (ftrace buffer empty)
[   43.545190] Modules linked in: lkdtm
[   43.545192] CPU: 0 PID: 2682 Comm: sh Not tainted 4.17.0-rc3+ #23
[   43.545192] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
[   43.545193] RIP: 0010:mark_lock+0xe/0x540
[   43.545193] RSP: 0018:ffffc900009c0000 EFLAGS: 00010002
[   43.545194] RAX: 000000000000000c RBX: ffff880079b3b590 RCX: 0000000000000008
[   43.545194] RDX: 0000000000000008 RSI: ffff880079b3b590 RDI: ffff880079b3ad40
[   43.545195] RBP: ffffc900009c0100 R08: 0000000000000002 R09: 0000000000000000
[   43.545195] R10: ffffc900009c0118 R11: 0000000000000000 R12: 0000000000000000
[   43.545196] R13: ffff880079b3ad40 R14: ffff880079b3ad40 R15: ffffffff810cb8d7
[   43.545196] FS:  00007f544c7d8700(0000) GS:ffff88007fc00000(0000) knlGS:0000000000000000
[   43.545197] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   43.545200] CR2: ffffc900009bfff8 CR3: 0000000079194000 CR4: 00000000000006f0
[   43.545200] Call Trace:
[   43.545201]  ? vprintk_emit+0x67/0x440
[   43.545201]  __lock_acquire+0x2e0/0x13e0
[   43.545201]  ? lock_acquire+0x9d/0x1e0
[   43.545202]  lock_acquire+0x9d/0x1e0
[   43.545202]  ? vprintk_emit+0x67/0x440
[   43.545203]  _raw_spin_lock+0x20/0x30
[   43.545203]  ? vprintk_emit+0x67/0x440
[   43.545203]  vprintk_emit+0x67/0x440
[   43.545204]  ? check_alloca+0x9a/0xb0
[   43.545204]  printk+0x50/0x6f
[   43.545204]  ? __probe_kernel_read+0x34/0x60
[   43.545205]  ? check_alloca+0x9a/0xb0
[   43.545205]  report_bug+0xd3/0x110
[   43.545206]  fixup_bug.part.10+0x13/0x30
[   43.545206]  do_error_trap+0x158/0x190
[   43.545206]  ? trace_hardirqs_off_thunk+0x1a/0x1c
[   43.545207]  invalid_op+0x14/0x20
[   43.545207] RIP: 0010:check_alloca+0x9a/0xb0
[   43.545207] RSP: 0018:ffffc900009c0408 EFLAGS: 00010287
[   43.545208] RAX: 0000000000000008 RBX: 0000000000003936 RCX: 0000000000000001
[   43.545209] RDX: 0000000000000002 RSI: 0000000000000000 RDI: ffffc900009c0408
[   43.545209] RBP: ffffc900009c3da0 R08: 0000000000000000 R09: 0000000000000000
[   43.545210] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000003936
[   43.545210] R13: 0000000001ff0610 R14: 0000000000000011 R15: ffffc900009c3f08
[   43.545210]  ? check_alloca+0x64/0xb0
[   43.545211]  do_alloca+0x55/0x71b [lkdtm]
[   43.545211]  ? noop_count+0x10/0x10
[   43.545211]  ? check_usage+0xb1/0x4d0
[   43.545212]  ? noop_count+0x10/0x10
[   43.545212]  ? check_usage+0xb1/0x4d0
[   43.545213]  ? serial8250_console_write+0x253/0x2b0
[   43.545213]  ? serial8250_console_write+0x253/0x2b0
[   43.545213]  ? __lock_acquire+0x2e0/0x13e0
[   43.545214]  ? up+0xd/0x50
[   43.545214]  ? console_unlock+0x374/0x660
[   43.545215]  ? __lock_acquire+0x2e0/0x13e0
[   43.545215]  ? retint_kernel+0x10/0x10
[   43.545215]  ? trace_hardirqs_on_caller+0xed/0x180
[   43.545216]  ? find_held_lock+0x2d/0x90
[   43.545216]  ? mark_held_locks+0x4e/0x80
[   43.545216]  ? console_unlock+0x471/0x660
[   43.545217]  ? trace_hardirqs_on_caller+0xed/0x180
[   43.545217]  ? vprintk_emit+0x235/0x440
[   43.545218]  ? get_stack_info+0x32/0x160
[   43.545218]  ? check_alloca+0x64/0xb0
[   43.545218]  ? do_alloca+0x1f/0x71b [lkdtm]
[   43.545219]  lkdtm_STACKLEAK_ALLOCA+0x8f/0xb0 [lkdtm]
[   43.545219]  direct_entry+0xc5/0x110 [lkdtm]
[   43.545220]  full_proxy_write+0x51/0x80
[   43.545220]  __vfs_write+0x49/0x180
[   43.545220]  ? rcu_read_lock_sched_held+0x53/0x60
[   43.545221]  ? rcu_sync_lockdep_assert+0x29/0x50
[   43.545221]  ? __sb_start_write+0x110/0x160
[   43.545221]  ? vfs_write+0x172/0x190
[   43.545222]  vfs_write+0xa8/0x190
[   43.545222]  ksys_write+0x50/0xc0
[   43.545223]  do_syscall_64+0x51/0x1a0
[   43.545223]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[   43.545223] RIP: 0033:0x7f544c306370
[   43.545224] RSP: 002b:00007ffc223bacb8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[   43.545225] RAX: ffffffffffffffda RBX: 0000000001ff0610 RCX: 00007f544c306370
[   43.545225] RDX: 0000000000000011 RSI: 0000000001ff0610 RDI: 0000000000000001
[   43.545225] RBP: 0000000000000011 R08: 41434f4c4c415f4b R09: 00007f544c5bce90
[   43.545226] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
[   43.545226] R13: 0000000000000011 R14: 7fffffffffffffff R15: 0000000000000000
[   43.545227] Code: 08 08 00 00 48 c7 c7 70 56 2d 82 5b 48 89 d1 e9 a4 48 01 00 66 0f 1f 84 00 00 00 00 00 41 57 41 56
89 d1 41 55 41 54 49 89 fd 55 <53> bb 01 00 00 00 d3 e3 48 89 f5 41 89 d4 48 83 ec 08 0f b7 46
[   43.545241] RIP: mark_lock+0xe/0x540 RSP: ffffc900009c0000
[   43.545241] ---[ end trace 63196de7418a092e ]---
[   43.545242] Kernel panic - not syncing: corrupted stack end detected inside scheduler
[   43.545242]


I can't say why VMAP_STACK report hangs during BUG_ON() handling on defconfig.
Andy, can you give a clue?

I see that MIN_STACK_LEFT = 2048 is enough for BUG_ON() handling on both x86_64
and x86_32. So I'm going to:
 - set MIN_STACK_LEFT to 2048;
 - improve the lkdtm test to cover this case.

Mark, Kees, Laura, does it sound good?

>>>> +EXPORT_SYMBOL(check_alloca);
>>>> +#endif
>>>> diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
>>>> index a34e9290a699..25dd2a14560d 100644
>>>> --- a/drivers/firmware/efi/libstub/Makefile
>>>> +++ b/drivers/firmware/efi/libstub/Makefile
>>>> @@ -20,7 +20,8 @@ cflags-$(CONFIG_EFI_ARMSTUB)	+= -I$(srctree)/scripts/dtc/libfdt
>>>>  KBUILD_CFLAGS			:= $(cflags-y) -DDISABLE_BRANCH_PROFILING \
>>>>  				   -D__NO_FORTIFY \
>>>>  				   $(call cc-option,-ffreestanding) \
>>>> -				   $(call cc-option,-fno-stack-protector)
>>>> +				   $(call cc-option,-fno-stack-protector) \
>>>> +				   $(DISABLE_STACKLEAK_PLUGIN)
>>>>  
>>>>  GCOV_PROFILE			:= n
>>>>  KASAN_SANITIZE			:= n
>>>
>>> I believe we'll also need to do this for the KVM hyp code in arch/arm64/kvm/hyp/.
>>
>> Could you please give more details on that? Why STACKLEAK breaks it?
> 
> In the hyp/EL2 exception level, we only map the hyp text, and not the
> rest of the kernel. So erase_kstack and check_alloca won't be mapped,
> and attempt to branch to them will fault.

Here you mean track_stack() and not erase_kstack(), right?

> Even if it were mapped, things like BUG_ON(), get_current(), etc do not
> work at hyp.
> 
> Additionally, the hyp code is mapped as a different virtual address from
> the rest of the kernel, so if any of the STACKLEAK code happens to use
> an absolute address, this will not work correctly.

Thanks for the details. This quite old article [1] says:
  The code run in HYP mode is limited to a few hundred instructions and isolated
  to two assembly files: arch/arm/kvm/interrupts.S and arch/arm/kvm/interrupts_head.S.

Is all hyp code now localized in arch/arm64/kvm/hyp/?

[1]: https://lwn.net/Articles/557132/

Best regards,
Alexander
