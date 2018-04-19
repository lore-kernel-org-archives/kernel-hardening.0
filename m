Date: Thu, 19 Apr 2018 09:46:47 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [patch V2 7/8] dm verity fec: Check result of init_rs()
Message-ID: <20180419134647.GA9817@redhat.com>
References: <20180419100441.548834519@linutronix.de>
 <20180419100935.340306831@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180419100935.340306831@linutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>, NeilBrown <neilb@suse.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Segher Boessenkool <segher@kernel.crashing.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linuxfoundation.org>, Boris Brezillon <boris.brezillon@free-electrons.com>, Richard Weinberger <richard@nod.at>, David Woodhouse <dwmw2@infradead.org>, Alasdair Kergon <agk@redhat.com>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 19 2018 at  6:04am -0400,
Thomas Gleixner <tglx@linutronix.de> wrote:

> From: Thomas Gleixner <tglx@linutronix.de>
> 
> The allocation of the reed solomon control structure can fail, but
> fec_alloc_bufs() ignores that and subsequent operations in dm verity use
> the potential NULL pointer unconditionally.
> 
> Add a proper check and abort if init_rs() fails.

This changelog makes little sense: init_rs() isn't in play relative to
this patch.

And it runs counter to this commit's changelog:

commit 34c96507e8f6be497c15497be05f489fb34c5880
Author: NeilBrown <neilb@suse.com>
Date:   Mon Apr 10 12:13:00 2017 +1000

    dm verity fec: fix GFP flags used with mempool_alloc()

    mempool_alloc() cannot fail for GFP_NOIO allocation, so there is no
    point testing for failure.

    One place the code tested for failure was passing "0" as the GFP
    flags.  This is most unusual and is probably meant to be GFP_NOIO,
    so that is changed.

    Also, allocation from ->extra_pool and ->prealloc_pool are repeated
    before releasing the previous allocation.  This can deadlock if the code
    is servicing a write under high memory pressure.  To avoid deadlocks,
    change these to use GFP_NOWAIT and leave the error handling in place.

    Signed-off-by: NeilBrown <neilb@suse.com>
    Signed-off-by: Mike Snitzer <snitzer@redhat.com>

Seems there is no real need for this patch.  Neil, what do you think?

Thanks,
Mike


> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Boris Brezillon <boris.brezillon@free-electrons.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Segher Boessenkool <segher@kernel.crashing.org>
> Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
> Cc: Richard Weinberger <richard@nod.at>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: Anton Vorontsov <anton@enomsg.org>
> Cc: Colin Cross <ccross@android.com>
> Cc: Andrew Morton <akpm@linuxfoundation.org>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Alasdair Kergon <agk@redhat.com>
> 
> ---
>  drivers/md/dm-verity-fec.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> --- a/drivers/md/dm-verity-fec.c
> +++ b/drivers/md/dm-verity-fec.c
> @@ -308,8 +308,13 @@ static int fec_alloc_bufs(struct dm_veri
>  {
>  	unsigned n;
>  
> -	if (!fio->rs)
> +	if (!fio->rs) {
>  		fio->rs = mempool_alloc(v->fec->rs_pool, GFP_NOIO);
> +		if (!fio->rs) {
> +			DMERR("failed to allocate RS control structure");
> +			return -ENOMEM;
> +		}
> +	}
>  
>  	fec_for_each_prealloc_buffer(n) {
>  		if (fio->bufs[n])
> 
> 
> 
> 
> 
