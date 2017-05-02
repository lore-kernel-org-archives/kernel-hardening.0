From: Tycho Andersen <tycho@docker.com>
Date: Tue,  2 May 2017 10:29:32 -0600
Message-Id: <20170502162932.12578-1-tycho@docker.com>
Subject: [kernel-hardening] [PATCH] ata-sff: always map page before data transfer
To: Tejun Heo <tj@kernel.org>, Juerg Haefliger <juerg.haefliger@hpe.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Tycho Andersen <tycho@docker.com>
List-ID: <kernel-hardening.lists.openwall.com>

The XPFO [1] patchset may unmap pages from physmap if they happened to be
destined for userspace. If such a page is unmapped, it needs to be
remapped. Rather than test if a page is in the highmem/xpfo unmapped state,
Christoph suggested [2] that we simply always map the page.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Tycho Andersen <tycho@docker.com>
CC: Juerg Haefliger <juerg.haefliger@hpe.com>
CC: Tejun Heo <tj@kernel.org>

[1]: https://lkml.org/lkml/2016/11/4/245
[2]: https://lkml.org/lkml/2016/11/4/253
---
I don't understand all the factors at play here, so thoughts are definitely
welcome.
---
 drivers/ata/libata-sff.c | 50 +++++++++++++++++-------------------------------
 1 file changed, 18 insertions(+), 32 deletions(-)

diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 2bd92dc..8da2572 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -703,6 +703,7 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
 	struct page *page;
 	unsigned int offset;
 	unsigned char *buf;
+	unsigned long flags;
 
 	if (qc->curbytes == qc->nbytes - qc->sect_size)
 		ap->hsm_task_state = HSM_ST_LAST;
@@ -716,24 +717,16 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
 
 	DPRINTK("data %s\n", qc->tf.flags & ATA_TFLAG_WRITE ? "write" : "read");
 
-	if (PageHighMem(page)) {
-		unsigned long flags;
-
-		/* FIXME: use a bounce buffer */
-		local_irq_save(flags);
-		buf = kmap_atomic(page);
+	/* FIXME: use a bounce buffer */
+	local_irq_save(flags);
+	buf = kmap_atomic(page);
 
-		/* do the actual data transfer */
-		ap->ops->sff_data_xfer(qc, buf + offset, qc->sect_size,
-				       do_write);
+	/* do the actual data transfer */
+	ap->ops->sff_data_xfer(qc, buf + offset, qc->sect_size,
+			       do_write);
 
-		kunmap_atomic(buf);
-		local_irq_restore(flags);
-	} else {
-		buf = page_address(page);
-		ap->ops->sff_data_xfer(qc, buf + offset, qc->sect_size,
-				       do_write);
-	}
+	kunmap_atomic(buf);
+	local_irq_restore(flags);
 
 	if (!do_write && !PageSlab(page))
 		flush_dcache_page(page);
@@ -836,6 +829,7 @@ static int __atapi_pio_bytes(struct ata_queued_cmd *qc, unsigned int bytes)
 	struct page *page;
 	unsigned char *buf;
 	unsigned int offset, count, consumed;
+	unsigned long flags;
 
 next_sg:
 	sg = qc->cursg;
@@ -861,24 +855,16 @@ static int __atapi_pio_bytes(struct ata_queued_cmd *qc, unsigned int bytes)
 
 	DPRINTK("data %s\n", qc->tf.flags & ATA_TFLAG_WRITE ? "write" : "read");
 
-	if (PageHighMem(page)) {
-		unsigned long flags;
-
-		/* FIXME: use bounce buffer */
-		local_irq_save(flags);
-		buf = kmap_atomic(page);
+	/* FIXME: use bounce buffer */
+	local_irq_save(flags);
+	buf = kmap_atomic(page);
 
-		/* do the actual data transfer */
-		consumed = ap->ops->sff_data_xfer(qc, buf + offset,
-								count, rw);
+	/* do the actual data transfer */
+	consumed = ap->ops->sff_data_xfer(qc, buf + offset,
+							count, rw);
 
-		kunmap_atomic(buf);
-		local_irq_restore(flags);
-	} else {
-		buf = page_address(page);
-		consumed = ap->ops->sff_data_xfer(qc, buf + offset,
-								count, rw);
-	}
+	kunmap_atomic(buf);
+	local_irq_restore(flags);
 
 	bytes -= min(bytes, consumed);
 	qc->curbytes += count;
-- 
2.9.3
