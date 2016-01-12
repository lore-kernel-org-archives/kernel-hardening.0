Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 12 Jan 2016 12:36:57 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160112123656.GC4858@leverpostej>
References: <1452518355-4606-1-git-send-email-ard.biesheuvel@linaro.org>
 <1452518355-4606-6-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1452518355-4606-6-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] Re: [PATCH v3 05/21] arm64: kvm: deal with kernel symbols outside of
 linear mapping
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, linux-kernel@vger.kernel.org, stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, arnd@arndb.de, marc.zyngier@arm.com, christoffer.dall@linaro.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jan 11, 2016 at 02:18:58PM +0100, Ard Biesheuvel wrote:
> KVM on arm64 uses a fixed offset between the linear mapping at EL1 and
> the HYP mapping at EL2. Before we can move the kernel virtual mapping
> out of the linear mapping, we have to make sure that references to kernel
> symbols that are accessed via the HYP mapping are translated to their
> linear equivalent.
> 
> To prevent inadvertent direct references from sneaking in later, change
> the type of all extern declarations to HYP kernel symbols to the opaque
> 'struct kvm_ksym', which does not decay to a pointer type like char arrays
> and function references. This is not bullet proof, but at least forces the
> user to take the address explicitly rather than referencing it directly.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Cool feature!

> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 5e377101f919..e3865845d3e1 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -105,24 +105,29 @@
>  #ifndef __ASSEMBLY__
>  struct kvm;
>  struct kvm_vcpu;
> +struct kvm_ksym;

So that one doesn't have to trawl git logs, it might be worth a comment
as to the purpose of struct kvm_ksym (and thus why we never need to
actually define it).

Either way:

Reviewed-by: Mark Rutland <mark.rutland@arm.com>

Mark.
