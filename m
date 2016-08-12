Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1471015666-23125-1-git-send-email-catalin.marinas@arm.com>
References: <1471015666-23125-1-git-send-email-catalin.marinas@arm.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 12 Aug 2016 11:04:39 -0700
Message-ID: <CAGXu5jJYoEVA2g5SNxh1hQ-G6gm0UBEUdAVEsuNidpYgdmuW3A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 0/7] arm64: Privileged Access Never using TTBR0_EL1 switching
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Julien Grall <julien.grall@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Aug 12, 2016 at 8:27 AM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> This is the first (public) attempt at emulating PAN by disabling
> TTBR0_EL1 accesses on arm64. I chose to use a per-CPU saved_ttbr0_el1
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

So awesome! Thank you for working on this. I still lack real arm64
hardware to test this on, but the lkdtm test ACCESS_USERSPACE should
trip this protection (e.g. this "cat" should get killed and the Oops
appear in dmesg):

# cat <(echo ACCESS_USERSPACE) > /sys/kernel/debug/provoke-crash/DIRECT

-Kees

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



-- 
Kees Cook
Nexus Security
