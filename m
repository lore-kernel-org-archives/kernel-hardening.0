Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160923201257.GA4763@pc.thejh.net>
References: <20160923201257.GA4763@pc.thejh.net>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 23 Sep 2016 13:52:50 -0700
Message-ID: <CAGXu5jL3VG3uDHyVX4m6cksfVJ11RrDvrvQDHqGfTojWqmXWmQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: CONFIG_HARDENED_USERCOPY incompatible with /proc/kcore
To: Jann Horn <jann@thejh.net>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Valdis Kletnieks <valdis.kletnieks@vt.edu>, Michael Ellerman <mpe@ellerman.id.au>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey.schaufler@intel.com>, Rik van Riel <riel@redhat.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

This was fixed recently in Linus's tree df04abfd181acc276ba6762c8206891ae10ae00d

On Fri, Sep 23, 2016 at 1:12 PM, Jann Horn <jann@thejh.net> wrote:
> On a relatively recent kernel, I ran "perf top", then tried to view
> performance-annotated disassembly of a kernel function, and this happened:
>
> [  990.083103] usercopy: kernel memory exposure attempt detected from ffffffffaf1e4a70 (<kernel text>) (1424 bytes)
> [  990.083112] ------------[ cut here ]------------
> [  990.083171] kernel BUG at mm/usercopy.c:75!
> [  990.083200] invalid opcode: 0000 [#1] PREEMPT SMP
> [  990.083240] Modules linked in:
> [  990.083265] CPU: 3 PID: 4148 Comm: perf Not tainted 4.8.0-rc6jann-00222-gf4a7ce3 #144
> [  990.083365] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./H81M-HDS, BIOS P1.60 12/06/2013
> [  990.083397] task: ffff8e52e0fc48c0 task.stack: ffff8e528191c000
> [  990.083417] RIP: 0010:[<ffffffffaf556bfc>]  [<ffffffffaf556bfc>] __check_object_size+0x7c/0x2ba
> [  990.083452] RSP: 0018:ffff8e528191fd30  EFLAGS: 00010286
> [  990.083471] RAX: 0000000000000064 RBX: ffffffffaf1e4a70 RCX: 0000000000000004
> [  990.083506] RDX: 0000000000000000 RSI: ffff8e532f2cce88 RDI: ffff8e532f2cce88
> [  990.083594] RBP: ffff8e528191fd70 R08: 0000000000000001 R09: 0000000000000000
> [  990.083618] R10: 0000000000000001 R11: 0000000000000001 R12: ffffffffaf1e5000
> [  990.083642] R13: 0000000000000001 R14: 0000000000000590 R15: ffffea000ab5f900
> [  990.083666] FS:  00007fdda7e47700(0000) GS:ffff8e532f2c0000(0000) knlGS:0000000000000000
> [  990.083705] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  990.083726] CR2: 00007fdda0006958 CR3: 00000003e2cf5000 CR4: 00000000001407e0
> [  990.083751] Stack:
> [  990.083762]  ffffffffaf1e4a70 ffffea000ab5f920 000000002bf10e26 0000000000000880
> [  990.083799]  ffff8e528191ff18 00007fdda0005950 ffffffffaf1e4a70 0000000000000590
> [  990.083833]  ffff8e528191fdd8 ffffffffaf697977 000000002bf10e26 000000002bf10e26
> [  990.083863] Call Trace:
> [  990.083877]  [<ffffffffaf1e4a70>] ? ptrace_get_task_struct+0x150/0x150
> [  990.083902]  [<ffffffffaf1e4a70>] ? ptrace_get_task_struct+0x150/0x150
> [  990.083928]  [<ffffffffaf697977>] read_kcore+0x397/0x660
> [  990.083966]  [<ffffffffaf6786b3>] proc_reg_read+0x83/0x190
> [  990.084025]  [<ffffffffaf55fc49>] __vfs_read+0x69/0x4e0
> [  990.084046]  [<ffffffffafade90a>] ? security_file_permission+0xca/0x150
> [  990.084069]  [<ffffffffaf560d3a>] ? rw_verify_area+0x6a/0x230
> [  990.084090]  [<ffffffffaf560fc2>] vfs_read+0xc2/0x290
> [  990.084109]  [<ffffffffaf563de3>] SyS_read+0x53/0xc0
> [  990.084129]  [<ffffffffb0fca9a9>] entry_SYSCALL_64_fastpath+0x1c/0xac
> [  990.084150] Code: 74 85 3a b1 48 c7 c6 9d 78 36 b1 48 0f 45 d1 48 c7 c1 e1 e2 35 b1 48 c7 c7 60 40 36 b1 48 0f 44 f1 48 89 d9 31 c0 e8 fb 5c ec ff <0f> 0b 48 c7 c7 f0 a3 bd b1 e8 f6 ef 7a 00 48 8b 45 d0 65 48 33
> [  990.084294] RIP  [<ffffffffaf556bfc>] __check_object_size+0x7c/0x2ba
> [  990.084317]  RSP <ffff8e528191fd30>
> [  990.092817] ---[ end trace 1d4ac38ee0788468 ]---
>
> Basically, CONFIG_HARDENED_USERCOPY is incompatible with any feature that
> intentionally exposes kernel memory to root - CONFIG_PROC_KCORE, CONFIG_DEVMEM,
> and probably (didn't test it) also CONFIG_DEVKMEM.
>
> I'm not entirely sure about what the best way to fix this would be - maybe
> just prevent the simultaneous use of those config options?



-- 
Kees Cook
Nexus Security
