Date: Mon, 14 Aug 2017 18:13:39 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
Message-ID: <20170814171338.gvtn76awussgxctn@armageddon.cambridge.arm.com>
References: <1502130965-18710-1-git-send-email-mark.rutland@arm.com>
 <1502130965-18710-11-git-send-email-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1502130965-18710-11-git-send-email-mark.rutland@arm.com>
Subject: [kernel-hardening] Re: [PATCH 10/14] arm64: assembler: allow adr_this_cpu to use the
 stack pointer
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, keescook@chromium.org, ard.biesheuvel@linaro.org, matt@codeblueprint.co.uk, kernel-hardening@lists.openwall.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, luto@amacapital.net, james.morse@arm.com, labbott@redhat.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 07, 2017 at 07:36:01PM +0100, Mark Rutland wrote:
> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> 
> Given that adr_this_cpu already requires a temp register in addition
> to the destination register, tweak the instruction sequence so that sp
> may be used as well.
> 
> This will simplify switching to per-cpu stacks in subsequent patches. While
> this limits the range of adr_this_cpu, to +/-4GiB, we don't currently use
> adr_this_cpu in modules, and this is not problematic for the main kernel image.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> [Mark: add more commit text]
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: James Morse <james.morse@arm.com>
> Cc: Laura Abbott <labbott@redhat.com>
> Cc: Will Deacon <will.deacon@arm.com>
> ---
>  arch/arm64/include/asm/assembler.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
> index 610a420..4775af5 100644
> --- a/arch/arm64/include/asm/assembler.h
> +++ b/arch/arm64/include/asm/assembler.h
> @@ -235,7 +235,8 @@
>  	 * @tmp: scratch register
>  	 */
>  	.macro adr_this_cpu, dst, sym, tmp
> -	adr_l	\dst, \sym
> +	adrp	\tmp, \sym
> +	add	\dst, \tmp, #:lo12:\sym
>  	mrs	\tmp, tpidr_el1
>  	add	\dst, \dst, \tmp
>  	.endm

Nitpick: it may be worth adding an #ifndef MODULE around these macros,
together with a comment, just in case. There are other macros in this
file like adr_l which are used in modules (crypto).

-- 
Catalin
