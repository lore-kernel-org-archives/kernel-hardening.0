Date: Tue, 20 Nov 2018 16:50:37 -0700
From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [RFC PATCH 4/6] x86/speculation, mm: add process local virtual
 memory region
Message-ID: <20181120235037.GB13641@cisco>
References: <cover.1542710668.git.jsteckli@amazon.de>
 <717f82f41dd541512edb0eb60afde8983377340d.1542710668.git.jsteckli@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <717f82f41dd541512edb0eb60afde8983377340d.1542710668.git.jsteckli@amazon.de>
To: Julian Stecklina <jsteckli@amazon.de>
Cc: kernel-hardening@lists.openwall.com, Liran Alon <liran.alon@oracle.com>, Jonathan Adams <jwadams@google.com>, David Woodhouse <dwmw2@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 20, 2018 at 03:10:25PM +0100, Julian Stecklina wrote:
> The Linux kernel has a global address space that is the same for any
> kernel code. This address space becomes a liability in a world with
> processor information leak vulnerabilities, such as L1TF. With the right
> cache load gadget, an attacker-controlled hyperthread pair can leak
> arbitrary data via L1TF. The upstream Linux kernel currently suggests
> disabling hyperthread, but this comes with a large performance hit for a
> wide range of workloads.
> 
> An alternative mitigation is to not make certain data in the kernel
> globally visible, but only when the kernel executes in the context of
> the process where this data belongs to.
> 
> This patch adds the initial plumbing for allocating process-local
> memory. By grabbing one entry in the PML4 of each set of page tables and
> start treating it as process-local memory. We currently only support 2MB
> of process-local allocations, but this is an arbitrary limitation and
> can be lifted by working on the page table allocation code.
> 
> While memory is used for process-local allocations, it is unmapped from
> the linear mapping of physical memory.
> 
> The code has some limitations that are spelled out in
> arch/x86/mm/proclocal.c.

Cool!

> +static int fault_in_process_local(unsigned long address)
> +{
> +#ifdef CONFIG_PROCLOCAL
> +	return address >= PROCLOCAL_START && address <= PROCLOCAL_END;
> +#else
> +	return false;
> +#endif
> +}
> +

I think the kernel style for this is something like

#ifdef CONFIG_PROCLOCAL
static bool fault_in_process_local(...) {
    ...
}
#else
static bool fault_in_process_local(...) {
    return false;
}

We should probably change the return type to bool, or return 0 there.

>  static inline bool smap_violation(int error_code, struct pt_regs *regs)
>  {
>  	if (!IS_ENABLED(CONFIG_X86_SMAP))
> @@ -1240,6 +1249,11 @@ __do_page_fault(struct pt_regs *regs, unsigned long error_code,
>  	 * protection error (error_code & 9) == 0.
>  	 */
>  	if (unlikely(fault_in_kernel_space(address))) {
> +
> +		if (unlikely(fault_in_process_local(address))) {
> +			BUG();

Do we really need a separate BUG() here? People don't like BUG() :) Can
we just let the flow all the way to no_context() and do some
annotation there?

> +int kalloc_proclocal(struct proclocal *pl, size_t len)
> +{
> +	struct mm_struct *mm = current->mm;
> +	size_t nr_pages = round_up(len, PAGE_SIZE) / PAGE_SIZE;
> +	int order, free_page_off;
> +	unsigned long vaddr;
> +	size_t i;
> +	
> +	PRL_DBG("%s: mm=%lx len=%zu -> nr_pages=%zu\n",
> +		(unsigned long)mm, len, nr_pages);
> +
> +	might_sleep();
> +	BUG_ON(!mm);

It's sort of unfortunate that you couldn't use this in kernel threads.
I'm not sure if there are any kernel threads with secrets to protect,
but I suppose there are some. I wonder if we can't do something like
the prmem patches where we reserve a small special section for this or
something?

> +
> +	if (len == 0)
> +		goto fail;
> +
> +	down_write(&mm->mmap_sem);
> +
> +	if (mm->proclocal_in_use_pages == 0 && proclocal_init(mm))
> +		goto fail_unlock;
> +
> +	order = get_count_order(nr_pages);
> +	nr_pages = 1U << order;
> +
> +	free_page_off = bitmap_find_free_region(mm->proclocal_bitmap, MAX_PROCLOCAL_PAGES, order);

Here and a few other places in the series there's some > 80 char
lines.

Cheers,

Tycho
