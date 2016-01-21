Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 21 Jan 2016 16:20:56 +0000
From: Matt Fleming <matt@codeblueprint.co.uk>
Message-ID: <20160121162056.GG2510@codeblueprint.co.uk>
References: <1452518355-4606-1-git-send-email-ard.biesheuvel@linaro.org>
 <1452518355-4606-22-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1452518355-4606-22-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] Re: [PATCH v3 20/21] efi: stub: use high allocation for converted
 command line
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, linux-kernel@vger.kernel.org, stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, arnd@arndb.de, marc.zyngier@arm.com, christoffer.dall@linaro.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 11 Jan, at 02:19:14PM, Ard Biesheuvel wrote:
> Before we can move the command line processing before the allocation
> of the kernel, which is required for detecting the 'nokaslr' option
> which controls that allocation, move the converted command line higher
> up in memory, to prevent it from interfering with the kernel itself.
> 
> Since x86 needs the address to fit in 32 bits, use UINT_MAX as the upper
> bound there. Otherwise, use ULONG_MAX (i.e., no limit)
> 
> Cc: Matt Fleming <matt@codeblueprint.co.uk>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/x86/include/asm/efi.h                     |  2 ++
>  drivers/firmware/efi/libstub/efi-stub-helper.c | 14 +++++++++++++-
>  2 files changed, 15 insertions(+), 1 deletion(-)

Reviewed-by: Matt Fleming <matt@codeblueprint.co.uk>
