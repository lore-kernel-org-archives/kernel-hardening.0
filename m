Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 15 Sep 2016 10:52:32 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
Message-ID: <20160915095232.GF2492@e104818-lin.cambridge.arm.com>
References: <1473788797-10879-1-git-send-email-catalin.marinas@arm.com>
 <20160914205425.GA15021@davidb.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160914205425.GA15021@davidb.org>
Subject: Re: [kernel-hardening] [PATCH v3 0/7] arm64: Privileged Access Never
 using TTBR0_EL1 switching
To: David Brown <david.brown@linaro.org>
Cc: kernel-hardening@lists.openwall.com, Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Will Deacon <will.deacon@arm.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, James Morse <james.morse@arm.com>, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Sep 14, 2016 at 02:54:25PM -0600, David Brown wrote:
> On Tue, Sep 13, 2016 at 06:46:30PM +0100, Catalin Marinas wrote:
> 
> >This is the third version of the arm64 PAN emulation using TTBR0_EL1
> >switching. The series has not yet included the alternative nop patches
> >from Mark Rutland, nor the empty_zero_page from Ard B. This will be done
> >in a subsequent version once 4.9-rc1 is out (which will include Mark's
> >alternative nop patches).
> 
> I've tested these with a bunch of reboots in both qemu and HiKey and
> have not seen the efi failure.

Thanks for testing. I'll defer adding your tested-by until I post the
hopefully final version after 4.9-rc1 (it's pretty late to merge these
patches now, I still need to do more testing on models with PAN or
PAN+UAO present).

-- 
Catalin
