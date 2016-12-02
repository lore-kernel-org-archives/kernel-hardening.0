Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1480693474.28515.56.camel@cs-046.org.aalto.fi>
From: Liljestrand Hans <ishkamiel@gmail.com>
Date: Fri, 02 Dec 2016 17:44:34 +0200
In-Reply-To: <20161201191543.GG3124@twins.programming.kicks-ass.net>
References: 
	<2236FBA76BA1254E88B949DDB74E612B41C1884B@IRSMSX102.ger.corp.intel.com>
	 <20161128121347.GY3092@twins.programming.kicks-ass.net>
	 <2236FBA76BA1254E88B949DDB74E612B41C190FC@IRSMSX102.ger.corp.intel.com>
	 <20161201191543.GG3124@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: Conversion from atomic_t to refcount_t: summary of issues
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Greg KH <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, "will.deacon@arm.com" <will.deacon@arm.com>, Boqun Feng <boqun.feng@gmail.com>, David Windsor <dwindsor@gmail.com>, "aik@ozlabs.ru" <aik@ozlabs.ru>, "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 2016-12-01 at 20:15 +0100, Peter Zijlstra wrote:
> On Tue, Nov 29, 2016 at 03:35:15PM +0000, Reshetova, Elena wrote:
> > but Hans will be finishing processing 
> 
> > > > The following functions are also needed quite commonly:
> > > 
> > > > refcount_inc_return()
> > > > refcount_dec_return()
> > > 
> > > What for? They don't typicaly make sense for refcounting? Other than the
> > > trivial pattern of dec_return() == 0, which is already well covered.
> 
> Hans, could you point me to a few users of {inc,dec}_return() that I can
> audit for (in)sanity?

Hi, sorry for the slow response, I have been a bit otherwise engaged.
Here's at least some of the cases we've already encountered.


There's a lot of uses like this (but unless I'm missing something they
should mostly go under the trivial dec_return() == 0 pattern already
mentioned):

if (!atomic_dec_return(&buf->refcount))
-
if (atomic_dec_return(&mcast->refcount) <= 1)
-
map_guard = atomic_add_return(-1, mux->map_guard);
if (!map_guard)


Then there's at least include/net/ip_vs.h that does unchecked decs and
instead has this dedicated free function that checks for negative values
(so with unsigned refcount it is broken anyway, guess we could do a
conditional dec with a _read, but then its no longer atomic):

http://lxr.free-electrons.com/source/include/net/ip_vs.h#L1424

 static inline void ip_vs_dest_put_and_free(struct ip_vs_dest *dest) 
 {
 	if (atomic_dec_return(&dest->refcnt) < 0)
 		kfree(dest);
 }


Then there's cases that check for the first increment, like here (maybe
something like inc_and_one could allow these without too much leeway?):

http://lxr.free-electrons.com/source/drivers/tty/serial/zs.c#L764

 irq_guard = atomic_add_return(1, &scc->irq_guard);
 	if (irq_guard == 1) {

http://lxr.free-electrons.com/source/drivers/usb/gadget/function/f_fs.c#L1497

 if (atomic_add_return(1, &ffs->opened) == 1 &&
 	ffs->state == FFS_DEACTIVATED) {


And finally some cases with other uses/values:

http://lxr.free-electrons.com/source/kernel/bpf/syscall.c#L231

 if (atomic_inc_return(&map->refcnt) > BPF_MAX_REFCNT) {

http://lxr.free-electrons.com/source/drivers/staging/lustre/lustre/ptlrpc/client.c#L3081

 if (atomic_inc_return(&req->rq_refcount) == 2)


Regards,
-hans
