Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 1 Jul 2016 16:59:20 +0200
From: Borislav Petkov <bp@alien8.de>
Message-ID: <20160701145920.GF4593@pd.tnic>
References: <cover.1466974736.git.luto@kernel.org>
 <fa7bc42def35d37f8237d8f9b2f1b1e05eb885b8.1466974736.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fa7bc42def35d37f8237d8f9b2f1b1e05eb885b8.1466974736.git.luto@kernel.org>
Subject: [kernel-hardening] Re: [PATCH v4 09/29] fork: Add generic vmalloced stack support
To: Andy Lutomirski <luto@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Oleg Nesterov <oleg@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jun 26, 2016 at 02:55:31PM -0700, Andy Lutomirski wrote:
> If CONFIG_VMAP_STACK is selected, kernel stacks are allocated with
> vmalloc_node.
> 
> grsecurity has had a similar feature (called
> GRKERNSEC_KSTACKOVERFLOW) for a long time.
> 
> Cc: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> ---
>  arch/Kconfig                        | 29 +++++++++++++
>  arch/ia64/include/asm/thread_info.h |  2 +-
>  include/linux/sched.h               | 15 +++++++
>  kernel/fork.c                       | 87 +++++++++++++++++++++++++++++--------
>  4 files changed, 113 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 15996290fed4..18a2c3a7b460 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -661,4 +661,33 @@ config ARCH_NO_COHERENT_DMA_MMAP
>  config CPU_NO_EFFICIENT_FFS
>  	def_bool n
>  
> +config HAVE_ARCH_VMAP_STACK
> +	def_bool n
> +	help
> +	  An arch should select this symbol if it can support kernel stacks
> +	  in vmalloc space.  This means:
> +
> +	  - vmalloc space must be large enough to hold many kernel stacks.
> +	    This may rule out many 32-bit architectures.
> +
> +	  - Stacks in vmalloc space need to work reliably.  For example, if
> +	    vmap page tables are created on demand, either this mechanism
> +	    needs to work while the stack points to a virtual address with
> +	    unpopulated page tables or arch code (switch_to and switch_mm,
> +	    most likely) needs to ensure that the stack's page table entries
> +	    are populated before running on a possibly unpopulated stack.
> +
> +	  - If the stack overflows into a guard page, something reasonable
> +	    should happen.  The definition of "reasonable" is flexible, but
> +	    instantly rebooting without logging anything would be unfriendly.

Nice, I wish more people would actually *explain* their Kconfig options
properly.

...

> diff --git a/kernel/fork.c b/kernel/fork.c
> index 146c9840c079..06761de69360 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -158,19 +158,37 @@ void __weak arch_release_thread_stack(unsigned long *stack)
>   * Allocate pages if THREAD_SIZE is >= PAGE_SIZE, otherwise use a
>   * kmemcache based allocator.
>   */
> -# if THREAD_SIZE >= PAGE_SIZE
> -static unsigned long *alloc_thread_stack_node(struct task_struct *tsk,
> -						  int node)
> +# if THREAD_SIZE >= PAGE_SIZE || defined(CONFIG_VMAP_STACK)
> +static unsigned long *alloc_thread_stack_node(struct task_struct *tsk, int node)
>  {
> +#ifdef CONFIG_VMAP_STACK
> +	void *stack = __vmalloc_node_range(
> +		THREAD_SIZE, THREAD_SIZE, VMALLOC_START, VMALLOC_END,
> +		THREADINFO_GFP | __GFP_HIGHMEM, PAGE_KERNEL,
> +		0, node, __builtin_return_address(0));

Reformat:

        void *stack = __vmalloc_node_range(THREAD_SIZE, THREAD_SIZE,
                                           VMALLOC_START, VMALLOC_END,
                                           THREADINFO_GFP | __GFP_HIGHMEM,
                                           PAGE_KERNEL,
                                           0, node, __builtin_return_address(0));


> +
> +	/*
> +	 * We can't call find_vm_area() in interrupt context, and
> +	 * free_thread_info can be called in interrupt context, so cache

free_thread_stack() ?

> +	 * the vm_struct.
> +	 */
> +	if (stack)
> +		tsk->stack_vm_area = find_vm_area(stack);
> +	return stack;
> +#else
>  	struct page *page = alloc_kmem_pages_node(node, THREADINFO_GFP,
>  						  THREAD_SIZE_ORDER);
>  
>  	return page ? page_address(page) : NULL;
> +#endif
>  }
>  
> -static inline void free_thread_stack(unsigned long *stack)
> +static inline void free_thread_stack(struct task_struct *tsk)
>  {
> -	free_kmem_pages((unsigned long)stack, THREAD_SIZE_ORDER);
> +	if (task_stack_vm_area(tsk))
> +		vfree(tsk->stack);
> +	else
> +		free_kmem_pages((unsigned long)tsk->stack, THREAD_SIZE_ORDER);
>  }
>  # else
>  static struct kmem_cache *thread_stack_cache;
> @@ -181,9 +199,9 @@ static unsigned long *alloc_thread_stack_node(struct task_struct *tsk,
>  	return kmem_cache_alloc_node(thread_stack_cache, THREADINFO_GFP, node);
>  }
>  
> -static void free_thread_stack(unsigned long *stack)
> +static void free_thread_stack(struct task_struct *tsk)
>  {
> -	kmem_cache_free(thread_stack_cache, stack);
> +	kmem_cache_free(thread_stack_cache, tsk->stack);
>  }
>  
>  void thread_stack_cache_init(void)
> @@ -213,24 +231,49 @@ struct kmem_cache *vm_area_cachep;
>  /* SLAB cache for mm_struct structures (tsk->mm) */
>  static struct kmem_cache *mm_cachep;
>  
> -static void account_kernel_stack(unsigned long *stack, int account)
> +static void account_kernel_stack(struct task_struct *tsk, int account)
>  {
> -	/* All stack pages are in the same zone and belong to the same memcg. */
> -	struct page *first_page = virt_to_page(stack);
> +	void *stack = task_stack_page(tsk);
> +	struct vm_struct *vm = task_stack_vm_area(tsk);
> +
> +	BUILD_BUG_ON(IS_ENABLED(CONFIG_VMAP_STACK) && PAGE_SIZE % 1024 != 0);
> +
> +	if (vm) {
> +		int i;
>  
> -	mod_zone_page_state(page_zone(first_page), NR_KERNEL_STACK_KB,
> -			    THREAD_SIZE / 1024 * account);
> +		BUG_ON(vm->nr_pages != THREAD_SIZE / PAGE_SIZE);
>  
> -	memcg_kmem_update_page_stat(
> -		first_page, MEMCG_KERNEL_STACK_KB,
> -		account * (THREAD_SIZE / 1024));
> +		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++) {
> +			mod_zone_page_state(page_zone(vm->pages[i]),
> +					    NR_KERNEL_STACK_KB,
> +					    PAGE_SIZE / 1024 * account);
> +		}
> +
> +		/* All stack pages belong to the same memcg. */
> +		memcg_kmem_update_page_stat(
> +			vm->pages[0], MEMCG_KERNEL_STACK_KB,
> +			account * (THREAD_SIZE / 1024));

Formatting:

		function_name(arg0, arg1,
			      arg2, arg3, ...);

> +	} else {
> +		/*
> +		 * All stack pages are in the same zone and belong to the
> +		 * same memcg.
> +		 */
> +		struct page *first_page = virt_to_page(stack);
> +
> +		mod_zone_page_state(page_zone(first_page), NR_KERNEL_STACK_KB,
> +				    THREAD_SIZE / 1024 * account);
> +
> +		memcg_kmem_update_page_stat(
> +			first_page, MEMCG_KERNEL_STACK_KB,
> +			account * (THREAD_SIZE / 1024));

Ditto.

> +	}
>  }
>  
>  void free_task(struct task_struct *tsk)
>  {
> -	account_kernel_stack(tsk->stack, -1);
> +	account_kernel_stack(tsk, -1);
>  	arch_release_thread_stack(tsk->stack);
> -	free_thread_stack(tsk->stack);
> +	free_thread_stack(tsk);
>  	rt_mutex_debug_task_free(tsk);
>  	ftrace_graph_exit_task(tsk);
>  	put_seccomp_filter(tsk);
-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
