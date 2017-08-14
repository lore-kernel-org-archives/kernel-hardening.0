Date: Mon, 14 Aug 2017 16:29:51 +0100
From: Dave Martin <Dave.Martin@arm.com>
Message-ID: <20170814152950.GT6321@e103592.cambridge.arm.com>
References: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
 <20170814125411.22604-3-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170814125411.22604-3-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] Re: [PATCH 02/30] ARM: assembler: introduce adr_l, ldr_l and str_l
 macros
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: kernel-hardening@lists.openwall.com, Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Russell King <linux@armlinux.org.uk>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Thomas Garnier <thgarnie@google.com>, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 14, 2017 at 01:53:43PM +0100, Ard Biesheuvel wrote:
> Like arm64, ARM supports position independent code sequences that
> produce symbol references with a greater reach than the ordinary
> adr/ldr instructions.
> 
> Currently, we use open coded instruction sequences involving literals
> and arithmetic operations. Instead, we can use movw/movt pairs on v7
> CPUs, circumventing the D-cache entirely. For older CPUs, we can emit
> the literal into a subsection, allowing it to be emitted out of line
> while retaining the ability to perform arithmetic on label offsets.
> 
> E.g., on pre-v7 CPUs, we can emit a PC-relative reference as follows:
> 
>        ldr          <reg>, 222f
>   111: add          <reg>, <reg>, pc
>        .subsection  1
>   222: .long        <sym> - (111b + 8)
>        .previous
> 
> This is allowed by the assembler because, unlike ordinary sections,
> subsections are combined into a single section into the object file,
> and so the label references are not true cross-section references that
> are visible as relocations. Note that we could even do something like
> 
>        add          <reg>, pc, #(222f - 111f) & ~0xfff
>        ldr          <reg>, [<reg>, #(222f - 111f) & 0xfff]
>   111: add          <reg>, <reg>, pc
>        .subsection  1
>   222: .long        <sym> - (111b + 8)
>        .previous

This is reinventing ldr=

I seem to remember ldr= barfing on things that .long happily accepts
though, was this the reason?


> if it turns out that the 4 KB range of the ldr instruction is insufficient
> to reach the literal in the subsection, although this is currently not a
> problem (of the 98 objects built from .S files in a multi_v7_defconfig
> build, only 11 have .text sections that are over 1 KB, and the largest one
> [entry-armv.o] is 3308 bytes)
> 
> Subsections have been available in binutils since 2004 at least, so
> they should not cause any issues with older toolchains.

(I also believe this to be an ancient feature, but I've not done the
digging to prove it.)

> So use the above to implement the macros mov_l, adr_l, adrm_l (using ldm
> to load multiple literals at once), ldr_l and str_l, all of which will
> use movw/movt pairs on v7 and later CPUs, and use PC-relative literals
> otherwise.
> 
> Cc: Russell King <linux@armlinux.org.uk>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm/include/asm/assembler.h | 71 ++++++++++++++++++++
>  1 file changed, 71 insertions(+)
> 
> diff --git a/arch/arm/include/asm/assembler.h b/arch/arm/include/asm/assembler.h
> index ad301f107dd2..516ebaf4ff38 100644
> --- a/arch/arm/include/asm/assembler.h
> +++ b/arch/arm/include/asm/assembler.h
> @@ -518,4 +518,75 @@ THUMB(	orr	\reg , \reg , #PSR_T_BIT	)
>  #endif
>  	.endm
>  
> +#ifdef CONFIG_THUMB2_KERNEL
> +#define	ARM_PC_BIAS		4
> +#else
> +#define	ARM_PC_BIAS		8
> +#endif
> +
> +	.macro		__adldst_l, op, reg, sym, tmp, c
> +	.if		__LINUX_ARM_ARCH__ < 7
> +	ldr\c		\tmp, 111f
> +	.subsection	1
> +	.align		2
> +111:	.long		\sym - (222f + ARM_PC_BIAS)

See above comment about ldr=.

> +	.previous
> +	.else
> +	W(movw\c\())	\tmp, #:lower16:\sym - (222f + ARM_PC_BIAS)
> +	W(movt\c\())	\tmp, #:upper16:\sym - (222f + ARM_PC_BIAS)

Why W()?

There are no narrow forms of these instructions anyway -- if there were
then they couldn't accommodate a 16-bit immediate.

> +	.endif
> +222:
> +	.ifc		\op, add
> +	add\c		\reg, \tmp, pc
> +	.elseif		CONFIG_THUMB2_KERNEL == 1
> +	add		\tmp, \tmp, pc
> +	\op\c		\reg, [\tmp]

Shame 
	\op\c		\reg, [pc, \tmp]
doesn't work.

But it doesn't, apparently.

> +	.else
> +	\op\c		\reg, [pc, \tmp]
> +	.endif
> +	.endm
> +
> +	/*
> +	 * mov_l - move a constant value or [relocated] address into a register
> +	 */
> +	.macro		mov_l, dst:req, imm:req, cond
> +	.if		__LINUX_ARM_ARCH__ < 7
> +	ldr\cond	\dst, =\imm
> +	.else
> +	W(movw\cond\())	\dst, #:lower16:\imm
> +	W(movt\cond\())	\dst, #:upper16:\imm
> +	.endif
> +	.endm
> +
> +	/*
> +	 * adr_l - adr pseudo-op with unlimited range
> +	 *
> +	 * @dst: destination register
> +	 * @sym: name of the symbol
> +	 */
> +	.macro		adr_l, dst:req, sym:req, cond
> +	__adldst_l	add, \dst, \sym, \dst, \cond
> +	.endm
> +
> +	/*
> +	 * ldr_l - ldr <literal> pseudo-op with unlimited range
> +	 *
> +	 * @dst: destination register
> +	 * @sym: name of the symbol
> +	 */
> +	.macro		ldr_l, dst:req, sym:req, cond
> +	__adldst_l	ldr, \dst, \sym, \dst, \cond
> +	.endm
> +
> +	/*
> +	 * str_l - str <literal> pseudo-op with unlimited range
> +	 *
> +	 * @src: source register
> +	 * @sym: name of the symbol
> +	 * @tmp: mandatory scratch register
> +	 */
> +	.macro		str_l, src:req, sym:req, tmp:req, cond
> +	__adldst_l	str, \src, \sym, \tmp, \cond
> +	.endm

Cheers
---Dave
