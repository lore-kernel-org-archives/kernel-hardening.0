MIME-Version: 1.0
References: <CAGXu5jKCs01jvtvpEFS7R8qCR-5iRqK11kJxLJY99NicGWc4aQ@mail.gmail.com>
 <20181028183126.GB744@hirez.programming.kicks-ass.net> <40cd77ce-f234-3213-f3cb-0c3137c5e201@gmail.com>
 <20181030152641.GE8177@hirez.programming.kicks-ass.net> <CAGXu5jJftJ+Hq+jrZGHX5CTDLWOog7kGsd_Ne=yMvrRs__skSg@mail.gmail.com>
 <0A7AFB50-9ADE-4E12-B541-EC7839223B65@amacapital.net> <20181030175814.GB10491@bombadil.infradead.org>
 <20181030182841.GE7343@cisco> <20181030192021.GC10491@bombadil.infradead.org>
 <9edbdf8b-b5fb-5a82-43b4-b639f5ec8484@gmail.com> <20181030213557.GE10491@bombadil.infradead.org>
In-Reply-To: <20181030213557.GE10491@bombadil.infradead.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 30 Oct 2018 21:41:13 -0700
Message-ID: <CALCETrW1FcT88u0QY9k_PMOeZj0G8H6KNb5Bnreo-12NvmmCEQ@mail.gmail.com>
Subject: Re: [PATCH 10/17] prmem: documentation
Content-Type: text/plain; charset="UTF-8"
To: Matthew Wilcox <willy@infradead.org>
Cc: Igor Stoppa <igor.stoppa@gmail.com>, Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-integrity <linux-integrity@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Igor Stoppa <igor.stoppa@huawei.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 30, 2018 at 2:36 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Tue, Oct 30, 2018 at 10:43:14PM +0200, Igor Stoppa wrote:
> > On 30/10/2018 21:20, Matthew Wilcox wrote:
> > > > > So the API might look something like this:
> > > > >
> > > > >         void *p = rare_alloc(...);      /* writable pointer */
> > > > >         p->a = x;
> > > > >         q = rare_protect(p);            /* read-only pointer */
> >
> > With pools and memory allocated from vmap_areas, I was able to say
> >
> > protect(pool)
> >
> > and that would do a swipe on all the pages currently in use.
> > In the SELinux policyDB, for example, one doesn't really want to
> > individually protect each allocation.
> >
> > The loading phase happens usually at boot, when the system can be assumed to
> > be sane (one might even preload a bare-bone set of rules from initramfs and
> > then replace it later on, with the full blown set).
> >
> > There is no need to process each of these tens of thousands allocations and
> > initialization as write-rare.
> >
> > Would it be possible to do the same here?
>
> What Andy is proposing effectively puts all rare allocations into
> one pool.  Although I suppose it could be generalised to multiple pools
> ... one mm_struct per pool.  Andy, what do you think to doing that?

Hmm.  Let's see.

To clarify some of this thread, I think that the fact that rare_write
uses an mm_struct and alias mappings under the hood should be
completely invisible to users of the API.  No one should ever be
handed a writable pointer to rare_write memory (except perhaps during
bootup or when initializing a large complex data structure that will
be rare_write but isn't yet, e.g. the policy db).

For example, there could easily be architectures where having a
writable alias is problematic.  On such architectures, an entirely
different mechanism might work better.  And, if a tool like KNOX ever
becomes a *part* of the Linux kernel (hint hint!)

If you have multiple pools and one mm_struct per pool, you'll need a
way to find the mm_struct from a given allocation.  Regardless of how
the mm_structs are set up, changing rare_write memory to normal memory
or vice versa will require a global TLB flush (all ASIDs and global
pages) on all CPUs, so having extra mm_structs doesn't seem to buy
much.

(It's just possible that changing rare_write back to normal might be
able to avoid the flush if the spurious faults can be handled
reliably.)
