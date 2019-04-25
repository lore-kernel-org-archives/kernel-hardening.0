Date: Thu, 25 Apr 2019 14:28:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v4 19/23] x86/ftrace: Use vmalloc special flag
Message-ID: <20190425142803.4f2e354a@gandalf.local.home>
In-Reply-To: <20190422185805.1169-20-rick.p.edgecombe@intel.com>
References: <20190422185805.1169-1-rick.p.edgecombe@intel.com>
	<20190422185805.1169-20-rick.p.edgecombe@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>, Nadav Amit <nadav.amit@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, linux_dti@icloud.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, akpm@linux-foundation.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, will.deacon@arm.com, ard.biesheuvel@linaro.org, kristen@linux.intel.com, deneen.t.dock@intel.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 22 Apr 2019 11:58:01 -0700
Rick Edgecombe <rick.p.edgecombe@intel.com> wrote:

> Use new flag VM_FLUSH_RESET_PERMS for handling freeing of special
> permissioned memory in vmalloc and remove places where memory was set NX
> and RW before freeing which is no longer needed.
> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>

Tested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Acked-by: Steven Rostedt (VMware) <rostedt@godomis.org>

-- Steve

> ---
>  arch/x86/kernel/ftrace.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index 53ba1aa3a01f..0caf8122d680 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -678,12 +678,8 @@ static inline void *alloc_tramp(unsigned long size)
>  {
>  	return module_alloc(size);
>  }
> -static inline void tramp_free(void *tramp, int size)
> +static inline void tramp_free(void *tramp)
>  {
> -	int npages = PAGE_ALIGN(size) >> PAGE_SHIFT;
> -
> -	set_memory_nx((unsigned long)tramp, npages);
> -	set_memory_rw((unsigned long)tramp, npages);
>  	module_memfree(tramp);
>  }
>  #else
> @@ -692,7 +688,7 @@ static inline void *alloc_tramp(unsigned long size)
>  {
>  	return NULL;
>  }
> -static inline void tramp_free(void *tramp, int size) { }
> +static inline void tramp_free(void *tramp) { }
>  #endif
>  
>  /* Defined as markers to the end of the ftrace default trampolines */
> @@ -808,6 +804,8 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
>  	/* ALLOC_TRAMP flags lets us know we created it */
>  	ops->flags |= FTRACE_OPS_FL_ALLOC_TRAMP;
>  
> +	set_vm_flush_reset_perms(trampoline);
> +
>  	/*
>  	 * Module allocation needs to be completed by making the page
>  	 * executable. The page is still writable, which is a security hazard,
> @@ -816,7 +814,7 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
>  	set_memory_x((unsigned long)trampoline, npages);
>  	return (unsigned long)trampoline;
>  fail:
> -	tramp_free(trampoline, *tramp_size);
> +	tramp_free(trampoline);
>  	return 0;
>  }
>  
> @@ -947,7 +945,7 @@ void arch_ftrace_trampoline_free(struct ftrace_ops *ops)
>  	if (!ops || !(ops->flags & FTRACE_OPS_FL_ALLOC_TRAMP))
>  		return;
>  
> -	tramp_free((void *)ops->trampoline, ops->trampoline_size);
> +	tramp_free((void *)ops->trampoline);
>  	ops->trampoline = 0;
>  }
>  
