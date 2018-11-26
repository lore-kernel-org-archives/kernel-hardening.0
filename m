MIME-Version: 1.0
References: <20181126165957.xhsyu2dhyy45mrjo@linutronix.de>
In-Reply-To: <20181126165957.xhsyu2dhyy45mrjo@linutronix.de>
From: Jann Horn <jannh@google.com>
Date: Mon, 26 Nov 2018 18:12:21 +0100
Message-ID: <CAG48ez0Cc5cQxWVLoFNqgYZ1YA+7hHhjnDp-GvQuyeH8nCoOzw@mail.gmail.com>
Subject: Re: Backtrace after invalid XRSTOR after "x86/fault: BUG() when
 uaccess helpers fault on kernel addresses"
Content-Type: text/plain; charset="UTF-8"
To: bigeasy@linutronix.de
Cc: Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, naveen.n.rao@linux.vnet.ibm.com, Borislav Petkov <bp@alien8.de>, kernel list <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 26, 2018 at 5:59 PM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> Commit 75045f77f7a7 ("x86/extable: Introduce _ASM_EXTABLE_UA for uaccess
> fixups") made copy_user_to_xregs() -> XSTATE_OP() use _ASM_EXTABLE_UA.
> Commit 9da3f2b74054 ("x86/fault: BUG() when uaccess helpers fault on
> kernel addresses") then decided that a #GP is not good and has to be
> reported loudly.
>
> I had a TC which sets a few invalid bits in xstate which is used by
> copy_user_to_xregs() on sig-return. Before that change I had:
> | sig-xstate-bum[2253] bad frame in rt_sigreturn frame:0000000056078134 ip:7f9da336c227 sp:7ffc871325e8 orax:ffffffffffffffff in  libc-2.27.so[7f9da3358000+146000]
>
> after those two patches are applied:
> |BUG: GPF in non-whitelisted uaccess (non-canonical address?)
> |general protection fault: 0000 [#1] PREEMPT SMP NOPTI
> |CPU: 26 PID: 2236 Comm: sig-xstate-bum Not tainted 4.20.0-rc3 #45
> |RIP: 0010:__fpu__restore_sig+0x1c1/0x540
> |Code: 02 00 00 48 8b 95 58 ff ff ff 48 f7 d2 48 21 d0 0f 85 6e 03 00 00 0f 01 cb 48 8b 85 58 ff ff ff 48 89 df 48 89 c2 48 c1 ea 20 <48> 0f ae 2f 31 db 0f 01 ca 85 db 0f 84 d7 00 00 00 4c 89 f7 bb ff
> |Call Trace:
> | fpu__restore_sig+0x28/0x40
> | restore_sigcontext+0x13a/0x180
> | __ia32_sys_rt_sigreturn+0xae/0x100
> | do_syscall_64+0x4f/0x100
> | entry_SYSCALL_64_after_hwframe+0x44/0xa9
> |RIP: 0033:0x7f9b06aea227
> |---[ end trace a45ac23b593e9ab0 ]---
>
> The expected behaviour would that `xrstor' performs a #GP and this does
> not a produce a backtrace like that and copy_user_to_fxregs() returns an
> error.
> copy_user_to_fxregs() / user_insn() does not have this behaviour and
> that also might generate a #GP (if invalid bits are set in MCSR).
> What do we do?

Bleh. This code has to use normal _ASM_EXTABLE. _ASM_EXTABLE_UA is
(almost, with the exception of stuff like probe_kernel_read() and
exact_copy_from_user()) only for code that isn't expected to throw
things other than #PF with a userspace address. I must have missed
this when looking at the documentation for XRSTOR, or something like
that...
