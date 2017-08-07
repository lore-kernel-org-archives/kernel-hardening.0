Date: Mon, 7 Aug 2017 23:00:56 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170807220056.GA29059@remoulade>
References: <20170807203948.GA22298@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170807203948.GA22298@beast>
Subject: [kernel-hardening] Re: [PATCH] lkdtm: Test VMAP_STACK allocates leading/trailing guard
 pages
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, ard.biesheuvel@linaro.org, catalin.marinas@arm.com, james.morse@arm.com, labbott@redhat.com, luto@amacapital.net, matt@codeblueprint.co.uk, will.deacon@arm.com, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On Mon, Aug 07, 2017 at 01:39:48PM -0700, Kees Cook wrote:
> Two new tests STACK_GUARD_PAGE_LEADING and STACK_GUARD_PAGE_TRAILING
> attempt to read the byte before and after, respectively, of the current
> stack frame, which should fault under VMAP_STACK.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> Do these tests both trip with the new arm64 VMAP_STACK code?

> +/* Test that VMAP_STACK is actually allocating with a leading guard page */
> +void lkdtm_STACK_GUARD_PAGE_LEADING(void)
> +{
> +	const unsigned char *stack = task_stack_page(current);
> +	const unsigned char *ptr = stack - 1;
> +	volatile unsigned char byte;
> +
> +	pr_info("attempting bad read from page below current stack\n");
> +
> +	byte = *ptr;
> +
> +	pr_err("FAIL: accessed page before stack!\n");
> +}
> +
> +/* Test that VMAP_STACK is actually allocating with a trailing guard page */
> +void lkdtm_STACK_GUARD_PAGE_TRAILING(void)
> +{
> +	const unsigned char *stack = task_stack_page(current);
> +	const unsigned char *ptr = stack + THREAD_SIZE;
> +	volatile unsigned char byte;
> +
> +	pr_info("attempting bad read from page above current stack\n");
> +
> +	byte = *ptr;
> +
> +	pr_err("FAIL: accessed page after stack!\n");
> +}

I can give these a go tomorrow.

These *should* fault, and IIUC should trigger the usual "Unable to handle
kernel %s at virtual address %08lx\n" splat from arm64's __do_kernel_fault(),
which should end up with an Oops().

Since these don't mess with the SP, they shouldn't trigger the overflow
detection, which detects whether we have sufficient stack space to store the
exception context to the stack. That caught the LKDTM overflow test reliably.

Thanks,
Mark.
