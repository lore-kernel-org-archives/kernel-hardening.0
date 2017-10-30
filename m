References: <1508631773-2502-1-git-send-email-alex.popov@linux.com>
 <1508631773-2502-3-git-send-email-alex.popov@linux.com>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <d74e0d32-d794-62d1-27fa-d96f4cf37522@linux.com>
Date: Mon, 30 Oct 2017 19:51:33 +0300
MIME-Version: 1.0
In-Reply-To: <1508631773-2502-3-git-send-email-alex.popov@linux.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH RFC v5 2/5] gcc-plugins: Add STACKLEAK plugin for tracking
 the kernel stack
To: kernel-hardening@lists.openwall.com, keescook@chromium.org, pageexec@freemail.hu, spender@grsecurity.net, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, tycho@docker.com, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 22.10.2017 03:22, Alexander Popov wrote:
> The STACKLEAK feature erases the kernel stack before returning from
> syscalls. That reduces the information which kernel stack leak bugs can
> reveal and blocks some uninitialized stack variable attacks. Moreover,
> STACKLEAK provides runtime checks for kernel stack overflow detection.
> 
> This commit introduces the STACKLEAK gcc plugin. It is needed for:
>  - tracking the lowest border of the kernel stack, which is important
>     for the code erasing the used part of the kernel stack at the end
>     of syscalls (comes in a separate commit);
>  - checking that alloca calls don't cause stack overflow.
> 
> So this plugin instruments the kernel code inserting:
>  - the check_alloca() call before alloca and the track_stack() call
>     after it;
>  - the track_stack() call for the functions with a stack frame size
>     greater than or equal to CONFIG_STACKLEAK_TRACK_MIN_SIZE.
> 
> The STACKLEAK feature is ported from grsecurity/PaX. More information at:
>   https://grsecurity.net/
>   https://pax.grsecurity.net/
> 
> This code is modified from Brad Spengler/PaX Team's code in the last
> public patch of grsecurity/PaX based on our understanding of the code.
> Changes or omissions from the original code are ours and don't reflect
> the original grsecurity/PaX code.
> 
> Signed-off-by: Alexander Popov <alex.popov@linux.com>
> ---
>  arch/Kconfig                           |  12 +
>  arch/x86/kernel/dumpstack.c            |  15 ++
>  fs/exec.c                              |  30 +++
>  scripts/Makefile.gcc-plugins           |   3 +
>  scripts/gcc-plugins/stackleak_plugin.c | 470 +++++++++++++++++++++++++++++++++
>  5 files changed, 530 insertions(+)
>  create mode 100644 scripts/gcc-plugins/stackleak_plugin.c
> 

[...]

> diff --git a/fs/exec.c b/fs/exec.c
> index 3e14ba2..481ef4b 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1958,3 +1958,33 @@ COMPAT_SYSCALL_DEFINE5(execveat, int, fd,
>  				  argv, envp, flags);
>  }
>  #endif
> +
> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> +void __used track_stack(void)
> +{
> +	/*
> +	 * N.B. The arch-specific part of the STACKLEAK feature fills the
> +	 * kernel stack with the poison value, which has the register width.
> +	 * That code assumes that the value of thread.lowest_stack is aligned
> +	 * on the register width boundary.
> +	 *
> +	 * That is true for x86 and x86_64 because of the kernel stack
> +	 * alignment on these platforms (for details, see cc_stack_align in
> +	 * arch/x86/Makefile). Take care of that when you port STACKLEAK to
> +	 * new platforms.
> +	 */
> +	unsigned long sp = (unsigned long)&sp;
> +
> +	if (sp < current->thread.lowest_stack &&
> +	    sp >= (unsigned long)task_stack_page(current) +
> +					2 * sizeof(unsigned long)) {
> +		current->thread.lowest_stack = sp;
> +	}
> +
> +#ifndef CONFIG_VMAP_STACK
> +	if (unlikely((sp & (THREAD_SIZE - 1)) < (THREAD_SIZE / 16)))
> +		BUG();

Hello, I need your help! I'm trying to solve the problem with the recursive
BUG() here (currently on x86_64).

When the thread stack is exhausted, this BUG() is hit. But do_error_trap(),
which handles the exception, calls track_stack() itself again (since it is
instrumented by the gcc plugin). So this recursion proceeds with exhausting the
thread stack.

Finally the stack pointer oversteps the stack bottom and the bug is not hit
anymore, because (sp & (THREAD_SIZE - 1)) is big again. And we have such an oops
message printed:

[   17.529075] ------------[ cut here ]------------
[   17.529075] kernel BUG at fs/exec.c:1986!
[   17.529075] invalid opcode: 0000 [#1] SMP
[   17.529075] Dumping ftrace buffer:
[   17.529075]    (ftrace buffer empty)
[   17.529075] Modules linked in: lkdtm
[   17.529075] CPU: 0 PID: 2651 Comm: sh Not tainted 4.14.0-rc5+ #10
[   17.529075] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
Ubuntu-1.8.2-1ubuntu1 04/01/2014
[   17.529075] task: ffff880079950040 task.stack: ffff88007a904000
[   17.529075] RIP: 0010:track_stack+0x52/0x60
[   17.529075] RSP: 0018:ffff88007a904078 EFLAGS: 00010193
[   17.529075] RAX: 0000000000000078 RBX: 0000000000000006 RCX: ffff88007a904010
[   17.529075] RDX: ffff880079950040 RSI: ffff88007a904000 RDI: ffff88007a904168
[   17.529075] RBP: ffff88007a904080 R08: 0000000000000004 R09: 000000000000018c
[   17.529075] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88007a904168
[   17.529075] R13: 0000000000000004 R14: ffffffff81bd33c9 R15: 0000000000000000
[   17.529075] FS:  00007f469977e700(0000) GS:ffff88007fc00000(0000)
knlGS:0000000000000000
[   17.529075] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   17.529075] CR2: 00000000021ab618 CR3: 000000007a404000 CR4: 00000000000006f0
[   17.529075] Call Trace:
[   17.529075]  do_error_trap+0x25/0xe0
[   17.529075]  do_invalid_op+0x2a/0x30
[   17.529075]  invalid_op+0x18/0x20
[   17.529075] RIP: 0010:track_stack+0x52/0x60
[   17.529075] RSP: 0018:ffff88007a904218 EFLAGS: 00010193
[   17.529075] RAX: 0000000000000218 RBX: 0000000000000006 RCX: ffff88007a904010
[   17.529075] RDX: ffff880079950040 RSI: ffff88007a904000 RDI: ffff88007a904308
[   17.529075] RBP: ffff88007a904220 R08: 0000000000000004 R09: 000000000000018c
[   17.529075] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88007a904308
[   17.529075] R13: 0000000000000004 R14: ffffffff81bd33c9 R15: 0000000000000000
[   17.529075]  do_error_trap+0x25/0xe0
[   17.529075]  do_invalid_op+0x2a/0x30
[   17.529075]  invalid_op+0x18/0x20
[   17.529075] RIP: 0010:track_stack+0x52/0x60
[   17.529075] RSP: 0018:ffff88007a9043b8 EFLAGS: 00010393
[   17.529075] RAX: 00000000000003b8 RBX: ffff88007a907d90 RCX: ffff88007a904010
[   17.529075] RDX: ffff880079950040 RSI: ffff88007a904000 RDI: ffff88007a907d90
[   17.529075] RBP: ffff88007a9043c0 R08: 0000000000000000 R09: 000000000000018c
[   17.529075] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000003d0
[   17.529075] R13: ffffffffc0007020 R14: 0000000000000016 R15: 000000000000003d
[   17.529075]  recursion+0x14/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  ? put_dec+0x24/0xb0
[   17.529075]  ? put_dec+0x24/0xb0
[   17.529075]  ? number+0x2c5/0x2e0
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  ? vsnprintf+0xd1/0x4b0
[   17.529075]  ? wait_for_xmitr+0x32/0x90
[   17.529075]  ? serial8250_console_putchar+0x25/0x30
[   17.529075]  ? wait_for_xmitr+0x90/0x90
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  ? up+0x30/0x50
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  ? vprintk_emit+0x24a/0x2d0
[   17.529075]  recursion+0x58/0x70 [lkdtm]
[   17.529075]  ? vprintk_func+0x31/0x80
[   17.529075]  ? printk+0x4a/0x55
[   17.529075]  lkdtm_STACKLEAK_TRACK_STACK+0x39/0x4d [lkdtm]
[   17.529075]  lkdtm_do_action+0x18/0x20 [lkdtm]
[   17.529075]  direct_entry+0xcc/0x130 [lkdtm]
[   17.529075]  full_proxy_write+0x4f/0x90
[   17.529075]  __vfs_write+0x36/0x140
[   17.529075]  ? security_file_permission+0x36/0xb0
[   17.529075]  vfs_write+0xb1/0x1a0
[   17.529075]  SyS_write+0x46/0xa0
[   17.529075]  entry_SYSCALL_64_fastpath+0x1a/0xaa
[   17.529075] RIP: 0033:0x7f46992a1600
[   17.529075] RSP: 002b:00007fffe4466838 EFLAGS: 00000246 ORIG_RAX:
0000000000000001
[   17.529075] RAX: ffffffffffffffda RBX: 000000000000006b RCX: 00007f46992a1600
[   17.529075] RDX: 0000000000000016 RSI: 00000000021a9610 RDI: 0000000000000001
[   17.529075] RBP: 0000000000002710 R08: 0000000000000003 R09: 0000000000002010
[   17.529075] R10: 0000000000000871 R11: 0000000000000246 R12: 00007f469955eb58
[   17.529075] R13: 0000000000002010 R14: 00000000021a9600 R15: 00007f469955eb00
[   17.529075] Code: 8d 4e 10 48 39 c8 73 0f 25 ff 3f 00 00 48 3d ff 03 00 00 76
16 c9 c3 48 89 82 30 0a 00 00 25 ff 3f 00 00 48 3d ff 03 00 00 77 ea <0f> 0b 66
90 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 54 53
[   17.529075] RIP: track_stack+0x52/0x60 RSP: ffff88007a904078
[   17.529075] ---[ end trace 3f0d8f585f4dcc08 ]---


But printing this message spoils the memory below the exhausted stack, right?

Can we somehow handle this BUG() in another stack to avoid the recursion?

Thanks!

> +#endif /* !CONFIG_VMAP_STACK */
> +}
> +EXPORT_SYMBOL(track_stack);
> +#endif /* CONFIG_GCC_PLUGIN_STACKLEAK */

[...]

Best regards,
Alexander
