Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1473788797-10879-1-git-send-email-catalin.marinas@arm.com>
References: <1473788797-10879-1-git-send-email-catalin.marinas@arm.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 14 Oct 2016 14:44:33 -0700
Message-ID: <CAGXu5jKMZTo7m=ygm7x8w__1my0jiQiVAiv9NowQ8pfQqCnjmw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 0/7] arm64: Privileged Access Never using TTBR0_EL1 switching
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, AKASHI Takahiro <takahiro.akashi@linaro.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

Just checking in on this feature -- I don't see it in -next nor
already in the tree. Is there any chance this is going to make the
v4.9 merge window?

It didn't sound like there were any unresolved issues remaining?

Thanks!

-Kees


On Tue, Sep 13, 2016 at 10:46 AM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> This is the third version of the arm64 PAN emulation using TTBR0_EL1
> switching. The series has not yet included the alternative nop patches
> from Mark Rutland, nor the empty_zero_page from Ard B. This will be done
> in a subsequent version once 4.9-rc1 is out (which will include Mark's
> alternative nop patches).
>
> Changes since v2:
>
> - efi_set_pgd() reworked to update the saved ttbr0 during run-time
>   services as this value is used during exception return
>
> - uaccess_(enable|disable) C macros no longer take an 'alt' parameter
>   Instead, uaccess_(enable|disable)_not_uao are introduced for the case
>   where hardware PAN switching is not required when UAO is present
>
> - post_ttbr0_update_workaround macro no longer takes a 'ret' parameter
>
> - system_supports_ttbr0_pan renamed to system_uses_ttbr0_pan
>
> - init_thread_info.ttbr0 moved towards the end of the setup_arch()
>   function and comment updated
>
> - vmlinux.lds.S fixed to use RESERVED_TTBR0_SIZE
>
> - Config option changed to ARM64_SW_TTBR0_PAN
>
> - Some comment clean-ups and commit log updates
>
> Catalin Marinas (7):
>   arm64: Factor out PAN enabling/disabling into separate uaccess_*
>     macros
>   arm64: Factor out TTBR0_EL1 post-update workaround into a specific asm
>     macro
>   arm64: Introduce uaccess_{disable,enable} functionality based on
>     TTBR0_EL1
>   arm64: Disable TTBR0_EL1 during normal kernel execution
>   arm64: Handle faults caused by inadvertent user access with PAN
>     enabled
>   arm64: xen: Enable user access before a privcmd hvc call
>   arm64: Enable CONFIG_ARM64_SW_TTBR0_PAN
>
> The patches are also available on this branch:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux ttbr0-pan
>
> Thanks for reviewing/testing.
>
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
>



-- 
Kees Cook
Nexus Security
