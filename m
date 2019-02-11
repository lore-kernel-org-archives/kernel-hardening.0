Date: Mon, 11 Feb 2019 19:37:50 +0100
From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v2 11/20] x86/jump-label: remove support for custom poker
Message-ID: <20190211183749.GO19618@zn.tnic>
References: <20190129003422.9328-1-rick.p.edgecombe@intel.com>
 <20190129003422.9328-12-rick.p.edgecombe@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190129003422.9328-12-rick.p.edgecombe@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>, Nadav Amit <nadav.amit@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, linux_dti@icloud.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, akpm@linux-foundation.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, will.deacon@arm.com, ard.biesheuvel@linaro.org, kristen@linux.intel.com, deneen.t.dock@intel.com, Nadav Amit <namit@vmware.com>, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@intel.com>, Masami Hiramatsu <mhiramat@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jan 28, 2019 at 04:34:13PM -0800, Rick Edgecombe wrote:
> From: Nadav Amit <namit@vmware.com>
> 
> There are only two types of poking: early and breakpoint based. The use
> of a function pointer to perform poking complicates the code and is
> probably inefficient due to the use of indirect branches.
> 
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Dave Hansen <dave.hansen@intel.com>
> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Nadav Amit <namit@vmware.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
>  arch/x86/kernel/jump_label.c | 24 ++++++++----------------
>  1 file changed, 8 insertions(+), 16 deletions(-)

...

> @@ -80,16 +71,17 @@ static void __ref __jump_label_transform(struct jump_entry *entry,
>  		bug_at((void *)jump_entry_code(entry), line);
>  
>  	/*
> -	 * Make text_poke_bp() a default fallback poker.
> +	 * As long as we're UP and not yet marked RO, we can use
> +	 * text_poke_early; SYSTEM_BOOTING guarantees both, as we switch to
> +	 * SYSTEM_SCHEDULING before going either.

s/going/doing/ ?

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
