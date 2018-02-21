Date: Wed, 21 Feb 2018 11:29:33 +0100
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v2] fork: Unconditionally clear stack on fork
Message-ID: <20180221102933.GD2231@dhcp22.suse.cz>
References: <20180221021659.GA37073@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180221021659.GA37073@beast>
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Laura Abbott <labbott@redhat.com>, Rasmus Villemoes <rasmus.villemoes@prevas.dk>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue 20-02-18 18:16:59, Kees Cook wrote:
> One of the classes of kernel stack content leaks[1] is exposing the
> contents of prior heap or stack contents when a new process stack is
> allocated. Normally, those stacks are not zeroed, and the old contents
> remain in place. In the face of stack content exposure flaws, those
> contents can leak to userspace.
> 
> Fixing this will make the kernel no longer vulnerable to these flaws,
> as the stack will be wiped each time a stack is assigned to a new
> process. There's not a meaningful change in runtime performance; it
> almost looks like it provides a benefit.
> 
> Performing back-to-back kernel builds before:
> 	Run times: 157.86 157.09 158.90 160.94 160.80
> 	Mean: 159.12
> 	Std Dev: 1.54
> 
> and after:
> 	Run times: 159.31 157.34 156.71 158.15 160.81
> 	Mean: 158.46
> 	Std Dev: 1.46

/bin/true or similar would be more representative for the worst case
but it is good to see that this doesn't have any visible effect on
a more real usecase.

> Instead of making this a build or runtime config, Andy Lutomirski
> recommended this just be enabled by default.
> 
> [1] A noisy search for many kinds of stack content leaks can be seen here:
> https://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=linux+kernel+stack+leak
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  include/linux/thread_info.h | 6 +-----
>  kernel/fork.c               | 3 +--
>  2 files changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
> index 34f053a150a9..cf2862bd134a 100644
> --- a/include/linux/thread_info.h
> +++ b/include/linux/thread_info.h
> @@ -43,11 +43,7 @@ enum {
>  #define THREAD_ALIGN	THREAD_SIZE
>  #endif
>  
> -#if IS_ENABLED(CONFIG_DEBUG_STACK_USAGE) || IS_ENABLED(CONFIG_DEBUG_KMEMLEAK)
> -# define THREADINFO_GFP		(GFP_KERNEL_ACCOUNT | __GFP_ZERO)
> -#else
> -# define THREADINFO_GFP		(GFP_KERNEL_ACCOUNT)
> -#endif
> +#define THREADINFO_GFP		(GFP_KERNEL_ACCOUNT | __GFP_ZERO)
>  
>  /*
>   * flag set/clear/test wrappers
> diff --git a/kernel/fork.c b/kernel/fork.c
> index be8aa5b98666..4f2ee527c7d2 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -216,10 +216,9 @@ static unsigned long *alloc_thread_stack_node(struct task_struct *tsk, int node)
>  		if (!s)
>  			continue;
>  
> -#ifdef CONFIG_DEBUG_KMEMLEAK
>  		/* Clear stale pointers from reused stack. */
>  		memset(s->addr, 0, THREAD_SIZE);
> -#endif
> +
>  		tsk->stack_vm_area = s;
>  		return s->addr;
>  	}
> -- 
> 2.7.4
> 
> 
> -- 
> Kees Cook
> Pixel Security

-- 
Michal Hocko
SUSE Labs
