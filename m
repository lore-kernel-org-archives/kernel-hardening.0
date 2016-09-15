Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 15 Sep 2016 17:41:14 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160915164114.GC19214@leverpostej>
References: <1473788797-10879-1-git-send-email-catalin.marinas@arm.com>
 <20160915162044.GB19214@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160915162044.GB19214@leverpostej>
Subject: [kernel-hardening] Re: [PATCH v3 0/7] arm64: Privileged Access Never using TTBR0_EL1
 switching
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, andre.przywara@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Will Deacon <will.deacon@arm.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, James Morse <james.morse@arm.com>, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Sep 15, 2016 at 05:20:45PM +0100, Mark Rutland wrote:
> Don't we need to fix up do_sysinstr() (which performs raw cache
> maintenance ops on __user addresses) with
> uaccess_{enable,disable}_not_uao()?

Actually, we don't even need to do anything in the case of PAN since
cache ops aren't affected by PAN/UAO; we just need to map/unmap in the
TTBR0-switching case to ensure we don't get stup fixing things up
forever.

/me commences name bikeshedding.

Thanks,
Mark.
