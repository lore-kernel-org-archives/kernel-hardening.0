From: Alexander Popov <alex.popov@linux.com>
Subject: Re: [PATCH RFC v8 1/6] x86/entry: Add STACKLEAK erasing the kernel
 stack at the end of syscalls
References: <1518804657-24905-1-git-send-email-alex.popov@linux.com>
 <1518804657-24905-2-git-send-email-alex.popov@linux.com>
 <20180221132443.GA9989@pd.tnic>
Message-ID: <1e30ffd0-b35c-fcc2-ec8f-4495aefa7f6f@linux.com>
Date: Thu, 22 Feb 2018 00:49:44 +0300
MIME-Version: 1.0
In-Reply-To: <20180221132443.GA9989@pd.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Borislav Petkov <bp@alien8.de>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hello Borislav,

Thanks a lot for your review. Please see my comments below.

On 21.02.2018 16:24, Borislav Petkov wrote:
> On Fri, Feb 16, 2018 at 09:10:52PM +0300, Alexander Popov wrote:
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index 63bf349..62748bd 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -119,6 +119,7 @@ config X86
>>  	select HAVE_ARCH_COMPAT_MMAP_BASES	if MMU && COMPAT
>>  	select HAVE_ARCH_SECCOMP_FILTER
>>  	select HAVE_ARCH_THREAD_STRUCT_WHITELIST
>> +	select HAVE_ARCH_STACKLEAK
>>  	select HAVE_ARCH_TRACEHOOK
>>  	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
>>  	select HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD if X86_64
>> diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
>> index 16c2c02..4a7365a 100644
>> --- a/arch/x86/entry/entry_32.S
>> +++ b/arch/x86/entry/entry_32.S
>> @@ -77,6 +77,90 @@
>>  #endif
>>  .endm
>>  
>> +.macro erase_kstack
>> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
>> +	call erase_kstack
> 
> Hmm, why do we need a macro *and* a function of the same name? Why not do
> 
> 	call erase_kstack
> 
> everywhere we need to?
> 
> And then do
> 
> ENTRY(erase_kstack)
> #ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> 	...
> 
> to tone down the ifdeffery.

This approach doesn't work. There is the diff:

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index b418d3a..0a05755 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -66,14 +66,8 @@ END(native_usergs_sysret64)
        TRACE_IRQS_FLAGS EFLAGS(%rsp)
 .endm

-.macro erase_kstack
-#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
-       call erase_kstack
-#endif
-.endm
-
-#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
 ENTRY(erase_kstack)
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
        pushq   %rdi
        pushq   %rcx
        pushq   %rax
@@ -173,8 +167,8 @@ ENTRY(erase_kstack)
        popq    %rcx
        popq    %rdi
        ret
-ENDPROC(erase_kstack)
 #endif
+ENDPROC(erase_kstack)

 /*
  * When dynamic function tracer is enabled it will add a breakpoint
@@ -455,7 +449,7 @@ syscall_return_via_sysret:
         * We are on the trampoline stack.  All regs except RDI are live.
         * We can do future final exit work right here.
         */
-       erase_kstack
+       call erase_kstack

        SWITCH_TO_USER_CR3_STACK scratch_reg=%rdi

@@ -765,7 +759,7 @@ GLOBAL(swapgs_restore_regs_and_return_to_usermode)
         * We are on the trampoline stack.  All regs except RDI are live.
         * We can do future final exit work right here.
         */
-       erase_kstack
+       call erase_kstack

        SWITCH_TO_USER_CR3_STACK scratch_reg=%rdi


It crashes the kernel with STACKLEAK disabled:

[    1.709081] VFS: Mounted root (ext4 filesystem) readonly on device 8:0.
[    1.710202] devtmpfs: mounted
[    1.711741] Freeing unused kernel memory: 1276K
[    1.712391] Kernel memory protection disabled.
[    1.760050] PANIC: double fault, error_code: 0x0
[    1.760627] CPU: 0 PID: 1 Comm: init Not tainted 4.16.0-rc1+ #8
[    1.761005] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
[    1.761005] RIP: 0010:update_curr+0x7/0x160
[    1.761005] RSP: 0000:fffffe0000002000 EFLAGS: 00010002
[    1.761005] RAX: ffff88007c890100 RBX: ffff88007fc20900 RCX: 000000003da0c28c
[    1.761005] RDX: ffff88007fc20900 RSI: ffff88007c890100 RDI: ffff88007fc20900
[    1.761005] RBP: ffff88007c890100 R08: ffffffffffffffda R09: 0000000000000001
[    1.761005] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88007fc20900
[    1.761005] R13: ffff88007b529d00 R14: ffff88007c890100 R15: 0000000000000000
[    1.761005] FS:  0000000000000000(0000) GS:ffff88007fc00000(0000) knlGS:0000000000000000
[    1.761005] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.761005] CR2: fffffe0000001ff8 CR3: 000000007b090000 CR4: 00000000000006f0
[    1.761005] Call Trace:
[    1.761005]  <ENTRY_TRAMPOLINE>
[    1.761005]  put_prev_entity+0x31/0x580
[    1.761005]  pick_next_task_fair+0x454/0x470
[    1.761005]  __schedule+0x14b/0x6f0
[    1.761005]  schedule+0x23/0x80
[    1.761005]  exit_to_usermode_loop+0x5c/0x90
[    1.761005]  do_syscall_64+0xfa/0x110
[    1.761005]  entry_SYSCALL_64_after_hwframe+0x21/0x86
[    1.761005] RIP: 81a00935:swapgs_restore_regs_and_return_to_usermode+0x38/0x8c
[    1.761005] RSP: 81a00935:ffffffff81a00935 EFLAGS: ffffffff81a00935 ORIG_RAX: ffffffffffffffda
[    1.761005] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000000000
[    1.761005] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff81a00935
[    1.761005] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[    1.761005] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[    1.761005] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[    1.761005]  ? swapgs_restore_regs_and_return_to_usermode+0x38/0x8c
[    1.761005]  ? swapgs_restore_regs_and_return_to_usermode+0x38/0x8c
[    1.761005]  ? swapgs_restore_regs_and_return_to_usermode+0x38/0x8c
[    1.761005]  ? swapgs_restore_regs_and_return_to_usermode+0x38/0x8c
[    1.761005]  ? swapgs_restore_regs_and_return_to_usermode+0x38/0x8c
[    1.761005]  ? swapgs_restore_regs_and_return_to_usermode+0x38/0x8c
[    1.761005]  </ENTRY_TRAMPOLINE>
[    1.761005] Code: 02 00 00 8b 78 18 e8 29 ff ff ff 48 ba db 34 b6 d7 82 de 1b 43 48 f7 e2 48 89 d0 48 c1 e8 12 c3 0f
1f 40 00 41 56 41 55 41 54 55 <53> 48 8b 5f 40 48 8b 87 30 01 00 00 48 85 db 48 8b 80 68 09 00
[    1.761005] Kernel panic - not syncing: Machine halted.


Actually gcc creates a strange erase_kstack():

ffffffff81a00010 <erase_kstack>:
ffffffff81a00010:	5f                   	pop    %rdi
ffffffff81a00011:	eb 31                	jmp    ffffffff81a00044 <entry_SYSCALL_64_after_hwframe>
ffffffff81a00013:	0f 1f 00             	nopl   (%rax)
ffffffff81a00016:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
ffffffff81a0001d:	00 00 00


But with the initial macro the binary doesn't have erase_kstack() at all
when STACKLEAK is disabled.

>> +#endif
>> +.endm
>> +
>> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
>> +ENTRY(erase_kstack)
>> +	pushl	%edi
>> +	pushl	%ecx
>> +	pushl	%eax
>> +	pushl	%ebp
>> +
>> +	movl	PER_CPU_VAR(current_task), %ebp
>> +	mov	TASK_lowest_stack(%ebp), %edi
> 
> So instead of TASK_lowest_stack and adding all the ifdeffery around, why
> not do this computation:
> 
> 	(unsigned long)task_stack_page(p) + 2 * sizeof(unsigned long);
> 
> in asm?
> 
> You only need task->stack as an offset variable. And other code might
> need it too, anyway so you could just as well use it instead of adding
> another var to thread_struct.
> 
> /me reads further.
> 
> Ah. So this lowest_stack thing changes at the end:
> 
> 	"Set the lowest_stack value to the top_of_stack - 256"
> 
> Why?
> 
> So that magic needs more explanation for slow people like me.

Thanks for your question.

The commit message says: "Full STACKLEAK feature also contains the gcc plugin
which comes in a separate commit".

And the next commit in this series introduces that plugin. Let me quote its
commit message as well:

 This commit introduces the STACKLEAK gcc plugin. It is needed for:
  - tracking the lowest border of the kernel stack, which is important
     for the code erasing the used part of the kernel stack at the end
     of syscalls (comes in a separate commit);
  - checking that alloca calls don't cause stack overflow.

 So this plugin instruments the kernel code inserting:
  - the check_alloca() call before alloca and the track_stack() call
     after it;
  - the track_stack() call for the functions with a stack frame size
     greater than or equal to CONFIG_STACKLEAK_TRACK_MIN_SIZE.

Tracking the lowest border of the kernel stack with the lowest_stack
variable makes STACKLEAK so efficient (please see the performance
statistics in the cover letter).

>> +	mov	$STACKLEAK_POISON, %eax
>> +	std
>> +
>> +	/*
>> +	 * Let's search for the poison value in the stack.
>> +	 * Start from the lowest_stack and go to the bottom (see std above).
> 
> Let's write insns capitalized: "see STD above".

Ok.

> ...
> 
>> +	/*
>> +	 * Check that some further qwords contain poison. If so, the part
>> +	 * of the stack below the address in %rdi is likely to be poisoned.
>> +	 * Otherwise we need to search deeper.
>> +	 */
>> +	mov	$STACKLEAK_POISON_CHECK_DEPTH / 8, %ecx
>> +	repe	scasq
>> +	jecxz	2f	/* Poison the upper part of the stack */
>> +	jne	1b	/* Search deeper */
>> +
>> +2:
> 
> You could name that label
> 
> .Lpoison
> 
> and make the code more readable:
> 
> 	jb	.Lpoison
> 
> and so on.

Ok, thanks.

>> +	/*
>> +	 * Two qwords at the bottom of the thread stack are reserved and
>> +	 * should not be poisoned (see CONFIG_SCHED_STACK_END_CHECK).
>> +	 */
>> +	or	$2 * 8, %rdi
>> +
>> +	/*
>> +	 * Check whether we are on the thread stack to prepare the counter
>> +	 * for stack poisoning.
>> +	 */
>> +	mov	PER_CPU_VAR(cpu_current_top_of_stack), %rcx
>> +	sub	%rsp, %rcx
>> +	cmp	$THREAD_SIZE_asm, %rcx
>> +	jb	3f
>> +
>> +	/*
>> +	 * We are not on the thread stack, so we can write poison between
>> +	 * the address in %rdi and the stack top.
>> +	 */
>> +	mov	PER_CPU_VAR(cpu_current_top_of_stack), %rcx
>> +	sub	%rdi, %rcx
>> +	jmp	4f
>> +
>> +3:
>> +	/*
>> +	 * We are on the thread stack, so we can write poison between the
>> +	 * address in %rdi and the address in %rsp (not included, used memory).
>> +	 */
>> +	mov	%rsp, %rcx
>> +	sub	%rdi, %rcx
>> +
>> +4:
>> +	/* Check that the counter value is sane */
>> +	cmp	$THREAD_SIZE_asm, %rcx
>> +	jb	5f
>> +	ud2
>> +
>> +5:
>> +	/*
>> +	 * So let's write the poison value to the kernel stack. Start from the
>> +	 * address in %rdi and move up (see cld).
>> +	 */
>> +	cld
>> +	shr	$3, %ecx
>> +	rep	stosq
> 
> Hohumm, that's >2K loops per syscall here and stack is
> 
> 0xffffc90000008010:     0xffffffffffff4111      0xffffffffffff4111
> 0xffffc90000008020:     0xffffffffffff4111      0xffffffffffff4111
> 0xffffc90000008030:     0xffffffffffff4111      0xffffffffffff4111
> 0xffffc90000008040:     0xffffffffffff4111      0xffffffffffff4111
> 0xffffc90000008050:     0xffffffffffff4111      0xffffffffffff4111
> 0xffffc90000008060:     0xffffffffffff4111      0xffffffffffff4111

Yes, so the stack is erased. That is the actual goal.

> ...
>> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
>> +/* Poison value points to the unused hole in the virtual memory map */
> 
> There are a bunch of those there now. Please document it in
> Documentation/x86/x86_64/mm.txt
> 
>> +# define STACKLEAK_POISON -0xBEEF

The mm.txt already has this line:
 ffffffffffe00000 - ffffffffffffffff (=2 MB) unused hole

Excuse me, I didn't get what to document.

Thanks again.

Best regards,
Alexander
