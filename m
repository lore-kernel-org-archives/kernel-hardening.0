Date: Fri, 20 Apr 2018 10:49:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch V2 7/8] dm verity fec: Check result of init_rs()
In-Reply-To: <87o9ieq1ud.fsf@notabene.neil.brown.name>
Message-ID: <alpine.DEB.2.21.1804201040420.1683@nanos.tec.linutronix.de>
References: <20180419100441.548834519@linutronix.de> <20180419100935.340306831@linutronix.de> <20180419134647.GA9817@redhat.com> <alpine.DEB.2.21.1804191551520.19539@nanos.tec.linutronix.de> <87o9ieq1ud.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: NeilBrown <neilb@suse.com>
Cc: Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Segher Boessenkool <segher@kernel.crashing.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linuxfoundation.org>, Boris Brezillon <boris.brezillon@free-electrons.com>, Richard Weinberger <richard@nod.at>, David Woodhouse <dwmw2@infradead.org>, Alasdair Kergon <agk@redhat.com>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 20 Apr 2018, NeilBrown wrote:
> On Thu, Apr 19 2018, Thomas Gleixner wrote:
> > The analysis above forgot to look at the mempool->alloc() callback. So yes,
> > while the NOIO is good at the mempool level, but init_rs() uses GPF_KERNEL
> > so there might be a different can of wurms lurking.
> 
> The ->alloc call back is not relevant to the question of when
> mempool_alloc() can return NULL.
> If the ->alloc() callback returns a non-NULL value, it will be returned
> by mempool_alloc().
> If it returns NULL, that will not be returned.

Yes, as I said before, I missed the NOIO flag.

> 
> mempool_alloc() *only* returns NULL in one place:
> 
> 	if (!(gfp_mask & __GFP_DIRECT_RECLAIM)) {
> 		spin_unlock_irqrestore(&pool->lock, flags);
> 		return NULL;
> 	}
> 
> so a NULL return is purely dependent on the GFP flags passed.
> GFP_NOIO contains __GFP_DIRECT_RECLAIM, so NULL cannot be returned.
> 
> It seems quite broken that init_rs() uses GFP_KERNEL. It should take a
> gfp_t arg for the allocation.

Well, init_rs() was that way before somebody used it in a mempool_alloc()
callback. And all other users are fine with GFP_KERNEL AFAICT.

> If the mempool_alloc() above really needs GFP_NOIO, then it could
> theoretically deadlock as it performs a GFP_KERNEL allocation inside
> rs_init().  So in that sense, the code is not correct as-is.
> It could possibly be fixed by calling memalloc_noio_save() /
> memalloc_noio_restore() around the call to init_rs() in fec_rs_alloc().

No, we surely can add a gfp aware version of init_rs(). It's trivial enough
to do.

Thanks,

	tglx
