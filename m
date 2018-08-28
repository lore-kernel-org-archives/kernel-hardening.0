Date: Wed, 29 Aug 2018 08:32:24 +0900
From: Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [PATCH v3 1/7] x86: refactor kprobes_fault() like
 kprobe_exceptions_notify()
Message-Id: <20180829083224.6b01b8f04872855d90c4786a@kernel.org>
In-Reply-To: <20180828201421.157735-2-jannh@google.com>
References: <20180828201421.157735-1-jannh@google.com>
	<20180828201421.157735-2-jannh@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Andy Lutomirski <luto@kernel.org>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, dvyukov@google.com, Masami Hiramatsu <mhiramat@kernel.org>, "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>, Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>, "David S. Miller" <davem@davemloft.net>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Borislav Petkov <bp@alien8.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 28 Aug 2018 22:14:15 +0200
Jann Horn <jannh@google.com> wrote:

> This is an extension of commit b506a9d08bae ("x86: code clarification patch
> to Kprobes arch code"). As that commit explains, even though
> kprobe_running() can't be called with preemption enabled, you don't have to
> disable preemption - if preemption is on, you can't be in a kprobe.
> 
> Also, use X86_TRAP_PF instead of 14.
> 
> Signed-off-by: Jann Horn <jannh@google.com>
> ---
> v3:
>  - avoid unnecessary branch on return value and split up the checks
>    (Borislav Petkov)
> 
>  arch/x86/mm/fault.c | 24 +++++++++++++-----------
>  1 file changed, 13 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index b9123c497e0a..bcdaae1d5bf5 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -44,17 +44,19 @@ kmmio_fault(struct pt_regs *regs, unsigned long addr)
>  
>  static nokprobe_inline int kprobes_fault(struct pt_regs *regs)
>  {
> -	int ret = 0;
> -
> -	/* kprobe_running() needs smp_processor_id() */
> -	if (kprobes_built_in() && !user_mode(regs)) {
> -		preempt_disable();
> -		if (kprobe_running() && kprobe_fault_handler(regs, 14))
> -			ret = 1;
> -		preempt_enable();
> -	}
> -
> -	return ret;
> +	if (!kprobes_built_in())
> +		return 0;
> +	if (user_mode(regs))
> +		return 0;
> +	/*
> +	 * To be potentially processing a kprobe fault and to be allowed to call
> +	 * kprobe_running(), we have to be non-preemptible.

Good catch!

Acked-by: Masami Hiramatsu <mhiramat@kernel.org>

Thanks!

> +	 */
> +	if (preemptible())
> +		return 0;
> +	if (!kprobe_running())
> +		return 0;
> +	return kprobe_fault_handler(regs, X86_TRAP_PF);
>  }
>  
>  /*
> -- 
> 2.19.0.rc0.228.g281dcd1b4d0-goog
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
