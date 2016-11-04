Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 4 Nov 2016 07:50:40 -0700
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20161104145040.GA24930@infradead.org>
References: <20160914071901.8127-1-juerg.haefliger@hpe.com>
 <20161104144534.14790-1-juerg.haefliger@hpe.com>
 <20161104144534.14790-2-juerg.haefliger@hpe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161104144534.14790-2-juerg.haefliger@hpe.com>
Subject: [kernel-hardening] Re: [RFC PATCH v3 1/2] Add support for eXclusive Page Frame
 Ownership (XPFO)
To: Juerg Haefliger <juerg.haefliger@hpe.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com, linux-x86_64@vger.kernel.org, vpk@cs.columbia.edu, Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

The libata parts here really need to be split out and the proper list
and maintainer need to be Cc'ed.

> diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
> index 051b6158d1b7..58af734be25d 100644
> --- a/drivers/ata/libata-sff.c
> +++ b/drivers/ata/libata-sff.c
> @@ -715,7 +715,7 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
>  
>  	DPRINTK("data %s\n", qc->tf.flags & ATA_TFLAG_WRITE ? "write" : "read");
>  
> -	if (PageHighMem(page)) {
> +	if (PageHighMem(page) || xpfo_page_is_unmapped(page)) {
>  		unsigned long flags;
>  
>  		/* FIXME: use a bounce buffer */
> @@ -860,7 +860,7 @@ static int __atapi_pio_bytes(struct ata_queued_cmd *qc, unsigned int bytes)
>  
>  	DPRINTK("data %s\n", qc->tf.flags & ATA_TFLAG_WRITE ? "write" : "read");
>  
> -	if (PageHighMem(page)) {
> +	if (PageHighMem(page) || xpfo_page_is_unmapped(page)) {
>  		unsigned long flags;
>  
>  		/* FIXME: use bounce buffer */
> diff --git a/include/linux/highmem.h b/include/linux/highmem.h

This is just piling one nasty hack on top of another.  libata should
just use the highmem case unconditionally, as it is the correct thing
to do for all cases.
