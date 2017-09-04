Date: Mon, 4 Sep 2017 12:05:40 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
In-Reply-To: <20170903120757.14968-4-ard.biesheuvel@linaro.org>
Message-ID: <nycvar.YSQ.7.76.1709041205090.8603@knanqh.ubzr>
References: <20170903120757.14968-1-ard.biesheuvel@linaro.org> <20170903120757.14968-4-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH v2 03/29] ARM: assembler: introduce adr_l, ldr_l and
 str_l macros
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, Arnd Bergmann <arnd@arndb.de>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, 3 Sep 2017, Ard Biesheuvel wrote:

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
> 
> if it turns out that the 4 KB range of the ldr instruction is insufficient
> to reach the literal in the subsection, although this is currently not a
> problem (of the 98 objects built from .S files in a multi_v7_defconfig
> build, only 11 have .text sections that are over 1 KB, and the largest one
> [entry-armv.o] is 3308 bytes)
> 
> Subsections have been available in binutils since 2004 at least, so
> they should not cause any issues with older toolchains.
> 
> So use the above to implement the macros mov_l, adr_l, ldr_l and str_l,
> all of which will use movw/movt pairs on v7 and later CPUs, and use
> PC-relative literals otherwise.
> 
> Cc: Russell King <linux@armlinux.org.uk>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

REviewed-by: Nicolas Pitre <nico@linaro.org>

> ---
>  arch/arm/include/asm/assembler.h | 76 ++++++++++++++++++++
>  1 file changed, 76 insertions(+)
> 
> diff --git a/arch/arm/include/asm/assembler.h b/arch/arm/include/asm/assembler.h
> index ad301f107dd2..341e4ed1ef84 100644
> --- a/arch/arm/include/asm/assembler.h
> +++ b/arch/arm/include/asm/assembler.h
> @@ -518,4 +518,80 @@ THUMB(	orr	\reg , \reg , #PSR_T_BIT	)
>  #endif
>  	.endm
>  
> +	.macro		__adldst_l, op, reg, sym, tmp
> +	.if		__LINUX_ARM_ARCH__ < 7
> +	ldr		\tmp, 111f
> +	.subsection	1
> +	.align		2
> +111:	.long		\sym - (222f + 8)
> +	.previous
> +	.else
> +	/*
> +	 * In Thumb-2 builds, the PC bias depends on whether we are currently
> +	 * emitting into a .arm or a .thumb section. So emit a nop and take
> +	 * its size, so we can infer the execution mode and PC bias from it.
> +	 */
> +   ARM(	.set		.Lnopsize, 4			)
> + THUMB(	.pushsection	".discard.nop", "x", %note	)
> + THUMB(	111:		nop				)
> + THUMB(	.set		.Lnopsize, . - 111b		)
> + THUMB(	.popsection					)
> +
> +	movw		\tmp, #:lower16:\sym - (222f + 2 * .Lnopsize)
> +	movt		\tmp, #:upper16:\sym - (222f + 2 * .Lnopsize)
> +	.endif
> +222:
> +	.ifc		\op, add
> +	add		\reg, \tmp, pc
> +	.elseif		.Lnopsize == 2		@ Thumb-2 mode
> +	add		\tmp, \tmp, pc
> +	\op		\reg, [\tmp]
> +	.else
> +	\op		\reg, [pc, \tmp]
> +	.endif
> +	.endm
> +
> +	/*
> +	 * mov_l - move a constant value or [relocated] address into a register
> +	 */
> +	.macro		mov_l, dst:req, imm:req
> +	.if		__LINUX_ARM_ARCH__ < 7
> +	ldr		\dst, =\imm
> +	.else
> +	movw		\dst, #:lower16:\imm
> +	movt		\dst, #:upper16:\imm
> +	.endif
> +	.endm
> +
> +	/*
> +	 * adr_l - adr pseudo-op with unlimited range
> +	 *
> +	 * @dst: destination register
> +	 * @sym: name of the symbol
> +	 */
> +	.macro		adr_l, dst:req, sym:req
> +	__adldst_l	add, \dst, \sym, \dst
> +	.endm
> +
> +	/*
> +	 * ldr_l - ldr <literal> pseudo-op with unlimited range
> +	 *
> +	 * @dst: destination register
> +	 * @sym: name of the symbol
> +	 */
> +	.macro		ldr_l, dst:req, sym:req
> +	__adldst_l	ldr, \dst, \sym, \dst
> +	.endm
> +
> +	/*
> +	 * str_l - str <literal> pseudo-op with unlimited range
> +	 *
> +	 * @src: source register
> +	 * @sym: name of the symbol
> +	 * @tmp: mandatory scratch register
> +	 */
> +	.macro		str_l, src:req, sym:req, tmp:req
> +	__adldst_l	str, \src, \sym, \tmp
> +	.endm
> +
>  #endif /* __ASM_ASSEMBLER_H__ */
> -- 
> 2.11.0
> 
> 
