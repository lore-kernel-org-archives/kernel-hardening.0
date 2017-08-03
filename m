Date: Thu, 3 Aug 2017 15:49:27 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
Message-ID: <20170803144926.7eankdjmnyxw3zru@armageddon.cambridge.arm.com>
References: <1500480092-28480-1-git-send-email-mark.rutland@arm.com>
 <1500480092-28480-2-git-send-email-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1500480092-28480-2-git-send-email-mark.rutland@arm.com>
Subject: [kernel-hardening] Re: [PATCH 01/11] arm64: docs: describe ELF hwcaps
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, arnd@arndb.de, jiong.wang@arm.com, marc.zyngier@arm.com, yao.qi@arm.com, suzuki.poulose@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, Dave.Martin@arm.com, kernel-hardening@lists.openwall.com, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jul 19, 2017 at 05:01:22PM +0100, Mark Rutland wrote:
> +3. The hwcaps exposed in AT_HWCAP
> +---------------------------------
> +
> +HWCAP_FP
> +
> +    Functionality implied by ID_AA64PFR0_EL1.FP == 0b0000.

Aren't these too restrictive? Linux would still present HWCAP_FP even
when ID_AA64PFR0_EL1.FP == 1. I think we should replace the strict
equal with greater than or equal, also mentioning that the field is
signed (or refer to the cpuid where the sign of the fields is
described).

-- 
Catalin
