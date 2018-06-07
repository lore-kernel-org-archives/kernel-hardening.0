From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 1/6] Convert virtio_console to struct_size
Date: Thu,  7 Jun 2018 07:57:15 -0700
Message-Id: <20180607145720.22590-2-willy@infradead.org>
In-Reply-To: <20180607145720.22590-1-willy@infradead.org>
References: <20180607145720.22590-1-willy@infradead.org>
To: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

From: Matthew Wilcox <mawilcox@microsoft.com>

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 drivers/char/virtio_console.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 21085515814f..4bf7c06c2343 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -433,8 +433,7 @@ static struct port_buffer *alloc_buf(struct virtio_device *vdev, size_t buf_size
 	 * Allocate buffer and the sg list. The sg list array is allocated
 	 * directly after the port_buffer struct.
 	 */
-	buf = kmalloc(sizeof(*buf) + sizeof(struct scatterlist) * pages,
-		      GFP_KERNEL);
+	buf = kmalloc(struct_size(buf, sg, pages), GFP_KERNEL);
 	if (!buf)
 		goto fail;
 
-- 
2.17.0
