Date: Mon, 11 Feb 2019 19:29:56 +0100
From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v2 10/20] x86: avoid W^X being broken during modules
 loading
Message-ID: <20190211182956.GN19618@zn.tnic>
References: <20190129003422.9328-1-rick.p.edgecombe@intel.com>
 <20190129003422.9328-11-rick.p.edgecombe@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190129003422.9328-11-rick.p.edgecombe@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>, Nadav Amit <nadav.amit@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, linux_dti@icloud.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, akpm@linux-foundation.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, will.deacon@arm.com, ard.biesheuvel@linaro.org, kristen@linux.intel.com, deneen.t.dock@intel.com, Nadav Amit <namit@vmware.com>, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@intel.com>, Masami Hiramatsu <mhiramat@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

> Subject: Re: [PATCH v2 10/20] x86: avoid W^X being broken during modules loading

For your next submission, please fix all your subjects:

The tip tree preferred format for patch subject prefixes is
'subsys/component:', e.g. 'x86/apic:', 'x86/mm/fault:', 'sched/fair:',
'genirq/core:'. Please do not use file names or complete file paths as
prefix. 'git log path/to/file' should give you a reasonable hint in most
cases.

The condensed patch description in the subject line should start with a
uppercase letter and should be written in imperative tone.


On Mon, Jan 28, 2019 at 04:34:12PM -0800, Rick Edgecombe wrote:
> From: Nadav Amit <namit@vmware.com>
> 
> When modules and BPF filters are loaded, there is a time window in
> which some memory is both writable and executable. An attacker that has
> already found another vulnerability (e.g., a dangling pointer) might be
> able to exploit this behavior to overwrite kernel code.
> 
> Prevent having writable executable PTEs in this stage. In addition,
> avoiding having W+X mappings can also slightly simplify the patching of
> modules code on initialization (e.g., by alternatives and static-key),
> as would be done in the next patch.
> 
> To avoid having W+X mappings, set them initially as RW (NX) and after
> they are set as RO set them as X as well. Setting them as executable is
> done as a separate step to avoid one core in which the old PTE is cached
> (hence writable), and another which sees the updated PTE (executable),
> which would break the W^X protection.
> 
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Dave Hansen <dave.hansen@intel.com>
> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Suggested-by: Andy Lutomirski <luto@amacapital.net>
> Signed-off-by: Nadav Amit <namit@vmware.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
>  arch/x86/kernel/alternative.c | 28 +++++++++++++++++++++-------
>  arch/x86/kernel/module.c      |  2 +-
>  include/linux/filter.h        |  2 +-
>  kernel/module.c               |  5 +++++
>  4 files changed, 28 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> index 76d482a2b716..69f3e650ada8 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -667,15 +667,29 @@ void __init alternative_instructions(void)
>   * handlers seeing an inconsistent instruction while you patch.
>   */
>  void *__init_or_module text_poke_early(void *addr, const void *opcode,
> -					      size_t len)
> +				       size_t len)
>  {
>  	unsigned long flags;
> -	local_irq_save(flags);
> -	memcpy(addr, opcode, len);
> -	local_irq_restore(flags);
> -	sync_core();
> -	/* Could also do a CLFLUSH here to speed up CPU recovery; but
> -	   that causes hangs on some VIA CPUs. */
> +
> +	if (static_cpu_has(X86_FEATURE_NX) &&

Not a fast path - boot_cpu_has() is fine here.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
