Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 4 Sep 2011 03:40:09 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110903234009.GC29169@openwall.com>
References: <20110812102954.GA3496@albatros> <20110812105824.GA7141@openwall.com> <20110825171934.GA3044@albatros> <20110902233413.GB26494@openwall.com> <20110903121205.GB2743@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110903121205.GB2743@albatros>
Subject: Re: [kernel-hardening] [RFC] x86, mm: start mmap allocation for libs from low addresses
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy,

On Sat, Sep 03, 2011 at 04:12:06PM +0400, Vasiliy Kulikov wrote:
> On Sat, Sep 03, 2011 at 03:34 +0400, Solar Designer wrote:
> > > +static unsigned long mmap_lib_base(void)
> > > +{
> > > +	return ASCII_ARMOR_MIN_ADDR + mmap_rnd();
> > > +}
> > 
> > I was about to suggest that you declare this function inline, but then I
> > noticed that all other tiny and single-use functions in
> > arch/x86/mm/mmap.c are also non-inline.  Weird.  You might want to bring
> > this up on LKML separately.
> 
> Why?  They are called once per process when mm_struct is initialized.
> Inlining would not boost the code.

Besides the minor and maybe unimportant speed difference, inlining of
functions invoked from just one place may reduce total code size.  Of
course, it's a very minor issue.

> > > +unsigned long
> > > +get_unmapped_exec_area(struct file *filp, unsigned long addr0,
> > > +		unsigned long len, unsigned long pgoff, unsigned long flags)
> > > +{
> > > +	unsigned long addr = addr0;
> > > +	struct mm_struct *mm = current->mm;
> > > +	struct vm_area_struct *vma;
> > > +
> > > +	if (len > TASK_SIZE)
> > > +		return -ENOMEM;
> > > +
> > > +	if (flags & MAP_FIXED)
> > > +		return addr;
> > 
> > In the MAP_FIXED case, don't we need to make sure that addr is actually
> > available - that is, do a "goto failed" here (fallback to old handling)?
> 
> No, what can old handling do?  If MAP_FIXED is passed, we may not change
> the behaviour.  If the region is already owned by someone, checks in the
> upper mm code would return error.  Also all other allocators just return
> addr in this case.

OK.  I'll trust you on this.

> It's possible to have a weird case: PIE is disabled, exec image is lower
> than 0x01000000, kernel.randomize_va_space=0.  It means brk area starts
> in ASCII-armor zone.  If we try to jump over brk, then next brk growth
> would fail as we've loaded some library just after the last brk page.

OK.  Maybe you can make the comment as clear as the above paragraph?
The way it's written currently, it is unclear what it talks about -
e.g., why "not DYNAMIC elf binaries"?  In fact, it doesn't even look
consistent with what you wrote above.

> At first, RHEL tries to allocate a region without brk check:
> 
> 		addr = !should_randomize() ? SHLIB_BASE :
> 			randomize_range(SHLIB_BASE, 0x01000000, len);
> 
> 
> Then if it fails, exec-shield tries to find a region in a cycle, without
> the brk check.  Then if it overruns 0x01000000, it starts to do brk
> check:
> 
> 			if (addr >= 0x01000000 && should_randomize()) {
> 				tmp = randomize_range(0x01000000,
> 					PAGE_ALIGN(max(mm->start_brk,
> 					(unsigned long)0x08000000)), len);
> 
> So, they don't care about this rare case.
> 
> I heard many times about legacy randomize_va_space=0 systems, which
> disable brk randomization because of some ancient proprietary software.
> Non-PIE binaries are very often nowadays.  I didn't see these 3 cases at
> once (non-PIE, low mmap exec base, no brk randomization), but I don't
> see why it's impossible.  If you know why it is, I'll remove the check.

I think non-PIE binaries with their fixed base address other than the
standard 0x08048000 are very rare - possibly they only exist in kernel
vulnerability exploits. ;-)  But I don't know for sure.  I don't mind
the check, but please make the comment descriptive and correct.

> > Now, the main question: what's wrong with doing something as simple as:
> > 
> > unsigned long
> > get_unmapped_exec_area(struct file *filp, unsigned long addr,
> > 		unsigned long len, unsigned long pgoff, unsigned long flags)
> > {
> > 	return current->mm->get_unmapped_area(filp, ((flags & MAP_FIXED) || len >= 0x00ef0000UL) ? addr : max_t(unsigned long, mm->lib_mmap_base, mmap_min_addr), len, pgoff, flags);
> > }
> > 
> > Of course, written in a cleaner and more generic fashion.
> 
> 1) get_unmapped_area may ignore the hint if the address is already owned.
> Then it would start from the cached hole address rather than ->lib_mmap_base.

OK.  This cached hole address might be a post-2.4 thing - at least, I
haven't seen this behavior on 2.4 and prior.

> 2) my code contains brk check in ASCII zone.

OK.

> I'd want to reduce the added code size too, but it is rather tricky to
> do it with mm code.  AFAICS, the way RHEL did it (separate
> ->get_unmapped_exec_area allocator) is the easiest one.

I am fine with this approach.  One nice aspect of it is that there's no
performance impact for non-exec mmap()'s.

Alexander
