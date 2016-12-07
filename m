Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 7 Dec 2016 14:52:41 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20161207135241.GI3107@twins.programming.kicks-ass.net>
References: <2236FBA76BA1254E88B949DDB74E612B41C1884B@IRSMSX102.ger.corp.intel.com>
 <20161128121347.GY3092@twins.programming.kicks-ass.net>
 <2236FBA76BA1254E88B949DDB74E612B41C190FC@IRSMSX102.ger.corp.intel.com>
 <20161201191543.GG3124@twins.programming.kicks-ass.net>
 <1480693474.28515.56.camel@cs-046.org.aalto.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1480693474.28515.56.camel@cs-046.org.aalto.fi>
Subject: [kernel-hardening] Re: Conversion from atomic_t to refcount_t: summary of issues
To: Liljestrand Hans <ishkamiel@gmail.com>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Greg KH <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, "will.deacon@arm.com" <will.deacon@arm.com>, Boqun Feng <boqun.feng@gmail.com>, David Windsor <dwindsor@gmail.com>, "aik@ozlabs.ru" <aik@ozlabs.ru>, "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Dec 02, 2016 at 05:44:34PM +0200, Liljestrand Hans wrote:
> 
> Then there's at least include/net/ip_vs.h that does unchecked decs and
> instead has this dedicated free function that checks for negative values
> (so with unsigned refcount it is broken anyway, guess we could do a
> conditional dec with a _read, but then its no longer atomic):
> 
> http://lxr.free-electrons.com/source/include/net/ip_vs.h#L1424
> 
>  static inline void ip_vs_dest_put_and_free(struct ip_vs_dest *dest) 
>  {
>  	if (atomic_dec_return(&dest->refcnt) < 0)
>  		kfree(dest);
>  }

This looks like one that uses -1 to free, so doing a +1 on the entire
scheme would restore 'sanity', but that's fairly thick code and I
couldn't say for sure.

> Then there's cases that check for the first increment, like here (maybe
> something like inc_and_one could allow these without too much leeway?):
> 
> http://lxr.free-electrons.com/source/drivers/tty/serial/zs.c#L764
> 
>  irq_guard = atomic_add_return(1, &scc->irq_guard);
>  	if (irq_guard == 1) {
> 
> http://lxr.free-electrons.com/source/drivers/usb/gadget/function/f_fs.c#L1497
> 
>  if (atomic_add_return(1, &ffs->opened) == 1 &&
>  	ffs->state == FFS_DEACTIVATED) {
> 
> 
> And finally some cases with other uses/values:
> 
> http://lxr.free-electrons.com/source/drivers/staging/lustre/lustre/ptlrpc/client.c#L3081
> 
>  if (atomic_inc_return(&req->rq_refcount) == 2)

Greg already went through these, they're not proper refcounts.


> http://lxr.free-electrons.com/source/kernel/bpf/syscall.c#L231
> 
>  if (atomic_inc_return(&map->refcnt) > BPF_MAX_REFCNT) {

I think this one already got discussed, its a custom refcount limit
scheme (with holes in).

All in all I'm not inclined to add {add,sub.inc,dec}_return() to
refcount, as previously stated, they don't make sense.
