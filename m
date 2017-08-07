References: <20170807203948.GA22298@beast> <20170807220056.GA29059@remoulade>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <0e9a80c2-3e5e-db98-dff6-b45e9e4817fd@redhat.com>
Date: Mon, 7 Aug 2017 15:55:22 -0700
MIME-Version: 1.0
In-Reply-To: <20170807220056.GA29059@remoulade>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] Re: [PATCH] lkdtm: Test VMAP_STACK allocates leading/trailing guard
 pages
To: Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, ard.biesheuvel@linaro.org, catalin.marinas@arm.com, james.morse@arm.com, luto@amacapital.net, matt@codeblueprint.co.uk, will.deacon@arm.com, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>

On 08/07/2017 03:00 PM, Mark Rutland wrote:
> Hi,
> 
> On Mon, Aug 07, 2017 at 01:39:48PM -0700, Kees Cook wrote:
>> Two new tests STACK_GUARD_PAGE_LEADING and STACK_GUARD_PAGE_TRAILING
>> attempt to read the byte before and after, respectively, of the current
>> stack frame, which should fault under VMAP_STACK.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>> Do these tests both trip with the new arm64 VMAP_STACK code?
> 
>> +/* Test that VMAP_STACK is actually allocating with a leading guard page */
>> +void lkdtm_STACK_GUARD_PAGE_LEADING(void)
>> +{
>> +	const unsigned char *stack = task_stack_page(current);
>> +	const unsigned char *ptr = stack - 1;
>> +	volatile unsigned char byte;
>> +
>> +	pr_info("attempting bad read from page below current stack\n");
>> +
>> +	byte = *ptr;
>> +
>> +	pr_err("FAIL: accessed page before stack!\n");
>> +}
>> +
>> +/* Test that VMAP_STACK is actually allocating with a trailing guard page */
>> +void lkdtm_STACK_GUARD_PAGE_TRAILING(void)
>> +{
>> +	const unsigned char *stack = task_stack_page(current);
>> +	const unsigned char *ptr = stack + THREAD_SIZE;
>> +	volatile unsigned char byte;
>> +
>> +	pr_info("attempting bad read from page above current stack\n");
>> +
>> +	byte = *ptr;
>> +
>> +	pr_err("FAIL: accessed page after stack!\n");
>> +}
> 
> I can give these a go tomorrow.
> 
> These *should* fault, and IIUC should trigger the usual "Unable to handle
> kernel %s at virtual address %08lx\n" splat from arm64's __do_kernel_fault(),
> which should end up with an Oops().
> 
> Since these don't mess with the SP, they shouldn't trigger the overflow
> detection, which detects whether we have sufficient stack space to store the
> exception context to the stack. That caught the LKDTM overflow test reliably.
> 
> Thanks,
> Mark.
> 

I gave these a quick test in QEMU and they seem to do the correct thing:

# echo STACK_GUARD_PAGE_LEADING > /sys/kernel/debug/provoke-crash/DIRECT 
[   24.593306] lkdtm: Performing direct entry STACK_GUARD_PAGE_LEADING
[   24.593780] lkdtm: attempting bad read from page below current stack
[   24.594289] Unable to handle kernel paging request at virtual address ffff000009b77fff
[   24.594747] swapper pgtable: 4k pages, 48-bit VAs, pgd = ffff000009050000
[   24.595443] [ffff000009b77fff] *pgd=000000007effe003, *pud=000000007effd003, *pmd=000000007cc43003, *pte=0000000000000000
[   24.596743] Internal error: Oops: 96000007 [#1] PREEMPT SMP
[   24.597425] Modules linked in:
[   24.597973] CPU: 5 PID: 1264 Comm: sh Not tainted 4.13.0-rc3-00260-g720ffe048bd5 #34
[   24.598555] Hardware name: linux,dummy-virt (DT)
[   24.598939] task: ffff800008b2d400 task.stack: ffff000009b78000
[   24.599738] PC is at lkdtm_STACK_GUARD_PAGE_LEADING+0x28/0x40
[   24.600100] LR is at lkdtm_STACK_GUARD_PAGE_LEADING+0x20/0x40
[   24.600460] pc : [<ffff0000085b9ac0>] lr : [<ffff0000085b9ab8>] pstate: 40000145
[   24.600855] sp : ffff000009b7bcf0
[   24.601058] x29: ffff000009b7bcf0 x28: ffff800008b2d400 
[   24.601319] x27: ffff0000089b1000 x26: ffff000008fa00f8 
[   24.601560] x25: ffff000009b7beb8 x24: ffff000009b7beb8 
[   24.601809] x23: ffff000008f9fe10 x22: 0000000000000019 
[   24.602052] x21: ffff80003cc08000 x20: ffff000008f9feb0 
[   24.602292] x19: ffff000009b78000 x18: 0000000000000000 
[   24.602532] x17: 0000ffffa6d71470 x16: ffff000008203cb0 
[   24.602773] x15: 0000000000000010 x14: ffff000088ff637f 
[   24.602998] x13: ffff000008ff638d x12: ffff000008ed9df0 
[   24.603390] x11: ffff00000855d518 x10: ffff000009b7ba00 
[   24.603946] x9 : 0000000000000016 x8 : 7320746e65727275 
[   24.604229] x7 : 6320776f6c656220 x6 : 00000000000000e9 
[   24.604511] x5 : 0000000000000000 x4 : 0000000000000001 
[   24.604804] x3 : 0000000000000007 x2 : 0000000000000007 
[   24.605106] x1 : ffff800008b2d400 x0 : ffff000008d05880 
[   24.605413] Process sh (pid: 1264, stack limit = 0xffff000009b78000)
[   24.605799] Call trace:
[   24.606029] Exception stack(0xffff000009b7bbb0 to 0xffff000009b7bcf0)
[   24.606414] bba0:                                   ffff000008d05880 ffff800008b2d400
[   24.606816] bbc0: 0000000000000007 0000000000000007 0000000000000001 0000000000000000
[   24.607324] bbe0: 00000000000000e9 6320776f6c656220 7320746e65727275 0000000000000016
[   24.608025] bc00: ffff000009b7ba00 ffff00000855d518 ffff000008ed9df0 ffff000008ff638d
[   24.608412] bc20: ffff000088ff637f 0000000000000010 ffff000008203cb0 0000ffffa6d71470
[   24.608816] bc40: 0000000000000000 ffff000009b78000 ffff000008f9feb0 ffff80003cc08000
[   24.609196] bc60: 0000000000000019 ffff000008f9fe10 ffff000009b7beb8 ffff000009b7beb8
[   24.609584] bc80: ffff000008fa00f8 ffff0000089b1000 ffff800008b2d400 ffff000009b7bcf0
[   24.609988] bca0: ffff0000085b9ab8 ffff000009b7bcf0 ffff0000085b9ac0 0000000040000145
[   24.610391] bcc0: ffff80003efa7770 0000000000000000 0001000000000000 0000000000000000
[   24.610792] bce0: ffff000009b7bcf0 ffff0000085b9ac0
[   24.611170] [<ffff0000085b9ac0>] lkdtm_STACK_GUARD_PAGE_LEADING+0x28/0x40
[   24.611528] [<ffff0000085b94b8>] lkdtm_do_action+0x1c/0x24
[   24.611843] [<ffff0000085b9300>] direct_entry+0xe8/0x190
[   24.612130] [<ffff0000083542d8>] full_proxy_write+0x60/0xa8
[   24.612430] [<ffff000008201188>] __vfs_write+0x18/0x118
[   24.612732] [<ffff0000082026ec>] vfs_write+0x9c/0x1a8
[   24.613032] [<ffff000008203cf8>] SyS_write+0x48/0xb0
[   24.613288] Exception stack(0xffff000009b7bec0 to 0xffff000009b7c000)
[   24.613629] bec0: 0000000000000001 0000000001059260 0000000000000019 0000000001059279
[   24.614037] bee0: 5f454741505f4452 00474e494441454c 8000000000000080 8080808080808080
[   24.614383] bf00: 0000000000000040 7f7f7f7f7f7f7f7f fefefefefefefeff 7f7f7f7f7f7f7f7f
[   24.614712] bf20: 0101010101010101 0000ffffa6e29cb8 0000ffffa6cb8a58 0000000000000008
[   24.615028] bf40: 0000000000000000 0000ffffa6d71470 0000000000000000 00000000004b4000
[   24.615547] bf60: 0000000000000001 0000000001059260 0000000000000019 0000000000000001
[   24.615926] bf80: 0000000000000020 0000000001056430 00000000004819d8 0000000001056468
[   24.616287] bfa0: 0000000000000000 0000ffffd4f915c0 000000000040a288 0000ffffd4f90bb0
[   24.616643] bfc0: 0000ffffa6d71458 00000000a0000000 0000000000000001 0000000000000040
[   24.616998] bfe0: 0000000000000000 0000000000000000 0000000000000000 0000ffffa6d71458
[   24.617345] [<ffff0000080837b0>] el0_svc_naked+0x24/0x28
[   24.617699] [<0000ffffa6d71458>] 0xffffa6d71458
[   24.618009] Code: 91210000 97ed620f 90003a60 91220000 (385ff261) 
[   24.618509] ---[ end trace d832d99efb2a6f68 ]---


# echo STACK_GUARD_PAGE_TRAILING > /sys/kernel/debug/provoke-crash/DIRECT 
[  103.144313] lkdtm: Performing direct entry STACK_GUARD_PAGE_TRAILING
[  103.144749] lkdtm: attempting bad read from page above current stack
[  103.145100] Unable to handle kernel paging request at virtual address ffff000009c2c000
[  103.145477] swapper pgtable: 4k pages, 48-bit VAs, pgd = ffff000009050000
[  103.145836] [ffff000009c2c000] *pgd=000000007effe003, *pud=000000007effd003, *pmd=000000007d014003, *pte=0000000000000000
[  103.146445] Internal error: Oops: 96000007 [#2] PREEMPT SMP
[  103.146767] Modules linked in:
[  103.146997] CPU: 5 PID: 1268 Comm: sh Tainted: G      D         4.13.0-rc3-00260-g720ffe048bd5 #34
[  103.147705] Hardware name: linux,dummy-virt (DT)
[  103.147962] task: ffff800008b2c600 task.stack: ffff000009c28000
[  103.148317] PC is at lkdtm_STACK_GUARD_PAGE_TRAILING+0x2c/0x48
[  103.148649] LR is at lkdtm_STACK_GUARD_PAGE_TRAILING+0x20/0x48
[  103.148968] pc : [<ffff0000085b9b04>] lr : [<ffff0000085b9af8>] pstate: 40000145
[  103.149378] sp : ffff000009c2bcf0
[  103.149583] x29: ffff000009c2bcf0 x28: ffff800008b2c600 
[  103.149851] x27: ffff0000089b1000 x26: ffff000008fa00f8 
[  103.150137] x25: ffff000009c2beb8 x24: ffff000009c2beb8 
[  103.150414] x23: ffff000008f9fe10 x22: 000000000000001a 
[  103.150742] x21: ffff800008bc4000 x20: ffff000008f9fec0 
[  103.151054] x19: ffff000009c2c000 x18: 0000000000000000 
[  103.151359] x17: 0000ffffa0537470 x16: ffff000008203cb0 
[  103.151677] x15: 0000000000000010 x14: ffff000088ff637f 
[  103.151978] x13: ffff000008ff638d x12: ffff000008ed9df0 
[  103.152288] x11: ffff00000855d518 x10: ffff000009c2ba00 
[  103.152566] x9 : 0000000000000016 x8 : 6572727563206576 
[  103.152861] x7 : 6f62612065676170 x6 : 000000000000012a 
[  103.153162] x5 : 0000000000000000 x4 : 0000000000000001 
[  103.153462] x3 : 0000000000000007 x2 : 0000000000000007 
[  103.153772] x1 : ffff800008b2c600 x0 : ffff000008d058f0 
[  103.154101] Process sh (pid: 1268, stack limit = 0xffff000009c28000)
[  103.154446] Call trace:
[  103.154622] Exception stack(0xffff000009c2bbb0 to 0xffff000009c2bcf0)
[  103.154985] bba0:                                   ffff000008d058f0 ffff800008b2c600
[  103.155416] bbc0: 0000000000000007 0000000000000007 0000000000000001 0000000000000000
[  103.155846] bbe0: 000000000000012a 6f62612065676170 6572727563206576 0000000000000016
[  103.156279] bc00: ffff000009c2ba00 ffff00000855d518 ffff000008ed9df0 ffff000008ff638d
[  103.156639] bc20: ffff000088ff637f 0000000000000010 ffff000008203cb0 0000ffffa0537470
[  103.156947] bc40: 0000000000000000 ffff000009c2c000 ffff000008f9fec0 ffff800008bc4000
[  103.157257] bc60: 000000000000001a ffff000008f9fe10 ffff000009c2beb8 ffff000009c2beb8
[  103.157573] bc80: ffff000008fa00f8 ffff0000089b1000 ffff800008b2c600 ffff000009c2bcf0
[  103.157886] bca0: ffff0000085b9af8 ffff000009c2bcf0 ffff0000085b9b04 0000000040000145
[  103.158193] bcc0: ffff80003efa7770 0000000000000000 0001000000000000 0000000000000000
[  103.158509] bce0: ffff000009c2bcf0 ffff0000085b9b04
[  103.158729] [<ffff0000085b9b04>] lkdtm_STACK_GUARD_PAGE_TRAILING+0x2c/0x48
[  103.159007] [<ffff0000085b94b8>] lkdtm_do_action+0x1c/0x24
[  103.159235] [<ffff0000085b9300>] direct_entry+0xe8/0x190
[  103.159464] [<ffff0000083542d8>] full_proxy_write+0x60/0xa8
[  103.159691] [<ffff000008201188>] __vfs_write+0x18/0x118
[  103.159913] [<ffff0000082026ec>] vfs_write+0x9c/0x1a8
[  103.160129] [<ffff000008203cf8>] SyS_write+0x48/0xb0
[  103.160335] Exception stack(0xffff000009c2bec0 to 0xffff000009c2c000)
[  103.160598] bec0: 0000000000000001 0000000039d352f0 000000000000001a 0000000039d3530a
[  103.160906] bee0: 545f454741505f44 00474e494c494152 0080808080808080 8080808080808080
[  103.161214] bf00: 0000000000000040 7f7f7f7f7f7f7f7f fefefefefefefeff 7f7f7f7f7f7f7f7f
[  103.161533] bf20: 0101010101010101 0000ffffa05efcb8 0000ffffa047ea58 0000000000000010
[  103.161846] bf40: 0000000000000000 0000ffffa0537470 0000000000000000 00000000004b4000
[  103.162224] bf60: 0000000000000001 0000000039d352f0 000000000000001a 0000000000000001
[  103.162521] bf80: 0000000000000020 0000000039d32430 00000000004819d8 0000000039d32468
[  103.162824] bfa0: 0000000000000000 0000ffffc8523810 000000000040a288 0000ffffc8522e00
[  103.163113] bfc0: 0000ffffa0537458 00000000a0000000 0000000000000001 0000000000000040
[  103.163401] bfe0: 0000000000000000 0000000000000000 0000000000000000 0000ffffa0537458
[  103.163695] [<ffff0000080837b0>] el0_svc_naked+0x24/0x28
[  103.163905] [<0000ffffa0537458>] 0xffffa0537458
[  103.164097] Code: 97ed61ff 91401273 90003a60 9123c000 (39400261) 
[  103.164340] ---[ end trace d832d99efb2a6f69 ]---

I also confirmed they failed as expected with CONFIG_VMAP_STACK=n
