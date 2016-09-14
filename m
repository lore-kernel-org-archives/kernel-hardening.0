Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 14 Sep 2016 17:45:11 +0100
From: Will Deacon <will.deacon@arm.com>
Message-ID: <20160914164511.GJ19622@arm.com>
References: <1473788797-10879-1-git-send-email-catalin.marinas@arm.com>
 <1473788797-10879-5-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1473788797-10879-5-git-send-email-catalin.marinas@arm.com>
Subject: [kernel-hardening] Re: [PATCH v3 4/7] arm64: Disable TTBR0_EL1 during normal kernel
 execution
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, James Morse <james.morse@arm.com>, Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, AKASHI Takahiro <takahiro.akashi@linaro.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Sep 13, 2016 at 06:46:34PM +0100, Catalin Marinas wrote:
> When the TTBR0 PAN feature is enabled, the kernel entry points need to
> disable access to TTBR0_EL1. The PAN status of the interrupted context
> is stored as part of the saved pstate, reusing the PSR_PAN_BIT (22).
> Restoring access to TTBR0_PAN is done on exception return if returning
> to user or returning to a context where PAN was disabled.
> 
> Context switching via switch_mm() must defer the update of TTBR0_EL1
> until a return to user or an explicit uaccess_enable() call.
> 
> Special care needs to be taken for two cases where TTBR0_EL1 is set
> outside the normal kernel context switch operation: EFI run-time
> services (via efi_set_pgd) and CPU suspend (via cpu_(un)install_idmap).
> Code has been added to avoid deferred TTBR0_EL1 switching as in
> switch_mm() and restore the reserved TTBR0_EL1 when uninstalling the
> special TTBR0_EL1.
> 
> This patch also removes a stale comment on the switch_mm() function.
> 
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: James Morse <james.morse@arm.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  arch/arm64/include/asm/efi.h         | 26 +++++++++++++-
>  arch/arm64/include/asm/mmu_context.h | 51 +++++++++++++++++++--------
>  arch/arm64/include/asm/ptrace.h      |  2 ++
>  arch/arm64/kernel/entry.S            | 67 ++++++++++++++++++++++++++++++++++++
>  arch/arm64/kernel/setup.c            |  9 +++++
>  arch/arm64/mm/context.c              |  7 +++-
>  6 files changed, 146 insertions(+), 16 deletions(-)

[...]

> diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
> index ada08b5b036d..458773ac5ec9 100644
> --- a/arch/arm64/include/asm/ptrace.h
> +++ b/arch/arm64/include/asm/ptrace.h
> @@ -21,6 +21,8 @@
>  
>  #include <uapi/asm/ptrace.h>
>  
> +#define _PSR_PAN_BIT		22

[...]

> +	.if	\el != 0
> +	tbnz	x22, #_PSR_PAN_BIT, 1f		// Skip re-enabling TTBR0 access if previously disabled
> +	.endif

I really don't like the duplication of the #defines, just because tbnz
takes a bit number rather than a mask. I think for now we should follow
the status quo and use the immediate with a comment (we already do this
with PSR_I_BIT), but perhaps as a followup we should adjust the UAPI
headers to generate the PSR masks using shifts instead?

Not taken a proper look at the series yet, but this jumped out at me :)

Will
