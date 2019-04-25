Date: Thu, 25 Apr 2019 18:26:21 +0200
From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v4 03/23] x86/mm: Introduce temporary mm structs
Message-ID: <20190425162620.GA5199@zn.tnic>
References: <20190422185805.1169-1-rick.p.edgecombe@intel.com>
 <20190422185805.1169-4-rick.p.edgecombe@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190422185805.1169-4-rick.p.edgecombe@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>, Nadav Amit <nadav.amit@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, linux_dti@icloud.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, akpm@linux-foundation.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, will.deacon@arm.com, ard.biesheuvel@linaro.org, kristen@linux.intel.com, deneen.t.dock@intel.com, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@intel.com>, Nadav Amit <namit@vmware.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Apr 22, 2019 at 11:57:45AM -0700, Rick Edgecombe wrote:
> From: Andy Lutomirski <luto@kernel.org>
> 
> Using a dedicated page-table for temporary PTEs prevents other cores
> from using - even speculatively - these PTEs, thereby providing two
> benefits:
> 
> (1) Security hardening: an attacker that gains kernel memory writing
> abilities cannot easily overwrite sensitive data.
> 
> (2) Avoiding TLB shootdowns: the PTEs do not need to be flushed in
> remote page-tables.
> 
> To do so a temporary mm_struct can be used. Mappings which are private
> for this mm can be set in the userspace part of the address-space.
> During the whole time in which the temporary mm is loaded, interrupts
> must be disabled.
> 
> The first use-case for temporary mm struct, which will follow, is for
> poking the kernel text.
> 
> [ Commit message was written by Nadav Amit ]
> 
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Dave Hansen <dave.hansen@intel.com>
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
> Tested-by: Masami Hiramatsu <mhiramat@kernel.org>
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> Signed-off-by: Nadav Amit <namit@vmware.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
>  arch/x86/include/asm/mmu_context.h | 33 ++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
> 
> diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
> index 19d18fae6ec6..d684b954f3c0 100644
> --- a/arch/x86/include/asm/mmu_context.h
> +++ b/arch/x86/include/asm/mmu_context.h
> @@ -356,4 +356,37 @@ static inline unsigned long __get_current_cr3_fast(void)
>  	return cr3;
>  }
>  
> +typedef struct {
> +	struct mm_struct *prev;
> +} temp_mm_state_t;
> +
> +/*
> + * Using a temporary mm allows to set temporary mappings that are not accessible
> + * by other cores. Such mappings are needed to perform sensitive memory writes

s/cores/CPUs/g

Yeah, the concept of a thread of execution we call a CPU in the kernel,
I'd say. No matter if it is one of the hyperthreads or a single thread
in core.

> + * that override the kernel memory protections (e.g., W^X), without exposing the
> + * temporary page-table mappings that are required for these write operations to
> + * other cores.

Ditto.

>  Using temporary mm also allows to avoid TLB shootdowns when the

Using a ..

> + * mapping is torn down.
> + *

Nice commenting.

> + * Context: The temporary mm needs to be used exclusively by a single core. To
> + *          harden security IRQs must be disabled while the temporary mm is
			      ^
			      ,

> + *          loaded, thereby preventing interrupt handler bugs from overriding
> + *          the kernel memory protection.
> + */
> +static inline temp_mm_state_t use_temporary_mm(struct mm_struct *mm)
> +{
> +	temp_mm_state_t state;
> +
> +	lockdep_assert_irqs_disabled();
> +	state.prev = this_cpu_read(cpu_tlbstate.loaded_mm);
> +	switch_mm_irqs_off(NULL, mm, current);
> +	return state;
> +}
> +
> +static inline void unuse_temporary_mm(temp_mm_state_t prev)
> +{
> +	lockdep_assert_irqs_disabled();
> +	switch_mm_irqs_off(NULL, prev.prev, current);

I think this code would be more readable if you call that
temp_mm_state_t variable "temp_state" and the mm_struct pointer "mm" and
then you have:

	switch_mm_irqs_off(NULL, temp_state.mm, current);

And above you'll have:

	temp_state.mm = ...

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
