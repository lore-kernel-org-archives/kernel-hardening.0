Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1443018250-22893-1-git-send-email-catalin.marinas@arm.com>
References: <1443018250-22893-1-git-send-email-catalin.marinas@arm.com>
Date: Thu, 10 Dec 2015 11:40:44 -0800
Message-ID: <CAGXu5jJYoCxATf8tWAhdosNH9jKovpcYQ=PqD85gHnT+oBF3CQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 0/4] arm: Privileged no-access for LPAE
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

[thread necromancy]

This series looks good to me. I'd love to see it accepted. At the very
least the cleanups look like no-brainers. :)

Please consider the series:

Reviewed-by: Kees Cook <keescook@chromium.org>

Thanks for working on it!

-Kees


On Wed, Sep 23, 2015 at 7:24 AM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> Hi,
>
> This is the first attempt to add support for privileged no-access on
> LPAE-enabled kernels by disabling TTBR0 page table walks. The first
> three patches are pretty much refactoring/clean-up without any
> functional change. The last patch implements the actual PAN using TTBR0
> disabling. Its description also contains the details of how this works.
>
> The patches can be found here:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64 arm32-pan
>
> Tested in different configurations (with and without LPAE, all
> VMSPLIT_*, loadable modules) but only under KVM on Juno (ARMv8).
>
> Thanks.
>
>
> Catalin Marinas (4):
>   arm: kvm: Move TTBCR_* definitions from kvm_arm.h into
>     pgtable-3level-hwdef.h
>   arm: Move asm statements accessing TTBCR into dedicated functions
>   arm: Reduce the number of #ifdef CONFIG_CPU_SW_DOMAIN_PAN
>   arm: Implement privileged no-access using TTBR0 page table walks
>     disabling
>
>  arch/arm/Kconfig                            | 22 ++++++++--
>  arch/arm/include/asm/assembler.h            | 68 +++++++++++++++++++++++++----
>  arch/arm/include/asm/kvm_arm.h              | 17 +-------
>  arch/arm/include/asm/pgtable-3level-hwdef.h | 26 +++++++++++
>  arch/arm/include/asm/proc-fns.h             | 12 +++++
>  arch/arm/include/asm/uaccess.h              | 53 +++++++++++++++++++---
>  arch/arm/kvm/init.S                         |  2 +-
>  arch/arm/lib/csumpartialcopyuser.S          | 20 ++++++++-
>  arch/arm/mm/fault.c                         | 10 +++++
>  arch/arm/mm/mmu.c                           |  7 ++-
>  10 files changed, 199 insertions(+), 38 deletions(-)
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel



-- 
Kees Cook
Chrome OS & Brillo Security
