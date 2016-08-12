Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 12 Aug 2016 19:22:58 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
Message-ID: <20160812182258.GM12939@e104818-lin.cambridge.arm.com>
References: <1471015666-23125-1-git-send-email-catalin.marinas@arm.com>
 <CAGXu5jJYoEVA2g5SNxh1hQ-G6gm0UBEUdAVEsuNidpYgdmuW3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJYoEVA2g5SNxh1hQ-G6gm0UBEUdAVEsuNidpYgdmuW3A@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH 0/7] arm64: Privileged Access Never using TTBR0_EL1
 switching
To: Kees Cook <keescook@chromium.org>
Cc: James Morse <james.morse@arm.com>, Julien Grall <julien.grall@arm.com>, Will Deacon <will.deacon@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Aug 12, 2016 at 11:04:39AM -0700, Kees Cook wrote:
> On Fri, Aug 12, 2016 at 8:27 AM, Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > This is the first (public) attempt at emulating PAN by disabling
> > TTBR0_EL1 accesses on arm64. I chose to use a per-CPU saved_ttbr0_el1
> > variable to store the actual TTBR0 as, IMO, it looks better w.r.t. the
> > context switching code, to the detriment of a slightly more complex
> > uaccess_enable() implementation. The alternative was storing the saved
> > TTBR0 in thread_info but with more complex thread switching since TTBR0
> > is normally tied to switch_mm() rather than switch_to(). The latter may
> > also get more complicated if we are to decouple the kernel stack from
> > thread_info at some point (vmalloc'ed stacks).
> >
> > The code requires more testing, especially for combinations where UAO is
> > present but PAN is not.
> >
> > The patches are also available on this branch:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux ttbr0-pan
> >
> > Thanks for reviewing/testing.
> 
> So awesome! Thank you for working on this. I still lack real arm64
> hardware to test this on, but the lkdtm test ACCESS_USERSPACE should
> trip this protection (e.g. this "cat" should get killed and the Oops
> appear in dmesg):
> 
> # cat <(echo ACCESS_USERSPACE) > /sys/kernel/debug/provoke-crash/DIRECT

It seems to work ;)

~# echo ACCESS_USERSPACE > /sys/kernel/debug/provoke-crash/DIRECT
[   51.918454] lkdtm: Performing direct entry ACCESS_USERSPACE
[   51.924018] lkdtm: attempting bad read at 0000ffff8e165000
[   51.929476] Internal error: Accessing user space memory outside uaccess.h routines: 96000004 [#1] PREEMPT SMP
[   51.963729] Hardware name: ARM Juno development board (r0) (DT)
[   51.969586] task: ffff8009763bf080 task.stack: ffff800973870000
[   51.975451] PC is at lkdtm_ACCESS_USERSPACE+0xb0/0x100
[   51.980536] LR is at lkdtm_ACCESS_USERSPACE+0xb0/0x100
[   51.985619] pc : [<ffff000008518638>] lr : [<ffff000008518638>] pstate: 60400145
[   51.992936] sp : ffff800973873cf0
[   51.996212] x29: ffff800973873cf0 x28: ffff800973870000
[   52.001474] x27: ffff000008872000 x26: 0000000000000040
[   52.006737] x25: 0000000000000120 x24: ffff000008d31290
[   52.011998] x23: ffff800973873eb8 x22: 0000000000000011
[   52.017259] x21: ffff800973cea000 x20: ffff000008d31400
[   52.022520] x19: 0000ffff8e165000 x18: 0000000000000006
[   52.027781] x17: 0000ffff8dfe6770 x16: ffff0000081da450
[   52.033043] x15: ffff000008d9bd15 x14: 0000000000000107
[   52.038304] x13: 0000000000000000 x12: 0000000005f5e0ff
[   52.043565] x11: 0000000000000002 x10: 0000000000000108
[   52.048826] x9 : ffff800973873a80 x8 : 6666303030302074
[   52.054087] x7 : 6120646165722064 x6 : 000000000000000a
[   52.059349] x5 : 0000000000000000 x4 : 0000000000000000
[   52.064610] x3 : 0000000000000000 x2 : ffff80097fed7728
[   52.069871] x1 : ffff800973870000 x0 : 000000000000002e
[   52.075131]
[   52.076602] Process bash (pid: 2739, stack limit = 0xffff800973870020)
[   52.083062] Stack: (0xffff800973873cf0 to 0xffff800973874000)
[   52.088748] 3ce0:                                   ffff800973873d20 ffff000008739954
[   52.096500] 3d00: 0000000000000170 00000000000000ba ffff7e0025d09f60 0000000000000000
[   52.104251] 3d20: ffff800973873d30 ffff000008517b00 ffff800973873d70 ffff000008329200
[   52.112002] 3d40: 0000000000000000 ffff8009759dc400 0000000034996408 0000000000000011
[   52.119753] 3d60: ffff800973873eb8 ffff000008d314e8 ffff800973873dc0 ffff0000081d830c
[   52.127504] 3d80: 0000000000000011 ffff8009759dc400 0000000000000000 ffff800973873eb8
[   52.135255] 3da0: 0000000034996408 0000000000000015 0000000000000400 0000000073966780
[   52.143005] 3dc0: ffff800973873e40 ffff0000081d9120 0000000000000011 ffff8009759dc400
[   52.150756] 3de0: ffff800974018900 000000000000000a ffff800973873e10 ffff0000080fd800
[   52.158507] 3e00: ffff80097680e280 0000000000000001 ffff800973873e30 ffff0000081dcde8
[   52.166257] 3e20: 0000000000000011 ffff8009759dc400 ffff800973873e40 ffff0000081d91e0
[   52.174008] 3e40: ffff800973873e80 ffff0000081da494 ffff8009759dc400 ffff8009759dc400
[   52.181759] 3e60: 0000000034996408 0000000000000011 0000000020000000 ffff000008083930
[   52.189509] 3e80: 0000000000000000 ffff000008083930 0000000000000000 0000000034996408
[   52.197260] 3ea0: ffffffffffffffff 0000ffff8e0398b8 0000000000000000 0000000000000000
[   52.205010] 3ec0: 0000000000000001 0000000034996408 0000000000000011 0000000000000000
[   52.212761] 3ee0: 00000000fbad2a85 0001555100045400 0000000034996418 555f535345434341
[   52.220512] 3f00: 0000000000000040 0000ffff8e0c4000 0000fffff925de90 7f7f7f7f7f7f7f7f
[   52.228263] 3f20: 0101010101010101 0000000000000005 ffffffffffffffff 0000000000000078
[   52.236013] 3f40: 0000000000000000 0000ffff8dfe6770 0000000000000003 0000000000000011
[   52.243764] 3f60: 0000000034996408 0000ffff8e0c0488 0000000000000011 00000000004d3af0
[   52.251515] 3f80: 00000000004f6000 00000000004f3000 0000000000000001 0000000034a99ec8
[   52.259265] 3fa0: 0000000034aeefe8 0000fffff925de40 0000ffff8dfe9558 0000fffff925de40
[   52.267016] 3fc0: 0000ffff8e0398b8 0000000020000000 0000000000000001 0000000000000040
[   52.274766] 3fe0: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
[   52.282513] Call trace:
[   52.284931] Exception stack(0xffff800973873b20 to 0xffff800973873c50)
[   52.291306] 3b20: 0000ffff8e165000 0001000000000000 ffff800973873cf0 ffff000008518638
[   52.299057] 3b40: ffff000008ceaf20 0000000000000006 0000000000000000 0000000000000000
[   52.306808] 3b60: 000000000000002e ffff000008d9b7d8 0000000000000002 ffff000008d9e128
[   52.314559] 3b80: ffff800973873ba0 ffff000008abd6c8 000000000000002e 0000000100000001
[   52.322310] 3ba0: ffff800973873c40 ffff0000081669d4 0000ffff8e165000 ffff000008d31400
[   52.330060] 3bc0: 000000000000002e ffff800973870000 ffff80097fed7728 0000000000000000
[   52.337812] 3be0: 0000000000000000 0000000000000000 000000000000000a 6120646165722064
[   52.345562] 3c00: 6666303030302074 ffff800973873a80 0000000000000108 0000000000000002
[   52.353313] 3c20: 0000000005f5e0ff 0000000000000000 0000000000000107 ffff000008d9bd15
[   52.361061] 3c40: ffff0000081da450 0000ffff8dfe6770
[   52.365891] [<ffff000008518638>] lkdtm_ACCESS_USERSPACE+0xb0/0x100
[   52.372009] [<ffff000008739954>] lkdtm_do_action+0x1c/0x24
[   52.377438] [<ffff000008517b00>] direct_entry+0xe0/0x160
[   52.382696] [<ffff000008329200>] full_proxy_write+0x58/0x88
[   52.388214] [<ffff0000081d830c>] __vfs_write+0x1c/0x110
[   52.393384] [<ffff0000081d9120>] vfs_write+0xa0/0x1b8
[   52.398383] [<ffff0000081da494>] SyS_write+0x44/0xa0
[   52.403296] [<ffff000008083930>] el0_svc_naked+0x24/0x28
[   52.408555] Code: b0002f60 aa1303e1 9135c000 97f138ce (f9400263)

-- 
Catalin
