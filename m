From: Laura Abbott <labbott@redhat.com>
Subject: [PATCH] dmaengine: dmatest: Remove use of VLAs
Date: Mon,  9 Apr 2018 14:06:03 -0700
Message-Id: <20180409210603.3575-1-labbott@redhat.com>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>
Cc: Laura Abbott <labbott@redhat.com>, dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

There's an ongoing effort to remove VLAs from the kernel
(https://lkml.org/lkml/2018/3/7/621) to eventually turn on -Wvla.
The uses in dmatest are bounded by a check to make sure they fit
in a u8 so use that as an upper bound.

Signed-off-by: Laura Abbott <labbott@redhat.com>
---
 drivers/dma/dmatest.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 80cc2be6483c..dcf787b173e4 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -556,7 +556,8 @@ static int dmatest_func(void *data)
 	       && !(params->iterations && total_tests >= params->iterations)) {
 		struct dma_async_tx_descriptor *tx = NULL;
 		struct dmaengine_unmap_data *um;
-		dma_addr_t srcs[src_cnt];
+		/* total buffer count must fit into u8 */
+		dma_addr_t srcs[255];
 		dma_addr_t *dsts;
 		unsigned int src_off, dst_off, len;
 
@@ -669,7 +670,8 @@ static int dmatest_func(void *data)
 						      srcs, src_cnt,
 						      len, flags);
 		else if (thread->type == DMA_PQ) {
-			dma_addr_t dma_pq[dst_cnt];
+			/* dst_cnt can't be more than u8 */
+			dma_addr_t dma_pq[255];
 
 			for (i = 0; i < dst_cnt; i++)
 				dma_pq[i] = dsts[i] + dst_off;
-- 
2.14.3
