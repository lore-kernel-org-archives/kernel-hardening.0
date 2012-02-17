Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 16 Feb 2012 18:11:09 -0800
From: Kees Cook <keescook@chromium.org>
Message-ID: <20120217021109.GC6541@outflux.net>
References: <CAEXv5_gkTsPHDFh+wQqD3P3D-Z+uCN-_1bVyHfHV=u7bS-tgeA@mail.gmail.com>
 <20120216204515.GH20420@outflux.net>
 <20120217002405.GB7746@kroah.com>
 <20120217010624.GA6541@outflux.net>
 <20120217014008.GA18763@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217014008.GA18763@kroah.com>
Subject: [kernel-hardening] Re: [ubuntu-hardened] Add overflow protection to kref
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Kees Cook <keescook@chromium.org>, pageexec@freemail.hu, Ubuntu security discussion <ubuntu-hardened@lists.ubuntu.com>, spender@grsecurity.net, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 16, 2012 at 05:40:08PM -0800, Greg KH wrote:
> Any reason you forgot to cc: me on the response?

Sorry about that; my MUA and I were fighting. :( Looks like David got
dropped too. Fixed.

> On Thu, Feb 16, 2012 at 05:06:24PM -0800, Kees Cook wrote:
> > On Thu, Feb 16, 2012 at 04:24:05PM -0800, Greg Kroah-Hartman wrote:
> > > On Thu, Feb 16, 2012 at 12:45:15PM -0800, Kees Cook wrote:
> > > > Hi,
> > > > 
> > > > [This should probably be discussed on LKML for an even wider audience, so
> > > > I've added a CC for it there.]
> > > > 
> > > > On Thu, Feb 16, 2012 at 09:02:13AM -0500, David Windsor wrote:
> > > > > Hi,
> > > > > 
> > > > > We are attempting to add various grsecurity/PAX features to upstream
> > > > > Ubuntu kernels.
> > > > 
> > > > This didn't parse quite right for me. I think you meant that the intent
> > > > is to get these features into the upstream Linux kernel, with potential
> > > > staging in Ubuntu kernels.
> > > > 
> > > > (Also s/PAX/PaX/g)
> > > > 
> > > > > The PAX folks added refcount overflow protection by inserting
> > > > > architecture-specific code in the increment paths of atomic_t.  For
> > > > > instance:
> > > > > 
> > > > > static inline void atomic_inc(atomic_t *v)
> > > > >  {
> > > > > 	asm volatile(LOCK_PREFIX "incl %0\n"
> > > > > 
> > > > > #ifdef CONFIG_PAX_REFCOUNT
> > > > > 		     "jno 0f\n"
> > > > > 		     LOCK_PREFIX "decl %0\n"
> > > > > 		     "int $4\n0:\n"
> > > > > 		     _ASM_EXTABLE(0b, 0b)
> > > > > #endif
> > > > > 
> > > > > 		     : "+m" (v->counter));
> > > > > }
> > > > > 
> > > > > There are two distinct classes of users we need to consider here:
> > > > > those who use atomic_t for reference counters and those who use
> > > > > atomic_t for keeping track of statistics, like performance counters,
> > > > > etc.; it makes little sense to overflow a performance counter, so we
> > > > > shouldn't subject those users to the same protections as imposed on
> > > > > actual reference counters.  The solution implemented by PAX is to
> > > > > create a family of *_unchecked() functions and to patch
> > > > > statistics-based users of atomic_t to use this interface.
> > > > > 
> > > > > PAX refcount overflow protection was developed before kref was
> > > > > created.  I'd like to move overflow protection out of atomic_t and
> > > > > into kref and gradually migrate atomic_t users to kref, leaving
> > > > > atomic_t for those users who don't need overflow protection (e.g.
> > > > > statistics-based counters).
> > > > 
> > > > For people new to this, can you give an overview of what attacks are foiled
> > > > by adding overflow protection?
> > > > 
> > > > > I realize that there are many users of atomic_t needing overflow
> > > > > protection, but the move to kref seems like the right thing to do in
> > > > > this case.
> > > > > 
> > > > > Leaving the semantics of overflow detection aside for the moment, what
> > > > > are everyone's thoughts on adding overflow protection to kref rather
> > > > > than to atomic_t?
> > > > 
> > > > Why was kref introduced? Or rather, how is kref currently different from
> > > > atomic_t?
> > > 
> > > a kref is to handle reference counting for an object, so you don't have
> > > to constantly "roll your own" all the time using an atomic_t or
> > > whatever.  It's the basis for the struct kobject and other object
> > > reference counting structures in the kernel for a very long time now.
> > > 
> > > And in all that time, I've never seen an instance where you can overflow
> > > the reference count, so I'm hard pressed to see how changing kref in
> > > this manner will help anything at all.
> > 
> > A quick search gives me:
> > CVE-2005-3359: https://bugzilla.redhat.com/show_bug.cgi?id=175769
> > CVE-2006-3741: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=b8444d00762703e1b6146fce12ce2684885f8bf6
> 
> Neither of those are kref issues, just bugs with other types of
> counting things.
> 
> > And actually an earlier discussion you were actually involved in:
> > https://lkml.org/lkml/2008/7/16/300
> 
> That wasn't about a kref issue either.  It was also a fun flamefest, but
> I don't see how that is relevant here.  What am I missing?

I was just trying to find some background on this topic. Perhaps other
folks have more details?

> > > So no, I don't recommend changing this logic at all in kref.
> > 
> > If it's inexpensive and helps defend against problems, it seems sensible to
> > add to me.
> 
> I have yet to see a patch, so why are we arguing about this?  :)
> 
> Again, I don't know of any kref overflows that have ever happened, so
> trying to "protect" this type of thing, seems odd to me.

Well, I think the issue was to protect counting things (which seems to
be what PaX was after originally), and that kref seemed like the place
to put it. I'll let David take it further.

Thanks,

-Kees

-- 
Kees Cook
ChromeOS Security
