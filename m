Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 15 Sep 2016 17:20:45 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160915162044.GB19214@leverpostej>
References: <1473788797-10879-1-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1473788797-10879-1-git-send-email-catalin.marinas@arm.com>
Subject: [kernel-hardening] Re: [PATCH v3 0/7] arm64: Privileged Access Never using TTBR0_EL1
 switching
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Kees Cook <keescook@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kernel-hardening@lists.openwall.com, Will Deacon <will.deacon@arm.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, James Morse <james.morse@arm.com>, andre.przywara@arm.com, suzuki.poulose@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Catalin,

On Tue, Sep 13, 2016 at 06:46:30PM +0100, Catalin Marinas wrote:
> This is the third version of the arm64 PAN emulation using TTBR0_EL1
> switching. The series has not yet included the alternative nop patches
> from Mark Rutland, nor the empty_zero_page from Ard B. This will be done
> in a subsequent version once 4.9-rc1 is out (which will include Mark's
> alternative nop patches).
 
>  arch/arm64/Kconfig                      |   8 ++
>  arch/arm64/include/asm/assembler.h      |  33 +++++++
>  arch/arm64/include/asm/cpufeature.h     |   6 ++
>  arch/arm64/include/asm/efi.h            |  26 ++++-
>  arch/arm64/include/asm/futex.h          |  14 +--
>  arch/arm64/include/asm/kernel-pgtable.h |   7 ++
>  arch/arm64/include/asm/mmu_context.h    |  51 +++++++---
>  arch/arm64/include/asm/ptrace.h         |   2 +
>  arch/arm64/include/asm/thread_info.h    |   3 +
>  arch/arm64/include/asm/uaccess.h        | 163 ++++++++++++++++++++++++++++++--
>  arch/arm64/kernel/armv8_deprecated.c    |  10 +-
>  arch/arm64/kernel/asm-offsets.c         |   3 +
>  arch/arm64/kernel/cpufeature.c          |   1 +
>  arch/arm64/kernel/entry.S               |  71 +++++++++++++-
>  arch/arm64/kernel/head.S                |   6 +-
>  arch/arm64/kernel/setup.c               |   9 ++
>  arch/arm64/kernel/vmlinux.lds.S         |   5 +
>  arch/arm64/lib/clear_user.S             |   8 +-
>  arch/arm64/lib/copy_from_user.S         |   8 +-
>  arch/arm64/lib/copy_in_user.S           |   8 +-
>  arch/arm64/lib/copy_to_user.S           |   8 +-
>  arch/arm64/mm/context.c                 |   7 +-
>  arch/arm64/mm/fault.c                   |  22 +++--
>  arch/arm64/mm/proc.S                    |  11 +--
>  arch/arm64/xen/hypercall.S              |  19 ++++
>  25 files changed, 428 insertions(+), 81 deletions(-)

I don't seee traps.c there. Don't we need to fix up do_sysinstr() (which
performs raw cache maintenance ops on __user addresses) with
uaccess_{enable,disable}_not_uao()?

Likewise, how do we handle __flush_cache_user_range and
flush_icache_range? Some callers (e.g. __do_compat_cache_op) pass in
__user addresses.

I hope we have some tests lying around for those. ;)

Thanks,
Mark.
