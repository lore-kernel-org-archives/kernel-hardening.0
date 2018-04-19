Date: Thu, 19 Apr 2018 16:08:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch V2 7/8] dm verity fec: Check result of init_rs()
In-Reply-To: <20180419134647.GA9817@redhat.com>
Message-ID: <alpine.DEB.2.21.1804191551520.19539@nanos.tec.linutronix.de>
References: <20180419100441.548834519@linutronix.de> <20180419100935.340306831@linutronix.de> <20180419134647.GA9817@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Mike Snitzer <snitzer@redhat.com>
Cc: NeilBrown <neilb@suse.com>, LKML <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Segher Boessenkool <segher@kernel.crashing.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linuxfoundation.org>, Boris Brezillon <boris.brezillon@free-electrons.com>, Richard Weinberger <richard@nod.at>, David Woodhouse <dwmw2@infradead.org>, Alasdair Kergon <agk@redhat.com>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 19 Apr 2018, Mike Snitzer wrote:

> On Thu, Apr 19 2018 at  6:04am -0400,
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > From: Thomas Gleixner <tglx@linutronix.de>
> > 
> > The allocation of the reed solomon control structure can fail, but
> > fec_alloc_bufs() ignores that and subsequent operations in dm verity use
> > the potential NULL pointer unconditionally.
> > 
> > Add a proper check and abort if init_rs() fails.
> 
> This changelog makes little sense: init_rs() isn't in play relative to
> this patch.

	fio->rs = mempool_alloc(v->fec->rs_pool, GFP_NOIO);

        f->rs_pool = mempool_create(num_online_cpus(), fec_rs_alloc,
                                    fec_rs_free, (void *) v);

static void *fec_rs_alloc(gfp_t gfp_mask, void *pool_data)
{
	struct dm_verity *v = (struct dm_verity *)pool_data;

        return init_rs(8, 0x11d, 0, 1, v->fec->roots);
}

So init_rs() is part of the chain, right?

Yes. I missed the NOIO part. But....

> And it runs counter to this commit's changelog:
> 
> commit 34c96507e8f6be497c15497be05f489fb34c5880
> Author: NeilBrown <neilb@suse.com>
> Date:   Mon Apr 10 12:13:00 2017 +1000
> 
>     dm verity fec: fix GFP flags used with mempool_alloc()
> 
>     mempool_alloc() cannot fail for GFP_NOIO allocation, so there is no
>     point testing for failure.
> 
>     One place the code tested for failure was passing "0" as the GFP
>     flags.  This is most unusual and is probably meant to be GFP_NOIO,
>     so that is changed.
> 
>     Also, allocation from ->extra_pool and ->prealloc_pool are repeated
>     before releasing the previous allocation.  This can deadlock if the code
>     is servicing a write under high memory pressure.  To avoid deadlocks,
>     change these to use GFP_NOWAIT and leave the error handling in place.
> 
>     Signed-off-by: NeilBrown <neilb@suse.com>
>     Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> 
> Seems there is no real need for this patch.  Neil, what do you think?

The analysis above forgot to look at the mempool->alloc() callback. So yes,
while the NOIO is good at the mempool level, but init_rs() uses GPF_KERNEL
so there might be a different can of wurms lurking.

Thanks,

	tglx
