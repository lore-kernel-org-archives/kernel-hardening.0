Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <1471015666-23125-1-git-send-email-catalin.marinas@arm.com>
References: <1471015666-23125-1-git-send-email-catalin.marinas@arm.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Sat, 13 Aug 2016 11:13:58 +0200
Message-ID: <CAKv+Gu9hz_=GSRYgW3RueVhUA8F3HaM5DC_8Jkbx1JHF3x5mKg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [PATCH 0/7] arm64: Privileged Access Never
 using TTBR0_EL1 switching
To: kernel-hardening@lists.openwall.com
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Kees Cook <keescook@chromium.org>, Julien Grall <julien.grall@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 12 August 2016 at 17:27, Catalin Marinas <catalin.marinas@arm.com> wrote:
> This is the first (public) attempt at emulating PAN by disabling
> TTBR0_EL1 accesses on arm64.

I take it using TCR_EL1.EPD0 is too expensive?

> I chose to use a per-CPU saved_ttbr0_el1
> variable to store the actual TTBR0 as, IMO, it looks better w.r.t. the
> context switching code, to the detriment of a slightly more complex
> uaccess_enable() implementation. The alternative was storing the saved
> TTBR0 in thread_info but with more complex thread switching since TTBR0
> is normally tied to switch_mm() rather than switch_to(). The latter may
> also get more complicated if we are to decouple the kernel stack from
> thread_info at some point (vmalloc'ed stacks).
>
> The code requires more testing, especially for combinations where UAO is
> present but PAN is not.
>
> The patches are also available on this branch:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux ttbr0-pan
>
> Thanks for reviewing/testing.
>
> Catalin Marinas (7):
>   arm64: Factor out PAN enabling/disabling into separate uaccess_*
>     macros
>   arm64: Factor out TTBR0_EL1 setting into a specific asm macro
>   arm64: Introduce uaccess_{disable,enable} functionality based on
>     TTBR0_EL1
>   arm64: Disable TTBR0_EL1 during normal kernel execution
>   arm64: Handle faults caused by inadvertent user access with PAN
>     enabled
>   arm64: xen: Enable user access before a privcmd hvc call
>   arm64: Enable CONFIG_ARM64_TTBR0_PAN
>
>  arch/arm64/Kconfig                      |   8 +++
>  arch/arm64/include/asm/assembler.h      | 106 +++++++++++++++++++++++++++++++-
>  arch/arm64/include/asm/cpufeature.h     |   6 ++
>  arch/arm64/include/asm/efi.h            |  14 +++++
>  arch/arm64/include/asm/futex.h          |  14 ++---
>  arch/arm64/include/asm/kernel-pgtable.h |   7 +++
>  arch/arm64/include/asm/mmu_context.h    |   3 +-
>  arch/arm64/include/asm/uaccess.h        |  57 ++++++++++++++---
>  arch/arm64/include/uapi/asm/ptrace.h    |   2 +
>  arch/arm64/kernel/armv8_deprecated.c    |  10 +--
>  arch/arm64/kernel/cpufeature.c          |   1 +
>  arch/arm64/kernel/entry.S               |  62 +++++++++++++++++++
>  arch/arm64/kernel/head.S                |   6 +-
>  arch/arm64/kernel/suspend.c             |  12 ++--
>  arch/arm64/kernel/vmlinux.lds.S         |   5 ++
>  arch/arm64/lib/clear_user.S             |   7 +--
>  arch/arm64/lib/copy_from_user.S         |   7 +--
>  arch/arm64/lib/copy_in_user.S           |   7 +--
>  arch/arm64/lib/copy_to_user.S           |   7 +--
>  arch/arm64/mm/context.c                 |  25 +++++++-
>  arch/arm64/mm/fault.c                   |  21 ++++---
>  arch/arm64/mm/proc.S                    |  16 +----
>  arch/arm64/xen/hypercall.S              |  18 ++++++
>  23 files changed, 347 insertions(+), 74 deletions(-)
>
