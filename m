Date: Tue, 15 Aug 2017 12:10:32 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
Message-ID: <20170815111031.xbga45isn5gumeni@armageddon.cambridge.arm.com>
References: <1502130965-18710-1-git-send-email-mark.rutland@arm.com>
 <1502130965-18710-15-git-send-email-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1502130965-18710-15-git-send-email-mark.rutland@arm.com>
Subject: [kernel-hardening] Re: [PATCH 14/14] arm64: add VMAP_STACK overflow detection
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, keescook@chromium.org, ard.biesheuvel@linaro.org, matt@codeblueprint.co.uk, kernel-hardening@lists.openwall.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, luto@amacapital.net, james.morse@arm.com, labbott@redhat.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 07, 2017 at 07:36:05PM +0100, Mark Rutland wrote:
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index e5aa866..44a27c3 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -72,6 +72,37 @@
>  	.macro kernel_ventry	label
>  	.align 7
>  	sub	sp, sp, #S_FRAME_SIZE
> +#ifdef CONFIG_VMAP_STACK
> +	add	sp, sp, x0			// sp' = sp + x0
> +	sub	x0, sp, x0			// x0' = sp' - x0 = (sp + x0) - x0 = sp
> +	tbnz	x0, #THREAD_SHIFT, 0f
> +	sub	x0, sp, x0			// sp' - x0' = (sp + x0) - sp = x0
> +	sub	sp, sp, x0			// sp' - x0 = (sp + x0) - x0 = sp
> +	b	\label

Maybe a small comment before this hunk just to tell the user that it's
trying to test a bit in SP without corrupting a gpr. It's obvious once
you read it but not you see it for the first time ;).

> +
> +	/* Stash the original SP value in tpidr_el0 */
> +0:	msr	tpidr_el0, x0

And a comment here that on this path we no longer care about the user
tpidr_el0 as we are never returning there.

Otherwise I'm fine with the series (I'm not a fan of the complexity it
adds but I don't have a better suggestion).

-- 
Catalin
