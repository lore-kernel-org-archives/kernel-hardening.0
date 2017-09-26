Date: Mon, 25 Sep 2017 20:02:39 -0700
From: Eric Biggers <ebiggers3@gmail.com>
Message-ID: <20170926030239.GA2623@zzz.localdomain>
References: <20170920004434.35308-2-ebiggers3@gmail.com>
 <20170926021536.GD17200@yexl-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170926021536.GD17200@yexl-desktop>
Subject: [kernel-hardening] Re: [lkp-robot] [x86/fpu]  14e633085a:
 Kernel_panic-not_syncing:Attempted_to_kill_init!exitcode=
To: kernel test robot <xiaolong.ye@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Dmitry Vyukov <dvyukov@google.com>, Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@kernel.org>, Kevin Hao <haokexin@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Wanpeng Li <wanpeng.li@hotmail.com>, Yu-cheng Yu <yu-cheng.yu@intel.com>, Michael Halcrow <mhalcrow@google.com>, Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org, lkp@01.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Sep 26, 2017 at 10:15:36AM +0800, kernel test robot wrote:
> [    7.286014] init[1] bad frame in 32bit sigreturn frame:00000000fff5eb2c ip:f7f369b5 sp:fff5f08c orax:ffffffffffffffff in libuClibc-0.9.33.2.so[f7f2c000+4f000]
> [    7.288482] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
> [    7.288482] 
> [    7.289898] CPU: 0 PID: 1 Comm: init Not tainted 4.14.0-rc1-00021-g14e6330 #38
> [    7.290988] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.3-20161025_171302-gandalf 04/01/2014
> [    7.292562] Call Trace:
> [    7.292960]  dump_stack+0x61/0x7e
> [    7.293485]  panic+0xd3/0x20f
> [    7.293967]  do_exit+0x4f2/0x983
> [    7.294440]  do_group_exit+0x45/0xb0
> [    7.294966]  get_signal+0x4b8/0x4e4
> [    7.295483]  do_signal+0x23/0x5bc
> [    7.295964]  ? force_sig_info+0xc6/0xd5
> [    7.296521]  ? force_sig+0x11/0x13
> [    7.297027]  ? signal_fault+0xb8/0xc1
> [    7.297557]  exit_to_usermode_loop+0x3a/0x72
> [    7.298178]  do_int80_syscall_32+0xe9/0xfe
> [    7.298784]  entry_INT80_compat+0x2a/0x40
> [    7.299374] RIP: 0023:0xf7f369b5
> [    7.299848] RSP: 002b:00000000fff5f08c EFLAGS: 00000246
> [    7.300587] RAX: 0000000000000000 RBX: 0000000000000004 RCX: 00000000f7fb670c
> [    7.301609] RDX: 000000000000000a RSI: 0000000000000f9f RDI: 0000000000000fa0
> [    7.302624] RBP: 00000000fff5f0f8 R08: 0000000000000000 R09: 0000000000000000
> [    7.303631] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> [    7.304666] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> [    7.305677] Kernel Offset: 0x7000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> 
> Elapsed time: 10

Thanks for testing!  This should already be fixed by the version of the patch in
tip/master (commit 814fb7bb7db543); there was a missing check for 'state_size'.

Eric
