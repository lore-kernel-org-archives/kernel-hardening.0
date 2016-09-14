Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 14 Sep 2016 14:54:25 -0600
From: David Brown <david.brown@linaro.org>
Message-ID: <20160914205425.GA15021@davidb.org>
References: <1473788797-10879-1-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1473788797-10879-1-git-send-email-catalin.marinas@arm.com>
Subject: Re: [kernel-hardening] [PATCH v3 0/7] arm64: Privileged Access Never
 using TTBR0_EL1 switching
To: kernel-hardening@lists.openwall.com
Cc: linux-arm-kernel@lists.infradead.org, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, AKASHI Takahiro <takahiro.akashi@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Sep 13, 2016 at 06:46:30PM +0100, Catalin Marinas wrote:

>This is the third version of the arm64 PAN emulation using TTBR0_EL1
>switching. The series has not yet included the alternative nop patches
>from Mark Rutland, nor the empty_zero_page from Ard B. This will be done
>in a subsequent version once 4.9-rc1 is out (which will include Mark's
>alternative nop patches).

I've tested these with a bunch of reboots in both qemu and HiKey and
have not seen the efi failure.

David
