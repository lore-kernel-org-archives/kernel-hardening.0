From: Tycho Andersen <tycho@docker.com>
Date: Thu,  4 May 2017 16:15:51 -0600
Message-Id: <20170504221551.6458-1-tycho@docker.com>
Subject: [kernel-hardening] [PATCH v2] ata-sff: always map page before data transfer
To: Tejun Heo <tj@kernel.org>, Juerg Haefliger <juerg.haefliger@hpe.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Tycho Andersen <tycho@docker.com>
List-ID: <kernel-hardening.lists.openwall.com>

The XPFO [1] patchset may unmap pages from physmap if they happened to be
destined for userspace. If such a page is unmapped, it needs to be
remapped. Rather than test if a page is in the highmem/xpfo unmapped state,
Christoph suggested [2] that we simply always map the page.

v2: * drop comment about bounce buffer
    * don't save IRQs before kmap/unmap
    * formatting

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Tycho Andersen <tycho@docker.com>
CC: Juerg Haefliger <juerg.haefliger@hpe.com>
CC: Tejun Heo <tj@kernel.org>

[1]: https://lkml.org/lkml/2016/11/4/245
[2]: https://lkml.org/lkml/2016/11/4/253
---
v1: https://lkml.org/lkml/2017/5/2/404
---
 drivers/ata/libata-sff.c | 44 ++++++++------------------------------------
 1 file changed, 8 insertions(+), 36 deletions(-)

diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 2bd92dca3e62..01cf07c919bc 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -716,24 +716,10 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
 
 	DPRINTK("data %s\n", qc->tf.flags & ATA_TFLAG_WRITE ? "write" : "read");
 
-	if (PageHighMem(page)) {
-		unsigned long flags;
-
-		/* FIXME: use a bounce buffer */
-		local_irq_save(flags);
-		buf = kmap_atomic(page);
-
-		/* do the actual data transfer */
-		ap->ops->sff_data_xfer(qc, buf + offset, qc->sect_size,
-				       do_write);
-
-		kunmap_atomic(buf);
-		local_irq_restore(flags);
-	} else {
-		buf = page_address(page);
-		ap->ops->sff_data_xfer(qc, buf + offset, qc->sect_size,
-				       do_write);
-	}
+	/* do the actual data transfer */
+	buf = kmap_atomic(page);
+	ap->ops->sff_data_xfer(qc, buf + offset, qc->sect_size, do_write);
+	kunmap_atomic(buf);
 
 	if (!do_write && !PageSlab(page))
 		flush_dcache_page(page);
@@ -861,24 +847,10 @@ static int __atapi_pio_bytes(struct ata_queued_cmd *qc, unsigned int bytes)
 
 	DPRINTK("data %s\n", qc->tf.flags & ATA_TFLAG_WRITE ? "write" : "read");
 
-	if (PageHighMem(page)) {
-		unsigned long flags;
-
-		/* FIXME: use bounce buffer */
-		local_irq_save(flags);
-		buf = kmap_atomic(page);
-
-		/* do the actual data transfer */
-		consumed = ap->ops->sff_data_xfer(qc, buf + offset,
-								count, rw);
-
-		kunmap_atomic(buf);
-		local_irq_restore(flags);
-	} else {
-		buf = page_address(page);
-		consumed = ap->ops->sff_data_xfer(qc, buf + offset,
-								count, rw);
-	}
+	/* do the actual data transfer */
+	buf = kmap_atomic(page);
+	consumed = ap->ops->sff_data_xfer(qc, buf + offset, count, rw);
+	kunmap_atomic(buf);
 
 	bytes -= min(bytes, consumed);
 	qc->curbytes += count;
-- 
2.11.0
