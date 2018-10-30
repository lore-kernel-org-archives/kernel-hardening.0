Date: Tue, 30 Oct 2018 14:35:57 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 10/17] prmem: documentation
Message-ID: <20181030213557.GE10491@bombadil.infradead.org>
References: <CAGXu5jKCs01jvtvpEFS7R8qCR-5iRqK11kJxLJY99NicGWc4aQ@mail.gmail.com>
 <20181028183126.GB744@hirez.programming.kicks-ass.net>
 <40cd77ce-f234-3213-f3cb-0c3137c5e201@gmail.com>
 <20181030152641.GE8177@hirez.programming.kicks-ass.net>
 <CAGXu5jJftJ+Hq+jrZGHX5CTDLWOog7kGsd_Ne=yMvrRs__skSg@mail.gmail.com>
 <0A7AFB50-9ADE-4E12-B541-EC7839223B65@amacapital.net>
 <20181030175814.GB10491@bombadil.infradead.org>
 <20181030182841.GE7343@cisco>
 <20181030192021.GC10491@bombadil.infradead.org>
 <9edbdf8b-b5fb-5a82-43b4-b639f5ec8484@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9edbdf8b-b5fb-5a82-43b4-b639f5ec8484@gmail.com>
To: Igor Stoppa <igor.stoppa@gmail.com>
Cc: Tycho Andersen <tycho@tycho.ws>, Andy Lutomirski <luto@amacapital.net>, Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-integrity <linux-integrity@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Igor Stoppa <igor.stoppa@huawei.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 30, 2018 at 10:43:14PM +0200, Igor Stoppa wrote:
> On 30/10/2018 21:20, Matthew Wilcox wrote:
> > > > So the API might look something like this:
> > > > 
> > > > 	void *p = rare_alloc(...);	/* writable pointer */
> > > > 	p->a = x;
> > > > 	q = rare_protect(p);		/* read-only pointer */
> 
> With pools and memory allocated from vmap_areas, I was able to say
> 
> protect(pool)
> 
> and that would do a swipe on all the pages currently in use.
> In the SELinux policyDB, for example, one doesn't really want to
> individually protect each allocation.
> 
> The loading phase happens usually at boot, when the system can be assumed to
> be sane (one might even preload a bare-bone set of rules from initramfs and
> then replace it later on, with the full blown set).
> 
> There is no need to process each of these tens of thousands allocations and
> initialization as write-rare.
> 
> Would it be possible to do the same here?

What Andy is proposing effectively puts all rare allocations into
one pool.  Although I suppose it could be generalised to multiple pools
... one mm_struct per pool.  Andy, what do you think to doing that?

> > but we'd probably wrap it in list_for_each_rare_entry(), just to be nicer.
> 
> This seems suspiciously close to the duplication of kernel interfaces that I
> was roasted for :-)

Can you not see the difference between adding one syntactic sugar function
and duplicating the entire infrastructure?
