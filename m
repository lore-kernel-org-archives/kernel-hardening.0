Reply-To: kernel-hardening@lists.openwall.com
References: <1453828249-14467-1-git-send-email-ard.biesheuvel@linaro.org>
 <1453828249-14467-6-git-send-email-ard.biesheuvel@linaro.org>
From: Marc Zyngier <marc.zyngier@arm.com>
Message-ID: <56A7B0A0.3020003@arm.com>
Date: Tue, 26 Jan 2016 17:45:04 +0000
MIME-Version: 1.0
In-Reply-To: <1453828249-14467-6-git-send-email-ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v4 05/22] arm64: kvm: deal with kernel symbols outside of
 linear mapping
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, linux-kernel@vger.kernel.org
Cc: stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, arnd@arndb.de, christoffer.dall@linaro.org, labbott@fedoraproject.org, matt@codeblueprint.co.uk
List-ID: <kernel-hardening.lists.openwall.com>

On 26/01/16 17:10, Ard Biesheuvel wrote:
> KVM on arm64 uses a fixed offset between the linear mapping at EL1 and
> the HYP mapping at EL2. Before we can move the kernel virtual mapping
> out of the linear mapping, we have to make sure that references to kernel
> symbols that are accessed via the HYP mapping are translated to their
> linear equivalent.
> 
> Reviewed-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
