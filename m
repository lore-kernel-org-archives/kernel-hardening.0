Date: Tue, 11 Jul 2017 21:04:04 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170711200404.GA7472@leverpostej>
References: <1499724283-30719-1-git-send-email-labbott@redhat.com>
 <1499724283-30719-3-git-send-email-labbott@redhat.com>
 <20170711195154.GA7124@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170711195154.GA7124@leverpostej>
Subject: Re: [kernel-hardening] Re: [RFC][PATCH 2/2] arm64: Clear the stack
To: Laura Abbott <labbott@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Alex Popov <alex.popov@linux.com>, kernel-hardening@lists.openwall.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jul 11, 2017 at 08:51:55PM +0100, Mark Rutland wrote:
> On Mon, Jul 10, 2017 at 03:04:43PM -0700, Laura Abbott wrote:
> > +	/* Reset the lowest stack to the top of the stack */
> > +7:
> > +	ldr	x1, [x0, TSK_STACK]
> > +	add	x1, x1, #THREAD_SIZE
> > +	sub	x1, x1, #256
> > +	str	x1, [x0, #TSK_TI_LOWEST_STACK]
> 
> I take it this is the offsetting you were querying?
> 
> I don't think it's quite right. Our stack looks like:
> 
> +---+ <- task_stack_page(p) + THREAD_SIZE
> |   |
> +---+ <- task_stack_page(p) + THREAD_START_SP
> |   |
> |   |
> +---+ <- task_pt_regs(p)
> |   |
> |   |
> |   |
> ~~~~~
> 
> ~~~~~
> |   |
> |   |
> |   |
> +---+ <- task_stack_page(p)
> 
> At the point we return to userspace, sp == task_pt_regs(p).
> 
> Judging by a generated asm-offsets.h, sizeof(struct_pt_regs) is 304
> bytes currently. THREAD_SIZE - THREAD_START_SP == 16.
> 
> We probably want to give that 16 a mnemonic (e.g FRAME_PADDING), and
> have something like:
> 
> 	ldr     x1, [x0, TSK_STACK]
> 	add	x1, x1, #THREAD_SIZE
> 	sub	x1, x1, #(S_FRAME_SIZE + FRAME_PADDING)
> 	str	x1, [x0, #TSK_TI_LOWEST_STACK]

Thinking about it, given that sp == task_pt_regs(p), we could just do:

	mov	x1, sp
	str     x1, [x0, #TSK_TI_LOWEST_STACK]

... unless I've managed to lose the plot here.

Mark.
