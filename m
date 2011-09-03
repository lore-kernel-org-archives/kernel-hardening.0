Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sat, 3 Sep 2011 16:12:06 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110903121205.GB2743@albatros>
References: <20110812102954.GA3496@albatros>
 <20110812105824.GA7141@openwall.com>
 <20110825171934.GA3044@albatros>
 <20110902233413.GB26494@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110902233413.GB26494@openwall.com>
Subject: Re: [kernel-hardening] [RFC] x86, mm: start mmap allocation for
 libs from low addresses
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Sep 03, 2011 at 03:34 +0400, Solar Designer wrote:
> > +static unsigned long mmap_lib_base(void)
> > +{
> > +	return ASCII_ARMOR_MIN_ADDR + mmap_rnd();
> > +}
> 
> I was about to suggest that you declare this function inline, but then I
> noticed that all other tiny and single-use functions in
> arch/x86/mm/mmap.c are also non-inline.  Weird.  You might want to bring
> this up on LKML separately.

Why?  They are called once per process when mm_struct is initialized.
Inlining would not boost the code.


> > @@ -131,6 +147,10 @@ void arch_pick_mmap_layout(struct mm_struct *mm)
> >  	} else {
> >  		mm->mmap_base = mmap_base();
> >  		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
> > +		if (mmap_is_ia32()) {
> > +			mm->get_unmapped_exec_area = get_unmapped_exec_area;
> > +			mm->lib_mmap_base = mmap_lib_base();
> > +		}
> >  		mm->unmap_area = arch_unmap_area_topdown;
> >  	}
> 
> Are you sure it's safe to leave get_unmapped_exec_area and lib_mmap_base
> uninitialized when !mmap_is_ia32()?  Is there implicit initialization to
> NULL before this point maybe?  (I did not check.)

There is:

struct mm_struct * mm_alloc(void)
{
	struct mm_struct * mm;

	mm = allocate_mm();
	if (mm) {
		memset(mm, 0, sizeof(*mm));
...


> > +/* Addresses before this value contain at least one zero byte. */
> > +#define ASCII_ARMOR_MAX_ADDR 0x01000000
> > +
> > +/*
> > + * This function finds the first unmapped region inside of
> > + * [mm->lib_mmap_base; ASCII_ARMOR_MAX_ADDR) region.  Addresses from this
> > + * region contain at least one zero byte, which greatly complicates
> 
> Maybe s/greatly // because this word is subjective, and the actual
> difficulty varies for different scenarios.

OK.


> > +unsigned long
> > +get_unmapped_exec_area(struct file *filp, unsigned long addr0,
> > +		unsigned long len, unsigned long pgoff, unsigned long flags)
> > +{
> > +	unsigned long addr = addr0;
> > +	struct mm_struct *mm = current->mm;
> > +	struct vm_area_struct *vma;
> > +
> > +	if (len > TASK_SIZE)
> > +		return -ENOMEM;
> > +
> > +	if (flags & MAP_FIXED)
> > +		return addr;
> 
> In the MAP_FIXED case, don't we need to make sure that addr is actually
> available - that is, do a "goto failed" here (fallback to old handling)?

No, what can old handling do?  If MAP_FIXED is passed, we may not change
the behaviour.  If the region is already owned by someone, checks in the
upper mm code would return error.  Also all other allocators just return
addr in this case.


> 
> > +	/* We ALWAYS start from the beginning as base addresses
> > +	 * with zero high bits is a valued resource */
> > +	addr = max_t(unsigned long, mm->lib_mmap_base, mmap_min_addr);
> > +
> > +	for (vma = find_vma(mm, addr); ; vma = vma->vm_next) {
> > +		/* At this point:  (!vma || addr < vma->vm_end). */
> > +		if (TASK_SIZE - len < addr)
> > +			return -ENOMEM;
> 
> Since this check is primarily of addr, I'd write it as:
> 
> 		if (addr > TASK_SIZE - len)
> 			return -ENOMEM;
> 
> Also, I hope the len == 0 && addr == TASK_SIZE case that this check
> happens to permit is irrelevant here.  I naively hope (well, maybe not)
> that addr has been checked for "< TASK_SIZE" at a higher level. ;-)
> You could want to review the current mm code for this.

len == 0 is checked in the callers - do_mmap_pgoff() and __do_brk().

"< TASK_SIZE":

	/* Careful about overflows.. */
	if (len > TASK_SIZE)
		return -ENOMEM;
    ...
	if (addr > TASK_SIZE - len)
		return -ENOMEM;

> > +		/* We don't want to reduce brk area of not DYNAMIC elf binaries
> > +		 * with sysctl kernel.randomize_va_space < 2. */
> > +		if (mm->brk && addr > mm->brk)
> > +			goto failed;
> 
> Does this check come from RHEL?

Partly, see below.


>  I don't fully understand it.  We also
> check for "vma->vm_end >= ASCII_ARMOR_MAX_ADDR" below.  Does this imply
> that we choose to handle the case of mm->brk being lower than
> ASCII_ARMOR_MAX_ADDR here?  Is it a practically relevant case?

It's possible to have a weird case: PIE is disabled, exec image is lower
than 0x01000000, kernel.randomize_va_space=0.  It means brk area starts
in ASCII-armor zone.  If we try to jump over brk, then next brk growth
would fail as we've loaded some library just after the last brk page.

(Also it would touch brk guard pages, which I didn't investigate.)


>  Or was
> this check possibly less redundant on RHEL?


At first, RHEL tries to allocate a region without brk check:

		addr = !should_randomize() ? SHLIB_BASE :
			randomize_range(SHLIB_BASE, 0x01000000, len);


Then if it fails, exec-shield tries to find a region in a cycle, without
the brk check.  Then if it overruns 0x01000000, it starts to do brk
check:

			if (addr >= 0x01000000 && should_randomize()) {
				tmp = randomize_range(0x01000000,
					PAGE_ALIGN(max(mm->start_brk,
					(unsigned long)0x08000000)), len);

So, they don't care about this rare case.

I heard many times about legacy randomize_va_space=0 systems, which
disable brk randomization because of some ancient proprietary software.
Non-PIE binaries are very often nowadays.  I didn't see these 3 cases at
once (non-PIE, low mmap exec base, no brk randomization), but I don't
see why it's impossible.  If you know why it is, I'll remove the check.


> (If these questions are time-consuming to find answers to, feel free to
> disregard them for now.)
> 
> > +		if (!vma || addr + len <= vma->vm_start)
> > +			return addr;
> > +
> > +		addr = vma->vm_end;
> > +
> > +		/* If ACSII-armor area is over, the algo gives up */
> > +		if (addr >= ASCII_ARMOR_MAX_ADDR)
> > +			goto failed;
> > +	}
> > +
> > +failed:
> > +	return current->mm->get_unmapped_area(filp, addr0, len, pgoff, flags);
> > +}
> 
> Now, the main question: what's wrong with doing something as simple as:
> 
> unsigned long
> get_unmapped_exec_area(struct file *filp, unsigned long addr,
> 		unsigned long len, unsigned long pgoff, unsigned long flags)
> {
> 	return current->mm->get_unmapped_area(filp, ((flags & MAP_FIXED) || len >= 0x00ef0000UL) ? addr : max_t(unsigned long, mm->lib_mmap_base, mmap_min_addr), len, pgoff, flags);
> }
> 
> Of course, written in a cleaner and more generic fashion.

1) get_unmapped_area may ignore the hint if the address is already owned.
Then it would start from the cached hole address rather than ->lib_mmap_base.

2) my code contains brk check in ASCII zone.


> This is similar to what I did in -ow patches, where I only needed to
> adjust TASK_UNMAPPED_BASE turning it from a constant to a trivial macro
> accepting the allocation size as input.

In times of -ow patch the allocator was simpler :)  Now it differs from
arch to arch, it can be top down and bottom up.  More than that:
currently bottom up allocator doesn't respect randomization.

We could reuse/refactor bottom up allocator to use randomization, but
it's likely to be taken as an invasive change.

Changing top down allocator is likely to be rejected too as it might
significantly slowdown the case when addr and the near zones are owned,
but the cache hint is just OK.  Note that we don't want to change
anything for non-32 bit systems.


I'd want to reduce the added code size too, but it is rather tricky to
do it with mm code.  AFAICS, the way RHEL did it (separate
->get_unmapped_exec_area allocator) is the easiest one.


Thanks,

-- 
Vasiliy
