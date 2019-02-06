Date: Wed, 6 Feb 2019 11:22:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 08/17] x86/ftrace: set trampoline pages as executable
Message-ID: <20190206112213.2ec9dd5c@gandalf.local.home>
In-Reply-To: <20190117003259.23141-9-rick.p.edgecombe@intel.com>
References: <20190117003259.23141-1-rick.p.edgecombe@intel.com>
	<20190117003259.23141-9-rick.p.edgecombe@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, linux_dti@icloud.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, akpm@linux-foundation.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, will.deacon@arm.com, ard.biesheuvel@linaro.org, kristen@linux.intel.com, deneen.t.dock@intel.com, Nadav Amit <namit@vmware.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 16 Jan 2019 16:32:50 -0800
Rick Edgecombe <rick.p.edgecombe@intel.com> wrote:

> From: Nadav Amit <namit@vmware.com>
> 
> Since alloc_module() will not set the pages as executable soon, we need
> to do so for ftrace trampoline pages after they are allocated.
> 
> For the time being, we do not change ftrace to use the text_poke()
> interface. As a result, ftrace breaks still breaks W^X.
> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Nadav Amit <namit@vmware.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
>  arch/x86/kernel/ftrace.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index 8257a59704ae..eb4a1937e72c 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -742,6 +742,7 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
>  	unsigned long end_offset;
>  	unsigned long op_offset;
>  	unsigned long offset;
> +	unsigned long npages;
>  	unsigned long size;
>  	unsigned long retq;
>  	unsigned long *ptr;
> @@ -774,6 +775,7 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
>  		return 0;
>  
>  	*tramp_size = size + RET_SIZE + sizeof(void *);
> +	npages = DIV_ROUND_UP(*tramp_size, PAGE_SIZE);
>  
>  	/* Copy ftrace_caller onto the trampoline memory */
>  	ret = probe_kernel_read(trampoline, (void *)start_offset, size);
> @@ -818,6 +820,13 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
>  	/* ALLOC_TRAMP flags lets us know we created it */
>  	ops->flags |= FTRACE_OPS_FL_ALLOC_TRAMP;
>  
> +	/*
> +	 * Module allocation needs to be completed by making the page
> +	 * executable. The page is still writable, which is a security hazard,
> +	 * but anyhow ftrace breaks W^X completely.
> +	 */

Perhaps we should set the page to non writable after the page is
updated? And set it to writable only when we need to update it.

As for this patch:

Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

-- Steve

> +	set_memory_x((unsigned long)trampoline, npages);
> +
>  	return (unsigned long)trampoline;
>  fail:
>  	tramp_free(trampoline, *tramp_size);
