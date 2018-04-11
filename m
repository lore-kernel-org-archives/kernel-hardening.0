From: Laura Abbott <labbott@redhat.com>
Subject: [PATCHv2] dmaengine: dmatest: Remove use of VLAs
Date: Tue, 10 Apr 2018 18:02:16 -0700
Message-Id: <20180411010216.17702-1-labbott@redhat.com>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>
Cc: Laura Abbott <labbott@redhat.com>, dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Sinan Kaya <okaya@codeaurora.org>
List-ID: <kernel-hardening.lists.openwall.com>

There's an ongoing effort to remove VLAs from the kernel
(https://lkml.org/lkml/2018/3/7/621) to eventually turn on -Wvla.
The test already pre-allocates some buffers with kmalloc so turn
the two VLAs in to pre-allocated kmalloc buffers.

Signed-off-by: Laura Abbott <labbott@redhat.com>
---
v2: Switch to using kmalloc buffers instead of putting a large array on
the stack.
---
 drivers/dma/dmatest.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 80cc2be6483c..9730956dfbe3 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -463,6 +463,8 @@ static int dmatest_func(void *data)
 	unsigned long long	total_len = 0;
 	u8			align = 0;
 	bool			is_memset = false;
+	dma_addr_t		*srcs;
+	dma_addr_t		*dma_pq;
 
 	set_freezable();
 
@@ -546,6 +548,14 @@ static int dmatest_func(void *data)
 
 	set_user_nice(current, 10);
 
+	srcs = kcalloc(src_cnt, sizeof(dma_addr_t), GFP_KERNEL);
+	if (!srcs)
+		goto err_dstbuf;
+
+	dma_pq = kcalloc(dst_cnt, sizeof(dma_addr_t), GFP_KERNEL);
+	if (!dma_pq)
+		goto err_srcs_array;
+
 	/*
 	 * src and dst buffers are freed by ourselves below
 	 */
@@ -556,7 +566,6 @@ static int dmatest_func(void *data)
 	       && !(params->iterations && total_tests >= params->iterations)) {
 		struct dma_async_tx_descriptor *tx = NULL;
 		struct dmaengine_unmap_data *um;
-		dma_addr_t srcs[src_cnt];
 		dma_addr_t *dsts;
 		unsigned int src_off, dst_off, len;
 
@@ -669,8 +678,6 @@ static int dmatest_func(void *data)
 						      srcs, src_cnt,
 						      len, flags);
 		else if (thread->type == DMA_PQ) {
-			dma_addr_t dma_pq[dst_cnt];
-
 			for (i = 0; i < dst_cnt; i++)
 				dma_pq[i] = dsts[i] + dst_off;
 			tx = dev->device_prep_dma_pq(chan, dma_pq, srcs,
@@ -772,6 +779,9 @@ static int dmatest_func(void *data)
 	runtime = ktime_to_us(ktime);
 
 	ret = 0;
+	kfree(dma_pq);
+err_srcs_array:
+	kfree(srcs);
 err_dstbuf:
 	for (i = 0; thread->udsts[i]; i++)
 		kfree(thread->udsts[i]);
-- 
2.14.3
