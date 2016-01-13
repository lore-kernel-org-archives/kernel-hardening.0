Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 13 Jan 2016 18:12:12 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160113181211.GL23370@leverpostej>
References: <1452518355-4606-1-git-send-email-ard.biesheuvel@linaro.org>
 <1452518355-4606-12-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1452518355-4606-12-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] Re: [PATCH v3 11/21] arm64: avoid R_AARCH64_ABS64 relocations for
 Image header fields
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, linux-kernel@vger.kernel.org, stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, arnd@arndb.de, marc.zyngier@arm.com, christoffer.dall@linaro.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jan 11, 2016 at 02:19:04PM +0100, Ard Biesheuvel wrote:
> Unfortunately, the current way of using the linker to emit build time
> constants into the Image header will no longer work once we switch to
> the use of PIE executables. The reason is that such constants are emitted
> into the binary using R_AARCH64_ABS64 relocations, which we will resolve
> at runtime, not at build time, and the places targeted by those
> relocations will contain zeroes before that.
> 
> So move back to assembly time constants or R_AARCH64_ABS32 relocations
> (which, interestingly enough, do get resolved at build time)

To me it seems very odd that ABS64 and ABS32 are treated differently,
and it makes me somewhat uncomfortable becuase it feels like a bug.

Do we know whether the inconsistency between ABS64 and ABS32 was
deliberate?

I couldn't spot anything declaring a difference in the AArch64 ELF
spec, and I'm not sure where else to look.

Thanks,
Mark.

> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm64/include/asm/assembler.h | 15 ++++++++
>  arch/arm64/kernel/head.S           | 17 +++++++--
>  arch/arm64/kernel/image.h          | 37 ++++++--------------
>  3 files changed, 40 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
> index d8bfcc1ce923..e211af783a3d 100644
> --- a/arch/arm64/include/asm/assembler.h
> +++ b/arch/arm64/include/asm/assembler.h
> @@ -222,4 +222,19 @@ lr	.req	x30		// link register
>  	.size	__pi_##x, . - x;	\
>  	ENDPROC(x)
>  
> +	.macro	le16, val
> +	.byte	\val & 0xff
> +	.byte	(\val >> 8) & 0xff
> +	.endm
> +
> +	.macro	le32, val
> +	le16	\val
> +	le16	(\val >> 16)
> +	.endm
> +
> +	.macro	le64, val
> +	le32	\val
> +	le32	(\val >> 32)
> +	.endm
> +
>  #endif	/* __ASM_ASSEMBLER_H */
> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> index 350515276541..211f75e673f4 100644
> --- a/arch/arm64/kernel/head.S
> +++ b/arch/arm64/kernel/head.S
> @@ -51,6 +51,17 @@
>  #define KERNEL_START	_text
>  #define KERNEL_END	_end
>  
> +#ifdef CONFIG_CPU_BIG_ENDIAN
> +#define __HEAD_FLAG_BE	1
> +#else
> +#define __HEAD_FLAG_BE	0
> +#endif
> +
> +#define __HEAD_FLAG_PAGE_SIZE ((PAGE_SHIFT - 10) / 2)
> +
> +#define __HEAD_FLAGS	((__HEAD_FLAG_BE << 0) |	\
> +			 (__HEAD_FLAG_PAGE_SIZE << 1))
> +
>  /*
>   * Kernel startup entry point.
>   * ---------------------------
> @@ -83,9 +94,9 @@ efi_head:
>  	b	stext				// branch to kernel start, magic
>  	.long	0				// reserved
>  #endif
> -	.quad	_kernel_offset_le		// Image load offset from start of RAM, little-endian
> -	.quad	_kernel_size_le			// Effective size of kernel image, little-endian
> -	.quad	_kernel_flags_le		// Informative flags, little-endian
> +	le64	TEXT_OFFSET			// Image load offset from start of RAM, little-endian
> +	.long	_kernel_size_le, 0		// Effective size of kernel image, little-endian
> +	le64	__HEAD_FLAGS			// Informative flags, little-endian
>  	.quad	0				// reserved
>  	.quad	0				// reserved
>  	.quad	0				// reserved
> diff --git a/arch/arm64/kernel/image.h b/arch/arm64/kernel/image.h
> index bc2abb8b1599..bb6b0e69d0a4 100644
> --- a/arch/arm64/kernel/image.h
> +++ b/arch/arm64/kernel/image.h
> @@ -26,41 +26,26 @@
>   * There aren't any ELF relocations we can use to endian-swap values known only
>   * at link time (e.g. the subtraction of two symbol addresses), so we must get
>   * the linker to endian-swap certain values before emitting them.
> + * Note that this will not work for 64-bit values: these are resolved using
> + * R_AARCH64_ABS64 relocations, which are fixed up at runtime rather than at
> + * build time when building the PIE executable (for KASLR).
>   */
>  #ifdef CONFIG_CPU_BIG_ENDIAN
> -#define DATA_LE64(data)					\
> -	((((data) & 0x00000000000000ff) << 56) |	\
> -	 (((data) & 0x000000000000ff00) << 40) |	\
> -	 (((data) & 0x0000000000ff0000) << 24) |	\
> -	 (((data) & 0x00000000ff000000) << 8)  |	\
> -	 (((data) & 0x000000ff00000000) >> 8)  |	\
> -	 (((data) & 0x0000ff0000000000) >> 24) |	\
> -	 (((data) & 0x00ff000000000000) >> 40) |	\
> -	 (((data) & 0xff00000000000000) >> 56))
> +#define DATA_LE32(data)				\
> +	((((data) & 0x000000ff) << 24) |	\
> +	 (((data) & 0x0000ff00) << 8)  |	\
> +	 (((data) & 0x00ff0000) >> 8)  |	\
> +	 (((data) & 0xff000000) >> 24))
>  #else
> -#define DATA_LE64(data) ((data) & 0xffffffffffffffff)
> +#define DATA_LE32(data) ((data) & 0xffffffff)
>  #endif
>  
> -#ifdef CONFIG_CPU_BIG_ENDIAN
> -#define __HEAD_FLAG_BE	1
> -#else
> -#define __HEAD_FLAG_BE	0
> -#endif
> -
> -#define __HEAD_FLAG_PAGE_SIZE ((PAGE_SHIFT - 10) / 2)
> -
> -#define __HEAD_FLAGS	((__HEAD_FLAG_BE << 0) |	\
> -			 (__HEAD_FLAG_PAGE_SIZE << 1))
> -
>  /*
>   * These will output as part of the Image header, which should be little-endian
> - * regardless of the endianness of the kernel. While constant values could be
> - * endian swapped in head.S, all are done here for consistency.
> + * regardless of the endianness of the kernel.
>   */
>  #define HEAD_SYMBOLS						\
> -	_kernel_size_le		= DATA_LE64(_end - _text);	\
> -	_kernel_offset_le	= DATA_LE64(TEXT_OFFSET);	\
> -	_kernel_flags_le	= DATA_LE64(__HEAD_FLAGS);
> +	_kernel_size_le		= DATA_LE32(_end - _text);
>  
>  #ifdef CONFIG_EFI
>  
> -- 
> 2.5.0
> 
