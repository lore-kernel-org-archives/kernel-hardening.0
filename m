Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 3 Sep 2011 03:34:13 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110902233413.GB26494@openwall.com>
References: <20110812102954.GA3496@albatros> <20110812105824.GA7141@openwall.com> <20110825171934.GA3044@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110825171934.GA3044@albatros>
Subject: Re: [kernel-hardening] [RFC] x86, mm: start mmap allocation for libs from low addresses
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy,

Here's another set of comments from me (I ran out of time when writing
the previous message on this).

On Thu, Aug 25, 2011 at 09:19:34PM +0400, Vasiliy Kulikov wrote:
> +++ b/arch/x86/mm/mmap.c
> @@ -118,6 +118,22 @@ static unsigned long mmap_legacy_base(void)
[...]
> +static unsigned long mmap_lib_base(void)
> +{
> +	return ASCII_ARMOR_MIN_ADDR + mmap_rnd();
> +}

I was about to suggest that you declare this function inline, but then I
noticed that all other tiny and single-use functions in
arch/x86/mm/mmap.c are also non-inline.  Weird.  You might want to bring
this up on LKML separately.

> @@ -131,6 +147,10 @@ void arch_pick_mmap_layout(struct mm_struct *mm)
>  	} else {
>  		mm->mmap_base = mmap_base();
>  		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
> +		if (mmap_is_ia32()) {
> +			mm->get_unmapped_exec_area = get_unmapped_exec_area;
> +			mm->lib_mmap_base = mmap_lib_base();
> +		}
>  		mm->unmap_area = arch_unmap_area_topdown;
>  	}

Are you sure it's safe to leave get_unmapped_exec_area and lib_mmap_base
uninitialized when !mmap_is_ia32()?  Is there implicit initialization to
NULL before this point maybe?  (I did not check.)

> +/* Addresses before this value contain at least one zero byte. */
> +#define ASCII_ARMOR_MAX_ADDR 0x01000000
> +
> +/*
> + * This function finds the first unmapped region inside of
> + * [mm->lib_mmap_base; ASCII_ARMOR_MAX_ADDR) region.  Addresses from this
> + * region contain at least one zero byte, which greatly complicates

Maybe s/greatly // because this word is subjective, and the actual
difficulty varies for different scenarios.

> + * exploitation of C string buffer overflows (C strings cannot contain zero
> + * byte inside) in return to libc class of attacks.
> + *
> + * This allocator is bottom up allocator like arch_get_unmapped_area(), but
> + * it differs from the latter.  get_unmapped_exec_area() does its best to
> + * allocate as low address as possible.
> + */
> +unsigned long
> +get_unmapped_exec_area(struct file *filp, unsigned long addr0,
> +		unsigned long len, unsigned long pgoff, unsigned long flags)
> +{
> +	unsigned long addr = addr0;
> +	struct mm_struct *mm = current->mm;
> +	struct vm_area_struct *vma;
> +
> +	if (len > TASK_SIZE)
> +		return -ENOMEM;
> +
> +	if (flags & MAP_FIXED)
> +		return addr;

In the MAP_FIXED case, don't we need to make sure that addr is actually
available - that is, do a "goto failed" here (fallback to old handling)?

And if so, don't we need to make it the very first check - before the
would-be-redundant len check?

> +	/* We ALWAYS start from the beginning as base addresses
> +	 * with zero high bits is a valued resource */
> +	addr = max_t(unsigned long, mm->lib_mmap_base, mmap_min_addr);
> +
> +	for (vma = find_vma(mm, addr); ; vma = vma->vm_next) {
> +		/* At this point:  (!vma || addr < vma->vm_end). */
> +		if (TASK_SIZE - len < addr)
> +			return -ENOMEM;

Since this check is primarily of addr, I'd write it as:

		if (addr > TASK_SIZE - len)
			return -ENOMEM;

Also, I hope the len == 0 && addr == TASK_SIZE case that this check
happens to permit is irrelevant here.  I naively hope (well, maybe not)
that addr has been checked for "< TASK_SIZE" at a higher level. ;-)
You could want to review the current mm code for this.

> +		/* We don't want to reduce brk area of not DYNAMIC elf binaries
> +		 * with sysctl kernel.randomize_va_space < 2. */
> +		if (mm->brk && addr > mm->brk)
> +			goto failed;

Does this check come from RHEL?  I don't fully understand it.  We also
check for "vma->vm_end >= ASCII_ARMOR_MAX_ADDR" below.  Does this imply
that we choose to handle the case of mm->brk being lower than
ASCII_ARMOR_MAX_ADDR here?  Is it a practically relevant case?  Or was
this check possibly less redundant on RHEL?

(If these questions are time-consuming to find answers to, feel free to
disregard them for now.)

> +		if (!vma || addr + len <= vma->vm_start)
> +			return addr;
> +
> +		addr = vma->vm_end;
> +
> +		/* If ACSII-armor area is over, the algo gives up */
> +		if (addr >= ASCII_ARMOR_MAX_ADDR)
> +			goto failed;
> +	}
> +
> +failed:
> +	return current->mm->get_unmapped_area(filp, addr0, len, pgoff, flags);
> +}

Now, the main question: what's wrong with doing something as simple as:

unsigned long
get_unmapped_exec_area(struct file *filp, unsigned long addr,
		unsigned long len, unsigned long pgoff, unsigned long flags)
{
	return current->mm->get_unmapped_area(filp, ((flags & MAP_FIXED) || len >= 0x00ef0000UL) ? addr : max_t(unsigned long, mm->lib_mmap_base, mmap_min_addr), len, pgoff, flags);
}

Of course, written in a cleaner and more generic fashion.

This is similar to what I did in -ow patches, where I only needed to
adjust TASK_UNMAPPED_BASE turning it from a constant to a trivial macro
accepting the allocation size as input.

Doesn't current->mm->get_unmapped_area() contain a similar loop to find
the nearest hole to the supplied address?

OK, I guess this is an attempt to avoid the risk of mmap'ing something
right after the current end of the brk area, which would prevent its
further expansion, if we have lots of small executable mappings.  With
-ow patches, this risk is probably present (although I've never seen
this happen in practice).  Is that the only reason?

If so, would it possibly be cleaner (less invasive) to call
current->mm->get_unmapped_area() first (adjusting the hint like -ow
patches did), then see if the found address is suitable for use (below
brk)?  In the unlikely case when the returned address is not suitable
for use, drop the hint and call again.  OK, someone might not like the
maybe 2x slowdown in the unlikely case that the address is unsuitable.
But then, your code also involves walking a portion of the vma list
twice in case you fallback to the old handling.  So it may be the same
speed, but more functionality duplication.

I am not exactly proposing this change.  Rather, I mention it as a
possibility for your consideration.

What do you think?

Alexander
