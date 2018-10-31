Date: Wed, 31 Oct 2018 10:29:42 +0100
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 10/17] prmem: documentation
Message-ID: <20181031092942.GJ744@hirez.programming.kicks-ass.net>
References: <20181026092609.GB3159@worktop.c.hoisthospitality.com>
 <CAGXu5jKCs01jvtvpEFS7R8qCR-5iRqK11kJxLJY99NicGWc4aQ@mail.gmail.com>
 <20181028183126.GB744@hirez.programming.kicks-ass.net>
 <40cd77ce-f234-3213-f3cb-0c3137c5e201@gmail.com>
 <20181030152641.GE8177@hirez.programming.kicks-ass.net>
 <CAGXu5jJftJ+Hq+jrZGHX5CTDLWOog7kGsd_Ne=yMvrRs__skSg@mail.gmail.com>
 <0A7AFB50-9ADE-4E12-B541-EC7839223B65@amacapital.net>
 <20181030175814.GB10491@bombadil.infradead.org>
 <28C8CD2A-BDC0-49A5-854E-1E18968528B8@amacapital.net>
 <20181030212551.GD10491@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181030212551.GD10491@bombadil.infradead.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andy Lutomirski <luto@amacapital.net>, nadav.amit@gmail.com, Kees Cook <keescook@chromium.org>, Igor Stoppa <igor.stoppa@gmail.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-integrity <linux-integrity@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Igor Stoppa <igor.stoppa@huawei.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 30, 2018 at 02:25:51PM -0700, Matthew Wilcox wrote:
> On Tue, Oct 30, 2018 at 11:51:17AM -0700, Andy Lutomirski wrote:
> > Finally, one issue: rare_alloc() is going to utterly suck
> > performance-wise due to the global IPI when the region gets zapped out
> > of the direct map or otherwise made RO.  This is the same issue that
> > makes all existing XPO efforts so painful. We need to either optimize
> > the crap out of it somehow or we need to make sure it’s not called
> > except during rare events like device enumeration.
> 
> Batching operations is kind of the whole point of the VM ;-)  Either
> this rare memory gets used a lot, in which case we'll want to create slab
> caches for it, make it a MM zone and the whole nine yeards, or it's not
> used very much in which case it doesn't matter that performance sucks.

Yes, for the dynamic case something along those lines would be needed.
If we have a single rare zone, we could even have __GFP_RARE or whatever
that manages this.

The page allocator would have to grow a rare memblock type, and every
rare alloc would allocate from a rare memblock, when none is available,
creation of a rare block would set up the mappings etc..

> For now, I'd suggest allocating 2MB chunks as needed, and having a
> shrinker to hand back any unused pieces.

Something like the percpu allocator?
