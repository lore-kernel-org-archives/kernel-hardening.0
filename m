Date: Tue, 30 Oct 2018 16:26:41 +0100
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 10/17] prmem: documentation
Message-ID: <20181030152641.GE8177@hirez.programming.kicks-ass.net>
References: <20181023213504.28905-1-igor.stoppa@huawei.com>
 <20181023213504.28905-11-igor.stoppa@huawei.com>
 <20181026092609.GB3159@worktop.c.hoisthospitality.com>
 <CAGXu5jKCs01jvtvpEFS7R8qCR-5iRqK11kJxLJY99NicGWc4aQ@mail.gmail.com>
 <20181028183126.GB744@hirez.programming.kicks-ass.net>
 <40cd77ce-f234-3213-f3cb-0c3137c5e201@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40cd77ce-f234-3213-f3cb-0c3137c5e201@gmail.com>
To: Igor Stoppa <igor.stoppa@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Matthew Wilcox <willy@infradead.org>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-integrity <linux-integrity@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Igor Stoppa <igor.stoppa@huawei.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Oct 29, 2018 at 11:04:01PM +0200, Igor Stoppa wrote:
> On 28/10/2018 18:31, Peter Zijlstra wrote:
> > On Fri, Oct 26, 2018 at 11:46:28AM +0100, Kees Cook wrote:
> > > On Fri, Oct 26, 2018 at 10:26 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > > > I still don't really understand the whole write-rare thing; how does it
> > > > really help? If we can write in kernel memory, we can write to
> > > > page-tables too.
> > 
> > > One aspect of hardening the kernel against attack is reducing the
> > > internal attack surface. Not all flaws are created equal, so there is
> > > variation in what limitations an attacker may have when exploiting
> > > flaws (not many flaws end up being a fully controlled "write anything,
> > > anywhere, at any time"). By making the more sensitive data structures
> > > of the kernel read-only, we reduce the risk of an attacker finding a
> > > path to manipulating the kernel's behavior in a significant way.
> > > 
> > > Examples of typical sensitive targets are function pointers, security
> > > policy, and page tables. Having these "read only at rest" makes them
> > > much harder to control by an attacker using memory integrity flaws.
> > 
> > Because 'write-anywhere' exploits are easier than (and the typical first
> > step to) arbitrary code execution thingies?
> > 
> > > The "write rarely" name itself may not sufficiently describe what is
> > > wanted either (I'll take the blame for the inaccurate name), so I'm
> > > open to new ideas there. The implementation requirements for the
> > > "sensitive data read-only at rest" feature are rather tricky:
> > > 
> > > - allow writes only from specific places in the kernel
> > > - keep those locations inline to avoid making them trivial ROP targets
> > > - keep the writeability window open only to a single uninterruptable CPU
> > 
> > The current patch set does not achieve that because it uses a global
> > address space for the alias mapping (vmap) which is equally accessible
> > from all CPUs.
> 
> I never claimed to achieve 100% resilience to attacks.

You never even begun explaining what you were defending against. Let
alone how well it achieved its stated goals.

> While it's true that the address space is accessible to all the CPUs, it is
> also true that the access has a limited duration in time, and the location
> where the access can be performed is not fixed.
> 
> Iow, assuming that the CPUs not involved in the write-rare operations are
> compromised and that they are trying to perform a concurrent access to the
> data in the writable page, they have a limited window of opportunity.

That sounds like security through obscurity. Sure it makes it harder,
but it doesn't stop anything.

> Said this, this I have posted is just a tentative implementation.
> My primary intent was to at least give an idea of what I'd like to do: alter
> some data in a way that is not easily exploitable.

Since you need to modify page-tables in order to achieve this, the
page-tables are also there for the attacker to write to.

> > > - fast enough to deal with page table updates
> > 
> > The proposed implementation needs page-tables for the alias; I don't see
> > how you could ever do R/O page-tables when you need page-tables to
> > modify your page-tables.
> 
> It's not all-or-nothing.

I really am still strugging with what it is this thing is supposed to
do. As it stands, I see very little value. Yes it makes a few things a
little harder, but it doesn't really do away with things.

> I hope we agree at least on the reasoning that having only a limited amount
> of address space directly attackable, instead of the whole set of pages
> containing exploitable data, is  reducing the attack surface.

I do not in fact agree. Most pages are not interesting for an attack at
all. So simply reducing the set of pages you can write to isn't
sufficient.

IOW. removing all noninteresting pages from the writable set will
satisfy your criteria, but it avoids exactly 0 exploits.

What you need to argue is that we remove common exploit targets, and
you've utterly failed to do so.

Kees mentioned: function pointers, page-tables and a few other things.
You mentioned nothing.

> Furthermore, if we think about possible limitations that the attack might
> have (maximum reach), the level of protection might be even higher. I have
> to use "might" because I cannot foresee the vulnerability.

That's just a bunch of words together that don't really say anything
afaict.

> Furthermore, taking a different angle: your average attacker is not
> necessarily very social and inclined to share the vulnerability found.
> It is safe to assume that in most cases each attacker has to identify the
> attack strategy autonomously.
> Reducing the amount of individual who can perform an attack, by increasing
> the expertise required is also a way of doing damage control.

If you make RO all noninteresting pages, you in fact increase the
density of interesting targets and make things easier.

> > And this is entirely irrespective of performance.
> 
> I have not completely given up on performance, but, being write-rare, I see
> improved performance as just a way of widening the range of possible
> recipients for the hardening.

What?! Are you saying you don't care about performance?

> > Right... /me goes find the patches we did for text_poke. Hmm, those
> > never seem to have made it:
> > 
> >    https://lkml.kernel.org/r/20180902173224.30606-1-namit@vmware.com
> > 
> > like that. That approach will in fact work and not be a completely
> > broken mess like this thing.
> 
> That approach is x86 specific.

It is not. Every architecture does switch_mm() with IRQs disabled, as
that is exactly what the scheduler does.

And keeping a second init_mm around also isn't very architecture
specific I feel.

> > > We need to find a good way to do the write-windowing that works well
> > > for static and dynamic structures _and_ for the page tables... this
> > > continues to be tricky.
> > > 
> > > Making it resilient against ROP-style targets makes it difficult to
> > > deal with certain data structures (like list manipulation). In my
> > > earlier RFC, I tried to provide enough examples of where this could
> > > get used to let people see some of the complexity[1]. Igor's series
> > > expands this to even more examples using dynamic allocation.
> > 
> > Doing 2 CR3 writes for 'every' WR write doesn't seem like it would be
> > fast enough for much of anything.
> 
> Part of the reason for the duplication is that, even if the wr_API I came up
> with, can be collapsed with the regular API, the implementation needs to be
> different, to be faster.
> 
> Ex:
> * force the list_head structure to be aligned so that it will always be
> fully contained by a single page
> * create alternate mapping for all the pages involved (max 1 page for each
> list_head)
> * do the lsit operation on the remapped list_heads
> * destroy all the mappings

Those constraints are due to single page aliases.

> I can try to introduce some wrapper similar to kmap_atomic(), as suggested
> by Dave Hansen, which can improve the coding, but it will not change the
> actual set of operations performed.

See below, I don't think kmap_atomic() is either correct or workable.

One thing that might be interesting is teaching objtool about the
write-enable write-disable markers and making it guarantee we reach a
disable after every enable. IOW, ensure we never leak this state.

I think that was part of why we hated on that initial thing Kees did --
well that an disabling all WP is of course completely insane ;-).

> > And I don't suppose we can take the WP fault and then fix up from there,
> > because if we're doing R/O page-tables, that'll incrase the fault depth
> > and we'll double fault all the time, and tripple fault where we
> > currently double fault. And we all know how _awesome_ tripple faults
> > are.
> > 
> > But duplicating (and wrapping in gunk) whole APIs is just not going to
> > work.
> 
> Would something like kmap_atomic() be acceptable?

Don't think so. kmap_atomic() on x86_32 (64bit doesn't have it at all)
only does the TLB invalidate on the one CPU, which we've established is
incorrect.

Also, kmap_atomic is still page-table based, which means not all
page-tables can be read-only.

> Do you have some better proposal, now that (I hope) it should be more clear
> what I'm trying to do and why?

You've still not talked about any actual attack vectors and how they're
mitigated by these patches.

I suppose the 'normal' attack goes like:

 1) find buffer-overrun / bound check failure
 2) use that to write to 'interesting' location
 3) that write results arbitrary code execution
 4) win

Of course, if the store of 2 is to the current cred structure, and
simply sets the effective uid to 0, we can skip 3.

Which seems to suggest all cred structures should be made r/o like this.
But I'm not sure I remember these patches doing that.


Also, there is an inverse situation with all this. If you make
everything R/O, then you need this allow-write for everything you do,
which then is about to include a case with an overflow / bound check
fail, and we're back to square 1.

What are you doing to avoid that?
