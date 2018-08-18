Subject: Re: [RFC/PoC PATCH 0/3] arm64: basic ROP mitigation
References: <20180802132133.23999-1-ard.biesheuvel@linaro.org>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <3d26b5e1-3e07-4166-1fe3-e1d6e44fcc98@redhat.com>
Date: Fri, 17 Aug 2018 18:27:33 -0700
MIME-Version: 1.0
In-Reply-To: <20180802132133.23999-1-ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, christoffer.dall@arm.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, labbott@fedoraproject.org, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>

On 08/02/2018 06:21 AM, Ard Biesheuvel wrote:
> This is a proof of concept I cooked up, primarily to trigger a discussion
> about whether there is a point to doing anything like this, and if there
> is, what the pitfalls are. Also, while I am not aware of any similar
> implementations, the idea is so simple that I would be surprised if nobody
> else thought of the same thing way before I did.
> 
> The idea is that we can significantly limit the kernel's attack surface
> for ROP based attacks by clearing the stack pointer's sign bit before
> returning from a function, and setting it again right after proceeding
> from the [expected] return address. This should make it much more difficult
> to return to arbitrary gadgets, given that they rely on being chained to
> the next via a return address popped off the stack, and this is difficult
> when the stack pointer is invalid.
> 
> Of course, 4 additional instructions per function return is not exactly
> for free, but they are just movs and adds, and leaf functions are
> disregarded unless they allocate a stack frame (this comes for free
> because simple_return insns are disregarded by the plugin)
> 
> Please shoot, preferably with better ideas ...
> 
> Ard Biesheuvel (3):
>    arm64: use wrapper macro for bl/blx instructions from asm code
>    gcc: plugins: add ROP shield plugin for arm64
>    arm64: enable ROP protection by clearing SP bit #55 across function
>      returns
> 
>   arch/Kconfig                                  |   4 +
>   arch/arm64/Kconfig                            |  10 ++
>   arch/arm64/include/asm/assembler.h            |  21 +++-
>   arch/arm64/kernel/entry-ftrace.S              |   6 +-
>   arch/arm64/kernel/entry.S                     | 104 +++++++++-------
>   arch/arm64/kernel/head.S                      |   4 +-
>   arch/arm64/kernel/probes/kprobes_trampoline.S |   2 +-
>   arch/arm64/kernel/sleep.S                     |   6 +-
>   drivers/firmware/efi/libstub/Makefile         |   3 +-
>   scripts/Makefile.gcc-plugins                  |   7 ++
>   scripts/gcc-plugins/arm64_rop_shield_plugin.c | 116 ++++++++++++++++++
>   11 files changed, 228 insertions(+), 55 deletions(-)
>   create mode 100644 scripts/gcc-plugins/arm64_rop_shield_plugin.c
> 

I tried this on the Fedora config and it died in mutex_lock

#0  el1_sync () at arch/arm64/kernel/entry.S:570
#1  0xffff000008c62ed4 in __cmpxchg_case_acq_8 (new=<optimized out>, old=<optimized out>, ptr=<optimized out>) at ./arch/arm64/include/asm/atomic_lse.h:480
#2  __cmpxchg_acq (size=<optimized out>, new=<optimized out>, old=<optimized out>, ptr=<optimized out>) at ./arch/arm64/include/asm/cmpxchg.h:141
#3  __mutex_trylock_fast (lock=<optimized out>) at kernel/locking/mutex.c:144
#4  mutex_lock (lock=0xffff0000098dee48 <cgroup_mutex>) at kernel/locking/mutex.c:241
#5  0xffff000008f40978 in kallsyms_token_index ()

ffff000008bda050 <mutex_lock>:
ffff000008bda050:       a9bf7bfd        stp     x29, x30, [sp, #-16]!
ffff000008bda054:       aa0003e3        mov     x3, x0
ffff000008bda058:       d5384102        mrs     x2, sp_el0
ffff000008bda05c:       910003fd        mov     x29, sp
ffff000008bda060:       d2800001        mov     x1, #0x0                        // #0
ffff000008bda064:       97ff85af        bl      ffff000008bbb720 <__ll_sc___cmpxchg_case_acq_8>
ffff000008bda068:       d503201f        nop
ffff000008bda06c:       d503201f        nop
ffff000008bda070:       b50000c0        cbnz    x0, ffff000008bda088 <mutex_lock+0x38>
ffff000008bda074:       a8c17bfd        ldp     x29, x30, [sp], #16
ffff000008bda078:       910003f0        mov     x16, sp
ffff000008bda07c:       9248fa1f        and     sp, x16, #0xff7fffffffffffff
ffff000008bda080:       d65f03c0        ret
ffff000008bda084:       d503201f        nop
ffff000008bda088:       aa0303e0        mov     x0, x3
ffff000008bda08c:       97ffffe7        bl      ffff000008bda028 <__mutex_lock_slowpath>
ffff000008bda090:       910003fe        mov     x30, sp
ffff000008bda094:       b24903df        orr     sp, x30, #0x80000000000000
ffff000008bda098:       a8c17bfd        ldp     x29, x30, [sp], #16
ffff000008bda09c:       910003f0        mov     x16, sp
ffff000008bda0a0:       9248fa1f        and     sp, x16, #0xff7fffffffffffff
ffff000008bda0a4:       d65f03c0        ret

ffff000008bbb720 <__ll_sc___cmpxchg_case_acq_8>:
ffff000008bbb720:       f9800011        prfm    pstl1strm, [x0]
ffff000008bbb724:       c85ffc10        ldaxr   x16, [x0]
ffff000008bbb728:       ca010211        eor     x17, x16, x1
ffff000008bbb72c:       b5000071        cbnz    x17, ffff000008bbb738 <__ll_sc___cmpxchg_case_acq_8+0x18>
ffff000008bbb730:       c8117c02        stxr    w17, x2, [x0]
ffff000008bbb734:       35ffff91        cbnz    w17, ffff000008bbb724 <__ll_sc___cmpxchg_case_acq_8+0x4>
ffff000008bbb738:       aa1003e0        mov     x0, x16
ffff000008bbb73c:       910003f0        mov     x16, sp
ffff000008bbb740:       9248fa1f        and     sp, x16, #0xff7fffffffffffff
ffff000008bbb744:       d65f03c0        ret

If I turn off CONFIG_ARM64_LSE_ATOMICS it works

Thanks,
Laura
