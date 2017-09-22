Date: Fri, 22 Sep 2017 10:07:24 -0700
From: Eric Biggers <ebiggers3@gmail.com>
Message-ID: <20170922170724.GA103935@gmail.com>
References: <20170921185239.88398-1-ebiggers3@gmail.com>
 <20170922053314.wryoupq2vgrel24c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170922053314.wryoupq2vgrel24c@gmail.com>
Subject: [kernel-hardening] Re: [PATCH v3 0/3] x86/fpu: prevent leaking FPU registers via
 invalid FPU state
To: Ingo Molnar <mingo@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Dmitry Vyukov <dvyukov@google.com>, Fenghua Yu <fenghua.yu@intel.com>, Kevin Hao <haokexin@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Wanpeng Li <wanpeng.li@hotmail.com>, Yu-cheng Yu <yu-cheng.yu@intel.com>, Michael Halcrow <mhalcrow@google.com>, Eric Biggers <ebiggers@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Sep 22, 2017 at 07:33:14AM +0200, Ingo Molnar wrote:
> 
> * Eric Biggers <ebiggers3@gmail.com> wrote:
> 
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > This series fixes the bug found by syzkaller where the ptrace syscall
> > can be used to set invalid bits in a task's FPU state.  I also found
> > that an equivalent bug was reachable using the sigreturn syscall, so the
> > first patch fixes the bug in both cases.
> > 
> > The other two patches start validating the other parts of the
> > xstate_header and make it so that invalid FPU states can no longer be
> > abused to leak the FPU registers of other processes.
> > 
> > Changes since v2:
> >     - Use an exception handler to handle invalid FPU states
> >       (suggested by Andy Lutomirski)
> >     - Check the size of xstate_header.reserved at build time
> >       (suggested by Dave Hansen)
> > 
> > Eric Biggers (3):
> >   x86/fpu: don't let userspace set bogus xcomp_bv
> >   x86/fpu: tighten validation of user-supplied xstate_header
> >   x86/fpu: reinitialize FPU registers if restoring FPU state fails
> > 
> >  arch/x86/include/asm/fpu/internal.h | 51 +++++++++++--------------------------
> >  arch/x86/include/asm/fpu/xstate.h   | 25 ++++++++++++++++++
> >  arch/x86/kernel/fpu/regset.c        | 20 +++++++--------
> >  arch/x86/kernel/fpu/signal.c        | 15 ++++++++---
> >  arch/x86/kernel/fpu/xstate.c        | 27 ++++++++------------
> >  arch/x86/mm/extable.c               | 24 +++++++++++++++++
> >  6 files changed, 94 insertions(+), 68 deletions(-)
> 
> Ok - could you please rebase these to to tip:master that is at:
> 
> 	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git master
> 
> In particular this has a WIP.x86/fpu branch with FPU fixes+changes queued up but 
> not merged upstream (yet), which conflict with these changes. I'd like to merge 
> them all together.
> 

Working on it, but there is a problem with current tip.  PTRACE_GETREGSET is
causing the following warning:

[    5.024462] WARNING: CPU: 1 PID: 347 at arch/x86/kernel/fpu/core.c:147 fpu__save+0x2ab/0x2c0
[    5.025030] CPU: 1 PID: 347 Comm: reproduce Not tainted 4.14.0-rc1-00274-ga4cc07ed56ab #615
[    5.025639] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
[    5.026183] task: ffff8af778664380 task.stack: ffff98f6008f8000
[    5.026590] RIP: 0010:fpu__save+0x2ab/0x2c0
[    5.027376] RSP: 0018:ffff98f6008fbd90 EFLAGS: 00010202
[    5.027751] RAX: ffff8af778665a40 RBX: ffff8af779ccfb80 RCX: 0000000000000340
[    5.028235] RDX: 0000000000000000 RSI: ffffffffb566d348 RDI: ffff8af779ccfb80
[    5.028718] RBP: ffff98f6008fbda0 R08: 0000000000000000 R09: 00007fffb907e870
[    5.029205] R10: ffffffffb4a25780 R11: ffffffffb5404c60 R12: ffff8af779ccfb80
[    5.029685] R13: 0000000000000340 R14: ffff8af779cce4c0 R15: ffff8af779ccfb80
[    5.030557] FS:  00007f662220d700(0000) GS:ffff8af77f400000(0000) knlGS:0000000000000000
[    5.031114] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    5.031504] CR2: 00007fa712274008 CR3: 0000000078730003 CR4: 00000000001606e0
[    5.031990] Call Trace:
[    5.032166]  fpu__activate_fpstate_read+0x90/0x240
[    5.032493]  xstateregs_get+0x53/0x160
[    5.032767]  ptrace_regset+0x123/0x180
[    5.033034]  ptrace_request+0x460/0x590
[    5.033300]  ? wait_task_inactive+0xdb/0x270
[    5.043352]  arch_ptrace+0x34c/0x3d0
[    5.043631]  ? ptrace_check_attach+0xd1/0x120
[    5.043929]  SyS_ptrace+0xa6/0x100
[    5.044164]  entry_SYSCALL_64_fastpath+0x1f/0xbe
[    5.044478] RIP: 0033:0x7f6621b17c6e
[    5.044724] RSP: 002b:00007fffb907e838 EFLAGS: 00000202 ORIG_RAX: 0000000000000065
[    5.045233] RAX: ffffffffffffffda RBX: 0000000000601050 RCX: 00007f6621b17c6e
[    5.045711] RDX: 0000000000000202 RSI: 000000000000015c RDI: 0000000000004204
[    5.046189] RBP: 00000000004008e0 R08: 0000000000004203 R09: 000000000000015b
[    5.046668] R10: 00007fffb907e850 R11: 0000000000000202 R12: 00000000004007f2
[    5.047777] R13: 00007fffb907f960 R14: 0000000000000000 R15: 0000000000000000
[    5.048262] Code: c0 0f 85 ce fe ff ff 48 c7 c2 88 34 5c b5 be 2c 00 00 00 48 c7 c7 e0 5f 5c b5 c6 05 49 71 f0 00 01 e8 da ae 0a 00 e9 aa fe ff ff <0f> ff e9 75 fd ff ff 0f ff e9 b5 fd ff ff 0f 1f 80 00 00 00 00 
