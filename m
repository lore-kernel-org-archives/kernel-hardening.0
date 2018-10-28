Date: Sun, 28 Oct 2018 19:31:26 +0100
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 10/17] prmem: documentation
Message-ID: <20181028183126.GB744@hirez.programming.kicks-ass.net>
References: <20181023213504.28905-1-igor.stoppa@huawei.com>
 <20181023213504.28905-11-igor.stoppa@huawei.com>
 <20181026092609.GB3159@worktop.c.hoisthospitality.com>
 <CAGXu5jKCs01jvtvpEFS7R8qCR-5iRqK11kJxLJY99NicGWc4aQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKCs01jvtvpEFS7R8qCR-5iRqK11kJxLJY99NicGWc4aQ@mail.gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Igor Stoppa <igor.stoppa@gmail.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Matthew Wilcox <willy@infradead.org>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-integrity <linux-integrity@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Igor Stoppa <igor.stoppa@huawei.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Oct 26, 2018 at 11:46:28AM +0100, Kees Cook wrote:
> On Fri, Oct 26, 2018 at 10:26 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > I still don't really understand the whole write-rare thing; how does it
> > really help? If we can write in kernel memory, we can write to
> > page-tables too.

> One aspect of hardening the kernel against attack is reducing the
> internal attack surface. Not all flaws are created equal, so there is
> variation in what limitations an attacker may have when exploiting
> flaws (not many flaws end up being a fully controlled "write anything,
> anywhere, at any time"). By making the more sensitive data structures
> of the kernel read-only, we reduce the risk of an attacker finding a
> path to manipulating the kernel's behavior in a significant way.
> 
> Examples of typical sensitive targets are function pointers, security
> policy, and page tables. Having these "read only at rest" makes them
> much harder to control by an attacker using memory integrity flaws.

Because 'write-anywhere' exploits are easier than (and the typical first
step to) arbitrary code execution thingies?

> The "write rarely" name itself may not sufficiently describe what is
> wanted either (I'll take the blame for the inaccurate name), so I'm
> open to new ideas there. The implementation requirements for the
> "sensitive data read-only at rest" feature are rather tricky:
> 
> - allow writes only from specific places in the kernel
> - keep those locations inline to avoid making them trivial ROP targets
> - keep the writeability window open only to a single uninterruptable CPU

The current patch set does not achieve that because it uses a global
address space for the alias mapping (vmap) which is equally accessible
from all CPUs.

> - fast enough to deal with page table updates

The proposed implementation needs page-tables for the alias; I don't see
how you could ever do R/O page-tables when you need page-tables to
modify your page-tables.

And this is entirely irrespective of performance.

> The proposal I made a while back only covered .data things (and used
> x86-specific features).

Oh, right, that CR0.WP stuff.

> Igor's proposal builds on this by including a
> way to do this with dynamic allocation too, which greatly expands the
> scope of structures that can be protected. Given that the x86-only
> method of write-window creation was firmly rejected, this is a new
> proposal for how to do it (vmap window). Using switch_mm() has also
> been suggested, etc.

Right... /me goes find the patches we did for text_poke. Hmm, those
never seem to have made it:

  https://lkml.kernel.org/r/20180902173224.30606-1-namit@vmware.com

like that. That approach will in fact work and not be a completely
broken mess like this thing.

> We need to find a good way to do the write-windowing that works well
> for static and dynamic structures _and_ for the page tables... this
> continues to be tricky.
> 
> Making it resilient against ROP-style targets makes it difficult to
> deal with certain data structures (like list manipulation). In my
> earlier RFC, I tried to provide enough examples of where this could
> get used to let people see some of the complexity[1]. Igor's series
> expands this to even more examples using dynamic allocation.

Doing 2 CR3 writes for 'every' WR write doesn't seem like it would be
fast enough for much of anything.

And I don't suppose we can take the WP fault and then fix up from there,
because if we're doing R/O page-tables, that'll incrase the fault depth
and we'll double fault all the time, and tripple fault where we
currently double fault. And we all know how _awesome_ tripple faults
are.

But duplicating (and wrapping in gunk) whole APIs is just not going to
work.
