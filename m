Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 2 Dec 2016 17:14:15 +0100
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20161202161415.GA6302@kroah.com>
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
Cc: Peter Zijlstra <peterz@infradead.org>, "Reshetova, Elena" <elena.reshetova@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>, "will.deacon@arm.com" <will.deacon@arm.com>, Boqun Feng <boqun.feng@gmail.com>, David Windsor <dwindsor@gmail.com>, "aik@ozlabs.ru" <aik@ozlabs.ru>, "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Dec 02, 2016 at 05:44:34PM +0200, Liljestrand Hans wrote:
> Then there's cases that check for the first increment, like here (maybe
> something like inc_and_one could allow these without too much leeway?):
> 
> http://lxr.free-electrons.com/source/drivers/tty/serial/zs.c#L764
> 
>  irq_guard = atomic_add_return(1, &scc->irq_guard);
>  	if (irq_guard == 1) {

That's horrid, let's fix it correctly, it just wants to know if the
driver has been initialized or not.  Make it a real lock and a variable
and all is good.

> http://lxr.free-electrons.com/source/drivers/usb/gadget/function/f_fs.c#L1497
> 
>  if (atomic_add_return(1, &ffs->opened) == 1 &&
>  	ffs->state == FFS_DEACTIVATED) {

Another horrid hack to try to be "cute" about only allowing one open to
succeed.  Again, let's do this correctly with a lock.

> And finally some cases with other uses/values:
> 
> http://lxr.free-electrons.com/source/kernel/bpf/syscall.c#L231
> 
>  if (atomic_inc_return(&map->refcnt) > BPF_MAX_REFCNT) {

A "don't allow any more than X things through at once" type counter, a
normal atomic type should be fine for this, it's not a "real" reference
counter for a data structure.

> http://lxr.free-electrons.com/source/drivers/staging/lustre/lustre/ptlrpc/client.c#L3081
> 
>  if (atomic_inc_return(&req->rq_refcount) == 2)

lustre should never be used as an excuse for anything, except for how to
not do things.  That's some messed up code that is slowly getting
better...

This audit is turning up good stuff, it will be nice to clean this crud
up!

thanks,

greg k-h
