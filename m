Date: Thu, 25 Oct 2018 09:11:30 +0100
From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH 14/17] prmem: llist, hlist, both plain and rcu
Message-ID: <20181025081130.GA31945@cisco>
References: <20181023213504.28905-1-igor.stoppa@huawei.com>
 <20181023213504.28905-15-igor.stoppa@huawei.com>
 <1634210774.446.1540381072927.JavaMail.zimbra@efficios.com>
 <243a8ff2-889c-089f-a1ff-c882933ca5c3@gmail.com>
 <20181024145606.GA9019@cisco>
 <d630474b-73a5-c6ae-2141-49c1184381b2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d630474b-73a5-c6ae-2141-49c1184381b2@gmail.com>
To: Igor Stoppa <igor.stoppa@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>, Matthew Wilcox <willy@infradead.org>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, kernel-hardening@lists.openwall.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, igor stoppa <igor.stoppa@huawei.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Kate Stewart <kstewart@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, rostedt <rostedt@goodmis.org>, Lai Jiangshan <jiangshanlai@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 25, 2018 at 01:52:11AM +0300, Igor Stoppa wrote:
> On 24/10/2018 17:56, Tycho Andersen wrote:
> > On Wed, Oct 24, 2018 at 05:03:01PM +0300, Igor Stoppa wrote:
> > > On 24/10/18 14:37, Mathieu Desnoyers wrote:
> > > > Also, is it the right approach to duplicate existing APIs, or should we
> > > > rather hook into page fault handlers and let the kernel do those "shadow"
> > > > mappings under the hood ?
> > > 
> > > This question is probably a good candidate for the small Q&A section I have
> > > in the 00/17.
> > > 
> > > 
> > > > Adding a new GFP flags for dynamic allocation, and a macro mapping to
> > > > a section attribute might suffice for allocation or definition of such
> > > > mostly-read-only/seldom-updated data.
> > > 
> > > I think what you are proposing makes sense from a pure hardening standpoint.
> > >  From a more defensive one, I'd rather minimise the chances of giving a free
> > > pass to an attacker.
> > > 
> > > Maybe there is a better implementation of this, than what I have in mind.
> > > But, based on my current understanding of what you are describing, there
> > > would be few issues:
> > > 
> > > 1) where would the pool go? The pool is a way to manage multiple vmas and
> > > express common property they share. Even before a vma is associated to the
> > > pool.
> > > 
> > > 2) there would be more code that can seamlessly deal with both protected and
> > > regular data. Based on what? Some parameter, I suppose.
> > > That parameter would be the new target.
> > > If the code is "duplicated", as you say, the actual differences are baked in
> > > at compile time. The "duplication" would also allow to have always inlined
> > > functions for write-rare and leave more freedom to the compiler for their
> > > non-protected version.
> > > 
> > > Besides, I think the separate wr version also makes it very clear, to the
> > > user of the API, that there will be a price to pay, in terms of performance.
> > > The more seamlessly alternative might make this price less obvious.
> > 
> > What about something in the middle, where we move list to list_impl.h,
> > and add a few macros where you have list_set_prev() in prlist now, so
> > we could do,
> > 
> > // prlist.h
> > 
> > #define list_set_next(head, next) wr_ptr(&head->next, next)
> > #define list_set_prev(head, prev) wr_ptr(&head->prev, prev)
> > 
> > #include <linux/list_impl.h>
> > 
> > // list.h
> > 
> > #define list_set_next(next) (head->next = next)
> > #define list_set_next(prev) (head->prev = prev)
> > 
> > #include <linux/list_impl.h>
> > 
> > I wonder then if you can get rid of some of the type punning too? It's
> > not clear exactly why that's necessary from the series, but perhaps
> > I'm missing something obvious :)
> 
> nothing obvious, probably there is only half a reference in the slides I
> linked-to in the cover letter :-)
> 
> So far I have minimized the number of "intrinsic" write rare functions,
> mostly because I would want first to reach an agreement on the
> implementation of the core write-rare.
> 
> However, once that is done, it might be good to convert also the prlists to
> be "intrinsics". A list node is 2 pointers.
> If that was the alignment, i.e. __align(sizeof(list_head)), it might be
> possible to speed up a lot the list handling even as write rare.
> 
> Taking as example the insertion operation, it would be probably sufficient,
> in most cases, to have only two remappings:
> - one covering the page with the latest two nodes
> - one covering the page with the list head
> 
> That is 2 vs 8 remappings, and a good deal of memory barriers less.
> 
> This would be incompatible with what you are proposing, yet it would be
> justifiable, I think, because it would provide better performance to prlist,
> potentially widening its adoption, where performance is a concern.

I guess the writes to these are rare, right? So perhaps it's not such
a big deal :)

> > I also wonder how much the actual differences being baked in at
> > compile time makes. Most (all?) of this code is inlined.
> 
> If the inlined function expects to receive a prlist_head *, instead of a
> list_head *, doesn't it help turning runtime bugs into buildtime bugs?

In principle it's not a bug to use the prmem helpers where the regular
ones would do, it's just slower (assuming the types are the same). But
mostly, it's a way to avoid actually copying and pasting most of the
implementations of most of the data structures. I see some other
replies in the thread already, but this seems not so good to me.

Tycho
