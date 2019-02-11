Date: Mon, 11 Feb 2019 19:22:21 +0100
From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v2 09/20] x86/kprobes: instruction pages initialization
 enhancements
Message-ID: <20190211182221.GM19618@zn.tnic>
References: <20190129003422.9328-1-rick.p.edgecombe@intel.com>
 <20190129003422.9328-10-rick.p.edgecombe@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190129003422.9328-10-rick.p.edgecombe@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>, Nadav Amit <nadav.amit@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, linux_dti@icloud.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, akpm@linux-foundation.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, will.deacon@arm.com, ard.biesheuvel@linaro.org, kristen@linux.intel.com, deneen.t.dock@intel.com, Nadav Amit <namit@vmware.com>
List-ID: <kernel-hardening.lists.openwall.com>

Only nitpicks:

> Subject: Re: [PATCH v2 09/20] x86/kprobes: instruction pages initialization enhancements

Subject needs a verb.

On Mon, Jan 28, 2019 at 04:34:11PM -0800, Rick Edgecombe wrote:
> From: Nadav Amit <namit@vmware.com>
> 
> Make kprobes instruction pages read-only (and executable) after they are
> set to prevent them from mistaken or malicious modifications.
> 
> This is a preparatory patch for a following patch that makes module
> allocated pages non-executable and sets the page as executable after
> allocation.
> 
> While at it, do some small cleanup of what appears to be unnecessary
> masking.
> 
> Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
> Signed-off-by: Nadav Amit <namit@vmware.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
>  arch/x86/kernel/kprobes/core.c | 24 ++++++++++++++++++++----
>  1 file changed, 20 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
> index 4ba75afba527..fac692e36833 100644
> --- a/arch/x86/kernel/kprobes/core.c
> +++ b/arch/x86/kernel/kprobes/core.c
> @@ -431,8 +431,20 @@ void *alloc_insn_page(void)
>  	void *page;
>  
>  	page = module_alloc(PAGE_SIZE);
> -	if (page)
> -		set_memory_ro((unsigned long)page & PAGE_MASK, 1);
> +	if (page == NULL)
> +		return NULL;

Null tests we generally do like this:

	if (! ...


like in the rest of this file.

> +
> +	/*
> +	 * First make the page read-only, and then only then make it executable

 s/then only then/only then/

ditto below.

> +	 * to prevent it from being W+X in between.
> +	 */
> +	set_memory_ro((unsigned long)page, 1);
> +
> +	/*
> +	 * TODO: Once additional kernel code protection mechanisms are set, ensure
> +	 * that the page was not maliciously altered and it is still zeroed.
> +	 */
> +	set_memory_x((unsigned long)page, 1);
>  
>  	return page;
>  }
> @@ -440,8 +452,12 @@ void *alloc_insn_page(void)
>  /* Recover page to RW mode before releasing it */
>  void free_insn_page(void *page)
>  {
> -	set_memory_nx((unsigned long)page & PAGE_MASK, 1);
> -	set_memory_rw((unsigned long)page & PAGE_MASK, 1);
> +	/*
> +	 * First make the page non-executable, and then only then make it
> +	 * writable to prevent it from being W+X in between.
> +	 */
> +	set_memory_nx((unsigned long)page, 1);
> +	set_memory_rw((unsigned long)page, 1);
>  	module_memfree(page);
>  }
>  
> -- 

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
