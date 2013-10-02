Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Wed, 2 Oct 2013 07:25:32 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20131002052531.GA31122@gmail.com>
References: <1380656245-29975-1-git-send-email-keescook@chromium.org>
 <20131002050714.GA27982@gmail.com>
 <fcdac020-6b9a-4d36-b424-290597669cb0@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fcdac020-6b9a-4d36-b424-290597669cb0@email.android.com>
Subject: [kernel-hardening] Re: [PATCH v6 0/7] Kernel base address randomization
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, x86@kernel.org, kernel-hardening@lists.openwall.com, adurbin@google.com, Eric Northup <digitaleric@google.com>, jln@google.com, wad@google.com, Mathias Krause <minipli@googlemail.com>, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Arnaldo Carvalho de Melo <acme@infradead.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>


* H. Peter Anvin <hpa@zytor.com> wrote:

> I think that the randomization offset would be necessary in order to 
> identify pointers.

I mean, for example in an oops message we print data in words: the RIP, 
other registers and stack contents. If any of these values lies within the 
randomization range then we could de-randomize it.

So instead of exposing randomized values, we could expose de-randomized 
values.

( This isn't fool-proof: if some data value happens to lie within the 
  random range spuriously then we'll incorrectly transform it. In the 
  context of oops messages this should not be a big practical problem 
  though. )

For example, assume that the following oops is from a distro kernel and 
contains raw randomized addresses:

[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at init/main.c:544 start_kernel+0x1fa/0x3e8()
[    0.000000] PANIC: double fault, error_code: 0xffffffff810e74ed
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.12.0-rc1-01728-gd787a30-dirty #54
[    0.000000] Hardware name: Supermicro X8DTN/X8DTN, BIOS 4.6.3 09/04/2008
[    0.000000] task: ffffffff81e104a0 ti: ffffffff81e00000 task.ti: ffffffff81e00000
[    0.000000] RIP: 0246:[<0000000000000010>]  [<0000000000000010>] 0xf
[    0.000000] RSP: 0000:0000000000000000  EFLAGS: ffffffff81e01de8
[    0.000000] RAX: 0000000005330533 RBX: 0000000000000001 RCX: 000000000000023f
[    0.000000] RDX: 0000000000000533 RSI: 0000000000000046 RDI: ffffffff82099944
[    0.000000] RBP: ffffffff81e01e68 R08: 000000004e524157 R09: 00000000000000ca
[    0.000000] R10: 3a4449502030203a R11: 555043203a474e49 R12: 00000000ffffffff
[    0.000000] R13: 0000000000000000 R14: 0000000000000044 R15: 0000000000000006
[    0.000000] FS:  0000000000000000(0000) GS:ffff8801b9c00000(0000) knlGS:0000000000000000
[    0.000000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.000000] CR2: ffff88033ffff000 CR3: 0000000001e0b000 CR4: 00000000000006b0
[    0.000000] 
[    0.000000] Kernel panic - not syncing: Machine halted.
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.12.0-rc1-01728-gd787a30-dirty #54
[    0.000000] Hardware name: Supermicro X8DTN/X8DTN, BIOS 4.6.3 09/04/2008
[    0.000000]  ffff8801b9c06f60 ffff8801b9c06e80 ffffffff81822bd3 0000000000000586
[    0.000000]  ffffffff81c8e10b ffff8801b9c06f00 ffffffff8181efdb ffffffff81e00000
[    0.000000]  0000000000000008 ffff8801b9c06f10 ffff8801b9c06eb0 6230653130303030
[    0.000000] Call Trace:
[    0.000000]  <#DF>  [<ffffffff81822bd3>] dump_stack+0x46/0x58
[    0.000000]  [<ffffffff8181efdb>] panic+0xb6/0x1bf
[    0.000000]  [<ffffffff81078980>] df_debug+0x30/0x30
[    0.000000]  [<ffffffff810e74ed>] ? vprintk_emit+0x1ed/0x4e0
[    0.000000]  [<ffffffff810e74ed>] ? vprintk_emit+0x1ed/0x4e0
[    0.000000]  [<ffffffff81046471>] do_double_fault+0x61/0x90
[    0.000000]  [<ffffffff818324d2>] double_fault+0x22/0x30
[    0.000000]  <<EOE>>  [<ffffffff813ba281>] ? vsnprintf+0x471/0x650
[    0.000000]  [<ffffffff81f28c9f>] ? start_kernel+0x1fa/0x3e8
[    0.000000]  [<ffffffff8181f505>] printk+0x5c/0x5e
[    0.000000]  [<ffffffff81f28c9f>] ? start_kernel+0x1fa/0x3e8
[    0.000000]  [<ffffffff810962ec>] warn_slowpath_common+0x6c/0xb0
[    0.000000]  [<ffffffff810963d1>] warn_slowpath_fmt+0x41/0x50
[    0.000000]  [<ffffffff81f28c9f>] start_kernel+0x1fa/0x3e8
[    0.000000]  [<ffffffff81f288a4>] ? repair_env_string+0x5e/0x5e
[    0.000000]  [<ffffffff81f285a5>] x86_64_start_reservations+0x2a/0x2c
[    0.000000]  [<ffffffff81f286a4>] x86_64_start_kernel+0xfd/0x101

Anyone who reads this oops can recover the random offset by knowing the 
non-randomized value:

   $ grep -w printk /boot/System.map-3.9.10-100.fc17.x86_64
   ffffffff81651a64 T printk

and substracting that from the value seen in the oops:

[    0.000000]  [<ffffffff8181f505>] printk+0x5c/0x5e

So my suggestion would be to check each printed out value in an oops 
message and de-randomize it if it's within the randomized range. So the 
above entry would be printed as the 'static' address:

[    0.000000]  [<ffffffff81651a64>] printk+0x5c/0x5e

Note how this entry does not expose the random offset anymore. It's also 
easy to stick the raw value into 'gdb vmlinux' and use it for debugging.

Something similar can be done for profiling streams where we _know_ that 
it's a kernel text address (the perf profiling trace entries for example), 
and the same could be done for /proc/kallsyms.

The random range is a fairly narrow region of 64-bit address space so 
spurious hits should be relatively rare.

Now, a 'raw' address might still lie in places like mixed up in registers 
or lying non-word-aligned on the kernel stack - but at least the 'typical' 
oops would be fairly safe to post and there would be no 'obvious' places 
to recover the secret from, even if you happen to have access to some logs 
and some profiling.

At least that's the argument that can be made. I'm not entirely sure it's 
valid and I'm leaning towards the simplicity of only outputting raw oops 
values.

Thanks,

	Ingo
