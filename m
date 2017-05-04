Date: Thu, 4 May 2017 02:51:34 -0700
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20170504095134.GA14372@infradead.org>
References: <20170502162932.12578-1-tycho@docker.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170502162932.12578-1-tycho@docker.com>
Subject: [kernel-hardening] Re: [PATCH] ata-sff: always map page before data transfer
To: Tycho Andersen <tycho@docker.com>
Cc: Tejun Heo <tj@kernel.org>, Juerg Haefliger <juerg.haefliger@hpe.com>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

> I don't understand all the factors at play here, so thoughts are definitely
> welcome.

I don't fully understand the old code either.  One thing that is weird
is the "use a bounce buffer comment" which doesn't make any sense.

The other is the local_irq_save, which isn't really needed for
kmap_atomic to start with, but maybe that's the reason why the original
author didn't want to do it unconditionally?

So based on that:

> +	/* FIXME: use a bounce buffer */

drop this comment..

> +	local_irq_save(flags);

.. remove the local_irq_save/local_irq_restore ..

> +	/* do the actual data transfer */
> +	ap->ops->sff_data_xfer(qc, buf + offset, qc->sect_size,
> +			       do_write);

.. and a nice alittle cleanup move the do_write onto the previous line.

> +	/* FIXME: use bounce buffer */
> +	local_irq_save(flags);
> +	buf = kmap_atomic(page);
>  
> +	/* do the actual data transfer */
> +	consumed = ap->ops->sff_data_xfer(qc, buf + offset,
> +							count, rw);

And same here.

And we should be fine.
