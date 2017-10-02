Date: Mon, 2 Oct 2017 11:42:05 +0100
From: Will Deacon <will.deacon@arm.com>
Message-ID: <20171002104205.GC3823@arm.com>
References: <1506816410-10230-1-git-send-email-me@tobin.cc>
 <1506816410-10230-3-git-send-email-me@tobin.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1506816410-10230-3-git-send-email-me@tobin.cc>
Subject: Re: [kernel-hardening] [RFC V2 2/6] lib: vsprintf: whitelist stack
 traces
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Steven Rostedt <rostedt@goodmis.org>, William Roberts <william.c.roberts@intel.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Oct 01, 2017 at 11:06:46AM +1100, Tobin C. Harding wrote:
> Use the %pP functionality to explicitly allow kernel
> pointers to be logged for stack traces.
> 
> Signed-off-by: Tobin C. Harding <me@tobin.cc>
> ---
>  arch/arm64/kernel/traps.c | 4 ++--
>  kernel/printk/printk.c    | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
> index 5ea4b85..fe09660 100644
> --- a/arch/arm64/kernel/traps.c
> +++ b/arch/arm64/kernel/traps.c
> @@ -147,7 +147,7 @@ void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk)
>  	struct stackframe frame;
>  	int skip;
>  
> -	pr_debug("%s(regs = %p tsk = %p)\n", __func__, regs, tsk);
> +	pr_debug("%s(regs = %pP tsk = %pP)\n", __func__, regs, tsk);

Why do we care for pr_debug?

>  	if (!tsk)
>  		tsk = current;
> @@ -233,7 +233,7 @@ static int __die(const char *str, int err, struct pt_regs *regs)
>  
>  	print_modules();
>  	__show_regs(regs);
> -	pr_emerg("Process %.*s (pid: %d, stack limit = 0x%p)\n",
> +	pr_emerg("Process %.*s (pid: %d, stack limit = 0x%pP)\n",
>  		 TASK_COMM_LEN, tsk->comm, task_pid_nr(tsk),
>  		 end_of_stack(tsk));
>  
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index 512f7c2..af0bc8e 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c

It probably makes sense to keep this separate from arch/ changes

Will
