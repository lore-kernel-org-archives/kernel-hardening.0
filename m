Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sun, 4 Sep 2011 11:21:31 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110904072131.GA3307@albatros>
References: <20110812102954.GA3496@albatros>
 <20110812105824.GA7141@openwall.com>
 <20110825171934.GA3044@albatros>
 <20110902233413.GB26494@openwall.com>
 <20110903121205.GB2743@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110903121205.GB2743@albatros>
Subject: Re: [kernel-hardening] [RFC] x86, mm: start mmap allocation for
 libs from low addresses
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Sep 03, 2011 at 16:12 +0400, Vasiliy Kulikov wrote:
> > > +		/* We don't want to reduce brk area of not DYNAMIC elf binaries
> > > +		 * with sysctl kernel.randomize_va_space < 2. */
> > > +		if (mm->brk && addr > mm->brk)
> > > +			goto failed;
> > 
> > Does this check come from RHEL?
> 
> Partly, see below.
> 
> 
> >  I don't fully understand it.  We also
> > check for "vma->vm_end >= ASCII_ARMOR_MAX_ADDR" below.  Does this imply
> > that we choose to handle the case of mm->brk being lower than
> > ASCII_ARMOR_MAX_ADDR here?  Is it a practically relevant case?
> 
> It's possible to have a weird case: PIE is disabled, exec image is lower
> than 0x01000000, kernel.randomize_va_space=0.  It means brk area starts
> in ASCII-armor zone.  If we try to jump over brk, then next brk growth
> would fail as we've loaded some library just after the last brk page.
> 
> (Also it would touch brk guard pages, which I didn't investigate.)
> 
> 
> >  Or was
> > this check possibly less redundant on RHEL?
> 

Sorry, I was precluded and have mixed things.  This should be read as:

> At first, RHEL tries to allocate a region without brk check:
> 
> 		addr = !should_randomize() ? SHLIB_BASE :
> 			randomize_range(SHLIB_BASE, 0x01000000, len);
> 
> 
> Then if it fails, exec-shield tries to find a region in a cycle, without
> the brk check.

s/without/with/

			/*
			 * Must not let a PROT_EXEC mapping get into the
			 * brk area:
			 */
			if (addr + len > mm->brk)
				goto failed;

>  Then if it overruns 0x01000000, it starts to do brk
> check:
> 
> 			if (addr >= 0x01000000 && should_randomize()) {
> 				tmp = randomize_range(0x01000000,
> 					PAGE_ALIGN(max(mm->start_brk,
> 					(unsigned long)0x08000000)), len);
> 
> So, they don't care about this rare case.

They care, but it is inconsistent - sometimes they check it, sometimes
not.  If the first guess failed - they do, otherwise don't.


> I heard many times about legacy randomize_va_space=0 systems, which
> disable brk randomization because of some ancient proprietary software.
> Non-PIE binaries are very often nowadays.  I didn't see these 3 cases at
> once (non-PIE, low mmap exec base, no brk randomization), but I don't
> see why it's impossible.  If you know why it is, I'll remove the check.

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
