Reply-To: kernel-hardening@lists.openwall.com
From: Nicolai Stange <nicstange@gmail.com>
References: <cover.1468270393.git.luto@kernel.org>
	<cover.1468270393.git.luto@kernel.org>
	<fb3254e25e38790c538cca0f46c4a7a714c77ddf.1468270393.git.luto@kernel.org>
	<5741.1469162592@turing-police.cc.vt.edu>
	<4b028b92-81f3-362f-c5be-b7a35cedf5ee@kernel.org>
	<8376.1469251283@turing-police.cc.vt.edu>
Date: Sat, 23 Jul 2016 16:58:16 +0200
In-Reply-To: <8376.1469251283@turing-police.cc.vt.edu> (Valdis Kletnieks's
	message of "Sat, 23 Jul 2016 01:21:23 -0400")
Message-ID: <87mvl8tn93.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [kernel-hardening] [PATCH v5 03/32] x86/cpa: In populate_pgd, don't set the pgd entry until it's populated
To: Valdis.Kletnieks@vt.edu
Cc: Andy Lutomirski <luto@kernel.org>, kernel-hardening@lists.openwall.com, x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Valdis.Kletnieks@vt.edu writes:

> On Thu, 21 Jul 2016 22:34:33 -0700, Andy Lutomirski said:
>
>> How much memory do you have and what's your config?  My code is
>> obviously buggy, but I'm wondering why neither I nor the 0day bot caught
>> this.
>
> Probably because your devel box and the 0day bot both have 4-level page
> tables and the dual-core i5 in my laptop has (presumably) 3?
>
> In any case, your patch didn't fix things, nor did (as you noted in a mail
> to Ingo) does reverting the problem commit (and then the following one that
> deletes now-dead code so it will compile cleanly).


Applying the patch directly on top of 360cb4d15567 ("x86/mm/cpa: In
populate_pgd(), don't set the PGD entry until it's populated") *does*
fix things for me.

Hardware: i7-4800MQ, 8GiB RAM, Dell Latitude E6540

FYI, the kernel panic grabbed via console=uart,io,0x3f8,... is

BUG: unable to handle kernel paging request at ffffb92ac0000fc0
IP: [<ffffffff8106b8d1>] native_set_pmd+0x1/0x10
PGD 0 
Oops: 0002 [#1] SMP
Modules linked in:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.7.0-rc6+ #190
Hardware name: Dell Inc. Latitude E6540/0725FP, BIOS A10 06/26/2014
task: ffffffff81e0d580 ti: ffffffff81e00000 task.ti: ffffffff81e00000
RIP: 0010:[<ffffffff8106b8d1>]  [<ffffffff8106b8d1>] native_set_pmd+0x1/0x10
RSP: 0000:ffffffff81e03c38  EFLAGS: 00010206
RAX: 00000000ff0000f3 RBX: 00000000ff000000 RCX: ffff880000000000
RDX: ffffb92ac0000fc0 RSI: 00000000ff0000f3 RDI: ffffb92ac0000fc0
RBP: ffffffff81e03c90 R08: ffff880000000fc0 R09: 0000000000000073
R10: ffff88022ede5000 R11: 0000000000000001 R12: ffffffff81e03e48
R13: 0000000001000000 R14: 0000000000000073 R15: ffff880000000018
FS:  0000000000000000(0000) GS:ffff88022ea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffb92ac0000fc0 CR3: 0000000001e06000 CR4: 00000000000406b0
Stack:
 ffffffff81e03c90 ffffffff8107217f 0000000000000073 0000000100000000
 0000000000000001 0000000000001000 ffff880000000018 0000000000001000
 ffffffff81e03e48 0000000100000000 ffffffffff2018a8 ffffffff81e03d08
Call Trace:
 [<ffffffff8107217f>] ? populate_pmd+0x11f/0x2c0
 [<ffffffff81072823>] __cpa_process_fault+0x503/0x5d0
 [<ffffffff81073223>] __change_page_attr_set_clr+0x563/0xe00
 [<ffffffff81074e6f>] kernel_map_pages_in_pgd+0x8f/0xd0
 [<ffffffff81fa5e2e>] __map_region+0x3c/0x58
 [<ffffffff81fa6064>] efi_map_region+0x31/0xca
 [<ffffffff81fa5af3>] efi_enter_virtual_mode+0x215/0x4bd
 [<ffffffff814c6289>] ? acpi_os_signal_semaphore+0x2c/0x38
 [<ffffffff814f5c4a>] ? acpi_ut_initialize_interfaces+0x62/0x67
 [<ffffffff81f84f78>] start_kernel+0x3cf/0x478
 [<ffffffff81f84120>] ? early_idt_handler_array+0x120/0x120
 [<ffffffff81f842db>] x86_64_start_reservations+0x2f/0x31
 [<ffffffff81f84429>] x86_64_start_kernel+0x14c/0x16f
Code: 89 e5 48 89 47 04 5d c3 66 90 55 48 89 e5 0f 01 f8 5d c3 0f 1f 80 00 00 00 00 55 48 89 37 48 89 e5 5d c3 0f 1f 80 00 00 00 00 55 <48> 89 37 48 89 e5 5d c3 0f 1f 80 00 00 00 00 55 48 89 37 48 89 
RIP  [<ffffffff8106b8d1>] native_set_pmd+0x1/0x10
 RSP <ffffffff81e03c38>
CR2: ffffb92ac0000fc0
---[ end trace 2f8154f277751049 ]---
Kernel panic - not syncing: Attempted to kill the idle task!
---[ end Kernel panic - not syncing: Attempted to kill the idle task!


The reason the patch didn't work for Valdis might be that there is
another issue in next-20150722 with the same symptoms (provided you
don't watch the serial console). Valdis, did you apply the provided
patch on top of next?

The "other issue" is:

RDX: 0000000000000010 RSI: 00000000000306c3 RDI: ffff88003bdea2fc
RBP: ffffffffb6e03a70 R08: ffff88003bdea000 R09: 0000000000000000
R10: ffffffffb713d3a0 R11: 0000000000000008 R12: 0000000000000020
R13: ffff88003bdea2fc R14: ffffffffb6e03a80 R15: ffffffffb6e03ea0
FS:  0000000000000000(0000) GS:ffff9208aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88003bdea300 CR3: 00000001dce06000 CR4: 00000000000406b0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Stack:
 ffffffffb6054cea 0000000000000000 0000000100000000 0000000000000001
 0000000000000000 0000000000000000 ffffffffb705c2e0 000000003fffc000
 ffffffffb6e03e90 ffffffffb6055487 ffff88003bdea2fc ffffffffb6e0d580
Call Trace:
 [<ffffffffb6054cea>] ? find_microcode_patch+0x4a/0xa0
 [<ffffffffb6055487>] load_microcode.isra.1.constprop.12+0x37/0xa0
 [<ffffffffb6036700>] ? dump_trace+0x120/0x320
 [<ffffffffb644fee8>] ? put_dec+0x18/0xa0
 [<ffffffffb645025d>] ? number+0x2ed/0x300
 [<ffffffffb6ff3ba1>] ? serial_putc+0x1e/0x2d
 [<ffffffffb6ff3b83>] ? serial8250_early_out+0x62/0x62
 [<ffffffffb654f127>] ? uart_console_write+0x57/0x70
 [<ffffffffb61094ad>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffffb6152775>] ? __module_address+0x5/0xf0
 [<ffffffffb6152872>] ? __module_text_address+0x12/0x60
 [<ffffffffb61967e4>] ? is_ftrace_trampoline+0x44/0x70
 [<ffffffffb60d68a6>] ? __kernel_text_address+0x56/0x70
 [<ffffffffb60371bb>] ? print_context_stack+0x7b/0x100
 [<ffffffffb6109695>] ? __bfs+0x25/0x280
 [<ffffffffb61967e4>] ? is_ftrace_trampoline+0x44/0x70
 [<ffffffffb6152775>] ? __module_address+0x5/0xf0
 [<ffffffffb6152872>] ? __module_text_address+0x12/0x60
 [<ffffffffb61967e4>] ? is_ftrace_trampoline+0x44/0x70
 [<ffffffffb60d68a6>] ? __kernel_text_address+0x56/0x70
 [<ffffffffb60371bb>] ? print_context_stack+0x7b/0x100
 [<ffffffffb6036700>] ? dump_trace+0x120/0x320
 [<ffffffffb644fee8>] ? put_dec+0x18/0xa0
 [<ffffffffb645025d>] ? number+0x2ed/0x300
 [<ffffffffb6ff3ba1>] ? serial_putc+0x1e/0x2d
 [<ffffffffb6ff3b83>] ? serial8250_early_out+0x62/0x62
 [<ffffffffb654f127>] ? uart_console_write+0x57/0x70
 [<ffffffffb61094ad>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffffb61094ad>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffffb689de84>] ? _raw_spin_unlock_irqrestore+0x54/0x60
 [<ffffffffb611f16d>] ? console_unlock+0x33d/0x670
 [<ffffffffb611f7a1>] ? vprintk_emit+0x301/0x5e0
 [<ffffffffb605553f>] ? collect_cpu_info_early+0x4f/0x140
 [<ffffffffb61ea845>] ? __pr_info+0x5a/0x76
 [<ffffffffb60557cd>] load_ucode_intel_ap+0x5d/0x80
 [<ffffffffb6054924>] load_ucode_ap+0x94/0xa0
 [<ffffffffb60481a8>] cpu_init+0x58/0x3e0
 [<ffffffffb60709bc>] ? set_pte_vaddr+0x5c/0x90
 [<ffffffffb6fac06c>] trap_init+0x2b6/0x328
 [<ffffffffb6fa0dba>] start_kernel+0x224/0x47f
 [<ffffffffb6fa0120>] ? early_idt_handler_array+0x120/0x120
 [<ffffffffb6fa02cf>] x86_64_start_reservations+0x29/0x2b
 [<ffffffffb6fa041e>] x86_64_start_kernel+0x14d/0x170
Code: c1 74 04 85 c2 74 e4 b8 01 00 00 00 5d c3 41 89 ca b8 01 00 00 00 41 09 d2 74 f1 85 d1 74 98 5d c3 31 c0 5d c3 90 e8 eb b1 84 00 <39> 4f 04 77 03 31 c0 c3 55 48 89 e5 e8 6a ff ff ff 5d c3 0f 1f 
RIP  [<ffffffffb6055af5>] has_newer_microcode+0x5/0x20
 RSP <ffffffffb6e03a30>
CR2: ffff88003bdea300
---[ end trace b163fd3960fd46fb ]---
Kernel panic - not syncing: Attempted to kill the idle task!
---[ end Kernel panic - not syncing: Attempted to kill the idle task!

I bisected this one to 21ef9a5c3164 ("Merge branch 'x86/microcode'"). Both
of its parents do not exhibit that behaviour.  This merge's author is
Ingo Molnar, so I added him to the CC list.


Thanks,

Nicolai
